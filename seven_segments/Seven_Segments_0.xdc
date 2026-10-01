## 100 MHz clock (W5)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## --- Buttons ---
## Dots
set_property PACKAGE_PIN T18 [get_ports dot1]
set_property IOSTANDARD LVCMOS33 [get_ports dot1]
set_property PACKAGE_PIN U17 [get_ports dot2]
set_property IOSTANDARD LVCMOS33 [get_ports dot2]
set_property PACKAGE_PIN W19 [get_ports dot3]
set_property IOSTANDARD LVCMOS33 [get_ports dot3]
set_property PACKAGE_PIN T17 [get_ports dot4]
set_property IOSTANDARD LVCMOS33 [get_ports dot4]

## Reset
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## --- Switches ---
## SW15-SW12: val1
set_property PACKAGE_PIN R2 [get_ports {val1[3]}]
set_property PACKAGE_PIN T1 [get_ports {val1[2]}]
set_property PACKAGE_PIN U1 [get_ports {val1[1]}]
set_property PACKAGE_PIN W2 [get_ports {val1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {val1[*]}]

## SW11-SW8: val2
set_property PACKAGE_PIN R3 [get_ports {val2[3]}]
set_property PACKAGE_PIN T2 [get_ports {val2[2]}]
set_property PACKAGE_PIN T3 [get_ports {val2[1]}]
set_property PACKAGE_PIN V2 [get_ports {val2[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {val2[*]}]

## SW7-SW4: val3
set_property PACKAGE_PIN W13 [get_ports {val3[3]}]
set_property PACKAGE_PIN W14 [get_ports {val3[2]}]
set_property PACKAGE_PIN V15 [get_ports {val3[1]}]
set_property PACKAGE_PIN W15 [get_ports {val3[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {val3[*]}]

## SW3-SW0: val4
set_property PACKAGE_PIN W17 [get_ports {val4[3]}]
set_property PACKAGE_PIN W16 [get_ports {val4[2]}]
set_property PACKAGE_PIN V16 [get_ports {val4[1]}]
set_property PACKAGE_PIN V17 [get_ports {val4[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {val4[*]}]

## --- Seven Segments ---
## Digits: digit
set_property PACKAGE_PIN W4 [get_ports {digit[3]}]
set_property PACKAGE_PIN V4 [get_ports {digit[2]}]
set_property PACKAGE_PIN U4 [get_ports {digit[1]}]
set_property PACKAGE_PIN U2 [get_ports {digit[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[*]}]

## ABCDEFG: display
set_property PACKAGE_PIN W7 [get_ports {display[6]}]
set_property PACKAGE_PIN W6 [get_ports {display[5]}]
set_property PACKAGE_PIN U8 [get_ports {display[4]}]
set_property PACKAGE_PIN V8 [get_ports {display[3]}]
set_property PACKAGE_PIN U5 [get_ports {display[2]}]
set_property PACKAGE_PIN V5 [get_ports {display[1]}]
set_property PACKAGE_PIN U7 [get_ports {display[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {display[*]}]

## DP: dp
set_property PACKAGE_PIN V7 [get_ports dp]
set_property IOSTANDARD LVCMOS33 [get_ports dp]


## Basys3 configuration bank voltage (same as the course board)
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
