onerror {quit -f}
vlib work
vlog -work work fsm_mealy.vo
vlog -work work fsm_mealy.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.FSM_MEALY_2_vlg_vec_tst
vcd file -direction fsm_mealy.msim.vcd
vcd add -internal FSM_MEALY_2_vlg_vec_tst/*
vcd add -internal FSM_MEALY_2_vlg_vec_tst/i1/*
add wave /*
run -all
