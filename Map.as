/*
 * Map objects represent relevant properties for a level.  
 */

class Map {
	public var MapWidth:Number;
	public var MapHeight:Number;
	public var LevelTiles:Array;
	public var Character1Spawn;
	public var Character2Spawn;
	public var CharacterDialogue:String;
	public var LevelTitle:String;
	
	// A map object, representing a simple map and its components.
	public function Map(mapWidth:Number, mapHeight:Number, levelTiles:Array, character1Spawn:Object, character2Spawn:Object, 
		characterDialogue:String, levelTitle:String){
		this.MapWidth = mapWidth;
		this.MapHeight = mapHeight;
		this.LevelTiles = levelTiles;
		this.Character1Spawn = character1Spawn;
		this.Character2Spawn = character2Spawn;
		this.CharacterDialogue = characterDialogue;
		this.LevelTitle = levelTitle;
	};
};
