local Version = "1.0";
local Author = "Zhur";

if(not orig_OnShow_RequestDialog) then
	orig_OnShow_RequestDialog = OnShow_RequestDialog
end


function checkSnoop( sContent, sButton1, sButton2 )
	if(string.find(sContent, "The transport to ")) or (string.find(sContent, "Do you want to bomb the target")) then
		ClickRequestDialogButton( 0 );
		return;
	end
	orig_OnShow_RequestDialog(sContent, sButton1, sButton2);
end

OnShow_RequestDialog = checkSnoop


