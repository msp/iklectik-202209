
// INIT ////////////////////////////////////////////////////////////
(
s.meter;
s.plotTree;
)

// If these change, re-run the SynthDefs!
(
~numPartials = 280;
~maxScopeChannels = 80;
~envSteps = 8;
~numPartials.dump;
~synths = [];
~seq;
~vizBus.free();
~audioBus = 0;
// ~audioBus.free();
~vizBus = Bus.audio(s, ~maxScopeChannels);
// ~audioBus = Bus.audio(s, ~numPartials);
~vizBus.dump;
// ~audioBus.dump;
~scope;
~factor = { arg numPartials;
	var factor = (numPartials / ~maxScopeChannels).ceil.max(1).asInteger;
	("-MSP FACTOR ("+factor+")-------------------------------- ").postln;
	factor;
}
)

(
~vizBus.dump;
// ~audioBus.dump;
)

// SCOPE ///////////////////////////////////////////////////////////
(
~scope = ~vizBus.scope;
)



(
~scope.index = ~vizBus.index;
~scope.numChannels = 30;
~scope.zoom =  1.4;
~scope.yZoom = 16;
~scope.style = 0;
)

// CONTROL /////////////////////////////////////////////////////////
(
~seq;
// ~seq.play;
~seq.stop;
~seq.beats;
~seq.seconds;
~seq.clock;
~synths;
~synths.collect{|x,i| x.free; };
~synths = [];
)

