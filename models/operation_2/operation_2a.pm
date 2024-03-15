dtmc

const int max_e1 = 70;  // maximum endurance
const int max_d1 = 40;  // maximum duration
const int max_d2 = 29;  // maximum duration
const int max_e2 = 120; // maximum endurance
const int max_d3 = 39;  // maximum duration

module ARDrone1

    e1 : [0..max_e1] init max_e1; // endurance

    [actn1] e1>0 & d1>0 -> (e1'=e1-1);
    [actn2] e1>0 & d2>0 -> (e1'=e1-1);
    []      e1=0 | d2=0 -> true;

endmodule

module HoverAction1

    d1 : [0..max_d1] init max_d1; // duration

    [actn1] d1>0 & e1>0 -> (d1'=d1-1);

endmodule

module HoverAction2

    d2 : [0..max_d2] init max_d2; // duration

    [actn2] d1=0 & d2>0 & e1>0 -> (d2'=d2-1);

endmodule

module Hummingbird2

    e2 : [0..max_e2] init max_e2; // endurance

    [actn3] e2>0 & d3>0 -> (e2'=e2-1);
    []      e2=0 | d3=0 -> true;

endmodule

module HoverAction3 = HoverAction1[d1=d3, max_d1=max_d3, actn1=actn3, e1=e2] endmodule