package definitions;
//instruction map
    const logic [2:0]kADD = 0b'000;
    const logic [2:0]kSUB = 0b'001;
    const logic [2:0]kBXOR = 0b'010;
    const logic [2:0]kRXOR = 0b'011;
    const logic [2:0]kAND = 0b'100;
    const logic [2:0]kSHIFT = 0b'101;
    const logic [2:0]kNOT = 0b'110;

    typedef enum logic[2:0] {
        ADD, SUB, BXOR, RXOR, AND, SHIFT, NOT 
    } op_mne;

endpackage