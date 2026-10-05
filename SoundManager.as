/*
 * Handles all sound-related functions. Users will select a sound via SoundLibraryEnum, which can 
   pass an index to getSoundByIndex. This will retrieve the sound from _soundLibrary.
 */ 
class SoundManager {
	private static var _songPos:Number = 0;
	private static var _soundLibrary:Array = [];	
	private static var _songLibrary:Array = [];	
	private static var _soundPlayerMC:MovieClip = null;
	private static var _songPlayerMC:MovieClip = null;
	private static var _MainMenuAndSettingsSoundCtrlMC:MovieClip = null; // so the main menu and settings songs can overlap
	// when fading
	private static var _numberOfUnlockedSongs:Number = 3; // increment this as songs are unlocked in campaign
	private static var _numberOfSongs:Number = 0;
	private static var _volumeAdjustmentValue:Number = 5;
	public static var SongCurrentlyPlaying;
	public static var SongCurrentlyPlayingName:String;
	public static var SongFadingFrom;
	public static var SoundCurrentlyPlaying;
	public static var isSongPlaying:Boolean = false;
	public static var CharacterIsTalking:Boolean = false;	
	public static var IndexOfCurrentSong:Number = 0;	
	public static var fadeOutTimeMS = 500;
	public static var fadeInTimeMS = 500;
	public static var fadingIntoSongIndex = null;
	public static var fadeIntervalID = null;
	public static var playedABCGateUnlockThisTurn:Boolean = false; // for making sure latches, gate sounds, etc. do not overlap for multiple gates and create this 
	public static var playedABCCageLatchThisTurn:Boolean = false;
	// awful cacophony if you're unlocking 20 gates
	private static var _MainMenuAndSettingsPosition:Number = 0;
	private static var _settingsSongPlayingInTandem;
	private static var SettingsFadeIntervalID = null;
	
	public static var SoundLibraryEnum:Object = {
		SwitchASnd: null,
		SwitchBSnd: null,
		SwitchCSnd: null,
		DoorBell: null,
		CapyTalk: null,
		RoombyTalk: null,
		Static: null,
		NextLevel: null,
		SwitchToRoombella: null,
		SwitchToCapy: null,
		UnlockGate: null,
		Latch: null,
		Teleport: null,
		CloneDeath: null,
		DoorCreak: null
	};
	
	public static var SongLibraryEnum:Object = {
		WelcomeSong: null, // menu		
		ImaginationCreationSong: null, // lvl editor
		HomeSong: null,	// lvl 1
		LivingRoomSong: null, // lvl2
		SweetDreamsSong: null, // lvl3
		SomethingSmellsSong: null, //  lvl4
		BoneAppleTeaSong: null, // lvl5 and lvl6
		RoundAndRoundSong: null, // lvl7 through lvl9
		GameDaySong: null, // lvl10
		OfficeSong: null, // lvl11
		GarageSong: null, // lvl12
		BasementSong: null, // lvl13
		AtticSong: null, // lvl14
		// end of campaign songs
		ThankYouSong: null,
		LikeTheViewSong: null, // settings	
		// DLC songs
		DLCLevelsTitle: null,
		WaiterSong: null,	
		RestaurantBathroomSong: null,
		Restaurant1Song: null,
		StinkySong: null,
		SewerSpiralSong: null,			
		Lab1Song: null,
		Lab2Song: null,
		Lab3Song: null,	
		Lab4Song: null,		
		FinalLevelSong: null,
		ExtraLevelsEnding: null
	};
	
	/*
	 * Initializes variables in the SoundManager.
	 */ 
	public static function InitSoundManager():Void {
		_songPlayerMC = _root.createEmptyMovieClip("_songPlayerMC", _root.getNextHighestDepth());
		_soundPlayerMC = _root.createEmptyMovieClip("_soundPlayerMC", _root.getNextHighestDepth());
		_initLibrary(SongLibraryEnum, _songLibrary, _songPlayerMC);
		_initLibrary(SoundLibraryEnum, _soundLibrary, _soundPlayerMC);
		CheckForNewSongToUnlock();
	};
	
	/*
	 * Initializes the given library.
	 * @param {Object} library The pseudo-enum containing the instance names of Sounds in the Flash library.
	 * @param {Array} library The array that will contain the Sounds from the Flash library.
	 * @param {MovieClip} The movie clip representing the player of the sound/song. Working with Flash limitation/quirk
	   where a Sound must be attached to a MovieClip to have its volume adjusted individually.
	 */ 
	private static function _initLibrary(libraryEnum:Object, library:Array, player:MovieClip):Void {
		var iteration:Number = 0;
		for (var key in libraryEnum){
			libraryEnum[key] = iteration;
			iteration++;
			var currentSound = new Sound(player);	
			currentSound.attachSound(key);
			library.push(currentSound);	
		};		
	};
	
