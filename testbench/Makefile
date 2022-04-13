
# ELIGIBLE FOR A COMMON.MK
BANNER=*******************************************************************************************

RM		= rm -f
RMDIR	= rm -rf
MAKE	= make -j`nproc`
MV		= mv

# Programs and commands
VERILATOR	 	 = verilator
VERI_FLAGS		+= -Wno-BLKANDNBLK
VERI_TRACE		?=
VERI_OBJ_DIR	 = cobj_dir
VERI_CFLAGS		+= -O2

# Our target: the simulation binary
TOP		= tb_top_verilator
TARGET	= testbench

# Files and directories
## Core
CORE					= cv32e40p
CORE_DIR				= ../$(CORE)
CORE_MANIFEST			= $(CORE_DIR)/cv32e40p_manifest.flist
export DESIGN_RTL_DIR	= $(CORE_DIR)/rtl

## Testbench
TB_SRC_DIR	= 	.
TB_PKG		= 	$(TB_SRC_DIR)/tb_riscv/include/perturbation_defines.sv
TB_SRC		=	$(TB_SRC_DIR)/$(TOP).sv \
				$(TB_SRC_DIR)/cv32e40p_tb_wrapper.sv \
				$(TB_SRC_DIR)/tb_riscv/riscv_rvalid_stall.sv \
				$(TB_SRC_DIR)/tb_riscv/riscv_gnt_stall.sv \
				$(TB_SRC_DIR)/mm_ram.sv \
				$(TB_SRC_DIR)/dp_ram.sv

VERILATED_SRC	=	$(VERI_OBJ_DIR)/V$(TOP).mk \
					$(VERI_OBJ_DIR)/V$(TOP).h \
					$(VERI_OBJ_DIR)/V$(TOP).cpp

# Options
ifneq (${WAVES}, 0)
VERI_TRACE="--trace"
VERI_CFLAGS+="-DVCD_TRACE"
endif

$(TARGET): $(VERILATED_SRC)
	@echo "$(BANNER)"
	@echo "* Compiling verilated CORE testbench and CV32E40P"
	@echo "$(BANNER)"
	@$(MAKE) -C $(VERI_OBJ_DIR) -f V$(TOP).mk >/dev/null
	@$(MV) $(VERI_OBJ_DIR)/V$(TOP) $(TARGET)

$(VERILATED_SRC): $(CORE_MANIFEST) $(CORE_DIR)/bhv/$(CORE)_core_log.sv $(TB_SRC_DIR)/$(TOP).cpp $(TB_SRC)
	@echo "$(BANNER)"
	@echo "* Verilating CORE testbench and CV32E40P"
	@echo "$(BANNER)"
	@$(VERILATOR) --cc --sv --exe \
		$(VERI_TRACE) \
		--Wno-lint --Wno-UNOPTFLAT \
		--Wno-MODDUP --top-module \
		$(TOP) $(TB_SRC) \
		-f $(CORE_MANIFEST) \
		$(CORE_DIR)/bhv/$(CORE)_core_log.sv \
		$(TB_SRC_DIR)/$(TOP).cpp --Mdir $(VERI_OBJ_DIR) \
		-CFLAGS "-std=gnu++11 $(VERI_CFLAGS)" \
		$(VERI_FLAGS)

$(CORE_MANIFEST):
	@make clone

$(CORE_DIR)/bhv/$(CORE)_core_log.sv:
	@make clone

clone:
	@echo "$(BANNER)"
	@echo "* Initializing and updating core submodule"
	@echo "$(BANNER)"
	@git submodule init
	@git submodule update

clean:
	@echo "$(BANNER)"
	@echo "* Cleaning up testbench"
	@echo "$(BANNER)"
	@$(RMDIR) $(VERI_OBJ_DIR)
	@$(RM) $(TARGET)

.PHONY: clean clone
