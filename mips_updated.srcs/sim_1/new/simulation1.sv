`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 01:01:51 AM
// Design Name: 
// Module Name: simulation1
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


module simulation1();


     logic clk, reset;      
	 logic[31:0] writedata, dataadr;
     logic[31:0] readdata;          
	 logic memwrite;
	 logic [31:0] instr, pc;
	 





    top myTop(clk, reset, writedata, dataadr, readdata, memwrite, instr, pc);
    
    
    
    
    
    
    initial begin
    
        clk = 0;
        reset = 1;
        
        #10
        clk = 1;
        reset = 0;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        #10
        clk = 0;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        #10
        clk = 0;
        
        #10
        clk = 1;
        
        
        
        
       
    end








endmodule
