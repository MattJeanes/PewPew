local PANEL = {}

function PANEL:Init()
	self.Value = 0
	self.OldValue = 0
	self.Min = 0
	self.Max = 100
	self.Current = 0
	self.Rate = 1
	self.Percent = 0
	self.Text = ""
end

function PANEL:SetMin( value ) 
	if (value > self.Max) then
		self.Min = self.Max
		self.Max = value
	else
		self.Min = value 
	end
end
function PANEL:SetMax( value ) 
	if (value < self.Min) then
		self.Max = self.Min
		self.Min = value
	else
		self.Max = value
	end
end
function PANEL:SetMinMax( min, max ) 
	self.Min = math.min( min,max )
	self.Max = math.max( min,max )
end
function PANEL:SetValue( value ) 
	self.Value = math.Clamp(tonumber(value or 0) or 0,self.Min,self.Max)
end
function PANEL:SetRate( value ) self.Rate = value end
function PANEL:SetText( value ) self.Text = value end

function PANEL:Paint()
	local w, h = self:GetSize()
	surface.SetDrawColor( 0,0,0,255 )
	surface.DrawOutlinedRect( 0,0 , w, h )
	
	if (self.Value != self.Current) then
		local Diff = self.Value - self.Current
		--local Add = math.max(math.sqrt((Diff*self.Rate)^2/(2-(self.Current/self.Max))),0.1)
		local Add = math.max(math.sqrt((Diff*self.Rate)^2/((self.Max-self.Min)/math.abs(Diff))),0.1)
		local sign = (Diff > 0 and 1 or -1)
		if ((Diff <= 0.1 and sign == 1) or (Diff >= 0.1 and sign == -1)) then
			self.Current = self.Value
			self.Percent = (self.Current-self.Min)/(self.Max-self.Min)
		else
			Add = Add * sign
			self.Current = self.Current + Add
			self.Percent = (self.Current-self.Min)/(self.Max-self.Min)
		end
	elseif (self.Value == self.Current and self.OldValue != self.Value) then
		self.OldValue = self.Value
	end

	surface.SetDrawColor( 255 - 255 * self.Percent, 255 * self.Percent, 0, 255 )
	surface.DrawRect( 1, 1, w * self.Percent - 2, h - 2 )
	
	surface.SetTextColor( 0,0,0,255 )
	local t
	if (self.Current > 10) then t = math.Round(self.Current) else t = self.Current end
	local textw, texth = surface.GetTextSize( t )
	surface.SetTextPos( w - textw - 2, h / 2 - texth/(6/3) )
	surface.DrawText( t )
	
	surface.SetTextColor( 0,0,0,255 )
	surface.SetTextPos( 4, h / 2 - texth/(6/3) )
	surface.DrawText( self.Text )
end

vgui.Register( "PewPew_StatusBar", PANEL, "DPanel" )