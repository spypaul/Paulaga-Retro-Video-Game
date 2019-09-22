`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Sync2.v
//This is a serial in serial out left-shifting shift register
//This allow us to use key board input signals directly 
//without having to worry about metastability or signal timing
//Shao-Peng Yang
//2/14/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module Sync2(CLK, ASYNC, ACLR_L, SYNC);
input CLK, ASYNC, ACLR_L;
output SYNC;
wire aclr_i; // active high internal signal for asynchronous clear
reg [1:0]shiftreg_i; 

assign aclr_i = ~ACLR_L;
assign SYNC = shiftreg_i[1]; // assign the serial output from the shift reg to the output

//creating a left-shifting shift register 
always @(posedge CLK, negedge aclr_i)
begin
    if(aclr_i == 1'b1)
        shiftreg_i <= 2'b00;
    else
        shiftreg_i <= {shiftreg_i[0], ASYNC};
end
endmodule
