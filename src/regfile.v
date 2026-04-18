module regfile (
    input  wire clk, rstn, wren,
    input  wire [2:0] addra, addrb, addrdest,
    input  wire [7:0] din,
    output wire [7:0] douta, doutb
);
    reg [7:0] storage [0:7];
    assign douta = storage[addra];
    assign doutb = storage[addrb];
    integer i;
    always @(posedge clk) begin
        if (!rstn) begin
            for (i=0; i<8; i=i+1) storage[i] <= 8'h00;
        end else if (wren) begin
            storage[addrdest] <= din;
        end
    end
endmodule
