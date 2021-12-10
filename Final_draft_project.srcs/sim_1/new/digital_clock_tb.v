`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos
// 
// Create Date: 11/09/2021 07:43:54 PM
// Design Name: digital_clock_tb
// Module Name: digital_clock_tb
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: tests the clock module
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module digital_clock_tb();

    // Inputs
    reg Clk_1sec;
    reg reset;
    reg am_pm_set_tb;
    reg [5:0] minutes_SW; 
    reg [4:0] hours_SW;
    reg time_set_enable;
    // Outputs
    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [4:0] hours;
    wire [1:0] am_pm;
    
    
    // Instantiate the Unit Under Test (UUT)
    digital_clock uut_a(
            .clk(Clk_1sec), .reset(reset), .set_am_pm(am_pm_set_tb),
            .set_enable(time_set_enable), .minutes_SW(minutes_SW), .hours_SW(hours_SW), 
            .seconds_clock(seconds), .minutes_clock(minutes), .hours_clock(hours), 
            .am_pm_clock(am_pm)
            );
    
    //Generating the Clock with `1 Hz frequency
    initial Clk_1sec = 0;
    always #0.001 Clk_1sec = ~Clk_1sec;  //1Mhz 

    initial begin
        reset = 1;
        // Wait 100 ns for global reset to finish
        #10;
        reset = 0;
        minutes_SW = 6'b000001;//1
        hours_SW  = 6'b11011;
        am_pm_set_tb = 6'b11;
        am_pm_set_tb = 1;
        time_set_enable = 1;
        #10;
        time_set_enable=0;
        #10;
        minutes_SW = 6'b111011;//11
        hours_SW  = 6'b01011;//59
        am_pm_set_tb = 6'b11;
        am_pm_set_tb = 1;
        time_set_enable=1;
        #10;
        time_set_enable = 0;
    end      
endmodule