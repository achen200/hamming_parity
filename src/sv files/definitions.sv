package definitions;
//instruction map
    const logic [3:0]kADD   = 'b0000;
    const logic [3:0]kSUB   = 'b0001;
    const logic [3:0]kBXOR  = 'b0010;
    const logic [3:0]kRXOR  = 'b0011;
    const logic [3:0]kAND   = 'b0100;
    const logic [3:0]kSHIFT = 'b0101;
    const logic [3:0]kNOT   = 'b0110;
    const logic [3:0]kMOV   = 'b0111;
    const logic [3:0]kPASS  = 'b1000;

    typedef enum logic[3:0] {
        ADD, SUB, BXOR, RXOR, AND, SHIFT, NOT, MOV, PASS
    } op_mne;

endpackage