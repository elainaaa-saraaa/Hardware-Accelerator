`timescale 1ns / 1ps

module tt_um_accelerator (
    input  wire [7:0] uiin,    // Dedicated inputs
    output wire [7:0] uoout,   // Dedicated outputs (The Staircase)
    input  wire [7:0] uioin,   // IOs: Input path
    output wire [7:0] uioout,  // IOs: Output path
    output wire [7:0] uiooe,   // IOs: Enable path
    input  wire ena,           // Design enable
    input  wire clk,           // Clock
    input  wire rstn           // Reset (active low)
);
    // --- Internal Storage ---
    reg [15:0] imem [0:15];    // 16-bit Instruction Memory
    reg [3:0]  pc;             // Program Counter
    reg [7:0]  rf [0:7];       // Register File (R0-R7)
    reg [15:0] acc;            // 16-BIT MAC ACCUMULATOR
    reg [7:0]  out_reg;        // Result visible on uoout
    reg [7:0]  timer;          // Strobe timer to slow down waveform for visibility

    assign uoout  = out_reg;
    assign uioout = 8'b0; 
    assign uiooe  = 8'b0;

    integer i;
    always @(posedge clk) begin
        if (!rstn) begin

            pc <= 0; acc <= 0; out_reg <= 0; timer <= 0;
            for (i=0; i<8; i=i+1) rf[i] <= 0;

            imem[0]  <= 16'h410A; // LOAD R1, 10
            imem[1]  <= 16'h4205; // LOAD R2, 5
            imem[2]  <= 16'h0312; // ALU: ADD R3 = R1+R2 (15)
            imem[3]  <= 16'h5300; // STORE R3 -> Output shows 15
            imem[4]  <= 16'h1412; // ALU: SUB R4 = R1-R2 (5)
            imem[5]  <= 16'h5400; // STORE R4 -> Output shows 5
            imem[6]  <= 16'h2512; // ALU: MUL R5 = R1*R2 (50)
            imem[7]  <= 16'h5500; // STORE R5 -> Output shows 50
            imem[8]  <= 16'h4640; // LOAD R6, 64 (Staircase step)
            imem[9]  <= 16'h5600; // STORE R6 -> Output shows 64
            imem[10] <= 16'h3012; // MAC: Acc = Acc + (10*5) = 50
            imem[11] <= 16'h8000; // STACC -> Output shows 50 (from Acc)
            imem[12] <= 16'h3012; // MAC: Acc = 50 + (10*5) = 100
            imem[13] <= 16'h8000; // STACC -> Output shows 100 (from Acc)
        end else if (ena) begin
         
            if (timer < 128) begin 
                timer <= timer + 1;
            end else begin
                timer <= 0;
                // --- Execution Logic ---
                case (imem[pc][15:12])
                    4'h0: rf[imem[pc][10:8]] <= rf[imem[pc][6:4]] + rf[imem[pc][2:0]]; // ADD
                    4'h1: rf[imem[pc][10:8]] <= rf[imem[pc][6:4]] - rf[imem[pc][2:0]]; // SUB
                    4'h2: rf[imem[pc][10:8]] <= rf[imem[pc][6:4]] * rf[imem[pc][2:0]]; // MUL
                    4'h6: rf[imem[pc][10:8]] <= rf[imem[pc][6:4]] << rf[imem[pc][2:0]][2:0]; // SHIFT
                    4'h4: rf[imem[pc][10:8]] <= imem[pc][7:0]; // LOAD
                    4'h3: acc <= acc + (rf[imem[pc][6:4]] * rf[imem[pc][2:0]]); // MAC UNIT
                    4'h5: out_reg <= rf[imem[pc][10:8]]; // STORE TO OUTPUT
                    4'h8: out_reg <= acc[7:0];           // STORE ACC TO OUTPUT
                endcase
                
                if (pc < 14) pc <= pc + 1;
            end
        end
    end
endmodule
