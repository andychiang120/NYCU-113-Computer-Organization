// ID : 314551134
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Data_Memory.v"
`include "Decoder.v"
`include "Forwarding_Unit.v"
`include "Hazard_Detection.v"
`include "Instruction_Memory.v"
`include "MUX_2to1.v"
`include "MUX_3to1.v"
`include "Reg_File.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"
`include "Pipe_Reg.v"
`include "ProgramCounter.v"

`timescale 1ns / 1ps

module Pipe_CPU_PRO(
    clk_i,
    rst_i
);
    
input clk_i;
input rst_i;

// Internal signal
wire [32-1:0] pc_in;
wire [32-1:0] IF_pc_out;
wire [32-1:0] pc_plus4;
wire [32-1:0] shifted_branch_offset;
wire [32-1:0] pc_branch;
wire [32-1:0] tmp_instr;
wire [32-1:0] instr;
wire RegWrite;
wire [2-1:0] ALUOp;
wire ALUSrc;
wire RegDst;
wire [2-1:0] Branch;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire [32-1:0] WriteData;
wire [32-1:0] RSdata;
wire [32-1:0] RTdata;
wire [4-1:0] ALU_operation;
wire [32-1:0] extendData;
wire [32-1:0] ALUsrcData;
wire [32-1:0] ALUresult;
wire zero;
wire [32-1:0] MemData;

// IF stage
ProgramCounter PC(
    .clk_i(clk_i),
	.rst_i(rst_i),
    .pc_write(PCWrite),
	.pc_in_i(pc_in),
	.pc_out_o(IF_pc_out)
);

Instruction_Memory IM(
    .addr_i(IF_pc_out),
    .instr_o(tmp_instr)
);

Adder PCplus4(
    .src1_i(IF_pc_out),
	.src2_i(32'd4),
	.sum_o(pc_plus4)
);

// IF/ID Pipeline Register
wire [32-1:0] ID_pc_out;

Pipe_Reg #(.size(64)) IFID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IFFlush),
    .write(IFIDWrite),
    .data_i({IF_pc_out, tmp_instr}),
    .data_o({ID_pc_out, instr})
);


// ID stage
Decoder MainControl (
    .instr_op_i(instr[31:26]),
	.ALUOp_o(ALUOp),
	.ALUSrc_o(ALUSrc),
	.RegWrite_o(RegWrite),
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.MemRead_o(MemRead),
	.MemWrite_o(MemWrite),
	.MemtoReg_o(MemtoReg)
);

Reg_File RF (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(instr[25:21]),
    .RTaddr_i(instr[20:16]),
    .RDaddr_i(WB_rd),
    .RDdata_i(WriteData),
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(RSdata),
    .RTdata_o(RTdata)
);

Sign_Extend SE (
    .data_i(instr[15:0]),
    .data_o(extendData)
);

wire IFFlush;
wire IDFlush;
wire EXFlush;
wire IFIDWrite;
wire PCWrite;

Hazard_Detection HDU(
    .memread(EX_MemRead),
    .instr_i(instr),
    .idex_regt(EX_rt),
    .branch((MEM_Branch == 2'b01 && MEM_zero) || (MEM_Branch == 2'b10 && ~MEM_zero)),
    .pcwrite(PCWrite),
    .ifid_write(IFIDWrite),
    .ifid_flush(IFFlush),
    .idex_flush(IDFlush),
    .exmem_flush(EXFlush)
);

// ID/EX Pipeline Register
wire EX_RegWrite;
wire [2-1:0] EX_ALUOp;
wire EX_ALUSrc;
wire EX_RegDst;
wire [2-1:0] EX_Branch;
wire EX_MemRead;
wire EX_MemWrite;
wire EX_MemtoReg;

Pipe_Reg #(.size(10)) IDEX_ContolSignal(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IDFlush),
    .write(1'b1),
    .data_i({MemtoReg, RegWrite, Branch, MemWrite, MemRead, ALUOp, ALUSrc, RegDst}),
    .data_o({EX_MemtoReg, EX_RegWrite, EX_Branch, EX_MemWrite, EX_MemRead, EX_ALUOp, EX_ALUSrc, EX_RegDst})
);

wire [32-1:0] EX_pc_out;
wire [32-1:0] EX_RSdata;
wire [32-1:0] EX_RTdata;
wire [32-1:0] EX_extendData;
wire [5-1:0] EX_rs;
wire [5-1:0] EX_rt;
wire [5-1:0] EX_rd;

Pipe_Reg #(.size(143)) IDEX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(IDFlush),
    .write(1'b1),
    .data_i({ID_pc_out, RSdata, RTdata, extendData, instr[25:21], instr[20:16], instr[15:11]}),
    .data_o({EX_pc_out, EX_RSdata, EX_RTdata, EX_extendData, EX_rs, EX_rt, EX_rd})
);

