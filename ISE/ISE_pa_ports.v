`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    Tue Nov 28 14:30:44 2017
// Design Name: 
// Module Name:    netlist_1_EMPTY
//////////////////////////////////////////////////////////////////////////////////
module netlist_1_EMPTY(DVI_D, DIP, LCD_DATA, TP, clk, rst_n, CLK_27MHZ_FPGA, CLK_33MHZ_FPGA, CLK_DIFF_FPGA_P, CLK_DIFF_FPGA_N, DVI_DE, DVI_H, DVI_V, DVI_RESET_B, DVI_XCLK_N, DVI_XCLK_P, audio_bit_clk, audio_sdata_in, audio_sdata_out, audio_sync, flash_audio_reset_b, BUTTON_C, BUTTON_E, BUTTON_W, BUTTON_S, BUTTON_N, TELE_TX, TELE_RX, LCD_RS, LCD_RW, LCD_EN, MOUSE_CLK, MOUSE_DATA, KEYBOARD_CLK, KEYBOARD_DATA, I2C_SCL_DVI, I2C_SDA_DVI, LED_C, LED_E, LED_W, LED_S, LED_N, LED_ERR_1, LED_ERR_0);
  output [11:0] DVI_D;
  input [7:0] DIP;
  inout  [3:0] LCD_DATA;
  output [7:0] TP;
  input clk;
  input rst_n;
  input CLK_27MHZ_FPGA;
  input CLK_33MHZ_FPGA;
  input CLK_DIFF_FPGA_P;
  input CLK_DIFF_FPGA_N;
  output DVI_DE;
  output DVI_H;
  output DVI_V;
  output DVI_RESET_B;
  output DVI_XCLK_N;
  output DVI_XCLK_P;
  input audio_bit_clk;
  input audio_sdata_in;
  output audio_sdata_out;
  output audio_sync;
  output flash_audio_reset_b;
  input BUTTON_C;
  input BUTTON_E;
  input BUTTON_W;
  input BUTTON_S;
  input BUTTON_N;
  output TELE_TX;
  input TELE_RX;
  output LCD_RS;
  output LCD_RW;
  output LCD_EN;
  inout  MOUSE_CLK;
  inout  MOUSE_DATA;
  inout  KEYBOARD_CLK;
  inout  KEYBOARD_DATA;
  inout  I2C_SCL_DVI;
  inout  I2C_SDA_DVI;
  output LED_C;
  output LED_E;
  output LED_W;
  output LED_S;
  output LED_N;
  output LED_ERR_1;
  output LED_ERR_0;


endmodule
