# ELIGIBLE FOR A COMMON.MK
BANNER=*******************************************************************************************

RM		= rm -f
RMDIR	= rm -rf
MAKE	= make -j`nproc`
MV		= mv

# Programs and commands
RISCV_PREFIX	= riscv32-corev-elf
RISCV_MARCH		= rv32imc
RISCV_CC		= $(RISCV_PREFIX)-gcc
RISCV_AR		= $(RISCV_PREFIX)-ar

# Our target: the simulation binary
TEST		?= hello-world

# Files
ASM			= asm

BSP			= bsp
LIBCV-VERIF = $(BSP)/libcv-verif.a 
LD_FILE		= $(BSP)/link.ld
LD_LIBRARY	= -L $(BSP)

TEST_DIR	= programs/$(TEST)
TEST_SRC	= $(filter %.c %.S,$(wildcard  $(TEST_DIR)/*))
TEST_OBJ	= $(patsubst %.c %.S, %.o, $(TEST_SRC))

all: $(TEST).hex $(TEST).readelf $(TEST).objdump $(TEST).itb

%.hex: %.elf
	@echo "* Generating hexfile, readelf and objdump files"
	@$(RISCV_PREFIX)-objcopy -O verilog \
 		$< \
 		$@

%.readelf: %.elf
	@echo "* Generating readelf"
	@$(RISCV_PREFIX)-readelf -a $< > $*.readelf

%.objdump: %.elf
	@echo "* Generating objdump"
	@$(RISCV_PREFIX)-objdump \
 		-d \
 		-M no-aliases \
 		-M numeric \
 		-S \
 		$*.elf > $*.objdump

%.itb: %.elf
	@echo "* Generating itb"
	@$(RISCV_PREFIX)-objdump \
     	-d \
        -S \
 		-M no-aliases \
 		-M numeric \
         -l \
 		$*.elf | ../bin/objdump2itb - > $*.itb

%.elf: $(LIBCV-VERIF) $(TEST_OBJ)
	@echo "$(BANNER)"
	@echo "* Linking test-program $@"
	@echo "$(BANNER)"
	@$(RISCV_CC) \
		-I $(ASM) \
		-I $(BSP) \
		-o $@ \
		-nostartfiles \
		$(TEST_OBJ) \
		-T $(LD_FILE) \
		$(LD_LIBRARY) \
		-lcv-verif

%.o : %.c
	@echo "* Compiling $<"
	@$(RISCV_CC) -c $< -o $@
	
%.o : %.S
	@echo "* Assemblying $<"
	@$(RISCV_CC) -c $< -o $@

$(LIBCV-VERIF):
	@$(MAKE) -s -C $(BSP)

clean:
	@$(RM) $(TEST).elf
	@$(RM) $(TEST).hex
	@$(RM) $(TEST).itb
	@$(RM) $(TEST).objdump
	@$(RM) $(TEST).readelf

.PHONY: bsp clean
