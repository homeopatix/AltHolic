------------------------------------------------------------------------------------------
-- CalcStat file
-- Written by Giseldah
-- Version 2.3.1
-- ****************************** Start CalcStat ******************************

local p = _G --p stands for package

-- local used library functions
local mathabs = math.abs
local mathfloor = math.floor
local mathfrexp = math.frexp
local mathhuge = math.huge
local mathldexp = math.ldexp
local mathlog10 = math.log10
local mathmodf = math.modf
local strfind = string.find
local strmatch = string.match
local strsub = string.sub
local strupper = string.upper

-- ****************************** Start CalcStat ******************************

-- removes leading and trailing white space characters from a string
local function trim(s)
	if type(s) == "string" then
		return strmatch(s,"^()%s*$") and "" or strmatch(s,"^%s*(.*%S)")
	else
		return ""
	end
end

-- **************** Misc. floating point support functions ****************

-- Floating point numbers bring errors into the calculation, both inside the Lotro-client and in this function collection. This is why a 100% match with the stats in Lotro is impossible.
-- Anyway, to compensate for some errors, we use a calculation deviation correction value. This makes for instance 24.49999999 round to 25, as it's assumed that 24.5 was intended as outcome of a formula.
local DblCalcDev = 0.00000001

-- Misc. functions for floating point rounding.
-- 2nd parameter is number of decimals.

local function CorrectDbl(dNum,dCorrection,dDec)
	local lSign = 1
	if dNum < 0 then
		lSign = -1
	end
	if -DblCalcDev <= dDec and dDec <= DblCalcDev then
		return lSign*mathfloor(lSign*dNum+dCorrection)
	else
		local lFactor
		if dDec >= 0.0 then
			lFactor = 10^mathfloor(dDec+DblCalcDev)
			return lSign*mathfloor((lSign*lFactor)*dNum+dCorrection)/lFactor
		else
			lFactor = 10^mathfloor(-dDec+DblCalcDev)
			return lSign*mathfloor((lSign/lFactor)*dNum+dCorrection)*lFactor
		end
	end
end

local function RoundDbl(dNum,vDec)
	if vDec == nil then
		return CorrectDbl(dNum,0.5+DblCalcDev,0.0)
	else
		return CorrectDbl(dNum,0.5+DblCalcDev,vDec)
	end
end

local function RoundDblDown(dNum,vDec)
	if vDec == nil then
		return CorrectDbl(dNum,DblCalcDev,0.0)
	else
		return CorrectDbl(dNum,DblCalcDev,vDec)
	end
end

local function RoundDblUp(dNum,vDec)
	if vDec == nil then
		return CorrectDbl(dNum,1.0-DblCalcDev,0.0)
	else
		return CorrectDbl(dNum,1.0-DblCalcDev,vDec)
	end
end

local function RoundDblLotro(dNum)
	local dCorrection = 1.0-DblCalcDev
	local lSign = 1
	if dNum < 0 then
		lSign = -1
	end

	local lNumCeiled = mathfloor(lSign*dNum+dCorrection)
	if lNumCeiled <= 1000 then
		return lSign*lNumCeiled
	end

	local lFactor = 1
	local lTestNum = mathfloor(lNumCeiled/1000)
	while lTestNum > 0 do
		lTestNum = mathfloor(lTestNum/10)
		lFactor = lFactor*10
	end

	return lSign*mathfloor(lNumCeiled/lFactor+dCorrection)*lFactor
end

local function RoundDblProg(dNum)
	if -DblCalcDev <= dNum and dNum <= DblCalcDev then
		return 0.0
	end

	local dCorrection = 0.5+DblCalcDev
	local lSign = 1
	if dNum < 0.0 then
		lSign = -1
	end

	local dTestNum = dNum/(0.5*(lSign*63))
	local lDec = -mathfloor(mathlog10(dTestNum))

	if lDec == 0 then
		return lSign*mathfloor(lSign*dNum+dCorrection)
	else
		local lFactor
		if lDec > 0 then
			lFactor = 10^lDec
			return lSign*mathfloor((lSign*lFactor)*dNum+dCorrection)/lFactor
		else
			lFactor = 10^(-lDec)
			return lSign*mathfloor((lSign/lFactor)*dNum+dCorrection)*lFactor
		end
	end
end

-- Constants for single-precision floating-point calculations
local IEEE754_MANTISSA_SIZE = 23 -- 23 bits for single-precision IEEE 754
local IEEE754_MANTISSA_BITSCALE = 2^IEEE754_MANTISSA_SIZE -- Scales mantissa [0,1) to bits value
local IEEE754_MANTISSA_VALUESCALE = 2^-IEEE754_MANTISSA_SIZE -- Scales mantissa bits value to [0,1)
local IEEE754_EXPONENT_SIZE = 8 -- 8 bits for single-precision IEEE 754
local IEEE754_MIN_NORMAL_EXPONENT = 2-2^(IEEE754_EXPONENT_SIZE-1) -- Smallest exponent for normalized numbers
local IEEE754_MAX_NORMAL_EXPONENT = 2^(IEEE754_EXPONENT_SIZE-1)-1 -- Largest exponent for normalized numbers


-- Converts a double-precision value into the equivalent of a single-precision value
local function EquSng(vVal)
	-- Handle special cases (zero, infinity, NaN)
	if vVal == 0 then
		return 0.0
	elseif vVal == mathhuge then
		return mathhuge
	elseif vVal == -mathhuge then
		return -mathhuge
	elseif vVal ~= vVal then
		return 0/0  -- NaN
	end

	-- Get the sign and absolute value of the (double float) number
	local nSign
	local nValAbs
	if vVal < 0 then
		nSign = -1.0
		nValAbs = -vVal
	else
		nSign = 1.0
		nValAbs = vVal
	end

	-- Explicit leading 1 used for calculating the single float value: will be 1(normalized value) or 0(subnormal number)
	local nLeadingOne -- tbd
	-- Use math.frexp to get mantissa and exponent, where nValAbs = mantissa * 2^exponent, with mantissa in the range [0.5,1.0)
	local nMantissa, nExponent = mathfrexp(nValAbs)
	-- math.frexp did not return a mantissa value in the right interval for a normalized number
	nMantissa = nMantissa*2.0 -- Transform mantissa from [0.5,1.0) to [1.0,2.0) for now. Later becomes implicit leading 1.0 + [0.0,1.0) for normalized numbers.
	nExponent = nExponent-1 -- Mantissa became larger by factor 2^1, need to compensate for this in the exponent.

	if nExponent > IEEE754_MAX_NORMAL_EXPONENT then
		-- Overflow to infinity
		return (nSign == -1.0) and -mathhuge or mathhuge
	elseif nExponent < IEEE754_MIN_NORMAL_EXPONENT then
		-- Subnormal number
		nLeadingOne = 0.0
		nMantissa = mathldexp(nMantissa,nExponent-IEEE754_MIN_NORMAL_EXPONENT) -- Transfer old exponent into mantissa and extract new exponent(MIN_NORMAL_EXPONENT) in one go
		nExponent = IEEE754_MIN_NORMAL_EXPONENT
	else
		-- Normalized number
		nLeadingOne = 1.0 -- Transfer 1 from mantissa to 'explicit leading 1'
		nMantissa = nMantissa-1.0 -- Mantissa is now in the interval [0.0,1.0)
	end

	-- Scale mantissa to bitfield representation integer
	local nFraction; nMantissa, nFraction = mathmodf(nMantissa*IEEE754_MANTISSA_BITSCALE)
	-- Round to nearest, ties to even (sticky to even)
    if nFraction > 0.5 or (nFraction == 0.5 and nMantissa%2 ~= 0) then
        nMantissa = nMantissa+1 -- Round-up if fraction is larger than 0.5 or if fraction is 0.5 and current mantissa is not an even number
    end
	-- Handle overflow
	if nMantissa == IEEE754_MANTISSA_BITSCALE then
		-- Overflow in mantissa
		if nLeadingOne == 0.0 then
			-- Subnormal number: transform to Normalized number
			nLeadingOne = 1.0
		else
			-- Normalized number: increment exponent
			nExponent = nExponent+1
			if nExponent > IEEE754_MAX_NORMAL_EXPONENT then
				-- Overflow to infinity
				return (nSign == -1.0) and -mathhuge or mathhuge
			end
		end
		nMantissa = 0 -- Reset mantissa
	end

	return nSign*mathldexp(nLeadingOne+nMantissa*IEEE754_MANTISSA_VALUESCALE,nExponent)
end

-- Converts a double value into the decimal representation of an equivalent single float value
local function DecSng(vVal)
	local dVal = EquSng(vVal)
	if dVal == 0.0 then
		-- return 0 when 0
		return 0.0
	end
	-- calculate decimals interval for a max total of 8 digit precision
	-- 0.09#######: 9 to 2
	-- 0.9#######: 8 to 1
	-- 9.#######: 7 to 0
	-- 9#.######: 6 to -1
	-- 9##.#####: 5 to -2 etc
	local iDecMin = 8-(mathfloor(mathlog10(mathabs(dVal)))+1)
	local iDecMax = iDecMin-7
	-- result always needs to be rounded at least once, even if the result is not the same as the original equiv. float value
	local dResult = CorrectDbl(dVal,0.5,iDecMin)
	-- search for the least number of decimals, while still keeping the same single value
	local dTest
	for iDec = iDecMin-1,iDecMax,-1 do
		dTest = CorrectDbl(dVal,0.5,iDec) -- test value with ever less precision
		if dTest ~= dResult then
			if EquSng(dTest) == dVal then
				dResult = dTest
			else
				-- (test)value contains no longer the same single value
				break
			end
		end
	end
	return dResult
end

function CalcStat(SName, SLvl, SParam)

	-- process parameters and parameter defaults

	local sStatName = trim(SName)
	if sStatName == "" then
		return 0, {Source = "CalcStat", Code = -1, Message = "Missing stat name"}
	end

	local SN
	repeat
		SN = strmatch(sStatName,"^-?%a%w*%a$") -- allow nested digits in stat name and a starting -
		if SN then break end
		SN = strmatch(sStatName,"^-?%a$") -- to allow single character stat name as well
		if SN then break end
		return 0, {Source = "CalcStat", Code = -2, Message = "Illegal stat name", Detail = "Stat '"..sStatName.."'"}
	until true
	SN = strupper(SN) -- uppercase and trimmed for keyword matching
	
	local L = 1.0 -- default L
	if type(SLvl) == "number" then
		L = SLvl
	elseif type(SLvl) ~= "nil" then
		return 0, {Source = "CalcStat", Code = -3, Message = "Illegal level", Detail = "Stat '"..SN.."' [Level:"..type(SLvl)..", Expecting:number,nil]"}
	end
	local Lm = L-DblCalcDev
	local Lp = L+DblCalcDev

	local N = 1.0 -- default N
	local C = "" -- default C
	if type(SParam) == "number" then
		N = SParam
	elseif type(SParam) == "string" then
		C = SParam
	elseif type(SParam) ~= "nil" then
		return 0, {Source = "CalcStat", Code = -4, Message = "Illegal N or C", Detail = "Stat '"..SN.."' [N or C:"..type(SParam)..", Expecting:number,string,nil]"}
	end

	local Result = 0.0

	-- binary search tree (generated code)

	if SN < "MINSTRELCDARMOURTOCOMPHYMIT" then
		if SN < "CPTSHIELDCRITDEF" then
			if SN < "BRAWLERCDVITALITYTOICMR" then
				if SN < "BEORNINGCDARMOURTOTACMIT" then
					if SN < "AWARDILVLDC" then
						if SN < "ARMOURT" then
							if SN < "AGILITYCI" then
								if SN < "ADJITEMMIT" then
									if SN < "ADJCREEPITEM" then
										if SN < "ACIDMIT" then
											if SN == "-VERSION" then
												Result = "2.4.12f"
											end
										elseif SN > "ACIDMIT" then
											if SN == "ACIDMITT" then
												Result = CalcStat("DmgTypeMitT",L,N)
											end
										else
											Result = CalcStat("DmgTypeMit",L,N)
										end
									elseif SN > "ADJCREEPITEM" then
										if SN < "ADJITEM" then
											if SN == "ADJCREEPITEMMIT" then
												if 450 <= Lp and Lm <= 499 then
													Result = 0.9235
												elseif 500 <= Lp and Lm <= 500 then
													Result = 0.9215
												elseif 549 <= Lp and Lm <= 549 then
													Result = 0.9914
												else
													Result = 1
												end
											end
										elseif SN > "ADJITEM" then
											if SN == "ADJITEMMAS" then
												if 499 <= Lp and Lm <= 499 then
													Result = 0.9
												elseif 500 <= Lp and Lm <= 550 then
													Result = 42/51
												else
													Result = 1
												end
											end
										else
											if 499 <= Lp and Lm <= 550 then
												Result = 0.9
											else
												Result = 1
											end
										end
									else
										if 450 <= Lp and Lm <= 499 then
											Result = 0.9226
										elseif 500 <= Lp and Lm <= 500 then
											Result = 0.923
										elseif 549 <= Lp and Lm <= 549 then
											Result = 0.9902
										else
											Result = 1
										end
									end
								elseif SN > "ADJITEMMIT" then
									if SN < "ADJVIRTUEMAS" then
										if SN < "ADJTRAITMAS" then
											if SN == "ADJTRAIT" then
												if 141 <= Lp and Lm <= 150 then
													Result = 0.9
												else
													Result = 1
												end
											end
										elseif SN > "ADJTRAITMAS" then
											if SN == "ADJTRAITMIT" then
												if 141 <= Lp and Lm <= 141 then
													Result = 0.78
												elseif 150 <= Lp and Lm <= 160 then
													Result = 0.7
												else
													Result = 1
												end
											end
										else
											if 141 <= Lp and Lm <= 141 then
												Result = 0.9
											elseif 150 <= Lp and Lm <= 160 then
												Result = 42/51
											else
												Result = 1
											end
										end
									elseif SN > "ADJVIRTUEMAS" then
										if SN < "AGILITY" then
											if SN == "ADJVIRTUEMORALE" then
												if Lm <= 0 then
													Result = 0
												elseif 50 <= Lp and Lm <= 50 then
													Result = 2
												elseif 60 <= Lp and Lm <= 80 then
													Result = 1.5
												elseif 499 <= Lp and Lm <= 499 then
													Result = 0.9475
												else
													Result = 1
												end
											end
										elseif SN > "AGILITY" then
											if SN == "AGILITYC" then
												Result = CalcStat("MainC",L,N)
											end
										else
											Result = CalcStat("Main",L,N)
										end
									else
										if Lm <= 0 then
											Result = 0
										elseif 399 <= Lp and Lm <= 399 then
											Result = 56/51
										elseif 499 <= Lp and Lm <= 499 then
											Result = 0.9
										elseif 500 <= Lp and Lm <= 550 then
											Result = 42/51
										else
											Result = 1
										end
									end
								else
									if 499 <= Lp and Lm <= 499 then
										Result = 0.78
									elseif 500 <= Lp and Lm <= 550 then
										Result = 0.7
									else
										Result = 1
									end
								end
							elseif SN > "AGILITYCI" then
								if SN < "ARMOURCILVLFILTER" then
									if SN < "ARMCATPROGB" then
										if SN < "ALIGNMENTNAME" then
											if SN == "AGILITYT" then
												Result = CalcStat("MainT",L,N)
											end
										elseif SN > "ALIGNMENTNAME" then
											if SN == "ARMCATMP" then
												Result = CalcStat("PntMPArmour",L)
											end
										else
											if 1 <= Lp and Lm <= 1 then
												Result = "Good"
											elseif 2 <= Lp and Lm <= 2 then
												Result = "Neutral"
											elseif 3 <= Lp and Lm <= 3 then
												Result = "Evil"
											else
												Result = ""
											end
										end
									elseif SN > "ARMCATPROGB" then
										if SN < "ARMOURC" then
											if SN == "ARMOUR" then
												Result = RoundDblDown(StatLinInter("ArmourPntMP","ItemPntS","ArmourProgB","AdjItemMit",L,C,0))
											end
										elseif SN > "ARMOURC" then
											if SN == "ARMOURCI" then
												Result = RoundDblLotro(CalcStat("ArmourCIRaw",L,N))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ArmourCI",CalcStat("ArmourCILvlFilter",N),N),0)
										end
									else
										if 1 <= Lp and Lm <= 1 then
											Result = CalcStat("ProgBArmourHeavy",N)
										elseif 2 <= Lp and Lm <= 2 then
											Result = CalcStat("ProgBArmourMedium",N)
										elseif 3 <= Lp and Lm <= 3 then
											Result = CalcStat("ProgBArmourLight",N)
										end
									end
								elseif SN > "ARMOURCILVLFILTER" then
									if SN < "ARMOURLOWPNTMP" then
										if SN < "ARMOURCRAW" then
											if SN == "ARMOURCIRAW" then
												Result = StatLinInter("PntMPArmourC","ItemPntS","ProgBArmour","AdjCreepItemMit",L,N,4)
											end
										elseif SN > "ARMOURCRAW" then
											if SN == "ARMOURLOW" then
												Result = RoundDblDown(StatLinInter("ArmourLowPntMP","ItemPntS","ArmourProgB","AdjItemMit",L,C,0))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ArmourCIRaw",CalcStat("ArmourCILvlFilter",N),N),99)
										end
									elseif SN > "ARMOURLOWPNTMP" then
										if SN < "ARMOURPNTMP" then
											if SN == "ARMOURPENT" then
												Result = EquSng(StatLinInter("PntMPArmourPenT","TraitPntS","ProgBArmour","",L,N,0))
											end
										elseif SN > "ARMOURPNTMP" then
											if SN == "ARMOURPROGB" then
												Result = CalcStat("ArmCatProgB",ArmCodeIndex(C,1),L)
											end
										else
											Result = CalcStat("ArmTypeMP",ArmCodeIndex(C,2))*CalcStat("ArmQtyMP",ArmCodeIndex(C,3),ArmCodeIndex(C,2))*CalcStat("ArmCatMP",ArmCodeIndex(C,1))
										end
									else
										Result = CalcStat("ArmTypeMP",ArmCodeIndex(C,2))*CalcStat("ArmQtyLowMP",ArmCodeIndex(C,2))*CalcStat("ArmCatMP",ArmCodeIndex(C,1))
									end
								else
									if 5.6 <= Lp and Lm <= 5.6 then
										Result = 515
									else
										Result = CalcStat("CreepILvlCurr",L)
									end
								end
							else
								Result = CalcStat("MainCI",L,N)
							end
						elseif SN > "ARMOURT" then
							if SN < "AWARDILVLBA" then
								if SN < "ARMTYPEMP" then
									if SN < "ARMQTYLOWMP" then
										if SN < "ARMQTYEPICMP" then
											if SN == "ARMQTYCOMMMP" then
												if 1 <= Lp and Lm <= 8 then
													Result = DataTableValue({22/30,22/30,0.8,0.8,0.76,0.804,0.8,0.7},L)
												end
											end
										elseif SN > "ARMQTYEPICMP" then
											if SN == "ARMQTYINCOMPMP" then
												if 1 <= Lp and Lm <= 8 then
													Result = DataTableValue({28/30,28/30,0.95,0.95,0.94,0.948,0.95,0.95},L)
												end
											end
										else
											if 1 <= Lp and Lm <= 8 then
												Result = DataTableValue({1,1,1,1,1,1.002,1,1},L)
											end
										end
									elseif SN > "ARMQTYLOWMP" then
										if SN < "ARMQTYRAREMP" then
											if SN == "ARMQTYMP" then
												if 1 <= Lp and Lm <= 1 then
													Result = CalcStat("ArmQtyCommMP",N)
												elseif 2 <= Lp and Lm <= 2 then
													Result = CalcStat("ArmQtyUncomMP",N)
												elseif 3 <= Lp and Lm <= 3 then
													Result = CalcStat("ArmQtyRareMP",N)
												elseif 4 <= Lp and Lm <= 4 then
													Result = CalcStat("ArmQtyIncompMP",N)
												elseif 5 <= Lp and Lm <= 5 then
													Result = CalcStat("ArmQtyEpicMP",N)
												end
											end
										elseif SN > "ARMQTYRAREMP" then
											if SN == "ARMQTYUNCOMMP" then
												if 1 <= Lp and Lm <= 8 then
													Result = DataTableValue({22/30,22/30,0.85,0.85,0.82,0.852,0.85,0.75},L)
												end
											end
										else
											if 1 <= Lp and Lm <= 8 then
												Result = DataTableValue({26/30,26/30,0.9,0.9,0.88,0.9,0.9,0.8},L)
											end
										end
									else
										if 1 <= Lp and Lm <= 8 then
											Result = DataTableValue({12/33,12/33,12/33,12/33,12/33,0.996*12/33,12/33,12/33},L)
										end
									end
								elseif SN > "ARMTYPEMP" then
									if SN < "AWARDILVLAB" then
										if SN < "AWARDILVLA" then
											if SN == "AUTOLVLTOILVL" then
												Result = CalcStat("AwardILvlCC",L)
											end
										elseif SN > "AWARDILVLA" then
											if SN == "AWARDILVLAA" then
												if 75 <= Lp and Lm <= 75 then
													Result = CalcStat("AwardILvlA",L)+3
												else
													Result = CalcStat("AwardILvlA",L)
												end
											end
										else
											if Lm <= 75 then
												Result = L
											elseif Lm <= 94 then
												Result = 5*L-304
											elseif Lm <= 95 then
												Result = 173
											elseif Lm <= 100 then
												Result = 5*L-304
											elseif Lm <= 101 then
												Result = 197
											elseif Lm <= 104 then
												Result = 4*L-206
											elseif Lm <= 105 then
												Result = 218
											elseif Lm <= 110 then
												Result = RoundDbl(LinFmod(1,295,303.8,106,110,L))
											elseif Lm <= 115 then
												Result = 304
											elseif Lm <= 119 then
												Result = RoundDbl(LinFmod(1,345,357,116,119,L))
											elseif Lm <= 120 then
												Result = 359
											elseif Lm <= 130 then
												Result = 395
											elseif Lm <= 140 then
												Result = RoundDbl(LinFmod(1,445.4,455.4,131,140,L))
											elseif Lm <= 150 then
												Result = RoundDbl(LinFmod(1,479.4,491.4,141,150,L))
											else
												Result = CalcStat("AwardILvlA",150)
											end
										end
									elseif SN > "AWARDILVLAB" then
										if SN < "AWARDILVLAOLD" then
											if SN == "AWARDILVLAC" then
												if 75 <= Lp and Lm <= 75 then
													Result = CalcStat("AwardILvlA",L)+2
												else
													Result = CalcStat("AwardILvlA",L)
												end
											end
										elseif SN > "AWARDILVLAOLD" then
											if SN == "AWARDILVLB" then
												if Lm <= 4 then
													Result = CalcStat("AwardILvlA",1)
												elseif Lm <= 50 then
													Result = CalcStat("AwardILvlA",L-4)
												elseif Lm <= 54 then
													Result = CalcStat("AwardILvlA",51)
												elseif Lm <= 75 then
													Result = CalcStat("AwardILvlA",L-4)
												elseif Lm <= 95 then
													Result = CalcStat("AwardILvlA",L)+4
												else
													Result = CalcStat("AwardILvlA",L)
												end
											end
										else
											Result = CalcStat("AwardILvlA",L)
										end
									else
										if 75 <= Lp and Lm <= 75 then
											Result = CalcStat("AwardILvlA",L)+1
										else
											Result = CalcStat("AwardILvlA",L)
										end
									end
								else
									if 1 <= Lp and Lm <= 8 then
										Result = DataTableValue({9,9,20,30,15,25,12,32.726},L)
									end
								end
							elseif SN > "AWARDILVLBA" then
								if SN < "AWARDILVLCF" then
									if SN < "AWARDILVLCB" then
										if SN < "AWARDILVLC" then
											if SN == "AWARDILVLBOLD" then
												Result = CalcStat("AwardILvlB",L)
											end
										elseif SN > "AWARDILVLC" then
											if SN == "AWARDILVLCA" then
												if Lm <= 8 then
													Result = CalcStat("AwardILvlA",1)
												elseif Lm <= 85 then
													Result = CalcStat("AwardILvlA",L)-8
												elseif 96 <= Lp and Lm <= 100 then
													Result = CalcStat("AwardILvlA",L)+4
												else
													Result = CalcStat("AwardILvlA",L)
												end
											end
										else
											if Lm <= 75 then
												Result = CalcStat("AwardILvlB",L)
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									elseif SN > "AWARDILVLCB" then
										if SN < "AWARDILVLCD" then
											if SN == "AWARDILVLCC" then
												Result = CalcStat("AwardILvlC",L)
											end
										elseif SN > "AWARDILVLCD" then
											if SN == "AWARDILVLCE" then
												if Lm <= 140 then
													Result = CalcStat("AwardILvlC",L)
												elseif Lm <= 150 then
													Result = RoundDbl(LinFmod(1,500.4,512.4,141,150,L))
												else
													Result = CalcStat("AwardILvlCE",150)
												end
											end
										else
											if Lm <= 8 then
												Result = CalcStat("AwardILvlA",1)
											elseif Lm <= 85 then
												Result = CalcStat("AwardILvlA",L)-8
											elseif Lm <= 100 then
												Result = CalcStat("AwardILvlA",L)-4
											elseif Lm <= 105 then
												Result = CalcStat("AwardILvlA",L)+4
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									else
										if Lm <= 10 then
											Result = CalcStat("AwardILvlA",1)
										elseif Lm <= 85 then
											Result = CalcStat("AwardILvlA",L)-10
										elseif 96 <= Lp and Lm <= 99 then
											Result = CalcStat("AwardILvlA",L)+4
										elseif 100 <= Lp and Lm <= 100 then
											Result = CalcStat("AwardILvlA",L)+6
										else
											Result = CalcStat("AwardILvlA",L)
										end
									end
								elseif SN > "AWARDILVLCF" then
									if SN < "AWARDILVLCJ" then
										if SN < "AWARDILVLCH" then
											if SN == "AWARDILVLCG" then
												if Lm <= 140 then
													Result = CalcStat("AwardILvlC",L)
												elseif Lm <= 150 then
													Result = RoundDbl(LinFmod(1,500.4,520.4,141,150,L))
												else
													Result = CalcStat("AwardILvlCG",150)
												end
											end
										elseif SN > "AWARDILVLCH" then
											if SN == "AWARDILVLCI" then
												if Lm <= 140 then
													Result = CalcStat("AwardILvlC",L)
												elseif Lm <= 150 then
													Result = RoundDbl(LinFmod(1,500.4,530.4,141,150,L))
												else
													Result = CalcStat("AwardILvlCI",150)
												end
											end
										else
											if Lm <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif Lm <= 150 then
												Result = RoundDbl(LinFmod(1,500.4,525.4,141,150,L))
											else
												Result = CalcStat("AwardILvlCH",150)
											end
										end
									elseif SN > "AWARDILVLCJ" then
										if SN < "AWARDILVLDA" then
											if SN == "AWARDILVLD" then
												if Lm <= 105 then
													Result = CalcStat("AwardILvlC",L)
												elseif Lm <= 115 then
													Result = 300
												else
													Result = CalcStat("AwardILvlA",L)
												end
											end
										elseif SN > "AWARDILVLDA" then
											if SN == "AWARDILVLDB" then
												if 106 <= Lp and Lm <= 115 then
													Result = RoundDbl(LinFmod(1,300,345,106,115,L))
												else
													Result = CalcStat("AwardILvlD",L)
												end
											end
										else
											if 106 <= Lp and Lm <= 115 then
												Result = RoundDbl(LinFmod(1,300,336.5,106,115,L))
											else
												Result = CalcStat("AwardILvlD",L)
											end
										end
									else
										if Lm <= 140 then
											Result = CalcStat("AwardILvlC",L)
										elseif Lm <= 150 then
											Result = RoundDbl(LinFmod(1,500.4,535.4,141,150,L))
										else
											Result = CalcStat("AwardILvlCJ",150)
										end
									end
								else
									if Lm <= 140 then
										Result = CalcStat("AwardILvlC",L)
									elseif Lm <= 150 then
										Result = RoundDbl(LinFmod(1,500.4,517.4,141,150,L))
									else
										Result = CalcStat("AwardILvlCF",150)
									end
								end
							else
								Result = CalcStat("AwardILvlB",L)
							end
						else
							Result = EquSng(StatLinInter("PntMPArmourT","TraitPntS","ProgBArmour","AdjTraitMit",L,N,0))
						end
					elseif SN > "AWARDILVLDC" then
						if SN < "AWARDLVLTOILVL" then
							if SN < "AWARDILVLGB" then
								if SN < "AWARDILVLEC" then
									if SN < "AWARDILVLDG" then
										if SN < "AWARDILVLDE" then
											if SN == "AWARDILVLDD" then
												if 106 <= Lp and Lm <= 114 then
													Result = RoundDbl(LinFmod(1,300,327,106,115,L))
												elseif 115 <= Lp and Lm <= 115 then
													Result = CalcStat("AwardILvlD",115)+30
												else
													Result = CalcStat("AwardILvlD",L)
												end
											end
										elseif SN > "AWARDILVLDE" then
											if SN == "AWARDILVLDF" then
												if 106 <= Lp and Lm <= 110 then
													Result = CalcStat("AwardILvlDF",111)
												elseif 111 <= Lp and Lm <= 115 then
													Result = RoundDbl(LinFmod(1,299.5,320.5,106,115,L))
												else
													Result = CalcStat("AwardILvlD",L)
												end
											end
										else
											if 106 <= Lp and Lm <= 115 then
												Result = RoundDbl(LinFmod(1,300.4,326.4,106,115,L))
											else
												Result = CalcStat("AwardILvlD",L)
											end
										end
									elseif SN > "AWARDILVLDG" then
										if SN < "AWARDILVLEA" then
											if SN == "AWARDILVLE" then
												if Lm <= 115 then
													Result = CalcStat("AwardILvlC",L)
												elseif Lm <= 120 then
													Result = 350
												else
													Result = CalcStat("AwardILvlA",L)
												end
											end
										elseif SN > "AWARDILVLEA" then
											if SN == "AWARDILVLEB" then
												if 116 <= Lp and Lm <= 119 then
													Result = RoundDbl(LinFmod(1,350,390,116,120,L))
												elseif 120 <= Lp and Lm <= 120 then
													Result = CalcStat("AwardILvlE",120)+38
												else
													Result = CalcStat("AwardILvlE",L)
												end
											end
										else
											if 116 <= Lp and Lm <= 119 then
												Result = RoundDbl(LinFmod(1,350,378,116,120,L))
											elseif 120 <= Lp and Lm <= 120 then
												Result = CalcStat("AwardILvlE",120)+26
											else
												Result = CalcStat("AwardILvlE",L)
											end
										end
									else
										if 106 <= Lp and Lm <= 114 then
											Result = RoundDbl(LinFmod(1,300,336,106,115,L))
										elseif 115 <= Lp and Lm <= 115 then
											Result = CalcStat("AwardILvlD",115)+40
										else
											Result = CalcStat("AwardILvlD",L)
										end
									end
								elseif SN > "AWARDILVLEC" then
									if SN < "AWARDILVLFA" then
										if SN < "AWARDILVLEE" then
											if SN == "AWARDILVLED" then
												if 116 <= Lp and Lm <= 120 then
													Result = RoundDbl(LinFmod(1,350,370,116,120,L))
												else
													Result = CalcStat("AwardILvlE",L)
												end
											end
										elseif SN > "AWARDILVLEE" then
											if SN == "AWARDILVLF" then
												if Lm <= 75 then
													Result = 0
												elseif Lm <= 84 then
													Result = LinFmod(1,78,118,76,84,L)
												elseif Lm <= 85 then
													Result = 0
												elseif Lm <= 93 then
													Result = RoundDbl(LinFmod(1,129.4,163,86,93,L))
												elseif Lm <= 95 then
													Result = 0
												elseif Lm <= 100 then
													Result = RoundDbl(LinFmod(1,175,198.4,95,100,L))
												elseif Lm <= 104 then
													Result = LinFmod(1,201,213,101,104,L)
												elseif Lm <= 105 then
													Result = 220
												elseif Lm <= 114 then
													Result = RoundDbl(LinFmod(1,300,323,106,114,L))
												elseif Lm <= 115 then
													Result = 324
												elseif Lm <= 119 then
													Result = RoundDbl(LinFmod(1,349.6,368.4,116,120,L))
												end
											end
										else
											if 116 <= Lp and Lm <= 119 then
												Result = RoundDbl(LinFmod(1,350,366,116,120,L))
											elseif 120 <= Lp and Lm <= 120 then
												Result = CalcStat("AwardILvlE",120)+14
											else
												Result = CalcStat("AwardILvlE",L)
											end
										end
									elseif SN > "AWARDILVLFA" then
										if SN < "AWARDILVLG" then
											if SN == "AWARDILVLFB" then
												if Lm <= 40 then
													Result = LinFmod(1,1,40,1,40,L)
												elseif Lm <= 45 then
													Result = LinFmod(1,40,44,41,45,L)
												elseif Lm <= 50 then
													Result = RoundDbl(LinFmod(1,45.4,47,46,50,L))
												elseif Lm <= 55 then
													Result = RoundDbl(LinFmod(1,51,54.4,51,55,L))
												elseif Lm <= 60 then
													Result = RoundDbl(LinFmod(1,54,57.4,56,60,L))
												elseif Lm <= 75 then
													Result = LinFmod(1,58,72,61,75,L)
												elseif Lm <= 84 then
													Result = CalcStat("AwardILvlF",L)
												elseif Lm <= 85 then
													Result = 122
												elseif Lm <= 93 then
													Result = CalcStat("AwardILvlF",L)
												elseif Lm <= 95 then
													Result = LinFmod(1,168,174,94,95,L)
												elseif Lm <= 119 then
													Result = CalcStat("AwardILvlF",L)
												elseif Lm <= 120 then
													Result = 380
												elseif Lm <= 125 then
													Result = LinFmod(1,400,416,121,125,L)
												elseif Lm <= 129 then
													Result = LinFmod(1,418,430,126,129,L)
												elseif Lm <= 130 then
													Result = 432
												elseif Lm <= 135 then
													Result = RoundDbl(LinFmod(1,450.4,463.8,131,135,L))
												elseif Lm <= 138 then
													Result = RoundDbl(LinFmod(1,465.8,472.8,136,138,L))
												elseif Lm <= 140 then
													Result = 475
												elseif Lm <= 150 then
													Result = RoundDbl(LinFmod(1,500.4,521.4,141,150,L))
												else
													Result = CalcStat("AwardILvlFB",150)
												end
											end
										elseif SN > "AWARDILVLG" then
											if SN == "AWARDILVLGA" then
												if 121 <= Lp and Lm <= 130 then
													Result = RoundDbl(LinFmod(1,400.4,412.4,121,130,L))
												else
													Result = CalcStat("AwardILvlG",L)
												end
											end
										else
											if Lm <= 120 then
												Result = CalcStat("AwardILvlC",L)
											elseif Lm <= 130 then
												Result = 400
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									else
										if Lm <= 9 then
											Result = RoundDbl(LinFmod(1,0.5,4.5,1,9,L))
										elseif Lm <= 19 then
											Result = LinFmod(1,6,15,10,19,L)
										elseif Lm <= 23 then
											Result = RoundDbl(LinFmod(1,15.5,17,20,23,L))
										elseif Lm <= 49 then
											Result = LinFmod(1,18,43,24,49,L)
										elseif Lm <= 65 then
											Result = LinFmod(1,43,58,50,65,L)
										elseif Lm <= 75 then
											Result = LinFmod(1,60,69,66,75,L)
										elseif Lm <= 84 then
											Result = CalcStat("AwardILvlF",L)
										elseif Lm <= 85 then
											Result = 120
										elseif Lm <= 93 then
											Result = CalcStat("AwardILvlF",L)
										elseif Lm <= 95 then
											Result = LinFmod(1,166,172,94,95,L)
										elseif Lm <= 119 then
											Result = CalcStat("AwardILvlF",L)
										elseif Lm <= 120 then
											Result = 368
										elseif Lm <= 129 then
											Result = RoundDbl(LinFmod(1,400,423,121,129,L))
										elseif Lm <= 130 then
											Result = 424
										elseif Lm <= 135 then
											Result = LinFmod(1,450,462,131,135,L)
										elseif Lm <= 139 then
											Result = LinFmod(1,463,472,136,139,L)
										elseif Lm <= 140 then
											Result = 473
										elseif Lm <= 150 then
											Result = RoundDbl(LinFmod(1,500.4,504.4,141,150,L))
										else
											Result = CalcStat("AwardILvlFA",150)
										end
									end
								else
									if 116 <= Lp and Lm <= 120 then
										Result = RoundDbl(LinFmod(1,350,382,116,120,L))
									else
										Result = CalcStat("AwardILvlE",L)
									end
								end
							elseif SN > "AWARDILVLGB" then
								if SN < "AWARDILVLJ" then
									if SN < "AWARDILVLGF" then
										if SN < "AWARDILVLGD" then
											if SN == "AWARDILVLGC" then
												if 121 <= Lp and Lm <= 130 then
													Result = RoundDbl(LinFmod(1,400.4,408.3,121,130,L))
												else
													Result = CalcStat("AwardILvlG",L)
												end
											end
										elseif SN > "AWARDILVLGD" then
											if SN == "AWARDILVLGE" then
												if 121 <= Lp and Lm <= 130 then
													Result = RoundDbl(LinFmod(1,400.4,434.4,121,130,L))
												else
													Result = CalcStat("AwardILvlG",L)
												end
											end
										else
											if 121 <= Lp and Lm <= 130 then
												Result = RoundDbl(LinFmod(1,400.4,426.4,121,130,L))
											else
												Result = CalcStat("AwardILvlG",L)
											end
										end
									elseif SN > "AWARDILVLGF" then
										if SN < "AWARDILVLI" then
											if SN == "AWARDILVLH" then
												if Lm <= 4 then
													Result = CalcStat("AwardILvlA",1)
												elseif Lm <= 50 then
													Result = CalcStat("AwardILvlA",L-4)
												elseif Lm <= 54 then
													Result = CalcStat("AwardILvlA",51)
												elseif Lm <= 75 then
													Result = CalcStat("AwardILvlA",L-4)
												else
													Result = L-4
												end
											end
										elseif SN > "AWARDILVLI" then
											if SN == "AWARDILVLIA" then
												if Lm <= 44 then
													Result = CalcStat("AwardILvlI",L)
												elseif Lm <= 55 then
													Result = RoundDblDown((L-45)/6)+51
												elseif Lm <= 90 then
													Result = CalcStat("AwardILvlI",L)
												elseif Lm <= 104 then
													Result = RoundDblDown((L-91)/5)*25+165
												elseif Lm <= 105 then
													Result = CalcStat("LvlToILvl",L)
												elseif Lm <= 110 then
													Result = CalcStat("LvlToILvl",106)+15
												elseif Lm <= 115 then
													Result = CalcStat("LvlToILvl",115)-20
												elseif Lm <= 120 then
													Result = CalcStat("LvlToILvl",116)+15
												elseif Lm <= 125 then
													Result = CalcStat("LvlToILvl",121)+15
												elseif Lm <= 130 then
													Result = CalcStat("LvlToILvl",130)-20
												elseif Lm <= 135 then
													Result = CalcStat("LvlToILvl",131)+15
												elseif Lm <= 140 then
													Result = CalcStat("LvlToILvl",140)-4
												elseif Lm <= 150 then
													Result = CalcStat("LvlToILvl",141)+15
												else
													Result = CalcStat("AwardILvlIA",150)
												end
											end
										else
											if Lm <= 44 then
												Result = 1
											elseif Lm <= 55 then
												Result = 52
											elseif Lm <= 75 then
												Result = RoundDblDown((L-56)/5)*5+60
											elseif Lm <= 85 then
												Result = RoundDblDown((L-76)/5)*29+100
											elseif Lm <= 95 then
												Result = RoundDblDown((L-86)/5)*20+155
											elseif Lm <= 100 then
												Result = RoundDblDown((L-96)/4)*10+190
											elseif Lm <= 105 then
												Result = RoundDblDown((L-101)/4)*35+215
											elseif Lm <= 110 then
												Result = CalcStat("LvlToILvl",106)+15
											elseif Lm <= 115 then
												Result = CalcStat("LvlToILvl",115)
											elseif Lm <= 119 then
												Result = CalcStat("LvlToILvl",116)+15
											elseif Lm <= 120 then
												Result = CalcStat("LvlToILvl",120)
											elseif Lm <= 125 then
												Result = CalcStat("LvlToILvl",121)+15
											elseif Lm <= 130 then
												Result = CalcStat("LvlToILvl",130)
											elseif Lm <= 135 then
												Result = CalcStat("LvlToILvl",131)+15
											elseif Lm <= 140 then
												Result = CalcStat("LvlToILvl",140)
											elseif Lm <= 145 then
												Result = CalcStat("LvlToILvl",141)+15
											elseif Lm <= 150 then
												Result = CalcStat("LvlToILvl",150)
											else
												Result = CalcStat("AwardILvlI",150)
											end
										end
									else
										if 121 <= Lp and Lm <= 130 then
											Result = RoundDbl(LinFmod(1,400.4,440.4,121,130,L))
										else
											Result = CalcStat("AwardILvlG",L)
										end
									end
								elseif SN > "AWARDILVLJ" then
									if SN < "AWARDILVLJD" then
										if SN < "AWARDILVLJB" then
											if SN == "AWARDILVLJA" then
												if 131 <= Lp and Lm <= 140 then
													Result = RoundDbl(LinFmod(1,450.4,465.4,131,140,L))
												else
													Result = CalcStat("AwardILvlJ",L)
												end
											end
										elseif SN > "AWARDILVLJB" then
											if SN == "AWARDILVLJC" then
												if 131 <= Lp and Lm <= 140 then
													Result = RoundDbl(LinFmod(1,450.4,475.4,131,140,L))
												else
													Result = CalcStat("AwardILvlJ",L)
												end
											end
										else
											if 131 <= Lp and Lm <= 140 then
												Result = RoundDbl(LinFmod(1,450.4,470.4,131,140,L))
											else
												Result = CalcStat("AwardILvlJ",L)
											end
										end
									elseif SN > "AWARDILVLJD" then
										if SN < "AWARDILVLL" then
											if SN == "AWARDILVLK" then
												Result = CalcStat("CombatBaseTacHPSLvlToILvl",L)
											end
										elseif SN > "AWARDILVLL" then
											if SN == "AWARDLVLCAP" then
												Result = 150
											end
										else
											if Lm <= 50 then
												Result = CalcStat("AwardILvlB",L)
											elseif Lm <= 54 then
												Result = CalcStat("AwardILvlA",L)-3
											elseif Lm <= 74 then
												Result = CalcStat("AwardILvlA",L)-4
											elseif Lm <= 75 then
												Result = CalcStat("AwardILvlA",L)-5
											elseif Lm <= 95 then
												Result = CalcStat("AwardILvlA",L)-1
											elseif Lm <= 115 then
												Result = CalcStat("AwardILvlA",L)-2
											elseif Lm <= 120 then
												Result = CalcStat("AwardILvlA",L)
											elseif Lm <= 130 then
												Result = RoundDbl(LinFmod(1,397,400,121,130,L))
											elseif Lm <= 134 then
												Result = CalcStat("AwardILvlA",L)
											elseif Lm <= 137 then
												Result = DataTableValue({449,450,450},L-134)
											elseif Lm <= 140 then
												Result = CalcStat("AwardILvlL",L-3)
											elseif Lm <= 145 then
												Result = RoundDbl(LinFmod(1,495.4,500.4,141,145,L))
											elseif Lm <= 150 then
												Result = RoundDbl(LinFmod(1,500.5,502,146,150,L))
											else
												Result = CalcStat("AwardILvlL",150)
											end
										end
									else
										if 131 <= Lp and Lm <= 140 then
											Result = RoundDbl(LinFmod(1,450.4,480.4,131,140,L))
										else
											Result = CalcStat("AwardILvlJ",L)
										end
									end
								else
									if Lm <= 130 then
										Result = CalcStat("AwardILvlC",L)
									elseif Lm <= 140 then
										Result = RoundDbl(LinFmod(1,450.4,460.4,131,140,L))
									else
										Result = CalcStat("AwardILvlA",L)
									end
								end
							else
								if 121 <= Lp and Lm <= 130 then
									Result = RoundDbl(LinFmod(1,400.4,418.4,121,130,L))
								else
									Result = CalcStat("AwardILvlG",L)
								end
							end
						elseif SN > "AWARDLVLTOILVL" then
							if SN < "BATTLELOREMAS" then
								if SN < "BASEFATE" then
									if SN < "BALANCEOFMANEVADE" then
										if SN < "AXEARMRENDPOS" then
											if SN == "AXEARMOURREND" then
												Result = -CalcStat("AxeArmRendPos",L)
											end
										elseif SN > "AXEARMRENDPOS" then
											if SN == "BALANCEOFMANBLOCK" then
												Result = CalcStat("BlockT",L,0.8)
											end
										else
											if Lm <= 7 then
												Result = RoundDbl(LinFmod(1,0.5,3.25,1,7,L))
											elseif Lm <= 14 then
												Result = RoundDbl(LinFmod(1,3.75,8.5,8,14,L))
											elseif Lm <= 30 then
												Result = RoundDbl(LinFmod(1,9,24.7,15,30,L))
											elseif Lm <= 39 then
												Result = RoundDbl(LinFmod(1,26.5,37,31,39,L))
											elseif Lm <= 50 then
												Result = RoundDbl(LinFmod(1,38.5,53,40,50,L))
											elseif Lm <= 52 then
												Result = 53
											elseif Lm <= 60 then
												Result = RoundDbl(LinFmod(1,53.2,64.8,53,60,L))
											elseif Lm <= 77 then
												Result = RoundDbl(LinFmod(1,66.15,94.8,61,77,L))
											elseif Lm <= 113 then
												Result = RoundDbl(RoundDbl(L/3-0.5)*1.95+44.1)
											elseif Lm <= 141 then
												Result = 116
											elseif Lm <= 181 then
												Result = RoundDbl(RoundDbl(L/4)*2+46)
											elseif Lm <= 217 then
												Result = RoundDbl(RoundDbl(L/4)*2+45)
											elseif Lm <= 221 then
												Result = 153
											elseif Lm <= 299 then
												Result = 155
											elseif Lm <= 308 then
												Result = RoundDbl(RoundDbl(L/2.6-0.4)*2-73)
											elseif Lm <= 317 then
												Result = RoundDbl(RoundDbl(L/2.74-0.75)*2-60)
											elseif Lm <= 325 then
												Result = 172
											elseif Lm <= 326 then
												Result = 174
											elseif 327 <= Lp and Lm <= 599 then
												Result = EquSng(ExpFmod(CalcStat("AxeArmRendPos",326),327,1,L,1))
											else
												Result = CalcStat("AxeArmRendPos",599)
											end
										end
									elseif SN > "BALANCEOFMANEVADE" then
										if SN < "BASEAGILITY" then
											if SN == "BALANCEOFMANPARRY" then
												Result = CalcStat("ParryT",L,0.8)
											end
										elseif SN > "BASEAGILITY" then
											if SN == "BASEARMOUR" then
												if Lm <= 50 then
													Result = RoundDblUp(LinFmod(1,1,10,1,50,L)*N)
												elseif Lm <= 60 then
													Result = RoundDblUp(LinFmod(1,10,15,50,60,L)*N)
												elseif Lm <= 65 then
													Result = RoundDblUp(LinFmod(1,15,20,60,65,L)*N)
												elseif Lm <= 75 then
													Result = RoundDblUp(LinFmod(1,20,30,65,75,L)*N)
												elseif Lm <= 85 then
													Result = RoundDblUp(LinFmod(1,30,45,75,85,L)*N)
												elseif Lm <= 95 then
													Result = RoundDblUp(LinFmod(1,45,65,85,95,L)*N)
												elseif Lm <= 100 then
													Result = RoundDblUp(LinFmod(1,65,100,95,100,L)*N)
												elseif Lm <= 105 then
													Result = RoundDblUp(LinFmod(1,100,130,100,105,L)*N)
												elseif Lm <= 115 then
													Result = RoundDblUp(LinFmod(1,143,200,106,115,L,0)*N)
												elseif Lm <= 120 then
													Result = RoundDblUp(LinFmod(1,230,250,116,120,L,0)*N)
												elseif Lm <= 130 then
													Result = RoundDblUp(LinFmod(1,288,380,121,130,L,0)*N)
												elseif Lm <= 140 then
													Result = RoundDblUp(LinFmod(1,440,750,131,140,L,0)*N)
												else
													Result = CalcStat("BaseArmour",140,N)
												end
											end
										else
											Result = CalcStat("BaseMain",L,N)
										end
									else
										Result = CalcStat("EvadeT",L,1.0)
									end
								elseif SN > "BASEFATE" then
									if SN < "BASEMORALE" then
										if SN < "BASEMAINPROG" then
											if SN == "BASEMAIN" then
												if Lm <= 50 then
													Result = RoundDbl(CalcStat("BaseMainProg",L)*1*N)
												elseif Lm <= 95 then
													Result = RoundDbl(CalcStat("BaseMainProg",L)*1*N)
												else
													Result = RoundDbl(CalcStat("BaseMainProg",L)*1*N)
												end
											end
										elseif SN > "BASEMAINPROG" then
											if SN == "BASEMIGHT" then
												Result = CalcStat("BaseMain",L,N)
											end
										else
											if Lm <= 95 then
												Result = CalcStat("StdProg",L,1.0)
											elseif Lm <= 140 then
												Result = RoundDbl(CalcStat("StdProg",L,1.0))
											else
												Result = RoundDbl(LinFmod(1,780,1360,141,150,L))
											end
										end
									elseif SN > "BASEMORALE" then
										if SN < "BASEVITALITY" then
											if SN == "BASEPOWER" then
												if Lm <= 50 then
													Result = RoundDblDown(CalcStat("ProgBEnergy",L)*5)
												elseif Lm <= 95 then
													Result = RoundDblDown(CalcStat("ProgBEnergy",L)*5)
												else
													Result = RoundDbl(CalcStat("ProgBEnergy",L)*5)
												end
											end
										elseif SN > "BASEVITALITY" then
											if SN == "BASEWILL" then
												Result = CalcStat("BaseMain",L,N)
											end
										else
											if Lm <= 50 then
												Result = RoundDbl(CalcStat("ProgBHealth",L)*0.75)
											elseif Lm <= 95 then
												Result = RoundDbl(CalcStat("ProgBHealth",L)*0.75)
											else
												Result = RoundDbl(CalcStat("BaseMorale",L)*0.15)
											end
										end
									else
										if Lm <= 50 then
											Result = RoundDblDown(CalcStat("ProgBHealth",L)*5)
										elseif Lm <= 95 then
											Result = RoundDbl(CalcStat("ProgBHealth",L)*5)
										else
											Result = RoundDbl(CalcStat("ProgBHealth",L)*5,-1)
										end
									end
								else
									if Lm <= 50 then
										Result = RoundDbl(CalcStat("ProgBEnergy",L)*3.5)
									elseif Lm <= 95 then
										Result = RoundDbl(CalcStat("ProgBEnergy",L)*3.5)
									else
										Result = RoundDbl(CalcStat("BasePower",L)*0.7)
									end
								end
							elseif SN > "BATTLELOREMAS" then
								if SN < "BEOMIGHTOFTHEWILDMIGHT" then
									if SN < "BEOEMISSARYFATE" then
										if SN < "BATTLELORETACMAS" then
											if SN == "BATTLELOREPHYMAS" then
												Result = CalcStat("BattleLoreMas",L)
											end
										elseif SN > "BATTLELORETACMAS" then
											if SN == "BEOBEARFORMCRITDEF" then
												Result = CalcStat("CritDefT",L,0.4)
											end
										else
											Result = CalcStat("BattleLoreMas",L)
										end
									elseif SN > "BEOEMISSARYFATE" then
										if SN < "BEOFERALPRESFATE" then
											if SN == "BEOFATE" then
												Result = CalcStat("FateT",L,CalcStat("Trait567810Choice",N)*0.4)
											end
										elseif SN > "BEOFERALPRESFATE" then
											if SN == "BEOFEWINNUMBERFATE" then
												Result = -CalcStat("FateT",L,0.4)
											end
										else
											Result = CalcStat("FateT",L,1.0)
										end
									else
										Result = CalcStat("FateT",L,1.0)
									end
								elseif SN > "BEOMIGHTOFTHEWILDMIGHT" then
									if SN < "BEORNINGCDAGILITYTOOUTHEAL" then
										if SN < "BEORNINGCDAGILITYTOEVADE" then
											if SN == "BEORNINGCDAGILITYTOCRITHIT" then
												Result = 2
											end
										elseif SN > "BEORNINGCDAGILITYTOEVADE" then
											if SN == "BEORNINGCDAGILITYTOFINESSE" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "BEORNINGCDAGILITYTOOUTHEAL" then
										if SN < "BEORNINGCDARMOURTOCOMPHYMIT" then
											if SN == "BEORNINGCDAGILITYTOPHYMAS" then
												Result = 2
											end
										elseif SN > "BEORNINGCDARMOURTOCOMPHYMIT" then
											if SN == "BEORNINGCDARMOURTONONPHYMIT" then
												Result = 0.2
											end
										else
											Result = 1
										end
									else
										Result = 2
									end
								else
									Result = CalcStat("MightT",L,1.0)
								end
							else
								if Lm <= 105 then
									Result = CalcStat("Mastery",L,2.5)
								elseif 120 <= Lp and Lm <= 120 or 130 <= Lp and Lm <= 130 then
									Result = CalcStat("MasteryT",L,1.6)
								else
									Result = CalcStat("MasteryT",L,1.2)
								end
							end
						else
							Result = CalcStat("AwardILvlC",L)
						end
					else
						if 106 <= Lp and Lm <= 110 then
							Result = RoundDbl(LinFmod(1,300,320,106,115,L))
						elseif 111 <= Lp and Lm <= 115 then
							Result = CalcStat("AwardILvlDC",110)
						else
							Result = CalcStat("AwardILvlD",L)
						end
					end
				elseif SN > "BEORNINGCDARMOURTOTACMIT" then
					if SN < "BLOCKPRATPCAPR" then
						if SN < "BEORNINGCDVITALITYTONCMR" then
							if SN < "BEORNINGCDCANBLOCK" then
								if SN < "BEORNINGCDBASENCMR" then
									if SN < "BEORNINGCDBASEICMR" then
										if SN < "BEORNINGCDBASEAGILITY" then
											if SN == "BEORNINGCDARMOURTYPE" then
												Result = 3
											end
										elseif SN > "BEORNINGCDBASEAGILITY" then
											if SN == "BEORNINGCDBASEFATE" then
												Result = CalcStat("ClassBaseFate",L)
											end
										else
											Result = CalcStat("ClassBaseAgilityM",L)
										end
									elseif SN > "BEORNINGCDBASEICMR" then
										if SN < "BEORNINGCDBASEMIGHT" then
											if SN == "BEORNINGCDBASEICPR" then
												Result = CalcStat("ClassBaseICPR",L)
											end
										elseif SN > "BEORNINGCDBASEMIGHT" then
											if SN == "BEORNINGCDBASEMORALE" then
												Result = CalcStat("ClassBaseMorale",L)
											end
										else
											Result = CalcStat("ClassBaseMightM",L)
										end
									else
										Result = CalcStat("ClassBaseICMRM",L)
									end
								elseif SN > "BEORNINGCDBASENCMR" then
									if SN < "BEORNINGCDBASEWILL" then
										if SN < "BEORNINGCDBASEPOWER" then
											if SN == "BEORNINGCDBASENCPR" then
												Result = CalcStat("ClassBaseNCPR",L)
											end
										elseif SN > "BEORNINGCDBASEPOWER" then
											if SN == "BEORNINGCDBASEVITALITY" then
												Result = CalcStat("ClassBaseVitality",L)
											end
										else
											Result = 10
										end
									elseif SN > "BEORNINGCDBASEWILL" then
										if SN < "BEORNINGCDCALCTYPENONPHYMIT" then
											if SN == "BEORNINGCDCALCTYPECOMPHYMIT" then
												Result = 14
											end
										elseif SN > "BEORNINGCDCALCTYPENONPHYMIT" then
											if SN == "BEORNINGCDCALCTYPETACMIT" then
												Result = 27
											end
										else
											Result = 14
										end
									else
										Result = CalcStat("ClassBaseWillM",L)
									end
								else
									Result = CalcStat("ClassBaseNCMRM",L)
								end
							elseif SN > "BEORNINGCDCANBLOCK" then
								if SN < "BEORNINGCDMIGHTTOPHYMAS" then
									if SN < "BEORNINGCDMIGHTTOCRITHIT" then
										if SN < "BEORNINGCDFATETOMORALE" then
											if SN == "BEORNINGCDFATETOICMR" then
												Result = 0.04
											end
										elseif SN > "BEORNINGCDFATETOMORALE" then
											if SN == "BEORNINGCDFATETONCMR" then
												Result = 0.12
											end
										else
											Result = 2.5
										end
									elseif SN > "BEORNINGCDMIGHTTOCRITHIT" then
										if SN < "BEORNINGCDMIGHTTOOUTHEAL" then
											if SN == "BEORNINGCDMIGHTTOEVADE" then
												Result = 2
											end
										elseif SN > "BEORNINGCDMIGHTTOOUTHEAL" then
											if SN == "BEORNINGCDMIGHTTOPARRY" then
												Result = 1
											end
										else
											Result = 3
										end
									else
										Result = 1
									end
								elseif SN > "BEORNINGCDMIGHTTOPHYMAS" then
									if SN < "BEORNINGCDPHYMITTONONPHYMIT" then
										if SN < "BEORNINGCDMIGHTTOTACMIT" then
											if SN == "BEORNINGCDMIGHTTOPHYMIT" then
												Result = 1
											end
										elseif SN > "BEORNINGCDMIGHTTOTACMIT" then
											if SN == "BEORNINGCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "BEORNINGCDPHYMITTONONPHYMIT" then
										if SN < "BEORNINGCDVITALITYTOICMR" then
											if SN == "BEORNINGCDTACMASTOOUTHEAL" then
												Result = 1
											end
										elseif SN > "BEORNINGCDVITALITYTOICMR" then
											if SN == "BEORNINGCDVITALITYTOMORALE" then
												Result = 4.5
											end
										else
											Result = 0.012
										end
									else
										Result = 1
									end
								else
									Result = 3
								end
							else
								if 6 <= Lp then
									Result = 1
								end
							end
						elseif SN > "BEORNINGCDVITALITYTONCMR" then
							if SN < "BLACKARROWCDCALCTYPECOMPHYMIT" then
								if SN < "BEORNINGRDPSVONENAME" then
									if SN < "BEORNINGCDWILLTOPHYMIT" then
										if SN < "BEORNINGCDWILLTOOUTHEAL" then
											if SN == "BEORNINGCDWILLTOFINESSE" then
												Result = 1
											end
										elseif SN > "BEORNINGCDWILLTOOUTHEAL" then
											if SN == "BEORNINGCDWILLTOPHYMAS" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "BEORNINGCDWILLTOPHYMIT" then
										if SN < "BEORNINGCDWILLTOTACMIT" then
											if SN == "BEORNINGCDWILLTORESIST" then
												Result = 1
											end
										elseif SN > "BEORNINGCDWILLTOTACMIT" then
											if SN == "BEORNINGRDPSVONEFATE" then
												Result = CalcStat("BeoEmissaryFate",L)
											end
										else
											Result = 1.5
										end
									else
										Result = 1.5
									end
								elseif SN > "BEORNINGRDPSVONENAME" then
									if SN < "BEORNINGRDTRAITVITALITY" then
										if SN < "BEORNINGRDTRAITFATE" then
											if SN == "BEORNINGRDPSVTWONAME" then
												Result = ""
											end
										elseif SN > "BEORNINGRDTRAITFATE" then
											if SN == "BEORNINGRDTRAITMIGHT" then
												Result = CalcStat("BeoMightoftheWildMight",L)
											end
										else
											Result = CalcStat("BeoFewinNumberFate",L)
										end
									elseif SN > "BEORNINGRDTRAITVITALITY" then
										if SN < "BEOVITALITYINCREASE" then
											if SN == "BEOTHICKHIDEVITALITY" then
												Result = CalcStat("VitalityT",L,1.0)
											end
										elseif SN > "BEOVITALITYINCREASE" then
											if SN == "BLACKARROWCANBLOCK" then
												Result = 1
											end
										else
											Result = CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4)
										end
									else
										Result = CalcStat("BeoThickHideVitality",L)
									end
								else
									Result = "Emissary"
								end
							elseif SN > "BLACKARROWCDCALCTYPECOMPHYMIT" then
								if SN < "BLOCKCRAW" then
									if SN < "BLOCK" then
										if SN < "BLACKARROWCDCALCTYPETACMIT" then
											if SN == "BLACKARROWCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										elseif SN > "BLACKARROWCDCALCTYPETACMIT" then
											if SN == "BLACKARROWCDHASPOWER" then
												Result = 1
											end
										else
											Result = 27
										end
									elseif SN > "BLOCK" then
										if SN < "BLOCKCI" then
											if SN == "BLOCKC" then
												Result = CalcStat("BPEC",L,N)
											end
										elseif SN > "BLOCKCI" then
											if SN == "BLOCKCIRAW" then
												Result = CalcStat("BPECIRAW",L,N)
											end
										else
											Result = CalcStat("BPECI",L,N)
										end
									else
										Result = CalcStat("BPE",L,N)
									end
								elseif SN > "BLOCKCRAW" then
									if SN < "BLOCKPRATPA" then
										if SN < "BLOCKPPRAT" then
											if SN == "BLOCKPBONUS" then
												Result = CalcStat("BPEPBonus",L)
											end
										elseif SN > "BLOCKPPRAT" then
											if SN == "BLOCKPRATP" then
												Result = CalcStat("BPEPRatP",L,N)
											end
										else
											Result = CalcStat("BPEPPRat",L,N)
										end
									elseif SN > "BLOCKPRATPA" then
										if SN < "BLOCKPRATPC" then
											if SN == "BLOCKPRATPB" then
												Result = CalcStat("BPEPRatPB",L)
											end
										elseif SN > "BLOCKPRATPC" then
											if SN == "BLOCKPRATPCAP" then
												Result = CalcStat("BPEPRatPCap",L)
											end
										else
											Result = CalcStat("BPEPRatPC",L)
										end
									else
										Result = CalcStat("BPEPRatPA",L)
									end
								else
									Result = CalcStat("BPECRAW",L,N)
								end
							else
								Result = 13
							end
						else
							Result = 0.12
						end
					elseif SN > "BLOCKPRATPCAPR" then
						if SN < "BRAWLERCDAGILITYTOPHYMAS" then
							if SN < "BRATCRITMAGN" then
								if SN < "BPEPPRAT" then
									if SN < "BPECI" then
										if SN < "BPE" then
											if SN == "BLOCKT" then
												Result = CalcStat("BPET",L,N)
											end
										elseif SN > "BPE" then
											if SN == "BPEC" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("BPECI",CalcStat("BPECILvlFilter",N),N),0)
											end
										else
											Result = EquSng(StatLinInter("PntMPBPE","ItemPntS","ProgBBPE","AdjItem",L,N,0))
										end
									elseif SN > "BPECI" then
										if SN < "BPECIRAW" then
											if SN == "BPECILVLFILTER" then
												if 3.8 <= Lp and Lm <= 3.8 or 4 <= Lp and Lm <= 4 or 4.6 <= Lp and Lm <= 4.6 or 6.2 <= Lp and Lm <= 6.2 or 8 <= Lp and Lm <= 8 or 12 <= Lp and Lm <= 12 then
													Result = 515
												else
													Result = CalcStat("CreepILvlCurr",L)
												end
											end
										elseif SN > "BPECIRAW" then
											if SN == "BPECRAW" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("BPECIRaw",CalcStat("BPECILvlFilter",N),N),99)
											end
										else
											Result = StatLinInter("PntMPBPEC","ItemPntS","ProgBBPE","AdjCreepItem",L,N,4)
										end
									else
										Result = RoundDblLotro(CalcStat("BPECIRaw",L,N))
									end
								elseif SN > "BPEPPRAT" then
									if SN < "BPEPRATPC" then
										if SN < "BPEPRATPA" then
											if SN == "BPEPRATP" then
												Result = CalcPercAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCap",L),N)
											end
										elseif SN > "BPEPRATPA" then
											if SN == "BPEPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatStandard")
											end
										else
											Result = 39
										end
									elseif SN > "BPEPRATPC" then
										if SN < "BPEPRATPCAPR" then
											if SN == "BPEPRATPCAP" then
												Result = 13
											end
										elseif SN > "BPEPRATPCAPR" then
											if SN == "BPET" then
												Result = EquSng(StatLinInter("PntMPBPE","TraitPntS","ProgBBPE","AdjTrait",L,N,0))
											end
										else
											Result = CalcStat("BPEPRatPB",L)*CalcStat("BPEPRatPC",L)
										end
									else
										Result = 0.5
									end
								else
									Result = CalcRatAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCapR",L),N)
								end
							elseif SN > "BRATCRITMAGN" then
								if SN < "BRATPARTBPE" then
									if SN < "BRATMITIGATIONS" then
										if SN < "BRATEXTRA" then
											if SN == "BRATDEVHIT" then
												Result = CalcStat("StdProg",L,400)
											end
										elseif SN > "BRATEXTRA" then
											if SN == "BRATMITHEAVY" then
												Result = CalcStat("BRatStandard",L)
											end
										else
											Result = CalcStat("StdProg",L,300)
										end
									elseif SN > "BRATMITIGATIONS" then
										if SN < "BRATMITMEDIUM" then
											if SN == "BRATMITLIGHT" then
												Result = CalcStat("BRatMitigations",L,0.666)
											end
										elseif SN > "BRATMITMEDIUM" then
											if SN == "BRATOUTHEAL" then
												Result = CalcStat("StdProg",L,450)
											end
										else
											Result = CalcStat("BRatMitigations",L,0.833)
										end
									else
										if Lm <= 50 then
											Result = LinFmod(1,(N*CalcStat("BRatStandard",1))*7/6-50.4,N*CalcStat("BRatStandard",50),1,50,L,"P")
										else
											Result = StatLinInter("","StdPntS","BRatStandard","",L,N,3)
										end
									end
								elseif SN > "BRATPARTBPE" then
									if SN < "BRAWLERCDAGILITYTOCRITHIT" then
										if SN < "BRATROUNDED" then
											if SN == "BRATPROGB" then
												if Lm <= 50 then
													Result = RoundDbl(CalcStat(C,L))
												else
													Result = CalcStat(C,L)
												end
											end
										elseif SN > "BRATROUNDED" then
											if SN == "BRATSTANDARD" then
												Result = CalcStat("StdProg",L,200)
											end
										else
											if Lm <= 50 then
												Result = RoundDbl(CalcStat(C,L))
											elseif Lm <= 105 then
												Result = RoundDbl(CalcStat(C,L),-1)
											elseif Lm <= 115 then
												Result = RoundDbl(CalcStat(C,L),-2)
											elseif Lm <= 130 then
												Result = RoundDbl(CalcStat(C,L),-1)
											elseif Lm <= 150 then
												Result = RoundDbl(CalcStat(C,L),-2)
											else
												Result = RoundDbl(CalcStat(C,L))
											end
										end
									elseif SN > "BRAWLERCDAGILITYTOCRITHIT" then
										if SN < "BRAWLERCDAGILITYTOFINESSE" then
											if SN == "BRAWLERCDAGILITYTOEVADE" then
												Result = 2
											end
										elseif SN > "BRAWLERCDAGILITYTOFINESSE" then
											if SN == "BRAWLERCDAGILITYTOOUTHEAL" then
												Result = 2
											end
										else
											Result = 1
										end
									else
										Result = 2
									end
								else
									Result = CalcStat("StdProg",L,350)
								end
							else
								Result = CalcStat("StdProg",L,600)
							end
						elseif SN > "BRAWLERCDAGILITYTOPHYMAS" then
							if SN < "BRAWLERCDCALCTYPECOMPHYMIT" then
								if SN < "BRAWLERCDBASEICPR" then
									if SN < "BRAWLERCDARMOURTYPE" then
										if SN < "BRAWLERCDARMOURTONONPHYMIT" then
											if SN == "BRAWLERCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "BRAWLERCDARMOURTONONPHYMIT" then
											if SN == "BRAWLERCDARMOURTOTACMIT" then
												Result = 0.2
											end
										else
											Result = 0.2
										end
									elseif SN > "BRAWLERCDARMOURTYPE" then
										if SN < "BRAWLERCDBASEFATE" then
											if SN == "BRAWLERCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityM",L)
											end
										elseif SN > "BRAWLERCDBASEFATE" then
											if SN == "BRAWLERCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRL",L)
											end
										else
											Result = CalcStat("ClassBaseFate",L)
										end
									else
										Result = 3
									end
								elseif SN > "BRAWLERCDBASEICPR" then
									if SN < "BRAWLERCDBASENCPR" then
										if SN < "BRAWLERCDBASEMORALE" then
											if SN == "BRAWLERCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightH",L)
											end
										elseif SN > "BRAWLERCDBASEMORALE" then
											if SN == "BRAWLERCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRL",L)
											end
										else
											Result = CalcStat("ClassBaseMorale",L)
										end
									elseif SN > "BRAWLERCDBASENCPR" then
										if SN < "BRAWLERCDBASEVITALITY" then
											if SN == "BRAWLERCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										elseif SN > "BRAWLERCDBASEVITALITY" then
											if SN == "BRAWLERCDBASEWILL" then
												Result = CalcStat("ClassBaseWillL",L)
											end
										else
											Result = CalcStat("ClassBaseVitality",L)
										end
									else
										Result = CalcStat("ClassBaseNCPR",L)
									end
								else
									Result = CalcStat("ClassBaseICPR",L)
								end
							elseif SN > "BRAWLERCDCALCTYPECOMPHYMIT" then
								if SN < "BRAWLERCDMIGHTTOOUTHEAL" then
									if SN < "BRAWLERCDFATETOPOWER" then
										if SN < "BRAWLERCDCALCTYPETACMIT" then
											if SN == "BRAWLERCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										elseif SN > "BRAWLERCDCALCTYPETACMIT" then
											if SN == "BRAWLERCDFATETONCPR" then
												Result = 0.07
											end
										else
											Result = 27
										end
									elseif SN > "BRAWLERCDFATETOPOWER" then
										if SN < "BRAWLERCDMIGHTTOCRITHIT" then
											if SN == "BRAWLERCDHASPOWER" then
												Result = 1
											end
										elseif SN > "BRAWLERCDMIGHTTOCRITHIT" then
											if SN == "BRAWLERCDMIGHTTOEVADE" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "BRAWLERCDMIGHTTOOUTHEAL" then
									if SN < "BRAWLERCDMIGHTTOTACMIT" then
										if SN < "BRAWLERCDMIGHTTOPHYMAS" then
											if SN == "BRAWLERCDMIGHTTOPARRY" then
												Result = 1
											end
										elseif SN > "BRAWLERCDMIGHTTOPHYMAS" then
											if SN == "BRAWLERCDMIGHTTOPHYMIT" then
												Result = 1
											end
										else
											Result = 3
										end
									elseif SN > "BRAWLERCDMIGHTTOTACMIT" then
										if SN < "BRAWLERCDPHYMITTONONPHYMIT" then
											if SN == "BRAWLERCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "BRAWLERCDPHYMITTONONPHYMIT" then
											if SN == "BRAWLERCDTACMASTOOUTHEAL" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								else
									Result = 3
								end
							else
								Result = 14
							end
						else
							Result = 2
						end
					else
						Result = CalcStat("BPEPRatPCapR",L)
					end
				else
					Result = 0.2
				end
			elseif SN > "BRAWLERCDVITALITYTOICMR" then
				if SN < "CHAMPIONCDARMOURTYPE" then
					if SN < "BURGLARCDVITALITYTOICMR" then
						if SN < "BURGLARCDAGILITYTOPHYMAS" then
							if SN < "BRWAGGPOSTUREPHYMIT" then
								if SN < "BRAWLERCDWILLTOTACMIT" then
									if SN < "BRAWLERCDWILLTOOUTHEAL" then
										if SN < "BRAWLERCDVITALITYTONCMR" then
											if SN == "BRAWLERCDVITALITYTOMORALE" then
												Result = 4.5
											end
										elseif SN > "BRAWLERCDVITALITYTONCMR" then
											if SN == "BRAWLERCDWILLTOFINESSE" then
												Result = 1
											end
										else
											Result = 0.12
										end
									elseif SN > "BRAWLERCDWILLTOOUTHEAL" then
										if SN < "BRAWLERCDWILLTOPHYMIT" then
											if SN == "BRAWLERCDWILLTOPHYMAS" then
												Result = 1
											end
										elseif SN > "BRAWLERCDWILLTOPHYMIT" then
											if SN == "BRAWLERCDWILLTORESIST" then
												Result = 1
											end
										else
											Result = 1.5
										end
									else
										Result = 1
									end
								elseif SN > "BRAWLERCDWILLTOTACMIT" then
									if SN < "BRGREVWEAKNFINESSE" then
										if SN < "BRGALLINONEXPFINESSE" then
											if SN == "BRGALLINFINESSE" then
												Result = CalcStat("Finesse",L,2)
											end
										elseif SN > "BRGALLINONEXPFINESSE" then
											if SN == "BRGREVWEAKNCRITDEF" then
												Result = -CalcStat("CritDefT",L,0.4)
											end
										else
											Result = -CalcStat("Finesse",L,2)
										end
									elseif SN > "BRGREVWEAKNFINESSE" then
										if SN < "BRGTRICKCNTDEFBPE" then
											if SN == "BRGREVWEAKNRESIST" then
												Result = -CalcStat("ResistT",L,0.4)
											end
										elseif SN > "BRGTRICKCNTDEFBPE" then
											if SN == "BRGTRICKCNTDEFCRITDEF" then
												Result = -CalcStat("CritDefT",L,0.8)
											end
										else
											Result = -CalcStat("BPET",L,1.2)
										end
									else
										Result = -CalcStat("FinesseT",L,0.4)
									end
								else
									Result = 1.5
								end
							elseif SN > "BRWAGGPOSTUREPHYMIT" then
								if SN < "BRWSHAREISBALANCEFINESSE" then
									if SN < "BRWMAELSTROMMIGHT" then
										if SN < "BRWINNSTRCLEVTECHFINESSE" then
											if SN == "BRWDEFPOSTUREPHYMAS" then
												Result = -CalcStat("PhyMasT",L,4)
											end
										elseif SN > "BRWINNSTRCLEVTECHFINESSE" then
											if SN == "BRWINNSTRPRECISIONCRITHIT" then
												Result = CalcStat("CritHitT",L,CalcStat("Trait13510Choice",N)*0.2)
											end
										else
											Result = CalcStat("FinesseT",L,CalcStat("Trait13510Choice",N)*0.2)
										end
									elseif SN > "BRWMAELSTROMMIGHT" then
										if SN < "BRWRETINTENSITYCRITHIT" then
											if SN == "BRWMIGHTINCREASE" then
												Result = CalcStat("MightT",L,CalcStat("Trait567810Choice",N)*0.4)
											end
										elseif SN > "BRWRETINTENSITYCRITHIT" then
											if SN == "BRWRETPRECISIONFINESSE" then
												Result = CalcStat("FinesseT",L,CalcStat("Trait234Choice",N))
											end
										else
											Result = CalcStat("CritHitT",L,CalcStat("Trait234Choice",N))
										end
									else
										Result = CalcStat("MightT",L,2)
									end
								elseif SN > "BRWSHAREISBALANCEFINESSE" then
									if SN < "BURGLARCDAGILITYTOCRITHIT" then
										if SN < "BRWTACMIT" then
											if SN == "BRWSHAREISHEAVYCRITHIT" then
												Result = CalcStat("BrwInnStrPrecisionCritHit",L,3)
											end
										elseif SN > "BRWTACMIT" then
											if SN == "BRWVITALITYINCREASE" then
												Result = CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4)
											end
										else
											Result = CalcStat("TacMitT",L,CalcStat("Trait12345Choice",N)*0.4)
										end
									elseif SN > "BURGLARCDAGILITYTOCRITHIT" then
										if SN < "BURGLARCDAGILITYTOOUTHEAL" then
											if SN == "BURGLARCDAGILITYTOEVADE" then
												Result = 2
											end
										elseif SN > "BURGLARCDAGILITYTOOUTHEAL" then
											if SN == "BURGLARCDAGILITYTOPARRY" then
												Result = 1
											end
										else
											Result = 3
										end
									else
										Result = 1
									end
								else
									Result = CalcStat("BrwInnStrClevTechFinesse",L,3)
								end
							else
								Result = -CalcStat("PhyMitT",L,3)
							end
						elseif SN > "BURGLARCDAGILITYTOPHYMAS" then
							if SN < "BURGLARCDBASEVITALITY" then
								if SN < "BURGLARCDBASEFATE" then
									if SN < "BURGLARCDARMOURTONONPHYMIT" then
										if SN < "BURGLARCDAGILITYTOTACMIT" then
											if SN == "BURGLARCDAGILITYTOPHYMIT" then
												Result = 1
											end
										elseif SN > "BURGLARCDAGILITYTOTACMIT" then
											if SN == "BURGLARCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "BURGLARCDARMOURTONONPHYMIT" then
										if SN < "BURGLARCDARMOURTYPE" then
											if SN == "BURGLARCDARMOURTOTACMIT" then
												Result = 0.2
											end
										elseif SN > "BURGLARCDARMOURTYPE" then
											if SN == "BURGLARCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityH",L)
											end
										else
											Result = 2
										end
									else
										Result = 0.2
									end
								elseif SN > "BURGLARCDBASEFATE" then
									if SN < "BURGLARCDBASEMORALE" then
										if SN < "BURGLARCDBASEICPR" then
											if SN == "BURGLARCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRL",L)
											end
										elseif SN > "BURGLARCDBASEICPR" then
											if SN == "BURGLARCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightM",L)
											end
										else
											Result = CalcStat("ClassBaseICPR",L)
										end
									elseif SN > "BURGLARCDBASEMORALE" then
										if SN < "BURGLARCDBASENCPR" then
											if SN == "BURGLARCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRL",L)
											end
										elseif SN > "BURGLARCDBASENCPR" then
											if SN == "BURGLARCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										else
											Result = CalcStat("ClassBaseNCPR",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								else
									Result = CalcStat("ClassBaseFate",L)
								end
							elseif SN > "BURGLARCDBASEVITALITY" then
								if SN < "BURGLARCDMIGHTTOCRITHIT" then
									if SN < "BURGLARCDCALCTYPETACMIT" then
										if SN < "BURGLARCDCALCTYPECOMPHYMIT" then
											if SN == "BURGLARCDBASEWILL" then
												Result = CalcStat("ClassBaseWillL",L)
											end
										elseif SN > "BURGLARCDCALCTYPECOMPHYMIT" then
											if SN == "BURGLARCDCALCTYPENONPHYMIT" then
												Result = 13
											end
										else
											Result = 13
										end
									elseif SN > "BURGLARCDCALCTYPETACMIT" then
										if SN < "BURGLARCDFATETOPOWER" then
											if SN == "BURGLARCDFATETONCPR" then
												Result = 0.07
											end
										elseif SN > "BURGLARCDFATETOPOWER" then
											if SN == "BURGLARCDHASPOWER" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 26
									end
								elseif SN > "BURGLARCDMIGHTTOCRITHIT" then
									if SN < "BURGLARCDMIGHTTOPHYMAS" then
										if SN < "BURGLARCDMIGHTTOFINESSE" then
											if SN == "BURGLARCDMIGHTTOEVADE" then
												Result = 1
											end
										elseif SN > "BURGLARCDMIGHTTOFINESSE" then
											if SN == "BURGLARCDMIGHTTOOUTHEAL" then
												Result = 2
											end
										else
											Result = 1.5
										end
									elseif SN > "BURGLARCDMIGHTTOPHYMAS" then
										if SN < "BURGLARCDPHYMITTONONPHYMIT" then
											if SN == "BURGLARCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "BURGLARCDPHYMITTONONPHYMIT" then
											if SN == "BURGLARCDTACMASTOOUTHEAL" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 2
									end
								else
									Result = 1.5
								end
							else
								Result = CalcStat("ClassBaseVitality",L)
							end
						else
							Result = 3
						end
					elseif SN > "BURGLARCDVITALITYTOICMR" then
						if SN < "CAPTAINCDCALCTYPETACMIT" then
							if SN < "CAPTAINCDARMOURTONONPHYMIT" then
								if SN < "BURGLARCDWILLTORESIST" then
									if SN < "BURGLARCDWILLTOFINESSE" then
										if SN < "BURGLARCDVITALITYTONCMR" then
											if SN == "BURGLARCDVITALITYTOMORALE" then
												Result = 4.5
											end
										elseif SN > "BURGLARCDVITALITYTONCMR" then
											if SN == "BURGLARCDWILLTOCRITHIT" then
												Result = 0.5
											end
										else
											Result = 0.12
										end
									elseif SN > "BURGLARCDWILLTOFINESSE" then
										if SN < "BURGLARCDWILLTOPHYMAS" then
											if SN == "BURGLARCDWILLTOOUTHEAL" then
												Result = 2
											end
										elseif SN > "BURGLARCDWILLTOPHYMAS" then
											if SN == "BURGLARCDWILLTOPHYMIT" then
												Result = 1
											end
										else
											Result = 2
										end
									else
										Result = 1.5
									end
								elseif SN > "BURGLARCDWILLTORESIST" then
									if SN < "CAPTAINCDAGILITYTOPARRY" then
										if SN < "CAPTAINCDAGILITYTOCRITHIT" then
											if SN == "C" then
												Result = C
											end
										elseif SN > "CAPTAINCDAGILITYTOCRITHIT" then
											if SN == "CAPTAINCDAGILITYTOFINESSE" then
												Result = 1
											end
										else
											Result = 2
										end
									elseif SN > "CAPTAINCDAGILITYTOPARRY" then
										if SN < "CAPTAINCDAGILITYTOTACMAS" then
											if SN == "CAPTAINCDAGILITYTOPHYMAS" then
												Result = 2
											end
										elseif SN > "CAPTAINCDAGILITYTOTACMAS" then
											if SN == "CAPTAINCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 2
										end
									else
										Result = 1
									end
								else
									Result = 1
								end
							elseif SN > "CAPTAINCDARMOURTONONPHYMIT" then
								if SN < "CAPTAINCDBASEMORALE" then
									if SN < "CAPTAINCDBASEFATE" then
										if SN < "CAPTAINCDARMOURTYPE" then
											if SN == "CAPTAINCDARMOURTOTACMIT" then
												Result = 0.2
											end
										elseif SN > "CAPTAINCDARMOURTYPE" then
											if SN == "CAPTAINCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityL",L)
											end
										else
											Result = 3
										end
									elseif SN > "CAPTAINCDBASEFATE" then
										if SN < "CAPTAINCDBASEICPR" then
											if SN == "CAPTAINCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRM",L)
											end
										elseif SN > "CAPTAINCDBASEICPR" then
											if SN == "CAPTAINCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightH",L)
											end
										else
											Result = CalcStat("ClassBaseICPR",L)
										end
									else
										Result = CalcStat("ClassBaseFate",L)
									end
								elseif SN > "CAPTAINCDBASEMORALE" then
									if SN < "CAPTAINCDBASEVITALITY" then
										if SN < "CAPTAINCDBASENCPR" then
											if SN == "CAPTAINCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRM",L)
											end
										elseif SN > "CAPTAINCDBASENCPR" then
											if SN == "CAPTAINCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										else
											Result = CalcStat("ClassBaseNCPR",L)
										end
									elseif SN > "CAPTAINCDBASEVITALITY" then
										if SN < "CAPTAINCDCALCTYPECOMPHYMIT" then
											if SN == "CAPTAINCDBASEWILL" then
												Result = CalcStat("ClassBaseWillM",L)
											end
										elseif SN > "CAPTAINCDCALCTYPECOMPHYMIT" then
											if SN == "CAPTAINCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										else
											Result = 14
										end
									else
										Result = CalcStat("ClassBaseVitality",L)
									end
								else
									Result = CalcStat("ClassBaseMorale",L)
								end
							else
								Result = 0.2
							end
						elseif SN > "CAPTAINCDCALCTYPETACMIT" then
							if SN < "CAPTAINCDVITALITYTOMORALE" then
								if SN < "CAPTAINCDMIGHTTOPHYMAS" then
									if SN < "CAPTAINCDHASPOWER" then
										if SN < "CAPTAINCDFATETONCPR" then
											if SN == "CAPTAINCDCANBLOCK" then
												if 15 <= Lp then
													Result = 1
												end
											end
										elseif SN > "CAPTAINCDFATETONCPR" then
											if SN == "CAPTAINCDFATETOPOWER" then
												Result = 1
											end
										else
											Result = 0.07
										end
									elseif SN > "CAPTAINCDHASPOWER" then
										if SN < "CAPTAINCDMIGHTTOCRITHIT" then
											if SN == "CAPTAINCDMIGHTTOBLOCK" then
												Result = 2
											end
										elseif SN > "CAPTAINCDMIGHTTOCRITHIT" then
											if SN == "CAPTAINCDMIGHTTOPARRY" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "CAPTAINCDMIGHTTOPHYMAS" then
									if SN < "CAPTAINCDPHYMITTOCOMPHYMIT" then
										if SN < "CAPTAINCDMIGHTTOTACMAS" then
											if SN == "CAPTAINCDMIGHTTOPHYMIT" then
												Result = 1
											end
										elseif SN > "CAPTAINCDMIGHTTOTACMAS" then
											if SN == "CAPTAINCDMIGHTTOTACMIT" then
												Result = 1
											end
										else
											Result = 3
										end
									elseif SN > "CAPTAINCDPHYMITTOCOMPHYMIT" then
										if SN < "CAPTAINCDTACMASTOOUTHEAL" then
											if SN == "CAPTAINCDPHYMITTONONPHYMIT" then
												Result = 1
											end
										elseif SN > "CAPTAINCDTACMASTOOUTHEAL" then
											if SN == "CAPTAINCDVITALITYTOICMR" then
												Result = 0.012
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								else
									Result = 3
								end
							elseif SN > "CAPTAINCDVITALITYTOMORALE" then
								if SN < "CHAMPIONCDAGILITYTOCRITHIT" then
									if SN < "CAPTAINCDWILLTOPHYMIT" then
										if SN < "CAPTAINCDWILLTOFINESSE" then
											if SN == "CAPTAINCDVITALITYTONCMR" then
												Result = 0.12
											end
										elseif SN > "CAPTAINCDWILLTOFINESSE" then
											if SN == "CAPTAINCDWILLTOPHYMAS" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "CAPTAINCDWILLTOPHYMIT" then
										if SN < "CAPTAINCDWILLTOTACMAS" then
											if SN == "CAPTAINCDWILLTORESIST" then
												Result = 1
											end
										elseif SN > "CAPTAINCDWILLTOTACMAS" then
											if SN == "CAPTAINCDWILLTOTACMIT" then
												Result = 1.5
											end
										else
											Result = 1
										end
									else
										Result = 1.5
									end
								elseif SN > "CHAMPIONCDAGILITYTOCRITHIT" then
									if SN < "CHAMPIONCDAGILITYTOPHYMAS" then
										if SN < "CHAMPIONCDAGILITYTOOUTHEAL" then
											if SN == "CHAMPIONCDAGILITYTOFINESSE" then
												Result = 1
											end
										elseif SN > "CHAMPIONCDAGILITYTOOUTHEAL" then
											if SN == "CHAMPIONCDAGILITYTOPARRY" then
												Result = 1
											end
										else
											Result = 2
										end
									elseif SN > "CHAMPIONCDAGILITYTOPHYMAS" then
										if SN < "CHAMPIONCDARMOURTONONPHYMIT" then
											if SN == "CHAMPIONCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "CHAMPIONCDARMOURTONONPHYMIT" then
											if SN == "CHAMPIONCDARMOURTOTACMIT" then
												Result = 0.2
											end
										else
											Result = 0.2
										end
									else
										Result = 2
									end
								else
									Result = 2
								end
							else
								Result = 4.5
							end
						else
							Result = 27
						end
					else
						Result = 0.012
					end
				elseif SN > "CHAMPIONCDARMOURTYPE" then
					if SN < "CLASSBASEMIGHTL" then
						if SN < "CHAMPIONCDWILLTOOUTHEAL" then
							if SN < "CHAMPIONCDFATETONCPR" then
								if SN < "CHAMPIONCDBASENCPR" then
									if SN < "CHAMPIONCDBASEICPR" then
										if SN < "CHAMPIONCDBASEFATE" then
											if SN == "CHAMPIONCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityM",L)
											end
										elseif SN > "CHAMPIONCDBASEFATE" then
											if SN == "CHAMPIONCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRH",L)
											end
										else
											Result = CalcStat("ClassBaseFate",L)
										end
									elseif SN > "CHAMPIONCDBASEICPR" then
										if SN < "CHAMPIONCDBASEMORALE" then
											if SN == "CHAMPIONCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightH",L)
											end
										elseif SN > "CHAMPIONCDBASEMORALE" then
											if SN == "CHAMPIONCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRH",L)
											end
										else
											Result = CalcStat("ClassBaseMorale",L)
										end
									else
										Result = CalcStat("ClassBaseICPR",L)
									end
								elseif SN > "CHAMPIONCDBASENCPR" then
									if SN < "CHAMPIONCDCALCTYPECOMPHYMIT" then
										if SN < "CHAMPIONCDBASEVITALITY" then
											if SN == "CHAMPIONCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										elseif SN > "CHAMPIONCDBASEVITALITY" then
											if SN == "CHAMPIONCDBASEWILL" then
												Result = CalcStat("ClassBaseWillL",L)
											end
										else
											Result = CalcStat("ClassBaseVitality",L)
										end
									elseif SN > "CHAMPIONCDCALCTYPECOMPHYMIT" then
										if SN < "CHAMPIONCDCALCTYPETACMIT" then
											if SN == "CHAMPIONCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										elseif SN > "CHAMPIONCDCALCTYPETACMIT" then
											if SN == "CHAMPIONCDCANBLOCK" then
												if 6 <= Lp then
													Result = 1
												end
											end
										else
											Result = 27
										end
									else
										Result = 14
									end
								else
									Result = CalcStat("ClassBaseNCPR",L)
								end
							elseif SN > "CHAMPIONCDFATETONCPR" then
								if SN < "CHAMPIONCDMIGHTTOTACMIT" then
									if SN < "CHAMPIONCDMIGHTTOOUTHEAL" then
										if SN < "CHAMPIONCDHASPOWER" then
											if SN == "CHAMPIONCDFATETOPOWER" then
												Result = 1
											end
										elseif SN > "CHAMPIONCDHASPOWER" then
											if SN == "CHAMPIONCDMIGHTTOCRITHIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "CHAMPIONCDMIGHTTOOUTHEAL" then
										if SN < "CHAMPIONCDMIGHTTOPHYMAS" then
											if SN == "CHAMPIONCDMIGHTTOPARRY" then
												Result = 3
											end
										elseif SN > "CHAMPIONCDMIGHTTOPHYMAS" then
											if SN == "CHAMPIONCDMIGHTTOPHYMIT" then
												Result = 1
											end
										else
											Result = 3
										end
									else
										Result = 3
									end
								elseif SN > "CHAMPIONCDMIGHTTOTACMIT" then
									if SN < "CHAMPIONCDVITALITYTOICMR" then
										if SN < "CHAMPIONCDPHYMITTONONPHYMIT" then
											if SN == "CHAMPIONCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "CHAMPIONCDPHYMITTONONPHYMIT" then
											if SN == "CHAMPIONCDTACMASTOOUTHEAL" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "CHAMPIONCDVITALITYTOICMR" then
										if SN < "CHAMPIONCDVITALITYTONCMR" then
											if SN == "CHAMPIONCDVITALITYTOMORALE" then
												Result = 4.5
											end
										elseif SN > "CHAMPIONCDVITALITYTONCMR" then
											if SN == "CHAMPIONCDWILLTOFINESSE" then
												Result = 1
											end
										else
											Result = 0.12
										end
									else
										Result = 0.012
									end
								else
									Result = 1
								end
							else
								Result = 0.07
							end
						elseif SN > "CHAMPIONCDWILLTOOUTHEAL" then
							if SN < "CHPFINESSEINCREASE" then
								if SN < "CHICKENCDCALCTYPETACMIT" then
									if SN < "CHAMPIONCDWILLTOTACMIT" then
										if SN < "CHAMPIONCDWILLTOPHYMIT" then
											if SN == "CHAMPIONCDWILLTOPHYMAS" then
												Result = 1
											end
										elseif SN > "CHAMPIONCDWILLTOPHYMIT" then
											if SN == "CHAMPIONCDWILLTORESIST" then
												Result = 1
											end
										else
											Result = 1.5
										end
									elseif SN > "CHAMPIONCDWILLTOTACMIT" then
										if SN < "CHICKENCDCALCTYPECOMPHYMIT" then
											if SN == "CHICKENCANBLOCK" then
												Result = 1
											end
										elseif SN > "CHICKENCDCALCTYPECOMPHYMIT" then
											if SN == "CHICKENCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										else
											Result = 14
										end
									else
										Result = 1.5
									end
								elseif SN > "CHICKENCDCALCTYPETACMIT" then
									if SN < "CHISELCRITHITL" then
										if SN < "CHISELCRITHITH" then
											if SN == "CHICKENCDHASPOWER" then
												Result = 1
											end
										elseif SN > "CHISELCRITHITH" then
											if SN == "CHISELCRITHITHOLD" then
												if Lm <= 105 then
													Result = RoundDbl(24.24*L)
												else
													Result = CalcStat("ProgExtHighLinExpRnd",L,CalcStat("ChiselCritHitHOld",105))
												end
											end
										else
											if Lm <= 140 then
												Result = CalcStat("U371LegacyStatFix",L,"ChiselCritHitHOld")
											else
												Result = CalcStat("ChiselCritHitH",140)
											end
										end
									elseif SN > "CHISELCRITHITL" then
										if SN < "CHP2HWPNBLOCK" then
											if SN == "CHISELCRITHITLOLD" then
												if Lm <= 105 then
													Result = RoundDbl(16.16*L)
												else
													Result = CalcStat("ProgExtHighLinExpRnd",L,CalcStat("ChiselCritHitLOld",105))
												end
											end
										elseif SN > "CHP2HWPNBLOCK" then
											if SN == "CHPCONTRBURNICPR" then
												Result = CalcStat("ICPRT",L,0.4)
											end
										else
											Result = CalcStat("BlockT",L,4)
										end
									else
										if Lm <= 140 then
											Result = CalcStat("U371LegacyStatFix",L,"ChiselCritHitLOld")
										else
											Result = CalcStat("ChiselCritHitL",140)
										end
									end
								else
									Result = 27
								end
							elseif SN > "CHPFINESSEINCREASE" then
								if SN < "CLASSBASEAGILITYM" then
									if SN < "CHPUNBREAKTACMIT" then
										if SN < "CHPMIGHTINCREASE" then
											if SN == "CHPFLURRYINCRCRITHIT" then
												Result = CalcStat("CritHitT",L,2.4)
											end
										elseif SN > "CHPMIGHTINCREASE" then
											if SN == "CHPSTALWBLADEVITALITY" then
												Result = CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4)
											end
										else
											Result = CalcStat("MightT",L,CalcStat("Trait567810Choice",N)*0.4)
										end
									elseif SN > "CHPUNBREAKTACMIT" then
										if SN < "CLASSBASEAGILITYH" then
											if SN == "CHPUNBREAKTIERPTS" then
												if 1 <= Lp and Lm <= 10 then
													Result = 0.4*L
												end
											end
										elseif SN > "CLASSBASEAGILITYH" then
											if SN == "CLASSBASEAGILITYL" then
												Result = CalcStat("BaseAgility",L,0.5)
											end
										else
											Result = CalcStat("BaseAgility",L,1.5)
										end
									else
										Result = CalcStat("TacMitT",L,CalcStat("ChpUnbreakTierPts",N))
									end
								elseif SN > "CLASSBASEAGILITYM" then
									if SN < "CLASSBASEICMRM" then
										if SN < "CLASSBASEICMRH" then
											if SN == "CLASSBASEFATE" then
												Result = CalcStat("BaseFate",L)
											end
										elseif SN > "CLASSBASEICMRH" then
											if SN == "CLASSBASEICMRL" then
												Result = 0.15
											end
										else
											Result = 0.2
										end
									elseif SN > "CLASSBASEICMRM" then
										if SN < "CLASSBASEICPRADJ" then
											if SN == "CLASSBASEICPR" then
												Result = EquSng(StatLinInter("PntMPClassBaseICPR","ClassBasePowerRegenPntS","ProgBICPR","ClassBaseICPRAdj",L,N,99))
											end
										elseif SN > "CLASSBASEICPRADJ" then
											if SN == "CLASSBASEMIGHTH" then
												Result = CalcStat("BaseMight",L,1.5)
											end
										else
											if Lm <= 1 then
												Result = 1.5
											elseif Lm <= 20 then
												Result = 1.1
											else
												Result = 1
											end
										end
									else
										Result = 0.175
									end
								else
									Result = CalcStat("BaseAgility",L,1.0)
								end
							else
								Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4)
							end
						else
							Result = 1
						end
					elseif SN > "CLASSBASEMIGHTL" then
						if SN < "COMBATDAMAGEMOD" then
							if SN < "COMBATBASEPHYDPS" then
								if SN < "CLASSBASEPOWER" then
									if SN < "CLASSBASENCMRL" then
										if SN < "CLASSBASEMORALE" then
											if SN == "CLASSBASEMIGHTM" then
												Result = CalcStat("BaseMight",L,1.0)
											end
										elseif SN > "CLASSBASEMORALE" then
											if SN == "CLASSBASENCMRH" then
												Result = 2
											end
										else
											Result = CalcStat("BaseMorale",L)
										end
									elseif SN > "CLASSBASENCMRL" then
										if SN < "CLASSBASENCPR" then
											if SN == "CLASSBASENCMRM" then
												Result = 1
											end
										elseif SN > "CLASSBASENCPR" then
											if SN == "CLASSBASENCPRADJ" then
												if Lm <= 1 then
													Result = 1.5
												elseif Lm <= 20 then
													Result = 1.1
												else
													Result = 1
												end
											end
										else
											Result = EquSng(StatLinInter("PntMPClassBaseNCPR","ClassBasePowerRegenPntS","ProgBNCPR","ClassBaseNCPRAdj",L,N,99))
										end
									else
										Result = 1
									end
								elseif SN > "CLASSBASEPOWER" then
									if SN < "CLASSBASEWILLL" then
										if SN < "CLASSBASEVITALITY" then
											if SN == "CLASSBASEPOWERREGENPNTS" then
												Result = {{1,20,50,60,65,75,85,95,100,105,115,120,130,140,150},{1,20,50,60,65,75,85,95,100,105,115,120,130,140,150}}
											end
										elseif SN > "CLASSBASEVITALITY" then
											if SN == "CLASSBASEWILLH" then
												Result = CalcStat("BaseWill",L,1.5)
											end
										else
											Result = CalcStat("BaseVitality",L)
										end
									elseif SN > "CLASSBASEWILLL" then
										if SN < "CLASSNAME" then
											if SN == "CLASSBASEWILLM" then
												Result = CalcStat("BaseWill",L,1.0)
											end
										elseif SN > "CLASSNAME" then
											if SN == "CLOTHARMOUR" then
												if Lm <= 50 then
													Result = L
												else
													Result = 50
												end
											end
										else
											if 23 <= Lp and Lm <= 23 then
												Result = "Guardian"
											elseif 24 <= Lp and Lm <= 24 then
												Result = "Captain"
											elseif 31 <= Lp and Lm <= 31 then
												Result = "Minstrel"
											elseif 40 <= Lp and Lm <= 40 then
												Result = "Burglar"
											elseif 52 <= Lp and Lm <= 52 then
												Result = "Warleader"
											elseif 71 <= Lp and Lm <= 71 then
												Result = "Reaver"
											elseif 126 <= Lp and Lm <= 126 then
												Result = "Stalker"
											elseif 127 <= Lp and Lm <= 127 then
												Result = "Weaver"
											elseif 128 <= Lp and Lm <= 128 then
												Result = "Defiler"
											elseif 162 <= Lp and Lm <= 162 then
												Result = "Hunter"
											elseif 172 <= Lp and Lm <= 172 then
												Result = "Champion"
											elseif 179 <= Lp and Lm <= 179 then
												Result = "Blackarrow"
											elseif 185 <= Lp and Lm <= 185 then
												Result = "LoreMaster"
											elseif 192 <= Lp and Lm <= 192 then
												Result = "Chicken"
											elseif 193 <= Lp and Lm <= 193 then
												Result = "RuneKeeper"
											elseif 194 <= Lp and Lm <= 194 then
												Result = "Warden"
											elseif 214 <= Lp and Lm <= 214 then
												Result = "Beorning"
											elseif 215 <= Lp and Lm <= 215 then
												Result = "Brawler"
											elseif 216 <= Lp and Lm <= 216 then
												Result = "Mariner"
											else
												Result = ""
											end
										end
									else
										Result = CalcStat("BaseWill",L,0.5)
									end
								else
									Result = CalcStat("BasePower",L)
								end
							elseif SN > "COMBATBASEPHYDPS" then
								if SN < "COMBATBASETACHPSCURVES" then
									if SN < "COMBATBASETACDPSRAW" then
										if SN < "COMBATBASETACDPSBYLEVEL" then
											if SN == "COMBATBASETACDPS" then
												Result = EquSng(DecSng(CalcStat("CombatBaseTacDPSRaw",L)))
											end
										elseif SN > "COMBATBASETACDPSBYLEVEL" then
											if SN == "COMBATBASETACDPSNOCLASS" then
												if Lm <= 50 then
													Result = L
												else
													Result = CalcStat("CombatBaseTacDPSNoClass",50)
												end
											end
										else
											if Lm <= 50 then
												Result = EquSng(LinFmod(1,2,20,1,50,L))
											else
												Result = CalcStat("CombatBaseTacDPSByLevel",50)
											end
										end
									elseif SN > "COMBATBASETACDPSRAW" then
										if SN < "COMBATBASETACHPSBYLEVEL" then
											if SN == "COMBATBASETACHPS" then
												if Lm <= 56 then
													Result = EquSng(CalcStat("CombatBaseTacHPSRaw",L))
												else
													Result = EquSng(DecSng(CalcStat("CombatBaseTacHPSRaw",L)))
												end
											end
										elseif SN > "COMBATBASETACHPSBYLEVEL" then
											if SN == "COMBATBASETACHPSBYLEVELRAW" then
												if Lm <= 46 then
													Result = CalcStat("CombatBaseTacHPSCurves",L)
												else
													Result = CalcStat("CombatBaseTacHPSByLevelRaw",46)
												end
											end
										else
											Result = EquSng(CalcStat("CombatBaseTacHPSByLevelRaw",L))
										end
									else
										if Lm <= 47 then
											Result = LinFmod(1,0.5,0.5,1,47,L)
										elseif Lm <= 50 then
											Result = LinFmod(1,0.5,0.8,47,50,L)
										elseif Lm <= 51 then
											Result = LinFmod(1,1,1,51,51,L)
										elseif Lm <= 60 then
											Result = LinFmod(1,1.32,6.6,52,60,L)
										elseif Lm <= 65 then
											Result = LinFmod(1,6.6,9.1,60,65,L)
										elseif Lm <= 75 then
											Result = LinFmod(1,9.1,19,65,75,L)
										elseif Lm <= 125 then
											Result = LinFmod(1,19,32,75,125,L)
										elseif Lm <= 175 then
											Result = LinFmod(1,32,49,125,175,L)
										elseif Lm <= 200 then
											Result = LinFmod(1,49,66,175,200,L)
										elseif Lm <= 222 then
											Result = LinFmod(1,66,88,200,222,L)
										elseif Lm <= 299 then
											Result = LinFmod(1,88,88,222,299,L)
										elseif Lm <= 349 then
											Result = LinFmod(1,99,124,300,349,L)
										elseif Lm <= 399 then
											Result = LinFmod(1,138,160,350,399,L)
										elseif Lm <= 449 then
											Result = LinFmod(1,178,219,400,449,L)
										elseif Lm <= 499 then
											Result = LinFmod(1,243,340,450,499,L)
										elseif Lm <= 549 then
											Result = LinFmod(1,380,520,500,549,L)
										elseif Lm <= 599 then
											Result = LinFmod(1,570,790,550,599,L)
										elseif Lm <= 649 then
											Result = RoundDblDown(RoundDblUp((L-49)/5.5)*36.7-2831,-1)
										else
											Result = CalcStat("CombatBaseTacDPSRaw",649)
										end
									end
								elseif SN > "COMBATBASETACHPSCURVES" then
									if SN < "COMBATBASEWPNDPS" then
										if SN < "COMBATBASETACHPSNOCLASS" then
											if SN == "COMBATBASETACHPSLVLTOILVL" then
												if Lm <= 75 then
													Result = LinFmod(1,1,75,1,75,L)
												elseif Lm <= 100 then
													Result = LinFmod(1,75,200,75,100,L)
												elseif Lm <= 104 then
													Result = RoundDbl(LinFmod(1,201.3,214.3,101,104,L))
												elseif Lm <= 105 then
													Result = 222
												else
													Result = RoundDbl(CalcStat("LvlToILvl",L))
												end
											end
										elseif SN > "COMBATBASETACHPSNOCLASS" then
											if SN == "COMBATBASETACHPSRAW" then
												if Lm <= 49 then
													Result = CalcStat("CombatBaseTacHPSCurves",L)-CalcStat("CombatBaseTacHPSByLevelRaw",L)
												elseif Lm <= 55 then
													Result = 0.5
												elseif Lm <= 599 then
													Result = CalcStat("CommonTacHPS",L)-CalcStat("CombatBaseTacHPSByLevelRaw",L)
												elseif Lm <= 649 then
													Result = (RoundDblUp((4*L+2)/22)*678-RoundDblUp((L+1)/22))*0.175-11734.1-CalcStat("CombatBaseTacHPSByLevelRaw",L)
												else
													Result = CalcStat("CombatBaseTacHPSRaw",649)
												end
											end
										else
											Result = EquSng(CalcStat("CombatBaseTacHPSByLevelRaw",L)+CalcStat("CombatBaseTacHPSRaw",CalcStat("CombatBaseTacHPSLvlToILvl",L)))
										end
									elseif SN > "COMBATBASEWPNDPS" then
										if SN < "COMBATBASEWPNDPSCATTYPEMP" then
											if SN == "COMBATBASEWPNDPSBASE" then
												Result = EquSng(DecSng(CalcStat("CombatBaseWpnDPSCatTypeMP",WpnCodeIndex(C,1)*4+WpnCodeIndex(C,2))*CalcStat("CombatBasePhyDPS",L)*1.08))
											end
										elseif SN > "COMBATBASEWPNDPSCATTYPEMP" then
											if SN == "COMBATBASEWPNDPSQTYMP" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,1.02,1.04,1.08,1.12},L))
												end
											end
										else
											if 9 <= Lp and Lm <= 9 then
												Result = 0.9
											elseif 5 <= Lp and Lm <= 5 then
												Result = 1
											elseif 10 <= Lp and Lm <= 11 then
												Result = 1.2
											elseif 6 <= Lp and Lm <= 7 then
												Result = 1.4
											else
												Result = 1
											end
										end
									else
										Result = EquSng(CalcStat("CombatBaseWpnDPSBase",L,C)*CalcStat("CombatBaseWpnDPSQtyMP",WpnCodeIndex(C,3)))
									end
								else
									if Lm <= 25 then
										Result = (13*L+85)*(81-L)/3920
									else
										Result = (13*L+85)*(75-L)/3500
									end
								end
							else
								if Lm <= 50 then
									Result = LinFmod(1,2,20,1,50,L)
								elseif Lm <= 60 then
									Result = LinFmod(1,20,26.6,50,60,L)
								elseif Lm <= 65 then
									Result = LinFmod(1,26.6,29.1,60,65,L)
								elseif Lm <= 75 then
									Result = LinFmod(1,29.1,39,65,75,L)
								elseif Lm <= 125 then
									Result = LinFmod(1,39,52,75,125,L)
								elseif Lm <= 175 then
									Result = LinFmod(1,52,69,125,175,L)
								elseif Lm <= 200 then
									Result = LinFmod(1,69,86,175,200,L)
								elseif Lm <= 222 then
									Result = LinFmod(1,86,108,200,222,L)
								elseif Lm <= 300 then
									Result = LinFmod(1,108,108,222,300,L)
								elseif Lm <= 350 then
									Result = LinFmod(1,119,144,301,350,L)
								elseif Lm <= 400 then
									Result = LinFmod(1,158,180,351,400,L)
								elseif Lm <= 450 then
									Result = LinFmod(1,198,239,401,450,L)
								elseif Lm <= 500 then
									Result = LinFmod(1,263,360,451,500,L)
								elseif Lm <= 550 then
									Result = LinFmod(1,400,540,501,550,L)
								elseif Lm <= 600 then
									Result = LinFmod(1,590,810,551,600,L)
								elseif Lm <= 650 then
									Result = RoundDblDown(RoundDblUp((L-50)/5.5)*36.7-2811,-1)
								else
									Result = CalcStat("CombatBasePhyDPS",650)
								end
							end
						elseif SN > "COMBATDAMAGEMOD" then
							if SN < "COMBATDAMAGEMODPLAYERSADJ" then
								if SN < "COMBATDAMAGEMODHEALTHMEDIUMADJ" then
									if SN < "COMBATDAMAGEMODHEALTHITEM" then
										if SN < "COMBATDAMAGEMODHEALTH" then
											if SN == "COMBATDAMAGEMODENERGY" then
												Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBEnergy","",L,N,2))
											end
										elseif SN > "COMBATDAMAGEMODHEALTH" then
											if SN == "COMBATDAMAGEMODHEALTHADJ" then
												if Lm <= 141 then
													Result = 1
												else
													Result = 0.66
												end
											end
										else
											Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBHealth","CombatDamageModHealthAdj",L,N,2))
										end
									elseif SN > "COMBATDAMAGEMODHEALTHITEM" then
										if SN < "COMBATDAMAGEMODHEALTHLOWADJ" then
											if SN == "COMBATDAMAGEMODHEALTHLOW" then
												Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBHealth","CombatDamageModHealthLowAdj",L,N,99))
											end
										elseif SN > "COMBATDAMAGEMODHEALTHLOWADJ" then
											if SN == "COMBATDAMAGEMODHEALTHMEDIUM" then
												Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBHealth","CombatDamageModHealthMediumAdj",L,N,99))
											end
										else
											if Lm <= 1 then
												Result = 0.144
											elseif Lm <= 25 then
												Result = 0.324
											elseif Lm <= 50 then
												Result = 0.576
											else
												Result = 0.9
											end
										end
									else
										Result = EquSng(StatLinInter("PntMPCombatDamageMod","ItemPntSClassic","ProgBHealth","",L,N,0))
									end
								elseif SN > "COMBATDAMAGEMODHEALTHMEDIUMADJ" then
									if SN < "COMBATDAMAGEMODPETS" then
										if SN < "COMBATDAMAGEMODNERFEDADJ" then
											if SN == "COMBATDAMAGEMODNERFED" then
												Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBCombatDamageMod","CombatDamageModNerfedAdj",L,N,2))
											end
										elseif SN > "COMBATDAMAGEMODNERFEDADJ" then
											if SN == "COMBATDAMAGEMODNPCS" then
												Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBCombatDamageMod","",L,N,99))
											end
										else
											if Lm <= 141 then
												Result = 1
											else
												Result = 0.82
											end
										end
									elseif SN > "COMBATDAMAGEMODPETS" then
										if SN < "COMBATDAMAGEMODPETSRND" then
											if SN == "COMBATDAMAGEMODPETSADJ" then
												if Lm <= 1 then
													Result = 1
												elseif Lm <= 25 then
													Result = 0.4
												elseif Lm <= 50 then
													Result = 0.5
												elseif Lm <= 60 then
													Result = 0.6
												elseif Lm <= 65 then
													Result = 0.7
												elseif Lm <= 75 then
													Result = 0.8
												elseif Lm <= 85 then
													Result = 0.85
												elseif Lm <= 95 then
													Result = 0.9
												elseif Lm <= 100 then
													Result = 0.95
												else
													Result = 1
												end
											end
										elseif SN > "COMBATDAMAGEMODPETSRND" then
											if SN == "COMBATDAMAGEMODPLAYERS" then
												Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBCombatDamageMod","CombatDamageModPlayersAdj",L,N,99))
											end
										else
											Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBCombatDamageMod","CombatDamageModPetsAdj",L,N,2))
										end
									else
										Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBCombatDamageMod","CombatDamageModPetsAdj",L,N,99))
									end
								else
									if Lm <= 1 then
										Result = 0.36
									elseif Lm <= 25 then
										Result = 0.54
									elseif Lm <= 50 then
										Result = 0.72
									else
										Result = 0.9
									end
								end
							elseif SN > "COMBATDAMAGEMODPLAYERSADJ" then
								if SN < "CPTCOVFATE" then
									if SN < "CONSTSTATC" then
										if SN < "COMMONTACHPS" then
											if SN == "COMBATINHEAL" then
												Result = CalcStat("InHeal",L,2.0)
											end
										elseif SN > "COMMONTACHPS" then
											if SN == "COMMONTACHPSITEMPNTS" then
												Result = {{1,50,60,65,75,125,175,200,222,299,300,349,350,399,400,449,450,499,500,549,550,599},{1,50,60,65,75,85,95,100,105,105,106,115,116,120,121,130,131,140,141,150,151,160}}
											end
										else
											Result = StatLinInter("PntMPTacHPS","CommonTacHPSItemPntS","ProgBTacHPS","",L,N,99)
										end
									elseif SN > "CONSTSTATC" then
										if SN < "CPTBLADEPHYMAS" then
											if SN == "CPTBLADECRITDEF" then
												Result = CalcStat("CritDefT",L,0.8)
											end
										elseif SN > "CPTBLADEPHYMAS" then
											if SN == "CPTBLADETACMAS" then
												Result = CalcStat("TacMasT",L,0.8)
											end
										else
											Result = CalcStat("PhyMasT",L,1.2)
										end
									else
										Result = CalcStat(C,1,L)
									end
								elseif SN > "CPTCOVFATE" then
									if SN < "CPTCRITDEF" then
										if SN < "CPTCOVPHYMIT" then
											if SN == "CPTCOVMAIN" then
												Result = CalcStat("MainT",L,0.4)
											end
										elseif SN > "CPTCOVPHYMIT" then
											if SN == "CPTCOVVITALITY" then
												Result = CalcStat("VitalityT",L,0.4)
											end
										else
											Result = CalcStat("PhyMitT",L,2.4)
										end
									elseif SN > "CPTCRITDEF" then
										if SN < "CPTIDOMEMAIN" then
											if SN == "CPTIDOMEFATE" then
												Result = CalcStat("FateT",L,0.4)
											end
										elseif SN > "CPTIDOMEMAIN" then
											if SN == "CPTIDOMEVITALITY" then
												Result = CalcStat("VitalityT",L,0.4)
											end
										else
											Result = CalcStat("MainT",L,0.4)
										end
									else
										Result = CalcStat("CritDef",L,0.6)
									end
								else
									Result = CalcStat("FateT",L,0.4)
								end
							else
								if Lm <= 1 then
									Result = 0.8
								elseif Lm <= 25 then
									Result = 0.9
								else
									Result = 1
								end
							end
						else
							Result = EquSng(StatLinInter("PntMPCombatDamageMod","TraitPntSVital","ProgBCombatDamageMod","",L,N,2))
						end
					else
						Result = CalcStat("BaseMight",L,0.5)
					end
				else
					Result = 3
				end
			else
				Result = 0.012
			end
		elseif SN > "CPTSHIELDCRITDEF" then
			if SN < "HNTARMOURRENDPARRY" then
				if SN < "EVADEPPRAT" then
					if SN < "CRITMAGNPRATPC" then
						if SN < "CRITDEFC" then
							if SN < "CREEPAUDACITYRNGREDP" then
								if SN < "CREEPAUDACITYCCDP" then
									if SN < "CPTSONGPHYMAS" then
										if SN < "CPTSHIELDTACMAS" then
											if SN == "CPTSHIELDPHYMAS" then
												Result = CalcStat("PhyMasT",L,0.8)
											end
										elseif SN > "CPTSHIELDTACMAS" then
											if SN == "CPTSONGCRITDEF" then
												Result = CalcStat("CritDefT",L,0.8)
											end
										else
											Result = CalcStat("TacMasT",L,0.8)
										end
									elseif SN > "CPTSONGPHYMAS" then
										if SN < "CPTSTANDALONEPHYMAS" then
											if SN == "CPTSONGTACMAS" then
												Result = CalcStat("TacMasT",L,1.2)
											end
										elseif SN > "CPTSTANDALONEPHYMAS" then
											if SN == "CPTSTANDALONETACMAS" then
												Result = CalcStat("TacMasT",L,0.8)
											end
										else
											Result = CalcStat("PhyMasT",L,1.2)
										end
									else
										Result = CalcStat("PhyMasT",L,0.8)
									end
								elseif SN > "CREEPAUDACITYCCDP" then
									if SN < "CREEPAUDACITYMELDMGP" then
										if SN < "CREEPAUDACITYCOSTBASE" then
											if SN == "CREEPAUDACITYCOST" then
												Result = CalcStat("CreepAudacityCostBase",L)*25
											end
										elseif SN > "CREEPAUDACITYCOSTBASE" then
											if SN == "CREEPAUDACITYDMGP" then
												if 1 <= Lp and Lm <= 10 then
													Result = LinFmod(1,1,1.2,1,10,L)
												elseif 11 <= Lp and Lm <= 36 then
													Result = LinFmod(1,1.2,1.25,10,36,L)
												elseif 37 <= Lp and Lm <= 41 then
													Result = LinFmod(1,1.25,1.3,36,41,L)
												elseif 42 <= Lp and Lm <= 60 then
													Result = LinFmod(1,1.3,1.25,41,60,L)
												end
											end
										else
											if 1 <= Lp and Lm <= 2 then
												Result = 2*L
											elseif 3 <= Lp and Lm <= 9 then
												Result = 2*L-1
											elseif 10 <= Lp and Lm <= 15 then
												Result = 3*L
											elseif 16 <= Lp and Lm <= 25 then
												Result = 6*L
											elseif 26 <= Lp and Lm <= 29 then
												Result = 9*L
											elseif 30 <= Lp and Lm <= 36 then
												Result = 300
											end
										end
									elseif SN > "CREEPAUDACITYMELDMGP" then
										if SN < "CREEPAUDACITYREDP" then
											if SN == "CREEPAUDACITYMELREDP" then
												Result = CalcStat("CreepAudacityRedP",L)
											end
										elseif SN > "CREEPAUDACITYREDP" then
											if SN == "CREEPAUDACITYRNGDMGP" then
												Result = CalcStat("CreepAudacityDmgP",L)
											end
										else
											if 1 <= Lp and Lm <= 10 then
												Result = LinFmod(1,0.5,0.5,1,10,L)
											elseif 11 <= Lp and Lm <= 36 then
												Result = LinFmod(1,0.5,0.5,10,36,L)
											elseif 37 <= Lp and Lm <= 41 then
												Result = LinFmod(1,0.5,0.5,36,41,L)
											elseif 42 <= Lp and Lm <= 60 then
												Result = LinFmod(1,0.5,0.5,41,60,L)
											end
										end
									else
										Result = CalcStat("CreepAudacityDmgP",L)
									end
								else
									if 1 <= Lp and Lm <= 16 then
										Result = 0.5
									elseif 17 <= Lp and Lm <= 60 then
										Result = 0.4
									end
								end
							elseif SN > "CREEPAUDACITYRNGREDP" then
								if SN < "CREEPBATPROMRNGDMGP" then
									if SN < "CREEPBATPROMHEALTHP" then
										if SN < "CREEPAUDACITYTACREDP" then
											if SN == "CREEPAUDACITYTACDMGP" then
												Result = CalcStat("CreepAudacityDmgP",L)
											end
										elseif SN > "CREEPAUDACITYTACREDP" then
											if SN == "CREEPBATPROMDMGP" then
												if 1 <= Lp and Lm <= 5 then
													Result = LinFmod(1,0.005,0.02,1,5,L)
												elseif 6 <= Lp and Lm <= 10 then
													Result = LinFmod(1,0.02,0.045,5,10,L)
												elseif 11 <= Lp and Lm <= 15 then
													Result = LinFmod(1,0.045,0.075,10,15,L)
												end
											end
										else
											Result = CalcStat("CreepAudacityRedP",L)
										end
									elseif SN > "CREEPBATPROMHEALTHP" then
										if SN < "CREEPBATPROMOUTHEALP" then
											if SN == "CREEPBATPROMMELDMGP" then
												Result = CalcStat("CreepBatPromDmgP",L)
											end
										elseif SN > "CREEPBATPROMOUTHEALP" then
											if SN == "CREEPBATPROMPOWERP" then
												Result = CalcStat("CreepBatPromVitalP",L)
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = LinFmod(1,0.02,0.1,1,5,L)
											elseif 6 <= Lp and Lm <= 10 then
												Result = LinFmod(1,0.1,0.15,5,10,L)
											elseif 11 <= Lp and Lm <= 15 then
												Result = LinFmod(1,0.15,0.2,10,15,L)
											end
										end
									else
										Result = CalcStat("CreepBatPromVitalP",L)
									end
								elseif SN > "CREEPBATPROMRNGDMGP" then
									if SN < "CREEPITEMPNTS" then
										if SN < "CREEPBATPROMVITALP" then
											if SN == "CREEPBATPROMTACDMGP" then
												Result = CalcStat("CreepBatPromDmgP",L)
											end
										elseif SN > "CREEPBATPROMVITALP" then
											if SN == "CREEPILVLCURR" then
												Result = 520
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = LinFmod(1,1.02,1.1,1,5,L)
											elseif 6 <= Lp and Lm <= 10 then
												Result = LinFmod(1,1.1,1.15,5,10,L)
											elseif 11 <= Lp and Lm <= 15 then
												Result = LinFmod(1,1.15,1.2,10,15,L)
											end
										end
									elseif SN > "CREEPITEMPNTS" then
										if SN < "CREEPTRAITPROGB" then
											if SN == "CREEPTRAITPNTS" then
												Result = {{1,150},{1,150}}
											end
										elseif SN > "CREEPTRAITPROGB" then
											if SN == "CRITDEF" then
												Result = EquSng(StatLinInter("PntMPCritDef","ItemPntS","ProgBCritDef","AdjItem",L,N,0))
											end
										else
											Result = LinFmod(1,0.01,1,1,CalcStat("LevelCap",L),L)
										end
									else
										Result = {{500,549},{141,150}}
									end
								else
									Result = CalcStat("CreepBatPromDmgP",L)
								end
							else
								Result = CalcStat("CreepAudacityRedP",L)
							end
						elseif SN > "CRITDEFC" then
							if SN < "CRITHITCILVLFILTER" then
								if SN < "CRITDEFPRATPB" then
									if SN < "CRITDEFCRAW" then
										if SN < "CRITDEFCILVLFILTER" then
											if SN == "CRITDEFCI" then
												Result = RoundDblLotro(CalcStat("CritDefCIRaw",L,N))
											end
										elseif SN > "CRITDEFCILVLFILTER" then
											if SN == "CRITDEFCIRAW" then
												Result = StatLinInter("PntMPCritDefC","ItemPntS","ProgBCritDef","AdjCreepItem",L,N,4)
											end
										else
											if 4 <= Lp and Lm <= 4 or 4.6 <= Lp and Lm <= 4.6 or 5.6 <= Lp and Lm <= 5.6 or 6.2 <= Lp and Lm <= 6.2 or 8.4 <= Lp and Lm <= 8.4 or 11.2 <= Lp and Lm <= 11.2 or 14 <= Lp and Lm <= 14 then
												Result = 515
											else
												Result = CalcStat("CreepILvlCurr",L)
											end
										end
									elseif SN > "CRITDEFCRAW" then
										if SN < "CRITDEFPRATP" then
											if SN == "CRITDEFPPRAT" then
												Result = CalcRatAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCapR",L),N)
											end
										elseif SN > "CRITDEFPRATP" then
											if SN == "CRITDEFPRATPA" then
												Result = 240
											end
										else
											Result = CalcPercAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCap",L),N)
										end
									else
										Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("CritDefCIRaw",CalcStat("CritDefCILvlFilter",N),N),99)
									end
								elseif SN > "CRITDEFPRATPB" then
									if SN < "CRITDEFT" then
										if SN < "CRITDEFPRATPCAP" then
											if SN == "CRITDEFPRATPC" then
												Result = 0.5
											end
										elseif SN > "CRITDEFPRATPCAP" then
											if SN == "CRITDEFPRATPCAPR" then
												Result = CalcStat("CritDefPRatPB",L)*CalcStat("CritDefPRatPC",L)
											end
										else
											Result = 80
										end
									elseif SN > "CRITDEFT" then
										if SN < "CRITHITC" then
											if SN == "CRITHIT" then
												Result = EquSng(StatLinInter("PntMPCritHit","ItemPntS","ProgBCritHit","AdjItem",L,N,0))
											end
										elseif SN > "CRITHITC" then
											if SN == "CRITHITCI" then
												Result = RoundDblLotro(CalcStat("CritHitCIRaw",L,N))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("CritHitCI",CalcStat("CritHitCILvlFilter",N),N),0)
										end
									else
										Result = EquSng(StatLinInter("PntMPCritDef","TraitPntS","ProgBCritDef","AdjTrait",L,N,0))
									end
								else
									Result = CalcStat("BRatRounded",L,"BRatStandard")
								end
							elseif SN > "CRITHITCILVLFILTER" then
								if SN < "CRITHITPRATPC" then
									if SN < "CRITHITPPRAT" then
										if SN < "CRITHITCRAW" then
											if SN == "CRITHITCIRAW" then
												Result = StatLinInter("PntMPCritHitC","ItemPntS","ProgBCritHit","AdjCreepItem",L,N,4)
											end
										elseif SN > "CRITHITCRAW" then
											if SN == "CRITHITOLD" then
												Result = CalcStat("CritHit",L,N)
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("CritHitCIRaw",CalcStat("CritHitCILvlFilter",N),N),99)
										end
									elseif SN > "CRITHITPPRAT" then
										if SN < "CRITHITPRATPA" then
											if SN == "CRITHITPRATP" then
												Result = CalcPercAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCap",L),N)
											end
										elseif SN > "CRITHITPRATPA" then
											if SN == "CRITHITPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatExtra")
											end
										else
											Result = 75
										end
									else
										Result = CalcRatAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCapR",L),N)
									end
								elseif SN > "CRITHITPRATPC" then
									if SN < "CRITMAGNPPRAT" then
										if SN < "CRITHITPRATPCAPR" then
											if SN == "CRITHITPRATPCAP" then
												Result = 25
											end
										elseif SN > "CRITHITPRATPCAPR" then
											if SN == "CRITHITT" then
												Result = EquSng(StatLinInter("PntMPCritHit","TraitPntS","ProgBCritHit","AdjTrait",L,N,0))
											end
										else
											Result = CalcStat("CritHitPRatPB",L)*CalcStat("CritHitPRatPC",L)
										end
									elseif SN > "CRITMAGNPPRAT" then
										if SN < "CRITMAGNPRATPA" then
											if SN == "CRITMAGNPRATP" then
												Result = CalcPercAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCap",L),N)
											end
										elseif SN > "CRITMAGNPRATPA" then
											if SN == "CRITMAGNPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatCritMagn")
											end
										else
											Result = 225
										end
									else
										Result = CalcRatAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCapR",L),N)
									end
								else
									Result = 0.5
								end
							else
								if 2.2 <= Lp and Lm <= 2.2 or 3.8 <= Lp and Lm <= 3.8 or 4.6 <= Lp and Lm <= 4.6 or 5.2 <= Lp and Lm <= 5.2 or 10.4 <= Lp and Lm <= 10.4 or 15.6 <= Lp and Lm <= 15.6 then
									Result = 515
								else
									Result = CalcStat("CreepILvlCurr",L)
								end
							end
						else
							Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("CritDefCI",CalcStat("CritDefCILvlFilter",N),N),0)
						end
					elseif SN > "CRITMAGNPRATPC" then
						if SN < "DWARFRDTRAITMIGHT" then
							if SN < "DEVHITPRATPCAPR" then
								if SN < "DEFILERCDCALCTYPETACMIT" then
									if SN < "CRYRESISTT" then
										if SN < "CRITMAGNPRATPCAPR" then
											if SN == "CRITMAGNPRATPCAP" then
												Result = 75
											end
										elseif SN > "CRITMAGNPRATPCAPR" then
											if SN == "CRYRESIST" then
												Result = CalcStat("ResistAdd",L,N)
											end
										else
											Result = CalcStat("CritMagnPRatPB",L)*CalcStat("CritMagnPRatPC",L)
										end
									elseif SN > "CRYRESISTT" then
										if SN < "DEFILERCDCALCTYPECOMPHYMIT" then
											if SN == "DEFILERCANBLOCK" then
												Result = 1
											end
										elseif SN > "DEFILERCDCALCTYPECOMPHYMIT" then
											if SN == "DEFILERCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										else
											Result = 13
										end
									else
										Result = CalcStat("ResistAddT",L,N)
									end
								elseif SN > "DEFILERCDCALCTYPETACMIT" then
									if SN < "DEVHITPRATPA" then
										if SN < "DEVHITPPRAT" then
											if SN == "DEFILERCDHASPOWER" then
												Result = 1
											end
										elseif SN > "DEVHITPPRAT" then
											if SN == "DEVHITPRATP" then
												Result = CalcPercAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCap",L),N)
											end
										else
											Result = CalcRatAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCapR",L),N)
										end
									elseif SN > "DEVHITPRATPA" then
										if SN < "DEVHITPRATPC" then
											if SN == "DEVHITPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatDevHit")
											end
										elseif SN > "DEVHITPRATPC" then
											if SN == "DEVHITPRATPCAP" then
												Result = 10
											end
										else
											Result = 0.5
										end
									else
										Result = 30
									end
								else
									Result = 27
								end
							elseif SN > "DEVHITPRATPCAPR" then
								if SN < "DWARFRDPSVONEFATE" then
									if SN < "DMGTYPEMITT" then
										if SN < "DISEASERESISTT" then
											if SN == "DISEASERESIST" then
												Result = CalcStat("ResistAdd",L,N)
											end
										elseif SN > "DISEASERESISTT" then
											if SN == "DMGTYPEMIT" then
												Result = EquSng(StatLinInter("PntMPDmgTypeMit","ItemPntS","ProgBMitigation","AdjItemMit",L,N,0))
											end
										else
											Result = CalcStat("ResistAddT",L,N)
										end
									elseif SN > "DMGTYPEMITT" then
										if SN < "DWARFFATEFULDWARFFATE" then
											if SN == "DWARFENDURVITALITY" then
												Result = CalcStat("VitalityT",L,1.0)
											end
										elseif SN > "DWARFFATEFULDWARFFATE" then
											if SN == "DWARFLOSTDWARFKDSFATE" then
												Result = -CalcStat("FateT",L,0.4)
											end
										else
											Result = CalcStat("FateT",L,1.0)
										end
									else
										Result = EquSng(StatLinInter("PntMPDmgTypeMitT","TraitPntS","ProgBMitigation","AdjTraitMit",L,N,0))
									end
								elseif SN > "DWARFRDPSVONEFATE" then
									if SN < "DWARFRDTRAITAGILITY" then
										if SN < "DWARFRDPSVTWOBLOCK" then
											if SN == "DWARFRDPSVONENAME" then
												Result = "Fateful Dwarf"
											end
										elseif SN > "DWARFRDPSVTWOBLOCK" then
											if SN == "DWARFRDPSVTWONAME" then
												Result = "Shield Brawler"
											end
										else
											Result = CalcStat("DwarfShieldBrwlBlock",L)
										end
									elseif SN > "DWARFRDTRAITAGILITY" then
										if SN < "DWARFRDTRAITICMR" then
											if SN == "DWARFRDTRAITFATE" then
												Result = CalcStat("DwarfLostDwarfKdsFate",L)
											end
										elseif SN > "DWARFRDTRAITICMR" then
											if SN == "DWARFRDTRAITICPR" then
												Result = CalcStat("DwarfUnwearBattleICPR",L)
											end
										else
											Result = CalcStat("DwarfUnwearBattleICMR",L)
										end
									else
										Result = CalcStat("DwarfStockyAgility",L)
									end
								else
									Result = CalcStat("DwarfFatefulDwarfFate",L)
								end
							else
								Result = CalcStat("DevHitPRatPB",L)*CalcStat("DevHitPRatPC",L)
							end
						elseif SN > "DWARFRDTRAITMIGHT" then
							if SN < "ELFFRIENDOFMANFATE" then
								if SN < "DWARFSTURDINESSPHYMITP" then
									if SN < "DWARFRDTRAITVITALITY" then
										if SN < "DWARFRDTRAITNCPR" then
											if SN == "DWARFRDTRAITNCMR" then
												Result = CalcStat("DwarfUnwearBattleNCMR",L)
											end
										elseif SN > "DWARFRDTRAITNCPR" then
											if SN == "DWARFRDTRAITPHYMITP" then
												Result = CalcStat("DwarfSturdinessPhyMitP",L)
											end
										else
											Result = CalcStat("DwarfUnwearBattleNCPR",L)
										end
									elseif SN > "DWARFRDTRAITVITALITY" then
										if SN < "DWARFSTOCKYAGILITY" then
											if SN == "DWARFSHIELDBRWLBLOCK" then
												Result = CalcStat("BlockT",L,0.8)
											end
										elseif SN > "DWARFSTOCKYAGILITY" then
											if SN == "DWARFSTURDINESSMIGHT" then
												Result = CalcStat("MightT",L,1.0)
											end
										else
											Result = -CalcStat("AgilityT",L,0.4)
										end
									else
										Result = CalcStat("DwarfSturdinessVitality",L)
									end
								elseif SN > "DWARFSTURDINESSPHYMITP" then
									if SN < "DWARFUNWEARBATTLENCMR" then
										if SN < "DWARFUNWEARBATTLEICMR" then
											if SN == "DWARFSTURDINESSVITALITY" then
												Result = CalcStat("VitalityT",L,1.0)
											end
										elseif SN > "DWARFUNWEARBATTLEICMR" then
											if SN == "DWARFUNWEARBATTLEICPR" then
												Result = CalcStat("ICPRT",L,0.6)
											end
										else
											Result = CalcStat("ICMRT",L,0.6)
										end
									elseif SN > "DWARFUNWEARBATTLENCMR" then
										if SN < "ELFAGILITYWOODSAGILITY" then
											if SN == "DWARFUNWEARBATTLENCPR" then
												Result = -CalcStat("NCPRT",L,0.4)
											end
										elseif SN > "ELFAGILITYWOODSAGILITY" then
											if SN == "ELFFADINGFIRSTBORNFATE" then
												Result = -CalcStat("FateT",L,0.4)
											end
										else
											Result = CalcStat("AgilityT",L,1.0)
										end
									else
										Result = -CalcStat("NCMRT",L,0.4)
									end
								else
									Result = 1
								end
							elseif SN > "ELFFRIENDOFMANFATE" then
								if SN < "ELFSORROWFIRSTBORNMORALE" then
									if SN < "ELFRDTRAITAGILITY" then
										if SN < "ELFRDPSVONENAME" then
											if SN == "ELFRDPSVONEFATE" then
												Result = CalcStat("ElfFriendOfManFate",L)
											end
										elseif SN > "ELFRDPSVONENAME" then
											if SN == "ELFRDPSVTWONAME" then
												Result = ""
											end
										else
											Result = "Friend Of Man"
										end
									elseif SN > "ELFRDTRAITAGILITY" then
										if SN < "ELFRDTRAITMORALE" then
											if SN == "ELFRDTRAITFATE" then
												Result = CalcStat("ElfFadingFirstbornFate",L)
											end
										elseif SN > "ELFRDTRAITMORALE" then
											if SN == "ELFRDTRAITNCMR" then
												Result = CalcStat("ElfSorrowFirstbornNCMR",L)
											end
										else
											Result = CalcStat("ElfSorrowFirstbornMorale",L)
										end
									else
										Result = CalcStat("ElfAgilityWoodsAgility",L)
									end
								elseif SN > "ELFSORROWFIRSTBORNMORALE" then
									if SN < "EVADECI" then
										if SN < "EVADE" then
											if SN == "ELFSORROWFIRSTBORNNCMR" then
												Result = -CalcStat("NCMRT",L,0.4)
											end
										elseif SN > "EVADE" then
											if SN == "EVADEC" then
												Result = CalcStat("BPEC",L,N)
											end
										else
											Result = CalcStat("BPE",L,N)
										end
									elseif SN > "EVADECI" then
										if SN < "EVADECRAW" then
											if SN == "EVADECIRAW" then
												Result = CalcStat("BPECIRAW",L,N)
											end
										elseif SN > "EVADECRAW" then
											if SN == "EVADEPBONUS" then
												Result = CalcStat("BPEPBonus",L)
											end
										else
											Result = CalcStat("BPECRAW",L,N)
										end
									else
										Result = CalcStat("BPECI",L,N)
									end
								else
									Result = -CalcStat("MoraleT",L,0.4)
								end
							else
								Result = CalcStat("FateT",L,1.0)
							end
						else
							Result = CalcStat("DwarfSturdinessMight",L)
						end
					else
						Result = 0.5
					end
				elseif SN > "EVADEPPRAT" then
					if SN < "GRDTENDERIZET3CRITHIT" then
						if SN < "FOODNCMRL" then
							if SN < "FINESSECI" then
								if SN < "FATE" then
									if SN < "EVADEPRATPC" then
										if SN < "EVADEPRATPA" then
											if SN == "EVADEPRATP" then
												Result = CalcStat("BPEPRatP",L,N)
											end
										elseif SN > "EVADEPRATPA" then
											if SN == "EVADEPRATPB" then
												Result = CalcStat("BPEPRatPB",L)
											end
										else
											Result = CalcStat("BPEPRatPA",L)
										end
									elseif SN > "EVADEPRATPC" then
										if SN < "EVADEPRATPCAPR" then
											if SN == "EVADEPRATPCAP" then
												Result = CalcStat("BPEPRatPCap",L)
											end
										elseif SN > "EVADEPRATPCAPR" then
											if SN == "EVADET" then
												Result = CalcStat("BPET",L,N)
											end
										else
											Result = CalcStat("BPEPRatPCapR",L)
										end
									else
										Result = CalcStat("BPEPRatPC",L)
									end
								elseif SN > "FATE" then
									if SN < "FEARRESIST" then
										if SN < "FATECI" then
											if SN == "FATEC" then
												Result = CalcStat("MainC",L,N)
											end
										elseif SN > "FATECI" then
											if SN == "FATET" then
												Result = RoundDblDown(StatLinInter("PntMPFate","TraitPntSVital","ProgBFate","",L,N,0))
											end
										else
											Result = CalcStat("MainCI",L,N)
										end
									elseif SN > "FEARRESIST" then
										if SN < "FINESSE" then
											if SN == "FEARRESISTT" then
												Result = CalcStat("ResistAddT",L,N)
											end
										elseif SN > "FINESSE" then
											if SN == "FINESSEC" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("FinesseCI",CalcStat("FinesseCILvlFilter",N),N),0)
											end
										else
											Result = EquSng(StatLinInter("PntMPFinesse","ItemPntS","ProgBFinesse","AdjItem",L,N,0))
										end
									else
										Result = CalcStat("ResistAdd",L,N)
									end
								else
									Result = RoundDblDown(StatLinInter("PntMPFate","ItemPntSVital","ProgBFate","",L,N,0))
								end
							elseif SN > "FINESSECI" then
								if SN < "FINESSEPRATPC" then
									if SN < "FINESSEPPRAT" then
										if SN < "FINESSECIRAW" then
											if SN == "FINESSECILVLFILTER" then
												if 3 <= Lp and Lm <= 3 or 3.6 <= Lp and Lm <= 3.6 or 6.2 <= Lp and Lm <= 6.2 or 7.2 <= Lp and Lm <= 7.2 or 10.8 <= Lp and Lm <= 10.8 or 14.4 <= Lp and Lm <= 14.4 then
													Result = 515
												else
													Result = CalcStat("CreepILvlCurr",L)
												end
											end
										elseif SN > "FINESSECIRAW" then
											if SN == "FINESSECRAW" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("FinesseCIRaw",CalcStat("FinesseCILvlFilter",N),N),99)
											end
										else
											Result = StatLinInter("PntMPFinesseC","ItemPntS","ProgBFinesse","AdjCreepItem",L,N,4)
										end
									elseif SN > "FINESSEPPRAT" then
										if SN < "FINESSEPRATPA" then
											if SN == "FINESSEPRATP" then
												Result = CalcPercAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCap",L),N)
											end
										elseif SN > "FINESSEPRATPA" then
											if SN == "FINESSEPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatStandard")
											end
										else
											Result = 150
										end
									else
										Result = CalcRatAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCapR",L),N)
									end
								elseif SN > "FINESSEPRATPC" then
									if SN < "FIREMIT" then
										if SN < "FINESSEPRATPCAPR" then
											if SN == "FINESSEPRATPCAP" then
												Result = 50
											end
										elseif SN > "FINESSEPRATPCAPR" then
											if SN == "FINESSET" then
												Result = EquSng(StatLinInter("PntMPFinesseT","TraitPntS","ProgBFinesse","AdjTrait",L,N,0))
											end
										else
											Result = CalcStat("FinessePRatPB",L)*CalcStat("FinessePRatPC",L)
										end
									elseif SN > "FIREMIT" then
										if SN < "FOODNCMRBASEPROG" then
											if SN == "FIREMITT" then
												Result = CalcStat("DmgTypeMitT",L,N)
											end
										elseif SN > "FOODNCMRBASEPROG" then
											if SN == "FOODNCMRH" then
												Result = EquSng(CalcStat("FoodNCMRProg",L,1)*N)
											end
										else
											if Lm <= 1 then
												Result = (N*70.2+210)/60
											elseif Lm <= 2 then
												Result = (N*84+216)/120
											else
												Result = (N*83.7+270)/90
											end
										end
									else
										Result = CalcStat("DmgTypeMit",L,N)
									end
								else
									Result = 0.5
								end
							else
								Result = RoundDblLotro(CalcStat("FinesseCIRaw",L,N))
							end
						elseif SN > "FOODNCMRL" then
							if SN < "FREEPAUDACITYRNGREDP" then
								if SN < "FOODRESIST" then
									if SN < "FOODNCPRH" then
										if SN < "FOODNCMRPROG" then
											if SN == "FOODNCMRM" then
												Result = EquSng(CalcStat("FoodNCMRProg",L,3)*N)
											end
										elseif SN > "FOODNCMRPROG" then
											if SN == "FOODNCPRBASEPROG" then
												if Lm <= 1 then
													Result = (N*75+300)/60
												elseif Lm <= 2 then
													Result = (N*100+350)/120
												else
													Result = (N*90+337.5)/90
												end
											end
										else
											if Lm <= 50 then
												Result = CalcStat("FoodNCMRBaseProg",N,L)
											elseif Lm <= 52 then
												Result = CalcStat("FoodNCMRBaseProg",N,50)
											elseif Lm <= 77 then
												Result = CalcStat("FoodNCMRBaseProg",N,L-3)
											elseif Lm <= 111 then
												Result = CalcStat("FoodNCMRBaseProg",N,RoundDbl((L+143)/3))
											elseif Lm <= 140 then
												Result = CalcStat("FoodNCMRBaseProg",N,85)
											elseif Lm <= 217 then
												Result = CalcStat("FoodNCMRBaseProg",N,RoundDbl((L+200)/4))
											elseif Lm <= 221 then
												Result = CalcStat("FoodNCMRBaseProg",N,104)
											elseif Lm <= 299 then
												Result = CalcStat("FoodNCMRBaseProg",N,105)
											elseif Lm <= 320 then
												Result = CalcStat("FoodNCMRBaseProg",N,RoundDbl((L-53)/(7/3)))
											elseif Lm <= 325 then
												Result = CalcStat("FoodNCMRBaseProg",N,114)
											elseif Lm <= 326 then
												Result = CalcStat("FoodNCMRBaseProg",N,115)
											elseif 327 <= Lp then
												Result = ExpFmod(CalcStat("FoodNCMRProg",326,N),327,1,L,1)
											end
										end
									elseif SN > "FOODNCPRH" then
										if SN < "FOODNCPRM" then
											if SN == "FOODNCPRL" then
												Result = EquSng(CalcStat("FoodNCPRProg",L,2)*N)
											end
										elseif SN > "FOODNCPRM" then
											if SN == "FOODNCPRPROG" then
												if Lm <= 1 then
													Result = CalcStat("FoodNCPRBaseProg",N,L)
												elseif Lm <= 6 then
													Result = CalcStat("FoodNCPRBaseProg",N,L)-0.25
												elseif Lm <= 24 then
													Result = CalcStat("FoodNCPRBaseProg",N,L)-0.5
												elseif Lm <= 48 then
													Result = CalcStat("FoodNCPRBaseProg",N,L)-0.75
												elseif Lm <= 61 then
													Result = RoundDblDown(CalcStat("FoodNCPRProg",48,N))+1
												elseif Lm <= 66 then
													Result = RoundDblDown(CalcStat("FoodNCPRProg",48,N))+2
												elseif Lm <= 72 then
													Result = RoundDblDown(CalcStat("FoodNCPRProg",48,N))+3
												elseif Lm <= 326 then
													Result = RoundDblDown(CalcStat("FoodNCPRProg",48,N))+4
												elseif 327 <= Lp then
													Result = ExpFmod(CalcStat("FoodNCPRProg",326,N),327,1,L,1)
												end
											end
										else
											Result = EquSng(CalcStat("FoodNCPRProg",L,3)*N)
										end
									else
										Result = EquSng(CalcStat("FoodNCPRProg",L,1)*N)
									end
								elseif SN > "FOODRESIST" then
									if SN < "FREEPAUDACITYMELREDP" then
										if SN < "FREEPAUDACITYDMGP" then
											if SN == "FREEPAUDACITYCCDP" then
												if 1 <= Lp and Lm <= 16 then
													Result = 0.5
												elseif 17 <= Lp and Lm <= 36 then
													Result = 0.4
												elseif 37 <= Lp and Lm <= 60 then
													Result = CalcStat("FreepAudacityCCDP",36)
												end
											end
										elseif SN > "FREEPAUDACITYDMGP" then
											if SN == "FREEPAUDACITYMELDMGP" then
												Result = CalcStat("FreepAudacityDmgP",L)
											end
										else
											if 1 <= Lp and Lm <= 16 then
												Result = 0.75
											elseif 17 <= Lp and Lm <= 36 then
												Result = LinFmod(1,1.15,1.25,17,36,L)
											elseif 37 <= Lp and Lm <= 60 then
												Result = CalcStat("FreepAudacityDmgP",36)
											end
										end
									elseif SN > "FREEPAUDACITYMELREDP" then
										if SN < "FREEPAUDACITYREDP" then
											if SN == "FREEPAUDACITYMORALEP" then
												if 1 <= Lp and Lm <= 16 then
													Result = LinFmod(1,0.5,1.3,1,16,L)
												elseif 17 <= Lp and Lm <= 36 then
													Result = 1.4
												elseif 37 <= Lp and Lm <= 60 then
													Result = CalcStat("FreepAudacityMoraleP",36)
												end
											end
										elseif SN > "FREEPAUDACITYREDP" then
											if SN == "FREEPAUDACITYRNGDMGP" then
												Result = CalcStat("FreepAudacityDmgP",L)
											end
										else
											if 1 <= Lp and Lm <= 16 then
												Result = 1.5
											elseif 17 <= Lp and Lm <= 36 then
												Result = 0.5
											elseif 37 <= Lp and Lm <= 60 then
												Result = CalcStat("FreepAudacityRedP",36)
											end
										end
									else
										Result = CalcStat("FreepAudacityRedP",L)
									end
								else
									Result = EquSng(StatLinInter("PntMPFoodResist","ItemPntS","ProgBResist","AdjItem",L,N,0))
								end
							elseif SN > "FREEPAUDACITYRNGREDP" then
								if SN < "FREEPBATPROMTACDMGP" then
									if SN < "FREEPBATPROMHEALTHP" then
										if SN < "FREEPAUDACITYTACREDP" then
											if SN == "FREEPAUDACITYTACDMGP" then
												Result = CalcStat("FreepAudacityDmgP",L)
											end
										elseif SN > "FREEPAUDACITYTACREDP" then
											if SN == "FREEPBATPROMDMGP" then
												if 1 <= Lp and Lm <= 1 then
													Result = 0.005
												elseif 2 <= Lp and Lm <= 14 then
													Result = LinFmod(1,0.005,0.065,2,14,L)
												elseif 15 <= Lp and Lm <= 15 then
													Result = 0.075
												end
											end
										else
											Result = CalcStat("FreepAudacityRedP",L)
										end
									elseif SN > "FREEPBATPROMHEALTHP" then
										if SN < "FREEPBATPROMPOWERP" then
											if SN == "FREEPBATPROMMELDMGP" then
												Result = CalcStat("FreepBatPromDmgP",L)
											end
										elseif SN > "FREEPBATPROMPOWERP" then
											if SN == "FREEPBATPROMRNGDMGP" then
												Result = CalcStat("FreepBatPromDmgP",L)
											end
										else
											Result = CalcStat("FreepBatPromVitalP",L)
										end
									else
										Result = CalcStat("FreepBatPromVitalP",L)
									end
								elseif SN > "FREEPBATPROMTACDMGP" then
									if SN < "GRDCRITDEF" then
										if SN < "FROSTMIT" then
											if SN == "FREEPBATPROMVITALP" then
												if 1 <= Lp and Lm <= 5 then
													Result = LinFmod(1,1.02,1.1,1,5,L)
												elseif 6 <= Lp and Lm <= 10 then
													Result = LinFmod(1,1.1,1.15,5,10,L)
												elseif 11 <= Lp and Lm <= 15 then
													Result = LinFmod(1,1.15,1.2,10,15,L)
												end
											end
										elseif SN > "FROSTMIT" then
											if SN == "FROSTMITT" then
												Result = CalcStat("DmgTypeMitT",L,N)
											end
										else
											Result = CalcStat("DmgTypeMit",L,N)
										end
									elseif SN > "GRDCRITDEF" then
										if SN < "GRDTENDERIZECRITHIT" then
											if SN == "GRDRELENTLASSFINESSE" then
												Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.2)
											end
										elseif SN > "GRDTENDERIZECRITHIT" then
											if SN == "GRDTENDERIZET2CRITHIT" then
												Result = CalcStat("CritHitT",L,CalcStat("Trait12345Choice",N)*0.4)
											end
										else
											Result = CalcStat("CritHitT",L,CalcStat("Trait12345Choice",N)*0.2)
										end
									else
										Result = CalcStat("CritDef",L)
									end
								else
									Result = CalcStat("FreepBatPromDmgP",L)
								end
							else
								Result = CalcStat("FreepAudacityRedP",L)
							end
						else
							Result = EquSng(CalcStat("FoodNCMRProg",L,2)*N)
						end
					elseif SN > "GRDTENDERIZET3CRITHIT" then
						if SN < "GUARDIANCDMIGHTTOCRITHIT" then
							if SN < "GUARDIANCDBASEICPR" then
								if SN < "GUARDIANCDAGILITYTOPHYMAS" then
									if SN < "GUARDIANCDAGILITYTOCRITHIT" then
										if SN < "GRDTENDERIZET5CRITHIT" then
											if SN == "GRDTENDERIZET4CRITHIT" then
												Result = CalcStat("CritHitT",L,CalcStat("Trait47101316Choice",N)*0.2)
											end
										elseif SN > "GRDTENDERIZET5CRITHIT" then
											if SN == "GRDWARDTACTTACMIT" then
												Result = CalcStat("TacMitT",L,CalcStat("Trait12345Choice",N)*0.2)
											end
										else
											Result = CalcStat("CritHitT",L,CalcStat("Trait58121620Choice",N)*0.2)
										end
									elseif SN > "GUARDIANCDAGILITYTOCRITHIT" then
										if SN < "GUARDIANCDAGILITYTOOUTHEAL" then
											if SN == "GUARDIANCDAGILITYTOFINESSE" then
												Result = 1
											end
										elseif SN > "GUARDIANCDAGILITYTOOUTHEAL" then
											if SN == "GUARDIANCDAGILITYTOPARRY" then
												Result = 1
											end
										else
											Result = 2
										end
									else
										Result = 2
									end
								elseif SN > "GUARDIANCDAGILITYTOPHYMAS" then
									if SN < "GUARDIANCDARMOURTYPE" then
										if SN < "GUARDIANCDARMOURTONONPHYMIT" then
											if SN == "GUARDIANCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "GUARDIANCDARMOURTONONPHYMIT" then
											if SN == "GUARDIANCDARMOURTOTACMIT" then
												Result = 0.2
											end
										else
											Result = 0.2
										end
									elseif SN > "GUARDIANCDARMOURTYPE" then
										if SN < "GUARDIANCDBASEFATE" then
											if SN == "GUARDIANCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityM",L)
											end
										elseif SN > "GUARDIANCDBASEFATE" then
											if SN == "GUARDIANCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRH",L)
											end
										else
											Result = CalcStat("ClassBaseFate",L)
										end
									else
										Result = 3
									end
								else
									Result = 2
								end
							elseif SN > "GUARDIANCDBASEICPR" then
								if SN < "GUARDIANCDCALCTYPECOMPHYMIT" then
									if SN < "GUARDIANCDBASENCPR" then
										if SN < "GUARDIANCDBASEMORALE" then
											if SN == "GUARDIANCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightH",L)
											end
										elseif SN > "GUARDIANCDBASEMORALE" then
											if SN == "GUARDIANCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRH",L)
											end
										else
											Result = CalcStat("ClassBaseMorale",L)
										end
									elseif SN > "GUARDIANCDBASENCPR" then
										if SN < "GUARDIANCDBASEVITALITY" then
											if SN == "GUARDIANCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										elseif SN > "GUARDIANCDBASEVITALITY" then
											if SN == "GUARDIANCDBASEWILL" then
												Result = CalcStat("ClassBaseWillL",L)
											end
										else
											Result = CalcStat("ClassBaseVitality",L)
										end
									else
										Result = CalcStat("ClassBaseNCPR",L)
									end
								elseif SN > "GUARDIANCDCALCTYPECOMPHYMIT" then
									if SN < "GUARDIANCDFATETONCPR" then
										if SN < "GUARDIANCDCALCTYPETACMIT" then
											if SN == "GUARDIANCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										elseif SN > "GUARDIANCDCALCTYPETACMIT" then
											if SN == "GUARDIANCDCANBLOCK" then
												Result = 1
											end
										else
											Result = 27
										end
									elseif SN > "GUARDIANCDFATETONCPR" then
										if SN < "GUARDIANCDHASPOWER" then
											if SN == "GUARDIANCDFATETOPOWER" then
												Result = 1
											end
										elseif SN > "GUARDIANCDHASPOWER" then
											if SN == "GUARDIANCDMIGHTTOBLOCK" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 0.07
									end
								else
									Result = 14
								end
							else
								Result = CalcStat("ClassBaseICPR",L)
							end
						elseif SN > "GUARDIANCDMIGHTTOCRITHIT" then
							if SN < "GUARDIANCDWILLTORESIST" then
								if SN < "GUARDIANCDTACMASTOOUTHEAL" then
									if SN < "GUARDIANCDMIGHTTOPHYMIT" then
										if SN < "GUARDIANCDMIGHTTOPARRY" then
											if SN == "GUARDIANCDMIGHTTOOUTHEAL" then
												Result = 3
											end
										elseif SN > "GUARDIANCDMIGHTTOPARRY" then
											if SN == "GUARDIANCDMIGHTTOPHYMAS" then
												Result = 3
											end
										else
											Result = 2
										end
									elseif SN > "GUARDIANCDMIGHTTOPHYMIT" then
										if SN < "GUARDIANCDPHYMITTOCOMPHYMIT" then
											if SN == "GUARDIANCDMIGHTTOTACMIT" then
												Result = 1
											end
										elseif SN > "GUARDIANCDPHYMITTOCOMPHYMIT" then
											if SN == "GUARDIANCDPHYMITTONONPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "GUARDIANCDTACMASTOOUTHEAL" then
									if SN < "GUARDIANCDWILLTOFINESSE" then
										if SN < "GUARDIANCDVITALITYTOMORALE" then
											if SN == "GUARDIANCDVITALITYTOICMR" then
												Result = 0.012
											end
										elseif SN > "GUARDIANCDVITALITYTOMORALE" then
											if SN == "GUARDIANCDVITALITYTONCMR" then
												Result = 0.12
											end
										else
											Result = 4.5
										end
									elseif SN > "GUARDIANCDWILLTOFINESSE" then
										if SN < "GUARDIANCDWILLTOPHYMAS" then
											if SN == "GUARDIANCDWILLTOOUTHEAL" then
												Result = 1
											end
										elseif SN > "GUARDIANCDWILLTOPHYMAS" then
											if SN == "GUARDIANCDWILLTOPHYMIT" then
												Result = 1.5
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								else
									Result = 1
								end
							elseif SN > "GUARDIANCDWILLTORESIST" then
								if SN < "HIGHELFRDPSVONEWILL" then
									if SN < "HELFPEACEELDARNCMR" then
										if SN < "HELFFADINGFIRSTBORNFATE" then
											if SN == "GUARDIANCDWILLTOTACMIT" then
												Result = 1.5
											end
										elseif SN > "HELFFADINGFIRSTBORNFATE" then
											if SN == "HELFPEACEELDARMORALE" then
												Result = CalcStat("MoraleT",L,1.0)
											end
										else
											Result = -CalcStat("FateT",L,0.4)
										end
									elseif SN > "HELFPEACEELDARNCMR" then
										if SN < "HELFTHOSEWHOREMAINWILL" then
											if SN == "HELFSORROWUNDYINGWILL" then
												Result = -CalcStat("WillT",L,0.4)
											end
										elseif SN > "HELFTHOSEWHOREMAINWILL" then
											if SN == "HIGHELFRDPSVONENAME" then
												Result = "Those Who Remain"
											end
										else
											Result = CalcStat("WillT",L,1.0)
										end
									else
										Result = CalcStat("NCMRT",L,0.6)
									end
								elseif SN > "HIGHELFRDPSVONEWILL" then
									if SN < "HIGHELFRDTRAITNCMR" then
										if SN < "HIGHELFRDTRAITFATE" then
											if SN == "HIGHELFRDPSVTWONAME" then
												Result = ""
											end
										elseif SN > "HIGHELFRDTRAITFATE" then
											if SN == "HIGHELFRDTRAITMORALE" then
												Result = CalcStat("HElfPeaceEldarMorale",L)
											end
										else
											Result = CalcStat("HElfFadingFirstbornFate",L)
										end
									elseif SN > "HIGHELFRDTRAITNCMR" then
										if SN < "HNTARMOURRENDBLOCK" then
											if SN == "HIGHELFRDTRAITWILL" then
												Result = CalcStat("HElfSorrowUndyingWill",L)
											end
										elseif SN > "HNTARMOURRENDBLOCK" then
											if SN == "HNTARMOURRENDEVADE" then
												Result = -CalcStat("EvadeT",L,CalcStat("Trait23456Choice",N)*0.4)
											end
										else
											Result = -CalcStat("ShieldBlock",L,CalcStat("Trait23456Choice",N)*0.4)
										end
									else
										Result = CalcStat("HElfPeaceEldarNCMR",L)
									end
								else
									Result = CalcStat("HElfThoseWhoRemainWill",L)
								end
							else
								Result = 1
							end
						else
							Result = 1
						end
					else
						Result = CalcStat("CritHitT",L,CalcStat("Trait357912Choice",N)*0.2)
					end
				else
					Result = CalcStat("BPEPPRat",L,N)
				end
			elseif SN > "HNTARMOURRENDPARRY" then
				if SN < "LOREMASTERCDBASEFATE" then
					if SN < "HUNTERCDWILLTORESIST" then
						if SN < "HUNTERCDBASEFATE" then
							if SN < "HOBHOBBITTOUGHNVITALITY" then
								if SN < "HNTSTRENGTHSTANCECRITHIT" then
									if SN < "HNTPRECISIONSTANCEFINESSE" then
										if SN < "HNTCAMPFIRENCMR" then
											if SN == "HNTBREACHFINDERRNGMIT" then
												Result = (-20)*L
											end
										elseif SN > "HNTCAMPFIRENCMR" then
											if SN == "HNTCAMPFIRENCPR" then
												Result = CalcStat("NCPRT",L,1.2)
											end
										else
											Result = CalcStat("NCMRT",L,1.2)
										end
									elseif SN > "HNTPRECISIONSTANCEFINESSE" then
										if SN < "HNTRAPIDFIREPHYMAS" then
											if SN == "HNTPURGEPOISONRESIST" then
												Result = CalcStat("PoisonResistT",L,4)
											end
										elseif SN > "HNTRAPIDFIREPHYMAS" then
											if SN == "HNTRAPIDFIRESEL" then
												if 1 <= Lp and Lm <= 8 then
													Result = L+2
												elseif 9 <= Lp and Lm <= 10 then
													Result = 2*L-6
												end
											end
										else
											Result = CalcStat("PhyMasT",L,CalcStat("HntRapidFireSel",N)*0.2)
										end
									else
										Result = CalcStat("FinesseT",L,1.6)
									end
								elseif SN > "HNTSTRENGTHSTANCECRITHIT" then
									if SN < "HOBBITRDTRAITMIGHT" then
										if SN < "HOBBITRDPSVONENAME" then
											if SN == "HOBBITRDPSVONEMIGHT" then
												Result = CalcStat("HobHobbitStatureMight",L)
											end
										elseif SN > "HOBBITRDPSVONENAME" then
											if SN == "HOBBITRDPSVTWONAME" then
												Result = ""
											end
										else
											Result = "Hobbit-stature"
										end
									elseif SN > "HOBBITRDTRAITMIGHT" then
										if SN < "HOBBITRDTRAITVITALITY" then
											if SN == "HOBBITRDTRAITNCMR" then
												Result = CalcStat("HobRapidRecoveryNCMR",L)
											end
										elseif SN > "HOBBITRDTRAITVITALITY" then
											if SN == "HOBHOBBITSTATUREMIGHT" then
												Result = CalcStat("MightT",L,1.0)
											end
										else
											Result = CalcStat("HobHobbitToughnVitality",L)
										end
									else
										Result = CalcStat("HobSmallSizeMight",L)
									end
								else
									Result = CalcStat("CritHitT",L,4)
								end
							elseif SN > "HOBHOBBITTOUGHNVITALITY" then
								if SN < "HUNTERCDAGILITYTOPHYMAS" then
									if SN < "HUNTERCDAGILITYTOCRITHIT" then
										if SN < "HOBSMALLSIZEMIGHT" then
											if SN == "HOBRAPIDRECOVERYNCMR" then
												Result = CalcStat("NCMRT",L,0.6)
											end
										elseif SN > "HOBSMALLSIZEMIGHT" then
											if SN == "HOPEMORALEP" then
												if Lm <= 5 then
													Result = DataTableValue({-0.99,-0.97,-0.95,-0.9,-0.85,-0.8,-0.65,-0.6,-0.5,-0.4,-0.3,-0.2,-0.15,-0.1,-0.05,0,0.01,0.02,0.03,0.04,0.05},L+16)
												else
													Result = CalcStat("HopeMoraleP",5)
												end
											end
										else
											Result = -CalcStat("MightT",L,0.4)
										end
									elseif SN > "HUNTERCDAGILITYTOCRITHIT" then
										if SN < "HUNTERCDAGILITYTOOUTHEAL" then
											if SN == "HUNTERCDAGILITYTOEVADE" then
												Result = 2
											end
										elseif SN > "HUNTERCDAGILITYTOOUTHEAL" then
											if SN == "HUNTERCDAGILITYTOPARRY" then
												Result = 1
											end
										else
											Result = 3
										end
									else
										Result = 1
									end
								elseif SN > "HUNTERCDAGILITYTOPHYMAS" then
									if SN < "HUNTERCDARMOURTONONPHYMIT" then
										if SN < "HUNTERCDAGILITYTOTACMIT" then
											if SN == "HUNTERCDAGILITYTOPHYMIT" then
												Result = 1
											end
										elseif SN > "HUNTERCDAGILITYTOTACMIT" then
											if SN == "HUNTERCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "HUNTERCDARMOURTONONPHYMIT" then
										if SN < "HUNTERCDARMOURTYPE" then
											if SN == "HUNTERCDARMOURTOTACMIT" then
												Result = 0.2
											end
										elseif SN > "HUNTERCDARMOURTYPE" then
											if SN == "HUNTERCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityH",L)
											end
										else
											Result = 2
										end
									else
										Result = 0.2
									end
								else
									Result = 3
								end
							else
								Result = CalcStat("VitalityT",L,1.0)
							end
						elseif SN > "HUNTERCDBASEFATE" then
							if SN < "HUNTERCDMIGHTTOCRITHIT" then
								if SN < "HUNTERCDBASEVITALITY" then
									if SN < "HUNTERCDBASEMORALE" then
										if SN < "HUNTERCDBASEICPR" then
											if SN == "HUNTERCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRM",L)
											end
										elseif SN > "HUNTERCDBASEICPR" then
											if SN == "HUNTERCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightM",L)
											end
										else
											Result = CalcStat("ClassBaseICPR",L)
										end
									elseif SN > "HUNTERCDBASEMORALE" then
										if SN < "HUNTERCDBASENCPR" then
											if SN == "HUNTERCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRM",L)
											end
										elseif SN > "HUNTERCDBASENCPR" then
											if SN == "HUNTERCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										else
											Result = CalcStat("ClassBaseNCPR",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								elseif SN > "HUNTERCDBASEVITALITY" then
									if SN < "HUNTERCDCALCTYPETACMIT" then
										if SN < "HUNTERCDCALCTYPECOMPHYMIT" then
											if SN == "HUNTERCDBASEWILL" then
												Result = CalcStat("ClassBaseWillL",L)
											end
										elseif SN > "HUNTERCDCALCTYPECOMPHYMIT" then
											if SN == "HUNTERCDCALCTYPENONPHYMIT" then
												Result = 13
											end
										else
											Result = 13
										end
									elseif SN > "HUNTERCDCALCTYPETACMIT" then
										if SN < "HUNTERCDFATETOPOWER" then
											if SN == "HUNTERCDFATETONCPR" then
												Result = 0.07
											end
										elseif SN > "HUNTERCDFATETOPOWER" then
											if SN == "HUNTERCDHASPOWER" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 26
									end
								else
									Result = CalcStat("ClassBaseVitality",L)
								end
							elseif SN > "HUNTERCDMIGHTTOCRITHIT" then
								if SN < "HUNTERCDVITALITYTOICMR" then
									if SN < "HUNTERCDMIGHTTOPHYMAS" then
										if SN < "HUNTERCDMIGHTTOFINESSE" then
											if SN == "HUNTERCDMIGHTTOEVADE" then
												Result = 1
											end
										elseif SN > "HUNTERCDMIGHTTOFINESSE" then
											if SN == "HUNTERCDMIGHTTOOUTHEAL" then
												Result = 2
											end
										else
											Result = 1.5
										end
									elseif SN > "HUNTERCDMIGHTTOPHYMAS" then
										if SN < "HUNTERCDPHYMITTONONPHYMIT" then
											if SN == "HUNTERCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "HUNTERCDPHYMITTONONPHYMIT" then
											if SN == "HUNTERCDTACMASTOOUTHEAL" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 2
									end
								elseif SN > "HUNTERCDVITALITYTOICMR" then
									if SN < "HUNTERCDWILLTOFINESSE" then
										if SN < "HUNTERCDVITALITYTONCMR" then
											if SN == "HUNTERCDVITALITYTOMORALE" then
												Result = 4.5
											end
										elseif SN > "HUNTERCDVITALITYTONCMR" then
											if SN == "HUNTERCDWILLTOCRITHIT" then
												Result = 0.5
											end
										else
											Result = 0.12
										end
									elseif SN > "HUNTERCDWILLTOFINESSE" then
										if SN < "HUNTERCDWILLTOPHYMAS" then
											if SN == "HUNTERCDWILLTOOUTHEAL" then
												Result = 2
											end
										elseif SN > "HUNTERCDWILLTOPHYMAS" then
											if SN == "HUNTERCDWILLTOPHYMIT" then
												Result = 1
											end
										else
											Result = 2
										end
									else
										Result = 1.5
									end
								else
									Result = 0.012
								end
							else
								Result = 1.5
							end
						else
							Result = CalcStat("ClassBaseFate",L)
						end
					elseif SN > "HUNTERCDWILLTORESIST" then
						if SN < "INSTRPOWER" then
							if SN < "INDMGPRATP" then
								if SN < "ICPR" then
									if SN < "ICMRCILVLFILTER" then
										if SN < "ICMRC" then
											if SN == "ICMR" then
												Result = EquSng(StatLinInter("PntMPICMR","ItemPntSVital","ProgBICMR","",L,N,1))
											end
										elseif SN > "ICMRC" then
											if SN == "ICMRCI" then
												Result = RoundDblLotro(CalcStat("ICMRCIRaw",L,N))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ICMRCI",CalcStat("ICMRCILvlFilter",N),N),0)
										end
									elseif SN > "ICMRCILVLFILTER" then
										if SN < "ICMRCRAW" then
											if SN == "ICMRCIRAW" then
												Result = StatLinInter("PntMPICMRC","ItemPntS","ProgBICMR","AdjCreepItem",L,N,4)
											end
										elseif SN > "ICMRCRAW" then
											if SN == "ICMRT" then
												Result = EquSng(StatLinInter("PntMPICMR","TraitPntSVital","ProgBICMR","",L,N,1))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ICMRCIRaw",CalcStat("ICMRCILvlFilter",N),N),99)
										end
									else
										if 0 <= Lp and Lm <= 0 then
											Result = 515
										else
											Result = CalcStat("CreepILvlCurr",L)
										end
									end
								elseif SN > "ICPR" then
									if SN < "ICPRCIRAW" then
										if SN < "ICPRCI" then
											if SN == "ICPRC" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ICPRCI",CalcStat("ICPRCILvlFilter",N),N),0)
											end
										elseif SN > "ICPRCI" then
											if SN == "ICPRCILVLFILTER" then
												if 0 <= Lp and Lm <= 0 then
													Result = 515
												else
													Result = CalcStat("CreepILvlCurr",L)
												end
											end
										else
											Result = RoundDblLotro(CalcStat("ICPRCIRaw",L,N))
										end
									elseif SN > "ICPRCIRAW" then
										if SN < "ICPRT" then
											if SN == "ICPRCRAW" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ICPRCIRaw",CalcStat("ICPRCILvlFilter",N),N),99)
											end
										elseif SN > "ICPRT" then
											if SN == "INDMGPPRAT" then
												Result = CalcRatAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCapR",L),N)
											end
										else
											Result = EquSng(StatLinInter("PntMPICPR","TraitPntSVital","ProgBICPR","",L,N,99))
										end
									else
										Result = StatLinInter("PntMPICPRC","ItemPntS","ProgBICPR","AdjCreepItem",L,N,4)
									end
								else
									Result = EquSng(StatLinInter("PntMPICPR","ItemPntSVital","ProgBICPR","",L,N,99))
								end
							elseif SN > "INDMGPRATP" then
								if SN < "INHEALPRATP" then
									if SN < "INDMGPRATPCAP" then
										if SN < "INDMGPRATPB" then
											if SN == "INDMGPRATPA" then
												Result = 1200
											end
										elseif SN > "INDMGPRATPB" then
											if SN == "INDMGPRATPC" then
												Result = 0.5
											end
										else
											Result = CalcStat("BRatRounded",L,"BRatStandard")
										end
									elseif SN > "INDMGPRATPCAP" then
										if SN < "INHEAL" then
											if SN == "INDMGPRATPCAPR" then
												Result = CalcStat("InDmgPRatPB",L)*CalcStat("InDmgPRatPC",L)
											end
										elseif SN > "INHEAL" then
											if SN == "INHEALPPRAT" then
												Result = CalcRatAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCapR",L),N)
											end
										else
											Result = EquSng(StatLinInter("PntMPInHeal","ItemPntS","ProgBInHeal","AdjItem",L,N,0))
										end
									else
										Result = 400
									end
								elseif SN > "INHEALPRATP" then
									if SN < "INHEALPRATPCAP" then
										if SN < "INHEALPRATPB" then
											if SN == "INHEALPRATPA" then
												Result = 75
											end
										elseif SN > "INHEALPRATPB" then
											if SN == "INHEALPRATPC" then
												Result = 0.5
											end
										else
											Result = CalcStat("BRatRounded",L,"BRatStandard")
										end
									elseif SN > "INHEALPRATPCAP" then
										if SN < "INHEALT" then
											if SN == "INHEALPRATPCAPR" then
												Result = CalcStat("InHealPRatPB",L)*CalcStat("InHealPRatPC",L)
											end
										elseif SN > "INHEALT" then
											if SN == "INSTRMORALE" then
												if Lm <= 105 then
													Result = RoundDbl(4.04*L)
												else
													Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("InstrMorale",105))
												end
											end
										else
											Result = EquSng(StatLinInter("PntMPInHeal","TraitPntS","ProgBInHeal","AdjTrait",L,N,0))
										end
									else
										Result = 25
									end
								else
									Result = CalcPercAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCap",L),N)
								end
							else
								Result = CalcPercAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCap",L),N)
							end
						elseif SN > "INSTRPOWER" then
							if SN < "LMHEARTYDIETMORALECHOICE" then
								if SN < "LI2ILVLCAP" then
									if SN < "ITEMPNTSVIRTUEMORALE" then
										if SN < "ITEMPNTSCLASSIC" then
											if SN == "ITEMPNTS" then
												Result = {{1,25,50,79,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599},{1,25,50,75,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160}}
											end
										elseif SN > "ITEMPNTSCLASSIC" then
											if SN == "ITEMPNTSVIRTUEMASTERY" then
												Result = {{0,1,25,50,79,80,200,225,300,349,399,400,449,450,499,500,549,550,599},{0,1,25,50,75,76,100,105,106,115,116,121,130,131,140,141,150,151,160}}
											end
										else
											Result = {{1,25,50,60,79,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599},{1,25,50,60,75,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160}}
										end
									elseif SN > "ITEMPNTSVIRTUEMORALE" then
										if SN < "L" then
											if SN == "ITEMPNTSVITAL" then
												Result = {{1,25,50,60,79,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599},{1,25,50,60,75,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160}}
											end
										elseif SN > "L" then
											if SN == "LEVELCAP" then
												Result = 150
											end
										else
											Result = L
										end
									else
										Result = {{0,1,2,50,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599},{0,1,2,50,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160}}
									end
								elseif SN > "LI2ILVLCAP" then
									if SN < "LIGHTNINGMIT" then
										if SN < "LIGHTMIT" then
											if SN == "LI2REFORGEILVL" then
												if Lm <= 145 then
													Result = CalcStat("AwardILvlI",L)
												else
													Result = N
												end
											end
										elseif SN > "LIGHTMIT" then
											if SN == "LIGHTMITT" then
												Result = CalcStat("DmgTypeMitT",L,N)
											end
										else
											Result = CalcStat("DmgTypeMit",L,N)
										end
									elseif SN > "LIGHTNINGMIT" then
										if SN < "LMANCIENTWISDOMWILL" then
											if SN == "LIGHTNINGMITT" then
												Result = CalcStat("DmgTypeMitT",L,N)
											end
										elseif SN > "LMANCIENTWISDOMWILL" then
											if SN == "LMHEARTYDIETMORALE" then
												Result = CalcStat("Morale",L,CalcStat("LmHeartyDietMoraleChoice",N))
											end
										else
											if Lm <= 105 then
												Result = RoundDbl(1.1*L)
											else
												Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("LmAncientWisdomWill",105))
											end
										end
									else
										Result = CalcStat("DmgTypeMit",L,N)
									end
								else
									Result = 530
								end
							elseif SN > "LMHEARTYDIETMORALECHOICE" then
								if SN < "LOREMASTERCDAGILITYTOEVADE" then
									if SN < "LMSWSTAFFBUGPARRYOLD" then
										if SN < "LMSWSTAFFBUGMORALE" then
											if SN == "LMPREPFORWARTACMAS" then
												Result = CalcStat("TacMasT",L,CalcStat("Trait12345Choice",N)*0.4)
											end
										elseif SN > "LMSWSTAFFBUGMORALE" then
											if SN == "LMSWSTAFFBUGPARRY" then
												if Lm <= 140 then
													Result = CalcStat("U371LegacyStatFix",L,"LmSwStaffBugParryOld")
												else
													Result = CalcStat("LMSwStaffBugParry",140)
												end
											end
										else
											if Lm <= 105 then
												Result = RoundDbl(LinFmod(1,16.2,696.9,1,105,L))
											else
												Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("LmSwStaffBugMorale",105))
											end
										end
									elseif SN > "LMSWSTAFFBUGPARRYOLD" then
										if SN < "LOEPASSIVE" then
											if SN == "LOE" then
												Result = 2*N
											end
										elseif SN > "LOEPASSIVE" then
											if SN == "LOREMASTERCDAGILITYTOCRITHIT" then
												Result = 2
											end
										else
											if 116 <= Lp and Lm <= 119 then
												Result = 20*L-2300
											elseif 120 <= Lp then
												Result = CalcStat("LoEPassive",119)
											end
										end
									else
										if Lm <= 105 then
											Result = RoundDbl(44.44*L)
										else
											Result = CalcStat("ProgExtHighLinExpRnd",L,CalcStat("LmSwStaffBugParryOld",105))
										end
									end
								elseif SN > "LOREMASTERCDAGILITYTOEVADE" then
									if SN < "LOREMASTERCDARMOURTONONPHYMIT" then
										if SN < "LOREMASTERCDAGILITYTOTACMAS" then
											if SN == "LOREMASTERCDAGILITYTOFINESSE" then
												Result = 1
											end
										elseif SN > "LOREMASTERCDAGILITYTOTACMAS" then
											if SN == "LOREMASTERCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 2
										end
									elseif SN > "LOREMASTERCDARMOURTONONPHYMIT" then
										if SN < "LOREMASTERCDARMOURTYPE" then
											if SN == "LOREMASTERCDARMOURTOTACMIT" then
												Result = 0.2
											end
										elseif SN > "LOREMASTERCDARMOURTYPE" then
											if SN == "LOREMASTERCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityL",L)
											end
										else
											Result = 1
										end
									else
										Result = 0.2
									end
								else
									Result = 1
								end
							else
								if 1 <= Lp and Lm <= 6 then
									Result = DataTableValue({0.4,1,1.6,2.4,3.2,3.2},L)
								end
							end
						else
							if Lm <= 9 then
								Result = RoundDbl(0.95*L+12.6)
							elseif Lm <= 18 then
								Result = RoundDbl(1.95*L+3)
							elseif Lm <= 26 then
								Result = RoundDbl(2.95*L-15.55)
							elseif Lm <= 35 then
								Result = RoundDbl(3.95*L-42.15)
							elseif Lm <= 42 then
								Result = RoundDbl(4.95*L-77.7)
							elseif Lm <= 45 then
								Result = RoundDbl(5.95*L-120.35)
							elseif Lm <= 105 then
								Result = RoundDbl(6*L-124)
							else
								Result = CalcStat("ProgExtMpExpRnd",L,CalcStat("InstrPower",105))
							end
						end
					else
						Result = 1
					end
				elseif SN > "LOREMASTERCDBASEFATE" then
					if SN < "MARINERCDAGILITYTOPHYMAS" then
						if SN < "LVLBONUSMORRES" then
							if SN < "LOREMASTERCDMIGHTTOCRITHIT" then
								if SN < "LOREMASTERCDBASEVITALITY" then
									if SN < "LOREMASTERCDBASEMORALE" then
										if SN < "LOREMASTERCDBASEICPR" then
											if SN == "LOREMASTERCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRL",L)
											end
										elseif SN > "LOREMASTERCDBASEICPR" then
											if SN == "LOREMASTERCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightM",L)
											end
										else
											Result = CalcStat("ClassBaseICPR",L)
										end
									elseif SN > "LOREMASTERCDBASEMORALE" then
										if SN < "LOREMASTERCDBASENCPR" then
											if SN == "LOREMASTERCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRL",L)
											end
										elseif SN > "LOREMASTERCDBASENCPR" then
											if SN == "LOREMASTERCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										else
											Result = CalcStat("ClassBaseNCPR",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								elseif SN > "LOREMASTERCDBASEVITALITY" then
									if SN < "LOREMASTERCDCALCTYPETACMIT" then
										if SN < "LOREMASTERCDCALCTYPECOMPHYMIT" then
											if SN == "LOREMASTERCDBASEWILL" then
												Result = CalcStat("ClassBaseWillH",L)
											end
										elseif SN > "LOREMASTERCDCALCTYPECOMPHYMIT" then
											if SN == "LOREMASTERCDCALCTYPENONPHYMIT" then
												Result = 12
											end
										else
											Result = 12
										end
									elseif SN > "LOREMASTERCDCALCTYPETACMIT" then
										if SN < "LOREMASTERCDFATETOPOWER" then
											if SN == "LOREMASTERCDFATETONCPR" then
												Result = 0.07
											end
										elseif SN > "LOREMASTERCDFATETOPOWER" then
											if SN == "LOREMASTERCDHASPOWER" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 25
									end
								else
									Result = CalcStat("ClassBaseVitality",L)
								end
							elseif SN > "LOREMASTERCDMIGHTTOCRITHIT" then
								if SN < "LOREMASTERCDVITALITYTOMORALE" then
									if SN < "LOREMASTERCDPHYMITTOCOMPHYMIT" then
										if SN < "LOREMASTERCDMIGHTTOPARRY" then
											if SN == "LOREMASTERCDMIGHTTOFINESSE" then
												Result = 1.5
											end
										elseif SN > "LOREMASTERCDMIGHTTOPARRY" then
											if SN == "LOREMASTERCDMIGHTTOTACMAS" then
												Result = 2
											end
										else
											Result = 1
										end
									elseif SN > "LOREMASTERCDPHYMITTOCOMPHYMIT" then
										if SN < "LOREMASTERCDTACMASTOOUTHEAL" then
											if SN == "LOREMASTERCDPHYMITTONONPHYMIT" then
												Result = 1
											end
										elseif SN > "LOREMASTERCDTACMASTOOUTHEAL" then
											if SN == "LOREMASTERCDVITALITYTOICMR" then
												Result = 0.012
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "LOREMASTERCDVITALITYTOMORALE" then
									if SN < "LOREMASTERCDWILLTOPHYMIT" then
										if SN < "LOREMASTERCDWILLTOCRITHIT" then
											if SN == "LOREMASTERCDVITALITYTONCMR" then
												Result = 0.12
											end
										elseif SN > "LOREMASTERCDWILLTOCRITHIT" then
											if SN == "LOREMASTERCDWILLTOEVADE" then
												Result = 2
											end
										else
											Result = 1
										end
									elseif SN > "LOREMASTERCDWILLTOPHYMIT" then
										if SN < "LOREMASTERCDWILLTOTACMAS" then
											if SN == "LOREMASTERCDWILLTORESIST" then
												Result = 1
											end
										elseif SN > "LOREMASTERCDWILLTOTACMAS" then
											if SN == "LOREMASTERCDWILLTOTACMIT" then
												Result = 1
											end
										else
											Result = 3
										end
									else
										Result = 1
									end
								else
									Result = 4.5
								end
							else
								Result = 1.5
							end
						elseif SN > "LVLBONUSMORRES" then
							if SN < "MANFOURTHAGEWILL" then
								if SN < "MAINC" then
									if SN < "LVLEXPCOST" then
										if SN < "LVLBONUSPOWRES" then
											if SN == "LVLBONUSPHYDMG" then
												Result = EquSng(0.1)
											end
										elseif SN > "LVLBONUSPOWRES" then
											if SN == "LVLBONUSTACDMG" then
												Result = EquSng(0.1)
											end
										else
											Result = CalcStat("SkillPowerCost",L,N)
										end
									elseif SN > "LVLEXPCOST" then
										if SN < "LVLTOILVL" then
											if SN == "LVLEXPCOSTTOT" then
												if 1 <= Lp then
													Result = CalcStat("LvlExpCostTot",L-1)+CalcStat("LvlExpCost",L)
												end
											end
										elseif SN > "LVLTOILVL" then
											if SN == "MAIN" then
												Result = RoundDblDown(StatLinInter("PntMPMain","ItemPntS","ProgBMain","AdjItem",L,N,0))
											end
										else
											if Lm <= 106 then
												Result = LinFmod(1,225,300,105,106,L)
											elseif Lm <= 115 then
												Result = LinFmod(1,300,349,106,115,L)
											elseif Lm <= 116 then
												Result = LinFmod(1,349,350,115,116,L)
											elseif Lm <= 120 then
												Result = LinFmod(1,350,399,116,120,L)
											elseif Lm <= 121 then
												Result = LinFmod(1,399,400,120,121,L)
											elseif Lm <= 130 then
												Result = LinFmod(1,400,449,121,130,L)
											elseif Lm <= 131 then
												Result = LinFmod(1,449,450,130,131,L)
											elseif Lm <= 140 then
												Result = LinFmod(1,450,499,131,140,L)
											elseif Lm <= 141 then
												Result = LinFmod(1,499,500,140,141,L)
											else
												Result = LinFmod(1,500,549,141,150,L)
											end
										end
									else
										if Lm <= 1 then
											Result = 0
										elseif Lm <= 5 then
											Result = RoundDbl(12.5*L*L+12.5666666666667*L+24.8666666666667)
										elseif Lm <= 10 then
											Result = RoundDbl(33.8*L*L-179.48*L+452.6)
										elseif Lm <= 15 then
											Result = RoundDbl(55.05*L*L-583.77*L+2370.5)
										elseif Lm <= 20 then
											Result = RoundDbl(76.2*L*L-1196.96*L+6809)
										elseif Lm <= 25 then
											Result = RoundDbl(97.4*L*L-2023*L+14849.8)
										elseif Lm <= 30 then
											Result = RoundDbl(118.7*L*L-3066.02 *L+27612.8)
										elseif Lm <= 35 then
											Result = RoundDbl(139.95*L*L-4319.23*L+46084.1)
										elseif Lm <= 40 then
											Result = RoundDbl(161.2*L*L-5785.04*L+71356.2)
										elseif Lm <= 45 then
											Result = RoundDbl(182.5*L*L-7467.38*L+104569.8)
										elseif Lm <= 50 then
											Result = RoundDbl(203.8*L*L-9363.48*L+146761.8)
										elseif Lm <= 55 then
											Result = RoundDbl(225.05*L*L-11467.77*L+198851.3)
										elseif Lm <= 60 then
											Result = RoundDbl(246.3*L*L-13784.46*L+261988)
										elseif 61 <= Lp and Lm <= 70 then
											Result = RoundDbl(ExpFmod(CalcStat("LvlExpCost",60),61,5.071,L,nil,3.485))
										elseif 71 <= Lp and Lm <= 75 then
											Result = RoundDbl(ExpFmod(CalcStat("LvlExpCost",70),71,5.072,L,nil,-0.95))
										elseif 76 <= Lp then
											Result = ExpFmod(CalcStat("LvlExpCost",75),76,5,L,0,-0.5)
										end
									end
								elseif SN > "MAINC" then
									if SN < "MAINCRAW" then
										if SN < "MAINCILVLFILTER" then
											if SN == "MAINCI" then
												Result = RoundDblLotro(CalcStat("MainCIRaw",L,N))
											end
										elseif SN > "MAINCILVLFILTER" then
											if SN == "MAINCIRAW" then
												Result = StatLinInter("PntMPMainC","ItemPntS","ProgBMain","AdjCreepItem",L,N,4)
											end
										else
											if 0 <= Lp and Lm <= 0 then
												Result = 515
											else
												Result = CalcStat("CreepILvlCurr",L)
											end
										end
									elseif SN > "MAINCRAW" then
										if SN < "MANDIMMANKINDWILL" then
											if SN == "MAINT" then
												Result = RoundDblDown(StatLinInter("PntMPMain","TraitPntS","ProgBMain","AdjTrait",L,N,0))
											end
										elseif SN > "MANDIMMANKINDWILL" then
											if SN == "MANEASILYINSPINHEALP" then
												Result = 5
											end
										else
											Result = -CalcStat("WillT",L,0.4)
										end
									else
										Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("MainCIRaw",CalcStat("MainCILvlFilter",N),N),99)
									end
								else
									Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("MainCI",CalcStat("MainCILvlFilter",N),N),0)
								end
							elseif SN > "MANFOURTHAGEWILL" then
								if SN < "MANRDTRAITFATE" then
									if SN < "MANRDPSVTWOBLOCK" then
										if SN < "MANRDPSVONENAME" then
											if SN == "MANGIFTOFMENFATE" then
												Result = CalcStat("FateT",L,1.0)
											end
										elseif SN > "MANRDPSVONENAME" then
											if SN == "MANRDPSVONEWILL" then
												Result = CalcStat("ManFourthAgeWill",L)
											end
										else
											Result = "Man of the Fourth Age"
										end
									elseif SN > "MANRDPSVTWOBLOCK" then
										if SN < "MANRDPSVTWONAME" then
											if SN == "MANRDPSVTWOEVADE" then
												Result = CalcStat("BalanceOfManEvade",L)
											end
										elseif SN > "MANRDPSVTWONAME" then
											if SN == "MANRDPSVTWOPARRY" then
												Result = CalcStat("BalanceOfManParry",L)
											end
										else
											Result = "Balance of Man"
										end
									else
										Result = CalcStat("BalanceOfManBlock",L)
									end
								elseif SN > "MANRDTRAITFATE" then
									if SN < "MANSTRONGMENMIGHT" then
										if SN < "MANRDTRAITMIGHT" then
											if SN == "MANRDTRAITINHEALP" then
												Result = CalcStat("ManEasilyInspInHealP",L)
											end
										elseif SN > "MANRDTRAITMIGHT" then
											if SN == "MANRDTRAITWILL" then
												Result = CalcStat("ManDimMankindWill",L)
											end
										else
											Result = CalcStat("ManStrongMenMight",L)
										end
									elseif SN > "MANSTRONGMENMIGHT" then
										if SN < "MARINERCDAGILITYTOOUTHEAL" then
											if SN == "MARINERCDAGILITYTOCRITHIT" then
												Result = 1
											end
										elseif SN > "MARINERCDAGILITYTOOUTHEAL" then
											if SN == "MARINERCDAGILITYTOPARRY" then
												Result = 3
											end
										else
											Result = 3
										end
									else
										Result = CalcStat("MightT",L,1.0)
									end
								else
									Result = CalcStat("ManGiftOfMenFate",L)
								end
							else
								Result = CalcStat("WillT",L,1.0)
							end
						else
							Result = EquSng(0.1)
						end
					elseif SN > "MARINERCDAGILITYTOPHYMAS" then
						if SN < "MARINERCDVITALITYTOICMR" then
							if SN < "MARINERCDBASEVITALITY" then
								if SN < "MARINERCDBASEFATE" then
									if SN < "MARINERCDARMOURTONONPHYMIT" then
										if SN < "MARINERCDAGILITYTOTACMIT" then
											if SN == "MARINERCDAGILITYTOPHYMIT" then
												Result = 1
											end
										elseif SN > "MARINERCDAGILITYTOTACMIT" then
											if SN == "MARINERCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "MARINERCDARMOURTONONPHYMIT" then
										if SN < "MARINERCDARMOURTYPE" then
											if SN == "MARINERCDARMOURTOTACMIT" then
												Result = 0.2
											end
										elseif SN > "MARINERCDARMOURTYPE" then
											if SN == "MARINERCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityM",L)
											end
										else
											Result = 2
										end
									else
										Result = 0.2
									end
								elseif SN > "MARINERCDBASEFATE" then
									if SN < "MARINERCDBASEMORALE" then
										if SN < "MARINERCDBASEICPR" then
											if SN == "MARINERCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRL",L)
											end
										elseif SN > "MARINERCDBASEICPR" then
											if SN == "MARINERCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightM",L)
											end
										else
											Result = CalcStat("ClassBaseICPR",L)
										end
									elseif SN > "MARINERCDBASEMORALE" then
										if SN < "MARINERCDBASENCPR" then
											if SN == "MARINERCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRL",L)
											end
										elseif SN > "MARINERCDBASENCPR" then
											if SN == "MARINERCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										else
											Result = CalcStat("ClassBaseNCPR",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								else
									Result = CalcStat("ClassBaseFate",L)
								end
							elseif SN > "MARINERCDBASEVITALITY" then
								if SN < "MARINERCDMIGHTTOCRITHIT" then
									if SN < "MARINERCDCALCTYPETACMIT" then
										if SN < "MARINERCDCALCTYPECOMPHYMIT" then
											if SN == "MARINERCDBASEWILL" then
												Result = CalcStat("ClassBaseWillM",L)
											end
										elseif SN > "MARINERCDCALCTYPECOMPHYMIT" then
											if SN == "MARINERCDCALCTYPENONPHYMIT" then
												Result = 13
											end
										else
											Result = 13
										end
									elseif SN > "MARINERCDCALCTYPETACMIT" then
										if SN < "MARINERCDFATETOPOWER" then
											if SN == "MARINERCDFATETONCPR" then
												Result = 0.07
											end
										elseif SN > "MARINERCDFATETOPOWER" then
											if SN == "MARINERCDHASPOWER" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 26
									end
								elseif SN > "MARINERCDMIGHTTOCRITHIT" then
									if SN < "MARINERCDMIGHTTOPHYMAS" then
										if SN < "MARINERCDMIGHTTOOUTHEAL" then
											if SN == "MARINERCDMIGHTTOFINESSE" then
												Result = 1.5
											end
										elseif SN > "MARINERCDMIGHTTOOUTHEAL" then
											if SN == "MARINERCDMIGHTTOPARRY" then
												Result = 1
											end
										else
											Result = 2
										end
									elseif SN > "MARINERCDMIGHTTOPHYMAS" then
										if SN < "MARINERCDPHYMITTONONPHYMIT" then
											if SN == "MARINERCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "MARINERCDPHYMITTONONPHYMIT" then
											if SN == "MARINERCDTACMASTOOUTHEAL" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 2
									end
								else
									Result = 1.5
								end
							else
								Result = CalcStat("ClassBaseVitality",L)
							end
						elseif SN > "MARINERCDVITALITYTOICMR" then
							if SN < "MASTERYT" then
								if SN < "MARINERCDWILLTORESIST" then
									if SN < "MARINERCDWILLTOFINESSE" then
										if SN < "MARINERCDVITALITYTONCMR" then
											if SN == "MARINERCDVITALITYTOMORALE" then
												Result = 4.5
											end
										elseif SN > "MARINERCDVITALITYTONCMR" then
											if SN == "MARINERCDWILLTOCRITHIT" then
												Result = 0.5
											end
										else
											Result = 0.12
										end
									elseif SN > "MARINERCDWILLTOFINESSE" then
										if SN < "MARINERCDWILLTOPHYMAS" then
											if SN == "MARINERCDWILLTOOUTHEAL" then
												Result = 2
											end
										elseif SN > "MARINERCDWILLTOPHYMAS" then
											if SN == "MARINERCDWILLTOPHYMIT" then
												Result = 1
											end
										else
											Result = 2
										end
									else
										Result = 1.5
									end
								elseif SN > "MARINERCDWILLTORESIST" then
									if SN < "MASTERYCILVLFILTER" then
										if SN < "MASTERYC" then
											if SN == "MASTERY" then
												Result = EquSng(StatLinInter("PntMPMastery","ItemPntS","ProgBMastery","AdjItemMas",L,N,0))
											end
										elseif SN > "MASTERYC" then
											if SN == "MASTERYCI" then
												Result = RoundDblLotro(CalcStat("MasteryCIRaw",L,N))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("MasteryCI",CalcStat("MasteryCILvlFilter",N),N),0)
										end
									elseif SN > "MASTERYCILVLFILTER" then
										if SN < "MASTERYCRAW" then
											if SN == "MASTERYCIRAW" then
												Result = StatLinInter("PntMPMasteryC","ItemPntS","ProgBMastery","AdjCreepItem",L,N,4)
											end
										elseif SN > "MASTERYCRAW" then
											if SN == "MASTERYOLD" then
												Result = CalcStat("Mastery",L,N)
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("MasteryCIRaw",CalcStat("MasteryCILvlFilter",N),N),99)
										end
									else
										if 4.6 <= Lp and Lm <= 4.6 or 4.8 <= Lp and Lm <= 4.8 or 7 <= Lp and Lm <= 7 or 9.6 <= Lp and Lm <= 9.6 or 14.4 <= Lp and Lm <= 14.4 then
											Result = 515
										else
											Result = CalcStat("CreepILvlCurr",L)
										end
									end
								else
									Result = 1
								end
							elseif SN > "MASTERYT" then
								if SN < "MINCOURAGERESIST" then
									if SN < "MIGHTCI" then
										if SN < "MIGHT" then
											if SN == "MATHOMLVLTOILVL" then
												Result = CalcStat("AwardLvlToILvl",L)
											end
										elseif SN > "MIGHT" then
											if SN == "MIGHTC" then
												Result = CalcStat("MainC",L,N)
											end
										else
											Result = CalcStat("Main",L,N)
										end
									elseif SN > "MIGHTCI" then
										if SN < "MINCOMPOSURERESIST" then
											if SN == "MIGHTT" then
												Result = CalcStat("MainT",L,N)
											end
										elseif SN > "MINCOMPOSURERESIST" then
											if SN == "MINCOMPOSURETACMIT" then
												Result = CalcStat("TacMitT",L,1.0)
											end
										else
											Result = CalcStat("ResistT",L,1.6)
										end
									else
										Result = CalcStat("MainCI",L,N)
									end
								elseif SN > "MINCOURAGERESIST" then
									if SN < "MINPIERCINGBALFINESSE" then
										if SN < "MINECHOESBATTLERESIST" then
											if SN == "MINECHOESBATTLECRITDEF" then
												Result = -CalcStat("CritDefT",L,2.0)
											end
										elseif SN > "MINECHOESBATTLERESIST" then
											if SN == "MINENDMORALE" then
												Result = CalcStat("MoraleT",L,CalcStat("Trait12345Choice",N)*0.8)
											end
										else
											Result = -CalcStat("SongResistT",L,1.0)
										end
									elseif SN > "MINPIERCINGBALFINESSE" then
										if SN < "MINSTRELCDAGILITYTOEVADE" then
											if SN == "MINSTRELCDAGILITYTOCRITHIT" then
												Result = 2
											end
										elseif SN > "MINSTRELCDAGILITYTOEVADE" then
											if SN > "MINSTRELCDAGILITYTOFINESSE" then
												if SN == "MINSTRELCDAGILITYTOTACMAS" then
													Result = 2
												end
											elseif SN == "MINSTRELCDAGILITYTOFINESSE" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4)
									end
								else
									Result = CalcStat("FearResistT",L,1.0)
								end
							else
								Result = EquSng(StatLinInter("PntMPMastery","TraitPntS","ProgBMastery","AdjTraitMas",L,N,0))
							end
						else
							Result = 0.012
						end
					else
						Result = 3
					end
				else
					Result = CalcStat("ClassBaseFate",L)
				end
			else
				Result = -CalcStat("ParryT",L,CalcStat("Trait23456Choice",N)*0.4)
			end
		else
			Result = CalcStat("CritDefT",L,1.2)
		end
	elseif SN > "MINSTRELCDARMOURTOCOMPHYMIT" then
		if SN < "TACMITLPRATPA" then
			if SN < "PNTMPBPEC" then
				if SN < "PARTBLOCKPRATPCAP" then
					if SN < "MITLIGHTPRATPCAP" then
						if SN < "MINSTRELCDWILLTOBLOCK" then
							if SN < "MINSTRELCDCALCTYPENONPHYMIT" then
								if SN < "MINSTRELCDBASEMIGHT" then
									if SN < "MINSTRELCDBASEAGILITY" then
										if SN < "MINSTRELCDARMOURTOTACMIT" then
											if SN == "MINSTRELCDARMOURTONONPHYMIT" then
												Result = 0.2
											end
										elseif SN > "MINSTRELCDARMOURTOTACMIT" then
											if SN == "MINSTRELCDARMOURTYPE" then
												Result = 1
											end
										else
											Result = 0.2
										end
									elseif SN > "MINSTRELCDBASEAGILITY" then
										if SN < "MINSTRELCDBASEICMR" then
											if SN == "MINSTRELCDBASEFATE" then
												Result = CalcStat("ClassBaseFate",L)
											end
										elseif SN > "MINSTRELCDBASEICMR" then
											if SN == "MINSTRELCDBASEICPR" then
												Result = CalcStat("ClassBaseICPR",L)
											end
										else
											Result = CalcStat("ClassBaseICMRL",L)
										end
									else
										Result = CalcStat("ClassBaseAgilityM",L)
									end
								elseif SN > "MINSTRELCDBASEMIGHT" then
									if SN < "MINSTRELCDBASEPOWER" then
										if SN < "MINSTRELCDBASENCMR" then
											if SN == "MINSTRELCDBASEMORALE" then
												Result = CalcStat("ClassBaseMorale",L)
											end
										elseif SN > "MINSTRELCDBASENCMR" then
											if SN == "MINSTRELCDBASENCPR" then
												Result = CalcStat("ClassBaseNCPR",L)
											end
										else
											Result = CalcStat("ClassBaseNCMRL",L)
										end
									elseif SN > "MINSTRELCDBASEPOWER" then
										if SN < "MINSTRELCDBASEWILL" then
											if SN == "MINSTRELCDBASEVITALITY" then
												Result = CalcStat("ClassBaseVitality",L)
											end
										elseif SN > "MINSTRELCDBASEWILL" then
											if SN == "MINSTRELCDCALCTYPECOMPHYMIT" then
												Result = 12
											end
										else
											Result = CalcStat("ClassBaseWillH",L)
										end
									else
										Result = CalcStat("ClassBasePower",L)
									end
								else
									Result = CalcStat("ClassBaseMightL",L)
								end
							elseif SN > "MINSTRELCDCALCTYPENONPHYMIT" then
								if SN < "MINSTRELCDMIGHTTOTACMAS" then
									if SN < "MINSTRELCDFATETOPOWER" then
										if SN < "MINSTRELCDCANBLOCK" then
											if SN == "MINSTRELCDCALCTYPETACMIT" then
												Result = 25
											end
										elseif SN > "MINSTRELCDCANBLOCK" then
											if SN == "MINSTRELCDFATETONCPR" then
												Result = 0.07
											end
										else
											if 20 <= Lp then
												Result = 1
											end
										end
									elseif SN > "MINSTRELCDFATETOPOWER" then
										if SN < "MINSTRELCDMIGHTTOCRITHIT" then
											if SN == "MINSTRELCDHASPOWER" then
												Result = 1
											end
										elseif SN > "MINSTRELCDMIGHTTOCRITHIT" then
											if SN == "MINSTRELCDMIGHTTOOUTHEAL" then
												Result = 2
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "MINSTRELCDMIGHTTOTACMAS" then
									if SN < "MINSTRELCDTACMASTOOUTHEAL" then
										if SN < "MINSTRELCDPHYMITTOCOMPHYMIT" then
											if SN == "MINSTRELCDMIGHTTOTACMIT" then
												Result = 1
											end
										elseif SN > "MINSTRELCDPHYMITTOCOMPHYMIT" then
											if SN == "MINSTRELCDPHYMITTONONPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "MINSTRELCDTACMASTOOUTHEAL" then
										if SN < "MINSTRELCDVITALITYTOMORALE" then
											if SN == "MINSTRELCDVITALITYTOICMR" then
												Result = 0.012
											end
										elseif SN > "MINSTRELCDVITALITYTOMORALE" then
											if SN == "MINSTRELCDVITALITYTONCMR" then
												Result = 0.12
											end
										else
											Result = 4.5
										end
									else
										Result = 1
									end
								else
									Result = 2
								end
							else
								Result = 12
							end
						elseif SN > "MINSTRELCDWILLTOBLOCK" then
							if SN < "MINTOTRESISTSEL" then
								if SN < "MINTIMEECHOESBATTLERESIST" then
									if SN < "MINSTRELCDWILLTORESIST" then
										if SN < "MINSTRELCDWILLTOEVADE" then
											if SN == "MINSTRELCDWILLTOCRITHIT" then
												Result = 1
											end
										elseif SN > "MINSTRELCDWILLTOEVADE" then
											if SN == "MINSTRELCDWILLTOPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "MINSTRELCDWILLTORESIST" then
										if SN < "MINSTRELCDWILLTOTACMIT" then
											if SN == "MINSTRELCDWILLTOTACMAS" then
												Result = 3
											end
										elseif SN > "MINSTRELCDWILLTOTACMIT" then
											if SN == "MINTACMAS" then
												Result = CalcStat("TacMasT",L,CalcStat("Trait123455Choice",N)*0.4)
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "MINTIMEECHOESBATTLERESIST" then
									if SN < "MINTOTFATESEL" then
										if SN < "MINTOTCRITHITSEL" then
											if SN == "MINTOTCRITHIT" then
												Result = CalcStat("CritHitT",L,CalcStat("MinToTCritHitSel",N))
											end
										elseif SN > "MINTOTCRITHITSEL" then
											if SN == "MINTOTFATE" then
												Result = CalcStat("FateT",L,CalcStat("MinToTFateSel",N))
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = DataTableValue({0,0,0,0.4,0.6},L)
											end
										end
									elseif SN > "MINTOTFATESEL" then
										if SN < "MINTOTFINESSESEL" then
											if SN == "MINTOTFINESSE" then
												Result = CalcStat("FinesseT",L,CalcStat("MinToTFinesseSel",N))
											end
										elseif SN > "MINTOTFINESSESEL" then
											if SN == "MINTOTRESIST" then
												Result = CalcStat("ResistT",L,CalcStat("MinToTResistSel",N))
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = DataTableValue({0,0,0.2,0.4,0.6},L)
											end
										end
									else
										if 1 <= Lp and Lm <= 5 then
											Result = DataTableValue({0.2,0.3,0.4,0.5,0.6},L)
										end
									end
								else
									Result = -CalcStat("SongResistT",L,0.6)
								end
							elseif SN > "MINTOTRESISTSEL" then
								if SN < "MITHEAVYPRATPCAP" then
									if SN < "MITHEAVYPRATP" then
										if SN < "MINTOTVITALITYSEL" then
											if SN == "MINTOTVITALITY" then
												Result = CalcStat("VitalityT",L,CalcStat("MinToTVitalitySel",N))
											end
										elseif SN > "MINTOTVITALITYSEL" then
											if SN == "MITHEAVYPPRAT" then
												Result = CalcRatAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCapR",L),N)
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = DataTableValue({0,0,0,0,0.4},L)
											end
										end
									elseif SN > "MITHEAVYPRATP" then
										if SN < "MITHEAVYPRATPB" then
											if SN == "MITHEAVYPRATPA" then
												Result = 180
											end
										elseif SN > "MITHEAVYPRATPB" then
											if SN == "MITHEAVYPRATPC" then
												Result = 0.5
											end
										else
											Result = CalcStat("BRatRounded",L,"BRatMitHeavy")
										end
									else
										Result = CalcPercAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCap",L),N)
									end
								elseif SN > "MITHEAVYPRATPCAP" then
									if SN < "MITLIGHTPRATP" then
										if SN < "MITIGATION" then
											if SN == "MITHEAVYPRATPCAPR" then
												Result = CalcStat("MitHeavyPRatPB",L)*CalcStat("MitHeavyPRatPC",L)
											end
										elseif SN > "MITIGATION" then
											if SN == "MITLIGHTPPRAT" then
												Result = CalcRatAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCapR",L),N)
											end
										else
											Result = EquSng(StatLinInter("PntMPMitigation","ItemPntS","ProgBMitigation","AdjItemMit",L,N,0))
										end
									elseif SN > "MITLIGHTPRATP" then
										if SN < "MITLIGHTPRATPB" then
											if SN == "MITLIGHTPRATPA" then
												Result = 120
											end
										elseif SN > "MITLIGHTPRATPB" then
											if SN == "MITLIGHTPRATPC" then
												Result = 0.5
											end
										else
											Result = CalcStat("BRatRounded",L,"BRatMitLight")
										end
									else
										Result = CalcPercAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCap",L),N)
									end
								else
									Result = 60
								end
							else
								if 1 <= Lp and Lm <= 5 then
									Result = DataTableValue({0,0.2,0.3,0.4,0.5},L)
								end
							end
						else
							Result = 1
						end
					elseif SN > "MITLIGHTPRATPCAP" then
						if SN < "OUTHEALPRATPC" then
							if SN < "NCPR" then
								if SN < "MITMEDIUMPRATPCAPR" then
									if SN < "MITMEDIUMPRATPA" then
										if SN < "MITMEDIUMPPRAT" then
											if SN == "MITLIGHTPRATPCAPR" then
												Result = CalcStat("MitLightPRatPB",L)*CalcStat("MitLightPRatPC",L)
											end
										elseif SN > "MITMEDIUMPPRAT" then
											if SN == "MITMEDIUMPRATP" then
												Result = CalcPercAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCap",L),N)
											end
										else
											Result = CalcRatAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCapR",L),N)
										end
									elseif SN > "MITMEDIUMPRATPA" then
										if SN < "MITMEDIUMPRATPC" then
											if SN == "MITMEDIUMPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatMitMedium")
											end
										elseif SN > "MITMEDIUMPRATPC" then
											if SN == "MITMEDIUMPRATPCAP" then
												Result = 50
											end
										else
											Result = 0.5
										end
									else
										Result = 150
									end
								elseif SN > "MITMEDIUMPRATPCAPR" then
									if SN < "MORALETADJ" then
										if SN < "MORALEADJ" then
											if SN == "MORALE" then
												Result = EquSng(StatLinInter("PntMPMorale","ItemPntSVital","ProgBMorale","MoraleAdj",L,N,0))
											end
										elseif SN > "MORALEADJ" then
											if SN == "MORALET" then
												Result = EquSng(StatLinInter("PntMPMorale","TraitPntSVital","ProgBMorale","MoraleTAdj",L,N,0))
											end
										else
											if Lm <= 25 then
												Result = 0.5
											elseif Lm <= 50 then
												Result = 0.6
											elseif Lm <= 60 then
												Result = 0.7
											elseif Lm <= 79 then
												Result = 0.8
											elseif Lm <= 80 then
												Result = 0.9
											else
												Result = 1
											end
										end
									elseif SN > "MORALETADJ" then
										if SN < "NCMR" then
											if SN == "N" then
												Result = N
											end
										elseif SN > "NCMR" then
											if SN == "NCMRT" then
												Result = EquSng(StatLinInter("PntMPNCMR","TraitPntSVital","ProgBNCMR","",L,N,1))
											end
										else
											Result = EquSng(StatLinInter("PntMPNCMR","ItemPntSVital","ProgBNCMR","",L,N,1))
										end
									else
										if Lm <= 25 then
											Result = 0.5
										elseif Lm <= 50 then
											Result = 0.6
										elseif Lm <= 60 then
											Result = 0.7
										elseif Lm <= 65 then
											Result = 0.8
										elseif Lm <= 75 then
											Result = 0.9
										else
											Result = 1
										end
									end
								else
									Result = CalcStat("MitMediumPRatPB",L)*CalcStat("MitMediumPRatPC",L)
								end
							elseif SN > "NCPR" then
								if SN < "OUTDMGPRATPC" then
									if SN < "OUTDMGPPRAT" then
										if SN < "OFFSET" then
											if SN == "NCPRT" then
												Result = EquSng(StatLinInter("PntMPNCPR","TraitPntSVital","ProgBNCPR","",L,N,99))
											end
										elseif SN > "OFFSET" then
											if SN == "ORCMIT" then
												Result = EquSng(StatLinInter("PntMPOrcMit","ItemPntS","ProgBMitigation","AdjItemMit",L,N,0))
											end
										else
											Result = L+N
										end
									elseif SN > "OUTDMGPPRAT" then
										if SN < "OUTDMGPRATPA" then
											if SN == "OUTDMGPRATP" then
												Result = CalcPercAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCap",L),N)
											end
										elseif SN > "OUTDMGPRATPA" then
											if SN == "OUTDMGPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatExtra")
											end
										else
											Result = 600
										end
									else
										Result = CalcRatAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCapR",L),N)
									end
								elseif SN > "OUTDMGPRATPC" then
									if SN < "OUTHEALPPRAT" then
										if SN < "OUTDMGPRATPCAPR" then
											if SN == "OUTDMGPRATPCAP" then
												Result = 200
											end
										elseif SN > "OUTDMGPRATPCAPR" then
											if SN == "OUTHEAL" then
												Result = EquSng(StatLinInter("PntMPOutHeal","ItemPntS","ProgBOutHeal","AdjItem",L,N,0))
											end
										else
											Result = CalcStat("OutDmgPRatPB",L)*CalcStat("OutDmgPRatPC",L)
										end
									elseif SN > "OUTHEALPPRAT" then
										if SN < "OUTHEALPRATPA" then
											if SN == "OUTHEALPRATP" then
												Result = CalcPercAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCap",L),N)
											end
										elseif SN > "OUTHEALPRATPA" then
											if SN == "OUTHEALPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatOutHeal")
											end
										else
											Result = 210
										end
									else
										Result = CalcRatAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCapR",L),N)
									end
								else
									Result = 0.5
								end
							else
								Result = EquSng(StatLinInter("PntMPNCPR","ItemPntSClassic","ProgBNCPR","",L,N,99))
							end
						elseif SN > "OUTHEALPRATPC" then
							if SN < "PARRYPRATPCAPR" then
								if SN < "PARRYCRAW" then
									if SN < "PARRY" then
										if SN < "OUTHEALPRATPCAPR" then
											if SN == "OUTHEALPRATPCAP" then
												Result = 70
											end
										elseif SN > "OUTHEALPRATPCAPR" then
											if SN == "OUTHEALT" then
												Result = EquSng(StatLinInter("PntMPOutHeal","TraitPntS","ProgBOutHeal","AdjTrait",L,N,0))
											end
										else
											Result = CalcStat("OutHealPRatPB",L)*CalcStat("OutHealPRatPC",L)
										end
									elseif SN > "PARRY" then
										if SN < "PARRYCI" then
											if SN == "PARRYC" then
												Result = CalcStat("BPEC",L,N)
											end
										elseif SN > "PARRYCI" then
											if SN == "PARRYCIRAW" then
												Result = CalcStat("BPECIRAW",L,N)
											end
										else
											Result = CalcStat("BPECI",L,N)
										end
									else
										Result = CalcStat("BPE",L,N)
									end
								elseif SN > "PARRYCRAW" then
									if SN < "PARRYPRATPA" then
										if SN < "PARRYPPRAT" then
											if SN == "PARRYPBONUS" then
												Result = CalcStat("BPEPBonus",L)
											end
										elseif SN > "PARRYPPRAT" then
											if SN == "PARRYPRATP" then
												Result = CalcStat("BPEPRatP",L,N)
											end
										else
											Result = CalcStat("BPEPPRat",L,N)
										end
									elseif SN > "PARRYPRATPA" then
										if SN < "PARRYPRATPC" then
											if SN == "PARRYPRATPB" then
												Result = CalcStat("BPEPRatPB",L)
											end
										elseif SN > "PARRYPRATPC" then
											if SN == "PARRYPRATPCAP" then
												Result = CalcStat("BPEPRatPCap",L)
											end
										else
											Result = CalcStat("BPEPRatPC",L)
										end
									else
										Result = CalcStat("BPEPRatPA",L)
									end
								else
									Result = CalcStat("BPECRAW",L,N)
								end
							elseif SN > "PARRYPRATPCAPR" then
								if SN < "PARTBLOCKMITPRATPCAP" then
									if SN < "PARTBLOCKMITPRATP" then
										if SN < "PARTBLOCKMITPBONUS" then
											if SN == "PARRYT" then
												Result = CalcStat("BPET",L,N)
											end
										elseif SN > "PARTBLOCKMITPBONUS" then
											if SN == "PARTBLOCKMITPPRAT" then
												Result = CalcStat("PartMitPPRat",L,N)
											end
										else
											Result = CalcStat("PartMitPBonus",L)
										end
									elseif SN > "PARTBLOCKMITPRATP" then
										if SN < "PARTBLOCKMITPRATPB" then
											if SN == "PARTBLOCKMITPRATPA" then
												Result = CalcStat("PartMitPRatPA",L)
											end
										elseif SN > "PARTBLOCKMITPRATPB" then
											if SN == "PARTBLOCKMITPRATPC" then
												Result = CalcStat("PartMitPRatPC",L)
											end
										else
											Result = CalcStat("PartMitPRatPB",L)
										end
									else
										Result = CalcStat("PartMitPRatP",L,N)
									end
								elseif SN > "PARTBLOCKMITPRATPCAP" then
									if SN < "PARTBLOCKPRATP" then
										if SN < "PARTBLOCKPBONUS" then
											if SN == "PARTBLOCKMITPRATPCAPR" then
												Result = CalcStat("PartMitPRatPCapR",L)
											end
										elseif SN > "PARTBLOCKPBONUS" then
											if SN == "PARTBLOCKPPRAT" then
												Result = CalcStat("PartBPEPPRat",L,N)
											end
										else
											Result = CalcStat("PartBPEPBonus",L)
										end
									elseif SN > "PARTBLOCKPRATP" then
										if SN < "PARTBLOCKPRATPB" then
											if SN == "PARTBLOCKPRATPA" then
												Result = CalcStat("PartBPEPRatPA",L)
											end
										elseif SN > "PARTBLOCKPRATPB" then
											if SN == "PARTBLOCKPRATPC" then
												Result = CalcStat("PartBPEPRatPC",L)
											end
										else
											Result = CalcStat("PartBPEPRatPB",L)
										end
									else
										Result = CalcStat("PartBPEPRatP",L,N)
									end
								else
									Result = CalcStat("PartMitPRatPCap",L)
								end
							else
								Result = CalcStat("BPEPRatPCapR",L)
							end
						else
							Result = 0.5
						end
					else
						Result = 40
					end
				elseif SN > "PARTBLOCKPRATPCAP" then
					if SN < "PERKNCMR" then
						if SN < "PARTFINESSEPPRAT" then
							if SN < "PARTEVADEMITPRATPCAPR" then
								if SN < "PARTBPEPRATPCAPR" then
									if SN < "PARTBPEPRATPA" then
										if SN < "PARTBPEPPRAT" then
											if SN == "PARTBLOCKPRATPCAPR" then
												Result = CalcStat("PartBPEPRatPCapR",L)
											end
										elseif SN > "PARTBPEPPRAT" then
											if SN == "PARTBPEPRATP" then
												Result = CalcPercAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCap",L),N)
											end
										else
											Result = CalcRatAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCapR",L),N)
										end
									elseif SN > "PARTBPEPRATPA" then
										if SN < "PARTBPEPRATPC" then
											if SN == "PARTBPEPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatPartBPE")
											end
										elseif SN > "PARTBPEPRATPC" then
											if SN == "PARTBPEPRATPCAP" then
												Result = 25
											end
										else
											Result = 0.5
										end
									else
										Result = 75
									end
								elseif SN > "PARTBPEPRATPCAPR" then
									if SN < "PARTEVADEMITPRATPA" then
										if SN < "PARTEVADEMITPPRAT" then
											if SN == "PARTEVADEMITPBONUS" then
												Result = CalcStat("PartMitPBonus",L)
											end
										elseif SN > "PARTEVADEMITPPRAT" then
											if SN == "PARTEVADEMITPRATP" then
												Result = CalcStat("PartMitPRatP",L,N)
											end
										else
											Result = CalcStat("PartMitPPRat",L,N)
										end
									elseif SN > "PARTEVADEMITPRATPA" then
										if SN < "PARTEVADEMITPRATPC" then
											if SN == "PARTEVADEMITPRATPB" then
												Result = CalcStat("PartMitPRatPB",L)
											end
										elseif SN > "PARTEVADEMITPRATPC" then
											if SN == "PARTEVADEMITPRATPCAP" then
												Result = CalcStat("PartMitPRatPCap",L)
											end
										else
											Result = CalcStat("PartMitPRatPC",L)
										end
									else
										Result = CalcStat("PartMitPRatPA",L)
									end
								else
									Result = CalcStat("PartBPEPRatPB",L)*CalcStat("PartBPEPRatPC",L)
								end
							elseif SN > "PARTEVADEMITPRATPCAPR" then
								if SN < "PARTEVADEPRATPCAPR" then
									if SN < "PARTEVADEPRATPA" then
										if SN < "PARTEVADEPPRAT" then
											if SN == "PARTEVADEPBONUS" then
												Result = CalcStat("PartBPEPBonus",L)
											end
										elseif SN > "PARTEVADEPPRAT" then
											if SN == "PARTEVADEPRATP" then
												Result = CalcStat("PartBPEPRatP",L,N)
											end
										else
											Result = CalcStat("PartBPEPPRat",L,N)
										end
									elseif SN > "PARTEVADEPRATPA" then
										if SN < "PARTEVADEPRATPC" then
											if SN == "PARTEVADEPRATPB" then
												Result = CalcStat("PartBPEPRatPB",L)
											end
										elseif SN > "PARTEVADEPRATPC" then
											if SN == "PARTEVADEPRATPCAP" then
												Result = CalcStat("PartBPEPRatPCap",L)
											end
										else
											Result = CalcStat("PartBPEPRatPC",L)
										end
									else
										Result = CalcStat("PartBPEPRatPA",L)
									end
								elseif SN > "PARTEVADEPRATPCAPR" then
									if SN < "PARTFINESSEDMGPRATPB" then
										if SN < "PARTFINESSEDMGPRATP" then
											if SN == "PARTFINESSEDMGPPRAT" then
												Result = CalcRatAB(CalcStat("PartFinesseDmgPRatPA",L),CalcStat("PartFinesseDmgPRatPB",L),CalcStat("PartFinesseDmgPRatPCapR",L),N)
											end
										elseif SN > "PARTFINESSEDMGPRATP" then
											if SN == "PARTFINESSEDMGPRATPA" then
												Result = 150
											end
										else
											Result = CalcPercAB(CalcStat("PartFinesseDmgPRatPA",L),CalcStat("PartFinesseDmgPRatPB",L),CalcStat("PartFinesseDmgPRatPCap",L),N)
										end
									elseif SN > "PARTFINESSEDMGPRATPB" then
										if SN < "PARTFINESSEDMGPRATPCAP" then
											if SN == "PARTFINESSEDMGPRATPC" then
												Result = 0.5
											end
										elseif SN > "PARTFINESSEDMGPRATPCAP" then
											if SN == "PARTFINESSEDMGPRATPCAPR" then
												Result = CalcStat("PartFinesseDmgPRatPB",L)*CalcStat("PartFinesseDmgPRatPC",L)
											end
										else
											Result = 50
										end
									else
										Result = CalcStat("BRatRounded",L,"BRatStandard")
									end
								else
									Result = CalcStat("PartBPEPRatPCapR",L)
								end
							else
								Result = CalcStat("PartMitPRatPCapR",L)
							end
						elseif SN > "PARTFINESSEPPRAT" then
							if SN < "PARTPARRYMITPPRAT" then
								if SN < "PARTMITPPRAT" then
									if SN < "PARTFINESSEPRATPC" then
										if SN < "PARTFINESSEPRATPA" then
											if SN == "PARTFINESSEPRATP" then
												Result = CalcPercAB(CalcStat("PartFinessePRatPA",L),CalcStat("PartFinessePRatPB",L),CalcStat("PartFinessePRatPCap",L),N)
											end
										elseif SN > "PARTFINESSEPRATPA" then
											if SN == "PARTFINESSEPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatStandard")
											end
										else
											Result = 150
										end
									elseif SN > "PARTFINESSEPRATPC" then
										if SN < "PARTFINESSEPRATPCAPR" then
											if SN == "PARTFINESSEPRATPCAP" then
												Result = 50
											end
										elseif SN > "PARTFINESSEPRATPCAPR" then
											if SN == "PARTMITPBONUS" then
												Result = 0.1
											end
										else
											Result = CalcStat("PartFinessePRatPB",L)*CalcStat("PartFinessePRatPC",L)
										end
									else
										Result = 0.5
									end
								elseif SN > "PARTMITPPRAT" then
									if SN < "PARTMITPRATPC" then
										if SN < "PARTMITPRATPA" then
											if SN == "PARTMITPRATP" then
												Result = CalcPercAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCap",L),N)
											end
										elseif SN > "PARTMITPRATPA" then
											if SN == "PARTMITPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatPartBPE")
											end
										else
											Result = 105
										end
									elseif SN > "PARTMITPRATPC" then
										if SN < "PARTMITPRATPCAPR" then
											if SN == "PARTMITPRATPCAP" then
												Result = 35
											end
										elseif SN > "PARTMITPRATPCAPR" then
											if SN == "PARTPARRYMITPBONUS" then
												Result = CalcStat("PartMitPBonus",L)
											end
										else
											Result = CalcStat("PartMitPRatPB",L)*CalcStat("PartMitPRatPC",L)
										end
									else
										Result = 0.5
									end
								else
									Result = CalcRatAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCapR",L),N)
								end
							elseif SN > "PARTPARRYMITPPRAT" then
								if SN < "PARTPARRYPPRAT" then
									if SN < "PARTPARRYMITPRATPC" then
										if SN < "PARTPARRYMITPRATPA" then
											if SN == "PARTPARRYMITPRATP" then
												Result = CalcStat("PartMitPRatP",L,N)
											end
										elseif SN > "PARTPARRYMITPRATPA" then
											if SN == "PARTPARRYMITPRATPB" then
												Result = CalcStat("PartMitPRatPB",L)
											end
										else
											Result = CalcStat("PartMitPRatPA",L)
										end
									elseif SN > "PARTPARRYMITPRATPC" then
										if SN < "PARTPARRYMITPRATPCAPR" then
											if SN == "PARTPARRYMITPRATPCAP" then
												Result = CalcStat("PartMitPRatPCap",L)
											end
										elseif SN > "PARTPARRYMITPRATPCAPR" then
											if SN == "PARTPARRYPBONUS" then
												Result = CalcStat("PartBPEPBonus",L)
											end
										else
											Result = CalcStat("PartMitPRatPCapR",L)
										end
									else
										Result = CalcStat("PartMitPRatPC",L)
									end
								elseif SN > "PARTPARRYPPRAT" then
									if SN < "PARTPARRYPRATPC" then
										if SN < "PARTPARRYPRATPA" then
											if SN == "PARTPARRYPRATP" then
												Result = CalcStat("PartBPEPRatP",L,N)
											end
										elseif SN > "PARTPARRYPRATPA" then
											if SN == "PARTPARRYPRATPB" then
												Result = CalcStat("PartBPEPRatPB",L)
											end
										else
											Result = CalcStat("PartBPEPRatPA",L)
										end
									elseif SN > "PARTPARRYPRATPC" then
										if SN < "PARTPARRYPRATPCAPR" then
											if SN == "PARTPARRYPRATPCAP" then
												Result = CalcStat("PartBPEPRatPCap",L)
											end
										elseif SN > "PARTPARRYPRATPCAPR" then
											if SN == "PERKMORALE" then
												if 1 <= Lp and Lm <= 4 then
													Result = DataTableValue({10,20,30,40},L)
												end
											end
										else
											Result = CalcStat("PartBPEPRatPCapR",L)
										end
									else
										Result = CalcStat("PartBPEPRatPC",L)
									end
								else
									Result = CalcStat("PartBPEPPRat",L,N)
								end
							else
								Result = CalcStat("PartMitPPRat",L,N)
							end
						else
							Result = CalcRatAB(CalcStat("PartFinessePRatPA",L),CalcStat("PartFinessePRatPB",L),CalcStat("PartFinessePRatPCapR",L),N)
						end
					elseif SN > "PERKNCMR" then
						if SN < "PHYMITHPRATPCAP" then
							if SN < "PHYMASCIRAW" then
								if SN < "PHYDMGPRATPA" then
									if SN < "PERKTACMIT" then
										if SN < "PERKPHYMIT" then
											if SN == "PERKNCPR" then
												Result = CalcStat("FoodNCPRL",L)
											end
										elseif SN > "PERKPHYMIT" then
											if SN == "PERKPOWER" then
												if 1 <= Lp and Lm <= 4 then
													Result = DataTableValue({10,20,30,40},L)
												end
											end
										else
											Result = CalcStat("PhyMitT",L,0.2*N)
										end
									elseif SN > "PERKTACMIT" then
										if SN < "PHYDMGPPRAT" then
											if SN == "PHYDMGPBONUS" then
												Result = CalcStat("OutDmgPBonus",L)
											end
										elseif SN > "PHYDMGPPRAT" then
											if SN == "PHYDMGPRATP" then
												Result = CalcStat("OutDmgPRatP",L,N)
											end
										else
											Result = CalcStat("OutDmgPPRat",L,N)
										end
									else
										Result = CalcStat("TacMitT",L,0.2*N)
									end
								elseif SN > "PHYDMGPRATPA" then
									if SN < "PHYDMGPRATPCAPR" then
										if SN < "PHYDMGPRATPC" then
											if SN == "PHYDMGPRATPB" then
												Result = CalcStat("OutDmgPRatPB",L)
											end
										elseif SN > "PHYDMGPRATPC" then
											if SN == "PHYDMGPRATPCAP" then
												Result = CalcStat("OutDmgPRatPCap",L)
											end
										else
											Result = CalcStat("OutDmgPRatPC",L)
										end
									elseif SN > "PHYDMGPRATPCAPR" then
										if SN < "PHYMASC" then
											if SN == "PHYMAS" then
												Result = CalcStat("Mastery",L,N)
											end
										elseif SN > "PHYMASC" then
											if SN == "PHYMASCI" then
												Result = CalcStat("MasteryCI",L,N)
											end
										else
											Result = CalcStat("MasteryC",L,N)
										end
									else
										Result = CalcStat("OutDmgPRatPCapR",L)
									end
								else
									Result = CalcStat("OutDmgPRatPA",L)
								end
							elseif SN > "PHYMASCIRAW" then
								if SN < "PHYMITCIRAW" then
									if SN < "PHYMIT" then
										if SN < "PHYMASOLD" then
											if SN == "PHYMASCRAW" then
												Result = CalcStat("MasteryCRaw",L,N)
											end
										elseif SN > "PHYMASOLD" then
											if SN == "PHYMAST" then
												Result = CalcStat("MasteryT",L,N)
											end
										else
											Result = CalcStat("Mastery",L,N)
										end
									elseif SN > "PHYMIT" then
										if SN < "PHYMITCI" then
											if SN == "PHYMITC" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("PhyMitCI",CalcStat("PhyMitCILvlFilter",N),N),0)
											end
										elseif SN > "PHYMITCI" then
											if SN == "PHYMITCILVLFILTER" then
												if 3.8 <= Lp and Lm <= 3.8 or 8.2 <= Lp and Lm <= 8.2 or 14.4 <= Lp and Lm <= 14.4 or 19.1 <= Lp and Lm <= 19.1 or 23.125 <= Lp and Lm <= 23.125 or 26.5 <= Lp and Lm <= 26.5 then
													Result = 515
												else
													Result = CalcStat("CreepILvlCurr",L)
												end
											end
										else
											Result = RoundDblLotro(CalcStat("PhyMitCIRaw",L,N))
										end
									else
										Result = EquSng(StatLinInter("PntMPPhyMit","ItemPntS","ProgBMitigation","AdjItemMit",L,N,0))
									end
								elseif SN > "PHYMITCIRAW" then
									if SN < "PHYMITHPRATP" then
										if SN < "PHYMITHPBONUS" then
											if SN == "PHYMITCRAW" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("PhyMitCIRaw",CalcStat("PhyMitCILvlFilter",N),N),99)
											end
										elseif SN > "PHYMITHPBONUS" then
											if SN == "PHYMITHPPRAT" then
												Result = CalcStat("MitHeavyPPRat",L,N)
											end
										else
											Result = CalcStat("MitHeavyPBonus",L)
										end
									elseif SN > "PHYMITHPRATP" then
										if SN < "PHYMITHPRATPB" then
											if SN == "PHYMITHPRATPA" then
												Result = CalcStat("MitHeavyPRatPA",L)
											end
										elseif SN > "PHYMITHPRATPB" then
											if SN == "PHYMITHPRATPC" then
												Result = CalcStat("MitHeavyPRatPC",L)
											end
										else
											Result = CalcStat("MitHeavyPRatPB",L)
										end
									else
										Result = CalcStat("MitHeavyPRatP",L,N)
									end
								else
									Result = StatLinInter("PntMPPhyMitC","ItemPntS","ProgBMitigation","AdjCreepItemMit",L,N,4)
								end
							else
								Result = CalcStat("MasteryCIRaw",L,N)
							end
						elseif SN > "PHYMITHPRATPCAP" then
							if SN < "PHYMITMPRATPCAP" then
								if SN < "PHYMITLPRATPCAP" then
									if SN < "PHYMITLPRATP" then
										if SN < "PHYMITLPBONUS" then
											if SN == "PHYMITHPRATPCAPR" then
												Result = CalcStat("MitHeavyPRatPCapR",L)
											end
										elseif SN > "PHYMITLPBONUS" then
											if SN == "PHYMITLPPRAT" then
												Result = CalcStat("MitLightPPRat",L,N)
											end
										else
											Result = CalcStat("MitLightPBonus",L)
										end
									elseif SN > "PHYMITLPRATP" then
										if SN < "PHYMITLPRATPB" then
											if SN == "PHYMITLPRATPA" then
												Result = CalcStat("MitLightPRatPA",L)
											end
										elseif SN > "PHYMITLPRATPB" then
											if SN == "PHYMITLPRATPC" then
												Result = CalcStat("MitLightPRatPC",L)
											end
										else
											Result = CalcStat("MitLightPRatPB",L)
										end
									else
										Result = CalcStat("MitLightPRatP",L,N)
									end
								elseif SN > "PHYMITLPRATPCAP" then
									if SN < "PHYMITMPRATP" then
										if SN < "PHYMITMPBONUS" then
											if SN == "PHYMITLPRATPCAPR" then
												Result = CalcStat("MitLightPRatPCapR",L)
											end
										elseif SN > "PHYMITMPBONUS" then
											if SN == "PHYMITMPPRAT" then
												Result = CalcStat("MitMediumPPRat",L,N)
											end
										else
											Result = CalcStat("MitMediumPBonus",L)
										end
									elseif SN > "PHYMITMPRATP" then
										if SN < "PHYMITMPRATPB" then
											if SN == "PHYMITMPRATPA" then
												Result = CalcStat("MitMediumPRatPA",L)
											end
										elseif SN > "PHYMITMPRATPB" then
											if SN == "PHYMITMPRATPC" then
												Result = CalcStat("MitMediumPRatPC",L)
											end
										else
											Result = CalcStat("MitMediumPRatPB",L)
										end
									else
										Result = CalcStat("MitMediumPRatP",L,N)
									end
								else
									Result = CalcStat("MitLightPRatPCap",L)
								end
							elseif SN > "PHYMITMPRATPCAP" then
								if SN < "PLAYERBASEPHYMAS" then
									if SN < "PHYRESISTT" then
										if SN < "PHYMITT" then
											if SN == "PHYMITMPRATPCAPR" then
												Result = CalcStat("MitMediumPRatPCapR",L)
											end
										elseif SN > "PHYMITT" then
											if SN == "PHYRESIST" then
												Result = CalcStat("ResistAdd",L,N)
											end
										else
											Result = EquSng(StatLinInter("PntMPPhyMit","TraitPntS","ProgBMitigation","AdjTraitMit",L,N,0))
										end
									elseif SN > "PHYRESISTT" then
										if SN < "PLAYERBASEMORALE" then
											if SN == "PLAYERBASEEVADE" then
												Result = 1
											end
										elseif SN > "PLAYERBASEMORALE" then
											if SN == "PLAYERBASEPARRY" then
												Result = 3
											end
										else
											Result = 52.5
										end
									else
										Result = CalcStat("ResistAddT",L,N)
									end
								elseif SN > "PLAYERBASEPHYMAS" then
									if SN < "PNTMPARMOURPENT" then
										if SN < "PNTMPARMOUR" then
											if SN == "PLAYERBASETACMAS" then
												Result = 11.5
											end
										elseif SN > "PNTMPARMOUR" then
											if SN == "PNTMPARMOURC" then
												Result = 20/1200
											end
										else
											Result = 4.4/1200
										end
									elseif SN > "PNTMPARMOURPENT" then
										if SN < "PNTMPARMOURVIRTUES" then
											if SN == "PNTMPARMOURT" then
												Result = 25/1200
											end
										elseif SN > "PNTMPARMOURVIRTUES" then
											if SN == "PNTMPBPE" then
												Result = 42/1200
											end
										else
											Result = 24/1200
										end
									else
										Result = 72/1200
									end
								else
									Result = 11.5
								end
							else
								Result = CalcStat("MitMediumPRatPCap",L)
							end
						else
							Result = CalcStat("MitHeavyPRatPCap",L)
						end
					else
						Result = CalcStat("FoodNCMRL",L)
					end
				else
					Result = CalcStat("PartBPEPRatPCap",L)
				end
			elseif SN > "PNTMPBPEC" then
				if SN < "RIVERHOBBITRDTRAITWILL" then
					if SN < "PROGBMASTERY" then
						if SN < "PNTMPPHYMITC" then
							if SN < "PNTMPICMRC" then
								if SN < "PNTMPDMGTYPEMIT" then
									if SN < "PNTMPCRITDEF" then
										if SN < "PNTMPCLASSBASENCPR" then
											if SN == "PNTMPCLASSBASEICPR" then
												Result = 0.125
											end
										elseif SN > "PNTMPCLASSBASENCPR" then
											if SN == "PNTMPCOMBATDAMAGEMOD" then
												Result = 300/1200
											end
										else
											Result = 0.25
										end
									elseif SN > "PNTMPCRITDEF" then
										if SN < "PNTMPCRITHIT" then
											if SN == "PNTMPCRITDEFC" then
												Result = 0.01667
											end
										elseif SN > "PNTMPCRITHIT" then
											if SN == "PNTMPCRITHITC" then
												Result = 20/1200
											end
										else
											Result = 20/1200
										end
									else
										Result = 40/1200
									end
								elseif SN > "PNTMPDMGTYPEMIT" then
									if SN < "PNTMPFINESSEC" then
										if SN < "PNTMPFATE" then
											if SN == "PNTMPDMGTYPEMITT" then
												Result = 60/1200
											end
										elseif SN > "PNTMPFATE" then
											if SN == "PNTMPFINESSE" then
												Result = 40/1200
											end
										else
											Result = 1.25
										end
									elseif SN > "PNTMPFINESSEC" then
										if SN < "PNTMPFOODRESIST" then
											if SN == "PNTMPFINESSET" then
												Result = 36/1200
											end
										elseif SN > "PNTMPFOODRESIST" then
											if SN == "PNTMPICMR" then
												Result = 0.015
											end
										else
											Result = 30/1200
										end
									else
										Result = 20/1200
									end
								else
									Result = 24/1200
								end
							elseif SN > "PNTMPICMRC" then
								if SN < "PNTMPMITIGATION" then
									if SN < "PNTMPMAIN" then
										if SN < "PNTMPICPRC" then
											if SN == "PNTMPICPR" then
												Result = 0.0625
											end
										elseif SN > "PNTMPICPRC" then
											if SN == "PNTMPINHEAL" then
												Result = 40/1200
											end
										else
											Result = 11.5/1200
										end
									elseif SN > "PNTMPMAIN" then
										if SN < "PNTMPMASTERY" then
											if SN == "PNTMPMAINC" then
												Result = 199.75/1200
											end
										elseif SN > "PNTMPMASTERY" then
											if SN == "PNTMPMASTERYC" then
												Result = 20/1200
											end
										else
											Result = 17/1200
										end
									else
										Result = 0.5
									end
								elseif SN > "PNTMPMITIGATION" then
									if SN < "PNTMPNCPR" then
										if SN < "PNTMPMORALEVIRTUES" then
											if SN == "PNTMPMORALE" then
												Result = 1
											end
										elseif SN > "PNTMPMORALEVIRTUES" then
											if SN == "PNTMPNCMR" then
												Result = 0.15
											end
										else
											Result = 0.75
										end
									elseif SN > "PNTMPNCPR" then
										if SN < "PNTMPOUTHEAL" then
											if SN == "PNTMPORCMIT" then
												Result = 19.2/1200
											end
										elseif SN > "PNTMPOUTHEAL" then
											if SN == "PNTMPPHYMIT" then
												Result = 36/1200
											end
										else
											Result = 30/1200
										end
									else
										Result = 0.5
									end
								else
									Result = 28/1200
								end
							else
								Result = 11.75/1200
							end
						elseif SN > "PNTMPPHYMITC" then
							if SN < "PROGBARMOUR" then
								if SN < "PNTMPTACMITC" then
									if SN < "PNTMPRESISTC" then
										if SN < "PNTMPPOWERT" then
											if SN == "PNTMPPOWER" then
												Result = 1
											end
										elseif SN > "PNTMPPOWERT" then
											if SN == "PNTMPRESIST" then
												Result = 36/1200
											end
										else
											Result = 0.6666
										end
									elseif SN > "PNTMPRESISTC" then
										if SN < "PNTMPTACHPS" then
											if SN == "PNTMPSHIELDBLOCK" then
												Result = 80/1200
											end
										elseif SN > "PNTMPTACHPS" then
											if SN == "PNTMPTACMIT" then
												Result = 36/1200
											end
										else
											Result = 0.0875
										end
									else
										Result = 20/1200
									end
								elseif SN > "PNTMPTACMITC" then
									if SN < "POISONRESIST" then
										if SN < "PNTMPVITALITYC" then
											if SN == "PNTMPVITALITY" then
												Result = 0.175
											end
										elseif SN > "PNTMPVITALITYC" then
											if SN == "PNTMPVITALITYT" then
												Result = 0.225
											end
										else
											Result = 199/1200
										end
									elseif SN > "POISONRESIST" then
										if SN < "POWER" then
											if SN == "POISONRESISTT" then
												Result = CalcStat("ResistAddT",L,N)
											end
										elseif SN > "POWER" then
											if SN == "POWERT" then
												Result = EquSng(StatLinInter("PntMPPowerT","TraitPntSVital","ProgBPower","",L,N,0))
											end
										else
											Result = EquSng(StatLinInter("PntMPPower","ItemPntSVital","ProgBPower","",L,N,0))
										end
									else
										Result = CalcStat("ResistAdd",L,N)
									end
								else
									Result = 20/1200
								end
							elseif SN > "PROGBARMOUR" then
								if SN < "PROGBENERGY" then
									if SN < "PROGBBPE" then
										if SN < "PROGBARMOURLIGHT" then
											if SN == "PROGBARMOURHEAVY" then
												Result = CalcStat("BRatProgB",L,"BRatMitHeavy")
											end
										elseif SN > "PROGBARMOURLIGHT" then
											if SN == "PROGBARMOURMEDIUM" then
												Result = CalcStat("BRatProgB",L,"BRatMitMedium")
											end
										else
											Result = CalcStat("BRatProgB",L,"BRatMitLight")
										end
									elseif SN > "PROGBBPE" then
										if SN < "PROGBCRITDEF" then
											if SN == "PROGBCOMBATDAMAGEMOD" then
												if Lm <= 25 then
													Result = LinFmod(1,5,45.5830901,1,25,L)
												elseif Lm <= 50 then
													Result = LinFmod(1,45.5830901,120,25,50,L)
												elseif Lm <= 60 then
													Result = LinFmod(1,120,175.56,50,60,L)
												elseif Lm <= 65 then
													Result = LinFmod(1,175.56,200.79,60,65,L)
												elseif Lm <= 75 then
													Result = LinFmod(1,200.79,292.5,65,75,L)
												elseif Lm <= 85 then
													Result = LinFmod(1,292.5,421.2,75,85,L)
												elseif Lm <= 95 then
													Result = LinFmod(1,421.2,600.3,85,95,L)
												elseif Lm <= 100 then
													Result = LinFmod(1,600.3,774,95,100,L)
												elseif Lm <= 105 then
													Result = LinFmod(1,774,985.5,100,105,L)
												elseif Lm <= 115 then
													Result = LinFmod(1,985.5,1350,105,115,L)
												elseif Lm <= 120 then
													Result = LinFmod(1,1350,1710,115,120,L)
												elseif Lm <= 130 then
													Result = LinFmod(1,1710,2330.25,120,130,L)
												elseif Lm <= 140 then
													Result = LinFmod(1,2330.25,3600,130,140,L)
												else
													Result = LinFmod(1,4010,5535,141,150,L)
												end
											end
										elseif SN > "PROGBCRITDEF" then
											if SN == "PROGBCRITHIT" then
												Result = CalcStat("BRatProgB",L,"BRatExtra")
											end
										else
											Result = CalcStat("BRatProgB",L,"BRatStandard")
										end
									else
										Result = CalcStat("BRatProgB",L,"BRatStandard")
									end
								elseif SN > "PROGBENERGY" then
									if SN < "PROGBICMR" then
										if SN < "PROGBFINESSE" then
											if SN == "PROGBFATE" then
												Result = CalcStat("ProgBEnergy",L)
											end
										elseif SN > "PROGBFINESSE" then
											if SN == "PROGBHEALTH" then
												if Lm <= 50 then
													Result = LinFmod(1,8,60,1,50,L)
												elseif Lm <= 60 then
													Result = LinFmod(1,60,80,50,60,L)
												elseif Lm <= 65 then
													Result = LinFmod(1,80,100,60,65,L)
												elseif Lm <= 75 then
													Result = LinFmod(1,100,150,65,75,L)
												elseif Lm <= 85 then
													Result = LinFmod(1,150,226,75,85,L)
												elseif Lm <= 95 then
													Result = LinFmod(1,226,300,85,95,L)
												elseif Lm <= 100 then
													Result = LinFmod(1,300,450,95,100,L)
												elseif Lm <= 105 then
													Result = LinFmod(1,450,600,100,105,L)
												elseif Lm <= 115 then
													Result = LinFmod(1,660,900,106,115,L)
												elseif Lm <= 120 then
													Result = LinFmod(1,1040,1120,116,120,L)
												elseif Lm <= 130 then
													Result = LinFmod(1,1280,1680,121,130,L)
												elseif Lm <= 140 then
													Result = LinFmod(1,1940,3360,131,140,L)
												elseif Lm <= 150 then
													Result = LinFmod(1,3860,6800,141,150,L)
												else
													Result = LinFmod(1,6800,13600,151,160,L)
												end
											end
										else
											Result = CalcStat("BRatProgB",L,"BRatStandard")
										end
									elseif SN > "PROGBICMR" then
										if SN < "PROGBINHEAL" then
											if SN == "PROGBICPR" then
												Result = CalcStat("ProgBEnergy",L)
											end
										elseif SN > "PROGBINHEAL" then
											if SN == "PROGBMAIN" then
												Result = CalcStat("StdProg",L,1.75)
											end
										else
											Result = CalcStat("BRatProgB",L,"BRatStandard")
										end
									else
										Result = CalcStat("ProgBHealth",L)
									end
								else
									if Lm <= 50 then
										Result = LinFmod(1,4,8,1,50,L)
									elseif Lm <= 60 then
										Result = LinFmod(1,8,10.6,50,60,L)
									elseif Lm <= 65 then
										Result = LinFmod(1,10.6,13.2,60,65,L)
									elseif Lm <= 75 then
										Result = LinFmod(1,13.2,19.8,65,75,L)
									elseif Lm <= 85 then
										Result = LinFmod(1,19.8,29.8,75,85,L)
									elseif Lm <= 95 then
										Result = LinFmod(1,29.8,39.6,85,95,L)
									elseif Lm <= 100 then
										Result = LinFmod(1,39.6,52,95,100,L)
									elseif Lm <= 105 then
										Result = LinFmod(1,52,70,100,105,L)
									elseif Lm <= 115 then
										Result = LinFmod(1,78,106,106,115,L)
									elseif Lm <= 120 then
										Result = LinFmod(1,122,132,116,120,L)
									elseif Lm <= 130 then
										Result = LinFmod(1,152,198,121,130,L)
									elseif Lm <= 140 then
										Result = LinFmod(1,228,396,131,140,L)
									elseif Lm <= 150 then
										Result = LinFmod(1,456,800,141,150,L)
									else
										Result = LinFmod(1,800,1600,151,160,L)
									end
								end
							else
								Result = CalcStat("BRatProgB",L,"BRatMitMedium")
							end
						else
							Result = 20/1200
						end
					elseif SN > "PROGBMASTERY" then
						if SN < "REPMAINL" then
							if SN < "PROGEXTMEDEXPRAW" then
								if SN < "PROGBTACHPS" then
									if SN < "PROGBNCPR" then
										if SN < "PROGBMORALE" then
											if SN == "PROGBMITIGATION" then
												Result = CalcStat("BRatProgB",L,"BRatMitMedium")
											end
										elseif SN > "PROGBMORALE" then
											if SN == "PROGBNCMR" then
												Result = CalcStat("ProgBHealth",L)
											end
										else
											Result = CalcStat("ProgBHealth",L)
										end
									elseif SN > "PROGBNCPR" then
										if SN < "PROGBPOWER" then
											if SN == "PROGBOUTHEAL" then
												Result = CalcStat("BRatProgB",L,"BRatOutHeal")
											end
										elseif SN > "PROGBPOWER" then
											if SN == "PROGBRESIST" then
												Result = CalcStat("BRatProgB",L,"BRatExtra")
											end
										else
											Result = CalcStat("ProgBEnergy",L)
										end
									else
										Result = CalcStat("ProgBEnergy",L)
									end
								elseif SN > "PROGBTACHPS" then
									if SN < "PROGEXTCOMLOWRAW" then
										if SN < "PROGEXTCOMHIGHRAW" then
											if SN == "PROGBVITALITY" then
												Result = CalcStat("ProgBHealth",L)
											end
										elseif SN > "PROGEXTCOMHIGHRAW" then
											if SN == "PROGEXTCOMHIGHRND" then
												if 121 <= Lp and Lm <= 121 then
													Result = ExpFmod(N,121,20,L,0)
												elseif 122 <= Lp and Lm <= 125 then
													Result = ExpFmod(CalcStat("ProgExtComHighRnd",121,N),122,5.5,L,0)
												elseif 126 <= Lp and Lm <= 126 then
													Result = ExpFmod(CalcStat("ProgExtComHighRnd",125,N),126,20,L,0)
												elseif 127 <= Lp and Lm <= 130 then
													Result = ExpFmod(CalcStat("ProgExtComHighRnd",126,N),127,5.5,L,0)
												elseif 131 <= Lp and Lm <= 131 then
													Result = ExpFmod(CalcStat("ProgExtComHighRnd",130,N),131,20,L,0)
												elseif 132 <= Lp and Lm <= 150 then
													Result = ExpFmod(CalcStat("ProgExtComHighRnd",131,N),132,5.5,L,0)
												elseif 151 <= Lp then
													Result = CalcStat("ProgExtComHighRnd",150,N)
												end
											end
										else
											if 121 <= Lp and Lm <= 121 then
												Result = ExpFmod(N,121,20,L,nil)
											elseif 122 <= Lp and Lm <= 125 then
												Result = ExpFmod(CalcStat("ProgExtComHighRaw",121,N),122,5.5,L,nil)
											elseif 126 <= Lp and Lm <= 126 then
												Result = ExpFmod(CalcStat("ProgExtComHighRaw",125,N),126,20,L,nil)
											elseif 127 <= Lp and Lm <= 130 then
												Result = ExpFmod(CalcStat("ProgExtComHighRaw",126,N),127,5.5,L,nil)
											elseif 131 <= Lp and Lm <= 131 then
												Result = ExpFmod(CalcStat("ProgExtComHighRaw",130,N),131,20,L,nil)
											elseif 132 <= Lp and Lm <= 150 then
												Result = ExpFmod(CalcStat("ProgExtComHighRaw",131,N),132,5.5,L,nil)
											elseif 151 <= Lp then
												Result = CalcStat("ProgExtComHighRaw",150,N)
											end
										end
									elseif SN > "PROGEXTCOMLOWRAW" then
										if SN < "PROGEXTHIGHLINEXPRND" then
											if SN == "PROGEXTCOMLOWRND" then
												if 116 <= Lp and Lm <= 116 then
													Result = ExpFmod(N,116,20,L,0)
												elseif 117 <= Lp and Lm <= 120 then
													Result = ExpFmod(CalcStat("ProgExtComLowRnd",116,N),117,5.5,L,0)
												elseif 121 <= Lp then
													Result = CalcStat("ProgExtComHighRnd",L,CalcStat("ProgExtComLowRnd",120,N))
												end
											end
										elseif SN > "PROGEXTHIGHLINEXPRND" then
											if SN == "PROGEXTLOWEXPRND" then
												if 106 <= Lp and Lm <= 115 then
													Result = ExpFmod(N,106,5.5,L,0)
												elseif 116 <= Lp then
													Result = CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtLowExpRnd",115,N))
												end
											end
										else
											if 106 <= Lp and Lm <= 115 then
												Result = LinFmod(N,2,4,106,115,L,-1)
											elseif 116 <= Lp then
												Result = CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtHighLinExpRnd",115,N))
											end
										end
									else
										if 116 <= Lp and Lm <= 116 then
											Result = ExpFmod(N,116,20,L,nil)
										elseif 117 <= Lp and Lm <= 120 then
											Result = ExpFmod(CalcStat("ProgExtComLowRaw",116,N),117,5.5,L,nil)
										elseif 121 <= Lp then
											Result = CalcStat("ProgExtComHighRaw",L,CalcStat("ProgExtComLowRaw",120,N))
										end
									end
								else
									Result = CalcStat("ProgBHealth",L)
								end
							elseif SN > "PROGEXTMEDEXPRAW" then
								if SN < "REPAGILITYH" then
									if SN < "REAVERCDCALCTYPECOMPHYMIT" then
										if SN < "RACENAME" then
											if SN == "PROGEXTMPEXPRND" then
												if 106 <= Lp and Lm <= 114 then
													Result = ExpFmod(N,106,7.5,L,0)
												elseif 115 <= Lp and Lm <= 115 then
													Result = 2*N
												elseif 116 <= Lp and Lm <= 119 then
													Result = ExpFmod(CalcStat("ProgExtMpExpRnd",115,N),116,25,L,0)
												elseif 120 <= Lp and Lm <= 120 then
													Result = RoundDbl((16/3)*N)
												elseif 121 <= Lp then
													Result = CalcStat("ProgExtComHighRnd",L,CalcStat("ProgExtMpExpRnd",120,N))
												end
											end
										elseif SN > "RACENAME" then
											if SN == "REAVERCANBLOCK" then
												Result = 1
											end
										else
											if 6 <= Lp and Lm <= 6 then
												Result = "Uruk"
											elseif 7 <= Lp and Lm <= 7 then
												Result = "Orc"
											elseif 12 <= Lp and Lm <= 12 then
												Result = "Spider"
											elseif 23 <= Lp and Lm <= 23 then
												Result = "Man"
											elseif 27 <= Lp and Lm <= 27 then
												Result = "Critter"
											elseif 65 <= Lp and Lm <= 65 then
												Result = "Elf"
											elseif 66 <= Lp and Lm <= 66 then
												Result = "Warg"
											elseif 73 <= Lp and Lm <= 73 then
												Result = "Dwarf"
											elseif 81 <= Lp and Lm <= 81 then
												Result = "Hobbit"
											elseif 114 <= Lp and Lm <= 114 then
												Result = "Beorning"
											elseif 117 <= Lp and Lm <= 117 then
												Result = "HighElf"
											elseif 120 <= Lp and Lm <= 120 then
												Result = "StoutAxe"
											elseif 125 <= Lp and Lm <= 125 then
												Result = "RiverHobbit"
											else
												Result = ""
											end
										end
									elseif SN > "REAVERCDCALCTYPECOMPHYMIT" then
										if SN < "REAVERCDCALCTYPETACMIT" then
											if SN == "REAVERCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										elseif SN > "REAVERCDCALCTYPETACMIT" then
											if SN == "REAVERCDHASPOWER" then
												Result = 1
											end
										else
											Result = 27
										end
									else
										Result = 13
									end
								elseif SN > "REPAGILITYH" then
									if SN < "REPFATEH" then
										if SN < "REPCRITDEF" then
											if SN == "REPAGILITYL" then
												Result = CalcStat("RepMainL",L)
											end
										elseif SN > "REPCRITDEF" then
											if SN == "REPCRITHIT" then
												if Lm <= 50 then
													Result = LinFmod(1,300,496,1,50,L)
												elseif Lm <= 85 then
													Result = LinFmod(1,496,636,50,85,L)
												elseif Lm <= 105 then
													Result = LinFmod(1,636,716,85,105,L)
												else
													Result = LinFmod(1,716,776,105,120,L)
												end
											end
										else
											if Lm <= 50 then
												Result = LinFmod(1,900,1488,1,50,L)
											elseif Lm <= 85 then
												Result = LinFmod(1,1488,1908,50,85,L)
											elseif Lm <= 105 then
												Result = LinFmod(1,1908,2148,85,105,L)
											else
												Result = LinFmod(1,2148,2328,105,120,L)
											end
										end
									elseif SN > "REPFATEH" then
										if SN < "REPFINESSE" then
											if SN == "REPFATEL" then
												Result = CalcStat("RepMainL",L)
											end
										elseif SN > "REPFINESSE" then
											if SN == "REPMAINH" then
												if Lm <= 50 then
													Result = RoundDblDown(LinFmod(1,80,153,1,50,L))
												elseif Lm <= 85 then
													Result = RoundDblDown(LinFmod(1,153,206,50,85,L))
												elseif Lm <= 105 then
													Result = RoundDblDown(LinFmod(1,206,236,85,105,L))
												else
													Result = RoundDblDown(LinFmod(1,236,258,105,120,L))
												end
											end
										else
											if Lm <= 50 then
												Result = LinFmod(1,322,557,1,50,L)
											elseif Lm <= 85 then
												Result = LinFmod(1,557,749.9477,50,85,L)
											elseif Lm <= 105 then
												Result = LinFmod(1,749.9477,859.1634,85,105,L)
											else
												Result = LinFmod(1,859.1634,939.2549,105,120,L)
											end
										end
									else
										Result = CalcStat("RepMainH",L)
									end
								else
									Result = CalcStat("RepMainH",L)
								end
							else
								if 106 <= Lp and Lm <= 106 then
									Result = ExpFmod(N,106,10,L,nil)
								elseif 107 <= Lp and Lm <= 115 then
									Result = ExpFmod(CalcStat("ProgExtMedExpRaw",106,N),107,5.5,L,nil)
								elseif 116 <= Lp then
									Result = CalcStat("ProgExtComLowRaw",L,CalcStat("ProgExtMedExpRaw",115,N))
								end
							end
						elseif SN > "REPMAINL" then
							if SN < "RESISTCIRAW" then
								if SN < "REPWILLH" then
									if SN < "REPPOWER" then
										if SN < "REPMIGHTL" then
											if SN == "REPMIGHTH" then
												Result = CalcStat("RepMainH",L)
											end
										elseif SN > "REPMIGHTL" then
											if SN == "REPMORALE" then
												if Lm <= 50 then
													Result = LinFmod(1,187,427,1,50,L)
												elseif Lm <= 85 then
													Result = LinFmod(1,427,599,50,85,L)
												elseif Lm <= 105 then
													Result = LinFmod(1,599,697,85,105,L)
												else
													Result = LinFmod(1,697,770,105,120,L)
												end
											end
										else
											Result = CalcStat("RepMainL",L)
										end
									elseif SN > "REPPOWER" then
										if SN < "REPVITALITYH" then
											if SN == "REPTACMIT" then
												if Lm <= 50 then
													Result = LinFmod(1,675,1116,1,50,L)
												elseif Lm <= 85 then
													Result = LinFmod(1,1116,1431,50,85,L)
												elseif Lm <= 105 then
													Result = LinFmod(1,1431,1611,85,105,L)
												else
													Result = LinFmod(1,1611,1746,105,120,L)
												end
											end
										elseif SN > "REPVITALITYH" then
											if SN == "REPVITALITYL" then
												Result = CalcStat("RepMainL",L)
											end
										else
											Result = CalcStat("RepMainH",L)
										end
									else
										if Lm <= 50 then
											Result = LinFmod(1,94,212,1,50,L)
										elseif Lm <= 85 then
											Result = LinFmod(1,212,296,50,85,L)
										elseif Lm <= 105 then
											Result = LinFmod(1,296,344,85,105,L)
										else
											Result = LinFmod(1,344,380,105,120,L)
										end
									end
								elseif SN > "REPWILLH" then
									if SN < "RESISTADDT" then
										if SN < "RESIST" then
											if SN == "REPWILLL" then
												Result = CalcStat("RepMainL",L)
											end
										elseif SN > "RESIST" then
											if SN == "RESISTADD" then
												Result = CalcStat("Resist",L,N)
											end
										else
											Result = EquSng(StatLinInter("PntMPResist","ItemPntS","ProgBResist","AdjItem",L,N,0))
										end
									elseif SN > "RESISTADDT" then
										if SN < "RESISTCI" then
											if SN == "RESISTC" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ResistCI",CalcStat("ResistCILvlFilter",N),N),0)
											end
										elseif SN > "RESISTCI" then
											if SN == "RESISTCILVLFILTER" then
												if 2.4 <= Lp and Lm <= 2.4 or 3.2 <= Lp and Lm <= 3.2 or 4 <= Lp and Lm <= 4 or 8 <= Lp and Lm <= 8 or 12 <= Lp and Lm <= 12 then
													Result = 515
												else
													Result = CalcStat("CreepILvlCurr",L)
												end
											end
										else
											Result = RoundDblLotro(CalcStat("ResistCIRaw",L,N))
										end
									else
										Result = CalcStat("ResistT",L,N)
									end
								else
									Result = CalcStat("RepMainH",L)
								end
							elseif SN > "RESISTCIRAW" then
								if SN < "RESISTPRATPCAPR" then
									if SN < "RESISTPRATPA" then
										if SN < "RESISTPPRAT" then
											if SN == "RESISTCRAW" then
												Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ResistCIRaw",CalcStat("ResistCILvlFilter",N),N),99)
											end
										elseif SN > "RESISTPPRAT" then
											if SN == "RESISTPRATP" then
												Result = CalcPercAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCap",L),N)
											end
										else
											Result = CalcRatAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCapR",L),N)
										end
									elseif SN > "RESISTPRATPA" then
										if SN < "RESISTPRATPC" then
											if SN == "RESISTPRATPB" then
												Result = CalcStat("BRatRounded",L,"BRatExtra")
											end
										elseif SN > "RESISTPRATPC" then
											if SN == "RESISTPRATPCAP" then
												Result = 50
											end
										else
											Result = 0.5
										end
									else
										Result = 150
									end
								elseif SN > "RESISTPRATPCAPR" then
									if SN < "RIVERHOBBITRDPSVTWONAME" then
										if SN < "RIVERHOBBITRDPSVONENAME" then
											if SN == "RESISTT" then
												Result = EquSng(StatLinInter("PntMPResist","TraitPntS","ProgBResist","AdjTrait",L,N,0))
											end
										elseif SN > "RIVERHOBBITRDPSVONENAME" then
											if SN == "RIVERHOBBITRDPSVONEWILL" then
												Result = CalcStat("RivHobSeenWorldWill",L)
											end
										else
											Result = "Seen the World"
										end
									elseif SN > "RIVERHOBBITRDPSVTWONAME" then
										if SN < "RIVERHOBBITRDTRAITFROSTMITP" then
											if SN == "RIVERHOBBITRDTRAITAGILITY" then
												Result = CalcStat("RivHobSlipperyAgility",L)
											end
										elseif SN > "RIVERHOBBITRDTRAITFROSTMITP" then
											if SN == "RIVERHOBBITRDTRAITMORALE" then
												Result = CalcStat("RivHobHardyHolbMorale",L)
											end
										else
											Result = CalcStat("RivHobSwimmerFrostMitP",L)
										end
									else
										Result = ""
									end
								else
									Result = CalcStat("ResistPRatPB",L)*CalcStat("ResistPRatPC",L)
								end
							else
								Result = StatLinInter("PntMPResistC","ItemPntS","ProgBResist","AdjCreepItem",L,N,4)
							end
						else
							if Lm <= 50 then
								Result = RoundDblDown(LinFmod(1,53,102,1,50,L))
							elseif Lm <= 85 then
								Result = RoundDblDown(LinFmod(1,102,137,50,85,L))
							elseif Lm <= 105 then
								Result = RoundDblDown(LinFmod(1,137,157,85,105,L))
							else
								Result = RoundDblDown(LinFmod(1,157,172,105,120,L))
							end
						end
					else
						Result = CalcStat("BRatProgB",L,"BRatExtra")
					end
				elseif SN > "RIVERHOBBITRDTRAITWILL" then
					if SN < "STDMORALEL" then
						if SN < "RUNEKEEPERCDHASPOWER" then
							if SN < "RUNEKEEPERCDBASEAGILITY" then
								if SN < "RUNEKEEPERCDAGILITYTOCRITHIT" then
									if SN < "RIVHOBSLIPPERYAGILITY" then
										if SN < "RIVHOBSECLUSIONWILL" then
											if SN == "RIVHOBHARDYHOLBMORALE" then
												Result = CalcStat("MoraleT",L,1.0)
											end
										elseif SN > "RIVHOBSECLUSIONWILL" then
											if SN == "RIVHOBSEENWORLDWILL" then
												Result = CalcStat("WillT",L,1.0)
											end
										else
											Result = -CalcStat("WillT",L,0.4)
										end
									elseif SN > "RIVHOBSLIPPERYAGILITY" then
										if SN < "RKDETERMINATIONWILL" then
											if SN == "RIVHOBSWIMMERFROSTMITP" then
												Result = 1
											end
										elseif SN > "RKDETERMINATIONWILL" then
											if SN == "RKFORTUNESMILESFATE" then
												Result = CalcStat("FateT",L,CalcStat("Trait567810Choice",N)*0.4)
											end
										else
											Result = CalcStat("WillT",L,CalcStat("Trait567810Choice",N)*0.4)
										end
									else
										Result = CalcStat("AgilityT",L,1.0)
									end
								elseif SN > "RUNEKEEPERCDAGILITYTOCRITHIT" then
									if SN < "RUNEKEEPERCDARMOURTOCOMPHYMIT" then
										if SN < "RUNEKEEPERCDAGILITYTOFINESSE" then
											if SN == "RUNEKEEPERCDAGILITYTOEVADE" then
												Result = 1
											end
										elseif SN > "RUNEKEEPERCDAGILITYTOFINESSE" then
											if SN == "RUNEKEEPERCDAGILITYTOTACMAS" then
												Result = 2
											end
										else
											Result = 1
										end
									elseif SN > "RUNEKEEPERCDARMOURTOCOMPHYMIT" then
										if SN < "RUNEKEEPERCDARMOURTOTACMIT" then
											if SN == "RUNEKEEPERCDARMOURTONONPHYMIT" then
												Result = 0.2
											end
										elseif SN > "RUNEKEEPERCDARMOURTOTACMIT" then
											if SN == "RUNEKEEPERCDARMOURTYPE" then
												Result = 1
											end
										else
											Result = 0.2
										end
									else
										Result = 1
									end
								else
									Result = 2
								end
							elseif SN > "RUNEKEEPERCDBASEAGILITY" then
								if SN < "RUNEKEEPERCDBASEPOWER" then
									if SN < "RUNEKEEPERCDBASEMIGHT" then
										if SN < "RUNEKEEPERCDBASEICMR" then
											if SN == "RUNEKEEPERCDBASEFATE" then
												Result = CalcStat("ClassBaseFate",L)
											end
										elseif SN > "RUNEKEEPERCDBASEICMR" then
											if SN == "RUNEKEEPERCDBASEICPR" then
												Result = CalcStat("ClassBaseICPR",L)
											end
										else
											Result = CalcStat("ClassBaseICMRL",L)
										end
									elseif SN > "RUNEKEEPERCDBASEMIGHT" then
										if SN < "RUNEKEEPERCDBASENCMR" then
											if SN == "RUNEKEEPERCDBASEMORALE" then
												Result = CalcStat("ClassBaseMorale",L)
											end
										elseif SN > "RUNEKEEPERCDBASENCMR" then
											if SN == "RUNEKEEPERCDBASENCPR" then
												Result = CalcStat("ClassBaseNCPR",L)
											end
										else
											Result = CalcStat("ClassBaseNCMRL",L)
										end
									else
										Result = CalcStat("ClassBaseMightM",L)
									end
								elseif SN > "RUNEKEEPERCDBASEPOWER" then
									if SN < "RUNEKEEPERCDCALCTYPENONPHYMIT" then
										if SN < "RUNEKEEPERCDBASEWILL" then
											if SN == "RUNEKEEPERCDBASEVITALITY" then
												Result = CalcStat("ClassBaseVitality",L)
											end
										elseif SN > "RUNEKEEPERCDBASEWILL" then
											if SN == "RUNEKEEPERCDCALCTYPECOMPHYMIT" then
												Result = 12
											end
										else
											Result = CalcStat("ClassBaseWillH",L)
										end
									elseif SN > "RUNEKEEPERCDCALCTYPENONPHYMIT" then
										if SN < "RUNEKEEPERCDFATETONCPR" then
											if SN == "RUNEKEEPERCDCALCTYPETACMIT" then
												Result = 25
											end
										elseif SN > "RUNEKEEPERCDFATETONCPR" then
											if SN == "RUNEKEEPERCDFATETOPOWER" then
												Result = 1
											end
										else
											Result = 0.07
										end
									else
										Result = 12
									end
								else
									Result = CalcStat("ClassBasePower",L)
								end
							else
								Result = CalcStat("ClassBaseAgilityL",L)
							end
						elseif SN > "RUNEKEEPERCDHASPOWER" then
							if SN < "RUNEKEEPERCDWILLTOTACMIT" then
								if SN < "RUNEKEEPERCDVITALITYTOICMR" then
									if SN < "RUNEKEEPERCDMIGHTTOTACMIT" then
										if SN < "RUNEKEEPERCDMIGHTTOOUTHEAL" then
											if SN == "RUNEKEEPERCDMIGHTTOCRITHIT" then
												Result = 1
											end
										elseif SN > "RUNEKEEPERCDMIGHTTOOUTHEAL" then
											if SN == "RUNEKEEPERCDMIGHTTOTACMAS" then
												Result = 2
											end
										else
											Result = 2
										end
									elseif SN > "RUNEKEEPERCDMIGHTTOTACMIT" then
										if SN < "RUNEKEEPERCDPHYMITTONONPHYMIT" then
											if SN == "RUNEKEEPERCDPHYMITTOCOMPHYMIT" then
												Result = 1
											end
										elseif SN > "RUNEKEEPERCDPHYMITTONONPHYMIT" then
											if SN == "RUNEKEEPERCDTACMASTOOUTHEAL" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 1
									end
								elseif SN > "RUNEKEEPERCDVITALITYTOICMR" then
									if SN < "RUNEKEEPERCDWILLTOEVADE" then
										if SN < "RUNEKEEPERCDVITALITYTONCMR" then
											if SN == "RUNEKEEPERCDVITALITYTOMORALE" then
												Result = 4.5
											end
										elseif SN > "RUNEKEEPERCDVITALITYTONCMR" then
											if SN == "RUNEKEEPERCDWILLTOCRITHIT" then
												Result = 1
											end
										else
											Result = 0.12
										end
									elseif SN > "RUNEKEEPERCDWILLTOEVADE" then
										if SN < "RUNEKEEPERCDWILLTORESIST" then
											if SN == "RUNEKEEPERCDWILLTOPHYMIT" then
												Result = 1
											end
										elseif SN > "RUNEKEEPERCDWILLTORESIST" then
											if SN == "RUNEKEEPERCDWILLTOTACMAS" then
												Result = 3
											end
										else
											Result = 1
										end
									else
										Result = 2
									end
								else
									Result = 0.012
								end
							elseif SN > "RUNEKEEPERCDWILLTOTACMIT" then
								if SN < "SONGRESISTT" then
									if SN < "SHIELDBRAWLERBLOCK" then
										if SN < "SHADOWMITT" then
											if SN == "SHADOWMIT" then
												Result = CalcStat("DmgTypeMit",L,N)
											end
										elseif SN > "SHADOWMITT" then
											if SN == "SHIELDBLOCK" then
												Result = EquSng(StatLinInter("PntMPShieldBlock","ItemPntS","ProgBBPE","AdjItem",L,N,0))
											end
										else
											Result = CalcStat("DmgTypeMitT",L,N)
										end
									elseif SN > "SHIELDBRAWLERBLOCK" then
										if SN < "SKILLPOWERCOSTMOUNTED" then
											if SN == "SKILLPOWERCOST" then
												if Lm <= 140 then
													Result = CalcStat("CombatDamageModEnergy",L,0.64*N)
												else
													Result = CalcStat("CombatDamageModEnergy",L,1.05*0.64*N)
												end
											end
										elseif SN > "SKILLPOWERCOSTMOUNTED" then
											if SN == "SONGRESIST" then
												Result = CalcStat("ResistAdd",L,N)
											end
										else
											Result = CalcStat("CombatDamageModEnergy",L,0.64*N)
										end
									else
										Result = CalcStat("DwarfShieldBrwlBlock",L)
									end
								elseif SN > "SONGRESISTT" then
									if SN < "STALKERCDCALCTYPETACMIT" then
										if SN < "STALKERCDCALCTYPECOMPHYMIT" then
											if SN == "STALKERCANBLOCK" then
												Result = 1
											end
										elseif SN > "STALKERCDCALCTYPECOMPHYMIT" then
											if SN == "STALKERCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										else
											Result = 13
										end
									elseif SN > "STALKERCDCALCTYPETACMIT" then
										if SN < "STATC" then
											if SN == "STALKERCDHASPOWER" then
												Result = 1
											end
										elseif SN > "STATC" then
											if SN == "STDMORALEH" then
												if Lm <= 105 then
													Result = RoundDbl(2*CalcStat("StdMoraleRaw",L))
												else
													Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("StdMoraleH",105))
												end
											end
										else
											Result = CalcStat(C,L)
										end
									else
										Result = 27
									end
								else
									Result = CalcStat("ResistAddT",L,N)
								end
							else
								Result = 1
							end
						else
							Result = 1
						end
					elseif SN > "STDMORALEL" then
						if SN < "TACDMGPBONUS" then
							if SN < "STOUTAXERDTRAITSHADOWMITP" then
								if SN < "STOUTAXERDPSVONENAME" then
									if SN < "STDPOWERH" then
										if SN < "STDMORALERAW" then
											if SN == "STDMORALEM" then
												if Lm <= 105 then
													Result = RoundDbl(1.5*CalcStat("StdMoraleRaw",L))
												else
													Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("StdMoraleM",105))
												end
											end
										elseif SN > "STDMORALERAW" then
											if SN == "STDPNTS" then
												Result = {{1,50,60,65,75,85,95,100,105,106,115,116,120,121,130,131,140,141,150,151,160},{1,50,60,65,75,85,95,100,105,106,115,116,120,121,130,131,140,141,150,151,160}}
											end
										else
											if Lm <= 50 then
												Result = LinFmod(1,7.51,227.59,1,50,L)
											else
												Result = LinFmod(1,227.59,1327.5,50,105,L)
											end
										end
									elseif SN > "STDPOWERH" then
										if SN < "STDPOWERRAW" then
											if SN == "STDPOWERL" then
												if Lm <= 105 then
													Result = RoundDbl(CalcStat("StdPowerRaw",L))
												else
													Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("StdPowerL",105))
												end
											end
										elseif SN > "STDPOWERRAW" then
											if SN == "STDPROG" then
												if Lm <= 50 then
													Result = LinFmod(N,1,10,1,50,L,"P")
												elseif Lm <= 60 then
													Result = LinFmod(CalcStat("StdProg",50,N),10/10,15/10,50,60,L,"P")
												elseif Lm <= 65 then
													Result = LinFmod(CalcStat("StdProg",60,N),15/15,20/15,60,65,L,"P")
												elseif Lm <= 75 then
													Result = LinFmod(CalcStat("StdProg",65,N),20/20,30/20,65,75,L,"P")
												elseif Lm <= 85 then
													Result = LinFmod(CalcStat("StdProg",75,N),30/30,45/30,75,85,L,"P")
												elseif Lm <= 95 then
													Result = LinFmod(CalcStat("StdProg",85,N),45/45,65/45,85,95,L,"P")
												elseif Lm <= 100 then
													Result = LinFmod(CalcStat("StdProg",95,N),65/65,90.27/65,95,100,L,"P")
												elseif Lm <= 105 then
													Result = LinFmod(CalcStat("StdProg",100,N),90.27/90.27,120.24/90.27,100,105,L,"P")
												elseif Lm <= 115 then
													Result = LinFmod(CalcStat("StdProg",105,N),1.1,1.5,106,115,L,"P")
												elseif Lm <= 120 then
													Result = LinFmod(CalcStat("StdProg",115,N),1.15,1.25,116,120,L,"P")
												elseif Lm <= 130 then
													Result = LinFmod(CalcStat("StdProg",120,N),1.15,1.5,121,130,L,"P")
												elseif Lm <= 140 then
													Result = LinFmod(CalcStat("StdProg",130,N),1.15,2,131,140,L,"P")
												elseif Lm <= 150 then
													Result = LinFmod(CalcStat("StdProg",140,N),1.3,2.205,141,150,L,"P")
												else
													Result = LinFmod(CalcStat("StdProg",150,N),1,2,151,160,L,"P")
												end
											end
										else
											if Lm <= 50 then
												Result = LinFmod(1,3,91.0375,1,50,L)
											else
												Result = LinFmod(1,91.0375,421,50,105,L)
											end
										end
									else
										if Lm <= 105 then
											Result = RoundDbl(2*CalcStat("StdPowerRaw",L))
										else
											Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("StdPowerH",105))
										end
									end
								elseif SN > "STOUTAXERDPSVONENAME" then
									if SN < "STOUTAXERDTRAITDISEASERESISTP" then
										if SN < "STOUTAXERDPSVTWONAME" then
											if SN == "STOUTAXERDPSVONEVITALITY" then
												Result = CalcStat("StoutUnwritDestVitality",L)
											end
										elseif SN > "STOUTAXERDPSVTWONAME" then
											if SN == "STOUTAXERDTRAITAGILITY" then
												Result = CalcStat("StoutWrBlackLAgility",L)
											end
										else
											Result = ""
										end
									elseif SN > "STOUTAXERDTRAITDISEASERESISTP" then
										if SN < "STOUTAXERDTRAITMIGHT" then
											if SN == "STOUTAXERDTRAITFATE" then
												Result = CalcStat("StoutDoomDrasaFate",L)
											end
										elseif SN > "STOUTAXERDTRAITMIGHT" then
											if SN == "STOUTAXERDTRAITPHYMITP" then
												Result = CalcStat("StoutUnyieldingPhyMitP",L)
											end
										else
											Result = CalcStat("StoutWrBlackLMight",L)
										end
									else
										Result = CalcStat("StoutWrBlackLDiseaseResistP",L)
									end
								else
									Result = "Unwritten Destiny"
								end
							elseif SN > "STOUTAXERDTRAITSHADOWMITP" then
								if SN < "STOUTWRBLACKLAGILITY" then
									if SN < "STOUTSHADOWEYEVITALITY" then
										if SN < "STOUTAXERDTRAITWILL" then
											if SN == "STOUTAXERDTRAITVITALITY" then
												Result = CalcStat("StoutShadowEyeVitality",L)
											end
										elseif SN > "STOUTAXERDTRAITWILL" then
											if SN == "STOUTDOOMDRASAFATE" then
												Result = -CalcStat("FateT",L,0.4)
											end
										else
											Result = CalcStat("StoutUnyieldingWill",L)
										end
									elseif SN > "STOUTSHADOWEYEVITALITY" then
										if SN < "STOUTUNYIELDINGPHYMITP" then
											if SN == "STOUTUNWRITDESTVITALITY" then
												Result = CalcStat("VitalityT",L,1.0)
											end
										elseif SN > "STOUTUNYIELDINGPHYMITP" then
											if SN == "STOUTUNYIELDINGWILL" then
												Result = CalcStat("WillT",L,1.0)
											end
										else
											Result = 1
										end
									else
										Result = -CalcStat("VitalityT",L,0.4)
									end
								elseif SN > "STOUTWRBLACKLAGILITY" then
									if SN < "T2PENARMOUR" then
										if SN < "STOUTWRBLACKLMIGHT" then
											if SN == "STOUTWRBLACKLDISEASERESISTP" then
												Result = 1
											end
										elseif SN > "STOUTWRBLACKLMIGHT" then
											if SN == "STOUTWRBLACKLSHADOWMITP" then
												Result = 1
											end
										else
											Result = CalcStat("MightT",L,1.0)
										end
									elseif SN > "T2PENARMOUR" then
										if SN < "T2PENMIT" then
											if SN == "T2PENBPE" then
												if Lm <= 115 then
													Result = (-40)*L
												else
													Result = EquSng(DecSng(CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenBPE",115))))
												end
											end
										elseif SN > "T2PENMIT" then
											if SN == "T2PENRESIST" then
												if Lm <= 115 then
													Result = (-90)*L
												else
													Result = EquSng(DecSng(CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenResist",115))))
												end
											end
										else
											if Lm <= 115 then
												Result = RoundDblDown(L*13.5)*-5
											else
												Result = EquSng(DecSng(CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenMit",115))))
											end
										end
									else
										Result = CalcStat("T2penMit",L)
									end
								else
									Result = CalcStat("AgilityT",L,1.0)
								end
							else
								Result = CalcStat("StoutWrBlackLShadowMitP",L)
							end
						elseif SN > "TACDMGPBONUS" then
							if SN < "TACMITC" then
								if SN < "TACMAS" then
									if SN < "TACDMGPRATPB" then
										if SN < "TACDMGPRATP" then
											if SN == "TACDMGPPRAT" then
												Result = CalcStat("OutDmgPPRat",L,N)
											end
										elseif SN > "TACDMGPRATP" then
											if SN == "TACDMGPRATPA" then
												Result = CalcStat("OutDmgPRatPA",L)
											end
										else
											Result = CalcStat("OutDmgPRatP",L,N)
										end
									elseif SN > "TACDMGPRATPB" then
										if SN < "TACDMGPRATPCAP" then
											if SN == "TACDMGPRATPC" then
												Result = CalcStat("OutDmgPRatPC",L)
											end
										elseif SN > "TACDMGPRATPCAP" then
											if SN == "TACDMGPRATPCAPR" then
												Result = CalcStat("OutDmgPRatPCapR",L)
											end
										else
											Result = CalcStat("OutDmgPRatPCap",L)
										end
									else
										Result = CalcStat("OutDmgPRatPB",L)
									end
								elseif SN > "TACMAS" then
									if SN < "TACMASCRAW" then
										if SN < "TACMASCI" then
											if SN == "TACMASC" then
												Result = CalcStat("MasteryC",L,N)
											end
										elseif SN > "TACMASCI" then
											if SN == "TACMASCIRAW" then
												Result = CalcStat("MasteryCIRaw",L,N)
											end
										else
											Result = CalcStat("MasteryCI",L,N)
										end
									elseif SN > "TACMASCRAW" then
										if SN < "TACMAST" then
											if SN == "TACMASOLD" then
												Result = CalcStat("Mastery",L,N)
											end
										elseif SN > "TACMAST" then
											if SN == "TACMIT" then
												Result = EquSng(StatLinInter("PntMPTacMit","ItemPntS","ProgBMitigation","AdjItemMit",L,N,0))
											end
										else
											Result = CalcStat("MasteryT",L,N)
										end
									else
										Result = CalcStat("MasteryCRaw",L,N)
									end
								else
									Result = CalcStat("Mastery",L,N)
								end
							elseif SN > "TACMITC" then
								if SN < "TACMITHPRATPA" then
									if SN < "TACMITCRAW" then
										if SN < "TACMITCILVLFILTER" then
											if SN == "TACMITCI" then
												Result = RoundDblLotro(CalcStat("TacMitCIRaw",L,N))
											end
										elseif SN > "TACMITCILVLFILTER" then
											if SN == "TACMITCIRAW" then
												Result = StatLinInter("PntMPTacMitC","ItemPntS","ProgBMitigation","AdjCreepItemMit",L,N,4)
											end
										else
											if 3.8 <= Lp and Lm <= 3.8 or 5.6 <= Lp and Lm <= 5.6 or 6.9 <= Lp and Lm <= 6.9 or 12.9 <= Lp and Lm <= 12.9 or 17.3 <= Lp and Lm <= 17.3 or 24.225 <= Lp and Lm <= 24.225 then
												Result = 515
											else
												Result = CalcStat("CreepILvlCurr",L)
											end
										end
									elseif SN > "TACMITCRAW" then
										if SN < "TACMITHPPRAT" then
											if SN == "TACMITHPBONUS" then
												Result = CalcStat("MitHeavyPBonus",L)
											end
										elseif SN > "TACMITHPPRAT" then
											if SN == "TACMITHPRATP" then
												Result = CalcStat("MitHeavyPRatP",L,N)
											end
										else
											Result = CalcStat("MitHeavyPPRat",L,N)
										end
									else
										Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("TacMitCIRaw",CalcStat("TacMitCILvlFilter",N),N),99)
									end
								elseif SN > "TACMITHPRATPA" then
									if SN < "TACMITHPRATPCAPR" then
										if SN < "TACMITHPRATPC" then
											if SN == "TACMITHPRATPB" then
												Result = CalcStat("MitHeavyPRatPB",L)
											end
										elseif SN > "TACMITHPRATPC" then
											if SN == "TACMITHPRATPCAP" then
												Result = CalcStat("MitHeavyPRatPCap",L)
											end
										else
											Result = CalcStat("MitHeavyPRatPC",L)
										end
									elseif SN > "TACMITHPRATPCAPR" then
										if SN < "TACMITLPPRAT" then
											if SN == "TACMITLPBONUS" then
												Result = CalcStat("MitLightPBonus",L)
											end
										elseif SN > "TACMITLPPRAT" then
											if SN == "TACMITLPRATP" then
												Result = CalcStat("MitLightPRatP",L,N)
											end
										else
											Result = CalcStat("MitLightPPRat",L,N)
										end
									else
										Result = CalcStat("MitHeavyPRatPCapR",L)
									end
								else
									Result = CalcStat("MitHeavyPRatPA",L)
								end
							else
								Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("TacMitCI",CalcStat("TacMitCILvlFilter",N),N),0)
							end
						else
							Result = CalcStat("OutDmgPBonus",L)
						end
					else
						if Lm <= 105 then
							Result = RoundDbl(CalcStat("StdMoraleRaw",L))
						else
							Result = CalcStat("ProgExtLowExpRnd",L,CalcStat("StdMoraleL",105))
						end
					end
				else
					Result = CalcStat("RivHobSeclusionWill",L)
				end
			else
				Result = 20/1200
			end
		elseif SN > "TACMITLPRATPA" then
			if SN < "WARDENCDMIGHTTOOUTHEAL" then
				if SN < "VIRTWISDOMFINESSE" then
					if SN < "VIRTDETERMINATIONCRITHIT" then
						if SN < "TPENRESIST" then
							if SN < "TOMEFATE" then
								if SN < "TACMITMPRATPA" then
									if SN < "TACMITLPRATPCAPR" then
										if SN < "TACMITLPRATPC" then
											if SN == "TACMITLPRATPB" then
												Result = CalcStat("MitLightPRatPB",L)
											end
										elseif SN > "TACMITLPRATPC" then
											if SN == "TACMITLPRATPCAP" then
												Result = CalcStat("MitLightPRatPCap",L)
											end
										else
											Result = CalcStat("MitLightPRatPC",L)
										end
									elseif SN > "TACMITLPRATPCAPR" then
										if SN < "TACMITMPPRAT" then
											if SN == "TACMITMPBONUS" then
												Result = CalcStat("MitMediumPBonus",L)
											end
										elseif SN > "TACMITMPPRAT" then
											if SN == "TACMITMPRATP" then
												Result = CalcStat("MitMediumPRatP",L,N)
											end
										else
											Result = CalcStat("MitMediumPPRat",L,N)
										end
									else
										Result = CalcStat("MitLightPRatPCapR",L)
									end
								elseif SN > "TACMITMPRATPA" then
									if SN < "TACMITMPRATPCAPR" then
										if SN < "TACMITMPRATPC" then
											if SN == "TACMITMPRATPB" then
												Result = CalcStat("MitMediumPRatPB",L)
											end
										elseif SN > "TACMITMPRATPC" then
											if SN == "TACMITMPRATPCAP" then
												Result = CalcStat("MitMediumPRatPCap",L)
											end
										else
											Result = CalcStat("MitMediumPRatPC",L)
										end
									elseif SN > "TACMITMPRATPCAPR" then
										if SN < "TACRESIST" then
											if SN == "TACMITT" then
												Result = EquSng(StatLinInter("PntMPTacMit","TraitPntS","ProgBMitigation","AdjTraitMit",L,N,0))
											end
										elseif SN > "TACRESIST" then
											if SN == "TACRESISTT" then
												Result = CalcStat("ResistAddT",L,N)
											end
										else
											Result = CalcStat("ResistAdd",L,N)
										end
									else
										Result = CalcStat("MitMediumPRatPCapR",L)
									end
								else
									Result = CalcStat("MitMediumPRatPA",L)
								end
							elseif SN > "TOMEFATE" then
								if SN < "TOMETOTALMAINDEC" then
									if SN < "TOMETOTALFATE" then
										if SN < "TOMEMAIN" then
											if SN == "TOMEFATEDEC" then
												Result = CalcStat("TomeTotalFateDec",L)-CalcStat("TomeTotalFateDec",L-1)
											end
										elseif SN > "TOMEMAIN" then
											if SN == "TOMEMAINDEC" then
												Result = CalcStat("TomeTotalMainDec",L)-CalcStat("TomeTotalMainDec",L-1)
											end
										else
											Result = CalcStat("TomeMainDec",RomanRankDecode(C))
										end
									elseif SN > "TOMETOTALFATE" then
										if SN < "TOMETOTALLEVEL" then
											if SN == "TOMETOTALFATEDEC" then
												Result = CalcStat("FateT",CalcStat("TomeTotalLevel",L),2.0)
											end
										elseif SN > "TOMETOTALLEVEL" then
											if SN == "TOMETOTALMAIN" then
												Result = CalcStat("TomeTotalMainDec",RomanRankDecode(C))
											end
										else
											if 1 <= Lp and Lm <= 23 then
												Result = DataTableValue({4,15,27,38,48,54,60,63,67,71,75,78,85,90,95,98,101,104,106,110,114,116,121},L)
											end
										end
									else
										Result = CalcStat("TomeTotalFateDec",RomanRankDecode(C))
									end
								elseif SN > "TOMETOTALMAINDEC" then
									if SN < "TOMEVITALITYDEC" then
										if SN < "TOMETOTALVITALITYDEC" then
											if SN == "TOMETOTALVITALITY" then
												Result = CalcStat("TomeTotalVitalityDec",RomanRankDecode(C))
											end
										elseif SN > "TOMETOTALVITALITYDEC" then
											if SN == "TOMEVITALITY" then
												Result = CalcStat("TomeVitalityDec",RomanRankDecode(C))
											end
										else
											Result = CalcStat("VitalityT",CalcStat("TomeTotalLevel",L),2.0)
										end
									elseif SN > "TOMEVITALITYDEC" then
										if SN < "TPENBPE" then
											if SN == "TPENARMOUR" then
												Result = -CalcStat("ArmourPenT",L,CalcStat("TpenChoice",N))
											end
										elseif SN > "TPENBPE" then
											if SN == "TPENCHOICE" then
												if 1 <= Lp then
													Result = DataTableValue({0.5,1,2},L)
												end
											end
										else
											Result = -CalcStat("BPET",L,CalcStat("TpenChoice",N))
										end
									else
										Result = CalcStat("TomeTotalVitalityDec",L)-CalcStat("TomeTotalVitalityDec",L-1)
									end
								else
									Result = CalcStat("MainT",CalcStat("TomeTotalLevel",L),2.0)
								end
							else
								Result = CalcStat("TomeFateDec",RomanRankDecode(C))
							end
						elseif SN > "TPENRESIST" then
							if SN < "U371LEGACYSTATFIX" then
								if SN < "TRAIT234CHOICE" then
									if SN < "TRAIT1234CHOICE" then
										if SN < "TRAIT12345CHOICE" then
											if SN == "TRAIT123455CHOICE" then
												if 1 <= Lp and Lm <= 6 then
													Result = DataTableValue({1,2,3,4,5,5},L)
												end
											end
										elseif SN > "TRAIT12345CHOICE" then
											if SN == "TRAIT12347CHOICE" then
												if 1 <= Lp and Lm <= 5 then
													Result = DataTableValue({1,2,3,4,7},L)
												end
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = DataTableValue({1,2,3,4,5},L)
											end
										end
									elseif SN > "TRAIT1234CHOICE" then
										if SN < "TRAIT13510CHOICE" then
											if SN == "TRAIT123CHOICE" then
												if 1 <= Lp and Lm <= 3 then
													Result = DataTableValue({1,2,3},L)
												end
											end
										elseif SN > "TRAIT13510CHOICE" then
											if SN == "TRAIT23456CHOICE" then
												if 1 <= Lp and Lm <= 5 then
													Result = DataTableValue({2,3,4,5,6},L)
												end
											end
										else
											if 1 <= Lp and Lm <= 4 then
												Result = DataTableValue({1,3,5,10},L)
											end
										end
									else
										if 1 <= Lp and Lm <= 4 then
											Result = DataTableValue({1,2,3,4},L)
										end
									end
								elseif SN > "TRAIT234CHOICE" then
									if SN < "TRAIT56789CHOICE" then
										if SN < "TRAIT47101316CHOICE" then
											if SN == "TRAIT357912CHOICE" then
												if 1 <= Lp and Lm <= 5 then
													Result = DataTableValue({3,5,7,9,12},L)
												end
											end
										elseif SN > "TRAIT47101316CHOICE" then
											if SN == "TRAIT567810CHOICE" then
												if 1 <= Lp and Lm <= 5 then
													Result = DataTableValue({5,6,7,8,10},L)
												end
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = DataTableValue({4,7,10,13,16},L)
											end
										end
									elseif SN > "TRAIT56789CHOICE" then
										if SN < "TRAITPNTS" then
											if SN == "TRAIT58121620CHOICE" then
												if 1 <= Lp and Lm <= 5 then
													Result = DataTableValue({5,8,12,16,20},L)
												end
											end
										elseif SN > "TRAITPNTS" then
											if SN == "TRAITPNTSVITAL" then
												Result = {{1,25,50,60,65,75,85,95,100,105,115,120,130,140,141,150},{1,25,50,60,65,75,85,95,100,105,115,120,130,140,141,150}}
											end
										else
											Result = {{1,25,50,60,65,75,85,95,100,105,115,120,130,131,140,141,150},{1,25,50,60,65,75,85,95,100,105,115,120,130,131,140,141,150}}
										end
									else
										if 1 <= Lp and Lm <= 5 then
											Result = DataTableValue({5,6,7,8,9},L)
										end
									end
								else
									if 1 <= Lp and Lm <= 3 then
										Result = DataTableValue({2,3,4},L)
									end
								end
							elseif SN > "U371LEGACYSTATFIX" then
								if SN < "VIRTCOMPASSIONTACMIT" then
									if SN < "VIRTCHARITYVITALITY" then
										if SN < "VIRTCHARITYPHYMIT" then
											if SN == "VARMOUR" then
												Result = RoundDbl(StatLinInter("PntMPArmourVirtues","ItemPntS","ProgBArmourLight","AdjItemMit",L,N,0))
											end
										elseif SN > "VIRTCHARITYPHYMIT" then
											if SN == "VIRTCHARITYRESIST" then
												Result = CalcStat("VSResistH",L)
											end
										else
											Result = CalcStat("VSPhyMitM",L)
										end
									elseif SN > "VIRTCHARITYVITALITY" then
										if SN < "VIRTCOMPASSIONARMOUR" then
											if SN == "VIRTCHARITYVPMORALE" then
												Result = CalcStat("VSVPMorale",L)
											end
										elseif SN > "VIRTCOMPASSIONARMOUR" then
											if SN == "VIRTCOMPASSIONPHYMIT" then
												Result = CalcStat("VSPhyMitH",L)
											end
										else
											Result = CalcStat("VSArmourL",L)
										end
									else
										Result = CalcStat("VSVitalityL",L)
									end
								elseif SN > "VIRTCOMPASSIONTACMIT" then
									if SN < "VIRTCONFIDENCEFINESSE" then
										if SN < "VIRTCONFIDENCECRITHIT" then
											if SN == "VIRTCOMPASSIONVPMORALE" then
												Result = CalcStat("VSVPMorale",L)
											end
										elseif SN > "VIRTCONFIDENCECRITHIT" then
											if SN == "VIRTCONFIDENCEEVADE" then
												Result = CalcStat("VSEvadeL",L)
											end
										else
											Result = CalcStat("VSCritHitH",L)
										end
									elseif SN > "VIRTCONFIDENCEFINESSE" then
										if SN < "VIRTCONFIDENCEVPTACMAS" then
											if SN == "VIRTCONFIDENCEVPPHYMAS" then
												Result = CalcStat("VSVPPhyMas",L)
											end
										elseif SN > "VIRTCONFIDENCEVPTACMAS" then
											if SN == "VIRTDETERMINATIONAGILITY" then
												Result = CalcStat("VSAgilityH",L)
											end
										else
											Result = CalcStat("VSVPTacMas",L)
										end
									else
										Result = CalcStat("VSFinesseM",L)
									end
								else
									Result = CalcStat("VSTacMitM",L)
								end
							else
								if Lm <= 2 then
									Result = 0
								else
									Result = RoundDblUp(CalcStat(C,L-2)*0.07)
								end
							end
						else
							Result = -CalcStat("ResistT",L,CalcStat("TpenChoice",N)*2)
						end
					elseif SN > "VIRTDETERMINATIONCRITHIT" then
						if SN < "VIRTIDEALISMVPMORALE" then
							if SN < "VIRTFORTITUDECRITDEF" then
								if SN < "VIRTEMPATHYARMOUR" then
									if SN < "VIRTDISCIPLINEINHEAL" then
										if SN < "VIRTDETERMINATIONVPPHYMAS" then
											if SN == "VIRTDETERMINATIONPHYMAS" then
												Result = CalcStat("VSPhyMasM",L)
											end
										elseif SN > "VIRTDETERMINATIONVPPHYMAS" then
											if SN == "VIRTDETERMINATIONVPTACMAS" then
												Result = CalcStat("VSVPTacMas",L)
											end
										else
											Result = CalcStat("VSVPPhyMas",L)
										end
									elseif SN > "VIRTDISCIPLINEINHEAL" then
										if SN < "VIRTDISCIPLINERESIST" then
											if SN == "VIRTDISCIPLINEPHYMIT" then
												Result = CalcStat("VSPhyMitL",L)
											end
										elseif SN > "VIRTDISCIPLINERESIST" then
											if SN == "VIRTDISCIPLINEVPMORALE" then
												Result = CalcStat("VSVPMorale",L)
											end
										else
											Result = CalcStat("VSResistH",L)
										end
									else
										Result = CalcStat("VSInHealM",L)
									end
								elseif SN > "VIRTEMPATHYARMOUR" then
									if SN < "VIRTFIDELITYPHYMIT" then
										if SN < "VIRTEMPATHYRESIST" then
											if SN == "VIRTEMPATHYCRITDEF" then
												Result = CalcStat("VSCritDefM",L)
											end
										elseif SN > "VIRTEMPATHYRESIST" then
											if SN == "VIRTEMPATHYVPMORALE" then
												Result = CalcStat("VSVPMorale",L)
											end
										else
											Result = CalcStat("VSResistL",L)
										end
									elseif SN > "VIRTFIDELITYPHYMIT" then
										if SN < "VIRTFIDELITYVITALITY" then
											if SN == "VIRTFIDELITYTACMIT" then
												Result = CalcStat("VSTacMitH",L)
											end
										elseif SN > "VIRTFIDELITYVITALITY" then
											if SN == "VIRTFIDELITYVPMORALE" then
												Result = CalcStat("VSVPMorale",L)
											end
										else
											Result = CalcStat("VSVitalityM",L)
										end
									else
										Result = CalcStat("VSPhyMitL",L)
									end
								else
									Result = CalcStat("VSArmourH",L)
								end
							elseif SN > "VIRTFORTITUDECRITDEF" then
								if SN < "VIRTHONESTYWILL" then
									if SN < "VIRTHONESTYCRITHIT" then
										if SN < "VIRTFORTITUDERESIST" then
											if SN == "VIRTFORTITUDEMORALE" then
												Result = CalcStat("VSMoraleH",L)
											end
										elseif SN > "VIRTFORTITUDERESIST" then
											if SN == "VIRTFORTITUDEVPMORALE" then
												Result = CalcStat("VSVPMorale",L)
											end
										else
											Result = CalcStat("VSResistL",L)
										end
									elseif SN > "VIRTHONESTYCRITHIT" then
										if SN < "VIRTHONESTYVPPHYMAS" then
											if SN == "VIRTHONESTYTACMAS" then
												Result = CalcStat("VSTacMasH",L)
											end
										elseif SN > "VIRTHONESTYVPPHYMAS" then
											if SN == "VIRTHONESTYVPTACMAS" then
												Result = CalcStat("VSVPTacMas",L)
											end
										else
											Result = CalcStat("VSVPPhyMas",L)
										end
									else
										Result = CalcStat("VSCritHitL",L)
									end
								elseif SN > "VIRTHONESTYWILL" then
									if SN < "VIRTHONOURVPMORALE" then
										if SN < "VIRTHONOURMORALE" then
											if SN == "VIRTHONOURCRITDEF" then
												Result = CalcStat("VSCritDefL",L)
											end
										elseif SN > "VIRTHONOURMORALE" then
											if SN == "VIRTHONOURTACMIT" then
												Result = CalcStat("VSTacMitM",L)
											end
										else
											Result = CalcStat("VSMoraleH",L)
										end
									elseif SN > "VIRTHONOURVPMORALE" then
										if SN < "VIRTIDEALISMINHEAL" then
											if SN == "VIRTIDEALISMFATE" then
												Result = CalcStat("VSFateH",L)
											end
										elseif SN > "VIRTIDEALISMINHEAL" then
											if SN == "VIRTIDEALISMMORALE" then
												Result = CalcStat("VSMoraleL",L)
											end
										else
											Result = CalcStat("VSInHealM",L)
										end
									else
										Result = CalcStat("VSVPMorale",L)
									end
								else
									Result = CalcStat("VSWillM",L)
								end
							else
								Result = CalcStat("VSCritDefM",L)
							end
						elseif SN > "VIRTIDEALISMVPMORALE" then
							if SN < "VIRTMERCYVPMORALE" then
								if SN < "VIRTJUSTICEVPMORALE" then
									if SN < "VIRTINNOCENCEVPMORALE" then
										if SN < "VIRTINNOCENCERESIST" then
											if SN == "VIRTINNOCENCEPHYMIT" then
												Result = CalcStat("VSPhyMitH",L)
											end
										elseif SN > "VIRTINNOCENCERESIST" then
											if SN == "VIRTINNOCENCETACMIT" then
												Result = CalcStat("VSTacMitL",L)
											end
										else
											Result = CalcStat("VSResistM",L)
										end
									elseif SN > "VIRTINNOCENCEVPMORALE" then
										if SN < "VIRTJUSTICEMORALE" then
											if SN == "VIRTJUSTICEICMR" then
												Result = CalcStat("VSICMRH",L)
											end
										elseif SN > "VIRTJUSTICEMORALE" then
											if SN == "VIRTJUSTICETACMIT" then
												Result = CalcStat("VSTacMitL",L)
											end
										else
											Result = CalcStat("VSMoraleM",L)
										end
									else
										Result = CalcStat("VSVPMorale",L)
									end
								elseif SN > "VIRTJUSTICEVPMORALE" then
									if SN < "VIRTLOYALTYVPMORALE" then
										if SN < "VIRTLOYALTYINHEAL" then
											if SN == "VIRTLOYALTYARMOUR" then
												Result = CalcStat("VSArmourM",L)
											end
										elseif SN > "VIRTLOYALTYINHEAL" then
											if SN == "VIRTLOYALTYVITALITY" then
												Result = CalcStat("VSVitalityH",L)
											end
										else
											Result = CalcStat("VSInHealL",L)
										end
									elseif SN > "VIRTLOYALTYVPMORALE" then
										if SN < "VIRTMERCYFATE" then
											if SN == "VIRTMERCYEVADE" then
												Result = CalcStat("VSEvadeH",L)
											end
										elseif SN > "VIRTMERCYFATE" then
											if SN == "VIRTMERCYVITALITY" then
												Result = CalcStat("VSVitalityL",L)
											end
										else
											Result = CalcStat("VSFateM",L)
										end
									else
										Result = CalcStat("VSVPMorale",L)
									end
								else
									Result = CalcStat("VSVPMorale",L)
								end
							elseif SN > "VIRTMERCYVPMORALE" then
								if SN < "VIRTTOLERANCERESIST" then
									if SN < "VIRTPATIENCEVPMORALE" then
										if SN < "VIRTPATIENCEEVADE" then
											if SN == "VIRTPATIENCECRITHIT" then
												Result = CalcStat("VSCritHitL",L)
											end
										elseif SN > "VIRTPATIENCEEVADE" then
											if SN == "VIRTPATIENCEPOWER" then
												Result = CalcStat("VSPowerH",L)
											end
										else
											Result = CalcStat("VSEvadeM",L)
										end
									elseif SN > "VIRTPATIENCEVPMORALE" then
										if SN < "VIRTRNKCOSTTOT" then
											if SN == "VIRTRNKCOST" then
												if Lm <= 0 then
													Result = 0
												elseif Lm <= 10 then
													Result = 1000
												elseif Lm <= 60 then
													Result = RoundDbl(18*L+878,-2)
												elseif Lm <= 73 then
													Result = RoundDbl(18.75*L+878,-2)
												elseif Lm <= 90 then
													Result = RoundDbl(17.45*L+878,-2)
												else
													Result = 2500
												end
											end
										elseif SN > "VIRTRNKCOSTTOT" then
											if SN == "VIRTTOLERANCEPHYMIT" then
												Result = CalcStat("VSPhyMitL",L)
											end
										else
											if 1 <= Lp then
												Result = CalcStat("VirtRnkCostTot",L-1)+CalcStat("VirtRnkCost",L)
											end
										end
									else
										Result = CalcStat("VSVPMorale",L)
									end
								elseif SN > "VIRTTOLERANCERESIST" then
									if SN < "VIRTVALOURFINESSE" then
										if SN < "VIRTTOLERANCEVPMORALE" then
											if SN == "VIRTTOLERANCETACMIT" then
												Result = CalcStat("VSTacMitH",L)
											end
										elseif SN > "VIRTTOLERANCEVPMORALE" then
											if SN == "VIRTVALOURCRITHIT" then
												Result = CalcStat("VSCritHitL",L)
											end
										else
											Result = CalcStat("VSVPMorale",L)
										end
									elseif SN > "VIRTVALOURFINESSE" then
										if SN < "VIRTVALOURVPPHYMAS" then
											if SN == "VIRTVALOURPHYMAS" then
												Result = CalcStat("VSPhyMasH",L)
											end
										elseif SN > "VIRTVALOURVPPHYMAS" then
											if SN == "VIRTVALOURVPTACMAS" then
												Result = CalcStat("VSVPTacMas",L)
											end
										else
											Result = CalcStat("VSVPPhyMas",L)
										end
									else
										Result = CalcStat("VSFinesseM",L)
									end
								else
									Result = CalcStat("VSResistM",L)
								end
							else
								Result = CalcStat("VSVPMorale",L)
							end
						else
							Result = CalcStat("VSVPMorale",L)
						end
					else
						Result = CalcStat("VSCritHitL",L)
					end
				elseif SN > "VIRTWISDOMFINESSE" then
					if SN < "VSMIGHTL" then
						if SN < "VMORALE" then
							if SN < "VITALITY" then
								if SN < "VIRTWITTACMAS" then
									if SN < "VIRTWISDOMWILL" then
										if SN < "VIRTWISDOMVPPHYMAS" then
											if SN == "VIRTWISDOMTACMAS" then
												Result = CalcStat("VSTacMasM",L)
											end
										elseif SN > "VIRTWISDOMVPPHYMAS" then
											if SN == "VIRTWISDOMVPTACMAS" then
												Result = CalcStat("VSVPTacMas",L)
											end
										else
											Result = CalcStat("VSVPPhyMas",L)
										end
									elseif SN > "VIRTWISDOMWILL" then
										if SN < "VIRTWITFINESSE" then
											if SN == "VIRTWITCRITHIT" then
												Result = CalcStat("VSCritHitM",L)
											end
										elseif SN > "VIRTWITFINESSE" then
											if SN == "VIRTWITPHYMAS" then
												Result = CalcStat("VSPhyMasL",L)
											end
										else
											Result = CalcStat("VSFinesseH",L)
										end
									else
										Result = CalcStat("VSWillH",L)
									end
								elseif SN > "VIRTWITTACMAS" then
									if SN < "VIRTZEALMIGHT" then
										if SN < "VIRTWITVPTACMAS" then
											if SN == "VIRTWITVPPHYMAS" then
												Result = CalcStat("VSVPPhyMas",L)
											end
										elseif SN > "VIRTWITVPTACMAS" then
											if SN == "VIRTZEALCRITHIT" then
												Result = CalcStat("VSCritHitL",L)
											end
										else
											Result = CalcStat("VSVPTacMas",L)
										end
									elseif SN > "VIRTZEALMIGHT" then
										if SN < "VIRTZEALVPPHYMAS" then
											if SN == "VIRTZEALPHYMAS" then
												Result = CalcStat("VSPhyMasM",L)
											end
										elseif SN > "VIRTZEALVPPHYMAS" then
											if SN == "VIRTZEALVPTACMAS" then
												Result = CalcStat("VSVPTacMas",L)
											end
										else
											Result = CalcStat("VSVPPhyMas",L)
										end
									else
										Result = CalcStat("VSMightH",L)
									end
								else
									Result = CalcStat("VSTacMasL",L)
								end
							elseif SN > "VITALITY" then
								if SN < "VITALITYTADJ" then
									if SN < "VITALITYCILVLFILTER" then
										if SN < "VITALITYC" then
											if SN == "VITALITYADJ" then
												if Lm <= 25 then
													Result = 0.5
												elseif Lm <= 50 then
													Result = 0.6
												elseif Lm <= 60 then
													Result = 0.7
												elseif Lm <= 79 then
													Result = 0.8
												elseif Lm <= 80 then
													Result = 0.9
												else
													Result = 1
												end
											end
										elseif SN > "VITALITYC" then
											if SN == "VITALITYCI" then
												Result = RoundDblLotro(CalcStat("VitalityCIRaw",L,N))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("VitalityCI",CalcStat("VitalityCILvlFilter",N),N),0)
										end
									elseif SN > "VITALITYCILVLFILTER" then
										if SN < "VITALITYCRAW" then
											if SN == "VITALITYCIRAW" then
												Result = StatLinInter("PntMPVitalityC","ItemPntS","ProgBVitality","AdjCreepItem",L,N,4)
											end
										elseif SN > "VITALITYCRAW" then
											if SN == "VITALITYT" then
												Result = RoundDblDown(StatLinInter("PntMPVitalityT","TraitPntSVital","ProgBVitality","VitalityTAdj",L,N,0))
											end
										else
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("VitalityCIRaw",CalcStat("VitalityCILvlFilter",N),N),99)
										end
									else
										if 0 <= Lp and Lm <= 0 then
											Result = 515
										else
											Result = CalcStat("CreepILvlCurr",L)
										end
									end
								elseif SN > "VITALITYTADJ" then
									if SN < "VMLOW" then
										if SN < "VMASTERYOLD" then
											if SN == "VMASTERY" then
												Result = EquSng(StatLinInter("PntMPMastery","ItemPntSVirtueMastery","ProgBMastery","AdjVirtueMas",L,N,0))
											end
										elseif SN > "VMASTERYOLD" then
											if SN == "VMHIGH" then
												if 1 <= Lp then
													Result = CalcStat(C,CalcStat("VRnkToILvl",L),2.0)
												end
											end
										else
											Result = CalcStat("VMastery",L,N)
										end
									elseif SN > "VMLOW" then
										if SN < "VMMEDIUM" then
											if SN == "VMMASTERYPSV" then
												if 1 <= Lp then
													Result = CalcStat("VMastery",CalcStat("VRnkToILvl",L),0.2)
												end
											end
										elseif SN > "VMMEDIUM" then
											if SN == "VMMORALEPSV" then
												if 1 <= Lp then
													Result = CalcStat("VMorale",CalcStat("VRnkToILvl",L),0.3)
												end
											end
										else
											if 1 <= Lp then
												Result = CalcStat(C,CalcStat("VRnkToILvl",L),1.0)
											end
										end
									else
										if 1 <= Lp then
											Result = CalcStat(C,CalcStat("VRnkToILvl",L),0.6)
										end
									end
								else
									if Lm <= 25 then
										Result = 0.5
									elseif Lm <= 50 then
										Result = 0.6
									elseif Lm <= 60 then
										Result = 0.7
									elseif Lm <= 65 then
										Result = 0.8
									elseif Lm <= 75 then
										Result = 0.9
									else
										Result = 1
									end
								end
							else
								Result = RoundDblDown(StatLinInter("PntMPVitality","ItemPntSVital","ProgBVitality","VitalityAdj",L,N,0))
							end
						elseif SN > "VMORALE" then
							if SN < "VSEVADEH" then
								if SN < "VSARMOURL" then
									if SN < "VSAGILITYH" then
										if SN < "VRNKLVLCAP" then
											if SN == "VRNKCAP" then
												Result = 94
											end
										elseif SN > "VRNKLVLCAP" then
											if SN == "VRNKTOILVL" then
												if Lm <= 0 then
													Result = 0
												elseif Lm <= 38 then
													Result = LinFmod(1,4,78,1,38,L)
												elseif Lm <= 48 then
													Result = LinFmod(1,78,178,38,48,L)
												elseif Lm <= 49 then
													Result = LinFmod(1,178,190,48,49,L)
												elseif Lm <= 50 then
													Result = LinFmod(1,190,210,49,50,L)
												elseif Lm <= 51 then
													Result = LinFmod(1,210,222,50,51,L)
												elseif Lm <= 52 then
													Result = LinFmod(1,222,236,51,52,L)
												elseif Lm <= 53 then
													Result = LinFmod(1,236,260,52,53,L)
												elseif Lm <= 55 then
													Result = LinFmod(1,260,292,53,55,L)
												elseif Lm <= 68 then
													Result = LinFmod(1,292,396,55,68,L)
												else
													Result = LinFmod(1,396,706,68,130,L)
												end
											end
										else
											if Lm <= 4 then
												Result = 2
											elseif Lm <= 110 then
												Result = RoundDblDown(L/2)
											elseif Lm <= 139 then
												Result = L-55
											elseif Lm <= 140 then
												Result = L-54
											elseif Lm <= 149 then
												Result = L-53
											else
												Result = 98
											end
										end
									elseif SN > "VSAGILITYH" then
										if SN < "VSAGILITYM" then
											if SN == "VSAGILITYL" then
												Result = CalcStat("VMLow",L,"Agility")
											end
										elseif SN > "VSAGILITYM" then
											if SN == "VSARMOURH" then
												Result = CalcStat("VMHigh",L,"Varmour")
											end
										else
											Result = CalcStat("VMMedium",L,"Agility")
										end
									else
										Result = CalcStat("VMHigh",L,"Agility")
									end
								elseif SN > "VSARMOURL" then
									if SN < "VSCRITDEFM" then
										if SN < "VSCRITDEFH" then
											if SN == "VSARMOURM" then
												Result = CalcStat("VMMedium",L,"Varmour")
											end
										elseif SN > "VSCRITDEFH" then
											if SN == "VSCRITDEFL" then
												Result = CalcStat("VMLow",L,"CritDef")
											end
										else
											Result = CalcStat("VMHigh",L,"CritDef")
										end
									elseif SN > "VSCRITDEFM" then
										if SN < "VSCRITHITL" then
											if SN == "VSCRITHITH" then
												Result = CalcStat("VMHigh",L,"CritHit")
											end
										elseif SN > "VSCRITHITL" then
											if SN == "VSCRITHITM" then
												Result = CalcStat("VMMedium",L,"CritHit")
											end
										else
											Result = CalcStat("VMLow",L,"CritHit")
										end
									else
										Result = CalcStat("VMMedium",L,"CritDef")
									end
								else
									Result = CalcStat("VMLow",L,"Varmour")
								end
							elseif SN > "VSEVADEH" then
								if SN < "VSFINESSEM" then
									if SN < "VSFATEL" then
										if SN < "VSEVADEM" then
											if SN == "VSEVADEL" then
												Result = CalcStat("VMLow",L,"Evade")
											end
										elseif SN > "VSEVADEM" then
											if SN == "VSFATEH" then
												Result = CalcStat("VMHigh",L,"Fate")
											end
										else
											Result = CalcStat("VMMedium",L,"Evade")
										end
									elseif SN > "VSFATEL" then
										if SN < "VSFINESSEH" then
											if SN == "VSFATEM" then
												Result = CalcStat("VMMedium",L,"Fate")
											end
										elseif SN > "VSFINESSEH" then
											if SN == "VSFINESSEL" then
												Result = CalcStat("VMLow",L,"Finesse")
											end
										else
											Result = CalcStat("VMHigh",L,"Finesse")
										end
									else
										Result = CalcStat("VMLow",L,"Fate")
									end
								elseif SN > "VSFINESSEM" then
									if SN < "VSINHEALH" then
										if SN < "VSICMRL" then
											if SN == "VSICMRH" then
												Result = CalcStat("VMHigh",L,"ICMR")
											end
										elseif SN > "VSICMRL" then
											if SN == "VSICMRM" then
												Result = CalcStat("VMMedium",L,"ICMR")
											end
										else
											Result = CalcStat("VMLow",L,"ICMR")
										end
									elseif SN > "VSINHEALH" then
										if SN < "VSINHEALM" then
											if SN == "VSINHEALL" then
												Result = CalcStat("VMLow",L,"InHeal")
											end
										elseif SN > "VSINHEALM" then
											if SN == "VSMIGHTH" then
												Result = CalcStat("VMHigh",L,"Might")
											end
										else
											Result = CalcStat("VMMedium",L,"InHeal")
										end
									else
										Result = CalcStat("VMHigh",L,"InHeal")
									end
								else
									Result = CalcStat("VMMedium",L,"Finesse")
								end
							else
								Result = CalcStat("VMHigh",L,"Evade")
							end
						else
							Result = EquSng(StatLinInter("PntMPMoraleVirtues","ItemPntSVirtueMorale","ProgBMorale","AdjVirtueMorale",L,N,0))
						end
					elseif SN > "VSMIGHTL" then
						if SN < "WARDENCDAGILITYTOBLOCK" then
							if SN < "VSRESISTM" then
								if SN < "VSPHYMITH" then
									if SN < "VSMORALEM" then
										if SN < "VSMORALEH" then
											if SN == "VSMIGHTM" then
												Result = CalcStat("VMMedium",L,"Might")
											end
										elseif SN > "VSMORALEH" then
											if SN == "VSMORALEL" then
												Result = CalcStat("VMLow",L,"VMorale")
											end
										else
											Result = CalcStat("VMHigh",L,"VMorale")
										end
									elseif SN > "VSMORALEM" then
										if SN < "VSPHYMASL" then
											if SN == "VSPHYMASH" then
												Result = CalcStat("VMHigh",L,"PhyMas")
											end
										elseif SN > "VSPHYMASL" then
											if SN == "VSPHYMASM" then
												Result = CalcStat("VMMedium",L,"PhyMas")
											end
										else
											Result = CalcStat("VMLow",L,"PhyMas")
										end
									else
										Result = CalcStat("VMMedium",L,"VMorale")
									end
								elseif SN > "VSPHYMITH" then
									if SN < "VSPOWERL" then
										if SN < "VSPHYMITM" then
											if SN == "VSPHYMITL" then
												Result = CalcStat("VMLow",L,"PhyMit")
											end
										elseif SN > "VSPHYMITM" then
											if SN == "VSPOWERH" then
												Result = CalcStat("VMHigh",L,"Power")
											end
										else
											Result = CalcStat("VMMedium",L,"PhyMit")
										end
									elseif SN > "VSPOWERL" then
										if SN < "VSRESISTH" then
											if SN == "VSPOWERM" then
												Result = CalcStat("VMMedium",L,"Power")
											end
										elseif SN > "VSRESISTH" then
											if SN == "VSRESISTL" then
												Result = CalcStat("VMLow",L,"Resist")
											end
										else
											Result = CalcStat("VMHigh",L,"Resist")
										end
									else
										Result = CalcStat("VMLow",L,"Power")
									end
								else
									Result = CalcStat("VMHigh",L,"PhyMit")
								end
							elseif SN > "VSRESISTM" then
								if SN < "VSVITALITYL" then
									if SN < "VSTACMITH" then
										if SN < "VSTACMASL" then
											if SN == "VSTACMASH" then
												Result = CalcStat("VMHigh",L,"TacMas")
											end
										elseif SN > "VSTACMASL" then
											if SN == "VSTACMASM" then
												Result = CalcStat("VMMedium",L,"TacMas")
											end
										else
											Result = CalcStat("VMLow",L,"TacMas")
										end
									elseif SN > "VSTACMITH" then
										if SN < "VSTACMITM" then
											if SN == "VSTACMITL" then
												Result = CalcStat("VMLow",L,"TacMit")
											end
										elseif SN > "VSTACMITM" then
											if SN == "VSVITALITYH" then
												Result = CalcStat("VMHigh",L,"Vitality")
											end
										else
											Result = CalcStat("VMMedium",L,"TacMit")
										end
									else
										Result = CalcStat("VMHigh",L,"TacMit")
									end
								elseif SN > "VSVITALITYL" then
									if SN < "VSVPTACMAS" then
										if SN < "VSVPMORALE" then
											if SN == "VSVITALITYM" then
												Result = CalcStat("VMMedium",L,"Vitality")
											end
										elseif SN > "VSVPMORALE" then
											if SN == "VSVPPHYMAS" then
												Result = CalcStat("VMMasteryPsv",L)
											end
										else
											Result = CalcStat("VMMoralePsv",L)
										end
									elseif SN > "VSVPTACMAS" then
										if SN < "VSWILLL" then
											if SN == "VSWILLH" then
												Result = CalcStat("VMHigh",L,"Will")
											end
										elseif SN > "VSWILLL" then
											if SN == "VSWILLM" then
												Result = CalcStat("VMMedium",L,"Will")
											end
										else
											Result = CalcStat("VMLow",L,"Will")
										end
									else
										Result = CalcStat("VMMasteryPsv",L)
									end
								else
									Result = CalcStat("VMLow",L,"Vitality")
								end
							else
								Result = CalcStat("VMMedium",L,"Resist")
							end
						elseif SN > "WARDENCDAGILITYTOBLOCK" then
							if SN < "WARDENCDBASEMORALE" then
								if SN < "WARDENCDARMOURTONONPHYMIT" then
									if SN < "WARDENCDAGILITYTOPHYMAS" then
										if SN < "WARDENCDAGILITYTOOUTHEAL" then
											if SN == "WARDENCDAGILITYTOCRITHIT" then
												Result = 1
											end
										elseif SN > "WARDENCDAGILITYTOOUTHEAL" then
											if SN == "WARDENCDAGILITYTOPARRY" then
												Result = 1
											end
										else
											Result = 3
										end
									elseif SN > "WARDENCDAGILITYTOPHYMAS" then
										if SN < "WARDENCDAGILITYTOTACMIT" then
											if SN == "WARDENCDAGILITYTOPHYMIT" then
												Result = 1
											end
										elseif SN > "WARDENCDAGILITYTOTACMIT" then
											if SN == "WARDENCDARMOURTOCOMPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									else
										Result = 3
									end
								elseif SN > "WARDENCDARMOURTONONPHYMIT" then
									if SN < "WARDENCDBASEFATE" then
										if SN < "WARDENCDARMOURTYPE" then
											if SN == "WARDENCDARMOURTOTACMIT" then
												Result = 0.2
											end
										elseif SN > "WARDENCDARMOURTYPE" then
											if SN == "WARDENCDBASEAGILITY" then
												Result = CalcStat("ClassBaseAgilityH",L)
											end
										else
											Result = 2
										end
									elseif SN > "WARDENCDBASEFATE" then
										if SN < "WARDENCDBASEICPR" then
											if SN == "WARDENCDBASEICMR" then
												Result = CalcStat("ClassBaseICMRH",L)
											end
										elseif SN > "WARDENCDBASEICPR" then
											if SN == "WARDENCDBASEMIGHT" then
												Result = CalcStat("ClassBaseMightM",L)
											end
										else
											Result = CalcStat("ClassBaseICPR",L)
										end
									else
										Result = CalcStat("ClassBaseFate",L)
									end
								else
									Result = 0.2
								end
							elseif SN > "WARDENCDBASEMORALE" then
								if SN < "WARDENCDCALCTYPETACMIT" then
									if SN < "WARDENCDBASEVITALITY" then
										if SN < "WARDENCDBASENCPR" then
											if SN == "WARDENCDBASENCMR" then
												Result = CalcStat("ClassBaseNCMRH",L)
											end
										elseif SN > "WARDENCDBASENCPR" then
											if SN == "WARDENCDBASEPOWER" then
												Result = CalcStat("ClassBasePower",L)
											end
										else
											Result = CalcStat("ClassBaseNCPR",L)
										end
									elseif SN > "WARDENCDBASEVITALITY" then
										if SN < "WARDENCDCALCTYPECOMPHYMIT" then
											if SN == "WARDENCDBASEWILL" then
												Result = CalcStat("ClassBaseWillL",L)
											end
										elseif SN > "WARDENCDCALCTYPECOMPHYMIT" then
											if SN == "WARDENCDCALCTYPENONPHYMIT" then
												Result = 13
											end
										else
											Result = 13
										end
									else
										Result = CalcStat("ClassBaseVitality",L)
									end
								elseif SN > "WARDENCDCALCTYPETACMIT" then
									if SN < "WARDENCDHASPOWER" then
										if SN < "WARDENCDFATETONCPR" then
											if SN == "WARDENCDCANBLOCK" then
												Result = 1
											end
										elseif SN > "WARDENCDFATETONCPR" then
											if SN == "WARDENCDFATETOPOWER" then
												Result = 1
											end
										else
											Result = 0.07
										end
									elseif SN > "WARDENCDHASPOWER" then
										if SN < "WARDENCDMIGHTTOCRITHIT" then
											if SN == "WARDENCDMIGHTTOBLOCK" then
												Result = 1
											end
										elseif SN > "WARDENCDMIGHTTOCRITHIT" then
											if SN == "WARDENCDMIGHTTOFINESSE" then
												Result = 1.5
											end
										else
											Result = 1.5
										end
									else
										Result = 1
									end
								else
									Result = 26
								end
							else
								Result = CalcStat("ClassBaseMorale",L)
							end
						else
							Result = 2
						end
					else
						Result = CalcStat("VMLow",L,"Might")
					end
				else
					Result = CalcStat("VSFinesseL",L)
				end
			elseif SN > "WARDENCDMIGHTTOOUTHEAL" then
				if SN < "WORTHTABL" then
					if SN < "WORTHTABAS" then
						if SN < "WORTHEXT8LIN" then
							if SN < "WARLEADERCANBLOCK" then
								if SN < "WARDENCDWILLTOFINESSE" then
									if SN < "WARDENCDTACMASTOOUTHEAL" then
										if SN < "WARDENCDPHYMITTOCOMPHYMIT" then
											if SN == "WARDENCDMIGHTTOPHYMAS" then
												Result = 2
											end
										elseif SN > "WARDENCDPHYMITTOCOMPHYMIT" then
											if SN == "WARDENCDPHYMITTONONPHYMIT" then
												Result = 1
											end
										else
											Result = 1
										end
									elseif SN > "WARDENCDTACMASTOOUTHEAL" then
										if SN < "WARDENCDVITALITYTOMORALE" then
											if SN == "WARDENCDVITALITYTOICMR" then
												Result = 0.012
											end
										elseif SN > "WARDENCDVITALITYTOMORALE" then
											if SN == "WARDENCDVITALITYTONCMR" then
												Result = 0.12
											end
										else
											Result = 4.5
										end
									else
										Result = 1
									end
								elseif SN > "WARDENCDWILLTOFINESSE" then
									if SN < "WARDENCDWILLTORESIST" then
										if SN < "WARDENCDWILLTOPHYMAS" then
											if SN == "WARDENCDWILLTOOUTHEAL" then
												Result = 1
											end
										elseif SN > "WARDENCDWILLTOPHYMAS" then
											if SN == "WARDENCDWILLTOPHYMIT" then
												Result = 1.5
											end
										else
											Result = 1
										end
									elseif SN > "WARDENCDWILLTORESIST" then
										if SN < "WARDINGLOREPHYMIT" then
											if SN == "WARDENCDWILLTOTACMIT" then
												Result = 1.5
											end
										elseif SN > "WARDINGLOREPHYMIT" then
											if SN == "WARDINGLORETACMIT" then
												if Lm <= 105 then
													Result = CalcStat("Mitigation",L,1.6)
												elseif 120 <= Lp and Lm <= 120 or 130 <= Lp and Lm <= 130 then
													Result = CalcStat("TacMitT",L,1.6)
												else
													Result = CalcStat("TacMitT",L,1.2)
												end
											end
										else
											if Lm <= 105 then
												Result = CalcStat("Mitigation",L,1.6)
											elseif 120 <= Lp and Lm <= 120 or 130 <= Lp and Lm <= 130 then
												Result = CalcStat("PhyMitT",L,1.6)
											else
												Result = CalcStat("PhyMitT",L,1.2)
											end
										end
									else
										Result = 1
									end
								else
									Result = 1
								end
							elseif SN > "WARLEADERCANBLOCK" then
								if SN < "WEAVERCDCALCTYPETACMIT" then
									if SN < "WARLEADERCDHASPOWER" then
										if SN < "WARLEADERCDCALCTYPENONPHYMIT" then
											if SN == "WARLEADERCDCALCTYPECOMPHYMIT" then
												Result = 14
											end
										elseif SN > "WARLEADERCDCALCTYPENONPHYMIT" then
											if SN == "WARLEADERCDCALCTYPETACMIT" then
												Result = 27
											end
										else
											Result = 14
										end
									elseif SN > "WARLEADERCDHASPOWER" then
										if SN < "WEAVERCDCALCTYPECOMPHYMIT" then
											if SN == "WEAVERCANBLOCK" then
												Result = 1
											end
										elseif SN > "WEAVERCDCALCTYPECOMPHYMIT" then
											if SN == "WEAVERCDCALCTYPENONPHYMIT" then
												Result = 14
											end
										else
											Result = 13
										end
									else
										Result = 1
									end
								elseif SN > "WEAVERCDCALCTYPETACMIT" then
									if SN < "WILLCI" then
										if SN < "WILL" then
											if SN == "WEAVERCDHASPOWER" then
												Result = 1
											end
										elseif SN > "WILL" then
											if SN == "WILLC" then
												Result = CalcStat("MainC",L,N)
											end
										else
											Result = CalcStat("Main",L,N)
										end
									elseif SN > "WILLCI" then
										if SN < "WORTHEXT" then
											if SN == "WILLT" then
												Result = CalcStat("MainT",L,N)
											end
										elseif SN > "WORTHEXT" then
											if SN == "WORTHEXT4LIN" then
												if Lm <= 501 then
													Result = CalcStat("WorthExt",L,C)
												elseif Lm <= 601 then
													Result = CalcStat("WorthExt",501,C)+(L-501)*4
												end
											end
										else
											if Lm <= 360 then
												Result = RoundDbl(CalcStat("StatC",L,C))
											elseif Lm <= 601 then
												Result = RoundDbl(CalcStat("StatC",L-1,C))
											end
										end
									else
										Result = CalcStat("MainCI",L,N)
									end
								else
									Result = 27
								end
							else
								Result = 1
							end
						elseif SN > "WORTHEXT8LIN" then
							if SN < "WORTHTABAD" then
								if SN < "WORTHMPH" then
									if SN < "WORTHMPD" then
										if SN < "WORTHMPB" then
											if SN == "WORTHMPA" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,1.1,1.15,1.2,1.3},L))
												end
											end
										elseif SN > "WORTHMPB" then
											if SN == "WORTHMPC" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,1,1,1,1},L))
												end
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = EquSng(DataTableValue({1,1.2,2,3,4},L))
											end
										end
									elseif SN > "WORTHMPD" then
										if SN < "WORTHMPF" then
											if SN == "WORTHMPE" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,1.1,1.15,1.2,1.25},L))
												end
											end
										elseif SN > "WORTHMPF" then
											if SN == "WORTHMPG" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,2,3,4,5},L))
												end
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = EquSng(DataTableValue({0.5,1,1.25,1.5,2},L))
											end
										end
									else
										if 1 <= Lp and Lm <= 5 then
											Result = EquSng(DataTableValue({1,1,1,2,3},L))
										end
									end
								elseif SN > "WORTHMPH" then
									if SN < "WORTHTABA" then
										if SN < "WORTHMPJ" then
											if SN == "WORTHMPI" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,2,2.5,3,10},L))
												end
											end
										elseif SN > "WORTHMPJ" then
											if SN == "WORTHMPK" then
												if 1 <= Lp and Lm <= 5 then
													Result = EquSng(DataTableValue({1,1.2,1.3,1.35,1.4},L))
												end
											end
										else
											if 1 <= Lp and Lm <= 5 then
												Result = EquSng(DataTableValue({1,1,1,1,5},L))
											end
										end
									elseif SN > "WORTHTABA" then
										if SN < "WORTHTABAB" then
											if SN == "WORTHTABAA" then
												Result = CalcStat("WorthTabD",L)+20
											end
										elseif SN > "WORTHTABAB" then
											if SN == "WORTHTABAC" then
												Result = CalcStat("WorthTabE",L)-30
											end
										else
											Result = 7*L+50
										end
									else
										if Lm <= 1 then
											Result = 1
										else
											Result = CalcStat("WorthTabAF",L)
										end
									end
								else
									if 1 <= Lp and Lm <= 5 then
										Result = EquSng(DataTableValue({1,1.2,1.8,3.2,5},L))
									end
								end
							elseif SN > "WORTHTABAD" then
								if SN < "WORTHTABAL" then
									if SN < "WORTHTABAH" then
										if SN < "WORTHTABAF" then
											if SN == "WORTHTABAE" then
												Result = CalcStat("WorthTabE",L)
											end
										elseif SN > "WORTHTABAF" then
											if SN == "WORTHTABAG" then
												Result = CalcStat("WorthTabAF",L)+25
											end
										else
											if Lm <= 49 then
												Result = 2.5*L
											else
												Result = 3*L-25
											end
										end
									elseif SN > "WORTHTABAH" then
										if SN < "WORTHTABAJ" then
											if SN == "WORTHTABAI" then
												if Lm <= 16 then
													Result = 10.73*L+54.3
												elseif Lm <= 34 then
													Result = 10.735*L+54
												elseif Lm <= 35 then
													Result = 429
												elseif Lm <= 41 then
													Result = 10.65*L+57.1
												elseif Lm <= 49 then
													Result = 10.7*L+55.3
												else
													Result = 9*L+141
												end
											end
										elseif SN > "WORTHTABAJ" then
											if SN == "WORTHTABAK" then
												if Lm <= 49 then
													Result = CalcStat("WorthTabALBase",L+1)
												else
													Result = 9*L+78
												end
											end
										else
											Result = CalcStat("WorthTabAH",L)
										end
									else
										if Lm <= 49 then
											Result = CalcStat("WorthTabALBase",L+7)-66
										else
											Result = 9*L+72
										end
									end
								elseif SN > "WORTHTABAL" then
									if SN < "WORTHTABAO" then
										if SN < "WORTHTABAM" then
											if SN == "WORTHTABALBASE" then
												Result = 9.86*L+23.51+RoundDbl(L*0.1+0.3)*0.4
											end
										elseif SN > "WORTHTABAM" then
											if SN == "WORTHTABAN" then
												if Lm <= 50 then
													Result = 8.25*L+27.75
												else
													Result = 8*L+40
												end
											end
										else
											Result = CalcStat("WorthTabB",L)
										end
									elseif SN > "WORTHTABAO" then
										if SN < "WORTHTABAQ" then
											if SN == "WORTHTABAP" then
												Result = CalcStat("WorthTabAQ",L)
											end
										elseif SN > "WORTHTABAQ" then
											if SN == "WORTHTABAR" then
												Result = CalcStat("WorthTabD",L)+37.5
											end
										else
											if Lm <= 10 then
												Result = 7.5*L+60
											elseif Lm <= 49 then
												Result = 5.5*L+80
											else
												Result = 6*L+55
											end
										end
									else
										Result = CalcStat("WorthTabE",L)
									end
								else
									if Lm <= 49 then
										Result = CalcStat("WorthTabALBase",L)
									else
										Result = 9*L+69
									end
								end
							else
								Result = 7*L+100
							end
						else
							if Lm <= 501 then
								Result = CalcStat("WorthExt",L,C)
							elseif Lm <= 601 then
								Result = CalcStat("WorthExt",501,C)+(L-501)*8
							end
						end
					elseif SN > "WORTHTABAS" then
						if SN < "WORTHTABBW" then
							if SN < "WORTHTABBG" then
								if SN < "WORTHTABAZBASE" then
									if SN < "WORTHTABAW" then
										if SN < "WORTHTABAU" then
											if SN == "WORTHTABAT" then
												if Lm <= 4 then
													Result = RoundDbl(3*L+20,-1)
												elseif Lm <= 7 then
													Result = 60
												elseif Lm <= 10 then
													Result = 100
												elseif Lm <= 13 then
													Result = 180
												elseif Lm <= 16 then
													Result = 270
												elseif Lm <= 19 then
													Result = 310
												elseif Lm <= 40 then
													Result = RoundDbl(3.2*L+274,-1)
												elseif Lm <= 43 then
													Result = 400
												elseif Lm <= 53 then
													Result = RoundDbl(1.9*L+334,-1)
												elseif Lm <= 56 then
													Result = 460
												elseif Lm <= 59 then
													Result = 480
												else
													Result = 20*L-680
												end
											end
										elseif SN > "WORTHTABAU" then
											if SN == "WORTHTABAV" then
												if Lm <= 4 then
													Result = RoundDbl(3*L+20,-1)
												elseif Lm <= 7 then
													Result = 70
												elseif Lm <= 10 then
													Result = 140
												elseif Lm <= 13 then
													Result = 270
												elseif Lm <= 16 then
													Result = 400
												elseif Lm <= 19 then
													Result = 460
												elseif Lm <= 25 then
													Result = RoundDbl(3*L+447.5,-1)
												elseif Lm <= 46 then
													Result = RoundDbl(3.2*L+455,-1)
												elseif Lm <= 50 then
													Result = 620
												else
													Result = 20*L-360
												end
											end
										else
											Result = CalcStat("WorthTabBN",L)*1.25
										end
									elseif SN > "WORTHTABAW" then
										if SN < "WORTHTABAY" then
											if SN == "WORTHTABAX" then
												if Lm <= 16 then
													Result = 10.75*L+54
												elseif Lm <= 34 then
													Result = 10.75*L+53.7
												elseif Lm <= 35 then
													Result = 429
												elseif Lm <= 41 then
													Result = 10.65*L+57.1
												elseif Lm <= 49 then
													Result = 10.68*L+56.25
												else
													Result = 12*L-9
												end
											end
										elseif SN > "WORTHTABAY" then
											if SN == "WORTHTABAZ" then
												if Lm <= 10 then
													Result = CalcStat("WorthTabAZBase",L)*62.5
												elseif Lm <= 65 then
													Result = CalcStat("WorthTabAZBase",L)*125
												else
													Result = CalcStat("WorthTabAZBase",L)*25
												end
											end
										else
											Result = 5*L
										end
									else
										if Lm <= 1 then
											Result = 50
										elseif Lm <= 49 then
											Result = 2.5*L+102.5
										elseif Lm <= 80 then
											Result = 3*L+78
										elseif Lm <= 120 then
											Result = 2.97*L+79.5
										else
											Result = 3*L+75
										end
									end
								elseif SN > "WORTHTABAZBASE" then
									if SN < "WORTHTABBC" then
										if SN < "WORTHTABBA" then
											if SN == "WORTHTABB" then
												if Lm <= 50 then
													Result = 8.25*L+22.25
												else
													Result = 8*L+35
												end
											end
										elseif SN > "WORTHTABBA" then
											if SN == "WORTHTABBB" then
												if Lm <= 1 then
													Result = 40
												elseif Lm <= 10 then
													Result = RoundDbl(0.35*L-0.1)*20
												elseif Lm <= 13 then
													Result = 100
												elseif Lm <= 19 then
													Result = RoundDbl(0.35*L+1.6)*20
												elseif Lm <= 25 then
													Result = RoundDbl(2*L+150,-1)
												elseif Lm <= 40 then
													Result = RoundDbl(2*L+164,-1)
												elseif Lm <= 49 then
													Result = RoundDbl(L+201,-1)
												else
													Result = 20*L-740
												end
											end
										else
											Result = 5*L+385
										end
									elseif SN > "WORTHTABBC" then
										if SN < "WORTHTABBE" then
											if SN == "WORTHTABBD" then
												Result = CalcStat("WorthTabK",L)+1
											end
										elseif SN > "WORTHTABBE" then
											if SN == "WORTHTABBF" then
												Result = CalcStat("WorthTabAV",L)+20
											end
										else
											if Lm <= 1 then
												Result = 60
											elseif Lm <= 7 then
												Result = RoundDbl(L/3)*40+30
											elseif Lm <= 13 then
												Result = RoundDbl(L/3)*130-210
											elseif Lm <= 19 then
												Result = RoundDbl(L/3)*60+140
											elseif Lm <= 25 then
												Result = RoundDbl(L/3)*10+480
											elseif Lm <= 46 then
												Result = RoundDbl(L/3)*10+490
											elseif Lm <= 50 then
												Result = 660
											else
												Result = 20*L-320
											end
										end
									else
										if Lm <= 34 then
											Result = RoundDbl(L/15+0.8)*3750+1250
										elseif Lm <= 35 then
											Result = 100000
										else
											Result = 125500
										end
									end
								else
									if Lm <= 44 then
										Result = RoundDbl(0.0525*L+0.7)
									elseif Lm <= 65 then
										Result = RoundDbl(0.19*L-4.85)
									elseif Lm <= 81 then
										Result = RoundDbl(0.19*L+28.15)
									else
										Result = RoundDbl(0.19*L+28.15+RoundDbl(L*0.05-4.55)*0.2)
									end
								end
							elseif SN > "WORTHTABBG" then
								if SN < "WORTHTABBO" then
									if SN < "WORTHTABBK" then
										if SN < "WORTHTABBI" then
											if SN == "WORTHTABBH" then
												if Lm <= 80 then
													Result = RoundDbl(0.05*L-0.05)+RoundDbl(0.05*L+0.45)
												else
													Result = RoundDbl(0.05*L-0.1)+RoundDbl(0.05*L+0.45)
												end
											end
										elseif SN > "WORTHTABBI" then
											if SN == "WORTHTABBJ" then
												Result = RoundDbl(0.1*L+0.45)*3
											end
										else
											Result = CalcStat("WorthTabG",L)-25
										end
									elseif SN > "WORTHTABBK" then
										if SN < "WORTHTABBM" then
											if SN == "WORTHTABBL" then
												if Lm <= 35 then
													Result = 126600
												elseif Lm <= 46 then
													Result = 150600
												elseif Lm <= 47 then
													Result = 180720
												else
													Result = 150600
												end
											end
										elseif SN > "WORTHTABBM" then
											if SN == "WORTHTABBN" then
												if Lm <= 1 then
													Result = 400
												else
													Result = 20*L+800
												end
											end
										else
											if Lm <= 1 then
												Result = 10
											else
												Result = 20*L-20
											end
										end
									else
										if Lm <= 10 then
											Result = RoundDbl(0.1*L+0.45)
										else
											Result = RoundDbl(0.1*L-0.6)*2
										end
									end
								elseif SN > "WORTHTABBO" then
									if SN < "WORTHTABBS" then
										if SN < "WORTHTABBQ" then
											if SN == "WORTHTABBP" then
												if Lm <= 10 then
													Result = 156.25*L+1562.5
												elseif Lm <= 20 then
													Result = 312.5*L
												elseif Lm <= 30 then
													Result = 625*L-6250
												elseif Lm <= 40 then
													Result = 1250*L-25000
												else
													Result = 2500*L-75000
												end
											end
										elseif SN > "WORTHTABBQ" then
											if SN == "WORTHTABBR" then
												if Lm <= 49 then
													Result = CalcStat("WorthTabBQ",L)*2
												else
													Result = 4*L+250
												end
											end
										else
											if Lm <= 1 then
												Result = 50
											elseif Lm <= 49 then
												Result = RoundDbl(2.5*L+100)
											else
												Result = 3*L+75
											end
										end
									elseif SN > "WORTHTABBS" then
										if SN < "WORTHTABBU" then
											if SN == "WORTHTABBT" then
												Result = 62500
											end
										elseif SN > "WORTHTABBU" then
											if SN == "WORTHTABBV" then
												if Lm <= 29 then
													Result = 1250
												else
													Result = RoundDbl(0.05*L-1)*2500
												end
											end
										else
											if Lm <= 80 then
												Result = 20*L+300
											else
												Result = 10*L+1100
											end
										end
									else
										Result = CalcStat("WorthTabBR",L)*2
									end
								else
									if Lm <= 10 then
										Result = 10
									elseif Lm <= 40 then
										Result = RoundDbl(0.1*L-0.55)*50-25
									elseif Lm <= 80 then
										Result = RoundDbl(0.1*L-0.55)*50
									else
										Result = RoundDbl(0.1*L-0.55)*25+175
									end
								end
							else
								if Lm <= 7 then
									Result = RoundDbl(0.2*L-0.4)*2+1
								elseif Lm <= 16 then
									Result = RoundDbl(L/3-2)*6
								elseif Lm <= 22 then
									Result = RoundDbl(L/3+1)*3
								elseif Lm <= 25 then
									Result = RoundDbl(L/3+1)*3-2
								elseif Lm <= 80 then
									Result = RoundDbl(L/3+18)-2
								else
									Result = L-37
								end
							end
						elseif SN > "WORTHTABBW" then
							if SN < "WORTHTABCL" then
								if SN < "WORTHTABCD" then
									if SN < "WORTHTABC" then
										if SN < "WORTHTABBY" then
											if SN == "WORTHTABBX" then
												if Lm <= 10 then
													Result = RoundDbl(0.1*L+0.45)*3
												elseif Lm <= 140 then
													Result = RoundDbl(0.1*L-0.6)*6
												else
													Result = RoundDbl(0.1*L+0.4)*4+22
												end
											end
										elseif SN > "WORTHTABBY" then
											if SN == "WORTHTABBZ" then
												if Lm <= 10 then
													Result = 27.42*L+273.1
												elseif Lm <= 20 then
													Result = 54.69*L
												elseif Lm <= 30 then
													Result = 109.35*L-1093
												elseif Lm <= 40 then
													Result = 218.75*L-4375
												elseif Lm <= 80 then
													Result = 437.5*L-13125
												else
													Result = 437*L-13085
												end
											end
										else
											Result = 90000
										end
									elseif SN > "WORTHTABC" then
										if SN < "WORTHTABCB" then
											if SN == "WORTHTABCA" then
												if Lm <= 10 then
													Result = 7.25*L+72.25
												elseif Lm <= 20 then
													Result = 14.49*L+0.11
												elseif Lm <= 30 then
													Result = 29*L-290
												elseif Lm <= 35 then
													Result = 57.99*L-1160.16
												elseif Lm <= 40 then
													Result = 57.99*L-1160.12
												elseif Lm <= 80 then
													Result = 115.94*L-3478.2
												else
													Result = 116*L-3483
												end
											end
										elseif SN > "WORTHTABCB" then
											if SN == "WORTHTABCC" then
												Result = CalcStat("WorthTabBK",L)*5
											end
										else
											Result = 0.1
										end
									else
										Result = CalcStat("WorthTabD",L)+20
									end
								elseif SN > "WORTHTABCD" then
									if SN < "WORTHTABCH" then
										if SN < "WORTHTABCF" then
											if SN == "WORTHTABCE" then
												Result = CalcStat("WorthTabBN",L)*10
											end
										elseif SN > "WORTHTABCF" then
											if SN == "WORTHTABCG" then
												Result = 20
											end
										else
											if Lm <= 20 then
												Result = RoundDbl(0.1*L-0.55)*600+200
											elseif Lm <= 40 then
												Result = RoundDbl(0.1*L-0.55)*1000-500
											elseif Lm <= 60 then
												Result = RoundDbl(0.1*L-0.55)*2000-4000
											elseif Lm <= 70 then
												Result = 8500
											elseif Lm <= 140 then
												Result = RoundDbl(0.1*L-0.55)*2500-7500
											elseif Lm <= 200 then
												Result = RoundDbl(0.1*L-0.55)*3000-14000
											else
												Result = RoundDbl(0.1*L-0.55)*2500-3500
											end
										end
									elseif SN > "WORTHTABCH" then
										if SN < "WORTHTABCJ" then
											if SN == "WORTHTABCI" then
												Result = 40000
											end
										elseif SN > "WORTHTABCJ" then
											if SN == "WORTHTABCK" then
												Result = 15000
											end
										else
											Result = 20000
										end
									else
										Result = 50000
									end
								else
									Result = CalcStat("WorthTabBK",L)*25
								end
							elseif SN > "WORTHTABCL" then
								if SN < "WORTHTABD" then
									if SN < "WORTHTABCP" then
										if SN < "WORTHTABCN" then
											if SN == "WORTHTABCM" then
												Result = 7500
											end
										elseif SN > "WORTHTABCN" then
											if SN == "WORTHTABCO" then
												Result = CalcStat("WorthTabAB",L)
											end
										else
											Result = RoundDbl(0.1*L+0.5)*10000
										end
									elseif SN > "WORTHTABCP" then
										if SN < "WORTHTABCR" then
											if SN == "WORTHTABCQ" then
												if Lm <= 10 then
													Result = RoundDbl(0.3*L+0.2)*2
												elseif Lm <= 16 then
													Result = RoundDbl(0.25*L-1)*6
												elseif Lm <= 22 then
													Result = RoundDbl(0.3*L+5.5)*2
												elseif Lm <= 50 then
													Result = RoundDbl((1/6)*L+8.75)*2
												elseif Lm <= 80 then
													Result = RoundDbl((1/3)*L-11.5)*6
												else
													Result = RoundDbl(0.25*L-4.6)*6
												end
											end
										elseif SN > "WORTHTABCR" then
											if SN == "WORTHTABCS" then
												Result = CalcStat("WorthTabBR",L)*3
											end
										else
											Result = CalcStat("WorthTabM",L)-15
										end
									else
										Result = 1
									end
								elseif SN > "WORTHTABD" then
									if SN < "WORTHTABH" then
										if SN < "WORTHTABF" then
											if SN == "WORTHTABE" then
												if Lm <= 9 then
													Result = 30*L+50
												else
													Result = 7*L+280
												end
											end
										elseif SN > "WORTHTABF" then
											if SN == "WORTHTABG" then
												if Lm <= 1 then
													Result = 50
												else
													Result = CalcStat("WorthTabAF",L)+100
												end
											end
										else
											Result = 0.1
										end
									elseif SN > "WORTHTABH" then
										if SN < "WORTHTABJ" then
											if SN == "WORTHTABI" then
												if Lm <= 4 then
													Result = 1
												elseif Lm <= 10 then
													Result = 0.7*L-1
												elseif Lm <= 15 then
													Result = 1.4*L-7
												elseif Lm <= 24 then
													Result = 1.25*L-5
												elseif Lm <= 49 then
													Result = 2.5*L-35
												else
													Result = 3*L-60
												end
											end
										elseif SN > "WORTHTABJ" then
											if SN == "WORTHTABK" then
												if Lm <= 9 then
													Result = 12*L+24
												else
													Result = 7*L+74
												end
											end
										else
											if Lm <= 4 then
												Result = 2.5*L+7.5
											elseif Lm <= 5 then
												Result = 23
											else
												Result = 4*L
											end
										end
									else
										if Lm <= 2 then
											Result = L
										elseif Lm <= 9 then
											Result = 1.48*L-2.85
										elseif Lm <= 11 then
											Result = 2.5*L-13
										elseif Lm <= 24 then
											Result = 2.5*L-10
										else
											Result = 5*L-70
										end
									end
								else
									if Lm <= 49 then
										Result = 7.5*L
									else
										Result = 8*L-25
									end
								end
							else
								Result = 12500
							end
						else
							if Lm <= 1 then
								Result = 645
							elseif Lm <= 9 then
								Result = 20*L+980
							else
								Result = 50*L+920
							end
						end
					else
						Result = CalcStat("WorthTabU",L)
					end
				elseif SN > "WORTHTABL" then
					if SN < "WORTHVALBV" then
						if SN < "WORTHVALAQ" then
							if SN < "WORTHVALAA" then
								if SN < "WORTHTABT" then
									if SN < "WORTHTABP" then
										if SN < "WORTHTABN" then
											if SN == "WORTHTABM" then
												if Lm <= 9 then
													Result = 10*L+11
												elseif Lm <= 49 then
													Result = 4*L+65
												else
													Result = 5*L+15
												end
											end
										elseif SN > "WORTHTABN" then
											if SN == "WORTHTABO" then
												Result = CalcStat("WorthTabB",L)+11
											end
										else
											Result = CalcStat("WorthTabAF",L)+25
										end
									elseif SN > "WORTHTABP" then
										if SN < "WORTHTABR" then
											if SN == "WORTHTABQ" then
												Result = 7*L+25
											end
										elseif SN > "WORTHTABR" then
											if SN == "WORTHTABS" then
												Result = CalcStat("WorthTabD",L)+17.5
											end
										else
											if Lm <= 9 then
												Result = 12*L+30
											else
												Result = 7*L+75
											end
										end
									else
										Result = CalcStat("WorthTabE",L)
									end
								elseif SN > "WORTHTABT" then
									if SN < "WORTHTABX" then
										if SN < "WORTHTABV" then
											if SN == "WORTHTABU" then
												if Lm <= 10 then
													Result = 9*L+20
												elseif Lm <= 49 then
													Result = 5.5*L+55
												else
													Result = 6*L+30
												end
											end
										elseif SN > "WORTHTABV" then
											if SN == "WORTHTABW" then
												Result = CalcStat("WorthTabD",L)+25
											end
										else
											Result = CalcStat("WorthTabB",L)-2.75
										end
									elseif SN > "WORTHTABX" then
										if SN < "WORTHTABZ" then
											if SN == "WORTHTABY" then
												Result = CalcStat("WorthTabD",L)+30
											end
										elseif SN > "WORTHTABZ" then
											if SN == "WORTHVALA" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabA")))
											end
										else
											Result = CalcStat("WorthTabR",L)-15
										end
									else
										Result = CalcStat("WorthTabAF",L)+75
									end
								else
									if Lm <= 1 then
										Result = 54
									elseif Lm <= 17 then
										Result = 10.73*L+43.57
									elseif Lm <= 35 then
										Result = 10.735*L+43.265
									elseif Lm <= 36 then
										Result = 429
									elseif Lm <= 42 then
										Result = 10.65*L+46.45
									elseif Lm <= 49 then
										Result = 10.7*L+44.6
									else
										Result = 9*L+130
									end
								end
							elseif SN > "WORTHVALAA" then
								if SN < "WORTHVALAI" then
									if SN < "WORTHVALAE" then
										if SN < "WORTHVALAC" then
											if SN == "WORTHVALAB" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAB")))
											end
										elseif SN > "WORTHVALAC" then
											if SN == "WORTHVALAD" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAD")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAC")))
										end
									elseif SN > "WORTHVALAE" then
										if SN < "WORTHVALAG" then
											if SN == "WORTHVALAF" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAF")))
											end
										elseif SN > "WORTHVALAG" then
											if SN == "WORTHVALAH" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt8Lin",L,"WorthTabAH")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAG")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAE")))
									end
								elseif SN > "WORTHVALAI" then
									if SN < "WORTHVALAM" then
										if SN < "WORTHVALAK" then
											if SN == "WORTHVALAJ" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt8Lin",L,"WorthTabAJ")))
											end
										elseif SN > "WORTHVALAK" then
											if SN == "WORTHVALAL" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt8Lin",L,"WorthTabAL")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt8Lin",L,"WorthTabAK")))
										end
									elseif SN > "WORTHVALAM" then
										if SN < "WORTHVALAO" then
											if SN == "WORTHVALAN" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAN")))
											end
										elseif SN > "WORTHVALAO" then
											if SN == "WORTHVALAP" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAP")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAO")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAM")))
									end
								else
									Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt8Lin",L,"WorthTabAI")))
								end
							else
								Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAA")))
							end
						elseif SN > "WORTHVALAQ" then
							if SN < "WORTHVALBF" then
								if SN < "WORTHVALAY" then
									if SN < "WORTHVALAU" then
										if SN < "WORTHVALAS" then
											if SN == "WORTHVALAR" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAR")))
											end
										elseif SN > "WORTHVALAS" then
											if SN == "WORTHVALAT" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAT")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAS")))
										end
									elseif SN > "WORTHVALAU" then
										if SN < "WORTHVALAW" then
											if SN == "WORTHVALAV" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAV")))
											end
										elseif SN > "WORTHVALAW" then
											if SN == "WORTHVALAX" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAX")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAW")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAU")))
									end
								elseif SN > "WORTHVALAY" then
									if SN < "WORTHVALBB" then
										if SN < "WORTHVALB" then
											if SN == "WORTHVALAZ" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabAZ")))
											end
										elseif SN > "WORTHVALB" then
											if SN == "WORTHVALBA" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBA")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabB")))
										end
									elseif SN > "WORTHVALBB" then
										if SN < "WORTHVALBD" then
											if SN == "WORTHVALBC" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBC")))
											end
										elseif SN > "WORTHVALBD" then
											if SN == "WORTHVALBE" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpJ",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBE")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBD")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBB")))
									end
								else
									Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabAY")))
								end
							elseif SN > "WORTHVALBF" then
								if SN < "WORTHVALBN" then
									if SN < "WORTHVALBJ" then
										if SN < "WORTHVALBH" then
											if SN == "WORTHVALBG" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBG")))
											end
										elseif SN > "WORTHVALBH" then
											if SN == "WORTHVALBI" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBI")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBH")))
										end
									elseif SN > "WORTHVALBJ" then
										if SN < "WORTHVALBL" then
											if SN == "WORTHVALBK" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBK")))
											end
										elseif SN > "WORTHVALBL" then
											if SN == "WORTHVALBM" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBM")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBL")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBJ")))
									end
								elseif SN > "WORTHVALBN" then
									if SN < "WORTHVALBR" then
										if SN < "WORTHVALBP" then
											if SN == "WORTHVALBO" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpG",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBO")))
											end
										elseif SN > "WORTHVALBP" then
											if SN == "WORTHVALBQ" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBQ")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBP")))
										end
									elseif SN > "WORTHVALBR" then
										if SN < "WORTHVALBT" then
											if SN == "WORTHVALBS" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBS")))
											end
										elseif SN > "WORTHVALBT" then
											if SN == "WORTHVALBU" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpF",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBU")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBT")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBR")))
									end
								else
									Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBN")))
								end
							else
								Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBF")))
							end
						else
							Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAQ")))
						end
					elseif SN > "WORTHVALBV" then
						if SN < "WORTHVALK" then
							if SN < "WORTHVALCK" then
								if SN < "WORTHVALCC" then
									if SN < "WORTHVALBZ" then
										if SN < "WORTHVALBX" then
											if SN == "WORTHVALBW" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBW")))
											end
										elseif SN > "WORTHVALBX" then
											if SN == "WORTHVALBY" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBY")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBX")))
										end
									elseif SN > "WORTHVALBZ" then
										if SN < "WORTHVALCA" then
											if SN == "WORTHVALC" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabC")))
											end
										elseif SN > "WORTHVALCA" then
											if SN == "WORTHVALCB" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCB")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCA")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBZ")))
									end
								elseif SN > "WORTHVALCC" then
									if SN < "WORTHVALCG" then
										if SN < "WORTHVALCE" then
											if SN == "WORTHVALCD" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabCD")))
											end
										elseif SN > "WORTHVALCE" then
											if SN == "WORTHVALCF" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabCF")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpH",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCE")))
										end
									elseif SN > "WORTHVALCG" then
										if SN < "WORTHVALCI" then
											if SN == "WORTHVALCH" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCH")))
											end
										elseif SN > "WORTHVALCI" then
											if SN == "WORTHVALCJ" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCJ")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCI")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCG")))
									end
								else
									Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabCC")))
								end
							elseif SN > "WORTHVALCK" then
								if SN < "WORTHVALCS" then
									if SN < "WORTHVALCO" then
										if SN < "WORTHVALCM" then
											if SN == "WORTHVALCL" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCL")))
											end
										elseif SN > "WORTHVALCM" then
											if SN == "WORTHVALCN" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpI",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCN")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCM")))
										end
									elseif SN > "WORTHVALCO" then
										if SN < "WORTHVALCQ" then
											if SN == "WORTHVALCP" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCP")))
											end
										elseif SN > "WORTHVALCQ" then
											if SN == "WORTHVALCR" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCR")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpK",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCQ")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCO")))
									end
								elseif SN > "WORTHVALCS" then
									if SN < "WORTHVALG" then
										if SN < "WORTHVALE" then
											if SN == "WORTHVALD" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabD")))
											end
										elseif SN > "WORTHVALE" then
											if SN == "WORTHVALF" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabF")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabE")))
										end
									elseif SN > "WORTHVALG" then
										if SN < "WORTHVALI" then
											if SN == "WORTHVALH" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabH")))
											end
										elseif SN > "WORTHVALI" then
											if SN == "WORTHVALJ" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabJ")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabI")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabG")))
									end
								else
									Result = RoundDbl(EquSng(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCS")))
								end
							else
								Result = RoundDbl(EquSng(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCK")))
							end
						elseif SN > "WORTHVALK" then
							if SN < "WOUNDRESIST" then
								if SN < "WORTHVALS" then
									if SN < "WORTHVALO" then
										if SN < "WORTHVALM" then
											if SN == "WORTHVALL" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabL")))
											end
										elseif SN > "WORTHVALM" then
											if SN == "WORTHVALN" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabN")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabM")))
										end
									elseif SN > "WORTHVALO" then
										if SN < "WORTHVALQ" then
											if SN == "WORTHVALP" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabP")))
											end
										elseif SN > "WORTHVALQ" then
											if SN == "WORTHVALR" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabR")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabQ")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabO")))
									end
								elseif SN > "WORTHVALS" then
									if SN < "WORTHVALW" then
										if SN < "WORTHVALU" then
											if SN == "WORTHVALT" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt8Lin",L,"WorthTabT")))
											end
										elseif SN > "WORTHVALU" then
											if SN == "WORTHVALV" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabV")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabU")))
										end
									elseif SN > "WORTHVALW" then
										if SN < "WORTHVALY" then
											if SN == "WORTHVALX" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabX")))
											end
										elseif SN > "WORTHVALY" then
											if SN == "WORTHVALZ" then
												Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabZ")))
											end
										else
											Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabY")))
										end
									else
										Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabW")))
									end
								else
									Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabS")))
								end
							elseif SN > "WOUNDRESIST" then
								if SN < "WRDFINESSE" then
									if SN < "WPNDPS" then
										if SN < "WPNDMGMAX" then
											if SN == "WOUNDRESISTT" then
												Result = CalcStat("ResistAddT",L,N)
											end
										elseif SN > "WPNDMGMAX" then
											if SN == "WPNDMGMIN" then
												Result = EquSng(((2-2*CalcStat("WpnDPSVarianceType",WpnCodeIndex(C,2)))/(2-CalcStat("WpnDPSVarianceType",WpnCodeIndex(C,2))))*CalcStat("CombatBaseWpnDPS",L,C))
											end
										else
											Result = EquSng((2/(2-CalcStat("WpnDPSVarianceType",WpnCodeIndex(C,2))))*CalcStat("CombatBaseWpnDPS",L,C))
										end
									elseif SN > "WPNDPS" then
										if SN < "WRDBATSTRIKESCRITDEF" then
											if SN == "WPNDPSVARIANCETYPE" then
												if 1 <= Lp and Lm <= 3 then
													Result = EquSng(DataTableValue({0.25,0.25,0.25},L))
												end
											end
										elseif SN > "WRDBATSTRIKESCRITDEF" then
											if SN == "WRDCRITDEF" then
												Result = CalcStat("CritDefT",L,1.0)
											end
										else
											Result = -CalcStat("CritDefT",L,CalcStat("Trait123Choice",N)*0.4)
										end
									else
										Result = CalcStat("CombatBaseWpnDPS",L,C)
									end
								elseif SN > "WRDFINESSE" then
									if SN < "WRDSHIELDMASBLOCK" then
										if SN < "WRDPHYMAS" then
											if SN == "WRDIMPRBLADESPARRY" then
												Result = CalcStat("ParryT",L,2.8)
											end
										elseif SN > "WRDPHYMAS" then
											if SN == "WRDRECKLESSNCRITHIT" then
												Result = CalcStat("CritHitT",L,2.4)
											end
										else
											Result = CalcStat("PhyMasT",L,CalcStat("Trait123455Choice",N)*0.4)
										end
									elseif SN > "WRDSHIELDMASBLOCK" then
										if SN < "WRDSTDYOURGRBLOCK" then
											if SN == "WRDSHIELDTACTCRITDEF" then
												Result = CalcStat("CritDefT",L,2)
											end
										elseif SN > "WRDSTDYOURGRBLOCK" then
											if SN > "WRDSTDYOURGREVADE" then
												if SN == "WRDSTDYOURGRPARRY" then
													Result = CalcStat("ParryT",L,CalcStat("Trait1234Choice",N)*0.4)
												end
											elseif SN == "WRDSTDYOURGREVADE" then
												Result = -CalcStat("EvadeT",L,CalcStat("Trait1234Choice",N)*0.4)
											end
										else
											Result = CalcStat("BlockT",L,CalcStat("Trait1234Choice",N)*0.4)
										end
									else
										Result = CalcStat("BlockT",L,2.8)
									end
								else
									Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4)
								end
							else
								Result = CalcStat("ResistAdd",L,N)
							end
						else
							Result = RoundDbl(EquSng(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabK")))
						end
					else
						Result = RoundDbl(EquSng(CalcStat("WorthMpD",QualityCodeIndex(C))*CalcStat("WorthExt4Lin",L,"WorthTabBV")))
					end
				else
					Result = CalcStat("WorthTabB",L)+19.25
				end
			else
				Result = 2
			end
		else
			Result = CalcStat("MitLightPRatPA",L)
		end
	else
		Result = 1
	end

	return Result
end

-- Support functions for CalcStat. These consist of implementations of more complex calculation types, decode methods for parameter "C" and rounding/min/max/compare functions for floating point numbers.

-- ****************** Calculation Type support functions ******************

-- DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
-- DataTableValue: Takes a value from an array table.

function DataTableValue(vDataArray, dIndex)

	local lIndex = RoundDbl(dIndex);
	if lIndex <= 1 then
		return vDataArray[1];
	elseif lIndex > #vDataArray then
		return vDataArray[#vDataArray];
	else
		return vDataArray[lIndex];
	end

end

-- EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
-- ExpFmod: Exponential function based on percentage.
-- Common percentage values are around ~5.5% for between levels and ~20% jumps between level segments.

function ExpFmod(dVal, dLstart, dPlvl, dLvl, vDec, vAdd)

	local dRng = dLvl-dLstart+1;
	if dRng <= DblCalcDev then
		return dVal;
	else
		local dFac = 1+dPlvl/100;
		local dAdd;
		if vAdd == nil then
			dAdd = 0;
		else
			dAdd = vAdd;
		end
		if vDec == nil then
			local dFacExp = dFac^dRng;
			return dVal*dFacExp+dAdd*((dFacExp-1)/(dFac-1));
		else
			local dResult = dVal;
			local dLm = dLstart-DblCalcDev;
			while dLm <= dLvl do
				dResult = RoundDbl(dResult*dFac+dAdd,vDec);
				dLm = dLm+1;
			end
			return dResult;
		end
	end

end

-- PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
-- CalcPercAB: Calculates the percentage out of a rating based on the AB formula.

function CalcPercAB(dA, dB, dPCap, dR)

	if dR <= DblCalcDev then
		return 0.0;
	else
		local dResult = dA/(1+dB/dR);
		if dResult >= dPCap-DblCalcDev then
			return dPCap;
		else
			return dResult;
		end
	end

end

-- RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
-- CalcRatAB: Calculates the rating out of a percentage based on the AB formula.

function CalcRatAB(dA, dB, dCapR, dP)

	if dP <= DblCalcDev then
		return 0.0;
	else
		local dResult = dB/(dA/dP-1);
		if dResult >= dCapR-DblCalcDev then
			return dCapR;
		else
			return dResult;
		end
	end

end

-- SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
-- StatLinInter: (Normalized) Stat Linear Interpolating

function StatLinInter(sPntMP, sProgScheme, sProgBase, sAdj, dLvl, vNorC, vRoundType)

	-- parameter processing
	local dN = 1;
	local sC = "";
	if type(vNorC) == "number" then
		dN = vNorC;
	elseif type(vNorC) == "string" then
		sC = vNorC;
	end

	local dRoundType = 0;
	if type(vRoundType) == "number" then
		dRoundType = vRoundType;
	end
	
	local dProgScheme = CalcStat(sProgScheme,dLvl);
	if type(dProgScheme) ~= "table" then
		return 0.0;
	end

	-- find level interval
	local dLvlMinus = dLvl-DblCalcDev;
	local iPointIndexHigh = 2;
	local iPointIndexMax = #dProgScheme[1];
	while iPointIndexHigh < iPointIndexMax do
		if dLvlMinus <= dProgScheme[1][iPointIndexHigh] then
			break;
		end
		iPointIndexHigh = iPointIndexHigh+1;
	end
	local iPointIndexLow = iPointIndexHigh-1;
		
	local dAccessLvlLow = dProgScheme[1][iPointIndexLow];
	local dAccessLvlHigh = dProgScheme[1][iPointIndexHigh];
	local dBaseLvlLow = dProgScheme[2][iPointIndexLow];
	local dBaseLvlHigh = dProgScheme[2][iPointIndexHigh];
	
	-- get values from base progression
	local dValLow = CalcStat(sProgBase,dBaseLvlLow,sC);
	local dValHigh = CalcStat(sProgBase,dBaseLvlHigh,sC);

	-- graph point multiplications
	if type(sPntMP) == "string" and sPntMP ~= "" then
		dValLow = dValLow*CalcStat(sPntMP,dAccessLvlLow,sC);
		dValHigh = dValHigh*CalcStat(sPntMP,dAccessLvlHigh,sC);
	end
	if type(sAdj) == "string" and sAdj ~= "" then
		dValLow = dValLow*CalcStat(sAdj,dAccessLvlLow,sC);
		dValHigh = dValHigh*CalcStat(sAdj,dAccessLvlHigh,sC);
	end
	dValLow = dValLow*dN;
	dValHigh = dValHigh*dN;

	-- graph point roundings
	if dRoundType == 0 then
		dValLow = RoundDblLotro(dValLow);
		dValHigh = RoundDblLotro(dValHigh);
	elseif dRoundType == 1 then
		if -100.0 <= dValLow and dValLow <= 100.0 then
			dValLow = RoundDblUp(dValLow,2);
		elseif -1000.0 <= dValLow and dValLow <= 1000.0 then
			dValLow = RoundDblUp(dValLow,1);
		else
			dValLow = RoundDblLotro(dValLow);
		end
		if -100.0 <= dValHigh and dValHigh <= 100.0 then
			dValHigh = RoundDblUp(dValHigh,2);
		elseif -1000.0 <= dValHigh and dValHigh <= 1000.0 then
			dValHigh = RoundDblUp(dValHigh,1);
		else
			dValHigh = RoundDblLotro(dValHigh);
		end
	elseif dRoundType == 2 then
		dValLow = RoundDblLotro(dValLow);
		if dValLow == -1 then
			dValLow = -2;
		end
		dValHigh = RoundDblLotro(dValHigh);
		if dValHigh == -1 then
			dValHigh = -2;
		end
	elseif dRoundType == 3 then
		dValLow = RoundDblProg(dValLow);
		dValHigh = RoundDblProg(dValHigh);
	end

	-- return interpolated value from the calculated graph points
	return LinFmod(1,dValLow,dValHigh,dAccessLvlLow,dAccessLvlHigh,dLvl);

end

-- TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
-- LinFmod: Linear line function between 2 points with some optional modifications.
-- Connects point (dLstart,dVal*dFstart) with (dLend,dVal*dFend).
-- Usually used with dVal=1 and dFstart/dFend containing unrelated points or dVal=# and dFstart/dFend containing multiplier factors.
-- Modification for in-between points on the line: rounding.

function LinFmod(dVal, dFstart, dFend, dLstart, dLend, dLvl, vDec)

	if type(vDec) == "string" then
		local sRoundType = string.upper(vDec);
		if sRoundType == "P" then
			return LinFmod(1,RoundDblProg(dVal*dFstart),RoundDblProg(dVal*dFend),dLstart,dLend,dLvl);
		elseif sRoundType == "L" then
			return LinFmod(1,RoundDblLotro(dVal*dFstart),RoundDblLotro(dVal*dFend),dLstart,dLend,dLvl);
		else
			return LinFmod(1,dVal*dFstart,dVal*dFend,dLstart,dLend,dLvl);
		end
	end
	if dLstart-DblCalcDev <= dLvl and dLvl <= dLstart+DblCalcDev then
		return dVal*dFstart;
	elseif dLend-DblCalcDev <= dLvl and dLvl <= dLend+DblCalcDev then
		return dVal*dFend;
	elseif dLstart == dLend then
		return 0.0;
	elseif vDec == nil then
		return dVal*(dFstart*(dLend-dLvl)+(dLvl-dLstart)*dFend)/(dLend-dLstart);
	else
		return RoundDbl(dVal*(dFstart*(dLend-dLvl)+(dLvl-dLstart)*dFend)/(dLend-dLstart),vDec);
	end

end

-- ****************** Parameter "C" decode support functions ******************

-- ArmCodeIndex: returns a specified index from an Armour Code.
-- sACode string:
-- 1st position: H=heavy, M=medium, L=light
-- 2nd position: H=head, S=shoulders, CL=cloak/back, C=chest, G=gloves, L=leggings, B=boots, Sh=shield
-- 3rd position: W=white/common, Y=yellow/uncommon, P=purple/rare, T=teal/blue/incomparable, G=gold/legendary/epic
-- Note: no such thing exists as a heavy, medium or light cloak, so no H/M/L in cloak codes (cloaks go automatically in the M class since U23, although historically this was L)

function ArmCodeIndex(sACode, iI)

	if sACode == nil or iI == nil then
		return 0;
	end
	if type(sACode) ~= "string" or type(iI) ~= "number" then
		return 0;
	end

	local sArmCode = string.match(sACode,"(%a+)");
	if not sArmCode then
		return 0;
	end
	sArmCode = string.upper(sArmCode).."    ";
	
	local sArmCat = string.sub(sArmCode,1,1);
	local sArmType = string.sub(sArmCode,2,2);
	local sArmCol = string.sub(sArmCode,3,3);

	if sArmType == "S" and sArmCol == "H" then
		sArmType = "SH";
		sArmCol = string.sub(sArmCode,4,4);
	elseif sArmCat == "C" and sArmType == "L" then
		sArmCat = "M";
		sArmType = "CL";
	elseif sArmType then
		sArmType = " "..sArmType;
	end
	
	local result = 0;
	if iI == 1 then
		if sArmCat then
			result = string.find("HML",sArmCat);
		end
	elseif iI == 2 then
		if sArmType then
			result = string.find(" H SCL C G L BSH",sArmType);
			if result then
				result = (result+1)/2;
			end
		end
	elseif iI == 3 then
		if sArmCol then
			result = string.find("WYPTG",sArmCol);
		end
	end

	if result then
		return result;
	else
		return 0;
	end
	
end

-- QualityCodeIndex: returns a quality index from a Quality Code.
-- sQCode string: W=white/common, Y=yellow/uncommon, P=purple/rare, T=teal/blue/incomparable, G=gold/legendary/epic

function QualityCodeIndex(sQCode)

	if sQCode == nil then
		return 0;
	end
	if type(sQCode) ~= "string" then
		return 0;
	end

	local sQtyCode = string.match(sQCode,"(%a+)");
	if not sQtyCode then
		return 0;
	end
	sQtyCode = string.upper(sQtyCode).." ";

	local sQtyCol = string.sub(sQtyCode,1,1);
	
	local result = 0;
	if sQtyCol then
		result = string.find("WYPTG",sQtyCol);
	end
	
	if result then
		return result;
	else
		return 0;
	end
	
end

-- WpnCodeIndex: returns a specified index from a Weapon Code.
-- sWCode string:
-- 1st position: H=heavy, L=light
-- 2nd position: O=one-handed, T=two-handed, B=bow
-- 3rd position: W=white/common, Y=yellow/uncommon, P=purple/rare, T=teal/blue/incomparable, G=gold/legendary/epic

function WpnCodeIndex(sWCode, iI)

	if sWCode == nil or iI == nil then
		return 0;
	end
	if type(sWCode) ~= "string" or type(iI) ~= "number" then
		return 0;
	end

	local sWpnCode = string.match(sWCode,"(%a+)");
	if not sWpnCode then
		return 0;
	end
	sWpnCode = string.upper(sWpnCode).."   ";
	
	local sWpnCat = string.sub(sWpnCode,1,1);
	local sWpnType = string.sub(sWpnCode,2,2);
	local sWpnCol = string.sub(sWpnCode,3,3);

	local result = 0;
	if iI == 1 then
		if sWpnCat then
			result = string.find("HL",sWpnCat);
		end
	elseif iI == 2 then
		if sWpnType then
			result = string.find("OTB",sWpnType);
		end
	elseif iI == 3 then
		if sWpnCol then
			result = string.find("WYPTG",sWpnCol);
		end
	end

	if result then
		return result;
	else
		return 0;
	end
	
end

-- RomanRankDecode: converts a string with a Roman number in characters, to an integer number.
-- used for Legendary Item Title calculation.

local RomanCharsToValues = {["M"]=1000,["CM"]=900,["D"]=500,["CD"]=400,["C"]=100,["XC"]=90,["L"]=50,["XL"]=40,["X"]=10,["IX"]=9,["V"]=5,["IV"]=4,["I"]=1};

function RomanRankDecode(sNumber)

	if sNumber ~= nil and type(sNumber) == "string" and sNumber ~= "" then
		for sRomanRankChar, iRomanRankValue in pairs(RomanCharsToValues) do
			if string.sub(string.upper(sNumber),1,string.len(sRomanRankChar)) == sRomanRankChar then
				return iRomanRankValue+RomanRankDecode(string.sub(sNumber,string.len(sRomanRankChar)+1));
			end
		end
	end
	
	return 0;
	
end

-- ReverseCalc: tries to calculate back a calculation result to the original (integer) level.
-- Does not support N.

function ReverseCalc(sStat, dNum)

	if string.len(string.match(sStat,"([-%w]+)")) > 0 then
		local dNumMinus = dNum-DblCalcDev;
		local dNumPlus = dNum+DblCalcDev;
		local minlvl = 1;
		local maxlvl = 549;
		local devlvl = 3;
	
		local left = minlvl-1;
		local right = maxlvl;
		local middle;
		
		local count = minlvl;

		while right > left+1 and count <= maxlvl do
			count = count+1;
			middle = math.floor((left+right)/2);
			if CalcStat(sStat,middle) >= dNumMinus then
				right = middle;
			else
				left = middle;
			end
		end

		local mintest = right-devlvl;
		if mintest < minlvl then
			mintest = minlvl;
		end
		local maxtest = right+devlvl;
		if maxtest > maxlvl then
			maxtest = maxlvl;
		end

		local dFound;
	
		-- we check nearby in case the progression is not completely ascending/sorted.
		for test = mintest, maxtest do
			dFound = CalcStat(sStat,test);
			if dNumMinus <= dFound and dFound <= dNumPlus then
				return test;
			end
		end
	end

	return 0;

end

-- ****************** Misc. floating point support functions ******************

-- Misc. functions for floating point rounding.
-- 2nd parameter is number of decimals.

function RoundDbl(dNum, vDec)

	local dCorrection = 0.5+DblCalcDev;
	local iSign = 1;
	if dNum < 0 then
		iSign = -1;
	end
	if vDec == nil or (-DblCalcDev <= vDec and vDec <= DblCalcDev) then
		return iSign*math.floor(iSign*dNum+dCorrection);
	else
		local dFactor = 10^vDec;
		return iSign*math.floor(iSign*dNum*dFactor+dCorrection)/dFactor;
	end
	
end

function RoundDblDown(dNum, vDec)

	local dCorrection = DblCalcDev;
	local iSign = 1;
	if dNum < 0 then
		iSign = -1;
	end
	if vDec == nil or (-DblCalcDev <= vDec and vDec <= DblCalcDev) then
		return iSign*math.floor(iSign*dNum+dCorrection);
	else
		local dFactor = 10^vDec;
		return iSign*math.floor(iSign*dNum*dFactor+dCorrection)/dFactor;
	end
	
end

function RoundDblUp(dNum, vDec)

	local dCorrection = 1-DblCalcDev;
	local iSign = 1;
	if dNum < 0 then
		iSign = -1;
	end
	if vDec == nil or (-DblCalcDev <= vDec and vDec <= DblCalcDev) then
		return iSign*math.floor(iSign*dNum+dCorrection);
	else
		local dFactor = 10^vDec;
		return iSign*math.floor(iSign*dNum*dFactor+dCorrection)/dFactor;
	end
	
end

function RoundDblLotro(dNum)

	local dCorrection = 1-DblCalcDev;
	local iSign = 1;
	if dNum < 0 then
		iSign = -1;
	end

	local iNumCeiled = math.floor(iSign*dNum+dCorrection);
	if iNumCeiled <= 1000 then
		return iSign*iNumCeiled;
	end

	local iFactor = 1;
	local iTestNum = math.floor(iNumCeiled/1000);
	while iTestNum > 0 do
		iTestNum = math.floor(iTestNum/10);
		iFactor = iFactor*10;
	end

	return iSign*math.floor(iNumCeiled/iFactor+dCorrection)*iFactor;

end

function RoundDblProg(dNum)

	local dCorrection = 0.5+DblCalcDev;
	local iSign = 1;
	if dNum < 0 then
		iSign = -1;
	end
	
	local dTestNum = dNum/(0.5*(iSign*63));
	local dDec = -math.floor(math.log10(dTestNum));

	if -DblCalcDev <= dDec and dDec <= DblCalcDev then
		return iSign*math.floor(iSign*dNum+dCorrection);
	else
		local dFactor = 10^dDec;
		return iSign*math.floor(iSign*dNum*dFactor+dCorrection)/dFactor;
	end

end

-- ******************************* End CalcStat *******************************