module CPU(clk,reset,led,digi,UART_RX,UART_TX);
  input clk;
  input reset;
   output [7:0] led;
   output [11:0] digi;
   input UART_RX;
   output UART_TX;
  
  parameter ILLOP=32'h8000_0004;
  parameter XADR=32'h8000_0008;
  reg [31:0]PC;
  reg [31:0]PC_next;
  wire [31:0]PC_plus_4;
  wire [31:0]ConBA;
  wire [31:0]DataBus_A;
  wire [31:0]DataBus_B;
  reg [31:0]DataBus_C;
  wire [31:0]DataRam;
  wire [31:0]Instruction;
  wire [31:0]ALUIn_A;
  reg [31:0]ALUIn_B;
  wire [31:0]ALUOut;
  reg [31:0]Imm32;
  reg [4:0]RegC;
  wire IRQ;
  
  wire [25:0]JT;
  wire [15:0]Imm16;
  wire [4:0]Shamt;
  wire [4:0]Rd;
  wire [4:0]Rt;
  wire [4:0]Rs;
    
  wire [2:0]PCSrc;
  wire [1:0]RegDst;
  wire RegWr;
  wire [1:0]ALUSrc1;
  wire [1:0]ALUSrc2;
  wire [5:0]ALUFun;
  wire Sign;
  wire MemWr;
  wire MemRd;
  wire [1:0]MemToReg;
  wire EXTOp;
  wire LUOp;
  reg [31:0]RA;
  wire PC_Hold,IF_Flush,IF_Hold,Control_Flush,undefine,irq_valid;
  wire [1:0]Forward_A,Forward_B,Forward_C,Mem_MemtoReg,EX_MemtoReg,WB_MemtoReg;
  wire [4:0]Mem_rd,WB_rd,EX_rs,EX_rt,EX_rd,EX_Shamt,ID_rs,ID_rt,ID_rd;
  wire [31:0]Instruct_in,ID_Instruct,ID_PC,WB_PC,Mem_Data,WBALU_out,EX_PC,EX_Imm,BUS_A,BUS_B,EX_ConBA;
  wire [31:0]Mem_PC,MemALU_out,wr_Data_Mem,PC_in;
  reg [31:0]ID_Imm,A1,B1,ID_PC_irq;
  wire WB_RegWr,EX_Sign,EX_MemWr,EX_RegWr,EX_MemRd,Mem_MemWr,Mem_RegWr,Mem_MemRd;
  wire [5:0]EX_ALUFun;
  wire [2:0]EX_PCSrc;
  reg [2:0]PCSrc_Final;
  wire ALUout_0;
  wire [1:0]EX_ALUSrc1,EX_ALUSrc2;

 wire [31:0]data_write,Data_write;
 assign data_write=WB_RegWr?DataBus_C:0;

 
  wire [31:0]DataRam_peri;
  wire [31:0]DataRam_final;
  wire [31:0]DataRam_uart;
  assign DataRam_final=DataRam_peri | DataRam | DataRam_uart;
  
  assign JT=ID_Instruct[25:0];
  assign Imm16=ID_Instruct[15:0];
  assign Shamt=ID_Instruct[10:6];
  assign Rd=ID_Instruct[15:11];
  assign Rt=ID_Instruct[20:16];
  assign Rs=ID_Instruct[25:21];
  assign ID_rs=Rs;
  assign ID_rt=Rt;
  assign ID_rd=RegC;
  assign ID_ConBA=ConBA;  
  assign PC_plus_4=PC+3'b100;
  assign ConBA={Imm32[29:0],2'b00}+ID_PC;
  
  assign ALUIn_A=EX_ALUSrc1?{27'b0,EX_Shamt}:A1;
 
  assign Instruct_in=IF_Flush?32'b0:Instruction;
  
  always @(*)
    if(!irq_valid) ID_PC_irq=ID_PC;
    else if(EX_PCSrc==3'b1&&ALUout_0)
      ID_PC_irq=PC_next;
    else if(EX_PCSrc==3'b1&&!ALUout_0)
      ID_PC_irq=PC;
    else ID_PC_irq=ID_PC-3'b100;
  
  
  always @(*)
    if(EX_PCSrc==3'b1&&ALUout_0) PCSrc_Final=EX_PCSrc;
    else PCSrc_Final=PCSrc;
      
  always @(*)
    if(EXTOp&Imm16[15]) Imm32={16'hFFFF,Imm16};
    else Imm32={16'h0000,Imm16};
  
  always @(*)
    case(Forward_C)
      2'b00: RA=DataBus_A;
      2'b01: RA=MemALU_out;
      2'b10: RA=DataBus_C;
      default: RA=DataBus_A;
    endcase
    
  always @(*)
    case(PCSrc_Final[2:0])
      3'd0: PC_next=PC_plus_4;
      3'd1: PC_next=((EX_PCSrc==3'b1)&&ALUout_0)?EX_ConBA:PC_plus_4;
      3'd2: PC_next={PC[31:28],JT,2'b00};
      3'd3: PC_next=RA;
      3'd4: PC_next=ILLOP;
      default: PC_next=XADR;
    endcase
  
  always @(*)
    case(RegDst)
      2'b00: RegC=Rd;
      2'b01: RegC=Rt;
      2'b10: RegC=5'd31;
      2'b11: RegC=5'd26;
      default: RegC=5'd0;
    endcase
    
  always @(*)
    if(LUOp) ID_Imm={Imm16,16'b0};
    else ID_Imm=Imm32;
  
  always @(*)
    case(Forward_A)
      2'b00: A1=BUS_A;
      2'b01: A1=MemALU_out;
      2'b10: A1=DataBus_C;
      default: A1=BUS_A;
    endcase
    
  always @(*)
    case(Forward_B)
      2'b00: B1=BUS_B;
      2'b01: B1=MemALU_out;
      2'b10: B1=DataBus_C;
      default: B1=BUS_B;
    endcase
    
  always @(*)
    if(EX_ALUSrc2)
      ALUIn_B=EX_Imm;
    else
      ALUIn_B=B1;
  
  always @(*)
    case(WB_MemtoReg)
      2'b00: DataBus_C=WBALU_out;
      2'b01: DataBus_C=Mem_Data;
      default: DataBus_C=WB_PC;
    endcase
  
  always @(posedge clk or negedge reset)
     if(~reset)
       PC<=32'b0;
     else
       PC<=PC_Hold?PC:PC_next;
  
    ROM rom(.addr(PC[30:0]),.data(Instruction));    
    Control control(.Instruct(ID_Instruct),.IRQ(IRQ),.PC31(PC[31]),.irq_valid(irq_valid),.PCSrc(PCSrc),.RegDst(RegDst),.RegWr(RegWr),.ALUSrc1(ALUSrc1),.ALUSrc2(ALUSrc2),.ALUFun(ALUFun),.Sign(Sign),.MemWr(MemWr),.MemRd(MemRd),.MemToReg(MemToReg),.EXTOp(EXTOp),.LUOp(LUOp),.undefine(undefine));
    RegFile regfile(.reset(reset),.clk(clk),.addr1(ID_rs),.data1(DataBus_A),.addr2(ID_rt),.data2(DataBus_B),.wr(WB_RegWr),.addr3(WB_rd),.data3(data_write));
    compare Com(.ALUFun(EX_ALUFun),.A(A1),.B(B1),.cmp(ALUout_0));
    ALU ALU(.Out(ALUOut),.A(ALUIn_A),.B(ALUIn_B),.ALUFun(EX_ALUFun),.Sign(EX_Sign));
    DataMem datamem(.reset(reset),.clk(clk),.rd(Mem_MemRd),.wr(Mem_MemWr),.addr(MemALU_out),.wdata(wr_Data_Mem),.rdata(DataRam));
    IFID_Reg IFID(.ID_Instruct(ID_Instruct),.ID_PC(ID_PC),.Instruct_in(Instruct_in),.IF_PC(PC_plus_4),.Hold(IF_Hold),.clk(clk),.reset(reset));
    IDEX_Reg IDEX(.EX_PC(EX_PC),.EX_Imm(EX_Imm),.BUS_A(BUS_A),.BUS_B(BUS_B),.EX_rs(EX_rs),.EX_rt(EX_rt),.EX_rd(EX_rd),.EX_Shamt(EX_Shamt),.EX_ALUFun(EX_ALUFun),.EX_Sign(EX_Sign),.EX_ALUSrc1(EX_ALUSrc1),.EX_ALUSrc2(EX_ALUSrc2),.EX_MemWr(EX_MemWr),.EX_MemtoReg(EX_MemtoReg),.EX_RegWr(EX_RegWr),.EX_MemRd(EX_MemRd),.EX_PCSrc(EX_PCSrc),.EX_ConBA(EX_ConBA),.ID_PC(ID_PC_irq),.ID_Imm(ID_Imm),.REG_A(DataBus_A),.REG_B(DataBus_B),.ID_rs(ID_rs),.ID_rt(ID_rt),.ID_rd(ID_rd),.ID_Shamt(Shamt),.ID_ALUFun(ALUFun),.ID_Sign(Sign),.ID_ALUSrc1(ALUSrc1),.ID_ALUSrc2(ALUSrc2),.ID_MemWr(MemWr),.ID_MemtoReg(MemToReg),.ID_RegWr(RegWr),.ID_MemRd(MemRd),.PCSrc(PCSrc),.ID_ConBA(ConBA),.Control_Flush(Control_Flush),.undefine(undefine),.clk(clk),.reset(reset));
    EXMEM_Reg EXMEM(.Mem_PC(Mem_PC),.MemALU_out(MemALU_out),.Mem_rd(Mem_rd),.wr_Data(wr_Data_Mem),.Mem_MemWr(Mem_MemWr),.Mem_MemtoReg(Mem_MemtoReg),.Mem_RegWr(Mem_RegWr),.Mem_MemRd(Mem_MemRd),.EX_PC(EX_PC),.ALU_out(ALUOut),.EX_rd(EX_rd),.after_BUS_B(B1),.EX_MemWr(EX_MemWr),.EX_MemtoReg(EX_MemtoReg),.EX_RegWr(EX_RegWr),.EX_MemRd(EX_MemRd),.clk(clk),.reset(reset));
    MemWB_Reg MemWB(.WB_PC(WB_PC),.Mem_Data(Mem_Data),.WBALU_out(WBALU_out),.WB_MemtoReg(WB_MemtoReg),.WB_RegWr(WB_RegWr),.WB_rd(WB_rd),.Mem_PC(Mem_PC),.MemALU_out(MemALU_out),.Mem_out(DataRam_final),.Mem_MemtoReg(Mem_MemtoReg),.Mem_RegWr(Mem_RegWr),.Mem_rd(Mem_rd),.clk(clk),.reset(reset));
    Forward FORWARD(Forward_A,Forward_B,Forward_C,Mem_rd,WB_rd,EX_rs,EX_rt,ID_rs,Mem_RegWr,WB_RegWr,EX_RegWr,EX_rd);
    Hazard HAZARD(PC_Hold,IF_Hold,IF_Flush,Control_Flush,ID_rt,ID_rs,EX_rt,EX_MemRd,PCSrc,EX_PCSrc,ALUout_0,undefine,irq_valid);   
    Peripheral PeripheralInst(.reset(reset), .clk(clk), .rd(Mem_MemRd), .wr(Mem_MemWr), .addr(MemALU_out), .wdata(wr_Data_Mem), .rdata(DataRam_peri), .led(led), .irqout(IRQ),.digi(digi));
	UART_top   uart1(.reset_(reset),.sysclk(clk),.cpu_clk(clk),.rd(Mem_MemRd),.wr(Mem_MemWr),.addr(MemALU_out),.wdata(wr_Data_Mem),.UART_RX(UART_RX),.UART_TX(UART_TX),.rdata(DataRam_uart));
    
endmodule