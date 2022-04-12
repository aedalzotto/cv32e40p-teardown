BANNER=*******************************************************************************************

MAKE           = make
WAVES          = 0
RISCV            = $(CV_SW_TOOLCHAIN)
MAKE_PATH     := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CORE_V_VERIF   = $(abspath $(MAKE_PATH))

ifndef CV_SW_MARCH
ifdef  TEST_CV_SW_MARCH
CV_SW_MARCH = $(TEST_CV_SW_MARCH)
else
ifdef  CFG_CV_SW_MARCH
CV_SW_MARCH = $(CFG_CV_SW_MARCH)
else
CV_SW_MARCH = rv32imc
$(warning CV_SW_MARCH not defined in either the shell environment, test.yaml or cfg.yaml)
endif
endif
endif

ifndef CV_SW_CC
ifdef  TEST_CV_SW_CC
CV_SW_CC = $(TEST_CV_SW_CC)
else
ifdef  CFG_CV_SW_CC
CV_SW_CC = $(CFG_CV_SW_CC)
else
CV_SW_CC = gcc
$(warning CV_SW_CC not defined in either the shell environment, test.yaml or cfg.yaml)
endif
endif
endif

ifndef CV_SW_CFLAGS
ifdef  TEST_CV_SW_CFLAGS
CV_SW_CFLAGS = $(TEST_CV_SW_CFLAGS)
else
ifdef  CFG_CV_SW_CFLAGS
CV_SW_CFLAGS = $(CFG_CV_SW_CFLAGS)
else
$(warning CV_SW_CFLAGS not defined in either the shell environment, test.yaml or cfg.yaml)
endif
endif
endif

RISCV_PREFIX     = $(CV_SW_PREFIX)
RISCV_EXE_PREFIX = $(RISCV)/bin/$(RISCV_PREFIX)
RISCV_MARCH      = $(CV_SW_MARCH)
RISCV_CC         = $(CV_SW_CC)
RISCV_CFLAGS     = $(CV_SW_CFLAGS)

ASM       ?= tests/asm

CV_CORE       ?= CV32E40P
CV_CORE_LC     = $(shell echo $(CV_CORE) | tr A-Z a-z)

CV_CORE_PKG         := $(CV_CORE_LC)
CV_CORE_MANIFEST    := $(CV_CORE_PKG)/cv32e40p_manifest.flist

export DESIGN_RTL_DIR = $(CV_CORE_PKG)/rtl

BSP                 = bsp

TBSRC_HOME  := tb
TBSRC_CORE  := $(TBSRC_HOME)/core
TBSRC_VERI  := $(TBSRC_CORE)/tb_top_verilator.sv \
               $(TBSRC_CORE)/cv32e40p_tb_wrapper.sv \
               $(TBSRC_CORE)/tb_riscv/riscv_rvalid_stall.sv \
               $(TBSRC_CORE)/tb_riscv/riscv_gnt_stall.sv \
               $(TBSRC_CORE)/mm_ram.sv \
               $(TBSRC_CORE)/dp_ram.sv

TBSRC_PKG   := $(TBSRC_CORE)/tb_riscv/include/perturbation_defines.sv

# Compile compile flags for all simulators
SV_CMP_FLAGS =

TEST         ?= hello-world
TEST_NAME=hello-world
TEST_TEST_DIR=tests/programs/custom/hello-world

TEST_PROGRAM_PATH    = tests/programs/custom
TEST_PROGRAM_RELPATH = tests/programs/custom

RUN_INDEX               ?= 0

SIM_RESULTS              = simulation_results
SIM_TEST_RESULTS         = $(SIM_RESULTS)/$(TEST)
SIM_RUN_RESULTS          = $(SIM_TEST_RESULTS)/$(RUN_INDEX)
SIM_TEST_PROGRAM_RESULTS = $(SIM_RUN_RESULTS)/test_program
SIM_BSP_RESULTS          = $(SIM_TEST_PROGRAM_RESULTS)/bsp

