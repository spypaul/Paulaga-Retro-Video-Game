`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//VGAEncoder.v
//This module is a VGA  encoder which takes the switch signal as inputs 
//it outputs the code for the colors(RGB)
//It also generate the horizontal and vertical sync signal corresponding to the
// internal counter for the coordinates
//Shao-Peng Yang
//2/28/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////


module VGAEncoder(CLK, CSEL, ARST_L, HSYNC, VSYNC, RED, GREEN, BLUE, HCOORD, VCOORD);
input CLK, ARST_L;
input [11:0]CSEL;
output reg HSYNC, VSYNC;
output reg [3:0] RED, GREEN, BLUE;
output reg [9:0] HCOORD, VCOORD;
// the internal signals for all the outputs
reg hsync_i, vsync_i;
reg [3:0] red_i, green_i, blue_i;
reg [9:0] hcoord_i, vcoord_i;

// Making the active low reset to active high internally
wire arst_i;
assign arst_i = ~ARST_L;

//the counter for the horizontal axis
// it rolls over at 799
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i == 1'b1)
        hcoord_i <= 10'b0000000000;
    else if (hcoord_i == 799)
        hcoord_i <= 10'b0000000000;
    else 
        hcoord_i <= hcoord_i+1;    
end
//the counter for the vertical axis
// it rolls over at 525
// it increments the counter when h counter reaches the end of the row
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i == 1'b1)
        vcoord_i <= 10'b0000000000;
//since the v counter changes at posedge of the clock and the counter increments every 800 clock cycle
//the counter should rolls over at 525 instead of 524, so that the count 524 would last for 800 clock cycles
    else if (vcoord_i == 525)
        vcoord_i <= 10'b0000000000;
    else if (hcoord_i == 799)
        vcoord_i <= vcoord_i+1;    
end

// this generate the hsync signals
always @ (hcoord_i)
begin
     if ((hcoord_i >= 659)&&(hcoord_i <= 755))
           hsync_i <= 1'b0;
     else 
           hsync_i <= 1'b1;
end
// this generate the vsync signals
always @ (vcoord_i)
begin
     if ((vcoord_i == 493)||(vcoord_i == 494))
           vsync_i <= 1'b0;
     else 
           vsync_i <= 1'b1;
end
//this generate the color code for the driver corresponding to the coordinates
//in the blanking timing region, the color code is all zero to display black
always @ (hcoord_i, vcoord_i,CSEL)
begin
    if (((hcoord_i >= 640) && (hcoord_i <= 799))|| ((vcoord_i >= 480) && (vcoord_i <= 524)))// the blanking timing region
    begin 
        red_i <= 4'b0000;
        green_i <= 4'b0000;
        blue_i <= 4'b0000;
    end
    else
    begin
        {red_i, green_i, blue_i} <= CSEL;
    end
end
//this creates registers for all the output to prevent the combinational logic delay
// the coordinates output is also registered to line up with other outputs
always @ (posedge CLK, posedge arst_i)
begin
    if (arst_i == 1'b1)
    begin
         RED <= 4'b0000;
         GREEN <= 4'b0000;
         BLUE <= 4'b0000;
         HSYNC <= 1'b1;//HSYNC is reset to high
         VSYNC <= 1'b1;//VSYNC is reset to high
         HCOORD <= 10'b0000000000;
         VCOORD <= 10'b0000000000;
    end
    else
    begin
         RED <= red_i;
         GREEN <= green_i;
         BLUE <= blue_i;
         HSYNC <= hsync_i;
         VSYNC <= vsync_i; 
         HCOORD <= hcoord_i;
         VCOORD <= vcoord_i;        
    end
end

endmodule
