import GameplayLogic;	
import MovieClip;

/*
 * Handles logic related to the map itself, such as aligning game objects to the grid. "Cell" refer to a tile's MovieClip, while "GridCoord" refers 
   to a tile's numerical location, given as a 0-indexed XY coordinate tied to the map's height and width (i.e. 0,0 refers to the tile in the upper
   left corner of a 15x15 map.) 
 */ 
class MapLogic {
	private static var _tileSize:Number = 38;
	private static var _mapWidth:Number = 0;
	private static var _mapHeight:Number = 0;
	public static var AllCells:Array = [];
	public static var CellToMoveTo:MovieClip = null;
	public static var TileTypeToMoveTo:String = null; // used rarely, only in timed gate calcs for char2
	public static var LevelTiles:Array = [];
	public static var Character1SpawnGridCoord:Object = null;
	public static var Character2SpawnGridCoord:Object = null;
	public static var GoalCell:MovieClip = null;
	public static var GoalGridCoord:Object;
	public static var Key1Cell:MovieClip;
	public static var Key1GridCoord:Object;
	public static var Gate1Cell:MovieClip;
	public static var Gate1GridCoord:Object;
	public static var ABCSwitchObjects:Array = []; // Array of Objects representing the ABC switches themselves, including their cells, grid coords, and status (A, B, or C). 
	// Using this method instead of creating a custom class for the sake of consistancy w/ other tiles
	public static var ABCGateObjects:Array = [];
	// start DLC objs
	public static var TimedGateObjects:Array = [];
	public static var ABCCageObjects:Array = [];
	public static var PortalObjects:Array = [];
	public static var ClonerObjects:Array = [];
	// end DLC objs
	public static var CurrentCampaignLvlNum:Number = null;
	public static var DirtCleaned:String = null;
	public static var MovesInAllLevels:Array = null;
	public static var CharacterDialogue:String;		
	public static var FurthestLevelReached:Number = 0;
	
	public static function get TileSize():Number {
		return _tileSize;
	};
	
	public static function get MapWidth():Number {
		return _mapWidth;
	};
	
	public static function get MapHeight():Number {
		return _mapHeight;
	};
	
	/*
	 * For a given coordinate, retrieves the ABC switch at that coordinate, if there is any.
	 * @param {Number} xCoord The X coordinate to search at.
	 * @param {Number} yCoord The Y coordinate to search at.
	 * @return {Object} The ABC Switch object. 
	 */ 
	public static function GetABCSwitchIndexByGridCoord(xCoord:Number, yCoord:Number):Object {
		for (var i = 0; i < ABCSwitchObjects.length; i++){
			if (ABCSwitchObjects[i].GridCoord.x == xCoord &&
				ABCSwitchObjects[i].GridCoord.y == yCoord){
				return i;
			};
		};			
		return null;
	};
	
	/*
	 * Scans through cells to find all gates of the type in the string (A, B, or C). If the gate is found, it is
	   unlocked.
	 * @param {String} type Should be "A", "B", or "C". This is the type of gate that should be unlocked.
	 */ 
	public static function UnlockAllABCGatesOfType(type:String):Void {			
		for (var i = 0; i < ABCGateObjects.length; i++){
			if (ABCGateObjects[i].status == type + "_closed"){
				ABCGateObjects[i].status = type + "_open";
				LevelTiles[ABCGateObjects[i].GridCoord.y][ABCGateObjects[i].GridCoord.x] = 
					MapLayouts.Tiles["ABCGate_" + ABCGateObjects[i].status];
					SoundManager.PlayABCGateSound(type);
			};
		};
	};
	
