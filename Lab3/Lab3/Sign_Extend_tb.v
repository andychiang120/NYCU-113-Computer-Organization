`timescale 1ns/1ps

module Sign_Extend_tb;

// 測試用 input/output
reg  [15:0] data_i;
wire [31:0] data_o;

// 宣告待測 module
Sign_Extend uut (
    .data_i(data_i),
    .data_o(data_o)
);

initial begin
    $display("Test Sign_Extend:");
    $display(" data_i (hex) | data_o (hex) ");
    $display("--------------|----------------");

    // Test 1: 正數，最低位元為 0，最高位元為 0
    data_i = 16'h1234; #1;
    $display("   %h       | %h ", data_i, data_o);

    // Test 2: 負數，最高位元為 1（0xFFFF => -1）
    data_i = 16'hFFFF; #1;
    $display("   %h       | %h ", data_i, data_o);

    // Test 3: -2
    data_i = 16'hFFFE; #1;
    $display("   %h       | %h ", data_i, data_o);

    // Test 4: 正數最大值（0x7FFF）
    data_i = 16'h7FFF; #1;
    $display("   %h       | %h ", data_i, data_o);

    // Test 5: 負數最小值（0x8000）
    data_i = 16'h8000; #1;
    $display("   %h       | %h ", data_i, data_o);

    // 結束模擬
    $finish;
end

endmodule
