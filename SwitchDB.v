`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//SwitchDB.v
//A Moore State machine that works as a switch debouncer
//It output an 1 when getting two straight 1s from the input
//Due to how the button is built on the board, this deboucer will combine two 
//bounce into a 1 at the output
//Shao-Peng Yang
//2/7/19: Initial Release
//////////////////////////////////////////////////////////////////////////////////
module SwitchDB(SW,CLK,ACLR_L,SWDB);
input SW,CLK,ACLR_L;
output reg SWDB;

// create the constant for the states
parameter SW_OFF = 2'b00; 
parameter SW_EDGE = 2'b01; 
parameter SW_VERF = 2'b11; 
parameter SW_HOLD = 2'b10; 

reg [1:0]next_state_i; // this store the next state
reg [1:0]state_i; // the bus track the present state
// make the active low clear input high
wire aclr_i;
assign aclr_i = ~ACLR_L;

// the state memory using D flipflop
always@ (posedge CLK, posedge aclr_i)
begin 
    if (aclr_i == 1'b1)
	    state_i <= SW_OFF;
	else
        state_i <= next_state_i;
end

// Next state logic
always @ (state_i, SW)
begin 
// This part check the present state, and assign the proper
// output and nextstate according to the SW input
    case (state_i)
		SW_OFF:
		begin 
		    if (SW == 1'b0)
			begin
		        next_state_i <= SW_OFF;
		        SWDB <= 1'b0;
			end			
			else 
			begin 
			    next_state_i <= SW_EDGE;
		        SWDB <= 1'b0;
			end
		end	
		
		SW_EDGE:
		begin 
		    if (SW == 1'b0)
			begin
		        next_state_i <= SW_OFF;
		        SWDB <= 1'b0;
			end
			else 
			begin 
			    next_state_i <= SW_VERF;
		        SWDB <= 1'b0;
			end
		end	
		
		SW_VERF:
		begin 
		        next_state_i <= SW_HOLD;
		        SWDB <= 1'b1;
		end	
		
		SW_HOLD:
		begin 
		    if (SW == 1'b0)
			begin
		        next_state_i <= SW_OFF;
		        SWDB <= 1'b0;
			end
			else 
			begin 
			    next_state_i <= SW_HOLD;
		        SWDB <= 1'b0;
			end
		end		
        default: begin
		end
    endcase
end	
endmodule