	/*
	 * Scans through cells to find all gates *not* of the type in the string (A, B, or C). If the gate is found, it is
	   locked. Includes verification to ensure only gates with acceptable traits are locked (i.e. not already being
	   held open by another switch, and those that don't have a character underneath them so the character isn't squished!)
	 * @param {String} type Should be "A", "B", or "C". This is the type of gate that should be kept open; others are locked.
	 */ 
	public static function LockAllABCGatesNotOfType(type:String, forClone:Boolean):Void {
		var canLockGate:Boolean;
		for (var i = 0; i < ABCGateObjects.length; i++){			
			canLockGate = true;
			if (ABCGateObjects[i].status != type + "_open"){ 
				var currentType = ABCGateObjects[i].status.charAt(0);
				for (var j = 0; j < ABCSwitchObjects.length; j++){
					if (ABCSwitchObjects[j].status == currentType){
						canLockGate = false; 
					};
				};									
				
				if (GameplayLogic.CharacterMode == 1){
					// if char1 moving, don't want to squish roombella
					if (!forClone){
						if ((ABCGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
							ABCGateObjects[i].GridCoord.y == GameplayLogic.Character2GridCoord.y)){
								canLockGate = false;
							};
					} else {
						if ((ABCGateObjects[i].GridCoord.x == GameplayLogic.Character1GridCoord.x &&
							ABCGateObjects[i].GridCoord.y == GameplayLogic.Character1GridCoord.y) ||
							(ABCGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
							ABCGateObjects[i].GridCoord.y == GameplayLogic.Character2GridCoord.y)){
								canLockGate = false;
						};
					};
					
					/* these 2 below are a bit unituitive but want to make sure that the movement functionality matches what was in the game at launch.
					 at launch, if capy stepped from a gate to a switch, he wouldn't close the gate behind him, because the game
					 checked where he WAS (inside the gate), not where he was GOING (the switch)*/
					if ((forClone && (DLCTileLogic.Char1Clone.GridCoord.x == ABCGateObjects[i].GridCoord.x &&
						DLCTileLogic.Char1Clone.GridCoord.y == ABCGateObjects[i].GridCoord.y)) ||
						(!forClone && (GameplayLogic.Character1GridCoord.x == ABCGateObjects[i].GridCoord.x  &&
						GameplayLogic.Character1GridCoord.y == ABCGateObjects[i].GridCoord.y))){
							canLockGate = false;
					};						
				} else if (GameplayLogic.CharacterMode == 2){						
					// if char2 moving, don't want to squish capy
					if (!forClone){
						if ((ABCGateObjects[i].GridCoord.x == GameplayLogic.Character1GridCoord.x &&
							ABCGateObjects[i].GridCoord.y == GameplayLogic.Character1GridCoord.y)){
								canLockGate = false;
							};
					} else {
						if ((ABCGateObjects[i].GridCoord.x == GameplayLogic.Character1GridCoord.x &&
							ABCGateObjects[i].GridCoord.y == GameplayLogic.Character1GridCoord.y) ||
							(ABCGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
							ABCGateObjects[i].GridCoord.y == GameplayLogic.Character2GridCoord.y)){
								canLockGate = false;
						};
					};
					
					if (ABCGateObjects[i].cell.hitTest(DLCTileLogic.Char2Clone) &&
						((ABCGateObjects[i].GridCoord.x == DLCTileLogic.Char2Clone.GridCoord.x) ||
						(ABCGateObjects[i].GridCoord.y == DLCTileLogic.Char2Clone.GridCoord.y)) && 
						canLockGate && !forClone){
						AnimationController.SpawnDestroyAnimationOfSpecificCloneAtGridCoord(2, DLCTileLogic.Char2Clone.GridCoord.x, 
							DLCTileLogic.Char2Clone.GridCoord.y);
						DLCTileLogic.DestroyClone(2);
					};
				};
				
				if (canLockGate){
					ABCGateObjects[i].status = currentType + "_closed";
					LevelTiles[ABCGateObjects[i].GridCoord.y][ABCGateObjects[i].GridCoord.x] = 
						MapLayouts.Tiles["ABCGate_" + ABCGateObjects[i].status];	
					// don't love this being here but it's more efficient putting this here than doing a check afterwards
					
					// also hate this hittest check being here BUT this is to prevent a bug where a closing gate would squish a character
					// if it was set as their target BUT they're not actually touching it yet
					if ((ABCGateObjects[i].cell.hitTest(DLCTileLogic.Char2Clone)) || 
						(ABCGateObjects[i].cell.hitTest(DLCTileLogic.Char1Clone))){
						AnimationController.SpawnDestroyAnimationOfCloneAtGridCoord(ABCGateObjects[i].GridCoord.x, 
							ABCGateObjects[i].GridCoord.y);
						DLCTileLogic.DestroyClonesAtGridCoord({x: ABCGateObjects[i].GridCoord.x, 
							y: ABCGateObjects[i].GridCoord.y});						
					};
				};
			};	
		};
	};		
	
