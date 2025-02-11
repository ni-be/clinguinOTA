"""
Single Shot OTA Wumpus Implementation According to the AAA

"""


from clingo import Control

AGENT_KNOWLEDGE = []
CURRENT_LOCATION = []
ENV_KNOWLEDGE = []


LOAD_ENV = [
    "instances/instance_simple.lp",
    "base_versions/environment.lp",
]
LOAD_AGENT = [
    "base_versions/agent.lp",
]

def agent_model(agent_m):
    for atom in agent_m.symbols(atoms=True):
        if atom not in AGENT_KNOWLEDGE:
            AGENT_KNOWLEDGE.append(atom)


def env_model(env_m):
    CURRENT_LOCATION.clear()
    for atom in env_m.symbols(shown=True):
        # if atom not in ENV_KNOWLEDGE:
        # ENV_KNOWLEDGE.append(atom)
        CURRENT_LOCATION.append(atom)
    for atom in env_m.symbols(atoms=True):
        if atom not in ENV_KNOWLEDGE:
            ENV_KNOWLEDGE.append(atom)


def solver(time, target, load_lp, add_knowledge):
    ctl = Control()
    for lp in load_lp:
        ctl.load(lp)
    # if add_knowledge:
    for adk in add_knowledge:
        ctl.add("base", [], f"{adk}.")
    ctl.add("base", [], f"time({time}).")
    ctl.ground([("base", [])])
    if target == "agent":
        ctl.solve(on_model=agent_model)
    else:
        ctl.solve(on_model=env_model)


def debug(who):
    if who == "agent":
        for a in AGENT_KNOWLEDGE:
            print(a)
    elif who == "env":
        for e in ENV_KNOWLEDGE:
            print(e)
    elif who == "loc":
        for e in CURRENT_LOCATION:
            print(e)


def print_debug(ext_time):
    # print(f"=============ENV KNOWLEDGE:@{ext_time}==============")
    # debug("env")
    # print("")

    # print(f"=============LOCATION DATA:@{ext_time}==============")
    # debug("loc")
    # print("")

    print(f"=============AGENT KNOWLEGDE: @{ext_time}============")
    debug("agent")
    print("")


def clinguin_export():
    with open("single_shot/env_data.lp", "w") as file:
        for atom in ENV_KNOWLEDGE:
            file.write(f"{atom}.\n")
    with open("single_shot/agent_data.lp", "w") as file:
        for atom in AGENT_KNOWLEDGE:
            file.write(f"{atom}.\n")


def single_shot():
    time = 0
    horizon = 20
    exploring = True
    while exploring: 
        solver(time, "env", LOAD_ENV, AGENT_KNOWLEDGE)
        working_knowledge = AGENT_KNOWLEDGE + CURRENT_LOCATION
        solver(time, "agent", LOAD_AGENT, working_knowledge)
        print_debug(time)
        time += 1
        if time == horizon:
            exploring = False

    clinguin_export()


single_shot()
