
(
SynthDef(\cero,{arg freq1=200, freq2=200, phase1=0, phase2=0, gate=0;   //make sure there are control arguments to affect!
 // var x, y;
  // x = SinOsc.ar(freq1, phase1);
  // y = SinOsc.ar(freq2, phase2) ;
  Out.ar(0,SinOsc.ar(freq1, phase1));
  Out.ar(1,SinOsc.ar(freq2, phase2));



}).add;

)

// ejecutor cero
s.scope;

(

var w, f1S, f2S, p1S, p2S;


a = Synth("cero");


///// GUI//////////////
///////////////////
////////////////////////////
w=Window("sineVisualizer", Rect(100, 400, 400, 300));

w.view.decorator = FlowLayout(w.view.bounds);

f1S= EZSlider(w, 300@50, "freq 1", ControlSpec(0, 2000, 'linear',0.1, 200), {|ez|
a.set(\freq1, ez.value)});
w.view.decorator.nextLine;

p1S= EZSlider(w, 300@50, "phase 1", ControlSpec(0, 2*pi, 'linear',0.1, 0), {|ez|
a.set(\phase1, ez.value)});
w.view.decorator.nextLine;

f2S= EZSlider(w, 300@50, "freq2", ControlSpec(0, 2000, 'linear', 0.10, 200), {|ez|
a.set(\freq2, ez.value)});
w.view.decorator.nextLine;


p2S= EZSlider(w, 300@50, "phase 2", ControlSpec(0, 2*pi, 'linear',0.1, 0), {|ez|
a.set(\phase2, ez.value)});

w.front;


)


// ejecutor cero con menor rango (pero mas presicion)

(

var w, f1S, f2S, p1S, p2S;


a = Synth("cero");


///// GUI//////////////
///////////////////
////////////////////////////
w=Window("sineVisualizer", Rect(100, 400, 400, 300));

w.view.decorator = FlowLayout(w.view.bounds);

f1S= EZSlider(w, 600@50, "freq 1", ControlSpec(500, 600, 'linear',0.1, 200), {|ez|
a.set(\freq1, ez.value)});
w.view.decorator.nextLine;

p1S= EZSlider(w, 300@50, "phase 1", ControlSpec(0, 2*pi, 'linear',0.1, 0), {|ez|
a.set(\phase1, ez.value)});
w.view.decorator.nextLine;

f2S= EZSlider(w, 600@50, "freq2", ControlSpec(500, 600, 'linear', 0.10, 200), {|ez|
a.set(\freq2, ez.value)});
w.view.decorator.nextLine;


p2S= EZSlider(w, 300@50, "phase 2", ControlSpec(0, 2*pi, 'linear',0.1, 0), {|ez|
a.set(\phase2, ez.value)});

w.front;


)
