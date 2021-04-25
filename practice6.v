`default_nettype none

`define DIV_BITS 15 // clk:33MHz div:32768 -> 1007Hz

module practice6(
	input wire clk,
	input wire sw_in_n,
	output wire [7:0] led_out
);

	reg sw_dff;
	reg sw_in_node_n;
	reg [`DIV_BITS-1:0] div_counter;
	wire div_clk;

	reg [21:0] clk_counter;
	wire clk_clk;

	reg [3:0] count_curr;


	always @(posedge clk) begin
		div_counter <= div_counter + `DIV_BITS'b1;
		clk_counter <= clk_counter + 22'b1;
	end


	// switch
	assign div_clk = div_counter[`DIV_BITS-1];

	always @(posedge div_clk) begin
		sw_in_node_n <= sw_in_n;
	end

	always @(negedge sw_in_node_n) begin
		sw_dff <= !sw_dff;
	end

	// start/stop roulette
	assign clk_clk = clk_counter[21];

	function [3:0] advance_count(input [3:0] curr);
	begin
		case (curr)
			4'b1001: advance_count = 4'b0000;
			4'b0000: advance_count = 4'b0001;
			4'b0001: advance_count = 4'b0010;
			4'b0010: advance_count = 4'b0011;
			4'b0011: advance_count = 4'b0100;
			4'b0100: advance_count = 4'b0101;
			4'b0101: advance_count = 4'b0110;
			4'b0110: advance_count = 4'b0111;
			4'b0111: advance_count = 4'b1000;
			4'b1000: advance_count = 4'b1001;
			default: advance_count = 4'b0000;
		endcase
	end
	endfunction

	always @(posedge clk_clk) begin
		if (sw_dff) begin
			count_curr <= advance_count(count_curr);
		end
	end

	// led
	function [7:0] hex7segdec(input [3:0] hex);
	begin
		case (hex)
			4'b0000: hex7segdec = 8'b00000011;
			4'b0001: hex7segdec = 8'b10011111;
			4'b0010: hex7segdec = 8'b00100101;
			4'b0011: hex7segdec = 8'b00001101;
			4'b0100: hex7segdec = 8'b10011001;
			4'b0101: hex7segdec = 8'b01001001;
			4'b0110: hex7segdec = 8'b01000001;
			4'b0111: hex7segdec = 8'b00011111;
			4'b1000: hex7segdec = 8'b00000001;
			4'b1001: hex7segdec = 8'b00001001;
			4'b1010: hex7segdec = 8'b00010001;
			4'b1011: hex7segdec = 8'b11000001;
			4'b1100: hex7segdec = 8'b11100101;
			4'b1101: hex7segdec = 8'b10000101;
			4'b1110: hex7segdec = 8'b01100001;
			4'b1111: hex7segdec = 8'b01110001;
			default: hex7segdec = 8'b10010001; // X
		endcase
	end
	endfunction

	assign led_out = hex7segdec(count_curr);

endmodule
