dtmc

const int max_e1 = 70;  // maximum endurance
const int max_d1 = 40;  // maximum duration
const int max_d2 = 29;  // maximum duration
const int max_e2 = 120; // maximum endurance
const int max_d3 = 40;  // maximum duration
const int max_e3 = 120; // maximum endurance
const int max_d4 = 41;  // maximum duration and point of failure via deadlock at state (30,0,29,80,0,80,1)

module ARDrone1

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

    [actn2] d1=0 & d3=0 & d4=0 & d2>0 & e1>0 -> (d2'=d2-1);

endmodule

module Hummingbird2

    e2 : [0..max_e2] init max_e2; // endurance

    [asst1] e2>0 & d3>0 -> (e2'=e2-1);
    [asst1] e2=0 | d3=0 -> true;

endmodule

module HoverAction3

    d3 : [0..max_d3] init max_d3; // duration

    [asst1] d3>0 & e2>0 -> (d3'=d3-1);
    [asst1] d3=0        -> true;

endmodule

module Hummingbird3 = Hummingbird2[e2=e3, max_e2=max_e3, d3=d4] endmodule
module HoverAction4 = HoverAction3[d3=d4, max_d3=max_d4, e2=e3] endmodule