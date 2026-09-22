------------------------------------------------------------------------------------------
-- MinimizedIcon file
-- Written by Ooz
------------------------------------------------------------------------------------------
import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

MinimizedIcon = class( Turbine.UI.Window );

-- Keep the floating launcher above AltHolic's ordinary windows, but below
-- LOTRO's full-screen overlays/loading screens. Extremely high values such
-- as 10000 can render plugin controls on top of the loading screen.
local LAUNCHER_Z_ORDER = 100;
local TOOLTIP_Z_ORDER = LAUNCHER_Z_ORDER + 1;

function MinimizedIcon:Constructor(image, width, height, callback)
	Turbine.UI.Window.Constructor( self );

	self:SetOpacity( 1 );
	self:SetVisible(true);
	self:SetZOrder(LAUNCHER_Z_ORDER);
	self:SetMouseVisible(true);
	self:SetWantsUpdates(false);

	self.passiveImage = image;
	self.icon = Turbine.UI.Control();
	self.icon:SetParent(self);
	self.icon:SetBackground(self.passiveImage);
	self.defaultOpacity = 1;

	self.trigger = Turbine.UI.Button();
	self.trigger:SetParent(self);
	self.trigger:SetZOrder(1);

	self:SetSize(width, height);
	local sh = Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
	self:SetPosition(1, sh);
	self.drag = false;
	
	self.active = false;
	self.framesPerActiveImage = 20;
	
	-- Small on-screen help shown when hovering the AltHolic icon.
	self.tooltip = Turbine.UI.Window();
	self.tooltip:SetSize( 205, 44 );
	self.tooltip:SetBackColor( Turbine.UI.Color( 0.92, 0.03, 0.03, 0.03 ) );
	self.tooltip:SetZOrder( TOOLTIP_Z_ORDER );
	self.tooltip:SetMouseVisible( false );
	self.tooltip:SetVisible( false );

	self.tooltipLabel = Turbine.UI.Label();
	self.tooltipLabel:SetParent( self.tooltip );
	self.tooltipLabel:SetPosition( 6, 3 );
	self.tooltipLabel:SetSize( 193, 38 );
	self.tooltipLabel:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	self.tooltipLabel:SetForeColor( Turbine.UI.Color( 1, 0.92, 0.78 ) );
	self.tooltipLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	self.tooltipLabel:SetMouseVisible( false );

	local function UpdateTooltipText()
		local moveText = "Alt+Drag: Move";
		if settings ~= nil and settings["altEnable"] ~= nil and settings["altEnable"]["altEnable"] == false then
			moveText = "Drag: Move";
		end
		self.tooltipLabel:SetText( "Shift+Click: Settings\n" .. moveText );
	end

	local function PositionTooltip()
		local x = self:GetLeft() + self:GetWidth() + 6;
		local y = self:GetTop() - 4;
		local screenW = Turbine.UI.Display.GetWidth();
		local screenH = Turbine.UI.Display.GetHeight();
		if x + self.tooltip:GetWidth() > screenW then
			x = self:GetLeft() - self.tooltip:GetWidth() - 6;
		end
		if y + self.tooltip:GetHeight() > screenH then
			y = screenH - self.tooltip:GetHeight() - 2;
		end
		if y < 0 then y = 0; end
		self.tooltip:SetPosition( x, y );
	end

	self.MouseEnter = function( sender, args )
		self:SetOpacity(1.0);
		UpdateTooltipText();
		PositionTooltip();
		self.tooltip:SetVisible( true );
	end
	self.MouseLeave = function( sender, args )
		self:SetOpacity(self.defaultOpacity);
		self.tooltip:SetVisible( false );
	end
	local function ToggleOptionsWindow()
		local isVisible = OptionsWindow ~= nil and OptionsWindow:IsVisible();
		if not isVisible then
			if OptionsWindow == nil then
				GenerateOptionsWindow();
			end
			OptionsWindow:SetVisible(true);
			AltHolicWindow:SetVisible(false);
			settings["isWindowVisible"]["isWindowVisible"] = false;
			settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = true;
		else
			OptionsWindow:SetVisible(false);
			AltHolicWindow:SetVisible(true);
			settings["isWindowVisible"]["isWindowVisible"] = true;
			settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
		end
	end

	local function ToggleMainWindow()
		local isVisible = AltHolicWindow:IsVisible();
		AltHolicWindow:SetVisible(not isVisible);
		settings["isWindowVisible"]["isWindowVisible"] = not isVisible;
	end

	self.trigger.MouseClick = function( sender, args )
		if (args.Button == Turbine.UI.MouseButton.Right) then
			settings["nameAccount"]["account1"]["isVisible"] = not settings["nameAccount"]["account1"]["isVisible"];
			UpdateMainWindow();
			return;
		end

		if (args.Button == Turbine.UI.MouseButton.Left and not self.thresholdTrigger) then
			-- Modifier state is a static Control API call. Do not gate Settings on
			-- account-name data: Shift+Click should always mean Settings.
			if Turbine.UI.Control.IsShiftKeyDown() then
				ToggleOptionsWindow();
			else
				ToggleMainWindow();
			end
		end
	end
	self.trigger.MouseDown = function( sender, args )
			self.drag = true;
			self.thresholdTrigger = false;
			self.mx0 = args.X;
			self.my0 = args.Y;
	end
	self.trigger.MouseUp = function( sender, args )
		self.drag = false;
	end
	self.trigger.MouseMove = function( sender, args )
		if(settings["altEnable"]["altEnable"] == true)then
			if self.drag and Turbine.UI.Control.IsAltKeyDown() then
				local dx = args.X - self.mx0;
				local dy = args.Y - self.my0;
				-- Write("dragged "..dx.." "..dy);
				if (self.thresholdTrigger or dx>3 or dx<-3 or dy>3 or dy<-3) then
					self.thresholdTrigger = true;
					local x = self:GetLeft()+dx;
					local y = self:GetTop()+dy;
					if x<0 then x=0 end;
					if y<0 then y=0 end;
					local sh = Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
					local sw = Turbine.UI.Display.GetWidth()-self:GetWidth()-1;
					if x>sw then x=sw end;
					if y>sh then y=sh end;
					self:SetLeft(x);
					self:SetTop(y);
				end
			end
		else
			if self.drag then
				local dx = args.X - self.mx0;
				local dy = args.Y - self.my0;
				-- Write("dragged "..dx.." "..dy);
				if (self.thresholdTrigger or dx>3 or dx<-3 or dy>3 or dy<-3) then
					self.thresholdTrigger = true;
					local x = self:GetLeft()+dx;
					local y = self:GetTop()+dy;
					if x<0 then x=0 end;
					if y<0 then y=0 end;
					local sh = Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
					local sw = Turbine.UI.Display.GetWidth()-self:GetWidth()-1;
					if x>sw then x=sw end;
					if y>sh then y=sh end;
					self:SetLeft(x);
					self:SetTop(y);
				end
			end
		end
	end
	self.Update = function(sender, args)
		if self.active then
			if not Turbine.Gameplay.LocalPlayer.GetInstance():IsInCombat() then
				self.frameCount = self.frameCount +1;
				if self.frameCount > self.framesPerActiveImage then
					self.frameCount = 0;
					self.currentImageIndex = self.currentImageIndex + 1;
					if self.currentImageIndex>#self.imageTable then
						self.currentImageIndex = 1;
					end
					self.icon:SetBackground(self.imageTable[self.currentImageIndex]);
					if self.activeTickCallback~=nil then
						self.activeTickCallback();
					end
				end
			end
		end
	end

