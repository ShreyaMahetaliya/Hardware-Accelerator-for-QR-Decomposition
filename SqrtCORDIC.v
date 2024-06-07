module SqrtCORDIC(input         Start,
                  input         clk,
                  input         rst,
                  input  [31:0] InpNum,
                  output [15:0] Result,
                  output reg    Stop);


/// D A T A   U N I T   variables

wire        init;
wire        gatedClk;
wire        le;
wire [15:0] added;
wire [15:0] addOrNot;
wire [47:0] squared;
wire [31:0] squaredRestr;

reg [15:0] OneShReg;
reg [15:0] Sqrt;
reg [31:0] InputReg;

//logic [7:0] IntegerPart, FractionalPart;

//assign gatedClk = clk & ~Stop;


/// C O N T R O L   U N I T   variables

reg [4:0] ctr;


/// D A T A   U N I T   definition

assign added        = OneShReg + Sqrt;
assign squared      = added * added;
assign squaredRestr = squared >> 8;
assign le           = (squaredRestr <= InputReg) ? 1'b1  : 1'b0;
assign addOrNot     = (le == 1)                  ? added : Sqrt;
//assign IntegerPart  = Sqrt[15:8];
//assign FractionalPart = Sqrt[7:0];
assign Result       = Sqrt>>4;

//always@(negedge gatedClk)
//begin
 //  OneShReg <= (init == 1'b1) ? (16'b1 << 15) : (OneShReg >>> 1);
  // Sqrt     <= (init == 1'b1) ? 16'b0         : addOrNot;
  // InputReg <= (init == 1'b1) ? InpNum        : InputReg;
//end

always @(posedge clk) begin
    if (rst) begin
   OneShReg <=16'b0;
Sqrt <=16'b0;
InputReg<=32'b0;
end else if (Start) begin
OneShReg<=16'b1<<15;
Sqrt<=16'b0;
InputReg<=InpNum;
end else if (~Stop) begin
OneShReg<=OneShReg>>1;
Sqrt<=addOrNot;
end
end
/// C O N T R O L   U N I T   definition

assign init = Start;

always@(posedge clk) begin
if (rst) begin
   ctr<= 5'b0;
 Stop<=1'b0;
end
else if (Start == 1'b1)
   begin
   ctr  <= 5'b0;
   Stop <= 1'b0;
   end
else
   if (ctr > 5'd15)
   begin
   ctr  <= ctr;
   Stop <= 1'b1;
   end
   else
   begin
   ctr  <= ctr + 5'b1;
   Stop <= 1'b0;
   end

end
endmodule 

