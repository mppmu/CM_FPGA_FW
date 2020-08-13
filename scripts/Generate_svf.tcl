#this has to be called from inside an open session
source ${apollo_root_path}/scripts/settings.tcl

#add the device info for the uC
#set device-info-file ${apollo_root_path}/scripts/CM_uC_dev_info.csv

set SVF_TARGET [format "svf_top%06u" [expr {round(1000000 *rand())}]]

set bitfile_full_path [format "%s/bit/top.bit" ${apollo_root_path}]
set svffile_full_path [format "%s/bit/top.svf" ${apollo_root_path}]


#derived from walkthrough https://blog.xjtag.com/2016/07/creating-svf-files-using-xilinx-vivado/
open_hw
if { [string length [get_hw_targets -quiet -regexp .*/${SVF_TARGET}] ]  } {
  delete_hw_target -quiet [get_hw_targets -regexp .*/${SVF_TARGET}]
}
create_hw_target ${SVF_TARGET}
close_hw_target
open_hw_target [get_hw_targets -regexp .*/${SVF_TARGET}]

#add the uC to the chain
#create_hw_device -idcode 4BA00477

#add the kintex to the chain
set DEVICE [create_hw_device -part ${FPGA_part}]
set_property PROGRAM.FILE ${bitfile_full_path} $DEVICE
set_param xicom.config_chunk_size 0
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

#add the virtex to the chain
create_hw_device -part xcvu7p-flvb2104-1-e

program_hw_devices -force -svf_file ${svffile_full_path} ${DEVICE}

set load_bit [format "up 0 %s" ${bitfile_full_path}]
set file_arg [format "%s/bit/top.mcs" ${apollo_root_path}]
write_cfgmem -force -loadbit ${load_bit}  -format mcs -size 128 -file $file_arg

delete_hw_target -quiet [get_hw_targets -regexp .*/${SVF_TARGET}]
