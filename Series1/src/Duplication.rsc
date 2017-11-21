module Duplication

import IO;
import List;
import Set;
import String;
import util::Math;
import Util;

int rankDuplication(int numCodeLines, int numDuplicates)
{
	list[int] thresholds = [3,5,10,20];
	int p = toInt(round(100.0 / numCodeLines * numDuplicates));
	return rankThresholds(p, thresholds);
}

list[tuple[int,str]] groupPerSixLines(list[str] cls)
{
	return for(i <- [0..size(cls)])
		append(<i, ("" | it + cls[j] + "\n" | j <- [i..min(i+6,size(cls))])>); 
}

int countDuplicates(list[str] cls)
{
	clsp6 = groupPerSixLines(cls);
	seenCode = {};
	seenCodeLines = ();
	set[int] duplicateLines = {};
	for(<i, c> <- clsp6)
	{
		if(c in seenCode)
		{
			duplicateLines += i;
			if(c in seenCodeLines)
			{
				duplicateLines += seenCodeLines[c];
				seenCodeLines -= (c:0);
			}
		}
		else
		{
			seenCode += c;
			seenCodeLines += (c:i);
		}
	}
	return (<0, 0> | <i, it[1] + ((i >= it[0] + 6) ? 6 : (i - it[0]))> | i <- sort(duplicateLines))[1];
}