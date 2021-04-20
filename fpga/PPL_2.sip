set_global_assignment -entity "PPL_2" -library "lib_PPL_2" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PPL_2" -library "lib_PPL_2" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "PPL_2" -library "lib_PPL_2" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PPL_2" -name SPD_FILE [file join $::quartus(sip_path) "PPL_2.spd"]

set_global_assignment -library "lib_PPL_2" -name MISC_FILE [file join $::quartus(sip_path) "PPL_2_sim/PPL_2.vo"]
