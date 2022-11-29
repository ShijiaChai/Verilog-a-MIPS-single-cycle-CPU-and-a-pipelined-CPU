module ALU(Out,A,B,ALUFun,Sign);
input [31:0] A, B;
input [5:0] ALUFun;
input Sign;
output reg [31:0] Out;
wire Z, V, N;
wire [31:0] Out1, Out2, Out3, Out4;
ARITH ari(ALUFun[0], A, B, Sign, Z, V, N, Out1);
LOGIC log(ALUFun[3:0], A, B, Out2);
SHIFT shi(ALUFun[1:0], A, B, Out3);
CMP cmp(ALUFun[3:1], Z, V, N, Out4);
always @* begin
	case(ALUFun[5:4])
		2'b00:Out<= Out1;
		2'b01:Out<= Out2;
		2'b10:Out<= Out3;
		2'b11:Out<= Out4;
		default:Out<= 32'h00000000;
	endcase
end	
endmodule

module SHIFT(FUNC, A, B, Out);
input [1:0] FUNC;
input [31:0] A, B;
output reg [31:0] Out;
reg [31:0] S ;
always @* begin
	case(FUNC)
		2'b00: begin
			if(A[4]) Out= ( B << 16 );
			if(A[3]) Out= ( Out << 8 );
			if(A[2]) Out= ( Out << 4 );
			if(A[1]) Out= ( Out << 2 );
			if(A[0]) Out= ( Out << 1 );
		end
		2'b01: begin
			if(A[4]) Out= ( B >> 16 );
			if(A[3]) Out= ( Out >> 8 );
			if(A[2]) Out= ( Out >> 4 );
			if(A[1]) Out= ( Out >> 2 );
			if(A[0]) Out= ( Out >> 1 );
		end
		2'b11: begin
			if(B[31]) S= 32'hffffffff;
			else S= 32'h00000000;
			if(A[4]) begin Out= ( B >>> 16 );  Out[31:16]= S[31:16]; end
			if(A[3]) begin Out= ( Out >>> 8 ); Out[31:24]= S[31:24]; end
			if(A[2]) begin Out= ( Out >>> 4 ); Out[31:28]= S[31:28]; end
			if(A[1]) begin Out= ( Out >>> 2 ); Out[31:30]= S[31:30]; end
			if(A[0]) begin Out= ( Out >>> 1 ); Out[31]   = S[31];    end
		end
		default: Out=32'h00000000;
	endcase
end
endmodule

module CMP(FUNC, Z, V, N, Out);
input [2:0] FUNC;
input Z, V, N;
output reg [31:0] Out;
always @* begin
	Out[31:0]= 32'h00000000;
	case(FUNC)
		3'b001: Out[0] <= Z;
		3'b000: Out[0] <= ~Z;
		3'b010: Out[0] <= N;
		3'b110: Out[0] <= ( Z || N );
		3'b101: Out[0] <= N;
		3'b111: Out[0] <= ~N;
		default: Out<= 32'h00000000;
	endcase
end
endmodule

module ARITH(FUNC, A, B, S, Z, V, N, Out);
input [31:0] A, B;
input FUNC;
input S;
output Z;
output reg V, N;
output reg [31:0] Out;
reg [31:0] C;
assign Z= (Out == 0);
always @* begin
	if(FUNC==0) begin
		if(S==1) begin
			Out= A + B;
			if(A[31]==0 && B[31]==0 && Out[31]==1 || A[31]==1 && B[31]==1 && Out[31]==0) V=1;
			else V=0;
			if(A[31]==1 && B[31]==1) N=1;
			else if(A[31]==0 && B[31]==0) N=0;
			else N=Out[31];
		end
		if(S==0) begin
			Out= A + B;
			V=0;
			N=0;
		end
	end
	if(FUNC==1) begin
		C= ~B + 1'b1;
		if(S==1) begin
			Out= A + C;
			if(A[31]==0 && C[31]==0 && Out[31]==1 || A[31]==1 && C[31]==1 && Out[31]==0) V=1;
			else V<=0;
			if(A[31]==1 && C[31]==1) N=1;
			else if(A[31]==0 && C[31]==0) N=0;
			else N=Out[31];
		end
		if(S==0) begin
		Out= A + C;
		V=0;
		if(A[31]==1 && B[31]==0 ) N=0;
		else if(A[31]==0 && B[31]==1 ) N=1;
		else N=Out[31];
		end
	end
end
endmodule

module LOGIC(FUNC, A, B, Z);
input [3:0] FUNC;
input [31:0] A, B;
output reg [31:0] Z;
always @* begin
	case(FUNC)
		4'b1000:Z= A & B;
		4'b1110:Z= A | B;
		4'b0110:Z= A ^ B;
		4'b0001:Z= ~ ( A | B );
		4'b1010:Z= A;
		default:Z=32'h00000000;
	endcase
end
endmodule