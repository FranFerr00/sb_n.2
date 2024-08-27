import("sbic2.lib");
import("seam.lib");
ta = hslider("[1]tau", 1, 1, 10000, 1);
s1=hslider("[0]freq_dfl", 0.1,0.0001,1,0.0001);

frw= hslider("[2]freqrw", 1, 0, 10, 0.001);
maxf = hslider("[4]maxrw",1,0, 1000, 1);



gain_dev=hslider("input_dev",0,0,1,0.01);

s= hslider("freq_rnd", 0.1,0.0001,1,0.0001);
tp=2*ma.PI;
//frequenza di 
omega(fc)= fc*2*ma.PI/ma.SR;
//

aapp(fc)=pow(ma.E,(0-omega(fc)));



g1=hslider("gain_fb", 0.1,0.0001,1,0.0001);

lp1p(g)= *(1-g):+~*(g);
ingr=_:abs:lp1p(aapp(1/s));

rndw(frw,imin,imax,omin,omax) = (no.pink_noise*10: sfi.lp1p(frw) : sba.scalel(imin,imax,omin,omax)):ingr;

dev= _*gain_dev:ef.gate_mono(-60,0.1,1,0.1):abs(_):_(+~(%(ma.SR)))/ma.SR;


tau(a)=ta+rndw(frw,-1,1,0,maxf)+(dev(a)*ma.SR);

dfl(a)=_:dflcvm(ma.SR*10,tau(a),g1);

//process = _<:dfl,dev,tog;
//process=no.noise<:ro.cross(2):_,(_<:_,_):dfl,dev,tog;
process=_<:dfl,dev;