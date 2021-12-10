`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos
// 
// Create Date: 11/09/2021 07:43:54 PM
// Design Name: 
// Module Name: digital_clock
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: 12 hour clock keeps accurate track of real time through different outpus for hours, minutes, and seconds
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module digital_clock(
    input clk,  //Clock
    input reset,
    input set_am_pm,
    input set_enable,
    input [5:0] minutes_SW,
    input [4:0] hours_SW,
    output reg [5:0] seconds_clock,
    output reg [5:0] minutes_clock,
    output reg [4:0] hours_clock,
    output reg [1:0] am_pm_clock

    );
    reg [26:0] counter;
    wire enable; //enables the clock to increment
    
    reg [5:0]seconds;
    reg [5:0]minutes;
    reg [4:0]hours;
    reg [1:0] am_pm;
    always @(posedge clk)   begin   //increments clock based of 1Mhz clock
                if(reset==1)
                    counter <= 0;
                else begin
                    if(counter>=99999999) 
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end
                end      
    assign clk_enable = (counter==99999999)?1:0;
    
    always @(posedge clk) begin
                if(reset) begin  //if reset = 1 
                    seconds = 0;
                    minutes = 0;
                    hours = 12;  
                    am_pm = 2'b00;  //LED

                    end
                else if(set_enable) begin   //if time set is enabled
                    hours = 12;
                    seconds = 0;
                    minutes = 59;
                    if(set_am_pm==1)begin
                        am_pm = 2'b11;

                        end
                    else if(set_am_pm==0)begin
                        am_pm = 2'b00;

                        end
                    if(minutes_SW < 60)begin    //must be within limit
                        minutes = minutes_SW;
                        end
                    if((hours_SW<=12)&&(hours_SW>0))begin       //must be within limit
                        hours = hours_SW;
                        end
                    end
                else if(clk_enable) begin        
                    seconds = seconds + 1;      //increment seconds
                    if(seconds == 60) begin           //check if seconds = 60
                        seconds <= 0;                 //reset seconds
                        minutes = minutes + 1;  //increment minutes
                        if(minutes == 60) begin       //check if minutes = 60
                            minutes <= 0;             //reset minutes
                            hours = hours + 1;  //increment hours
                           if(hours == 12) begin      //when hits 12 change am/pm                                
                                am_pm = ~am_pm; // RGB=RED

                                end
                           if(hours == 13) begin      //check if hours = 13
                                hours <= 1 ;          //reset hours
                           end 
                        end
                    end     
                end
                hours_clock <= hours;
                minutes_clock <= minutes;
                seconds_clock <= seconds;
                am_pm_clock <= am_pm;
    end                                       
        
        
endmodule