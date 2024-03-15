dtmc

const int max_e1 = 120; // maximum endurance
const int max_d1 = 40;  // maximum duration
const int max_d2 = 40;  // maximum duration
const int max_d3 = 40;  // maximum duration
const int max_e2 = 120; // maximum endurance
const int max_d4 = 40;  // maximum duration
const int max_d5 = 41;  // maximum duration and point of failure via deadlock at state (40,0,0,40,40,0,1)

module Hummingbird1

    e1 : [0..max_e1] init max_e1; // endurance

    [asst1] e1>0 & d1>0 -> (e1'=e1-1);
    [asst1] e1>0 & d2>0 -> (e1'=e1-1);
    [actn3] e1>0 & d3>0 -> (e1'=e1-1);
    []      e1=0 | d3=0 -> true;

endmodule

module HoverAction1

    d1 : [0..max_d1] init max_d1; // duration

    [asst1] d1>0 & e1>0 -> (d1'=d1-1);
    [asst1] d1=0        -> true;

endmodule

module HoverAction2

    d2 : [0..max_d2] init max_d2; // duration

    [asst1] d1>0               -> true;
    [asst1] d1=0 & d2>0 & e1>0 -> (d2'=d2-1);

endmodule

module HoverAction3

    d3 : [0..max_d3] init max_d3; // duration

    [actn3] d2=0 & d5=0 & d3>0 & e1>0 -> (d3'=d3-1);

endmodule

module Hummingbird2

    e2 : [0..max_e2] init max_e2; // endurance

    [asst1] e2>0 & d4>0 -> (e2'=e2-1);
    [asst1] e2>0 & d5>0 -> (e2'=e2-1);
    [asst1] e2=0 | d5=0 -> true;

endmodule

module HoverAction4

    d4 : [0..max_d4] init max_d4; // duration

    [asst1] d4>0 & e2>0 -> (d4'=d4-1);
    [asst1] d4=0        -> true;

endmodule

module HoverAction5

    d5 : [0..max_d5] init max_d5; // duration

    [asst1] d4>0               -> true;
    [asst1] d4=0 & d5>0 & e2>0 -> (d5'=d5-1);
    [asst1]        d5=0        -> true;

endmodule