`timescale 1ns / 1ps

module ALU_tb;

  // Inputs
  reg [31:0] src1_i;
  reg [31:0] src2_i;
  reg [3:0] ctrl_i;

  // Outputs
  wire [31:0] result_o;
  wire zero_o;
  wire overflow;

  // Instantiate the ALU
  ALU uut (
    .src1_i(src1_i),
    .src2_i(src2_i),
    .ctrl_i(ctrl_i),
    .result_o(result_o),
    .zero_o(zero_o),
    .overflow(overflow)
  );

  // Operation codes
  parameter ADD = 4'b0010;
  parameter SUB = 4'b0110;
  parameter AND = 4'b0001;
  parameter OR  = 4'b0000;
  parameter NOR = 4'b1101;
  parameter SLT = 4'b0111;

  initial begin
    $display("Time\tctrl_i\tsrc1_i\tsrc2_i\tresult_o\tzero_o\toverflow");

    // ADD
    ctrl_i = ADD; src1_i = 32'd15; src2_i = 32'd10;
    #10 $display("%0dns\tADD\t%d\t%d\t%d\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // SUB
    ctrl_i = SUB; src1_i = 32'd15; src2_i = 32'd15;
    #10 $display("%0dns\tSUB\t%d\t%d\t%d\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // AND
    ctrl_i = AND; src1_i = 32'hFFFF0000; src2_i = 32'h00FF00FF;
    #10 $display("%0dns\tAND\t%h\t%h\t%h\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // OR
    ctrl_i = OR; src1_i = 32'h00000001; src2_i = 32'h00000010;
    #10 $display("%0dns\tOR\t%h\t%h\t%h\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // NOR
    ctrl_i = NOR; src1_i = 32'h00000000; src2_i = 32'hFFFFFFFF;
    #10 $display("%0dns\tNOR\t%h\t%h\t%h\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // SLT (signed)
    ctrl_i = SLT; src1_i = -32'd1; src2_i = 32'd1;
    #10 $display("%0dns\tSLT\t%d\t%d\t%d\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // Overflow test (ADD)
    ctrl_i = ADD; src1_i = 32'h7FFFFFFF; src2_i = 32'd1;
    #10 $display("%0dns\tADDovf\t%h\t%h\t%h\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    // Overflow test (SUB)
    ctrl_i = SUB; src1_i = 32'h80000000; src2_i = 32'd1;
    #10 $display("%0dns\tSUBovf\t%h\t%h\t%h\t%b\t%b", $time, src1_i, src2_i, result_o, zero_o, overflow);

    $finish;
  end

endmodule
