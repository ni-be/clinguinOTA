import logging
import textwrap
import time


from typing import Any, Self

from clingo import Control, parse_term
from clingo.script import enable_python

from clinguin.server import StandardJsonEncoder, UIState
from clinguin.server.data.domain_state import solve, tag

# from ....utils.logger import domctl_log
# from ....utils.transformer import UsesSignatureTransformer


from clinguin.server.application.backends import ClingoBackend


LOAD_ENV = [
    "single_shot_clinguin_control/environment.lp",
    "instances/instance_small_no_env.lp",
]
LOAD_TEMP_INSTANCE = "temp_instance.lp"
CURRENT_LOCATION = []
ENV_KNOWLEDGE = []


class environment_backend(ClingoBackend):
    def env_model(self, env_m):
        CURRENT_LOCATION.clear()
        for atom in env_m.symbols(shown=True):
            # if atom not in ENV_KNOWLEDGE:
            # ENV_KNOWLEDGE.append(atom)
            # CURRENT_LOCATION.append(atom)
            print("hello")
            self._add_assumption(atom, "true")

        for atom in env_m.symbols(atoms=True):
            print("hello2")
            if atom not in ENV_KNOWLEDGE:
                ENV_KNOWLEDGE.append(atom)

    def observe(self, curr_time, occurs) -> None:
        """
        When called should use the current time step and the action of the agent and then ground the program
        output should be location that which is true with #show

        - Store knowledge in a file
        - Load that file

        """
        env_ctl = Control()
        for env in LOAD_ENV:
            env_ctl.load([], f"{env}")

        if int(curr_time) > 0:
            for temp_instance in LOAD_TEMP_INSTANCE:
                env_ctl.add("base", [], f"{temp_instance}.")

            # for actions in occurs:
            # if parse_term(actions).name == "occurs":
        #    print(occurs)
        env_ctl.add("base", [], f"{occurs}.")

        env_ctl.add("base", [], f"time({curr_time}).")
        env_ctl.solve(on_model=self.env_model)

        # ctl = self._ctl
        # for env in LOAD_ENV:
        #    ctl._load_file(env)

        # self._add_atom(f"{occurs}.")
        # self._add_assumption(f"time({curr_time}).", "true")
        # for x in self._ctl
        #    print(x)
        # self._ground("base", [])
        # self.select("")
        # with open(f"{LOAD_TEMP_INSTANCE}", "w") as file:
        #    for atom in ENV_KNOWLEDGE:
        #        file.write(f"{atom}.\n")

    def observe(self, curr_time) -> None:
        environment_single_shot(curr_time, self._assumption_list)
        # print(curr_time)
        # print(self._assumption_list)
        # print(self._ctl_arguments_list)


# def __init_commandline(self):
#     #initialize env files
#     #initialize local variables
#     self._env_info = ""
#     self._actions = ""
#     self._current_step = 0

# def register_options(self):
#     #Add option for env files

# def _init_ctl(self):
#     super.init_ctl()
#     self._update_env()
#     self._ctl.add("base", [], self._env_info) #maybe not needed
#     self._ctl.add("base", [], self._actions)

# def _update_env(self):
#     ctl_env = Control(env_file)
#     ctl_env.add("base", [], self._actions)
#     env = get_new_env(ctl_env)
#     self._env_info.add(env)

# def act(self, action):
#     self._actions.append(action)
#     self._current_step += 1
#     self._init_ctl()
