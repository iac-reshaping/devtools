# Defines that these are Makefile rules and not file names to build.
.PHONY: default clean build test 

default: build test

clean: 
	@rm -rf obj_dir/ && echo "Removing obj_dir/"
	@rm -f *.vcd && echo "Removing waveforms"

build:
	@echo "======= Building ======="
	@verilator -sv -Wall --cc --build --trace --top-module mod_test --timescale 1s/1s rtl/mod_*.sv -Irtl
	@echo "==== Build complete ===="

test:
	@echo "==== Building test ====="
	@verilator -Wall --cc --exe --build --trace --top-module mod_test -o tb_test --timescale 1s/1s -Irtl test/tb_test.cpp rtl/*.sv
	@echo "==== Running test ====="
	@./obj_dir/tb_test