end

function MinimizedIcon:SetImage(image)
    self.passiveImage = image;
    self.icon:SetBackground(image);
end

function MinimizedIcon:SetDefaultOpacity(opacity)
	self.defaultOpacity = opacity;
	self:SetOpacity(opacity);
	self:SetBlendMode(Turbine.UI.BlendMode.Overlay)
end

function MinimizedIcon:SetActiveAnimation(imageTable)
	self.imageTable = imageTable;
	self.currentImageIndex = 1;
	self.frameCount = 0;
end

function MinimizedIcon:SetActive(value)
	if value then
		self:SetOpacity( .90 );
		if self.imageTable==nil or #self.imageTable==0 then
			self.imageTable	= {self.passiveImage}; -- graceful error handling
		end
		self:SetWantsUpdates(true);
		self.active = true;
	else
		self.active = false;
		self:SetWantsUpdates(false);
		self:SetOpacity( .25 );
		self.icon:SetBackground(self.passiveImage);
	end
end

function MinimizedIcon:SetFramesPerActiveImage(value)
	self.framesPerActiveImage = tonumber(value) or 20;
end

function MinimizedIcon:SetActiveTickCallback(callback)
	self.activeTickCallback = callback;
end

function MinimizedIcon:SetSize(width, height)
	Turbine.UI.Control.SetSize(self, width, height);
	self.icon:SetSize(width, height);
	self.trigger:SetSize(width, height);
end

function MinimizedIcon:SetHeight(height)
	self:SetSize(self:GetWidth(), height)
end

function MinimizedIcon:SetWidth(width)
	self:SetSize(width, self:GetHeight())
end

function MinimizedIcon:SetText(text)
	self.trigger:SetText(text);
end

function MinimizedIcon:SetFont(font)
	self.trigger:SetFont(font);
end

function MinimizedIcon:SetFontStyle(style)
	self.trigger:SetFontStyle(style);
end

function MinimizedIcon:SetForeColor(color)
	self.trigger:SetForeColor(color);
end

function MinimizedIcon:SetOutlineColor(color)
	self.trigger:SetOutlineColor(color);
end

