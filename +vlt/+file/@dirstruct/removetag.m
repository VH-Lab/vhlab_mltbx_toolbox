function removetag(ds, dir, tagname)
% REMOVETAG - Remove a tag from a dirstruct directory
%
%  REMOVETAG(THEDIRSTRUCT, DIR, TAGNAME)
%
%  Removes a 'tag' with tagname TAGNAME from the directory DIR
%  that is part of the directory structure object (DIRSTRUCT)
%  named THEDIRSTRUCT.  DIR should just be the name of the
%  directory within THEDIRSTRUCT's path.
%
%  See also: ADDTAG, GETTAG, vlt.file.saveStructArray

wholedir = [getpathname(ds) filesep dir];
tagfilename = [wholedir filesep 'tags.txt'];
taglockfilename = [wholedir filesep 'tags-lock.txt'];

tags = gettag(ds,dir);
if ~isempty(tags),
	tf = find(strcmp(tagname,{tags.tagname}));
	if length(tf)>0,
		tags(tf) = [];
	end;
	[fid,key] = vlt.file.checkout_lock_file(taglockfilename,30,1);
	if fid>0,
		if length(tags)==0,
			delete(tagfilename);
		else,
			vlt.file.saveStructArray(tagfilename,tags);
		end;
		vlt.file.release_lock_file(taglockfilename,key);
	end;
end;

