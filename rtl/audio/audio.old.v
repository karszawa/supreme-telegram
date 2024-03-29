// Audio Controlling in FPGA
//   ____________           ________
//   |          | ->->->->- |      | ->->->->- ||
//   |   FPGA   |           | AC97 |           || Audio Line In / Line Out
//   | Virtex-5 | -<-<-<-<- |      | -<-<-<-<- ||
//   ~~~~~~~~~~~~           ~~~~~~~~
//

module audio(
	     led0, led1, led2, led3, led4, led5, led6, led7, // for debugging
	     n_rst,  	         // FPGA pin T23
	     clk,          	 // FPGA pin AD13
	     btn_c, btn_n, btn_e, btn_s, btn_w,
	     audio_sdata_out,	 // FPGA pin AC11 (bank 4)
	     audio_bit_clk,	 // FPGA pin AC13 (bank 4)
	     audio_sdata_in,	 // FPGA pin AC12 (bank 4)
	     audio_sync,	 // FPGA pin AD11 (bank 4)
	     flash_audio_reset_b // FPGA pin AD10 (bank 4)
);
	
   // Access between FPGA and AC97; input: FPGA <- AC97, output: FPGA -> AC97
   input        audio_bit_clk;			// 12.288MHz bit clock generated by AC97
   output       flash_audio_reset_b;	        // reset of AC97, negative reset
   input 	audio_sdata_in;			// serial data from AC97, 256bit per frame
   output	audio_sdata_out;		// serial data to AC97, 256bit per frame
   output	audio_sync;			// AC-Link frame sync, 12.288MHz/256 = 48kHz
       
   // Other ports
   input 	clk;
   input 	n_rst;				// reset of FPGA, down:1, up:0
   input 	btn_c, btn_n, btn_e, btn_s, btn_w;
      
   // registers & wires
   reg [4:0] 	counter;
   reg [7:0] 	counter_audio;
   reg [255:0] 	data_in_tmp;
   reg [255:0] 	data_out_tmp;
   reg [255:0] 	data_in;
   reg [255:0] 	data_out;
   reg 		n_audio_reset;
   reg 		audio_start;
   reg [3:0] 	audio_state;
   wire 	audio_sync_start;
   wire [19:0] 	eval_data_out_l, eval_data_out_r;

   // LEDs for debugging (edit as you like!)
   output 	led0, led1, led2, led3, led4, led5, led6, led7;
   assign led0 = audio_sdata_out;
   assign led1 = flash_audio_reset_b;
   assign led2 = audio_sync;
   assign led3 = |data_in[199:180];
   assign led4 = |data_in[179:160];
   assign led5 = |data_out[199:180];
   assign led6 = |data_out[179:160];
   assign led7 = audio_bit_clk;

   // signals
   assign audio_sync_start    = audio_start ? (~|counter_audio[7:4]) : 1'b1;
   assign audio_sync          = n_rst ? audio_sync_start : 1'b1;
   assign audio_sdata_out     = flash_audio_reset_b ? data_out_tmp[255] : 1'b0;
   assign flash_audio_reset_b = ~btn_c;

   // eval
   eval eval(n_rst, clk, data_in[199:180], data_in[179:160], eval_data_out_l, eval_data_out_r);

   // initial setting
   always @(posedge clk) begin		
      if (n_rst == 0) begin
	 counter <= 0;
	 audio_start <= 0;
      end else begin
	 counter <= counter + 1;
      end
      if (counter == 5'd17) audio_start <= 1;
   end
	
// data formatting
always @(posedge audio_bit_clk) begin
	if (audio_start == 0) begin
		counter_audio <= 8'b10000000;
		data_in_tmp   <= 256'd0;
		data_out_tmp  <= 256'd0;
		data_in       <= 256'd0;
	end else begin
		if (counter_audio == 0) begin
			data_in      <= {data_in_tmp[254:0], audio_sdata_in};
			data_out_tmp <= data_out;				
		end else begin
			data_out_tmp <= {data_out_tmp[254:0], 1'b0};
		end
		data_in_tmp     <= {data_in_tmp[254:0], audio_sdata_in};
		counter_audio   <= counter_audio + 1'b1;
	end
end
	
   // data writing
   always @(posedge audio_sync) begin
      if (n_rst == 0) begin
	 data_out <= {256{1'b0}};
	 audio_state <= 4'b0000;
			
	 // Initial Control Register Setting
      end else if ( audio_state == 4'b0000 ) begin // REG 00 write: Register Reset
	 data_out[255:240] <= 16'b1110_0000_0000_0000;
	 data_out[238:220] <= 20'b0000_0000_0000_0000_0000;
	 data_out[219:200] <= 20'b0000_0000_0010_1000_0000;
	 data_out[199:160] <= {40{1'b0}};
	 data_out[159:0] <= {160{1'b0}};
	 audio_state <= 4'b0001;
      end else if ( audio_state == 4'b0001 ) begin // REG 76 write: DAM, FMXE
	 data_out[255:240] <= 16'b1110_0000_0000_0000;
	 data_out[239:220] <= 20'b0111_0110_0000_0000_0000;
	 data_out[219:200] <= 20'b0000_1010_0000_0000_0000;
	 data_out[199:160] <= {40{1'b0}};
	 data_out[159:0] <= {160{1'b0}};
	 audio_state <= 4'b0010;
      end else if ( audio_state == 4'b0010 ) begin // REG 02 write: Master Volume Mute OFF
	 data_out[255:240] <= 16'b1111_1000_0000_0000;
	 data_out[239:220] <= 20'b0000_0010_0000_0000_0000;
	 data_out[219:200] <= 20'b0000_0000_0000_0000_0000;
	 data_out[199:160] <= {40{1'b0}};
	 data_out[159:0] <= {160{1'b0}};
	 audio_state <= 4'b0011;
      end else if ( audio_state == 4'b0011 ) begin // REG 18 write: PCM Out Mute OFF
	 data_out[255:240] <= 16'b1111_1000_0000_0000;
	 data_out[239:220] <= 20'b0001_1000_0000_0000_0000;
	 data_out[219:200] <= 20'b0000_0000_0000_0000_0000;
	 data_out[199:160] <= {40{1'b0}};
	 data_out[159:0] <= {160{1'b0}};
	 audio_state <= 4'b0100;
      end else if ( audio_state == 4'b0100 ) begin // REG 1C write: Input Mute OFF
	 data_out[255:240] <= 16'b1111_1000_0000_0000;
	 data_out[239:220] <= 20'b0001_1100_0000_0000_0000;
	 data_out[219:200] <= 20'b0000_0000_0000_0000_0000;
	 data_out[199:160] <= {40{1'b0}};
	 data_out[159:0] <= {160{1'b0}};
	 audio_state <= 4'b0101;
	 
	 // Setting by Button (edit as you like!) 
      end else if ( btn_n ) begin
	 data_out[199:180] <= eval_data_out_l;
	 data_out[179:160] <= eval_data_out_r;
      end else if ( btn_w ) begin
	 data_out[199:180] <= {20{1'b0}};
	 data_out[179:160] <= {20{1'b0}};
      end else if ( btn_c ) begin
	 data_out[199:180] <= {20{1'b0}};
	 data_out[179:160] <= {20{1'b0}};
      end else if ( btn_e ) begin
	 data_out[199:180] <= {4'b0000, eval_data_out_l[19:4]};
	 data_out[179:160] <= {4'b0000, eval_data_out_r[19:4]};
      end else if ( btn_s ) begin
	 data_out[199:180] <= {eval_data_out_r[19:4], 4'b0000};
	 data_out[179:160] <= {eval_data_out_r[19:4], 4'b0000};
	 
	 // Data Output
      end else begin
	 data_out[255:240] <= 16'b1001_1000_0000_0000;
	 data_out[239:220] <= 20'b0000_0000_0000_0000_0000;
	 data_out[219:200] <= 20'b0000_0000_0000_0000_0000;
	 data_out[199:180] <= eval_data_out_l;
	 data_out[179:160] <= eval_data_out_r;
	 data_out[159:0] <= {160{1'b0}};
      end
   end

endmodule

// main
module eval(n_rst, clk, data_in_l, data_in_r, data_out_l, data_out_r);
   
   input	 n_rst, clk;
   input [19:0]  data_in_l;
   input [19:0]  data_in_r;
   output [19:0] data_out_l;
   output [19:0] data_out_r;
	
   assign data_out_l = data_in_l;
   assign data_out_r = data_in_r;
   
endmodule
