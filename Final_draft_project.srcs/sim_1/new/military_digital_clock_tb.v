`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2021 10:50:43 PM
// Design Name: 
// Module Name: military_digital_clock_tb
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


module military_digital_clock_tb();
    
        // Inputs
    reg Clk_1sec;
    reg reset;
    reg [1:0] am_pm_tb;
    reg [5:0] minutes_tb, seconds_tb; 
    reg [4:0]hours_tb;
    // Outputs
    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [4:0] hours;
    wire [1:0] am_pm;

      military_digital_clock uut(
      .clock_100Mhz(Clk_1sec), .reset(reset),.am_pm(am_pm_tb),
      .minutes_clock(minutes_tb), .hours_clock(hours_tb), .seconds_clock(seconds_tb),
      .seconds_military(seconds), .minutes_military(minutes), .hours_military(hours),
      .am_pm_military(am_pm)
      );
    integer i, j, a;
      //Generating the Clock with `1 Hz frequency
    initial Clk_1sec = 0;
    always #1 Clk_1sec = ~Clk_1sec;  //1Mhz 
      

    initial begin
        reset = 1;
        #10;
        reset = 0;
        am_pm_tb = 2'b11;
        for(i = 1; i < 12; i = i + 1) begin
            hours_tb = i;
            for(j=0; j <60; j = j+1) begin
                minutes_tb = j;
                for(a=0; a <60; a = a+1) begin
                    seconds_tb = a;
                    #10;    
                    if((hours == hours_tb+12) && (minutes==minutes_tb) &&(seconds==seconds_tb)) begin
                        $display(hours_tb,minutes_tb, seconds_tb," passed. ");
                    end else begin
                        $display(hours_tb,minutes_tb, seconds_tb, " failed. ");
                        end
                    end                         
                end
            end  
            $finish;    
       end
            
endmodule              

