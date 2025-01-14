 clinguin client-server --domain-file single_shot/agent_semi_single.lp --ui-files=ui_files/single_shot_ui.lp  --custom-classes backend/ota_backend.py --backend ota_backend --env-file single_shot/environment_semi_single.lp --instance instances/instance_small_no_env.lp


clinguin client-server --domain-file multi_shot/{agent_multi.lp, agent_init_loc.lp } --ui-files=ui_files/multi_ui.lp --custom-classes backend/ms_ota.py --backend ota_backend --env-file multi_shot/environment_multi.lp --instance instances/instance_simple.lp
