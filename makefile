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
util_dir = utils

ss_dir = seven_segments

mod_ss_d0 = ss_dec.sv ss_dec_handler_0.sv clock_divider.sv one_pulse.sv
src_ss_d0 = $(mod_ss_d0) ss_dec_test0.sv
v_ss_d0 = $(patsubst %, $(ss_dir)/%, $(src_ss_d0))

mod_ss_ex0 = ss_ex_mod0.sv switch_reader.sv timer.sv $(mod_ss_d0)
src_ss_ex0 = $(mod_ss_ex0)
v_ss_ex0 = $(patsubst %, $(ss_dir)/%, $(src_ss_ex0))

pb_dir = push_buttons

mod_pb_dbc = double_click.sv
vmod_pb_dbc = $(patsubst %, $(pb_dir)/%, $(mod_pb_dbc))
util_pb_dbc = timer.sv
vutil_pb_dbc = $(patsubst %, $(util_dir)/%, $(util_pb_dbc))
vpb_dbc = $(vmod_pb_dbc) $(vutil_pb_dbc)

mod_pb_dbc_ex0 = double_click_ex0.sv
vmod_pb_dbc_ex0 = $(patsubst %, $(pb_dir)/%, $(mod_pb_dbc_ex0))
util_pb_dbc_ex0 = debounce.sv one_pulse.sv
vutil_pb_dbc_ex0 = $(patsubst %, $(util_dir)/%, $(util_pb_dbc_ex0))
ss_mod = ss_dec_handler_0.sv ss_dec.sv clock_divider.sv
vss_mod = $(patsubst %, $(ss_dir)/%, $(ss_mod))
vpb_dbc_ex0 = $(vmod_pb_dbc_ex0) $(vutil_pb_dbc_ex0) $(vpb_dbc) $(vss_mod)

# .vvp requirements
vvp_ss_d0 = $(vvpdir)/ss_dec0.vvp
$(vvp_ss_d0): $(v_ss_d0)

vvp_ss_ex0 = $(vvpdir)/ss_ex0.vvp
$(vvp_ss_ex0): $(v_ss_ex0)

vvp_pb_dbc = $(vvpdir)/pb_dbc.vvp
$(vvp_pb_dbc): $(vpb_dbc)

vvp_pb_dbc_ex0 = $(vvpdir)/pb_dbc_ex0.vvp
$(vvp_pb_dbc_ex0): $(vpb_dbc_ex0)

# --- Targets ---
.PNONY: clean ss_d0 ss_ex0 pb_dbc pb_dbc_ex0

ss_d0: ss_d0_com ss_d0_sim
ss_d0_com: $(vvp_ss_d0)
ss_d0_sim: run-ss_dec0

ss_ex0: ss_ex0_com ss_ex0_sim
ss_ex0_com: $(vvp_ss_ex0)
ss_ex0_sim: run-ss_ex0

pb_dbc: pb_dbc_com pb_dbc_sim
pb_dbc_com: $(vvp_pb_dbc)
pb_dbc_sim: run-pb_dbc

pb_dbc_ex0: pb_dbc_ex0_com pb_dbc_ex0_sim
pb_dbc_ex0_com: $(vvp_pb_dbc_ex0)
pb_dbc_ex0_sim: run-pb_dbc_ex0

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
