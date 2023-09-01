library verilog;
use verilog.vl_types.all;
entity COUNTER_MOD5_V2_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        R               : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end COUNTER_MOD5_V2_vlg_sample_tst;
