`default_nettype none

`define DIV_BITS 15 // clk:33MHz div:32768 -> 1007Hz

module clk_div(
	input wire clk,
	output wire clk_o
);

	reg [`DIV_BITS-1:0] div_counter;

	always @(posedge clk) begin
		div_counter <= div_counter + `DIV_BITS'b1;
	end

	assign clk_o = div_counter[`DIV_BITS-1];

endmodule
