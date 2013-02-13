`include "contador.v"
`include "dec_cuenta.v"
module uc_cableada(input wire q0, start, clk, output wire CargaQ, DesplazaQ, ResetA, CargaA, Fin);

wire [3:0] cuenta;
wire[15:0] out_dec;

contador cont(clk,start,Fin,cuenta);
dec_cuenta dc(cuenta,out_dec);
assign CargaQ = out_dec[0]; //a 1 si el estado es S0
assign DesplazaQ = (out_dec[2]|out_dec[4]);
assign ResetA = out_dec[0];
assign CargaA = (q0 & ((out_dec[1])|out_dec[3])|out_dec[5]);
assign Fin =out_dec[6];
endmodule
