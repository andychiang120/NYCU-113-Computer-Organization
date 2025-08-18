`timescale 1ns/1ps

module Shift_Left_Two_32_tb;

reg  [31:0] data_i;
wire [31:0] data_o;

Shift_Left_Two_32 uut (
    .data_i(data_i),
    .data_o(data_o)
);

initial begin
    $display("Test Shift_Left_Two_32:");
    $display(" data_i (hex)   | data_o (hex)   ");
    $display("----------------|----------------");

    // Test 1: 0x0000_0001 -> 0x0000_0004
    data_i = 32'h00000001; #1;
    $display("   %h     |   %h ", data_i, data_o);

    // Test 2: 0x0000_0003 -> 0x0000_000C
    data_i = 32'h00000003; #1;
    $display("   %h     |   %h ", data_i, data_o);

    // Test 3: 0xFFFFFFFF -> 0xFFFFFFFC
    data_i = 32'hFFFFFFFF; #1;
    $display("   %h     |   %h ", data_i, data_o);

    // Test 4: 0x80000000 -> 0x00000000 (overflow bits丟掉)
    data_i = 32'h80000000; #1;
    $display("   %h     |   %h ", data_i, data_o);

    // Test 5: 0x12345678 -> 0x48D159E0
    data_i = 32'h12345678; #1;
    $display("   %h     |   %h ", data_i, data_o);

    $finish;
end

endmodule
