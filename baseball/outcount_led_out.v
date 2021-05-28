`default_nettype none

`define NO_OUT      3'd0
`define ONE_OUT     3'd1
`define TWO_OUT     3'd2
`define THREE_OUT   3'd3
`define CHANGE_TEAM 3'd4

module outcount_led_out(
	input wire clk,
	input wire reset_n,
	input wire out_pulse,
	output wire outcount1_led, outcount2_led, outcount3_led,
	output wire change_pulse
);

	reg [2:0] sreg;
	wire [2:0] next_sreg;

	always @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			sreg <= `NO_OUT;
		end else begin
			sreg <= next_sreg;
		end
	end

	function [6:0] outchange(input [2:0] state, input out_pulse);
	begin
		case (state)
			`NO_OUT: begin
				if (out_pulse) begin
					outchange = {1'b1, 1'b1, 1'b1, 1'b0, `ONE_OUT};
				end else begin
					outchange = {1'b1, 1'b1, 1'b1, 1'b0, `NO_OUT};
				end
			end
			`ONE_OUT: begin
				if (out_pulse) begin
					outchange = {1'b0, 1'b1, 1'b1, 1'b0, `TWO_OUT};
				end else begin
					outchange = {1'b0, 1'b1, 1'b1, 1'b0, `ONE_OUT};
				end
			end
			`TWO_OUT: begin
				if (out_pulse) begin
					outchange = {1'b0, 1'b0, 1'b1, 1'b0, `THREE_OUT};
				end else begin
					outchange = {1'b0, 1'b0, 1'b1, 1'b0, `TWO_OUT};
				end
			end
			`THREE_OUT: begin
				outchange = {1'b0, 1'b0, 1'b0, 1'b1, `CHANGE_TEAM};
			end
			`CHANGE_TEAM: begin
				outchange = {1'b0, 1'b0, 1'b0, 1'b0, `NO_OUT};
			end
			default: begin
				outchange = {1'b1, 1'b1, 1'b1, 1'b0, `NO_OUT};
			end
		endcase
	end
	endfunction

	assign {outcount1_led, outcount2_led, outcount3_led, change_pulse, next_sreg} = outchange(sreg, out_pulse);

endmodule
