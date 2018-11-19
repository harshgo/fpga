// Grid Elements:
module Elem#(
// you may have similar parameters as the top level module here...
  // Number of bits per character
  parameter CWIDTH = 2,
  // Number of bits per score
  parameter SWIDTH = 16,
  // Weights
  parameter signed MATCH = 1,
  parameter signed INDEL = -1,
  parameter signed MISMATCH = -1
)(
//...
  input wire signed[SWIDTH-1:0] left,
  input wire signed[SWIDTH-1:0] topLeft,
  input wire signed[SWIDTH-1:0] top,
  input wire signed[CWIDTH-1:0] c1,
  input wire signed[CWIDTH-1:0] c2,
  output wire signed[SWIDTH-1:0] out
);
  wire signed[SWIDTH-1:0] Left, TopLeft, Top, inter, match;
    assign match = (c1 == c2) ? MATCH : MISMATCH;
    assign Left = left + INDEL;
    assign TopLeft = topLeft + match;
    assign Top = top + INDEL;
    assign inter = (Left > TopLeft) ? Left : TopLeft;
    assign out = (inter > Top) ? inter : Top;
endmodule

// Grid:
module Grid#(
  // Number of characters per string
  parameter LENGTH = 10,
  // Number of bits per character
  parameter CWIDTH = 2,
  // Number of bits per score
  parameter SWIDTH = 16,
  // Weights
  parameter signed MATCH = 1,
  parameter signed INDEL = -1,
  parameter signed MISMATCH = -1
)(
  // Clock
  input wire clk,
  // Input strings
  input wire signed[LENGTH*CWIDTH-1:0] s1,
  input wire signed[LENGTH*CWIDTH-1:0] s2,
  input wire valid,
  // Match score
  output wire signed[SWIDTH-1:0] score,
  output wire done
);
  reg signed[SWIDTH-1:0] ris[(LENGTH)*(LENGTH)-1:0];
  reg[SWIDTH-1:0] numCycles = 0;
  genvar i;
  for (i = 0; i < LENGTH*LENGTH; i = i + 1) begin : GridElems
    wire signed[SWIDTH-1:0] xi, left, topLeft, top;
    wire[LENGTH:0] row, col;
    wire[CWIDTH-1:0] c1, c2;
    assign col = i % LENGTH;
    assign row = i / LENGTH;
    // getting left
    assign left = (col == 0) ? -(i/LENGTH + 1) : ris[i-1];
    // getting topLeft
    assign topLeft = (row == 0) ? -(col)
                     : (col == 0) ? -(row)
                     : ris[i -LENGTH - 1];

    // getting top
    assign top = (row == 0) ? -(i+1) : ris[i-LENGTH];
    // getting c1
    assign c1 = s1[((i%LENGTH)+1)*CWIDTH - 1:((i%LENGTH)*CWIDTH)];
    // getting c2
    assign c2 = s2[((i/LENGTH)+1)*CWIDTH - 1:((i/LENGTH)*CWIDTH)];
    Elem#(
      .CWIDTH(CWIDTH),
      .SWIDTH(SWIDTH),
      .MATCH(MATCH),
      .INDEL(INDEL),
      .MISMATCH(MISMATCH)
    ) elem(left, topLeft, top, c1, c2, xi);

    assign done = numCycles == LENGTH;

    always @(posedge clk) begin
      if (valid) begin
        ris[i] <= xi;
        numCycles <= numCycles + 1;
      end
    end
      

    // getting 
  end


// ...
// you may find genvar and generate statements to be VERY useful here. 
endmodule
