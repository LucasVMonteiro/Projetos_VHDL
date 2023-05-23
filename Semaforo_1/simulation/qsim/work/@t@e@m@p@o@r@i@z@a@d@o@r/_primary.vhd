library verilog;
use verilog.vl_types.all;
entity TEMPORIZADOR is
    port(
        CLK_I           : in     vl_logic;
        TEMPO           : in     vl_logic_vector(4 downto 0);
        N_BITS          : in     vl_logic_vector(4 downto 0);
        CHIP_SELECT     : in     vl_logic;
        SINAL_FINAL     : out    vl_logic;
        CLK_O           : out    vl_logic
    );
end TEMPORIZADOR;
