set_global_assignment -entity "PPL_1" -library "lib_PPL_1" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PPL_1" -library "lib_PPL_1" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "PPL_1" -library "lib_PPL_1" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PPL_1" -name SPD_FILE [file join $::quartus(sip_path) "PPL_1.spd"]

set_global_assignment -library "lib_PPL_1" -name MISC_FILE [file join $::quartus(sip_path) "PPL_1_sim/PPL_1.vo"]
