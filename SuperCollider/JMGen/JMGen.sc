JMGen{
	classvar basepath,randSeed,clock,tempo,width,height,snarePattern,kickPattern,hatPatternBase,s,scale,chords;
	var <project,<currentScene,rest,times,procAddress,snarePatternBase,kickPatternBase,key,mode,chordsBase,tempShapes,mousePress,currentShape,playingPattern;

	*new{arg wid = 1250,hei = 830;
		^super.new.init(wid,hei);
	}

	init{arg wid,hei;
		//The init method initialises all the variables, as well as all of the OSCdefs and SynthDefs.
		s = Server.local;
		project = List.new;
		tempShapes = List.new;
		times = Array.fill(500,{0});
		this.newScene;
		currentScene = 0;
		randSeed = 500.rand;
		thisThread.randSeed = randSeed;
		width = wid;
		height = hei;

		mousePress = false;

		tempo = (40+50.rand)/60;
		clock = TempoClock(tempo);

		procAddress = NetAddr("127.0.0.1", 12000);

		//startup message sent to Processing, supercollider port + tempo
		procAddress.sendMsg("/startup",NetAddr.langPort,tempo);

		//the key, scale mode and chords are initialised here, and are all randomised.
		key = 12.rand;
		mode = (0..7).wchoose([0.1,0.2,0.1,0.1,0.15,0.3,0.05]);

		scale = [0,2,4,5,7,9,11,12,14,16,17,19,21,23].rotate(mode.neg)+key+24;

		chordsBase = [[0,4,7],[2,5,9],[4,7,11],[5,9,12],[7,11,14],[9,12,16],[11,14,17],[12,16,19],[14,17,21],[16,19,23],[17,21,24],[19,23,26],[21,24,28],[23,26,29],[24,28,31]].rotate(mode.neg)+key+36;

		chords = Array.fill(7,{arg i;
			chordsBase[i];
		});

		basepath = this.class.filenameSymbol.asString.dirname;


		//A rest pattern is created to play if a scene is empty
		rest = Pbind(
			\instrument, \default,
			[\freq,\dur], Pseq([[\,2]],1),
			\amp, 0,
		);

		//OSCdefs
		//The osc receiveers are implemented here, and all relate to the duplication of the data structure in Processing.

		OSCdef('ChangeScene', {arg msg,time,addr,recvPort;
			msg.postln;
			currentScene = msg[1];
		},"ChangeScene");

		OSCdef('NewScene', {arg msg,time,addr,recvPort;
			msg.postln;
			this.newScene;
		},"NewScene");

		OSCdef('NewProject', {arg msg,time,addr,recvPort;
			msg.postln;
			this.newProject;
		},"NewProject");

		OSCdef('NewSceneCustomTime', {arg msg,time,addr,recvPort;
			msg.postln;
			this.newSceneCustomTime(msg[1]);
		},"NewSceneCustomTime");

		OSCdef('NewSquare', {arg msg,time,addr,recvPort;
			msg.postln;
			project.at(currentScene).add(JMGenSquare.new(msg[1],msg[2],msg[3],msg[4]));
			mousePress = true;
		},"NewSquare");
		OSCdef('NewTriangle', {arg msg,time,addr,recvPort;
			msg.postln;
			project.at(currentScene).add(JMGenTriangle.new(msg[1],msg[2],msg[3],msg[4]));
			mousePress = true;
		},"NewTriangle");
		OSCdef('NewCircle', {arg msg,time,addr,recvPort;
			msg.postln;
			project.at(currentScene).add(JMGenCircle.new(msg[1],msg[2],msg[3],msg[4]));
			mousePress = true;
		},"NewCircle");
		OSCdef('NewHexagon', {arg msg,time,addr,recvPort;
			msg.postln;
			project.at(currentScene).add(JMGenHexagon.new(msg[1],msg[2],msg[3],msg[4]));
			mousePress = true;
		},"NewHexagon");
		OSCdef('NewStar', {arg msg,time,addr,recvPort;
			msg.postln;
			project.at(currentScene).add(JMGenStar.new(msg[1],msg[2],msg[3],msg[4]));
			mousePress = true;
		},"NewStar");
		OSCdef('NewParallel', {arg msg,time,addr,recvPort;
			msg.postln;
			project.at(currentScene).add(JMGenParallel.new(msg[1],msg[2],msg[3],msg[4]));
			mousePress = true;
		},"NewParallel");

		OSCdef('RemoveShape', {arg msg,time,addr,recvPort;
			var index;
			msg.postln;
			if(msg[1]!=0,{
				for(0,project.at(currentScene).size-1,{arg i;
					project.at(currentScene).at(i).postln;
					if(project.at(currentScene).at(i).uniqueID == (msg[1]),{
						index = i;
					});
				});
				project.at(currentScene).removeAt(index);
			});
		},"RemoveShape");

		OSCdef('Play', {arg msg,time,addr,recvPort;
			msg.postln;
			this.play;
		},"Play");

		OSCdef('Stop', {arg msg,time,addr,recvPort;
			msg.postln;
			this.stop;
		},"Stop");

		OSCdef('PlayCurrent', {arg msg,time,addr,recvPort;
			msg.postln;
			this.playCurrent;
		},"PlayCurrent");

		OSCdef('SceneTimePlus', {arg msg,time,addr,recvPort;
			msg.postln;
			times[currentScene] = times[currentScene] +1;
		},"SceneTimePlus");

		OSCdef('SceneTimeMinus', {arg msg,time,addr,recvPort;
			msg.postln;
			times[currentScene] = times[currentScene] -1;
		},"SceneTimeMinus");

		OSCdef('SceneTimeSet', {arg msg,time,addr,recvPort;
			msg.postln;
			times[currentScene] = msg[1];
		},"SceneTimeSet");

		OSCdef('MouseReleased', {arg msg,time,addr,recvPort;
			msg.postln;
			if(mousePress, {
				currentShape.stop;
			});
		},"MouseReleased");

		OSCdef('RandomSeed', {arg msg,time,addr,recvPort;
			msg.postln;
			this.randSeed(msg[1]);
		},"RandomSeed");

		OSCdef('Load', {arg msg,time,addr,recvPort;
			msg.postln;
			this.loadMode;
		},"Load");

		OSCdef('MoveShape', {arg msg,time,addr,recvPort;
			var index;
			msg.postln;
			for(0,project.at(currentScene).size-1,{arg i;

				if(project.at(currentScene).at(i).uniqueID == (msg[1]),{
					index = i;
				});
			});
			project.at(currentScene).at(index).move(msg[2],msg[3]);
			currentShape = project.at(currentScene).at(index);
			if(mousePress,{
				if(currentShape.playing, {},{currentShape.play;});
			});


		},"MoveShape");

		OSCdef('Close', {arg msg,time,addr,recvPort;
			msg.postln;
			0.exit;
		},"Close");



		//drum pattern generation
		//drum patterns are generated in the superclass so they are accessible to multiple classes.

		kickPatternBase = Array.fill(8,{0});
		snarePatternBase = Array.fill(8,{0});
		hatPatternBase = Array.fill(16,{0});

		//snare and kick patterns are generated, with a kick or snare hit chosen at random for every quaver in a bar.
		8.do({arg i;
			if(100.rand>50, {
				snarePatternBase[i] = 0;
				kickPatternBase[i] = 0.4;
				},  {
					snarePatternBase[i] = 0.4;
					kickPatternBase[i] = 0;
			});
		});

		16.do({arg i;
			if(100.rand>50, {
				hatPatternBase[i] = 0.5;
				},{
					hatPatternBase[i] = 0.0;
			});

		});

		kickPattern = Pseq([ [kickPatternBase[0],0.25],[kickPatternBase[1],0.25],[kickPatternBase[2],0.25],[kickPatternBase[3],0.25],[kickPatternBase[4],0.25],[kickPatternBase[5],0.25],[kickPatternBase[6],0.25],[kickPatternBase[7],0.25] ],1);
		snarePattern = Pseq([ [snarePatternBase[0],0.25],[snarePatternBase[1],0.25],[snarePatternBase[2],0.25],[snarePatternBase[3],0.25],[snarePatternBase[4],0.25],[snarePatternBase[5],0.25],[snarePatternBase[6],0.25],[snarePatternBase[7],0.25] ],1);


		//SynthDefs
		//Buffer player for drum samples
		SynthDef(\bufferplayback,{arg bufnum = 0, amp = 0.1,gate=1,x=0,y=0;
			var playbuf,env,sound,pos,dist;
			playbuf = PlayBuf.ar(1,bufnum);
			env = EnvGen.ar(Env.adsr(0.0,0.0,1.0,0.1),gate,doneAction:2);
			sound = playbuf*env*amp;

			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		//Bass Synths
		SynthDef(\bass, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2, sound, env,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.35,0.5,0.3),gate,doneAction:2);
			osc1 = SinOsc.ar(freq);
			osc2 = Saw.ar(freq*2)*0.8;
			sound = (osc1+osc2)*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		SynthDef(\sinBass, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1, sound, env,pos,dist;
			env = EnvGen.ar(Env.adsr(0.01,0.35,0.9,0.1),gate,doneAction:2);
			osc1 = SinOsc.ar(freq);
			sound = (osc1)*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		SynthDef(\bass2, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2,osc3, sound, env,oscs,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.17,0.2,0.17),gate,doneAction:2);
			osc1 = SinOsc.ar(freq/2);
			osc2 = Saw.ar(freq);
			osc3 = Pulse.ar(freq*1.01);
			oscs = LPF.ar((osc1+osc2+osc3),4000);
			sound = oscs*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		SynthDef(\bass3, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2,osc3, sound, env,oscs,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.28,0.6,0.19),gate,doneAction:2);
			osc1 = Saw.ar((freq/2)*0.99);
			osc2 = Saw.ar(freq);
			osc3 = Saw.ar((freq/2)*1.01);
			oscs = RLPF.ar((osc1+osc2+osc3),2500);
			sound = oscs*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		SynthDef(\bass4, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2,osc3, sound, env,oscs,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.28,0.6,0.19),gate,doneAction:2);
			osc1 = Saw.ar((freq/2)*0.99);
			osc2 = Pulse.ar(freq);
			osc3 = Saw.ar((freq/2)*1.01);
			oscs = RLPF.ar((osc1+osc2+osc3),4000);
			sound = oscs*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		SynthDef(\bass5, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2,osc3, sound, env,oscs,pos,dist;
			env = EnvGen.ar(Env.adsr(0.15,8.0,0.6,0.13),gate,doneAction:2);
			osc1 = SinOsc.ar((freq/2));
			osc2 = SinOsc.ar(freq*1.01);
			osc3 = LPF.ar(HPF.ar(WhiteNoise.ar(1),freq-20),freq+20)*0.5;
			oscs = (osc1+osc2+osc3);
			sound = oscs*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		//Keyboard Style Synths

		SynthDef(\keys2, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2,osc3, sound, env,oscs,lfo,pos,dist;
			env = EnvGen.ar(Env.adsr(1.0,0.8,0.6,0.53),gate,doneAction:2);
			lfo = Saw.ar(0.5)*EnvGen.ar(Env.adsr(0.8,0.2,0.6,0.53),gate,doneAction:2);
			osc1 = Saw.ar((freq+lfo)*1.01);
			osc2 = Pulse.ar((freq+lfo)*0.99);
			osc3 = Saw.ar((freq+lfo)*0.99);
			oscs = LPF.ar((osc1+osc2+osc3),4000);
			sound = oscs*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		SynthDef(\keys3, {arg freq = 440, amp =0.8,gate=1,x=0,y=0;
			var osc1,osc2,osc3, sound, env,oscs,lfo,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.58,0.15,0.54),gate,doneAction:2);
			lfo = SinOsc.ar(0.75)*0.5;
			osc1 = Pulse.ar((freq+lfo),0.4);
			osc2 = Pulse.ar((freq+lfo)*0.99,0.2);
			osc3 = Saw.ar((freq+lfo)*1.01,0.8);
			oscs = RLPF.ar((osc1+osc2+osc3),2000);
			sound = oscs*amp*env;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;

		//Pulse Oscillator and inputs used from everythingrhodes SynthDef in StealThisSound (2011) by Mithcell Sigman, adapted by Nick Collins
		SynthDef(\keys1,{arg out= 0, freq = 440, amp = 0.1, cutoff= 2000,gate=1,x=0,y=0;
			var pulse, filter, env,env2,strike,noise,sound,pos,dist;
			env = EnvGen.ar(Env.adsr(0.001,0.3,0.8,0.5),gate,doneAction:2);
			strike = Impulse.ar(0.01);
			env2 = Decay2.ar(strike, 0.008, 0.04);
			noise = PinkNoise.ar(1)*env2*0.05;

			pulse = Pulse.ar(freq*[1,33.5],[0.2,0.1],[0.7,0.3]);
			filter = LPF.ar(pulse,3000)*env*amp;
			sound = RLPF.ar(filter,cutoff,0.2) + noise;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(out,PanAz.ar(2,Mix((sound*dist)),pos));
		}).add;

		//Lead melody synths
		SynthDef(\lead1, {arg freq = 440, amp =0.8, gate = 1,x=0,y=0;
			var osc1, sound, env,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.35,0.9,0.3),gate,doneAction:2);
			osc1 = Saw.ar((Array.rand(6,1,1.01)*freq),0.2)*env*2;
			sound = Pan2.ar((osc1)*amp,0.5);
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;
		SynthDef(\lead2, {arg freq = 440, amp =0.8, gate = 1,x=0,y=0;
			var osc1,osc2, sound, env,pos,dist;
			env = EnvGen.ar(Env.adsr(0,0.35,0.6,0.1),gate,doneAction:2);
			osc1 = Pulse.ar(freq*1.5)*0.15;
			osc2 = Saw.ar(freq);
			sound = RLPF.ar((osc1+osc2),3000,1.0)*amp;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;
		SynthDef(\lead3, {arg freq = 440, amp =0.8, gate = 1,x=0,y=0;
			var osc1,osc2, sound, env,pos,dist;
			env = EnvGen.ar(Env.adsr(0.05,0.25,0.7,0.2),gate,doneAction:2);
			osc1 = Pulse.ar(freq);
			osc2 = Saw.ar(freq*2);
			sound = RLPF.ar((osc1+osc2),3000,0.8)*0.6*amp;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;
		SynthDef(\lead4, {arg freq = 440, amp =0.8, gate = 1,x=0,y=0;
			var osc1,osc2,osc3,osc4, sound, env,pos,dist;
			env = EnvGen.ar(Env.adsr(0.05,0.25,0.7,0.2),gate,doneAction:2);
			osc1 = SinOsc.ar(freq)*0.5;
			osc2 = Saw.ar(freq*0.99);
			osc3 = Pulse.ar(freq*0.995,0.4);
			osc4 = Pulse.ar(freq,0.6);
			sound = RLPF.ar((osc1+osc2+osc3+osc4),3000,1.5)*0.3*amp;
			pos = atan2(((x/width)-0.5),((y/height)-0.5))/(pi);
			dist = 1-(((((x-(width/2))*(x-(width/2)))+((y-(height/2))*(y-(height/2)))).sqrt)/((((width-(width/2))*(width-(width/2)))+((height-(height/2))*(height-(height/2)))).sqrt));
			Out.ar(0,PanAz.ar(2,(sound*dist),pos));
		}).add;




	}

	randSeed{arg newRandSeed;
		randSeed = newRandSeed;
		thisThread.randSeed = randSeed;
	}


	newScene{
		project.add(List.new);
		currentScene = project.size-1;
		times[currentScene] = 1;

	}

	newProject{
		//Method to create new project and reset all variables controlling the projext
		project = List.new;
		tempShapes = List.new;
		times = Array.fill(500,{0});
		this.newScene;
		currentScene = 0;
		tempo = (40+50.rand)/60;
		clock = TempoClock(tempo);
		key = 12.rand;
		mode = (0..7).wchoose([0.1,0.2,0.1,0.1,0.15,0.3,0.05]);
		scale = [0,2,4,5,7,9,11,12,14,16,17,19,21,23].rotate(mode.neg)+key+24;

		chordsBase = [[0,4,7],[2,5,9],[4,7,11],[5,9,12],[7,11,14],[9,12,16],[11,14,17],[12,16,19],[14,17,21],[16,19,23],[17,21,24],[19,23,26],[21,24,28],[23,26,29],[24,28,31]].rotate(mode.neg)+key+36;

		chords = Array.fill(7,{arg i;
			chordsBase[i];
		});
		procAddress.sendMsg("/startup",NetAddr.langPort,tempo);
	}

	newSceneCustomTime{arg time;
		//method for duplication of scenes
		project.add(List.new);
		currentScene = project.size-1;
		times[currentScene] = time;

	}

	loadMode{
		//method for preparing to load a project
		project = List.new;
		tempShapes = List.new;
		times = Array.fill(500,{0});
	}

	copyScene{
		//method for duplication of a scene
		project.add(project.at(currentScene));
		times[project.size-1] = times[currentScene];
		currentScene = project.size-1;
	}

	play{
		//compiles scenes into a Pseq of Ppars
		var scenes = Array.fill(project.size,{arg i;
			Array.fill(project.at(i).size,{arg j;
				project.at(i).at(j).get;
			});
		});
		var ppars = Array.fill(project.size, {arg i;
			if(scenes[i].notEmpty, {
				Ppar(scenes[i],times[i]);
				},{
					Pseq([rest],times.[i]);
			});
		});

		playingPattern = Pseq(ppars).asEventStreamPlayer;
		playingPattern.play(clock);
	}

	playCurrent{
		//compiles the patterns from the shapes into a Ppar and plays it
		var ppar,scene;
		scene = Array.fill(project.at(currentScene).size,{arg i;
			project.at(currentScene).at(i).get;
		});

		if(scene.notEmpty, {
			ppar = Ppar(scene,times[currentScene]);
			},{
				ppar = Pseq([rest],times[currentScene]);
		});



		playingPattern = Pseq([ppar]).asEventStreamPlayer;
		playingPattern.play(clock);
	}

	stop{
		//stops any current playing pattern.
		playingPattern.stop;

	}
}