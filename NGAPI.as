import com.newgrounds.*;

/*
 * Manage all interactions with the Newgrounds API.
 */ 
class NGAPI {
	private static var _query:SaveQuery;
	private static var _curCampaignSaveFile:SaveFile;
	private static var _queryPseudoFile:Object;
	public static var CurrentPlayerId:Number;
	public static var CurrentlySavingUserLevelForFirstTime:Boolean = false;
	public static var LoadedLevelAuthorId:Number; // need this because the authorId can't be retrieved from SaveFile.currentFile
	public static var FinishGameMedalName:String = "Tidied Up";
	public static var FinishDLCGameMedalName:String = "Can I Get a To-Go Box?";
	public static var MovesInAllLevelsScoreboardName:String = "Fewest Moves to Beat Classic Campaign";
	public static var MovesInAllDLCLevelsScoreboardName:String = "Fewest Moves to Beat Restaurant Campaign";
	public static var LevelCalls:String = ""; // just for testing 
	public static var LoadedLevelFromUserCreationsOnNG;
	
	/*
	 * Initializes connection to the Newgrounds API.
	 */ 
	public static function InitNGAPI():Void {
		API.addEventListener(APIEvent.API_CONNECTED, _onAPIConnected);	
		API.addEventListener(APIEvent.FILE_LOADED, _onFileLoaded);
	};
	
	/*
	 * Executes after the connection to the Newgrounds API is established, initializing connection-dependant functions.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	private static function _onAPIConnected(event):Void {
		CurrentPlayerId = API.userId;
		LoadCampaignProgressCloudSave();
	};
	
	/*
	 * Executes when the user loads in one of their own levels, then opens it in the Level Editor.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	private static function _onUsersOwnLevelLoaded(event){
		var currentLevelData = event.data.data.data;
		LoadedLevelAuthorId = event.data.authorId;	
		LevelEditorLogic.CurrentLevelBeingTestedString = currentLevelData;
		_root.gotoAndStop(FrameNavigation.LevelEditor);
	};
	
	/*
	 * Executes when a user has loaded in another user's level through the file browser.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	private static function _onLevelLoaded(event){
		var loadedLevelData = event.data.data.data;
		LoadedLevelAuthorId = event.data.authorId;
		MapLogic.BuildLevel(MapLogic.ReadLevelString(loadedLevelData));
		LevelEditorLogic.PreviewLevel(loadedLevelData, false); 						
	};
	
	/*
	 * Executes when a user has voted on a user's level through the file browser.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	public static function OnVoteSubmitted(){
		LevelEditorLogic.ClearLevelEditorProperties();
		_root.gotoAndStop(FrameNavigation.MainMenu);
	};
	
	/*
	 * Executes after a custom level Save File is loaded. Manages setup related to establishing variables and navigation related to Custom Levels.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	private static function _onFileLoaded(event):Void {		
		if (event.data.group.name == "Custom Levels"){			
			if (event.data.data.data == undefined){
				event.data.load();
			};
			
			if (_root._currentframe == 1 && event.data.data.data != undefined){
				LoadedLevelFromUserCreationsOnNG = event;
				return;
			};
			
			if (LevelEditorLogic.LoadedLevelMadeByUser){
				_onUsersOwnLevelLoaded(event);
			} else {
				_onLevelLoaded(event);
			};
		};
	};
	
		public static function DEBUGGetCampaignData():String{
			return "Campaign lvl: " + _curCampaignSaveFile.data.campaignLvl + ", DLC cur level: " + _curCampaignSaveFile.data.DLCcampaignLvl + 
			", updated date: " + _curCampaignSaveFile.updatedDate;
		}
	
	/*
	 * Manages functionality when the campaign cloud save is fully loaded in. 
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	private static function _onCampaignSaveFileLoaded(event):Void {
		_curCampaignSaveFile = event.data;	
		MapLogic.CurrentCampaignLvlNum = _curCampaignSaveFile.data.campaignLvl;
		MapLogic.FurthestLevelReached = _curCampaignSaveFile.data.campaignLvl;
		MapLogic.DirtCleaned = _curCampaignSaveFile.data.dirtCleaned;
		MapLogic.MovesInAllLevels = _curCampaignSaveFile.data.movesInAllLevels;
		DLCLevelLogic.CurrentDLCCampaignLvlNum = _curCampaignSaveFile.data.DLCcampaignLvl;
		DLCLevelLogic.FurthestDLCLevelReached = _curCampaignSaveFile.data.DLCcampaignLvl;
		DLCLevelLogic.DLCDirtCleaned = _curCampaignSaveFile.data.DLCdirtCleaned;
		DLCLevelLogic.MovesInAllDLCLevels = _curCampaignSaveFile.data.DLCmovesInAllLevels;
		//_root.APIText.text += DEBUGGetCampaignData();
	};
	
	/*
	 * Unlocks a medal.
	 * @param {String} medalName The name of the medal to unlock.
	 */ 
	
