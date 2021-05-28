`default_nettype none

module baseball_led_out(
	input wire clk,
	input wire reset_n,
	input reg team,
	input wire [2:0] base,
	input wire [3:0] add_to_score,
	output wire team0_led, team1_led,
	output wire base1_led, base2_led, base3_led,
	output wire [7:0] score0_led, score1_led
);

	function [3:0] score_enc(input [3:0] wires);
	begin
		case (wires)
			4'b0001: score_enc = 4'b0001;
			4'b0010: score_enc = 4'b0010;
			4'b0100: score_enc = 4'b0011;
			4'b1000: score_enc = 4'b0100;
			default: score_enc = 4'b0000;
		endcase
	end
	endfunction

	// score adder
	reg [3:0] score0, score1;
	always @(posedge clk, negedge reset_n) begin
		if (!reset_n) begin
			score0 <= 0;
			score1 <= 0;
		end else begin
			if ((add_to_score[0] || add_to_score[1] || add_to_score[2] || add_to_score[3]) && !team) begin
				score0 <= score0 + score_enc(add_to_score);
			end
			if ((add_to_score[0] || add_to_score[1] || add_to_score[2] || add_to_score[3]) && team) begin
				score1 <= score1 + score_enc(add_to_score);
			end
		end
	end


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

	// display
	assign team0_led = team;
	assign team1_led = !team;
	assign base1_led = !base[2];
	assign base2_led = !base[1];
	assign base3_led = !base[0];
	assign score0_led = hex7segdec(score0);
	assign score1_led = hex7segdec(score1);

endmodule
