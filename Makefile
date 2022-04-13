# Constants
BANNER=*******************************************************************************************

# Variables
WAVES	?= 0

# Programs
MAKE			= make >/dev/null || make
RISCV_PREFIX	= riscv32-corev-elf
RISCV_MARCH		= rv32imc
RISCV_CC		= $(RISCV_PREFIX)-gcc

ASM				= tests/asm


BSP	= bsp

TBSRC_DIR	:= tb
TBSRC		:=	$(TBSRC_DIR)/tb_top_verilator.sv \
				$(TBSRC_DIR)/cv32e40p_tb_wrapper.sv \
				$(TBSRC_DIR)/tb_riscv/riscv_rvalid_stall.sv \
				$(TBSRC_DIR)/tb_riscv/riscv_gnt_stall.sv \
				$(TBSRC_DIR)/mm_ram.sv \
				$(TBSRC_DIR)/dp_ram.sv

TBSRC_PKG   :=	$(TBSRC_DIR)/tb_riscv/include/perturbation_defines.sv

TEST         ?= hello-world
TEST_DIR=tests/programs/$(TEST)

TEST_PROGRAM_PATH    = tests/programs

RUN_INDEX               ?= 0

SIM_DIR					= sim
SIM_RESULTS				= simulation_results
SIM_TEST_RESULTS		= $(SIM_RESULTS)/$(TEST)
SIM_RUN_RESULTS			= $(SIM_TEST_RESULTS)/$(RUN_INDEX)
SIM_BSP_RESULTS			= $(SIM_TEST_PROGRAM_RESULTS)/bsp

VERILATOR           = verilator
VERI_COMPILE_FLAGS += -Wno-BLKANDNBLK
VERI_TRACE         ?=
VERI_OBJ_DIR       ?= cobj_dir
VERI_LOG_DIR       ?= $(SIM_DIR)
VERI_CFLAGS        += -O2

ifneq (${WAVES}, 0)
VERI_TRACE="--trace"
VERI_CFLAGS+="-DVCD_TRACE"
endif

SIM_RESULTS              = simulation_results
SIM_TEST_RESULTS         = $(SIM_RESULTS)/$(TEST)

# corev-dv tests needs an added run_index_suffix, blank for other tests
ifeq ($(shell echo $(TEST) | head -c 6),corev_)
export OPT_RUN_INDEX_SUFFIX=_$(RUN_INDEX)
endif

