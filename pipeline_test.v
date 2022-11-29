module pipeline_test();
reg clk;
reg reset;
wire uart_tx;
reg uart_rx;
wire [7:0] led;
wire [11:0] digi;
reg sysclk;
parameter T=104160;
initial begin
reset = 0;
sysclk=0;
#91 reset = 1;
#6000000 $stop;
end
always #5 sysclk=~sysclk;
initial
begin
uart_rx=1;
#(10*T) uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=1;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=1;
#(T) uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=1;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=0;
#T uart_rx=1;
end
CPU cpu(.sys_clk(sysclk),.reset(reset),.led(led),.digi(digi),.UART_RX(uart_rx),.UART_TX(uart_tx));
endmodule