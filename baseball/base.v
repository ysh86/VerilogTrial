`default_nettype none

`define NO_RUNNER 3'd0
`define RUNNER1   3'd1
`define RUNNER12  3'd2
`define RUNNER13  3'd3
`define RUNNER123 3'd4
`define RUNNER2   3'd5
`define RUNNER23  3'd6
`define RUNNER3   3'd7

module base(
	input wire clk,
	input wire reset_n,
	input wire [3:0] hit, // hit1,hit2,hit3,hit4
	output reg [2:0] base
);

	reg [2:0] sreg;
	wire [2:0] next_sreg;
	wire next_base1, next_base2, next_base3;

	always @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			sreg <= `NO_RUNNER;
			base <= 3'b000;
		end else begin
			sreg <= next_sreg;
			base <= {next_base1, next_base2, next_base3};
		end
	end

	function [5:0] advance(input [2:0] state, input [3:0] hit);
	begin
		case (state)
			`NO_RUNNER: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER1, 1'b1, 1'b0, 1'b0};
					end
					4'b0100: begin
						advance = {`RUNNER2, 1'b0, 1'b1, 1'b0};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					default: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
				endcase
			end
			`RUNNER1: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER12, 1'b1, 1'b1, 1'b0};
					end
					4'b0100: begin
						advance = {`RUNNER23, 1'b0, 1'b1, 1'b1};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER1, 1'b1, 1'b0, 1'b0};
					end
				endcase
			end
			`RUNNER12: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER123, 1'b1, 1'b1, 1'b1};
					end
					4'b0100: begin
						advance = {`RUNNER23, 1'b0, 1'b1, 1'b1};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER12, 1'b1, 1'b1, 1'b0};
					end
				endcase
			end
			`RUNNER13: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER12, 1'b1, 1'b1, 1'b0};
					end
					4'b0100: begin
						advance = {`RUNNER23, 1'b0, 1'b1, 1'b1};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER13, 1'b1, 1'b0, 1'b1};
					end
				endcase
			end
			`RUNNER123: begin
				case (hit)
					4'b0100: begin
						advance = {`RUNNER23, 1'b0, 1'b1, 1'b1};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER123, 1'b1, 1'b1, 1'b1};
					end
				endcase
			end
			`RUNNER2: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER13, 1'b1, 1'b0, 1'b1};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER2, 1'b0, 1'b1, 1'b0};
					end
				endcase
			end
			`RUNNER23: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER13, 1'b1, 1'b0, 1'b1};
					end
					4'b0100: begin
						advance = {`RUNNER2, 1'b0, 1'b1, 1'b0};
					end
					4'b0010: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER23, 1'b0, 1'b1, 1'b1};
					end
				endcase
			end
			`RUNNER3: begin
				case (hit)
					4'b1000: begin
						advance = {`RUNNER1, 1'b1, 1'b0, 1'b0};
					end
					4'b0100: begin
						advance = {`RUNNER2, 1'b0, 1'b1, 1'b0};
					end
					4'b0001: begin
						advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
					end
					default: begin
						advance = {`RUNNER3, 1'b0, 1'b0, 1'b1};
					end
				endcase
			end
			default: begin
				advance = {`NO_RUNNER, 1'b0, 1'b0, 1'b0};
			end
		endcase
	end
	endfunction

	assign {next_sreg, next_base1, next_base2, next_base3} = advance(sreg, hit);

endmodule
