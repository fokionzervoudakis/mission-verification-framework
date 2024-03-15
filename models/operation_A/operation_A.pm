dtmc

const int max_e1 = 120; // maximum endurance
const int max_d1 = 60;  // maximum duration
const int max_d2 = 60;  // maximum duration
const int max_e2 = 120; // maximum endurance
const int max_d3 = 60;  // maximum duration
const int max_d4 = 60;  // maximum duration
const int max_d5 = 50;  // maximum duration

module Hummingbird1

    e1 : [0..max_e1] init max_e1; // endurance

    [asst1] e1>0 & d1>0 -> (e1'=e1-1);
    [asst1] e1>0 & d2>0 -> (e1'=e1-1);
    [asst1] e1=0 | d2=0 -> true;

endmodule

module TraversePathSegmentAction1

    d1 : [0..max_d1] init max_d1; // duration

    [asst1] d1>0 & e1>0 -> (d1'=d1-1);
    [asst1] d1=0        -> true;

endmodule

module TraversePathSegmentAction2

    d2 : [0..max_d2] init max_d2; // duration

    [asst1] d1>0                      -> true;
    [asst1] d1=0 & d3=0 & d2>0 & e1>0 -> (d2'=d2-1);
    [asst1]               d2=0        -> true;

endmodule

module Hummingbird2

    e2 : [0..max_e2] init max_e2; // endurance

    [asst1] e2>0 & d3>0 -> (e2'=e2-1);
    [asst1] e2>0 & d4>0 -> (e2'=e2-1);
    [asst1] e2=0 | d4=0 -> true;

endmodule

module TraversePathSegmentAction3

    d3 : [0..max_d3] init max_d3; // duration

    [asst1] d3>0 & e2>0 -> (d3'=d3-1);
    [asst1] d3=0        -> true;

endmodule

module TraversePathSegmentAction4

    d4 : [0..max_d4] init max_d4; // duration

    [asst1] d3>0               -> true;
    [asst1] d3=0 & d4>0 & e2>0 -> (d4'=d4-1);
    [asst1]        d4=0        -> true;

endmodule

module PhotoSurveillanceAction5

    d5 : [0..max_d5] init max_d5; // duration
    r5 : bool init false;         // running

    [asst1] d3>0               -> true;
    [asst1] d3=0 & d5>0 & e1>0 -> (d5'=d5-1)&(r5'=true);
    [asst1]        d5=0        -> (r5'=false);

endmodule

//

const int start4 = 60; // threat area incursion start for TraversePathSegmentAction4
const int finish4 = 0; // threat area incursion end for TraversePathSegmentAction4
formula actn4_tai = d4>finish4 & d4<=start4; // threat area incursion during TraversePathSegmentAction4

module Hummingbird2_Survivability

    a2d : bool init false; // Hummingbird 2 destroyed

    [asst1] !a2d &  actn4_tai -> 0.99:(a2d'=false) + 0.01:(a2d'=true);
    [asst1]  a2d | !actn4_tai -> true;

endmodule

formula duration4 = start4 - finish4;

formula tkad2 = duration4; // total kinetic action durations

module SensorActionCounter2

    sad2 : [0..tkad2] init 0; // sensor action duration

    [asst1]  actn4_tai &  (r5) & sad2<tkad2 -> (sad2'=sad2+1);
    [asst1] !actn4_tai | !(r5) -> true;

endmodule

formula raf2 = sad2 / tkad2; // risk acceptability factor