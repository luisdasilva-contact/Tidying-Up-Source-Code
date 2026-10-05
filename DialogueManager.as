import flash.external.*;

class DialogueManager {	
	private static var _speakingCharacter:Number = 1;
	private static var _speakingCharEmotion:String = ""; // H for happy, S for sad, E for elated
	public static var InCharacterLineBreakDelimiter:String = "æ";
	private static var _char1DelimiterMin:Number = 0;
	private static var _char1DelimiterMax:Number = 2;
	private static var _char2DelimiterMin:Number = 2;
	private static var _char2DelimiterMax:Number = 6;
	private static var _startingIndex:Number = 0;
	private static var _currentSlice;
	private static var _indexOfDelimiter;
	private static var _millisecondsPerWord:Number = 700; //900
	private static var _timeForNextLine:Number = 0;
	private static var _timeForNextHint:Number = 0;
	private static var _hintFrequency:Number = 120000;
	private static var _characterIndex:Number = 0;
	private static var _characterIndexMax:Number = 0;
	private static var _lineIndex:Number = 0;
	private static var _lineIndexMax:Number = 0;	
	private static var _dialogueEditorCurrentPage:Number = 0;
	private static var _dialogueLinesPerPage:Number = 3;
	private static var _currentLineAtTopOfPage:Number = 0;
	private static var _defaultText:String = "Your text here!";
	private static var _startButtonManualTimer:Number = null;
	public static var ExistingdialogueStringArg:String = ""; // need this because hint system checks it for already-written hints
	public static var DialogueComplete:Boolean = false;
	public static var DialogueArray:Array = [];	
	public static var CharDelimiters:Array = ["±", "¶", "ß", "µ", "ø", "§"]; 
	// index 0 for sad Capy, 1 for happy Capy. 2-5 for sad Roombella, 
	//happy/normal Roombella, elated Roombella, mad Roombella
	public static var charEmotions:Array = ["S", "H", "E", "M"]; // sad, happy, elated, mad
	public static var StartDialogueDelay:Number = 2000;
	public static var EpilogueIndex:Number = 0;
	public static var EpilogueDialogue:Array = [["Capy", "Jacob! I thought you were working today?"], ["Jacob", "You think I'd wanna miss this?"],
		["Capy", "Well, it's just a bunch of old junk..."],
		["Jacob", "Yeah, but I'm sure you have stories about each and every thing in here"],
		["Roombella", "Ahem!"],
		["Jacob", "Oh, hi, Roombella!"],
		["Roombella", "Please don't get him started on anything..."],
		["Capy", "It's okay! I promise I'm ready to let it all go!"],
		["Jacob", "Woah, don't tell me you're getting rid of this little guy!"],
		["Jacob", "He's a treasure!"],
		["Capy", "Hmmm...you know, I might need to keep that one..."],
		["Roombella", "..."],
		["Capy","..."],
		["Capy", "...Everything must go."],
		["Jacob", "SOLD! I'll take it."],
		["Jacob", "Seems I'm fresh out of cash...mind if I pay in kisses?"],
		["Roombella", "BOO! GET A ROOM!"],
		["Capy", "H-HEY!"],
		["Roomba", "Hehehe!"]
	];
	
	/*
	 * For a given delimiter derived from CharDelimiters, sets the speakingCharacter and 
	   speakingCharEmotion variables accordingly.
	 * @param {String} delimiter The delimiter to use to set the speakingCharacter and
	   speakingCharEmotion variables.
	 */ 
	private static function _setSpeakingCharAndEmotion(delimiter:String):Void {
		switch (delimiter){
			case CharDelimiters[0]:
				_speakingCharacter = 1;
				_speakingCharEmotion = charEmotions[0];
				break;
			case CharDelimiters[1]:
				_speakingCharacter = 1;
				_speakingCharEmotion = charEmotions[1];
				break;
			case CharDelimiters[2]:
				_speakingCharacter = 2;
				_speakingCharEmotion = charEmotions[0];
				break;
			case CharDelimiters[3]:
				_speakingCharacter = 2;
				_speakingCharEmotion = charEmotions[1];
				break;
			case CharDelimiters[4]:
				_speakingCharacter = 2;
				_speakingCharEmotion = charEmotions[2];
				break;
			case CharDelimiters[5]:
				_speakingCharacter = 2;
				_speakingCharEmotion = charEmotions[3];
		};
	};
	
