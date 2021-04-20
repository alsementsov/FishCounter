set_global_assignment -entity "PLL_MTL" -library "lib_PLL_MTL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_MTL" -library "lib_PLL_MTL" -name IP_TOOL_VERSION "13.1"
set_global_assignment -entity "PLL_MTL" -library "lib_PLL_MTL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_MTL" -name SPD_FILE [file join $::quartus(sip_path) "PLL_MTL.spd"]

set_global_assignment -library "lib_PLL_MTL" -name MISC_FILE [file join $::quartus(sip_path) "PLL_MTL_sim/PLL_MTL.vo"]