// EXECUTE! ////////////////////////////////////////////////////////
(
// NB: must match value in SynthDef!
var numPartials = ~numPartials;
var envSteps = ~envSteps;
var envTimeScale = 4;
var n = (1..numPartials);
var freq = 55;
var freqChoices = [55, 110, 165, 220, 275, 660];
var freqs = [];
var levels = [];
var tilt = -3;
var pairs = [];
var pairs2 = [];
var pairsRand = [];
var mixerWhite = 0.04;
var mixerSub = 3;
var r;
var dur;
var tmpViz = [];
var factor = 2;
var scopeStyle = 0;

~seq = Routine {
    inf.do({ arg count;
		mixerWhite = rrand(0.01, 0.08);
		// mixerSub = rrand(0.5,5);
		mixerSub = 0;

		// Sometimes go very lowercase with <= 30 partials
		// if(0.4.coin) {
		if(0.8.coin) {
			n = (1..(numPartials.min(30.rand)));
			// mixerWhite = 0.04;
		} {
			n = (1..numPartials);
		};

		factor = ~factor.value(n.size);

		tmpViz = n[0, factor..];
		("-MSP SCOPE ("+tmpViz.size+")-------------------------------- ").postln;

		// http://doc.sccode.org/Guides/GUI-Introduction.html#Caution:%20GUI%20and%20timing
		{
			scopeStyle = [0, 2].wchoose([0.92, 0.08]);

			// ~scope.dump;
			~scope.index = ~vizBus.index;
			~scope.numChannels = tmpViz.size;

			// 0 == tracks
			// 2 == X/Y
			if(scopeStyle == 0) {
				if(n.size > 25) {
					~scope.zoom  = [12, 14, 16].wchoose([0.33, 0.33, 0.34]);
					~scope.yZoom = rrand(2, 16);
				} {
					~scope.zoom =  rrand(0.4, 1.5);
					~scope.yZoom = 16;
				};
			} {
				// ~scope.zoom =  [0, 1, 2].wchoose([0.65, 0.25, 0.10]);
				~scope.zoom =  1.2.rand;
				~scope.yZoom = [8, 10, 12].wchoose([0.33, 0.33, 0.34]);
			};
			~scope.style = scopeStyle;
		}.defer;

		("-MSP PARTIALS ("+n.size+")----------------------------- ").postln;

		freq = freqChoices.choose;
		("-MSP FREQ ("+freq+")--------------------------------- ").postln;
		freqs = freq * n;
		// envStepsMult = rrand(8,16); // the steps must be fixed in the synthdef


		// envTimeScale = rrand(1,3);

		if(0.5.coin) {
			envTimeScale = rrand(2,4);
		} {
			envTimeScale = rrand(14, 23);
		};

		//tilt EQ to roll off harsh highs
		levels = 1 * (log2(n) * tilt).dbamp;


		("-MSP TIMESCALE ("+envTimeScale+")------------------------ ").postln;
		// FREQS /////////////////////////////////////////////////////////
		//frequency dispersion
		freqs = freqs  * (1 + (n * n * 0.000521)).abs.sqrt;

		// ** TODO MSP Play with these values for timbre **

		// Hmm, sometimes these get out of sync
		if(freqs.size == levels.size) {
			if(0.2.coin) {
				freqs.collectInPlace{|x,i| if((i%2) == 0) {levels.put(i,0.0); x;} {x;}};
			} {};
		} {
			"freqs.size: ".post;
			freqs.size.postln;
			"levels.size: ".post;
			levels.size.postln;
		};

		if(0.8.coin) {
			("-MSP INHARMONIC SHIFT ------------------------------ ").postln;
			// inharmonic frequency shift of every 4th partial by 20 hz
			freqs.collectInPlace{|x,i| if((i%4) == 0) {x = x + 20;} {x;}};
		} {};


		if(0.4.coin) {
			("-MSP 3RD PARTIAL ----------------------------------- ").postln;
			// harmonic ratio multiplication of every 3rd partial
			freqs.collectInPlace{|x,i| if((i%3) == 0) {x = x * 1.5;} {x;}};
		} {};


		if(0.5.coin) {
			("-MSP 5TH PARTIAL ----------------------------------- ").postln;
			freqs.collectInPlace{|x,i| if((i%5) == 0) {x = x * 5;} {x;}};
			// freqs.collectInPlace{|x,i| if((i%5) == 0) {x = x + rrand(450, 550);} {x;}};
			levels.collectInPlace{|x,i| if((i%5) == 0) {x = x * 0.5;} {x;}};
		} {};

		freqs.postln;

		// LEVELS ////////////////////////////////////////////////////////
		//uncomment this to silence every 2nd harmonic, creating a square-like timbre
		// levels.collectInPlace{|x,i| if(i.even) {x = x*0.0;} {x;}};

		//periodic filter approximation?
		//x axis controls phase, y axis number of peaks/troughs. exponent controls steepness
		// levels.collectInPlace{|x,i| {x * (((i/MouseY.kr(0.5,48) + MouseX.kr(0,8)).sin.abs) ** 4);}};

		//different approach from nathan ho's video
		// levels = levels * (1 - log2(n * MouseX.kr(1,16) + MouseY.kr(1,100)).sin.abs);
		// levels.plot;

		// "-MSP freqs 2 ---------------------------------- ".postln;
		// freqs.collectInPlace{|x,i| XLine.kr(x, freqs.scramble[i], 0.3) };

		//mute all sines above 20k to prevent aliasing
		freqs.collectInPlace{|x,i| if(x>20000) {levels.put(i,0.0); x;} {x;}};

		// ENV ///////////////////////////////////////////////////////////
		pairsRand = { { rrand(0.01, 1.0) } ! 2 } ! envSteps;
		// pairsRand = { [1.0.rand, rrand(0., 0.8)] } ! envSteps;

		// the length of the ENV will be the max time value in the [time,level] pairs
		// times the scale
		dur = pairsRand.collect{|x,i| x[0]; }.sort.reverse[0] * envTimeScale;
		// pairsRand = { { 1.0.rand } ! 2 } ! 8;
		//
		// pairs = [ [ 0.46644532680511, 0.95408070087433 ], [ 0.79316735267639, 0.72445929050446 ], [ 0.66931366920471, 0.13437724113464 ], [ 0.45547497272491, 0.63586318492889 ], [ 0.46265351772308, 0.66731905937195 ] ];

		("-MSP DUR ("+dur+")------------------------- ").postln;
		("-MSP ENV ---------------------------------- ").postln;
		// pairs = pairs ++ [[1.0, 0.001]];
		pairs = pairsRand.collect{|x,i| [x[1], x[0]] };
		pairs2 = pairsRand.collect{|x,i| [x[1], x[0]] };
		// pairs2 = pairs;

		// {
		// 	Env.pairs(pairs, \exp).plot;
		// }.defer;

		pairs.postln;

		("-MSP FIRING! ("+count+")***************************** ").postln;
		("***************************************************** ").postln;
		"".postln;
		"".postln;
		"".postln;

		~synths.add(
			Synth(\mspAdder,
			[
				\out: ~audioBus,
				\vizOut: ~vizBus,
				\freqs: freqs,
				\levels: levels,
				\pairs: pairs,
				\pairs2: pairs2,
					\mixerWhite: mixerWhite,
					// \mixerWhite: 0,
					\mixerSub: mixerSub,
					// \mixerSub: 0,
				\envTimeScale: envTimeScale
			])
		);

		rrand(dur/6, (dur + 2)).wait;
		// (dur + 2).wait;
    });
    // Wait half second before saying we're done
    0.5.wait;
    "done".postln;
}.play;

)

