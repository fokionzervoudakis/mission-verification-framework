dtmc

const int max_e1 = 120; // maximum endurance
const int max_d1 = 30;  // maximum duration
const int max_d2 = 30;  // maximum duration
const int max_d3 = 30;  // maximum duration
const int max_d4 = 30;  // maximum duration

module Hummingbird1

    e1 : [0..max_e1] init max_e1; // endurance

    [actn1] e1>0 & d1>0 -> (e1'=e1-1);
    [actn2] e1>0 & d2>0 -> (e1'=e1-1);
    [actn3] e1>0 & d3>0 -> (e1'=e1-1);
    [actn4] e1>0 & d4>0 -> (e1'=e1-1);
    []      e1=0 | d4=0 -> true;

endmodule

module TraversePathSegmentAction1

    d1 : [0..max_d1] init max_d1; // duration

    [actn1] d1>0 & e1>0 -> (d1'=d1-1);

endmodule

module TraversePathSegmentAction2

    d2 : [0..max_d2] init max_d2; // duration

    [actn2] d1=0 & d2>0 & e1>0 -> (d2'=d2-1);

endmodule

module HoverAction3 = TraversePathSegmentAction2[d2=d3, max_d2=max_d3, actn2=actn3, d1=d2] endmodule
module TraversePathSegmentAction4 = HoverAction3[d3=d4, max_d3=max_d4, actn3=actn4, d2=d3] endmodule