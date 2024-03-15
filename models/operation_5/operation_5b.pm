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

const int i4 = 5;                    // interval
const int icf4 = 2;                  // interval calibration factor
formula ci4 = nse4 ? i4 * icf4 : i4; // current interval

module LidarAction4

    r4 : [0..max_d1] init 0; // readings
    nse4 : bool init false;  // nominal speed exceeded

    [actn1]  mod(d1, ci4)=0 & r4<max_d1 &  spd1=2 -> (r4'=r4+1)&(nse4'=true);
    [actn1]  mod(d1, ci4)=0 & r4<max_d1 & !spd1=2 -> (r4'=r4+1)&(nse4'=false);
    [actn1] !mod(d1, ci4)=0                       -> true;

endmodule

module FreewaySection1 // low speed freeway section

    // 0 = minimum speed
    // 1 = nominal speed
    // 2 = nominal speed exceeded
    spd1 : [0..2] init 1;

    [actn1] spd1=0 -> 0.3:(spd1'=0) + 0.7:(spd1'=1);
    [actn1] spd1=1 -> 0.3:(spd1'=0) + 0.3:(spd1'=1) + 0.4:(spd1'=2);
    [actn1] spd1=2 -> 0.6:(spd1'=1) + 0.4:(spd1'=2);

endmodule

//

const int i5 = 5;                    // interval
const int icf5 = 3;                  // interval calibration factor
formula ci5 = nse5 ? i5 * icf5 : i5; // current interval

module LidarAction5

    r5 : [0..max_d3] init 0; // readings
    nse5 : bool init false;  // nominal speed exceeded

    [actn3]  mod(d3, ci5)=0 & r5<max_d3 &  spd2=2 -> (r5'=r5+1)&(nse5'=true);
    [actn3]  mod(d3, ci5)=0 & r5<max_d3 & !spd2=2 -> (r5'=r5+1)&(nse5'=false);
    [actn3] !mod(d3, ci5)=0                       -> true;

endmodule

module FreewaySection2 // high speed freeway section

    // 0 = minimum speed
    // 1 = nominal speed
    // 2 = nominal speed exceeded
    spd2 : [0..2] init 1;

    [actn3] spd2=0 -> 0.1:(spd2'=0) + 0.9:(spd2'=1);
    [actn3] spd2=1 -> 0.2:(spd2'=0) + 0.3:(spd2'=1) + 0.5:(spd2'=2);
    [actn3] spd2=2 -> 0.5:(spd2'=1) + 0.5:(spd2'=2);

endmodule