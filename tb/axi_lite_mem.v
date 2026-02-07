`timescale 1ns/1ps

module axi_lite_mem(
    input wire CLK,
    input wire RST_N,
    input wire arvalid,
    input wire [31:0] araddr,
    output reg arready,
    output reg [63:0] rdata,
    output reg rvalid,
    output reg [1:0] rresp
);

    reg [31:0] mem [0:4095];

    // Load NOP instructions if prog.hex exists
    initial begin
        if ($fopen("prog.hex"))
            $readmemh("prog.hex", mem);
    end

    always @(posedge CLK) begin
        if (!RST_N) begin
            arready <= 0;
            rvalid  <= 0;
            rdata   <= 0;
            rresp   <= 2'b0;
        end else begin
            arready <= 1'b1; // Always ready
            if (arvalid) begin
                rdata  <= {32'b0, mem[araddr[13:2]]}; // lower 32 bits
                rvalid <= 1'b1;
                rresp  <= 2'b00;
            end else begin
                rvalid <= 0;
            end
        end
    end

endmodule
