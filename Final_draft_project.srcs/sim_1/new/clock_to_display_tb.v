`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos
// 
// Create Date: 11/09/2021 07:43:54 PM
// Design Name: seven segment display module
// Module Name: clock_to_display_tb
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: tests the clock to display module
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_to_display_tb(

    );
    
    reg clock_100Mhz_tb; // 100 Mhz clock source on Basys 3 FPGA
    reg reset_tb; // reset  
    reg [7:0] seconds_tb;
    reg [7:0] minutes_tb;
    reg [7:0] hours_tb;
    reg [1:0] am_pm_tb;
    wire [7:0] anodes_tb,cathodes_tb; // cathode patterns of the 7-segment LED display
    
    clock_to_display uut(
     .clock_100Mhz(clock_100Mhz_tb),
     .am_pm(am_pm_tb),
     .reset(reset_tb),       
     .seconds(seconds_tb),
     .minutes(minutes_tb),
     .hours(hours_tb),
     .anodes(anodes_tb), // anode signals of the 7-segment LED display
     .cathodes(cathodes_tb) // cathode patterns of the 7-segment LED display
    );

        always #0.001 clock_100Mhz_tb = ~clock_100Mhz_tb;  //Every 0.5 sec toggle the clock.
        integer h,m,s;
        initial begin
            clock_100Mhz_tb = 0;
            reset_tb = 1;
            // Wait 100 ns for global reset to finish
            #1;
            reset_tb = 0;
            am_pm_tb = 1;
            for(h=1;h<=13;h=h+1) begin
                for(m=0;m<=60;m=m+1) begin
                    for(s=0;s<=60;s=s+1) begin
                        hours_tb = h;
                        minutes_tb = m;
                        seconds_tb = s;
                        #100;
                    end
                end    
            end
            $finish;
        end
    
    
endmodule
