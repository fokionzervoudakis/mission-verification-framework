dtmc

const int max_e1 = 120; // maximum endurance
const int max_d1 = 30;  // maximum duration
const int max_d2 = 30;  // maximum duration
const int max_d3 = 30;  // maximum duration
const int max_d4 = 30;  // maximum duration
const int max_d5 = 35;  // maximum duration
const int max_d6 = 12;  // maximum duration and point of failure

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

module PhotoSurveillanceAction5

    d5 : [0..max_d5] init max_d5; // duration
    r5 : bool init false;         // running

    [actn3] d2=0 & d5>0 & e1>0 -> (d5'=d5-1)&(r5'=true);
    [actn3]        d5=0        -> (r5'=false);

    [actn4] d2=0 & d5>0 & e1>0 -> (d5'=d5-1)&(r5'=true);
    [actn4]        d5=0        -> (r5'=false);

endmodule

module PhotoSurveillanceAction6

    d6 : [0..max_d6] init max_d6; // duration
    r6 : bool init false;         // running

    [actn4] d3=0 & d6>0 & e1>0 -> (d6'=d6-1)&(r6'=true);
    [actn4]        d6=0        -> (r6'=false);

endmodule

//

const int start2 = 15; // threat area incursion start for TraversePathSegmentAction2
const int start3 = 30; // threat area incursion start for HoverAction1
const int start4 = 30; // threat area incursion start for TraversePathSegmentAction3
const int finish2 = 0; // threat area incursion end for TraversePathSegmentAction2
const int finish3 = 0; // threat area incursion end for HoverAction1
const int finish4 = 5; // threat area incursion end for TraversePathSegmentAction3
formula actn2_tai = d2>finish2 & d2<=start2; // threat area incursion during TraversePathSegmentAction2
formula actn3_tai = d3>finish3 & d3<=start3; // threat area incursion during HoverAction1
formula actn4_tai = d4>finish4 & d4<=start4; // threat area incursion during TraversePathSegmentAction3

module Hummingbird1_Survivability

    a1d : bool init false; // Hummingbird 1 destroyed

    [actn2] !a1d &  actn2_tai -> 0.99:(a1d'=false) + 0.01:(a1d'=true);
    [actn2]  a1d | !actn2_tai -> true;

    [actn3] !a1d &  actn3_tai -> 0.99:(a1d'=false) + 0.01:(a1d'=true);
    [actn3]  a1d | !actn3_tai -> true;

    [actn4] !a1d &  actn4_tai -> 0.99:(a1d'=false) + 0.01:(a1d'=true);
    [actn4]  a1d | !actn4_tai -> true;

endmodule

formula duration2 = start2 - finish2;
formula duration3 = start3 - finish3;
formula duration4 = start4 - finish4;

formula tkad1 = duration2 + duration3 + duration4; // total threat area action durations

module SensorActionCounter1

    sad1 : [0..tkad1] init 0; // sensor action duration

    [actn3]  actn3_tai &  r5 & sad1<tkad1 -> (sad1'=sad1+1);
    [actn3] !actn3_tai | !r5              -> true;

    [actn4]  actn4_tai &  (r5 | r6) & sad1<tkad1 -> (sad1'=sad1+1);
    [actn4] !actn4_tai | !(r5 | r6)              -> true;

endmodule

formula raf1 = sad1 / tkad1; // risk acceptability factor
