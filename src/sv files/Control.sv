import definitions::*;
// control decoder
module Control #(parameter opwidth = 3, mcodebits = 8)(
  input [mcodebits:0] instr,    // subset of machine code (any width you need)
  output logic Branch, MemRead, MemWrite, Reg_Size, Func_Ex, Jump, ALUSrc, RegWrite,
  output logic[opwidth:0] ALUOp,	   // for up to 16 ALU operations

  logic opcode = instr[8:5],
  logic funct  = instr[1:0]
);
always_comb begin
// defaults
  Branch 	 =  'b0;   // 1: Set to 1 only if EQ is true
  MemRead  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  MemWrite =	'b0;   // 1: store to memory
  ALUOp	   =  'b1000; // default: pass
  Reg_Size =  'b1;   // 0: For H type instructions, 1 for C type and M type
  Func_Ex  =  'b0;   // 0: For H type and C type, 1 for M type
  Jump     =  'b0;   //
  ALUSrc   =  'b1;   //0: if instruction has immediate
  RegWrite =  'b1;   //1: write to register file
  
// sample values only -- use what you need
 // override defaults with exceptions
case(opcode)  
  //BXOR, LOAD, STORE, NOT
  'b000: begin              
    case(funct)
      //LOAD
      'b00: begin
        ALUOp = kADD;
        MemRead = 'b1;
        ALUSrc  =  'b0;
        Func_Ex = 'b1;
      end
      //STORE                   
      'b01: begin
        ALUOp     = kADD;
        MemRead   = 'b1;
        ALUSrc    =  'b0;
        Func_Ex   = 'b1;
        RegWrite  ='b0;
      end
      //NOT                
      'b10: ALUOp = kNOT;      
      //BXOR          
      'b11: begin
       ALUOp    = kBXOR; 
       Reg_Size = 'b0;
      end               
    endcase
  end
  //EQ 
  'b001: begin
    ALUOp     = kSUB;
    Branch    = 'b1;
    RegWrite  = 'b0; 
  end
  //ADD, ADDI, SUB, SUBI                               
  'b010: begin
    Reg_Size = 'b0;
    case(funct)
      //ADD
      'b00: ALUOp = kADD;
      //ADDI     
      'b01: begin 
        ALUOp = kADD;
        ALUSrc = 'b0;
      end
      //SUB                
      'b10: ALUOp = kSUB; 
      //SUBI             
      'b11: begin
        ALUOp = kSUB;
        ALUSrc = 'b0;  
      end                
    endcase
  end
  //JAL
  'b011: begin
    ALUOp = kPASS; //alu_out = rd1
    Jump = 'b1;
  end

  //MOV                      
  'b100:  ALUOp = kMOV;  //alu_out = rd2  
  //AND                  
  'b101: ALUOp = kAND; 
  //SH                  
  'b110: begin
    ALUOp = kSHIFT;
    ALUSrc = 'b0;
  end 
  //RXOR                
  'b111: ALUOp = kRXOR;
endcase

end
	
endmodule