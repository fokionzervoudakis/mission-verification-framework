dtmc

const int max_e1 = 70;  // maximum endurance
const int max_d1 = 40;  // maximum duration
const int max_d2 = 30;  // maximum duration
const int max_d3 = 40;  // maximum duration
const int max_d4 = 29;  // maximum duration

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

module PhotoSurveillanceAction3

    d3 : [0..max_d3] init max_d3; // duration

    [actn1] d3>0 & e1>0 -> (d3'=d3-1);
    [actn1] d3=0        -> true;

    [actn2] d3>0 & e1>0 -> (d3'=d3-1);
    [actn2] d3=0        -> true;

endmodule

module PhotoSurveillanceAction4

    d4 : [0..max_d4] init max_d4; // duration

    [actn1] d1>0 | d3>0               -> true;
    [actn1] d1=0 & d3=0 & d4>0 & e1>0 -> (d4'=d4-1);
    [actn1]               d4=0        -> true;

    [actn2] d1>0 | d3>0               -> true;
    [actn2] d1=0 & d3=0 & d4>0 & e1>0 -> (d4'=d4-1);
    [actn2]               d4=0        -> true;

endmodule