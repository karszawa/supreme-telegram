
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

hdi::project new -name ISE -dir "/home/jikken17/FPGA_TOP/ISE/planAhead_run_2"
hdi::project setArch -name ISE -arch virtex5
hdi::design setOptions -project ISE -top netlist_1_EMPTY
hdi::param set -name project.paUcfFile -svalue "/home/jikken17/FPGA_TOP/fpga/fpga_top.ucf"
hdi::floorplan new -name floorplan_1 -part xc5vlx50ff676-1 -project ISE
hdi::port import -project ISE -verilog {ISE_pa_ports.v work}
hdi::pconst import -project ISE -floorplan floorplan_1 -file "/home/jikken17/FPGA_TOP/fpga/fpga_top.ucf"
