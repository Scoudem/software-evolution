module Duplication

import IO;
import List;
import String;
import lang::java::jdt::m3::Core;
import util::Math;
import Util;

int rankDuplication(loc prj)
{
	nCl = size(codeLines(prj));
	nDs = (0 | it + d | <_,_,d> <- duplicates(prj));
	list[int] thresholds = [3,5,10,20];
	int p = toInt(round(100.0 / nCl * nDs));
	int r = (0
			| p > x ? it + 1 : it
			| x <- thresholds);
	return r;
}

list[tuple[int,int,int]] duplicates(loc prj)
{
	result = [];
	cls = codeLines(prj);
	for(i <- [0..size(cls)])
	{
		for(j <- [i+1..size(cls)])
		{
			int d = 0;
			while(j+d < size(cls) && cls[i+d] == cls[j+d])
			{
				a = cls[i+d];
				b = cls[j+d];
				d += 1;
			}
			if(j == i + 1) d += 1;
			if(d >= 6) result += <i,j,d>;
		}
	}
	return result;
}

list[str] codeLines(loc prj) = concat([cl | <cl, _> <- codeLinesPerFile(prj)]);

lrel[list[str], loc] codeLinesPerFile(loc prj)
{
	rel[loc,loc] m3Doc = createM3FromEclipseProject(prj).documentation;
	ls = [<withoutComments(f, m3Doc), f> | f <- srcFiles(prj)];
	ls = [<removeEmptyLines(lls<0>), lls<1>> | lls <- ls];
	ls = [<mapper(lls<0>, trim), lls<1>> | lls <- ls];
	return ls;
}

list[str] withoutComments(loc f, rel[loc,loc] m3Doc)
{
	list[loc] doc = sort([x | <_, x> <- m3Doc, x.uri == f.uri], offsetMoreThan);
	return removeComments(doc, readFileLines(f));
}

list[str] removeComments(list[loc] doc, list[str] lines)
{
	for(i <- [0..size(doc)])
	{
		x = doc[i];
		b = x.begin.line - 1;
		e = x.end.line - 1;
		bc = x.begin.column;
		ec = x.end.column;
		if(b == e) 
			lines[b] = lines[b][0..bc] + lines[b][ec..];
		else
		{
			lines[e] = lines[e][ec..];
			for(j <- [e-1..b]) lines[j] = "";
			lines[b] = lines[b][0..bc];
		}
	}
	return lines;
}

list[str] removeEmptyLines(list[str] ls) = [x | x <- ls, /^\s*$/ !:= x];

bool offsetMoreThan(loc a, loc b) = a.offset > b.offset;