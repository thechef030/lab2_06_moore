`timescale 1ns/1ps
// Combo II-DLD S75. Main clock B6 MUST be set to 1 kHz.
// K4: reset. N8: step button. DIPS W1..8 = sw[7]..sw[0].
module lab2_moore #(parameter STABLE_CYCLES = 20) (
    input wire clk, rst, button,
    input wire [7:0] sw,
    output wire [7:0] led
);
    wire reset, press;
    wire [7:0] switches;
    input_frontend #(.STABLE_CYCLES(STABLE_CYCLES)) inputs(
        clk, rst, button, sw, reset, press, switches);
    wire [1:0] value;
    moore_cycle core(clk, reset, press, switches[7], value);
    assign led = {6'b000000, value};
endmodule