	public static function UnlockMedal(medalName:String):Void {
		com.newgrounds.API.unlockMedal(medalName);
	};	
	
	/*
	 * Submits the current level to the Newgrounds Sharing API.
	 */ 
	public static function SubmitLevelToNGAPI():Void {
		CurrentlySavingUserLevelForFirstTime = true;
		var mapToSubmit = new Map(MapLogic.MapWidth, MapLogic.MapHeight, MapLogic.LevelTiles, 
								MapLogic.Character1SpawnGridCoord, MapLogic.Character2SpawnGridCoord, 
								LevelEditorLogic.LevelEditorDialogueToString(), _root.lvlNameTxtBox.text);
		var stringForNGAPI = LevelEditorLogic.CurrentLevelBeingTestedString;
		var file = com.newgrounds.API.createSaveFile("Custom Levels");	
		file.name = _root.lvlNameTxtBox.text;
		file.data = {data: stringForNGAPI};
		file.description = LevelEditorLogic.MapDescription;
		file.createIcon(LevelEditorLogic.MapScreenshot);
		file.authorName = com.newgrounds.API.username;
		file.authorId = com.newgrounds.API.userId;
		LoadedLevelAuthorId = com.newgrounds.API.userId;			
		file.save();				
		file.addEventListener(com.newgrounds.APIEvent.FILE_SAVED, GameplayLogic.OnLevelSubmitted);			
	};
	
	/*
	 * Initiates a query to retrieve a user's cloud save for their progress in the campaign.
	 */ 
	public static function LoadCampaignProgressCloudSave(forDLC:Boolean):Void {
		// Checking that the current user is A) logged in, and B) Not the Debugger user ID
		if (CurrentPlayerId != 0 && CurrentPlayerId != 10){
			var cloudSaveTitle = "Cloud Save";			
			_query = API.createSaveQuery(cloudSaveTitle);			
			_query.sortOn(SaveQuery.CREATED_ON, true);
			_query.addCondition(SaveQuery.AUTHOR_ID, SaveQuery.OPERATOR_EQUAL, 
				CurrentPlayerId.toString()); 
			_query.resultsPerPage = 1;
			_query.page = 1;
			_query.addEventListener(APIEvent.QUERY_COMPLETE, _cloudSaveQueryComplete); 
			_query.execute();
		};
	};
	
