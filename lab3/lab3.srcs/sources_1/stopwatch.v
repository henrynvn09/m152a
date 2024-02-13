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


module stopwatch(
    input clk,
    input SEL,
    input ADJ,
    input btnPAUSE,
    input btnRST, 
    output [6:0] seg,
    output [3:0] an
    );
    
    reg [26:0] clkCounter500, clkCounter2, clkCounter14, clkCounter1;
    
    reg clk500, clk2, clk14, clk1;
    
    reg inc;
        
        
    initial begin
        clkCounter500 =0;
        clkCounter14 =0;
        clkCounter2 =0;
        clkCounter1 =0;
        
        inc = 1;
    end
    
    
    // clock increment
    always @(posedge clk) begin
        clkCounter500 = clkCounter500 + inc;
        clkCounter14 = clkCounter14 + inc;
        clkCounter2 = clkCounter2 + inc;
        clkCounter1 = clkCounter1 + inc;
        
        // for 500 hz
        if (clkCounter500 == 200000) begin
            clk500 = ~clk500;
            clkCounter500 = 0;
        end
            

        // for 2 hz
        if (clkCounter2 == 50000000) begin
            clk2 = ~clk2;
            clkCounter2 = 0;
        end
            
        // for 1.4 hz
        if (clkCounter14 == 70000000) begin
            clk14 = ~clk14;
            clkCounter14 = 0;
        end
        
        // for 1 hz
        if (clkCounter1 == 100000000) begin
            clk1 = ~clk1;
            clkCounter1 = 0;
        end
                        
    end
    
    integer sec, min;
    always @(posedge clk1) begin
        sec = sec + 1;
        if (sec == 60) begin
            sec = 0;
            min = min + 1;
            if (min == 60) min = 0;
        end
    end
    
    
    // Display 7 segment bits
    module seven_segment_decoder(
        input [3:0] decimal_digit,
        output [6:0] seven_segment_output
    );
     
    // Define the inverted 7-segment representation for each decimal digit
    //            A
    //          -----
    //       F |     | B
    //         |  G  |
    //          -----
    //       E |     | C
    //         |     |
    //          -----
    //            D
     
    // Inverted seven-segment representation for digits 0 to 9
    parameter [6:0] inverted_seven_segment_data [0:9] = {
        7'b011_1111, // 0
        7'b000_0110, // 1
        7'b101_1011, // 2
        7'b100_1111, // 3
        7'b110_0110, // 4
        7'b110_1101, // 5
        7'b111_1101, // 6
        7'b000_0111, // 7
        7'b111_1111, // 8
        7'b110_1111  // 9
    };
     
    // Output the inverted 7-segment representation based on the input decimal digit
    assign seven_segment_output = inverted_seven_segment_data[decimal_digit];
     
    endmodule

    
    
    // handle adjust
    always @(ADJ) begin
        inc = ~inc;
    end
    always @(posedge clk2) begin
        if (ADJ) begin
            
        end
    end
    
    
    
    
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
