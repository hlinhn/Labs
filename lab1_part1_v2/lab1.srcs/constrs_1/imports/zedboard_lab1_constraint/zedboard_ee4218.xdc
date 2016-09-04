## Constraint file for ZedBoard

###########################################
# Global Clock, which is 100MHz
###########################################
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33    [get_ports clk]
###########################################
# Buttons
###########################################
#Center
set_property PACKAGE_PIN P16 [get_ports raw_press_button_count]
 set_property IOSTANDARD LVCMOS18    [get_ports raw_press_button_count]
#Down
set_property PACKAGE_PIN R16 [get_ports raw_press_button_load]
 set_property IOSTANDARD LVCMOS18 [get_ports raw_press_button_load]
#Left
set_property PACKAGE_PIN N15 [get_ports raw_press_button_mode]
 set_property IOSTANDARD LVCMOS18 [get_ports raw_press_button_mode]
#Right
set_property PACKAGE_PIN R18 [get_ports raw_press_button_tick]
 set_property IOSTANDARD LVCMOS18 [get_ports raw_press_button_tick]
#Up
##set_property PACKAGE_PIN T18 [get_ports {BTNU}]
 ##set_property IOSTANDARD LVCMOS18 [get_ports {BTNU}]

###########################################
# LEDs
###########################################
set_property PACKAGE_PIN T22 [get_ports count[3]]
set_property IOSTANDARD LVCMOS33 [get_ports count[3]]
set_property PACKAGE_PIN T21 [get_ports count[2]]
set_property IOSTANDARD LVCMOS33 [get_ports count[2]]
set_property PACKAGE_PIN U22 [get_ports count[1]]
set_property IOSTANDARD LVCMOS33 [get_ports count[1]]
set_property PACKAGE_PIN U21 [get_ports count[0]]
set_property IOSTANDARD LVCMOS33 [get_ports count[0]]
#set_property PACKAGE_PIN V22 [get_ports {LD4}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LD4}]
#set_property PACKAGE_PIN W22 [get_ports {LD5}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LD5}]
#set_property PACKAGE_PIN U19 [get_ports {LD6}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LD6}]
#set_property PACKAGE_PIN U14 [get_ports {LD7}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LD7}]


###########################################
# DIP Switches
###########################################
set_property PACKAGE_PIN F22 [get_ports {dips[0]}]
set_property IOSTANDARD LVCMOS18    [get_ports {dips[0]}]
set_property PACKAGE_PIN G22 [get_ports {dips[1]}]
set_property IOSTANDARD LVCMOS18    [get_ports {dips[1]}]
set_property PACKAGE_PIN H22 [get_ports dips[2]]
set_property IOSTANDARD LVCMOS18    [get_ports {dips[2]}]
set_property PACKAGE_PIN F21 [get_ports {dips[3]}]
set_property IOSTANDARD LVCMOS18    [get_ports {dips[3]}]
#set_property PACKAGE_PIN H19 [get_ports {SW4}]
#set_property IOSTANDARD LVCMOS18    [get_ports {SW5}]
#set_property PACKAGE_PIN H18 [get_ports {SW5}]
#set_property IOSTANDARD LVCMOS18    [get_ports {SW6}]
#set_property PACKAGE_PIN H17 [get_ports {SW6}]
#set_property IOSTANDARD LVCMOS18    [get_ports {SW7}]
#set_property PACKAGE_PIN M15 [get_ports {SW7}]
#set_property IOSTANDARD LVCMOS18    [get_ports {SW8}]
