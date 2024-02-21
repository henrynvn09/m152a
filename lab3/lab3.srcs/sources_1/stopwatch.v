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
    input btnPAUSE_BOARD,
    input btnRST, 
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    
    
    reg [31:0] clkCounter500, clkCounter2, clkCounter14, clkCounter1;
    
    reg clk500, clk2, clk14, clk1;
    // clk14: blinking in adj mode
    // clk500: displaying
    
    reg inc;
    integer disp;
    
    reg btnPAUSE;
    reg prevPAUSE;
    initial begin
        clkCounter500 = 32'd0;
        clkCounter14 = 32'd0;
        clkCounter2 = 32'd0;
        clkCounter1 = 32'd0;
        
        inc = 32'd1;
        
        disp = 0;
        
        btnPAUSE = 0;
        prevPAUSE = 0;
    end
    
    integer sec10, sec1, min10, min1;
    integer sec, min;

    // clock increment
    always @(posedge clk or posedge btnRST) begin
        if (btnRST) begin
            clkCounter500 = 0;
            clkCounter14 = 0;
            clkCounter2 = 0;
            clkCounter1 = 0;
            sec = 0;
            min = 0;
        end
        else begin
                  
                clkCounter500 = clkCounter500 + 32'd1;
                clkCounter14 = clkCounter14 + 32'd1;
                clkCounter2 = clkCounter2 + 32'd1;
                if (btnPAUSE == 0 && ADJ == 0) clkCounter1 = clkCounter1 + 32'd1;
                
                
                // for 500 hz
                if (clkCounter500 >= 32'd200000) begin
                    clk500 = ~clk500;
                    clkCounter500 = 32'd0;
                    
                    sec10 = sec /10;
                    sec1 = sec % 10;
                    min10 = min/10;
                    min1 = min % 10;
                    
                    case (disp)
                        0: begin
                            if (clk14 && ADJ && SEL) begin
                                an = 4'b1111;
                            end else an = 4'b1110;
                            seg = seven_segment_decoder(sec1);
                        end
                        1: begin
                            if (clk14 && ADJ && SEL) begin
                                an = 4'b1111;
                            end else an = 4'b1101;
                            seg = seven_segment_decoder(sec10);
                        end
                        2: begin
                            if (clk14 && ADJ && ~SEL) begin
                                an = 4'b1111;
                            end else an = 4'b1011;
                            seg = seven_segment_decoder(min1);
                        end
                        3: begin
                            if (clk14 && ADJ && ~SEL) begin
                                an = 4'b1111;
                            end else an = 4'b0111;
                            seg = seven_segment_decoder(min10);
                        end
                     endcase
                     disp = (disp+1) % 4;
                    
        
                end
                    
        
                // for 2 hz
                if (clkCounter2 >= 32'd50000000) begin
                    clk2 = ~clk2;
                    clkCounter2 = 32'd0;
                     
                     
                    // adjust mode increment
                    if (ADJ == 1) begin
                        if (SEL == 1) begin
                            // flash in second       
                            sec = (sec + 1) % 60;
                        end else begin
                            // flash in minute  
                            min = (min + 1) % 60;
                        end
                    end
                    
                end
                    
                // for 1.4 hz
                if (clkCounter14 >= 32'd25000000) begin
                    clk14 = ~clk14;
                    clkCounter14 = 32'd0;
                end
                
                // for 1 hz
                if (clkCounter1 >= 32'd100000000) begin
                    clk1 = ~clk1;
                    clkCounter1 = 32'd0;
                    
                    sec = sec + 1;
                    if (sec == 60) begin
                        sec = 0;
                        min = min + 1;
                        if (min == 60) min = 0;
                    end
                end
                
        end 
    end
    
    
    
    // --------------- Display 7 segment bits ---------------
    function [6:0] seven_segment_decoder;
        input [3:0] digit;
        begin
            case(digit)
                0: seven_segment_decoder=~7'b011_1111;
                1: seven_segment_decoder=~7'b000_0110;
                2: seven_segment_decoder=~7'b101_1011;
                3: seven_segment_decoder=~7'b100_1111;
                4: seven_segment_decoder=~7'b110_0110;
                5: seven_segment_decoder=~7'b110_1101;
                6: seven_segment_decoder=~7'b111_1101;
                7: seven_segment_decoder=~7'b000_0111;
                8: seven_segment_decoder=~7'b111_1111;
                9: seven_segment_decoder=~7'b110_1111;
            endcase
         
        end
    endfunction
    
    
//      always @(posedge btnPAUSE_BOARD) begin
//        btnPAUSE = ~btnPAUSE;
//      end
    always @(posedge clkCounter500) begin
        if (prevPAUSE == 0 && btnPAUSE_BOARD == 1) begin
            btnPAUSE = ~btnPAUSE;
        end
        prevPAUSE = btnPAUSE_BOARD;
    end
    // --------------- handle adjust ---------------
//    always @(posedge clk2) begin
//    end
//    always @(posedge clk2) begin
//        if (ADJ) begin
            
//        end
//    end
    
    
    
    
endmodule
