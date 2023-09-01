library verilog;
use verilog.vl_types.all;
entity FSM_MEALY_2 is
    port(
        X               : in     vl_logic;
        RST             : in     vl_logic;
        CLK             : in     vl_logic;
        y               : out    vl_logic
    );
end FSM_MEALY_2;
