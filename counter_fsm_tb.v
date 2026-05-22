`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2023 01:35:20 PM
// Design Name: 
// Module Name: le9_tb
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

module test;
  // Inputs
  reg en, clk, reset;
  
  // Wires to read the outputs from our two counters
  wire [7:0] ones_count;
  wire [7:0] tens_count;
  
  // Wires for the pulses
  wire ones_pulse;
  wire tens_pulse; // Don't really need but its best practice to connect
    
  // The Ones Place Counter (Counts 0 to 9)
  state_cntr ones_place(
    .en(en),               // Driven by our main testbench enable switch
    .clk(clk), 
    .reset(reset), 
    .term_cnt(8'd9),       // Tell it to stop at 9
    .cnt(ones_count),      // Send the current number to our ones_count wire
    .pulse(ones_pulse)     // Sends a high pulse when number hits 9
  );

  // The Tens Place Counter (Counts 0 to 3)
  state_cntr tens_place(
    .en(ones_pulse),       // Only enabled when the ones place hits 9
    .clk(clk), 
    .reset(reset), 
    .term_cnt(8'd3),       // Tell it to stop at 3
    .cnt(tens_count),      // Send the current number to our tens_count wire
    .pulse(tens_pulse)
  );

  initial begin
    // Start everything at zero
    en = 0; 
    clk = 0; 
    reset = 0;
    
    // Quick reset sequence
    #2 reset = 1; // Wait for 2 nanoseconds
    #2 reset = 0; // Wait for 2 nanoseconds
    
    // Turn the main system on
    #6 en = 1; // Wait 6 nanoseconds
    
    // We need 40 clock cycles to count from 00 to 39. 
    // At 20ns per cycle, that's 800ns. 
    #1000 // We will wait 1000ns just so we can watch it roll over from 39 back to 00!
    
    $finish;
  end
  
  always begin
    // 20ns clock
    #10 clk = ~clk; // invert clock signal
  end
  
endmodule