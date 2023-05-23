onerror {quit -f}
vlib work
vlog -work work Semaforo.vo
vlog -work work Semaforo.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.CONVERSOR_1KHZ_vlg_vec_tst
vcd file -direction Semaforo.msim.vcd
vcd add -internal CONVERSOR_1KHZ_vlg_vec_tst/*
vcd add -internal CONVERSOR_1KHZ_vlg_vec_tst/i1/*
add wave /*
run -all
