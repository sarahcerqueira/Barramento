	component unsaved is
		port (
			botao_export    : in  std_logic                    := 'X';             -- export
			clk_clk         : in  std_logic                    := 'X';             -- clk
			leds_export     : out std_logic_vector(7 downto 0);                    -- export
			reset_reset_n   : in  std_logic                    := 'X';             -- reset_n
			switches_export : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			uart_rxd        : in  std_logic                    := 'X';             -- rxd
			uart_txd        : out std_logic                                        -- txd
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			botao_export    => CONNECTED_TO_botao_export,    --    botao.export
			clk_clk         => CONNECTED_TO_clk_clk,         --      clk.clk
			leds_export     => CONNECTED_TO_leds_export,     --     leds.export
			reset_reset_n   => CONNECTED_TO_reset_reset_n,   --    reset.reset_n
			switches_export => CONNECTED_TO_switches_export, -- switches.export
			uart_rxd        => CONNECTED_TO_uart_rxd,        --     uart.rxd
			uart_txd        => CONNECTED_TO_uart_txd         --         .txd
		);