	/*
	 * Checks whether or not the gate at a given XY coordinate is open. 
	 * @param {Number} xCoord The X coordinate to search at.
	 * @param {Number} yCoord The Y coordinate to search at.
	 * @return {Bool} True if the gate at the coordinate is open, false if it's closed.
	 */ 
	public static function CheckGateAtCoordIsOpen(xCoord:Number, yCoord:Number):Boolean {
		for (var i = 0; i < ABCGateObjects.length; i++){
			if (ABCGateObjects[i].GridCoord.x == xCoord &&
				ABCGateObjects[i].GridCoord.y == yCoord){
				if (ABCGateObjects[i].status.indexOf("_open") == -1){
					return false;
				} else {
					return true;
				};
			};
		};
	};		
	
	/*
	 * Retrieves the next letter in the "ABC" sequence, looping back to A at C.
	 * @param {String} letter The letter to find the next character for.
	 * @return {String} The next letter in the sequence.
	 */ 
	public static function GetNextCharInABCSequence(letter:String):String {
		if (letter == "A"){
			return "B";
		} else if (letter == "B"){
			return "C";
		} else if (letter == "C"){
			return "A";
		};
	};
	
	/*
	 * Interprets a level that has been converted to a string, and returns a Map object.
	 * @param {String} levelToBuild The string to convert into a Map object.
	 * @return {Map} The Map object built from the string.
	 */ 
	public static function ReadLevelString(levelToBuild:String):Map {			
		var levelComponents:Array = levelToBuild.split("^");
		
		levelComponents[0] = Number(levelComponents[0]);
		levelComponents[1] = Number(levelComponents[1]);
		
		var substr1 = levelComponents[2].substring(1, levelComponents[2].length - 1);
		
		var levelDesignArray:Array = [];
		
		for (var i = 0; i < levelComponents[0]; i++){
			var tempArray = [];
			var stringToBreakDown = "";
			
			if (i == 0){ // first row, skipping opening bracket
				stringToBreakDown = levelComponents[2].slice(2, levelComponents[2].indexOf("]"));
			} else {					
				var indexOfStart:Number = i * ((levelComponents[0] * 2) + 1);
				var startingIndex = levelComponents[2].indexOf("[", indexOfStart);
				var tempSlice = levelComponents[2].slice(startingIndex + 1);
				stringToBreakDown = tempSlice.slice(0, levelComponents[2].indexOf("]") - 2);					
			};
			
			for (var char = 0; char < stringToBreakDown.length; char++){
				if (stringToBreakDown.charAt(char) != ","){
					if (!isNaN(Number(stringToBreakDown.charAt(char)))){
						tempArray.push(Number(stringToBreakDown.charAt(char)));
					} else {
						tempArray.push(stringToBreakDown.charAt(char));
					};
				};
			};
			levelDesignArray.push(tempArray);
		};
		
		levelComponents[2] = levelDesignArray;			
		levelComponents[3] = levelComponents[3].split(",");
		levelComponents[4] = levelComponents[4].split(",");
		
		var mapToBuild = new Map(levelComponents[0], levelComponents[1], levelComponents[2], levelComponents[3], 
			levelComponents[4], levelComponents[5],  levelComponents[6]);			
		return mapToBuild;		
	};
	
