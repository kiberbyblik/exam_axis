module tb #(parameter DATA_WIDTH = 32);

    logic clk;
    logic arstn_i = 0;

    logic [DATA_WIDTH-1:0] s_axis_tdata;
    logic s_axis_tvalid = 0;
    logic s_axis_tready;

    logic [DATA_WIDTH-1:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready = 0;


    ///////////////////
    //  Connections  //
    ///////////////////

    axis_reg #(DATA_WIDTH) dut (
        .clk_i(clk),
        .arstn_i(arstn_i),
        .s_axis_tdata_i(s_axis_tdata),
        .s_axis_tvalid_i(s_axis_tvalid),
        .s_axis_tready_o(s_axis_tready),
        .m_axis_tdata_o(m_axis_tdata),
        .m_axis_tvalid_o(m_axis_tvalid),
        .m_axis_tready_i(m_axis_tready)
    );

    //////////////////////////////////
    //  Master & salve declaration  //
    //////////////////////////////////

    class axis_slave_agent;
        int transaction_count = 0;

        task run(int num_transactions);
            for (int i = 0; i < num_transactions; i++) begin
                @(posedge clk);
                s_axis_tdata  = $urandom();
                s_axis_tvalid = 1;

                do @(posedge clk); while (!s_axis_tready);

                s_axis_tvalid = 0;
                transaction_count++;
            end
        endtask
    endclass

    class axis_master_agent #(parameter DATA_WIDTH = 32, parameter RANDOMIZE_READY = 1);
    int received_count = 0;
    int delay_counter = 0;

    task run();
        forever begin
            @(posedge clk);

            if (RANDOMIZE_READY) begin
                if (delay_counter > 0) begin
                    m_axis_tready = 0;
                    delay_counter--;
                end else begin
                    m_axis_tready = 1;

                    if (m_axis_tvalid && m_axis_tready) begin
                        $display("Master received: 0x%08h", m_axis_tdata);
                        received_count++;

                        if ($urandom_range(0, 3) == 0)
                            delay_counter = $urandom_range(1, 3);
                    end
                end
            end else begin
                m_axis_tready = 1;
                
                if (m_axis_tvalid && m_axis_tready) begin
                    $display("Master received: 0x%08h", m_axis_tdata);
                    received_count++;
                end
            end
        end
    endtask
    endclass

    axis_slave_agent  slave_agent;
    axis_master_agent master_agent;
    
    /* Reset task */
    task reset();
        arstn_i = 0;
        repeat (2) @(posedge clk);
        arstn_i = 1;
    endtask

    /* Clock start initial */
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    /* Main initial */
    initial begin
        slave_agent  = new();
        master_agent = new();

        reset();

        fork
            slave_agent.run(10);
            master_agent.run();
        join_none

        wait (master_agent.received_count == 10);
        $display("Test complete. Received %0d transactions.", master_agent.received_count);
        #10 $finish;
    end

endmodule
