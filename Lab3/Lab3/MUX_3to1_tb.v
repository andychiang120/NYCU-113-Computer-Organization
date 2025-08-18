`timescale 1ns/1ps

module MUX_3to1_tb;

parameter size = 8;

reg  [size-1:0] data0_i;
reg  [size-1:0] data1_i;
reg  [size-1:0] data2_i;
reg  [1:0]      select_i;
wire [size-1:0] data_o;

// 待測 module 宣告
MUX_3to1 #(.size(size)) uut (
    .data0_i(data0_i),
    .data1_i(data1_i),
    .data2_i(data2_i),
    .select_i(select_i),
    .data_o(data_o)
);

initial begin
    $display("Test MUX_3to1:");
    $display("sel | data0 | data1 | data2 | data_o");
    $display("----|-------|-------|-------|--------");

    // select = 00，輸出 data0
    data0_i = 8'hA5; data1_i = 8'h3C; data2_i = 8'hF0; select_i = 2'b00; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    // select = 01，輸出 data1
    data0_i = 8'hA5; data1_i = 8'h3C; data2_i = 8'hF0; select_i = 2'b01; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    // select = 10，輸出 data2
    data0_i = 8'hA5; data1_i = 8'h3C; data2_i = 8'hF0; select_i = 2'b10; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    // select = 11，還是輸出 data2（根據你的設計）
    data0_i = 8'hA5; data1_i = 8'h3C; data2_i = 8'hF0; select_i = 2'b11; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    // 隨機數值測試
    data0_i = 8'h00; data1_i = 8'hFF; data2_i = 8'h7E; select_i = 2'b00; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    data0_i = 8'h00; data1_i = 8'hFF; data2_i = 8'h7E; select_i = 2'b01; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    data0_i = 8'h00; data1_i = 8'hFF; data2_i = 8'h7E; select_i = 2'b10; #1;
    $display(" %b  |  %h  |  %h  |  %h  |  %h", select_i, data0_i, data1_i, data2_i, data_o);

    $finish;
end

endmodule
