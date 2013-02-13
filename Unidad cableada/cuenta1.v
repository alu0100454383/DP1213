`include "uc_cableada.v"
`include "regA.v"
`include "regQ.v"
`include "sum4.v"
module cuenta1(input wire [2:0] Valor, input wire start, clk, output wire [3:0] Cuenta, output wire fin);

wire ResetA, CargaA, CargaQ, DesplazaQ;
wire [3:0] EntA, SalA;
wire [2:0] SalQ;
	
assign Cuenta = SalA; //Para producir salidas de tipo wire

sum4 sum(EntA,,, SalA, 4'b0001, 1'b0); //Acarreos sin conectar a nada, el de entrada a 0
regA A(clk, ResetA, CargaA, EntA, SalA);
uc_cableada uc_c(SalQ[0], start, clk, CargaQ, DesplazaQ, ResetA, CargaA, fin);
regQ Q(Valor, CargaQ, DesplazaQ, clk, 1'b0, SalQ); //anulamos el reset, ya que se inicializa con la carga de Valor

endmodule
