`timescale 1ns/1ps
// Main clock is 1 kHz: STABLE_CYCLES=20 means 20 ms.
// Set switches first, then press the button; the bus is not an atomic CDC.
module input_frontend #(parameter STABLE_CYCLES = 20) (
    input wire clk, rst, button,
    input wire [7:0] sw,
    output wire reset,
    output reg press,
    output wire [7:0] switches
);
    (* ASYNC_REG = "TRUE" *) reg [1:0] reset_pipe;
    (* ASYNC_REG = "TRUE" *) reg button_meta, button_sync;
    (* ASYNC_REG = "TRUE" *) reg [7:0] sw_meta, sw_sync;
    localparam integer WIDTH = (STABLE_CYCLES < 2) ? 1 : $clog2(STABLE_CYCLES);
    reg [WIDTH-1:0] count;
    reg accepted;
    assign reset = reset_pipe[1];
    assign switches = sw_sync;
    // Asynchronous assertion; release follows two main-clock edges.
    always @(posedge clk or posedge rst) begin
        if (rst) reset_pipe <= 2'b11;
        else reset_pipe <= {reset_pipe[0], 1'b0};
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            button_meta <= 0; button_sync <= 0;
            sw_meta <= 0; sw_sync <= 0;
        end else begin
            button_meta <= button; button_sync <= button_meta;
            sw_meta <= sw; sw_sync <= sw_meta;
        end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0; accepted <= 0; press <= 0;
        end else begin
            press <= 0;
            if (button_sync == accepted) count <= 0;
            else if (count == STABLE_CYCLES - 1) begin
                accepted <= button_sync;
                count <= 0;
                press <= button_sync;
            end else count <= count + 1'b1;
        end
    end
endmodule
