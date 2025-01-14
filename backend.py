class backend(ClingoBackend):

    def __init_commandline(self):
        #initialize env files
        #initialize local variables
        self._env_info = ""
        self._actions = ""
        self._current_step = 0

    def register_options(self):
        #Add option for env files

    def _init_ctl(self):
        super.init_ctl()
        self._update_env()
        self._ctl.add("base", [], self._env_info) #maybe not needed
        self._ctl.add("base", [], self._actions)

    def _update_env(self):
        ctl_env = Control(env_file)
        ctl_env.add("base", [], self._actions)
        env = get_new_env(ctl_env)
        self._env_info.add(env)

    def act(self, action):
        self._actions.append(action)
        self._current_step += 1
        self._init_ctl()






_any(right(X)).
when(x, clicked, call, act(right(x,T))).

