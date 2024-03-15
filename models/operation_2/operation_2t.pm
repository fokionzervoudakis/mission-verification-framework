dtmc

const int max_e1 = 120; // maximum endurance
const int max_d1 = 60;  // maximum duration
const int max_d2 = 30;  // maximum duration
const int max_e2 = 120; // maximum endurance
const int max_d3 = 30;  // maximum duration
const int max_d4 = 30;  // maximum duration
const int max_e3 = 120; // maximum endurance
const int max_d5 = 31;  // maximum duration and point of failure via deadlock at state (90,30,30,90,0,30,90,1)

module Hummingbird1

    e1 : [0..max_e1] init max_e1; // endurance

    [asst1] e1>0 & d1>0 -> (e1'=e1-1);
    [actn2] e1>0 & d2>0 -> (e1'=e1-1);
    []      e1=0 | d2=0 -> true;

endmodule

module HoverAction1

    d1 : [0..max_d1] init max_d1; // duration

    [asst1] d1>0 & e1>0 -> (d1'=d1-1);

endmodule

module HoverAction2

    d2 : [0..max_d2] init max_d2; // duration

    [actn2] d1=0 & d4=0 & d2>0 & e1>0 -> (d2'=d2-1);

endmodule

module Hummingbird2

    e2 : [0..max_e2] init max_e2; // endurance

    [asst1] e2>0 & d3>0 -> (e2'=e2-1);
    [asst1] e2>0 & d4>0 -> (e2'=e2-1);
    [asst1] e2=0 | d4=0 -> true;

endmodule

module HoverAction3

    d3 : [0..max_d3] init max_d3; // duration

    [asst1] d3>0 & e2>0 -> (d3'=d3-1);
    [asst1] d3=0        -> true;

endmodule

module HoverAction4

    d4 : [0..max_d4] init max_d4; // duration

    [asst1] d3>0                      -> true;
    [asst1] d3=0 & d5=0 & d4>0 & e2>0 -> (d4'=d4-1);
    [asst1]               d4=0        -> true;

endmodule

module Hummingbird3

    e3 : [0..max_e3] init max_e3; // endurance

    [asst1] e3>0 & d5>0 -> (e3'=e3-1);
    [asst1] e3=0 | d5=0 -> true;

endmodule

module HoverAction5

    d5 : [0..max_d5] init max_d5; // duration

    [asst1] d5>0 & e3>0 -> (d5'=d5-1);
    [asst1] d5=0        -> true;

endmodule