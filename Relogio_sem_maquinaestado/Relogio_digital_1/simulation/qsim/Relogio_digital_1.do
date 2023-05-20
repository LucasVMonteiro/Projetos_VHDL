onerror {quit -f}
vlib work
vlog -work work Relogio_digital_1.vo
vlog -work work Relogio_digital_1.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.BLOCO_CONTADOR23_vlg_vec_tst
vcd file -direction Relogio_digital_1.msim.vcd
vcd add -internal BLOCO_CONTADOR23_vlg_vec_tst/*
vcd add -internal BLOCO_CONTADOR23_vlg_vec_tst/i1/*
add wave /*
run -all
