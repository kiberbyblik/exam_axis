`ifndef AXIS_PKG
`define AXIS_PKG

`include "axis_defines.sv"

package axis_pkg;

  typedef enum {DRIVE_REQ, GET_RESP}  e_apb_driver_state;
  typedef enum {ADDR = 0, ID = 1}     e_route_state;
  typedef enum {DRIVE_INITIAL, DRIVE} e_axis_driver_state;
  endpackage

`endif //!AXIS_PKG