(
SynthDef(\addSynthArray, { arg freq=300, dur=0.5, mul=100, addDiv=8, partials = #[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], amps = #[ 0.30, 0.15, 0.10, 0.07, 0.06, 0.05, 0.04, 0.03, 0.03, 0.03, 0.02, 0.02, 0.02, 0.02, 0.02 ];
	var signal, env;
	env = EnvGen.ar(Env.perc(0.01, dur), doneAction: 2);
	signal = Mix.arFill(partials.size, {arg i;
				SinOsc.ar(
					freq * partials[i],
					0,
					amps[i]
				)});

	Out.ar(0, signal.dup * env)
	}).add
)


Synth(\addSynthArray, [\freq, 600])


Synth(\addSynthArray, [\freq, 400, \partials, {|i| (i+1)+rrand(-0.2, 0.2)}!15])

(
fork {  // fork is basically a Routine
	100.do({
		// partial frequencies:
		// f = Array.fill(15, {arg i; i=i+1; i}).postln; // harmonic spectra (saw wave)
		f = Array.fill(15, {10.0.rand}); // inharmonic spectra (a bell?)
		// partial amplitudes:
		// a = Array.fill(15, {arg i; i=i+1; 1/i;}).normalizeSum.postln; // saw wave amps
		a = Array.fill(15, {1.0.rand}).normalizeSum.postln; // random amp on each harmonic

		Synth(\addSynthArray).set(\partials, f, \amps, a);
		rrand(0.15, 0.65).wait;
	});
}
)

fork {  // fork is basically a Routine
        100.do({
		n = rrand(10, 45);
		"Number of UGens: ".post; n.postln;
		{ Mix.fill(n , {
			SinOsc.ar( [67.0.rrand(2000), 67.0.rrand(2000)], 0, n.reciprocal)
			*
			EnvGen.kr(Env.sine(rrand(4.0, 10) ) )
		}) * EnvGen.kr(Env.perc(11, 6), doneAction: 2, levelScale: 0.75)
		}.play;
		rrand(5, 10).wait;
		})
}

{ Klang.ar(`[ Array.rand(12, 600.0, 1000.0), nil, nil ], 1, 0) * 0.05 }.play;