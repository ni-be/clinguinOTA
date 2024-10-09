"""
Custom CLinguin Backend for the Single Shot OTA implementation

Keep Clingo CTL to Agent, and Environment External

[ ]TODO : Compute Agent is not triggered at all


[x]TODO1: Compute Environment at time T.
[ ]TODO2: Transfer Environment Info to agent
[ ]TODO3: Reground Agent
[ ]TODO4: Update UI for current Time Step.
[ ]TODO5: Add User Choice - Drop Down Menu -> Possible_goals
[ ]TODO6: After Choice, ground and solve again

"""

from clinguin.utils.annotations import extends


from clingo import Control
from clinguin.server.application.backends import ClingoBackend


class otabackend(ClingoBackend):
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
        # parser.add_argument("--horizon", help="Add and Horizon (INT)", nargs="*")

    @extends(ClingoBackend)
    def _init_command_line(self):
        super()._init_command_line()
        self._env_info = self._args.env_file
        self._instance_info = self._args.instance_file
        # self._horizon = self._args.horizon
        self._current_time = 0
        self._current_location = []
        self._env_data = []
        self._actions = []
        self._agent_data = []

    def _init_ctl(self):
        # self._create_ctl()
        self.gprepare()
        self._ground()
        self._ds_model
        # print(self._domain_state)
        # self._update_ui_state()
        # self._load_and_add()
        # self._ground("base", None)
        # self._on_model(None)
        # print(self._current_location)
        # print(self._assumption_list)

    # @extends(ClingoBackend)
    # def _init_interactive(self):
    #    super()._init_interactive()

    # @extends(ClingoBackend)
    def gprepare(self):
        """
        Does any preparation before a solve call.
        """
        super()._prepare()
        # Load environment and instance files
        if not self._env_info:
            raise ValueError("Environment file is missing.")
        if not self._instance_info:
            raise ValueError("Instance file is missing.")

        self._compute_env()
        self._compute_agent()
        self._load_and_add()

    def agent_model(self, agent_m):
        for atom in agent_m.symbols(shown=True):
            self._add_atom(atom)
            print(atom)

    #     #     self._current_location.append(atom)
    #     #     # print(atom)
    #     for atom in agent_m.symbols(atoms=True):
    #         if atom not in self._agent_data:
    #             self._agent_data.append(atom)
    #             print(atom)

    # @extends(ClingoBackend)
    def _compute_agent(self):
        # super()._load_and_add()
        for f in self._domain_files:
            self._load_file(f)
        self._ctl.add("base", [], f"time({self._current_time}).")
        for al in self._actions:
            self._ctl.add("base", [], f"{al}.")
        for cl in self._current_location:
            self._ctl.add("base", [], f"{cl}.")
        # if self._current_time > 0:
        # for ad in self._agent_data:
        #        self._ctl.add("base", [], "f{ad}.")
        # print("hello")
        self._ctl.ground([("base", [])])
        self._ctl.solve(on_model=self.agent_model)

    def env_model(self, env_m):
        for atom in env_m.symbols(shown=True):
            self._current_location.append(atom)
            # print(atom)
        for atom in env_m.symbols(atoms=True):
            if atom not in self._env_data:
                self._env_data.append(atom)
                # print(atom)

    def _compute_env(self):
        # print(self._current_time)
        # print(self._actions)
        # print("hello")
        ctl_env = Control()
        # Load Instance.lp and environment.lp
        ctl_env.load(self._env_info[0])
        ctl_env.load(self._instance_info[0])
        if len(self._actions) > 0:
            ctl_env.add("base", [], f"{self._actions[0]}.")
        ctl_env.add("base", [], f"time({self._current_time}).")
        if len(self._env_data) > 0:
            for atoms in self._env_data:
                ctl_env.add("base", [], f"{atoms}.")
        ctl_env.ground([("base", [])])
        ctl_env.solve(on_model=self.env_model)

    def agent_action(self, action):
        print(action)
        self._actions.append(action)
        self._current_time += 1
        self._init_ctl()
