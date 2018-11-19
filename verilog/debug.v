include constants.v;
include nw.v;

// We're going to use a hard-wired length of 4 here
localparam HLENGTH = 4;

// Instantiate compute grid with hard-wired inputs 
wire [HLENGTH*CWIDTH-1:0] s1 = {A, T, C, G}; //, A, T, C, G};
wire [HLENGTH*CWIDTH-1:0] s2 = {A, T, C, G}; //, T, A, C, G};
wire signed[SWIDTH-1:0] score;
wire done;
Grid#(
  .LENGTH(HLENGTH),
  .CWIDTH(CWIDTH),
  .SWIDTH(SWIDTH),
  .MATCH(MATCH),
  .INDEL(INDEL),
  .MISMATCH(MISMATCH) 
) g (
  .clk(clock.val),
  .s1(s1),
  .s2(s2),
  .valid(1),
  .score(score),
  .done(done)
);

// Time out after 16 cycles
reg [5:0] count = 0;

// Print the result. We should see:
//  1  0 -1 -2
//  0  2  1  0
// -1  1  3  2
// -2  0  2  4
// after you replace the "..." below with signals for the 
// grid elements in your top level module
always @(posedge clock.val) begin
  // $display("%d %d %d %d %d %d %d %d", g.ris[0], g.ris[1], g.ris[2], g.ris[3], g.ris[4], g.ris[5], g.ris[6], g.ris[7]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[8], g.ris[9], g.ris[10], g.ris[11], g.ris[12], g.ris[13], g.ris[14], g.ris[15]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[16], g.ris[17], g.ris[18], g.ris[19], g.ris[20], g.ris[21], g.ris[22], g.ris[23]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[24], g.ris[25], g.ris[26], g.ris[27], g.ris[28], g.ris[29], g.ris[30], g.ris[31]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[32], g.ris[33], g.ris[34], g.ris[35], g.ris[36], g.ris[37], g.ris[38], g.ris[39]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[40], g.ris[41], g.ris[42], g.ris[43], g.ris[44], g.ris[45], g.ris[46], g.ris[47]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[48], g.ris[49], g.ris[50], g.ris[51], g.ris[52], g.ris[53], g.ris[54], g.ris[55]);
  // $display("%d %d %d %d %d %d %d %d", g.ris[56], g.ris[57], g.ris[58], g.ris[59], g.ris[60], g.ris[61], g.ris[62], g.ris[63]);
  $display("%d %d %d %d", g.ris[0], g.ris[1], g.ris[2], g.ris[3]);
  $display("%d %d %d %d", g.ris[4], g.ris[5], g.ris[6], g.ris[7]);
  $display("%d %d %d %d", g.ris[8], g.ris[9], g.ris[10], g.ris[11]);
  $display("%d %d %d %d", g.ris[12], g.ris[13], g.ris[14], g.ris[15]);
  $display("");
  
  count <= (count + 1);
  if (done | (&count)) begin
    $finish(1);
  end
end
