/*
 * Stores the level design for each of the campaign levels.
 */ 
class MapLayouts {
	// A = red, B = orange, blue = C
	public static var Tiles = {Default: 0, Wall: 1, Dirt: 2, Goal: 3, Key1: 4, Gate1: 5, 	
	Portal_A: 6, Portal_B: 7, Portal_C: 8,
	ABCSwitch_A: "A", ABCSwitch_B: "B", ABCSwitch_C: "C", 
	ABCGate_A_open: "D", ABCGate_B_open: "E", ABCGate_C_open: "F",
	ABCGate_A_closed: "G", ABCGate_B_closed: "H", ABCGate_C_closed: "I",
	Timer9: "J", Timer8: "K", Timer7: "L", Timer6: "M", Timer5: "N", Timer4: "O",
	Timer3: "P", Timer2: "Q", Timer1: "R", TimerOpen: "S",	
	Cloner: "T", 
	ABCCage_A_open: "U", ABCCage_B_open: "V", ABCCage_C_open: "W",
	ABCCage_A_closed: "X", ABCCage_B_closed: "Y", ABCCage_C_closed: "Z"
	};
	
	public static var EditorBaseMap:Map = new Map(
		15,
		15,		
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], 		
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]		
		],
		{x: 2, y: 2},
		{x: 2, y: 3}, // OG spawns
		"",
		"My Cool Level"
	);

	private static var _lvl1:Map = new Map (			
		15,
		15,		
		[ 
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 1],
		[1, 0, 1, 0, 0, 2, 2, 2, 2, 2, 2, 1, 1, 0, 1],
		[1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 4, 1, 1, 0, 1],
		[1, 0, 1, 1, 2, 2, 2, 2, 2, 2, 2, 1, 1, 0, 1],
		[1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 4, y: 8},
		{x: 4, y: 7},
		"¶Whoa! Is this... my entry way?" +
		"µYep! My navigation system was able to get it all mapped out for us!" +
		"¶And this stuff? That must be trash, right?" + 
		"øExactly! With your help, we'll have this place cleaned up in no time!" + 
		"¶Thanks Roomby, I really don't know what I'd do without your help..." + 
		"µIt's no trouble at all! Now let's get started!",
		"Entry Way"
	);
	
	private static var _lvl2:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 1, 1, 2, 2, 2, 1, 1, 1, 0, 1],
		[1, 0, 0, 0, 1, 2, 1, 0, 0, 2, 1, 3, 1, 0, 1],
		[1, 0, 1, 1, 1, 2, 0, 0, 0, 2, 2, 0, 1, 0, 1],
		[1, 0, 1, 2, 2, 2, 0, 0, 0, 2, 1, 1, 1, 0, 1],
		[1, 0, 1, 2, 0, 0, 0, 0, 0, 2, 1, 1, 1, 0, 1],
		[1, 0, 1, 0, 0, 1, 0, 0, 0, 2, 2, 2, 1, 0, 1],
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 3, y: 8},
		{x: 3, y: 9},
		"ßOh....I see what you mean." +
		"±It's really bad, isn't it?" +
		"µHey now, I didn't say I was giving up!" +
		"µWe're gettin' through this together, okay?" +
		"±..." +
		"¶Okay." +
		"øThat's the spirit!" +
		"¶Just let me know how I can help." +
		"ßWell, it's kind of embarrassing, but I've always..." +
		"ßHad kind of a one track mind." +
		"µWhat I mean is...I can only move in straight lines." +
		"µDo you think you could--?" +
		"¶You want me to help you stop if you ever get off track?" +
		"øEXACTLY." +
		"øThat'd be such a huge help, you have no idea." +
		"¶Can do!",
		"Living Room"
	);
	
	private static var _lvl3:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 2, 2, 2, 0, 0, 1, 1, 1, 0, 0, 1],
		[1, 0, 0, 1, 2, 2, 2, 0, 0, 2, 0, 1, 0, 0, 1],
		[1, 0, 0, 1, 2, 1, 2, 0, 0, 2, 3, 1, 0, 0, 1],
		[1, 0, 0, 1, 2, 0, 2, 1, 0, 2, 0, 1, 0, 0, 1],
		[1, 0, 0, 1, 2, 0, 1, 2, 1, 1, 1, 1, 0, 0, 1],
		[1, 0, 0, 1, 2, 0, 0, 2, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 4, y: 10},
		{x: 5, y: 10},
		"ßOof. Things aren't getting any better in here, huh?" +
		"±..." +
		"ßOh! I'm sorry Capy!" +
		"ßI didn't mean to hurt your feelings!" +
		"±No, it's okay... I know it's gotten out of control." +
		"µSo, what made you decide today was the day anyway?" +
		"¶Hehe, well, I've actually met someone new." +
		"øAw! I'm so proud of you!" +
		"µHow long's it been? Why didn't you tell me earlier?" +
		"¶It's only been a couple weeks!" +
		"¶...But I really like him. I wanted to invite him over here for once." +
		"µThat's really sweet! You gonna cook him dinner?" +
		"¶That's the idea!" +
		"µWow, we'd better start cleaning then." +
		"øSounds like you'll be needing this room REAL soon!" +
		"±HEY!" +
		"øScandalous! Hehe.",
		"Bedroom 1"
	);
	
	private static var _lvl4:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 1, 0, 0, 2, 2, 1, 1, 1, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 1, 4, 1, 0, 0, 1, 0, 1],
		[1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 2, 0, 0, 0, 1],
		[1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
		[1, 0, 0, 1, 0, 1, 0, 1, 5, 1, 0, 1, 0, 0, 1],
		[1, 0, 1, 0, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 4, y: 8},
		{x: 12, y: 10},
		"ßOh, Capy...." +
		"±You promised you weren't gonna say anything anymore!" +
		"ßBut isn't this your only bathroom?" +
		"±..." +
		"ßOh, Capy..." +
		"±...It would be nice to take a bath again.",
		"Bathroom"
	);
	
	private static var _lvl5:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 0, 0, 0, 1, 2, 1, 0, 0, 1, 4, 1, 0, 1],
		[1, 2, 2, 2, 2, 2, 2, 1, 0, 1, 2, 2, 2, 0, 1],
		[1, 2, 1, 2, 2, 2, 2, 5, 0, 0, 0, 0, 0, 0, 1],
		[1, 2, 0, 2, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 2, 2, 2, 1, 2, 2, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1],
		[1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
		[1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1],
		[1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1],
		[1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1],
		[1, 0, 1, 0, 2, 2, 2, 2, 2, 2, 2, 1, 1, 3, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 8, y: 9},
		{x: 1, y: 13},
		"µSo, what's his name anyway?" +
		"¶Huh?" +
		"øYour new boyfriend! " +
		"¶Oh! It's Jacob." +
		"øAnd....where you'd meet, etc etc? You know I need the whole scoop!" +
		"¶Jeez, pushy pushy!" +
		"¶Hmmm, well, we met online...he likes swimming and burrowing....and...." +
		"¶He's got kind eyes." +
		"øAw, swoon!" +
		"ß...how long has it been since-- you know?" +
		"±..." +
		"ßI'm sorry...I spoiled the moment, huh?" +
		"±..." +
		"ßForget it, it's none of my business anyway. " +
		"µWe'll just get back to cleaning." +
		"±...okay.",
		"Kitchen"
	);
	
	private static var _lvl6:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
		[1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 1],
		[1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 2, 1],
		[1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 2, 0, 0, 0, 4, 1, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 2, 0, 0, 0, 5, 3, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 2, 0, 1, 0, 0, 1, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 1},
		{x: 12, y: 13},
		"ßI'm really sorry about earlier, I didn't mean to bring up bad memories..." +
		"±They aren't bad memories, that's part of why it's been hard..." +
		"ßYeah, I s'pose that's true." +
		"±..." +
		"µI meant it when I said I was proud of you though!" +
		"µGetting back on the dating scene has gotta be a big step!" +
		"¶Thanks." +
		"¶I'm still a little nervous, but they're mostly good jitters I think." +
		"øYou got this!" + 
		"¶I hope so." +
		"øI believe in you! Now let's clean this room!",
		"Bedroom 2"
	);
	
	private static var _lvl7:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 2, 1, 0, 1, 1],
		[1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 4, 1, 1],
		[1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 1, 1],
		[1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1],
		[1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 5, 3, 1, 1],
		[1, 1, 1, 0, 1, 2, 0, 0, 0, 0, 0, 1, 1, 1, 1],
		[1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1],
		[1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 12, y: 3},
		{x: 7, y: 8},
		"±Let me just apologize in advance for putting you through this one." +
		"µHmm? What makes this room any worse than the others?" +
		"¶Oh, right, you don't have a nose...uh, nevermind then." +
		"¶...Maybe I'll just toss in a few loads while we're here.",
		"Laundry Room"
	);
	
	private static var _lvl8:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 2, 2, 2, 2, 2, 1, 0, 0, 0, 2, 2, 2, 1],
		[1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 0, 0, 5, 0, 0, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 2, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 3, 0, 0, 0, 0, 0, 0, 1],
		[1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
		[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 2, 0, "A", "G", 0, 0, 4, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2, 2, 0, 1],
		[1, 2, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 2, y: 11},
		{x: 7, y: 5},
		"ßUmmm..." +
		"µOkay, question..." +
		"¶Hmm?" +
		"µThis place seems WAY too big for you. " +
		"µWhy do you need three bedrooms?" +
		"¶They came with the house." +
		"µBut like, obviously you looked at other houses before you bought this one..." +
		"¶Hmmm? No, just this one." +
		"ßThis is the only place you ever looked at?" +
		"¶What's wrong? It seemed like a nice enough place." +
		"ßThat's not--" +
		"µOkay, another time, we'll have this talk another time." +
		"¶I thought it could be fun to sleep in a different bed each night." +
		"ßNo, we're done having this conversation, you can stop now." +
		"±…",
		"Bedroom 3"
	);
	
	private static var _lvl9:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 0, 0, 1],
		[1, 0, 1, 0, 0, 0, 2, 2, 2, 5, 0, 1, 0, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, "A", 1, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 1, 1, 1, 1, "B", 1, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 1, 2, 2, 2, 1, 2, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 0, 1, 2, 1, 1, 0, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 0, "G", 4, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 6, y: 9},
		{x: 3, y: 4},
		"ß...Can I ask how it started?" +
		"¶How what--?" +
		"±Oh..." +
		"¶I feel like you already kind of know." +
		"±When James left, I just wanted to forget..." +
		"±And I tried my best to bury those memories..." +
		"±...but I couldn't bear the thought of throwing any of it out." +
		"±...And so, I guess I just buried myself alongside them." +
		"ßI'm so sorry Capy..." +
		"ßDo you--?" +
		"±Miss him? I guess so...I don't know." +
		"±I just wish I had some closure." +
		"ß..." +
		"¶I'm moving on now though, right?" +
		"¶Let's get back to work!" +
		"ß..." +
		"ß...Capy...",
		"Dining Room"			
	);
	
	private static var _lvl10:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 3, 0, 5, 0, 0, "B", 2, 0, 4, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1],
		[1, "G", "G", 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, "G", 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, "I", 1],
		[1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1],
		[1, 2, 0, 0, 0, 0, 2, 0, 2, 0, 0, 1, 0, 2, 1],
		[1, 2, 0, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 2, 1],
		[1, 2, 2, 2, 2, 2, "C", 2, 2, 2, 2, 2, 2, 2, 1],
		[1, 1, 1, 1, 1, 1, 2, 0, 2, 0, 0, 0, 0, 2, 1],
		[1, 0, 0, 0, 0, 0, 2, 1, 2, 2, 2, 2, 1, 2, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 6},
		{x: 1, y: 13},
		"µWoah! This room..." +
		"¶Pretty impressive, isn't it?" +
		"µWell, you've certainly got a lot to keep you busy!" +
		"¶You bet! We'll have to play a round of air hockey once we're done here!" +
		"ß..." +
		"±What's wrong?" +
		"ßWell...it's just...you're not like--" +
		"ßI mean...after we're all done here..." +
		"ßHow do I know you're not just gonna fall back into your old ways?" +
		"¶Hmmm..." +
		"ßI'm just worried, you know?" +
		"±I guess I can't really promise anything..." +
		"ß..." +
		"¶...But your encouragement has really made such a difference." +
		"ßOh, Capy..." +
		"µYou know I'll always be here." +
		"µYou just have to remember to ask." +
		"±I know..." +
		"µGive me a hug you silly thing.",
		"Game Room"			
	);
	
	private static var _lvl11:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 0, 1, 1],
		[1, 1, 1, 1, 2, 0, 0, 0, 0, 0, "D", 0, 2, 1, 1],
		[1, 1, 1, 1, 2, 0, "H", 0, 0, 0, 0, 0, 2, 1 , 1],
		[1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1],
		[1, 1, 1, 1, 2, 2, 2, 2, 2, 2, "H", 2, "H", 1, 1],
		[1, 1, 1, 1, 2, 2, 0, 0, 0, 0, 2, 2, 2, 1, 1],
		[1, 1, 1, 1, 2, 2, 0, 0, 0, "I", 2, 2, 2, 1, 1],
		[1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2, 0, 1, 1, 1],
		[1, 1, 1, 1, 0, 0, 0, 0, "A", 0, 2, 3, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 4, y: 10},
		{x: 12, y: 1},
		"µIs this your office or something?" +
		"¶Yeah...We used to work together in here." +
		"µYou and James?" +
		"¶Yeah. We'd sit back to back during the day." +
		"¶He'd swivel around every so often to pull me away..." +
		"¶Or just remind me to have lunch, hehe" +
		"ßWhat is it that you do anyway?" +
		"¶Oh, I just manage accounts for this big tech company." +
		"ßSounds stressful." +
		"¶I've always thought it was kind of fun actually." +
		"¶Staring at numbers just helps take my mind off everything else." +
		"ßI could never...." +
		"µAlthough... I guess I'm the same with cleaning." +
		"øI just love to imagine that transformation once I'm done with it." +
		"øIt's such a satisfying feeling." +
		"¶Yeah! You get it." +
		"¶I just like solving problems." +
		"øWell, you'll have one less problem soon!",
		"Office"			
	);
	
	private static var _lvl12:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 2, 1, "F", 0, 0, "H", 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, "H", 0, 0, 0, 0, 0, 0 , 1],
		[1, 0, 0, 0, 0, "G", 0, 0, 0, 0, 0, "D", 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 1],
		[1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "H", 0, 0, 1],
		[1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 1],
		[1, 0, 0, 0, 0, 2, 0, 0, 2, 2, 2, 2, 0, 0, 1],
		[1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 1],
		[1, "A", "B", 2, 0, 0, 0, 0, 1, 0, 0, 3, 0, 0, 1],
		[1, 0, "C", 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 13},
		{x: 11, y: 2},
		"ßCapy, this is a three car garage..." +
		"ßYou don't even own ONE car!" +
		"¶But it's so nice for storing stuff!" +
		"ßI'm not sure that's such a good thing in your case..." +
		"±Maybe not..." +
		"µMaybe....you could have a garage sale after it's all cleaned up." +
		"¶Hey, that sounds like a good idea!" +
		"±..." +
		"±You wouldn't mind helping, would you?" +
		"øFor half the profits?" +
		"¶You've got a deal!" +
		"ßHaha, I was just kidding!" +
		"µ..." +
		"µI'd take 25 percent though...",
		"Garage"			
	);
	
	private static var _lvl13:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 0, 0, 1],
		[1, 1, "A", 0, "B", "C", "G", 2, 2, 1, 4, 1, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, "A", 1, 1],
		[1, 0, 1, 3, 1, 0, 0, 1, 2, 0, 0, 0, 0, 1, 1],
		[1, 0, 1, 5, 1, 0, 0, 1, 2, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 2, 2, 2, 2, 2, "G", 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, "B", 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, "E", 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, "B", 0, 0, 1, 2, 0, 1],
		[1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 2, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
		[1, 0, 2, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]			
		],
		{x: 13, y: 1},
		{x: 3, y: 2},
		"¶Wow, I haven't been down here in quite a while." + 
		"µSounds like you're just as scared of basements as I am." +
		"±Well, it's not exactly that..." +
		"ßOh..." +
		"ßAre there memories down here?" +
		"±This is where I kept most of his things...the rest are in the attic." +
		"ßSaved the hardest rooms for last, huh?" +
		"ßAre you sure you're gonna be okay going through it all?" +
		"¶Yeah...I'll be okay. I should have done this a long time ago." +
		"¶I'm over him now, I'm just so sentimental about it." +
		"ßWell, you don't have to get rid of any of it unless you want to..." +
		"ßWe can still organize--" +
		"¶No...I think I want to. I think it's something I need to do." +
		"¶For my own sake." +
		"øThatta boy!",
		"Basement"			
	);
	
	private static var _lvl14:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
		[1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1],
		[1, 1, 0, 0, 0, 1, 2, 2, 1, 2, 0, 0, 1, 0, 1],
		[1, 0, 1, 0, 0, 0, 2, 1, 0, 0, "H", 0, 1, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 0, 5, 0, 0, 2, 1, "A", 1],
		[1, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 1, 0, 1],
		[1, 1, 0, 0, 0, 1, 2, 3, 2, 1, 0, 2, 1, 0, 1],
		[1, 1, "E", 1, 1, 1, 2, 2, 2, 1, 0, 2, 1, 0, 1],
		[1, 2, 0, 0, 0, 1, 1, 1, 1, 0, 0, 2, 1, 0, 1],
		[1, 1, "F", 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
		[1, 4, 0, 0, 0, 1, 0, 0, "B", "A", 0, 0, 1, 0, 1],
		[1, 0, "A", 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1],
		[1, 0, 2, 1, 1, 2, 2, 1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 11, y: 3},
		{x: 1, y: 13},
		"µSo this is it, huh? The last room?" +
		"¶Yep, this is it." +
		"µSo how are you gonna celebrate once we're all done?" +
		"¶Hmmm...." +
		"¶I dunno!" +
		"µBORING!" +
		"¶What do you think I should do then?" +
		"µHow about you AND ME go out for dinner" +
		"ø...your treat!" +
		"±My treat?" +
		"øOh, why thank you for the kind offer! I accept!" +
		"±Hey!" +
		"øHehehe" +
		"¶Okay, fine, I suppose you've earned it anyway." +
		"øYAY! Can I choose the restaurant too?" +
		"±Is 'no' an option?" +
		"øNOPE!" +
		"µ..." +
		"µNah, it's okay, you can choose, hehe." +
		"øDon't pretend you can't afford it though!",
		"Attic"			
	);
	
	private static var _DLClvl1:Map = new Map (			
		15,
		15,
		/*[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 4, 2, 1, 2, 2, 1, "A", "B", "I", "F", 0, 1, 3, 1],
		[1, 2, "H", 2, 2, 2, 2, "C", 1, "F", 1, 0, 1, 5, 1],
		[1, 1, 1, 1, "I", 1, 1, 1, 2, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
		[1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 2, 0, 0, "E", 2, 0, 0, 0, 1, 1],
		[1, 2, 0, 0, 1, 1, 0, 1, 1, "G", 2, 0, 0, 0, 1],
		[1, 1, 2, 0, "C", 1, 0, 1, 0, 2, "G", 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],*/ // Bleak's version of restaurant
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 4, 0, 0, 1, 0, 0, 0, 1, 0, "P", "E", 1, 3, 1],
		[1, 0, 0, "K", "D", "A", 1, 0, "M", 0, 1, "B", 1, 5, 1],
		[1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1],
		[1, 2, 0, 0, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 1],
		[1, 1, 2, 0, 2, 2, 2, 2, 0, 1, 1, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 8, y: 13}, 
		{x: 13, y: 13},
		"ßCapy, what're you doing over there?" +
		"±I've really gotta pee!" +
		"ßBut the bathroom is over there!" +
		"±They're holding the key ransom!" +
		"ßWhat're you talking about?" +
		"±They say they won't give it to me" +
		"±Unless..." +
		"ßUnless what? This sounds ominous." +
		"±Unless you clean all their dishes..." +
		"ßWHAT?!" +
		"µCapy, you know I'm so in!" +
		"¶Wait, really?" +
		"µOf course!" +
		"µNo friend of mine is peeing on the floor!" +
		"ßYou know, in public...",
		"Restaurant"			
	);
	
	private static var _DLClvl2:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, "C", 0, 0, 0, 1, 0, 2, 2, 2, "I", "N", 1, 1, 1],
		[1, "Q", 1, 0, 1, 1, 0, 2, 1, 1, 1, "G", 1, 1, 1],
		[1, 0, 1, 0, 0, 1, 1, 2, 2, 0, 1, "M", 1, 1, 1],
		[1, 5, 1, 1, 4, 1, 1, 1, 1, 0, 1, "Q", 0, 1, 1],
		[1, 0, 2, 0, "H", 1, 0, 0, 0, 0, 1, 1, 0, 0, 1],
		[1, 0, 1, 0, 0, 1, 1, 0, 2, 2, 1, 0, 2, 0, 1],
		[1, 0, 1, 0, 0, 1, 0, 0, 2, 1, 1, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 1, 0, 0, 0, 2, 1, 2, 0, 1, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 2, 2, 1],
		[1, 0, 2, 1, 2, 1, 0, "L", "Q", 2, "I", 1, 0, 2, 1],
		[1, 0, 1, 0, 2, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 2, 2, 0, 2, 1, 0, 2, 2, 1],
		[1, 0, 2, 2, 1, 2, 0, 0, 0, 0, 1, 0, 2, 3, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 4, y: 7},
		{x: 1, y: 3},
		"ßWow, what a dump!" +
		"±!!!" +
		"±What are you doing in here?!" +
		"µ..." +
		"ßI got lonely." +
		"±...I don't think--?" +
		"ßCapy, I'm a robot!" +
		"±..." +
		"ß..." +
		"ß...Fine! I'll wait outside!" +
		"¶Thanks." +
		"øDon't fall in now!",
		"Restroom"
	);
	
	private static var _DLClvl3:Map = new Map (			
		15,
		15,
		[ 
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 3, 2, 2, 1, 0, 0, "N", 0, 0, 1, "K", "V", 2, 1],
		[1, 2, 1, 1, 1, 1, 0, 1, 1, 1, 2, 2, 0, 0, 1],
		[1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
		[1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1],
		[1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0, 0, "W", 0, 1],
		[1, 2, 2, 1, 2, 2, 1, "H", 0, 1, 0, 0, 0, 2, 1],
		[1, 2, 1, 2, 2, 1, 5, "U", 1, 0, "G", 2, 0, "M", 1],
		[1, 2, 1, 2, 1, 0, 4, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 2, 1, 0, 0, 0, 0, 1, 0, 0, 0, "G", 1],
		[1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, "P", 1],
		[1, 1, 1, 2, 0, 0, 0, 0, 0, "I", 1, 1, 1, 2, 1],
		[1, 0, 0, 2, 0, 0, 2, "R", 1, "U", 1, "V", 1, "P", 1],
		[1, 1, "A", 1, 2, 2, 2, 2, 1, 2, "H", 2, "N", 2, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 2, y: 12},
		{x: 10, y: 9},
		"ßWhat IS this place anyway?" +
		"±I dunno, I guess it could be some kind of storage or something." +
		"ßIt looks pretty dusty..." +
		"±..." +
		"ß..." +
		"ß...What?!" +
		"±You've got that look again." +
		"ßI can't help it! The urge is embedded deep into my code!" +
		"¶Let's just look for a way out." +
		"µFine! Fine!" +
		"ß..." +
		"ßYou mind if I clean just a little as we go?" +
		"±Sure..." +
		"øYAY!",
		"Lost Restaurant Floor"	
	);
	
	private static var _DLClvl4:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
		[1, "U", 2, 2, 2, 2, 2, 2, 2, 1, 2, 1, 5, 3, 1],
		[1, 2, 1, 1, 2, 2, 2, 2, 2, 1, "G", "H", "I", 1, 1],
		[1, 2, 1, 1, 1, 2, 2, 2, 2, 1, 2, 1, 1, 1, 1],
		[1, 6, 1, 1, 1, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 1, 2, 2, 2, 1, 2, 0, 2, 1, "H", "C", 1],
		[1, 1, 2, 2, 2, 1, 2, 7, 2, 2, 2, 2, 2, "H", 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 2, 7, 2, 2, 2, 2, 0, 0, 0, 1, 0, 1],
		[1, 4, 1, 2, 2, 2, 1, 2, 1, "A", 1, 0, 0, 8, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 2, 2, 2, 0, 0, 0, 0, 2, 2, 0, 0, 6, 1],
		[1, 0, 0, 0, 2, 2, 2, 1, 2, 1, 2, 2, 0, 8, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 13},
		{x: 1, y: 12},
		"§Hold on! You didn't leave a tip?!" +
		"±They never even came by to refill my water!" +
		"§WOW!" +
		"§You better clean up your act soon or else Jacob is gonna find out you're a cheap date!" +
		"±Hey! I just have standards!" + 
		"§A CHEAP DATE." +
		"µ..." +
		"ßWait, are we in a sewer?",
		"Suspicious Sewers"	
	);
	
	private static var _DLClvl5:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
		[1, 1, 1, 1, 0, "J", 1, 1, 1, 1, 1, 0, 0, 1, 1],
		[1, 1, 1, "J", 0, 1, 1, 0, 0, 0, 0, 1, "P", 0, 1],
		[1, 1, 0, 2, 1, 1, 0, 0, 1, 1, 2, 0, 1, 0, 1],
		[1, 1, 0, 0, 1, 2, 0, 1, 2, 2, 1, 0, 1, 0, 1],
		[1, 1, 0, "J", 0, "Z", 0, 1, 5, 3, 1, 0, 1, 0, 1],
		[1, 1, 1, 0, 1, 2, 0, 0, 0, 1, 0, "J", 1, 0, 1],
		[1, 0, 1, 0, 2, 1, 2, 2, 1, 0, 2, 1, 1, "W", 1],
		[1, 0, 2, 1, 0, 0, 1, 1, 0, "J", 1, 0, "U", 2, 1],
		[1, "W", 2, 4, 1, "J", 0, 0, 2, 1, 1, "U", "B", "V", 1],
		[1, 1, 0, 2, "C", 1, 1, 1, 1, 1, "P", 2, "V", 1, 1],
		[1, 1, 1, 0, 0, 0, 2, 2, 2, 2, 2, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 10},
		{x: 1, y: 9}, // original placements; just commenting out for testing
		"µHuh, looks like this place runs pretty far down." +
		"±..." +
		"±Don't you think we should try to turn back now?" +
		"±Maybe we missed something!" +
		"µWhere's your sense of adventure?!" +
		"µAren't you curious what's down here? What they might be hiding?" +
		"±What are you even talking about?" +
		"ßNot much of a tin foil hat kind of guy, huh?" +
		"¶I'm a realist Roombella, I deal in numbers and facts." +
		"µHush! A girl can dream!" +
		"±But I thought you said--?" +
		"µOh, forget about that! C'mon, let's go to work!",
		"Sewer Spiral Stairway"	
	);
	
	private static var _DLClvl6:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 6, 0, 2, 1, 2, 2, 2, 2, 2, "G", "H", "I", 8, 1], 
		[1, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, "I", 1],
		[1, 2, 1, 2, 2, "R", 1, 1, 1, 1, 1, 0, 1, 2, 1],
		[1, 2, 0, 1, "R", 0, 2, 1, 1, 1, 1, 2, 1, 2, 1],
		[1, 2, "R", 2, 2, 2, 1, 2, "Q", 2, 0, "R", 2, 2, 1], 
		[1, "R", 1, 1, 1, 1, 2, 0, 1, 0, 1, 2, 1, "S", 1],
		[1, 2, 2, 2, 4, 1, 2, 2, 1, 2, 1, 2, 2, 2, 1],
		[1, 1, 1, 1, 1, 1, 2, 1, 2, 2, 2, "R", 1, "R", 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 1, 0, 1, 0, 1, 7, 0, 1, 1, 1, 0, 6, 1],
		[1, 0, 0, "C", 0, 0, 1, 0, 0, "G", "H", "I", "T", 8, 1],
		[1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 7, 0, 0, 0, 0, 5, 2, 0, 0, 0, 0, 0, 3, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 2, y: 13}, 
		{x: 4, y: 13},
		"±...I'm sure there's some explanation-" +
		"µC'mon Capy, this is DEFINITELY some kind of weird cloning lab!" +
		"±..." +
		"øLook, this one even has your eyes!" +
		"µAw...Capy, you're a father!" +
		"¶..." +
		"±..." +
		"±Okay, okay! Fine. But what are they doing down here?" +
		"±And why do they have to look like ME?!" +
		"±*shudders*" +
		"ß..." +
		"ß...Why don't I get a clone?"
		,
		"The Lab"	
	);
	
	private static var _DLClvl7:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 1, 7, 1, 0, 2, 1, "W", 3, 1, 0, 1],
		[1, 0, 0, 1, 2, 2, 1, 0, 1, 7, 5, 1, 0, 0, 1],
		[1, 0, 0, 1, "V", 0, 1, 0, 1, 2, 0, 1, 0, 0, 1],
		[1, 0, 0, 1, 1, 0, 1, 0, 1, 2, "V", 1, 0, 0, 1],
		[1, 0, 0, "B", 0, 0, 1, 2, 1, 0, "W", 1, 0, 0, 1],
		[1, 0, 0, 1, 0, 1, 2, 0, 1, "U", "U", 1, 0, 0, 1],
		[1, 0, 1, 4, 0, 1, 0, 0, 1, "V", 0, 1, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 2, 2, "A", 1, 2, 1, 0, 0, 1],
		[1, 2, 0, 0, 2, 0, 2, 0, 1, 0, 0, 1, 0, 0, 1],
		[1, 0, 2, 2, 0, 2, 0, 0, 1, 0, 0, 1, 0, 0, 1],
		[1, 2, 2, 0, 2, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
		[1, 0, 0, 0, 0, 0, "I", 2, 2, "W", 0, 2, 1, 0, 1],
		[1, 0, 0, 0, 0, 1, 2, "W", "V", 0, 0, 2, 1, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 13}, 
		{x: 2, y: 13},
		"øIT'S A GIANT ROBOT!" +
		"¶:O" +
		"±Okay, adventure over! Let's get out of here!" +
		"µNo! Capy, wait! This is our chance!" +
		"±I thought we passed our chance like 16 floors ago." +
		"ßNo way!" +
		"µDon't you see?" +
		"±No." +
		"øWe're riding this boy all the way to the top!" +
		"±Again, I thought robots didn't have genders..." +
		"ß*sigh*...always so binary..." +
		"±...but aren't robots coded in bi--?" +
		"±Also, WHAT?! You want to ride this thing?" +
		"øYep!" +
		"øAND HERE WE GO!" +
		"±..." +
		"±...you're buying me dinner next time."		
		,
		"Robot Legs"	
	);
	
	private static var _DLClvl8:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 4, 1, 6, 1, 0, 0, 0, 0, 0, 0, 0, 5, 3, 1],
		[1, 2, 1, "V", 1, "G", 0, 0, 0, 0, 0, 0, 2, 1, 1], 
		[1, 0, "G", 0, 1, 0, "U", 1, 2, 0, 0, 0, 0, 2, 1],
		[1, "H", 1, 1, 1, 0, 1, 1, 1, 2, 0, 0, 0, 0, 1],
		[1, "V", 0, "H", 0, 0, "U", 1, 1, 1, 2, 0, 0, 0, 1],
		[1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 2, 0, 0, 1],
		[1, 0, 1, 1, 1, 1, 2, 8, 2, 1, 1, 1, 2, 0, 1],
		[1, 0, 1, 1, 1, 2, 2, "W", 2, 2, 1, 1, 1, 0, 1],
		[1, 1, 1, 1, 2, 2, "W", 0, "W", 2, 2, 1, 2, 7, 1],
		[1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 2, 2, 0, 0, "C", 0, "T", "R", "U", "H", "R", 6, 1],
		[1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, "V", 1],
		[1, 7, 0, 0, "C", "R", "R", 8, "R", "R", 2, 2, 2, 2, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 7, y: 11}, 
		{x: 7, y: 9},
		"±How much further do we have to go?" +
		"µI think we're about halfway there!" +
		"±...halfway?" +
		"øHALFWAY!" +
		"±Halfway..."
		,
		"Robot Chest"	
	);
	
	private static var _DLClvl9:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 2, 1],
		[1, 0, 1, 6, 0, 0, 0, 6, 1, 0, 0, 0, 2, 2, 1],
		[1, "R", 1, 0, 0, 0, 0, 0, 1, "R", 0, 0, 1, 1, 1],
		[1, 0, 1, "R", "R", "R", "R", "R", 1, 0, 0, 3, 1, 1, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1],
		[1, 8, 0, 0, 2, 2, 2, 0, 0, 0, 1, 7, 1, 1, 1],
		[1, 0, 5, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 2, 1],
		[1, 1, 0, 0, 0, 0, 1, 2, 2, 1, 0, "W", 0, "H", 1],
		[1, 7, 0, 1, 0, "V", "I", 0, 2, 1, 0, 0, 0, 0, 1],
		[1, 2, 1, "C", 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1],
		[1, 2, "B", "A", 1, 1, 0, 1, 1, 1, 0, 1, 2, 1, 1],
		[1, 2, 1, "C", 2, "V", "G", 1, 1, "G", 0, 0, "U", 2, 1],
		[1, 2, 1, 0, 1, "H", 0, 4, 8, 1, 1, 1, 0, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 3, y: 13}, 
		{x: 12, y: 13},
		"µThat's it! We're almost to the top!" +
		"¶How do you still have this much energy?" +
		"øFound a charge port on this guy's belly button a bit ago!" + 
		"øI'm refreshed, recharged, and ready to take on the world!" +
		"±...A belly button?" +
		"±I still have so many questions about robots..."
		,
		"Robot Head"	
	);
	
	private static var _DLClvl10:Map = new Map (			
		15,
		15,
		[
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 2, 0, 1],
		[1, 0, 0, 0, 1, 1, "Q", 1, 1, 2, 1, 1, 0, 0, 1],
		[1, 0, 1, 0, 2, 2, "R", "R", 1, 2, 0, 0, 0, 2, 1],
		[1, 0, 0, 0, 1, 1, "Q", 1, 1, 0, 0, 0, 2, 2, 1],
		[1, 1, 6, 1, 1, 2, 2, 2, "Q", "R", 1, 2, 1, 0, 1],
		[1, 0, 1, 0, 0, 1, 1, 1, 0, "P", 1, 3, 1, 0, 1],
		[1, 0, 0, 0, 0, 1, "W", 1, 0, 0, 2, 1, 2, 2, 1],
		[1, 0, 4, 1, 0, 0, 0, 1, 1, "J", 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 1, "V", "U", "O", 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, "F", 1, "M", 1, 0, 0, 0, "N", "Q", 1, 1],
		[1, 1, 1, 2, 1, 1, "W", "V", 2, 1, 1, 1, 0, 1, 1],
		[1, 0, 0, 2, 6, 5, 1, 1, 1, 1, 1, 1, 0, 1, 1],
		[1, 1, "A", 1, 1, 8, "G", 1, 0, 8, 0, "T", 0, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		],
		{x: 1, y: 12}, 
		{x: 10, y: 13},
		"µAlright, this looks like the control room!" +
		"¶Does that mean you know how to work this thing?" +
		"øNot at all!" +
		"±..." +
		"µYou wanna help me mess around with some of these levers?" +
		"±...I guess..."
		,
		"Escape"	
	);
	
	public static var Campaign:Array = [ 
	_lvl1 , _lvl2, _lvl3, 
	_lvl4, _lvl5, _lvl6,
	_lvl7, _lvl8, _lvl9, 
	_lvl10, _lvl11, _lvl12,
	_lvl13, _lvl14
	];			
	
	public static var DLCCampaign:Array = [
	_DLClvl1, _DLClvl2, _DLClvl3,
	_DLClvl4, _DLClvl5, _DLClvl6,
	_DLClvl7, _DLClvl8, _DLClvl9,
	_DLClvl10
	];
};
