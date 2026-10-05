import flash.external.*;

/*
 * Handles functionality related to UI, such as interpreting user input and assigning/managing functionality to buttons.
 */ 
class UI {
	private static var _navigationBtns:Array = ["MainMenu", "PreGameIntro", "Campaign", "Epilogue", "LevelSelect", "Settings", "LevelEditor", 
										"LevelEditorSetDialogue", "LevelEditorPreview", "FileBrowser", "EditOwnLevels", "OST"];
	private static var _settingsBtnsCheckmarks:Object = {hint: "hintCheckmarkArt", altTransition: "altTransitionCheckmarkArt"};	
	private static var _stageItemsAboveTransition:Array = ["characterPortraitFrame", "characterPortrait", "charDialogueTxtBox", 
													"decrementDialoguePage", "incrementDialoguePage", 
												"dialogueFrame", "startLevelDialogueBtn","charWindowTxtBox"];
	private static var _stageItemsLinkedToInputEnablement:Array = ["MainMenuBtn", "mobileMoveUp", "mobileMoveDown", "mobileMoveLeft", "mobileMoveRight",
																	"mobileSwitchCharBtn", "PlayMusicBtnInstc", "PrevMusicTrackNavBtn", "NextMusicTrackNavBtn"];
	public static var _songTitles:Array = ["Welcome!", "Imagination Creation", "Home", "Living Room", "Sweet Dreams", "Something Smells...", "Bone Apple Tea",
									"Round and Round", "Game Day", "Nine-To-Five", "Garage Beat", 
									"Haunted Basement", "Journey's End", // campaign level names end here
									"Thank You For Everything!", // end cutscene
									"Like the View",//settings
									"Title Screen: Round Two",// DLC songs start here
									"Waiter, There's a Puzzle in my Soup",
									"Double Flusher",
									"6 Feet Under the Restaurant", 
									"Stinky Situation",
									"Sewer Spiral Stairway",
									"The Lab Time Left Behind",
									"Gears and Gizmos",
									"Autoplay",
									"Metallic Meltdown",									
									"The Great Escape",
									"Ending: Round Two - Cleaned Up!"
									];
	private static var _backToMenuFromLvlEditorOwnLvlTxtBody:String = "Make sure to submit your level to the API if you're done!" +
		" Note that you can submit your level after beating it in the level preview.";
	private static var _backToMenuHeaderTxt:String = "Are you sure you want to leave?";
	private static var _backToMenuFromCampaignBodyTxt:String = "Note that if you're logged in, your campaign progress is saved to your account!";
	private static var _btnSuffix:String = "Btn";
	private static var _tileOffScreenStorage:Number = 200;
	private static var _tileSetDotIndicatorPrefix:String = "tileSetDotIndicator";
	public static var PreventInput:Boolean = false; // i.e. during a transition 
	public static var ShowedOwnLevelCompletedPopup:Boolean = false;
	public static var InPostSceneDialogue:Boolean = false;
	public static var UserTextInputTitleMaxChars:Number = 25;
	public static var UserTextInputLvlDescriptionMaxChars:Number = 100;
	public static var UserTextInputMaxChars:Number = 50;
	public static var AllowUserToChangeMusic:Boolean = true;
	
	/*
	 * Toggles the setting for whether or not the user wants to see hints. 
	 */ 
	private static function _hintCheckboxToggle():Void {
		Settings.ToggleHints();
		_updateCheckbox(_settingsBtnsCheckmarks.hint);
	};
	
	/*
	 * Toggles the setting for whether or not the user wants the epilepsy-friendly level transition. 
	 */ 
	private static function _altTransitionToggle():Void {
		Settings.ToggleAltTransition();
		_updateCheckbox(_settingsBtnsCheckmarks.altTransition);
	};
	
