import Math.random;

/*
 * Manages functionality for the hint system.
 */ 
class HintSystem {
	public static var CleanedLevelCondition = "cleanedLevel";
	public static var FiveMinPassedSinceStartingLevelCondition = "fiveMinPassedSinceStartingLevel";
	public static var ThirtySecPassedSinceStartingLevelCondition = "thirtySecPassedSinceStartingLevel";
	public static var SwitchedCharsThisLevelCondition = "switchedCharsThisLevel";
	public static var CappyTouchedGoalCondition = "cappyTouchedGoal";
	public static var CreatedRoombellaCloneFirstTimeCondition = "CreatedRoombellaCloneFirstTime";
	public static var RoombellaTrappedInCageFirstTimeCondition = "RoombellaTrappedInCageFirstTime";
	public static var CapyTrappedInCageFirstTimeCondition = "CapyTrappedInCageFirstTime";
	public static var BothCharsTrappedAtSameTimeCondition = "BothCharsTrappedAtSameTime";
	public static var ShowedRoombellaCloneMessageBefore = false;
	public static var ShowedEitherCharTrappedMessageBefore = false;
	
	/*
	 * can have multiple stylings/phrasings for hints, like so: hintDialogue: ["`µVersion 1 of this hint!" + "¶Neat!",
	   "µVersion 2 of this hint!" + "¶Also neat!"]
	 */ 
	private static var _level1Hints = [	
		{
			hintConditions: [
				{condition: ThirtySecPassedSinceStartingLevelCondition, bool: true}, 
				{condition: SwitchedCharsThisLevelCondition, bool: false}],
				hintDialogue: ["µRemember, if you need my help, you can tag me in at any time!" +
				"µJust tap the 'SWITCH' button (or the spacebar) and I'll get to work!" + "¶That sounds easy enough!"]		
		}, 
		{
			hintConditions: [
				{condition: CleanedLevelCondition, bool: true},
				{condition: ThirtySecPassedSinceStartingLevelCondition, bool: true}
			],
			hintDialogue: ["¶I think I'm ready to move on to the next room now." + 
							"µSounds good! Just lead the way!" + 
							"¶I guess I'll make my way to the door then, huh?" + 
							"µThat should do the trick!"]
		}	
	];
	
	private static var _level2Hints = [	
		{
			hintConditions: [
				{condition: FiveMinPassedSinceStartingLevelCondition, bool: true}
			],
			hintDialogue: ["µRemember, you can always block my path if I'm getting sidetracked." + 
							"µI promise I won't be offended!"]
		}	
	];	
	
	
	public static var CampaignHints = [
	_level1Hints, _level2Hints, null, null, 
	null, null, null, null,
	null, null, null, null,
	null, null
	];
	
	public static var DLCCampaignHints = [
	null, null, null, null, 
	null, null, null, null,
	null, null, null, null,
	null, null
	];
	
	/*
	 * Checks an individual hint's condition along with its bool to see if it match's the game's status.
	 * @param {String} condition The condition to check, matched against the conditions in this class.
	 * @param {Boolean} bool If the condition must be true or false when compared to the game's status.
	 * @return {Boolean} Whether or not the hint is acceptable to display.
	 */ 
	private static function _checkHintCondition(condition:String, bool:Boolean):Boolean {
		var gameplayStatus:Boolean;
		var returnStatus:Boolean;
		var statusComparison = function(gameplayStatus:Boolean){			
			if (gameplayStatus == bool){
				returnStatus = true;
			} else {
				returnStatus = false;
			};
		};
		
		switch(condition){
			case CleanedLevelCondition:
				if (GameplayLogic.Dirt.length == 0){
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case CappyTouchedGoalCondition:				
				if (GameplayLogic.CappyTouchedGoal){
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case FiveMinPassedSinceStartingLevelCondition:
				if (getTimer() - GameplayLogic.TimeLevelStarted >= (1000 * 300)){
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case ThirtySecPassedSinceStartingLevelCondition:
				if (getTimer() - GameplayLogic.TimeLevelStarted >= (1000 * 30)){
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case SwitchedCharsThisLevelCondition:
				if (GameplayLogic.PlayerSwitchedCharacters){
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case CreatedRoombellaCloneFirstTimeCondition:
				if (DLCTileLogic.Char2Clone != null && !ShowedRoombellaCloneMessageBefore){
					ShowedRoombellaCloneMessageBefore = true;
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case RoombellaTrappedInCageFirstTimeCondition:
				if (DLCTileLogic.RoombellaTrappedAtLeastOnce && !ShowedEitherCharTrappedMessageBefore){
					ShowedEitherCharTrappedMessageBefore = true;
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;
			case CapyTrappedInCageFirstTimeCondition:
				if (DLCTileLogic.CapyTrappedAtLeastOnce && !ShowedEitherCharTrappedMessageBefore){
					ShowedEitherCharTrappedMessageBefore = true;
					statusComparison(true);
				} else {
					statusComparison(false);
				};
				break;	
			case BothCharsTrappedAtSameTimeCondition:
				if (DLCTileLogic.CharacterInABCCage(1) && DLCTileLogic.CharacterInABCCage(2)){
					statusComparison(true);
				} else {
					statusComparison(false);
				};
		};
		
		if (returnStatus){
			return true;
		} else {
			return false;
		};
	};
	
	/*
	 * Checks a levelHints object to see if any hints are valid to display.
	 * @param {Array} levelHints The level hint object which will have its condition(s) checked. If all pass, the hintDialogue will be 
	   displayed to the user.
	 * @return {String} The string to display as a hint if all conditions are met.
	 */ 
	public static function CheckLevelConditions(levelHints:Array):String {
		for (var i = 0; i < levelHints.length; i++){
			var hintConditionObj = levelHints[i]; 
			var allConditionsPass = true;
			var dialogueIndex = 0;
			
			for (var j = 0; j < hintConditionObj.hintConditions.length; j++){
				var condition = hintConditionObj.hintConditions[j].condition;
				var bool = hintConditionObj.hintConditions[j].bool;
				if (!_checkHintCondition(condition, bool)){
					allConditionsPass = false;
				};
			};			
			
			if (allConditionsPass){
				// this for loop exists to make sure the same hint isn't being written twice.
				for (var i = 0; i < hintConditionObj.hintDialogue.length; i++){
					if (DialogueManager.ExistingdialogueStringArg.indexOf(hintConditionObj.hintDialogue[i]) != -1){
						return null;
					};
				};				
				
				if (hintConditionObj.hintDialogue.length > 1){
					dialogueIndex  = Math.floor(Math.random() * hintConditionObj.hintDialogue.length);
				};
				return hintConditionObj.hintDialogue[dialogueIndex];			
			};
			
		};
		return null;
	};		
};