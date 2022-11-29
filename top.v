`timescale 1ns / 1ps
module top(clk,reset,led,digi,UART_RX,UART_TX);
input clk;
input reset;
output [7:0] led;
output [11:0] digi;
input UART_RX;
output UART_TX;
//wire clk_div;
//watchmaker ww(clk,clk_div);
CPU cpu(clk,reset,led,digi,UART_RX,UART_TX);
endmodule
