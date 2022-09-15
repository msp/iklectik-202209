(
// var s = Server.default;
// Window.closeAll;
SynthDef (\msp, {
	arg out = 0;
	var pitchEnv = Env([1, [1, 2, 3], 0.5, 0.5, [3, 2, 1], 2], [1, 1, 0.5, 1], [[\exp, \sin]]);
	var ampEnv =   Env.circle([0, 1, 0], [0.5, 0.5, 0.2]);
	var freq = 55;
	var numPartials = 60;
	var n = (1..numPartials);
	var freqs = freq * n;
	var snd;
	freqs = freqs  * (1 + (n * n * 0.000521)).abs.sqrt;

	// pitchEnv.plot;

	snd = SinOsc.ar(
		EnvGen.kr(ampEnv) * freqs,
		// freqs,
		0,
		// 1 * -20.dbamp
		[EnvGen.ar(ampEnv) * -20.dbamp]
	);

	Out.ar(out, snd);

	// snd.poll(label:"server value");
	// snd.poll().dump;
}).add;

// Stethoscope(s,2);
// s.scopeWindow.size = 1920;
// s.scope.style = 2;
// s.scope.numChannels = 20;
// // s.scope.index = 12;
// s.scope.scopeView.waveColors([Color.rand,Color.rand]);
)

z = Synth.new(\msp, [\out, ~vizBus]);
z.free;

s.options.numAudioBusChannels;
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

(
SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;

	sig = In.ar(in, ~numPartials);
	// sig = SinOsc.ar(440, 0, 0.3);

	// stereo spread
	// sig = sig[0,2..].sum + ([-1,1] * sig[1,3..].sum);
	sig = sig.sum!2;
	sig = sig * -8.dbamp;
	sig = FreeVerb.ar(sig, 0.2, 0.7, 0.4, 1);
	Out.ar(out, sig);
}).add;
)

y = Synth.new(\reverb, [\in, ~audioBus]);
y.free;

Stethoscope.ugenScopes;

x = { SinOsc.ar({155}!40, 0, 0.5) }.play(s, ~vizBus);
x.free;


Env.circle(
	[0, 1, 0],
	[0.5, 0.5, 0.2]
).plot;
)


("aaaa" +11+ "bbb").postln;

Buffer

Bus