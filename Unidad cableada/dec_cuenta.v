module dec_cuenta(input wire [3:0] sel,output wire [15:0] ope);
assign ope= 1<< sel;
endmodule