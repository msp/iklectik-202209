(	// create controls directly with literal arrays:
SynthDef(\dynsynth, {| freqs = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	amps = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	rings = #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]|
	Out.ar(0, DynKlang.ar(`[freqs, amps, rings]))
}).add
)

(
var bufsize, ms, slid, cspec, rate;
var harmonics = 20;
GUI.qt;

x = Synth(\dynsynth).setn(
				\freqs, Array.fill(harmonics, {|i| 110*(i+1)}),
				\amps, Array.fill(harmonics, {0})
				);

// GUI :
w = Window("harmonics", Rect(200, 470, 20*harmonics+40,140)).front;
ms = MultiSliderView(w, Rect(20, 10, 20*harmonics, 110));
ms.value_(Array.fill(harmonics,0.0));
ms.isFilled_(true);
ms.indexThumbSize_(10.0);
ms.strokeColor_(Color.blue);
ms.fillColor_(Color.blue(alpha: 0.2));
ms.gap_(10);
ms.action_({
	x.setn(\amps, ms.value*harmonics.reciprocal);
});
)