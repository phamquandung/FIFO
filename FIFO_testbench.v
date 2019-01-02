`timescale 100ns / 10ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2018 05:13:44 PM
// Design Name: 
// Module Name: FIFO_testbench
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


module FIFO_testbench();
//parameter DATA_WIDTH = 32; //32 BITS
//parameter ADDR_WIDTH = 3; 
//parameter FIFO_DEPTH = (1 << ADDR_WIDTH);  //RAM save = 1000

reg clk, rst, pop, push;
reg [31:0] data_in;
reg [31:0] tempdata;

wire [31:0] data_out;
wire empty, full, ready;
always #0.5 clk = ~clk;
FIFO FF(.clk(clk), .rst(rst), .push(push), .pop(pop), .data_in(data_in), .data_out(data_out), .ready(ready), .empty(empty), .full(full));
initial
    begin
        clk = 1;
        rst = 1;
        push = 0;
        pop = 0;
        //data_in = 32'b00000000000000000000000000000000;
        tempdata = 32'b00000000000000000000000000000000;
        #1 rst = 0;
        push_task(32'b00000000000000000000000000000000);
        //pop_task(tempdata);      // fork
        push_task(32'b00000000000000000000000000000001);
        //pop_task(tempdata);       //   pop_task(tempdata);
              // join              //push and pop together   
        push_task(32'b00000000000000000000000000000011);
        //pop_task(tempdata);
        push_task(32'b00000000000000000000001111111111);
        //pop_task(tempdata);
        push_task(32'b00000000000000000000000000001111);
        //pop_task(tempdata);
        push_task(32'b00000000000000000000000000011111);
        push_task(32'b00000000000000000000000000111111);
        pop_task(tempdata);
        //push_task(50);
        //push_task(60);
       
        pop_task(tempdata);
        pop_task(tempdata);
        pop_task(tempdata);
        pop_task(tempdata);
        pop_task(tempdata);
        pop_task(tempdata);
        #20 $finish;
    end
    
task push_task;
    input[31:0] data;
    if(full)
        $display("---Cannot push: Buffer Full---");
    else
        begin
            $display("Pushed ",data );
            data_in = data;
            push = 1;
            @(posedge clk);
            #1 push = 0;
        end    
endtask
    
task pop_task;
    output [31:0] data;    
    if(empty)
        $display("---Cannot Pop: Buffer Empty---");
    else
        begin
        pop = 1;
        @(posedge clk);
        #1 pop = 0;
        data = data_out;
        $display("-------------------------------Poped ", data);
        end
endtask

endmodule
