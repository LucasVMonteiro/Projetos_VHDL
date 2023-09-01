library verilog;
use verilog.vl_types.all;
entity FSM_MEALY_1_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        X               : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end FSM_MEALY_1_vlg_sample_tst;
