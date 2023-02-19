// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
		branch_en,             // branch enable (PC+2)
        jump_en,				// jump enable (labels)
        zero
  input       [7:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr,
  output logic[D-1:0] prevAddr
);

  always_ff @(posedge clk)
    prevAddr<= 'b0;
    if(reset)
	    prog_ctr <= '0;
    else if(branch_en && zero)
      prog_ctr <= prog_ctr + 2;
    else if(jump_en)
      prevAddr <= prog_ctr + 'b1;
      prog_ctr <= {prog_ctr[D-1:D-4], target};
    else
      prog_ctr <= prog_ctr + 'b1;

endmodule