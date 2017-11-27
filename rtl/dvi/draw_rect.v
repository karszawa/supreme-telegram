`timescale 1ns/1ps

module draw_rect (
		input					clk,
		input					rst_n,

		input					i_pls_c,
		input					i_pls_e,
		input					i_pls_w,
		input					i_pls_s,
		input					i_pls_n,
		input					i_mouse_valid	,
		input	[12-1: 0]		i_rect_pos_x	,// current mouse position
		input	[12-1: 0]		i_rect_pos_y	,
		input	[ 9-1: 0]		i_mouse_dif_x	,// [8] sign
		input	[ 9-1: 0]		i_mouse_dif_y	,// incremental mouse position

		input					i_sync_vs,
		input					i_sync_hs,
		input					i_sync_va,
		input					i_sync_ha,
		input					i_sync_de,

		output	reg				o_sync_vs,
		output	reg				o_sync_hs,
		output	reg				o_sync_va,
		output	reg				o_sync_ha,
		output	reg				o_sync_de,
		output	reg	[ 8-1: 0]	o_sync_red,
		output	reg	[ 8-1: 0]	o_sync_grn,
		output	reg	[ 8-1: 0]	o_sync_blu 
);

parameter		MAX_W			= 11'd1024;
parameter		MAX_H			= 11'd768;
parameter		RECT_W		= 11'd50;
parameter		RECT_H		= 11'd50;
parameter		STEP			= 11'd05;

// Rectagle Color
parameter		RECT_COLOR_RED	= 8'd255;
parameter		RECT_COLOR_GRN	= 8'd128;
parameter		RECT_COLOR_BLU	= 8'd128;

// Background Color
parameter		BG_COLOR_RED	= 8'd0;
parameter		BG_COLOR_GRN	= 8'd0;
parameter		BG_COLOR_BLU	= 8'd0;

reg		[11-1: 0]		r_cnt_x;
reg		[11-1: 0]		r_cnt_y;


reg		[11-1: 0]		r_pos_x;
reg		[11-1: 0]		r_pos_y;

reg								area;

reg [1025:0] board;

assign i_sync_all = i_sync_vs & i_sync_hs & i_sync_va & i_sync_ha & i_sync_de;
always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		board <= 1026'd16640;
		
		r_cnt_x	<= 11'd0;
		r_cnt_y	<= 11'd0;
	end else if (i_sync_all) begin
		if (r_cnt_x==(MAX_W-1)) begin
			r_cnt_x	<= 11'd0;
			if (r_cnt_y==(MAX_H-1)) begin
				r_cnt_y	<= 11'd0;
			end else begin
				r_cnt_y	<= r_cnt_y + 1;
			end
		end else begin
				r_cnt_x	<= r_cnt_x + 1;
		end
	end
end

wire [3:0] tmp;
assign tmp = ((r_cnt_y >> 4) * 10 + (r_cnt_x >> 4)) * 4;

// AREA
always @ (*) begin	
	if ((r_cnt_x > 320) || r_cnt_y > 640) begin
		area <= 1;
	end else if ((r_cnt_x >> 1) % 16 == 0) begin
		area <= 0;
	end else if ((r_cnt_y >> 1) % 16 == 0) begin
		area <= 0;
	end else if (board[tmp+:4] != 4'd0) begin
		area <= 1;
	end else begin
		area <= 0;
	end
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		o_sync_vs		<= 1'b0;
		o_sync_hs		<= 1'b0;
		o_sync_va		<= 1'b0;
		o_sync_ha		<= 1'b0;
		o_sync_de		<= 1'b0;
		o_sync_red	<= 8'd0;
		o_sync_grn	<= 8'd0;
		o_sync_blu	<= 8'd0;
	end else begin
		o_sync_vs		<= i_sync_vs	;
		o_sync_hs		<= i_sync_hs	;
		o_sync_va		<= i_sync_va	;
		o_sync_ha		<= i_sync_ha	;
		o_sync_de		<= i_sync_de	;
		o_sync_red	<= (area) ? RECT_COLOR_RED : BG_COLOR_RED	;
		o_sync_grn	<= (area) ? RECT_COLOR_GRN : BG_COLOR_GRN	;
		o_sync_blu	<= (area) ? RECT_COLOR_BLU : BG_COLOR_BLU	;
	end
end

endmodule
