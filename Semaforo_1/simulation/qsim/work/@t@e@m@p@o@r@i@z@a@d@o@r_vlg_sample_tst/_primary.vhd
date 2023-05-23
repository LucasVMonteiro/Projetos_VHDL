library verilog;
use verilog.vl_types.all;
entity TEMPORIZADOR_vlg_sample_tst is
    port(
        CHIP_SELECT     : in     vl_logic;
        CLK_I           : in     vl_logic;
        N_BITS          : in     vl_logic_vector(4 downto 0);
        TEMPO           : in     vl_logic_vector(4 downto 0);
        sampler_tx      : out    vl_logic
    );
end TEMPORIZADOR_vlg_sample_tst;
