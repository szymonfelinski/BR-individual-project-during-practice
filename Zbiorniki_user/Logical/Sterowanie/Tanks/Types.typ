
TYPE
	TanksPara : 	STRUCT  (*Parameters used to define gTanks*)
		Stop : BOOL; (*Stops the state machine*)
		Start : BOOL; (*Starts the state machine*)
		Loop : BOOL; (*Enables closed loop execution*)
		EnableStir : BOOL; (*Enables stirring*)
		StirTime : TIME; (*Defines stirring time*)
		FirstTankFilled : BOOL; (*Has the first subsidiary tank been filled to set level?*)
		SecondTankFilled : BOOL; (*Has the second subsidiary tank been filled to set level?*)
		MainTankFilled : BOOL; (*Has the main tank been filled to set level?*)
		FirstTankMaxLevel : INT; (*Defines desired fill level for the first tank*)
		SecondTankMaxLevel : INT; (*Defines desired fill level for the second tank*)
		MainTankMaxLevel : INT; (*Defines desired fill level for the main tank*)
		MainTankMinLevel : INT; (*Defines the minimum allowed fill level for the main tank*)
		FirstTankCapacity : INT; (*Defines first tank's capacity*)
		SecondTankCapacity : INT; (*Defines second tank's capacity*)
		MainTankCapacity : INT; (*Defines main tank's capacity*)
		CurrentState : TanksStateMachine; (*Defines which state the machine is in*)
	END_STRUCT;
	TanksStateMachine : 
		( (*Main state machine used to define gTanks behaviour*)
		TANKS_FILL_SUB, (*Filling subsidiary tanks*)
		TANKS_FILL_MAIN, (*Filling main tank*)
		TANKS_STIR, (*Stirring main tank's contents*)
		TANKS_DRAIN_MAIN, (*Draining main tank*)
		TANKS_STOP (*All operation is stopped*)
		);
END_TYPE
