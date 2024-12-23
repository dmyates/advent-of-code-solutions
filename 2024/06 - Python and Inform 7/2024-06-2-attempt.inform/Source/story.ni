"Guard Gallivant P2 Solution" by "David Yates"

[Warning: this code is liable to freeze up and crash. It does not produce a solution for AoC 2024 6-2.]

Chapter 1 - Patrolling

Forward is a direction that varies. Forward is north.

Patrolling is an action applying to nothing. Understand "patrol" as patrolling.

Carry out patrolling:
	while the player is not in Endgame:
		try going forward.
		
Report going to Endgame when NewGamePlus is false:
	say "You have visited [number of visited rooms] rooms in total.";
	end the story.

Instead of going nowhere:
	now forward is right of forward;
	say "Turning right...";
	say "You have visited [number of visited rooms] rooms so far.";
	try going forward.

To decide what direction is right of (D - direction):
	if D is north:
		decide on east;
	if D is east:
		decide on south;
	if D is south:
		decide on west;
	if D is west:
		decide on north.

Chapter 2 - Blocking The Way

NewGamePlus is a truth state that varies. NewGamePlus is false.

Section 1 - The Path

[The idea here is that the player plays through the game once and then uses the path-finding action to enter the list of visited rooms.
An alternative and probably superior approach would be to save the rooms to a file and load them.]
	
Before going to Endgame when NewGamePlus is false:
	say "You visited these rooms: [a list of visited rooms]".

The path is a list of rooms that varies.

The starting position is a room that varies.

