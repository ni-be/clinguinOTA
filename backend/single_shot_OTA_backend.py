"""
Custom Clinguin Backend for the Single Shot OTA implementation

"""


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
        self._env_data = [] 
        self._agent_data = []
        self._actions = []
        self._line_count = 0

    """ 
    2. Get the init environment at time 0 to load based on the provided instance data
    """

    def env_model(self, env_m):
        """
        1. Solve the control object of the environment
        2. The Atoms defined in the env. encoding with a #show are now added to the clinguin control object.
        3. The env atoms will be that are true will stored in the env_data array.
        """
        # print("model env trigger")
        for atom in env_m.symbols(shown=True):
            # self._ctl.add("base", [], f"{atom}.")
            # print("return shown true f. env ", atom)
            self._loc_data.append(atom)
        for atom in env_m.symbols(atoms=True):
            if atom not in self._env_data:
                self._env_data.append(atom)
                # print("if true: ", atom)

    def agent_model(self, agent_m):
        """Collects atoms from the agent's solution model for UI update."""
        for atom in agent_m.symbols(shown=True):
            self._agent_data.append(atom)
            # print("Agent result atom:", atom)
            self._add_atom(atom)

    def compute_env(self):
        """
        1. create control object for the environent
        2. load the env. information and instance data
        3. if actions have been chosen, in the UI/agent, include add them to ctl.
        4. add the current time,
        5. ground
        6. solve
        """
        ctl_env = Control()
        ctl_env.load(self._env_info[0])
        ctl_env.load(self._instance_info[0])
        for act in self._actions:
            ctl_env.add("base", [], f"{act}.")

        for env_his in self._env_data:
            ctl_env.add("base", [], f"{env_his}.")

        ctl_env.add("base", [], f"time({self._current_time}).")
        ctl_env.ground([("base", [])])
        ctl_env.solve(on_model=self.env_model)

    def compute_agent(self):
        for loc in self._loc_data:
            self._ctl.add("base", [], f"{loc}.")

        for atom in self._agent_data:
            self._ctl.add("base", [], f"{atom}.")

        self._ctl.add("base", [], f"time({self._current_time}).")
             
        self._ctl.ground([("base", [])])

        self._agent_data.clear()

        self._ctl.solve(on_model=self.agent_model)

        self._outdate()
        self._init_ctl()
        self._ground()


    @extends(ClingoBackend)
    def _init_ctl(self):
        """
        Init the clingiun control with the data provided the environment.

        """
        super()._init_ctl()
        self._ctl.add("base", [], f"time({self._current_time}).")

        for atom in self._agent_data:
            self._ctl.add("base", [], f"{atom}.")
            # print(atom)
        self.compute_env()
        for ld in self._loc_data:
            self._ctl.add("base", [], f"{ld}.")

    def agent_action_semi(self, action):
        """
        when action is triggered in UI, append action to the list of actions.
        all actions that influence the env. are in here.

        """
        self._actions.append(action)
        self._agent_data.append(action)
        self._current_time += 1
        self.compute_agent()
       