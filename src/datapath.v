`include "defines.v"
module datapath (
    input  wire        clk, reset,
    input  wire [3:0]  opcode,
    input  wire [7:0]  a, b,
    output reg  [7:0]  result,
    output reg  [15:0] acc
);
    wire [15:0] mul_temp = a * b;
    always @(posedge clk) begin
        if (reset) begin
            acc <= 16'b0; result <= 8'b0;
        end else begin
            case (opcode)
                `OPADD:   result <= a + b;
                `OPSUB:   result <= a - b;
                `OPMUL:   result <= mul_temp[7:0];
                `OPMAC:   acc    <= acc + mul_temp;
                `OPSHL:   result <= a << b[2:0];
                `OPLOAD:  result <= b;         
                `OPSTORE: result <= a;         
                `OPSTACC: result <= acc[7:0];  
                default:  result <= result;
            endcase
        end
    end
endmodule
