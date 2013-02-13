`timescale 1 ns / 1 ps
`include "cuenta1.v"
module cuenta1_tb;
reg [2:0] Valor;
wire [3:0] Cuenta;

reg start,clk;
wire fin;

cuenta1 test_cuenta1(Valor,start,clk,Cuenta,fin);


always //RELOJ
begin
	clk=0;
	#60;
	clk=1;
	#60;
end

initial
begin
	$dumpfile("mimodulo_tb.vcd");
	$dumpvars;
	Valor=3'b000;
	start=1;
	#1;
	start=0;

	#600;
	$finish;

end

endmodule
