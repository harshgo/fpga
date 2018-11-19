include constants.v;
include nw.v;

// We're going to use a hard-wired length here
localparam HLENGTH = 8;

// Instantiate compute grid with hard-wired inputs 
wire [HLENGTH*CWIDTH-1:0] s1 = {HLENGTH{A}};
wire [HLENGTH*CWIDTH-1:0] s2 = {HLENGTH{G}};
wire done;
Grid#(
  .LENGTH(HLENGTH),
  .CWIDTH(CWIDTH),
  .SWIDTH(SWIDTH),
  .MATCH(MATCH),
  .INDEL(INDEL),
  .MISMATCH(MISMATCH) 
) grid (
  .clk(clock.val),
  .s1(s1),
  .s2(s2),
  .valid(1),
  .done(done)
);

// Count the number of cycles taken
reg [31:0] count = 1;
always @(posedge clock.val) begin
  if (done) begin
    $display("Final cycle count: %d cycles", count);
    $finish;
  end
  count <= (count + 1);
end
