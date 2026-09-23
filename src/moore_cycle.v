`timescale 1ns/1ps
module moore_cycle (
    input wire clk, rst, enable, advance,
    output reg [1:0] value
);
    always @(posedge clk) begin
        if (rst) value <= 2'b00;
        else if (enable && advance) begin
            case (value)
                2'b00: value <= 2'b01;
                2'b01: value <= 2'b10;
                default: value <= 2'b00;
            endcase
        end
    end
endmodule
