`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos
// 
// Create Date: 11/09/2021 07:43:54 PM
// Design Name: 24-hour clock
// Module Name: military_digital_clock
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: takes in input for hours,minutes,seconds, from the digital clock 
//              and converts it to 24 hour based on the time of day(am/pm)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module military_digital_clock(
  input clock_100Mhz,  //Clock
  input reset,
  input [1:0] am_pm,
  input [5:0] minutes_clock,
  input [4:0] hours_clock,
  input [5:0] seconds_clock,
  output reg [5:0] seconds_military,
  output reg [5:0] minutes_military,
  output reg [4:0] hours_military,
  output reg [1:0]am_pm_military
  );

  reg [5:0]seconds;
  reg [5:0]minutes;
  reg [4:0]hours;
  
  always @(posedge clock_100Mhz) begin   //increments clock based of 1Mhz clock
    if(reset==1)begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
    end
    seconds <= seconds_clock;
            minutes <= minutes_clock;
            hours <= hours_clock;
    if(am_pm==2'b11)begin
        if((hours+12)==24)
            hours = 0;
        else
            hours = hours+12;
    end
    hours_military <= hours;
    minutes_military <= minutes;
    seconds_military <= seconds;
    am_pm_military <= 2'b01;
  end                                       
            
endmodule