# Single rule for compiling test source into an ELF file
# For directed tests, TEST_FILES gathers all of the .S and .c files in a test directory
TEST_FILES        = $(filter %.c %.S,$(wildcard  $(TEST_DIR)/*))

# Optionally use linker script provided in test directory
# this must be evaluated at access time, so ifeq/ifneq does
# not get parsed correctly
TEST_RESULTS_LD = $(addprefix $(SIM_TEST_PROGRAM_RESULTS)/, link.ld)
TEST_LD         = $(addprefix $(TEST_TEST_DIR)/, link.ld)

LD_FILE 	= $(BSP)/link.ld
LD_LIBRARY	= -L $(BSP)

CORE_TEST_DIR                        = tests/programs
RISCV_TESTS                          = $(CORE_TEST_DIR)/riscv_tests
RISCV_COMPLIANCE_TESTS               = $(CORE_TEST_DIR)/riscv_compliance_tests
FIRMWARE                             = $(CORE_TEST_DIR)/firmware
FIRMWARE_OBJS            = $(addprefix $(FIRMWARE)/, \
                             start.o print.o sieve.o multest.o stats.o)
FIRMWARE_TEST_OBJS       = $(addsuffix .o, \
                             $(basename $(wildcard $(RISCV_TESTS)/rv32ui/*.S)) \
                             $(basename $(wildcard $(RISCV_TESTS)/rv32um/*.S)) \
                             $(basename $(wildcard $(RISCV_TESTS)/rv32uc/*.S)))
COMPLIANCE_TEST_OBJS     = $(addsuffix .o, \
                             $(basename $(wildcard $(RISCV_COMPLIANCE_TESTS)/*.S)))


default: sanity-veri-run

sanity-veri-run:
	make veri-test TEST=hello-world

veri-test: $(SIM_DIR)/testbench $(TEST_PROGRAM_PATH)/$(TEST)/$(TEST).hex
	@echo "$(BANNER)"
	@echo "* Running with Verilator: logfile in $(SIM_DIR)/$(TEST).log"
	@echo "$(BANNER)"
	@$(SIM_DIR)/testbench \
		"+firmware=$(TEST_PROGRAM_PATH)/$(TEST)/$(TEST).hex" \
		| tee $(VERI_LOG_DIR)/$(TEST).log

$(SIM_DIR)/testbench: verilate
	@echo "$(BANNER)"
	@echo "* Compiling verilated CORE testbench and CV32E40P"
	@echo "$(BANNER)"
	@$(MAKE) -C $(VERI_OBJ_DIR) -f Vtb_top_verilator.mk
	@mkdir -p $(SIM_DIR)
	@mv $(VERI_OBJ_DIR)/Vtb_top_verilator $(SIM_DIR)/testbench

verilate: core $(TBSRC) $(TBSRC_PKG)
	@echo "$(BANNER)"
	@echo "* Verilating CORE testbench and CV32E40P"
	@echo "$(BANNER)"
	@$(VERILATOR) --cc --sv --exe \
		$(VERI_TRACE) \
		--Wno-lint --Wno-UNOPTFLAT \
		--Wno-MODDUP --top-module \
		tb_top_verilator $(TBSRC) \
		-f $(CV_CORE_MANIFEST) \
		$(CV_CORE)/bhv/$(CV_CORE)_core_log.sv \
		$(TBSRC_DIR)/tb_top_verilator.cpp --Mdir $(VERI_OBJ_DIR) \
		-CFLAGS "-std=gnu++11 $(VERI_CFLAGS)" \
		$(VERI_COMPILE_FLAGS)

###############################################################################
# Rule to generate hex (loadable by simulators) from elf
#    $@ is the file being generated.
#    $< is first prerequiste.
#    $^ is all prerequistes.
#    $* is file_name (w/o extension) of target
%.hex: %.elf
	@echo "$(BANNER)"
	@echo "* Generating hexfile, readelf and objdump files"
	@echo "$(BANNER)"
	@$(RISCV_PREFIX)-objcopy -O verilog \
		$< \
		$@
	@$(RISCV_PREFIX)-readelf -a $< > $*.readelf
	@$(RISCV_PREFIX)-objdump \
		-d \
		-M no-aliases \
		-M numeric \
		-S \
		$*.elf > $*.objdump
	@$(RISCV_PREFIX)-objdump \
    	-d \
        -S \
		-M no-aliases \
		-M numeric \
        -l \
		$*.elf | bin/objdump2itb - > $*.itb

%.elf: bsp $(TEST_FILES)
	@echo "$(BANNER)"
	@echo "* Compiling test-program $@"
	@echo "$(BANNER)"
	@$(RISCV_CC) \
		-I $(ASM) \
		-I $(BSP) \
		-o $@ \
		-nostartfiles \
		$(TEST_FILES) \
		-T $(LD_FILE) \
		$(LD_LIBRARY) \
		-lcv-verif

.PHONY: bsp

bsp:
	@echo "$(BANNER)"
	@echo "* Compiling the BSP"
	@echo "$(BANNER)"
	@make -C $(BSP) \
		RISCV_PREFIX=$(RISCV_PREFIX)- \
		RISCV_EXE_PREFIX=$(RISCV_PREFIX)- \
		RISCV_MARCH=$(RISCV_MARCH) \
		RISCV_CC=$(RISCV_CC) \
		all

core:
	@echo "$(BANNER)"
	@echo "Initializing and updating core submodule"
	@echo "$(BANNER)"
	@git submodule init
	@git submodule update

clean: clean-sim-results clean-test-programs clean_testbench firmware-clean

clean-sim-results:
	rm -rf $(SIM_RESULTS)

# clean up toolchain generated files
clean-test-programs:
	find tests/programs -name *.o       -exec rm {} \;
	find tests/programs -name *.hex     -exec rm {} \;
	find tests/programs -name *.elf     -exec rm {} \;
	find tests/programs -name *.map     -exec rm {} \;
	find tests/programs -name *.readelf -exec rm {} \;
	find tests/programs -name *.objdump -exec rm {} \;
	find tests/programs -name corev_*.S -exec rm {} \;


# Should have a 'tc-clean' here
clean_testbench:
	if [ -d $(SIM_RESULTS) ]; then rm -r $(SIM_RESULTS); fi
	if [ -d $(VERI_OBJ_DIR) ]; then rm -r $(VERI_OBJ_DIR); fi
	rm -rf testbench_verilator
	if [ -e memory_dump.bin ]; then rm memory_dump.bin; fi

firmware-clean:
	rm -vrf $(addprefix $(FIRMWARE)/firmware., elf bin hex map) \
		$(FIRMWARE_OBJS) $(FIRMWARE_TEST_OBJS) $(COMPLIANCE_TEST_OBJS)
