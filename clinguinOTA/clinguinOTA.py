"""
Wumpus Implementation According to the AAA

"""

import re
import time as t
from clingo import Control

# ctl = Control()

AGENT_KNOWLEDGE = []
CURRENT_LOCATION = []
ENV_KNOWLEDGE = []


LOAD_ENV = [
    "world_facts/world_facts.lp",
    "instances/instance00_env.lp",
    "environment/environment.lp",
]
LOAD_AGENT = [
    "instances/instance00_agent.lp",
    "agent/agent.lp",
    "world_facts/world_facts.lp",
]


def agent_model(agent_m):
    for atom in agent_m.symbols(shown=True):
        if atom not in AGENT_KNOWLEDGE:
            AGENT_KNOWLEDGE.append(atom)


def env_model(env_m):
    CURRENT_LOCATION.clear()
    for atom in env_m.symbols(shown=True):
        if atom not in ENV_KNOWLEDGE:
            ENV_KNOWLEDGE.append(atom)
        CURRENT_LOCATION.append(atom)


def solver(ext_time, target, load_lp, add_knowledge):
    ctl = Control()
    for lp in load_lp:
        ctl.load(lp)
    if add_knowledge:
        for adk in add_knowledge:
            ctl.add("base", [], f"{adk}.")
    ctl.add("base", [], f"ext_time({ext_time}).")
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


def clinota():
    ext_time = 0
    horizon = 1
    exploring = True

    while exploring:
        # for the initial state
        if ext_time == 0:
            solver(ext_time, "agent", LOAD_AGENT, False)
            # somehow reduce agent_knowledge transferd to env to holds(T,in(agent,C)).
            solver(ext_time, "env", LOAD_ENV, AGENT_KNOWLEDGE)
        #elif ext_time > 0:
        #    working_knowledge = AGENT_KNOWLEDGE + CURRENT_LOCATION
        #    print(ext_time)
        #    solver(ext_time, "agent", LOAD_AGENT, working_knowledge)
        #    solver(ext_time, "env", LOAD_ENV, AGENT_KNOWLEDGE)

        ext_time += 1
        #print("AGENT")
        debug("agent")
        print("ENV")
        debug("env")
        if ext_time == horizon:
            # later set to when gold was found
            exploring = False


clinota()
