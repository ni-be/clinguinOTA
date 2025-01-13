"""
Custom Clinguin Backend for the Single Shot OTA implementation

"""

import clingo
from functools import cached_property
import time
from clinguin.server.application.backends.clingo_backend import UIState
from clinguin.utils.annotations import extends
from clinguin.server.application.backends import ClingoBackend
from clinguin.server.data.domain_state import solve, tag
from clingo import Control


class ota_backend(ClingoBackend):
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
        self._env_data = []  # Actually Needed?
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

        # for last_loc in self._loc_data:
        #     self._set_external(last_loc, "release")  # print("model env trigger")
        for atom in env_m.symbols(shown=True):
            # self._ctl.add("base", [], f"{atom}.")
            # print("return shown true f. env ", atom)

            # if atom not in self._loc_data:
            # self._add_assumption(atom, "true")
            self._set_external(atom, "true")
            self._loc_data.append(atom)
            print(atom)
            # self._add_assumption(atom, "true")
        print("====================================")
        for atom in env_m.symbols(atoms=True):
            if atom not in self._env_data:
                self._env_data.append(atom)
                # print("if true: ", atom)
            # print(atom)

    def _compute_env(self, step, action):
        """
        1. create control object for the environent
        2. load the env. information and instance data
        3. if actions have been chosen, in the UI/agent, include add them to ctl.
        4. add the current time,
        5. ground
        6. solve
        """
        print("env compute")
        ctl_env = Control()
        # print("comp env trigger")
        ctl_env.load(self._env_info[0])
        ctl_env.load(self._instance_info[0])
        ctl_env.add("base", [], f"{action}.")

        for env_his in self._env_data:
            ctl_env.add("base", [], f"{env_his}.")

        ctl_env.add("base", [], f"time({int(step)}).")
        ctl_env.ground([("base", [])])
        ctl_env.solve(on_model=self.env_model)

    def agent_action_multi(self, step, action):
        """
        when action is triggered in UI, append action to the list of actions.
        all actions that influence the env. are in here.

        """
        # start_time = time.perf_counter()

        # self._ground("step", [step])

        self.add_assumption(action, "true")

        self._ground("step", [f"{int(step) + 1}"])

        self.set_external(f"query({int(step)})", "false")

        self.set_external(f"query({int(step)+1})", "true")
        self._compute_env(f"{int(step)}", action)
        # self._outdate()
        self.update()

    # def agent_init_request(self, step,action):
    #     self._compute_env()

    @cached_property
    def _ds_env(self):
        prg = "#defined _clinguin_env/1. "

        with open(self._instance_info[0], "r") as file:
            for line in file:
                line = line.strip().rstrip(".")
                prg += f"_clinguin_env({str(line)}).\n"
        return prg
