Trig.kr(1, 0.9)

{ Dust.ar(1) }.play;

{ Trig.kr(FSinOsc.ar(800), 0.1).poll }.play;

{ Impulse.ar(3).poll; }.play;

Env
//adapted from 2.18 Vibrations of a Stiff String, p61, Thomas D. Rossing and Neville H. Fletcher (1995) Principles of Vibration and Sound. New York: Springer-Verlag
(
var modes,modefreqs,modeamps;
var mu,t,e,s,k,f1,l,c,a,beta,beta2,density;
var decaytimefunc;
var material;

material= \nylon; //\nylon; // \steel

//don't know values of E and mu for a nylon/gut string
//so let's try steel

//radius 1 cm
a=0.01;

s=pi*a*a;

//radius of gyration
k=a*0.5;


if (material ==\nylon,{

	e=2e+7;

	density=2000;

},{//steel

	e= 2e+11; // 2e+7; //2e+11 steel;

	//density p= 7800 kg m-3
	//linear density kg m = p*S

	density=12800;
});

mu=density*s;

t=100000;

c= (t/mu).sqrt;	//speed of sound on wave

l=1.8;	//0.3

f1= c/(2*l);

beta= (a*a/l)*((pi*e/t).sqrt);

beta2=beta*beta;

modes=10;

modefreqs= Array.fill(modes,{arg i;
	var n,fr;
	n=i+1;

	fr=n*f1*(1+beta+beta2+(n*n*pi*pi*beta2*0.125));

	if(fr>21000, {fr=21000}); //no aliasing

	fr
});

decaytimefunc= {arg freq;
	var t1,t2,t3;
	var m,calc,e1dive2;

	//VS p 50 2.13.1 air damping

	m=(a*0.5)*((2*pi*freq/(1.5e-5)).sqrt);

	calc= 2*m*m/((2*(2.sqrt)*m)+1);

	t1= (density/(2*pi*1.2*freq))*calc;

	e1dive2=0.01; //a guess!

	t2= e1dive2/(pi*freq);

	//leave G as 1
	t3= 1.0/(32*mu*l*freq*freq*1);

	1/((1/t1)+(1/t2)+(1/t3))
};

modeamps=Array.fill(modes,{arg i; decaytimefunc.value(modefreqs.at(i))});

modefreqs.postln;
modeamps.postln;

Window.closeAll;

{
	var output;
	var envLevels = [0, 1, 1, 0];
	var envTimes = [0, 5, 2, 0];
	var pairs = { [ 1.0.rand, 4.0.rand ] } ! 16;
	pairs.postln;git
	// var envTimeLevelPairs = [
	// 	[0, 1],
	// 	[1, 0.7],
	// 	[1, 0.1],
	// 	[1, 1],
	// 	[1, 0]
	// ];
	//EnvGen.ar(Env.new([0.001,1.0,0.9,0.001],[0.001,0.01,0.3],'exponential'),WhiteNoise.ar)
	//could slightly vary amps and phases with each strike?

	output=EnvGen.ar(
	Env.new([0,1,1,0],[0,5,0]),doneAction:2)*
	//slight initial shape favouring lower harmonics- 1.0*((modes-i)/modes)
	Mix.fill(modes,{arg i; XLine.ar(1.0,modeamps.at(i),10.0)*SinOsc.ar(modefreqs.at(i),0,1.0/modes)});

	// Env.pairs(pairs, \exp).circle.test.plot;

	// output=EnvGen.ar(
		// Env.pairs(pairs, \exp),doneAction:2)*
	//slight initial shape favouring lower harmonics- 1.0*((modes-i)/modes)
		// Mix.fill(modes,{arg i; XLine.ar(1.0,modeamps.at(i),10.0)*SinOsc.ar(modefreqs.at(i),0,1.0/modes)});

/*	output=EnvGen.ar(
        Env([0, 1, 0, 0.2, 0, 0.5, 0.8, 0], [0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01], releaseNode: 5, loopNode: 1), gate: Trig.kr(1, dur: 1) )*
	    //slight initial shape favouring lower harmonics- 1.0*((modes-i)/modes)
	    Mix.fill(modes,{arg i; XLine.ar(1.0,modeamps.at(i),10.0)*SinOsc.ar(modefreqs.at(i),0,1.0/modes)}
	);*/

	Pan2.ar(output,0)
}.play;

)
