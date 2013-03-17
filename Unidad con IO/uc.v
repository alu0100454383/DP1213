module uc(
		input clk,
		input reset,
		input z,
		input [5:0] opcode, 
		output  s_inc,
		output s_io_alu,
		output s_inm_alu, 
		output s_rel,
		output s_we3,
		output s_WA3, 
		output s_PC, 
		output s_inm_rd,
		output s_wePC2, 
 		output [2:0] s_op,
 		output s_io,
 		output s_io_enable);

	reg r_inc;
	reg r_io_alu;
	reg r_inm_alu; 
	reg r_rel;
	reg r_we3; 
	reg r_WA3;
	reg r_PC;
	reg r_inm_rd;
	reg r_wePC2; 
 	reg [2:0] r_op;
 	reg r_io;
 	reg r_io_enable;
initial
begin
	r_inc=1'b1;
	r_io_alu=1'b0;
	r_inm_alu=1'b0; 
	r_rel=1'b0;
	r_we3=1'b0;
	r_WA3=1'b1; 
    r_PC=1'b0;
	r_inm_rd=1'b0;
	r_wePC2=1'b0; 
 	r_op=3'b000;
 	r_io=1'b0;
 	r_io_enable=1'b0;
end
always @ (posedge clk)
begin         //  operaciones de la alu
if (~opcode[2])
   begin 
	  r_inc=1'b1;
	  r_io_alu=1'b0;
	  r_inm_alu=1'b0; 
	  r_rel=1'b0;
	  r_we3=1'b1;
	  r_WA3=1'b1; 
      r_PC=1'b0;
	  r_inm_rd=1'b0;
	  r_wePC2=1'b0; 
 	  r_op=opcode[5:3];
 	  r_io=1'b0;
 	  r_io_enable=1'b0;
   end
