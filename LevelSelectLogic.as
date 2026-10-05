/*
 * Manages functionality related to the Level Select. Largely focused on UI functionality,
   reading the user's campaign data, and loading levels.
 */
class LevelSelectLogic {
	private static var _buttonPrefix:String = "Level";
	private static var _DLCbuttonPrefix:String = "DLCLevel";
	private static var _buttonSuffix:String = "Btn";
	private static var CampaignLevelSelect:Array = [];
	private static var DLCCampaignLevelSelect:Array = [];
	
	/*
	 * Initiates the list of level select buttons.
	 */ 
	public static function InitCampaignLevelSelectButtonList():Void {
		for (var i = 0; i < MapLayouts.Campaign.length; i++){
			var btn = _root[_buttonPrefix + (i + 1) + _buttonSuffix];
			CampaignLevelSelect.push(btn);
		};
	};
	
	public static function InitDLCLevelSelectButtonList():Void {
		for (var i = 0; i < MapLayouts.DLCCampaign.length; i++){
			var btn = _root[_DLCbuttonPrefix + (i + 1) + _buttonSuffix];
			DLCCampaignLevelSelect.push(btn);
		};
	};
	
	/*
	 * Initiates visuals for the buttons in the level select screen.
	 * @param {MovieClip} btn The button to the the appearance for.
	 * @param {Number} level The level the button corresponds to.
	 * @param {Boolean} completedLevel Whether or not the level has been completed.
	 * @param {Boolean} Whether or not the level has had all its dirt cleaned.
	 */ 
	public static function SetLevelSelectButtonAppearance(btn:MovieClip, level:Number, completedLevel:Boolean, cleanedAllDirt:Boolean, forDLC:Boolean):Void {
		var btnFrame:Number = 1;
		var movesInLevel:String = "";
		var movesList = MapLogic.MovesInAllLevels;
		var prefix = _buttonPrefix;
		
		if (forDLC){
			movesList = DLCLevelLogic.MovesInAllDLCLevels;
			prefix = _DLCbuttonPrefix;
		};
		
		if (movesList[level] == 0 || movesList[level] == undefined){
			movesInLevel = "-";
		} else if (movesList[level] > 999){
			movesInLevel = "999+";
		} else {
			movesInLevel = movesList[level];
		};
		
		if (cleanedAllDirt){
			btnFrame = 3;
		} else if (completedLevel){
			btnFrame = 2;
		};		
		
		btn.LevelNum.text = level + 1;
		// using rollout and rollover as workarounds for button states because Flash cannot detect mouseover
		// on buttons nested w/ in MCs
		if (cleanedAllDirt || completedLevel){
			btn.gotoAndStop(btnFrame);
			btn.nestedBtn.gotoAndStop(1);
			btn.nestedBtn.LevelNum.text = level + 1;
			btn.onRollOver = function(){
				btn.nestedBtn.gotoAndStop(2);
				btn.nestedBtn.LevelNum.text = GetLevelLabelFromInstanceName(btn, prefix);
			};
			
			btn.onRollOut = function(){
				btn.nestedBtn.gotoAndStop(1);
				btn.nestedBtn.LevelNum.text = GetLevelLabelFromInstanceName(btn, prefix);
			};
			
			btn.MovesNum.text = movesInLevel;
			return;
		};		
		btn.LevelNum.text = GetLevelLabelFromInstanceName(btn, prefix);
		btn.gotoAndStop(btnFrame);		
	};
	
	/*
	 * Gets the level label from a Movie Clip's instance name.
	 * @param {MovieClip} mc The Movie Clip to retrieve the label from.
	 * @param {String} The new label.
	 */ 
	public static function GetLevelLabelFromInstanceName(mc:MovieClip, prefix:String):String {
		var newName = mc._name.substr(prefix.length, mc._name.length);
		return newName.substr(0, newName.length - _buttonSuffix.length);
	};
	
