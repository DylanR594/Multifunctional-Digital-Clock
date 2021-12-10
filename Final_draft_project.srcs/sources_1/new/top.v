`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos, Jason Jingco, Jose Reyes
// 
// Create Date: 12/01/2021 01:44:20 PM
// Design Name: top
// Module Name: top
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: Controls the inputs and outputs of the entire module which are 
//              mapped to the FPGA board through a constraint file. 
//              Makes use of a mux to select the output connected to the display module.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clock_100Mhz, // 100 Mhz clock 
    input reset_top,
    input set_clock,    //sets clock with button
    input set_alarm,    //sets alarm with button
    input enable_alarm, //enables the alarm to trigger
    input am_pm_SW,     //sets 0:AM , 1:PM
    input stop_stopW,   //stops timer of the stop watch when its active high
    input [1:0] mode_SW,    //4 modes
    input [5:0] minutes_SW, //minutes input from switches in binary
    input [4:0] hours_SW,   //hours input from switches in binary
    output [2:0] alarm_RGB, //signals when alarm is ready
    output [7:0] anodes_top, // anode signals of the 7-segment LED display
    output [7:0] cathodes_top // cathode patterns of the 7-segment LED display
    );
    
    // Top outputs
    reg [5:0] seconds_top;
    reg [5:0] minutes_top;
    reg [4:0] hours_top;
    reg [1:0] am_pm_top;
    // Clock
    wire [5:0] seconds_clock;
    wire [5:0] minutes_clock;
    wire [4:0] hours_clock;
    wire [1:0] am_pm_clock; 
    // Alarm
    wire [5:0] seconds_alarm;
    wire [5:0] minutes_alarm;
    wire [4:0] hours_alarm;
    wire [1:0] am_pm_alarm;
    // Military
    wire [5:0] seconds_military;
    wire [5:0] minutes_military;
    wire [4:0] hours_military;
    wire [1:0] am_pm_military;
    // Stopwatch
    wire [5:0] seconds_stopwatch;
    wire [5:0] minutes_stopwatch;
    wire [4:0] hours_stopwatch;
    wire [1:0] am_pm_stopwatch;
      
    always @(*) begin
        case(mode_SW)
          2'b00 : begin // Assign Display to Clock
            seconds_top = seconds_clock;
            minutes_top = minutes_clock;
            hours_top = hours_clock;
            am_pm_top = am_pm_clock;
            end
          2'b01: begin // Assign Display to Alarm
            seconds_top = seconds_alarm;
            minutes_top = minutes_alarm;
            hours_top = hours_alarm;
            am_pm_top = am_pm_alarm;//not set
            end
          2'b10: begin // Assign Display to Military
            seconds_top = seconds_military;
            minutes_top = minutes_military;
            hours_top = hours_military;
            am_pm_top = am_pm_military;
            end
          2'b11: begin // Assign Display to Stopwatch
            seconds_top = seconds_stopwatch;
            minutes_top = minutes_stopwatch;
            hours_top = hours_stopwatch;
            am_pm_top = am_pm_stopwatch;//not set, default to 0 on display
            end 
        endcase
    end
    
    // Instantiaion of Modules
    digital_clock uut_a(
        .clk(clock_100Mhz), .reset(reset_top), .set_am_pm(am_pm_SW),
        .set_enable(set_clock), .minutes_SW(minutes_SW), .hours_SW(hours_SW),
        .seconds_clock(seconds_clock), .minutes_clock(minutes_clock), .hours_clock(hours_clock), .am_pm_clock(am_pm_clock)
        );
   
    alarm_clock uut_al(
        .clk(clock_100Mhz), .reset(reset_top), .set_alarm(set_alarm), .minutes_SW(minutes_SW), .hours_SW(hours_SW), 
        .seconds_alarm(seconds_alarm), .minutes_alarm(minutes_alarm), .hours_alarm(hours_alarm), .c_minutes(minutes_clock),
        .c_hours(hours_clock), .Alarm(alarm_RGB), .am_pm_digital_clock(am_pm_clock), .set_am_pm(am_pm_SW), 
        .am_pm_alarm_out(am_pm_alarm), .enable_alarm(enable_alarm)
        );
         
    clock_to_display uut(
        .clock_100Mhz(clock_100Mhz), .reset(reset_top), .seconds(seconds_top), 
        .minutes(minutes_top), .hours(hours_top), .am_pm(am_pm_top), 
        .anodes(anodes_top), .cathodes(cathodes_top) 
        );
    
    military_digital_clock uut2(
       .clock_100Mhz(clock_100Mhz), .reset(reset_top), .am_pm(am_pm_clock),  
       .minutes_clock(minutes_clock), .hours_clock(hours_clock), .seconds_clock(seconds_clock),
       .seconds_military(seconds_military), .minutes_military(minutes_military), .hours_military(hours_military), 
       .am_pm_military(am_pm_military)
       );    
    
    stopwatch uut3(
      .clk(clock_100Mhz), .reset(reset_top), .stop(stop_stopW), .seconds_stopwatch(seconds_stopwatch), 
      .minutes_stopwatch(minutes_stopwatch), .hours_stopwatch(hours_stopwatch), .am_pm_stopwatch(am_pm_stopwatch)
      );
              
endmodule
