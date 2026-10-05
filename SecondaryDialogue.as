/*
 * Contains all non-primary dialogue and non-hint dialogue, such as inter-scene dialogue and conditional secondary dialogue.
 */ 
class SecondaryDialogue {
	public static var IntroDialogue = "µI'm he--!" + 
		"ßOh...Oh my, this place is a lot worse than I thought..." + 
		"±Sorry...I know...it's pretty embarrassing." + 
		"±You don't have to help if it's too much to ask." + 
		"µNo, it's okay! I can handle it!" + 
		"µThis is exactly the sort of thing I'm programmed for!" + 
		"¶Oh, that's great! I wouldn't even know where to get started..." +
		"¶...Where should we get started actually?" +
		"øHow 'bout right here? This room's as good as any!";	
	private static var _lvl1PostDialogue = "¶Wow, we really did it." +
		"øSee? That wasn't too bad!" + 
		"±Well, no....but you haven't seen the rest of the house yet...." +
		"øI'm sure we can do it if we work together!" +
		"±I don't know if I'm quite so confident...."
	private static var _lvl2PostDialogue = "¶I think I'm starting to get the hang of this." +
		"µWhere to next?" +
		"¶Hmmm, let's head to the bedroom." +
		"øWe got this!";
	private static var _level13PostDialogue = "øWe did it!" + 
		"øI'm proud of you Capy! You've come a long way." +
		"¶I'm proud of me too." +
		"µSo how are you feeling? Do you need to take a break before we tackle the attic?" +
		"¶No, I'm ready, let's do it!" +
		"øAlright, you lead the way!";
			
	private static var _level14PostDialogue = "¶We really did it! I never thought I'd see the floor of this place again." +
		"µWell, that's why you ask for help!" +
		"¶Thank you Roombella." +
		"¶I really couldn't have done it without you." +
		"øNo trouble at all!" +
		"µBut...I wouldn't mind doing something else next time!" +
		"µMaybe...to meet your new boyfriend?" +
		"¶You're so pushy! We'll see!" +
		"ßBah, you're no fun." +
		"¶I said we'll see!" +
		"µAlright, alright." +
		"µDinner then? I'm still holding you to that one!" +
		"¶Yeah. Dinner sounds nice." +
		"øHooray! I'm so hungry, you have no idea!";
	
	private static var _level7AddtlDialogue = [
		{
			hintConditions: [
			{condition: HintSystem.CleanedLevelCondition, bool: true}], 
			hintDialogue: 
				[
				"±Do you think there's something wrong with me?" +
				"ß..." +
				"±What kind of animal would choose to live like this, right?" +
				"ßWell..." +
				"±It's okay, you can say it." +
				"ßI've just never seen it like this before." +
				"ßYou were never the tidiest guy, but it was never like this." +
				"±I know....I think I just sort of gave up after a certain point." +
				"±I just didn't have the energy, you know?" +
				"¶Oh, i just heard the laundry." +
				"µWould you like some help folding?" +
				"¶Oh...yeah, thanks."				
				]					
		}	
	];	
	
	private static var _DLClevel3AddtlDialogue = [
		{
			hintConditions: [
				{condition: HintSystem.RoombellaTrappedInCageFirstTimeCondition, bool: true}
			],
			hintDialogue: ["ßAgh! I'm stuck in a cage!" +
							"µHmm, It looks like the cage triggers when a lever's color matches the cages!"]
		},	
		{
			hintConditions: [
				{condition: HintSystem.CapyTrappedInCageFirstTimeCondition, bool: true}
			],
			hintDialogue: ["±Agh! I'm stuck in a cage!" + 
							"¶Hmm, It looks like the cage triggers when a lever's color matches the cages!"]
		},
		{
			hintConditions: [
				{condition: HintSystem.BothCharsTrappedAtSameTimeCondition, bool: true}
			],
			hintDialogue: ["ßAgh, now we're both stuck! Might wanna hit that \"restart\" button..."]
		}		
	];
	
	private static var _DLClevel6AddtlDialogue = [
		{
			hintConditions: [
				{condition: HintSystem.CreatedRoombellaCloneFirstTimeCondition, bool: true}
			],
			hintDialogue: ["øIt's ME!" +
							"µI'm you!" + 
							"µYou're me!" + 
							"øA lifelong dream..." + 
							"ø...finally achieved."]
		},
		{
			hintConditions: [
				{condition: HintSystem.BothCharsTrappedAtSameTimeCondition, bool: true}
			],
			hintDialogue: ["ßAgh, now we're both stuck! Might wanna hit that \"restart\" button..."]
		}
		
	];
	
	private static var _DLClevel2PostDialogue = "±AGHHHHH!" + 
	"ßWhat's going on in there?!" +
	"±HELP!" + 
	"ßYOU REALLY FELL IN?!" + 
	"±I didn't mean to!" +
	"øDon't you worry! I'm comin' down!" +
	"±But--!";
	
	private static var _DLClevel3PostDialogue = "¶Hey, here's a door!" + 
	"±...Oh." + 
	"±...It's just a ladder going even deeper..." + 
	"µ..." +
	"±..." +
	"µWe're doing this, right?" +
	"±..." +
	"øC'mon! Down the rabbit hole we go!" +
	"±..." +
	"±I'm glad I didn't leave a tip...";
		
