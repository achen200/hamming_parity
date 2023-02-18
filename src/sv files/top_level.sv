// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
            A = 3;             	// ALU command bit width
  wire[D-1:0] target, 			    // jump 
              prog_ctr;
  wire[7:0] datA,datB,		  // from RegFile
            muxB, 
			      rslt,               // alu output
            immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		  zeroQ;                    // registered zero flag from ALU 
  wire  Branch, Jump;                     // from control to PC; relative jump enable
  wire  zero,
		    sc_clr,
		    sc_en,
        MemWrite,
        MemRead,
        ALUSrc,
        Func_Ex,
        Reg_Size,
        RegWrite;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_adrB;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
          .clk              ,
		      .branch_en (branch),
		      .jump_en (jump),
		      .target  (datB),
		      .prog_ctr);

// lookup table to facilitate jumps/branches
/*
  PC_LUT #(.D(D))
    pl1 (.addr  (how_high),
         .target          );   
*/

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(.instr(mach_code),
  .Branch,
  .Jump, 
  .MemWrite,
  .MemRead, 
  .ALUSrc,     
  .Func_Ex,
  .Reg_Size,
  .ALUOp(alu_cmd),
  .RegWrite);


  assign rd_addrA = mach_code[2:0];
  assign rd_addrB = mach_code[5:3];
  assign alu_cmd  = mach_code[8:6];

  reg_file #(.pw(3)) rf1(.dat_in(regfile_dat),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrB),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  assign muxB = ALUSrc? immed : datB;

  alu alu1(
    .alu_cmd(alu_cmd),
    .inA    (datA),
		.inB    (muxB),
		.rslt,
		.sc_o   (sc_o), // input to sc registered 
    );  

  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datA),
             .dat_out());

// registered flags from ALU
  always_ff @(posedge clk) begin
	zeroQ <= zero;
    if(sc_clr)
	  //sc_in <= 'b0;
    else if(sc_en)
      //sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule