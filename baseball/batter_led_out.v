`default_nettype none

module batter_led_out(
	input wire [4:0] hitout, // hit1,hit2,hit3,hit4,out
	output wire [7:0] batter_led
);

	function [7:0] hit7segdec(input [4:0] hit);
	begin
		case (hit)
			5'b10000: hit7segdec = 8'b10011111; // hit1
			5'b01000: hit7segdec = 8'b00100101; // hit2
			5'b00100: hit7segdec = 8'b00001101; // hit3
			5'b00010: hit7segdec = 8'b10010001; // hit4
			5'b00001: hit7segdec = 8'b00000011; // out
			default:  hit7segdec = 8'b11111111; // none
		endcase
	end
	endfunction

	assign batter_led = hit7segdec(hitout);

endmodule
