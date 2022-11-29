module ALU(Z,A,B,ALUFun,Sign);
  output reg [31:0]Z;
  input [31:0]A;
  input [31:0]B;
  input [5:0]ALUFun;
  input Sign;
  
  wire [31:0]Add;
  wire NZ;
  reg Cmp;
  wire Cmp0;
  reg Cmp1;
  reg Cmp2;
  reg [31:0]Logic;
  reg [31:0]Shift;
  wire [31:0]Shift_left;
  wire [31:0]Shift_left_8;
  wire [31:0]Shift_left_4;
  wire [31:0]Shift_left_2;
  wire [31:0]Shift_left_1;
  wire [31:0]Shift_right0;
  wire [31:0]Shift_right0_8;
  wire [31:0]Shift_right0_4;
  wire [31:0]Shift_right0_2;
  wire [31:0]Shift_right0_1;
  wire [31:0]Shift_right1;
  wire [31:0]Shift_right1_8;
  wire [31:0]Shift_right1_4;
  wire [31:0]Shift_right1_2;
  wire [31:0]Shift_right1_1;
  
  assign Add=A+(ALUFun[0]?(~B+1'b1):B);
  
  assign NZ=|Add;
  assign Cmp0=ALUFun[1]^NZ;
  always @(*)
    case({A[31],B[31]})
      2'b01: Cmp1=~Sign;
      2'b10: Cmp1=Sign;
      default: Cmp1=Add[31];
    endcase
  
  always @(*)
    case(ALUFun[2:1])
      2'b10: Cmp2=(A[31])|(~(|A));
      2'b01: Cmp2=A[31];
      default: Cmp2=(~A[31])&(|A);
    endcase
  
  always @(*)
    if(ALUFun[3])
      Cmp=Cmp2;
    else if(ALUFun[2])
      Cmp=Cmp1;
    else
      Cmp=Cmp0;
  
  always @(*)
    case(ALUFun[3:0])
      4'b1000: Logic=A&B;
      4'b1110: Logic=A|B;
      4'b0110: Logic=A^B;
      4'b0001: Logic=~(A|B);
      default: Logic=A;
    endcase
  
  assign Shift_left_1=A[0]?{B[30:0],1'b0}:B;
  assign Shift_left_2=A[1]?{Shift_left_1[29:0],2'b0}:Shift_left_1;
  assign Shift_left_4=A[2]?{Shift_left_2[27:0],4'b0}:Shift_left_2;
  assign Shift_left_8=A[3]?{Shift_left_4[23:0],8'b0}:Shift_left_4;
  assign Shift_left=A[4]?{Shift_left_8[18:0],16'b0}:Shift_left_8;
  
  assign Shift_right0_1=A[0]?{1'b0,B[31:1]}:B;
  assign Shift_right0_2=A[1]?{2'b0,Shift_right0_1[31:2]}:Shift_right0_1;
  assign Shift_right0_4=A[2]?{4'b0,Shift_right0_2[31:4]}:Shift_right0_2;
  assign Shift_right0_8=A[3]?{8'b0,Shift_right0_4[31:8]}:Shift_right0_4;
  assign Shift_right0=A[4]?{16'b0,Shift_right0_8[31:16]}:Shift_right0_8;
  
  assign Shift_right1_1=A[0]?{1'b1,B[31:1]}:B;
  assign Shift_right1_2=A[1]?{2'b11,Shift_right1_1[31:2]}:Shift_right1_1;
  assign Shift_right1_4=A[2]?{4'b1111,Shift_right1_2[31:4]}:Shift_right1_2;
  assign Shift_right1_8=A[3]?{8'b11111111,Shift_right1_4[31:8]}:Shift_right1_4;
  assign Shift_right1=A[4]?{16'b1111111111111111,Shift_right1_8[31:16]}:Shift_right1_8;
  
  always @(*)
    if(ALUFun[0])
      if(ALUFun[1]&B[31]) Shift=Shift_right1;
      else Shift=Shift_right0;
    else Shift=Shift_left;
  
  always @(*)
    case(ALUFun[5:4])
      2'b00: Z=Add;
      2'b01: Z=Logic;
      2'b10: Z=Shift;
      2'b11: Z={31'b0,Cmp};
      default: Z=32'b0;
    endcase

endmodule
