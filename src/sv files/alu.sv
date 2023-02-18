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
    kADD: // add 2 8-bit unsigned; automatically makes carry-out
      {sc_o,rslt} = inA + inB + sc_i;
	  kSHIFT: //SHIFT
      if (inB < 0)  begin //left shift by 2s comp immediate if immediate (inB) is negative
        {sc_o, rslt} = inA << -inB
      end  
      else begin //right shift by 2s comp immediate if immediate (inB) is nonnegative
        // right shift (1 added to number passed in to avoid wasting the 0)    
        {rslt,sc_o} = inA >> (inB+1);
      end 
    kBXOR: // bitwise XOR
	    rslt = inA ^ inB;
	  kAND: // bitwise AND (mask)
	    rslt = inA & inB;
  	bRXOR: // reduction XOR
	    rslt = ^inA;
	  kSUB: // subtract
	    {sc_o,rslt} = inA - inB;
	  kNOT: // not
	    rslt = ~inA;
    default:
      
  endcase
end
   
endmodule