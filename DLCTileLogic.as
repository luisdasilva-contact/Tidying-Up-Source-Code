/*
 * Manages behavior for the tiles in the DLC pack, including Timed Gates, 
   ABC Cages, Cloning Machines/Cloners, and Portals.
 */ 
class DLCTileLogic {
	public static var Char1Clone = null;	
	public static var Char1CloneIsMoving:Boolean = false;
	public static var Char1CloneCellToMoveTo:MovieClip = null;
	public static var Char2Clone = null;
	public static var Char2CloneIsMoving:Boolean = false;
	public static var Char2CloneTravelDirection:String;
	public static var Char2CloneCellToMoveTo:MovieClip = null;
	public static var Char2CloneLaunchGridCoord = null;
	public static var Char2CloneBouncingBackToPrevCell:Boolean = false;
	public static var Char2CloneTileTypeToMoveTo = null;
	public static var CloneJustSpawned = false;
	public static var CapyTrappedAtLeastOnce = false;
	public static var RoombellaTrappedAtLeastOnce = false;
	
	/*
	 * For a tile (derrived from MapLayouts.Tiles), checks whether or not a timed gate
	   should count down if the tile in question is a character's target tile.
	 * @param {String} targetTile The tile the character is targeting. 
	 * @return {Boolean} Whether or not it is a valid target for timed gates to count down. 
	 */ 
	public static function ValidTileForGateCountdown(targetTile:String):Boolean {
		if (targetTile == undefined){
			targetTile = null;
		};
		
		if (
			targetTile == MapLayouts.Tiles.Wall ||
			targetTile == MapLayouts.Tiles.Gate1 ||
			targetTile == MapLayouts.Tiles.Key1 ||
			targetTile == MapLayouts.Tiles.ABCGate_A_closed ||
			targetTile == MapLayouts.Tiles.ABCGate_B_closed ||
			targetTile == MapLayouts.Tiles.ABCGate_C_closed ||
			targetTile == MapLayouts.Tiles.Timer9 ||
			targetTile == MapLayouts.Tiles.Timer8 ||
			targetTile == MapLayouts.Tiles.Timer7 ||
			targetTile == MapLayouts.Tiles.Timer6 ||
			targetTile == MapLayouts.Tiles.Timer5 ||
			targetTile == MapLayouts.Tiles.Timer4 ||
			targetTile == MapLayouts.Tiles.Timer3 ||
			targetTile == MapLayouts.Tiles.Timer2){
				// can't have this progressing when a character doesn't go anywhere!
				return false;
		} else {
			return true;
		};
	};
	
