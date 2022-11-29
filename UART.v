`timescale 1ns/1ps
module UART_top(reset_,sysclk,cpu_clk,rd,wr,addr,wdata,UART_RX,UART_TX,rdata);
input reset_,sysclk,cpu_clk,rd,wr,UART_RX;
input [31:0] addr,wdata;
output UART_TX;
output reg [31:0] rdata;
wire reset,baud_rate_16,baud_rate,rx_status,tx_en,tx_status;

reg [31:0] UART_DATA[7:0];
reg [2:0] number_1,number_2;

wire [4:0] uart_con;
wire [7:0] rx_data,UART_TXD;
wire [3:0] temp;
wire [2:0] count;
assign temp=4'd8;
assign count=(number_1!=number_2)?1:0;
assign reset=~reset_;


integer i;
always@(posedge baud_rate_16 or posedge reset)
begin
  if(reset) begin
      number_1<=0;
for(i=0;i<8;i=i+1) UART_DATA[i]<=0;
    end
  else if(rx_status)begin
  UART_DATA[number_1]<=rx_data;number_1<=number_1+1;
end
else;
end

always@(posedge cpu_clk or posedge reset)
begin
  if(reset) number_2<=0;
  else if(rd&&addr==32'h4000001c&&uart_con[3]) number_2<=number_2+1;
  else;
end
      

always@(*)
begin
  if(rd)
    case(addr)
    32'h4000001c: rdata={24'd0,UART_DATA[number_2]};
    32'h40000020: rdata={27'b0,uart_con}; 
    32'h40000018: rdata={24'b0,UART_TXD};
    default:rdata=0;
    endcase
    else rdata=0;
    end
       
UART_Baud_rate_genetator gen(.sys_clk(sysclk),.baud_rate_16(baud_rate_16),
			.baud_rate(baud_rate));
UART_sender send(.tx_data(UART_TXD),.tx_en(tx_en),
		.baud_rate_16(baud_rate_16),.reset(reset),
		.uart_tx(UART_TX),.tx_status(tx_status));
UART_receiver rec(.uart_rx(UART_RX),.baud_rate_16(baud_rate_16),.reset(reset),.rx_data(rx_data),.rx_status(rx_status));
UART_controller contro(.clk(baud_rate_16),.cpu_clk(cpu_clk),.reset(reset),.RX_STATUS(rx_status),.TX_STATUS(tx_status),
.Addr(addr),.Wr(wr),.Rd(rd),.WriteData(wdata),.cnt(count),.TX_EN(tx_en),
.UART_CON(uart_con),.TX_DATA(UART_TXD));

		
endmodule
		
module UART_Baud_rate_genetator(sys_clk,baud_rate_16,baud_rate);

input sys_clk;
output reg baud_rate_16,baud_rate;

reg [8:0] num1;
reg [2:0] num2;

initial 
begin
num1<=0;
num2<=0;
baud_rate_16<=0;
baud_rate<=0;
end

always@(posedge sys_clk)
begin
 if(num1==162) 
  begin
   num1<=0;
   baud_rate_16<=~baud_rate_16;
  end
else num1<=num1+1;
end

always @(posedge baud_rate_16)
begin
if(num2==7)
 begin
  num2<=0;
  baud_rate<=~baud_rate;
 end 
else num2<=num2+1;
end


endmodule


module UART_controller(clk,cpu_clk,reset,RX_STATUS,TX_STATUS,Addr,Wr,Rd,WriteData,cnt,TX_EN,UART_CON,TX_DATA);
  input clk,reset,cpu_clk;
  input RX_STATUS;
  input TX_STATUS;
  input [31:0] Addr;
  input Wr,Rd;
  input [31:0] WriteData;
  input [2:0] cnt;
  output reg TX_EN;
  output [4:0] UART_CON;
  output reg [7:0] TX_DATA;
  
wire UART_CON4;
reg [2:0] UART_CONx;
reg newdata_available;
  
assign UART_CON4=~TX_STATUS;
assign UART_CON={UART_CON4,cnt,UART_CONx};
assign rst_con2=reset||TX_STATUS;

always@(posedge cpu_clk or posedge reset)
begin
  if(reset)
    TX_EN<=0; 
  else if(Addr==32'h40000018&Wr)
    begin
      TX_EN<=1;
      TX_DATA<=WriteData[7:0];
    end
  else if(TX_EN) TX_EN<=0;
end
   
always@(posedge clk or posedge rst_con2)
    begin
      if(rst_con2)
        UART_CONx[2]<=1'b1;
      else if(Addr==32'h40000020&&Wr) UART_CONx[2]<=WriteData[2];
      else if(Addr==32'h40000018&&Rd) UART_CONx[2]<=1'b0;
      else;
    end
always@(posedge clk or posedge reset)
      begin
        if(reset) UART_CONx[0]<=1;
        else if(Addr==32'h40000020&&Wr) UART_CONx[0]<=WriteData[0];
        else;
      end
        
always@(posedge clk or posedge reset)
        begin
          if(reset) UART_CONx[1]<=1;
          else if(Addr==32'h40000020&&Wr) UART_CONx[1]<=WriteData[1];
        end
          
          


endmodule


module UART_receiver(
input uart_rx,
input baud_rate_16,
input reset,
output reg [7:0] rx_data,
output reg rx_status
);

reg enable;
reg [3:0] cnt;
reg [3:0] num;
reg [7:0] data;

initial
begin 
enable<=0;
cnt<=0;
num<=0;
data<=0;
rx_data<=0;
rx_status<=0;

end
always@(posedge reset,posedge baud_rate_16)
begin
  if(reset)
    begin
    enable<=0;
    cnt<=0;
    num<=0;
    rx_data<=0;
    rx_status<=0;
    end
  else
    begin
    if(!(uart_rx)&!(enable)) enable<=1;
    if(enable)
       begin
       if(!num)
         begin
         if(cnt==7) 
           begin
           cnt<=0;
           num<=1;
           end
         else cnt<=cnt+1;
         end
       if((num!=0)&(num!=10))
         begin
         if(cnt==15)
           begin
           cnt<=0;
           data[num-1]<=uart_rx;
           num<=num+1;
           end
         else 
           begin
           cnt<=cnt+1;
           end
         end
       if(num==10)
         begin         
           enable<=0;
           num<=0;
           cnt<=0;
           rx_data<=data;
           rx_status<=1; 
         end
       end
    if(!enable) rx_status<=0;
    end
end
endmodule

`timescale 1ns/1ps
module UART_sender( tx_data,tx_en,baud_rate_16,reset,uart_tx,tx_status);

input [7:0] tx_data;
input tx_en;
input baud_rate_16;
input reset;
output reg uart_tx;
output reg tx_status;
reg [3:0] count,counting;
reg signal_sender;

initial
  begin
  uart_tx<=1;
  tx_status<=1;
  signal_sender<=0;
  count<=0;
  counting<=0;
  end

always@(posedge tx_en,posedge baud_rate_16)
  begin
  if(tx_en)
    begin
    signal_sender<=1;
    tx_status<=0;
    end
  else
    if(signal_sender)
    begin
      if(counting==15)
        begin
        count=count+1;
        counting<=0;
        end
      else counting<=counting+1;
      if(counting==0)
        begin
        if(count==0) uart_tx<=0;
        if((count!=0)&(count<9)) uart_tx<=tx_data[count-1];
        if(count==9)
          begin 
          count<=0;
          counting<=0;
          tx_status<=1;
          signal_sender<=0;
          uart_tx<=1;
          end
      end
    end
    else
    uart_tx<=1;
  end
endmodule