	/*
	 * Retrieves a sound from the soundLibrary via its index. 
	 * @param {Number} indexVal The index of the sound in the library.
	 * @return {Sound} The Sound object from the library.
	 */ 
	private static function _getSoundByIndex(indexVal:Number):Sound {
		return _soundLibrary[indexVal];	
	};
	
	/*
	 * Retrieves a song from the songLibrary via its index. 
	 * @param {Number} indexVal The index of the song in the library.
	 * @return {Sound} The Sound object from the library.
	 */ 
	private static function _getSongByIndex(indexVal:Number):Sound {
		return _songLibrary[indexVal];	
	};
	
	/*
	 * Plays a Sound with the given index.
	 * @param {soundIndex} The index of the Sound to play.
	 */ 
	public static function PlaySound(soundIndex:Number):Void {
		var sound =  _getSoundByIndex(soundIndex);		
		sound.start();
		SoundCurrentlyPlaying = sound;
	};
	
	/*
	 * Plays a Sound, but does not place the sound in the "SoundCurrentlyPlaying".
	 * @param {soundIndex} The index of the Sound to play.
	 */ 	
	public static function PlaySoundOverride(soundIndex:Number):Void  {
		var sound =  _getSoundByIndex(soundIndex);		
		sound.start();
	};
	
	/*
	 * Play the "character talking" sound effect on loop.
	 * @param {Number} char The character (1 being Capy, 2 being Roomby) to play the speaking 
	   sound for.
	 */ 
	public static function PlayCharTalkingOnLoop(char:Number):Void {
		var charEnum = "";
		if (char == 1){
			charEnum = "CapyTalk";
		} else {
			charEnum = "RoombyTalk";
		};
		
		if (!CharacterIsTalking){
			CharacterIsTalking = charEnum;
			PlaySound(SoundLibraryEnum[charEnum]);
		} else if (charEnum != CharacterIsTalking) {
			StopCharacterTalking();
			CharacterIsTalking = charEnum;
			PlaySound(SoundLibraryEnum[charEnum]);
		} else {
			if (SoundCurrentlyPlaying.position == SoundCurrentlyPlaying.duration){
				SoundCurrentlyPlaying.position = 0;
				SoundCurrentlyPlaying.start();
			};		
		};
	};
	
	/*
	 * End the character speaking sound effect.
	 */ 
	public static function StopCharacterTalking():Void {
		if (CharacterIsTalking){
			CharacterIsTalking = null;
			SoundCurrentlyPlaying.stop();
		};
	};
	
	/*
	 * Plays a song with the given index.
	 * @param {soundIndex} The index of the song to play.
	 */ 
	public static function PlaySong(soundIndex:Number):Void {
		if (soundIndex == IndexOfCurrentSong && isSongPlaying){
			return;
		};
		
		if (SongCurrentlyPlaying){
			SongCurrentlyPlaying.stop(SongCurrentlyPlayingName);
			_songPos = 0;
		};
		
		SongCurrentlyPlaying =  _getSongByIndex(soundIndex);
		
		for(var id:String in SongLibraryEnum) {
		  var value:Number = SongLibraryEnum[id];
		  
		  if (value == soundIndex){
			  SongCurrentlyPlayingName = id;
			  break;
		  };
		};
		
		SongCurrentlyPlaying.start();	
		SongCurrentlyPlaying.onSoundComplete = function(){
			SongCurrentlyPlaying.start();
		};
		isSongPlaying = true;
		IndexOfCurrentSong = soundIndex;
	};
	
	private static function _PlaySettingsSongInTandem(){
		_MainMenuAndSettingsSoundCtrlMC = _root.createEmptyMovieClip("MainMenuAndSettingsSoundCtrlMC", 
		_root.getNextHighestDepth());
		
		
		_settingsSongPlayingInTandem = new Sound(_MainMenuAndSettingsSoundCtrlMC);
		_settingsSongPlayingInTandem.attachSound("LikeTheViewSong");
		_settingsSongPlayingInTandem.start();	
		_settingsSongPlayingInTandem.onSoundComplete = function(){
			_settingsSongPlayingInTandem.start();
		};		
		_settingsSongPlayingInTandem.setVolume(0);
	};
	
	/*
	 * Stops the song currently playing.
	 */ 
	public static function StopSong():Void {
		if (isSongPlaying){
			SongCurrentlyPlaying.stop(SongCurrentlyPlayingName);
			_songPos = SongCurrentlyPlaying.position;
			isSongPlaying = false;
		};
	};
	
