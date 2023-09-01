library verilog;
use verilog.vl_types.all;
entity COUNTER_MOD5_V2_vlg_check_tst is
    port(
        QOUT            : in     vl_logic_vector(2 downto 0);
        sampler_rx      : in     vl_logic
    );
end COUNTER_MOD5_V2_vlg_check_tst;
