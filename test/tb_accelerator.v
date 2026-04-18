`timescale 1ns / 1ps

module tb_accelerator();
    reg clk, rstn, ena;
    wire [7:0] uoout;

    tt_um_accelerator uut (
        .uiin(8'h0), .uioin(8'h0), 
        .uoout(uoout), .uioout(), .uiooe(), 
        .ena(ena), .clk(clk), .rstn(rstn)
    );

    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; 
    end

    initial begin
        ena = 1;
        rstn = 0;      
        #100 rstn = 1; 
        #30000;        
        $finish;
    end
endmodule
