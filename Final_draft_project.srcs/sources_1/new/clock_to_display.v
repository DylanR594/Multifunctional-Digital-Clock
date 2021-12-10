`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: California State University Long Beach
// Engineer: Dylan Ramos
// 
// Create Date: 11/09/2021 07:43:54 PM
// Design Name: seven segment display module
// Module Name: clock_to_display
// Project Name: Multifunctional Digital Clock
// Target Devices: Nexys A7 100T FPGA board
// Tool Versions: Vivado 2016.2
// Description: takes in input for hours,minutes,seconds, am/pm indicator and 
//              converts it to an output the FPGA board can process on the seven segment display
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module clock_to_display(
    input clock_100Mhz, // 100 Mhz clock 
    input reset,
    input [1:0] am_pm, 
    input [5:0] seconds,
    input [5:0] minutes,
    input [4:0] hours,
    output reg [7:0] anodes, // anode signals of the 7-segment LED display
    output reg [7:0] cathodes // cathode patterns of the 7-segment LED display
    );

    reg [3:0] decimal_to_BCD;   //converts number from seconds,minutes,hours and converts to digit on 7seg
    reg [19:0] refresh_cnt;     //counter used to refresh display 2.6ms per digit                   
    wire [2:0] anode_counter;   //used to choose which anode to activate
            
    always @(posedge clock_100Mhz or posedge reset)
        begin 
            if(reset==1)
                refresh_cnt <= 0;
            else
                refresh_cnt <= refresh_cnt + 1;
        end 
    assign anode_counter = refresh_cnt[19:17];
     
     // decoder to activate anode signals 
     always @(*)
     begin
         case(anode_counter)
         3'b000: begin      //0 activates, 1 deactivates due to negative logic 
             anodes = 8'b1111_1110;                           // activate LED0
             decimal_to_BCD = 0; //"_" symbol 
             end
         3'b001: begin
             anodes = 8'b1111_1101;  //sets A or P for am/pm  // activate LED1 
             case(am_pm)
                2'b00: begin
                    decimal_to_BCD = 4'b1010; //decoder sets it to A for AM
                    end
                2'b01:begin
                    decimal_to_BCD = 4'b0000; //decoder sets it to 0
                    end
                2'b10: begin
                    decimal_to_BCD = 4'b0000; //decoder sets it to 0
                    end    
                2'b11: begin
                    decimal_to_BCD = 4'b1011; //decoder sets it to P for PM
                    end
                default: begin
                    decimal_to_BCD = 4'b0000; //decoder sets it to 0
                    end
             endcase             

             end
         3'b010: begin
             anodes = 8'b1111_1011;                           // activate LED2 
             decimal_to_BCD = ((seconds % 1000)%100)%10;      // the first digit of the seconds
               end
         3'b011: begin
             anodes = 8'b1111_0111;                           // activate LED3 
             decimal_to_BCD = ((seconds % 1000)%100)/10;      // the second digit of seconds
               end
         3'b100: begin
             anodes = 8'b1110_1111;                           // activate LED4 
             decimal_to_BCD = ((minutes % 1000)%100)%10;      // the first digit of minutes
               end
         3'b101: begin
             anodes = 8'b1101_1111;                           // activate LED5 
             decimal_to_BCD = ((minutes % 1000)%100)/10;      // the second digit of minutes    
                end
         3'b110: begin
             anodes = 8'b1011_1111;                           // activate LED6 
             decimal_to_BCD = ((hours % 1000)%100)%10;        // the first digit hours            
                end
         3'b111: begin
             anodes = 8'b0111_1111;                           // activate LED7 
             decimal_to_BCD = ((hours % 1000)%100)/10;        // the second digit of hours             
                end               
         endcase
     end
     // Cathode patterns of the 7-segment LED display 
     always @(*)
     begin                                      
         case(decimal_to_BCD)                    //the cathodes are sequenced: abcdefgh.
         4'b0000 : cathodes = 8'b00000011;//0    // 0 = enable, 1=disable
         4'b0001 : cathodes = 8'b10011111;//1
         4'b0010 : cathodes = 8'b00100101;//2
         4'b0011 : cathodes = 8'b00001101;//3
         4'b0100 : cathodes = 8'b10011001;//4
         4'b0101 : cathodes = 8'b01001001;//5
         4'b0110 : cathodes = 8'b01000001;//6
         4'b0111 : cathodes = 8'b00011111;//7
         4'b1000 : cathodes = 8'b00000001;//8
         4'b1001 : cathodes = 8'b00001001;//9
         4'b1010 : cathodes = 8'b00010001;//A
         4'b1011 : cathodes = 8'b00110001;//P
         4'b1111 : cathodes = 8'b11101111;//"_"
         default : cathodes = 8'b00000011;
         endcase
     end
  endmodule
