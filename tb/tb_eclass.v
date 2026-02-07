`timescale 1ns/1ps

module tb_eclass;

    // Clock and reset
    reg clk;
    reg rst_n;

    // Clock generation: 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset sequence
    initial begin
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // AXI instruction interface (master_i)
    wire        master_i_arvalid;
    wire [31:0] master_i_araddr;
    wire        master_i_arready;
    wire [63:0] master_i_rdata;
    wire        master_i_rvalid;
    wire [1:0]  master_i_rresp;

    wire [2:0] master_i_arprot;
    wire [2:0] master_i_awprot;

    // AXI data interface (master_d)
    wire        master_d_arvalid;
    wire [31:0] master_d_araddr;
    wire        master_d_arready;
    wire [63:0] master_d_rdata;
    wire        master_d_rvalid;
    wire [1:0]  master_d_rresp;

    wire        master_d_awvalid;
    wire [31:0] master_d_awaddr;
    wire [2:0]  master_d_awprot;
    wire [1:0]  master_d_awsize;
    wire        master_d_m_awready_awready;
    wire        master_d_wvalid;
    wire [63:0] master_d_wdata;
    wire [7:0]  master_d_wstrb;
    wire        master_d_m_wready_wready;
    wire        master_d_m_bvalid_bvalid;
    wire [1:0]  master_d_m_bvalid_bresp;
    wire        master_d_bready;
    wire [1:0]  master_d_arsize;

    // Tie-offs for unused outputs
    wire RDY_sb_clint_msip_put;
    wire RDY_sb_clint_mtip_put;
    wire RDY_sb_clint_mtime_put;
    wire RDY_sb_ext_interrupt_put;
    wire RDY_io_dump_get;

    // Tie constant inputs
    wire EN_sb_clint_msip_put = 1'b0;
    wire EN_sb_clint_mtip_put = 1'b0;
    wire EN_sb_clint_mtime_put = 1'b0;
    wire EN_sb_ext_interrupt_put = 1'b0;
    wire EN_io_dump_get = 1'b0;
    wire sb_clint_msip_put = 0;
    wire sb_clint_mtip_put = 0;
wire [63:0]  sb_clint_mtime_put = 64'b0;
    wire sb_ext_interrupt_put = 0;
wire [166:0] io_dump_get       = 167'b0;

    // Instantiate E-Class CPU
    mkeclass dut (
        .CLK(clk),
        .RST_N(rst_n),

        .master_d_awvalid(master_d_awvalid),
        .master_d_awaddr(master_d_awaddr),
        .master_d_awprot(master_d_awprot),
        .master_d_awsize(master_d_awsize),
        .master_d_m_awready_awready(master_d_m_awready_awready),
        .master_d_wvalid(master_d_wvalid),
        .master_d_wdata(master_d_wdata),
        .master_d_wstrb(master_d_wstrb),
        .master_d_m_wready_wready(master_d_m_wready_wready),
        .master_d_m_bvalid_bvalid(master_d_m_bvalid_bvalid),
        .master_d_m_bvalid_bresp(master_d_m_bvalid_bresp),
        .master_d_bready(master_d_bready),
        .master_d_arvalid(master_d_arvalid),
        .master_d_araddr(master_d_araddr),
        .master_d_arprot(master_d_awprot),
        .master_d_arsize(master_d_arsize),
        .master_d_m_arready_arready(master_d_arready),
        .master_d_m_rvalid_rvalid(master_d_rvalid),
        .master_d_m_rvalid_rresp(master_d_rresp),
        .master_d_m_rvalid_rdata(master_d_rdata),
        .master_d_rready(master_d_bready),

        .master_i_awvalid(),
        .master_i_awaddr(),
        .master_i_awprot(master_i_awprot),
        .master_i_awsize(),
        .master_i_m_awready_awready(),
        .master_i_wvalid(),
        .master_i_wdata(),
        .master_i_wstrb(),
        .master_i_m_wready_wready(),
        .master_i_m_bvalid_bvalid(),
        .master_i_m_bvalid_bresp(),
        .master_i_bready(),
        .master_i_arvalid(master_i_arvalid),
        .master_i_araddr(master_i_araddr),
        .master_i_arprot(master_i_arprot),
        .master_i_arsize(),
        .master_i_m_arready_arready(master_i_arready),
        .master_i_m_rvalid_rvalid(master_i_rvalid),
        .master_i_m_rvalid_rresp(master_i_rresp),
        .master_i_m_rvalid_rdata(master_i_rdata),
        .master_i_rready(),

        .sb_clint_msip_put(sb_clint_msip_put),
        .EN_sb_clint_msip_put(EN_sb_clint_msip_put),
        .RDY_sb_clint_msip_put(RDY_sb_clint_msip_put),

        .sb_clint_mtip_put(sb_clint_mtip_put),
        .EN_sb_clint_mtip_put(EN_sb_clint_mtip_put),
        .RDY_sb_clint_mtip_put(RDY_sb_clint_mtip_put),

        .sb_clint_mtime_put(sb_clint_mtime_put),
        .EN_sb_clint_mtime_put(EN_sb_clint_mtime_put),
        .RDY_sb_clint_mtime_put(RDY_sb_clint_mtime_put),

        .sb_ext_interrupt_put(sb_ext_interrupt_put),
        .EN_sb_ext_interrupt_put(EN_sb_ext_interrupt_put),
        .RDY_sb_ext_interrupt_put(RDY_sb_ext_interrupt_put),

        .EN_io_dump_get(EN_io_dump_get),
        .io_dump_get(io_dump_get),
        .RDY_io_dump_get(RDY_io_dump_get)
    );

    // Instruction memory (AXI-lite)
    axi_lite_mem imem (
        .CLK(clk),
        .RST_N(rst_n),
        .arvalid(master_i_arvalid),
        .araddr(master_i_araddr),
        .arready(master_i_arready),
        .rdata(master_i_rdata),
        .rvalid(master_i_rvalid),
        .rresp(master_i_rresp)
    );

    // Data memory (AXI-lite)
    axi_lite_mem dmem (
        .CLK(clk),
        .RST_N(rst_n),
        .arvalid(master_d_arvalid),
        .araddr(master_d_araddr),
        .arready(master_d_arready),
        .rdata(master_d_rdata),
        .rvalid(master_d_rvalid),
        .rresp(master_d_rresp)
    );

    // VCD dump for waveform
    initial begin
        $dumpfile("eclass.vcd");
        $dumpvars(0, tb_eclass);
    end

    // Simulation timeout
    initial begin
        $display("=== ECLASS CORE SIM START ===");
        #1000;
        $display("=== TIMEOUT ===");
        $finish;
    end

    // Monitor instruction fetch addresses
    always @(posedge clk) begin
        if (master_i_arvalid && master_i_arready)
            $display("IFETCH addr = 0x%08x at time %0t", master_i_araddr, $time);
    end

endmodule
