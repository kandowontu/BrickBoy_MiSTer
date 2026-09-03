// BrickBoy polariser rot / "Vinegar Syndrome".
//
// This is a fixed-point sampling of the original FRAG_DEFECTS equations, not
// an independently designed look. tools/bake_vinegar.py evaluates Kathoc's
// four-octave fBm, superellipse/blob geometry, seed 7, coverage curve and
// opacity curve.  The six maps are three depths for each original pattern.
// Four 3-bit node samples are packed per native LCD cell and bilinearly
// expanded across its 4x4 output pixels here. The original rot colour is
// (0.11, 0.07, 0.14), or RGB888 (28,18,36).

module brick_vinegar (
	input  wire        clk,
	input  wire [9:0]  gx,
	input  wire [9:0]  gy,
	input  wire [1:0]  depth,       // 0 off; 1=.25, 2=.50, 3=1.00
	input  wire        blob_mode,   // 0 centre/superellipse; 1 blobs
	input  wire [23:0] in_rgb,
	output reg  [23:0] out_rgb
);

localparam int CELLS = 160 * 144;
reg [71:0] map[0:CELLS-1];
initial $readmemh("rtl/brickboy/brick_vinegar_map.hex", map);

wire [7:0] nx = gx[9:2];
wire [7:0] ny = gy[9:2];
wire [1:0] sx = gx[1:0];
wire [1:0] sy = gy[1:0];
wire [2:0] map_no = (depth == 0) ? 3'd0 :
	                 (blob_mode ? 3'd3 : 3'd0) + {1'b0, depth} - 3'd1;
wire [14:0] addr = ny * 160 + nx;

reg [71:0] q0;
reg [1:0] sx0, sy0;
reg [1:0] depth0;
reg [2:0] map_no0;
reg [23:0] c0;
always @(posedge clk) begin
	q0 <= map[addr];
	sx0 <= sx;
	sy0 <= sy;
	depth0 <= depth;
	map_no0 <= map_no;
	c0 <= in_rgb;
end

reg [11:0] corners;
always @(*) begin
	case (map_no0)
		3'd0: corners = q0[11:0];
		3'd1: corners = q0[23:12];
		3'd2: corners = q0[35:24];
		3'd3: corners = q0[47:36];
		3'd4: corners = q0[59:48];
		default: corners = q0[71:60];
	endcase
end

function automatic [3:0] expand3(input [2:0] v);
	case (v)
		3'd0: expand3 = 4'd0;
		3'd1: expand3 = 4'd2;
		3'd2: expand3 = 4'd4;
		3'd3: expand3 = 4'd6;
		3'd4: expand3 = 4'd9;
		3'd5: expand3 = 4'd11;
		3'd6: expand3 = 4'd13;
		default: expand3 = 4'd15;
	endcase
endfunction

wire signed [5:0] a = $signed({2'b00, expand3(corners[2:0])});
wire signed [5:0] b = $signed({2'b00, expand3(corners[5:3])});
wire signed [5:0] c = $signed({2'b00, expand3(corners[8:6])});
wire signed [5:0] d = $signed({2'b00, expand3(corners[11:9])});
wire signed [7:0] top = (a <<< 2) + (b - a) * $signed({1'b0, sx0});
wire signed [7:0] bot = (c <<< 2) + (d - c) * $signed({1'b0, sx0});
wire signed [9:0] op_i = (top <<< 2) + (bot - top) * $signed({1'b0, sy0});

reg [7:0] op1;
reg [23:0] c1;
always @(posedge clk) begin
	op1 <= (depth0 == 0) ? 8'd0 : op_i[7:0]; // Q0.8; maximum 240 = .9375
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
