import("stdfaust.lib");
import("seam.lib");
t = hslider("tau", 1, 1, 1000, 1);
g= hslider("gain", 0, -1, 1, 0.01):si.smoo;
frw= hslider("freqrw", 1, 0, 10, 0.001);
maxf = hslider("maxrw",1, 0, 1000, 1);



s=nentry("fc", 0.01, 0.001, 0.9999, 0.001);
tp=2*ma.PI;

omega(fc)= fc*tp/ma.SR;
aapp(fc)=pow(ma.E,(0-omega(fc)));
lp1p(g)= *(1-g):+~*(g);
ingr=_:abs:lp1p(aapp(1/s));

rndw(frw,imin,imax,omin,omax) = (no.pink_noise*10: sfi.lp1p(frw) : sba.scalel(imin,imax,omin,omax));






dev= _*tog:ef.gate_mono(-60,0.1,1,0.1):abs(_)*0.1:_(+~(%(1000)))/1000;



dfl = +@(t-1)~ *(g) : mem;
dfld(g,t) = ( + : de.sdelay(10000,512,t-1))~ *(g) : mem;



tau=t+rndw(frw,-1,1,0,maxf);
apfp=sms.apfvm(ma.SR*5,tau,1/sqrt(2));


process = _<:apfp;