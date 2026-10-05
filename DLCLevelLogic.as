
/*
 * Manages level-based functionality and variables for the DLC campaign.
 */ 
class DLCLevelLogic {
	public static var CurrentDLCCampaignLvlNum:Number = null;
	public static var DLCDirtCleaned:String = null;
	public static var MovesInAllDLCLevels:Array;
	public static var FurthestDLCLevelReached:Number = 0;
	
	/*
	 * Initializes the DirtCleaned variable. Appends to the existing DirtCleaned variable if there is one.
	 */ 
	public static function InitDLCDirtTracking():Void {
		for (var i = 0; i < MapLayouts.DLCCampaign.length; i++){
			if (DLCDirtCleaned == null){
				DLCDirtCleaned = "F";
			} else {
				DLCDirtCleaned = DLCDirtCleaned + "F";
			};
		};
	};	
	
	/*
	 * Initializes the MovesInAllLevels variable. Appends to the existing MovesInAllLevels variable if there is one.
	 */ 
	public static function InitMovesInAllDLCLevels():Void {
		if (MovesInAllDLCLevels == null){
			MovesInAllDLCLevels = [];
		};
		
		for (var i = 0; i < MapLayouts.DLCCampaign.length; i++){
			MovesInAllDLCLevels.push(0);
		};
	};
};