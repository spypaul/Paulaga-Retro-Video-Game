`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Clk25Mhz.v
//This is a module for a clock divider 
//It divides the frequency of the input clock by 4 
//Since the clock input will be 100Mhz, it slows the clock down to 25Mhz
//Shao-Peng Yang
//2/28/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module Clk25Mhz(CLKIN, ACLR_L, CLKOUT);
input CLKIN, ACLR_L;
output reg CLKOUT;
reg cnt; // Internal counter signal

// Making the active low reset to active high internally
wire aclr_i;
assign aclr_i = ~ACLR_L;

// The counter rolls over when it reaches 1
// It dIvides the clock by 2
always @ (posedge CLKIN, posedge aclr_i)
begin
    if (aclr_i == 1'b1)
        cnt <= 1'b0;
    else if (cnt == 1'b1)
        cnt <= 1'b0;
    else
        cnt <= cnt+1;     
end
// The clock is further divided by two thru the TFF with enable
// This also makes the duty cycle of the clock stays at 50%
always @ (posedge CLKIN, posedge aclr_i)
begin 
    if (aclr_i == 1'b1)
       CLKOUT <= 1'b0;
    else if (cnt == 1'b1)
       CLKOUT <= ~CLKOUT;
end

endmodule

