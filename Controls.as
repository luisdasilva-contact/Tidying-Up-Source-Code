
import flash.events.KeyboardEvent;
import gameplayCode.GameplayLogic;
import mapCode.MapLogic;
import flash.display.MovieClip;
import frameNavigation;
import com.newgrounds.*;
import levelEditorLogic;	
	
/*
 * Manages character and gameplay controls, not including UI functions.
 */ 
class Controls {
	public static var MousePos;
	private static var _keyListener:Object;		
	public static var TileTypes = ["editorDefault", "editorWall", "editorDirt", "editorGoal", "editorKey1", "editorGate1", 
									"editorPortalA", "editorPortalB", "editorPortalC",
									"editorABCSwitchA", "editorABCSwitchB", "editorABCSwitchC",
									"editorABCGateAOpen", "editorABCGateBOpen", "editorABCGateCOpen", "editorABCGateAClosed", "editorABCGateBClosed", "editorABCGateCClosed",
									"editorTimer9", "editorTimer8", "editorTimer7", "editorTimer6", "editorTimer5", "editorTimer4", "editorTimer3",
									"editorTimer2", "editorTimer1", "editorTimerOpen", 
									"editorCloner",
									"editorABCCageAOpen", "editorABCCageBOpen", "editorABCCageCOpen", 
									"editorABCCageAClosed", "editorABCCageBClosed", "editorABCCageCClosed"										
									]; 
	private static var _tileDescriptions = {editorDefault: "This is the default tile. It acts as solid ground for the characters to move across.", 
											editorWall: "A wall tile. It's a barrier that characters cannot move through.",
											editorDirt: "A dirt tile. Capy cannot move through it but Roombella can. Put these in places " + 
											"where Roombella can clear out a path for her buddy!",
											editorGoal: "The goal! Bring the capybara here!",
											editorKey1: "A key, which can only be picked up by Capy. Make sure there's a gate somewhere in your level for this key to unlock!",
											editorGate1: "A gate. Make sure there's a keu somewhere in your level for this gate to be unlocked by!",
											editorPortalA: "An A Portal. When a character steps into it, they will be teleported to the other A Portal. Max of 2 A Portals " +
											"per level.",
											editorPortalB: "A B Portal. When a character steps into it, they will be teleported to the other B Portal. Max of 2 B Portals " +
											"per level.",
											editorPortalC: "A C Portal. When a character steps into it, they will be teleported to the other C Portal. Max of 2 C Portals " +
											"per level.",
											editorABCSwitchA: "An ABC Switch, defaulting to its A status. Touching this will cycle the switch through A, B, and C. In A status, all A gates will " +
												"be lifted, and all others will be closed unless another active switch or character holds them up.",
											editorABCSwitchB: "An ABC Switch, defaulting to its B status. Touching this will cycle the switch through A, B, and C. In B status, all B gates will " +
												"be lifted, and all others will be closed unless another active switch or character holds them up.",
											editorABCSwitchC: "An ABC Switch, defaulting to its C status. Touching this will cycle the switch through A, B, and C. In C status, all C gates will " +
												"be lifted, and all others will be closed unless another active switch or character holds them up.",
											editorABCGateAOpen: "An Open A gate. This can be closed by setting a switch to B or C status, so long as there isn't an A switch or a character holding " +
												"this up.",
											editorABCGateBOpen: "An Open B gate. This can be closed by setting a switch to A or C status, so long as there isn't a B switch or a character holding " +
												"this up.",
											editorABCGateCOpen: "An Open C gate. This can be closed by setting a switch to A or B status, so long as there isn't a C switch or a character holding " +
												"this up.",
											editorABCGateAClosed: "A closed A gate. This can be opened by setting a switch to A status.",
											editorABCGateBClosed: "A closed B gate. This can be opened by setting a switch to B status.",												
											editorABCGateCClosed: "A closed C gate. This can be opened by setting a switch to C status.",				
											editorTimer9: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 9 moves until" +
												" it opens again.",
											editorTimer8: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 8 moves until" +
												" it opens again.",
											editorTimer7: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 7 moves until" +
												" it opens again.",
											editorTimer6: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 6 moves until" +
												" it opens again.",
											editorTimer5: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 5 moves until" +
												" it opens again.",
											editorTimer4: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 4 moves until" +
												" it opens again.",
											editorTimer3: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 3 moves until" +
												" it opens again.",
											editorTimer2: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 2 moves until" +
												" it opens again.",
											editorTimer1: "A Timed Gate. This will count down from its starting value each time a character moves, open, then close again. It'll be 1 move until" +
												" it opens again.",
											editorTimerOpen: "A Timed Gate. This is open at the start and will close as soon as a character moves. It'll be 9 moves until" +
												" it opens again.",																											
											editorCloner: "When a character steps into this, their clone will appear in the chamber! Only 1 clone per character. Clones can be " +
											"removed by squishing them in a closing ABC Gate, ABC Cage, or Timed Gate. Only the original Capy can complete a level.",
											editorABCCageAOpen: "An open A Cage. If an A switch is active, this will capture a character as soon as they step on it. " +
											"De-activate all A switches to release them.",
											editorABCCageBOpen: "An open B Cage. If a B switch is active, this will capture a character as soon as they step on it. " +
											"De-activate all B switches to release them.",
											editorABCCageCOpen: "An open C Cage. If a C switch is active, this will capture a character as soon as they step on it. " +
											"De-activate all C switches to release them.",
											editorABCCageAClosed: "A closed A Cage. If there are no active A switches, this will open up. It will trigger and capture" +
											" a character when they step on it, and will hold them until all A switches are de-activated.",
											editorABCCageBClosed: "A closed B Cage. If there are no active B switches, this will open up. It will trigger and capture" +
											" a character when they step on it, and will hold them until all B switches are de-activated.",
											editorABCCageCClosed: "A closed C Cage. If there are no active C switches, this will open up. It will trigger and capture" +
											" a character when they step on it, and will hold them until all C switches are de-activated."
											};
	private static var _standardTileSet = ["Standard Tiles", ["editorDefault", "editorWall", "editorDirt", "editorGoal", "editorKey1", "editorGate1"]];
	private static var _ABCSwitchesAndGatesTileSet = ["ABC Switches and Gates", ["editorABCSwitchA", "editorABCSwitchB", "editorABCSwitchC",
											"editorABCGateAOpen", "editorABCGateBOpen", "editorABCGateCOpen", "editorABCGateAClosed", 
											"editorABCGateBClosed", "editorABCGateCClosed"]];
	private static var _timedGateTileSet = ["Timed Gates", ["editorTimer9", "editorTimer8", "editorTimer7", "editorTimer6", "editorTimer5", "editorTimer4", "editorTimer3",
											"editorTimer2", "editorTimer1", "editorTimerOpen"]];
	private static var _ABCCages = ["ABC Cages", ["editorABCCageAOpen", "editorABCCageBOpen", "editorABCCageCOpen", 
									"editorABCCageAClosed", "editorABCCageBClosed", "editorABCCageCClosed"]];
	private static var _miscTileSet = ["Mad Science", ["editorPortalA", "editorPortalB", "editorPortalC", "editorCloner"]];
	public static var allTileSets = [_standardTileSet, _ABCSwitchesAndGatesTileSet, _ABCCages, _timedGateTileSet, _miscTileSet];
	public static var DirectionalArrowsWithKeyCodes = {mobileMoveUp: 38, mobileMoveLeft: 37, mobileMoveRight: 39, mobileMoveDown: 40};
	