	/*
	* For each timed gate in the map, manages their countdown behavior. If the gate's value is 2 through 9,
	   they are decreased by 1. If its value is 1, it is opened. If it is open, it is closed and set
	   back to its original value.
	* @param {Object} targetTile An object containing the XY coordinates of the current character's target.
	* @param {Object} targetTile An object containing the XY coordinates of the current clone's target (if clone exists).
	* @param {string} direction The direction the active character is moving in. Relevant only for Capy's clone check.
	*/ 	 
	public static function TimedGateCountdown(targetTile:Object, cloneTargetTile:Object, direction:String):Void {
		for (var i = 0; i < MapLogic.TimedGateObjects.length; i++){
			var oppositeCharacterValid:Boolean = true;
			// will check for the character not moving; if they're occupying the timed gate, do not countdown!
			if (GameplayLogic.CharacterMode == 1){
				if (MapLogic.TimedGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
					MapLogic.TimedGateObjects[i].GridCoord.y == GameplayLogic.Character2GridCoord.y){
					oppositeCharacterValid = false;
				};
			} else if (GameplayLogic.CharacterMode == 2){
				if (MapLogic.TimedGateObjects[i].GridCoord.x == GameplayLogic.Character1GridCoord.x &&
					MapLogic.TimedGateObjects[i].GridCoord.y == GameplayLogic.Character1GridCoord.y){
					oppositeCharacterValid = false;
				};
			};
			trace("in timed gate. OG target tile: " + targetTile.x + ", y: " + targetTile.y + ", clone 1 current tile: " + 
			"clone x: " + Char1Clone.GridCoord.x + ", y: " + Char1Clone.GridCoord.y + ", targetile arg? " + targetTile);
			// insanely, crazily specific scenario: a clone chamber being directly next to a timed gate. Char creates a 
			// clone, is stopped so he doesnt run right into the clone, and then the timed gate continues if this isnt caught...
			var clonerCheck:Boolean = true;
			
			if (MapLogic.LevelTiles[targetTile.y][targetTile.x] == MapLayouts.Tiles.Cloner && DLCTileLogic.Char1Clone == null && 
				GameplayLogic.CharacterMode == 1){
				clonerCheck = false;
			} else if (GameplayLogic.CharacterMode == 2 && DLCTileLogic.Char2Clone == null){
				if (GameplayLogic.GetNextTile(GameplayLogic.Char2TravelDirection, GameplayLogic.Char2LaunchGridCoord.x, 
					GameplayLogic.Char2LaunchGridCoord.y) == MapLayouts.Tiles.Cloner){
					trace("not counting down, next tile is cloner");
					clonerCheck = false;
				};
			};
			
			if ((MapLogic.TimedGateObjects[i].status != MapLayouts.Tiles.TimerOpen) ||
				(MapLogic.TimedGateObjects[i].status == MapLayouts.Tiles.TimerOpen) &&
				!(MapLogic.TimedGateObjects[i].GridCoord.x == targetTile.x &&
					MapLogic.TimedGateObjects[i].GridCoord.y == targetTile.y) &&
				!(MapLogic.TimedGateObjects[i].GridCoord.x == cloneTargetTile.x &&
					MapLogic.TimedGateObjects[i].GridCoord.y == cloneTargetTile.y) &&
				oppositeCharacterValid && clonerCheck){
				switch(MapLogic.TimedGateObjects[i].status){
					case MapLayouts.Tiles.Timer9:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer8;
						break;
					case MapLayouts.Tiles.Timer8:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer7;
						break;
					case MapLayouts.Tiles.Timer7:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer6;
						break;
					case MapLayouts.Tiles.Timer6:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer5;
						break;
					case MapLayouts.Tiles.Timer5:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer4;
						break;
					case MapLayouts.Tiles.Timer4:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer3;
						break;
					case MapLayouts.Tiles.Timer3:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer2;
						break;
					case MapLayouts.Tiles.Timer2:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.Timer1;
						break;
					case MapLayouts.Tiles.Timer1:
						MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.TimerOpen;
						break;
					case MapLayouts.Tiles.TimerOpen:
						if (GameplayLogic.CharacterMode == 2){							
							var prevCellOfGate = GameplayLogic.GetPrevGridCoord(GameplayLogic.Char2TravelDirection, 
							MapLogic.TimedGateObjects[i]);
							// this is to make sure a gate will stay open if Roombella is about to step into it!
							if ((GameplayLogic.Character2GridCoord.x == prevCellOfGate.x &&
								GameplayLogic.Character2GridCoord.y == prevCellOfGate.y && !GameplayLogic.Character2IsMoving) ||
								(DLCTileLogic.Char2Clone.GridCoord.x == prevCellOfGate.x &&
								DLCTileLogic.Char2Clone.GridCoord.y == prevCellOfGate.y && 
								!DLCTileLogic.Char2CloneIsMoving)){
									continue;								
							} else {
								MapLogic.TimedGateObjects[i].status = MapLogic.TimedGateObjects[i].originalStatus;
							};
						} else {
							if (GameplayLogic.Character2GridCoord.x == MapLogic.TimedGateObjects[i].GridCoord.x &&
								GameplayLogic.Character2GridCoord.y == MapLogic.TimedGateObjects[i].GridCoord.y){
									continue;
								} else {
									MapLogic.TimedGateObjects[i].status = MapLogic.TimedGateObjects[i].originalStatus;
							};							
						};
				};
			};
			
			MapLogic.LevelTiles[MapLogic.TimedGateObjects[i].GridCoord.y][MapLogic.TimedGateObjects[i].GridCoord.x] = 
				MapLogic.TimedGateObjects[i].status;
			AnimationController.UpdateTimedGateVisual(MapLogic.TimedGateObjects[i], MapLogic.TimedGateObjects[i].status);
			
			if (MapLogic.TimedGateObjects[i].status != MapLayouts.Tiles.TimerOpen){	
				// also hate this hittest check being here BUT this is to prevent a bug where a closing gate would squish a character
					// if it was set as their target BUT they're not actually touching it yet
					// the clone 1 check is to make sure the clone is NOT stepping out of the gate when it closes; don't want it to 
					// close on him on the way out
				if ((MapLogic.TimedGateObjects[i].cell.hitTest(DLCTileLogic.Char2Clone)) || 
					(MapLogic.TimedGateObjects[i].cell.hitTest(DLCTileLogic.Char1Clone))){
						if ((MapLogic.TimedGateObjects[i].GridCoord.x == DLCTileLogic.Char2Clone.GridCoord.x &&
							MapLogic.TimedGateObjects[i].GridCoord.y == DLCTileLogic.Char2Clone.GridCoord.y) ||
							((DLCTileLogic.Char1Clone != null && (cloneTargetTile == undefined || 
							!ValidTileForGateCountdown(MapLogic.LevelTiles[cloneTargetTile.y][cloneTargetTile.x], 0, 0, true)) &&
							MapLogic.TimedGateObjects[i].GridCoord.x == DLCTileLogic.Char1Clone.GridCoord.x &&
							MapLogic.TimedGateObjects[i].GridCoord.y == DLCTileLogic.Char1Clone.GridCoord.y))){
								var canSquish:Boolean = true;
								// after all that, if trying to squish char1 clone... if the clone is just moving into the valid spot
								// of where OG Capy was, then no, cannot squish. This is another check to make sure clone is not 
								// squished stepping out of the gate...
								trace("pre-check. Hit true? " + MapLogic.TimedGateObjects[i].cell.hitTest(DLCTileLogic.Char1Clone) + 
								", target open? " + Controls._isTargetTileOpen(MapLogic.LevelTiles[targetTile.y][targetTile.x], 0, 0, true) + 
								", clone trailing? " + IsCloneTrailingOriginal(1, direction) + ", direction?" + direction);
								if (MapLogic.TimedGateObjects[i].cell.hitTest(DLCTileLogic.Char1Clone)){
									if (ValidTileForGateCountdown(MapLogic.LevelTiles[targetTile.y][targetTile.x]) &&
									IsCloneTrailingOriginal(1, direction)){
										canSquish = false;
									};
								};
								
								if (canSquish){
								AnimationController.SpawnDestroyAnimationOfCloneAtGridCoord(MapLogic.TimedGateObjects[i].GridCoord.x, 
									MapLogic.TimedGateObjects[i].GridCoord.y);
									trace("destroy 1, clone target tile: " + cloneTargetTile + ", x: " + cloneTargetTile.x + ", y: " + 
									cloneTargetTile.y + ", target tile open? " + Controls._isTargetTileOpen(MapLogic.LevelTiles[cloneTargetTile.y][cloneTargetTile.x], 0, 0, true) + 
									", clone x: " + DLCTileLogic.Char1Clone.GridCoord.x + ", y: " + DLCTileLogic.Char1Clone.GridCoord.y + ", clone moving? " + DLCTileLogic.Char1CloneIsMoving
									 + ", clone trailing? " + IsCloneTrailingOriginal(1, "right"));
								DestroyClonesAtGridCoord({x: MapLogic.TimedGateObjects[i].GridCoord.x, 
									y: MapLogic.TimedGateObjects[i].GridCoord.y});		
								};							
						};					
				};
			} else {
				// need to squish clone if they're not already on way out; useful for scenarios where clone technically
				// doesn't have a target tile because they're stuck in a corner on top of a countdown tile
				if ((MapLogic.TimedGateObjects[i].cell.hitTest(DLCTileLogic.Char2Clone) && !DLCTileLogic.Char2CloneIsMoving &&
					DLCTileLogic.Char2Clone.GridCoord.x == MapLogic.TimedGateObjects[i].GridCoord.x &&
					DLCTileLogic.Char2Clone.GridCoord.y == MapLogic.TimedGateObjects[i].GridCoord.y) || 
					(MapLogic.TimedGateObjects[i].cell.hitTest(DLCTileLogic.Char1Clone) && !DLCTileLogic.Char1CloneIsMoving &&
					DLCTileLogic.Char1Clone.GridCoord.x == MapLogic.TimedGateObjects[i].GridCoord.x &&
					DLCTileLogic.Char1Clone.GridCoord.y == MapLogic.TimedGateObjects[i].GridCoord.y && 
					(cloneTargetTile.x != MapLogic.TimedGateObjects[i].GridCoord.x && cloneTargetTile.y != MapLogic.TimedGateObjects[i].GridCoord.y))){
				AnimationController.SpawnDestroyAnimationOfCloneAtGridCoord(MapLogic.TimedGateObjects[i].GridCoord.x, 
					MapLogic.TimedGateObjects[i].GridCoord.y);
				DestroyClonesAtGridCoord({x: MapLogic.TimedGateObjects[i].GridCoord.x, 
					y: MapLogic.TimedGateObjects[i].GridCoord.y});
				};
			};
		};
	};
	
