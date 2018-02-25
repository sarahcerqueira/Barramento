
module unsaved (
	botao_export,
	clk_clk,
	leds_export,
	reset_reset_n,
	switches_export,
	uart_rxd,
	uart_txd);	

	input		botao_export;
	input		clk_clk;
	output	[7:0]	leds_export;
	input		reset_reset_n;
	input	[3:0]	switches_export;
	input		uart_rxd;
	output		uart_txd;
endmodule
