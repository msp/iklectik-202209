

(
// we create a SynthDef
SynthDef(\oscsynth, {
	arg bufnum, freq = 440, ts = 1;
	a = Osc.ar(bufnum, freq, 0, 0.2) * EnvGen.ar(Env.perc(0.01), timeScale: ts, doneAction:2);
	Out.ar(0, a ! 2);
}).add;
)
// and then we fill the buffer with our waveform and generate the GUI
(
var bufsize, ms, slid, cspec, freq;
var harmonics;

freq = 55;
bufsize=4096;
harmonics=50;

b=Buffer.alloc(s, bufsize, 1);

x = Synth(\oscsynth, [\bufnum, b.bufnum, \ts, 0.1]);

// GUI :
w = Window("harmonics", Rect(200, 470, 20*harmonics+140,150)).front;
ms = MultiSliderView(w, Rect(20, 20, 20*harmonics, 100));
ms.value_(Array.fill(harmonics,0.0));
ms.isFilled_(true);
ms.valueThumbSize_(1.0);
ms.canFocus_(false);
ms.indexThumbSize_(10.0);
ms.strokeColor_(Color.blue);
ms.fillColor_(Color.blue(alpha: 0.2));
ms.gap_(10);
ms.action_({ b.sine1(ms.value, false, true, true) }); // set the harmonics
slid=Slider(w, Rect(20*harmonics+30, 20, 20, 100));
cspec= ControlSpec(70,1000, 'exponential', 10, 440);
slid.action_({
	freq = cspec.map(slid.value);
	[\frequency, freq].postln;
	x.set(\freq, cspec.map(slid.value));
	});
slid.value_(0.3);
slid.action.value;
Button(w, Rect(20*harmonics+60, 20, 70, 20))
	.states_([["Plot",Color.black,Color.clear]])
	.action_({	a = b.plot });
Button(w, Rect(20*harmonics+60, 44, 70, 20))
	.states_([["Start",Color.black,Color.clear], ["Stop!",Color.black,Color.clear]])
	.action_({arg sl;
		if(sl.value ==1, {
			x = Synth(\oscsynth, [\bufnum, b.bufnum, \freq, freq, \ts, 1000]);
			},{x.free;});
	});
Button(w, Rect(20*harmonics+60, 68, 70, 20))
	.states_([["Play",Color.black,Color.clear]])
	.action_({
		Synth(\oscsynth, [\bufnum, b.bufnum, \freq, freq, \ts, 0.1]);
	});
Button(w, Rect(20*harmonics+60, 94, 70, 20))
	.states_([["Play rand",Color.black,Color.clear]])
	.action_({
		Synth(\oscsynth, [\bufnum, b.bufnum, \freq, rrand(20,100)+50, \ts, 0.1]);
	});
)