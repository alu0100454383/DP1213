`timescale 1 ns / 1 ps
`include "microc.v"
`include "uc.v"

module proc;
reg [7:0] puerto;
reg reset;
wire z1,z2;
wire z;
wire [5:0] opcode;
wire s_inc, s_inm, we3,jrel,pc_sel,wePC2;
wire [2:0] s_op;
reg clk;
wire [7:0] in_data;
wire [11:0]out_data;

wire s_inm_io;
always
	#60 clk=~clk;


uc unicon (clk, reset, z2, opcode, s_inc, s_io_alu, s_inm_alu, s_rel, s_we3, s_WA3, s_PC, s_inm_rd, s_wePC2, s_op, s_io, s_io_enable);

microc controlador (clk, reset, s_inc, s_io_alu, s_inm_alu, s_rel, s_we3, s_WA3, s_PC, s_inm_rd, s_wePC2, s_io_enable, s_op, s_io, z, opcode);

ffdc lag ( clk, reset, 1, z1, z2);


initial
begin
	clk=0;
	$dumpfile("procesador.vcd");
	$dumpvars;
	reset=1;
	#60
	reset =0;
	puerto=42;
	#6000;
	$finish;

end
assign p1=puerto;
endmodule

 