	/*
	 * Builds a level that has been parsed from a string by ReadLevelString.
	 * @param {levelComponents} A Map object, containing the components necessary to build the level.
	 */ 
	public static function BuildLevel(levelComponents:Map):Void {
		GameplayLogic.TimeLevelStarted = getTimer();
		GameplayLogic.CappyTouchedGoal = false;
		GameplayLogic.PlayerSwitchedCharacters = false;
		GameplayLogic.Dirt = [];
		GameplayLogic.MovesThisLevel = 0;
		GameplayLogic.Char1InGoal = false;
		GameplayLogic.CharacterMode = 1;
		SoundManager.playedABCGateUnlockThisTurn = false;
		SoundManager.playedABCCageLatchThisTurn = false;
		Key1Cell = null;
		Key1GridCoord = null;
		Gate1Cell = null;
		Gate1GridCoord = null;
		ABCSwitchObjects = [];
		ABCGateObjects = [];
		TimedGateObjects = [];
		ABCCageObjects = [];
		PortalObjects = [];
		ClonerObjects = [];
		AllCells = [];
		TileTypeToMoveTo = null;
		GameplayLogic.Character1IsMoving = false;
		GameplayLogic.Character2IsMoving = false;
		DLCTileLogic.Char1Clone = null;
		DLCTileLogic.Char2Clone = null;
		DLCTileLogic.Char1CloneCellToMoveTo = null;
		DLCTileLogic.Char1CloneIsMoving = false;
		DLCTileLogic.Char2CloneIsMoving = false;
		DLCTileLogic.Char2CloneLaunchGridCoord = null;
		DLCTileLogic.Char2CloneCellToMoveTo = null;
		DLCTileLogic.Char2CloneTileTypeToMoveTo = null;
		DLCTileLogic.Char2CloneBouncingBackToPrevCell = false;
		_mapWidth = levelComponents.MapWidth;
		_mapHeight = levelComponents.MapHeight;
		LevelTiles = levelComponents.LevelTiles;
		Character1SpawnGridCoord = {x: levelComponents.Character1Spawn[0], y: levelComponents.Character1Spawn[1]};
		Character2SpawnGridCoord = {x: levelComponents.Character2Spawn[0], y: levelComponents.Character2Spawn[1]};				
		CharacterDialogue = levelComponents.CharacterDialogue;			
		
		for (var i = 0; i < _mapHeight; i++) {
			var allCellsRow:Array = new Array();
			
			for (var j = 0; j < _mapWidth; j++) {
				var cell = _root['stageDrawingCanvas'].attachMovie('tile', 'tile' + i + "_" + j, _root['stageDrawingCanvas'].getNextHighestDepth());
				if (!isNaN(LevelTiles[i][j])){
					cell.gotoAndStop(LevelTiles[i][j] + 1);
				};
				cell._x = _tileSize * j;
				cell._y = _tileSize * i;
				allCellsRow.push(cell);
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.Dirt){
					var dirtObj = {};
					dirtObj.cell = cell;
					dirtObj.loc = {x: i, y: j};
					GameplayLogic.Dirt.push(dirtObj);
					AnimationController.RotateMCAtRandomRightAngle(cell.dirt);
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.Goal){
					GoalCell = cell;
					GoalGridCoord = {x: j, y: i};
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.Key1){
					Key1Cell = cell;
					Key1GridCoord = {x: j, y: i};
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.Gate1){
					Gate1Cell = cell;
					Gate1GridCoord = {x: j, y: i};
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_A ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_B ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_C){
					var ABCObj = {};
					ABCObj.GridCoord = {x: j, y: i};
					
					if (LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_A){
						ABCObj.status = "A";							
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_B){
						ABCObj.status = "B";
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_C){
						ABCObj.status = "C";
					};
					ABCObj.cell = cell;
					ABCSwitchObjects.push(ABCObj);
					
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_A_open ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_B_open ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_C_open ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_A_closed ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_B_closed ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_C_closed){
					var ABCGateObj = {};
					ABCGateObj.GridCoord = {x: j, y: i};
					
					if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_A_open){
						ABCGateObj.status = "A_open";
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_B_open){
						ABCGateObj.status = "B_open";
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_C_open){
						ABCGateObj.status = "C_open";
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_A_closed){
						ABCGateObj.status = "A_closed";
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_B_closed){
						ABCGateObj.status = "B_closed";
					} else if (LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_C_closed){
						ABCGateObj.status = "C_closed";
					};
					
					ABCGateObj.cell = cell;
					ABCGateObjects.push(ABCGateObj);
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.Timer9 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer8 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer7 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer6 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer5 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer4 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer3 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer2 ||
					LevelTiles[i][j] == MapLayouts.Tiles.Timer1 ||
					LevelTiles[i][j] == MapLayouts.Tiles.TimerOpen){	
						var timedGateObj = {};
						timedGateObj.cell = cell;
						if (LevelTiles[i][j] != MapLayouts.Tiles.TimerOpen){
							timedGateObj.originalStatus = LevelTiles[i][j];
						} else {
							timedGateObj.originalStatus = MapLayouts.Tiles.Timer9;
						};
						
						timedGateObj.status = LevelTiles[i][j];
						timedGateObj.GridCoord = {x: j, y: i};
						TimedGateObjects.push(timedGateObj);						
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_A_open ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_B_open ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_C_open ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_A_closed ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_B_closed ||
					LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_C_closed){
						var ABCCageObj = {};
						ABCCageObj.GridCoord = {x: j, y: i};
						
						switch(LevelTiles[i][j]){
							case MapLayouts.Tiles.ABCCage_A_open:
								ABCCageObj.status = "A_open";
								break;
							case MapLayouts.Tiles.ABCCage_B_open:
								ABCCageObj.status = "B_open";
								break;
							case MapLayouts.Tiles.ABCCage_C_open:
								ABCCageObj.status = "C_open";
								break;
							case MapLayouts.Tiles.ABCCage_A_closed:
								ABCCageObj.status = "A_closed";
								break;
							case MapLayouts.Tiles.ABCCage_B_closed:
								ABCCageObj.status = "B_closed";
								break;
							case MapLayouts.Tiles.ABCCage_C_closed:
								ABCCageObj.status = "C_closed";
								break;
						};
						
						ABCCageObj.cell = cell;
						ABCCageObjects.push(ABCCageObj);
					};
				
				// continue w cloner, etc etc etc
				if (LevelTiles[i][j] == MapLayouts.Tiles.Portal_A ||	
					LevelTiles[i][j] == MapLayouts.Tiles.Portal_B ||	
					LevelTiles[i][j] == MapLayouts.Tiles.Portal_C){
					var PortalObj = {};
					PortalObj.GridCoord = {x: j, y: i};
					PortalObj.cell = cell;
					switch(LevelTiles[i][j]){
						case MapLayouts.Tiles.Portal_A:
							PortalObj.status = "A";
							break;
						case MapLayouts.Tiles.Portal_B:
							PortalObj.status = "B";
							break;
						case MapLayouts.Tiles.Portal_C:
							PortalObj.status = "C";
							break;
					};
					
					PortalObjects.push(PortalObj);
				};
				
				if (LevelTiles[i][j] == MapLayouts.Tiles.Cloner){
					var clonerObj = {};
					clonerObj.GridCoord = {x: j, y: i};
					clonerObj.cell = cell;
					ClonerObjects.push(clonerObj);
				};
				
				cell.gotoAndStop(AnimationController.GetTileFrameFromType(LevelTiles[i][j]));
			};
			
