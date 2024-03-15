dtmc

const int max_e1 = 120; // maximum endurance
const int max_d1 = 30;  // maximum duration
const int max_d2 = 30;  // maximum duration
const int max_d3 = 30;  // maximum duration

module Hummingbird1

    e1 : [0..max_e1] init max_e1; // endurance

    [actn1] e1>0 & d1>0 -> (e1'=e1-1);
    [actn2] e1>0 & d2>0 -> (e1'=e1-1);
    [actn3] e1>0 & d3>0 -> (e1'=e1-1);
    []      e1=0 | d3=0 -> true;

endmodule

module HoverAction1

    d1 : [0..max_d1] init max_d1; // duration

    [actn1] d1>0 & e1>0 -> (d1'=d1-1);

endmodule

module TraversePathSegmentAction2

    d2 : [0..max_d2] init max_d2; // duration

    [actn2] d1=0 & d2>0 & e1>0 -> (d2'=d2-1);

endmodule

module HoverAction3

    d3 : [0..max_d3] init max_d3; // duration

    [actn3] d2=0 & d3>0 & e1>0 -> (d3'=d3-1);

endmodule

//

const int i4 = 5; // interval
const int i5 = 5; // interval

module LidarAction4

    r4 : [0..max_d1] init 0; // readings

    [actn1]  mod(d1, i4)=0 & r4<max_d1 -> (r4'=r4+1);
    [actn1] !mod(d1, i4)=0             -> true;

endmodule

module LidarAction5 = LidarAction4[r4=r5, max_d1=max_d3, actn1=actn3, d1=d3, i4=i5] endmodule