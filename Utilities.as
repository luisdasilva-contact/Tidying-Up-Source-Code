/*
 * General-use Flash utilities that can be re-used for other Flash projects.
 */ 
class Utilities {	
	/*
	 * Show the mouse cursor if the mouse is over any of the items in the given array, and prohibits such behavior for
	   a given MovieClip. Best used in scenarios where the child of a MovieClip will have the mouse shown when hovered over,
	   but not the parent itself.
	 * @param {Array} checkForMouseCollision The list of MovieClips and/or Buttons to check for collision with the mouse.
	 * @param {Array} The object that will not have the hand cursor displayed when hovered over.
	 */ 
	public static function ShowMouseIfColliding(checkForMouseCollision:Array, ignoreCollision:MovieClip):Void {
		for (var i = 0; i < checkForMouseCollision.length; i++){
			if (checkForMouseCollision[i].hitTest(_root._xmouse, _root._ymouse)){
				ignoreCollision.useHandCursor = true;
				return;
			};
		};
		ignoreCollision.useHandCursor = false;
	};
	
	/*
	 * A Movie Clip is given to serve as an animated screen transition (i.e. fade, screen wipe). At a specified frame in the transition animation, 
	   a function is provided to execute during the "blackout" portion of the transition (i.e. goToAndStop("targetFrame")). Note that this must be executed 
	   during every relevant frame, meaning this is best used as an OnEnterFrame function.
	 * @param {MovieClip} transitionMC The MovieClip containing the transition animation.
	 * @param {Number|String} transitionFrame A number or string representing the "blackout" portion of the screen transition.
	 * @param {Function} functionDuringTransition A function to execute during the "blackout" portion of the transition.
	 * @param {MovieClip} [nestedMC] Optional MC. For transitions with nested animations that must have their frames tracked *instead* of the parent MC, pass the nested
	   animation in here. 
	 * @param {Boolean} [deleteMCOnComplete] Optional boolean indicating whether the transitionMC (as well as any of its children) will have itself as well as its OnEnterFrame
	   functionality deleted upon completion. If false, only the OnEnterFrame behavior will be deleted, not the MC itself. Defaults to false.
	*/
	public static function TransitionActions(transitionMC:MovieClip, transitionFrame, functionDuringTransition:Function, nestedMC:MovieClip, deleteMCOnComplete:Boolean):Void {
		var MCToTrackFrames:MovieClip;
		if (nestedMC){
			MCToTrackFrames = nestedMC;
		} else {
			MCToTrackFrames = transitionMC;
		};
		
		if (MCToTrackFrames._currentframe == transitionFrame){
			functionDuringTransition();
		}; 
		
		if (MCToTrackFrames._currentframe == MCToTrackFrames._totalframes){
			if (deleteMCOnComplete){
				DeleteEnterFrameAndMC(transitionMC);
			} else {
				transitionMC.stop();
				if (nestedMC){
					nestedMC.stop();
				};
				delete transitionMC.onEnterFrame;
			};
		};
	};
	
	/*
	 * Delete's a Movie Clip's onEnterFrame function, and deletes the movieclip from the program.
	 * @param {MovieClip} mc The Movie Clip to manipulate.
	*/
	public static function DeleteEnterFrameAndMC(mc):Void {
		delete mc.onEnterFrame;
		
		if (mc.getDepth() < 0){
			mc.swapDepths(500); // definitely not a smart way of doing this but Ruffle does have its quirks
		};
		mc.removeMovieClip();
	};	
};