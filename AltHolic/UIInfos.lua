------------------------------------------------------------------------------------------
-- UIInfos file
-- Written by Homeopatix
-- 16 juin 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create infos window
------------------------------------------------------------------------------------------
function CreateInfosWindow()
	AltHolicInfosWindow=Turbine.UI.Lotro.GoldWindow(); 
	AltHolicInfosWindow:SetSize(300,450); 
	AltHolicInfosWindow:SetText("Informations"); 
	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(150,10); 
	AltHolicInfosWindow.Message:SetPosition(AltHolicInfosWindow:GetWidth()/2 - 75, AltHolicInfosWindow:GetHeight() - 20); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetText(T[ "PluginText" ]); 
	AltHolicInfosWindow:SetZOrder(1);
	AltHolicInfosWindow:SetWantsKeyEvents(true);
	AltHolicInfosWindow:SetVisible(false);

	AltHolicInfosWindow:SetPosition((Turbine.UI.Display:GetWidth()-AltHolicInfosWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-AltHolicInfosWindow:GetHeight())/2);
	------------------------------------------------------------------------------------------
	-- center window
	------------------------------------------------------------------------------------------

	posx = 40 ;
	Texte1 = Turbine.UI.Label();
	Texte1:SetParent(AltHolicInfosWindow); 
	Texte1:SetSize(250, 50); 
	Texte1:SetPosition(25, posx); 
	Texte1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);  
	Texte1:SetForeColor(Turbine.UI.Color.Gold); 
	Texte1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
	Texte1:SetText(T[ "PluginName" ]);
	Texte1:SetZOrder(1);

	posx = posx + 35;

	Texte2 = Turbine.UI.Label();
	Texte2:SetParent(AltHolicInfosWindow); 
	Texte2:SetSize(250, 50); 
	Texte2:SetPosition(25, posx); 
	Texte2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	Texte2:SetForeColor(Turbine.UI.Color.Gold); 
	Texte2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
	Texte2:SetText("V " .. tostring(Plugins[pluginName]:GetVersion())); 
	Texte2:SetZOrder(1);

	posx = posx + 60;

	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(300, 30); 
	AltHolicInfosWindow.Message:SetPosition(5, posx); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	AltHolicInfosWindow.Message:SetText( "Latest Update" ); 
	AltHolicInfosWindow.Message:SetForeColor(Turbine.UI.Color.Lime);

	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(300, 30); 
	AltHolicInfosWindow.Message:SetPosition(0, posx); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	AltHolicInfosWindow.Message:SetText("________________________"); 
	AltHolicInfosWindow.Message:SetForeColor(Turbine.UI.Color.Blue);

	posx = posx + 15;

	Texte2 = Turbine.UI.Label();
	Texte2:SetParent(AltHolicInfosWindow); 
	Texte2:SetSize(250, 50); 
	Texte2:SetPosition(25, posx); 
	Texte2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	Texte2:SetForeColor(Turbine.UI.Color.Gold); 
	Texte2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	Texte2:SetText(T[ "PluginDateUpdate" ]); 
	Texte2:SetZOrder(1);

	posx = posx + 60;

	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(300, 30); 
	AltHolicInfosWindow.Message:SetPosition(5, posx); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	AltHolicInfosWindow.Message:SetText( "Traductors" ); 
	AltHolicInfosWindow.Message:SetForeColor(Turbine.UI.Color.Lime);

	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(300, 30); 
	AltHolicInfosWindow.Message:SetPosition(0, posx); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	AltHolicInfosWindow.Message:SetText("________________________"); 
	AltHolicInfosWindow.Message:SetForeColor(Turbine.UI.Color.Blue);

	posx = posx + 15;

	Texte = Turbine.UI.Label();
	Texte:SetParent(AltHolicInfosWindow); 
	Texte:SetSize(250, 50); 
	Texte:SetPosition(25, posx); 
	Texte:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	Texte:SetForeColor(Turbine.UI.Color.Gold); 
	Texte:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	Texte:SetText(T[ "PluginLangUpdateFR" ]); 
	Texte:SetZOrder(1);

	posx = posx + 35;

	Texte = Turbine.UI.Label();
	Texte:SetParent(AltHolicInfosWindow); 
	Texte:SetSize(250, 50); 
	Texte:SetPosition(25, posx); 
	Texte:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	Texte:SetForeColor(Turbine.UI.Color.Gold); 
	Texte:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	Texte:SetText(T[ "PluginLangUpdateDE" ]); 
	Texte:SetZOrder(1);

	posx = posx + 35;

	Texte = Turbine.UI.Label();
	Texte:SetParent(AltHolicInfosWindow); 
	Texte:SetSize(250, 50); 
	Texte:SetPosition(25, posx); 
	Texte:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	Texte:SetForeColor(Turbine.UI.Color.Gold); 
	Texte:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	Texte:SetText(T[ "PluginLangUpdateEN" ]); 
	Texte:SetZOrder(1);

	posx = posx + 60;

	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(300, 30); 
	AltHolicInfosWindow.Message:SetPosition(5, posx); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	AltHolicInfosWindow.Message:SetText( "CalcStat By Giseldah" ); 
	AltHolicInfosWindow.Message:SetForeColor(Turbine.UI.Color.Lime);

	AltHolicInfosWindow.Message=Turbine.UI.Label(); 
	AltHolicInfosWindow.Message:SetParent(AltHolicInfosWindow); 
	AltHolicInfosWindow.Message:SetSize(300, 30); 
	AltHolicInfosWindow.Message:SetPosition(0, posx); 
	AltHolicInfosWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicInfosWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	AltHolicInfosWindow.Message:SetText("________________________"); 
	AltHolicInfosWindow.Message:SetForeColor(Turbine.UI.Color.Blue);

	posx = posx + 15;

	Texte = Turbine.UI.Label();
	Texte:SetParent(AltHolicInfosWindow); 
	Texte:SetSize(250, 50); 
	Texte:SetPosition(25, posx); 
	Texte:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	Texte:SetForeColor(Turbine.UI.Color.Gold); 
	Texte:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	Texte:SetText("V " .. T[ "PluginCalcStatVersion" ]); 
	Texte:SetZOrder(1);
end