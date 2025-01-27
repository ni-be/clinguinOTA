"""
Custom Clinguin Backend for the Multi Shot ClinguinOTA implementation

"""
import time
from functools import cached_property
from clinguin.utils.annotations import extends
from clinguin.server.application.backends import ClingoBackend
from clingo import Control


class multi_shot_ota_backend(ClingoBackend):
    """Backend for multi-shot over-the-air (OTA) updates.

    This backend extends the ClingoBackend to support multi-shot OTA updates,
    allowing for the specification of environment and instance files.

    Attributes:
        _env_info (list): List of environment file paths.
        _instance_info (list): List of instance file paths.
        _current_time (int): Current time step.
        _loc_data (list): List of location atoms.
        _env_data (list): List of environment atoms.
        _agent_data (list): List of agent atoms.  (Currently unused, consider removing)
        _actions (list): List of actions. (Currently unused, consider removing)

    Args:
        See base class ClingoBackend.

    Raises:
        See base class ClingoBackend.
    """
    @classmethod
    def register_options(cls, parser):
        """Registers command-line options specific to the Multi-shot OTA backend.
        Args:
            parser: An argument parser object (e.g., from argparse).
        """
        ClingoBackend.register_options(parser)

        parser.add_argument(
            "--env-file",
            help="environment file",
            nargs="*",
        )
        parser.add_argument(
            "--instance-file",
            help="Add an Instance File",
            nargs="*",
        )


    @extends(ClingoBackend)
    def _init_command_line(self):
        """Initializes command-line arguments and internal data structures."""
        super()._init_command_line()
        print("init commandline")
        self._env_info = self._args.env_file
        self._instance_info = self._args.instance_file
        self._current_time = 0
        self._loc_data = []
        self._env_data = []
        self._agent_data = []
        self._actions = []


    @extends(ClingoBackend)
    def _init_ds_constructors(self):
        """Initializes domain state constructors, adding a constructor for the environment."""
        super()._init_ds_constructors()
        self._add_domain_state_constructor("_ds_env")


    def env_model(self, env_m):
        """Processes the environment model from clingo.
        Args:
            env_m: The clingo model object representing the environment.
        Outputs: adds the atoms to the Clinguin control object.
        """
        
        for atom in env_m.symbols(shown=True):
            if atom not in self._loc_data:
                self._set_external(atom, "true")
                self._loc_data.append(atom)

        for atom in env_m.symbols(atoms=True):
            if atom not in self._env_data:
                self._env_data.append(atom)

    def _compute_env(self, step, action):
        """Computes the environment state given a step and action.

        Args:
            step (int or str): The current time step.
            action (str): The action taken.
        """
        
        ctl_env = Control()
        ctl_env.load(self._env_info[0])
        ctl_env.load(self._instance_info[0])
        ctl_env.add("base", [], f"{action}.")

        for env_his in self._env_data:
            ctl_env.add("base", [], f"{env_his}.")

        ctl_env.add("base", [], f"time({int(step)}).")
        ctl_env.ground([("base", [])])
        ctl_env.solve(on_model=self.env_model)

    def user_choice_inc(self, step, action):
        """Increments the time step and updates the environment based on user action.

        Args:
            step (int or str): The current time step.
            action (str): The action taken by the user.
        """
        
        self._set_constant("x", f"{step}")
        self.add_assumption(action, "true")
        self._ground("step", [f"{int(step) + 1}"])
        self.set_external(f"query({int(step)})", "false")
        self.set_external(f"query({int(step)+1})", "true")
        self._compute_env(f"{int(step)}", action)
        self.update()

    @cached_property
    def _ds_env(self):
        """Constructs the environment domain state.
        Returns:
            str: The ASP program representing the environment domain state.
        """
        prg = "#defined _clinguin_env/1. "
        with open(self._instance_info[0], "r") as file:
            for line in file:
                line = line.strip().rstrip(".")
                prg += f"_clinguin_env({str(line)}).\n"
        return prg
