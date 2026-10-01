# -- Compiler and directory variables --
# Compilers
IV = iverilog
VP = vvp
GTK = gtkwave

# Flags, important for compiling system verilog
FIV = -g2012

# Directories
vvpdir = vvps
wavedir = waves

# -- Source declare --
# Verilog source files
ss_dir = seven_segments

mod_ss_d0 = ss_dec.sv ss_dec_handler_0.sv clock_divider.sv
src_ss_d0 = $(mod_ss_d0) ss_dec_test0.sv
v_ss_d0 = $(patsubst %, $(ss_dir)/%, $(src_ss_d0))

# .vvp requirements
vvp_ss_d0 = $(vvpdir)/ss_dec0.vvp
$(vvp_ss_d0): $(v_ss_d0)

# --- Targets ---
.PNONY: clean ss_d0

ss_d0: ss_d0_com ss_d0_sim
ss_d0_com: $(vvp_ss_d0)
ss_d0_sim: run-ss_dec0

# -- Universal make logic --
# Compile pattern rule
$(vvpdir)/%.vvp: | $(vvpdir)
	@echo "==> Compiling $@"
	$(IV) $(FIV) -o $@ $^

# Simulation
run-%: $(vvpdir)/%.vvp | $(wavedir)
	@echo "==> Simulating $<"
	$(VP) $<

# Directories
$(vvpdir) $(wavedir):
	mkdir -p $@

# -- Clean --
clean:
	rm -rf $(vvpdir) $(wavedir)
