// student ID : 314551134
module ALU(
	src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	//overflow
	);
     
// I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output reg[32-1:0]	 result_o;
output           zero_o;
//output           overflow;

// Internal signals
parameter ADD = 4'b0010;
parameter SUB = 4'b0110;
parameter AND = 4'b0001;
parameter OR  = 4'b0000;
parameter NOR = 4'b1101;
parameter SLT = 4'b0111;

assign zero_o = (result_o == 32'b0);
//assign overflow = ~((ctrl_i == SUB) ^ (src1_i[31] ^ src2_i[31])) & (src1_i[31] ^ result_o[31]) & (ctrl_i == SUB | ctrl_i == ADD);

// Main function
always @(*) begin
	case (ctrl_i)
      ADD: result_o = src1_i + src2_i;
      SUB: result_o = src1_i - src2_i;
      AND: result_o = src1_i & src2_i;
      OR: result_o = src1_i | src2_i;
      NOR: result_o = ~(src1_i | src2_i);
      SLT: result_o = src1_i < src2_i;
      default: result_o = 32'b0;
    endcase
end

endmodule