	/*
	 * Continues the song that has been paused.
	 */ 
	public static function ContinueSong():Void {
		if (!isSongPlaying){
			SongCurrentlyPlaying.start(_songPos / 1000);
			isSongPlaying = true;
		};
	};
	
	/*
	 * Pauses/un-pauses the current song.
	 */ 
	public static function ToggleSongPlaying():Void {
		if (isSongPlaying){
			StopSong();			
		} else {
			ContinueSong();
		};
	};
	
	/*
	 * Plays a song by an index adjustment (i.e. a value of 1 plays the next song
	   in the list, a value of -1 plays the previous song).
	 @ param {Number} index The index adjustment.
	 */ 
	public static function PlaySongByIndexAdjustment(index:Number):Void {
		if (IndexOfCurrentSong + index < 0){
			index = _numberOfUnlockedSongs - 1;
		} else if (IndexOfCurrentSong + index >= _numberOfUnlockedSongs){
			index = 0;
		} else {
			index = IndexOfCurrentSong + index;
		};
		PlaySong(index);
	};
	
	/*
	 * Checks the user's current campaign level and sees if there are any songs to unlock.
	 */ 
	public static function CheckForNewSongToUnlock():Void {
		var unlockTracks:Number = 0;
		var levelsToUnlockSongsFor:Number = MapLogic.FurthestLevelReached;
		var DLCUnlockValue:Number = DLCLevelLogic.FurthestDLCLevelReached;
		
		if (MapLogic.FurthestLevelReached + 1 >= MapLayouts.Campaign.length){
			unlockTracks = 13;
		};
		
		if (DLCLevelLogic.FurthestDLCLevelReached + 1 >= MapLayouts.DLCCampaign.length){
			unlockTracks += 12; // replace 0 w/ however many DLC tracks there are
		};
		
		if (unlockTracks == 0){
			if (_numberOfUnlockedSongs > 0){
				unlockTracks = _numberOfUnlockedSongs;
			} else {
				unlockTracks = _numberOfUnlockedSongs;
			};
		};
		
		if (unlockTracks > _numberOfUnlockedSongs){
			_numberOfUnlockedSongs = unlockTracks;
		};
	};
	
