import time as t
from clingo import Control

# ctl = Control()

AGENT_KNOWLEDGE = []
CURRENT_LOCATION = []
ENV_KNOWLEDGE = []


LOAD_ENV = [
    "instances/instance_small_no_env.lp",
    "single_shot_clinguin_control/environment.lp",
]


def env_model(env_m):
    CURRENT_LOCATION.clear()
    for atom in env_m.symbols(shown=True):
        # if atom not in ENV_KNOWLEDGE:
        # ENV_KNOWLEDGE.append(atom)
        CURRENT_LOCATION.append(atom)
    for atom in env_m.symbols(atoms=True):
        if atom not in ENV_KNOWLEDGE:
            ENV_KNOWLEDGE.append(atom)


def solver(time, load_lp, add_knowledge):
    ctl = Control()
    for lp in load_lp:
        ctl.load(lp)
    # if add_knowledge:
    for adk in add_knowledge:
        ctl.add("base", [], f"{adk}.")
    ctl.add("base", [], f"time({time}).")
    ctl.ground([("base", [])])
    ctl.solve(on_model=env_model)


def debug(who):
    if who == "env":
        for e in ENV_KNOWLEDGE:
            print(e)
    elif who == "loc":
        for e in CURRENT_LOCATION:
            print(e)


def print_debug(ext_time):
    print(f"=============ENV KNOWLEDGE:@{ext_time}==============")
    debug("env")
    print("")

    # print(f"=============LOCATION DATA:@{ext_time}==============")
    # debug("loc")
    # print("")


def clinguin_export():
    with open("single_shot/data_single_shot_env.lp", "w") as file:
        for atom in ENV_KNOWLEDGE:
            file.write(f"{atom}.\n")


def environment_single_shot(time, AGENT_KNOWLEDGE):
    print(time)
    # solver(time, "env", LOAD_ENV, AGENT_KNOWLEDGE)
    return
    # print_debug(time)

    # clinguin_export()