	/*
	 * Executed when the query in LoadCampaignProgressCloudSave has been completed. Creates a Cloud Save for the user
	   if one doesn't exist.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	private static function _cloudSaveQueryComplete(event):Void {
		_queryPseudoFile = event.data.files[0];
		if ((_queryPseudoFile == null || _queryPseudoFile == undefined) ||
			_queryPseudoFile.authorId != CurrentPlayerId) {
			_curCampaignSaveFile = API.createSaveFile("Cloud Save");
			MapLogic.InitDirtTracking();
			MapLogic.InitMovesInAllLevels();
			DLCLevelLogic.InitDLCDirtTracking();
			DLCLevelLogic.InitMovesInAllDLCLevels();
			OverwriteCampaignSave(0, MapLogic.DirtCleaned, MapLogic.MovesInAllLevels, 0, DLCLevelLogic.DLCDirtCleaned, 
				DLCLevelLogic.MovesInAllDLCLevels);			
		} else {
			_queryPseudoFile.addEventListener(APIEvent.FILE_LOADED, _onCampaignSaveFileLoaded);
			_queryPseudoFile.load();	
		};				
	};
	
	
	/*
	 * Updates the user's campaign save file.
	 * @param {Number} currentLvl The level the user is currently on in the campaign. A value of 0 erases progress.
	 */ 
	public static function OverwriteCampaignSave(currentLvl:Number, currentDirtTracking:String, currentMovesInAllLevels:Array,
	currentDLCLvl:Number, currentDLCDirtTracking:String, currentMovesInAllDLCLevels:Array):Void {
		if (_curCampaignSaveFile == null){
			return;
		} else {			
			_curCampaignSaveFile.data = {campaignLvl: currentLvl, dirtCleaned: currentDirtTracking, movesInAllLevels: currentMovesInAllLevels, 
				DLCcampaignLvl: currentDLCLvl, DLCdirtCleaned: currentDLCDirtTracking, DLCmovesInAllLevels: currentMovesInAllDLCLevels
			};
			_curCampaignSaveFile.name = "Campaign: Level " + (currentLvl + 1); // name isn't great but no need to mess w/ this at this point
			// because user never sees it anyway
			_curCampaignSaveFile.description = API.username + "'s Cloud Save";
			_curCampaignSaveFile.createIcon(_root.stageDrawingCanvas);
			_curCampaignSaveFile.save();
		};
	};	
	
	/*
	 * Executes when a level is loaded from the file browser.
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	public static function OnFileBrowserLevelLoaded(event):Void {
		var eventData = SaveFile(event.data);		
		var mapObjFromString = MapLogic.ReadLevelString(eventData);
		MapLogic.ClearCurrentMap();			
		_root.gotoAndStop(FrameNavigation.LevelEditorPreview);
		MapLogic.BuildLevel(mapObjFromString);
		UI.InitGameplayUI();	
	};
	
	/*
	 * If a user edits a level they've previously made, this function overwrites the previous level. 
	 */ 
	public static function OverwriteLevelSave():Void {
		var mapToSubmit = new Map(MapLogic.MapWidth, MapLogic.MapHeight, MapLogic.LevelTiles, 
									MapLogic.Character1SpawnGridCoord, MapLogic.Character2SpawnGridCoord, 
									LevelEditorLogic.LevelEditorDialogueToString(), _root.lvlNameTxtBox.text);
		var stringForNGAPI = LevelEditorLogic.CurrentLevelBeingTestedString;
		SaveFile.currentFile.name = _root.lvlNameTxtBox.text;
		SaveFile.currentFile.data = {data: stringForNGAPI};
		SaveFile.currentFile.description = LevelEditorLogic.MapDescription;
		SaveFile.currentFile.createIcon(LevelEditorLogic.MapScreenshot);
		SaveFile.currentFile.save();
		SaveFile.currentFile.addEventListener(APIEvent.FILE_SAVED, GameplayLogic.OnLevelSubmitted);	
	};	
	
	public static function PostMovesInAllLevelsToScoreboard(forDLC:Boolean):Void {
		var sumOfAllMoves = 0;
		var correspondingScoreboardName = MovesInAllLevelsScoreboardName;
		if (forDLC){
			correspondingScoreboardName = MovesInAllDLCLevelsScoreboardName;
			for (var i = 0; i < DLCLevelLogic.MovesInAllDLCLevels.length; i++){
				sumOfAllMoves += DLCLevelLogic.MovesInAllDLCLevels[i];
			};
		} else {
			for (var i = 0; i < MapLogic.MovesInAllLevels.length; i++){
				sumOfAllMoves += MapLogic.MovesInAllLevels[i];
			};
		};
		
		API.postScore(correspondingScoreboardName, sumOfAllMoves);
	};
};