	public static var AllPostLevelDialogue = [
		_lvl1PostDialogue, _lvl2PostDialogue, null, 
		null, null, null,
		null, null, null,
		null, null, null,
		_level13PostDialogue, _level14PostDialogue
	];
	
	public static var AllDLCPostLevelDialogue = [
		null, _DLClevel2PostDialogue, _DLClevel3PostDialogue, 
		null, null, null,
		null, null, null,
		null
	];
	
	public static var AllAddtlDialogue = [
		null, null, null, 
		null, null, null, 
		_level7AddtlDialogue, null, null,
		null, null, null, 
		null, null
	];
	
	public static var AllDLCAddtlDialogue = [
		null, null, _DLClevel3AddtlDialogue, 
		_DLClevel3AddtlDialogue, _DLClevel3AddtlDialogue, _DLClevel6AddtlDialogue, 
		_DLClevel3AddtlDialogue, _DLClevel3AddtlDialogue, _DLClevel3AddtlDialogue,
		_DLClevel3AddtlDialogue
	]; //  little hack-y to just have the level 4 dialogue for each section, but they're
	// all the same anyway and this file doesn't need to be longer for no good reason
	
	private static var _DLCCrashCutsceneLevel = 2; 
	private static var _DLCLabCutsceneLevel = 5;
	private static var _DLCRobotCutsceneLevel = 6;
	public static var PlayedDLCCrashCutscene = false;
	public static var PlayedDLCLabCutscene = false;
	public static var PlayedDLCRobotCutscene = false;
	public static var SecondaryEffectLine = "...Oh.";
	
	/*
	 * For a given level number (0-indexed), gets the post-scene dialogue; i.e.
	   if the levelNum is 0, returns the dialogue between level 1 and 2.
	 * @param {Boolean} forDLC Whether or not the dialogue for the DLC is being retrieved.
	 * @param {Number} levelNum The 0-indexed level to retrieve dialogue for.
	 * @return {String} The dialogue string, interpretable by functions in DialogueManager.
	 */ 
	public static function GetPostSceneDialogue(forDLC:Boolean, levelNum:Number):String {
		if (forDLC){
			return AllDLCPostLevelDialogue[levelNum];
		} else {
			return AllPostLevelDialogue[levelNum];
		};
	};
	
	public static function DoesDLCLevelHaveCutscene(levelToCheck:Number):Boolean {
		if (levelToCheck == _DLCCrashCutsceneLevel && PlayedDLCCrashCutscene == false){
			PlayedDLCCrashCutscene = true;
			return true;
		} else if (levelToCheck == _DLCLabCutsceneLevel && PlayedDLCLabCutscene == false){
			PlayedDLCLabCutscene = true;
			return true;
		} else if (levelToCheck == _DLCRobotCutsceneLevel && PlayedDLCRobotCutscene == false){
			PlayedDLCRobotCutscene = true;
			return true;
		};
		
		return false;			
	};
	
	public static function CheckForDLCCutscene(levelToCheck:Number){
		if (levelToCheck == _DLCCrashCutsceneLevel || levelToCheck == _DLCLabCutsceneLevel 
			|| levelToCheck == _DLCRobotCutsceneLevel){
			var cutscene = null;
			
			if (levelToCheck == _DLCCrashCutsceneLevel){
				cutscene = _root.attachMovie("BathroomCollapseMC", "BathroomCollapseMCInstc", _root.getNextHighestDepth());
			} else if (levelToCheck == _DLCLabCutsceneLevel){
				cutscene = _root.attachMovie("ConspiracyConfirmedMC", "ConspiracyConfirmedMCInstc", _root.getNextHighestDepth());
			} else if (levelToCheck == _DLCRobotCutsceneLevel){				
				cutscene = _root.attachMovie("RobotCutsceneMC", "RobotCutsceneMCInstc", _root.getNextHighestDepth());				
			};
			
			if (cutscene != null){
				cutscene._x = 640;
				cutscene._y = 360;
				cutscene.onEnterFrame = function(){
					if (cutscene._currentframe == cutscene._totalframes){
						DialogueManager.DialogueComplete = true;
					};
					// having this here allows dialoguecomplete to be set true by another object, 
					// such as the Skip button
					if (DialogueManager.DialogueComplete == true){
						// hate doing it this way but buttons cannot be removed from scene
						Utilities.DeleteEnterFrameAndMC(cutscene);
					};
				};
			};
		};
	};
	
	/*
	 * For a given level number (0-indexed), gets the additional dialogue object, containing
	   the dialogue and conditions to display the dialogue.
	 * @param {Boolean} forDLC Whether or not the dialogue for the DLC is being retrieved.
	 * @param {Number} levelNum The 0-indexed level to retrieve dialogue for.
	 * @return {Array} The additional dialogue object. 
	 */ 
	public static function GetAddtlDialogue(forDLC:Boolean, levelNum:Number):Array {
		if (forDLC){
			return AllDLCAddtlDialogue[levelNum];
		} else {
			return AllAddtlDialogue[levelNum];
		};
	};			
};