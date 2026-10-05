import flash.display.MovieClip;
import mapCode.MapLogic;
import NGAPI;

/*
 * Manages moment-to-moment gameplay variables and logic.
 */ 
class GameplayLogic {		
	private static var _characterMode:Number = 1;
	private static var _characterSpeed:Number = 12;	
	public static var MovesThisLevel:Number = 0;
	public static var SwitchIndexesAlreadyFlippedDuringChar2Movement = [];
	public static var SwitchIndexesAlreadyFlippedDuringChar2CloneMovement = [];
	public static var Character1;
	public static var Character2;
	public static var Character1GridCoord:Object = null;		
	public static var Character2GridCoord:Object = null;
	public static var Dirt:Array = [];	
	public static var Character1IsMoving:Boolean = false;
	public static var Character2IsMoving:Boolean = false;			
	public static var Char2TravelDirection:String;	
	public static var Char2LaunchGridCoord = null;
	public static var Char2BouncingToPrevCell:Boolean = false;
	public static var Char1InGoal:Boolean = false;
	public static var TimeLevelStarted:Number = null;		
	public static var CappyTouchedGoal = false;
	public static var PlayerSwitchedCharacters = false;
	public static var OffScreenStorage = 2000;		
	public static var ActiveCampaign = 0; // 0 for classic levels, 1 for restaurant
	
	/*
	 * Retrieves the active character.
	 * @param {Number} The active character; 1 if Capy, 2 if Roombella.
	 */
	public static function get CharacterMode():Number {
		return _characterMode;			
	};
	
	/*
	 * Sets the active character.
	 * @param {Number} The active character; 1 if Capy, 2 if Roombella.
	 */
	public static function set CharacterMode(characterMode:Number):Number {
		_characterMode = characterMode;			
	};
	
	/*
	 * Switches the active character.
	 */
	public static function ToggleCharacterMode():Void {
		if (_characterMode == 1){
			_characterMode = 2;
			AnimationController.SpawnVisualEffect("Sparkle", Character2._x + (GameplayLogic.Character2._width * 3), 
				Character2._y + (Character2._height * 3));
		} else if (_characterMode == 2){
			_characterMode = 1;
			AnimationController.SpawnVisualEffect("Sparkle", Character1._x + (GameplayLogic.Character1._width * 3), 
				Character1._y + (Character1._height * 3));
		};
	};			
	
	/*
	 * Handles functionality to initialize the campaign.
	 */ 
	public static function BeginCampaign():Void {
		var campaignLvl:Number = 0;
		var campaignList:Array = null;
		
		if (ActiveCampaign == 0){
			campaignLvl = MapLogic.CurrentCampaignLvlNum;
			campaignList = MapLayouts.Campaign;
		} else {
			campaignLvl = DLCLevelLogic.CurrentDLCCampaignLvlNum;
			campaignList = MapLayouts.DLCCampaign; 
			SecondaryDialogue.PlayedDLCCrashCutscene = false;
			SecondaryDialogue.PlayedDLCLabCutscene = false;
			SecondaryDialogue.PlayedDLCRobotCutscene = false;
		};
		
		
		if (campaignLvl == null ||
			campaignLvl >= campaignList.length){
			if (ActiveCampaign == 0){
				MapLogic.CurrentCampaignLvlNum = 0;
			} else {
				DLCLevelLogic.CurrentDLCCampaignLvlNum = 0;
			};
		};
		
		if (ActiveCampaign == 0){
			if (MapLogic.DirtCleaned == null){
				MapLogic.InitDirtTracking();
			};		
		} else {
			if (DLCLevelLogic.DLCDirtCleaned == null){
				DLCLevelLogic.InitDLCDirtTracking();
			};
		};
		
		if (ActiveCampaign == 0){
			if (MapLogic.MovesInAllLevels == null){
				MapLogic.InitMovesInAllLevels();
			};
		} else {
			if (DLCLevelLogic.MovesInAllDLCLevels == null){
				DLCLevelLogic.InitMovesInAllDLCLevels();
			};
		};
		
		UI.PreventInput = true;
		UI.EnableCampaignGameplayButtons(false);
		UI.MoveDialogueWindowToCenter();			
		TransitionLogic.BeginCampaignTransition();
	};
	