// EX stage
Shift_Left_Two_32 branchSL(
    .data_i(EX_extendData),
    .data_o(shifted_branch_offset)
);

Adder BranchTgt(
    .src1_i(EX_pc_out),
	.src2_i(shifted_branch_offset),
	.sum_o(pc_branch)
);

ALU_Ctrl ALUControl(
    .funct_i(EX_extendData[5:0]),
    .ALUOp_i(EX_ALUOp),
    .ALUCtrl_o(ALU_operation)
);
wire [32-1:0] ALUSrc1;
wire [32-1:0] CorrectRt;

MUX_3to1 #(.size(32)) MUX_ForwardA(
    .data0_i(EX_RSdata),
    .data1_i(MEM_ALUresult), // from EX/MEM
    .data2_i(WriteData), // from MEM/WB
    .select_i(ForWardA),
    .data_o(ALUSrc1)
);

MUX_3to1 #(.size(32)) MUX_ForwardB(
    .data0_i(EX_RTdata),
    .data1_i(MEM_ALUresult), // from EX/MEM
    .data2_i(WriteData), // from MEM/WB
    .select_i(ForWardB),
    .data_o(CorrectRt)
);

MUX_2to1 #(.size(32)) MUX_ALUSrc(
    .data0_i(CorrectRt),
    .data1_i(EX_extendData),
    .select_i(EX_ALUSrc),
    .data_o(ALUsrcData)
);

ALU ALU(
    .src1_i(ALUSrc1),
	.src2_i(ALUsrcData),
	.ctrl_i(ALU_operation),
	.result_o(ALUresult),
	.zero_o(zero)
);

wire [5-1:0] rd;
MUX_2to1 #(.size(5)) MUX_RegDst(
    .data0_i(EX_rt),
    .data1_i(EX_rd),
    .select_i(EX_RegDst),
    .data_o(rd)
);

wire [2-1:0] ForWardA;
wire [2-1:0] ForWardB;

Forwarding_Unit FU(
    .regwrite_mem(MEM_RegWrite),
    .regwrite_wb(WB_RegWrite),
    .idex_regs(EX_rs),
    .idex_regt(EX_rt),
    .exmem_regd(MEM_rd),
    .memwb_regd(WB_rd),
    .forwarda(ForWardA),
    .forwardb(ForWardB)
);
// EX/MEM Pipeline Register
wire MEM_MemtoReg;
wire MEM_RegWrite;
wire [2-1:0] MEM_Branch;
wire MEM_MemWrite;
wire MEM_MemRead;

Pipe_Reg #(.size(6)) EXMEM_ControlSignal(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(EXFlush),
    .write(1'b1),
    .data_i({EX_MemtoReg, EX_RegWrite, EX_Branch, EX_MemWrite, EX_MemRead}),
    .data_o({MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_MemWrite, MEM_MemRead})
);

wire [32-1:0] branch_TgtAddr;
wire MEM_zero;
wire [32-1:0] MEM_ALUresult;
wire [32-1:0] MEM_RTdata;
wire [5-1:0] MEM_rd;

Pipe_Reg #(.size(102)) EXMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(EXFlush),
    .write(1'b1),
    .data_i({pc_branch, zero, ALUresult, CorrectRt, rd}),
    .data_o({branch_TgtAddr, MEM_zero, MEM_ALUresult, MEM_RTdata, MEM_rd})
);

// MEM stage

MUX_2to1 #(.size(32)) MUX_branch(
    .data0_i(pc_plus4),
    .data1_i(branch_TgtAddr),
    .select_i((MEM_Branch == 2'b01 && MEM_zero) || (MEM_Branch == 2'b10 && ~MEM_zero)),
    .data_o(pc_in)
);

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(MEM_ALUresult),
    .data_i(MEM_RTdata),
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_o(MemData)
);

// MEM/WB Pipeline Register
wire WB_MemtoReg;
wire WB_RegWrite;

Pipe_Reg #(.size(2)) MEMWB_ControlSignal(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({MEM_MemtoReg, MEM_RegWrite}),
    .data_o({WB_MemtoReg, WB_RegWrite})
);

wire [32-1:0] WB_MemData;
wire [32-1:0] WB_ALUresult;
wire [5-1:0] WB_rd;

Pipe_Reg #(.size(69)) MEMWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush(1'b0),
    .write(1'b1),
    .data_i({MemData, MEM_ALUresult, MEM_rd}),
    .data_o({WB_MemData, WB_ALUresult, WB_rd})
);

// WB stage
MUX_2to1 #(.size(32)) MUX_MemtoReg(
    .data0_i(WB_ALUresult),
    .data1_i(WB_MemData),
    .select_i(WB_MemtoReg),
    .data_o(WriteData)
);

endmodule