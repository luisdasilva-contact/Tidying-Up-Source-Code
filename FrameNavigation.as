/*
 * A class holding the frame number for scenes referenced in if statements throughout the program. Necessary because AS2 cannot check the
   frame label of the current frame.
 */ 
class FrameNavigation {
	public static var Intro = 2;
	public static var MainMenu = 3; 
	public static var PreGameIntro = 4;	
	public static var CampaignSelect = 5;
	public static var Campaign = 6;
	public static var LevelSelect = 7;
	public static var DLCLevelSelect = 8;
	public static var Epilogue = 9;
	public static var Settings = 10;
	public static var LevelEditor = 11; 
	public static var LevelEditorSetDialogue = 12; 
	public static var LevelEditorPreview = 13;
	public static var FileBrowser = 14;
	public static var EditOwnLevels = 15;
	public static var OST = 16;
	public static var DLCEnding = 17;
};