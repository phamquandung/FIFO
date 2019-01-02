`timescale 100ns / 10ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2018 10:05:16 AM
// Design Name: 
// Module Name: FIFO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIFO(clk, rst, push, pop, data_in, data_out, ready, empty, full);
parameter DATA_WIDTH = 32; //32 BITS
parameter ADDR_WIDTH = 3; 
parameter FIFO_DEPTH = (1 << ADDR_WIDTH);  //RAM save = 1000

//input and output
input clk, rst, push, pop;
input [DATA_WIDTH-1:0] data_in;
output reg empty, full;
output reg ready;
output reg [DATA_WIDTH-1:0] data_out;

//internal variable
reg [ADDR_WIDTH:0] wr_ptr;
reg [ADDR_WIDTH:0] rd_ptr;
reg [24:0] stt_cnt;
reg [DATA_WIDTH-1:0] data_ram[6:0];

//variable assignment
always@(stt_cnt)
begin
    full = (stt_cnt == FIFO_DEPTH - 2); 
    empty = (stt_cnt == 0);
end
always@(posedge clk or posedge rst)
begin: STT_CNT
    if (rst) begin
        stt_cnt = 0;
    end
    else if ((!full&&push)&&(!empty&&pop))begin
            stt_cnt = stt_cnt;
        end
    else if (!full&&push) begin 
        stt_cnt = stt_cnt +1;
        //else stt_cnt = stt_cnt;
    end
    else if (!empty&&pop) begin
        stt_cnt = stt_cnt - 1;
    end
    else stt_cnt = stt_cnt;
end

always@(posedge clk or posedge rst)
begin
    if (rst) begin ready = 0; end
    else begin
        @(negedge empty) ready = 1; 
        @(posedge empty) ready = 0;
    end
end

always@(posedge clk or posedge rst)
begin: REA_WRI_PTR
    if (rst) 
    begin
        rd_ptr = 0;
        wr_ptr = 0;
    end
    else begin 
        if (pop && !empty) 
        begin
            rd_ptr = rd_ptr + 1;
        end
        else rd_ptr = rd_ptr;
        if (push && !full) 
        begin
            wr_ptr = wr_ptr + 1;
        end
        else wr_ptr = wr_ptr;
     end
end

always@(posedge clk)
begin: WRI_DATA
    if (push && !full)
        data_ram[wr_ptr] = data_in;
    else data_ram[wr_ptr] = data_ram[wr_ptr];
end

always@(posedge clk /*or posedge rst*/)
begin: REA_DATA
    //if(rst) data_out = 0;
    //else begin
        if ((pop && !empty) && ready) begin
            data_out = data_ram[rd_ptr];
        end
        else data_out = data_out;
    //end
end

endmodule
