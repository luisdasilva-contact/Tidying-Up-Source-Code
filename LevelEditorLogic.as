import flash.display.BitmapData;
import flash.events.Event;

class LevelEditorLogic {
	private static var _activeTileNo;
	public static var tileSetIndex:Number = 0;
	private static var _activeTileGhost;
	private static var _allNonDefaultCellsPlaced = [];
	private static var _nonDefaultCellPropsBeforeDrag = null;
	private static var _tempGhostCell = null;
	public static var CurrentLevelBeingTestedString:String = null;
	public static var LevelEditingStage;		
	public static var SingularElementBeingDragged;
	public static var CellPosOfDragged;		
	public static var UserWrittenDialogueLineObjects:Array = [];
	public static var ActiveCustomDialogueEmotion = "¶";
	public static var TitleMaxChars:Number = 12;
	public static var LoadedLevelMadeByUser:Boolean = false;
	public static var MapScreenshot:BitmapData ; // storing here so the icon attached to the NG API submission is the level at its start, NOT after the user finishes testing it
	public static var MapDescription:String = "This is the best level I've ever made. My mom says she's so proud of me.";
			
	/*
	 * Manages actions that need to be executed before a level can be previewed.
	 * @return {String} A string representation of the level.
	 */ 
	public static function GetCurrentLevelForPreview():String {
		var mapToTest:Map = new Map(MapLogic.MapWidth, MapLogic.MapHeight, MapLogic.LevelTiles, 
								MapLogic.Character1SpawnGridCoord, MapLogic.Character2SpawnGridCoord, 
								LevelEditorDialogueToString(), _root.lvlEditorLvlTitle.text);						
								
		var bitmapData:BitmapData = new BitmapData(_root.stageDrawingCanvas._width, _root.stageDrawingCanvas._height, false, 0xFFFFFF);
		bitmapData.draw(_root.stageDrawingCanvas);
		MapScreenshot = bitmapData;
		return MapLogic.ConvertLevelPropertiesToString(mapToTest);
	};
	
	/*
	 * Initiates items and logic for the level editor.
	 */ 
	public static function InitLevelEditor():Void {
		var editorMap;
		
		if (CurrentLevelBeingTestedString == null){
			editorMap = MapLogic.ConvertLevelPropertiesToString(MapLayouts.EditorBaseMap);
		} else {
			editorMap = CurrentLevelBeingTestedString;
		};
		
		_activeTileGhost = null;
		_allNonDefaultCellsPlaced = [];
		
		var editorBaseMap = MapLogic.ReadLevelString(editorMap);
		MapLogic.BuildLevel(editorBaseMap);
		
		for (var i = 0; i < MapLogic.LevelTiles.length; i++){
			for (var j = 0; j < MapLogic.LevelTiles[i].length; j++){
				if (MapLogic.LevelTiles[i][j] != 0){
					_allNonDefaultCellsPlaced.push(MapLogic.AllCells[i][j]);
				}
			};
		};
		
		_root.lvlEditorLvlTitle.text = editorBaseMap.LevelTitle;
		if ((LoadedLevelMadeByUser) && (NGAPI.LoadedLevelAuthorId == NGAPI.CurrentPlayerId) &&
			(MapLogic.CharacterDialogue.length != 0 && UserWrittenDialogueLineObjects.length == 0)){ // basically want to make sure new userwrittenlineobjs only writtne once
			DialogueManager.InitiateDialogueArray(MapLogic.CharacterDialogue); // disasterous, 99% sure no good will come of this
			DialogueManager.InitDialogueLineObjectsFromLoadedCustomLevel();
			UserWrittenDialogueLineObjects.length;
		}
	};
	
	/*
	 * Clears out level editor properties. 
	 */ 
	public static function ClearLevelEditorProperties():Void {
		if (_activeTileGhost){
			_activeTileGhost._alpha = 0; //compensating for Ruffle bug where removeMovieClip
			// won't always fire
			_activeTileGhost.removeMovieClip();
			_activeTileGhost = null;
			_activeTileNo = null;
			tileSetIndex = 0;
			// move tiles back into place here
		};
		
		if (_root.tileHolster){
			_root.tileHolster._alpha = 0;
			_root.tileHolster.removeMovieClip();
		};
		
		LoadedLevelMadeByUser = false;
		NGAPI.LoadedLevelAuthorId = null;
		CurrentLevelBeingTestedString = null;
		_nonDefaultCellPropsBeforeDrag = null;
		_allNonDefaultCellsPlaced = [];
		UserWrittenDialogueLineObjects = [];
	};
	