	/*
	 * Plays the default track for the level and/or area of the game the user is in.
	 */ 
	public static function PlayDefaultTrack():Void {		
		if (_root._currentframe != FrameNavigation.MainMenu &&
			_root._currentframe != FrameNavigation.Settings){
				_destroyInTandemSettingsSong(); // don't want the Settings song playing in BG and taking up resources
				// if you're anywhere but the main menu or settings
		};
		
		if (_root._currentframe == FrameNavigation.MainMenu){
			// play song normally if there's no fading song.
			
			if (_MainMenuAndSettingsSoundCtrlMC == null){
				_PlaySettingsSongInTandem();
			} else {
				SetSettingsSongFadeOutInterval();				
				_setFadingIntoSongIndex(SongLibraryEnum.WelcomeSong);
				fadeIntervalID = setInterval(IncreaseVolumeOfCurrentTrackByDefaultValue, 25);				
			}
			
			if ((!fadeIntervalID && !SettingsFadeIntervalID)){
				PlaySong(SongLibraryEnum.WelcomeSong);
			} else if (!fadeIntervalID){
				// coming from anywhere BUT Settings
				_setFadingIntoSongIndex(SongLibraryEnum.WelcomeSong);	
				fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
			};
		} else if (_root._currentframe == FrameNavigation.Campaign){
			if (GameplayLogic.ActiveCampaign == 0){			
				if (MapLogic.CurrentCampaignLvlNum == 0){
					_setFadingIntoSongIndex(SongLibraryEnum.HomeSong);				
				} else if (MapLogic.CurrentCampaignLvlNum == 1){
					_setFadingIntoSongIndex(SongLibraryEnum.LivingRoomSong);
				} else if (MapLogic.CurrentCampaignLvlNum == 2){
					_setFadingIntoSongIndex(SongLibraryEnum.SweetDreamsSong);
				} else if (MapLogic.CurrentCampaignLvlNum == 3){
					_setFadingIntoSongIndex(SongLibraryEnum.SomethingSmellsSong);
				} else if (MapLogic.CurrentCampaignLvlNum == 4 || MapLogic.CurrentCampaignLvlNum == 5){
					_setFadingIntoSongIndex(SongLibraryEnum.BoneAppleTeaSong);
				} else if (MapLogic.CurrentCampaignLvlNum >= 6 && MapLogic.CurrentCampaignLvlNum <= 8){
					_setFadingIntoSongIndex(SongLibraryEnum.RoundAndRoundSong);	
				} else if (MapLogic.CurrentCampaignLvlNum == 9){
					_setFadingIntoSongIndex(SongLibraryEnum.GameDaySong);	
				} else if (MapLogic.CurrentCampaignLvlNum == 10){
					_setFadingIntoSongIndex(SongLibraryEnum.OfficeSong);	
				} else if (MapLogic.CurrentCampaignLvlNum == 11){
					_setFadingIntoSongIndex(SongLibraryEnum.GarageSong);	
				} else if (MapLogic.CurrentCampaignLvlNum == 12){
					_setFadingIntoSongIndex(SongLibraryEnum.BasementSong);	
				} else if (MapLogic.CurrentCampaignLvlNum == 13){
					_setFadingIntoSongIndex(SongLibraryEnum.AtticSong);	
				};
			} else if (GameplayLogic.ActiveCampaign == 1){
				if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 0){
					_setFadingIntoSongIndex(SongLibraryEnum.WaiterSong);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 1){
					_setFadingIntoSongIndex(SongLibraryEnum.RestaurantBathroomSong);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 2){
					_setFadingIntoSongIndex(SongLibraryEnum.Restaurant1Song);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 3){
					_setFadingIntoSongIndex(SongLibraryEnum.StinkySong);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 4){
					_setFadingIntoSongIndex(SongLibraryEnum.SewerSpiralSong);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 5){
					_setFadingIntoSongIndex(SongLibraryEnum.Lab1Song);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 6){
					_setFadingIntoSongIndex(SongLibraryEnum.Lab2Song);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 7){
					_setFadingIntoSongIndex(SongLibraryEnum.Lab3Song);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 8){
					_setFadingIntoSongIndex(SongLibraryEnum.Lab4Song);	
				} else if (DLCLevelLogic.CurrentDLCCampaignLvlNum == 9){
					_setFadingIntoSongIndex(SongLibraryEnum.FinalLevelSong);	
				};
			};
			fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
		} else if (_root._currentframe == FrameNavigation.CampaignSelect){
			_setFadingIntoSongIndex(SongLibraryEnum.DLCLevelsTitle);	
			fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
		} else if (_root._currentframe == FrameNavigation.LevelEditor){
			_setFadingIntoSongIndex(SongLibraryEnum.ImaginationCreationSong);	
			fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
		} else if (_root._currentframe == FrameNavigation.Settings){
			_setFadingIntoSongIndex(SongLibraryEnum.LikeTheViewSong);
			fadeIntervalID = setInterval(_fadeIntoSettingsMusic, 25);			
		} else if (_root._currentframe == FrameNavigation.Epilogue){
			_setFadingIntoSongIndex(SongLibraryEnum.ThankYouSong);	
			fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
		} else if (_root._currentframe == FrameNavigation.DLCEnding){
				_setFadingIntoSongIndex(SongLibraryEnum.ExtraLevelsEnding);	
				fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
		} else {
				_setFadingIntoSongIndex(SongLibraryEnum.HomeSong);	
				fadeIntervalID = setInterval(_fadeFromCurrentSongToNewSong, 25);
		};
		
