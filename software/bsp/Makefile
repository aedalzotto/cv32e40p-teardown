# Constants
BANNER=*******************************************************************************************

RISCV_PREFIX	= riscv32-corev-elf
RISCV_MARCH		= rv32imc
RISCV_CC		= $(RISCV_PREFIX)-gcc
RISCV_AR		= $(RISCV_PREFIX)-ar

SRC = crt0.S handlers.S syscalls.c vectors.S
OBJ = crt0.o handlers.o syscalls.o vectors.o
LIBCV-VERIF = libcv-verif.a 
CFLAGS ?= -Os -g -static -mabi=ilp32 -march=rv32imc -Wall -pedantic

$(LIBCV-VERIF): $(OBJ)
	@echo "* Linking the BSP"
	@$(RISCV_AR) rcs $@ $(OBJ)

%.o : %.c
	@echo "* Compiling $<"
	@$(RISCV_CC) $(CFLAGS) -c $< -o $@
	
%.o : %.S
	@echo "* Assemblying $<"
	@$(RISCV_CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "* Cleaning up BSP"
	@rm -f $(OBJ) $(LIBCV-VERIF)
