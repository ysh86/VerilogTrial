`default_nettype none

module practice(
	output wire [7:0] led_out
);

	wire [3:0] counter;

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

	assign counter = 4'b0010;
	assign led_out = hex7segdec(counter);

endmodule