	/*
	 * Initiates the level select button functionality.
	 */ 
	public static function InitLevelSelectButtonFuncs():Void {
		if (_root._currentframe == FrameNavigation.LevelSelect)
		
		if (CampaignLevelSelect.length == 0){
			InitCampaignLevelSelectButtonList();
		};
		
		for (var i = 0; i < CampaignLevelSelect.length; i++){
			var btn:MovieClip = CampaignLevelSelect[i];
			var completedLevel:Boolean = false;
			var cleanedAllDirt:Boolean = false;
			
			if (MapLogic.DirtCleaned.charAt(i) == "T"){
				cleanedAllDirt = true;
			};
			
			if (i <= MapLogic.FurthestLevelReached){
				if (btn.onPress == null){
					btn.onPress = function(){
						btn.NestedBtn.gotoAndStop(3);
						MapLogic.CurrentCampaignLvlNum = Number(GetLevelLabelFromInstanceName(this, _buttonPrefix)) - 1;
						GameplayLogic.ActiveCampaign = 0;
						_root.gotoAndStop(FrameNavigation.Campaign);					
					};
				};
				completedLevel = true;
			}; 
			
			SetLevelSelectButtonAppearance(btn, i, completedLevel, cleanedAllDirt, false);	
		};
		
		if (MapLogic.FurthestLevelReached + 1 >= CampaignLevelSelect.length &&
			MapLogic.CheckDirtTrackingForAllCleaned(false)){
			_root.retryMedal._y = 600.2;
			_root.retryMedal.onPress = function(){
				NGAPI.UnlockMedal(NGAPI.FinishGameMedalName);
			};
		};
		
		if (MapLogic.CheckMovesInAllLevelsCompleted(false)){
			_root.resubmitLevelScoresBtn._y = 642.65;			
			_root.resubmitLevelScoresBtn.onPress = function(){
				NGAPI.PostMovesInAllLevelsToScoreboard(false);
			};
		};
		
		_root.MainMenuBtn.onPress = function(){
			_root.gotoAndStop(FrameNavigation.MainMenu);
		};
		
		_root.ToRestaurantLevelsBtn.onPress = function(){
			_root.gotoAndStop(FrameNavigation.DLCLevelSelect);
		};
	};
	
	
	public static function InitDLCLevelSelectButtonFuncs():Void {		
		if (DLCCampaignLevelSelect.length == 0){
			InitDLCLevelSelectButtonList();
		};
		
		for (var i = 0; i < DLCCampaignLevelSelect.length; i++){
			var btn:MovieClip = DLCCampaignLevelSelect[i];
			var completedLevel:Boolean = false;
			var cleanedAllDirt:Boolean = false;
			
			if (DLCLevelLogic.DLCDirtCleaned.charAt(i) == "T"){
				cleanedAllDirt = true;
			};
			
			if (i <= DLCLevelLogic.FurthestDLCLevelReached){
				if (btn.onPress == null){
					btn.onPress = function(){
						btn.NestedBtn.gotoAndStop(3);
						DLCLevelLogic.CurrentDLCCampaignLvlNum = Number(GetLevelLabelFromInstanceName(this, _DLCbuttonPrefix)) - 1;
						GameplayLogic.ActiveCampaign = 1;
						_root.gotoAndStop(FrameNavigation.Campaign);					
					};
				};
				completedLevel = true;
			}; 
			
			SetLevelSelectButtonAppearance(btn, i, completedLevel, cleanedAllDirt, true);
		};
		
		if (DLCLevelLogic.FurthestDLCLevelReached + 1 >= DLCCampaignLevelSelect.length &&
			MapLogic.CheckDirtTrackingForAllCleaned(true)){
			_root.retryDLCMedal._y = 600.2;
			_root.retryDLCMedal.onPress = function(){
				NGAPI.UnlockMedal(NGAPI.FinishDLCGameMedalName);
			};
		};
		
		if (MapLogic.CheckMovesInAllLevelsCompleted(true)){
			_root.resubmitDLCLevelScoresBtn._y = 642.65;			
			_root.resubmitDLCLevelScoresBtn.onPress = function(){
				NGAPI.PostMovesInAllLevelsToScoreboard(true);
			};
		};
		
		_root.MainMenuBtn.onPress = function(){
			_root.gotoAndStop(FrameNavigation.MainMenu);
		};
		
		_root.ToClassicLevelsBtn.onPress = function(){
			_root.gotoAndStop(FrameNavigation.LevelSelect);
		};
	};
};