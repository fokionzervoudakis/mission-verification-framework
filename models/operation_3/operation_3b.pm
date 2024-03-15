dtmc

const int max_e1 = 70;  // maximum endurance
const int max_d1 = 69;  // maximum duration
const int max_d2 = 69;  // maximum duration

module ARDrone1

    e1 : [0..max_e1] init max_e1; // endurance

    [actn1] e1>0 & d1>0 -> (e1'=e1-1);
    []      e1=0 | d1=0 -> true;

endmodule

module HoverAction1

    d1 : [0..max_d1] init max_d1; // duration

    [actn1] d1>0 & e1>0 -> (d1'=d1-1);

endmodule

module PhotoSurveillanceAction2

    d2 : [0..max_d2] init max_d2; // duration

    [actn1] d2>0 & e1>0 -> (d2'=d2-1);
    [actn1] d2=0        -> true;

endmodule