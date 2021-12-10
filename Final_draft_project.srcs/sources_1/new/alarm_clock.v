`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2021 10:19:45 PM
// Design Name: 
// Module Name: Alarm_Clock
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


module alarm_clock(
 input reset, 
 input clk, 
 input set_alarm,  // sets the alarm
 input [1:0] am_pm_digital_clock, // gets the am_pm from digit_clock module
 input set_am_pm,  // sets the alarm to 0=AM or 1=PM 
 input enable_alarm, // enable and disable's the alarm
 input [5:0] minutes_SW,  c_minutes,
 input [4:0] c_hours, hours_SW,
 output reg [1:0]am_pm_alarm_out, // outputs the am_pm_alarm
 output reg [2:0] Alarm, // outputs the alarm using one of the RGB leds
 output reg [2:0] Alarm_tb_out, // used to output the RGB leds of the test bench
 // outputs the alarm time
 output reg [5:0] seconds_alarm, minutes_alarm, 
 output reg [4:0] hours_alarm
 );
 
// Internal parameters for flashing the Alarm led
integer led_flash_counter = 0;
 
// Set Alarm Clock Operation
 always @(posedge clk or posedge reset) begin
    if(reset) begin 
        seconds_alarm = 0;
        minutes_alarm = 0;
        hours_alarm = 12;
        am_pm_alarm_out = 1'b00; // default am_pm_alarm_out to 00=AM
    end 
    else if(set_alarm) begin
        if(set_am_pm==1) 
            am_pm_alarm_out = 2'b11; // sets to 11=PM
        else if(set_am_pm==0) 
            am_pm_alarm_out = 2'b00; // set to 00=AM
        if(minutes_SW < 60) 
            minutes_alarm = minutes_SW;
        if((hours_SW<=12)&&(hours_SW>0)) // must be within limit 
            hours_alarm = hours_SW; 
    end
end 
 
//Alarm functionality
 always @(posedge clk or posedge reset) begin
    if(reset) begin
        Alarm <= 0;
        led_flash_counter <= 0;
    end
    else begin
        if({hours_alarm, minutes_alarm, am_pm_alarm_out}=={c_hours, c_minutes, am_pm_digital_clock} && enable_alarm == 1) begin
           Alarm_tb_out = 3'b111; // used for test bench output
           if(led_flash_counter) begin
                if(led_flash_counter < 100000000) begin
                    led_flash_counter <= led_flash_counter + 1;
                end
                else begin
                    led_flash_counter <= 0;
                    Alarm <= ~Alarm;
                end
           end
           else begin
                if(led_flash_counter < 100000000) begin
                    led_flash_counter <= led_flash_counter + 1;
                end
                else begin
                    led_flash_counter <= 0;
                    Alarm <= ~Alarm;
                end                
           end
       end
      else begin
           Alarm <= 0;
           Alarm_tb_out = 3'b000; // used for test bench output
      end
   end
 end
 
endmodule
