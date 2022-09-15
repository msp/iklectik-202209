(  // a custom dual oscilloscope
// Server.default = Server.internal;  // make internal the default server

// allocate two audio buffers
~bufferA = Buffer.alloc(Server.default, 1024,2);
~bufferB = Buffer.alloc(Server.default, 1024,2);

~bufferA.dump;
~bufferB.dump;

Server.default.waitForBoot({
	var waveScope, phaseScope; // the two scopes

	// a stereo signal
	var sound = {
		var signal = Resonz.ar(
			[ ClipNoise.ar(1.7), ClipNoise.ar(1.8) ],
			SinOsc.ar(1000).range(100,500)); // a stereo signal
		ScopeOut2.ar(signal, ~bufferA); // update first buffer
		ScopeOut2.ar(signal, ~bufferB); // update second buffer
		Out.ar(0,signal * 0.4); // write to output
	}.play;


	// create the main Window
	var window = Window("Dual Oscilloscope", 640@320).front
	.onClose_({ // on close stop sound and free buffers
		sound.free;
		~bufferA.free;
		~bufferB.free;
	});

	~bufferA.dump;
	~bufferB.dump;

	window.addFlowLayout; // add a flowLayout to the window

	// create the ScopeViews and set their buffers
	waveScope = ScopeView(window,314@310).bufnum_(~bufferA.bufnum);
	phaseScope = ScopeView(window,314@310).bufnum_(~bufferB.bufnum);

	waveScope.server = s; // Important: one must assign the ScopeView to a server
	phaseScope.server = s; // Important: one must assign the ScopeView to a server

	waveScope.bufnum = ~bufferA.bufnum;
	phaseScope.bufnum = ~bufferB.bufnum;

	waveScope.start;
	phaseScope.start;

	// customize waveScope
	waveScope.style_(1)   // overlay channels
	.waveColors_([Color.red, Color.yellow]).background_(Color.magenta(0.4))
	.xZoom_(1.7).yZoom_(1.2);   // scaling factors

	// customize phaseScope
	phaseScope.style_(2)   // lissajous mode
	.waveColors_([Color.magenta]).background_(Color.cyan(0.3))
	.xZoom_(1.2).yZoom_(1.2);   // scaling factors
})
)