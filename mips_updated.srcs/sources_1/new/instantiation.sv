`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 12:17:13 AM
// Design Name: 
// Module Name: instantiation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instantiation(

        input CLK, button_clk, button_reset,
        
        output memwrite_led,
        
        output [6:0]seg, 
        output [3:0]an,
        output dp
        
    );
   
    logic clear = 0;
    logic mips_clk, mips_reset;
    
    
    pulse_controller c1(CLK, button_clk, clear, mips_clk);
    pulse_controller c2(CLK, button_reset, clear, mips_reset);
    
    
    logic [31:0] writedata, dataadr, readdata;
    logic memwrite;
 
    top processor(mips_clk, mips_reset, writedata, dataadr, readdata, memwrite);
    
    assign memwrite_led = memwrite;
    
    logic [3:0] in3, in2, in1, in0;
    
    assign in3 = writedata[7:4];
    assign in2 = writedata[3:0];
    
    assign in1 = dataadr[7:4];
    assign in0 = dataadr[3:0];
    
    display_controller disp(CLK, in3, in2, in1, in0, seg, dp, an);
    
   
    
endmodule
