(
w = Window("envelope", Rect(150 , Window.screenBounds.height - 250, 400, 150)).front;
w.view.decorator = FlowLayout(w.view.bounds);

b = EnvelopeView(w, Rect(0, 0, 350, 100))
    .thumbSize_(5)
    .drawLines_(true)
    .fillColor_(Color.green)
    .selectionColor_(Color.red)
    .drawRects_(true)
    .value_([(0.0, 0.1 .. 1.0), (0.0, 0.1 .. 1.0)])
    .setEditable(0,false);
)


10.rand;

[ 1.0.rand, 1.0.rand ] ! 16

Env.pairs({ [ 3.0.rand, 1.0.rand ] } ! 16, \exp).test.plot;



(
// var pairs = { { 1.0.rand } ! 2 } ! 2;
var pairs = [
	[0.0, 0.36],
	[0.55, 0.32]
];
var envShape = Env.pairs(pairs, \exp);

"-200 ---------------------------------- ".postln;
pairs.postln;



Window.closeAll;

envShape.plot;
Env.circle(envShape.levels, envShape.times).plot;

{
	SinOsc.ar(
		EnvGen.kr(
			Env.circle(envShape.levels, envShape.times)
	    ) * 440 - 200
	) * 0.8 ! 2

}.play;

// Env(levels: [0, 0.1, 0.2, 0.3], times: [0.1, 0.1, 0.1], curve: 8).times.postln;
)

a.free;


(
var pairs = { { 1.0.rand } ! 2 } ! 3;
var envShape = Env.pairs(pairs, \exp);
var mod = SinOsc.kr(Rand(0.1, 0.9), 0, Rand(5, 20));

"1200 ---------------------------------- ".postln;
pairs.postln;

Window.closeAll;

envShape.duration = 1;
envShape.plot;
Env.circle(envShape.levels, envShape.times).plot;

b= {
	SinOsc.ar(
		EnvGen.kr(
			// Env.circle([0, 1, 0], [0.01, 0.5, 0.2])
			Env.circle(envShape.levels, envShape.times)
	    ) * 440 + 1200
	) * 0.1

}.play;

// Env(levels: [0, 0.1, 0.2, 0.3], times: [0.1, 0.1, 0.1], curve: 8).times.postln;
)

b.free;

// frequency modulation
(
play {
    DynKlang.ar(`[
		[400, 1000, 1200] + SinOsc.kr([2, 3, 4.2], 0, [13, 24, 12]),
		// [400, 1000, 1200],
        [0.3, 0.3, 0.3],
        [pi,pi,pi]
    ]
) * 0.05
};
)


(
	SynthDef('fullkickdrum', {

		var subosc, subenv, suboutput, clickosc, clickenv, clickoutput;

		subosc = {SinOsc.ar(60)};
		subenv = {Line.ar(1, 0, 1, doneAction: 2)};

		clickosc = {LPF.ar(WhiteNoise.ar(1),1500)};
		clickenv = {Line.ar(1, 0, 0.01)};

		suboutput = (subosc * subenv);
		clickoutput = (clickosc * clickenv);

		Out.ar(0,
			Pan2.ar(suboutput + clickoutput, 0)
		)

	}).send(s);
)

t = Synth('fullkickdrum');



(
fork {
    loop {
        Synth('fullkickdrum');
        1.wait;
    }
}
)

(
SynthDef('kickdrum', {

    var osc, env, output;

    osc = {SinOsc.ar(60)};
    env = {Line.ar(1, 0, 1, doneAction: 2)};

    output = osc * env;

    Out.ar(0,
        Pan2.ar(output, 0)
    )

}).send(s);
)

t = Synth('kickdrum');

(
fork {
    loop {
        Synth('kickdrum');
        0.8.wait;
    }
}
)

(
SynthDef('openhat', {

    var hatosc, hatenv, hatnoise, hatoutput;

    hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

    hatosc = {HPF.ar(hatnoise,2000)};
    hatenv = {Line.ar(1, 0, 0.6)};

    hatoutput = (hatosc * hatenv * 0.8);

    Out.ar(0,
    Pan2.ar(hatoutput, 0)
    )

}).send(s);

SynthDef('closedhat', {

    var hatosc, hatenv, hatnoise, hatoutput;

    hatnoise = {LPF.ar(WhiteNoise.ar(1),6000)};

    hatosc = {HPF.ar(hatnoise,2000)};
    hatenv = {Line.ar(1, 0, 0.005)};

    hatoutput = (hatosc * hatenv * 0.5);

    Out.ar(0,
    Pan2.ar(hatoutput, 0)
    )

}).send(s);
)

o = Synth('openhat');
c = Synth('closedhat');

(
fork {
    loop {
        Synth('closedhat');
        0.5.wait;
    }
}
)

{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007, 0.007])) * 0.3 }.play;

(
SynthDef(\help_Klank, { arg out=0, i_freq;
    var klank, n, harm, amp, ring;

    // harmonics
    harm = \harm.ir(Array.series(4, 1, 1).postln);
    // amplitudes
    amp = \amp.ir(Array.fill(4, 0.05));
    // ring times
    ring = \ring.ir(Array.fill(4, 1));

    klank = Klank.ar(`[harm, amp, ring], {ClipNoise.ar(0.003)}.dup, i_freq);

    Out.ar(out, klank);
}).add;
)

// nothing special yet, just using the default set of harmonics.
a = Synth(\help_Klank, [\i_freq, 300]);
b = Synth(\help_Klank, [\i_freq, 400]);
c = Synth(\help_Klank, [\i_freq, 533.33]);
d = Synth(\help_Klank, [\i_freq, 711.11]);

a.free;
b.free;
c.free;
d.free;
// set harmonics, ring times and amplitudes
(
a = Synth(\help_Klank, [
    \i_freq, 500,
    \harm, [4, 1, 3, 5, 7],
    \ring, Array.fill(4, 0.1), // set shorter ring time
    \amp, Array.fill(4, 0.2) // set louder amps
])
);

(
play({
    Klank.ar(`[
        Array.rand(12, 800.0, 4000.0),         // frequencies
        nil,                             // amplitudes (default to 1.0)
        Array.rand(12, 0.1, 2)                // ring times
        ], Decay.ar(Impulse.ar(4), 0.03, ClipNoise.ar(0.01)))
})
)








