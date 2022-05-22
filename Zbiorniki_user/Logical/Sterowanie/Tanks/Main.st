
PROGRAM _INIT
	gZb1_poziom;
	gZb1_zawor;
	gZb2_poziom;
	gZb2_zawor;
	
	gZb3_poziom;
	gZb3_zawor_glowny;
	gZb3_zawor_lewy;
	gZb3_zawor_prawy;
	
	ManualControl;
	
	gMieszadlo;
	
	gTanks.Loop := TRUE;
	
	gTanks.StirTime := T#5s;
	gTanks.EnableStir := TRUE;
	
	gTanks.FirstTankCapacity := 10000;
	gTanks.SecondTankCapacity := 10000;
	gTanks.MainTankCapacity := 10000;
	
	gTanks.FirstTankMaxLevel := 8000;
	gTanks.SecondTankMaxLevel := 8000;
	gTanks.MainTankMaxLevel := 8000;
	gTanks.MainTankMinLevel := 0;
	
	FirstValveOpenLevel := 100;
	SecondValveOpenLevel := 100;
	
	gTanks.CurrentState := TANKS_STOP;
	
	TON_Stir();
	
	FirstRun := FALSE;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	IF gTanks.Stop THEN
		gTanks.CurrentState := TANKS_STOP;
	END_IF
	
	IF gTanks.EnableStir THEN
		gTanks.MainTankMaxLevel := 10000;
	ELSE
		gTanks.MainTankMaxLevel := 8000;
	END_IF
	
	
	CASE gTanks.CurrentState OF
		TANKS_STOP:
			gTanks.FirstTankFilled := FALSE;
			gTanks.SecondTankFilled := FALSE;
			gTanks.MainTankFilled := FALSE;
			TON_Stir.IN := FALSE;
			
			Status := 0;
			
			IF gTanks.Start THEN
				gTanks.CurrentState := TANKS_FILL_SUB;
			END_IF
			
		TANKS_FILL_SUB:
			Status := 1;
			IF gZb1_poziom>=gTanks.FirstTankMaxLevel THEN
				gZb1_zawor := FALSE;
				gTanks.FirstTankFilled := TRUE;
			ELSIF NOT gTanks.FirstTankFilled THEN
				gZb1_zawor := TRUE;
			END_IF
			
			IF gZb2_poziom>=gTanks.SecondTankMaxLevel THEN
				gZb2_zawor := FALSE;
				gTanks.SecondTankFilled := TRUE;
			ELSIF NOT gTanks.SecondTankFilled THEN
				gZb2_zawor := TRUE;
			END_IF
			
			IF gTanks.FirstTankFilled AND gTanks.SecondTankFilled THEN
				gTanks.CurrentState := TANKS_FILL_MAIN;
			END_IF			
			
		TANKS_FILL_MAIN:
			IF gZb3_poziom >= gTanks.MainTankMaxLevel THEN
				gZb3_zawor_lewy := 0;
				gZb3_zawor_prawy := 0;
				gTanks.MainTankFilled := TRUE;
			ELSE
				gZb3_zawor_glowny := FALSE;
				gZb3_zawor_lewy := SecondValveOpenLevel;
				gZb3_zawor_prawy := FirstValveOpenLevel;
			END_IF
			
			
			IF gTanks.MainTankFilled THEN
				IF gTanks.EnableStir THEN
					gTanks.CurrentState := TANKS_STIR;
				ELSE
					gTanks.CurrentState := TANKS_DRAIN_MAIN;
				END_IF
			END_IF
			
		TANKS_STIR:
			TON_Stir.IN := TRUE;
			IF TON_Stir.Q THEN
				gTanks.CurrentState := TANKS_DRAIN_MAIN;
				gMieszadlo := 0;
				TON_Stir.IN := FALSE;
			ELSE
				gMieszadlo := 1;
			END_IF
			
			
		TANKS_DRAIN_MAIN:
			IF gZb3_poziom <= gTanks.MainTankMinLevel THEN
				gZb3_zawor_glowny := FALSE;
				gTanks.CurrentState := TANKS_STOP;
			ELSE
				gZb3_zawor_glowny := TRUE;
			END_IF
			
			
	END_CASE
	
	TON_Stir(PT := gTanks.StirTime);
	
END_PROGRAM

PROGRAM _EXIT
	gTanks.MainTankFilled := FALSE;
	gTanks.FirstTankFilled := FALSE;
	gTanks.SecondTankFilled := FALSE;
	gZb1_zawor := FALSE;
	gZb2_zawor := FALSE;
	gZb3_zawor_glowny := FALSE;
	gZb3_zawor_lewy := 0;
	gZb3_zawor_prawy := 0;
	gMieszadlo := FALSE;
	 
END_PROGRAM

