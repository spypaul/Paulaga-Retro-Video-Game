`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//EksBox.v
//This is the top level module of a hierarchy design
//This is module for the video game that involves with controlling multiple objects
// and display on the monitor
//Shao-Peng Yang
//2/14/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module EksBox(CLK, ARST_L, SCLK, SDATA, HSYNC, VSYNC, RED, GREEN, BLUE);
input CLK, ARST_L, SCLK, SDATA;
output HSYNC, VSYNC;
output [3:0] RED, BLUE, GREEN;
wire [1:0] sync_i;
wire clkout_i;
wire [3:0] hex0_i, hex1_i;
wire [7:0] hex_i;
wire keyup_i, swdb_i;
wire [9:0] hcoord_i, vcoord_i;
wire [11:0] csel_i;

assign hex_i = {hex1_i, hex0_i}; // signal for concatenating the key board code

Sync2         U1 (.CLK(CLK), .ASYNC(SCLK), .ACLR_L(ARST_L), .SYNC(sync_i[0]));
Sync2         U2 (.CLK(CLK), .ASYNC(SDATA), .ACLR_L(ARST_L), .SYNC(sync_i[1]));
Clk25Mhz      U3 (.CLKIN(CLK), .ACLR_L(ARST_L), .CLKOUT(clkout_i));
KBDecoder     U4 (.CLK(sync_i[0]), .SDATA(sync_i[1]), .ARST_L(ARST_L), .HEX1(hex1_i), .HEX0(hex0_i), .KEYUP(keyup_i));
SwitchDB      U5 (.SW(keyup_i), .CLK(clkout_i), .ACLR_L(ARST_L), .SWDB(swdb_i));
VGAController U6 (.CLK(clkout_i), .KBCODE(hex_i), .HCOORD(hcoord_i), .VCOORD(vcoord_i), .KBSTROBE(swdb_i), .ARST_L(ARST_L), .CSEL(csel_i));
VGAEncoder    U7 (.CLK(clkout_i), .CSEL(csel_i), .ARST_L(ARST_L), .HSYNC(HSYNC), .VSYNC(VSYNC), .RED(RED), .BLUE(BLUE), .GREEN(GREEN), .HCOORD(hcoord_i),
                 .VCOORD(vcoord_i));


endmodule
