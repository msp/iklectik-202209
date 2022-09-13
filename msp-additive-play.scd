(
{
    var snd, dur, freq, freqMult, freqs, levels, n, numPartials, pairs, pairsRand, pairs2, env, env2, envShape, envStepsMult;
	freq = 110;
	// freq = [55, 110, 165, 220, 275].rand;
	numPartials = 380;
	dur = 30;
	envStepsMult = 0.2;

    n = (1..numPartials);

	// Window.closeAll;


	"-MSP freqs ------------------------------------ ".postln;
	freqs = freq * n;

	freqs.postln;

    //frequency dispersion
	freqs = freqs  * (1 + (n * n * 0.000521)).abs.sqrt;
	// MSP
	// freqs = freqs  * (1 + (n * n * 0.0021)).abs.sqrt;

	freqs.postln;

    //tilt EQ to roll off harsh highs
    levels = 1 * (log2(n) * \tilt.kr(-3)).dbamp;

	// ** TODO MSP Play with these vales for timbre **

    //inharmonic frequency shift of every 4th partial by 20 hz
	freqs.collectInPlace{|x,i| if((i%4) == 0) {x = x + 20;} {x;}};

    //harmonic ratio multiplication of every 3rd partial
	// freqs.collectInPlace{|x,i| if((i%3) == 0) {x = x * 1.5;} {x;}};
	// MSP
	// freqs.collectInPlace{|x,i| if((i%3) == 0) {x = x * 1.5;} {x;}};
	// freqs.collectInPlace{|x,i| if((i%5) == 0) {x = x * 5;} {x;}};

    //uncomment this to silence every 2nd harmonic, creating a square-like timbre
	// levels.collectInPlace{|x,i| if(i.even) {x = x*0.0;} {x;}};

    //periodic filter approximation?
    //x axis controls phase, y axis number of peaks/troughs. exponent controls steepness
	levels.collectInPlace{|x,i| {x * (((i/MouseY.kr(0.5,48) + MouseX.kr(0,8)).sin.abs) ** 4);}};

    //different approach from nathan ho's video
	/*levels = levels * (1 - log2(n * MouseX.kr(1,16) + MouseY.kr(1,100)).sin.abs);*/
	// levels.plot;

    //mute all sines above 20k to prevent aliasing
	freqs.collectInPlace{|x,i| if(x>20000) {levels.put(i,0.0); x;} {x;}};

	// "-MSP freqs 2 ---------------------------------- ".postln;
	// freqs.collectInPlace{|x,i| XLine.kr(x, freqs.scramble[i], 0.3) };

	pairsRand = { { 1.0.rand } ! 2 } ! (dur * envStepsMult);
	// pairsRand = { { 1.0.rand } ! 2 } ! 8;
	// pairsRand = { [1.0.linrand, rrand(0.52, 1)] } ! 8;
	// pairs = [ [ 0.46644532680511, 0.95408070087433 ], [ 0.79316735267639, 0.72445929050446 ], [ 0.66931366920471, 0.13437724113464 ], [ 0.45547497272491, 0.63586318492889 ], [ 0.46265351772308, 0.66731905937195 ] ];

	pairs = pairsRand;

	"-MSP ENV ---------------------------------- ".postln;

	pairs.postln;
	pairs = pairs ++ [[1.0, 0.001]];
	pairs2 = pairsRand.collect{|x,i| [x[1], x[0]] };

	// Env.pairs(pairs, \exp).plot;

	envShape = Env.pairs(pairs, \exp);
	env =  EnvGen.ar(envShape, timeScale: dur, levelScale: 1,doneAction: Done.freeSelf);
	envShape = Env.pairs(pairs2, \exp);
	env2 = EnvGen.ar(envShape, timeScale: dur, levelScale: 1, doneAction: Done.freeSelf);
	// env = EnvGen.ar(envShape, timeScale: dur);



	// freqs.collectInPlace{|x,i| x * env2  };
	// levels = levels * (1 - log2(n * Line.kr(\comb1.kr(1), \comb2.kr(20), dur)).sin.abs);

	// levels = levels * (1 - log2(n * env2).sin.abs);
	// levels.collectInPlace{|x,i| if((i%5) == 0) {x = x * 0.1;} {x;}};

	snd = SinOsc.ar(freqs,0.0, levels);
	// snd = [];

	snd = snd.addFirst(
		Resonz.ar(
			WhiteNoise.ar(1.5),
			env2 * 20000,
			0.3)
	);
	snd = snd.addFirst(
		SinOsc.ar(50, 0, 4) * env;
	);


	// snd = snd * EnvGen.ar(
	// 	Env.cutoff(0.1, 1), timeScale: dur, doneAction: Done.freeSelf
	// );


	// either..
	// snd = snd.sum ! 2;

    // or
	// stereo spread
	snd = snd[0,2..].sum + ([-1,1] * snd[1,3..].sum);
	snd = snd * -20.dbamp;
    Out.ar(0,snd);

}.play(fadeTime: 0);
)

// s.options.numWireBufs = 64 * 64;
