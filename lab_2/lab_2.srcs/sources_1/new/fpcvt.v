`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2024 02:11:22 PM
// Design Name: 
// Module Name: fpcvt
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


module fpcvt(
    input clk,
    input [11:0] D,
    output S,
    output [2:0] E,
    output [3:0] F
    );
    
    // ----- First block-------
    assign S = D[11];
    
    reg[11:0] D_tmp;
    
      reg[2:0] exp;
      integer index_leading0;
      reg[3:0] Sig;
      integer i;
      always @(D) begin
              
      // negate if negative
          if (S)
              D_tmp = ~D + 1;
          else
              D_tmp = D;
          #100

      // ----- next block: count leading 0 -------
                  
          

        exp = 0;
        index_leading0 = 0;
            
                #100
        for (i=5; i<=11; i=i+1) begin
            if (D_tmp[i]) begin
                index_leading0 = i;
                exp = 8 - (12-i-1);
            end
           end
        //for (i=1; i<=7; i=i+1)
        //    if (D_tmp[i+3]) exp <= i;
            
        
        #1000
            
     // ----- next block: get first four bits -------

        if (index_leading0 == 0)
            Sig = 4'b0000 | D_tmp[index_leading0];
        else if (index_leading0 == 1)
                        Sig = 4'b0000 | D_tmp[index_leading0 -:2]; 
                else if (index_leading0 == 2)
                                Sig = 4'b0000 | D_tmp[index_leading0 -:3];
                        else Sig = D_tmp[index_leading0 -:4];
        #1000
        //$display("got: inp - %b : %b:%b: 1st 4-bits %b, index %d",D_tmp, S, exp, Sig,index_leading0);
        if (D_tmp[index_leading0 - 4] == 1) begin
                //$display("if 0");
                if (Sig == 4'b1111 && exp < 7) begin
                    //$display("if 1");
                    Sig = 0;
                    exp = exp + 1;
                end else if (Sig < 4'b1111) begin
                    Sig = Sig + 1;
                end
       end       
      //$display("got: inp - %b : %b:%b: 1st 4-bits %b, index %d",D, S, exp, Sig,index_leading0);

     end
   assign E = exp;
   assign F = Sig;
endmodule
