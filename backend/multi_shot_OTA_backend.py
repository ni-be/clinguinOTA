"""
Custom Clinguin Backend for the Single Shot OTA implementation

"""

import time
from functools import cached_property
from clinguin.utils.annotations import extends
from clinguin.server.application.backends import ClingoBackend
from clingo import Control


class multi_shot_ota_backend(ClingoBackend):
    """
    First init command line, include arrays to store temp data in for computation
    """

    @classmethod
    def register_options(cls, parser):
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
        super()._init_command_line()
        print("init commandline")
        self._env_info = self._args.env_file
        self._instance_info = self._args.instance_file
        self._current_time = 0
        self._loc_data = []
        self._env_data = []
        self._agent_data = []
        self._actions = []

    """ 
    2. Get the init environment at time 0 to load based on the provided instance data
    """

    @extends(ClingoBackend)
    def _init_ds_constructors(self):
        super()._init_ds_constructors()
        self._add_domain_state_constructor("_ds_env")

    def env_model(self, env_m):
        """
        1. Solve the control object of the environment
        2. The Atoms defined in the env. encoding with a #show are now added to the clinguin control object.
        3. The env atoms will be that are true will stored in the env_data array.
        """

        for atom in env_m.symbols(shown=True):
            if atom not in self._loc_data:
                self._set_external(atom, "true")
                self._loc_data.append(atom)
        for atom in env_m.symbols(atoms=True):
            if atom not in self._env_data:
                self._env_data.append(atom)

    def _compute_env(self, step, action):
        """ """
        ctl_env = Control()
        ctl_env.load(self._env_info[0])
        ctl_env.load(self._instance_info[0])
        ctl_env.add("base", [], f"{action}.")

        for env_his in self._env_data:
            ctl_env.add("base", [], f"{env_his}.")

        ctl_env.add("base", [], f"time({int(step)}).")
        ctl_env.ground([("base", [])])
        ctl_env.solve(on_model=self.env_model)

    def agent_action_multi(self, step, action):
        """ """
        event_start_time = time.perf_counter()
        self._set_constant("x", f"{step}")
        self.add_assumption(action, "true")

        self._ground("step", [f"{int(step) + 1}"])
        self.set_external(f"query({int(step)})", "false")

        self.set_external(f"query({int(step)+1})", "true")

        agent_time = time.perf_counter()
        agent_runtime = agent_time - event_start_time
        env_start_time = time.perf_counter()

        self._compute_env(f"{int(step)}", action)

        env_time = time.perf_counter()
        env_runtime = env_time - env_start_time

        self.update()
        runtime = time.perf_counter()
        full_runtime = runtime - event_start_time

        print(f"Step:{step}, AGENT RUNTIME: {agent_runtime}")
        print(f"Step:{step}, ENV RUNTIME: {env_runtime}")

        print(f"Step:{step}, Total RUNTIME: {full_runtime}")

    @cached_property
    def _ds_env(self):
        prg = "#defined _clinguin_env/1. "

        with open(self._instance_info[0], "r") as file:
            for line in file:
                line = line.strip().rstrip(".")
                prg += f"_clinguin_env({str(line)}).\n"
        return prg