~vizBus.index;

~vizBus.dump;

~vizBus.scope;



// ~vizBus.kr(60).poll;



(
SynthDef(\mspAdder, {
	| out = 0, vizOut = 5, envTimeScale = 1, mixerWhite = 0.01, mixerSub = 3 |
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

	"-MSP numPartials ------------------------------------ ".postln;
	numPartials.dump;

	n = (1..numPartials);
	// Window.closeAll;

	"-MSP freqs ------------------------------------ ".postln;
	freqs.size.postln;
	// freqs.postln;
	// freqs.collect{|x,i| "freq:".post; i.post; "-".post; x.poll; };

	envShape = Env.pairs(pairs, \exp);
	// envShape = Env.perc(0.05, 3, 1, -4);
	env =  EnvGen.ar(envShape, timeScale: envTimeScale, levelScale: 1,doneAction: Done.freeSelf);

	envShape = Env.pairs(pairs2, \exp);
	// envShape = Env.perc(0.05, 3, 1, -4);
	env2 = EnvGen.ar(envShape, timeScale: envTimeScale, levelScale: 1, doneAction: Done.freeSelf);


	// SHAPING /////////////////////////////////////////////////////
	// freqs.collectInPlace{|x,i| x * env2  };
	// levels = levels * (1 - log2(n * Line.kr(\comb1.kr(1), \comb2.kr(20), envTimeScale)).sin.abs);

	levels = levels * (1 - log2(n * env2).sin.abs);
	// levels = levels * env2;

	snd = SinOsc.ar(freqs, 0.0, levels);

	snd = snd.addFirst(
		Resonz.ar(
			WhiteNoise.ar(1.5),
			env2 * 20000,
			0.5,
		mixerWhite)
	);
	snd = snd.addFirst(
		SinOsc.ar(50, 0, mixerSub) * env;
	);

	// SCOPE TESTS
	// SinOsc.ar(freqs[0] + freqs[1], 0.0, levels[0] + levels[1]).scope;

	// Grab a subset of partials for the viz bus
	// (we only want to send a max of 80ch to the scope, seems to bork with more)
	factor = ~factor.value(freqs.size);
	Out.ar(vizOut, snd[0, factor..]);

	// audioBus verison
	// snd = snd * -20.dbamp;
	// Out.ar(out, snd);

	// stereo out version
	// either..
	snd = snd.sum ! 2;
    // or
	// stereo spread
	// snd = snd[0,2..].sum + ([-1,1] * snd[1,3..].sum);

	snd = snd * -30.dbamp;
	snd = FreeVerb.ar(snd, 0.33, 0.7, 0.4, 1);
	snd = Limiter.ar(snd);
	snd = LeakDC.ar(snd);
	Out.ar(out, snd);
}).add;
)



