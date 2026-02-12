------------------------------------------------------------------------------------------
-- FCT_Utility file
-- Written by Homeopatix
-- 19 march 2022
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Utility functions
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Random function
------------------------------------------------------------------------------------------
local cDate = Turbine.Engine.GetDate();
local u = cDate.Second;
function Random(x, y)
    u = u + 10;
    if(x ~= nil and y ~= nil) then
        return math.floor(x +(math.random(math.randomseed(Turbine.Engine.GetLocalTime()+u))*999999 %y));
    else
        return math.floor((math.random(math.randomseed(Turbine.Engine.GetLocalTime()+u))*100));
    end
end
------------------------------------------------------------------------------------------
-- function to round a value --
------------------------------------------------------------------------------------------
function Round(valeur)

	valeur = tonumber(valeur);
	if(valeur ~= nil)then
		local floor = math.floor(valeur);
		local ceiling = math.ceil(valeur);
		if ((valeur - floor) >= 0.5) then
			return ceiling;
		end
		return floor;
	else
		return valeur;
	end
end
------------------------------------------------------------------------------------------
-- set pourcentage
-- Formula and data used from: http://lotro-wiki.com/index.php/rating_to_percentage_formula
-- Huge thanks to Giseldah for figuring this out and sharing    
------------------------------------------------------------------------------------------
function get_percentage(Attribute,R,L,PenName,PenFactor, namePlayerToShow)
    local SName = Attribute;
    local Capped = 0;
    
    if SName == "PhyMit" or SName == "TacMit" then -- is dependant on armour type
        if PlayerDatas[namePlayerToShow].cla == 185 or PlayerDatas[namePlayerToShow].cla == 31 or PlayerDatas[namePlayerToShow].cla == 193 then
            SName = SName.."L";
        elseif PlayerDatas[namePlayerToShow].cla == 40 or PlayerDatas[namePlayerToShow].cla == 162 or PlayerDatas[namePlayerToShow].cla == 194 then
            SName = SName.."M";
        elseif PlayerDatas[namePlayerToShow].cla == 214 or PlayerDatas[namePlayerToShow].cla == 24 or PlayerDatas[namePlayerToShow].cla == 172 or PlayerDatas[namePlayerToShow].cla == 23 then
            SName = SName.."H";
        end
    end

    local P = CalcStat(SName.."PRatP",L,R) + 0.0002 + CalcStat(SName.."PBonus",L);
    local Rcap = CalcStat(SName.."PRatPCapR",L);
  
    if PenName == nil then
      if R >= Rcap then
        Capped = 1;
      end
    else
      local PenValue;
      PenValue = CalcStat("TPen"..PenName,L,3);
      if PenFactor ~= nil then PenValue = PenValue * PenFactor; end
      if R + PenValue >= Rcap then
        Capped = 4;
      else
        PenValue = CalcStat("TPen"..PenName,L,2);
        if PenFactor ~= nil then PenValue = PenValue * PenFactor; end
        if R + PenValue >= Rcap then
          Capped = 3;
        else
          PenValue = CalcStat("T2Pen"..PenName,L);
          if PenFactor ~= nil then PenValue = PenValue * PenFactor; end
          if R + PenValue >= Rcap then
            Capped = 2;
          elseif R >= Rcap then
              Capped = 1;
          end
        end
      end
    end
    
    return rating_string(R, P, Attribute), Capped;
end
------------------------------------------------------------------------------------------
-- return rating
-- String format for Rating and percentage 1234 (25.1%)
------------------------------------------------------------------------------------------
function rating_string(r,p,a) 
    r = comma_value(math.floor(r+0.5));
    if a == "PartBlock" or a == "PartParry" or a == "PartEvade" then return (string.format("%.1f", p) .. "%"); end
    return (r .. " (" .. string.format("%.1f", p) .. "%)");
end
------------------------------------------------------------------------------------------
-- return comma separator for millier --
------------------------------------------------------------------------------------------
function comma_value(n) -- credit http://richard.warburton.it
    if(n ~= nil)then
		local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
		return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	else
		return n;
	end
end
------------------------------------------------------------------------------------------
-- split strings function
------------------------------------------------------------------------------------------
function Split(s, delimiter)
    result = {};
    if(s ~= "" and s ~= nil)then
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match);
        end
    end
    return result;
end
------------------------------------------------------------------------------------------
-- return table lenght
------------------------------------------------------------------------------------------
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