	/*
	 * During standard gameplay, checks if a user's input can result in a valid action.
	 * @param {Number} keyCode The keycode corresponding to the key pressed.
	 */ 
	public static function GameplayLoopKeyPress(keyCode:Number):Void {
		if (_root._currentframe == FrameNavigation.Campaign || _root._currentframe == FrameNavigation.LevelEditorPreview){
			if (!UI.PreventInput){
				if (keyCode >= 37 && keyCode <= 40) {
					Movement(keyCode);
					AnimationController.SetCharacterFacingDirection(keyCode, GameplayLogic.CharacterMode);
				} else if (keyCode == 32) {
					SwitchCharMode();					
				} else if (keyCode == 13){
					if (_root.campaignNextLvlBtn){
						MapLogic.NextCampaignLvl();
					};
				};
			};
			
			if (keyCode == 188){
				DecrementDialogue();
			} else if (keyCode == 190){
				IncrementDialogue();
			};	
			
		};
	};
	
	/*
	 * Moves the active player in the direction corresponding to the user's input.
	 * @param {Number} keyCode The keycode corresponding to the key pressed.
	 */ 
	public static function Movement(keyCode:Number):Void {
		if (GameplayLogic.CharacterMode == 1) {
			if (GameplayLogic.Character1IsMoving == false && GameplayLogic.Character2IsMoving == false &&
				DLCTileLogic.Char1CloneIsMoving == false && DLCTileLogic.Char2CloneIsMoving == false){
				var XYValues:Object = Character1MovementIncrementValues(keyCode);
				var targetTile = MapLogic.LevelTiles[GameplayLogic.Character1GridCoord.y + XYValues.y]
					[GameplayLogic.Character1GridCoord.x + XYValues.x];
				var cloneTargetTile = MapLogic.LevelTiles[DLCTileLogic.Char1Clone.GridCoord.y + XYValues.y]
					[DLCTileLogic.Char1Clone.GridCoord.x + XYValues.x];
				var char1CanMove = _isTargetTileOpen(targetTile, XYValues.x, XYValues.y, false);
				var char1CloneCanMove = _isTargetTileOpen(cloneTargetTile, XYValues.x, XYValues.y, true);
				
				if (DLCTileLogic.CharacterInABCCage(GameplayLogic.CharacterMode)){
					char1CanMove = false;
				};
				
				if (char1CanMove || char1CloneCanMove){
					GameplayLogic.MovesThisLevel++;
					trace("triggering timed gate countdown. Char1clone can move? " + char1CloneCanMove + ", IS moving? " + DLCTileLogic.Char1CloneIsMoving + 
					", char1can move?" + char1CanMove);
					
					
					DLCTileLogic.TimedGateCountdown({x: GameplayLogic.Character1GridCoord.x + XYValues.x, 
						y: GameplayLogic.Character1GridCoord.y + XYValues.y}, 
						{x: DLCTileLogic.Char1Clone.GridCoord.x + XYValues.x, y: DLCTileLogic.Char1Clone.GridCoord.y + XYValues.y}, _getDirectionFromKeyCode(keyCode));
					
					// band-aid solution in case char1 or clone are directly next to each other and 1 goes into portal and other doesn't take the now-empty spot	
					var leaderBeforeMovement = DLCTileLogic.GetChar1Lead(_getDirectionFromKeyCode(keyCode), 1);
					
					if (targetTile == MapLayouts.Tiles.Portal_A ||
						targetTile == MapLayouts.Tiles.Portal_B ||
						targetTile == MapLayouts.Tiles.Portal_C){
						if (leaderBeforeMovement != null && !char1CloneCanMove){
							char1CloneCanMove = true;
						};
					};
					trace("char1 can move after check?" + char1CanMove);
					
					if (cloneTargetTile == MapLayouts.Tiles.Portal_A ||
						cloneTargetTile == MapLayouts.Tiles.Portal_B ||
						cloneTargetTile == MapLayouts.Tiles.Portal_C){
						if (leaderBeforeMovement != null && !char1CanMove){
							char1CanMove = true;
						};
					};		
					trace("char1 can move after check 2?" + char1CanMove);
					
					if (char1CanMove){
						_character1Movement(targetTile, XYValues.x, XYValues.y, false, DLCTileLogic.IsCloneTrailingOriginal(1, _getDirectionFromKeyCode(keyCode)));	
					};
					if (DLCTileLogic.Char1Clone != null && !DLCTileLogic.CloneJustSpawned){
					// the "cloneJustSpawned" check is needed so the clone doesn't move forward in the next frame after spawning
					if (char1CloneCanMove){
						_character1Movement(cloneTargetTile, XYValues.x, XYValues.y, true, DLCTileLogic.IsCloneTrailingOriginal(1, _getDirectionFromKeyCode(keyCode)));	
					}
					} else if (DLCTileLogic.Char1Clone != null && DLCTileLogic.CloneJustSpawned){
						DLCTileLogic.CloneJustSpawned = false;
					};
					
					// additional collision fixes for clone
					var leader = DLCTileLogic.GetChar1Lead(_getDirectionFromKeyCode(keyCode), 2);
					
					if (leader != null){
						if (GameplayLogic.Character1IsMoving && leader ==  GameplayLogic.Character1){
							// if char1 is leader AND moving, that means it's going to a valid tile
							if (!DLCTileLogic.Char1CloneIsMoving){
								Controls._character1Movement(cloneTargetTile, XYValues.x, XYValues.y, true, true);
							}
						} else if (DLCTileLogic.Char1CloneIsMoving && leader == DLCTileLogic.Char1Clone){
							if (!GameplayLogic.Character1IsMoving && !DLCTileLogic.CharacterInABCCage(GameplayLogic.CharacterMode)){
								Controls._character1Movement(targetTile, XYValues.x, XYValues.y, false, false);
							};
						};
					};						
				} else {
					// really hate putting this here but this is the only good place for this w/ out a massive overhaul
					/* just checking if the teleport anim should play if the character's already sitting on the target portal, this only occurs
					 when 2 portals are directly next to each other. this is to give the illusion the player is moving even if they're not, 
					 just a little qol thing*/
					 if (!char1CanMove && DLCTileLogic.IsCharacterTargetingOccupiedPortal(1, false, XYValues.x, XYValues.y) &&
						(targetTile == MapLayouts.Tiles.Portal_A ||	targetTile == MapLayouts.Tiles.Portal_B || 
						targetTile == MapLayouts.Tiles.Portal_C)){
							_CheckForIdleTeleportAnimation(1, false, XYValues.x, XYValues.y);	
						};					 
					 
					 if (!char1CloneCanMove && DLCTileLogic.IsCharacterTargetingOccupiedPortal(1, true, XYValues.x, XYValues.y) &&
					 (cloneTargetTile == MapLayouts.Tiles.Portal_A || cloneTargetTile == MapLayouts.Tiles.Portal_B ||
					cloneTargetTile == MapLayouts.Tiles.Portal_C)){
						_CheckForIdleTeleportAnimation(1, true, XYValues.x, XYValues.y);	
					 };
				};
			};
		} else if (GameplayLogic.CharacterMode == 2) {
			if (GameplayLogic.Character1IsMoving == false && GameplayLogic.Character2IsMoving == false &&				
				DLCTileLogic.Char1CloneIsMoving == false && DLCTileLogic.Char2CloneIsMoving == false){
				var XYValues = Character1MovementIncrementValues(keyCode);
				var targetTile = MapLogic.LevelTiles[GameplayLogic.Character2GridCoord.y + XYValues.y]
					[GameplayLogic.Character2GridCoord.x +  XYValues.x];
				var cloneTargetTile = MapLogic.LevelTiles[DLCTileLogic.Char2Clone.GridCoord.y + XYValues.y]
					[DLCTileLogic.Char2Clone.GridCoord.x +  XYValues.x];
				// for checking if char2 can move even 1 tile, regardless of where her final destination is
				var char2CanMove = _isTargetTileOpen(targetTile, XYValues.x, XYValues.y, false);
				var char2CloneCanMove = _isTargetTileOpen(cloneTargetTile, XYValues.x, XYValues.y, true);
				
				if (DLCTileLogic.CharacterInABCCage(GameplayLogic.CharacterMode)){
					char2CanMove = false;
				};
				
				if (char2CanMove || char2CloneCanMove){
					GameplayLogic.MovesThisLevel++;		
					if (char2CanMove){
						Character2Movement(keyCode, false, false);	
					};
					/*// TimedGateCountdown is after _character2Movement because calcs are much more complex for char2 than 1, 
					 * and those can't be solved in a simple check like for char1*/
					if (DLCTileLogic.Char2Clone != null && char2CloneCanMove){
						Character2Movement(keyCode, true, false);				
					};	
					
					// do not change this
					if ((DLCTileLogic.ValidTileForGateCountdown(GameplayLogic.GetNextTile(GameplayLogic.Char2TravelDirection, GameplayLogic.Char2LaunchGridCoord.x, 
					GameplayLogic.Char2LaunchGridCoord.y))) || 
					((DLCTileLogic.Char2Clone != null) && (DLCTileLogic.ValidTileForGateCountdown(GameplayLogic.GetNextTile(DLCTileLogic.Char2CloneTravelDirection, DLCTileLogic.Char2CloneLaunchGridCoord.x, 
					DLCTileLogic.Char2CloneLaunchGridCoord.y))))){
							DLCTileLogic.TimedGateCountdown(MapLogic.TileTypeToMoveTo);
					};
					DLCTileLogic.Char2LeaderCorrection(_getDirectionFromKeyCode(keyCode));
				} else {
					// really hate putting this here but this is the only good place for this w/ out a massive overhaul
					/* just checking if the teleport anim should play if the character's already sitting on the target portal, this only occurs
					 when 2 portals are directly next to each other. this is to give the illusion the player is moving even if they're not, 
					 just a little qol thing*/
					 if (!char2CanMove && DLCTileLogic.IsCharacterTargetingOccupiedPortal(2, false, XYValues.x, XYValues.y) &&
					 (targetTile == MapLayouts.Tiles.Portal_A || targetTile == MapLayouts.Tiles.Portal_B ||
					targetTile == MapLayouts.Tiles.Portal_C)){
						_CheckForIdleTeleportAnimation(2, false, XYValues.x, XYValues.y);	
					 };
					 
					 if (!char2CloneCanMove && DLCTileLogic.IsCharacterTargetingOccupiedPortal(2, true, XYValues.x, XYValues.y) &&
					 (cloneTargetTile == MapLayouts.Tiles.Portal_A || cloneTargetTile == MapLayouts.Tiles.Portal_B ||
							cloneTargetTile == MapLayouts.Tiles.Portal_C)){
						_CheckForIdleTeleportAnimation(2, true, XYValues.x, XYValues.y);	
					 };
				};
			};
		};
	};
	
