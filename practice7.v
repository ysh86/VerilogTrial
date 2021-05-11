`default_nettype none

`define DIV_BITS 15 // clk:33MHz div:32768 -> 1007Hz

module practice7(
	input wire clk,
	input wire reset_n,
	input wire sw_in_n,
	output wire [7:0] led_out0,
	output wire [7:0] led_out1,
	output wire [7:0] led_out2
);

	reg sw0, sw1, sw2;

	roulette roulette_unit0(clk, sw0, led_out0);
	roulette roulette_unit1(clk, sw1, led_out1);
	roulette roulette_unit2(clk, sw2, led_out2);

	wire sw_in;
	reg sw_in_node_n;
	reg [`DIV_BITS-1:0] div_counter;
	wire div_clk;

	// clock
	always @(posedge clk) begin
		div_counter <= div_counter + `DIV_BITS'b1;
	end
	assign div_clk = div_counter[`DIV_BITS-1];

	// switch
	always @(posedge div_clk) begin
		sw_in_node_n <= sw_in_n;
	end
	assign sw_in = !sw_in_node_n;

	// start/stop roulette
	always @(posedge clk) begin
		if (!reset_n) begin
			sw0 <= 1;
			sw1 <= 1;
			sw2 <= 1;
		end else begin
			if (sw_in) begin
				if (sw0 && sw1 && sw2) begin
					sw0 <= 0;
				end else if (!sw0 && sw1 && sw2) begin
					sw1 <= 0;
				end else if (!sw0 && !sw1 && sw2) begin
					sw2 <= 0;
				end
			end
		end
	end

endmodule
