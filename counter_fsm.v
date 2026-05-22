`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Landon Glazier
// 
// Create Date: 03/28/2023 01:35:37 PM
// Design Name: 
// Module Name: le9
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

module state_cntr(
    input en,
    input clk,
    input reset,
    output pulse,
    input [7:0] term_cnt, //LG
    output reg [7:0] cnt //LG
    );

reg [7:0] next_cnt; 

// flip-flops (state memeory)
always @(posedge clk or posedge reset) begin
    if (reset==1'b1) cnt<=8'd0; // reset to zero 
    else cnt <= next_cnt;
end

// next-state logic 
always @(*) begin
    if(en) begin // check for the enable 
        if (cnt == term_cnt) next_cnt = 8'd0; // if the counter reaches 15 go back to zero LG
        else next_cnt = cnt + 8'd1; // new concept -- a counter! LG
    end 
    else next_cnt = cnt; // if enable is low stay in the same state 
end

// output logic 
assign pulse = (cnt == term_cnt); // at the last state send out a pulse 

endmodule
