# Implementing the Observe Think Act loop using Clinguin. 


## Installation Instructions

Clingo
[Dowload Clingo on Potassco.org](https://potassco.org/clingo/)
Clinguin
[Clinguin install instruction can be found here](https://clinguin.readthedocs.io/en/v2.2.2/clinguin/installation.html)


## Repository Structure

- Backend
  Location of the Backend Files

- Ui Files
  - multi_shot_ui.lp 
  - single_shot_ui.lp

- Multi_shot
  - agent_multi_shot.lp (Agent encoding)
  - agent_init_loc.lp **Domain file describing the agent initial location

- Single_shot
  - agent_single_shot.lp 
   
- Environment
  - environment_single_shot.lp
  - environent_multi_shot.lp


- Instance Files
    - instance_4x5_.lp  empty map
    - instance_4x5_g.lp   gold
    - instance_4x5_pg.lp  pit and gold
    - instance_4x5_wpg.lp wumpus pit and gold

## How to Run 
After installing both Clinguin, and Clingo you need to open a terminal and cd into the root directory of the repository.
from the CLI you then run the following command for single_shot and multi_shot

the --instance argument can be changed to any of the other instances avaible.

### Single shot
```console
foo@bar:~$ clinguin client-server --domain-file single_shot/agent_single_shot.lp --ui-files=ui_files/single_shot_ui.lp  --custom-classes backend/single_shot_OTA_backend.py --backend ota_backend --env-file environment/environment_single_shot.lp --instance instances/instance_4x5_wpg.lp
```
### Multi Shot

```console
foo@bar:~$ ❯ clinguin client-server --domain-file multi_shot/{agent_multi_shot.lp, agent_init_loc.lp } --ui-files=ui_files/multi_shot_ui.lp --custom-classes backend/multi_shot_OTA_backend.py --backend multi_shot_ota_backend --env-file environment/environment_multi_shot.lp --instance instances/instance_4x5_wpg.lp

```

## License