VERILATOR           = verilator
VERI_FLAGS         +=
VERI_COMPILE_FLAGS += -Wno-BLKANDNBLK $(SV_CMP_FLAGS) # hope this doesn't hurt us in the long run
VERI_TRACE         ?=
VERI_OBJ_DIR       ?= cobj_dir
VERI_LOG_DIR       ?= $(SIM_TEST_PROGRAM_RESULTS)
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
# For corev_ tests, TEST_FILES will only point to the specific .S for the RUN_INDEX and TEST_NAME provided to make
ifeq ($(shell echo $(TEST) | head -c 6),corev_)
TEST_FILES        = $(filter %.c %.S,$(wildcard  $(SIM_TEST_PROGRAM_RESULTS)/$(TEST_NAME)$(OPT_RUN_INDEX_SUFFIX).S))
else
TEST_FILES        = $(filter %.c %.S,$(wildcard  $(TEST_TEST_DIR)/*))
endif

# If a test defines "default_cflags" in its yaml, then it is responsible to define ALL flags
# Otherwise add the default cflags in the variable CFLAGS defined above
ifneq ($(TEST_DEFAULT_CFLAGS),)
TEST_CFLAGS += $(TEST_DEFAULT_CFLAGS)
else
TEST_CFLAGS += $(CFLAGS)
endif

# Optionally use linker script provided in test directory
# this must be evaluated at access time, so ifeq/ifneq does
# not get parsed correctly
TEST_RESULTS_LD = $(addprefix $(SIM_TEST_PROGRAM_RESULTS)/, link.ld)
TEST_LD         = $(addprefix $(TEST_TEST_DIR)/, link.ld)

LD_LIBRARY 	= $(if $(wildcard $(TEST_RESULTS_LD)),-L $(SIM_TEST_PROGRAM_RESULTS),$(if $(wildcard $(TEST_LD)),-L $(TEST_TEST_DIR),))
LD_FILE 	= $(if $(wildcard $(TEST_RESULTS_LD)),$(TEST_RESULTS_LD),$(if $(wildcard $(TEST_LD)),$(TEST_LD),$(BSP)/link.ld))
LD_LIBRARY += -L $(SIM_BSP_RESULTS)

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

veri-test: testbench_verilator $(TEST_PROGRAM_PATH)/$(TEST)/$(TEST).hex
	@echo "$(BANNER)"
	@echo "* Running with Verilator: logfile in $(SIM_TEST_RESULTS)/$(TEST).log"
	@echo "$(BANNER)"
	mkdir -p $(VERI_LOG_DIR)
	$(SIM_TEST_RESULTS)/verilator_executable \
		$(VERI_FLAGS) \
		"+firmware=$(TEST_PROGRAM_RELPATH)/$(TEST)/$(TEST).hex" \
		| tee $(VERI_LOG_DIR)/$(TEST).log

testbench_verilator: core $(TBSRC_VERI) $(TBSRC_PKG)
	@echo "$(BANNER)"
	@echo "* Compiling CORE TB and CV32E40P with Verilator"
	@echo "$(BANNER)"
	$(VERILATOR) --cc --sv --exe \
		$(VERI_TRACE) \
		--Wno-lint --Wno-UNOPTFLAT \
		--Wno-MODDUP --top-module \
		tb_top_verilator $(TBSRC_VERI) \
		-f $(CV_CORE_MANIFEST) \
		$(CV_CORE_PKG)/bhv/$(CV_CORE_LC)_core_log.sv \
		$(TBSRC_CORE)/tb_top_verilator.cpp --Mdir $(VERI_OBJ_DIR) \
		-CFLAGS "-std=gnu++11 $(VERI_CFLAGS)" \
		$(VERI_COMPILE_FLAGS)
	$(MAKE) -C $(VERI_OBJ_DIR) -f Vtb_top_verilator.mk
	mkdir -p $(SIM_RESULTS)
	mkdir -p $(SIM_TEST_RESULTS)
	mv $(VERI_OBJ_DIR)/Vtb_top_verilator $(SIM_TEST_RESULTS)/verilator_executable

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
	$(RISCV_EXE_PREFIX)objcopy -O verilog \
		$< \
		$@
	$(RISCV_EXE_PREFIX)readelf -a $< > $*.readelf
	$(RISCV_EXE_PREFIX)objdump \
		-d \
		-M no-aliases \
		-M numeric \
		-S \
		$*.elf > $*.objdump
	$(RISCV_EXE_PREFIX)objdump \
    	-d \
        -S \
		-M no-aliases \
		-M numeric \
        -l \
		$*.elf | ${CORE_V_VERIF}/bin/objdump2itb - > $*.itb

ifeq ($(TEST_FIXED_ELF),1)
%.elf:
	@echo "$(BANNER)"
	@echo "* Copying fixed ELF test program to $(@)"
	@echo "$(BANNER)"
	mkdir -p $(SIM_TEST_PROGRAM_RESULTS)
	cp $(TEST_TEST_DIR)/$(TEST).elf $@
else
%.elf: $(TEST_FILES)
	mkdir -p $(SIM_TEST_PROGRAM_RESULTS)
	make bsp
	@echo "$(BANNER)"
	@echo "* Compiling test-program $@"
	@echo "$(BANNER)"
	$(RISCV_EXE_PREFIX)$(RISCV_CC) \
		$(CFG_CFLAGS) \
		$(TEST_CFLAGS) \
		$(RISCV_CFLAGS) \
		-I $(ASM) \
		-I $(BSP) \
		-o $@ \
		-nostartfiles \
		$(TEST_FILES) \
		-T $(LD_FILE) \
		$(LD_LIBRARY) \
		-lcv-verif
endif

.PHONY: bsp

bsp:
	@echo "$(BANNER)"
	@echo "* Compiling the BSP at $(SIM_BSP_RESULTS)"
	@echo "$(BANNER)"
	mkdir -p $(SIM_BSP_RESULTS)
	cp $(BSP)/Makefile $(SIM_BSP_RESULTS)
	make -C $(SIM_BSP_RESULTS) \
		VPATH=../../../../../$(BSP) \
		RISCV=$(RISCV) \
		RISCV_PREFIX=$(RISCV_PREFIX) \
		RISCV_EXE_PREFIX=$(RISCV_EXE_PREFIX) \
		RISCV_MARCH=$(RISCV_MARCH) \
		RISCV_CC=$(RISCV_CC) \
		RISCV_CFLAGS="$(RISCV_CFLAGS)" \
		all

core:
	@echo "$(BANNER)"
	@echo "Initializing and updating core submodule"
	@echo "$(BANNER)"
	@git submodule init
	@git submodule update

clean: clean-sim-results clean-test-programs verilate-clean firmware-clean

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
verilate-clean:
	if [ -d $(SIM_RESULTS) ]; then rm -r $(SIM_RESULTS); fi
	if [ -d $(VERI_OBJ_DIR) ]; then rm -r $(VERI_OBJ_DIR); fi
	rm -rf testbench_verilator
	if [ -e memory_dump.bin ]; then rm memory_dump.bin; fi

firmware-clean:
	rm -vrf $(addprefix $(FIRMWARE)/firmware., elf bin hex map) \
		$(FIRMWARE_OBJS) $(FIRMWARE_TEST_OBJS) $(COMPLIANCE_TEST_OBJS)
