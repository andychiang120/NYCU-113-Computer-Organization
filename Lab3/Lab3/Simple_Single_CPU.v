// student ID : 314551134
`include "ProgramCounter.v"
`include "Instr_Memory.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "MUX_2to1.v"
`include "MUX_3to1.v"
`include "Decoder.v"
`include "Sign_Extend.v"
`include "Shift_Left_Two_32.v"

module Shifter (
    leftRight,
    shamt,
    sftSrc,
    result
);
  input leftRight;
  input [5-1:0] shamt;
  input [32-1:0] sftSrc;
  output [32-1:0] result;

  assign result = (leftRight) ? sftSrc >> shamt : sftSrc << shamt;

endmodule


module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
// I/O port
input         clk_i;
input         rst_i;

// Internal Signals
wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] pc_plus4;
wire [32-1:0] shifted_branch_offset;
wire [32-1:0] pc_branch;
wire [32-1:0] pc_before_jump;
wire [32-1:0] pc_before_jr;
wire [32-1:0] instr;
wire RegWrite;
wire [2-1:0] ALUOp;
wire ALUSrc;
wire [2-1:0] RegDst;
wire Jump;
wire [2-1:0] Branch;
wire JRsrc;
wire MemRead;
wire MemWrite;
wire [2-1:0] MemtoReg;
wire [5-1:0] FinalRegNo;
wire [32-1:0] WriteData;
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [4-1:0] ALU_operation;
wire FURslt;
wire shifhterSource;
wire leftRight;
wire [32-1:0] extendData;
wire [32-1:0] ALUsrcData;
wire [32-1:0] ALUresult;
wire zero;
wire overflow;
wire [5-1:0] shamt;
wire [32-1:0] sftResult;
wire [32-1:0] FURres;
wire [32-1:0] MemData;

// Components
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_in),   
        .pc_out_o(pc_out) 
);

Instr_Memory IM(
        .pc_addr_i(pc_out),  
        .instr_o(instr)
);

Adder PCplus4(
        .src1_i(pc_out),
        .src2_i(32'd4),
        .sum_o(pc_plus4)
);

Shift_Left_Two_32 branchSE(
        .data_i(extendData),
        .data_o(shifted_branch_offset)
);

Adder BranchTgt(
        .src1_i(pc_out),        // 無參考點
        .src2_i(shifted_branch_offset),
        .sum_o(pc_branch)
);

MUX_2to1 #(.size(32)) MUX_branch(
        .data0_i(pc_plus4),
        .data1_i(pc_branch),
        .select_i((Branch == 2'b01 && zero) || (Branch == 2'b10 && ~zero)),
        .data_o(pc_before_jump)
);

MUX_2to1 #(.size(32)) MUX_jump(
        .data0_i(pc_before_jump),
        .data1_i({pc_plus4[31:28], instr[25:0], 2'b00}),
        .select_i(Jump),
        .data_o(pc_before_jr)
);

MUX_2to1 #(.size(32)) MUX_JR(
        .data0_i(pc_before_jr),
        .data1_i(RSdata),       // jr $xx
        .select_i(JRsrc),
        .data_o(pc_in)
);

Decoder MainControl(
        .instr_op_i(instr[31:26]),
	.ALU_op_o(ALUOp),
	.ALUSrc_o(ALUSrc),
	.RegWrite_o(RegWrite),
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.Jump_o(Jump),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg)
);

ALU_Ctrl ALU_Control(
        .funct_i(instr[5:0]),
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALU_operation),
        .FURslt_o(FURslt), // choose what unit should be used
        .leftRight_o(leftRight),
        .shifhterSource_o(shifhterSource),
        .JR_source_o(JRsrc)
);

MUX_2to1 #(.size(5)) MUX_shamt(
        .data0_i(instr[10:6]),
        .data1_i(RSdata[4:0]),
        .select_i(shifhterSource),
        .data_o(shamt)
);

MUX_3to1 #(.size(5)) MUX_RegDst(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'd31),
        .select_i(RegDst),
        .data_o(FinalRegNo)
);

Shifter shifter (
        .leftRight(leftRight),
        .shamt(shamt),
        .sftSrc(RTdata), // ALUsrcData
        .result(sftResult)
);

Reg_File Registers(
        .clk_i(clk_i),
        .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]),
        .RTaddr_i(instr[20:16]),
        .RDaddr_i(FinalRegNo), 
        .RDdata_i(WriteData),   
        .RegWrite_i(RegWrite & (~JRsrc)),  
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata) 
);

Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(extendData)
);

MUX_2to1 #(.size(32)) MUX_ALUSrc(
        .data0_i(RTdata),
        .data1_i(extendData),
        .select_i(ALUSrc),
        .data_o(ALUsrcData)
);

ALU ALU(
        .src1_i(RSdata),
	.src2_i(ALUsrcData),
	.ctrl_i(ALU_operation),
	.result_o(ALUresult),
	.zero_o(zero),
	.overflow(overflow)
);

MUX_2to1 #(.size(32)) MUX_FUR (
      .data0_i (ALUresult),
      .data1_i (sftResult),
      .select_i(FURslt),
      .data_o  (FURres)
);
	
Data_Memory Data_Memory(
	.clk_i(clk_i), 
	.addr_i(FURres),
	.data_i(RTdata), 
	.MemRead_i(MemRead), 
	.MemWrite_i(MemWrite), 
	.data_o(MemData)
);

MUX_3to1 #(.size(32)) Mux_Final(
      .data0_i (FURres),
      .data1_i (MemData),
      .data2_i (pc_plus4),
      .select_i(MemtoReg),
      .data_o  (WriteData)
);

endmodule
