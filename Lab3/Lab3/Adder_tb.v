`timescale 1ns/1ps

module Adder_tb;

reg  [31:0] src1_i;
reg  [31:0] src2_i;
wire [31:0] sum_o;

// 待測 module
Adder uut (
    .src1_i(src1_i),
    .src2_i(src2_i),
    .sum_o(sum_o)
);

initial begin
    $display("Test 32-bit Adder:");
    $display("src1_i        | src2_i        | sum_o");
    $display("--------------|---------------|--------------");

    // Test 1: 1 + 2 = 3
    src1_i = 32'd1; src2_i = 32'd2; #1;
    $display("%h | %h | %h", src1_i, src2_i, sum_o);

    // Test 2: 0xFFFFFFFF + 1 = 0 (overflow)
    src1_i = 32'hFFFFFFFF; src2_i = 32'd1; #1;
    $display("%h | %h | %h", src1_i, src2_i, sum_o);

    // Test 3: 0x80000000 + 0x80000000 = 0x00000000 (overflow)
    src1_i = 32'h80000000; src2_i = 32'h80000000; #1;
    $display("%h | %h | %h", src1_i, src2_i, sum_o);

    // Test 4: 0x12345678 + 0x11111111 = 0x23456789
    src1_i = 32'h12345678; src2_i = 32'h11111111; #1;
    $display("%h | %h | %h", src1_i, src2_i, sum_o);

    // Test 5: 0 + 0 = 0
    src1_i = 32'd0; src2_i = 32'd0; #1;
    $display("%h | %h | %h", src1_i, src2_i, sum_o);

    $finish;
end

endmodule
