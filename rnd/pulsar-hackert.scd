(
{
    var snd, freq, formantCount, formantFreq, sineCycles, pulsaretPhase, window, randomLFO, randomLFOs, lfoRate;
    formantCount = 3;
    lfoRate = LFDNoise1.kr(0.3).linexp(-1, 1, 0.1, 16);
    randomLFO = {
        var trigger;
        trigger = Dust.kr(lfoRate);
        Select.kr(ToggleFF.kr(trigger), [
            LFNoise2.kr(lfoRate),
            TRand.kr(-1, 1, trigger)
        ]);
    };


    randomLFOs = { { randomLFO.() } ! formantCount };
	freq = randomLFO.().linexp(-1, 1, 1, 1000);
	// freq = 400;
	formantFreq = randomLFOs.().linexp(-1, 1, 2, 8000);
	// formantFreq = 4000;
	sineCycles = randomLFOs.().linlin(-1, 1, 1, 4);
	// sineCycles = 2;
    pulsaretPhase = LFSaw.ar(freq, iphase: 1).linlin(-1, 1, 0, 1) * formantFreq / freq;


    window = pulsaretPhase.lincurve(0, 1, 1, 0, -4);

    snd = sin(pulsaretPhase * 2pi * sineCycles.floor) * window * (pulsaretPhase < 1);

	SendTrig.kr(Impulse.kr(10), 0, snd);

	// ÷snd = snd * randomLFOs.().linlin(-1, 1, 0, 1);
	// snd = Pan2.ar(snd, randomLFOs.() * 0.4);
	// snd = Pan2.ar(snd, 0.5);
	// snd = snd.flop.sum;
	// [0.2, 0.1, 0.05].do { |windowSize|
	// 	snd = PitchShift.ar(snd, windowSize, randomLFO.().linexp(-1, 1, 0.5, 2)) * 6.dbamp;
	// 	snd = FreqShift.ar(snd, randomLFO.() * 100);
	// };
    snd = Limiter.ar(snd);
    snd = snd * -2.dbamp;
    snd;
}.play(fadeTime: 0);
)

(
o = OSCFunc({ |msg| msg.postln }, '/tr', s.addr);
)
\