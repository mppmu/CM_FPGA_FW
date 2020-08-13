#create bit file
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
write_bitstream -force ${apollo_root_path}/bit/top.bit

#create hwdef file
write_hwdef -file ${apollo_root_path}/kernel/hw/top.hwdef -force

# create the hwdef files
write_sysdef -hwdef ${apollo_root_path}/kernel/hw/top.hwdef -bit ${apollo_root_path}/bit/top.bit -file ${apollo_root_path}/kernel/hw/top.hdf -force

#create any debugging files
write_debug_probes -force ${apollo_root_path}/bit/top.ltx                                                                                                                                 