[Code for matching user input to room names adapted from https://intfiction.org/t/new-mini-extension-objects-matching-snippets/3278, credit to Mike Ciul]
The item to match is a object that varies.
Definition: A room is matchable if it is the item to match.

Does the object’s name appear in is a snippet based rulebook. The does the object’s name appear in rulebook has outcomes it does (success) and it does not (failure).

Does the object’s name appear in a snippet (called S):
	if the item to match is a room and S includes "[any matchable room]", it does;
	it does not.

To decide whether the name of (candidate - an object) appears in (S - a snippet):
	now the item to match is candidate;
	follow the does the object's name appear in rules for S;
	decide on whether or not the outcome of the rulebook is the it does outcome;

Snippet-inclusion relates an object (called candidate) to a snippet (called S) when the name of candidate appears in S. The verb to be named in implies the snippet-inclusion relation.

Path-finding is an action applying to nothing. Understand "pathfind" as path-finding.

Carry out path-finding:
	now NewGamePlus is true;
	now the command prompt is "Enter path locations >".
	
To decide whether collecting the path:
	if the command prompt is "Enter path locations >", yes;
	no.
	
After reading a command when collecting the path:
	repeat with current room running through rooms:
		if the name of the current room appears in the player's command:
			add the current room to the path, if absent;
	say "The path is: [the path]";
	now the command prompt is ">";
	reject the player's command.

Section 3 - Blocking

A room can be blocked or unblocked. A room is usually unblocked.

Instead of going to a blocked room:
	now forward is right of forward;
	say "Turning right at the new obstacle...";
	say "You have visited [number of visited rooms] rooms so far.";
	try going forward.

Section 4 - Looping

[I believe the key to getting this working is finding the right place for the while loop that navigates the map.]

Obstacle test is a number that varies. Obstacle test is 0.

Loop count is a number that varies. Loop count is 0.

The last four rooms is a list of rooms that varies.

Stuck is a truth state that varies. Stuck is false.

Looping is an action applying to nothing. Understand "loop" as looping.

Carry out looping:
	if obstacle test is not 0:
		now entry obstacle test in the path is unblocked;
		say "Unblocked [entry obstacle test in the path].[line break]";
	increment obstacle test;
	if obstacle test is greater than the number of entries in the path:
		say "All positions tested. Total loops: [loop count]";
		end the story instead;
	now entry obstacle test in the path is blocked;
	say "Blocked [entry obstacle test in the path].";
	while the player is not in Endgame:
		say "Patrolling...";
		try going forward;
		if stuck is true:
			break;
	say "Done patrolling.";
	if stuck is true:
		say "You appear to be stuck in a loop! Resetting...[line break]";
		increment the loop count;
	otherwise:
		say "No loop here. Resetting...";
	say "Loops found so far: [loop count]";
	reset.
	
Instead of looping when NewGamePlus is false:
	say "Enter the path first!"
	
Report going somewhere when NewGamePlus is true:
	[if the location is Endgame:
		say "No loop here. Resetting...";
		say "Loops found so far: [loop count]";
		reset instead;]
	add the location to the last four rooms;
	say "[last four rooms]";
	if the number of entries in the last four rooms is greater than 4:
		remove entry 1 from the last four rooms;
	if the number of entries in the last four rooms is 4:
		if entry 1 of the last four rooms is entry 3 of the last four rooms and entry 2 of the last four rooms is entry 4 of the last four rooms:
			now stuck is true instead.
			[say "You appear to be stuck in a loop! Resetting...[line break]";
			say "Loops found so far: [loop count]";
			increment the loop count;
			reset instead.]
				
To reset:
	remove entries 1 to the number of entries in the last four rooms from the last four rooms;
	now forward is north;
	move the player to the starting position;
	now stuck is false;
	try looping.
	
Test looping with "pathfind / Point1-5 Point1-6 Point1-7 Point1-8 Point1-4 / pathfind / Point2-4 Point2-8 Point3-4 Point3-8 Point4-3 / pathfind / Point4-4 Point4-5 Point4-6 Point4-8 Point4-2 Point5-2 Point5-4 / pathfind / Point5-6 Point5-8 Point6-2 / pathfind / Point6-3 Point6-4 Point6-5 Point6-6 / pathfind / Point6-7 Point6-8 Point7-2 Point7-3 / pathfind / Point7-4 Point7-5 Point7-6 Point7-7 / pathfind / Point7-1 Point8-1 Point8-2 / pathfind / Point8-3 Point8-4 Point8-5 Point8-6 Point8-7 / pathfind / Point9-7 / loop"

Test short with "pathfind / Point1-5 Point1-6 Point1-7 Point1-8 Point1-4 / pathfind / Point2-4 Point2-8 Point3-4 Point3-8 Point4-3 / pathfind / Point4-4 Point4-5 / loop".
Test short2 with "pathfind / Point4-6 Point4-8 Point4-2 Point5-2 Point5-4 / pathfind / Point5-6 Point5-8 Point6-2 / pathfind / Point6-3 Point6-4 Point6-5 Point6-6 / loop".
Test short3 with "pathfind / Point6-7 Point6-8 Point7-2 Point7-3 / pathfind / Point7-4 Point7-5 Point7-6 Point7-7 / pathfind / Point7-1 Point8-1 Point8-2 / loop".
Test short4 with "pathfind / Point8-3 Point8-4 Point8-5 Point8-6 Point8-7 / pathfind / Point9-7 / loop".
Test findloop with "pathfind / Point6-3 / loop".
	
[
Point1-5 Point1-6 Point1-7 Point1-8 Point1-4 Point2-4 Point2-8 Point3-4 Point3-8 Point4-3 Point4-4 Point4-5 Point4-6 Point4-8 Point4-2 Point5-2 Point5-4 Point5-6 Point5-8 Point6-2
Point6-3 Point6-4 Point6-5 Point6-6 Point6-7 Point6-8 Point7-2 Point7-3 Point7-4 Point7-5 Point7-6 Point7-7 Point7-1 Point8-1 Point8-2 Point8-3 Point8-4 Point8-5 Point8-6 Point8-7
Point9-7
]

Chapter 3 - The Map

Point0-0 is a room.
Endgame is west of Point0-0.
Point0-1 is east of Point0-0.
Endgame is north of Point0-0.
Point1-0 is south of Point0-0.
Point0-1 is a room.
Point0-0 is west of Point0-1.
Point0-2 is east of Point0-1.
Endgame is north of Point0-1.
Point1-1 is south of Point0-1.
Point0-2 is a room.
Point0-1 is west of Point0-2.
Point0-3 is east of Point0-2.
Endgame is north of Point0-2.
Point1-2 is south of Point0-2.
Point0-3 is a room.
Point0-2 is west of Point0-3.
Endgame is north of Point0-3.
Point1-3 is south of Point0-3.
[Point0-4 is an obstacle.]
Point0-5 is a room.
Point0-6 is east of Point0-5.
Endgame is north of Point0-5.
Point1-5 is south of Point0-5.
Point0-6 is a room.
Point0-5 is west of Point0-6.
Point0-7 is east of Point0-6.
Endgame is north of Point0-6.
Point1-6 is south of Point0-6.
Point0-7 is a room.
Point0-6 is west of Point0-7.
Point0-8 is east of Point0-7.
Endgame is north of Point0-7.
Point1-7 is south of Point0-7.
Point0-8 is a room.
Point0-7 is west of Point0-8.
Point0-9 is east of Point0-8.
Endgame is north of Point0-8.
Point1-8 is south of Point0-8.
Point0-9 is a room.
Point0-8 is west of Point0-9.
Endgame is east of Point0-9.
Endgame is north of Point0-9.
Point1-0 is a room.
Endgame is west of Point1-0.
Point1-1 is east of Point1-0.
Point0-0 is north of Point1-0.
Point2-0 is south of Point1-0.
Point1-1 is a room.
Point1-0 is west of Point1-1.
Point1-2 is east of Point1-1.
Point0-1 is north of Point1-1.
Point2-1 is south of Point1-1.
Point1-2 is a room.
Point1-1 is west of Point1-2.
Point1-3 is east of Point1-2.
Point0-2 is north of Point1-2.
Point2-2 is south of Point1-2.
Point1-3 is a room.
Point1-2 is west of Point1-3.
Point1-4 is east of Point1-3.
Point0-3 is north of Point1-3.
Point2-3 is south of Point1-3.
Point1-4 is a room.
Point1-3 is west of Point1-4.
Point1-5 is east of Point1-4.
Point2-4 is south of Point1-4.
Point1-5 is a room.
Point1-4 is west of Point1-5.
Point1-6 is east of Point1-5.
Point0-5 is north of Point1-5.
Point2-5 is south of Point1-5.
Point1-6 is a room.
Point1-5 is west of Point1-6.
Point1-7 is east of Point1-6.
Point0-6 is north of Point1-6.
Point2-6 is south of Point1-6.
Point1-7 is a room.
Point1-6 is west of Point1-7.
Point1-8 is east of Point1-7.
Point0-7 is north of Point1-7.
Point2-7 is south of Point1-7.
Point1-8 is a room.
Point1-7 is west of Point1-8.
Point0-8 is north of Point1-8.
Point2-8 is south of Point1-8.
[Point1-9 is an obstacle.]
Point2-0 is a room.
Endgame is west of Point2-0.
Point2-1 is east of Point2-0.
Point1-0 is north of Point2-0.
Point3-0 is south of Point2-0.
Point2-1 is a room.
Point2-0 is west of Point2-1.
Point2-2 is east of Point2-1.
Point1-1 is north of Point2-1.
Point3-1 is south of Point2-1.
Point2-2 is a room.
Point2-1 is west of Point2-2.
Point2-3 is east of Point2-2.
Point1-2 is north of Point2-2.
Point2-3 is a room.
Point2-2 is west of Point2-3.
Point2-4 is east of Point2-3.
Point1-3 is north of Point2-3.
Point3-3 is south of Point2-3.
Point2-4 is a room.
Point2-3 is west of Point2-4.
Point2-5 is east of Point2-4.
Point1-4 is north of Point2-4.
Point3-4 is south of Point2-4.
Point2-5 is a room.
Point2-4 is west of Point2-5.
Point2-6 is east of Point2-5.
Point1-5 is north of Point2-5.
Point3-5 is south of Point2-5.
Point2-6 is a room.
Point2-5 is west of Point2-6.
Point2-7 is east of Point2-6.
Point1-6 is north of Point2-6.
Point3-6 is south of Point2-6.
Point2-7 is a room.
Point2-6 is west of Point2-7.
Point2-8 is east of Point2-7.
Point1-7 is north of Point2-7.
Point3-7 is south of Point2-7.
Point2-8 is a room.
Point2-7 is west of Point2-8.
Point2-9 is east of Point2-8.
Point1-8 is north of Point2-8.
Point3-8 is south of Point2-8.
Point2-9 is a room.
Point2-8 is west of Point2-9.
Endgame is east of Point2-9.
Point3-9 is south of Point2-9.
Point3-0 is a room.
Endgame is west of Point3-0.
Point3-1 is east of Point3-0.
Point2-0 is north of Point3-0.
Point4-0 is south of Point3-0.
Point3-1 is a room.
Point3-0 is west of Point3-1.
Point2-1 is north of Point3-1.
Point4-1 is south of Point3-1.
[Point3-2 is an obstacle.]
Point3-3 is a room.
Point3-4 is east of Point3-3.
Point2-3 is north of Point3-3.
Point4-3 is south of Point3-3.
Point3-4 is a room.
Point3-3 is west of Point3-4.
Point3-5 is east of Point3-4.
Point2-4 is north of Point3-4.
Point4-4 is south of Point3-4.
Point3-5 is a room.
Point3-4 is west of Point3-5.
Point3-6 is east of Point3-5.
Point2-5 is north of Point3-5.
Point4-5 is south of Point3-5.
Point3-6 is a room.
Point3-5 is west of Point3-6.
Point3-7 is east of Point3-6.
Point2-6 is north of Point3-6.
Point4-6 is south of Point3-6.
Point3-7 is a room.
Point3-6 is west of Point3-7.
Point3-8 is east of Point3-7.
Point2-7 is north of Point3-7.
Point3-8 is a room.
Point3-7 is west of Point3-8.
Point3-9 is east of Point3-8.
Point2-8 is north of Point3-8.
Point4-8 is south of Point3-8.
Point3-9 is a room.
Point3-8 is west of Point3-9.
Endgame is east of Point3-9.
Point2-9 is north of Point3-9.
Point4-9 is south of Point3-9.
Point4-0 is a room.
Endgame is west of Point4-0.
Point4-1 is east of Point4-0.
Point3-0 is north of Point4-0.
Point5-0 is south of Point4-0.
Point4-1 is a room.
Point4-0 is west of Point4-1.
Point4-2 is east of Point4-1.
Point3-1 is north of Point4-1.
Point5-1 is south of Point4-1.
Point4-2 is a room.
Point4-1 is west of Point4-2.
Point4-3 is east of Point4-2.
Point5-2 is south of Point4-2.
Point4-3 is a room.
Point4-2 is west of Point4-3.
Point4-4 is east of Point4-3.
Point3-3 is north of Point4-3.
Point5-3 is south of Point4-3.
Point4-4 is a room.
Point4-3 is west of Point4-4.
Point4-5 is east of Point4-4.
Point3-4 is north of Point4-4.
Point5-4 is south of Point4-4.
Point4-5 is a room.
Point4-4 is west of Point4-5.
Point4-6 is east of Point4-5.
Point3-5 is north of Point4-5.
Point5-5 is south of Point4-5.
Point4-6 is a room.
Point4-5 is west of Point4-6.
Point3-6 is north of Point4-6.
Point5-6 is south of Point4-6.
[Point4-7 is an obstacle.]
Point4-8 is a room.
Point4-9 is east of Point4-8.
Point3-8 is north of Point4-8.
Point5-8 is south of Point4-8.
Point4-9 is a room.
Point4-8 is west of Point4-9.
Endgame is east of Point4-9.
Point3-9 is north of Point4-9.
Point5-9 is south of Point4-9.
Point5-0 is a room.
Endgame is west of Point5-0.
Point5-1 is east of Point5-0.
Point4-0 is north of Point5-0.
Point6-0 is south of Point5-0.
Point5-1 is a room.
Point5-0 is west of Point5-1.
Point5-2 is east of Point5-1.
Point4-1 is north of Point5-1.
Point5-2 is a room.
Point5-1 is west of Point5-2.
Point5-3 is east of Point5-2.
Point4-2 is north of Point5-2.
Point6-2 is south of Point5-2.
Point5-3 is a room.
Point5-2 is west of Point5-3.
Point5-4 is east of Point5-3.
Point4-3 is north of Point5-3.
Point6-3 is south of Point5-3.
Point5-4 is a room.
Point5-3 is west of Point5-4.
Point5-5 is east of Point5-4.
Point4-4 is north of Point5-4.
Point6-4 is south of Point5-4.
Point5-5 is a room.
Point5-4 is west of Point5-5.
Point5-6 is east of Point5-5.
Point4-5 is north of Point5-5.
Point6-5 is south of Point5-5.
Point5-6 is a room.
Point5-5 is west of Point5-6.
Point5-7 is east of Point5-6.
Point4-6 is north of Point5-6.
Point6-6 is south of Point5-6.
Point5-7 is a room.
Point5-6 is west of Point5-7.
Point5-8 is east of Point5-7.
Point6-7 is south of Point5-7.
Point5-8 is a room.
Point5-7 is west of Point5-8.
Point5-9 is east of Point5-8.
Point4-8 is north of Point5-8.
Point6-8 is south of Point5-8.
Point5-9 is a room.
Point5-8 is west of Point5-9.
Endgame is east of Point5-9.
Point4-9 is north of Point5-9.
Point6-9 is south of Point5-9.
Point6-0 is a room.
Endgame is west of Point6-0.
Point5-0 is north of Point6-0.
Point7-0 is south of Point6-0.
[Point6-1 is an obstacle.]
Point6-2 is a room.
Point6-3 is east of Point6-2.
Point5-2 is north of Point6-2.
Point7-2 is south of Point6-2.
Point6-3 is a room.
Point6-2 is west of Point6-3.
Point6-4 is east of Point6-3.
Point5-3 is north of Point6-3.
Point7-3 is south of Point6-3.
Point6-4 is a room.
Point6-3 is west of Point6-4.
Point6-5 is east of Point6-4.
Point5-4 is north of Point6-4.
Point7-4 is south of Point6-4.

When play begins:
	now the player is in Point6-4;
	now the starting position is Point6-4.

Point6-5 is a room.
Point6-4 is west of Point6-5.
Point6-6 is east of Point6-5.
Point5-5 is north of Point6-5.
Point7-5 is south of Point6-5.
Point6-6 is a room.
Point6-5 is west of Point6-6.
Point6-7 is east of Point6-6.
Point5-6 is north of Point6-6.
Point7-6 is south of Point6-6.
Point6-7 is a room.
Point6-6 is west of Point6-7.
Point6-8 is east of Point6-7.
Point5-7 is north of Point6-7.
Point7-7 is south of Point6-7.
Point6-8 is a room.
Point6-7 is west of Point6-8.
Point6-9 is east of Point6-8.
Point5-8 is north of Point6-8.
Point6-9 is a room.
Point6-8 is west of Point6-9.
Endgame is east of Point6-9.
Point5-9 is north of Point6-9.
Point7-9 is south of Point6-9.
Point7-0 is a room.
Endgame is west of Point7-0.
Point7-1 is east of Point7-0.
Point6-0 is north of Point7-0.
Point7-1 is a room.
Point7-0 is west of Point7-1.
Point7-2 is east of Point7-1.
Point8-1 is south of Point7-1.
Point7-2 is a room.
Point7-1 is west of Point7-2.
Point7-3 is east of Point7-2.
Point6-2 is north of Point7-2.
Point8-2 is south of Point7-2.
Point7-3 is a room.
Point7-2 is west of Point7-3.
Point7-4 is east of Point7-3.
Point6-3 is north of Point7-3.
Point8-3 is south of Point7-3.
Point7-4 is a room.
Point7-3 is west of Point7-4.
Point7-5 is east of Point7-4.
Point6-4 is north of Point7-4.
Point8-4 is south of Point7-4.
Point7-5 is a room.
Point7-4 is west of Point7-5.
Point7-6 is east of Point7-5.
Point6-5 is north of Point7-5.
Point8-5 is south of Point7-5.
Point7-6 is a room.
Point7-5 is west of Point7-6.
Point7-7 is east of Point7-6.
Point6-6 is north of Point7-6.
Point8-6 is south of Point7-6.
Point7-7 is a room.
Point7-6 is west of Point7-7.
Point6-7 is north of Point7-7.
Point8-7 is south of Point7-7.
[Point7-8 is an obstacle.]
Point7-9 is a room.
Endgame is east of Point7-9.
Point6-9 is north of Point7-9.
Point8-9 is south of Point7-9.
[Point8-0 is an obstacle.]
Point8-1 is a room.
Point8-2 is east of Point8-1.
Point7-1 is north of Point8-1.
Point9-1 is south of Point8-1.
Point8-2 is a room.
Point8-1 is west of Point8-2.
Point8-3 is east of Point8-2.
Point7-2 is north of Point8-2.
Point9-2 is south of Point8-2.
Point8-3 is a room.
Point8-2 is west of Point8-3.
Point8-4 is east of Point8-3.
Point7-3 is north of Point8-3.
Point9-3 is south of Point8-3.
Point8-4 is a room.
Point8-3 is west of Point8-4.
Point8-5 is east of Point8-4.
Point7-4 is north of Point8-4.
Point9-4 is south of Point8-4.
Point8-5 is a room.
Point8-4 is west of Point8-5.
Point8-6 is east of Point8-5.
Point7-5 is north of Point8-5.
Point9-5 is south of Point8-5.
Point8-6 is a room.
Point8-5 is west of Point8-6.
Point8-7 is east of Point8-6.
Point7-6 is north of Point8-6.
Point8-7 is a room.
Point8-6 is west of Point8-7.
Point8-8 is east of Point8-7.
Point7-7 is north of Point8-7.
Point9-7 is south of Point8-7.
Point8-8 is a room.
Point8-7 is west of Point8-8.
Point8-9 is east of Point8-8.
Point9-8 is south of Point8-8.
Point8-9 is a room.
Point8-8 is west of Point8-9.
Endgame is east of Point8-9.
Point7-9 is north of Point8-9.
Point9-9 is south of Point8-9.
Point9-0 is a room.
Endgame is west of Point9-0.
Point9-1 is east of Point9-0.
Endgame is south of Point9-0.
Point9-1 is a room.
Point9-0 is west of Point9-1.
Point9-2 is east of Point9-1.
Point8-1 is north of Point9-1.
Endgame is south of Point9-1.
Point9-2 is a room.
Point9-1 is west of Point9-2.
Point9-3 is east of Point9-2.
Point8-2 is north of Point9-2.
Endgame is south of Point9-2.
Point9-3 is a room.
Point9-2 is west of Point9-3.
Point9-4 is east of Point9-3.
Point8-3 is north of Point9-3.
Endgame is south of Point9-3.
Point9-4 is a room.
Point9-3 is west of Point9-4.
Point9-5 is east of Point9-4.
Point8-4 is north of Point9-4.
Endgame is south of Point9-4.
Point9-5 is a room.
Point9-4 is west of Point9-5.
Point8-5 is north of Point9-5.
Endgame is south of Point9-5.
[Point9-6 is an obstacle.]
Point9-7 is a room.
Point9-8 is east of Point9-7.
Point8-7 is north of Point9-7.
Endgame is south of Point9-7.
Point9-8 is a room.
Point9-7 is west of Point9-8.
Point9-9 is east of Point9-8.
Point8-8 is north of Point9-8.
Endgame is south of Point9-8.
Point9-9 is a room.
Point9-8 is west of Point9-9.
Endgame is east of Point9-9.
Point8-9 is north of Point9-9.
Endgame is south of Point9-9.