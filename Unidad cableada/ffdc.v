module ffdc #(parameter retardo = 1)(input wire clk, reset, carga, d, output reg q);
//reset as�ncrono, carga s�ncrona
always @(posedge clk, posedge reset)
  if (reset)
    q <= #retardo 1'b0; //asignaci�n no bloqueante q=0
  else
    if (carga)
      q <= #retardo d; //asignaci�n no bloqueante q=d
endmodule
