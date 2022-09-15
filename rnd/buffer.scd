(
var ixa;

ixa = { |freq, in, index|
    var phase, waveform, snd;
    phase = Phasor.ar(Impulse.ar(0), freq / SampleRate.ir, 0, 1);
    waveform = (phase % 0.5 * 2pi).sin * (2 * (phase % 0.5 < 0.25) - 1);
    waveform = waveform + (2 * (phase % 0.5 >= 0.25));
    waveform = waveform + (2 * (phase >= 0.5));
    snd = (waveform + (in * index)).fold2;
    snd;
};

{
    var freq = 100;
    ixa.(freq, SinOsc.ar(freq), Line.kr(0, 10, 3)) * 0.5 ! 2;
}.play(fadeTime: 0);
)

0.2.coin



log2([1,2,3,4] * MouseX.kr(1,16) + MouseY.kr(1,100)).sin.abs;

log2([1,2,3,4] * 2 + 60).sin.abs;


(
 var levels;

 levels = log2([1,2,3,4] * 10).sin.abs;
)

-0.5.sin.abs

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) !2 * 0.5}.play;

{ PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2) }.plot(1);


(1..10)

[55, 110, 165, 220, 275].choose

[55, 110, 165, 660].rand * (1..10)

[55, 110, 165, 660].choose * (1..10)

[55, 110, 165, 220, 275, 660].rand

{ [rrand(0.52, 1)] } ! 8

{ { rrand(0.01, 1) } ! 2 } ! 8

// Routine {
// 	// var bpm, beat, tatum;
// 	// var s;
// 	// bpm = 160;
// 	// beat = 60 / bpm;
// 	// tatum = beat * 0.25;
// 	// s = Server.default;
//
// 	inf.do({ |i|
// 		// var synth, dur;
// 		// dur = tatum * [1, 2, 4].choose;
// 		// dur = 2;
//
// 		i.postln;
//
// 		dur.wait;
//
// 		/*		Synth(\mspAdder,
// 		[
// 		\freqs: freqs,
// 		\levels: levels,
// 		\pairs: pairs,
// 		\pairs2: pairs2,
// 		\mixerWhite: mixerWhite,
// 		\mixerSub: mixerSub,
// 		\dur: dur
// 		]);	*/
//
// 	});
//
// } .play;

20.do({ 0.5.coin.postln });


0.9.coin;

(

var numPartials = 10;
var levels = {0.1}!numPartials;
var pairsRand = [
	[0.001, 0.001],
	[0.05, 0.9],
	[0.5, 0.5],
	[0.6, 0.4],
	[0.7, 0.3],
	[0.8, 0.2],
	[0.9, 0.1],
	[1.0, 0.001]
];
var n = (1..numPartials);
var envShape = Env.pairs(pairsRand, \exp);
var env = EnvGen.ar(envShape, timeScale: 1, levelScale: 1, doneAction: Done.freeSelf);

levels.postln;
levels = levels * (1 - log2(n * env).sin.abs);
levels.postln;
)

levels = levels * (1 - log2(n * env2).sin.abs);

var dur = pairs.collect{|x,i| x[0]; }.sort.reverse[0] * 10;

"--- dur".postln;
dur.postln;
)

[5,1,2,4].sort.reverse[0];

[1,2,3,4,5,6,7,8,9][0..1]

(
if(0.5.coin) {
	"heads".postln;
} {
	"tails".postln;
};

)

60.max;
160.max(100)

(1..(20.min(20.rand)))

(
var numPartials = 280;
var maxScopeChannels = 80;
var ar = (1..numPartials);
var factor = (numPartials / maxScopeChannels).ceil.max(1).asInteger;
// ar.postln;
"factor: ".post;
factor.postln;
"viz size: ".post;
ar[0, factor..].size.postln;
"viz array:".post;
ar[0, factor..].postln;
)

4.max(1).asInteger

0.1.floor.max(1)

1.2.rand


Env.asr(0.001, 0.9, 1.0).plot;

165 * (1..2);

200.min(30.rand)

-25.dbamp

(
{
loop({
    play({
        var nPartials = 12, nChans = 5, n = nPartials * nChans;
        Splay.ar(Klang.ar(`[ { { rrand(200.0, 2000.0) } ! nPartials } ! nChans, nil, nil ], 1, 0))
             * EnvGen.kr(Env.sine(4), 1, 0.02, doneAction: Done.freeSelf);
    });
    5.wait;
})
}.fork;
)


5.mod(2pi)

pi
2pi

SynthDef(\mspAdderTest, {
	| out = 0, vizOut = 5, envTimeScale = 1, mixerWhite = 0.01, mixerSub = 3, envDuration = 1 |
	var snd, freqMult, n, env, env2, envShape;
	var numPartials = ~numPartials;
	// var envSteps = ~envSteps;
	var envSteps = 8;
	var factor = 2;
	var defaultPairs = { { rrand(0.01, 1) } ! 2 } ! envSteps;
	var freqs = NamedControl.kr(\freqs, {55}!numPartials);
	var levels = NamedControl.kr(\levels, {0.1}!numPartials);
	var pairs = NamedControl.kr(\pairs, defaultPairs);
	var pairs2 = NamedControl.kr(\pairs2, defaultPairs);

	snd = SinOsc.ar(freqs, 0.0, levels);

	// stop pops at the end of the sound
	snd = snd * EnvGen.ar(
		// Env.cutoff(1, 0.95),
		// Env.asr(0.3, 0.9, 1.0),
		// Env.sine(envDuration),
		Env.linen(0.01, (envDuration - 0.2), 0.2, 0.95),
		// Env.linen(0.001, 0.2, 0.1, 0.95, \lin),
		// timeScale: envDuration,
		doneAction: Done.freeSelf
	);

	snd = snd * -45.dbamp;
	// snd = Limiter.ar(snd);
	// snd = FreeVerb.ar(snd, 0.33, 0.7, 0.4);
	// snd = LeakDC.ar(snd);
	Out.ar(out, snd.sum!2);
}).add;