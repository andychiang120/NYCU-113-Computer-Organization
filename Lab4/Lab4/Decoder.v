// ID : 314551134
module Decoder( 
	instr_op_i, 
	ALUOp_o, 
	ALUSrc_o,
	RegWrite_o,	
	RegDst_o,
	Branch_o,
	MemRead_o, 
	MemWrite_o, 
	MemtoReg_o
);
     
// TO DO
// I/O ports
input	[6-1:0] instr_op_i;

output	[2-1:0] ALUOp_o;
output  [2-1:0] Branch_o;
output			RegDst_o, MemtoReg_o, ALUSrc_o, RegWrite_o, Jump_o, MemRead_o, MemWrite_o;

// Instruction opcode parameters
parameter Rtype = 6'b000000;
parameter ADDI  = 6'b001001;
parameter LW    = 6'b101100;
parameter SW    = 6'b100100;
parameter BEQ   = 6'b000110;
parameter BNE   = 6'b000101;

assign RegDst_o   = (instr_op_i == Rtype);


assign ALUSrc_o   = (instr_op_i == ADDI || instr_op_i == LW || instr_op_i == SW);

assign MemtoReg_o = (instr_op_i == LW);

assign RegWrite_o = (instr_op_i == Rtype || instr_op_i == ADDI || instr_op_i == LW);

assign MemRead_o  = (instr_op_i == LW);
assign MemWrite_o = (instr_op_i == SW);

assign Branch_o   = (instr_op_i == BEQ) ? 2'b01 :
                    (instr_op_i == BNE) ? 2'b10 : 2'b00;

assign ALUOp_o   = (instr_op_i == Rtype) ? 2'b10 :
                    (instr_op_i == BEQ || instr_op_i == BNE) ? 2'b01 : 2'b00;

endmodule