	/*
	 * For a given delimiter, retrieves the corresponding emotion.
	 * @param {String} delimiter The delimiter to retrieve the emotion of.
	 * @return {String} The emotion the delimiter corresponds to, retrieved from CharEmotions.
	 */ 
	public static function GetEmotionFromDelimiterIndex(delimiter:String):String {
		switch (delimiter){
			case CharDelimiters[0]:
				return charEmotions[0];
			case CharDelimiters[1]:
				return charEmotions[1];
			case CharDelimiters[2]:
				return charEmotions[0];
			case CharDelimiters[3]:
				return charEmotions[1];
			case CharDelimiters[4]:
				return charEmotions[2];
			case CharDelimiters[5]:
				return charEmotions[3];
		};
	};
	
	/*
	 * For a given delimiter, retrieves the corresponding character.
	 * @param {String} delimiter The delimiter to retrieve the character of.
	 * @return {String} The character the delimiter corresponds to.
	 */ 
	public static function GetCharacterFromDelimiterIndex(delimiter:String):String {
		switch (delimiter){
		case CharDelimiters[0]:
			return "Capy";
		case CharDelimiters[1]:
			return "Capy";
		case CharDelimiters[2]:
			return "Roombella";
		case CharDelimiters[3]:
			return "Roombella";
		case CharDelimiters[4]:
			return "Roombella";
		case CharDelimiters[5]:
			return "Roombella";
		};
	};
	
	/*
	 * Initiate the dialogue array, which manages each character's lines.
	 * @param {String} dialogueToParse The string, containing delimiters to show which characters are speaking and when, to break down into the Dialogue Array. 
	 */ 
	public static function InitiateDialogueArray(dialogueToParse:String):Void {
		DialogueComplete = false;
		ExistingdialogueStringArg += dialogueToParse;
		DialogueArray = [];
		_indexOfDelimiter = null;
		_speakingCharacter = 1;
		_startingIndex = 0;
		_timeForNextLine = 0;
		_characterIndex = 0;
		_characterIndexMax = 0;
		_lineIndex = 0;
		_lineIndexMax = 0;		
		
		for (var char = 0; char < dialogueToParse.length; char++){
			if (_startingIndex == 0){
				_setSpeakingCharAndEmotion(dialogueToParse.charAt(char));
				_startingIndex++;
			} else {
				var smallestValidIndex:Number = undefined; // loop through all possible delimiters for the other character(s), return whichever one is
				var oppositeCharDelimMin:Number = undefined;
				var oppositeCharDelimMax:Number = undefined;
				var charDelimMin:Number = undefined;
				var charDelimMax:Number = undefined;
				
				switch (_speakingCharacter){
					case 1:
						oppositeCharDelimMin = _char2DelimiterMin;
						oppositeCharDelimMax = _char2DelimiterMax;
						charDelimMin = _char1DelimiterMin;
						charDelimMax = _char1DelimiterMax;
						_indexOfDelimiter = dialogueToParse.indexOf(CharDelimiters[1], _startingIndex);
						break;							
					case 2:
						oppositeCharDelimMin = _char1DelimiterMin;
						oppositeCharDelimMax = _char1DelimiterMax;
						charDelimMin = _char2DelimiterMin;
						charDelimMax = _char2DelimiterMax;
						_indexOfDelimiter = dialogueToParse.indexOf(CharDelimiters[0], _startingIndex);
						break;
				};
				
				for (var i = oppositeCharDelimMin; i < oppositeCharDelimMax; i++){
					var indexToCheck = dialogueToParse.indexOf(CharDelimiters[i], _startingIndex);
					if (indexToCheck > -1){
						if (indexToCheck < smallestValidIndex || smallestValidIndex == undefined){
							smallestValidIndex = indexToCheck;
						};
					};
				};
				_indexOfDelimiter = smallestValidIndex;	
				
				if (_indexOfDelimiter == -1){
					_currentSlice = dialogueToParse.slice(_startingIndex, dialogueToParse.length);
				} else {
					_currentSlice = dialogueToParse.slice(_startingIndex, _indexOfDelimiter);
				};
				
				var speakingCharEmotions = [];
				speakingCharEmotions.push(_speakingCharEmotion);				
				var checkForDupeCharDelimiterArray = [];
				
				for (var charCheck = 0; charCheck < _currentSlice.length; charCheck++){
					for (var i = charDelimMin; i < charDelimMax; i++){
						if (_currentSlice.charAt(charCheck) == CharDelimiters[i]){
							checkForDupeCharDelimiterArray.push(charCheck);
						};
					};
				};				
				
				for (var i = 0; i < _currentSlice.length; i++){
					for (var j = 0; j < CharDelimiters.length; j++){
						if (_currentSlice.charAt(i) == CharDelimiters[j]){
							speakingCharEmotions.push(GetEmotionFromDelimiterIndex(CharDelimiters[j]));
						};
					};					
				};				
				
				for (var i = 0; i < checkForDupeCharDelimiterArray.length; i++){
					_currentSlice[checkForDupeCharDelimiterArray[i]] = InCharacterLineBreakDelimiter;
					var newCurSliceString = _currentSlice.slice(0, checkForDupeCharDelimiterArray[i]);
					newCurSliceString += InCharacterLineBreakDelimiter;
					newCurSliceString += _currentSlice.slice(checkForDupeCharDelimiterArray[i] + 1, _currentSlice.length + 1);
					_currentSlice = newCurSliceString;						
				};
				
				var currentSliceSplit = _currentSlice.split(InCharacterLineBreakDelimiter);
				var thisCharacterDialogue = {char: _speakingCharacter, dialogueLines: currentSliceSplit, emotion: speakingCharEmotions};				
				
				DialogueArray.push(thisCharacterDialogue);
				
				if (_indexOfDelimiter == -1 ||
					_indexOfDelimiter == undefined){
					_characterIndexMax = DialogueArray.length;
					break;
				};					
				
				_startingIndex = _indexOfDelimiter + 1;
				_setSpeakingCharAndEmotion(dialogueToParse.charAt(_indexOfDelimiter));
			};
		};
	};
	
