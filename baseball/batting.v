`default_nettype none

`define ONE_BASE     4'd0
`define HOMERUN      4'd1
`define OUT0         4'd2
`define OUT1         4'd3
`define OUT2         4'd4
`define OUT3         4'd5
`define OUT4         4'd6
`define OUT5         4'd7
`define OUT6         4'd8
`define OUT7         4'd9
`define OUT8         4'd10
`define THREE_BASE   4'd11
`define TWO_BASE     4'd12

module batting(
	input wire clk,
	input wire reset_n,
	input wire active,
	output wire [4:0] hitout // hit1,hit2,hit3,hit4,out
);

	reg [3:0] sreg;
	wire next_sreg;

	always @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			sreg <= `OUT8;
		end else begin
			sreg <= next_sreg;
		end
	end

	function [8:0] hitout_roulette(input [3:0] state, input active);
	begin
		case (state)
			`ONE_BASE: begin
				if (active) begin
					hitout_roulette = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, `OUT3};
				end else begin
					hitout_roulette = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, `ONE_BASE};
				end
			end
			`HOMERUN: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `OUT2};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `HOMERUN};
				end
			end
			`OUT0: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT1};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT0};
				end
			end
			`OUT1: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `ONE_BASE};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT1};
				end
			end
			`OUT2: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT8};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT2};
				end
			end
			`OUT3: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT4};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT3};
				end
			end
			`OUT4: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT5};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT4};
				end
			end
			`OUT5: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT6};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT5};
				end
			end
			`OUT6: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT7};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT6};
				end
			end
			`OUT7: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `THREE_BASE};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT7};
				end
			end
			`OUT8: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT0};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `OUT8};
				end
			end
			`THREE_BASE: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `TWO_BASE};
				end else begin
					hitout_roulette = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `THREE_BASE};
				end
			end
			`TWO_BASE: begin
				if (active) begin
					hitout_roulette = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `HOMERUN};
				end else begin
					hitout_roulette = {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `TWO_BASE};
				end
			end
			default: begin
				hitout_roulette = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `ONE_BASE};
			end
		endcase
	end
	endfunction

	assign {hitout, next_sreg} = hitout_roulette(sreg, active);

endmodule
