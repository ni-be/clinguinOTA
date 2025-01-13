"""
Multi Shot OTA Wumpus Implementation According to the AAA

"""

import sys
from typing import cast, Any, Callable, Optional, Sequence

from clingo.application import clingo_main, Application, ApplicationOptions
from clingo.control import Control
from clingo.solving import SolveResult
from clingo.symbol import Function, Number
# ctl = Control()

AGENT_KNOWLEDGE = []
CURRENT_LOCATION = []
ENV_KNOWLEDGE = []


LOAD_ENV = [
    # "instances/instance_small_no_env.lp",
    # "instances/inst_move_check.lp",
    "instances/instance_small_wumpus.lp",
    # "instances/instance_med_wumpus_2pit.lp",
    "base_versions/agent_multi.lp",
    "base_versions/environment.lp",
]
# LOAD_AGENT = [
#     "base_versions/agent_multi.lp",
# ]


class IncConfig:
    """
    Configuration object for incremental solving.
    """

    imin: int
    imax: Optional[int]
    istop: str

    def __init__(self):
        self.imin = 1
        self.imax = None
        self.istop = "SAT"


def parse_int(
    conf: Any, attr: str, min_value: Optional[int] = None, optional: bool = False
) -> Callable[[str], bool]:
    """
    Returns a parser for integers.

    The parser stores its result in the `attr` attribute (given as string) of
    the `conf` object. The parser can be configured to only accept integers
    having a minimum value and also to treat value `"none"` as `None`.
    """

    def parse(sval: str) -> bool:
        if optional and sval == "none":
            value = None
        else:
            value = int(sval)
            if min_value is not None and value < min_value:
                raise RuntimeError("value too small")
        setattr(conf, attr, value)
        return True

    return parse


def parse_stop(conf: Any, attr: str) -> Callable[[str], bool]:
    """
    Returns a parser for `istop` values.
    """

    def parse(sval: str) -> bool:
        if sval not in ("SAT", "UNSAT", "UNKNOWN"):
            raise RuntimeError("invalid value")
        setattr(conf, attr, sval)
        return True

    return parse


class IncApp(Application):
    """
    The example application implemeting incremental solving.
    """

    program_name: str = "inc-example"
    version: str = "1.0"
    _conf: IncConfig

    def __init__(self):
        self._conf = IncConfig()

    def register_options(self, options: ApplicationOptions):
        """
        Register program options.
        """
        group = "Inc-Example Options"

        options.add(
            group,
            "imin",
            "Minimum number of steps [{}]".format(self._conf.imin),
            parse_int(self._conf, "imin", min_value=0),
            argument="<n>",
        )

        options.add(
            group,
            "imax",
            "Maximum number of steps [{}]".format(self._conf.imax),
            parse_int(self._conf, "imax", min_value=0, optional=True),
            argument="<n>",
        )

        options.add(
            group,
            "istop",
            "Stop criterion [{}]".format(self._conf.istop),
            parse_stop(self._conf, "istop"),
        )

    def main(self, ctl: Control, files: Sequence[str]):
        """
        The main function implementing incremental solving.
        """
        if not files:
            files = ["-"]
        for file_ in files:
            ctl.load(file_)
        ctl.add("check", ["t"], "#external time(t).")

        conf = self._conf
        step = 0
        ret: Optional[SolveResult] = None

        while (conf.imax is None or step < conf.imax) and (
            ret is None
            or step < conf.imin
            or (
                (conf.istop == "SAT" and not ret.satisfiable)
                or (conf.istop == "UNSAT" and not ret.unsatisfiable)
                or (conf.istop == "UNKNOWN" and not ret.unknown)
            )
        ):
            parts = []
            parts.append(("check", [Number(step)]))
            if step > 0:
                ctl.release_external(Function("time", [Number(step - 1)]))
                parts.append(("step", [Number(step)]))
            else:
                parts.append(("base", []))
            ctl.ground(parts)

            ctl.assign_external(Function("time", [Number(step)]), True)
            ret, step = cast(SolveResult, ctl.solve()), step + 1


clingo_main(IncApp(), sys.argv[1:])
# def agent_model(agent_m):
#     for atom in agent_m.symbols(atoms=True):
#         if atom not in AGENT_KNOWLEDGE:
#             AGENT_KNOWLEDGE.append(atom)


# def env_model(env_m):
#     CURRENT_LOCATION.clear()
#     for atom in env_m.symbols(shown=True):
#         # if atom not in ENV_KNOWLEDGE:
#         # ENV_KNOWLEDGE.append(atom)
#         CURRENT_LOCATION.append(atom)
#     for atom in env_m.symbols(atoms=True):
#         if atom not in ENV_KNOWLEDGE:
#             ENV_KNOWLEDGE.append(atom)


# def solver(time, target, load_lp, add_knowledge):
#     ctl = Control()
#     for lp in load_lp:
#         ctl.load(lp)
#     # if add_knowledge:
#     for adk in add_knowledge:
#         ctl.add("base", [], f"{adk}.")
#     ctl.add("base", [], f"time({time}).")
#     ctl.ground([("base", [])])
#     if target == "agent":
#         ctl.solve(on_model=agent_model)
#     else:
#         ctl.solve(on_model=env_model)


# def debug(who):
#     if who == "agent":
#         for a in AGENT_KNOWLEDGE:
#             print(a)
#     elif who == "env":
#         for e in ENV_KNOWLEDGE:
#             print(e)
#     elif who == "loc":
#         for e in CURRENT_LOCATION:
#             print(e)


# def print_debug(ext_time):
#     print(f"=============ENV KNOWLEDGE:@{ext_time}==============")
#     debug("env")
#     print("")

#     print(f"=============LOCATION DATA:@{ext_time}==============")
#     debug("loc")
#     print("")

#     print(f"=============AGENT KNOWLEGDE: @{ext_time}============")
#     debug("agent")
#     print("")


# def clinguin_export():
#     with open("base_versions/env_data.lp", "w") as file:
#         for atom in ENV_KNOWLEDGE:
#             file.write(f"{atom}.\n")
#     with open("base_versions/agent_data.lp", "w") as file:
#         for atom in AGENT_KNOWLEDGE:
#             file.write(f"{atom}.\n")


# def single_shot():
#     time = 0
#     horizon = 20

#     exploring = True

#     while exploring:  # for the initial state
#         solver(time, "env", LOAD_ENV, AGENT_KNOWLEDGE)
#         working_knowledge = AGENT_KNOWLEDGE + CURRENT_LOCATION
#         solver(time, "agent", LOAD_AGENT, working_knowledge)

#         print_debug(time)

#         time += 1
#         if time == horizon:
#             # later set to when gold was found
#             exploring = False

#     clinguin_export()


# single_shot()
