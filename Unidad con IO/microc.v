`include "componentes.v"
`include "memprog.v"
`include "alu.v"
module microc(
	input clk,
	input reset,
	input s_inc,
	input s_io_alu,
	input s_inm_alu, 
	input s_rel,
	input s_we3,
	input s_WA3, 
	input s_PC, 
	input s_inm_rd,
	input s_wePC2,
	input s_io_enable,
 	input [2:0] s_op,
 	input s_io, //seleccion modo: 0-> entrada; 1-> salida
 	output z, 
 	output [5:0] opcode
 	
	
 	);
	reg [7:0] puerto;
	wire [9:0] out_MuxPC;
	wire [9:0] out_MuxPC2;
	wire [9:0] out_PC2; 
	wire [9:0] out_sumPC;
	wire [7:0] out_Mux_IO;
	wire [3:0] out_muxWA3;
	wire [7:0] out_mux_alu;
	wire [9:0] out_mux_rel;
	wire [7:0] out_mux_reg;
	wire [15:0] memdata;
	wire [9:0] out_PC;
	wire [7:0] reg_out1;
	wire [7:0] reg_out2;
	wire [7:0] alu_out;
	
	wire [7:0] in_data; //datos que vienen de I/O
	wire [7:0] p0,p1,p2,p3,p4,p5,p6,p7;
	wire [7:0] p8,p9,p10,p11,p12,p13,p14,p15; //puertos del modulo I/O
	
    //Microcontrolador sin memoria de datos de un solo ciclo
	
	registro  PC(clk, reset, out_MuxPC2, out_PC);
	
	registro_we PC2(clk,reset,s_wePC2, out_MuxPC, out_PC2);
	
	memprog memoria(clk, out_PC, memdata);
	
	regfile registros( clk, s_we3, memdata[11:8], memdata[7:4], 
		out_muxWA3, out_mux_reg, reg_out1, reg_out2); 
	
	alu ual(reg_out1,reg_out2, s_op, alu_out, z);
	
	IO EntSal(clk, reset, s_io_enable, s_io, memdata[3:0],
	 in_data, out_Mux_IO, p0, p1, p2, p3, p4, p5, p6, p7,
	 p8, p9, p10, p11, p12, p13, p14, p15);
	

	initial
	puerto=27;

	
	sum sumpc(out_PC, out_mux_rel, out_sumPC);
	//				  Entrada 1	     Entrada 2      selector   salida
	mux2 #10 muxrel(  1,             memdata[9:0],  s_rel,     out_mux_rel);
	mux2 #10 muxPC(   memdata[9:0],  out_sumPC,     s_inc,     out_MuxPC);
	mux2 #10 muxPC2(  out_MuxPC,     out_PC2,       s_PC,      out_MuxPC2);
	
	mux2 #8  muxreg(  out_mux_alu,   memdata[11:4], s_inm_alu, out_mux_reg);
	mux2 #4  mux_WA3( memdata[7:4],  memdata[3:0],  s_WA3,     out_muxWA3);
	mux2 #8  muxalu(  alu_out,       in_data,       s_io_alu,  out_mux_alu);
	mux2 #8  mux_IO(  memdata[11:4], reg_out2,      s_inm_rd,  out_Mux_IO);
//Instanciar e interconectar pc, memprog, regfile, alu, sum y mux's
assign opcode=memdata[15:10];
assign	 p1=puerto;
endmodule