	public static function InitCampaignSelectUI(){
		PreventInput = false;
		_root.PlayClassicBtnInstc.onPress = function(){
			if (!PreventInput){
				PreventInput = true;
				SoundManager.StopSong();
				SoundManager.PlaySoundOverride(SoundManager.SoundLibraryEnum.DoorBell);
				var irisAnim = _root.attachMovie("irisCloseTransition", "irisCloseTransitionInstc", 50);
				irisAnim._x = Stage.width / 2;
				irisAnim._y = Stage.height / 2;
				var transitionFunc = function(){
					PreventInput = false;
					GameplayLogic.ActiveCampaign = 0;	
					_root.gotoAndStop(FrameNavigation.PreGameIntro);
				};
				
				irisAnim.onEnterFrame = function() {
					Utilities.TransitionActions(_root.irisCloseTransitionInstc, 30, transitionFunc, _root.irisCloseTransitionInstc.irisCloseGroup, true);
				};
			};
		};
		
		_root.PlayDLCBtnInstc.onPress = function(){
			if (!PreventInput){
				PreventInput = true;
				SoundManager.StopSong();
				SoundManager.PlaySoundOverride(SoundManager.SoundLibraryEnum.DoorBell);
				var irisAnim = _root.attachMovie("irisCloseTransition", "irisCloseTransitionInstc", 50);
				irisAnim._x = Stage.width / 2;
				irisAnim._y = Stage.height / 2;
				var transitionFunc = function(){
					PreventInput = false;
					GameplayLogic.ActiveCampaign = 1;
					_root.gotoAndStop(FrameNavigation.Campaign);	
				};
				
				irisAnim.onEnterFrame = function() {
					Utilities.TransitionActions(_root.irisCloseTransitionInstc, 30, transitionFunc, _root.irisCloseTransitionInstc.irisCloseGroup, true);
				};
			};
		};
		
		_root.MainMenuBtnCampaignSelectInstc.onPress = function(){
			_root.gotoAndStop(FrameNavigation.MainMenu);
		};
	};
	
	/*
	 * Assigns functions to buttons placed in the Main Menu.
	 */ 
	public static function AssignFunctionsToMainMenuBtns():Void {
		PreventInput = true;
		
		if (NGAPI.CurrentPlayerId != 10 && NGAPI.CurrentPlayerId != 0){	
			AssignFunctionToNavigationBtns(_root.LevelEditorCustomTitleAnimInstc.LevelEditorBtn, function(){NGAPI.CurrentlySavingUserLevelForFirstTime = true});
			AssignFunctionToNavigationBtns(_root.MyLevelsCustomTitleAnimInsc.EditOwnLevelsBtn, function(){NGAPI.CurrentlySavingUserLevelForFirstTime = false});
		} else {
			_root.LevelEditorCustomTitleAnimInstc._x = GameplayLogic.OffScreenStorage;
			_root.LevelEditorGrayedCustomTitleAnimInstc._x = 0;
			_root.MyLevelsCustomTitleAnim.EditOwnLevelsBtn._x = GameplayLogic.OffScreenStorage;	
			_root.MyLevelsGrayedCustomTitleAnimInsc._x = 0;
		};
		
		AssignFunctionToNavigationBtns(_root.LevelSelectTitleAnimInstc.LevelSelectBtn);
		AssignFunctionToNavigationBtns(_root.SettingsBtnTitleAnimInstc.SettingsBtn);
		AssignFunctionToNavigationBtns(_root.OSTTitleAnimInstc.OSTBtn);
		_root.StoryBtnTitleAnimInstc.CampaignBtn.onPress = function(){
			gotoAndStop(FrameNavigation.CampaignSelect);
			
		};
		
		AssignFunctionToNavigationBtns(_root.BrowseCustomTitleAnimInstc.FileBrowserBtn);
		var setPreventInputFalse = function(){
			PreventInput = false;
		};
		_root.StoryBtnTitleAnimInstc.onEnterFrame = function(){
			Utilities.TransitionActions(_root.StoryBtnTitleAnimInstc, 54, setPreventInputFalse, null, false);
		};
	};
	
	/*
	 * Sets PopupIsOpen to false. Need a dedicated function because arguments cannot be passed to button functions.
	 */ 
	public static function SetPopupOpenFalse():Void {
		UI.PreventInput = false;
	};
	
	/*
	 * Retrieve the name of the level transition MC. Depends on the user's choice between the
	   default transition and the alternate one.
	 * @return {String} The name of the transition MC.
	 */ 
	public static function get TransitionName():String {
		if (Settings.altTransition){
			return "altGlitchTransition";
		} else {
			return "GlitchTransitionAnim";
		};
	};
	
