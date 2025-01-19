# Implementing the Observe Think Act loop using Clinguin. 

In this repository you find the first iteration of the Observe Think Act Loop implented using Clinguin


## Installation Instructions

Clingo

Clinguin

Clingraph

## Repository Structure

- Backend
  Location of the Backend Files

- Ui Files
  - multi_shot_ui.lp 
  - single_shot_ui.lp

- Multi_shot
  - Agent Encoding for:
    - m (Mapping)
    - mp (Mapping + PickUp)
    - mo (Mapping + Obstacle Avoidance)
    - mpoi (Mapping + PickUp + Obstacle Avoidance and Interaction)
    - agent_init_loc.lp **Domain file describing the agent initial location

- Single_shot
  - Agent Encoding for:
    - m (Mapping)
    - mp (Mapping + PickUp)
    - mo (Mapping + Obstacle Avoidance)
    - mpoi (Mapping + PickUp + Obstacle Avoidance and Interaction)

- Environment
  - TODO

- Benchmarks

- Instance Files
  - Files for:
    - m (Mapping)
    - mp (Mapping + PickUp)
    - mo (Mapping + Obstacle Avoidance)
    - mpoi (Mapping + PickUp + Obstacle Avoidance and Interaction)

## How to Run 

### Single shot

### Multi Shot
'''Shell
clinguin client-server --domain-file multi_shot/{**DOMAIN**_multi_shot_agent.lp, agent_init_loc.lp } --ui-files=ui_files/multi_shot_ui.lp --custom-classes backend/multi_shot_OTA_backend.py --backend multi_shot_backend --env-file multi_shot/environment_multi.lp --instance instances/**INSERT INSTANCE**.lp
'''

So that would be or example:

TODO 
'''Shell
clinguin client-server --domain-file multi_shot/{agent_multi.lp, agent_init_loc.lp } --ui-files=ui_files/multi_shot_ui.lp --custom-classes backend/multi_shot_OTA_backend.py --backend ota_backend --env-file multi_shot/environment_multi.lp --instance instances/instance_simple.lp
'''

## License