else//opcode de 6 bits
begin
	case(opcode[5:0])
		6'b0001xx: //Carga de inmediato
		begin
		   r_inc=1'b1;
		   r_io_alu=1'b0;
		   r_inm_alu=1'b1; 
		   r_rel=1'b0;
		   r_we3=1'b1;
		   r_WA3=1'b1; 
    	   r_PC=1'b0;
		   r_inm_rd=1'b0;
		   r_wePC2=1'b0; 
 		   r_op=3'b000;
 		   r_io=1'b0;
 		   r_io_enable=1'b0;
		end
		6'b001100: //PC2<-PC
		begin
			r_inc=1'b1;
			r_io_alu=1'b0;
			r_inm_alu=1'b0; 
			r_rel=1'b0;
			r_we3=1'b0;
			r_WA3=1'b1; 
		    r_PC=1'b0;
			r_inm_rd=1'b0;
			r_wePC2=1'b1; 
		 	r_op=3'b000;
		 	r_io=1'b0;
		 	r_io_enable=1'b0;	
		end
		6'b001101:  //PC<-PC2
		begin
			r_inc=1'b0;
			r_io_alu=1'b0;
			r_inm_alu=1'b0; 
			r_rel=1'b0;
			r_we3=1'b0;
			r_WA3=1'b1; 
		    r_PC=1'b1;
			r_inm_rd=1'b0;
			r_wePC2=1'b0; 
		 	r_op=3'b000;
		 	r_io=1'b0;
		 	r_io_enable=1'b0;	         
		end
		6'b010100://REG<-PORT (INPUT)
		begin
		   	r_inc=1'b1;
			r_io_alu=1'b1;
			r_inm_alu=1'b0; 
			r_rel=1'b0;
			r_we3=1'b1;
			r_WA3=1'b0; 
		    r_PC=1'b0;
			r_inm_rd=1'b0;
			r_wePC2=1'b0; 
		 	r_op=3'b000;
		 	r_io=1'b0;
		 	r_io_enable=1'b1;
		end
		6'b010101://PORT<-REG (OUTPUT)
		begin
 		   	r_inc=1'b1;
			r_io_alu=1'b1;
			r_inm_alu=1'b0; 
			r_rel=1'b0;
			r_we3=1'b0;
			r_WA3=1'b0; 
		    r_PC=1'b0;
			r_inm_rd=1'b0;
			r_wePC2=1'b0; 
		 	r_op=3'b000;
		 	r_io=1'b1;
		 	r_io_enable=1'b1;
		end
		6'b010110://PORT<-INM (IOUTPUT)
		begin
			r_inc=1'b1;
			r_io_alu=1'b1;
			r_inm_alu=1'b0; 
			r_rel=1'b0;
			r_we3=1'b0;
			r_WA3=1'b0; 
		    r_PC=1'b0;
			r_inm_rd=1'b1;
			r_wePC2=1'b0; 
		 	r_op=3'b000;
		 	r_io=1'b1;
		 	r_io_enable=1'b1;
		end
		3'b110:
		begin
		end
		3'b111:
		begin
			case(opcode[1:0])
			2'b00: //salto si zero
			begin
			   if(z)
			   begin
					r_inc=1'b1;
					r_io_alu=1'b1;
					r_inm_alu=1'b0; 
					r_rel=1'b0;
					r_we3=1'b0;
					r_WA3=1'b0; 
				    r_PC=1'b0;
					r_inm_rd=1'b1;
					r_wePC2=1'b0; 
				 	r_op=3'b000;
				 	r_io=1'b1;
				 	r_io_enable=1'b1;
			   end
			   else
			   begin
					r_inc=1'b1;
					r_io_alu=1'b1;
					r_inm_alu=1'b0; 
					r_rel=1'b0;
					r_we3=1'b0;
					r_WA3=1'b0; 
				    r_PC=1'b0;
					r_inm_rd=1'b1;
					r_wePC2=1'b0; 
				 	r_op=3'b000;
				 	r_io=1'b1;
				 	r_io_enable=1'b1;
			   end
			end
			2'b01: //salto si no zero
			begin
			   if(~z)
			   begin
				  	r_inc=1'b1;
					r_io_alu=1'b1;
					r_inm_alu=1'b0; 
					r_rel=1'b0;
					r_we3=1'b0;
					r_WA3=1'b0; 
				    r_PC=1'b0;
					r_inm_rd=1'b1;
					r_wePC2=1'b0; 
				 	r_op=3'b000;
				 	r_io=1'b1;
				 	r_io_enable=1'b1;
			   end
			   else
			   begin
				  	r_inc=1'b1;
					r_io_alu=1'b1;
					r_inm_alu=1'b0; 
					r_rel=1'b0;
					r_we3=1'b0;
					r_WA3=1'b0; 
				    r_PC=1'b0;
					r_inm_rd=1'b1;
					r_wePC2=1'b0; 
				 	r_op=3'b000;
				 	r_io=1'b1;
				 	r_io_enable=1'b1;
			   end
			end
			2'b10://salto relativo
			begin
			  		r_inc=1'b1;
					r_io_alu=1'b1;
					r_inm_alu=1'b0; 
					r_rel=1'b0;
					r_we3=1'b0;
					r_WA3=1'b0; 
				    r_PC=1'b0;
					r_inm_rd=1'b1;
					r_wePC2=1'b0; 
				 	r_op=3'b000;
				 	r_io=1'b1;
				 	r_io_enable=1'b1;		
			 end
			2'b11: //salto absoluto
			begin
			end
			endcase
		end
	endcase
		
end 
end
assign s_op=r_op;
assign s_inc=r_inc;
assign s_io_alu=r_io_alu;
assign s_inm_alu=r_inm_alu;
assign s_rel=r_rel;
assign s_we3=r_we3;
assign s_WA3=r_WA3;
assign s_PC=r_PC;
assign s_inm_rd=r_inm_rd;
assign s_wePC2=r_wePC2;
assign s_op=r_op;
assign s_io=r_io;
assign s_io_enable=r_io_enable;
endmodule

 
