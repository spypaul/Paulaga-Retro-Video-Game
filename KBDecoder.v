`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//ENCount.v
//This is the Key Board decoder module for the reader 
//This is created by a right-shifting shift register 
//Once the decoder gets the key up code
//it will output the break code that is sent after the key up code
//Shao-Peng Yang
//2/7/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module KBDecoder(CLK, SDATA, ARST_L, HEX0, HEX1, KEYUP);
input CLK, SDATA, ARST_L;
output  reg KEYUP;
output reg [3:0] HEX0, HEX1;

wire arst_i;
assign arst_i = ~ARST_L; // creating a active high asynchronous reset 
reg [21:0] shiftreg_i; // internal signals of the shift register

// creating a serial in parallel out right-shifting shift register 
//triggering negedge of the clock sent by the key board
always@(negedge CLK, posedge arst_i)
begin
    if (arst_i == 1'b1)
        shiftreg_i <= 0;
    else 
        shiftreg_i <= {SDATA, shiftreg_i[21:1]};
end

// this block triggers the key up code and output the break code and a 1 to KEYUP
// after the keyup and break code is sent, 
//the last posedge allow the block to output the break code and the keyup value  
always@ (posedge CLK)
begin
    if (shiftreg_i[8:1] == 8'b 11110000)
    begin
       HEX0 <= shiftreg_i[15:12];
       HEX1 <= shiftreg_i[19:16];
       KEYUP <= 1'b1;
    end
    else
       KEYUP <= 1'b0;
end

endmodule
