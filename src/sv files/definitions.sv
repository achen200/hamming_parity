package definitions;
//instruction map
    const logic [3:0]kADD   = 0b'0000;
    const logic [3:0]kSUB   = 0b'0001;
    const logic [3:0]kBXOR  = 0b'0010;
    const logic [3:0]kRXOR  = 0b'0011;
    const logic [3:0]kAND   = 0b'0100;
    const logic [3:0]kSHIFT = 0b'0101;
    const logic [3:0]kNOT   = 0b'0110;
    const logic [3:0]kMOV   = 0b'0111;
    const logic [3:0]kPASS  = 0b'1000;

    typedef enum logic[3:0] {
        ADD, SUB, BXOR, RXOR, AND, SHIFT, NOT, MOV, PASS
    } op_mne;

endpackage