	/*
	 * Scans through cells to find all cages of the type in the string (A, B, or C). If the cage is found, it is
	   unlocked.
	 * @param {String} type Should be "A", "B", or "C". This is the type of cage that should be unlocked.
	 */ 
	public static function UnlockAllABCCagesOfType(type:String):Void {
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){
			if (MapLogic.ABCCageObjects[i].status == type + "_closed"){
				MapLogic.ABCCageObjects[i].status = type + "_open";
				MapLogic.LevelTiles[MapLogic.ABCCageObjects[i].GridCoord.y][MapLogic.ABCCageObjects[i].GridCoord.x] = 
					MapLayouts.Tiles["ABCCage_" + MapLogic.ABCCageObjects[i].status];
				SoundManager.PlayABCGateSound(type);
			};
		};
	};
	
	/*
	 * Scans through cells to find all cages not of the type in the string (A, B, or C). If the cage is found, it is
	   unlocked.
	 * @param {String} type Should be "A", "B", or "C". This is the type of cage that should be excluded from being unlocked.
	 */ 
	public static function UnlockAllABCCagesNotOfType(type:String):Void {
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){
			var currentType = MapLogic.ABCCageObjects[i].status.charAt(0);
			if (MapLogic.ABCCageObjects[i].status.indexOf("_open") == -1 &&
				currentType != type){
					
				// before opening the cage, need to make sure there isn't another switch somewhere keeping it open
				var passesSecondUnlockCheck = true;
				for (var j = 0; j < MapLogic.ABCSwitchObjects.length; j++){
					if (MapLogic.ABCSwitchObjects[j].status == currentType){
						passesSecondUnlockCheck = false;
					};
				};
				
				if (passesSecondUnlockCheck){
					// if closed AND doesn't match type in arg, good to open
					MapLogic.ABCCageObjects[i].status = currentType + "_open";
					MapLogic.LevelTiles[MapLogic.ABCCageObjects[i].GridCoord.y][MapLogic.ABCCageObjects[i].GridCoord.x] = 
						MapLayouts.Tiles["ABCCage_" + MapLogic.ABCCageObjects[i].status];					
					AnimationController.RemoveABCCageVisualAtGridCoord(MapLogic.ABCCageObjects[i].GridCoord.x, MapLogic.ABCCageObjects[i].GridCoord.y);
					SoundManager.PlayABCGateSound(type);
				};
			};			
		};
	};
	
	/*
	 * Scans through cells to find any ABC Cages that can be triggered, either capturing Capy or Roombella or squishing
	   their clones. Contains all the same checks as LockAllABCGatesNotOfType as far as checking which characters can be moved,
	   squished, etc.
	 * @param {String} type Should be "A", "B", or "C". This is the type of cage that should be kept open; others are locked.
	 * @param {Number} character If the character performing the check is 1 or 2. 
	 * @param {Boolean} forClone Whether or not the check is being performed by a clone.
	 * @param {Number} targetX The X value being targeted on the map by the character performing the check.
	 * * @param {Number} targetY The Y value being targeted on the map by the character performing the check.
	 */ 
	public static function TriggerABCCagesWithCharacters(type:String, character:Number, forClone:Boolean, 
		targetX:Number, targetY:Number):Void {
		var canLockCage:Boolean;
		
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){
			canLockCage = true;
			if (MapLogic.ABCCageObjects[i].status == type + "_open"){
				
				// only trigger if a character OR clone is already in the cage
				// char 1 and its clone have a handful of specific checks to prevent a bug where a cage could
				// be triggered when a character is walking out of it, and into a switch that would then trigger it
				if ((MapLogic.ABCCageObjects[i].GridCoord.x == GameplayLogic.Character1GridCoord.x &&
					MapLogic.ABCCageObjects[i].GridCoord.y == GameplayLogic.Character1GridCoord.y &&
					!GameplayLogic.Character1IsMoving) ||
					(MapLogic.ABCCageObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
					MapLogic.ABCCageObjects[i].GridCoord.y == GameplayLogic.Character2GridCoord.y &&
					!GameplayLogic.Character2IsMoving)){
						if (character != 1 ||
						((character == 1 && !forClone) && !(targetX == MapLogic.ABCCageObjects[i].GridCoord.x &&
						targetY == MapLogic.ABCCageObjects[i].GridCoord.y) && !(MapLogic.ABCCageObjects[i].GridCoord.x 
						== GameplayLogic.Character1GridCoord.x && MapLogic.ABCCageObjects[i].GridCoord.y == GameplayLogic.Character1GridCoord.y))){							
							CheckCageAtCoordIsReadyToSpring(MapLogic.ABCCageObjects[i].GridCoord.x, MapLogic.ABCCageObjects[i].GridCoord.y);
						};						
				};
					
				if ((DLCTileLogic.Char1Clone != null &&
					MapLogic.ABCCageObjects[i].GridCoord.x == DLCTileLogic.Char1Clone.GridCoord.x &&
					MapLogic.ABCCageObjects[i].GridCoord.y == DLCTileLogic.Char1Clone.GridCoord.y &&
					!DLCTileLogic.Char1CloneIsMoving) ||
					(DLCTileLogic.Char2Clone != null &&
					MapLogic.ABCCageObjects[i].GridCoord.x == DLCTileLogic.Char2Clone.GridCoord.x &&
					MapLogic.ABCCageObjects[i].GridCoord.y == DLCTileLogic.Char2Clone.GridCoord.y &&
					!DLCTileLogic.Char2CloneIsMoving && !DLCTileLogic.Char2CloneBouncingBackToPrevCell)){
						if (character != 1 ||
						((character == 1 && forClone) && !(targetX == MapLogic.ABCCageObjects[i].GridCoord.x &&
						targetY == MapLogic.ABCCageObjects[i].GridCoord.y) && !(MapLogic.ABCCageObjects[i].GridCoord.x 
						== DLCTileLogic.Char1Clone.GridCoord.x && MapLogic.ABCCageObjects[i].GridCoord.y == DLCTileLogic.Char1Clone.GridCoord.y))){
							CheckCageAtCoordIsReadyToSpring(MapLogic.ABCCageObjects[i].GridCoord.x, MapLogic.ABCCageObjects[i].GridCoord.y);
							DestroyClonesAtGridCoord({x: MapLogic.ABCCageObjects[i].GridCoord.x, 
								y: MapLogic.ABCCageObjects[i].GridCoord.y});
							AnimationController.SpawnDestroyAnimationOfCloneAtGridCoord(MapLogic.ABCCageObjects[i].GridCoord.x, 
							MapLogic.ABCCageObjects[i].GridCoord.y);
						};
					
				};
			};
		};
	};	
	
	/*
	* Checks if an ABC Cage can be sprung, including a check that a cage is A) open and B) has a matching
	   switch on. If it's ready to spring, spring it!
	* @param {Number} xCoord The X Grid coordinate to check for a cage.
	* @param {Number} yCoord The Y Grid coordinate to check for a cage.
	*/ 
	public static function CheckCageAtCoordIsReadyToSpring(xCoord:Number, yCoord:Number){
		if (CheckCageAtCoordIsOpen(xCoord, yCoord)){			
			var currentType = MapLogic.LevelTiles[yCoord][xCoord].charAt(0);
			var index = IndexOfOpenCage(xCoord, yCoord);
			var matchingType = GetABCSwitchFromCageType(currentType);
			
			for (var i = 0; i < MapLogic.ABCSwitchObjects.length; i++){
				if (MapLogic.ABCSwitchObjects[i].status == matchingType){
					MapLogic.ABCCageObjects[index].status = matchingType + "_closed";
					MapLogic.LevelTiles[yCoord][xCoord] = MapLayouts.Tiles["ABCCage_" + matchingType + "_closed"];
					
					if (!SoundManager.playedABCCageLatchThisTurn){
						SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Latch);
						SoundManager.playedABCCageLatchThisTurn = true;
					};					
					
					AnimationController.CreateABCCageVisual(matchingType, xCoord, yCoord, MapLogic.ABCCageObjects[index].cell._x, MapLogic.ABCCageObjects[index].cell._y);
					AnimationController.UpdateAllABCCages(); // inefficient, really only need to update THIS abc cage
					
					return;
				};
			};			
		};		
	};
	
	/*
	* For character2 (Roombella), checks if the cage on her trajectory is ready to spring.
	* @param {Number} xCoord The X Grid coordinate to check for a cage.
	* @param {Number} yCoord The Y Grid coordinate to check for a cage.
	* @return {Boolean} Whether or not the given cage is ready to spring.
	*/ 
	public static function Char2CheckCageAtCoordIsReadyToSpring(xCoord:Number, yCoord:Number):Boolean {		
		if (CheckCageAtCoordIsOpen(xCoord, yCoord) && !(xCoord == GameplayLogic.Char2LaunchGridCoord.x &&
			yCoord == GameplayLogic.Char2LaunchGridCoord.y)){
			var currentType = MapLogic.LevelTiles[yCoord][xCoord].charAt(0);
			var index = IndexOfOpenCage(xCoord, yCoord);
			var matchingType = GetABCSwitchFromCageType(currentType);
			for (var i = 0; i < MapLogic.ABCSwitchObjects.length; i++){
				if (MapLogic.ABCSwitchObjects[i].status == matchingType){
					return true;
				};
			};			
		};
		return false;
	};
	
	/*
	 * For a given open cage type, return its corresponding switch from MapLayouts.Tiles.
	 * @param {String} cageType The type of open cage to check for, derived from MapLayouts.Tiles.
	 * @return {String} The corresponding ABC switch type, derived from MapLayouts.Tiles.
	 */ 
	public static function GetABCSwitchFromCageType(cageType:String):String {
		switch(cageType){
			case MapLayouts.Tiles.ABCCage_A_open:
				return MapLayouts.Tiles.ABCSwitch_A;
			case MapLayouts.Tiles.ABCCage_B_open:
				return MapLayouts.Tiles.ABCSwitch_B;
			case MapLayouts.Tiles.ABCCage_C_open:
				return MapLayouts.Tiles.ABCSwitch_C;
		};
	};
	
	/*
	 * Checks whether or not the cage at a given XY coordinate is open. 
	 * @param {Number} xCoord The X coordinate to search at.
	 * @param {Number} yCoord The Y coordinate to search at.
	 * @return {Bool} True if the cage at the coordinate is open, false if it's closed.
	 */ 
	public static function CheckCageAtCoordIsOpen(xCoord:Number, yCoord:Number):Boolean {
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){			
			if (MapLogic.ABCCageObjects[i].GridCoord.x == xCoord &&
				MapLogic.ABCCageObjects[i].GridCoord.y == yCoord){
					
				trace("cage x: " + xCoord + ", y: " + yCoord + ", status: " + MapLogic.ABCCageObjects[i].status);
				if (MapLogic.ABCCageObjects[i].status.indexOf("_open") == -1){
					return false;
				} else {
					return true;
				};
			};
		};
	};	
	
	/*
	 * Retrieves the index of an open ABC cage at the given Grid coordinates.
	 * @param {Number} xCoord The X coordinate to search at.
	 * @param {Number} yCoord The Y coordinate to search at.
	 * @return {Number} The index of the ABC Cage in the list of ABC Cage Objects.
	 */ 
	public static function IndexOfOpenCage(xCoord:Number, yCoord:Number):Number {
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){
			if (MapLogic.ABCCageObjects[i].GridCoord.x == xCoord &&
				MapLogic.ABCCageObjects[i].GridCoord.y == yCoord){
				if (MapLogic.ABCCageObjects[i].status.indexOf("_open") != -1){
					return i;
				};
			};
		};
		return null;
	};
	
	/*
	 * Checks if a character is trapped in an ABC cage.
	 * @param {Number} char The character to check. 1 is Capy, 2 is Roombella.
	 * @return {Boolean} Whether or not the given character is in an ABC Cage.
	 */ 
	public static function CharacterInABCCage(char:Number):Boolean {
		var tileToCheck;
		if (char == 1){
			tileToCheck = MapLogic.LevelTiles[GameplayLogic.Character1GridCoord.y][GameplayLogic.Character1GridCoord.x];
		} else if (char == 2){
			tileToCheck = MapLogic.LevelTiles[GameplayLogic.Character2GridCoord.y][GameplayLogic.Character2GridCoord.x];
		} else {
			return;
		};
		
		if (tileToCheck == MapLayouts.Tiles.ABCCage_A_closed ||
			tileToCheck == MapLayouts.Tiles.ABCCage_B_closed ||
			tileToCheck == MapLayouts.Tiles.ABCCage_C_closed){
			return true;
		} else {
			return false;
		};
	};
	
	/*
	* Checks if a character is targetting a portal that is currently occupied. 
	* @param {Number} char The character to check for. 1 for Capy, 2 for Roombella. 
	* @param {Boolean} forClone Whether or not the function is checking for a clone.
	* @param xAddition {Number} The number of X Grid units the character is traveling to get to the portal in question.
	* @param yAddition {Number} The number of Y Grid units the character is traveling to get to the portal in question.
	*/ 
	public static function IsCharacterTargetingOccupiedPortal(char:Number, forClone:Boolean, xAddition:Number, 
		yAddition:Number):Boolean {
		var targetMC:MovieClip;
		var baselineX:Number;
		var baselineY:Number;
		if (char == 1){
			if (forClone){
				baselineX = Char1Clone.GridCoord.x + xAddition;
				baselineY = Char1Clone.GridCoord.y + yAddition;
			} else {
				baselineX = GameplayLogic.Character1GridCoord.x + xAddition;
				baselineY = GameplayLogic.Character1GridCoord.y + yAddition;
			};
		} else if(char == 2){
			if (forClone){
				baselineX = Char2Clone.GridCoord.x + xAddition;
				baselineY = Char2Clone.GridCoord.y + yAddition;
			} else {
				baselineX = GameplayLogic.Character2GridCoord.x + xAddition;
				baselineY = GameplayLogic.Character2GridCoord.y + yAddition;
			};
		};
		for (var i = 0; i < MapLogic.PortalObjects.length; i++){
			if (MapLogic.PortalObjects[i].GridCoord.x == baselineX &&
				MapLogic.PortalObjects[i].GridCoord.y == baselineY){
				if (DLCTileLogic.IsCharacterInCorrespondingPortal(
					MapLogic.PortalObjects[i].status, MapLogic.PortalObjects[i].GridCoord.x, 
					MapLogic.PortalObjects[i].GridCoord.y)){
					return true;						
				};
			};
		};
		return false;
	};	
	
	/*
	 * For a given portal type, find the corresponding one. 
	 * @param {String} type The type of portal to search for. Should be A, B, or C.
	 * @param {Number} xCoord The X Grid Coordinate of the portal to check for.
	 * @param {Number} yCoord The Y Grid Coordinate of the portal to check for.
	 * @return {MovieClip} The matching portal.
	 */ 
	public static function GetCorrespondingPortal(type:String, xCoord:Number, yCoord:Number):MovieClip {		
		for (var i = 0; i < MapLogic.PortalObjects.length; i++){
			if (MapLogic.PortalObjects[i].status == type && 
			!(MapLogic.PortalObjects[i].GridCoord.x == xCoord &&
				MapLogic.PortalObjects[i].GridCoord.y == yCoord)){
					return MapLogic.PortalObjects[i];
			};
		};
		return null;
	};
	
	/*
	 * If a portal is at a given grid coord, return it.
	 * @param {Number} xCoord The X Grid Coordinate of the portal to check for.
	 * @param {Number} yCoord The Y Grid Coordinate of the portal to check for.
	 * @return {MovieClip} The matching portal.
	 */ 
	public static function GetPortalAtGridCoord(xCoord:Number, yCoord:Number):MovieClip {
		for (var i = 0; i < MapLogic.PortalObjects.length; i++){
			if (MapLogic.PortalObjects[i].GridCoord.x == xCoord &&
				MapLogic.PortalObjects[i].GridCoord.y == yCoord){
					return MapLogic.PortalObjects[i];
			};
		};
		return null;
	};
	
	/*
	 * Checks if any character is in the corresponding portal.
	 * @param {String} type The type of portal to search for. Should be A, B, or C.
	 * @param {Number} xCoord The X Grid Coordinate of the portal to check for.
	 * @param {Number} yCoord The Y Grid Coordinate of the portal to check for.
	 * @return {Boolean} Whether or not there's a character in the corresponding portal.
	 */ 
	public static function IsCharacterInCorrespondingPortal(type:String, xCoord:Number, yCoord:Number):Boolean {
		var correspondingPortal = GetCorrespondingPortal(type, xCoord, yCoord);
		if (correspondingPortal != null){
			if ((correspondingPortal.GridCoord.x == GameplayLogic.Character1GridCoord.x &&
				correspondingPortal.GridCoord.y == GameplayLogic.Character1GridCoord.y) ||
				IsCloneAtGridCoord(1, correspondingPortal.GridCoord.x, correspondingPortal.GridCoord.y) ||
				(correspondingPortal.GridCoord.x == GameplayLogic.Character2GridCoord.x &&
				correspondingPortal.GridCoord.y == GameplayLogic.Character2GridCoord.y) ||
				IsCloneAtGridCoord(2, correspondingPortal.GridCoord.x, correspondingPortal.GridCoord.y)){
				return true;
			};
		};	
		return false;
	};
		
	/*
	 * Checks for whether or not a specific character is in the corresponding portal. Used to see if 
	  teleportation visual should be used for when a character steps into a portal directly next to the
	   one they're already sitting in.
	 * @param {Number} char The character to check for.
	 * @param {Boolean} forClone Whether or not this function is being run for a clone.
	 * @param {String} * @param {String} type The type of portal to search for. Should be A, B, or C.
	 * @param {Number} xCoord The X Grid Coordinate of the portal to check for.
	 * @param {Number} yCoord The Y Grid Coordinate of the portal to check for.
	 */
	public static function CheckIfCharInCorrespondingPortal(char:Number, forClone:Boolean, 
		type:String, xCoord:Number, yCoord:Number){
		var correspondingPortal = GetCorrespondingPortal(type, xCoord, yCoord);
		var charGridCoordX;
		var charGridCoordY;
		if (correspondingPortal != null){
			if (char == 1){
				if (!forClone){
					charGridCoordX = GameplayLogic.Character1GridCoord.x;
					charGridCoordY = GameplayLogic.Character1GridCoord.y;
				} else {
					charGridCoordX = Char1Clone.GridCoord.x;
					charGridCoordY = Char1Clone.GridCoord.y;
				};
			} else if (char == 2){
				if (!forClone){
					charGridCoordX = GameplayLogic.Character2GridCoord.x;
					charGridCoordY = GameplayLogic.Character2GridCoord.y;
				} else {
					charGridCoordX = Char2Clone.GridCoord.x;
					charGridCoordY = Char2Clone.GridCoord.y;
				};
			};
			
			if (correspondingPortal.GridCoord.x == charGridCoordX &&
				correspondingPortal.GridCoord.y == charGridCoordY){
				return true;
			};
		};	
		return false;		
	};
	
	/*
	 * Checks if any character is at a given grid location.
	 * @param {Number} xCoord The X Grid Coordinate to check.
	 * @param {Number} yCoord The Y Grid Coordinate to check. 
	 * @return {Boolean} Whether or not a character is at the grid coord.
	 */ 
	public static function IsAnyCharacterAtGridCoord(xCoord:Number, yCoord:Number):Boolean {
		if (IsCloneAtGridCoord(1, xCoord, yCoord) || IsCloneAtGridCoord(2, xCoord, yCoord)){
			return true;
		};
		
		if (GameplayLogic.Character1GridCoord.x == xCoord &&
			GameplayLogic.Character1GridCoord.y == yCoord){
				return true;
		};
		
		if (GameplayLogic.Character2GridCoord.x == xCoord &&
			GameplayLogic.Character2GridCoord.y == yCoord){
				return true;
		};
		
		return false;
	};
	
	/*
	 * Checks if a character's clone is at a specific grid location.
	 * @param {Number} characterNo The character to check for. 1 is Capy, 2 is Roombella.
	 * @param {Number} xCoord The X Grid Coordinate of the portal to check for.
	 * @param {Number} yCoord The Y Grid Coordinate of the portal to check for. 
	 */ 
	public static function IsCloneAtGridCoord(characterNo:Number, xCoord:Number, yCoord:Number):Boolean {
		if (characterNo == 1){
			if (Char1Clone != null){
				if (Char1Clone.GridCoord.x == xCoord && Char1Clone.GridCoord.y == yCoord){
					return true;
				};
			}; 
		} else if (characterNo == 2){
			if (Char2Clone != null){
				if (Char2Clone.GridCoord.x == xCoord && Char2Clone.GridCoord.y == yCoord){
					return true;
				};
			};
		};
		return false;
	};
	
	/*
	 * Create a clone!
	 * @param {Number} characterNo Which character to clone. 1 is Capy, 2 is Roombella.
	 * @param {Object} gridCoord An object with XY coordinates, showing where to spawn the character on the grid.
	*/
	public static function CreateClone(characterNo:Number, gridCoord:Object){		
		var charMC:MovieClip = null;
		var charName:String = "";
		if (characterNo == 1){
			charMC = _root['stageDrawingCanvas'].attachMovie('hero', 'heroClone', _root['stageDrawingCanvas'].getNextHighestDepth());		
			charMC.GridCoord = {x: Number(gridCoord.x), y: Number(gridCoord.y)};
			DLCTileLogic.Char1Clone = charMC;
			charName = "Capy";
		} else if (characterNo == 2){
			charMC = _root['stageDrawingCanvas'].attachMovie('hero2', 'hero2Clone', _root['stageDrawingCanvas'].getNextHighestDepth());		
			charMC.GridCoord = {x: Number(gridCoord.x), y: Number(gridCoord.y)};
			DLCTileLogic.Char2Clone = charMC;
			charName = "Roombella";
		};
		charMC.gotoAndStop(4);
		charMC._x = gridCoord.x * MapLogic.TileSize;
		charMC._y = gridCoord.y * MapLogic.TileSize;
		SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Teleport);
		AnimationController.SpawnVisualEffect(charName + "TeleportAnim", MapLogic.AllCells[charMC.GridCoord.y][charMC.GridCoord.x]._x + 
			MapLogic.AllCells[charMC.GridCoord.y][charMC.GridCoord.x]._parent._x, 
			MapLogic.AllCells[charMC.GridCoord.y][charMC.GridCoord.x]._y + 
			MapLogic.AllCells[charMC.GridCoord.y][charMC.GridCoord.x]._parent._y);
	};
	
	/*
	 * Destroy any clones at the Grid coordinate.
	 * @param {Object} gridCoord An object with XY coordinates, showing where to spawn the character on the grid.
	 */ 
	public static function DestroyClonesAtGridCoord(gridCoord:Object):Void {
		DestroyCloneAtGridCoord(1, gridCoord);
		DestroyCloneAtGridCoord(2, gridCoord);
	};
	
	/*
	 * Destroy any clone at the given Grid coordinate. 
	 * @param {Number} characterNo The character clone to destroy. 1 for Capy, 2 for Roombela.
	 * @param {Object} gridCoord An object with XY coordinates, showing where to spawn the character on the grid.
	 */
	public static function DestroyCloneAtGridCoord(characterNo:Number, gridCoord:Object):Void {
		if (characterNo == 1){
			if (IsCloneAtGridCoord(1, gridCoord.x, gridCoord.y)){
				SoundManager.PlaySound(SoundManager.SoundLibraryEnum.CloneDeath);
				DestroyClone(1);
			};
		} else if (characterNo == 2){
			if (IsCloneAtGridCoord(2, gridCoord.x, gridCoord.y)){
				SoundManager.PlaySound(SoundManager.SoundLibraryEnum.CloneDeath);
				DestroyClone(2);
			};
		};
	};
	
	/*
	 * Destroy the given clone.
	 * @param {Number} characterNo The character to destroy. 1 for Capy, 2 for Roombella.
	 */ 
	public static function DestroyClone(characterNo:Number):Void {
		if (characterNo == 1){
			Char1Clone.removeMovieClip();
			Char1Clone = null;
			Char1CloneIsMoving = false;
			Char1CloneCellToMoveTo = null;
		} else if (characterNo == 2){
			DLCTileLogic.Char2Clone.removeMovieClip();
			Char2Clone = null;
			Char2CloneIsMoving = false;
			Char2CloneTravelDirection = null;
			Char2CloneCellToMoveTo = null;
			Char2CloneLaunchGridCoord = null;
			Char2CloneTileTypeToMoveTo = null;
			Char2CloneBouncingBackToPrevCell = false;
		};
	};
	
	/*
	 * Checks whether or not a character's clone is trailing them. 
	 * @param {Number} characterNo The character to check. 1 for Capy, 2 for Roombella.
	 * @param {String} direction The direction the character is traveling: left, right, up, or down. 
	 * @return {Boolean} Whether or not the character's clone is trailing them.
	 */ 
	public static function IsCloneTrailingOriginal(characterNo:Number, direction:String):Boolean {
		if (characterNo == 1){
		if (Char1Clone != null){
			// if in the same row/column and only 1 y unit apart in either direction
			if ((Char1Clone.GridCoord.x == GameplayLogic.Character1GridCoord.x &&
			Math.abs(Char1Clone.GridCoord.y - GameplayLogic.Character1GridCoord.y) == 1) ||
			(Char1Clone.GridCoord.y == GameplayLogic.Character1GridCoord.y &&
			Math.abs(Char1Clone.GridCoord.x - GameplayLogic.Character1GridCoord.x) == 1)){
				if (direction == "left"){
					if (GameplayLogic.Character1._x < Char1Clone._x){
						return true;
					};
				} else if (direction == "right"){
					if (GameplayLogic.Character1._x > Char1Clone._x){
						return true;
					};
				} else if (direction == "up"){
					if (GameplayLogic.Character1._y < Char1Clone._y){
						return true;
					};
				} else if (direction == "down"){
					if (GameplayLogic.Character1._y > Char1Clone._y){
						return true;
					};				
				};			
			};
		}; 
		} else if (characterNo == 2){
			if (Char2Clone != null){
				if ((Char2Clone.GridCoord.x == GameplayLogic.Character2GridCoord.x &&
				Math.abs(Char2Clone.GridCoord.y - GameplayLogic.Character2GridCoord.y) == 1) ||
				(Char2Clone.GridCoord.y == GameplayLogic.Character2GridCoord.y &&
				Math.abs(Char2Clone.GridCoord.x - GameplayLogic.Character2GridCoord.x) == 1)){
					if (direction == "left"){
						if (GameplayLogic.Character2._x < Char2Clone._x){
							return true;
						};
					} else if (direction == "right"){
						if (GameplayLogic.Character2._x > Char2Clone._x){
							return true;
						};
					} else if (direction == "up"){
						if (GameplayLogic.Character2._y < Char2Clone._y){
							return true;
						};
					} else if (direction == "down"){
						if (GameplayLogic.Character2._y > Char2Clone._y){
							return true;
						};				
					};			
				};
			};
		};
		return false;
	};
	
	/*
	* As Capy's clone's movement occurs after Capy's, in situations where he's moving up or left and the clone is above or to his left respectively, 
	   or Capy is above and his clone is moving down, movement can't work as intended due to collission. This checks who's the leader and acts accordingly.
	* @param {String} direction The direction the character is traveling: left, right, up, or down. 
	* @param {Number} unitsApart The number of units apart they must be to check for whether or not they're next to each other.
	* @return {MovieClip} Which of the characters is the lead, Capy or his clone.
	*/ 
	public static function GetChar1Lead(direction:String, unitsApart:Number):MovieClip {
		var leader = null;
		if (Char1Clone != null){
			if ((Char1Clone.GridCoord.x == GameplayLogic.Character1GridCoord.x &&
			Math.abs(Char1Clone.GridCoord.y - GameplayLogic.Character1GridCoord.y) == unitsApart) ||
			(Char1Clone.GridCoord.y == GameplayLogic.Character1GridCoord.y &&
			Math.abs(Char1Clone.GridCoord.x - GameplayLogic.Character1GridCoord.x) == unitsApart)){
				if (direction == "left"){
					if (GameplayLogic.Character1._x < Char1Clone._x){
						leader = GameplayLogic.Character1;
					} else {
						leader = Char1Clone;
					};
				} else if (direction == "right"){
					if (GameplayLogic.Character1._x > Char1Clone._x){
						leader = GameplayLogic.Character1;
					} else {
						leader = Char1Clone;
					};
				} else if (direction == "up"){
					if (GameplayLogic.Character1._y < Char1Clone._y){
						leader = GameplayLogic.Character1;
					} else {
						leader = Char1Clone;
					};
				} else if (direction == "down"){
					if (GameplayLogic.Character1._y > Char1Clone._y){
						leader = GameplayLogic.Character1;
					} else {
						leader = Char1Clone;
					};					
				};			
			};
			
			return leader;
		};
	};
	
	/*
	* As Roombella's clone's movement occurs after Roombella's, in situations where she's moving up or left and the clone is above or to her left respectively, 
	   or Roombella is above and her clone is moving down, movement can't work as intended due to colision. This checks who's the leader and acts accordingly.
	* @param {String} direction The direction the character is traveling: left, right, up, or down. 
	* @param {Number} unitsApart The number of units apart they must be to check for whether or not they're next to each other.
	* @return {MovieClip} Which of the characters is the lead, Roombella or her clone.
	*/ 
	public static function GetChar2Lead(direction:String):MovieClip {
		var leader = null;
		if (Char2Clone != null){
			if (direction == "left" && 
				(GameplayLogic.Character2GridCoord.y == Char2Clone.GridCoord.y)){
				if (GameplayLogic.Character2._x < Char2Clone._x){
					leader = GameplayLogic.Character2;
				} else {
					leader = Char2Clone;
				};
			} else if (direction == "right" &&
				(GameplayLogic.Character2GridCoord.y == Char2Clone.GridCoord.y)){
				if (GameplayLogic.Character2._x > Char2Clone._x){
					leader = GameplayLogic.Character2;
				} else {
					leader = Char2Clone;
				};
			} else if (direction == "up" &&
				(GameplayLogic.Character2GridCoord.x == Char2Clone.GridCoord.x)){
				if (GameplayLogic.Character2._y < Char2Clone._y){
					leader = GameplayLogic.Character2;
				} else {
					leader = Char2Clone;
				};
			} else if (direction == "down" &&
				(GameplayLogic.Character2GridCoord.x == Char2Clone.GridCoord.x)){
				if (GameplayLogic.Character2._y > Char2Clone._y){
					leader = GameplayLogic.Character2;
				} else {
					leader = Char2Clone;
				};					
			};						
			return leader;
		};
	};
	
	/*
	 * In scenarios where Roombella's bounces into her clone or vice-versa, corrects their pathing.
	 * @param {String} direction The direction Roombella and/or her clone are traveling. 
	 */ 
	public static function Char2LeaderCorrection(direction:String):Void {
		var leader = null;
		if (Char2Clone != null){
			// after doing all leader checks and such, set cellToMoveTo of the "follower" to 1 cell BEHIND the leader
			
			if ((Char2Clone.GridCoord.x == GameplayLogic.Character2GridCoord.x && (direction == "up" || direction == "down")) ||
			(Char2Clone.GridCoord.y == GameplayLogic.Character2GridCoord.y && (direction == "left" || direction == "right"))){
				if (direction == "left"){
					if (GameplayLogic.Character2._x < Char2Clone._x){
						leader = GameplayLogic.Character2;
					} else {
						leader = Char2Clone;
					};
				} else if (direction == "right"){
					if (GameplayLogic.Character2._x > Char2Clone._x){
						leader = GameplayLogic.Character2;
					} else {
						leader = Char2Clone;
					};
				} else if (direction == "up"){
					if (GameplayLogic.Character2._y < Char2Clone._y){
						leader = GameplayLogic.Character2;
					} else {
						leader = Char2Clone;
					};
				} else if (direction == "down"){
					if (GameplayLogic.Character2._y > Char2Clone._y){
						leader = GameplayLogic.Character2;
					} else {
						leader = Char2Clone;
					};					
				};			
			};
			
			if (leader != null){				
				if (GameplayLogic.Character2IsMoving && leader == GameplayLogic.Character2){					
					if (!Char2CloneIsMoving){
						Controls.Character2Movement(Controls.GetKeyCodeFromDirection(direction), true, false);
					};
				} else if (Char2CloneIsMoving && leader == Char2Clone){
					if (!GameplayLogic.Character2IsMoving){
						for (var i = 0; i < MapLogic.TimedGateObjects.length; i++){
							if (MapLogic.TimedGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
								MapLogic.TimedGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x &&
								MapLogic.TimedGateObjects[i].status != MapLayouts.Tiles.TimerOpen){
									// absurdly specific situation. This means OG Roombella was directly behind her clone,
									// while OG was in a timed gate. Clone got the go-ahead to move ahead, OG was in a tile
									// that reset. Need to cheat a little and keep gate open for movement to work; otherwise,
									// it'll just launch Roombella into her previous tile... even if that's a wall.
									// potentially not needed anymore...?
									/*MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.TimerOpen;
									MapLogic.LevelTiles[MapLogic.TimedGateObjects[i].GridCoord.y][MapLogic.TimedGateObjects[i].GridCoord.x] = 
									MapLogic.TimedGateObjects[i].status;
									AnimationController.UpdateTimedGateVisual(MapLogic.TimedGateObjects[i], MapLogic.TimedGateObjects[i].status);
									*/ 
								}
						}
						Controls.Character2Movement(Controls.GetKeyCodeFromDirection(direction), false, false);
					};
				};
			};
		};
	};
};