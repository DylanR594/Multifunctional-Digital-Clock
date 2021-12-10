`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 05:22:40 PM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(
    input clk,  //Clock
    input reset,
    input stop,
    output reg [5:0] seconds_stopwatch,
    output reg [5:0] minutes_stopwatch,
    output reg [4:0] hours_stopwatch,
    output reg [1:0] am_pm_stopwatch
    );
    reg [26:0] counter;
    wire enable;// one second enable for counting numbers
    
    always @(posedge clk)
            begin
                if(reset==1)
                    counter <= 0;
                else begin
                    if(counter>=99999999) 
                        counter <= 0;
                    else if(!stop)
                        counter <= counter + 1;
                    end
                end      
    assign enable = (counter==99999999)?1:0;
    
        always @(posedge clk) //always activate on positive edge of clock, must be 0.5 sec
        begin
                if(reset) begin  //if reset = 1  reset to default
                    seconds_stopwatch = 0;
                    minutes_stopwatch = 0;
                    hours_stopwatch = 0;  //set hours to zero
                    am_pm_stopwatch = 2'b01; // set AM/PM to default case to display 0's
                    end
                else if(enable) begin        //each second
                    seconds_stopwatch = seconds_stopwatch + 1;              //increment seconds
                    if(seconds_stopwatch == 60) begin    //check if seconds = 60
                        seconds_stopwatch <= 0;                   //reset seconds
                        minutes_stopwatch = minutes_stopwatch + 1;          //increment minutes
                        if(minutes_stopwatch == 60) begin //check if minutes = 60
                            minutes_stopwatch <= 0;               //reset minutes
                        end
                    end     
                end
            end   
endmodule
