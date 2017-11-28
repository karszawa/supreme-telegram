
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

hdi::project new -name ISE -dir "/home/jikken17/FPGA_TOP/ISE/planAhead_run_2"
hdi::project setArch -name ISE -arch virtex5
hdi::design setOptions -project ISE -top fpga_top   \
    -verilogDir { {/home/jikken17/FPGA_TOP/include/} }
hdi::param set -name project.paUcfFile -svalue "/home/jikken17/FPGA_TOP/fpga/fpga_top.ucf"
hdi::floorplan new -name floorplan_1 -part xc5vlx50ff676-1 -project ISE
hdi::port import -project ISE \
    -verilog {../rtl/dvi/Register.v work} \
    -verilog {../rtl/dvi/HardRegister.v work} \
    -verilog {../rtl/dvi/FIFORegControl.v work} \
    -verilog {../rtl/dvi/ShiftRegister.v work} \
    -verilog {../rtl/dvi/FIFORegister.v work} \
    -verilog {../rtl/dvi/Counter.v work} \
    -verilog {../rtl/dvi/CountCompare.v work} \
    -verilog {../rtl/dvi/I2CMaster.v work} \
    -verilog {../rtl/dvi/FIFOShiftRound.v work} \
    -verilog {../rtl/dvi/CountRegion.v work} \
    -verilog {../rtl/dvi/SDR2DDR.v work} \
    -verilog {../rtl/dvi/PixelCounter.v work} \
    -verilog {../rtl/dvi/IORegister.v work} \
    -verilog {../rtl/dvi/I2CDRAMMaster.v work} \
    -verilog {../rtl/dvi/FIFOInitial.v work} \
    -verilog {../rtl/dvi/disp_digit_seg.v work} \
    -verilog {../rtl/sysele/lcd/lcd_memory.v work} \
    -verilog {../rtl/sysele/lcd/lcd_control.v work} \
    -verilog {../rtl/sysele/lcd/lcd_comm.v work} \
    -verilog {../rtl/sysele/lcd/key2char.v work} \
    -verilog {../rtl/ps2/ps2_data_in.v work} \
    -verilog {../rtl/ps2/ps2_command_out.v work} \
    -verilog {../rtl/dvi/sync_gen.v work} \
    -verilog {../rtl/dvi/DVIInitial.v work} \
    -verilog {../rtl/dvi/DVIData.v work} \
    -verilog {../rtl/dvi/draw_rect.v work} \
    -verilog {../rtl/dvi/disp_digit.v work} \
    -verilog {../rtl/dvi/button_detector.v work} \
    -verilog {../rtl/tele_txrx/tele_tx.v work} \
    -verilog {../rtl/tele_txrx/tele_rx.v work} \
    -verilog {../rtl/tele_txrx/tele_err.v work} \
    -verilog {../rtl/tele_txrx/tele_crg.v work} \
    -verilog {../rtl/sysele/rstgen.v work} \
    -verilog {../rtl/sysele/lcd/lcd_ctrl_top.v work} \
    -verilog {../rtl/sysele/lcd/lcd.v work} \
    -verilog {../rtl/ps2/ps2_mouse.v work} \
    -verilog {../rtl/ps2/ps2_keyboard_ctrl.v work} \
    -verilog {../rtl/ps2/ps2_keyboard.v work} \
    -verilog {../rtl/dvi/move_rect.v work} \
    -verilog {../rtl/dvi/DVI.v work} \
    -verilog {../rtl/dvi/display.v work} \
    -verilog {../rtl/dvi/CPG.v work} \
    -verilog {../rtl/audio/audio_proc.v work} \
    -verilog {../rtl/audio/audio_if.v work} \
    -verilog {pll2.v work} \
    -verilog {pll.v work} \
    -verilog {../rtl/sysele/lcd_top.v work} \
    -verilog {../rtl/ps2/ps2_top.v work} \
    -verilog {../rtl/dvi/DVI_TOP.v work} \
    -verilog {../rtl/audio/audio.v work} \
    -verilog {crg.v work} \
    -verilog {../fpga/fpga_top.v work} \
    -verilog {clock_gen.v work} \
    -verilog {clockgen.v work}
hdi::port export -project ISE -file ISE_pa_ports.v -format verilog
hdi::pconst import -project ISE -floorplan floorplan_1 -file "/home/jikken17/FPGA_TOP/fpga/fpga_top.ucf"
