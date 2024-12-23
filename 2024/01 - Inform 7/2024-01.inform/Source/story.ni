"Historian Hysteria Solution" by "David Yates"

Chapter 1 - Definitions

List 1 is a list of numbers that varies.

List 2 is a list of numbers that varies.

When play begins:
	repeat with N running from 1 to the number of rows in the Table of Location IDs:
		add first in row N of the Table of Location IDs to List 1;
	repeat with M running from 1 to the number of rows in the Table of Location IDs:
		add second in row M of the Table of Location IDs to List 2;
	sort List 1;
	sort List 2.
		
To decide what number is the sum of (N - number) and (M - number)
	(this is summing):
	decide on M plus N.
	
To decide what number is the distance between (N - number) and (M - number):
	if M is greater than N:
		decide on M minus N;
	decide on N minus M
	
Chapter 2 - The Answer

The Chief Historian's Office is a room. "Elves run amuck looking for location IDs."

[Type "z" in game to trigger this.]
Instead of waiting:
	say "The elves diff the lists...[line break]";
	let diffs be a list of numbers;
	repeat with X running from 1 to the number of entries in List 1:
		add the distance between entry X of List 1 and entry X of List 2 to diffs;
	say "The elves add it all together...[line break]";
	let answer be the summing reduction of diffs;
	say "The elves tell you that the answer is [answer]."

[Type "yes" in game to trigger this.]
Instead of saying yes:
	let similarity be 0;
	repeat with N running through List 1:
		let count be 0;
		repeat with M running through List 2:
			if N is M:
				now count is count plus 1;
			if M is greater than N: [list is sorted]
				break;
		now similarity is similarity plus N times count;
	say "The elves tell you the answer is [similarity]."
	
Chapter 3 - Inputs

[Really more of an appendix]

Table of Location IDs
First (a number)	Second (a number)
3	4
4	3
2	5
1	3
3	9
3	3


