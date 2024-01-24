# Custom Processor Design
## Custom ISA and Processor Specs:
The processor is designed to run the Hamming Parity bit algorithm to detect and correct corrupted bits. Our ISA uses an instruction width of 9 bits. Further
documentation and diagrams can be found [here](https://docs.google.com/document/d/1FqtxIWGAnZTD27aaHzwTmiMNtMX_EEcOBYN-0US8_qk/edit#heading=h.n8befiq7h4m6)

## Programs:
Designed to run Hamming Parity Algorithm
-  Program 1 `src/prog1.txt`
    -  Calculate parity bits given  input of two bytes
- Program 2 `src/prog2.txt`
    -  Detect errors based off parity calculations
- Program 3 `src/prog3.txt`
    - Parse a data stream and identify/correct corrupted bits
## Working Tree:
- Source Code Location: src > sv files
    - top_level.sv - contains top level
    - definitions.sv - contains lookup table for ALUops
    - Rest of the file names match module functions
- Machine code, assembly code, assembler, and warning messages located in src folder
## Collaborators
- [achen200](https://github.com/achen200/)
- [alm011](https://github.com/alm011)
- [KH-CL](https://github.com/KH-CL) 