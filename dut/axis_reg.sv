module axis_reg #(
    DATA_WIDTH = 32

)(
    input  logic                  clk_i,
    input  logic                  arstn_i,

    input  logic [DATA_WIDTH-1:0] s_axis_tdata_i,
    input  logic                  s_axis_tvalid_i,
    output logic                  s_axis_tready_o,

    output logic [DATA_WIDTH-1:0] m_axis_tdata_o,
    output logic                  m_axis_tvalid_o,
    input  logic                  m_axis_tready_i
);


    //////////////////////////
    //  Local Declarations  //
    //////////////////////////

    logic                  s_axis_tready_reg;
    logic                  m_axis_tvalid_reg;
    logic [DATA_WIDTH-1:0] data_reg;

    ////////////////////////
    //  AXI4-S reg logic  //
    ////////////////////////

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            s_axis_tready_reg <= 'b0;
            m_axis_tvalid_reg <= 'b0;
            data_reg          <= 'd0;
        end else begin
            /* Readiness management */
            s_axis_tready_reg <= m_axis_tvalid_reg ? m_axis_tready_i : 1'b1;

            /* Valid control */
            if (s_axis_tready_reg && s_axis_tvalid_i) begin
                m_axis_tvalid_reg <= 'b1;
                data_reg          <= s_axis_tdata_i;
            end else if (m_axis_tready_i && m_axis_tvalid_reg) begin
                m_axis_tvalid_reg <= 'b0;
            end
        end
    end

    /* Comb logic */
    always_comb begin
        s_axis_tready_o = s_axis_tready_reg;
        m_axis_tvalid_o = m_axis_tvalid_reg;
        m_axis_tdata_o  = data_reg;
    end 

endmodule