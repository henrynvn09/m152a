`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2024 03:42:09 PM
// Design Name: 
// Module Name: tb
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


module tb;
    reg clk;
    
    reg[11:0] D;
    wire       S;
    wire[2:0]  E;
    wire[3:0]  F;
    
   fpcvt func (     .clk(clk),
                    .D(D),
                    .S(S),
                    .E(E),
                    .F(F));
  initial
    begin
        clk = 0;
        #100;
        
        D = 12'b000001111101;
                #4000
        $display("%b : %b %b %b",D, S, E, F);

        D = 12'b011111111111;
        #4000
        $display("%b : %b %b %b",D, S, E, F);
        
        D = 12'b000110100110;
                #4000
                $display("%b : %b %b %b",D, S, E, F);
        
        D = 12'b111111111111;
        #4000
                $display("%b : %b %b %b",D, S, E, F);
        
                #1000
        $finish;
     end
         
         
   always #5 clk = ~clk;

endmodule


