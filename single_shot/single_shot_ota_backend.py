"""
Custom Clinguin Backend for the Single Shot OTA implementation

[x] TODO-1: Cleaned Up environment, UI-FIlE
[ ] TODO0 : _init
[ ] TODO1 : Compute ENV at time time T.
[ ] TODO2 : Make GUI visible
[ ] TODO3 : create ds property
[ ] TODO4 : User Choice, Occurs
[ ] TODO5 : POST action
[ ] TODO6 : compute POST action
[ ] TODO7 : new atoms for time +1
[ ] TODO8 : Add to Domain Control
[ ] TODO9 : Update GUI
[ ] TODO10: Go round trip with just occurs
[ ] TODO11: Add Assumptions if assumed wumpus or pit
[ ] TODO12: Be able to remove assumptions if assumed wumpus or pit
[ ] TODO13: 
[ ] TODO14:
[ ] TODOXX: Make Left Container invisible /
            Visible press of button /
            Help / after escaping


"""

from clinguin.utils.annotations import extends
from clinguin.server.application.backends import ClingoBackend 
clingo import Control

class otabackendSS(ClingoBackend):
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
        self._env_info = self._args.env_file
        self._instance_info = self._args.instance_file
        self._current_time = 0
        self._current_location = []
        self._env_data = []
        self._actions = []
        self._agent_data = []

