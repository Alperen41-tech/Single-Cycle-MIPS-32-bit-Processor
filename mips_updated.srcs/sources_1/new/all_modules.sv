`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2024 02:33:45 PM
// Design Name: 
// Module Name: all_modules
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


module all_modules();





endmodule


// Top level system including MIPS and memories

module top  (input   logic 	 clk, reset,            
	     output  logic[31:0] writedata, dataadr, 
	     output  logic[31:0] readdata,           
	     output  logic       memwrite,
	     output logic [31:0] instr_test, pc_test
	      );    
   // instantiate processor and memories  
   logic [31:0] instr, pc;
   mips mips (clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);  
   imem imem (pc[7:0], instr);  
   dmem dmem (clk, memwrite, dataadr, writedata, readdata);
   
   assign instr_test = instr;
   assign pc_test = pc;

endmodule


// External data memory used by MIPS single-cycle processor

module dmem (input  logic        clk, we,
             input  logic[31:0]  a, wd,
             output logic[31:0]  rd);

   logic  [31:0] RAM[63:0];
  
   assign rd = RAM[a[31:2]];    // word-aligned  read (for lw)

   always_ff @(posedge clk)
     if (we)
       RAM[a[31:2]] <= wd;      // word-aligned write (for sw)

endmodule

// External instruction memory used by MIPS single-cycle
// processor. It models instruction memory as a stored-program 
// ROM, with address as input, and instruction as output

module imem ( input logic [7:0] addr, output logic [31:0] instr);

// imem is modeled as a lookup table, a stored-program byte-addressable ROM
	always_comb
	   case (addr)		   	// word-aligned fetch
//		address		instruction
//		-------		-----------

		
		
		// for sw+ instruction testing 
		
		//8'h00: instr = 32'h20080016;  //ADDI $t0 $zero 0x0016	
		//8'h04: instr = 32'h20090008;  //ADDI $t1 $zero 0x0008	
		//8'h08: instr = 32'h41280000;  //sw+ t0, 0(t1)	
		//8'h0c: instr = 32'hAD090000;  //SW $t1 0x0000 $t0
		//8'h10: instr = 32'h200A0008;  //ADDI $t2 $zero 0x0008
		//8'h14: instr = 32'h8D4B0000;  //LW $t3 0x0000 $t2
		
		
		// for trying testbench bor jaladd
		
	    8'h00: instr = 32'h2008000E;  	 // addi t0, zero, 14
		8'h04: instr = 32'h20090006;     // addi t1, zero, 6
		8'h08: instr = 32'h01090030;     // jaladd t0, t1
		8'h0c: instr = 32'h00e22025;     // just a instruction 
		8'h10: instr = 32'h00e22025;      // just a instruction 
		8'h14: instr = 32'hAC1F0008;      // sw 31, 8(zero)
		
		
		//8'h00: instr = 32'h20020005;  	// disassemble, by hand 
		//8'h04: instr = 32'h2003000c;  	// or with a program,
		//8'h08: instr = 32'h2067fff7;  	// to find out what
		//8'h0c: instr = 32'h00e22025;  	// this program does!
		//8'h10: instr = 32'h00642824;
		//8'h14: instr = 32'h00a42820;
		8'h18: instr = 32'h10a7000a;
		8'h1c: instr = 32'h0064202a;
	
		
		8'h20: instr = 32'h10800001;
		8'h24: instr = 32'h20050000;
		8'h28: instr = 32'h00e2202a;
		8'h2c: instr = 32'h00853820;
		8'h30: instr = 32'h00e23822;
		8'h34: instr = 32'hac670044;
		8'h38: instr = 32'h8c020050;
		8'h3c: instr = 32'h08000011;
		8'h40: instr = 32'h20020001;
		8'h44: instr = 32'hac020054;
		8'h48: instr = 32'h08000012;	// j 48, so it will loop here
	     default:  instr = {32{1'bx}};	// unknown address
	   endcase
endmodule



// single-cycle MIPS processor, with controller and datapath

module mips (input  logic        clk, reset,
             output logic[31:0]  pc,
             input  logic[31:0]  instr,
             output logic        memwrite,
             output logic[31:0]  aluout, writedata,
             input  logic[31:0]  readdata);

  logic        memtoreg, pcsrc, zero, alusrc, regdst, regwrite, jump, jadd, swp;
  logic [2:0]  alucontrol;

  controller c (instr[31:26], instr[5:0], zero, memtoreg, memwrite, pcsrc,
                        alusrc, regdst, regwrite, jump, jadd, swp, alucontrol);

  datapath dp (clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump,
                          alucontrol, jadd, swp, zero, pc, instr, aluout, writedata, readdata);

endmodule

module controller(input  logic[5:0] op, funct,
                  input  logic     zero,
                  output logic     memtoreg, memwrite,
                  output logic     pcsrc, alusrc,
                  output logic     regdst, regwrite,
                  output logic     jump,
                  output logic jadd,
                  output logic swp,
                  output logic[2:0] alucontrol);

   logic [1:0] aluop;
   logic       branch;

   maindec md (op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, 
		 jump, swp, aluop);

   aludec  ad (funct, aluop, jadd, alucontrol);

   assign pcsrc = branch & zero;

endmodule


module maindec (input logic[5:0] op, 
	              output logic memtoreg, memwrite, branch,
	              output logic alusrc, regdst, regwrite, jump,
	              output logic swp,
	              output logic[1:0] aluop );
   logic [9:0] controls;

   assign {regwrite, regdst, alusrc, branch, memwrite,
                memtoreg,  aluop, jump, swp} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 10'b1100001000; // R-type
      6'b100011: controls <= 10'b1010010000; // LW
      6'b101011: controls <= 10'b0010100000; // SW
      6'b000100: controls <= 10'b0001000100; // BEQ
      6'b001000: controls <= 10'b1010000000; // ADDI
      6'b000010: controls <= 10'b0000000010; // J
      6'b010000: controls <= 10'b1x101x0001; //sw+
      default:   controls <= 10'bxxxxxxxxx; // illegal op
    endcase
endmodule


module aludec (input    logic[5:0] funct,
               input    logic[1:0] aluop,
               output   logic jadd,
               output   logic[2:0] alucontrol);
  
 
  always_comb begin
    jadd = 0;
    case(aluop)
      2'b00: alucontrol  = 3'b010;  // add  (for lw/sw/addi)
      2'b01: alucontrol  = 3'b110;  // sub   (for beq)
      default: case(funct)          // R-TYPE instructions
          6'b100000: alucontrol  = 3'b010; // ADD
          6'b100010: alucontrol  = 3'b110; // SUB
          6'b100100: alucontrol  = 3'b000; // AND
          6'b100101: alucontrol  = 3'b001; // OR
          6'b101010: alucontrol  = 3'b111; // SLT
          6'b110000: begin
                     alucontrol  = 3'b010;
                     jadd = 1'b1;
                     end
          default:   alucontrol  = 3'bxxx; // ???
        endcase
    endcase
  end
endmodule



module datapath (input  logic clk, reset, memtoreg, pcsrc, alusrc, regdst,
                 input  logic regwrite, jump, 
		         input  logic[2:0]  alucontrol, 
		         input  logic jadd,
		         input  logic swp,
                 output logic zero, 
		         output logic[31:0] pc, 
	             input  logic[31:0] instr,
                 output logic[31:0] aluout, writedata, 
	             input  logic[31:0] readdata);

  logic [4:0]  writereg, standartdest, reddestination;
  logic [31:0] pcnext, pcnextbr, pcnextj, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh, srca, srcb, resultdata, resultpc4, purpleadderresult, result;
 
  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
                
  mux2 #(32)  pcjmux(pcnextbr, {pcplus4[31:28], 
                    instr[25:0], 2'b00}, jump, pcnextj);
  
  
  // burasý bizim taraf jadd için extradan pc kontrolüne yönelix mux yüklenmesi           
  
   mux2 #(32) pcmux(pcnextj, aluout, jadd, pcnext);
                    

// register file logic
   regfile     rf (clk, regwrite, instr[25:21], instr[20:16], writereg,
                   result, srca, writedata);
                   
   mux2 #(5)    wrmux (instr[20:16], instr[15:11], regdst, standartdest);
   mux2 #(5)    redDestMux (standartdest, 6'b011111, jadd, reddestination);
   mux2 #(5)    purpleMux  (reddestination, instr[25:21], swp, writereg);
   
  
  
  
   mux2 #(32)  standartmux (aluout, readdata, memtoreg, resultdata);
   
   mux2 #(32)  redmux (resultdata, pcplus4, jadd, resultpc4);
   
   adder       purpleAdder (srca, 32'b100, purpleadderresult);
   mux2 #(32)  purplemux (resultpc4, purpleadderresult, swp, result);
   
   
   signext         se (instr[15:0], signimm);

  // ALU logic
  
   mux2 #(32)  srcbmux (writedata, signimm, alusrc, srcb);
   alu         alu (srca, srcb, alucontrol, aluout, zero);

endmodule


module regfile (input    logic clk, we3, 
                input    logic[4:0]  ra1, ra2, wa3, 
                input    logic[31:0] wd3, 
                output   logic[31:0] rd1, rd2);

  logic [31:0] rf [31:0];

  // three ported register file: read two ports combinationally
  // write third port on rising edge of clock. Register0 hardwired to 0.

  always_ff@(posedge clk)
     if (we3) 
         rf [wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf [ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ ra2] : 0;

endmodule


module alu(input  logic [31:0] a, b, 
           input  logic [2:0]  alucont, 
           output logic [31:0] result,
           output logic zero);             
    always_comb
        case(alucont)
            3'b010: result = a + b;
            3'b110: result = a - b;
            3'b000: result = a & b;
            3'b001: result = a | b;
            3'b111: result = (a < b) ? 1 : 0;
            3'b100: result = a & ~b;
            3'b101: result = a | ~b;
            default: result = {32{1'bx}};
        endcase
    
    assign zero = (result == 0) ? 1'b1 : 1'b0;
endmodule


module adder (input  logic[31:0] a, b,
              output logic[31:0] y);
     
     assign y = a + b;
endmodule

module sl2 (input  logic[31:0] a,
            output logic[31:0] y);
     
     assign y = {a[29:0], 2'b00}; // shifts left by 2
endmodule

module signext (input  logic[15:0] a,
                output logic[31:0] y);
              
  assign y = {{16{a[15]}}, a};    // sign-extends 16-bit a
endmodule

// parameterized register
module flopr #(parameter WIDTH = 8)
              (input logic clk, reset, 
	       input logic[WIDTH-1:0] d, 
               output logic[WIDTH-1:0] q);

  always_ff@(posedge clk, posedge reset)
    if (reset) q <= 0; 
    else       q <= d;
endmodule


// paramaterized 2-to-1 MUX
module mux2 #(parameter WIDTH = 8)
             (input  logic[WIDTH-1:0] d0, d1,  
              input  logic s, 
              output logic[WIDTH-1:0] y);
  
   assign y = s ? d1 : d0; 
endmodule



