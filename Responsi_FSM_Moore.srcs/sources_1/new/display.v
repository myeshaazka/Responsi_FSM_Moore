module display(
    input  wire clk,
    input  wire w_in,
    input  wire y_out,
    input  wire [1:0] state,
    output reg [6:0] seg,
    output reg [7:0] an
);

    reg [16:0] scan = 0;
    wire [2:0] sel = scan[16:14];

    // 7-segment common anode, active low
    localparam [6:0] CHAR_0 = 7'b1000000;
    localparam [6:0] CHAR_1 = 7'b1111001;
    localparam [6:0] CHAR_w = 7'b1100011;
    localparam [6:0] CHAR_y = 7'b0010001;
    localparam [6:0] CHAR_S = 7'b0010010;
    localparam [6:0] CHAR_t = 7'b0000111;
    localparam [6:0] BLANK  = 7'b1111111;

    always @(posedge clk) begin
        scan <= scan + 1;
    end

    always @(*) begin
        an = 8'b11111111;
        an[sel] = 1'b0;
        seg = BLANK;

        case (sel)
            // Format: wXyXStXX
            3'd7: seg = CHAR_w;

            3'd6: begin
                if (w_in)
                    seg = CHAR_1;
                else
                    seg = CHAR_0;
            end

            3'd5: seg = CHAR_y;

            3'd4: begin
                if (y_out)
                    seg = CHAR_1;
                else
                    seg = CHAR_0;
            end

            3'd3: seg = CHAR_S;
            3'd2: seg = CHAR_t;

            // State bit MSB
            3'd1: begin
                if (state[1])
                    seg = CHAR_1;
                else
                    seg = CHAR_0;
            end

            // State bit LSB
            3'd0: begin
                if (state[0])
                    seg = CHAR_1;
                else
                    seg = CHAR_0;
            end

            default: seg = BLANK;
        endcase
    end

endmodule