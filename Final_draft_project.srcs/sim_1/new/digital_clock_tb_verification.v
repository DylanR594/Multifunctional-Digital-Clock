`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos
// 
// Create Date: 11/09/2021 07:43:54 PM
// Design Name: digital_clock_tb_verification
// Module Name: digital_clock_tb_verification
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: tests the clock module using erification methods
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module digital_clock_tb_verification(

    );
 // Inputs
       reg Clk_1sec;
       reg reset;
       reg am_pm_set_tb;
       reg [5:0] minutes_SW_tb; 
       reg [4:0] hours_SW_tb;
       reg time_set_enable_tb;
       // Outputs
       wire [5:0] seconds;
       wire [5:0] minutes;
       wire [4:0] hours;
       wire [1:0] am_pm;
       
       
       // Instantiate the Unit Under Test (UUT)
       digital_clock uut_a(
               .clk(Clk_1sec), .reset(reset), .set_am_pm(am_pm_set_tb),
               .set_enable(time_set_enable_tb), .minutes_SW(minutes_SW_tb), .hours_SW(hours_SW_tb), 
               .seconds_clock(seconds), .minutes_clock(minutes), .hours_clock(hours), 
               .am_pm_clock(am_pm)
               );
       
       //Generating the Clock with `1 Hz frequency
       initial Clk_1sec = 0;
       always #0.001 Clk_1sec = ~Clk_1sec;  //1Mhz 
   
       initial begin
           reset = 1;
           // Wait 100 ns for global reset to finish
           //test if set works
           #10;
           
           reset = 0;      
           minutes_SW_tb = 6'b000001;//1
           hours_SW_tb  = 6'b1011; //11
           am_pm_set_tb = 1;
           time_set_enable_tb = 1;
           #20;                  
           if ((hours == hours_SW_tb) && (minutes == minutes_SW_tb))begin
                $display(minutes_SW_tb, hours_SW_tb,"Passed.");                
           end  
           else begin
                $display(minutes_SW_tb, hours_SW_tb,"Failed.");
           end
           #20;
           
            //set is off
           minutes_SW_tb = 6'b000000;//1
           hours_SW_tb  = 6'b0000; //11
           am_pm_set_tb = 1;
           time_set_enable_tb=0;   //time set is not enabled
           #10;                    
           if ((hours != hours_SW_tb) && (minutes != minutes_SW_tb))begin //should not be equal
                $display(minutes_SW_tb, hours_SW_tb,"Passed.");                
           end  
           else begin
                $display(minutes_SW_tb, hours_SW_tb,"Failed.");
           end           
           #20;
           
           
           minutes_SW_tb = 6'b001110;//11
           hours_SW_tb  = 6'b0010;//2
           am_pm_set_tb = 0;
           time_set_enable_tb=1;
           #10;
           if ((hours == hours_SW_tb) && (minutes == minutes_SW_tb))begin //should be equal
                $display(minutes_SW_tb, hours_SW_tb,"Passed.");                
           end  
           else begin
                $display(minutes_SW_tb, hours_SW_tb,"Failed.");
           end  
           #20;
           
           //testing to see if input is greater than max
           minutes_SW_tb = 6'b111111;//63
           hours_SW_tb  = 6'b11111;//31
           am_pm_set_tb = 1;
           time_set_enable_tb=1;
           #10;
           if ((hours == 12) && (minutes == 59))begin //should be max at 12:59
                $display(minutes_SW_tb, hours_SW_tb,"Passed.");                
           end  
           else begin
                $display(minutes_SW_tb, hours_SW_tb,"Failed.");
           end  
       end      
   endmodule
