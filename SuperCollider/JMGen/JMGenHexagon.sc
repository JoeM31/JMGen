JMGenHexagon : JMGen{
	var <>x,<>y,<colourID,<uniqueID,hexagonKickBuffer,hexagonSnareBuffer,hexagonHatBuffer,<playing = false,auditionPattern,pattern,harmPattern,melPattern,melDur,melNote,melNotes,melDurations,melChances;
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
		Pdefn(\x,x);
		Pdefn(\y,y);


		//samples are chosen from a short list of similar sounding samples
		hexagonKickBuffer = Buffer.read(s,basepath++["/Samples/Acoustic Kicks/DR ue-bda rock 1.aif","/Samples/Acoustic Kicks/DR YT-CK-BD-09-G#1-01.aif"].choose);
		hexagonSnareBuffer = Buffer.read(s,basepath++["/Samples/Acoustic Snares/DR YT-CK-SD-08-E2-01.aif","/Samples/Acoustic Snares/DR DNA W Snr f Cl.aif"].choose);
		hexagonHatBuffer = Buffer.read(s,basepath++["/Samples/Acoustic Hats/ILO2-HH_STK_04.aif","/Samples/Acoustic Hats/ILO2-HH_STK_01.aif"].choose);

		melNotes = [[scale[0],scale[2]],[scale[1],scale[3]],[scale[2],scale[4]],[scale[3],scale[5]],[scale[4],scale[6]],[scale[5],scale[7]],[scale[6],scale[8]],[scale[7],scale[9]],[scale[8],scale[10]]];

		//harmNotes = [scale[2],scale[3],scale[4],scale[5],scale[6],scale[7],scale[8],scale[9],scale[10]];
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
		if(colourID == 0,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, hexagonKickBuffer,
				[\amp,\dur],  Pseq([[0.4,0.5],[0,0.25],[0.4,0.25],[0,0.75],[0.4,0.25]],1),
				\x,x,
				\y,y
			);
		});

		if(colourID == 1,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, hexagonSnareBuffer,
				[\amp,\dur], Pseq([[0.4,0.5],[0.4,0.5],[0.4,0.5],[0.4,0.5]],1),
				\x,x,
				\y,y
			);

		});

		if(colourID == 2,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, hexagonHatBuffer,
				[\amp,\dur], Pseq([[0.4,0.5],[0.4,0.5],[0.4,0.5],[0.4,0.5]],1),
				\x,x,
				\y,y
			);

		});

		if(colourID == 3,{
			pattern = Pbind(
				\instrument, \bass2,
				[\midinote,\dur], Pseq([[scale[0],1.5],[scale[4],0.5]]),
				\x,x,
				\y,y
			);

		});

		if(colourID == 4,{
			pattern = Pbind(
				\instrument, \keys2,
				\midinote, Pseq([chords[0][0]+12,chords[0][2],chords[0][1],chords[0][0],chords[4][0]+12,chords[4][2],chords[4][1],chords[4][0]]),
				\dur,0.25,
				\x,x,
				\y,y
			);

		});

		if(colourID == 5,{
			pattern = Pbind(
				\instrument, \lead3,
				[\midinote,\dur], Pseq(melPattern),
				\x,x,
				\y,y
			);
		});

		if(colourID == 6,{
			pattern = Pbind(
				\instrument, \lead3,
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
				\bufnum, hexagonKickBuffer,
				[\amp,\dur],  Pseq([[0.4,0.5],[0,0.25],[0.4,0.25],[0,0.75],[0.4,0.25]],1),
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);
		});

		if(colourID == 1,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, hexagonSnareBuffer,
				[\amp,\dur], Pseq([[0.4,0.5],[0.4,0.5],[0.4,0.5],[0.4,0.5]],1),
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 2,{
			pattern = Pbind(
				\instrument, \bufferplayback,
				\bufnum, hexagonHatBuffer,
				[\amp,\dur], Pseq([[0.4,0.5],[0.4,0.5],[0.4,0.5],[0.4,0.5]],1),
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 3,{
			pattern = Pbind(
				\instrument, \bass2,
				[\midinote,\dur], Pseq([[scale[0],1.5],[scale[4],0.5]]),
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});

		if(colourID == 4,{
			pattern = Pbind(
				\instrument, \keys2,
				\midinote, Pseq([chords[0][0]+12,chords[0][2],chords[0][1],chords[0][0],chords[4][0]+12,chords[4][2],chords[4][1],chords[4][0]]),
				\dur,0.25,
				\x,Pdefn(\x,x),
				\y,Pdefn(\y,y)
			);

		});
		if(colourID == 5,{
			pattern = Pbind(
				\instrument, \lead3,
				[\midinote,\dur], Pseq(melPattern),
				\x,Pdefn(\x),
				\y,Pdefn(\y)
			);
		});

		if(colourID == 6,{
			pattern = Pbind(
				\instrument, \lead3,
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