	/*
	 * Assigns functions to buttons placed in the Settings menu.
	 */ 
	public static function AssignFunctionsToSettingsBtns():Void {
		var removeCheckMark = function(){			
			if (_root.hintCheckmarkArt){
					_root.hintCheckmarkArt.removeMovieClip();
			};	
			
			if (_root.altTransitionCheckmarkArt){
					_root.altTransitionCheckmarkArt.removeMovieClip();
			};	
		};
		
		_updateCheckbox(_settingsBtnsCheckmarks.hint);
		_root.hintsCheckbox.onRelease = _hintCheckboxToggle;	
		_updateCheckbox(_settingsBtnsCheckmarks.altTransition);
		_root.altTransitionCheckbox.onRelease = _altTransitionToggle;		
		
		if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
			_root.autoPlayBtn.gotoAndStop(1);
			_root.manualBtn.gotoAndStop(2);
		} else if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.auto) {
			_root.autoPlayBtn.gotoAndStop(2);
			_root.manualBtn.gotoAndStop(1);
		};
		
		_root.autoPlayBtn.onPress = function(){
			Settings.SetActiveDialogueStyleToAuto();
			_root.autoPlayBtn.gotoAndStop(2);
			_root.manualBtn.gotoAndStop(1);
		};
		
		_root.manualBtn.onPress = function(){
			Settings.SetActiveDialogueStyleToManual();
			_root.manualBtn.gotoAndStop(2);
			_root.autoPlayBtn.gotoAndStop(1);
		};
		
		_root.ClearSaveDataBtnInstc.onPress = function(){
			PreventInput = true;
			var clearSaveDataPopup = _root.attachMovie("ClearSaveDataPopup", "ClearSaveDataPopupInstc", _root.getNextHighestDepth());
			clearSaveDataPopup._x = Stage.width / 2;
			clearSaveDataPopup._y = Stage.height / 2;
			
			clearSaveDataPopup.confirmClearSaveDataBtnInstc.onPress = function(){
				PreventInput = false;
				MapLogic.CurrentCampaignLvlNum = 0;
				DLCLevelLogic.CurrentDLCCampaignLvlNum = 0;
				MapLogic.FurthestLevelReached = 0;
				DLCLevelLogic.FurthestDLCLevelReached = 0;
				MapLogic.DirtCleaned = null;
				DLCLevelLogic.DLCDirtCleaned = null;
				MapLogic.InitDirtTracking();	
				DLCLevelLogic.InitDLCDirtTracking();
				MapLogic.MovesInAllLevels = null;
				DLCLevelLogic.MovesInAllDLCLevels = null;
				MapLogic.InitMovesInAllLevels();
				DLCLevelLogic.InitMovesInAllDLCLevels();				
				
				NGAPI.OverwriteCampaignSave(0, MapLogic.DirtCleaned, MapLogic.MovesInAllLevels, 0, 
					DLCLevelLogic.DLCDirtCleaned, DLCLevelLogic.MovesInAllDLCLevels);
				SoundManager.CheckForNewSongToUnlock();
				CreateBackToMenuPopup("Save data cleared!", "Go back to menu?", false, removeCheckMark);
				clearSaveDataPopup.removeMovieClip();
			};
			
			clearSaveDataPopup.cancelPopup.onPress = function(){
				PreventInput = false;
				clearSaveDataPopup.removeMovieClip();
			};
		};
		
		AssignFunctionToNavigationBtns(_root.MainMenuBtn, removeCheckMark);
	};
	
	
	/*
	 * For a given property with a checkbox, checks the status of that property (on or off) and updates the checkbox's visual accordingly.
	 * @param {String} property The property to check, pulled from _settingsBtnsCheckmarks.
	 */ 
	private static function _updateCheckbox(property:String):Void {
		var settingCheck:Boolean;
		var checkmarkBox:Button;
		
		switch(property){
			case _settingsBtnsCheckmarks.hint:
				settingCheck = Settings.displayHints;
				checkmarkBox = _root.hintsCheckbox;
				break;
			case _settingsBtnsCheckmarks.altTransition:
				settingCheck = Settings.altTransition;
				checkmarkBox = _root.altTransitionCheckbox;
				break;
			default:
				return;
		};		
		
		if (settingCheck){
			_root.attachMovie("checkmarkArt", property, _root.getNextHighestDepth());
			_root[property]._x = checkmarkBox._x;
			_root[property]._y = checkmarkBox._y;
		} else {
			if (_root[property]){
				_root[property].removeMovieClip();
			};
		};
	};	
	
	/*
	 * Based on the array in _navigationBtns, assigns navigational code to menu buttons.
	 * @param {Button} button The button to assign a navigational option to. On the stage, must have an instance name of one of the items in
	   the navigation buttons array followed by _btnSuffix (i.e. "LevelEditorBtn".)
	 * @param {Function=} addtlFunc An optional parameter for an additional function for the button to perform when pressed.
	 */ 
	public static function AssignFunctionToNavigationBtns(button:Button, addtlFunc:Function):Void {
		var assignNavigation:String;
		for (var i = 0; i < _navigationBtns.length; i++){
			if (button._name == _navigationBtns[i] + _btnSuffix){
				assignNavigation = _navigationBtns[i];
				break;
			};
		};
		
		if (assignNavigation){
			button.onRelease = function(){
				if (!PreventInput){
					if (addtlFunc){
						addtlFunc();
					};					
					gotoAndStop(assignNavigation);
				};
			};
		};		
	};
		
	/*
	 * Initiates the Level Editor UI.
	 */ 
	public static function InitLevelEditorUI():Void {
		LevelEditorLogic.LoadedLevelMadeByUser = true;	
				
		for (var i = 0; i < Controls.TileTypes.length; i++){
			var tileFromStage = Controls.TileTypes[i];
			Controls.AssignLvlEditorTileFuncs(_root[tileFromStage]);
		};
		
		LevelEditorLogic.tileSetIndex = 0;
		_updateTileSetDotIndicators();
		_root["PrevTiles"].onPress = function(){
			var prevIndex:Number = LevelEditorLogic.tileSetIndex;
			_setLevelEditorTileIndex(-1);
			ArrangeLevelEditorTiles(prevIndex, LevelEditorLogic.tileSetIndex);
			_updateLevelEditorTileSetTitle();
			_updateTileSetDotIndicators();
		};
		
		_root["NextTiles"].onPress = function(){
			var prevIndex:Number = LevelEditorLogic.tileSetIndex;
			_setLevelEditorTileIndex(1);
			ArrangeLevelEditorTiles(prevIndex, LevelEditorLogic.tileSetIndex);
			_updateLevelEditorTileSetTitle();
			_updateTileSetDotIndicators();
		};
		
		var dialoguePrep = function(){
			if (_root.tileGhost){
				_root.tileGhost.removeMovieClip();
			};
			LevelEditorLogic.CurrentLevelBeingTestedString = LevelEditorLogic.GetCurrentLevelForPreview();
			_root.gotoAndStop(FrameNavigation.LevelEditorSetDialogue);			
		};
		
		AssignFunctionToNavigationBtns(_root.LevelEditorSetDialogueBtn, dialoguePrep);
		_root.previewLvl.onRelease = function(){
			LevelEditorLogic.PreviewLevel(LevelEditorLogic.GetCurrentLevelForPreview(), true);		
		};
		_root.stageDrawingCanvas.onPress = LevelEditorLogic.ClickDrawingCanvas;
		_root.stageDrawingCanvas.onRelease = LevelEditorLogic.ClearDraggingVars;
		
		_root.MainMenuBtn.onRelease = function(){
			MainMenuBtnActions();
		};
		
		_root.editLevelDescriptionButton.onRelease = function(){
			PreventInput = true;
			var levelDescriptionPopup = _root.levelDescriptionPopupInstc;
			var	closeLevelDescriptionPopup = _root.levelDescriptionPopupInstc.closeLevelDescriptionPopupInstc;
			levelDescriptionPopup._x = Stage.width / 2;
			levelDescriptionPopup._y = Stage.height / 2;
			
			_root.levelDescriptionPopupInstc.swapDepths(_root.getNextHighestDepth());
			var levelDescriptionTextField = _root.levelDescriptionPopupInstc.levelDescriptionTextField;
			FormatTextForLevelDescription(levelDescriptionTextField, LevelEditorLogic.MapDescription);	

			closeLevelDescriptionPopup.onPress = function(){
				PreventInput = false;
				LevelEditorLogic.MapDescription = levelDescriptionTextField.text;
				levelDescriptionPopup._x = GameplayLogic.OffScreenStorage;
			};
		};
		
		_root.ClearActiveTileBtnInstc.onPress = function(){
			LevelEditorLogic.ClearActiveTileGhost();
		};
		
		_initMusicControls();				
	};	
	
	/* 
	 * Initiates the Level Editor dialogue UI.
	 */
	public static function InitLevelEditorDialogueUI():Void {
		if (_root.tileHolster){
			_root.tileHolster.removeMovieClip();
		};

		_root.newLineButton.onPress = function(){
			DialogueManager.CreateNewLineInLevelEditor();
		};

		_root.backToTestingBtn.onPress = function() {
			DialogueManager.RemoveLineObjectMCs();
			if (_root.dialogueEditorPageUp){
				_root.dialogueEditorPageUp.removeMovieClip();
			};
			
			if (_root.dialogueEditorPageDown){
				_root.dialogueEditorPageDown.removeMovieClip();
			};
			
			_root.gotoAndStop(FrameNavigation.LevelEditor);
		};
		DialogueManager.ReDrawAllLevelEditorDialogueLines();
	};
	
	/*
	 * Formats text according to the game's style guide for the Level Description.
	 * @param {TextField} dialogueTextField The text field to format.
	 * @param {String=} optionalText Optional text to enter in the field.
	 */ 
	public static function FormatTextForLevelDescription(dialogueTextField:TextField, optionalText:String):Void {
		var format1_fmt:TextFormat = new TextFormat();
		format1_fmt.font = "Junegull";
		format1_fmt.size = 26;
		dialogueTextField.type = "input";
		dialogueTextField.textColor = 0x190E2B;
		if (optionalText){
			dialogueTextField.text = optionalText;
		};
		dialogueTextField.setTextFormat(format1_fmt);
	};
	
	/*
	 * Handles initialization of the music controls in the UI.
	 */ 
	private static function _initMusicControls():Void {
		SoundManager.CheckForNewSongToUnlock();
		if (SoundManager.isSongPlaying){
			_root.PlayMusicBtnInstc.gotoAndStop(2);
		} else {
			_root.PlayMusicBtnInstc.gotoAndStop(1);
		};
		
		_root.PlayMusicBtnInstc.onRelease = function(){
			if (!UI.PreventInput){
				SoundManager.ToggleSongPlaying();
				if (SoundManager.isSongPlaying){
					_root.PlayMusicBtnInstc.gotoAndStop(2);
				} else {
					_root.PlayMusicBtnInstc.gotoAndStop(1);
				};
			};
		};
		
		_root.NextMusicTrackNavBtn.onRelease = function(){
			if (!UI.PreventInput){
				SoundManager.PlaySongByIndexAdjustment(1);
				//_root.MusicPlayingTxt.text = _songTitles[SoundManager.IndexOfCurrentSong];
				UI.ChangeMusicLabel(_songTitles[SoundManager.IndexOfCurrentSong]);
			};
		};
		
		_root.PrevMusicTrackNavBtn.onRelease = function(){
			if (!UI.PreventInput){
				SoundManager.PlaySongByIndexAdjustment(-1);
				//_root.MusicPlayingTxt.text = _songTitles[SoundManager.IndexOfCurrentSong];
				UI.ChangeMusicLabel(_songTitles[SoundManager.IndexOfCurrentSong]);
			};
		};	
		
		SoundManager.PlayDefaultTrack();	
		UI.ChangeMusicLabel(_songTitles[SoundManager.fadingIntoSongIndex]);
	};

	/*
	 * Initiates the Level Editor Preview UI.
	 */ 	
	public static function InitLevelEditorPreviewUI():Void {		
		AssignFunctionToNavigationBtns(_root.customLevelSelectBtn);
		var levelEditorFromPreviewBtnActions = function() {
			if (!PreventInput){
				if (NGAPI.LoadedLevelFromUserCreationsOnNG){
					NGAPI.LoadedLevelFromUserCreationsOnNG = null;
				};
				MapLogic.ClearCurrentMap();
				delete _root.onEnterFrame;
				_root.gotoAndStop(FrameNavigation.LevelEditor);
			};
		}
		AssignFunctionToNavigationBtns(_root.LevelEditorBtn, levelEditorFromPreviewBtnActions);	
		_root.submitToNGAPIButton.onPress = function(){
			if (!PreventInput){
				PreventInput = true;
				_root.NGAPILoadingPopup._x = Stage.width / 2;
				NGAPI.SubmitLevelToNGAPI();			
			};
		};
		
		_root.updateNGAPILevel.onPress = function(){
			if (!PreventInput){
				_root.NGAPILoadingPopup._x = Stage.width / 2;
				NGAPI.OverwriteLevelSave();	
			};
		};		
		
		if (!LevelEditorLogic.LoadedLevelMadeByUser){
			_root.LevelEditorBtn._x = GameplayLogic.OffScreenStorage;
		};
		
		if (_root.tileHolster){
			_root.tileHolster.removeMovieClip();
		};	
		
		InitGameplayUI();	
		
		// FOR TESTING ONLY
		_root.copyLvl.onPress = function(){
			System.setClipboard(LevelEditorLogic.GetCurrentLevelForPreview()); 
		};
		// END OF TESTING ONLY
	};
	
	/*
	 * Functionality used by the Main Menu button in the Campaign, Level Editor, and the Level Editor Preview. 
	 */ 
	public static function MainMenuBtnActions():Void {		
		if (LevelEditorLogic.LoadedLevelMadeByUser && 
		(_root._currentframe == FrameNavigation.LevelEditor || _root._currentframe == FrameNavigation.LevelEditorPreview)){
			CreateBackToMenuFromGameplayPopup(_backToMenuHeaderTxt, _backToMenuFromLvlEditorOwnLvlTxtBody);
		} else if (_root._currentframe == FrameNavigation.LevelEditor || _root._currentframe == FrameNavigation.LevelEditorPreview){
			CreateBackToMenuFromGameplayPopup(_backToMenuHeaderTxt,"");
		} else if (_root._currentframe == FrameNavigation.Campaign){
			CreateBackToMenuFromGameplayPopup(_backToMenuHeaderTxt, _backToMenuFromCampaignBodyTxt);
		};
	};
	
	/*
	 * Create a standard popup to go back to the main menu.
	 * @param {String} header The text to display in the header.
	 * @param {String} body The text to display in the body.
	 * @param {Boolean} includeBackground Whether or not to include the blue tint background.
	 * @param {Function} additionalFunction Any additional functions to perform after going back to menu.
	 */ 
	public static function CreateBackToMenuPopup(header:String, body:String, includeBackground:Boolean, additionalFunction:Function):Void {
		PreventInput = true;
		var backToMenuPopup = _root.attachMovie("backToMenuPopup", "backToMenuPopupInstc", _root.getNextHighestDepth());
		backToMenuPopup._x = Stage.width / 2;
		backToMenuPopup._y = Stage.height / 2;
		
		backToMenuPopup.goToMenuPopup.onPress = function(){
			PreventInput = false;
			_root.gotoAndStop(FrameNavigation.MainMenu);
			backToMenuPopup.removeMovieClip();
			if (additionalFunction){
				additionalFunction();
			};
		};
		
		backToMenuPopup.cancelPopup.onPress = function(){
			PreventInput = false;
			backToMenuPopup.removeMovieClip();
		};	
		
		if (!includeBackground){
			backToMenuPopup.BackToMenuPopupBG.swapDepths(1);
			backToMenuPopup.BackToMenuPopupBG.removeMovieClip();
		};
		
		backToMenuPopup.BackToMenuHeaderText.text = header;
		backToMenuPopup.BackToMenuBodyText.text = body;
	};
	
	/*
	 * Creates a menu that takes the user back to the Main Menu.
	 * @param {String} header The text to display in the header.
	 * @param {String} body The text to display in the body.
	 */ 
	
	public static function CreateBackToMenuFromGameplayPopup(header:String, body:String):Void {
		PreventInput = true;
		var backToMenuPopup = _root.attachMovie("backToMenuPopup", "backToMenuPopupInstc", _root.getNextHighestDepth());
		backToMenuPopup._x = Stage.width / 2;
		backToMenuPopup._y = Stage.height / 2;
		
		backToMenuPopup.goToMenuPopup.onPress = function(){
			PreventInput = false;
			LevelEditorLogic.ClearLevelEditorProperties();
			_root.gotoAndStop(FrameNavigation.MainMenu);
			backToMenuPopup.removeMovieClip();
			if (_root.dialogueFrame != null){
				_root.dialogueFrame.removeMovieClip();
			};
			if (_root.campaignNextLvlBtn != null){
				_root.campaignNextLvlBtn.removeMovieClip();
			};
			ShowedOwnLevelCompletedPopup = false;
		};
		
		backToMenuPopup.cancelPopup.onPress = function(){
			PreventInput = false;
			backToMenuPopup.removeMovieClip();
		};	
		
		backToMenuPopup.BackToMenuHeaderText.text = header;
		backToMenuPopup.BackToMenuBodyText.text = body;
	};
	
	/* 
	 * From the stage, retrieve the items that will be above the scene transition.
	 * @return {Array} Returns an Array of the Movie Clip items that should stay above the scene during a level-to-level transition.
	 */ 
	public static function GetStageMCsAboveTransition():Array {
		var itemsAboveTransition = [];
		for (var i = 0; i < _stageItemsAboveTransition.length; i++){
			itemsAboveTransition.push(_root[_stageItemsAboveTransition[i]]);
		};
		
		return itemsAboveTransition;
	};
	
	/*
	 * Initializes UI for main gameplay loop.
	 */ 
	public static function InitGameplayUI():Void {
		_root.mobileSwitchCharBtn.onPress = Controls.SwitchCharMode;
		_root.characterPortrait.gotoAndStop(_root.characterPortrait._totalframes);
			
		for (var key in Controls.DirectionalArrowsWithKeyCodes){
			var buttonFromStage = _root[key];
			Controls.AssignDirectionalArrowFunctions(buttonFromStage);
		};	
		
		DialogueManager.InitiateDialogueArray(MapLogic.CharacterDialogue);
		//if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){			
		if (_root._currentframe == FrameNavigation.LevelEditorPreview){ // really bad band-aid solution, don't know why this needs to be done
					DialogueManager.initManualDialogue();
					DialogueManager.manualWrite();
		};		
		
		_root.incrementDialoguePage.onPress = function() {
			Controls.IncrementDialogue();
		};
		
		_root.decrementDialoguePage.onPress = function() {
			Controls.DecrementDialogue();
		};
		
		if (_root.MainMenuBtn.onRelease == null){
			_root.MainMenuBtn.onRelease = function(){
				ClearDialogueWindow();
				MainMenuBtnActions();
			};
		};
		
		_initMusicControls();
	};
	
	/*
	 * Used when beginning a level that had an inter-level dialogue before it. Sets the dialogue
	   window back into its normal gameplay position.
	 */ 
	public static function MoveDialogueWindowToStandardPosition():Void {
		_root.charWindowTxtBox._x = 669.1;
		_root.characterPortraitFrame._x = 668.5;
		_root.characterPortrait._x = 684.3;
		_root.dialogueFrame._x = 668.5;
		_root.charDialogueTxtBox._x = 685.8;
		_root.startLevelDialogueBtn._x = GameplayLogic.OffScreenStorage;
		_root.decrementDialoguePage._x = 851.5;
		_root.incrementDialoguePage._x = 893.7;
	};
	
	/*
	 * Used when beginning a level that had an inter-level dialogue after it. Sets the dialogue
	   window into the center during the dialogue.
	 */ 
	public static function MoveDialogueWindowToCenter():Void {
		_root.charWindowTxtBox._x = 498.4;
		_root.characterPortraitFrame._x = 495.4;
		_root.characterPortrait._x = 513.5;
		_root.dialogueFrame._x = 495.6;
		_root.charDialogueTxtBox._x = 515.6;
		_root.characterPortrait.gotoAndStop(6);
		_root.charWindowTxtBox.text = "-"
		_root.decrementDialoguePage._x = 678.5;
		_root.incrementDialoguePage._x = 720.8;
	};
	
	/* 
	 * Clears out the dialogue window completely.
	 */ 
	public static function ClearDialogueWindow():Void {
		trace("clearing dialogue window, dialogue text exists? " + _root.charDialogueTxtBox.removeTextField());
		_root.charWindowTxtBox.removeTextField();
		_root.characterPortraitFrame.removeMovieClip();
		_root.characterPortrait.removeMovieClip();
		_root.dialogueFrame.removeMovieClip();
		_root.charDialogueTxtBox.removeTextField();
		_root.characterPortrait.removeMovieClip();
		_root.decrementDialoguePage.removeMovieClip();
		_root.incrementDialoguePage.removeMovieClip();
	};
	
	/*
	 * Initializes UI for the Epilogue scene.
	 */ 
	public static function InitEpilogueUI():Void {
		
		if (_root.decrementDialoguePage){
			_root.decrementDialoguePage.removeMovieClip();
		};
		
		if (_root.incrementDialoguePage){
			_root.incrementDialoguePage.removeMovieClip();
		};
		
		_root.EpilogueAnimInstc.onEnterFrame = function() {
			if (_root.EpilogueAnimInstc._currentframe == 140){
				_root.EpilogueNextLineInstc._x = 1172.9;
				DialogueManager.WriteLineToEpilogueBoxes();
				delete _root.EpilogueNextLineInstc.onEnterFrame;
			};
		};
		
		var backToMenuFunc = function() {
			_root.gotoAndStop(FrameNavigation.MainMenu);
		};
		
		var GlitchInitFunc = function (){			
			_root.attachMovie(UI.TransitionName, "GlitchTransitionAnimInstc", _root.getNextHighestDepth());
			SoundManager.PlaySoundOverride(SoundManager.SoundLibraryEnum.Static);
			_root.GlitchTransitionAnimInstc.onEnterFrame = function() {
				Utilities.TransitionActions(_root.GlitchTransitionAnimInstc, _root.GlitchTransitionAnimInstc._totalframes, backToMenuFunc, null, true);
			};			
		};
		
		_root.EpilogueNextLineInstc.onPress = function(){
			if (DialogueManager.EpilogueIndex + 1 < DialogueManager.EpilogueDialogue.length){
				DialogueManager.EpilogueIndex++;
				DialogueManager.WriteLineToEpilogueBoxes();
			} else {
				_root.EpilogueNextLineInstc._x = GameplayLogic.OffScreenStorage;
				_root.attachMovie("irisCloseTransition", "irisEpilogueClose", _root.getNextHighestDepth());
				_root.irisEpilogueClose._x = Stage.width / 2;
				_root.irisEpilogueClose._y = Stage.height / 2;
				_root.irisEpilogueClose.onEnterFrame = function() {
					Utilities.TransitionActions(_root.irisEpilogueClose, 30, GlitchInitFunc, _root.irisEpilogueClose.irisCloseGroup, true);
				};			
			};
		};
	};
	
	/*
	 * Enables or disables all on-screen buttons in the Campaign mode. Used mainly for preventing the user from tapping buttons 
	   (i.e. menu button, music controls) during the dialogue scenes.
	 * @param {Boolean} enable Whether to enable or disable the gameplay buttons.
	 */ 
	public static function EnableCampaignGameplayButtons(enable:Boolean):Void {
		for (var i = 0; i < _stageItemsLinkedToInputEnablement.length; i++){
			var gameplayBtn = _root[_stageItemsLinkedToInputEnablement[i]];
			gameplayBtn.enabled = enable;			
		};
	};
	
	// document this
	private static function _setLevelEditorTileIndex(indexIncrement:Number){
		if (LevelEditorLogic.tileSetIndex + indexIncrement < 0){
			LevelEditorLogic.tileSetIndex = Controls.allTileSets.length - 1;
		} else if (LevelEditorLogic.tileSetIndex + indexIncrement > Controls.allTileSets.length - 1){
			LevelEditorLogic.tileSetIndex = 0;
		} else {
			LevelEditorLogic.tileSetIndex += indexIncrement;
		};
	};
	
	// document this
	public static function ArrangeLevelEditorTiles(prevIndex:Number, newIndex:Number){
		// put current tileset off-screen and disable them
		if (newIndex != prevIndex){
			var currentTileSetArray = Controls.allTileSets[prevIndex][1];
			// 1 as index because index 0 is the title
			for (var i = 0; i < currentTileSetArray.length; i++){
				_root[currentTileSetArray[i]].enabled = false;
				_root[currentTileSetArray[i]]._y -= _tileOffScreenStorage;
			};
		};
		
		var newTileSetArray =  Controls.allTileSets[newIndex][1];
		for (var i = 0; i < newTileSetArray.length; i++){
			_root[newTileSetArray[i]].enabled = true;
			_root[newTileSetArray[i]]._y += _tileOffScreenStorage;
		};		
	};
	
	// aaaaand doc this
	private static function _updateLevelEditorTileSetTitle(){
		_root["tileSetTitle"].text = Controls.allTileSets[LevelEditorLogic.tileSetIndex][0];
	};
	
	// and doc this
	private static function _updateTileSetDotIndicators(){
		for (var i = 0; i < Controls.allTileSets.length; i++){
			if (i == LevelEditorLogic.tileSetIndex){
				_root[_tileSetDotIndicatorPrefix + i].gotoAndStop(1);
			} else {
				_root[_tileSetDotIndicatorPrefix + i].gotoAndStop(2);
			};
		};
	};
	
	// document me
	public static function InitOSTMenu(){
		_root["Bandcamp" + _btnSuffix].onPress = function(){
			_root.getURL("https://taxmann.bandcamp.com/album/tidying-up-original-game-soundtrack", "_blank");
		};
		
		_root["Spotify" + _btnSuffix].onPress = function(){
			_root.getURL("https://open.spotify.com/album/3nIt6P78qX64nCbDUW3Rst?si=uA4uPuNxT7S9bRl0R8AwKg&nd=1&dlsi=ffd7e9a8ab7e43d8", "_blank");
		};
		
		_root["Newgrounds" + _btnSuffix].onPress = function(){
			_root.getURL("https://www.newgrounds.com/album/275881/tidying-up-ost", "_blank");
		};
		
		_root["Apple" + _btnSuffix].onPress = function(){
			_root.getURL("https://music.apple.com/us/album/tidying-up-original-game-soundtrack/1681348683", "_blank");
		};
		
		_root["Youtube" + _btnSuffix].onPress = function(){
			_root.getURL("https://music.youtube.com/playlist?list=OLAK5uy_mVuLGrfVQiNv4J_XGmesS3d1k_zjMSVBE&feature=share", "_blank");
		};
					
		_root.MainMenuBtn.onPress = function(){
			_root.gotoAndStop(FrameNavigation.MainMenu);
		};			
	};
	
	public static function MoveMusicNavigationOffScreen():Void {
		_root.NextMusicTrackNavBtn._x = GameplayLogic.OffScreenStorage;
		_root.PrevMusicTrackNavBtn._x = GameplayLogic.OffScreenStorage;
	};
	
	
	public static function ChangeMusicLabel(newLabel:String):Void {
		var txtFormat:TextFormat = _root.MusicPlayingTxt.getTextFormat();
		
		if (newLabel.length <= 24){
			txtFormat.size = 30;
			_root.MusicPlayingTxt._y = 636.55;		
			_root.MusicPlayingTxt._height = 40;
		} else {
			txtFormat.size = 25;
			_root.MusicPlayingTxt._y = 624;	
			_root.MusicPlayingTxt._height = 90;
		};
		_root.MusicPlayingTxt.text = newLabel;
		_root.MusicPlayingTxt.wordWrap = true;
		_root.MusicPlayingTxt.multiline = true;
		
		_root.MusicPlayingTxt.setTextFormat(txtFormat);
		
					
	};
};