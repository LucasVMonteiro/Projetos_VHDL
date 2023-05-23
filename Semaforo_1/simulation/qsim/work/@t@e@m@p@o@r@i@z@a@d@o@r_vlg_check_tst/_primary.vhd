library verilog;
use verilog.vl_types.all;
entity TEMPORIZADOR_vlg_check_tst is
    port(
        CLK_O           : in     vl_logic;
        RAZ             : in     vl_logic_vector(31 downto 0);
        SINAL_FINAL     : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end TEMPORIZADOR_vlg_check_tst;
