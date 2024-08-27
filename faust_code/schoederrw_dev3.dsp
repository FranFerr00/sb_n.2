import("stdfaust.lib");
import("seam.lib");



t = hslider("tau", 100, 1, 10000, 1);
tog=hslider("gain_dev",0,0,1,0.01);
g=hslider("gain",0,0,1,0.01);




//INTEGRATORE
s0=0.1;
//s1=nentry("fcg", 0.01, 0.00001, 0.9999, 0.00001);
s2=0.8;
tp=2*ma.PI;
//frequenza di 
omega(fc)= fc*2*ma.PI/ma.SR;
//

aapp(fc)=pow(ma.E,(0-omega(fc)));

lp1p(g)= *(1-g):+~*(g);
x=_;
ingr(x,s)=x:abs:lp1p(aapp(1/s));






rndwmc(frw,imin,imax,omin,omax) = no.multinoise(8): par(i,8,_*1000*(i+1):sfi.lp1p(frw)) : par(i,8,sba.scalel(imin,imax,omin,(omax*(i+1)))):par(i,8,ingr(x,s2));


dev= _*tog:ef.gate_mono(-60,0.1,1,0.1):abs(_):_(+~(%(ma.SR)));


dfl(x,y,rw)=y:sms.dflcvm(ma.SR*2,(t+rw+dev(x)),g);
apfprw(x,y,rw)= y:sms.apfvm(ma.SR*2,((t+rw+dev(x))),1/sqrt(2));



shroederrw(x) = _<:si.bus(4),rndwmc(1,-1,1,0,100):(_,ro.crossn1(6):_,_,_,ro.crossn1(4):_,_,_,_,_,ro.crossn1(2):par(i,4,dfl(x)):>_),si.bus(4):apfprw(x),si.bus(3):apfprw(x),si.bus(2):apfprw(x),si.bus(1):apfprw(x);
process=_,(_<:_,_):ro.cross(2),_:(shroederrw:fi.dcblocker),dev/ma.SR;
//process=rndwmc(frw,-1,1,0,maxf);