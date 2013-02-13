module contador(input wire clk, input wire reset,input wire fin, output wire [3:0] res);
reg [3:0] cont ;
assign  res=cont;

always @ (posedge clk,posedge reset, posedge fin)begin : loop_block

		if (fin)
			disable loop_block;
		else
			if (reset)
				cont = 0;
			else
				cont = cont + 1;

end
endmodule
