/*
 * Manages functions related to user preferences in the Settings menu.
 */ 
class Settings {
	private static var _displayHints:Boolean = true;
	private static var _dialogueStyles = {auto: "auto", manual: "manual"};
	private static var _activeDialogueStyle:String = _dialogueStyles.manual;
	private static var _altTransition = false;
	
	/*
	 * Retrieves status of whether or not user indicated they want to receive in-game hints.
	 * @return {Boolean} User does or does not want hints.
	 */ 
	public static function get displayHints():Boolean {
		return _displayHints;
	};
	
	/*
	 * Retrieves status of whether or not user indicated they want dialogue to automatically play
	   or if they want to manually control dialogue.
	 * @return {String} From the faux-enum _dialogueStyles, returns "auto" or "manual".
	 */ 
	public static function get ActiveDialogueStyle():String {
		return _activeDialogueStyle;
	};
	
	/*
	 * Retrieves status of whether or not user wants to use the alternate, 
	   epilepsy-friendly level transition.	   
	 * @return {Boolean} User does or does not want alt transition.
	 */ 
	public static function get altTransition():Boolean {
		return _altTransition;
	};
	
	/*
	 * Retrieves an object containing the potential dialogue styles the user can choose from. 
	 * @return {Object} Returns the _dialogueStyles pseudo-enum.
	 */ 
	public static function get dialogueStyles():Object {
		return _dialogueStyles;
	};
	
	/*
	 * Toggle for users to indicate if they want to receive hints.
	 */ 
	public static function ToggleHints():Void {
		_displayHints = !_displayHints;
	};
	/*
	 * Toggles whether or not user uses the alternate, epilepsy-friendly level transition.
	 */ 
	public static function ToggleAltTransition():Void {
		_altTransition = !_altTransition;
	};
	
	/*
	 * Sets the active dialogue style to autoplay dialogue.
	 */ 
	public static function SetActiveDialogueStyleToAuto():Void {
		_activeDialogueStyle = _dialogueStyles.auto;
	};
	
	/*
	 * Sets active dialogue style to provide users with controls to navigate dialogue.
	 */ 
	public static function SetActiveDialogueStyleToManual():Void {
		_activeDialogueStyle = _dialogueStyles.manual;
	};
};