	/*
	 * If a character is sitting on a teleporter, and they're about to walk into the matching teleporter
	   directly next to them, a teleportation animation should play, even if the character isn't technically
	   moving; this is just a QoL feature, some animation polish.
	 * @param {Number} characterNumber Which character to check for: 1 for Capy, 2 for Roombella.
	 * @param {Boolean} forClone Whether or not this is for a clone.
	 * @param {Number} xIncrement The number of X units on the Grid the character is intending to move.
	 * @param {Number} yIncrement The number of Y units on the Grid the character is intending to move.
	 */ 
	private static function _CheckForIdleTeleportAnimation(characterNumber:Number, forClone:Boolean, xIncrement:Number,
	yIncrement:Number){
		var charX;
		var charY;
		
		if (characterNumber == 1){			
			if (forClone){
				charX = DLCTileLogic.Char1Clone.GridCoord.x;
				charY = DLCTileLogic.Char1Clone.GridCoord.y;
			} else {
				charX = GameplayLogic.Character1GridCoord.x;
				charY = GameplayLogic.Character1GridCoord.y;
			};			
		} else if (characterNumber == 2){
			if (forClone){
				charX = DLCTileLogic.Char2Clone.GridCoord.x;
				charY = DLCTileLogic.Char2Clone.GridCoord.y;
			} else {
				charX = GameplayLogic.Character2GridCoord.x;
				charY = GameplayLogic.Character2GridCoord.y;
			};	
		};
		
		var charCurrentPortal =  DLCTileLogic.GetPortalAtGridCoord(charX, charY);
		if (charCurrentPortal != null){
			var correspondingPortal = DLCTileLogic.GetCorrespondingPortal(charCurrentPortal.status, 
				charCurrentPortal.GridCoord.x, charCurrentPortal.GridCoord.y);
			if (correspondingPortal.GridCoord.x == (charX + xIncrement) &&
				correspondingPortal.GridCoord.y == (charY + yIncrement)){
				// confirmed char is targeting a portal that goes to exactly where she is already, play anim
				AnimationController.TeleportVisuals(characterNumber, charCurrentPortal.cell, correspondingPortal.cell);
				SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Teleport);
			};
		};
	};
	
	/*
	 * Manages functionality associated with toggling the active character.
	 */ 
	public static function SwitchCharMode():Void {
		if (!GameplayLogic.Character1IsMoving && !GameplayLogic.Character2IsMoving) {
			GameplayLogic.ToggleCharacterMode();
			GameplayLogic.PlayerSwitchedCharacters = true;
			if (GameplayLogic.CharacterMode == 1){
				SoundManager.PlaySound(SoundManager.SoundLibraryEnum.SwitchToCapy);
			} else {
				SoundManager.PlaySound(SoundManager.SoundLibraryEnum.SwitchToRoombella);
			};
			AnimationController.ManageCharacterCursorAnimation();
		};			
	};
	
	/*
	 * Assigns functionality to the on-screen arrow keys during gameplay.
	 * @param {Button} arrow The on-screen directional arrow. 
	 */ 
	public static function AssignDirectionalArrowFunctions(arrow:Button):Void {
		for (var key in DirectionalArrowsWithKeyCodes){
			if (key == arrow._name){
				arrow.onPress = function(){
					Movement(DirectionalArrowsWithKeyCodes[key]);
					AnimationController.SetCharacterFacingDirection(DirectionalArrowsWithKeyCodes[key], GameplayLogic.CharacterMode);
				};
				break;
			};
		};
	};
	
	/*
	 * For a given keycode, returns an object where the x value represents how many units to the right
	   character 1 is moving, while the y value represents how many units up they're moving. Negative
	   values mean they're moving left or down respectively.
	 *@return {Object} An XY pairing showing how many units the character is moving.
	 */ 
	public static function Character1MovementIncrementValues(keyCode:Number):Object {
		var characterXIncrement:Number;
		var characterYIncrement:Number;
		
		switch (keyCode){
			case 40:					
				characterXIncrement = 0;
				characterYIncrement = 1;
				break;
			case 38:
				characterXIncrement = 0;
				characterYIncrement = -1;
				break;
			case 39:
				characterXIncrement = 1;
				characterYIncrement = 0;
				break;
			case 37:
				characterXIncrement = -1;
				characterYIncrement = 0;
				break;
		};
		var XYobj = {x: characterXIncrement, y: characterYIncrement};
		return XYobj;
	};
	
	/*
	* For a given keycode (used by Flash to identify keyboard keys by numbers), 
	   returns the direction in-game.
	* @param {Number} keyCode The keycode to retrieve a direction for. Should correspond
	  to an arrow key.
	* @return {String} The corresponding direction as a string.
	*/ 
	private static function _getDirectionFromKeyCode(keyCode:Number):String {
		var characterXIncrement:Number;
		var characterYIncrement:Number;			
		switch (keyCode){
			case 40:					
				return "down";
				break;
			case 38:
				return "up";
				break;
			case 39:
				return "right";
				break;
			case 37:
				return "left";
				break;
			default:
				return null;
				break;
		};
	};
	
	/*
	* For a given direction, returns the corresponding Flash keycode.
	* @param {String} direction The direction to retrieve a key code for. Should correspond
	  to an arrow key.
	* @return {Number} The corresponding keycode.
	*/ 
	public static function GetKeyCodeFromDirection(direction:String):Number {
		var characterXIncrement:Number;
		var characterYIncrement:Number;			
		switch (direction){
			case "down":					
				return 40;
				break;
			case "up":
				return 38;
				break;
			case "right":
				return 39;
				break;
			case "left":
				return 37;
				break;
			default:
				return null;
				break;
		};
	};
	
	/* Checks if tile is valid for a character to step into.
	 * @param {String} targetTile The tile the character is going to step into (corresponding to MapLayouts.Tiles).
	 * @param {Number} characterXIncrement The number of X Grid units the character is going to move from their current position.
	 * @param {Number} characterYIncrement The number of Y Grid units the character is going to move from their current position.
	 * @param {Boolean} forClone Whether or not the function is being performed for a clone.
	 * @return {Boolean} Whether or not the target tile is open.	
	*/
	public static function _isTargetTileOpen(targetTile:String, characterXIncrement:Number, characterYIncrement:Number, forClone:Boolean):Boolean {
		var referenceGridCoord;
		var targetX; 
		var targetY;
		var CapyCloneCheck = true;
		var RoombellaCloneCheck = true;
		var dirtCheck = true;
		var keyCheck = true;
		
		if (GameplayLogic.CharacterMode == 1){
			if (!forClone){
				referenceGridCoord = GameplayLogic.Character1GridCoord;
			} else {
				referenceGridCoord = DLCTileLogic.Char1Clone.GridCoord;
			};
			
			targetX = referenceGridCoord.x + characterXIncrement;
			targetY = referenceGridCoord.y + characterYIncrement;	
			
			if (DLCTileLogic.Char1Clone != null && !forClone){
				CapyCloneCheck = !(targetY == DLCTileLogic.Char1Clone.GridCoord.y &&
				targetX == DLCTileLogic.Char1Clone.GridCoord.x);
			} else if (forClone){
				CapyCloneCheck = !(targetY == GameplayLogic.Character1GridCoord.y &&
				targetX == GameplayLogic.Character1GridCoord.x);
			};
			
			if (DLCTileLogic.Char2Clone != null){
				RoombellaCloneCheck = !((targetY == DLCTileLogic.Char2Clone.GridCoord.y &&
					targetX == DLCTileLogic.Char2Clone.GridCoord.x) ||
					(targetY == GameplayLogic.Character2GridCoord.y &&
					targetX == GameplayLogic.Character2GridCoord.x));
			} else {
				RoombellaCloneCheck = !(targetY == GameplayLogic.Character2GridCoord.y &&
					targetX == GameplayLogic.Character2GridCoord.x);
			};
			
			dirtCheck = !(targetTile == MapLayouts.Tiles.Dirt);
		} else if (GameplayLogic.CharacterMode == 2){
			if (!forClone){
				referenceGridCoord = GameplayLogic.Character2GridCoord;
			} else {
				referenceGridCoord = DLCTileLogic.Char2Clone.GridCoord;
			};
			
			targetX = referenceGridCoord.x + characterXIncrement;
			targetY = referenceGridCoord.y + characterYIncrement;	
			
			if (DLCTileLogic.Char2Clone != null && !forClone){
				RoombellaCloneCheck = !(targetY == DLCTileLogic.Char2Clone.GridCoord.y &&
				targetX == DLCTileLogic.Char2Clone.GridCoord.x);
			} else if (forClone){
				RoombellaCloneCheck = !(targetY == GameplayLogic.Character2GridCoord.y &&
				targetX ==  GameplayLogic.Character2GridCoord.x);
			};
			
			if (DLCTileLogic.Char1Clone != null){
				CapyCloneCheck = !((targetY == DLCTileLogic.Char1Clone.GridCoord.y &&
					targetX == DLCTileLogic.Char1Clone.GridCoord.x) ||
					(targetY == GameplayLogic.Character1GridCoord.y &&
					targetX == GameplayLogic.Character1GridCoord.x));
			} else {
				CapyCloneCheck = !(targetY == GameplayLogic.Character1GridCoord.y &&
					targetX == GameplayLogic.Character1GridCoord.x);
			};
							
			keyCheck = !(targetTile == MapLayouts.Tiles.Key1);
		};
		trace("targetile in check: " + targetTile + ", target x: " + targetX + ", y: " + targetY + 
		", forclone: " + forClone + ", cage check: " + DLCTileLogic.CheckCageAtCoordIsOpen(targetX, targetY) + 
		", gate check: " + MapLogic.CheckGateAtCoordIsOpen(targetX, targetY) + ", capy check: " + CapyCloneCheck);
		if ((targetTile == MapLayouts.Tiles.Default ||
				targetTile == MapLayouts.Tiles.Dirt ||
				targetTile == MapLayouts.Tiles.Key1 ||
				targetTile == MapLayouts.Tiles.Goal ||
				targetTile == MapLayouts.Tiles.ABCSwitch_A ||
				targetTile == MapLayouts.Tiles.ABCSwitch_B ||
				targetTile == MapLayouts.Tiles.ABCSwitch_C ||
				MapLogic.CheckGateAtCoordIsOpen(targetX, targetY) ||
				DLCTileLogic.CheckCageAtCoordIsOpen(targetX, targetY) ||
				targetTile == MapLayouts.Tiles.Timer1 ||
				targetTile == MapLayouts.Tiles.TimerOpen ||
				targetTile == MapLayouts.Tiles.Portal_A ||
				targetTile == MapLayouts.Tiles.Portal_B ||
				targetTile == MapLayouts.Tiles.Portal_C ||
				targetTile == MapLayouts.Tiles.Cloner) &&
				CapyCloneCheck && RoombellaCloneCheck && dirtCheck && keyCheck){							
			return true;
		} else {
			return false;
		};
	};
	
	/*
	 * Movement code for Capy, managing movement across the grid, as well as verifying valid spaces to move.
	 * @param {String} targetTile the type of tile the user is headed towards.
	 * @param {Number} characterXIncrement The number of units the character will move on the X axis.
	 * @param {Number} characterYIncrement The number of units the character will move on the Y axis.
	 * @param {Boolean} forClone Whether or not this movement is for a clone. If false, it's for the "main" Capy.
	 * @param {Boolean} cloneTrailing If a clone does exist, returns whether or not the clone is following behind the "main" Capy's movement. False if no clone.
	 */ 
	public static function _character1Movement(targetTile:String, characterXIncrement:Number, characterYIncrement:Number, forClone:Boolean, cloneTrailing:Boolean):Void {
		var targetX; 
		var targetY;
		if (!forClone){
			targetX = GameplayLogic.Character1GridCoord.x + characterXIncrement;
			targetY = GameplayLogic.Character1GridCoord.y + characterYIncrement;
		} else {
			targetX = DLCTileLogic.Char1Clone.GridCoord.x + characterXIncrement;
			targetY = DLCTileLogic.Char1Clone.GridCoord.y + characterYIncrement;
		};	
		
		if (MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.Key1){
			MapLogic.UnlockGate(1);
		};
		
		// code for ABC switch here
		if (targetTile == MapLayouts.Tiles.ABCSwitch_A ||
			targetTile == MapLayouts.Tiles.ABCSwitch_B ||
			targetTile == MapLayouts.Tiles.ABCSwitch_C){
			var statusOfABCSwitch:String; // will be A, B, or C
			var ABCSwitchIndex = MapLogic.GetABCSwitchIndexByGridCoord(targetX, targetY);			
			MapLogic.ABCSwitchObjects[ABCSwitchIndex].status = MapLogic.GetNextCharInABCSequence(MapLogic.ABCSwitchObjects[ABCSwitchIndex].status);
			statusOfABCSwitch = MapLogic.ABCSwitchObjects[ABCSwitchIndex].status;
			MapLogic.UnlockAllABCGatesOfType(statusOfABCSwitch);
			DLCTileLogic.UnlockAllABCCagesNotOfType(statusOfABCSwitch);	
			DLCTileLogic.TriggerABCCagesWithCharacters(statusOfABCSwitch, 1, forClone, targetX, targetY);
			MapLogic.LockAllABCGatesNotOfType(statusOfABCSwitch, forClone);
			AnimationController.UpdateAllABCSwitchesAndGates();
			AnimationController.UpdateAllABCCages();
		};	
		
		if (targetTile == MapLayouts.Tiles.ABCCage_A_open ||
			targetTile == MapLayouts.Tiles.ABCCage_B_open ||
			targetTile == MapLayouts.Tiles.ABCCage_C_open){
			DLCTileLogic.CheckCageAtCoordIsReadyToSpring(targetX, targetY);
			
			// if cage was sprung, squish clone
			if ((MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.ABCCage_A_closed ||
				MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.ABCCage_B_closed ||
				MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.ABCCage_C_closed) && forClone){
					
					// hacky solution to ensure destroy anim plays even though char1clone technically isn't at the target
					DLCTileLogic.Char1Clone.GridCoord.x = targetX;
					DLCTileLogic.Char1Clone.GridCoord.y = targetY;
					AnimationController.SpawnDestroyAnimationOfCloneAtGridCoord(targetX, targetY);		
					SoundManager.PlaySound(SoundManager.SoundLibraryEnum.CloneDeath);
					DLCTileLogic.DestroyClone(1);
			} else if ((MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.ABCCage_A_closed ||
				MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.ABCCage_B_closed ||
				MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.ABCCage_C_closed) && !forClone){
				DLCTileLogic.CapyTrappedAtLeastOnce = true;
				trace("capy trapped once...");
				GameplayLogic.Character1GridCoord.x = GameplayLogic.Character1GridCoord.x;						
				GameplayLogic.Character1GridCoord.y = GameplayLogic.Character1GridCoord.y;	
				GameplayLogic.Character1IsMoving = false;
			}
		};		
		
		if (targetTile == MapLayouts.Tiles.Portal_A || targetTile == MapLayouts.Tiles.Portal_B || targetTile == MapLayouts.Tiles.Portal_C){
			var type = "";
			switch (targetTile){
				case MapLayouts.Tiles.Portal_A:
					type = "A";
					break;
				case MapLayouts.Tiles.Portal_B:
					type = "B";
					break;
				case MapLayouts.Tiles.Portal_C:
					type = "C";
					break;								
			};
			
			if (!DLCTileLogic.IsCharacterInCorrespondingPortal(type, targetX, targetY)){							
				var portalToGoTo = DLCTileLogic.GetCorrespondingPortal(type, targetX, targetY);		
				
				if (!forClone){
					GameplayLogic.Character1._x = portalToGoTo.cell._x;
					GameplayLogic.Character1._y = portalToGoTo.cell._y;
					GameplayLogic.Character1GridCoord.x = portalToGoTo.GridCoord.x;						
					GameplayLogic.Character1GridCoord.y = portalToGoTo.GridCoord.y;	
					GameplayLogic.Character1IsMoving = false;
					AnimationController.ManageCharacterCursorAnimation();
					SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Teleport);
					AnimationController.TeleportVisuals(1, MapLogic.AllCells[targetY][targetX], portalToGoTo.cell);
					return;
				// returning early because this should be an instant teleport, will play an animation to mask the transition
				} else {
					DLCTileLogic.Char1Clone._x = portalToGoTo.cell._x;
					DLCTileLogic.Char1Clone._y = portalToGoTo.cell._y;
					DLCTileLogic.Char1Clone.GridCoord.x = portalToGoTo.GridCoord.x;	
					DLCTileLogic.Char1Clone.GridCoord.y = portalToGoTo.GridCoord.y;	
					DLCTileLogic.Char1CloneIsMoving = false;
					SoundManager.PlaySound(SoundManager.SoundLibraryEnum.Teleport);
					AnimationController.TeleportVisuals(1, MapLogic.AllCells[targetY][targetX], portalToGoTo.cell);
					return;
				};
			} else {
				// a character is in other end of portal
				if (DLCTileLogic.CheckIfCharInCorrespondingPortal(1, forClone, type, targetX, targetY)){
					var portalToGoTo = DLCTileLogic.GetCorrespondingPortal(type, targetX, targetY);	
					AnimationController.TeleportVisuals(1, MapLogic.AllCells[targetY][targetX], portalToGoTo.cell);
				};					
				//return; 9/27/24, removed this because if Capy was behind his clone and the clone tried stepping onto an occupied tile, Capy would overlap clone
			};
		};
		
		if ((MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.Cloner) && DLCTileLogic.Char1Clone == null && !forClone){
			DLCTileLogic.CreateClone(1, {x: targetX, y: targetY});
			AnimationController.SpawnVisualEffect("Sparkle", MapLogic.AllCells[targetY][targetX]._x + 
				MapLogic.AllCells[targetY][targetX]._parent._x, 
				MapLogic.AllCells[targetY][targetX]._y + 
				MapLogic.AllCells[targetY][targetX]._parent._y);
			MapLogic.CellToMoveTo = null;
			GameplayLogic.Character1IsMoving = false;
			DLCTileLogic.CloneJustSpawned = true;
			return;
		};
		
		if (MapLogic.LevelTiles[targetY][targetX] == MapLayouts.Tiles.Goal && !forClone){
			GameplayLogic.Char1InGoal = true;
			GameplayLogic.CappyTouchedGoal = true;
		} else {
			GameplayLogic.Char1InGoal = false;
		};
		
		if (!forClone){
			GameplayLogic.Character1IsMoving = true;
			MapLogic.CellToMoveTo = MapLogic.AllCells[targetY][targetX];
		} else {
			// very rare circumstance where char1's movement can destroy clone while its moving (ie stepping on abc
			// cage), so we don't want to re-enable char1clone moving
			if (DLCTileLogic.Char1Clone != null){
			DLCTileLogic.Char1CloneIsMoving = true;
			DLCTileLogic.Char1CloneCellToMoveTo = MapLogic.AllCells[targetY][targetX];
			} else {
				return;
			};
		};
		
		if (!forClone){
			GameplayLogic.Character1GridCoord.x += characterXIncrement;						
			GameplayLogic.Character1GridCoord.y += characterYIncrement;	
		} else {
			DLCTileLogic.Char1Clone.GridCoord.x += characterXIncrement;		
			DLCTileLogic.Char1Clone.GridCoord.y += characterYIncrement;	
		};
	};
	
	
	/*
	 * Movement code for character 2, managing movement across the grid, as well as verifying valid spaces to move.
	   Each direction's slightly different checks (i.e. levelTiles check changes between inner or outer array check depending on the direction)
	   prevents an organizational style similar to _character1Movement.
	 * @param {Number} keyCode The keycode representing the direction the character will go.
	 * @param {Boolean} forClone If this movement is for a clone.
	 * @param {Boolean} forReorientation Whether or not this is being used for re-orienting Roombella after a clone teleportation may change her 
	   trajectory.
	 */ 
	public static function Character2Movement(keyCode:Number, forClone:Boolean, forReorientation:Boolean):Void {
		if ((GameplayLogic.Character2IsMoving && !forClone && !forReorientation) ||
			(DLCTileLogic.Char2CloneIsMoving && forClone && !forReorientation)){
			// don't let user input during movement
			return;
		};	
		
		if (!forClone && DLCTileLogic.CharacterInABCCage(2)){
			return; // don't move OG if she's trapped in cage
		};
		
		if (!forClone){
			MapLogic.TileTypeToMoveTo = null;
		} else {
			DLCTileLogic.Char2CloneTileTypeToMoveTo = null;
		};				
		
		var gridCoordX; 
		var gridCoordY;
		var launchGridCoordX;
		var launchGridCoordY;	
						
		if (!forClone){
			GameplayLogic.Char2LaunchGridCoord = {x: GameplayLogic.Character2GridCoord.x, y: GameplayLogic.Character2GridCoord.y};
			gridCoordX = GameplayLogic.Character2GridCoord.x;
			launchGridCoordX = GameplayLogic.Character2GridCoord.x;
			gridCoordY = GameplayLogic.Character2GridCoord.y;
			launchGridCoordY = GameplayLogic.Character2GridCoord.y;		
		} else if (forClone){
			DLCTileLogic.Char2CloneLaunchGridCoord = {x: DLCTileLogic.Char2Clone.GridCoord.x, y: DLCTileLogic.Char2Clone.GridCoord.y};
			gridCoordX = DLCTileLogic.Char2Clone.GridCoord.x;
			launchGridCoordX = DLCTileLogic.Char2Clone.GridCoord.x;
			gridCoordY = DLCTileLogic.Char2Clone.GridCoord.y;
			launchGridCoordY = DLCTileLogic.Char2Clone.GridCoord.y;
		};
		
		if (!forReorientation){
			for (var i = 0; i < MapLogic.ABCSwitchObjects.length; i++){
				if (MapLogic.ABCSwitchObjects[i].GridCoord.x == launchGridCoordX &&
				MapLogic.ABCSwitchObjects[i].GridCoord.y == launchGridCoordY){
					if (!forClone){
						GameplayLogic.SwitchIndexesAlreadyFlippedDuringChar2Movement.push(i);
					} else {
						GameplayLogic.SwitchIndexesAlreadyFlippedDuringChar2CloneMovement.push(i);
					};				
				};
			};
		};
			
		var travelDirection = "";
		var iteratorCompare = null;
		var iteratorMin = null;
		var iteratorMax = null;
		var yIter = null;
		var xIter = null;
		var compare = null;
		var CapyCollideCheck = null;
		var CapyCloneCollideCheck = null;
		var RoombellaCollideCheck = false;
			
		switch(keyCode){
			case 40:
				travelDirection = "down";
				iteratorMin = gridCoordY;
				iteratorMax = MapLogic.MapHeight;
				break;
			case 38:
				travelDirection = "up";
				//iteratorMin = gridCoordY; 
				iteratorMin = gridCoordY - 1; // no clue why this is needed it just is...
				iteratorMax = 0;
				break;
			case 39:
				travelDirection = "right";
				iteratorMin = gridCoordX;
				iteratorMax = MapLogic.MapWidth;
				break;
			case 37:								
				travelDirection = "left";
				//iteratorMin = gridCoordX;
				iteratorMin = gridCoordX - 1; 
				iteratorMax = 0;
				break;					
		};		
		
		if (travelDirection == "down" || travelDirection == "right"){						
			for (var i = iteratorMin; i < iteratorMax; i++) {
				if (travelDirection == "down"){
					compare = MapLogic.LevelTiles[i][gridCoordX];
					yIter = i - 1;
					xIter = gridCoordX;
					CapyCollideCheck = (i == GameplayLogic.Character1GridCoord.y && 
						GameplayLogic.Character1GridCoord.x == gridCoordX);
						
					if (DLCTileLogic.Char1Clone != null){
						CapyCloneCollideCheck = (i == DLCTileLogic.Char1Clone.GridCoord.y &&
						DLCTileLogic.Char1Clone.GridCoord.x == gridCoordX);
					} else {
						CapyCloneCollideCheck = false;
					};
					
				} else if (travelDirection == "right"){
					compare = MapLogic.LevelTiles[gridCoordY][i]; 
					yIter = gridCoordY;
					xIter = i - 1;
					CapyCollideCheck = (i == GameplayLogic.Character1GridCoord.x && 
						GameplayLogic.Character1GridCoord.y == gridCoordY);						
						
					if (DLCTileLogic.Char1Clone != null){
						CapyCloneCollideCheck = (i == DLCTileLogic.Char1Clone.GridCoord.x && 
						DLCTileLogic.Char1Clone.GridCoord.y == gridCoordY);
						
					} else {
						CapyCloneCollideCheck = false;
					};
				};
				
				if (compare == MapLayouts.Tiles.Wall ||
					compare == MapLayouts.Tiles.Gate1 ||
					compare == MapLayouts.Tiles.Key1 ||
					compare == MapLayouts.Tiles.ABCGate_A_closed ||
					compare == MapLayouts.Tiles.ABCGate_B_closed ||
					compare == MapLayouts.Tiles.ABCGate_C_closed ||
					compare == MapLayouts.Tiles.Timer9 || compare == MapLayouts.Tiles.Timer8 || compare == MapLayouts.Tiles.Timer7 ||
					compare == MapLayouts.Tiles.Timer6 || compare == MapLayouts.Tiles.Timer5 || compare == MapLayouts.Tiles.Timer4 ||
					compare == MapLayouts.Tiles.Timer3 || compare == MapLayouts.Tiles.Timer2 || 
					compare == MapLayouts.Tiles.ABCCage_A_closed || compare == MapLayouts.Tiles.ABCCage_B_closed || compare == MapLayouts.Tiles.ABCCage_C_closed ||
					CapyCollideCheck || CapyCloneCollideCheck || RoombellaCollideCheck) {								
					if (!forClone){
						GameplayLogic.Character2IsMoving = true;
						MapLogic.CellToMoveTo = MapLogic.AllCells[yIter][xIter];
						MapLogic.TileTypeToMoveTo = MapLogic.LevelTiles[yIter][xIter];
						if (travelDirection == "down"){
							GameplayLogic.Character2GridCoord.y = yIter;
						} else if (travelDirection == "right"){
							GameplayLogic.Character2GridCoord.x = xIter;
						};
					} else if (forClone){
						DLCTileLogic.Char2CloneIsMoving = true;
						DLCTileLogic.Char2CloneCellToMoveTo = MapLogic.AllCells[yIter][xIter];
						DLCTileLogic.Char2CloneTileTypeToMoveTo = MapLogic.LevelTiles[yIter][xIter];
						if (travelDirection == "down"){
							DLCTileLogic.Char2Clone.GridCoord.y = yIter;
						} else if (travelDirection == "right"){
							DLCTileLogic.Char2Clone.GridCoord.x = xIter;
						};
					};												
					
						GameplayLogic.Char2TravelDirection = travelDirection;	
						if (DLCTileLogic.Char2Clone != null){
							DLCTileLogic.Char2CloneTravelDirection = travelDirection;
						};
					break;
				};
			};												
		} else if (travelDirection == "up" || travelDirection == "left"){
			for (var i = iteratorMin; i >= iteratorMax; i--) {
				if (travelDirection == "up"){
					compare = MapLogic.LevelTiles[i][gridCoordX];
					yIter = i + 1;
					xIter = gridCoordX;
					CapyCollideCheck = (i == GameplayLogic.Character1GridCoord.y && 
						GameplayLogic.Character1GridCoord.x == gridCoordX);
						
					if (DLCTileLogic.Char1Clone != null){
						CapyCloneCollideCheck = (i == DLCTileLogic.Char1Clone.GridCoord.y && 
						DLCTileLogic.Char1Clone.GridCoord.x == gridCoordX);
					} else {
						CapyCloneCollideCheck = false;
					};
				} else if (travelDirection == "left"){
					compare = MapLogic.LevelTiles[gridCoordY][i];
					yIter = gridCoordY;
					xIter = i + 1;
					CapyCollideCheck = (i == GameplayLogic.Character1GridCoord.x && 
						GameplayLogic.Character1GridCoord.y == gridCoordY);
						
					if (DLCTileLogic.Char1Clone != null){
						CapyCloneCollideCheck = (i == DLCTileLogic.Char1Clone.GridCoord.x && 
						DLCTileLogic.Char1Clone.GridCoord.y == gridCoordY);
					} else {
						CapyCloneCollideCheck = false;
					};
				};
				
				if (compare == MapLayouts.Tiles.Wall ||
					compare == MapLayouts.Tiles.Gate1 ||
					compare == MapLayouts.Tiles.Key1 ||
					compare == MapLayouts.Tiles.ABCGate_A_closed ||
					compare == MapLayouts.Tiles.ABCGate_B_closed ||
					compare == MapLayouts.Tiles.ABCGate_C_closed ||
					compare == MapLayouts.Tiles.Timer9 || compare == MapLayouts.Tiles.Timer8 || compare == MapLayouts.Tiles.Timer7 ||
					compare == MapLayouts.Tiles.Timer6 || compare == MapLayouts.Tiles.Timer5 || compare == MapLayouts.Tiles.Timer4 ||
					compare == MapLayouts.Tiles.Timer3 || compare == MapLayouts.Tiles.Timer2 || 
					compare == MapLayouts.Tiles.ABCCage_A_closed || compare == MapLayouts.Tiles.ABCCage_B_closed || compare == MapLayouts.Tiles.ABCCage_C_closed ||
					CapyCollideCheck || CapyCloneCollideCheck || RoombellaCollideCheck) {
					if (!forClone){
						GameplayLogic.Character2IsMoving = true;
						MapLogic.CellToMoveTo = MapLogic.AllCells[yIter][xIter];
						MapLogic.TileTypeToMoveTo = MapLogic.LevelTiles[yIter][xIter];
						
						if (travelDirection == "up"){
							GameplayLogic.Character2GridCoord.y = yIter;
						} else if (travelDirection == "left"){
							GameplayLogic.Character2GridCoord.x = xIter;
						};	
					} else if (forClone){
						DLCTileLogic.Char2CloneIsMoving = true;
						DLCTileLogic.Char2CloneCellToMoveTo = MapLogic.AllCells[yIter][xIter];
						DLCTileLogic.Char2CloneTileTypeToMoveTo = MapLogic.LevelTiles[yIter][xIter];
						if (travelDirection == "up"){
							DLCTileLogic.Char2Clone.GridCoord.y = yIter;
						} else if (travelDirection == "left"){
							DLCTileLogic.Char2Clone.GridCoord.x = xIter;
						};	
					};
					
					GameplayLogic.Char2TravelDirection = travelDirection;								
					if (DLCTileLogic.Char2Clone != null){
						DLCTileLogic.Char2CloneTravelDirection = travelDirection;
					};
					break;
				};
			};
		};
	};
	
	/*
	 * In the Level Editor, assign functionality to each of the tiles a player can choose from.
	 * @param {Button} tile The on-screen tile the user can click to change the active tile in the editor.
	 */ 
	public static function AssignLvlEditorTileFuncs(tile:Button):Void {
		var tileNum:Number;
		var description:String;			
		
		for (var i = 0; i < TileTypes.length; i++){
			if (tile._name == TileTypes[i]){
				description = _tileDescriptions[TileTypes[i]];
				tileNum = i;
			};
		};
		
		if (tileNum != null && description != null){
			tile.onRelease = function() {
				if (!UI.PreventInput){
					LevelEditorLogic.ChangeActiveTileAndDescription(tileNum, description);
				};
			};
		};
	};	
	
	/*
	 * Initializes the key listener for the user's input.
	 */ 
	public static function InitiateKeyListener():Void {
		_keyListener = new Object();
		_keyListener.onKeyDown = function() {
			GameplayLoopKeyPress(Key.getCode());
		};
		Key.addListener(_keyListener);
	};
	
	/*
	 * Unloads the key listener for the user's input.
	 */ 
	public static function UnloadKeyListener():Void {
		Key.removeListener(_keyListener);
	};
	
	/*
	 * Reloads the key listener for the user's input.
	 */ 
	public static function ReloadKeyListener():Void {
		UnloadKeyListener();
		InitiateKeyListener();
	};
	
	/*
	 * Shows the next line of dialogue on-screen.
	 */ 
	public static function IncrementDialogue():Void {
		if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
			DialogueManager.IncrementLineIndex();
			DialogueManager.manualWrite();
			DialogueManager.ManualDialogueNavCheck();
			if (UI.InPostSceneDialogue){
				if (!DialogueManager.CheckForNextLine()){						
					_root.startLevelDialogueBtn._x = _root.charDialogueTxtBox._x;
				};
			};
		} else if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.auto){
			DialogueManager.IncrementLineIndex();
			DialogueManager.AutoplayText();
			DialogueManager.ManualDialogueNavCheck();
		};
		DialogueManager.SoundEffectCheck();
	};
	
	/*
	 * Shows the previous line of dialogue on-screen.
	 */ 
	public static function DecrementDialogue():Void {
		if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.manual){
			DialogueManager.DecrementLineIndex();
			DialogueManager.manualWrite();
			DialogueManager.ManualDialogueNavCheck();
		} else if (Settings.ActiveDialogueStyle == Settings.dialogueStyles.auto) {
			DialogueManager.DecrementLineIndex();
			DialogueManager.AutoplayText();
			DialogueManager.ManualDialogueNavCheck();
		};
		DialogueManager.SoundEffectCheck();
	};
};