	/*
	 * Converts the user-entered dialogue into a string that can be interpreted by the game's map-building logic.
	 * @return {String} The string interpretation of user-entered dialogue.
	 */ 
	public static function LevelEditorDialogueToString():String {
		var stringToReturn = "";		
			var curEmotion = 0;
			for (var i = 0; i < UserWrittenDialogueLineObjects.length; i++){
				if (UserWrittenDialogueLineObjects[i].activeEmotion != curEmotion){
					stringToReturn += UserWrittenDialogueLineObjects[i].activeEmotion;
				} else {
					stringToReturn += DialogueManager.InCharacterLineBreakDelimiter;
				};
				
				stringToReturn += UserWrittenDialogueLineObjects[i].line;
			};
		return stringToReturn;
	};
	
	/*
	 * Manages functionality to let the user preview the level they're currently building.
	 * @param {String} currentLevelBeingTested String representation of the level to preview.
	 * @param {Boolean} skipValidation Whether or not to skip validation. 
	 */ 
	public static function PreviewLevel(currentLevelBeingTested, performValidation:Boolean) {
		var foundError:Boolean = false;
		var errorString:String = "Errors: \n";			
		
		if (performValidation){
			// validating level properties and tiles
			if (MapLogic.Key1GridCoord != null && MapLogic.Gate1GridCoord == null ||
				MapLogic.Key1GridCoord == null && MapLogic.Gate1GridCoord != null){
					errorString += "- Found key without gate or vice-versa, must have gate for key\n";
					foundError = true;
				};
			
			if (MapLogic.LevelTiles[MapLogic.Character1SpawnGridCoord.y][MapLogic.Character1SpawnGridCoord.x] != MapLayouts.Tiles.Default){
				errorString += "- Character 1 is on illegal tile; can only be spawned on default tiles\n";	
				foundError = true;
			};
			if (MapLogic.LevelTiles[MapLogic.Character2SpawnGridCoord.y][MapLogic.Character2SpawnGridCoord.x] != MapLayouts.Tiles.Default){
				errorString += "- Character 2 is on illegal tile; can only be spawned on default tiles\n";
				foundError = true;
			};
			
			if (MapLogic.Character1SpawnGridCoord.x == MapLogic.Character2SpawnGridCoord.x &&
				MapLogic.Character1SpawnGridCoord.y == MapLogic.Character2SpawnGridCoord.y){
					errorString += "- Characters cannot be spawned in same tile\n";
					foundError = true;
			};
			
			if (MapLogic.GoalGridCoord == null) {
				errorString += "- Cannot create level without a goal\n";
				foundError = true;
			};
			
			var containsABCSwitch:Boolean = false;
			var containsABCGate:Boolean = false;
			var containsABCCage:Boolean = false;
			for (var i = 0; i < MapLogic.LevelTiles.length; i++){
				if (containsABCSwitch && containsABCGate){
					break;				
				} else {
					for (var j = 0; j < MapLogic.LevelTiles[i].length; j++){
						if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_A ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_B ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCSwitch_C){
								containsABCSwitch = true;
						} else if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_A_open ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_B_open ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_C_open ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_A_closed ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_B_closed ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCGate_C_closed){
								containsABCGate = true;
						} else if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_A_open ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_B_open ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_C_open ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_A_closed ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_B_closed ||
							MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.ABCCage_C_closed){
								containsABCCage = true;
						};
					};
				};				
			};
			
			if (containsABCSwitch && (!containsABCGate && !containsABCCage) ||
				!containsABCSwitch && containsABCGate ||
				!containsABCSwitch && containsABCCage){
				errorString += "- Found ABC Switch without ABC Gate or ABC Cage, or vice-versa. Must have at least 1 ABC Switch or ABC Cage if an ABC Gate is present\n";
				foundError = true;
			};
			
			var portalAInstances:Number = 0;
			var portalBInstances:Number = 0;
			var portalCInstances:Number = 0;
			
			for (var i = 0; i < MapLogic.LevelTiles.length; i++){
				for (var j = 0; j < MapLogic.LevelTiles[i].length; j++){
					if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.Portal_A){
						portalAInstances++;
					} else if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.Portal_B){
						portalBInstances++;
					} else if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.Portal_C){
						portalCInstances++;
					};
				};				
			};
			
			if ((portalAInstances != 0 && portalAInstances != 2) ||
				(portalBInstances != 0 && portalBInstances != 2) ||
				(portalCInstances != 0 && portalCInstances != 2)){
				errorString += "- Cannot have 1 or 3+ instances of any portal type; if a portal is present, can only have 2 per type\n";
				foundError = true;
			};
			
			var clonerInstances:Number = 0;
			
			for (var i = 0; i < MapLogic.LevelTiles.length; i++){
				for (var j = 0; j < MapLogic.LevelTiles[i].length; j++){
					if (MapLogic.LevelTiles[i][j] == MapLayouts.Tiles.Cloner){
						clonerInstances++;
					};
				};				
			};
			
			if (clonerInstances > 1){
				errorString += "- Cannot have more than 1 instance of a cloner type\n";
				foundError = true;
			};
			
			if (foundError){
				_root['messagesTextbox'].text = errorString;
				_root.fileLoadTestText.text = "Found this error: " + errorString;
				return;
			};
		};
		
		CurrentLevelBeingTestedString = currentLevelBeingTested;
		
		if (_activeTileGhost != null){
			_activeTileGhost.removeMovieClip();
		};			
		
		_activeTileGhost = null;
		_activeTileNo = null;
		tileSetIndex = 0;
		
		MapLogic.ClearCurrentMap();	
		_root.gotoAndStop(FrameNavigation.LevelEditorPreview);
		Controls.ReloadKeyListener();			
		MapLogic.BuildLevel(MapLogic.ReadLevelString(currentLevelBeingTested));	
		_root.onEnterFrame = GameplayLogic.MainGameplayLoop;
	};
	
	/*
	 * Manages frame-by-frame logic in the Level Editor.
	 */ 
	public static function MainLevelEditorLoop():Void {
		/* need this because the characters are children of the stageDrawingCanvas, and cannot have their
		   useHandCursor status flipped on/off independent of the stageDrawingCanvas. */
		if (_root['stageDrawingCanvas'].hitTest(_root._xmouse, _root._ymouse)){
			var showForCollidingArray = [];
			for (var i = 0; i < _allNonDefaultCellsPlaced.length; i++){				
				showForCollidingArray.push(_allNonDefaultCellsPlaced[i]);
			};
			
			showForCollidingArray.push(GameplayLogic.Character1);
			showForCollidingArray.push(GameplayLogic.Character2);
			
			Utilities.ShowMouseIfColliding(showForCollidingArray, _root['stageDrawingCanvas']);
		} else {
			// for releasing/letting go of items once the mouse goes off of the stage canvas				
			if (SingularElementBeingDragged){
				ClearDraggingVars();
			};
		};
		
		// Logic for  dragging obj behavior
		if (SingularElementBeingDragged != null){
			Controls.MousePos = TileMousePosIsIn({x: _root._xmouse, y: _root._ymouse});
			if (CellPosOfDragged == null){		
				CellPosOfDragged = Controls.MousePos;
				
				if (_nonDefaultCellPropsBeforeDrag == null && SingularElementBeingDragged._name != "hero" 
					&& SingularElementBeingDragged._name != "hero2" ){								
					_nonDefaultCellPropsBeforeDrag = {};
					_nonDefaultCellPropsBeforeDrag.x = Controls.MousePos.x;
					_nonDefaultCellPropsBeforeDrag.y = Controls.MousePos.y;
					_nonDefaultCellPropsBeforeDrag.type = MapLogic.LevelTiles[Controls.MousePos.y][Controls.MousePos.x];
					_nonDefaultCellPropsBeforeDrag.name = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._name;
					
					_tempGhostCell = _root['stageDrawingCanvas'].attachMovie('tile', 'tileTemp', 
						_root['stageDrawingCanvas'].getNextHighestDepth());
						
					SingularElementBeingDragged.swapDepths(_root['stageDrawingCanvas'].getNextHighestDepth()); 
					_tempGhostCell.gotoAndStop(SingularElementBeingDragged._currentframe);
					_tempGhostCell._alpha = 50;
					_tempGhostCell._x = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._x;
					_tempGhostCell._y = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._y;
				};					
			};				
			
			if (((Controls.MousePos.x != CellPosOfDragged.x) || (Controls.MousePos.y != CellPosOfDragged.y)) &&
				Controls.MousePos.x != 0 && Controls.MousePos.x != (MapLogic.MapWidth - 1) &&
				Controls.MousePos.y != 0 && Controls.MousePos.y != (MapLogic.MapHeight - 1)) {						
				// more validation!
				if (MapLogic.LevelTiles[Controls.MousePos.y][Controls.MousePos.x] != 0){
					if (SingularElementBeingDragged._name != "hero" &&
						SingularElementBeingDragged._name != "hero2" &&
						_nonDefaultCellPropsBeforeDrag != null){
						return;
					};
				} else if ((SingularElementBeingDragged._name != "hero" &&
						SingularElementBeingDragged._name != "hero2") && 
						MapLogic.LevelTiles[Controls.MousePos.y][Controls.MousePos.x] == 0 &&
					(Controls.MousePos.x == MapLogic.Character1SpawnGridCoord.x &&
					Controls.MousePos.y == MapLogic.Character1SpawnGridCoord.y) ||
					(Controls.MousePos.x == MapLogic.Character2SpawnGridCoord.x &&
					Controls.MousePos.y == MapLogic.Character2SpawnGridCoord.y)){
					return;
				};
				
				SingularElementBeingDragged._x = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._x;
				SingularElementBeingDragged._y = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._y;
			};		
		};	
	};
	
	/*
	 * For a given mouse position, determines which cell the mouse is in.
	 * @param {Object} mousePos Object containing the mouse's XY coordinates. 
	 * @return {Object} A Grid Coord object containing data on which tile the mouse is in.
	 */
	public static function TileMousePosIsIn(mousePos:Object):Object {
		var horizontalCell:Number = 1;
		var verticalCell:Number = 1;
		
		if (mousePos.x !== 0){ // if x was 0, don't want to perform any division calcs
			var horizontalCanvasWidthInPixels = _root['stageDrawingCanvas']._width;
			var horizontalPos = horizontalCanvasWidthInPixels / (mousePos.x - _root['stageDrawingCanvas']._x);
			horizontalCell = Math.floor(MapLogic.MapWidth / horizontalPos);
		};
		
		if (mousePos.y !== 0){ // if y was 0, don't want to perform any division calcs
			var verticalCanvasHeightInPixels = _root['stageDrawingCanvas']._height;
			var verticalPos = verticalCanvasHeightInPixels / (mousePos.y - _root['stageDrawingCanvas']._y);
			verticalCell = Math.floor(MapLogic.MapHeight / verticalPos);				
		};
		
		return {x: horizontalCell, y: verticalCell};			
	};
	
	/*
	 * Executes functionality related to clicking on the level drawing canvas.
	 */ 
	public static function ClickDrawingCanvas():Void {
		if (!UI.PreventInput){
			if (GameplayLogic.Character1.hitTest(_root._xmouse, _root._ymouse)){
				SingularElementBeingDragged = GameplayLogic.Character1;
				return;
			} else if (GameplayLogic.Character2.hitTest(_root._xmouse, _root._ymouse)){
				SingularElementBeingDragged = GameplayLogic.Character2;
				return;
			}; 
			if (_activeTileNo != null && ((AnimationController.GetTileFrameFromType(TypeOfCellClicked()) - 1) != _activeTileNo)){
				_setActiveTileOnStage();
			} else {					
				var nonDefaultCheck =  NonDefaultTileBeingDragged();
				
				if (nonDefaultCheck != null) {
					SingularElementBeingDragged = nonDefaultCheck;	
					SingularElementBeingDragged.swapDepths(_root.getNextHighestDepth());
					
				};
			};
		};
	};
	
	/*
	 * Checks if the user is attempting to drag a non-default tile (i.e. a dirt tile). 
	 * @return Returns the cell MovieClip if the user is attempting to drag the tile. Otherwise, returns null.
	 */ 
	public static function NonDefaultTileBeingDragged(){
		for (var tileIndex = 0; tileIndex < _allNonDefaultCellsPlaced.length; tileIndex++){
			
			if (_allNonDefaultCellsPlaced[tileIndex].hitTest(_root._xmouse, _root._ymouse)){
				
				var mouseTiles = TileMousePosIsIn({x: _root._xmouse, y: _root._ymouse});
				var horizontalCell:Number = mouseTiles.x;
				var verticalCell:Number = mouseTiles.y;
				
				// making sure you can't drag the tiles on the edges 
				if (!(verticalCell == 0) && !(verticalCell == MapLogic.MapWidth-1) && 
					!(horizontalCell == 0) && !(horizontalCell == MapLogic.MapHeight - 1) &&
					MapLogic.LevelTiles[verticalCell][horizontalCell] != MapLayouts.Tiles.Default){
						// V brand new, dont like this being here 
						MapLogic.AllCells[verticalCell][horizontalCell].gotoAndStop(_allNonDefaultCellsPlaced[tileIndex]._currentframe);
					 return MapLogic.AllCells[verticalCell][horizontalCell];									
					
				};
			};								
		};
		return null;
	};
	
	/*
	 * Returns the type of cell that has been clicked. Results will be one of the types in MapLayouts.Tiles.
	   i.e. if it's a blank tile, "0" will be returned.
	 */ 
	public static function TypeOfCellClicked(){			
		var mouseTiles = TileMousePosIsIn({x: _root._xmouse, y: _root._ymouse});
		var horizontalCell:Number = mouseTiles.x;
		var verticalCell:Number = mouseTiles.y;			
		return MapLogic.LevelTiles[verticalCell][horizontalCell];
	};			
	
	/*
	 * Manages functionality that allows a user to place a tile on the stage in the Level Editor.
	 */ 
	private static function _setActiveTileOnStage():Void {
		if (_activeTileNo != null){
			var mouseTiles = TileMousePosIsIn({x: _root._xmouse, y: _root._ymouse});
			var horizontalCell:Number = mouseTiles.x;
			var verticalCell:Number = mouseTiles.y;
		
			if (!(verticalCell == 0) && !(verticalCell == MapLogic.MapWidth-1) && 
				!(horizontalCell == 0) && !(horizontalCell == MapLogic.MapHeight-1)){
			
				var cellToChange = MapLogic.AllCells[verticalCell][horizontalCell];	
				
				if (cellToChange._currentframe == MapLayouts.Tiles.Goal + 1){
					MapLogic.GoalGridCoord = null;
					MapLogic.GoalCell = null;
				} else if (cellToChange._currentframe == MapLayouts.Tiles.Key1 + 1){
					MapLogic.Key1GridCoord = null;
					MapLogic.Key1Cell = null;
				} else if (cellToChange._currentframe == MapLayouts.Tiles.Gate1 + 1){
					MapLogic.Gate1GridCoord = null;
					MapLogic.Gate1Cell = null;
				};
				
				if (_activeTileNo != 0 && MapLogic.LevelTiles[verticalCell][horizontalCell] == MapLayouts.Tiles.Default){						
					_allNonDefaultCellsPlaced.push(cellToChange);
				} else if (_activeTileNo == 0 && MapLogic.LevelTiles[verticalCell][horizontalCell] != MapLayouts.Tiles.Default){
					for (var i = 0; i < _allNonDefaultCellsPlaced.length; i++){
						if (_allNonDefaultCellsPlaced[i]._name == cellToChange._name){
							_allNonDefaultCellsPlaced.splice(i, 1);
						};
					};						
				}; 
				
				// ALSO need to account for overwriting a non-default with another non-default!
				// validation to make sure only 1 gate and 1 key can be placed, and can only place 1 goal	
				if (_activeTileNo == MapLayouts.Tiles.Key1){
					if (MapLogic.Key1Cell != null){	
						MapLogic.LevelTiles[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x] = MapLayouts.Tiles.Default;
						MapLogic.AllCells[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x].gotoAndStop(MapLayouts.Tiles.Default + 1);							
					};					
					
					MapLogic.Key1Cell = MapLogic.AllCells[verticalCell][horizontalCell];
					MapLogic.Key1GridCoord = {x: horizontalCell, y: verticalCell};
				} else if (_activeTileNo == MapLayouts.Tiles.Gate1){
					if (MapLogic.Gate1Cell != null){				
					MapLogic.LevelTiles[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x] = MapLayouts.Tiles.Default;
					MapLogic.AllCells[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x].gotoAndStop(MapLayouts.Tiles.Default + 1);
					};
					
					MapLogic.Gate1Cell = MapLogic.AllCells[verticalCell][horizontalCell];
					MapLogic.Gate1GridCoord = {x: horizontalCell, y: verticalCell};
				} else if (_activeTileNo == MapLayouts.Tiles.Goal){
					if (MapLogic.GoalCell != null){
						MapLogic.LevelTiles[MapLogic.GoalGridCoord.y][MapLogic.GoalGridCoord.x] = MapLayouts.Tiles.Default;
						MapLogic.AllCells[MapLogic.GoalGridCoord.y][MapLogic.GoalGridCoord.x].gotoAndStop(MapLayouts.Tiles.Default + 1);		
					};
					
					MapLogic.GoalCell = MapLogic.AllCells[verticalCell][horizontalCell];
					MapLogic.GoalGridCoord = {x: horizontalCell, y: verticalCell};
				};					
				
				cellToChange.gotoAndStop(_activeTileNo + 1); // +1 to account for 0 indexing
				MapLogic.LevelTiles[verticalCell][horizontalCell] = AnimationController.GetTypeFromTileFrame(cellToChange._currentframe);
				
			};
		};			
	};	
	
	/*
	 * Clears variables related to dragging items. Fired when the user releases over the stage canvas.
	 */ 
	public static function ClearDraggingVars():Void {			
		if (SingularElementBeingDragged){
			if (SingularElementBeingDragged._name != "hero" &&
			SingularElementBeingDragged._name != "hero2"){
				if (Controls.MousePos.x != 0 && Controls.MousePos.x != (MapLogic.MapWidth - 1) &&
				Controls.MousePos.y != 0 && Controls.MousePos.y != (MapLogic.MapHeight - 1) &&
				!(Controls.MousePos.x == MapLogic.Character1SpawnGridCoord.x &&
					Controls.MousePos.y == MapLogic.Character1SpawnGridCoord.y) && !(Controls.MousePos.x == MapLogic.Character2SpawnGridCoord.x &&
					Controls.MousePos.y == MapLogic.Character2SpawnGridCoord.y) && !(Controls.MousePos.x == _nonDefaultCellPropsBeforeDrag.x && 
						Controls.MousePos.y == _nonDefaultCellPropsBeforeDrag.y)){
					
					for (var i = 0; i < _allNonDefaultCellsPlaced.length; i++){
						if (_allNonDefaultCellsPlaced[i]._name == _nonDefaultCellPropsBeforeDrag.name ||
							_allNonDefaultCellsPlaced[i]._name == undefined){
							_allNonDefaultCellsPlaced.splice(i, 1);
							// null / undefined check needed to compensate for Flash quirk
						};
					};
					SingularElementBeingDragged._name = "tile" + Controls.MousePos.y + "_" + Controls.MousePos.x;
					_allNonDefaultCellsPlaced.push(MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]); 
					var frameNo = SingularElementBeingDragged._currentframe;
					_tempGhostCell._name = _nonDefaultCellPropsBeforeDrag.name;
					 MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x].gotoAndStop(frameNo);
					MapLogic.LevelTiles[Controls.MousePos.y][Controls.MousePos.x] = _nonDefaultCellPropsBeforeDrag.type;
					MapLogic.AllCells[_nonDefaultCellPropsBeforeDrag.y][_nonDefaultCellPropsBeforeDrag.x] = _tempGhostCell;
					MapLogic.LevelTiles[_nonDefaultCellPropsBeforeDrag.y][_nonDefaultCellPropsBeforeDrag.x] = 0;
					_tempGhostCell._alpha = 100;
					_tempGhostCell.gotoAndStop(1);
					SingularElementBeingDragged.removeMovieClip();
				} else {
					var newName = SingularElementBeingDragged._name;
					for (var i = 0; i < _allNonDefaultCellsPlaced.length; i++){
						if (_allNonDefaultCellsPlaced[i]._name == undefined){
							_allNonDefaultCellsPlaced.splice(i, 1);
							break;
						};
					};
					MapLogic.AllCells[_nonDefaultCellPropsBeforeDrag.y][_nonDefaultCellPropsBeforeDrag.x] = _tempGhostCell;
					_tempGhostCell._name = newName;
					_tempGhostCell._alpha = 100;
					SingularElementBeingDragged.removeMovieClip();
				}
			} else if (SingularElementBeingDragged._name == "hero" || SingularElementBeingDragged._name == "hero2"){					
				if (MapLogic.LevelTiles[Controls.MousePos.y][Controls.MousePos.x] == MapLayouts.Tiles.Default){
					SingularElementBeingDragged._x = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._x;
					SingularElementBeingDragged._y = MapLogic.AllCells[Controls.MousePos.y][Controls.MousePos.x]._y;
						switch(SingularElementBeingDragged._name){
							// placing chars
							case "hero":
								MapLogic.Character1SpawnGridCoord = {x: Controls.MousePos.x, y: Controls.MousePos.y}
								break;
							case "hero2":
								MapLogic.Character2SpawnGridCoord = {x: Controls.MousePos.x, y: Controls.MousePos.y}
								break;
							default:
								break;
						};
				} else {
					// returning to their original pos
					SingularElementBeingDragged._x = MapLogic.AllCells[CellPosOfDragged.y][CellPosOfDragged.x]._x;
					SingularElementBeingDragged._y = MapLogic.AllCells[CellPosOfDragged.y][CellPosOfDragged.x]._y;	
				};						
			};	
			
			SingularElementBeingDragged = null;
			CellPosOfDragged = null;
			_nonDefaultCellPropsBeforeDrag = null;
			_tempGhostCell = null;
			ClearActiveTileGhost();
		};
	};
	
	/*
	 * Handles functionality for switching the active tile.
	 * @param {Number} newActiveTile The value associated with the tile, represented by the index of the tile in Controls.TileTypes.
	 * @param {String} newDescription The description to show in the Level Editor's description box.
	 */ 
	public static function ChangeActiveTileAndDescription(newActiveTile:Number, newDescription:String){
		// readme - move to UI
		_activeTileNo = newActiveTile;
		_root.messagesTextbox.text = newDescription;
		
		if (_activeTileGhost == null){
			_activeTileGhost = _root.attachMovie('tile', 'tileGhost', _root.getNextHighestDepth());
			_activeTileGhost.gotoAndStop(_activeTileNo + 1);
		} else if (_activeTileGhost.currentFrame - 1 != _activeTileNo){
			_activeTileGhost.gotoAndStop(_activeTileNo + 1);
		};		
			
		_activeTileGhost._x = _root['tileHolster']._x;
		_activeTileGhost._width =  _root['tileHolster']._width * 0.95;
		_activeTileGhost._y = _root['tileHolster']._y;
		_activeTileGhost._height =  _root['tileHolster']._height * 0.95;	
		_activeTileGhost.swapDepths(1);
		_root['tileHolster'].swapDepths(_activeTileGhost);
	};
	
	public static function ClearActiveTileGhost(){
		if (_activeTileGhost != null){
			ChangeActiveTileAndDescription(null, 
				"No active tile. Feel free to drag around the tiles already on the map or select a new one from the right!");
			_activeTileGhost.swapDepths(1);
			_activeTileGhost.removeMovieClip();
			_activeTileGhost = null;				
		};	
	};
};		