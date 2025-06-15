`ifndef AXI_STREAM_TRANSACTION
`define AXI_STREAM_TRANSACTION

class axi_stream_transaction;

  // Declaring the transaction fields
  rand logic        [`AXI_DATA_W -1:0] data [$];

 constraint data_size_c {
    data.size() <= 10;
  }
  
  function void display(string name);
    $display("-------------------------");
    $display("TIME: %0t", $realtime);
    $display("-------------------------");
    $display("- %s ", name);
    $display("-------------------------");
    $display("- Data: ");
    $display("%p", data);
    $display("- Data Size: ");
    $display("%d", data.size());
    $display("-------------------------");
  endfunction
  
  function void copy(axi_stream_transaction src);
      this.data = src.data;
  endfunction
endclass : axi_stream_transaction

`endif //!AXI_STREAM_TRANSACTION
