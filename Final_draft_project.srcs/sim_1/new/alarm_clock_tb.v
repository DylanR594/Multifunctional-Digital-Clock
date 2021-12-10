`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2021 09:33:02 PM
// Design Name: 
// Module Name: alarm_clock_tb
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


module alarm_clock_tb();
    
    // Inputs
    reg Clk_1sec;
    reg reset;
    reg enable_alarm;
    reg am_pm_SW;
    reg [1:0] am_pm_clock_in;
    reg set_alarm_button;
    reg [5:0] minutes_clock;
    reg [5:0] hours_clock;
    reg [5:0] minutes_SW, hours_SW;
    // Outputs
    wire [1:0] alarm_am_pm;
    wire [5:0] minutes_alarm;
    wire [4:0] hours_alarm;
    wire [2:0] alarm_RGB;
     
    
    alarm_clock uut5(
        .clk(Clk_1sec), .reset(reset), .set_alarm(set_alarm_button), .minutes_SW(minutes_SW), .hours_SW(hours_SW), 
        .minutes_alarm(minutes_alarm), .hours_alarm(hours_alarm), .c_minutes(minutes_clock),
        .c_hours(hours_clock), .Alarm_tb_out(alarm_RGB), .am_pm_digital_clock(am_pm_clock_in), .set_am_pm(am_pm_SW), .am_pm_alarm_out(alarm_am_pm), 
        .enable_alarm(enable_alarm)
        );
    
        
    initial Clk_1sec = 0;
    localparam CLK_PERIOD = 10;
    localparam period = 10;
    
    always Clk_1sec =  #(CLK_PERIOD/2) ~Clk_1sec;  
    integer i = 0;
    initial begin
        reset = 1;
        #period;
        reset = 0;
                
        for(i = 1; i < 13; i = i + 1) begin
            #period;
            // Test if enable_alarm switch is active and {alarm_time, pm} = {digital_time, pm} 
            // Set input values
            minutes_clock = 0;
            hours_clock = 2;
            am_pm_clock_in = 2'b11;  
            minutes_SW = 0;
            hours_SW = i;
            am_pm_SW = 1; // set to PM
            set_alarm_button = 1;
            enable_alarm = 1;
            #period
            if(alarm_RGB > 0 && {hours_alarm, minutes_alarm, alarm_am_pm} == {hours_clock, minutes_clock, am_pm_clock_in})
                $display("Test if enable_alarm switch is active and {alarm_time, pm} = {digital_time, pm} : PASSED.");
                       
            #period;
            // Test if enable_alarm switch is inactive and {alarm_time, pm} = {digital_time, pm}
            // Set input values
            minutes_clock = 0;
            hours_clock = 3;
            am_pm_clock_in = 2'b11;     
            minutes_SW = 0;
            hours_SW = i;
            am_pm_SW = 1; // // set to PM
            set_alarm_button = 1;
            enable_alarm = 0;
            #period;
            if(alarm_RGB == 0 && {hours_alarm, minutes_alarm, alarm_am_pm} == {hours_clock, minutes_clock, am_pm_clock_in})
                $display("Test if enable_alarm switch is inactive and {alarm_time, pm} = {digital_time, pm}: PASSED.");
            
            #period;
            // Test if enable_alarm switch is active and {alarm_time, am} = {digital_time, am} 
            // Set input values
            minutes_clock = 30;
            hours_clock = 4;
            am_pm_clock_in = 2'b00;     
            minutes_SW = 30;
            hours_SW = i;
            am_pm_SW = 0; // set to AM
            set_alarm_button = 1;
            enable_alarm = 1;
            #period;
            if(alarm_RGB > 0 && {hours_alarm, minutes_alarm, alarm_am_pm} == {hours_clock, minutes_clock, am_pm_clock_in})
                $display("Test if enable_alarm switch is active and {alarm_time, am} = {digital_time, am}: PASSED.");
            
            #period;       
            // Test if enable_alarm switch is active and {alarm_time, am} == {digital_time, am} 
            // Set input values
            minutes_clock = 55;
            hours_clock = 6;
            am_pm_clock_in = 2'b00;     
            minutes_SW = 55;
            hours_SW = i;
            am_pm_SW = 0; // set to AM
            set_alarm_button = 1;
            enable_alarm = 1;
            #period;
            if(alarm_RGB > 0 && {hours_alarm, minutes_alarm, alarm_am_pm} == {hours_clock, minutes_clock, am_pm_clock_in})
                $display("Test if enable_alarm switch is active and {alarm_time, am} = {digital_time, am}: PASSED.");    
                                  
        end
    end    
endmodule
