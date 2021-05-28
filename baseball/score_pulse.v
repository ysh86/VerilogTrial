`default_nettype none

`define ADD_ONE   3'd0
`define ADD_TWO   3'd1
`define ADD_THREE 3'd2
`define ADD_FOUR  3'd3
`define IDLE      3'd4

module score_pulse(
	input wire clk,
	input wire reset_n,
	input wire [6:0] basehit, // base1,base2,base3,hit1,hit2,hit3,hit4
	output reg [3:0] add_to_score
);

	reg [2:0] sreg;
	wire [2:0] next_sreg;
	wire next_add_to_score1, next_add_to_score2, next_add_to_score3, next_add_to_score4;

	always @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			sreg <= `IDLE;
			add_to_score <= 4'b0000;
		end else begin
			sreg <= next_sreg;
			add_to_score <= {next_add_to_score4, next_add_to_score3, next_add_to_score2, next_add_to_score1};
		end
	end

	function [6:0] pulse(input [2:0] state, input [6:0] basehit);
	begin
		case (state)
			`ADD_ONE: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`ADD_TWO: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`ADD_THREE: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`ADD_FOUR: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`IDLE: begin
				casex (basehit)
					7'bxx1_1000,
					7'bx10_0100,
					7'bx01_0100,
					7'b100_0010,
					7'b010_0010,
					7'b001_0010,
					7'b000_0001: begin
						pulse = {`ADD_ONE, 1'b1, 1'b0, 1'b0, 1'b0};
					end
					7'bx11_0100,
					7'b110_0010,
					7'b101_0010,
					7'b011_0010,
					7'b100_0001,
					7'b010_0001,
					7'b001_0001: begin
						pulse = {`ADD_TWO, 1'b0, 1'b1, 1'b0, 1'b0};
					end
					7'b111_0010,
					7'b110_0001,
					7'b101_0001,
					7'b011_0001: begin
						pulse = {`ADD_THREE, 1'b0, 1'b0, 1'b1, 1'b0};
					end
					7'b111_0001: begin
						pulse = {`ADD_FOUR, 1'b0, 1'b0, 1'b0, 1'b1};
					end
					default: begin
						pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0};
					end
				endcase
			end
			default: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0};
			end
		endcase
	end
	endfunction

	assign {next_sreg, next_add_to_score1, next_add_to_score2, next_add_to_score3, next_add_to_score4} = pulse(sreg, basehit);

endmodule
