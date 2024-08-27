import("stdfaust.lib");


tog=hslider("gain_dev",0,0,1,0.01);
t=hslider("delay",1,1,20,1);



//filtro



//router
cross(x)= _*x,_*(1-x),_*(1-x),_*x:_,ro.cross(2),_;


//
//cond=(_*tog)/2:filtr(freqdev,qdev):ef.gate_mono(ba.linear2db(0.01),1,1,0.01):abs(_)*0.01:_(+~(%(100))):_*0.01;

//trigger
toggle=tog:ba.ramp(ma.SR*t);


process=_,_<:((_<:si.bus(2)),(_<:si.bus(2)):si.bus(4):cross(toggle));

//process=_+_:cond;
