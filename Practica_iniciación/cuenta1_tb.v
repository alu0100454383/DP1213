`timescale 1 ns / 1 ps

module cuenta1_tb;
reg [2:0] Valor;
wire [3:0] Cuenta;

reg start,clk;
wire fin;

cuenta1 test_cuenta1(Valor,start,clk,Cuenta,fin);


always //RELOJ
begin
	clk=0;
	#1;
	clk=1;
	#1;
end

initial
begin
	$dumpfile("mimodulo_tb.vcd");
	$dumpvars;
	Valor=3'b110;
	start=1;
	#1;
	start=0;

	#600;
	$finish;

end

endmodule
