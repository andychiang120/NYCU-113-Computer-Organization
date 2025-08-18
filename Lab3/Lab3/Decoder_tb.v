
`timescale 1ns/1ps

module Decoder_tb;

  // Inputs
  reg [5:0] instr_op_i;

  // Outputs
  wire [1:0] ALU_op_o;
  wire [1:0] RegDst_o, MemtoReg_o;
  wire [1:0] Branch_o;
  wire       ALUSrc_o, RegWrite_o, Jump_o, MemRead_o, MemWrite_o;

  // Instantiate the Unit Under Test (UUT)
  Decoder uut (
    .instr_op_i(instr_op_i),
    .ALU_op_o(ALU_op_o),
    .ALUSrc_o(ALUSrc_o),
    .RegWrite_o(RegWrite_o),
    .RegDst_o(RegDst_o),
    .Branch_o(Branch_o),
    .Jump_o(Jump_o),
    .MemRead_o(MemRead_o),
    .MemWrite_o(MemWrite_o),
    .MemtoReg_o(MemtoReg_o)
  );

  // Define opcodes
  localparam Rtype = 6'b000000,
             ADDI  = 6'b001001,
             LW    = 6'b101100,
             SW    = 6'b100100,
             BEQ   = 6'b000110,
             BNE   = 6'b000101,
             J     = 6'b000111,
             JAL   = 6'b000011;

  initial begin
    $display("Time	Opcode	ALUop	RegDst	ALUSrc	MemtoReg	RegWrite	MemRead	MemWrite	Branch	Jump");

    instr_op_i = Rtype; #10;
    $display("%0t	Rtype	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = ADDI; #10;
    $display("%0t	ADDI	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = LW; #10;
    $display("%0t	LW	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = SW; #10;
    $display("%0t	SW	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = BEQ; #10;
    $display("%0t	BEQ	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = BNE; #10;
    $display("%0t	BNE	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = J; #10;
    $display("%0t	J	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    instr_op_i = JAL; #10;
    $display("%0t	JAL	%b	%b	%b	%b	%b	%b	%b	%b	%b", 
      $time, ALU_op_o, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemRead_o, MemWrite_o, Branch_o, Jump_o);

    $finish;
  end

endmodule
