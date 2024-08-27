import("stdfaust.lib");
import("seam.lib");
t = hslider("tau", 1, 1, 1000, 1);
g= hslider("gain", 0, 0, 0.99, 0.01):si.smoo;
f= hslider("freq", 1, 0.001, 20, 0.001);
frw(y)= (y:an.rms_envelope_t60(1):@(ma.SR*10));
maxf = hslider("maxrw", 1, 1, 500, 0.01);
grw= hslider("gainrw", 0, 0, 2, 0.01):si.smoo;




rndw(frw,imin,imax,omin,omax,y) = no.pink_noise*maxf : sfi.lp1p(frw(y)) : sba.scalel(imin,imax,omin,omax);



s=hslider("fc", 0.01, 0.001, 0.9999, 0.001);
tp=2*ma.PI;

omega(fc)= fc*tp/ma.SR;
aapp(fc)=pow(ma.E,(0-omega(fc)));
//aapp(fc)=(0-omega(fc)):aa.tanh;
lp1p(g)= *(1-g):+~*(g);
ingr=_:abs:lp1p(aapp(1/s));
envelope=(rndw(frw,-1,1,0,1):ingr):abs;
process=_<:(_*(envelope:min(1)));