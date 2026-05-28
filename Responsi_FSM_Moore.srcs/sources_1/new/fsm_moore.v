module fsm_moore(
    input  wire clk,
    input  wire reset,
    input  wire ce,
    input  wire w,
    output reg y,
    output wire [1:0] state_display
);

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] curr, next;

    assign state_display = curr;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            curr <= S0;
        else if (ce)
            curr <= next;
    end

    // Next state logic sesuai diagram
    always @(*) begin
        next = curr;

        case (curr)
            S0: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S1;
            end

            S1: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S2;
            end

            S2: begin
                if (w == 1'b0)
                    next = S3;
                else
                    next = S2;
            end

            S3: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S2;
            end

            default: next = S0;
        endcase
    end

    // Output Moore: hanya bergantung pada state
    always @(*) begin
        case (curr)
            S0: y = 1'b0;
            S1: y = 1'b1;
            S2: y = 1'b1;
            S3: y = 1'b0; // Kalau S3 harus Y=1, ubah jadi 1'b1
            default: y = 1'b0;
        endcase
    end

endmodule