//Componentes varios

//Banco de registros de dos salidas y una entrada
module regfile(input  wire        clk, 
               input  wire        we3,           //se�al de habilitaci�n de escritura
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [7:0]  wd3, 			 //dato a escribir
               output wire [7:0]  rd1, rd2);     //datos leidos

  reg [7:0] regb[0:15]; //memoria de 16 registros de 8 bits de ancho 
  wire [7:0] r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
initial
begin
   $readmemb("regfile.dat",regb);
end
  // El registro 0 siempre es cero
  // se leen dos reg combinacionalmente
  // y la escritura del tercero ocurre en flanco de subida del reloj
  always @( clk)
    if (we3) regb[wa3] <= wd3;	

assign rd1 = (ra1 != 0) ? regb[ra1] : 0;
assign rd2 = (ra2 != 0) ? regb[ra2] : 0;
assign r1= regb[1];
assign r2= regb[2];
assign r3= regb[3];
assign r4= regb[4];
assign r5= regb[5];
assign r6= regb[6];
assign r7= regb[7];
assign r8= regb[8];
assign r9= regb[9];
assign r10= regb[10];
assign r11= regb[11];
assign r12= regb[12];
assign r13= regb[13];
assign r14= regb[14];
assign r15= regb[15];

endmodule

//modulo sumador  
module sum(input  wire [9:0] a, b,
             output wire [9:0] y);

  assign y = a + b;
endmodule

//modulo de registro para modelar el PC, cambia en cada flanco de subida de reloj o de reset
module registro #(parameter WIDTH = 10)
              (input  wire             clk, reset,
               input  wire [WIDTH-1:0] d, 
               output reg  [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule
//module demux_n_to_m #(parameter WIDTH = 8)()
//endmodule


//modulo para PC2
module registro_we #(parameter WIDTH = 10)
              (input  wire             clk, reset, s_we,
               input  wire [WIDTH-1:0] d,
               output reg  [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else if (s_we)      q <= d;
endmodule

//modulo multiplexor, cos s=1 sale d1, s=0 sale d0
module mux2 #(parameter WIDTH = 10)
             (input  wire [WIDTH-1:0] d0, d1, 
              input  wire             s, 
              output wire [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module ffdc #(parameter retardo = 1)(input wire clk, reset, carga, d, output reg q);
//reset as�ncrono, carga s�ncrona
always @(posedge clk, posedge reset)
  if (reset)
    q <= #retardo 1'b0; //asignaci�n no bloqueante q=0
  else
    if (carga)
      q <= #retardo d; //asignaci�n no bloqueante q=d
endmodule

module IO #(parameter WIDTH = 8)
          (
          input       clk, reset, 
          input       io_enable,
          input       sel_io,//select mode 0-> INPUT; 1-> OUTPUT 
          input [3:0] sel_p,
          output reg [7:0] in_data, //hacia la cpu
          input [7:0] out_data, //desde la cpu hacia el puerto
          inout [7:0] p0, p1, p2, p3, p4, p5, p6, p7,
          inout [7:0] p8, p9, p10, p11, p12, p13, p14, p15
          );

reg [7:0] puertos [15:0];
reg [15:0] ioflags;

initial
ioflags=16'b0000000000000000;
//reg->fuera
assign p0  = (ioflags[0])  ? puertos[0]  : 8'bz;
assign p1  = (ioflags[1])  ? puertos[1]  : 8'bz;
assign p2  = (ioflags[2])  ? puertos[2]  : 8'bz;
assign p3  = (ioflags[3])  ? puertos[3]  : 8'bz;
assign p4  = (ioflags[4])  ? puertos[4]  : 8'bz;
assign p5  = (ioflags[5])  ? puertos[5]  : 8'bz;
assign p6  = (ioflags[6])  ? puertos[6]  : 8'bz;
assign p7  = (ioflags[7])  ? puertos[7]  : 8'bz;
assign p8  = (ioflags[8])  ? puertos[8]  : 8'bz;
assign p9  = (ioflags[9])  ? puertos[9]  : 8'bz;
assign p10 = (ioflags[10]) ? puertos[10] : 8'bz;
assign p11 = (ioflags[11]) ? puertos[11] : 8'bz;
assign p12 = (ioflags[12]) ? puertos[12] : 8'bz;
assign p13 = (ioflags[13]) ? puertos[13] : 8'bz;
assign p14 = (ioflags[14]) ? puertos[14] : 8'bz;
assign p15 = (ioflags[15]) ? puertos[15] : 8'bz;


always @ (posedge clk)
begin
   if (reset)
      $readmemb("regfile.dat",puertos);

   if (io_enable)//habilitar
   begin
      if (sel_io) //OUTPUT
           puertos[sel_p]  = (ioflags[sel_p])  ? out_data : puertos[sel_p] ;
      else //INPUT
         in_data=puertos[sel_p] ;
   end
   puertos[0]  = (~ioflags[0])  ? p0  : puertos[0]  ;
   puertos[1]  = (~ioflags[1])  ? p1  : puertos[1]  ;
   puertos[2]  = (~ioflags[2])  ? p2  : puertos[2]  ;
   puertos[3]  = (~ioflags[3])  ? p3  : puertos[3]  ;
   puertos[4]  = (~ioflags[4])  ? p4  : puertos[4]  ;
   puertos[5]  = (~ioflags[5])  ? p5  : puertos[5]  ;
   puertos[6]  = (~ioflags[6])  ? p6  : puertos[6]  ;
   puertos[7]  = (~ioflags[7])  ? p7  : puertos[7]  ;
   puertos[8]  = (~ioflags[8])  ? p8  : puertos[8]  ;
   puertos[9]  = (~ioflags[9])  ? p9  : puertos[9]  ;
   puertos[10] = (~ioflags[10]) ? p10 : puertos[10] ;
   puertos[11] = (~ioflags[11]) ? p11 : puertos[11] ;
   puertos[12] = (~ioflags[12]) ? p12 : puertos[12] ;
   puertos[13] = (~ioflags[13]) ? p13 : puertos[13] ;
   puertos[14] = (~ioflags[14]) ? p14 : puertos[14] ;
   puertos[15] = (~ioflags[15]) ? p15 : puertos[15] ;
end




endmodule