library verilog;
use verilog.vl_types.all;
entity COUNTER_MOD5_V1 is
    port(
        R               : in     vl_logic;
        CLK             : in     vl_logic;
        QOUT            : out    vl_logic_vector(2 downto 0)
    );
end COUNTER_MOD5_V1;
