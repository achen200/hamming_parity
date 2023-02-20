// combinational -- no clock
import definitions::*;

module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
			   zero      // NOR (output)
);

always_comb begin 
  rslt = 'b0;  //result          
  sc_o = 'b0;  //shift carry out
  zero = !rslt; //if zero
  case(alu_cmd)
    kADD: {sc_o,rslt} = inA + inB; //+ sc_i;  add 2 8-bit unsigned; automatically makes carry-out
	kSHIFT: begin//SHIFT
      if (inB < 0)   //left shift by 2s comp immediate if immediate (inB) is negative
        {sc_o, rslt} = inA << -inB;  
      else //right shift by 2s comp immediate if immediate (inB) is nonnegative
        {rslt,sc_o} = inA >> (inB+1);// right shift (1 added to number passed in to avoid wasting the 0)    
	end
    kBXOR: rslt = inA ^ inB;// bitwise XOR
	kAND: rslt = inA & inB;// bitwise AND (mask)
  	kRXOR: rslt = ^inA; // reduction XOR
	kSUB: {sc_o,rslt} = inA - inB;// subtract   
	kNOT: rslt = ~inA;// not
    kPASS: rslt = inB; //Pass (one variable to another)
      
    endcase
end
   
endmodule