			AllCells.push(allCellsRow);			
		};
		
		_spawnCharacter(1, Character1SpawnGridCoord);
		_spawnCharacter(2, Character2SpawnGridCoord);
		AnimationController.CharacterCursor = null;
		_root.lvlNameTxtBox.text = levelComponents.LevelTitle;
	};
	
	/*
	 * Spawns the given character in the grid XY coordinate given in gridCoord.
	 * @param {Number} characterNo Character 1 or 2.
	 * @param {Object} gridCoord An object with XY coordinates, showing where to spawn the character on the grid.
	 */ 
	private static function _spawnCharacter(characterNo:Number, gridCoord:Object):Void {			
		var character;
		if (characterNo == 1){
			character = _root['stageDrawingCanvas'].attachMovie('hero', 'hero', _root['stageDrawingCanvas'].getNextHighestDepth());				
			GameplayLogic.Character1 = character;
			GameplayLogic.Character1GridCoord = {x: Number(gridCoord.x), y: Number(gridCoord.y)};
		} else if (characterNo == 2){				
			character = _root['stageDrawingCanvas'].attachMovie('hero2', 'hero2', _root['stageDrawingCanvas'].getNextHighestDepth());
			GameplayLogic.Character2 = character;
			GameplayLogic.Character2GridCoord = {x: Number(gridCoord.x), y: Number(gridCoord.y)};
		};
		
		character.gotoAndStop(4);
		character._x = gridCoord.x * _tileSize;
		character._y = gridCoord.y * _tileSize;	
	};
	
	/*
	 * Clears the map's Movie Clips from the scene.
	 */ 
	public static function ClearCurrentMap():Void {
		for (var i = 0; i < AllCells.length; i++){
			for (var j = 0; j < AllCells[i].length; j++){
				AllCells[i][j].removeMovieClip();
			};
		};
		
		GameplayLogic.Character1.removeMovieClip();
		GameplayLogic.Character2.removeMovieClip();		
		if (DLCTileLogic.Char1Clone != null){
			DLCTileLogic.Char1Clone.removeMovieClip();
		};
		
		if (DLCTileLogic.Char2Clone != null){
			DLCTileLogic.Char2Clone.removeMovieClip();
		};
		AnimationController.CharacterCursor.removeMovieClip();
		for (var i = 0; i < AnimationController.ABCCages.length; i++){
			AnimationController.ABCCages[i].MC.removeMovieClip();
		};
		AnimationController.ABCCages = null;			
	};
	
	/*
	 * Handles visual and gameplay changes when a user unlocks a gate with a key. Unlocks all gates corresponding to a given key.
	 * @param {Number} gateToClear The gate number to clear. 
	 */ 
	public static function UnlockGate(gateToClear:Number):Void {
		var gateFrameNo:Number = 0;
		if (gateToClear == 1){
			gateFrameNo = 6;
			Key1Cell.gotoAndStop(1);
		};
		
		if (!SoundManager.playedABCGateUnlockThisTurn){
			SoundManager.PlaySound(SoundManager.SoundLibraryEnum.UnlockGate);
			SoundManager.playedABCGateUnlockThisTurn = true;
		};
		AnimationController.UnlockGateVisuals();			
	};
	
	/*
	 * Takes a Map with a level's properties (i.e. from MapLayouts.as) and converts it to a string that represents
	   the map. This string can then be read by ReadLevelString to convert it to a Map object. Maps are stored as strings
	   for the purpose of sharing user's custom levels via the Newgrounds API.
	 * @param {Map} levelProps An object containing the level's properties. MapLayouts.as provides examples.
	 * @return {String} The level string, containing data from levelProps.
	 */ 
	public static function ConvertLevelPropertiesToString(levelProps:Map):String {
		var levelString:String = "";
		levelString += String(levelProps.MapWidth) + "^";
		levelString += String(levelProps.MapHeight) + "^";
		
		var arrayString:String = "[";
		var levelTilesArray = levelProps.LevelTiles;
		
		for (var i = 0; i < levelTilesArray.length; i++){
			var arrayToAppend:String = "["

			for (var j = 0; j < levelTilesArray[i].length; j++){
				arrayToAppend += levelTilesArray[i][j];
				if (j != (levelTilesArray[i].length - 1)){
					arrayToAppend += ",";
				};
			};

			arrayToAppend += "]"
			if (i != (levelTilesArray.length - 1)){
				arrayToAppend += ",";
			};
			arrayString += arrayToAppend;
		};
		arrayString += "]";
		
		levelString += arrayString + "^";
		levelString += levelProps.Character1Spawn.x + "," + levelProps.Character1Spawn.y + "^";
		levelString += levelProps.Character2Spawn.x + "," + levelProps.Character2Spawn.y + "^";
		levelString += levelProps.CharacterDialogue + "^";
		
		levelString += levelProps.LevelTitle;
		return levelString;					
	};
	
	/*
	 * Begins the process of transitioning from one Campaign map to the next. Includes level cleanup, initialization for the next
	   level, and inter-scene dialogue functionality.
	 * @param {Boolean} forDLC Whether or not the DLC is active.
	 */ 
	public static function NextCampaignLvl():Void {
		var forDLC:Boolean = false;
		if (GameplayLogic.ActiveCampaign == 1){
			forDLC = true;
		};
		
		UI.PreventInput = true;	
		UI.EnableCampaignGameplayButtons(false);
		if (GameplayLogic.Dirt.length == 0){
			if (forDLC){
				DLCLevelLogic.DLCDirtCleaned = DLCLevelLogic.DLCDirtCleaned.substr(0, DLCLevelLogic.CurrentDLCCampaignLvlNum) + "T" + 
					DLCLevelLogic.DLCDirtCleaned.substr(DLCLevelLogic.CurrentDLCCampaignLvlNum + 1);	
			} else {
				DirtCleaned = DirtCleaned.substr(0, MapLogic.CurrentCampaignLvlNum) + "T" + 
					DirtCleaned.substr(MapLogic.CurrentCampaignLvlNum + 1);	
			};
		};
		
		if (forDLC){
			if (DLCLevelLogic.MovesInAllDLCLevels[DLCLevelLogic.CurrentDLCCampaignLvlNum] == 0 ||
				DLCLevelLogic.MovesInAllDLCLevels[DLCLevelLogic.CurrentDLCCampaignLvlNum] > GameplayLogic.MovesThisLevel){
					DLCLevelLogic.MovesInAllDLCLevels[DLCLevelLogic.CurrentDLCCampaignLvlNum] = GameplayLogic.MovesThisLevel;
			};
		} else {
			if (MovesInAllLevels[MapLogic.CurrentCampaignLvlNum] == 0 ||
				MovesInAllLevels[MapLogic.CurrentCampaignLvlNum] > GameplayLogic.MovesThisLevel){
					MovesInAllLevels[MapLogic.CurrentCampaignLvlNum] = GameplayLogic.MovesThisLevel;
			};
		};
		// could probably stand to clean this up!
		
		var currentLevelNumRef = CurrentCampaignLvlNum;
		var currentCampaignLenRef = MapLayouts.Campaign.length;
		var furthestLevelReachedRef = FurthestLevelReached;
		var ClassicCampaignIncrement = 1;
		var DLCCampaignIncrement = 0;
		
		if (forDLC){
			currentLevelNumRef = DLCLevelLogic.CurrentDLCCampaignLvlNum;
			currentCampaignLenRef = MapLayouts.DLCCampaign.length;
			furthestLevelReachedRef = DLCLevelLogic.FurthestDLCLevelReached;
			ClassicCampaignIncrement = 0;
			DLCCampaignIncrement = 1;
		};
		
		if (currentLevelNumRef + 1 < currentCampaignLenRef){ // accounting for 0 indexing
			if (currentLevelNumRef + 1 > furthestLevelReachedRef){
				NGAPI.OverwriteCampaignSave(CurrentCampaignLvlNum + ClassicCampaignIncrement, 
					DirtCleaned, MovesInAllLevels, DLCLevelLogic.CurrentDLCCampaignLvlNum + DLCCampaignIncrement,
					DLCLevelLogic.DLCDirtCleaned, DLCLevelLogic.MovesInAllDLCLevels);
				if (forDLC){
					DLCLevelLogic.FurthestDLCLevelReached = DLCLevelLogic.CurrentDLCCampaignLvlNum + 1;
				} else {
					FurthestLevelReached = CurrentCampaignLvlNum + 1;
				};			
			} else {
				// ie. scenario where player did not advance in campaign (i.e. furthest they went is lvl 5 but they just beat & fully cleaned lvl 2,
				// their progress on the dirt cleaning should still be saved
				ClassicCampaignIncrement = 0;
				DLCCampaignIncrement = 0;
				
				NGAPI.OverwriteCampaignSave(CurrentCampaignLvlNum + ClassicCampaignIncrement, 
					DirtCleaned, MovesInAllLevels, DLCLevelLogic.CurrentDLCCampaignLvlNum + DLCCampaignIncrement,
					DLCLevelLogic.DLCDirtCleaned, DLCLevelLogic.MovesInAllDLCLevels);
			};
		} else if (currentLevelNumRef + 1 == currentCampaignLenRef){
			// reached end of campaign!
			ClassicCampaignIncrement = 0;
			DLCCampaignIncrement = 0;
				
				NGAPI.OverwriteCampaignSave(CurrentCampaignLvlNum + ClassicCampaignIncrement, 
					DirtCleaned, MovesInAllLevels, DLCLevelLogic.CurrentDLCCampaignLvlNum + DLCCampaignIncrement,
					DLCLevelLogic.DLCDirtCleaned, DLCLevelLogic.MovesInAllDLCLevels);
		};		
		
		if (CheckMovesInAllLevelsCompleted(forDLC)){
			NGAPI.PostMovesInAllLevelsToScoreboard(forDLC);
		};		
		
		_root.campaignNextLvlBtn.removeMovieClip();
		TransitionLogic.NextLevelTransition();		
	};		
	
	/*
	 * Initializes the DirtCleaned variable. Appends to the existing DirtCleaned variable if there is one.
	 */ 
	public static function InitDirtTracking():Void {
		for (var i = 0; i < MapLayouts.Campaign.length; i++){
			if (DirtCleaned == null){
				DirtCleaned = "F";
			} else {
				DirtCleaned = DirtCleaned + "F";
			};
		};
	};		
	
	/*
	 * Checks each character in the DirtCleaned string. If a single level has not been fully cleaned, returns false.
	   otherwise, returns true.
	 * @param {Boolean} forDLC Whether or not this is checking for the DLC levels.
	 * @return {Boolean} True if all levels have been cleaned, false otherwise.
	 */ 
	public static function CheckDirtTrackingForAllCleaned(forDLC:Boolean):Boolean {
		var dirtString = DirtCleaned;
		if (forDLC){
			dirtString = DLCLevelLogic.DLCDirtCleaned;
		};
		
		for (var i = 0; i < dirtString.length; i++){
			if (dirtString.charAt(i) == "F"){
				return false;
			};
		};
		return true;
	};
	
	/*
	 * Initializes the MovesInAllLevels variable. Appends to the existing MovesInAllLevels variable if there is one.
	 */ 
	public static function InitMovesInAllLevels():Void {
		if (MovesInAllLevels == null){
			MovesInAllLevels = [];
		};
		
		for (var i = 0; i < MapLayouts.Campaign.length; i++){
			MovesInAllLevels.push(0);
		};
	};
	
	// Checks if all levels have a valid move # in them 
	public static function CheckMovesInAllLevelsCompleted(forDLC:Boolean):Boolean {
		var levelCount = MapLayouts.Campaign.length;
		var movesInLevels = MovesInAllLevels;
		if (forDLC){
			levelCount = MapLayouts.DLCCampaign.length;
			movesInLevels = DLCLevelLogic.MovesInAllDLCLevels;
		};
		
		if (movesInLevels.length == levelCount){
			var canSubmit = true;
			for (var i = 0; i < movesInLevels.length; i++){
				if (movesInLevels[i] == 0 || movesInLevels[i] == undefined || movesInLevels[i] == null){
					canSubmit = false;
				};
			};
			if (canSubmit){
				return true;
			};
		};
		return false;			
	};
};