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


[55, 110, 165, 220, 275].choose

[55, 110, 165, 660].rand * (1..10)

[55, 110, 165, 660].choose * (1..10)

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

// pairsRand = { { 1.0.rand } ! 2 } ! 8;
var pairs = [ [ 0.46644532680511, 0.95408070087433 ], [ 0.79316735267639, 0.72445929050446 ], [ 0.66931366920471, 0.13437724113464 ], [ 0.45547497272491, 0.63586318492889 ], [ 0.96265351772308, 0.66731905937195 ] ];

var dur = pairs.collect{|x,i| x[0]; }.sort.reverse[0] * 10;

"--- dur".postln;
dur.postln;
)

[5,1,2,4].sort.reverse[0];

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