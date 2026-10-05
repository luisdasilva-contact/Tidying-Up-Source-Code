/*
 * Manages functionality related to screen transitions, including visual transitions and loading/unloading assets.
 */ 
class TransitionLogic {
	
	public static var skipCutsceneCoords:Object = {x: 967.2, y: 604.15};
	
	public static function InstantiateSkipCutsceneBtn(){
		trace("instantiating skip btn");
		_root.attachMovie("skipIntroBtn", "skipCutsceneBtnInstc", _root.getNextHighestDepth());				
		_root.skipCutsceneBtnInstc._x = skipCutsceneCoords.x;
		_root.skipCutsceneBtnInstc._y = skipCutsceneCoords.y;
		_root.skipCutsceneBtnInstc.gotoAndStop(1);
		_root.skipCutsceneBtnInstc.onRelease = function(){
			_root.startLevelDialogueBtn._x = GameplayLogic.OffScreenStorage;
			DialogueManager.DialogueComplete = true;
			_root["skipCutsceneBtnInstc"].removeMovieClip();
		};
	};
	
	/*
	 * Manages core functionality for transitioning into campaign from the main menu. Includes initiating variables, loading/unloading 
	  assets, and managing visual transitions.
	 */
	public static function BeginCampaignTransition():Void {
		if (_root.irisCloseTransitionInstc){
			_root.irisCloseTransitionInstc.removeMovieClip();
		};
		
		if (MapLogic.CurrentCampaignLvlNum == 0){
			IrisTransitionBehavior("irisCloseTransition", 0, 0);
		} else {
			_root.attachMovie("irisCloseTransition", "irisCloseTransitionInstc", _root.getNextHighestDepth());
			_root.irisCloseTransitionInstc.x = 0; 
			_root.irisCloseTransitionInstc.y = 0; 
		};
		
		var CampaignArray = MapLayouts.Campaign;
		var currentLevel = MapLogic.CurrentCampaignLvlNum;
		var completeAtLaunch = DialogueManager.DialogueComplete;
		// have this here in case DialogueComplete was set to true by skip button in intro cutscene; also don't want to reference DialogueComplte
		// itself because that's changed by one of the funcs below and frankly don't want to keep stacking onto existing code base
		if (GameplayLogic.ActiveCampaign == 1){
			CampaignArray = MapLayouts.DLCCampaign;
			currentLevel = DLCLevelLogic.CurrentDLCCampaignLvlNum;
		};
		
		_root.irisCloseTransitionInstc.irisCloseGroup.gotoAndStop(_root.irisCloseTransitionInstc.irisCloseGroup._totalframes);
		_root.irisCloseTransitionInstc.irisCloseGroup.irisCloseInstc.gotoAndStop(_root.irisCloseTransitionInstc.irisCloseGroup._totalframes);
		UI.InPostSceneDialogue = true;
		var mapObjectFromLevelString = MapLogic.ReadLevelString(MapLogic.ConvertLevelPropertiesToString(CampaignArray[currentLevel]));
		Controls.ReloadKeyListener();
		MapLogic.BuildLevel(mapObjectFromLevelString);
		_root.onEnterFrame = GameplayLogic.MainGameplayLoop;		
		UI.InitGameplayUI();
		
		if (GameplayLogic.ActiveCampaign == 0){
			if (!(MapLogic.FurthestLevelReached + 1 >= MapLayouts.Campaign.length)){
				// checking how far user got; if they finished campaign, let them change songs
				UI.AllowUserToChangeMusic = false; // triple-check if this is actually used anywhere, can just get rid of AllowUserToChangeMusic otherwise
				UI.MoveMusicNavigationOffScreen();	
			};
		} else if (GameplayLogic.ActiveCampaign == 1){
			if (!(DLCLevelLogic.FurthestDLCLevelReached + 1 >= MapLayouts.DLCCampaign.length)){
				// checking how far user got; if they finished campaign, let them change songs
				UI.AllowUserToChangeMusic = false;
				UI.MoveMusicNavigationOffScreen();	
			};
		};			
		
		if (MapLogic.CurrentCampaignLvlNum == 0 && GameplayLogic.ActiveCampaign == 0 && !completeAtLaunch){
			DialogueManager.InitiateDialogueArray(SecondaryDialogue.IntroDialogue);
			trace("skip cutscene instc 1");
			InstantiateSkipCutsceneBtn();
		} else {
			DialogueManager.DialogueComplete = true;
		};
		
		if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
			DialogueManager.initManualDialogue();
			DialogueManager.manualWrite();
		} else {
			DialogueManager.AutoplayText();
		};
	};
	
	/*
	 * Manages transitions, such as inter-scene dialogue and unloading the last level ahead of loading in the next.
	 */ 
	public static function TransitionFunctionality():Void {		
		if (UI.InPostSceneDialogue){
			if (DialogueManager.DialogueComplete){
				_root.irisCloseTransitionInstc.swapDepths(0); // CANNOT get rid of this line; removeMovieClip() doesn't work on items with a depth below 0
				_root.irisCloseTransitionInstc.removeMovieClip();
				
				if (_root.GlitchTransitionAnimInstc == null){
					UI.MoveDialogueWindowToStandardPosition();
					_root.attachMovie(UI.TransitionName, "GlitchTransitionAnimInstc", _root.getNextHighestDepth());
					SoundManager.PlaySoundOverride(SoundManager.SoundLibraryEnum.Static);
					_root.GlitchTransitionAnimInstc.onEnterFrame = function() {
						Utilities.TransitionActions(_root.GlitchTransitionAnimInstc, 27, CreateGlitchTransition, null, true);
					};	
				};
			};					
		};
	};
	
	public static function ResetCurrentLevel():Void {		
		if (_root._currentframe == FrameNavigation.Campaign){
			if (GameplayLogic.ActiveCampaign == 0){
				MapLogic.CurrentCampaignLvlNum--;
			} else {
				DLCLevelLogic.CurrentDLCCampaignLvlNum--;
			};
			
			CreateGlitchTransition();
			DialogueManager.DialogueComplete = true; // don't love this being here, but this is for 
			// instances like levels 2 or 3 where the post-scene dialogue would play upon restarting a level
		} else if (_root._currentframe == FrameNavigation.LevelEditorPreview){
			MapLogic.ClearCurrentMap();	
			LevelEditorLogic.PreviewLevel(LevelEditorLogic.CurrentLevelBeingTestedString, false);
		};	
	};
	
	
	/* 
	 * Manages functionality for the glitch transition after the "closing iris" animation has completed and before the 
	   "opening iris" animation has begun.
	 */ 
	public static function CreateGlitchTransition():Void {
		var mapObjectFromLevelString;
		var campaignLevel = MapLogic.CurrentCampaignLvlNum;
		var currentCampaignLength = MapLayouts.Campaign.length;
		var forDLC = false;
		
		if (GameplayLogic.ActiveCampaign == 1){
			forDLC = true;
			campaignLevel = DLCLevelLogic.CurrentDLCCampaignLvlNum;
			currentCampaignLength = MapLayouts.DLCCampaign.length;			
		};
		
		if (!UI.InPostSceneDialogue){
			UI.InPostSceneDialogue = true;			
			UI.EnableCampaignGameplayButtons(false);
			MapLogic.ClearCurrentMap();
			if (forDLC){
				DLCLevelLogic.CurrentDLCCampaignLvlNum++;
				campaignLevel = DLCLevelLogic.CurrentDLCCampaignLvlNum;
				mapObjectFromLevelString = MapLogic.ReadLevelString(MapLogic.ConvertLevelPropertiesToString(MapLayouts.DLCCampaign[campaignLevel]));
			} else {
				MapLogic.CurrentCampaignLvlNum++;
				campaignLevel = MapLogic.CurrentCampaignLvlNum;
				mapObjectFromLevelString = MapLogic.ReadLevelString(MapLogic.ConvertLevelPropertiesToString(MapLayouts.Campaign[campaignLevel]));
			};			
			
			Controls.ReloadKeyListener();
			MapLogic.BuildLevel(mapObjectFromLevelString);
			UI.InitGameplayUI();
			UI.MoveDialogueWindowToCenter();		
			_ManageTransitionSwapDepth(_root.irisCloseTransitionInstc);		
			DialogueManager.InitiateDialogueArray(SecondaryDialogue.GetPostSceneDialogue(forDLC, campaignLevel - 1));
			if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
				DialogueManager.initManualDialogue();
				DialogueManager.manualWrite();
			};			
			
			if (SecondaryDialogue.GetPostSceneDialogue(forDLC, MapLogic.CurrentCampaignLvlNum - 1) != null){
				DialogueManager.InitiateDialogueArray(SecondaryDialogue.GetPostSceneDialogue(forDLC, campaignLevel - 1));
				if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
					DialogueManager.initManualDialogue();
					DialogueManager.manualWrite();
				};
				InstantiateSkipCutsceneBtn();
			}  else {
				// just go to next level if there's no post-scene dialogue
				_root.startLevelDialogueBtn._x = GameplayLogic.OffScreenStorage;
				DialogueManager.DialogueComplete = true;
			};				
		} else if (forDLC && SecondaryDialogue.DoesDLCLevelHaveCutscene(campaignLevel)){
				if (DialogueManager.DialogueComplete){
					DialogueManager.DialogueComplete = false;
					UI.EnableCampaignGameplayButtons(false);
					SecondaryDialogue.CheckForDLCCutscene(DLCLevelLogic.CurrentDLCCampaignLvlNum);
					InstantiateSkipCutsceneBtn();
				};
		} else if (UI.InPostSceneDialogue){
			if (campaignLevel >= currentCampaignLength){
				UI.PreventInput = false;				
				UI.EnableCampaignGameplayButtons(true);
				UI.ClearDialogueWindow();
				if (forDLC){
					_root.gotoAndStop(FrameNavigation.DLCEnding);
					
					_root["DLCEpilogueMCInstc"].onEnterFrame = function(){
						if (_root["DLCEpilogueMCInstc"]._currentframe == _root["DLCEpilogueMCInstc"]._totalframes){
							_root["DLCEpilogueMCInstc"].stop();
									_root.gotoAndStop(FrameNavigation.MainMenu);
						};
					};
					
				} else {					
					_root.gotoAndStop(FrameNavigation.Epilogue);
					// this is here to account for a rare instance where a user uses the "hold to start" button in the final dialogue
					// before the epilogue
					if (_root["skipCutsceneBtnInstc"] != null){
						_root["skipCutsceneBtnInstc"].removeMovieClip();
					};
				};
				if (_root.irisCloseTransitionInstc){
					_root.irisCloseTransitionInstc.removeMovieClip();
				};				
				
				if (MapLogic.CheckDirtTrackingForAllCleaned(forDLC)){
					if (forDLC){
						NGAPI.UnlockMedal(NGAPI.FinishDLCGameMedalName);
					} else {
						NGAPI.UnlockMedal(NGAPI.FinishGameMedalName);
					};					
				};
				NGAPI.PostMovesInAllLevelsToScoreboard(forDLC);
				return;
			};			
			
			_root.skipCutsceneBtnInstc.removeMovieClip();
			UI.InPostSceneDialogue = false;		
			IrisTransitionBehavior("irisOpenTransition", GameplayLogic.Character1._x + (GameplayLogic.Character1._width * 2), 
				GameplayLogic.Character1._y + (GameplayLogic.Character1._height * 3.5));
			_root.irisOpenTransitionInstc.swapDepths(_root.getNextHighestDepth());
			UI.MoveDialogueWindowToStandardPosition();
			var transitionFunc = function() {
				UI.EnableCampaignGameplayButtons(true);
				UI.SetPopupOpenFalse();
				DialogueManager.DialogueComplete = false;
				DialogueManager.InitiateDialogueArray(MapLogic.CharacterDialogue);
				if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
					DialogueManager.initManualDialogue();
					DialogueManager.manualWrite();
				} else {
					DialogueManager.AutoplayText();					
				}
				GameplayLogic.TimeLevelStarted = getTimer();				
			};
			
			_root.irisOpenTransitionInstc.onEnterFrame = function() {
				Utilities.TransitionActions(_root.irisOpenTransitionInstc, 
				Math.floor(_root.irisOpenTransitionInstc.irisOpenGroup._totalframes / 4), transitionFunc, _root.irisOpenTransitionInstc.irisOpenGroup, true);
			};
		};			
	};
	
	/*
	 * Initiates functions and variables related to preparing for the "iris close" animation, signifying preparations for the 
	   next level.
	 */ 
	public static function NextLevelTransition():Void {
		IrisTransitionBehavior("irisCloseTransition", GameplayLogic.Character1._x + (GameplayLogic.Character1._width * 2), 
		GameplayLogic.Character1._y + (GameplayLogic.Character1._height * 3.5));

		var postTransitionFunc = function() {				
			_root.attachMovie(UI.TransitionName, "GlitchTransitionAnimInstc", _root.getNextHighestDepth());
			SoundManager.PlaySoundOverride(SoundManager.SoundLibraryEnum.Static);
			_root.GlitchTransitionAnimInstc.onEnterFrame = function() {
				Utilities.TransitionActions(_root.GlitchTransitionAnimInstc, 27, TransitionLogic.CreateGlitchTransition, null, true);
			};
		};

		_root.irisCloseTransitionInstc.onEnterFrame = function() {
			Utilities.TransitionActions(_root.irisCloseTransition, 30, postTransitionFunc, _root.irisCloseTransitionInstc.irisCloseGroup, false);
		};	
	};
	
	/*
	 * Manages behavior for the IrisClose and IrisOpen transitions. Includes processes for spawning the MC in the correct location as 
	   well as ensuring it's layered in the proper place.
	 * @param {transitionToSpawn} Which of the transitions to spawn.
	 * @param {Number} irisX X coordinate of where to spawn the animation.
	 * @param {Number} irisY Y coordinate of where to spawn the animation.
	 */ 
	public static function IrisTransitionBehavior(transitionToSpawn:String, irisX:Number, irisY:Number):Void {
		var irisAnim = _root.attachMovie(transitionToSpawn, transitionToSpawn + "Instc", _root.getNextHighestDepth());
		irisAnim._x = irisX;
		irisAnim._y = irisY;
		
		if (MapLogic.CurrentCampaignLvlNum == 0 && transitionToSpawn == "irisCloseTransition" && !GameplayLogic.Char1InGoal){
			_ManageTransitionSwapDepth(irisAnim);
		};		
	};
	
	/*
	 * Manages a transition MC when it needs to have its depth swapped in order to display inter-scene dialogue.
	 * @param {MovieClip} transitionMC The MC that will have its depth swapped with the MovieClips above the transition.
	 */ 
	private static function _ManageTransitionSwapDepth(transitionMC:MovieClip){
		/*var MCsAboveTransition = UI.GetStageMCsAboveTransition();
		var lowestDepthMC;
		var lowestDepth;
		
		for (var i = 0; i < MCsAboveTransition.length; i++){			
			if (lowestDepth == null){
				_root.LayerText.text += "MC name: " + MCsAboveTransition[i]._name + ", depth: " + MCsAboveTransition[i].getDepth() + 
				"/n";
				lowestDepth = MCsAboveTransition[i].getDepth();
				lowestDepthMC = MCsAboveTransition[i];
				continue;
			};
			if (MCsAboveTransition[i].getDepth() <= lowestDepth){
				lowestDepth = MCsAboveTransition[i].getDepth();		
				lowestDepthMC = MCsAboveTransition[i];
			};
			_root.LayerText.text += "MC name: " + MCsAboveTransition[i]._name + ", depth: " + MCsAboveTransition[i].getDepth() +
			"/n";
		};		
		_root.LayerText.text += "final lowest depth: " + lowestDepth;
		trace("MC with lowest depth: " + lowestDepthMC._name + ", MC: " + lowestDepth);
		//transitionMC.swapDepths(lowestDepth);*/
		// experimenting below, usual line above
		// not a great solution, but determined outsied of runtime that this is the proper depth; this could be done in a more
		// complex way but it's more error-prone
		transitionMC.swapDepths( -16340);
	};
};