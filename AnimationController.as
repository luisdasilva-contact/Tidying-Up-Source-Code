/*
 * Manages animation manipulation.
 */ 
class AnimationController {
	private static var _characterFacingDirectionFrames:Object = {up: 1, left: 2, right: 3, down: 4};	
	public static var RoombellaFrameHold:Number = 0;
	public static var CharacterCursor:MovieClip = null;
	public static var ABCCages:Array = null;
	
	/*
	 * Sets the facing direction for the character (i.e. left, right, etc.)
	 * @param {Number} keyCode The value representing the key the user pressed.
	 * @param {Number} character Which character to change the value of; Character1 is Capy, 
	   Character 2 is Roombella. 
	*/ 
	public static function SetCharacterFacingDirection(keyCode:Number, character:Number):Void {
		var direction = GetDirectionFromKeyCode(keyCode);
		
		if (character == 1){
			GameplayLogic.Character1.gotoAndStop(direction);
			
			if (DLCTileLogic.Char1Clone != null){
				DLCTileLogic.Char1Clone.gotoAndStop(direction);
			};
			
		} else if (character == 2){
			GameplayLogic.Character2.gotoAndStop(direction);
			
			if (DLCTileLogic.Char2Clone != null){
				DLCTileLogic.Char2Clone.gotoAndStop(direction);
			};
		};
	};
	
	/*
	 * For the keyCode, the value Flash uses to interpret key strokes, returns the corresponding
	   directional value from _characterFacingDirectionFrames.
	 * @param {Number} keyCode The numeric value Flash uses to represent a key press.
	 * @return {Number} The value from _characterFacingDirectionFrames that corresponds to the key stroke.
	*/ 
	public static function GetDirectionFromKeyCode(keyCode:Number):Number {
		switch(keyCode){
			case 37:
				return _characterFacingDirectionFrames.left;
			case 38:
				return _characterFacingDirectionFrames.up;
			case 39:
				return _characterFacingDirectionFrames.right;
			case 40:
				return _characterFacingDirectionFrames.down;
		};
	};	
	
	/*
	 * Uses the timer to hold Roombella's winking animation. The time to hold this until is stored as a number of milliseconds in RoombellaFrameHold,
	   and when the time has been passed, returns to Roombella's standard animation.
	*/ 
	public static function HoldRoombellaWink():Void {
		if (getTimer() >= RoombellaFrameHold){
			GameplayLogic.Character2.gotoAndStop(GameplayLogic.Character2._currentframe - 4);
			delete GameplayLogic.Character2.onEnterFrame;
		};
	};	
	
	/*
	 * Manages visuals and animation when a gate is unlocked. 
	*/
	public static function UnlockGateVisuals():Void {
		SpawnVisualEffect("Sparkle", MapLogic.AllCells[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x]._x + 
			MapLogic.AllCells[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x]._parent._x, 
			MapLogic.AllCells[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x]._y + 
			MapLogic.AllCells[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x]._parent._y);
		SpawnVisualEffect("Sparkle", MapLogic.AllCells[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x]._x + 
			MapLogic.AllCells[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x]._parent._x, 
			MapLogic.AllCells[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x]._y + 
			MapLogic.AllCells[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x]._parent._y);
		MapLogic.AllCells[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x].gotoAndStop(1);
		MapLogic.LevelTiles[MapLogic.Gate1GridCoord.y][MapLogic.Gate1GridCoord.x] = 0;
		MapLogic.AllCells[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x].gotoAndStop(1);
		MapLogic.LevelTiles[MapLogic.Key1GridCoord.y][MapLogic.Key1GridCoord.x] = 0;
	};
	
