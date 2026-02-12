------------------------------------------------------------------------------------------
-- OptionWindow file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define size of the window
------------------------------------------------------------------------------------------
local windowWidth = 0;
local windowHeight = 0;

windowWidth = 450;
windowHeight = 800;

checkBoxMale = {};
checkBoxFemale = {};
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateFestivalWindow()
		local nbrPlayerCanChangeSexe = 0;

		for i in pairs(PlayerDatas) do 
			nbrPlayerCanChangeSexe = nbrPlayerCanChangeSexe + 1;
		end

		if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
			windowHeight = 200 + (nbrPlayerCanChangeSexe * 32);
		else
			windowHeight = 200;
		end

		if(Turbine.UI.Display:GetHeight() < windowHeight)then
			windowHeight = Turbine.UI.Display:GetHeight() - 150;
		end
		
		FestivalWindow=Turbine.UI.Lotro.GoldWindow(); 
		FestivalWindow:SetSize(windowWidth, windowHeight); 
		FestivalWindow:SetText(T[ "PluginGendreText" ]); 

		FestivalWindow.Message=Turbine.UI.Label(); 
		FestivalWindow.Message:SetParent(FestivalWindow); 
		FestivalWindow.Message:SetSize(150,10); 
		FestivalWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		FestivalWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		FestivalWindow.Message:SetText(T[ "PluginText" ]); 

		FestivalWindow:SetZOrder(100);
		FestivalWindow:SetWantsKeyEvents(true);
		FestivalWindow:SetWantsUpdates(true);

		FestivalWindow:SetPosition((Turbine.UI.Display:GetWidth()-FestivalWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-FestivalWindow:GetHeight())/2);

		FestivalWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- option panel --
		------------------------------------------------------------------------------------------
		-- sort player name by alphabetical order
		a = {};
		local count = 0;
		for i in pairs(PlayerDatas) do 
			table.insert(a, i);
			count = count + 1;
		end
		table.sort(a);

		posx = 5;
		posy = 5;

		listbox = Turbine.UI.ListBox();
		listbox:SetParent( FestivalWindow );
		--listbox:SetBackColor( Turbine.UI.Color.Red );
		listbox:SetSize(windowWidth - 45, windowHeight - 140);
		listbox:SetPosition(20, 70);
		listbox:IsMouseVisible(true);
		listbox:SetZOrder(20);

		for n, i in ipairs(a) do 
			
			listItem = Turbine.UI.Control();
			listItem:SetSize( windowWidth - 45, 40 );
			listItem:SetMouseVisible(true);

			FestivalWindow.Message=Turbine.UI.Label(); 
			FestivalWindow.Message:SetParent(listItem); 
			FestivalWindow.Message:SetSize(120, 30); 
			FestivalWindow.Message:SetPosition(posx, posy); 
			FestivalWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			FestivalWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			FestivalWindow.Message:SetForeColor(Turbine.UI.Color.Gold);
			FestivalWindow.Message:SetText(i); 

			FestivalWindow.Message=Turbine.UI.Label(); 
			FestivalWindow.Message:SetParent(listItem); 
			FestivalWindow.Message:SetSize(300, 30); 
			FestivalWindow.Message:SetPosition(posx + 120, posy); 
			FestivalWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			FestivalWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			if(PlayerFestival[i].Yule ~= nil)then
				FestivalWindow.Message:SetText("Terminez L'esprit de Yule (" .. PlayerFestival[i].Yule .. "/4)");
			else
				FestivalWindow.Message:SetText("Terminez L'esprit de Yule (0/4)");
			end


			 
			--posy = posy + 35;	
			listbox:AddItem( listItem );
		end
		------------------------------------------------------------------------------------------
		--- scrollbar handler
		------------------------------------------------------------------------------------------
		vscrollListBox=Turbine.UI.Lotro.ScrollBar();
		vscrollListBox:SetParent(FestivalWindow);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth-20, 70);
		vscrollListBox:SetSize(10, windowHeight - 140); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum( (count * 50)); -- we will allow scrolling the height of the map-the viewport height
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end

		listbox:SetVerticalScrollBar(vscrollListBox);


		buttonValider = Turbine.UI.Lotro.GoldButton();
		buttonValider:SetParent( FestivalWindow );
		buttonValider:SetPosition(windowWidth/2 - 125,  windowHeight - 50);
		buttonValider:SetSize( 300, 20 );
		buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonValider:SetText( T[ "PluginCloseButton" ] );
		buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonValider:SetVisible(true);
		buttonValider:SetMouseVisible(true);

		CloseFestivalWindow();

		EscapeKeyHandlerForWindows(FestivalWindow, settings["isFestivalWindowVisible"]["value"]);
	end
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------

function CloseFestivalWindow()
	buttonValider.MouseClick = function(sender, args)
		FestivalWindow:SetVisible(false);
		settings["isFestivalWindowVisible"]["value"] = false;
	end
end