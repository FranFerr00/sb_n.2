import("sbic2.lib");

tog=hslider("gain_route",0,0,1,0.01);
t=hslider("delay",1,1,20,1);

frw= hslider("freqrw", 1, 0.01, 1, 0.001);
maxf = hslider("maxrw", 1, 1, 100, 0.01);

s=0.1;

process=_,_<:((_<:si.bus(2)),(_<:si.bus(2)):si.bus(4):cross(toggle));
//process=cross(toggle+rw);
//process=rw;