	/*
	 * Manages functionality for auto-writing dialogue to the dialogue textbox.
	 */ 
	public static function WriteDialogueToTextbox():Void {
		if (getTimer() >= _timeForNextLine){			
			if (CheckForNextLine()){
				IncrementLineIndex();
				AutoplayText();
				DialogueManager.ManualDialogueNavCheck();
			} else {
				DialogueComplete = true;
			};
		};
	};
	
	/*
	 * Dedicated to non-primary dialogue, such as secondary dialogue and hints.
	 * @param {Boolean} forHint Indicates if the dialogue is related to the hint system. 
	 * @param {Array} dialogueObject The Array containing the dialogue and conditions to write the text, outlined in HintSystem.as. 
	 */ 
	public static function writeSecondaryDialogueToTextBox(forHint:Boolean,  dialogueObject:Array):Void {
		var additionalManualDelay = 0;
		var timePrerequisite = 0;
		
		if (forHint){
			additionalManualDelay = _hintFrequency;
			timePrerequisite = _timeForNextHint;
		} else {
			timePrerequisite = getTimer();
		};
		
		if ((Settings.ActiveDialogueStyle == Settings.dialogueStyles.auto && DialogueComplete) ||
			Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual && 
			(getTimer() >= GameplayLogic.TimeLevelStarted + additionalManualDelay + StartDialogueDelay)){			
			var hintObject = HintSystem.CheckLevelConditions(dialogueObject);
			
			if (getTimer() >= timePrerequisite){
				if (Settings.ActiveDialogueStyle== Settings.dialogueStyles.auto && hintObject != null){				
					DialogueComplete = false;
					InitiateDialogueArray(hintObject);	
				} else if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual && hintObject != null){
					var curCharMax = _characterIndexMax - 1;
					var curLineMax = DialogueArray[curCharMax].dialogueLines.length - 1;
					InitiateDialogueArray(MapLogic.CharacterDialogue + hintObject);
					MapLogic.CharacterDialogue = MapLogic.CharacterDialogue + hintObject;
					_characterIndex = curCharMax;
					_lineIndex = curLineMax;
					IncrementLineIndex();
					manualWrite();
					ManualDialogueNavCheck();
				};
				
				if (forHint){
					_timeForNextHint = getTimer() + _hintFrequency;
				};
			};
		};		
	};
	
	/*
	 * Increments _lineIndex by 1 if checks pass.
	 */ 
	public static function IncrementLineIndex():Void {			
		if (CheckForNextLine()){
			_lineIndex++;
		};
	};
	
	/*
	 * Decrements _lineIndex by 1 and adjusts _characterIndex accordingly.
	 */ 
	public static function DecrementLineIndex():Void {
		if (_lineIndex > 0){
			_lineIndex--;
		} else {
			if (_characterIndex > 0){
				_characterIndex--;
				_lineIndex = DialogueArray[_characterIndex].dialogueLines.length - 1;
			};
		};
	};
	
	/*
	 * Manages functionality related to initiating manual dialogue.
	 */ 
	public static function initManualDialogue():Void {
		if (_characterIndex == (_characterIndexMax - 1) && _lineIndex == (_lineIndexMax - 1)){
			_root.incrementDialoguePage._x = GameplayLogic.OffScreenStorage;
		} else {
			if (!_characterIndexMax == 1 && _lineIndexMax == 0){ // so long as there isn't just 1 line of dialogue here
				_root.incrementDialoguePage._x = 893.7;
			};
		};
		
		if (_characterIndex == 0 && _lineIndex == 0){
			_root.decrementDialoguePage._x = GameplayLogic.OffScreenStorage;
		} else {
			_root.decrementDialoguePage._x = 851.5;
		};	
		ManualDialogueNavCheck();
	};
		
	/*
	 * Handles functionality for manualy writing text to the character dialogue box, as opposed to auto-playing.
	 */ 
	public static function manualWrite():Void {		
		if (_characterIndex <= (_characterIndexMax - 1)){			
			_lineIndexMax = DialogueArray[_characterIndex].dialogueLines.length;
			
			if (_lineIndex <= (_lineIndexMax - 1) || (_lineIndex == _lineIndexMax)){
				if (_lineIndex == _lineIndexMax) {
					_characterIndex++;
					_lineIndex = 0;	
				};
				
				_root.charDialogueTxtBox.text = DialogueArray[_characterIndex].dialogueLines[_lineIndex];
				_root.characterPortrait.gotoAndStop(_getFrameForCharEmotion(DialogueArray[_characterIndex].char, DialogueArray[_characterIndex].emotion[_lineIndex]));
			}; 
			
			if (DialogueArray[_characterIndex].char == 1){
				_root.charWindowTxtBox.text = "Capy"
			} else {
				_root.charWindowTxtBox.text = "Roombella";
			};
		};
	};
	
	/*
	 * Retrieves the corresponding animation frame in the Character Portrait MC for a given character
	   and emotion.
	 * @param {Number} characterSpeaking Which character is speaking; 1 for Capy, 2 for Roombella.
	 * @param {String} emotion The emotion to retrieve the frame for, derived from charEmotions.
	 * @return {Number} The corresponding animation frame. 
	 */ 
	private static function _getFrameForCharEmotion(characterSpeaking:Number, emotion:String):Number {
		if (characterSpeaking == 1){
			if (emotion == charEmotions[0]){
				return 1;
			} else if (emotion == charEmotions[1]){
				return 2;
			};
		} else if (characterSpeaking == 2){
			if (emotion == charEmotions[0]){
				return 3;
			} else if (emotion == charEmotions[1]){
				return 4;
			} else if (emotion == charEmotions[2]){
				return 5;
			} else if (emotion == charEmotions[3]){
				return 6;
			};
		};			
		return 7;
	};
	
	/*
	 * Moves dialogue buttons as needed depending on user's current navigation in the manual dialogue.
	 */ 
	public static function ManualDialogueNavCheck():Void {
		if (!UI.InPostSceneDialogue){
			if (_characterIndex == 0 && _lineIndex == 0){
				_root.decrementDialoguePage._x = GameplayLogic.OffScreenStorage;
			} else {
				_root.decrementDialoguePage._x = 851.5;
			};
			
			if (!CheckForNextLine()){
				_root.incrementDialoguePage._x = GameplayLogic.OffScreenStorage;				
			} else {
				_root.incrementDialoguePage._x = 893.7;
			};
		} else {
			if (_characterIndex == 0 && _lineIndex == 0){
				_root.decrementDialoguePage._x = GameplayLogic.OffScreenStorage;
			} else {
				_root.decrementDialoguePage._x = 678.5;
			};
			
			if (!CheckForNextLine()){
				_root.incrementDialoguePage._x = GameplayLogic.OffScreenStorage;
				
				if (_characterIndex == 0 && _lineIndex == 0){
					_root.startLevelDialogueBtn._x = 625;
				};				
			} else {
				_root.incrementDialoguePage._x = 720.8;
			};
		};
	};
	
	/*
	 * Checks to see if there's another line in the dialogue.
	 * @return {Boolean} True if there's another line, false if not.
	 */ 
	public static function CheckForNextLine():Boolean {
		if (DialogueArray[_characterIndex].dialogueLines[_lineIndex + 1] == undefined &&
			DialogueArray[_characterIndex + 1].dialogueLines[0] == undefined){
			return false;
		} else {
			return true;
		};
	};
	
	/*
	 * Manages functionality to auto-write text to the dialogue window, managing a timer based upon the character length of the line.
	 */ 
	public static function AutoplayText():Void {	
			if (_characterIndex <= (_characterIndexMax - 1)){			
				_lineIndexMax = DialogueArray[_characterIndex].dialogueLines.length;
				
				if (_lineIndex <= (_lineIndexMax - 1) || (_lineIndex == _lineIndexMax)){						
					if (_lineIndex == _lineIndexMax){
						_characterIndex++;
						_lineIndex = 0;
					};
					
					_root.charDialogueTxtBox.text = DialogueArray[_characterIndex].dialogueLines[_lineIndex];
					_root.characterPortrait.gotoAndStop(_getFrameForCharEmotion(DialogueArray[_characterIndex].char, DialogueArray[_characterIndex].emotion[_lineIndex]));
					var wordNumCheck = DialogueArray[_characterIndex].dialogueLines[_lineIndex].split(" ").length;					
					_timeForNextLine = getTimer() + (wordNumCheck * _millisecondsPerWord);
				};
				
				if (DialogueArray[_characterIndex].char == 1){
				_root.charWindowTxtBox.text = "Capy"
				} else {
					_root.charWindowTxtBox.text = "Roombella";
				};					
			} else {
				_root.charWindowTxtBox.text = "-";
				_root.charDialogueTxtBox.text = "-";
				_root.characterPortrait.gotoAndStop(_root.characterPortrait._totalframes);
				DialogueComplete = true;
				_timeForNextHint = getTimer() + _hintFrequency;	
			};
		
	};
	
	/*
	 * Manages functionality related to adding a new line of dialogue in the Level Editor.
	 */ 
	public static function CreateNewLineInLevelEditor():Void {
		var lineObjectMCName:String = "CustomDialogueObject" + (LevelEditorLogic.UserWrittenDialogueLineObjects.length + Number(1));
		var lineObjectMC = _root.attachMovie("CustomDialogueObject", lineObjectMCName, _root.getNextHighestDepth());
		lineObjectMC._x = 39.5;
		lineObjectMC._y = 28.2 * (LevelEditorLogic.UserWrittenDialogueLineObjects.length + 1) + (LevelEditorLogic.UserWrittenDialogueLineObjects.length * 164.7);
		var deleteLineButton;
		var newestTextField = _root[lineObjectMCName].customDialogue;
		FormatTextForDialogue(newestTextField, _defaultText);	
		
		LevelEditorSetCharToActiveEmotion(_root[lineObjectMCName].charEmote, _root[lineObjectMCName].charName);
		_root[lineObjectMCName].charEmote.onPress = function() {
			for (var i = 0; i < LevelEditorLogic.UserWrittenDialogueLineObjects.length; i++){						
				if (LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC._name == this._parent._name){
					if (LevelEditorLogic.ActiveCustomDialogueEmotion == CharDelimiters[CharDelimiters.length]){
						LevelEditorLogic.ActiveCustomDialogueEmotion = CharDelimiters[0];
					} else {
						var indexOfActiveDelimiter;
						for (var j = 0; j < CharDelimiters.length; j++){
							if (CharDelimiters[j] == LevelEditorLogic.ActiveCustomDialogueEmotion){
								indexOfActiveDelimiter = j;
								break;
							};
						};						
						LevelEditorLogic.ActiveCustomDialogueEmotion = CharDelimiters[indexOfActiveDelimiter];						
					};
					LevelEditorSwitchActiveEmotion(this, this._parent.charName);	
					LevelEditorLogic.UserWrittenDialogueLineObjects[i].activeEmotion = LevelEditorLogic.ActiveCustomDialogueEmotion;
				};
			};
		};
		
		deleteLineButton = _root[lineObjectMCName].deleteBtn;		
		deleteLineButton.onPress = function() {
			for (var i = 0; i < LevelEditorLogic.UserWrittenDialogueLineObjects.length; i++){
				if (LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC._name == this._parent._name){
					LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC.removeMovieClip();
					LevelEditorLogic.UserWrittenDialogueLineObjects.splice(i, 1);
					break;
				};				
			};
			ReDrawAllLevelEditorDialogueLines(); 
			_checkForDialogueNavButtons();
		};
		
		var lineObj = {activeEmotion: LevelEditorLogic.ActiveCustomDialogueEmotion, line: newestTextField.text, lineTextField: newestTextField, 
			deleteButton: deleteLineButton, MC: lineObjectMC};
		LevelEditorLogic.UserWrittenDialogueLineObjects.push(lineObj);		
		if (LevelEditorLogic.UserWrittenDialogueLineObjects.length > _dialogueLinesPerPage){
			 _currentLineAtTopOfPage++; 
			 ReDrawAllLevelEditorDialogueLines();	
		};				
	};
	
	/*
	 * Re-draws all dialogue lines on screen, starting with the _currentLineAtTopOfPage, running through the max number
	   that can be displayed on screen, _dialogueLinesPerPage.
	 */ 
	public static function ReDrawAllLevelEditorDialogueLines():Void {
		RemoveLineObjectMCs();
		
		var loopVal:Number;
		if (LevelEditorLogic.UserWrittenDialogueLineObjects.length <= _dialogueLinesPerPage){
			loopVal = LevelEditorLogic.UserWrittenDialogueLineObjects.length;
			_currentLineAtTopOfPage = 0;
		} else {
			loopVal = _dialogueLinesPerPage + _currentLineAtTopOfPage;			
		};
		
		for (var i = _currentLineAtTopOfPage; i < loopVal; i++){
			if (LevelEditorLogic.UserWrittenDialogueLineObjects[i].line != undefined){
				var lineObjectMCName = "CustomDialogueObject" + (i + 1);
				var lineObjectMC = _root.attachMovie("CustomDialogueObject", lineObjectMCName, _root.getNextHighestDepth());
				
				lineObjectMC._x = 39.5;
				lineObjectMC._y = 28.2 + ((i - _currentLineAtTopOfPage) * (164.7 + 28.2));
				var reWrittenTextField = _root[lineObjectMCName].customDialogue;
				reWrittenTextField.text = LevelEditorLogic.UserWrittenDialogueLineObjects[i].line;
				FormatTextForDialogue(reWrittenTextField);
				LevelEditorLogic.ActiveCustomDialogueEmotion = LevelEditorLogic.UserWrittenDialogueLineObjects[i].activeEmotion; 
				LevelEditorSetCharToActiveEmotion(_root[lineObjectMCName].charEmote, _root[lineObjectMCName].charName);
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].lineTextField = reWrittenTextField;
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].deleteButton = _root[lineObjectMCName].deleteBtn;
				
				_root[lineObjectMCName].deleteBtn.onPress = function() {
					for (var i = 0; i < LevelEditorLogic.UserWrittenDialogueLineObjects.length; i++){
						if (LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC._name == this._parent._name){
							LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC.removeMovieClip();
							LevelEditorLogic.UserWrittenDialogueLineObjects.splice(i, 1);
							break;
						};				
					};
					ReDrawAllLevelEditorDialogueLines(); 
					_checkForDialogueNavButtons();
				};
				
				_root[lineObjectMCName].charEmote.onPress = function() {
					for (var i = 0; i < LevelEditorLogic.UserWrittenDialogueLineObjects.length; i++){						
						if (LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC._name == this._parent._name){
							if (LevelEditorLogic.ActiveCustomDialogueEmotion == CharDelimiters[CharDelimiters.length]){
								LevelEditorLogic.ActiveCustomDialogueEmotion = CharDelimiters[0];
							} else {
								var indexOfActiveDelimiter;
								for (var j = 0; j < CharDelimiters.length; j++){
									if (CharDelimiters[j] == LevelEditorLogic.ActiveCustomDialogueEmotion){
										indexOfActiveDelimiter = j;
										break;
									};
								};
								
								LevelEditorLogic.ActiveCustomDialogueEmotion = CharDelimiters[indexOfActiveDelimiter];
								
							}
							LevelEditorSwitchActiveEmotion(this, this._parent.charName);	
							LevelEditorLogic.UserWrittenDialogueLineObjects[i].activeEmotion = LevelEditorLogic.ActiveCustomDialogueEmotion;
						};
					};
				};
						
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC = lineObjectMC;				
			};
		};
		_checkForDialogueNavButtons();
	};
	
	/*
	 * Manages creation of dialogue navigation buttons when the user has more lines of dialogue than _dialogueLinesPerPage.
	 */ 
	private static function _checkForDialogueNavButtons():Void {
		if (LevelEditorLogic.UserWrittenDialogueLineObjects.length > _dialogueLinesPerPage){			
			_checkLineForNavBtnCreation("dialogueEditorPageUp");
			_checkLineForNavBtnCreation("dialogueEditorPageDown");			
		} else {
			if (_root["dialogueEditorPageUp"]){
				_root["dialogueEditorPageUp"].removeMovieClip();
			};
			
			if (_root["dialogueEditorPageDown"]){
				_root["dialogueEditorPageDown"].removeMovieClip();
			};
		};
	};
	
	/*
	 * Runs checks to see if a if a navigation button needs to be created/deleted when the user has more lines of dialogue than _dialogueLinesPerPage.
	 * @param {String} direction The direction to check creation/deletion for.
	 */ 
	private static function _checkLineForNavBtnCreation(direction:String):Void {
		var oppositeDirection;
		var check1; 
		var check2;
		var xLoc;
		var opxLoc;
		var lineIncrement;
		var opLineIncrement;
		
		if (direction == "dialogueEditorPageUp"){
			oppositeDirection = "dialogueEditorPageDown";
			check1 = _currentLineAtTopOfPage + (_dialogueLinesPerPage - 1);
			check2 = LevelEditorLogic.UserWrittenDialogueLineObjects.length - 1;
			xLoc = 200;
			opxLoc = 290;
			lineIncrement = -1;
			opLineIncrement = 1;
		} else if (direction == "dialogueEditorPageDown"){
			oppositeDirection = "dialogueEditorPageUp";
			check1 = _currentLineAtTopOfPage;
			check2 = 0;
			xLoc = 290;
			opxLoc = 200;
			lineIncrement = 1;
			opLineIncrement =  -1;
		};
		
		if (check1 == check2){
			if (_root[oppositeDirection]){
				_root[oppositeDirection].removeMovieClip();
			};
			
			if (_root[direction] == null){
				_root.attachMovie(direction, direction, _root.getNextHighestDepth());
				_root[direction]._x = xLoc;
				_root[direction]._y = 650;
				
				_root[direction].onPress = function(){
					_currentLineAtTopOfPage = _currentLineAtTopOfPage + lineIncrement;
					ReDrawAllLevelEditorDialogueLines();
				};
			};				
		} else {
			if (_root[oppositeDirection] == null){
				_root.attachMovie(oppositeDirection, oppositeDirection, _root.getNextHighestDepth());
				_root[oppositeDirection]._x = opxLoc;
				_root[oppositeDirection]._y = 650;
				
				_root[oppositeDirection].onPress = function() {
					_currentLineAtTopOfPage = _currentLineAtTopOfPage + opLineIncrement;
					ReDrawAllLevelEditorDialogueLines();
				};
			};
		};		
	};
	
	/*
	 * Removes all user-entered dialogue line MovieClips on the stage. Also resets all variables as needed.
	 */ 
	public static function RemoveLineObjectMCs():Void {			
		for (var i = 0; i < LevelEditorLogic.UserWrittenDialogueLineObjects.length; i++){			
			if (LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC != null &&
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC != undefined){
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].line = LevelEditorLogic.UserWrittenDialogueLineObjects[i].lineTextField.text; 
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].deleteButton = null;
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].lineTextField = null;
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC.removeMovieClip();
				LevelEditorLogic.UserWrittenDialogueLineObjects[i].MC = null;
			};
		};
	};
	
	/*
	 * Formats text according to the game's style guide.
	 * @param {TextField} dialogueTextField The text field to format.
	 * @param {!String} optionalText Optional text to enter in the field.
	 */ 
	public static function FormatTextForDialogue(dialogueTextField:TextField, optionalText:String):Void {
		var format1_fmt:TextFormat = new TextFormat();
		format1_fmt.font = "GamePixies";
		format1_fmt.size = 40;
		
		dialogueTextField.maxChars = UI.UserTextInputMaxChars;
		dialogueTextField.type = "input";
		dialogueTextField.textColor = 0xffffff;
		if (optionalText){
			dialogueTextField.text = optionalText;
		};
		dialogueTextField.setTextFormat(format1_fmt);
	};
	
	/*
	 * In the Level Editor, sets a given MC and nameField to the active emotion.
	 * @param {MovieClip} charEmoteMC The MovieClip containing the character's emotion.
	 * @param {TextField} nameField The text field That will have the character's name.
	 */ 
	public static function LevelEditorSetCharToActiveEmotion(charEmoteMC:MovieClip, nameField:TextField):Void {
		for (var i = 0; i < CharDelimiters.length; i++){
			if (CharDelimiters[i] == LevelEditorLogic.ActiveCustomDialogueEmotion){
				charEmoteMC.gotoAndStop(i + 1);	
				nameField.text = GetCharacterFromDelimiterIndex(LevelEditorLogic.ActiveCustomDialogueEmotion);
				break;
			};
		};
	};
	
	/*
	 * Switch the speaking character in the dialogue object.
	 * @param {MovieClip} charEmoteMC The MovieClip containing the character's emotion.
	 * @param {TextField} nameField The text field That will have the character's name.
	 */ 
	public static function LevelEditorSwitchActiveEmotion(charEmoteMC:MovieClip, nameField:TextField):Void {
		for (var i = 0; i < CharDelimiters.length; i++){
			if (CharDelimiters[i] == LevelEditorLogic.ActiveCustomDialogueEmotion){
				if (i == (CharDelimiters.length - 1)){
					LevelEditorLogic.ActiveCustomDialogueEmotion = CharDelimiters[0];
					charEmoteMC.gotoAndStop(1);					
				} else {
					LevelEditorLogic.ActiveCustomDialogueEmotion = CharDelimiters[i + 1];
					charEmoteMC.gotoAndStop(i + 2);					
				};
				nameField.text = GetCharacterFromDelimiterIndex(LevelEditorLogic.ActiveCustomDialogueEmotion);
				break;
			};
		};
	};
	
	/*
	 * Manage dialogue display in the Epilogue.
	 */ 
	public static function WriteLineToEpilogueBoxes():Void {
		_root.EpilogueSpeakerTxtBox.text = EpilogueDialogue[EpilogueIndex][0];
		_root.EpilogueDialogueTxtBox.text = EpilogueDialogue[EpilogueIndex][1];
	};
	
	/* 
	 * Initiates dialogue from a loaded level, allowing dialogue to be edited after upload.
	 */ 
	public static function InitDialogueLineObjectsFromLoadedCustomLevel():Void {
		LevelEditorLogic.UserWrittenDialogueLineObjects = [];
		for (var i = 0; i < DialogueArray.length; i++){
			var characterEntry = DialogueArray[i];
			var linesArray = characterEntry.dialogueLines;
			var emoteArray = characterEntry.emotion;
			
			for (var j = 0; j < linesArray.length; j++){
				var newLineObj = {};
				newLineObj.MC = null;
				newLineObj.deleteButton = null;
				newLineObj.lineTextField = null;
				
				if (characterEntry.char == 1 && emoteArray[j] == "S"){
					newLineObj.activeEmotion = CharDelimiters[0];					
				} else if (characterEntry.char == 1 && emoteArray[j] == "H"){
					newLineObj.activeEmotion = CharDelimiters[1];
				} else if (characterEntry.char == 2 && emoteArray[j] == "S"){
					newLineObj.activeEmotion = CharDelimiters[2];
				} else if (characterEntry.char == 2 && emoteArray[j] == "H"){
					newLineObj.activeEmotion = CharDelimiters[3];
				} else if (characterEntry.char == 2 && emoteArray[j] == "E"){
					newLineObj.activeEmotion = CharDelimiters[4];
				} else if (characterEntry.char == 2 && emoteArray[j] == "M"){
					newLineObj.activeEmotion = CharDelimiters[5];
				};
				
				newLineObj.line = linesArray[j];
				LevelEditorLogic.UserWrittenDialogueLineObjects.push(newLineObj);
			};			
		};
	};
	
	// checks if current line of dialogue shoudl result in sound effect; frankly terrible way of doing this
	// but it's only used once soooooo
	public static function SoundEffectCheck(){
		if (_root.charDialogueTxtBox.text == SecondaryDialogue.SecondaryEffectLine){
			SoundManager.PlaySound(SoundManager.SoundLibraryEnum.DoorCreak);
		};
	};
};