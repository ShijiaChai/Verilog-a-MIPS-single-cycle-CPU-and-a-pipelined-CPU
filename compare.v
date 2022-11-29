module compare(cmp,ALUFun,A,B);
  output reg cmp;
  input [5:0]ALUFun;
  input [31:0]A;
  input [31:0]B;
  
  wire [31:0]Z;
  assign Z=A+~B+1;
    
  always@(*)
    case(ALUFun[3:1])
      3'b000: cmp<=A^B;
      3'b001: cmp<=!(A^B);
      3'b010: cmp<=Z[31]^((A[31]^B[31])&(B[31]^~Z[31]));
      3'b110: cmp<=(A[31]|~(A^32'h0));
      3'b101: cmp<=A[31];
      3'b111: cmp<=~A[31];
      default:cmp<=0;
    endcase
endmodule
