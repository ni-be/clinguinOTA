"""
Custom CLinguin Backend for the Single Shot OTA implementation

Keep Clingo CTL to Agent, and Environment External

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

    def _init_ctl(self):
        self._create_ctl()
        self._prepare()
        # self._load_and_add()
        # self._ground("base", None)
        # self._on_model(None)
        print(self._atoms)
        # print(self._assumption_list)

    @extends(ClingoBackend)
    def _prepare(self):
        """
        Does any preparation before a solve call.
        """
        # Load environment and instance files
        if not self._env_info:
            raise ValueError("Environment file is missing.")
        if not self._instance_info:
            raise ValueError("Instance file is missing.")

        self._compute_env()
        self._update_agent()

    def _update_agent(self):
        for cl in self._current_location:
            self._add_atom(f"{cl}.")
        self._add_atom(f"time({self._current_time}).")

    def env_model(self, env_m):
        for atom in env_m.symbols(shown=True):
            self._current_location.append(atom)
            # print(atom)
        for atom in env_m.symbols(atoms=True):
            if atom not in self._env_data:
                self._env_data.append(atom)
                # print(atom)

    def _compute_env(self):
        print("hello")
        ctl_env = Control()
        ctl_env.load(self._env_info[0])
        ctl_env.load(self._instance_info[0])
        if len(self._actions) > 0:
            ctl_env.load(self._actions[0])
        ctl_env.add("base", [], f"time({self._current_time}).")
        if len(self._env_data) > 0:
            for atoms in self._env_data:
                ctl_env.add("base", [], f"{atoms}.")
        ctl_env.ground([("base", [])])
        ctl_env.solve(on_model=self.env_model)

    def _agent_action(self, action):
        self._actions.append(action)
        self._current_time += 1
        self._init_ctl()
