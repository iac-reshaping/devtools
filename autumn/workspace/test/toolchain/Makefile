# Defines that these are Makefile rules and not file names to build.
.PHONY: default clean build test 

default: build tb_toolchain tb_verilator

clean: 
	@rm -rf obj_dir/ && echo "Removing obj_dir/"
	@rm -f *.vcd && echo "Removing waveforms"

build:
	@echo "======= Building ======="
	@verilator -sv -Wall --cc --build --trace --top-module mod_test --timescale 1s/1s rtl/mod_*.sv -Irtl
	@echo "==== Build complete ===="

tb_toolchain:
	@echo "==== Building Toolchain test ====="
	@mkdir -p obj_dir
	@riscv64-unknown-elf-gcc test/tb_toolchain.cpp -o obj_dir/tb_toolchain
	@file obj_dir/tb_toolchain

tb_verilator:
	@echo "==== Building Verilator test ====="
	@verilator -Wall --cc --exe --build --trace --top-module mod_test -o tb_verilator --timescale 1s/1s -Irtl test/tb_verilator.cpp rtl/*.sv
	@echo "==== Running test ====="
	@./obj_dir/tb_verilator
