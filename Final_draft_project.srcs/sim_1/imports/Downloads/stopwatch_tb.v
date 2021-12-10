`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: Jose Reyes
// 
// Create Date: 12/04/2021 09:30:53 PM
// Design Name: 
// Module Name: stopwatch_tb
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


module stopwatch_tb();
    
// Inputs
reg clk_1sec;
reg reset;
reg stop;

// Outputs
wire [5:0] seconds;
wire [5:0] minutes;

stopwatch uut(
        .clk(clk_1sec), .reset(reset), .stop(stop),
        .seconds_stopwatch(seconds), .minutes_stopwatch(minutes)
        );
        
initial clk_1sec = 0;
always #0.001 clk_1sec = ~clk_1sec;

initial begin
    reset = 1;
    stop = 1;
    #1000;
    if ((minutes == 0) && (seconds == 0))begin //should be equal
         $display(minutes, seconds,"Passed.");                
    end  
    else begin
         $display(minutes, seconds,"Failed.");
    end 
    reset = 0;
    #1000;
    stop = 0;
    #10;
end
endmodule
