`timescale 1ns/1ps

module MUX_2to1_tb;

    // 測試用變數（非 wire，不是連到實體）
    reg src1, src2, select;
    wire result;

    // DUT: Device Under Test
    MUX_2to1 uut (
        .src1(src1),
        .src2(src2),
        .select(select),
        .result(result)
    );

    // 測試流程
    initial begin
    $display("SEL SRC1 SRC2 | RESULT");

    src1 = 0; src2 = 0; select = 0; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);
    src1 = 0; src2 = 1; select = 0; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);
    src1 = 1; src2 = 0; select = 0; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);
    src1 = 1; src2 = 1; select = 0; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);

    src1 = 0; src2 = 0; select = 1; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);
    src1 = 0; src2 = 1; select = 1; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);
    src1 = 1; src2 = 0; select = 1; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);
    src1 = 1; src2 = 1; select = 1; #1; $display(" %b    %b    %b  |   %b", select, src1, src2, result);

    $finish;
    end


endmodule