	/*
	 * Runs each frame during gameplay. Manages Roombella's movement functionality.
	 * @param {Boolean} forClone Whether the movement is being managed for Roombella or her clone.
	 */ 
	private static function RoombellaMovingFunctionality(forClone:Boolean):Void {
		var char2MC;
		var targetCell;
		var movingCheck;
		var travelDirection;
		var launchGridCoord;

		if (!forClone){
			char2MC = Character2;
			targetCell = MapLogic.CellToMoveTo;				
			launchGridCoord = GameplayLogic.Char2LaunchGridCoord;
			_moveObjectTowardsTargetObject(char2MC, targetCell);
			movingCheck = Character2IsMoving;
			travelDirection = Char2TravelDirection;
		} else {
			char2MC = DLCTileLogic.Char2Clone;
			targetCell = DLCTileLogic.Char2CloneCellToMoveTo;				
			launchGridCoord = DLCTileLogic.Char2CloneLaunchGridCoord;
			_moveCloneTowardsTarget(char2MC, targetCell);
			movingCheck = DLCTileLogic.Char2CloneIsMoving;
			travelDirection = DLCTileLogic.Char2CloneTravelDirection;
		};
		
		for (var i = 0; i < Dirt.length; i++){			
			if (Dirt[i].cell.hitTest(char2MC)){ // this check to verify that an adjacent cell wasn't mistakenly caught in hit test	
				if (_dirtCollisionWChar2Verification(Dirt[i], targetCell, char2MC, travelDirection) == true){
					MapLogic.LevelTiles[Dirt[i].loc.x][Dirt[i].loc.y] = 0;
					MapLogic.AllCells[Dirt[i].loc.x][Dirt[i].loc.y].gotoAndStop(1);					
					Dirt.splice(i, 1);
					if (char2MC.onEnterFrame == null){
						char2MC.gotoAndStop(char2MC._currentframe + 4);
						AnimationController.RoombellaFrameHold = getTimer() + 1000;
						char2MC.onEnterFrame = function(){
							AnimationController.HoldRoombellaWink();
						};
					};
					break; // because more than 1 cell cannot be hit per frame!
				};
			};
		};
		
		for (var i = 0; i < MapLogic.ABCSwitchObjects.length; i++){
			if (MapLogic.ABCSwitchObjects[i].cell.hitTest(char2MC)){
				var switchAlreadyHit:Boolean = false;
				
				for (var j = 0; j < SwitchIndexesAlreadyFlippedDuringChar2Movement.length; j++ ){
					if (SwitchIndexesAlreadyFlippedDuringChar2Movement[j] == i && !forClone){
						switchAlreadyHit = true;
					};
				};
				
				for (var j = 0; j < SwitchIndexesAlreadyFlippedDuringChar2CloneMovement.length; j++ ){
					if (SwitchIndexesAlreadyFlippedDuringChar2CloneMovement[j] == i && forClone){
						switchAlreadyHit = true;
					};
				};
				
				if (!switchAlreadyHit && movingCheck){
					if (!forClone){
						SwitchIndexesAlreadyFlippedDuringChar2Movement.push(i);
					} else {
						SwitchIndexesAlreadyFlippedDuringChar2CloneMovement.push(i);
					};						
					
					MapLogic.ABCSwitchObjects[i].status = MapLogic.GetNextCharInABCSequence(MapLogic.ABCSwitchObjects[i].status);
					MapLogic.UnlockAllABCGatesOfType(MapLogic.ABCSwitchObjects[i].status);
					DLCTileLogic.UnlockAllABCCagesNotOfType(MapLogic.ABCSwitchObjects[i].status);
					DLCTileLogic.TriggerABCCagesWithCharacters(MapLogic.ABCSwitchObjects[i].status, 2, forClone, 
						launchGridCoord.x, launchGridCoord.y);
					MapLogic.LockAllABCGatesNotOfType(MapLogic.ABCSwitchObjects[i].status, forClone);	
					AnimationController.UpdateAllABCSwitchesAndGates();		
					AnimationController.UpdateAllABCCages();
					return;
				};
			};
		};
		
		// it's possible that a gate can be thrown up *while* char2 is moving; this accounts for that
		for (var i = 0; i < MapLogic.ABCGateObjects.length; i++){
			if (MapLogic.ABCGateObjects[i].cell.hitTest(char2MC)){
				if (MapLogic.ABCGateObjects[i].status.indexOf("_closed") != -1){ // hit gate that *should* be closed
					// checking that the ABC Gate is before the target cell AND that Roombella is actually clipping into the gate to force a pushback
					// the or statement is to also catch an edge case where the ABC Gate is directly next to a wall. I.e. if Roombella's target was the cell 
					// before the wall BUT that target is now a closed block, need to push her back to before it!
					if ((_isCellBeforeTarget(travelDirection, targetCell, 
						MapLogic.AllCells[MapLogic.ABCGateObjects[i].GridCoord.y][MapLogic.ABCGateObjects[i].GridCoord.x]) &&
						_isCellBeforeTarget(travelDirection, 
							MapLogic.AllCells[MapLogic.ABCGateObjects[i].GridCoord.y][MapLogic.ABCGateObjects[i].GridCoord.x], char2MC)) ||
						targetCell == MapLogic.AllCells[MapLogic.ABCGateObjects[i].GridCoord.y][MapLogic.ABCGateObjects[i].GridCoord.x]){						
							// if roombella and her clone are right next to each other in line, don't want them to target same tile
							
							_setChar2GridCoordAndTargetAsPrevCell(travelDirection, MapLogic.ABCGateObjects[i], forClone);									
					};
				};
			};					
		};	
		
		// very situational/obscure but a timed gate can be thrown up during gameplay as well
		var timedGateBounceBack:Boolean = false;
		for (var i = 0; i < MapLogic.TimedGateObjects.length; i++){
			if (MapLogic.TimedGateObjects[i].cell.hitTest(char2MC)){
				if (MapLogic.TimedGateObjects[i].status != MapLayouts.Tiles.TimerOpen){ // hit timer that *should* be closed					
					if (_isCellBeforeTarget(travelDirection, targetCell, 
						MapLogic.AllCells[MapLogic.TimedGateObjects[i].GridCoord.y][MapLogic.TimedGateObjects[i].GridCoord.x]) &&
						_isCellBeforeTarget(travelDirection, 
							MapLogic.AllCells[MapLogic.TimedGateObjects[i].GridCoord.y][MapLogic.TimedGateObjects[i].GridCoord.x], char2MC)){
						// if roombella and her clone are right next to each other in line, don't want them to target same tile
						
						if (!timedGateBounceBack){
							_setChar2GridCoordAndTargetAsPrevCell(travelDirection, MapLogic.TimedGateObjects[i], forClone);	
							timedGateBounceBack = true;
						};
					} else if (MapLogic.TimedGateObjects[i].cell._y == targetCell._y &&
							MapLogic.TimedGateObjects[i].cell._x == targetCell._x){
						// in certain scenarios (i.e. if this closed gate in question is next to a wall block),
						// and it WAS open when roombella first set off, this closed gate will be set as roombella's destination
						
						if (!timedGateBounceBack){
							_setChar2GridCoordAndTargetAsPrevCell(travelDirection, MapLogic.TimedGateObjects[i], forClone);	
							timedGateBounceBack = true;
						};
					};
				};
			};					
		};	
		
		// very rare/obscure scenario where roombella can be bounced backwards into a gate already closed (ie two "1" gates next to each other)
		// also don't love running this here for performance reasons, but it needs to be outside the loop above
		// just in case the gate that's opening comes afterwards in the loop, meaning it'll just be closed again
		for (var i = 0; i < MapLogic.TimedGateObjects.length; i++){
			if (!forClone && MapLogic.TimedGateObjects[i].status != MapLayouts.Tiles.TimerOpen &&
				MapLogic.TimedGateObjects[i].GridCoord.y == GameplayLogic.Character2GridCoord.y &&
				MapLogic.TimedGateObjects[i].GridCoord.x == GameplayLogic.Character2GridCoord.x && 
				timedGateBounceBack == true){
					MapLogic.TimedGateObjects[i].status = MapLayouts.Tiles.TimerOpen;
					MapLogic.LevelTiles[MapLogic.TimedGateObjects[i].GridCoord.y][MapLogic.TimedGateObjects[i].GridCoord.x] = 
					MapLogic.TimedGateObjects[i].status;
					AnimationController.UpdateTimedGateVisual(MapLogic.TimedGateObjects[i], MapLogic.TimedGateObjects[i].status);					
			} else if (forClone && MapLogic.TimedGateObjects[i].status != MapLayouts.Tiles.TimerOpen &&
				MapLogic.TimedGateObjects[i].GridCoord.y == DLCTileLogic.Char2Clone.GridCoord.y &&
				MapLogic.TimedGateObjects[i].GridCoord.x == DLCTileLogic.Char2Clone.GridCoord.x && 
				timedGateBounceBack == true){
					AnimationController.SpawnDestroyAnimationOfSpecificCloneAtGridCoord(2, MapLogic.TimedGateObjects[i].GridCoord.x, 
						MapLogic.TimedGateObjects[i].GridCoord.y);
					DLCTileLogic.DestroyClone(2);
				};
		};
		
		for (var i = 0; i < MapLogic.ABCCageObjects.length; i++){
			if (MapLogic.ABCCageObjects[i].cell.hitTest(char2MC)){
				var canTrap = false;
				if (DLCTileLogic.Char2CheckCageAtCoordIsReadyToSpring(MapLogic.ABCCageObjects[i].GridCoord.x, MapLogic.ABCCageObjects[i].GridCoord.y)){
					// confirmed ready to spring
					DLCTileLogic.CheckCageAtCoordIsReadyToSpring(MapLogic.ABCCageObjects[i].GridCoord.x, MapLogic.ABCCageObjects[i].GridCoord.y);
					DLCTileLogic.RoombellaTrappedAtLeastOnce = true;
					if (_isCellBeforeTarget(travelDirection, targetCell, MapLogic.AllCells[MapLogic.ABCCageObjects[i].GridCoord.y][MapLogic.ABCCageObjects[i].GridCoord.x])){
						canTrap = true;
					};
					// accounting for scenarios where the clone targeted an abc cage that closes AND is their target cell
					if (forClone && (targetCell == MapLogic.AllCells[MapLogic.ABCCageObjects[i].GridCoord.y][MapLogic.ABCCageObjects[i].GridCoord.x])){
						canTrap = true;
					}
					if (canTrap){
						if (!forClone){
							GameplayLogic.Character2GridCoord.x = MapLogic.ABCCageObjects[i].GridCoord.x;
							GameplayLogic.Character2GridCoord.y = MapLogic.ABCCageObjects[i].GridCoord.y;
							MapLogic.CellToMoveTo = MapLogic.AllCells[MapLogic.ABCCageObjects[i].GridCoord.y][MapLogic.ABCCageObjects[i].GridCoord.x];
						} else {															
							AnimationController.SpawnDestroyAnimationOfSpecificCloneAtGridCoord(2, MapLogic.ABCCageObjects[i].GridCoord.x, 
								MapLogic.ABCCageObjects[i].GridCoord.y);
							SoundManager.PlaySound(SoundManager.SoundLibraryEnum.CloneDeath);
							DLCTileLogic.DestroyClone(2);
						};
					};
				};
			};					
		};	
		
		for (var i = 0; i < MapLogic.PortalObjects.length; i++){
			if (MapLogic.PortalObjects[i].cell.hitTest(char2MC) && !(MapLogic.PortalObjects[i].GridCoord.x == launchGridCoord.x &&
				MapLogic.PortalObjects[i].GridCoord.y == launchGridCoord.y) && 
					!DLCTileLogic.IsCharacterInCorrespondingPortal(MapLogic.PortalObjects[i].status, MapLogic.PortalObjects[i].GridCoord.x, 
					MapLogic.PortalObjects[i].GridCoord.y)){
					var portalToGoTo = DLCTileLogic.GetCorrespondingPortal(MapLogic.PortalObjects[i].status, MapLogic.PortalObjects[i].GridCoord.x, 
						MapLogic.PortalObjects[i].GridCoord.y);
						
				var onSameLaneBeforeTeleport:Boolean = (DLCTileLogic.GetChar2Lead(GameplayLogic.Char2TravelDirection) != null ||
					DLCTileLogic.GetChar2Lead(DLCTileLogic.Char2CloneTravelDirection) != null);	
				if (!forClone){							
					MapLogic.CellToMoveTo = MapLogic.AllCells[portalToGoTo.gridCoord.y][portalToGoTo.gridCoord.x];
					char2MC._x = portalToGoTo.cell._x;
					char2MC._y = portalToGoTo.cell._y;
					GameplayLogic.Character2GridCoord.x = portalToGoTo.GridCoord.x;						
					GameplayLogic.Character2GridCoord.y = portalToGoTo.GridCoord.y;	
					GameplayLogic.Character2IsMoving = false;
					GameplayLogic.Char2TravelDirection = null;
					Char2BouncingToPrevCell = false;
					AnimationController.ManageCharacterCursorAnimation();
				} else {
					DLCTileLogic.Char2CloneCellToMoveTo = MapLogic.AllCells[portalToGoTo.gridCoord.y][portalToGoTo.gridCoord.x];
					DLCTileLogic.Char2Clone._x = portalToGoTo.cell._x;
					DLCTileLogic.Char2Clone._y = portalToGoTo.cell._y;
					DLCTileLogic.Char2Clone.GridCoord.x = portalToGoTo.GridCoord.x;	
					DLCTileLogic.Char2Clone.GridCoord.y = portalToGoTo.GridCoord.y;	
					DLCTileLogic.Char2CloneIsMoving = false;
					DLCTileLogic.Char2CloneBouncingBackToPrevCell = false;
					DLCTileLogic.Char2CloneTravelDirection = null;
				};
				AnimationController.TeleportVisuals(2, MapLogic.PortalObjects[i].cell, portalToGoTo.cell);
				SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Teleport);
				
				/* For extremely obscure situations where char2 clone or char2 OG are on the same line, heading
				 to the same teleporter. after one teleports, the other must have their target destination
				 re-oriented, or else they'll continue on the path targeting the same tile they were when the
				 other was in front of them. The checks for getCharLead are to make sure they're actually both on the
				 same lane.*/
				if (DLCTileLogic.Char2Clone != null && onSameLaneBeforeTeleport){
					if (forClone){
						// if forClone, want to re-orient OG roombella and vice-versa
						Controls.Character2Movement(Controls.GetKeyCodeFromDirection(travelDirection), false, true);						
					} else {
						Controls.Character2Movement(Controls.GetKeyCodeFromDirection(travelDirection), true, true);
					};
				};
				
				return;
			} else if (DLCTileLogic.CheckIfCharInCorrespondingPortal(2, forClone, MapLogic.PortalObjects[i].status, MapLogic.PortalObjects[i].GridCoord.x, 
					MapLogic.PortalObjects[i].GridCoord.y)){
					/* just checking if the teleport anim should play if the character's already sitting on the target portal, this only occurs
					 when 2 portals are directly next to each other. this is to give the illusion the player is moving even if they're not, 
					 just a little qol thing*/
					var portalToGoTo = DLCTileLogic.GetCorrespondingPortal(MapLogic.PortalObjects[i].status, MapLogic.PortalObjects[i].GridCoord.x, 
					MapLogic.PortalObjects[i].GridCoord.y);	
					if (!DLCTileLogic.IsAnyCharacterAtGridCoord(portalToGoTo.GridCoord.x, portalToGoTo.GridCoord.y) &&
					((!forClone && !GameplayLogic.Character2IsMoving) || (forClone && !DLCTileLogic.Char2CloneIsMoving))){
						AnimationController.TeleportVisuals(2, MapLogic.PortalObjects[i].cell, portalToGoTo.cell);
						SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Teleport);
					};				
			};
		};
		
		for (var i = 0; i < MapLogic.ClonerObjects.length; i++){
			if (MapLogic.ClonerObjects[i].cell.hitTest(char2MC) && !(MapLogic.ClonerObjects[i].GridCoord.x == launchGridCoord.x &&
				MapLogic.ClonerObjects[i].GridCoord.y == launchGridCoord.y) && DLCTileLogic.Char2Clone == null & !forClone){
					DLCTileLogic.CreateClone(2, {x: MapLogic.ClonerObjects[i].GridCoord.x, y: MapLogic.ClonerObjects[i].GridCoord.y});						
					_setChar2GridCoordAndTargetAsPrevCell(travelDirection, MapLogic.ClonerObjects[i], forClone);	
					return;							
			};
		};
		
		if (DLCTileLogic.Char2Clone != null){
			// preventing visual overlap bug
			if (Character2.hitTest(DLCTileLogic.Char2Clone)){
				var lead = DLCTileLogic.GetChar2Lead(travelDirection);
				var intendedCloseCell = null;
				var intendedFarCell = null;
				var canProceedWithChangeOfCourse:Boolean = false;
				var Char2GridObj = null;
				/* if Char2 and her clone collide, a wall must've gone up somehow while they were traveling.
				 * If char2 is the lead, its implied that her targetcell should be farther than the clone's and vice-versa. 
				*/
				if (lead == Character2){
					intendedCloseCell = DLCTileLogic.Char2CloneCellToMoveTo;					
					intendedFarCell = MapLogic.CellToMoveTo;	
					Char2GridObj =  {x: Character2GridCoord.x, y: Character2GridCoord.y};
				} else if (lead == DLCTileLogic.Char2Clone){
					intendedCloseCell = MapLogic.CellToMoveTo;
					intendedFarCell = DLCTileLogic.Char2CloneCellToMoveTo;					
					Char2GridObj = {x: DLCTileLogic.Char2Clone.GridCoord.x, y: DLCTileLogic.Char2Clone.GridCoord.y};					
				};
				
				var Char2ParentObj = {GridCoord: Char2GridObj}; // just a gridcoord obj for char2gridcoord, for easier processing in existing funcs
				if (lead != null && ((forClone && !DLCTileLogic.Char2CloneBouncingBackToPrevCell) ||
						(!forClone && !Char2BouncingToPrevCell))){
					if (travelDirection == "right"){
						if (intendedCloseCell._x > intendedFarCell._x){
							canProceedWithChangeOfCourse = true;							
							};
					} else if (travelDirection == "left"){
						if (intendedCloseCell._x < intendedFarCell._x){
							canProceedWithChangeOfCourse = true;	
						};
					} else if (travelDirection == "up"){
						if (intendedCloseCell._y < intendedFarCell._y){
							canProceedWithChangeOfCourse = true;
						};
					} else if (travelDirection == "down"){
						if (intendedCloseCell._y > intendedFarCell._y){
							canProceedWithChangeOfCourse = true;								
						};
					};
					
					// adding on 8/6/24 to compensate for bug where RB and clone can have the same target cell even 
					// after bouncing back, i.e. if RB is directly behind clone while they're traveling right, and clone
					// bumps into a closing gate. Whoever is NOT the lead should bounce backwards.
					if (DLCTileLogic.Char2CloneCellToMoveTo == MapLogic.CellToMoveTo){
						if (!canProceedWithChangeOfCourse){ // if not already trying to change target
							if (lead == Character2){
								_setChar2BouncingBack(true);
								_setChar2GridCoordAndTargetAsPrevCell(travelDirection, Char2ParentObj, true);
							} else {
								_setChar2BouncingBack(false);
								_setChar2GridCoordAndTargetAsPrevCell(travelDirection, Char2ParentObj, false);
							};
						};
					};					
					
					if (canProceedWithChangeOfCourse){
						if (lead == Character2){
							_setChar2BouncingBack(true);
							_setChar2GridCoordAndTargetAsPrevCell(travelDirection, Char2ParentObj, true);
						} else if (lead == DLCTileLogic.Char2Clone){
							_setChar2BouncingBack(false);
							_setChar2GridCoordAndTargetAsPrevCell(travelDirection, Char2ParentObj, false);
						};
					};
				};						
			};
		};		
	};
	
	/*
	 * Should only be used for the last section of Roombella's movement. Sets variable for if a character is bouncing
	   back to a previous cell after launching.
	 *@param {Boolean} forClone Whether or not this is for Roombella or her clone.
	 */ 
	private static function _setChar2BouncingBack(forClone:Boolean):Void {
		if (forClone){
			DLCTileLogic.Char2CloneBouncingBackToPrevCell = true;
		} else {
			Char2BouncingToPrevCell = true;
		};
	};
	
	/* 
	 * Manages logic checks for each frame.
	 */ 
	public static function MainGameplayLoop():Void {
		// NOT a fantastic place for this, but it can be possible for both char1 and char1clone to be moving at same time		
		if (DLCTileLogic.Char1CloneIsMoving){
			_moveCloneTowardsTarget(DLCTileLogic.Char1Clone, DLCTileLogic.Char1CloneCellToMoveTo);
		};
		
		if (DLCTileLogic.Char2CloneIsMoving){
			RoombellaMovingFunctionality(true);
		};
		
		if (Character1IsMoving) {
			_moveObjectTowardsTargetObject(Character1, MapLogic.CellToMoveTo);
		} else if (Character2IsMoving) {
			RoombellaMovingFunctionality(false);
		} else {// neither character is moving				
			if (_root._currentframe == FrameNavigation.Campaign){
				
				// JUST FOR TESTING
				//GameplayLogic.Char1InGoal = true;
				// END OF JUST FOR TESTING
				
				
				if (Char1InGoal){
					if (!_root.campaignNextLvlBtn){
						if (!UI.PreventInput){
							var campaignNxtLvl = _root.attachMovie("campaignNextLvlBtn", "campaignNextLvlBtn", _root.getNextHighestDepth());
							campaignNxtLvl._x = 997.8;
							campaignNxtLvl._y = 183.7;
							campaignNxtLvl.onPress = MapLogic.NextCampaignLvl;
							AnimationController.SpawnVisualEffect("Sparkle", campaignNxtLvl._x, campaignNxtLvl._y);
							_root.SparkleInstc._width = _root.SparkleInstc._width * 2;
							_root.SparkleInstc._height = _root.SparkleInstc._height * 2;
							SoundManager.PlaySound(SoundManager.SoundLibraryEnum.NextLevel);
						};
					};
				} else {
					if (_root.campaignNextLvlBtn){
						_root.campaignNextLvlBtn.removeMovieClip();
					};
				};
				TransitionLogic.TransitionFunctionality();			
			} else if (_root._currentframe == FrameNavigation.LevelEditorPreview){
				if (Char1InGoal){
					if (LevelEditorLogic.LoadedLevelMadeByUser && com.newgrounds.SaveFile.currentFile.group.name == "Custom Levels" &&
						NGAPI.CurrentlySavingUserLevelForFirstTime == false){
						_root.updateNGAPILevel._x = 996.6;
					} else if (LevelEditorLogic.LoadedLevelMadeByUser && NGAPI.CurrentlySavingUserLevelForFirstTime &&
						(!NGAPI.LoadedLevelFromUserCreationsOnNG || !NGAPI.LoadedLevelFromUserCreationsOnNG == undefined)) {							
						UI.ShowedOwnLevelCompletedPopup = true; // not a great place for this but want to make sure the 
						//pop-up doesn't show after submitting level 
						_root.submitToNGAPIButton._x = 996.6;							
					} else if (com.newgrounds.SaveFile.currentFile.group.name == "Custom Levels" ||
							NGAPI.LoadedLevelFromUserCreationsOnNG){
						if ((com.newgrounds.API.userId != undefined) && 
						(com.newgrounds.API.userId != null) &&
						(com.newgrounds.API.userId != 0) &&
						NGAPI.LoadedLevelAuthorId != undefined && 
						NGAPI.LoadedLevelAuthorId != NGAPI.CurrentPlayerId){
							_root.VoteBarInstc._x = (Stage.width / 2) - (_root.VoteBarInstc._width / 2);
							_root.VoteBarInstc._y = (Stage.height / 2) - (_root.VoteBarInstc.height / 2);
						} else if (NGAPI.LoadedLevelAuthorId == NGAPI.CurrentPlayerId){
							if (!UI.ShowedOwnLevelCompletedPopup){
								UI.ShowedOwnLevelCompletedPopup = true;
								var clearChar1InGoalOnExit = function() {
									GameplayLogic.Char1InGoal = false;
								};
								// ^ need this to fix obscure bug where a user could beat their own level, go back to level search, 
								// select their level, and have this popup immediately show up; shown here at 0:17: 
								// https://www.youtube.com/watch?v=k-OMYcNbL0M
								
								UI.CreateBackToMenuPopup("Congrats, you beat your own level!", "Go back to menu?", true, clearChar1InGoalOnExit);
							};
						};
					};
				} else {
					UI.ShowedOwnLevelCompletedPopup = false;
				};
			};				
			_dialogueFunctionsInGameplayLoop();
		};			
	};
	
	/*
	 * Manages dialogue functionality in the main gameplay loop, including primary dialogue, secondary dialogue, and hints.
	 */ 
	private static function _dialogueFunctionsInGameplayLoop():Void {
		if (getTimer() >= TimeLevelStarted + DialogueManager.StartDialogueDelay ||
			UI.InPostSceneDialogue){
			if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.auto){
				if (!DialogueManager.DialogueComplete && (DialogueManager.DialogueArray.length != 0)){					
					DialogueManager.WriteDialogueToTextbox();				
				} else if (DialogueManager.DialogueArray.length == 0){
					_root.charWindowTxtBox.text = "-";
					_root.charDialogueTxtBox.text = "-";
					DialogueManager.DialogueComplete = true;	
				};
			};
		};
		
		if (_root._currentframe == FrameNavigation.Campaign){
			var forDLC:Boolean = false;
			var curLvl = MapLogic.CurrentCampaignLvlNum;
			if (ActiveCampaign == 1){
				forDLC = true;
				curLvl = DLCLevelLogic.CurrentDLCCampaignLvlNum;
			};
			DialogueManager.writeSecondaryDialogueToTextBox(false, SecondaryDialogue.GetAddtlDialogue(forDLC, curLvl));
			if (Settings.displayHints){
				var hintsArray = HintSystem.CampaignHints[curLvl];
				if (ActiveCampaign == 1){
					hintsArray = HintSystem.DLCCampaignHints[curLvl];
				};
				
				DialogueManager.writeSecondaryDialogueToTextBox(true, hintsArray);
			};
		};
	};
		
	/*
	 * Moves a character's MovieClip towards another MovieClip. Mainly used for player control functionality.
	 * @param {MovieClip} character The character to move to the destination.
	 * @param {MovieClip} destination The MovieClip the character is moving towards.
	 */ 
	private static function _moveObjectTowardsTargetObject(character, destination):Void {
		if (Character1IsMoving == true || Character2IsMoving == true) {			
			var distanceX:Number = destination._x - character._x;
			var distanceY:Number = destination._y - character._y;
			if ((distanceX * distanceX + distanceY * distanceY < _characterSpeed * _characterSpeed)) {
				character._x = destination._x;
				character._y = destination._y;					
				Character1IsMoving = false;
				Character2IsMoving = false;
				SwitchIndexesAlreadyFlippedDuringChar2Movement = [];
				SwitchIndexesAlreadyFlippedDuringChar2CloneMovement = [];
				Char2LaunchGridCoord = null;
				Char2TravelDirection = null;
				Char2BouncingToPrevCell = false;
				SoundManager.playedABCGateUnlockThisTurn = false;
				SoundManager.playedABCCageLatchThisTurn = false;
			} else { // we're moving!
				var angleRads:Number = Math.atan2(distanceY, distanceX);
				var velocityX:Number = Math.cos(angleRads) * _characterSpeed;
				var velocityY:Number = Math.sin(angleRads) * _characterSpeed;
				
				character._x += velocityX;
				character._y += velocityY;
			};
			AnimationController.ManageCharacterCursorAnimation();
		};
	};
	
	// finish documentation
	/*
	 * Moves a character's clone towards its intended destination.
	 * @param {MovieClip} character The clone to be moved.
	 * @param {MovieClip} destination the destination to move to.
	 */ 
	private static function _moveCloneTowardsTarget(character, destination):Void {
		if (DLCTileLogic.Char1CloneIsMoving || DLCTileLogic.Char2CloneIsMoving) {			
			var distanceX:Number = destination._x - character._x;
			var distanceY:Number = destination._y - character._y;
			
			if ((distanceX * distanceX + distanceY * distanceY < _characterSpeed * _characterSpeed)) {
				character._x = destination._x;
				character._y = destination._y;	
				if (DLCTileLogic.Char1CloneIsMoving){
					DLCTileLogic.Char1CloneIsMoving = false;
				} else if (DLCTileLogic.Char2CloneIsMoving){
					SwitchIndexesAlreadyFlippedDuringChar2CloneMovement = [];
					DLCTileLogic.Char2CloneLaunchGridCoord = null;
					DLCTileLogic.Char2CloneIsMoving = false;
					DLCTileLogic.Char2CloneTravelDirection = null;
					DLCTileLogic.Char2CloneBouncingBackToPrevCell = false;
				};
				SoundManager.playedABCGateUnlockThisTurn = false;
				SoundManager.playedABCCageLatchThisTurn = false;
			} else { // we're moving!
				var angleRads:Number = Math.atan2(distanceY, distanceX);
				var velocityX:Number = Math.cos(angleRads) * _characterSpeed;
				var velocityY:Number = Math.sin(angleRads) * _characterSpeed;
				
				character._x += velocityX;
				character._y += velocityY;
			};
		};
	};
	
	/*
	 * Checks if a cell is before the targetCell.
	 * @param {String} direction The direction the function is checking for. Should be left, right, up, or down.
	 * @param {MovieClip} targetCell The cell to use as reference.
	 * @param {MovieClip} cellToCheck The cell to check whether it's before or after the target.
	 */ 
	private static function _isCellBeforeTarget(travelDirection:String, targetCell, cellToCheck):Boolean {
		trace("in isCellBeforeTraget. Tarvel dir: " + travelDirection + ", targCell: " + targetCell + ", cellTocheck: " + cellToCheck);
		if (travelDirection == "right" && targetCell._x > cellToCheck._x){
			return true;
		} else if (travelDirection == "left" && targetCell._x < cellToCheck._x){
			return true;
		} else if (travelDirection == "down" && targetCell._y > cellToCheck._y){
			return true;
		} else if (travelDirection == "up" && targetCell._y < cellToCheck._y){
			return true;
		} else {
			return false;
		};
	};
	
	/*
	 * Retrieves the Grid Coord directly before the one the targetObj is set at.
	 * @param {String} direction The direction the function is checking for. Should be left, right, up, or down.
	 * @param {targetObj} The object that will have its Grid Coord checked.
	 */ 
	public static function GetPrevGridCoord(travelDirection:String, targetObj:Object){
		var xGridCoordAddition = 0;
		var yGridCoordAddition = 0;
		if (travelDirection == "right"){
			xGridCoordAddition = -1;
		} else if (travelDirection == "left"){
			xGridCoordAddition = 1;
		} else if (travelDirection == "up"){
			yGridCoordAddition = 1;
		} else if (travelDirection == "down"){
			yGridCoordAddition = -1;
		};
		var GridCoord = {};
		GridCoord.x = targetObj.GridCoord.x + xGridCoordAddition;
		GridCoord.y = targetObj.GridCoord.y + yGridCoordAddition;
		return GridCoord;
	}
	
	/*
	 * Gets the tile directly after the one at a given Grid coordinate.
	 * @param {String} direction The direction the function is checking for. Should be left, right, up, or down.
	 * @param {Number} xVal The X coordinate to reference to get the next tile.
	 * @param {Number} yVal The Y coordinate to reference to get the next tile.
	 */ 
	public static function GetNextTile(travelDirection:String, xVal:Number, yVal:Number){
		var xGridCoordAddition = 0;
		var yGridCoordAddition = 0;
		if (travelDirection == "right"){
			xGridCoordAddition = 1;
		} else if (travelDirection == "left"){
			xGridCoordAddition = -1;
		} else if (travelDirection == "up"){
			yGridCoordAddition = -1;
		} else if (travelDirection == "down"){
			yGridCoordAddition = 1;
		};
		var GridCoord = {};
		GridCoord.x = xVal + xGridCoordAddition;
		GridCoord.y = yVal + yGridCoordAddition;
		return MapLogic.LevelTiles[GridCoord.y][GridCoord.x];			
	};
	
	/*
	 * Used for very specific scenarios where Roombella's grid coord and target needs to be set as her previous cell. Usually
	   used for bouncing back when she's hit a wall/barrier of some kind while traveling.
	 * @param {String} travelDirection The direction Roombella is moving. Should be left, right, up, or down.
	 * @param {Object} targetObj The object she is currently targeting. 
	 * @param {Boolean} forClone Whether or not this is for a clone.
	 */ 
	private static function _setChar2GridCoordAndTargetAsPrevCell(travelDirection:String, targetObj:Object, forClone:Boolean):Void {
		var gridVals = GetPrevGridCoord(travelDirection, targetObj);	
		
		if (!forClone){			
			GameplayLogic.Character2GridCoord.x = gridVals.x;
			GameplayLogic.Character2GridCoord.y = gridVals.y;
			MapLogic.CellToMoveTo = MapLogic.AllCells[gridVals.y][gridVals.x];
		} else {
			DLCTileLogic.Char2Clone.GridCoord.x = gridVals.x;
			DLCTileLogic.Char2Clone.GridCoord.y = gridVals.y;
			DLCTileLogic.Char2CloneCellToMoveTo = MapLogic.AllCells[gridVals.y][gridVals.x];
		};
	};
	
	/*
	 * Manages checks for character 2's collision with dirt tiles. Thorough logic
	   tests are needed because hitTest functionality will often mistakenly catch adjacent tiles.
	 * @param {MovieClip} dirtTile The tile to verify for collision. 
	 * @param {MovieClip} targetCell The cell that Roombella is currently targetting.
	 * @param {MovieClip} char2MC The MovieClip for whichever Roombella is in question; the OG or the clone.
	 * @return {Boolean} True if character 2 (Roombella) collided with the dirt. False otherwise.
	 */ 
	private static function _dirtCollisionWChar2Verification(dirtTile:Object, targetCell, char2MC, travelDirection):Boolean {		
		if (travelDirection == "left"){
			if ((targetCell._y == dirtTile.cell._y) && 
				(targetCell._y == char2MC._y) && 
				(dirtTile.cell._x < char2MC._x)){
					return true;
				};			
		} else if (travelDirection == "right"){
			if ((targetCell._y == dirtTile.cell._y) && 
				(targetCell._y == char2MC._y) &&
				(dirtTile.cell._x  > char2MC._x)){
				return true;
				};
		} else if (travelDirection == "up"){
			if ((targetCell._x == dirtTile.cell._x) && 
				(targetCell._x == char2MC._x) &&
				(dirtTile.cell._y < char2MC._y)){
					return true;
				};
		} else if (travelDirection == "down"){
			if ((targetCell._x == dirtTile.cell._x) && 
				(targetCell._x == char2MC._x) &&
				(dirtTile.cell._y > char2MC._y)){
					return true;
				};
		};		
		return false;
	};
	
	/*
	 * Executed when the user submits their custom level. 
	 * @param {APIEvent} event The event object containing contextual information from the event listener.
	 */ 
	public static function OnLevelSubmitted(event):Void {
		_root.NGAPILoadingPopup._x = OffScreenStorage;	
		
		if (event.success){
			_root.NGAPIFileSavedPopup._x = Stage.width / 2;	
			UI.AssignFunctionToNavigationBtns(_root.NGAPIFileSavedPopup.MainMenuBtn, MapLogic.ClearCurrentMap);
			LevelEditorLogic.ClearLevelEditorProperties();		
			NGAPI.LoadedLevelAuthorId = null;
		} else {
			_root.NGAPIFileNotSavedPopupInstc._x = Stage.width / 2;
			_root.NGAPIFileNotSavedPopupInstc.onPress = function(){
				_root.NGAPIFileNotSavedPopupInstc._x = OffScreenStorage;
			};
			NGAPI.LoadedLevelAuthorId = null;
		};
		UI.PreventInput = false;
		NGAPI.CurrentlySavingUserLevelForFirstTime = false;
	};		
};
