// BrickBoy polariser rot / "Vinegar Syndrome".
//
// This is a fixed-point sampling of the original FRAG_DEFECTS equations, not
// an independently designed look. tools/bake_vinegar.py evaluates Kathoc's
// four-octave fBm, superellipse/blob geometry, seed 7, coverage curve and
// opacity curve. The six maps are three depths for each original pattern.
// Unique native-grid nodes retain 8-bit opacity in four parity banks, allowing
// all four cell corners to be read together and bilinearly expanded across the
// 4x4 output pixels. The original rot colour is (0.11, 0.07, 0.14), or RGB888
// (28,18,36).

module brick_vinegar (
	input  wire        clk,
	input  wire [9:0]  gx,
	input  wire [9:0]  gy,
	input  wire [1:0]  depth,       // 0 off; 1=.25, 2=.50, 3=1.00
	input  wire        blob_mode,   // 0 centre/superellipse; 1 blobs
	input  wire [23:0] in_rgb,
	output reg  [23:0] out_rgb
);

// A cell's four nodes always occupy the four different x/y parity banks.
// Storing every node once removes the old four-way corner duplication and
// leaves enough M10Ks to retain source-like 8-bit opacity.
reg [47:0] map_ee[0:5912]; // 81 x 73: even x, even y
reg [47:0] map_eo[0:5839]; // 80 x 73: odd  x, even y
reg [47:0] map_oe[0:5831]; // 81 x 72: even x, odd  y
reg [47:0] map_oo[0:5759]; // 80 x 72: odd  x, odd  y
initial begin
	$readmemh("rtl/brickboy/brick_vinegar_map_ee.hex", map_ee);
	$readmemh("rtl/brickboy/brick_vinegar_map_eo.hex", map_eo);
	$readmemh("rtl/brickboy/brick_vinegar_map_oe.hex", map_oe);
	$readmemh("rtl/brickboy/brick_vinegar_map_oo.hex", map_oo);
end

wire [7:0] nx = gx[9:2];
wire [7:0] ny = gy[9:2];
wire [1:0] sx = gx[1:0];
wire [1:0] sy = gy[1:0];
wire [2:0] map_no = (depth == 0) ? 3'd0 :
	                 (blob_mode ? 3'd3 : 3'd0) + {1'b0, depth} - 3'd1;
wire [7:0] ix_even = {1'b0, nx[7:1]} + nx[0];
wire [7:0] ix_odd  = {1'b0, nx[7:1]};
wire [7:0] iy_even = {1'b0, ny[7:1]} + ny[0];
wire [7:0] iy_odd  = {1'b0, ny[7:1]};
wire [12:0] addr_ee = iy_even * 81 + ix_even;
wire [12:0] addr_eo = iy_even * 80 + ix_odd;
wire [12:0] addr_oe = iy_odd  * 81 + ix_even;
wire [12:0] addr_oo = iy_odd  * 80 + ix_odd;

reg [47:0] q_ee, q_eo, q_oe, q_oo;
reg [1:0] sx0, sy0;
reg [1:0] depth0;
reg [2:0] map_no0;
reg nx_odd0, ny_odd0;
reg [23:0] c0;
always @(posedge clk) begin
	q_ee <= map_ee[addr_ee];
	q_eo <= map_eo[addr_eo];
	q_oe <= map_oe[addr_oe];
	q_oo <= map_oo[addr_oo];
	sx0 <= sx;
	sy0 <= sy;
	depth0 <= depth;
	map_no0 <= map_no;
	nx_odd0 <= nx[0];
	ny_odd0 <= ny[0];
	c0 <= in_rgb;
end

function automatic [7:0] map_sample(input [47:0] q, input [2:0] n);
	case (n)
		3'd0: map_sample = q[7:0];
		3'd1: map_sample = q[15:8];
		3'd2: map_sample = q[23:16];
		3'd3: map_sample = q[31:24];
		3'd4: map_sample = q[39:32];
		default: map_sample = q[47:40];
	endcase
endfunction

wire [7:0] v_ee = map_sample(q_ee, map_no0);
wire [7:0] v_eo = map_sample(q_eo, map_no0);
wire [7:0] v_oe = map_sample(q_oe, map_no0);
wire [7:0] v_oo = map_sample(q_oo, map_no0);
reg [7:0] a, b, c, d;
always @(*) begin
	case ({ny_odd0, nx_odd0})
		2'b00: begin a = v_ee; b = v_eo; c = v_oe; d = v_oo; end
		2'b01: begin a = v_eo; b = v_ee; c = v_oo; d = v_oe; end
		2'b10: begin a = v_oe; b = v_oo; c = v_ee; d = v_eo; end
		default: begin a = v_oo; b = v_oe; c = v_eo; d = v_ee; end
	endcase
end

wire [2:0] wx0 = 3'd4 - {1'b0, sx0};
wire [2:0] wy0 = 3'd4 - {1'b0, sy0};
wire [10:0] top = a * wx0 + b * {1'b0, sx0};
wire [10:0] bot = c * wx0 + d * {1'b0, sx0};
wire [12:0] op_i = top * wy0 + bot * {1'b0, sy0};

reg [7:0] op1;
reg [23:0] c1;
always @(posedge clk) begin
	op1 <= (depth0 == 0) ? 8'd0 : (op_i + 13'd8) >> 4;
	c1 <= c0;
end

function automatic [7:0] blend(input [7:0] v, input [7:0] rot,
	                              input [7:0] op);
	reg [16:0] p;
	begin
		p = v * (9'd256 - op) + rot * op + 17'd128;
		blend = p[15:8];
	end
endfunction

always @(posedge clk) begin
	out_rgb <= {blend(c1[23:16], 8'd28, op1),
	            blend(c1[15:8],  8'd18, op1),
	            blend(c1[7:0],   8'd36, op1)};
end

endmodule
