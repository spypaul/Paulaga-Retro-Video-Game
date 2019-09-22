`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//EksBoxTestBench.v
//This is a testbench for the EksBox
//It sends a keyboard code and keyboard clock to the DUT
//It also pulls the clock to high after 64 clock cycles
//Shao-Peng Yang
//3/15/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////



module EksBoxTestBench;
reg CLK, ARST_L;
reg [21:0]testvector_i;  // signal to hold the test vector
wire SDATA;
reg SCLK;
wire HSYNC, VSYNC;
wire [3:0] RED, GREEN, BLUE;
EksBox DUT(.CLK(CLK), .ARST_L(ARST_L), .SCLK(SCLK), .SDATA(SDATA), .HSYNC(HSYNC), .VSYNC(VSYNC), .RED(RED), .GREEN(GREEN), .BLUE(BLUE));

// creates 100Mhz clock signal
initial CLK <= 1'b0;
always #5CLK <= ~CLK;


// create a SCLK that would pulled hight after 64 clock cycles
initial 
begin
    SCLK <= 1'b0;
end
integer i = 0;
initial 
begin
    for(i=0; i < 63 ; i= i+1 )
    begin
    #20000 SCLK <= ~SCLK;
    end
end
// reset the decoder and deactivate the reset
initial
begin
    ARST_L <= 1'b0;
    #30 ARST_L <= 1'b1;
end

initial 

begin 
    testvector_i <= 22'b0000011110100110001001; // test vector
end        

// a left-shifting shift register
// shifts MSB to the DUT
assign SDATA = testvector_i[21];
initial 
begin 
    repeat(10) @ (negedge SCLK);
    repeat(22) @ (negedge SCLK) testvector_i <= {testvector_i[20:0], 1'b0};
end
endmodule
