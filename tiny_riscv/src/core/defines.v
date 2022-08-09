

`define CpuResetAddr    32'b0

`define RstEnable       1'b0
`define RstDisable      1'b1
`define JumpEnable      1'b0
`define JumpDisable     1'b1

`define INT_BUS         7:0


`define Hold_Flag_Bus   2:0
`define Hold_None       3'b000
`define Hold_Pc         3'b001
`define Hold_If         3'b010
`define Hold_Id         3'b011


`define RomNum          4096

`define MemNum          4096
`define MemBus          31:0
`define MemAddrBus      31:0

`define InstBus         31:0
`define InstAddrBus     31:0

`define RegAddrBus      4:0
`define RegBus          31:0
`define DoubleRegBus    63:0
`define RegWidth        32
`define RegNum          32
`define RegNumLog2      2
