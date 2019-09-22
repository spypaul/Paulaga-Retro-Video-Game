`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//VGAControllerTestBench.v
//This is a testbench for the VGAController
//It sends a keyboard code and keystobe to the DUT
//It also sends the HCOORD and VCOORD input
//Shao-Peng Yang
//3/15/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module VGAControllerTestBench;

reg CLK; 
wire [7:0]KBCODE; 
reg KBSTROBE;
reg [9:0] HCOORD, VCOORD;
reg ARST_L; 
wire [11:0]CSEL;
VGAController DUT(.CLK(CLK), .KBCODE(KBCODE), .HCOORD(HCOORD), .VCOORD(VCOORD), .KBSTROBE(KBSTROBE), .ARST_L(ARST_L), .CSEL(CSEL)); 

// create a 25MHZ clock
initial 
begin
    CLK <= 1'b0;
end
always #20 CLK <= ~CLK;

// reset the decoder and deactivate the reset
initial
begin
    ARST_L <= 1'b0;
    #30 ARST_L <= 1'b1;
end

// this creates the kbstrobe
initial KBSTROBE <= 1'b1;
always
begin
    repeat(50) @ (posedge CLK);
    KBSTROBE <= 1'b0;
end
// this is the testvector
assign KBCODE = 8'h1D;

// This part creates the input signal for the HCOORD and VCCORD
// it simlulate the behaviours of the coordinate signal sent by VGAEncoder
initial HCOORD <=0;
initial VCOORD <=0;
always
begin
    repeat(800) @ (posedge CLK)HCOORD <= HCOORD+1;    
    if (HCOORD == 799)
        HCOORD <= 0;
end


always
begin
    repeat(800) @ (posedge HCOORD);
    VCOORD <= VCOORD +1;    
end  
endmodule
