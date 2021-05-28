`default_nettype none

`define ONE_BASE     3'd0
`define TWO_BASE     3'd1
`define THREE_BASE   3'd2
`define HOMERUN      3'd3
`define BATTER_OUT   3'd4
`define IDLE         3'd5
`define WAIT_STOP    3'd6

module batting_pulse(
	input wire clk,
	input wire reset_n,
	input wire start,
	input wire [4:0] hitout,    // hit1,hit2,hit3,hit4,out
	output reg [3:0] hit_pulse, // hit1,hit2,hit3,hit4
	output reg out_pulse
);

	reg [2:0] sreg;
	wire [2:0] next_sreg;
	wire next_hit1_o, next_hit2_o, next_hit3_o, next_hit4_o, next_out_signal_o;

	always @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			sreg <= `IDLE;
			hit_pulse <= 4'b0000;
			out_pulse <= 1'b0;
		end else begin
			sreg <= next_sreg;
			hit_pulse <= {next_hit1_o, next_hit2_o, next_hit3_o, next_hit4_o};
			out_pulse <= next_out_signal_o;
		end
	end

	function [7:0] pulse(input [2:0] state, input start, input [4:0] hitout);
	begin
		case (state)
			`ONE_BASE: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`TWO_BASE: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`THREE_BASE: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`HOMERUN: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`BATTER_OUT: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			end
			`IDLE: begin
				if (start) begin
					pulse = {`WAIT_STOP, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
				end else begin
					pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
				end
			end
			`WAIT_STOP: begin
				case ({start,hitout})
					6'b010000: begin
						pulse = {`ONE_BASE, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
					end
					6'b001000: begin
						pulse = {`TWO_BASE, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
					end
					6'b000100: begin
						pulse = {`THREE_BASE, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
					end
					6'b000010: begin
						pulse = {`HOMERUN, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
					end
					6'b000001: begin
						pulse = {`BATTER_OUT, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
					end
					default: begin
						pulse = {`WAIT_STOP, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
					end
				endcase
			end
			default: begin
				pulse = {`IDLE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
			end
		endcase
	end
	endfunction

	assign {next_sreg, next_hit1_o, next_hit2_o, next_hit3_o, next_hit4_o, next_out_signal_o} = pulse(sreg, start, hitout);

endmodule
