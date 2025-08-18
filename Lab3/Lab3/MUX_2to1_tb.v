`timescale 1ns/1ps

module MUX_2to1_tb;

// 你要測試的參數
parameter size = 8;

reg  [size-1:0] data0_i;
reg  [size-1:0] data1_i;
reg             select_i;
wire [size-1:0] data_o;

// 宣告待測 MUX
MUX_2to1 #(.size(size)) uut (
    .data0_i(data0_i),
    .data1_i(data1_i),
    .select_i(select_i),
    .data_o(data_o)
);

initial begin
    $display("Test MUX_2to1:");
    $display("select | data0_i  | data1_i  | data_o");
    $display("-------|----------|----------|---------");

    // select = 0，輸出 data0_i
    data0_i = 8'hA5; data1_i = 8'h3C; select_i = 1'b0; #1;
    $display("  %b    |    %h    |   %h     |  %h", select_i, data0_i, data1_i, data_o);

    // select = 1，輸出 data1_i
    data0_i = 8'hA5; data1_i = 8'h3C; select_i = 1'b1; #1;
    $display("  %b    |    %h    |   %h     |  %h", select_i, data0_i, data1_i, data_o);

    // select = 0，不同數字
    data0_i = 8'h55; data1_i = 8'hFF; select_i = 1'b0; #1;
    $display("  %b    |    %h    |   %h     |  %h", select_i, data0_i, data1_i, data_o);

    // select = 1，不同數字
    data0_i = 8'h55; data1_i = 8'hFF; select_i = 1'b1; #1;
    $display("  %b    |    %h    |   %h     |  %h", select_i, data0_i, data1_i, data_o);

    // 邊界值測試
    data0_i = 8'h00; data1_i = 8'hFF; select_i = 1'b0; #1;
    $display("  %b    |    %h    |   %h     |  %h", select_i, data0_i, data1_i, data_o);

    data0_i = 8'h00; data1_i = 8'hFF; select_i = 1'b1; #1;
    $display("  %b    |    %h    |   %h     |  %h", select_i, data0_i, data1_i, data_o);

    $finish;
end

endmodule
