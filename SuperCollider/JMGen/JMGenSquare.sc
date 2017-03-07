JMGenSquare : JMGen{
	var <>x,<>y,<colourID,<uniqueID,squareKickBuffer,squareSnareBuffer,squareHatBuffer,chord1,chord2,cid4Durs,<playing = false,auditionPattern,pattern,harmPattern,melPattern,melDur,melNote,melNotes,melDurations,melChances;
	//0 red, 1 blue, 2 green, 3 yellow.
	*new{ arg xPos,yPos,colour,id;
		^super.new.init(xPos,yPos,colour,id);
	}

	init{arg xPos,yPos,colour,id;
		s = Server.local;
		x = xPos;
		y = yPos;
		colourID = colour;
		uniqueID = id;
		thisThread.randSeed = randSeed;
		//need kick buffers& patterns in here
		Pdefn(\x,x);
		Pdefn(\y,y);
		//samples are chosen from a short list of similar sounding samples
		squareKickBuffer = Buffer.read(s,basepath++["/Samples/Electronic Kicks/DR bde-2step01.aif","/Samples/Electronic Kicks/DR AD-drums.7.aif"].choose);
		squareSnareBuffer = Buffer.read(s,basepath++["/Samples/Electronic Snares/DR 909snare15b.aif","/Samples/Electronic Snares/DR bbK_snare10_D#1.aif"].choose);
		squareHatBuffer = Buffer.read(s,basepath++["/Samples/Electronic Hats/GB_Tasty909kit_HH1.aif","/Samples/Electronic Hats/GB_Tasty909kit_HH2.aif","/Samples/Electronic Hats/GB_Tasty909kit_HHo1.aif"].choose);


		melNotes = [[scale[0],scale[2]],[scale[1],scale[3]],[scale[2],scale[4]],[scale[3],scale[5]],[scale[4],scale[6]],[scale[5],scale[7]],[scale[6],scale[8]],[scale[7],scale[9]],[scale[8],scale[10]]];

		melChances = [0.3,0.075,0.1,0.05,0.2,0.075,0.075,0.05,0.075];
		melDurations = [1.0,1.0,0.5,0.5,0.5,0.25,0.25,0.25,0.25,0.25,0.25,0.125,0.125,0.125];
		melNote =  List.new;
		melDur = List.new;

		melNote.add(melNotes.wchoose(melChances));
		melDur.add(melDurations.choose);

		for(0,500,{
			var dur,note,finalNote;
			dur = melDurations.choose;
			note = melNote.at(melNote.size-1);
			if(melDur.sum+dur <=2.0,{
				//melody note must move to a consecutive note
				if(note == melNotes[0], {
					finalNote = [melNotes[0],melNotes[1]].choose;
				});
				if(note == melNotes[1], {
					finalNote = [melNotes[0],melNotes[2]].choose;
				});
				if(note == melNotes[2], {
					finalNote = [melNotes[1],melNotes[3]].choose;
				});
				if(note == melNotes[3], {
					finalNote = [melNotes[2],melNotes[4]].choose;
				});
				if(note == melNotes[4], {
					finalNote = [melNotes[3],melNotes[5]].choose;
				});
				if(note == melNotes[5], {
					finalNote = [melNotes[4],melNotes[6]].choose;
				});
				if(note == melNotes[6], {
					finalNote = [melNotes[5],melNotes[7]].choose;
				});
				if(note == melNotes[7], {
					finalNote = [melNotes[6],melNotes[8]].choose;
				});
				if(note == melNotes[8], {
					finalNote = [melNotes[8],melNotes[7]].choose
				});
				melNote.add(finalNote);

				melDur.add(dur);
			});
		});

		melPattern = Array.fill(melNote.size,{0;});
		for(0,melNote.size-1, {arg i;
			melPattern[i] = [(melNote.at(i)[0])+24,melDur.at(i)];
		});
		harmPattern = Array.fill(melNote.size,{0;});
		for(0,melNote.size-1, {arg i;
			harmPattern[i] = [melNote.at(i)[1]+24,melDur.at(i)];
		});

		chord1 = chords.choose;
		chord2 = chords.choose;
		cid4Durs = [[0.5,1.5].scramble,[1,1],[0.75,1.25].scramble].choose;


	}

	move {arg xMov,yMov;
		x = xMov;
		y = yMov;
		//Pdefns are updated to allow for real time auditioning of the 2D panning.
		Pdefn(\x,x);
		Pdefn(\y,y);
	}

	get{
		//get method returns a pattern for the superclass to compile in a ppar and play.
		//Kick
		if(colourID == 0,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, squareKickBuffer,
				[\amp,\dur], kickPattern,
				\x,x,
				\y,y
			);
		});

		if(colourID == 1,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, squareSnareBuffer,
				[\amp,\dur], snarePattern,
				\x,x,
				\y,y
			);

		});

		if(colourID == 2,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, squareHatBuffer,
				\amp, Pseq(hatPatternBase,1),
				\dur,0.125,
				\x,x,
				\y,y
			);

		});

		if(colourID == 3,{
			pattern = Pbind(
				\instrument, \bass4,
				\midinote, Pseq([scale[0],scale[0],scale[0],scale[0],scale[2],scale[2],scale[4],scale[4]]),
				\dur, 0.25,
				\x,x,
				\y,y
			);

		});

		if(colourID == 4,{
			pattern = Pbind(
				\instrument, \keys3,
				\midinote, Pseq([chord1,chord2]),
				\dur,Pseq(cid4Durs),
				\x,x,
				\y,y
			);

		});

		if(colourID == 5,{
			pattern = Pbind(
				\instrument, \lead1,
				[\midinote,\dur], Pseq(melPattern),
				\x,x,
				\y,y
			);
		});

		if(colourID == 6,{
			pattern = Pbind(
				\instrument, \lead1,
				[\midinote,\dur], Pseq(harmPattern),
				\x,x,
				\y,y
			);
		});

		^pattern;

	}

	set{
		if(colourID == 0,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, squareKickBuffer,
				[\amp,\dur], kickPattern,
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);
		});

		if(colourID == 1,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, squareSnareBuffer,
				[\amp,\dur], snarePattern,
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 2,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, squareHatBuffer,
				\amp, Pseq(hatPatternBase,1),
				\dur,0.125,
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 3,{
			pattern = Pbind(
				\instrument, \bass4,
				\midinote, Pseq([scale[0],scale[0],scale[0],scale[0],scale[2],scale[2],scale[4],scale[4]]),
				\dur, 0.25,
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 4,{
			pattern = Pbind(
				\instrument, \keys3,
				\midinote, Pseq([chord1,chord2]),
				\dur,Pseq(cid4Durs),
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 5,{
			pattern = Pbind(
				\instrument, \lead1,
				[\midinote,\dur], Pseq(melPattern),
				\x,Pdefn(\x),
				\y,Pdefn(\y)
			);
		});

		if(colourID == 6,{
			pattern = Pbind(
				\instrument, \lead1,
				[\midinote,\dur], Pseq(harmPattern),
				\x,Pdefn(\x),
				\y,Pdefn(\y)
			);
		});

	}

	play{
		var tempPattern;
		this.set;
		tempPattern = Pseq([pattern],inf);
		auditionPattern = tempPattern.asEventStreamPlayer;
		auditionPattern.play(clock);
		playing = true;
	}

	stop{
		playing = false;
		auditionPattern.stop;
	}
}