		if (_root.MusicPlayingTxt){
			UI.ChangeMusicLabel(UI._songTitles[SoundManager.IndexOfCurrentSong]);
			//_root.MusicPlayingTxt.text = UI._songTitles[SoundManager.IndexOfCurrentSong];
		};
	};
	
	/*
	 * Sets the index of the song that will be faded into.
	 * @param {Number} newIndex The index of the song that will be faded into. 
	 */ 
	private static function _setFadingIntoSongIndex(newIndex:Number):Void {				
		if (fadeIntervalID){				
			clearInterval(fadeIntervalID);
		};
		fadeIntervalID = null;
		SongFadingFrom = SongCurrentlyPlaying;
		fadingIntoSongIndex = newIndex;
	};
	
	// ugh
	private static function SetSettingsSongFadeOutInterval(){
		if (SettingsFadeIntervalID){
			clearInterval(SettingsFadeIntervalID);
		};
		
		SettingsFadeIntervalID = setInterval(_fadeSettingsSongOut, 
				25);
	};
	
	private static function _fadeSettingsSongOut(){
		if (_settingsSongPlayingInTandem.getVolume() > 0){
			_settingsSongPlayingInTandem.setVolume(_settingsSongPlayingInTandem.getVolume() - 5);
		} else {
			_settingsSongPlayingInTandem.setVolume(0);
			clearInterval(SettingsFadeIntervalID);
		};
	};
	
	/*
	 * Fade from the current song to the new one, specified by _setFadingIntoSongIndex.
	 */ 
	private static function _fadeFromCurrentSongToNewSong():Void {		
		if (fadeIntervalID != null){
			if (SongFadingFrom.getVolume() > 0 && IndexOfCurrentSong != fadingIntoSongIndex){
				ReduceVolumeOfSongFadingFromTrack(_volumeAdjustmentValue);
			} else if (SongFadingFrom.getVolume() == 0 && IndexOfCurrentSong != fadingIntoSongIndex){
				SongFadingFrom.stop(SongCurrentlyPlayingName);
				SongFadingFrom = null;
				PlaySong(fadingIntoSongIndex);
				SongCurrentlyPlaying.setVolume(0);
			} else {
				if (SongCurrentlyPlaying.getVolume() < 100){				
					IncreaseVolumeOfCurrentTrack(_volumeAdjustmentValue);
				} else if (SongCurrentlyPlaying.getVolume() == 100){
					clearInterval(fadeIntervalID);	
					fadingIntoSongIndex = null;			
					fadeIntervalID = null;						
				};
			};	
		};
	};
	
	private static function _fadeIntoSettingsMusic(){
		if (fadeIntervalID != null){
			if (SongFadingFrom.getVolume() > 0){
				ReduceVolumeOfSongFadingFromTrack(5);
			} else {
				SongFadingFrom.setVolume(0);
			};
			if (_settingsSongPlayingInTandem.getVolume() < 100){
				_settingsSongPlayingInTandem.setVolume(_settingsSongPlayingInTandem.getVolume() + 5);
			} else if (_settingsSongPlayingInTandem.getVolume() >= 100){
				clearInterval(fadeIntervalID);	
				fadingIntoSongIndex = null;			
				fadeIntervalID = null;				
			};		
			
		};
	};
	
		private static function _destroyInTandemSettingsSong(){
			_settingsSongPlayingInTandem.stop();
			_MainMenuAndSettingsSoundCtrlMC.removeMovieClip();
			_MainMenuAndSettingsSoundCtrlMC = null;
		};
	
	/*
	 * Reduces the volume of the current song fading out by the number of units specified in volumeAdjustmentValue.
	 */ 
	public static function ReduceVolumeOfSongFadingFromTrack(reductionValue:Number):Void {
		if (SongFadingFrom.getVolume() - reductionValue < 0){
			SongFadingFrom.setVolume(0);
		} else {
			SongFadingFrom.setVolume(SongFadingFrom.getVolume() - reductionValue);
		};
	};
	
	/*
	 * Reduces the volume of the current song by the number of units specified in volumeAdjustmentValue.
	 */ 
	public static function ReduceVolumeOfCurrentTrack(reductionValue:Number):Void {		
		if (SongCurrentlyPlaying.getVolume() - reductionValue < 0){
			SongCurrentlyPlaying.setVolume(0);
		} else {
			SongCurrentlyPlaying.setVolume(SongCurrentlyPlaying.getVolume() - reductionValue);
		};
	};
	
	/*
	 * Increases the volume of the current song by the number of units specified in volumeAdjustmentValue.
	 */ 
	public static function IncreaseVolumeOfCurrentTrack(incrementValue:Number):Void {		
		if (SongCurrentlyPlaying.getVolume() + incrementValue > 100){
			SongCurrentlyPlaying.setVolume(100);
		} else {
			SongCurrentlyPlaying.setVolume(SongCurrentlyPlaying.getVolume() + incrementValue);
		};
	};
	
	/*
	 * Increases the volume of the current song by the number of units specified in volumeAdjustmentValue.
	 */ 
	public static function IncreaseVolumeOfCurrentTrackByDefaultValue():Void {		
		if (SongCurrentlyPlaying.getVolume() + _volumeAdjustmentValue > 100){
			SongCurrentlyPlaying.setVolume(100);
		} else {
			SongCurrentlyPlaying.setVolume(SongCurrentlyPlaying.getVolume() + _volumeAdjustmentValue);
		};
	};
	
	/*
	 * For a given gateType (A, B, or C), plays the corresponding gate sound.
	 */ 
	public static function PlayABCGateSound(gateType:String):Void {
		if (!playedABCGateUnlockThisTurn){
			if (gateType == "A"){
				PlaySound(SoundLibraryEnum.SwitchASnd);
			} else if (gateType == "B"){
				PlaySound(SoundLibraryEnum.SwitchBSnd);
			} else if (gateType == "C"){
				PlaySound(SoundLibraryEnum.SwitchCSnd);
			};
			playedABCGateUnlockThisTurn = true;
		};
	};
};