	/*
	 * Manages visuals and animation for when a character is teleported.
	 * @param {Number} The character which will have their teleportation animation play. 1 For Capy, 2 for Roombella.
	 * @param {MovieClip} entrancePortalCell The cell where the first teleporting animation will play.
	 * @param {MovieClip} exitPortalCell The cell where the second teleporting animation will play.
	*/ 
	public static function TeleportVisuals(character:Number, entrancePortalCell:MovieClip, exitPortalCell:MovieClip):Void {
		// take entrance portal and exit portal gridcoord as args, AS WELL as which character
		var characterTeleport:String = "CapyTeleport";
		if (character == 2){
			characterTeleport = "RoombellaTeleport";
		};
		
		SpawnVisualEffectAsChildOfParent(characterTeleport, entrancePortalCell._x, 
			entrancePortalCell._y, exitPortalCell._parent);
		SpawnVisualEffectAsChildOfParent(characterTeleport, exitPortalCell._x, 
			exitPortalCell._y, exitPortalCell._parent);
	};
	
		

	/*
	 * For every ABC Switch and Gate in the current level, updates their visual appearance to match their current status.
	*/ 
	public static function UpdateAllABCSwitchesAndGates():Void {
		for (var i = 0; i < MapLogic.ABCSwitchObjects.length; i++){
			MapLogic.ABCSwitchObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLogic.ABCSwitchObjects[i].status));
		};
		
		for (var i = 0; i < MapLogic.ABCGateObjects.length; i++){			
			if (MapLogic.ABCGateObjects[i].status == "A_open"){
				MapLogic.ABCGateObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCGate_A_open));
			} else if (MapLogic.ABCGateObjects[i].status == "B_open"){
				MapLogic.ABCGateObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCGate_B_open));
			} else if (MapLogic.ABCGateObjects[i].status == "C_open"){
				MapLogic.ABCGateObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCGate_C_open));
			} else if (MapLogic.ABCGateObjects[i].status == "A_closed"){
				MapLogic.ABCGateObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCGate_A_closed));
			}  else if (MapLogic.ABCGateObjects[i].status == "B_closed"){
				MapLogic.ABCGateObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCGate_B_closed));
			} else if (MapLogic.ABCGateObjects[i].status == "C_closed"){
				MapLogic.ABCGateObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCGate_C_closed));
			};
		};
	};
	
	/*
	 * Creates the visual when an ABC Cage is triggered.
	 * @param {String} gateType The type of gate that has been triggered, derived from MapLayouts.Tiles.
	 * @param {Number} gridXCoord The X coordinate on the game grid where the visual will be placed.
	 * @param {Number} gridYCoord The Y coordinate on the game grid where the visual will be placed.
	 * @param {Number} xLocation The X coordinate on the Stage where the visual will be placed.
	 * @param {Number} yLocation The Y coordinate on the Stage where the visual will be placed.
	*/ 
	public static function CreateABCCageVisual(gateType:String, gridXCoord:Number, gridYCoord:Number, xLocation:Number, yLocation:Number):Void{
		var ABCCageObject = {};
		var ABCCageVisualMC:MovieClip = _root['stageDrawingCanvas'].attachMovie("ABCCageArtOverlay", "ABCCageArtOverlayInstc", _root['stageDrawingCanvas'].getNextHighestDepth());
				
		switch (gateType){
			case MapLayouts.Tiles.ABCSwitch_A:
				ABCCageVisualMC.gotoAndStop(1);
				break;
			case MapLayouts.Tiles.ABCSwitch_B:
				ABCCageVisualMC.gotoAndStop(2);
				break;
			case MapLayouts.Tiles.ABCSwitch_C:
				ABCCageVisualMC.gotoAndStop(3);
				break;
		};
		
		ABCCageVisualMC._x = xLocation;
		ABCCageVisualMC._y = yLocation;
		ABCCageObject.x = gridXCoord;
		ABCCageObject.y = gridYCoord;
		ABCCageObject.MC = ABCCageVisualMC;
		
		if (ABCCages == null){
			ABCCages = new Array();
		};
		ABCCages.push(ABCCageObject);
	};
	
	/*
	 * For a given rid coordinate, if an ABC Cage visual exists there, destroys it.
	 * @param {Number} gridXCoord The X Grid coordinate of the ABC Cage visual that will be removed.
	 * @param {Number} gridYCoord The Y Grid coordinate of the ABC Cage visual that will be removed.
	*/ 
	public static function RemoveABCCageVisualAtGridCoord(gridXCoord:Number, gridYCoord:Number){
		for (var i = 0; i < ABCCages.length; i++){
			if (ABCCages[i].x == gridXCoord && ABCCages[i].y == gridYCoord){
				ABCCages[i].MC.removeMovieClip();
				ABCCages.splice(i, 1);
				return;
			};
		};
	};
	
	/*
	 * For every ABC Cage in the current level, update their visual appearance to match their current status.
	 */ 
	public static function UpdateAllABCCages():Void {
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){
			if (MapLogic.ABCCageObjects[i].status == "A_open"){
				MapLogic.ABCCageObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCCage_A_open));
			} else if (MapLogic.ABCCageObjects[i].status == "B_open"){
				MapLogic.ABCCageObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCCage_B_open));
			} else if (MapLogic.ABCCageObjects[i].status == "C_open"){
				MapLogic.ABCCageObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCCage_C_open));
			} else if (MapLogic.ABCCageObjects[i].status == "A_closed"){
				MapLogic.ABCCageObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCCage_A_closed));
			}  else if (MapLogic.ABCCageObjects[i].status == "B_closed"){
				MapLogic.ABCCageObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCCage_B_closed));
			} else if (MapLogic.ABCCageObjects[i].status == "C_closed"){
				MapLogic.ABCCageObjects[i].cell.gotoAndStop(GetTileFrameFromType(MapLayouts.Tiles.ABCCage_C_closed));
			};
		};
	};
	
	/*
	 * Spawns a visual effect at the given location, and destroys it immediately upon completion.
	 * @param {String} effectTitle The title of the effect in the Flash library.
	 * @param {Number} xLoc The X value of the Stage coordinates of where the effect will spawn.
	 * @param {Number} yLoc The Y value of the Stage coordinates of where the effect will spawn.
	 */ 
	public static function SpawnVisualEffect(effectTitle:String, xLocation:Number, yLocation:Number):Void {
		var effect = _root.attachMovie(effectTitle, effectTitle + "Instc", _root.getNextHighestDepth());
		effect._x = xLocation;
		effect._y = yLocation;
		
		effect.onEnterFrame = function(){
			if (effect._currentframe == effect._totalframes){
				Utilities.DeleteEnterFrameAndMC(effect);
			};
		};
	};
	
	/*
	 * Spawns the animation to destroy a given character if they exist at a grid point.
	 * @param {Number} character The character to spawn the "destroy clone" animation for.
	 * @param {Number} gridXCoord The X Grid coordinate to spawn the animation at.
	 * @param {Number} gridYCoord The Y Grid coordinate to spawn the animation at.
	 */ 
	public static function SpawnDestroyAnimationOfSpecificCloneAtGridCoord(character:Number, gridXCoord:Number, gridYCoord:Number):Void {
		if (character == 1){
			if (DLCTileLogic.Char1Clone != null){
				SpawnVisualEffectAsChildOfParent("CapyCloneAnimReversed", MapLogic.AllCells[gridYCoord][gridXCoord]._x, 
					MapLogic.AllCells[gridYCoord][gridXCoord]._y, MapLogic.AllCells[gridYCoord][gridXCoord]._parent);			
			};
		} else if (character == 2){
			if (DLCTileLogic.Char2Clone != null){
				SpawnVisualEffectAsChildOfParent("RoombellaCloneAnimReversed", MapLogic.AllCells[gridYCoord][gridXCoord]._x, 
					MapLogic.AllCells[gridYCoord][gridXCoord]._y, MapLogic.AllCells[gridYCoord][gridXCoord]._parent);			
			};
		};
	};
	
	/*
	 * If any clone exists at the given point, spawns the corresponding "destroy clone" animation.
	 * @param {Number} character The character to spawn the "destroy clone" animation for.
	 * @param {Number} gridXCoord The X Grid coordinate to spawn the animation at.
	 * @param {Number} gridYCoord The Y Grid coordinate to spawn the animation at.
	 */ 
	public static function SpawnDestroyAnimationOfCloneAtGridCoord(gridCoordX:Number, gridCoordY:Number):Void {
		if (DLCTileLogic.Char1Clone != null){
			if (DLCTileLogic.IsCloneAtGridCoord(1, gridCoordX, gridCoordY)){
				SpawnVisualEffectAsChildOfParent("CapyCloneAnimReversed", MapLogic.AllCells[gridCoordY][gridCoordX]._x, 
					MapLogic.AllCells[gridCoordY][gridCoordX]._y, MapLogic.AllCells[gridCoordY][gridCoordX]._parent);
			}
		}
		
		if (DLCTileLogic.Char2Clone != null){
			if (DLCTileLogic.IsCloneAtGridCoord(2, gridCoordX, gridCoordY)){
				SpawnVisualEffectAsChildOfParent("RoombellaCloneAnimReversed", MapLogic.AllCells[gridCoordY][gridCoordX]._x, 
					MapLogic.AllCells[gridCoordY][gridCoordX]._y, MapLogic.AllCells[gridCoordY][gridCoordX]._parent);
			}
		}
	}
	/*
	 * Spawns a given visual effect as a child of a MovieClip; in this game, usually used to spawn a visual effect on the drawing canvas.
	 * @param {String} effectTitle The name of the effect to spawn. Drawn from the Actionscript-linked name in the Flash project's library.
	 * @param {Number} xLocation The X Stage coordinate where the effect will be spawned.
	 * @param {Number} yLocation The Y Stage coordinate where the effect will be spawned.
	 * @param {MovieClip} parent The MovieClip that will be the parent of the newly-spawned visual effect.
	 */ 
	public static function SpawnVisualEffectAsChildOfParent(effectTitle:String, xLocation:Number, yLocation:Number, parent:MovieClip):Void {
		var effect = parent.attachMovie(effectTitle, effectTitle + "Instc", parent.getNextHighestDepth());
		effect._x = xLocation;
		effect._y = yLocation;
		
		effect.onEnterFrame = function(){
			if (effect._currentframe == effect._totalframes){
				Utilities.DeleteEnterFrameAndMC(effect);
			};
		};	
	};
	
	/*
	 * Rotates a Movie Clip at a random right angle.
	 * @param {MovieClip} mc The Movie Clip to rotate.
	 */ 
	public static function RotateMCAtRandomRightAngle(mc:MovieClip):Void {
		var angles = [0, 90, 180, 270];
		var direction = Math.floor(Math.random() * 4);
		
		mc._rotation = angles[direction];
		
		if (angles[direction] == angles[1]){
			mc._x += mc._width;
		} else if (angles[direction] == angles[2]){
			mc._x += mc._width;
			mc._y += mc._height;
		} else if (angles[direction] == angles[3]){
			mc._y += mc._height;
		};
	};
	
	/*
	 * Manages animation for the Character Cursor. Moves it to follow the active character.
	 */ 	
	public static function ManageCharacterCursorAnimation():Void {
		if (!CharacterCursor){
			CharacterCursor = _root['stageDrawingCanvas'].attachMovie('CharacterCursor', 'CharacterCursorInstc', _root['stageDrawingCanvas'].getNextHighestDepth());
		};
		
		if (GameplayLogic.CharacterMode == 1){
			CharacterCursor._x = GameplayLogic.Character1._x;
			CharacterCursor._y = GameplayLogic.Character1._y;
		} else if (GameplayLogic.CharacterMode == 2){
			CharacterCursor._x = GameplayLogic.Character2._x;
			CharacterCursor._y = GameplayLogic.Character2._y;
		};
	};
	
	/*
	 * Updates a specific ABC Gate object to a new status.
	 * @param {Object} gateObjectToUpdate The ABC Gate object to update.
	 * @param {String} newStatus The new status for the gate.
	 */ 
	public static function UpdateTimedGateVisual(gateObjectToUpdate:Object, newStatus:String):Void {
		trace("in update timed gate visual. newstatus: " + newStatus + ", corresponding tile frame: " + GetTileFrameFromType(newStatus));
		gateObjectToUpdate.cell.gotoAndStop(GetTileFrameFromType(newStatus));
	};	
	
	/*
	 * For a given tileType (derived from MapLayouts.Tiles), returns the corresponding frame in the Tiles 
	   Movie Clip in the Flash library.
	 * @param {String} tileType The tile type, derived from MapLayouts.Tiles.
	 * @return {Number} The corresponding frame number for the Tiles MovieClip in the Flash library.
	 */ 
	public static function GetTileFrameFromType(tileType:String):Number {
		switch (tileType){
			case 0:
				return 1;
				break;
			case 1:
				return 2;
				break;
			case 2:
				return 3;
				break;
			case 3:
				return 4;
				break;
			case 4:
				return 5;
				break;
			case 5:
				return 6;
				break;
			case 6:
				return 7;
				break;
			case 7:
				return 8;
				break;
			case 8:
				return 9;
				break;
			case "A":
				return 10;
				break;
			case "B":
				return 11;
				break;
			case "C":
				return 12;
				break;
			case "D":
				return 13;
				break;
			case "E":
				return 14;
				break;
			case "F":
				return 15;
				break;
			case "G":
				return 16;
				break;
			case "H":
				return 17;
				break;
			case "I":
				return 18;
				break;
			case "J":
				return 19;
				break;
			case "K":
				return 20;
				break;
			case "L":
				return 21;
				break;
			case "M":
				return 22;
				break;
			case "N":
				return 23;
				break;
			case "O":
				return 24;
				break;
			case "P":
				return 25;
				break;
			case "Q":
				return 26;
				break;
			case "R":
				return 27;
				break;
			case "S":
				return 28;
				break;
			case "T":
				return 29;
				break;
			case "U":
				return 30;
				break;
			case "V":
				return 31;
				break;
			case "W":
				return 32;
				break;
			case "X":
				return 33;
				break;
			case "Y":
				return 34;
				break;
			case "Z":
				return 35;
				break;
		};
	};
	
	/*
	 * For a given frame number (corresponding to the Tiles Movie Clip in the Flash library), returns the 
	   corresponding String from MapLayouts.Tiles.
	 * @param {Number} tileFrame The frame number for the Tiles MovieClip in the Flash library. 
	 * @return {Number} The corresponding tile type, derived from MapLayouts.Tiles.
	 */ 
	public static function GetTypeFromTileFrame(tileFrame:Number) {
		switch (tileFrame){
			case 1:
				return 0;
				break;
			case 2:
				return 1;
				break;
			case 3:
				return 2;
				break;
			case 4:
				return 3;
				break;
			case 5:
				return 4;
				break;
			case 6:
				return 5;
				break;
			case 7:
				return 6;
				break;
			case 8:
				return 7;
				break;
			case 9:
				return 8;
				break;
			case 10:
				return "A";
				break;
			case 11:
				return "B";
				break;
			case 12:
				return "C";
				break;
			case 13:
				return "D";
				break;
			case 14:
				return "E";
				break;
			case 15:
				return "F";
				break;
			case 16:
				return "G";
				break;
			case 17:
				return "H";
				break;
			case 18:
				return "I";
				break;
			case 19:
				return "J";
				break;
			case 20:
				return "K";
				break;
			case 21:
				return "L";
				break;
			case 22:
				return "M";
				break;
			case 23:
				return "N";
				break;
			case 24:
				return "O";
				break;
			case 25:
				return "P";
				break;
			case 26:
				return "Q";
				break;
			case 27:
				return "R";
				break;
			case 28:
				return "S";
				break;
			case 29:
				return "T";
				break;
			case 30:
				return "U";
				break;
			case 31:
				return "V";
				break;
			case 32:
				return "W";
			case 33:
				return "X";
			case 34:
				return "Y";
				break;
			case 35:
				return "Z";
		};
	};
};