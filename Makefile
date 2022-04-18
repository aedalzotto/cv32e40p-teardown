# Constants
BANNER=*******************************************************************************************

# Variables
WAVES	?= 0
TEST	?= hello-world

TB_DIR		= testbench
SOFT_DIR	= software

sim: $(TB_DIR)/testbench $(SOFT_DIR)/$(TEST)/$(TEST).hex
	@echo "$(BANNER)"
	@echo "* Running with Verilator: logfile in $(TEST).log"
	@echo "$(BANNER)"
	@$(TB_DIR)/testbench \
		"+firmware=$(SOFT_DIR)/$(TEST).hex" \
		| tee $(TEST).log

$(TB_DIR)/testbench:
	@$(MAKE) -C $(TB_DIR)

$(SOFT_DIR)/$(TEST)/$(TEST).hex:
	@$(MAKE) -C $(SOFT_DIR)

clean: clean-testbench clean-software
	@$(RM) *.vcd
	@$(RM) *.bin
	@$(RM) *.log

clean-software:
	@$(MAKE) clean -C $(SOFT_DIR)

clean-testbench:
	@$(MAKE) clean -C $(TB_DIR)


.PHONY: clean clean-software clean-testbench
