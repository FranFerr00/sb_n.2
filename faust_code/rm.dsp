import("stdfaust.lib");
import("seam.lib");

freq=hslider("freqp",3,1,100,0.001);
n1=os.osc(fr)+1/2;
fig=1.5;



t1 = hslider("tau1", 1, 1, 1000, 2);
t2 = hslider("tau2", 1,1, 1000, 2);
g1=1/sqrt(2) ;


filtr(freq,q)=fi.lowpass(16,freq+q/2) :fi.highpass(16,freq-q/2);

dev(freqdev,qdev,x)= x:filtr(freqdev,qdev):ef.gate_mono(-60,0.1,1,0.1):abs(_)*0.001:_(+~(%(100)))/100;


t = hslider("tau", 1, 1, 1000, 1);
g= hslider("gain", 0, 0, 2, 0.01):si.smoo;
f= hslider("freq", 1, 0.001, 200, 0.001);
frw= 10;
maxf = 100;

rndw(frw,imin,imax,omin,omax) = no.pink_noise*maxf : sfi.lp1p(frw) : sba.scalel(imin,imax,omin,omax);
n4=rndw(frw,-1,1,0,1);



irr(x)=_*ba.pulsen(10000,ma.SR/(freq+(dev(500,50,x)*10))):(abs(_)*n4*fig+(dev(400,50,x)*0.01):(+ ~ de.sdelay(ma.SR,ma.SR/2,ba.sec2samp(n4*fig*0.1)): (_ %(1000+n4*fig*0.01))):_ %1):fi.dcblocker:_*g;


//process=abs(_)*0.0001 : + ~ (_ %100) ;
//rmpazzo(x)=_<:(_*0.01*ba.pulsen(10000,ma.SR/(freq+(dev(500,50,x)))):(abs(_)*n4*fig+(dev(400,50,x)*10):(+ ~ de.sdelay(ma.SR,ma.SR/2,ba.sec2samp(n4*fig*0.01)): (_ %(1000+n4*fig*0.01))):_ %1):fi.dcblocker:_*g)*_;

//process=_<:rmpazzo,dev(500,50);
process=_<:(_*irr),dev(500,50);
//process=_*ba.pulsen(1,ma.SR/freq);