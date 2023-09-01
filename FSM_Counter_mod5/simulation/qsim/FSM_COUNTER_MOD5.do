onerror {quit -f}
vlib work
vlog -work work FSM_COUNTER_MOD5.vo
vlog -work work FSM_COUNTER_MOD5.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.COUNTER_MOD5_V2_vlg_vec_tst
vcd file -direction FSM_COUNTER_MOD5.msim.vcd
vcd add -internal COUNTER_MOD5_V2_vlg_vec_tst/*
vcd add -internal COUNTER_MOD5_V2_vlg_vec_tst/i1/*
add wave /*
run -all
