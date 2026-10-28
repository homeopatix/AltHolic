-- Created by Giseldah

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

local CalcStat
local LinFmod

-- removes leading and trailing white space characters from a string
local function trim(s)
	if type(s) ~= "string" then return "" end
	return strmatch(s,"^()%s*$") and "" or strmatch(s,"^%s*(.*%S)")
end

-- **************** Misc. floating point support functions ****************

-- Misc. functions for floating point rounding.
-- 2nd parameter is number of decimals.

-- Floating point numbers bring errors into the calculation, both inside the Lotro-client and in this function collection. This is why a 100% match with the stats in Lotro is impossible.
-- Anyway, to compensate for some errors, we use a calculation deviation correction value. This makes for instance 24.49999999 round to 25, as it's assumed that 24.5 was intended as outcome of a formula.
local DblCalcDev = 1e-8
local DblCorrDown = DblCalcDev
local DblCorrNormal = 0.5+DblCalcDev
local DblCorrUp = 1.0-DblCalcDev

local IntPow10 = {10,100,1000,10000,100000,1000000,10000000,100000000,1000000000,10000000000} -- 1-10 decimals

local function CorrectDbl(vNum,dCorrection,iDec)
	if vNum == 0.0 then return 0 end -- integer result

	local dSignedCorrection = dCorrection
	if vNum < 0.0 then dSignedCorrection = -dCorrection end

	if iDec == 0 then return (mathmodf(vNum+dSignedCorrection)) end -- integer result

	local iFactor

	if iDec < 0 then
		iFactor = IntPow10[-iDec]
		return (mathmodf(vNum/iFactor+dSignedCorrection))*iFactor -- integer result
	end

	iFactor = IntPow10[iDec]
	local dRounded = (mathmodf(vNum*iFactor+dSignedCorrection))/iFactor
	local iInt, fFrac = mathmodf(dRounded)
	if fFrac == 0.0 then return iInt end -- integer result

	return dRounded -- double result
end

local function RoundDbl(vNum,vDec)
	if vDec == nil then return CorrectDbl(vNum,DblCorrNormal,0) end
	return CorrectDbl(vNum,DblCorrNormal,(mathmodf(vDec)))
end

local function RoundDblDown(vNum,vDec)
	if vDec == nil then return CorrectDbl(vNum,DblCorrDown,0) end
	return CorrectDbl(vNum,DblCorrDown,(mathmodf(vDec)))
end

local function RoundDblUp(vNum,vDec)
	if vDec == nil then return CorrectDbl(vNum,DblCorrUp,0) end
	return CorrectDbl(vNum,DblCorrUp,(mathmodf(vDec)))
end

local function RoundDblLotro(vNum)
	if (0.0 > vNum and vNum >= -2.0) then return -2 end
	local dAbsNum = mathabs(vNum)
	if dAbsNum <= 1000.0 then return CorrectDbl(vNum,DblCorrUp,0) end
	return CorrectDbl(vNum,DblCorrUp,2-mathfloor(mathlog10(dAbsNum)))
end

local function RoundDblMorReg(vNum)
	local dAbsNum = mathabs(vNum)
	if dAbsNum <= 100.0 then return CorrectDbl(vNum,DblCorrUp,2) end
	if dAbsNum <= 1000.0 then return CorrectDbl(vNum,DblCorrUp,1) end
	return CorrectDbl(vNum,DblCorrUp,2-mathfloor(mathlog10(dAbsNum)))
end

local function RoundDblProg(vNum)
	if vNum == 0.0 then return vNum end
	return CorrectDbl(vNum,DblCorrNormal,2-mathfloor(mathlog10(mathabs(vNum))+0.5))
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
	-- Handle special cases (zero/-zero, infinity, -infinity, NaN)
	if vVal == 0 or vVal == mathhuge or vVal == -mathhuge or vVal ~= vVal then
		return vVal
	end

	-- Get the sign and absolute value of the (double float) number
	local nSign = 1
	local nValAbs = vVal
	if vVal < 0 then
		nSign = -1
		nValAbs = -vVal
	end

	-- Use math.frexp to get mantissa and exponent, where nValAbs = mantissa * 2^exponent, with mantissa in the range [0.5,1.0)
	local nMantissa, nExponent = mathfrexp(nValAbs)
	-- math.frexp did not return a mantissa value in the right interval for a normalized number
	nMantissa = nMantissa*2 -- Transform mantissa from [0.5,1.0) to [1.0,2.0) for now. Later becomes implicit leading 1.0 + [0.0,1.0) for normalized numbers.
	nExponent = nExponent-1 -- Mantissa became larger by factor 2^1, need to compensate for this in the exponent.

	if nExponent > IEEE754_MAX_NORMAL_EXPONENT then
		-- Overflow to infinity
		return (nSign < 0) and -mathhuge or mathhuge
	end

	-- Explicit leading 1 used for calculating the single float value: will be 1(normalized value) or 0(subnormal number)
	local nLeadingOne = 0
	if nExponent < IEEE754_MIN_NORMAL_EXPONENT then
		-- Subnormal number
		nMantissa = mathldexp(nMantissa,nExponent-IEEE754_MIN_NORMAL_EXPONENT) -- Transfer old exponent into mantissa and extract new exponent(MIN_NORMAL_EXPONENT) in one go
		if nMantissa == 0 then
			return 0*nSign  -- flush to zero, preserve sign
		end
		nExponent = IEEE754_MIN_NORMAL_EXPONENT
	else
		-- Normalized number
		nLeadingOne = 1 -- Transfer 1 from mantissa to 'explicit leading 1'
		nMantissa = nMantissa-1 -- Mantissa is now in the interval [0.0,1.0)
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
		if nLeadingOne == 0 then
			-- Subnormal number: transform to Normalized number
			nLeadingOne = 1
		else
			-- Normalized number: increment exponent
			nExponent = nExponent+1
			if nExponent > IEEE754_MAX_NORMAL_EXPONENT then
				-- Overflow to infinity
				return (nSign < 0) and -mathhuge or mathhuge
			end
		end
		nMantissa = 0 -- Reset mantissa
	end

	return nSign*mathldexp(nLeadingOne+nMantissa*IEEE754_MANTISSA_VALUESCALE,nExponent)
end

-- Converts a double value into the decimal representation of an equivalent single float value
local function DecSng(vVal)
	local dVal = EquSng(vVal)
	if dVal == 0.0 then return 0.0 end -- return 0 when 0
	
	-- calculate decimals interval for a max total of 8 digit precision
	-- 0.09#######: 9 to 2
	-- 0.9#######: 8 to 1
	-- 9.#######: 7 to 0
	-- 9#.######: 6 to -1
	-- 9##.#####: 5 to -2 etc
	local iDecMin = 8-(mathfloor(mathlog10(mathabs(dVal)))+1)
	local iDecMax = iDecMin-7
	-- result always needs to be rounded at least once, even if the result is not the same as the original equiv. float value
	local dResult = CorrectDbl(dVal,DblCorrNormal,iDecMin)
	-- search for the least number of decimals, while still keeping the same single value
	local dTest
	for iDec = iDecMin-1,iDecMax,-1 do
		dTest = CorrectDbl(dVal,DblCorrNormal,iDec) -- test value with ever less precision
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

-- ****************** Calculation Type support functions ******************

-- DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
-- DataTableValue: Takes a value from an array table.
local function DataTableValue(vDataArray,dIndex)
	local iIndex = RoundDbl(dIndex)
	if iIndex <= 1 then return vDataArray[1] end
	if iIndex > #vDataArray then return vDataArray[#vDataArray] end
	return vDataArray[iIndex]
end

-- EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
-- ExpFmod: Exponential function based on percentage.
-- Common percentage values are around ~5.5% for between levels and ~20% jumps between level segments.
local function ExpFmod(dVal,dLstart,dPlvl,dLvl,vAdd,vDec)
	local dRng = dLvl-dLstart+1.0
	if dRng <= 0.0 then return dVal end
	
	local dFac = 1.0+dPlvl/100.0

	local dAdd = 0.0
	if vAdd ~= nil then dAdd = vAdd end

	if vDec == nil then
		local dFacExp = dFac^dRng
		return dVal*dFacExp+dAdd*((dFacExp-1.0)/(dFac-1.0))
	end
	
	local dResult = dVal
	local dL = dLstart
	while dL <= dLvl do
		dResult = RoundDbl(dResult*dFac+dAdd,vDec)
		dL = dL+1.0
	end
	return dResult
end

-- IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
-- LinInter: Linear Interpolation, given simple graph point data {{levels},{values}}
local function LinInter(dProgGraph,dLvl)
	-- parameter processing
	local dLevels = dProgGraph[1]
	local dValues = dProgGraph[2]

	-- find interval points for requested level
	local iHigh = 2
	local iMax = #dLevels
	while iHigh < iMax and dLvl > dLevels[iHigh] do iHigh = iHigh+1 end
	local iLow = iHigh-1

	-- return interpolated value from the calculated graph points
	return LinFmod(1.0,dValues[iLow],dValues[iHigh],dLevels[iLow],dLevels[iHigh],dLvl)
end

-- PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
-- CalcPercAB: Calculates the percentage out of a rating based on the AB formula.
local function CalcPercAB(dA,dB,dPCap,dR)
	if dR <= 0.0 then return 0.0 end
	local dResult = dA/(1.0+dB/dR)
	if dResult >= dPCap then return dPCap end
	return dResult
end

-- RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
-- CalcRatAB: Calculates the rating out of a percentage based on the AB formula.
local function CalcRatAB(dA,dB,dCapR,dP)
	if dP <= 0.0 then return 0.0 end
	local dResult = dB/(dA/dP-1.0)
	if dResult >= dCapR then return dCapR end
	return dResult
end

-- SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
-- StatLinInter: (Normalized) Stat Linear Interpolating
local function StatLinInter(sPntMP,sProgScheme,sProgBase,sAdj,dLvl,vNorC,vRoundType)
	-- parameter processing
	local dN = 1.0
	local sC = ""
	if vNorC then
		if type(vNorC) == "number" then dN = vNorC else sC = vNorC end
	end

	local dProgScheme = CalcStat(sProgScheme,dLvl)
	local dAccessLvls = dProgScheme[1]
	local dBaseLvls = dProgScheme[2]

	-- find interval points for requested level
	local iHigh = 2
	local iMax = #dAccessLvls
	while iHigh < iMax and dLvl > dAccessLvls[iHigh] do iHigh = iHigh+1 end
	local iLow = iHigh-1

	local dAccessLvlLow = dAccessLvls[iLow]
	local dAccessLvlHigh = dAccessLvls[iHigh]

	local dValLow, dValHigh
	if sProgBase == "" then
		-- if not given: expect the base levels to contain the values directly
		dValLow = dBaseLvls[iLow]
		dValHigh = dBaseLvls[iHigh]
	else
		-- get values from base progression if given
		dValLow = CalcStat(sProgBase,dBaseLvls[iLow],sC)
		dValHigh = CalcStat(sProgBase,dBaseLvls[iHigh],sC)
	end
	
	-- graph point multiplications
	if sPntMP ~= "" then
		dValLow = dValLow*CalcStat(sPntMP,dAccessLvlLow,sC)
		dValHigh = dValHigh*CalcStat(sPntMP,dAccessLvlHigh,sC)
	end
	if sAdj ~= "" then
		dValLow = dValLow*CalcStat(sAdj,dAccessLvlLow,sC)
		dValHigh = dValHigh*CalcStat(sAdj,dAccessLvlHigh,sC)
	end

	-- return interpolated value from the calculated graph points
	return LinFmod(dN,dValLow,dValHigh,dAccessLvlLow,dAccessLvlHigh,dLvl,vRoundType)
end

-- TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
-- LinFmod: Linear line function between 2 points with some optional modifications.
-- Connects point (dLstart,dVal*dFstart) with (dLend,dVal*dFend).
-- Usually used with dVal=1 and dFstart/dFend containing unrelated points or dVal=base and dFstart/dFend containing multiplier factors.
-- Modification for points: rounding.

-- list of functions which are used for rounding graph point values
local fRoundTypes = {
	[0] = function(dValue) return dValue end, -- no rounding function
	RoundDblProg,
	RoundDblLotro,
	RoundDblMorReg
}

LinFmod = function(dVal,dFstart,dFend,dLstart,dLend,dLvl,vRoundType)
	-- parameter processing
	local fRound = fRoundTypes[vRoundType or 0]

	-- finalize interval values: multiply base Value by Factor and apply rounding by requested type
	-- return point value directly if requested level is a low/high interval point
	local dVstart = fRound(dVal*dFstart)
	if dLvl == dLstart then return dVstart end
	local dVend = fRound(dVal*dFend)
	if dLvl == dLend then return dVend end

	if dLstart == dLend then return 0.0 end -- can't interpolate, return 0

	-- return interpolated value from the calculated graph points
	return (dVstart*(dLend-dLvl)+(dLvl-dLstart)*dVend)/(dLend-dLstart)
end

-- VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
-- TranslateValue: translates a value to an other by using a lookup table and a result table.
-- If the value is not found in the lookup table then the function returns the default value, which is the last element in the result table.
-- Object types allowed are both numbers (doubles, integers) and strings (non case sensitive matching) and may be mixed.

local function TranslateValue(vSourceData,vResultData,vSearch)
	if type(vSearch) == "number" then
		for iSrc, vSrc in ipairs(vSourceData) do
			if type(vSrc) == "number" and vSrc == vSearch then return vResultData[iSrc] end
		end
	elseif type(vSearch) == "string" then
		local sSearch = strupper(trim(vSearch))
		for iSrc, vSrc in ipairs(vSourceData) do
			if type(vSrc) == "string" and vSrc == sSearch then return vResultData[iSrc] end
		end
	end

	return vResultData[#vResultData] -- return default value
end

-- **************** Parameter "C" decode support functions ****************

-- ArmCodeIndex: returns a specified index from an Armour Code.
-- sACode string:
-- 1st position: H=heavy, M=medium, L=light
-- 2nd position: H=head, S=shoulders, CL=cloak/back, C=chest, G=gloves, L=leggings, B=boots, Sh=shield
-- 3rd position: W=white/common, Y=yellow/uncommon, P=purple/rare, T=teal/blue/incomparable, G=gold/legendary/epic
-- Note: no such thing exists as a heavy, medium or light cloak, so no H/M/L in cloak codes (cloaks go automatically in the M class since U23, although historically this was L)
local function ArmCodeIndex(sACode,iI)
	local sArmCode = trim(sACode)
	if sArmCode == "" then return 0 end
	sArmCode = strupper(sArmCode).."    "

	local sArmCat = strsub(sArmCode,1,1)
	local sArmType = strsub(sArmCode,2,2)
	local sArmCol = strsub(sArmCode,3,3)

	if sArmType == "S" and sArmCol == "H" then
		sArmType = "SH"
		sArmCol = strsub(sArmCode,4,4)
	elseif sArmCat == "C" and sArmType == "L" then
		sArmCat = "M"
		sArmType = "CL"
	elseif sArmType then
		sArmType = " "..sArmType
	end

	local result = 0
	if iI == 1 then
		if sArmCat then
			result = strfind("HML",sArmCat)
		end
	elseif iI == 2 then
		if sArmType then
			result = strfind(" H SCL C G L BSH",sArmType)
			if result then
				result = (result+1)/2
			end
		end
	elseif iI == 3 then
		if sArmCol then
			result = strfind("WYPTG",sArmCol)
		end
	end

	if result then return result else return 0 end
end

-- EnumIndex: returns an index in a Enum string for a character at a specified index in a Code string
-- returns 0 for unknown or missing character
local function EnumIndex(sCodeChars,iCodeIndex,sEnumChars)
	local sCode = trim(sCodeChars)
	if sCode == "" then return 0 end -- no code given
	sCode = strupper(sCode)

	local sChar = strsub(sCode,iCodeIndex,iCodeIndex)
	if sChar == "" then return 0 end -- no character found at specified index

	return strfind(sEnumChars,sChar) or 0 -- returns index of char in Enum string or 0 if not found
end

-- RomanRankDecode: converts a string with a Roman number in characters, to an integer number.
-- used for Legendary Item Title calculation.
local sRomanRankChars = {"M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"}
local iRomanRankValues = {1000,900,500,400,100,90,50,40,10,9,5,4,1}

local function RomanRankDecode(sRCode)
	local sRomanCode = strupper(trim(sRCode))
	if sRomanCode == "" then return 0 end

	local iValue = 0

	local iCharFound
	local iCharEnd
	
	local C = 1
	local iCodeLen = #sRomanCode
	while C <= iCodeLen do
		iCharFound = nil
		for I = 1, 13 do
			iCharEnd = C+(I-1)%2
			if iCharEnd <= iCodeLen and strsub(sRomanCode,C,iCharEnd) == sRomanRankChars[I] then
				iCharFound = I
				break
			end
		end
		if iCharFound == nil then break end -- found unknown character: terminate
		iValue = iValue+iRomanRankValues[iCharFound]
		C = iCharEnd+1
	end

	return iValue
end

-- ************************ Main CalcStat function ************************

CalcStat = function(SName,SLvl,SParam)
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

	if SN > "MINECHOESBATTLECRITDEF" then
		if SN < "TACMITMPRATPCAPR" then
			if SN > "PHYMITT" then
				if SN > "RUNEKEEPERCDARMOURTYPE" then
					if SN > "STDPROGHEALTH" then
						if SN < "TACMAS" then
							if SN < "STOUTSHADOWEYEVITALITY" then
								if SN < "STOUTAXERDTRAITDISEASERESISTP" then
									if SN < "STOUTAXERDPSVONENAME" then
										if SN == "STDPROGRATINGS" then
											if L <= 0 then
												Result = 0.0
											elseif L <= 50 then
												Result = LinFmod(N,1.0,10.0,1,50,L,1)
											elseif L <= 60 then
												Result = LinFmod(CalcStat("StdProgRatings",50,N),1.0,1.5,50,60,L,1)
											elseif L <= 65 then
												Result = LinFmod(CalcStat("StdProgRatings",60,N),1.0,1.333,60,65,L,1)
											elseif L <= 75 then
												Result = LinFmod(CalcStat("StdProgRatings",65,N),1.0,1.5,65,75,L,1)
											elseif L <= 85 then
												Result = LinFmod(CalcStat("StdProgRatings",75,N),1.0,1.5,75,85,L,1)
											elseif L <= 95 then
												Result = LinFmod(CalcStat("StdProgRatings",85,N),1.0,1.445,85,95,L,1)
											elseif L <= 100 then
												Result = LinFmod(CalcStat("StdProgRatings",95,N),1.0,1.39,95,100,L,1)
											elseif L <= 105 then
												Result = LinFmod(CalcStat("StdProgRatings",100,N),1.0,1.33,100,105,L,1)
											elseif L <= 115 then
												Result = LinFmod(CalcStat("StdProgRatings",105,N),1.1,1.5,106,115,L,1)
											elseif L <= 120 then
												Result = LinFmod(CalcStat("StdProgRatings",115,N),1.15,1.25,116,120,L,1)
											elseif L <= 130 then
												Result = LinFmod(CalcStat("StdProgRatings",120,N),1.15,1.5,121,130,L,1)
											elseif L <= 140 then
												Result = LinFmod(CalcStat("StdProgRatings",130,N),1.15,2.0,131,140,L,1)
											elseif L <= 150 then
												Result = LinFmod(CalcStat("StdProgRatings",140,N),1.3,2.205,141,150,L,1)
											elseif L <= 160 then
												Result = LinFmod(CalcStat("StdProgRatings",150,N),1.3,2.0,151,160,L,1)
											else
												Result = LinFmod(CalcStat("StdProgRatings",160,N),1.0,2.0,161,170,L,1)
											end
										elseif SN == "STDPROGRATINGSOLD" then
											if 151 <= L and L <= 160 then
												Result = LinFmod(CalcStat("StdProgRatings",150,N),1,2.0,151,160,L,1)
											else
												Result = CalcStat("StdProgRatings",L,N)
											end
										end
									elseif SN > "STOUTAXERDPSVONENAME" then
										if SN == "STOUTAXERDPSVONEVITALITY" then
											Result = CalcStat("StoutUnwritDestVitality",L)
										elseif SN == "STOUTAXERDPSVTWONAME" then
											Result = ""
										elseif SN == "STOUTAXERDTRAITAGILITY" then
											Result = CalcStat("StoutWrBlackLAgility",L)
										end
									else
										Result = "Unwritten Destiny"
									end
								elseif SN > "STOUTAXERDTRAITDISEASERESISTP" then
									if SN > "STOUTAXERDTRAITSHADOWMITP" then
										if SN == "STOUTAXERDTRAITVITALITY" then
											Result = CalcStat("StoutShadowEyeVitality",L)
										elseif SN == "STOUTAXERDTRAITWILL" then
											Result = CalcStat("StoutUnyieldingWill",L)
										elseif SN == "STOUTDOOMDRASAFATE" then
											Result = -CalcStat("FateT",L,0.4)
										end
									elseif SN < "STOUTAXERDTRAITSHADOWMITP" then
										if SN == "STOUTAXERDTRAITFATE" then
											Result = CalcStat("StoutDoomDrasaFate",L)
										elseif SN == "STOUTAXERDTRAITMIGHT" then
											Result = CalcStat("StoutWrBlackLMight",L)
										elseif SN == "STOUTAXERDTRAITPHYMITP" then
											Result = CalcStat("StoutUnyieldingPhyMitP",L)
										end
									else
										Result = CalcStat("StoutWrBlackLShadowMitP",L)
									end
								else
									Result = CalcStat("StoutWrBlackLDiseaseResistP",L)
								end
							elseif SN > "STOUTSHADOWEYEVITALITY" then
								if SN < "TACDMGPBONUS" then
									if SN > "STOUTWRBLACKLAGILITY" then
										if SN == "STOUTWRBLACKLDISEASERESISTP" then
											Result = 1.0
										elseif SN == "STOUTWRBLACKLMIGHT" then
											Result = CalcStat("MightT",L,1.0)
										elseif SN == "STOUTWRBLACKLSHADOWMITP" then
											Result = 1.0
										end
									elseif SN < "STOUTWRBLACKLAGILITY" then
										if SN == "STOUTUNWRITDESTVITALITY" then
											Result = CalcStat("VitalityT",L,1.0)
										elseif SN == "STOUTUNYIELDINGPHYMITP" then
											Result = 1.0
										elseif SN == "STOUTUNYIELDINGWILL" then
											Result = CalcStat("WillT",L,1.0)
										end
									else
										Result = CalcStat("AgilityT",L,1.0)
									end
								elseif SN > "TACDMGPBONUS" then
									if SN > "TACDMGPRATPB" then
										if SN == "TACDMGPRATPC" then
											Result = CalcStat("OutDmgPRatPC",L)
										elseif SN == "TACDMGPRATPCAP" then
											Result = CalcStat("OutDmgPRatPCap",L)
										elseif SN == "TACDMGPRATPCAPR" then
											Result = CalcStat("OutDmgPRatPCapR",L)
										end
									elseif SN < "TACDMGPRATPB" then
										if SN == "TACDMGPPRAT" then
											Result = CalcStat("OutDmgPPRat",L,N)
										elseif SN == "TACDMGPRATP" then
											Result = CalcStat("OutDmgPRatP",L,N)
										elseif SN == "TACDMGPRATPA" then
											Result = CalcStat("OutDmgPRatPA",L)
										end
									else
										Result = CalcStat("OutDmgPRatPB",L)
									end
								else
									Result = CalcStat("OutDmgPBonus",L)
								end
							else
								Result = -CalcStat("VitalityT",L,0.4)
							end
						elseif SN > "TACMAS" then
							if SN > "TACMITHPRATPCAPR" then
								if SN < "TACMITLPRATPCAPR" then
									if SN > "TACMITLPRATPA" then
										if SN == "TACMITLPRATPB" then
											Result = CalcStat("MitLightPRatPB",L)
										elseif SN == "TACMITLPRATPC" then
											Result = CalcStat("MitLightPRatPC",L)
										elseif SN == "TACMITLPRATPCAP" then
											Result = CalcStat("MitLightPRatPCap",L)
										end
									elseif SN < "TACMITLPRATPA" then
										if SN == "TACMITLPBONUS" then
											Result = CalcStat("MitLightPBonus",L)
										elseif SN == "TACMITLPPRAT" then
											Result = CalcStat("MitLightPPRat",L,N)
										elseif SN == "TACMITLPRATP" then
											Result = CalcStat("MitLightPRatP",L,N)
										end
									else
										Result = CalcStat("MitLightPRatPA",L)
									end
								elseif SN > "TACMITLPRATPCAPR" then
									if SN > "TACMITMPRATPA" then
										if SN == "TACMITMPRATPB" then
											Result = CalcStat("MitMediumPRatPB",L)
										elseif SN == "TACMITMPRATPC" then
											Result = CalcStat("MitMediumPRatPC",L)
										elseif SN == "TACMITMPRATPCAP" then
											Result = CalcStat("MitMediumPRatPCap",L)
										end
									elseif SN < "TACMITMPRATPA" then
										if SN == "TACMITMPBONUS" then
											Result = CalcStat("MitMediumPBonus",L)
										elseif SN == "TACMITMPPRAT" then
											Result = CalcStat("MitMediumPPRat",L,N)
										elseif SN == "TACMITMPRATP" then
											Result = CalcStat("MitMediumPRatP",L,N)
										end
									else
										Result = CalcStat("MitMediumPRatPA",L)
									end
								else
									Result = CalcStat("MitLightPRatPCapR",L)
								end
							elseif SN < "TACMITHPRATPCAPR" then
								if SN < "TACMITCILVLFILTER" then
									if SN > "TACMAST" then
										if SN == "TACMIT" then
											Result = EquSng(StatLinInter("PntMPTacMit","ItemPntS","MitMediumPRatPB","AdjItemMit",L,N,2))
										elseif SN == "TACMITC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("TacMitCI",CalcStat("TacMitCILvlFilter",L,N),N),2)
										elseif SN == "TACMITCI" then
											Result = RoundDblLotro(StatLinInter("PntMPTacMitC","ItemPntS","MitMediumPRatPB","AdjCreepMit",L,N))
										end
									elseif SN < "TACMAST" then
										if SN == "TACMASC" then
											Result = CalcStat("MasteryC",L,N)
										elseif SN == "TACMASCI" then
											Result = CalcStat("MasteryCI",L,N)
										elseif SN == "TACMASOLD" then
											Result = CalcStat("Mastery",L,N)
										end
									else
										Result = CalcStat("MasteryT",L,N)
									end
								elseif SN > "TACMITCILVLFILTER" then
									if SN > "TACMITHPRATPA" then
										if SN == "TACMITHPRATPB" then
											Result = CalcStat("MitHeavyPRatPB",L)
										elseif SN == "TACMITHPRATPC" then
											Result = CalcStat("MitHeavyPRatPC",L)
										elseif SN == "TACMITHPRATPCAP" then
											Result = CalcStat("MitHeavyPRatPCap",L)
										end
									elseif SN < "TACMITHPRATPA" then
										if SN == "TACMITHPBONUS" then
											Result = CalcStat("MitHeavyPBonus",L)
										elseif SN == "TACMITHPPRAT" then
											Result = CalcStat("MitHeavyPPRat",L,N)
										elseif SN == "TACMITHPRATP" then
											Result = CalcStat("MitHeavyPRatP",L,N)
										end
									else
										Result = CalcStat("MitHeavyPRatPA",L)
									end
								else
									Result = TranslateValue({2.8,3.8,5.6,6.9,12.9},{565,565,565,565,565,570},N)
								end
							else
								Result = CalcStat("MitHeavyPRatPCapR",L)
							end
						else
							Result = CalcStat("Mastery",L,N)
						end
					elseif SN < "STDPROGHEALTH" then
						if SN < "RUNEKEEPERCDWILLTOPHYMIT" then
							if SN > "RUNEKEEPERCDFATETOICPR" then
								if SN < "RUNEKEEPERCDPHYMITTOCOMPHYMIT" then
									if SN > "RUNEKEEPERCDMIGHTTOCRITHIT" then
										if SN == "RUNEKEEPERCDMIGHTTOOUTHEAL" then
											Result = 2.0
										elseif SN == "RUNEKEEPERCDMIGHTTOTACMAS" then
											Result = 2.0
										elseif SN == "RUNEKEEPERCDMIGHTTOTACMIT" then
											Result = 1.0
										end
									elseif SN < "RUNEKEEPERCDMIGHTTOCRITHIT" then
										if SN == "RUNEKEEPERCDFATETONCPR" then
											Result = 0.15
										elseif SN == "RUNEKEEPERCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "RUNEKEEPERCDHASPOWER" then
											Result = 1
										end
									else
										Result = 1.0
									end
								elseif SN > "RUNEKEEPERCDPHYMITTOCOMPHYMIT" then
									if SN > "RUNEKEEPERCDVITALITYTOMORALE" then
										if SN == "RUNEKEEPERCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "RUNEKEEPERCDWILLTOCRITHIT" then
											Result = 1.0
										elseif SN == "RUNEKEEPERCDWILLTOEVADE" then
											Result = 2.0
										end
									elseif SN < "RUNEKEEPERCDVITALITYTOMORALE" then
										if SN == "RUNEKEEPERCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "RUNEKEEPERCDTACMASTOOUTHEAL" then
											Result = 1.0
										elseif SN == "RUNEKEEPERCDVITALITYTOICMR" then
											Result = 0.012
										end
									else
										Result = 4.5
									end
								else
									Result = 1.0
								end
							elseif SN < "RUNEKEEPERCDFATETOICPR" then
								if SN < "RUNEKEEPERCDBASENCMR" then
									if SN > "RUNEKEEPERCDBASEICMR" then
										if SN == "RUNEKEEPERCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "RUNEKEEPERCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										elseif SN == "RUNEKEEPERCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										end
									elseif SN < "RUNEKEEPERCDBASEICMR" then
										if SN == "RUNEKEEPERCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityL",L)
										elseif SN == "RUNEKEEPERCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										end
									else
										Result = CalcStat("ClassBaseICMRL",L)
									end
								elseif SN > "RUNEKEEPERCDBASENCMR" then
									if SN > "RUNEKEEPERCDBASEWILL" then
										if SN == "RUNEKEEPERCDCALCTYPECOMPHYMIT" then
											Result = 12
										elseif SN == "RUNEKEEPERCDCALCTYPENONPHYMIT" then
											Result = 12
										elseif SN == "RUNEKEEPERCDCALCTYPETACMIT" then
											Result = 25
										end
									elseif SN < "RUNEKEEPERCDBASEWILL" then
										if SN == "RUNEKEEPERCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "RUNEKEEPERCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										elseif SN == "RUNEKEEPERCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										end
									else
										Result = CalcStat("ClassBaseWillH",L)
									end
								else
									Result = CalcStat("ClassBaseNCMRL",L)
								end
							else
								Result = 0.015
							end
						elseif SN > "RUNEKEEPERCDWILLTOPHYMIT" then
							if SN > "SORCERESSCDHASPOWER" then
								if SN < "STDMORALEH" then
									if SN > "STALKERCDCALCTYPENONPHYMIT" then
										if SN == "STALKERCDCALCTYPETACMIT" then
											Result = 27
										elseif SN == "STALKERCDHASPOWER" then
											Result = 1
										elseif SN == "STATC" then
											Result = CalcStat(C,L)
										end
									elseif SN < "STALKERCDCALCTYPENONPHYMIT" then
										if SN == "SPEARPIERCEDMG" then
											Result = CalcStat("CombatDamageModDamageItem",L,-0.65)
										elseif SN == "STALKERCANBLOCK" then
											Result = 1
										elseif SN == "STALKERCDCALCTYPECOMPHYMIT" then
											Result = 13
										end
									else
										Result = 14
									end
								elseif SN > "STDMORALEH" then
									if SN > "STDPOWERH" then
										if SN == "STDPOWERL" then
											Result = EquSng(DecSng(CalcStat("DirectEnergy",L,23583.0/1200.0)))
										elseif SN == "STDPROGDAMAGE" then
											if L <= 0 then
												Result = 0.0
											elseif L <= 50 then
												Result = LinFmod(N,1.0,10.0,1,50,L,1)
											elseif L <= 60 then
												Result = LinFmod(CalcStat("StdProgDamage",50,N),1.0,1.33,50,60,L,1)
											elseif L <= 65 then
												Result = LinFmod(CalcStat("StdProgDamage",60,N),1.0,1.095,60,65,L,1)
											elseif L <= 75 then
												Result = LinFmod(CalcStat("StdProgDamage",65,N),1.0,1.33,65,75,L,1)
											elseif L <= 85 then
												Result = LinFmod(CalcStat("StdProgDamage",75,N),1.0,1.33,75,85,L,1)
											elseif L <= 95 then
												Result = LinFmod(CalcStat("StdProgDamage",85,N),1.0,1.33,85,95,L,1)
											elseif L <= 100 then
												Result = LinFmod(CalcStat("StdProgDamage",95,N),1.0,1.25,95,100,L,1)
											elseif L <= 105 then
												Result = LinFmod(CalcStat("StdProgDamage",100,N),1.0,1.25,100,105,L,1)
											elseif L <= 115 then
												Result = LinFmod(CalcStat("StdProgDamage",105,N),1.1,1.33,106,115,L,1)
											elseif L <= 120 then
												Result = LinFmod(CalcStat("StdProgDamage",115,N),1.1,1.25,116,120,L,1)
											elseif L <= 130 then
												Result = LinFmod(CalcStat("StdProgDamage",120,N),1.1,1.33,121,130,L,1)
											elseif L <= 140 then
												Result = LinFmod(CalcStat("StdProgDamage",130,N),1.1,1.5,131,140,L,1)
											elseif L <= 150 then
												Result = LinFmod(CalcStat("StdProgDamage",140,N),1.1,1.5,141,150,L,1)
											elseif L <= 160 then
												Result = LinFmod(CalcStat("StdProgDamage",150,N),1.1,1.5,151,160,L,1)
											else
												Result = LinFmod(CalcStat("StdProgDamage",160,N),1.1,1.5,161,170,L,1)
											end
										elseif SN == "STDPROGENERGY" then
											if L <= 0 then
												Result = 0.0
											elseif L <= 50 then
												Result = LinFmod(N,1.0,2.0,1,50,L,1)
											elseif L <= 60 then
												Result = LinFmod(CalcStat("StdProgEnergy",50,N),1.0,1.33,50,60,L,1)
											elseif L <= 65 then
												Result = LinFmod(CalcStat("StdProgEnergy",60,N),1.0,1.25,60,65,L,1)
											elseif L <= 75 then
												Result = LinFmod(CalcStat("StdProgEnergy",65,N),1.0,1.5,65,75,L,1)
											elseif L <= 85 then
												Result = LinFmod(CalcStat("StdProgEnergy",75,N),1.0,1.5,75,85,L,1)
											elseif L <= 95 then
												Result = LinFmod(CalcStat("StdProgEnergy",85,N),1.0,1.33,85,95,L,1)
											elseif L <= 100 then
												Result = LinFmod(CalcStat("StdProgEnergy",95,N),1.0,1.315,95,100,L,1)
											elseif L <= 105 then
												Result = LinFmod(CalcStat("StdProgEnergy",100,N),1.0,1.333,100,105,L,1)
											elseif L <= 115 then
												Result = LinFmod(CalcStat("StdProgEnergy",105,N),1.1,1.5,106,115,L,1)
											elseif L <= 120 then
												Result = LinFmod(CalcStat("StdProgEnergy",115,N),1.15,1.25,116,120,L,1)
											elseif L <= 130 then
												Result = LinFmod(CalcStat("StdProgEnergy",120,N),1.15,1.5,121,130,L,1)
											elseif L <= 140 then
												Result = LinFmod(CalcStat("StdProgEnergy",130,N),1.15,2.0,131,140,L,1)
											elseif L <= 150 then
												Result = LinFmod(CalcStat("StdProgEnergy",140,N),1.15,2.0,141,150,L,1)
											elseif L <= 160 then
												Result = LinFmod(CalcStat("StdProgEnergy",150,N),1.15,2.0,151,160,L,1)
											else
												Result = LinFmod(CalcStat("StdProgEnergy",160,N),1.15,2.0,161,170,L,1)
											end
										end
									elseif SN < "STDPOWERH" then
										if SN == "STDMORALEL" then
											Result = RoundDblUp(CalcStat("DirectHealth",L,8726.1/1200.0),0)
										elseif SN == "STDMORALEM" then
											Result = RoundDblUp(CalcStat("DirectHealth",L,13093.057/1200.0),0)
										elseif SN == "STDPNTS" then
											Result = {{1,50,60,65,75,85,95,100,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170},{1,50,60,65,75,85,95,100,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170}}
										end
									else
										Result = EquSng(DecSng(CalcStat("DirectEnergy",L,47055.0/1200.0)))
									end
								else
									Result = RoundDblUp(CalcStat("DirectHealth",L,17446.233/1200.0),0)
								end
							elseif SN < "SORCERESSCDHASPOWER" then
								if SN < "SKILLPOWERCOST" then
									if SN > "SHADOWMIT" then
										if SN == "SHADOWMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										elseif SN == "SHIELDBLOCK" then
											Result = CalcStat("BPE",L,N*(80.0/42.0))
										elseif SN == "SHIELDBRAWLERBLOCK" then
											Result = CalcStat("DwarfShieldBrwlBlock",L)
										end
									elseif SN < "SHADOWMIT" then
										if SN == "RUNEKEEPERCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "RUNEKEEPERCDWILLTOTACMAS" then
											Result = 3.0
										elseif SN == "RUNEKEEPERCDWILLTOTACMIT" then
											Result = 1.0
										end
									else
										Result = CalcStat("DmgTypeMit",L,N)
									end
								elseif SN > "SKILLPOWERCOST" then
									if SN > "SORCERESSCANBLOCK" then
										if SN == "SORCERESSCDCALCTYPECOMPHYMIT" then
											Result = 13
										elseif SN == "SORCERESSCDCALCTYPENONPHYMIT" then
											Result = 14
										elseif SN == "SORCERESSCDCALCTYPETACMIT" then
											Result = 27
										end
									elseif SN < "SORCERESSCANBLOCK" then
										if SN == "SKILLPOWERCOSTMOUNTED" then
											Result = CalcStat("CombatDamageModEnergy",L,0.32*N)
										elseif SN == "SONGRESIST" then
											Result = CalcStat("ResistAdd",L,N)
										elseif SN == "SONGRESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										end
									else
										Result = 1
									end
								else
									if 141 <= L then
										Result = CalcStat("CombatDamageModEnergy",L,1.05*0.32*N)
									else
										Result = CalcStat("CombatDamageModEnergy",L,0.32*N)
									end
								end
							else
								Result = 1
							end
						else
							Result = 1.0
						end
					else
						if L <= 0 then
							Result = 0.0
						elseif L <= 50 then
							Result = LinFmod(N,1.0,7.5,1,50,L,1)
						elseif L <= 60 then
							Result = LinFmod(CalcStat("StdProgHealth",50,N),1.0,1.33,50,60,L,1)
						elseif L <= 65 then
							Result = LinFmod(CalcStat("StdProgHealth",60,N),1.0,1.25,60,65,L,1)
						elseif L <= 75 then
							Result = LinFmod(CalcStat("StdProgHealth",65,N),1.0,1.5,65,75,L,1)
						elseif L <= 85 then
							Result = LinFmod(CalcStat("StdProgHealth",75,N),1.0,1.5,75,85,L,1)
						elseif L <= 95 then
							Result = LinFmod(CalcStat("StdProgHealth",85,N),1.0,1.33,85,95,L,1)
						elseif L <= 100 then
							Result = LinFmod(CalcStat("StdProgHealth",95,N),1.0,1.5,95,100,L,1)
						elseif L <= 105 then
							Result = LinFmod(CalcStat("StdProgHealth",100,N),1.0,1.333,100,105,L,1)
						elseif L <= 115 then
							Result = LinFmod(CalcStat("StdProgHealth",105,N),1.1,1.5,106,115,L,1)
						elseif L <= 120 then
							Result = LinFmod(CalcStat("StdProgHealth",115,N),1.15,1.25,116,120,L,1)
						elseif L <= 130 then
							Result = LinFmod(CalcStat("StdProgHealth",120,N),1.15,1.5,121,130,L,1)
						elseif L <= 140 then
							Result = LinFmod(CalcStat("StdProgHealth",130,N),1.15,2.0,131,140,L,1)
						elseif L <= 150 then
							Result = LinFmod(CalcStat("StdProgHealth",140,N),1.15,2.0,141,150,L,1)
						elseif L <= 160 then
							Result = LinFmod(CalcStat("StdProgHealth",150,N),1.15,2.0,151,160,L,1)
						else
							Result = LinFmod(CalcStat("StdProgHealth",160,N),1.15,2.0,161,170,L,1)
						end
					end
				elseif SN < "RUNEKEEPERCDARMOURTYPE" then
					if SN > "PROGBENERGY" then
						if SN < "RESISTC" then
							if SN > "REPFATEL" then
								if SN < "REPTACMIT" then
									if SN > "REPMIGHTH" then
										if SN == "REPMIGHTL" then
											Result = CalcStat("RepMainL",L)
										elseif SN == "REPMORALE" then
											Result = LinInter({{1,50,85,105,120},{187.0,427.0,599.0,697.0,770.0}},L)
										elseif SN == "REPPOWER" then
											Result = LinInter({{1,50,85,105,120},{94.0,212.0,296.0,344.0,380.0}},L)
										end
									elseif SN < "REPMIGHTH" then
										if SN == "REPFINESSE" then
											Result = LinInter({{1,50,85,105,120},{322.0,557.0,749.9477,859.1634,939.2549}},L)
										elseif SN == "REPMAINH" then
											Result = RoundDblDown(LinInter({{1,50,85,105,120},{80.0,153.0,206.0,236.0,258.0}},L),0)
										elseif SN == "REPMAINL" then
											Result = RoundDblDown(LinInter({{1,50,85,105,120},{53.0,102.0,137.0,157.0,172.0}},L),0)
										end
									else
										Result = CalcStat("RepMainH",L)
									end
								elseif SN > "REPTACMIT" then
									if SN > "REPWILLL" then
										if SN == "RESIST" then
											Result = EquSng(StatLinInter("PntMPResist","ItemPntS","ResistPRatPB","AdjItemRat",L,N,2))
										elseif SN == "RESISTADD" then
											Result = CalcStat("Resist",L,N)
										elseif SN == "RESISTADDT" then
											Result = CalcStat("ResistT",L,N)
										end
									elseif SN < "REPWILLL" then
										if SN == "REPVITALITYH" then
											Result = CalcStat("RepMainH",L)
										elseif SN == "REPVITALITYL" then
											Result = CalcStat("RepMainL",L)
										elseif SN == "REPWILLH" then
											Result = CalcStat("RepMainH",L)
										end
									else
										Result = CalcStat("RepMainL",L)
									end
								else
									Result = LinInter({{1,50,85,105,120},{675.0,1116.0,1431.0,1611.0,1746.0}},L)
								end
							elseif SN < "REPFATEL" then
								if SN < "REAVERCDCALCTYPENONPHYMIT" then
									if SN > "PROGBMAINOLD" then
										if SN == "RACENAME" then
											Result = TranslateValue({6,7,12,23,27,39,65,66,73,81,114,117,120,125},{"Uruk","Orc","Spider","Man","Critter","Angmarim","Elf","Warg","Dwarf","Hobbit","Beorning","HighElf","StoutAxe","RiverHobbit",""},L)
										elseif SN == "REAVERCANBLOCK" then
											Result = 1
										elseif SN == "REAVERCDCALCTYPECOMPHYMIT" then
											Result = 13
										end
									elseif SN < "PROGBMAINOLD" then
										if SN == "PROGBHEALTH" then
											Result = CalcStat("StdProgHealth",L,4.0)
										elseif SN == "PROGBMAIN" then
											Result = CalcStat("StdProgRatings",L,1.75)
										end
									else
										Result = CalcStat("StdProgRatingsOld",L,1.75)
									end
								elseif SN > "REAVERCDCALCTYPENONPHYMIT" then
									if SN > "REPAGILITYL" then
										if SN == "REPCRITDEF" then
											Result = LinInter({{1,50,85,105,120},{900.0,1488.0,1908.0,2148.0,2328.0}},L)
										elseif SN == "REPCRITHIT" then
											Result = LinInter({{1,50,85,105,120},{300.0,496.0,636.0,716.0,776.0}},L)
										elseif SN == "REPFATEH" then
											Result = CalcStat("RepMainH",L)
										end
									elseif SN < "REPAGILITYL" then
										if SN == "REAVERCDCALCTYPETACMIT" then
											Result = 27
										elseif SN == "REAVERCDHASPOWER" then
											Result = 1
										elseif SN == "REPAGILITYH" then
											Result = CalcStat("RepMainH",L)
										end
									else
										Result = CalcStat("RepMainL",L)
									end
								else
									Result = 14
								end
							else
								Result = CalcStat("RepMainL",L)
							end
						elseif SN > "RESISTC" then
							if SN > "RIVERHOBBITRDTRAITMORALE" then
								if SN < "RKFORTUNESMILESFATE" then
									if SN > "RIVHOBSEENWORLDWILL" then
										if SN == "RIVHOBSLIPPERYAGILITY" then
											Result = CalcStat("AgilityT",L,1.0)
										elseif SN == "RIVHOBSWIMMERFROSTMITP" then
											Result = 1.0
										elseif SN == "RKDETERMINATIONWILL" then
											Result = CalcStat("WillT",L,CalcStat("Trait567810Choice",N)*0.4)
										end
									elseif SN < "RIVHOBSEENWORLDWILL" then
										if SN == "RIVERHOBBITRDTRAITWILL" then
											Result = CalcStat("RivHobSeclusionWill",L)
										elseif SN == "RIVHOBHARDYHOLBMORALE" then
											Result = CalcStat("MoraleT",L,1.0)
										elseif SN == "RIVHOBSECLUSIONWILL" then
											Result = -CalcStat("WillT",L,0.4)
										end
									else
										Result = CalcStat("WillT",L,1.0)
									end
								elseif SN > "RKFORTUNESMILESFATE" then
									if SN > "RUNEKEEPERCDAGILITYTOTACMAS" then
										if SN == "RUNEKEEPERCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "RUNEKEEPERCDARMOURTONONPHYMIT" then
											Result = 0.2
										elseif SN == "RUNEKEEPERCDARMOURTOTACMIT" then
											Result = 0.2
										end
									elseif SN < "RUNEKEEPERCDAGILITYTOTACMAS" then
										if SN == "RUNEKEEPERCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "RUNEKEEPERCDAGILITYTOEVADE" then
											Result = 1.0
										elseif SN == "RUNEKEEPERCDAGILITYTOFINESSE" then
											Result = 1.0
										end
									else
										Result = 2.0
									end
								else
									Result = CalcStat("FateT",L,CalcStat("Trait12345Choice",N)*0.4)
								end
							elseif SN < "RIVERHOBBITRDTRAITMORALE" then
								if SN < "RESISTPRATPCAP" then
									if SN > "RESISTPRATP" then
										if SN == "RESISTPRATPA" then
											Result = 150.0
										elseif SN == "RESISTPRATPB" then
											Result = CalcStat("BRatExtra",L)
										elseif SN == "RESISTPRATPC" then
											Result = 0.5
										end
									elseif SN < "RESISTPRATP" then
										if SN == "RESISTCI" then
											Result = RoundDblLotro(StatLinInter("PntMPResistC","ItemPntS","ResistPRatPB","AdjCreepExtra",L,N))
										elseif SN == "RESISTCILVLFILTER" then
											Result = TranslateValue({1.6,2.0,2.0,3.2,4.0,8.0},{565,565,565,565,565,565,570},N)
										elseif SN == "RESISTPPRAT" then
											Result = CalcRatAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCapR",L),N)
										end
									else
										Result = CalcPercAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCap",L),N)
									end
								elseif SN > "RESISTPRATPCAP" then
									if SN > "RIVERHOBBITRDPSVONEWILL" then
										if SN == "RIVERHOBBITRDPSVTWONAME" then
											Result = ""
										elseif SN == "RIVERHOBBITRDTRAITAGILITY" then
											Result = CalcStat("RivHobSlipperyAgility",L)
										elseif SN == "RIVERHOBBITRDTRAITFROSTMITP" then
											Result = CalcStat("RivHobSwimmerFrostMitP",L)
										end
									elseif SN < "RIVERHOBBITRDPSVONEWILL" then
										if SN == "RESISTPRATPCAPR" then
											Result = CalcStat("ResistPRatPB",L)*CalcStat("ResistPRatPC",L)
										elseif SN == "RESISTT" then
											Result = EquSng(StatLinInter("PntMPResist","TraitPntS","ResistPRatPB","AdjTraitRat",L,N,2))
										elseif SN == "RIVERHOBBITRDPSVONENAME" then
											Result = "Seen the World"
										end
									else
										Result = CalcStat("RivHobSeenWorldWill",L)
									end
								else
									Result = 50.0
								end
							else
								Result = CalcStat("RivHobHardyHolbMorale",L)
							end
						else
							Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ResistCI",CalcStat("ResistCILvlFilter",L,N),N),2)
						end
					elseif SN < "PROGBENERGY" then
						if SN < "PNTMPINHEAL" then
							if SN > "PNTMPCRITDEF" then
								if SN < "PNTMPFINESSE" then
									if SN > "PNTMPDMGTYPEMIT" then
										if SN == "PNTMPDMGTYPEMITT" then
											Result = 0.05
										elseif SN == "PNTMPFATE" then
											Result = 2.5
										elseif SN == "PNTMPFELLWMIT" then
											Result = 0.016
										end
									elseif SN < "PNTMPDMGTYPEMIT" then
										if SN == "PNTMPCRITDEFC" then
											Result = 0.0165165
										elseif SN == "PNTMPCRITHIT" then
											Result = 20.0/1200.0
										elseif SN == "PNTMPCRITHITC" then
											Result = 0.01651
										end
									else
										Result = 0.02
									end
								elseif SN > "PNTMPFINESSE" then
									if SN > "PNTMPICMRC" then
										if SN == "PNTMPICMRDEBUFFT" then
											Result = 0.076
										elseif SN == "PNTMPICPR" then
											Result = 0.125
										elseif SN == "PNTMPICPRC" then
											Result = 0.019
										end
									elseif SN < "PNTMPICMRC" then
										if SN == "PNTMPFINESSEC" then
											Result = 0.0165165
										elseif SN == "PNTMPFINESSET" then
											Result = 0.03
										elseif SN == "PNTMPICMR" then
											Result = 0.03
										end
									else
										Result = 0.0194
									end
								else
									Result = 40.0/1200.0
								end
							elseif SN < "PNTMPCRITDEF" then
								if SN < "PNTMPARMOURC" then
									if SN > "PLAYERBASEEVADE" then
										if SN == "PLAYERBASEPARRY" then
											Result = 3.0
										elseif SN == "PLAYERBASEPHYMAS" then
											Result = 1.0
										elseif SN == "PLAYERBASETACMAS" then
											Result = 1.0
										end
									elseif SN < "PLAYERBASEEVADE" then
										if SN == "PHYRESIST" then
											Result = CalcStat("ResistAdd",L,N)
										elseif SN == "PHYRESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										end
									else
										Result = 1.0
									end
								elseif SN > "PNTMPARMOURC" then
									if SN > "PNTMPBPE" then
										if SN == "PNTMPBPEC" then
											Result = 0.0165165
										elseif SN == "PNTMPCLASSBASEICPR" then
											Result = 0.15
										elseif SN == "PNTMPCLASSBASENCPR" then
											Result = 0.5
										end
									elseif SN < "PNTMPBPE" then
										if SN == "PNTMPARMOURPENT" then
											Result = 0.06
										elseif SN == "PNTMPARMOURT" then
											Result = 25.0/1200.0
										elseif SN == "PNTMPARMOURVIRTUES" then
											Result = 0.02
										end
									else
										Result = 0.035
									end
								else
									Result = 0.0165165
								end
							else
								Result = 40.0/1200.0
							end
						elseif SN > "PNTMPINHEAL" then
							if SN > "PNTMPPOWER" then
								if SN < "PNTMPVITALITYT" then
									if SN > "PNTMPTACMIT" then
										if SN == "PNTMPTACMITC" then
											Result = 0.0165165
										elseif SN == "PNTMPVITALITY" then
											Result = 0.35
										elseif SN == "PNTMPVITALITYC" then
											Result = 0.329
										end
									elseif SN < "PNTMPTACMIT" then
										if SN == "PNTMPPOWERT" then
											Result = 1.333
										elseif SN == "PNTMPRESIST" then
											Result = 0.03
										elseif SN == "PNTMPRESISTC" then
											Result = 0.01651
										end
									else
										Result = 0.03
									end
								elseif SN > "PNTMPVITALITYT" then
									if SN > "POWERT" then
										if SN == "PROGBDAMAGE" then
											Result = CalcStat("StdProgDamage",L,2.0)
										elseif SN == "PROGBDAMAGENOIMP" then
											Result = StatLinInter("","TraitPntSVital","ProgBDamage","ProgBDamageNoImpAdj",L,N)
										elseif SN == "PROGBDAMAGENOIMPADJ" then
											if L <= 50 then
												Result = LinFmod(1.0,1.25,3.0,1,50,L)
											elseif L <= 100 then
												Result = LinFmod(1.0,3.0,4.5,50,100,L)
											else
												Result = 4.5+(L-100)*0.0125
											end
										end
									elseif SN < "POWERT" then
										if SN == "POISONRESIST" then
											Result = CalcStat("ResistAdd",L,N)
										elseif SN == "POISONRESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										elseif SN == "POWER" then
											Result = EquSng(StatLinInter("PntMPPower","ItemPntSVital","ProgBEnergy","",L,N,2))
										end
									else
										Result = EquSng(StatLinInter("PntMPPowerT","TraitPntSVital","ProgBEnergy","",L,N,2))
									end
								else
									Result = 0.45
								end
							elseif SN < "PNTMPPOWER" then
								if SN < "PNTMPNCMR" then
									if SN > "PNTMPMASTERYC" then
										if SN == "PNTMPMITIGATION" then
											Result = 28.0/1200.0
										elseif SN == "PNTMPMORALE" then
											Result = 2.0
										elseif SN == "PNTMPMORALEVIRTUES" then
											Result = 1.5
										end
									elseif SN < "PNTMPMASTERYC" then
										if SN == "PNTMPMAIN" then
											Result = 0.5
										elseif SN == "PNTMPMAINC" then
											Result = 0.1651
										elseif SN == "PNTMPMASTERY" then
											Result = 17.0/1200.0
										end
									else
										Result = 0.01651
									end
								elseif SN > "PNTMPNCMR" then
									if SN > "PNTMPORCCMIT" then
										if SN == "PNTMPOUTHEAL" then
											Result = 0.025
										elseif SN == "PNTMPPHYMIT" then
											Result = 0.03
										elseif SN == "PNTMPPHYMITC" then
											Result = 0.0165165
										end
									elseif SN < "PNTMPORCCMIT" then
										if SN == "PNTMPNCMRC" then
											Result = 0.194
										elseif SN == "PNTMPNCPR" then
											Result = 1.0
										elseif SN == "PNTMPNCPRC" then
											Result = 0.19
										end
									else
										Result = 0.016
									end
								else
									Result = 0.3
								end
							else
								Result = 2.0
							end
						else
							Result = 40.0/1200.0
						end
					else
						Result = CalcStat("StdProgEnergy",L,2.0)
					end
				else
					Result = 1
				end
			elseif SN < "PHYMITT" then
				if SN < "PARRYPRATPCAPR" then
					if SN > "MITHEAVYPRATPB" then
						if SN < "NCPRCI" then
							if SN > "MITMEDIUMPRATPB" then
								if SN < "N" then
									if SN > "MNTENDURANCE" then
										if SN == "MNTENDURANCET" then
											Result = CalcStat("MoraleT",L,N)
										elseif SN == "MORALE" then
											Result = EquSng(StatLinInter("PntMPMorale","ItemPntSVital","ProgBHealth","AdjItemHealth",L,N,2))
										elseif SN == "MORALET" then
											Result = EquSng(StatLinInter("PntMPMorale","TraitPntSVital","ProgBHealth","AdjTraitHealth",L,N,2))
										end
									elseif SN < "MNTENDURANCE" then
										if SN == "MITMEDIUMPRATPC" then
											Result = 0.5
										elseif SN == "MITMEDIUMPRATPCAP" then
											Result = 50.0
										elseif SN == "MITMEDIUMPRATPCAPR" then
											Result = CalcStat("MitMediumPRatPB",L)*CalcStat("MitMediumPRatPC",L)
										end
									else
										Result = CalcStat("Morale",L,N)
									end
								elseif SN > "N" then
									if SN > "NCMRCILVLFILTER" then
										if SN == "NCMRT" then
											Result = EquSng(StatLinInter("PntMPNCMR","TraitPntSVital","ProgBHealth","",L,N,3))
										elseif SN == "NCPR" then
											Result = EquSng(StatLinInter("PntMPNCPR","ItemPntSVital","ProgBEnergy","",L,N))
										elseif SN == "NCPRC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("NCPRCI",CalcStat("NCPRCILvlFilter",L,N),N),2)
										end
									elseif SN < "NCMRCILVLFILTER" then
										if SN == "NCMR" then
											Result = EquSng(StatLinInter("PntMPNCMR","ItemPntSVital","ProgBHealth","",L,N,3))
										elseif SN == "NCMRC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("NCMRCI",CalcStat("NCMRCILvlFilter",L,N),N),2)
										elseif SN == "NCMRCI" then
											Result = RoundDblProg(StatLinInter("PntMPNCMRC","ItemPntSVital","ProgBHealth","AdjCreepHealth",L,N))
										end
									else
										Result = TranslateValue({0},{570},N)
									end
								else
									Result = N
								end
							elseif SN < "MITMEDIUMPRATPB" then
								if SN < "MITLIGHTPRATPA" then
									if SN > "MITHEAVYPRATPCAPR" then
										if SN == "MITIGATION" then
											Result = EquSng(StatLinInter("PntMPMitigation","ItemPntS","MitMediumPRatPB","AdjItemMit",L,N,2))
										elseif SN == "MITLIGHTPPRAT" then
											Result = CalcRatAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCapR",L),N)
										elseif SN == "MITLIGHTPRATP" then
											Result = CalcPercAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCap",L),N)
										end
									elseif SN < "MITHEAVYPRATPCAPR" then
										if SN == "MITHEAVYPRATPC" then
											Result = 0.5
										elseif SN == "MITHEAVYPRATPCAP" then
											Result = 60.0
										end
									else
										Result = CalcStat("MitHeavyPRatPB",L)*CalcStat("MitHeavyPRatPC",L)
									end
								elseif SN > "MITLIGHTPRATPA" then
									if SN > "MITLIGHTPRATPCAPR" then
										if SN == "MITMEDIUMPPRAT" then
											Result = CalcRatAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCapR",L),N)
										elseif SN == "MITMEDIUMPRATP" then
											Result = CalcPercAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCap",L),N)
										elseif SN == "MITMEDIUMPRATPA" then
											Result = 150.0
										end
									elseif SN < "MITLIGHTPRATPCAPR" then
										if SN == "MITLIGHTPRATPB" then
											Result = CalcStat("BRatMitLight",L)
										elseif SN == "MITLIGHTPRATPC" then
											Result = 0.5
										elseif SN == "MITLIGHTPRATPCAP" then
											Result = 40.0
										end
									else
										Result = CalcStat("MitLightPRatPB",L)*CalcStat("MitLightPRatPC",L)
									end
								else
									Result = 120.0
								end
							else
								Result = CalcStat("BRatMitMedium",L)
							end
						elseif SN > "NCPRCI" then
							if SN > "OUTHEALPRATPA" then
								if SN < "PARRYCI" then
									if SN > "OUTHEALPRATPCAPR" then
										if SN == "OUTHEALT" then
											Result = EquSng(StatLinInter("PntMPOutHeal","TraitPntS","OutHealPRatPB","AdjTraitRat",L,N,2))
										elseif SN == "PARRY" then
											Result = CalcStat("BPE",L,N)
										elseif SN == "PARRYC" then
											Result = CalcStat("BPEC",L,N)
										end
									elseif SN < "OUTHEALPRATPCAPR" then
										if SN == "OUTHEALPRATPB" then
											Result = CalcStat("BRatOutHeal",L)
										elseif SN == "OUTHEALPRATPC" then
											Result = 0.5
										elseif SN == "OUTHEALPRATPCAP" then
											Result = 70.0
										end
									else
										Result = CalcStat("OutHealPRatPB",L)*CalcStat("OutHealPRatPC",L)
									end
								elseif SN > "PARRYCI" then
									if SN > "PARRYPRATPA" then
										if SN == "PARRYPRATPB" then
											Result = CalcStat("BPEPRatPB",L)
										elseif SN == "PARRYPRATPC" then
											Result = CalcStat("BPEPRatPC",L)
										elseif SN == "PARRYPRATPCAP" then
											Result = CalcStat("BPEPRatPCap",L)
										end
									elseif SN < "PARRYPRATPA" then
										if SN == "PARRYPBONUS" then
											Result = CalcStat("BPEPBonus",L)
										elseif SN == "PARRYPPRAT" then
											Result = CalcStat("BPEPPRat",L,N)
										elseif SN == "PARRYPRATP" then
											Result = CalcStat("BPEPRatP",L,N)
										end
									else
										Result = CalcStat("BPEPRatPA",L)
									end
								else
									Result = CalcStat("BPECI",L,N)
								end
							elseif SN < "OUTHEALPRATPA" then
								if SN < "OUTDMGPRATPA" then
									if SN > "ORCCMIT" then
										if SN == "ORCCMITT" then
											Result = EquSng(StatLinInter("PntMPOrcCMit","TraitPntS","MitMediumPRatPB","AdjTraitMit",L,N,2))
										elseif SN == "OUTDMGPPRAT" then
											Result = CalcRatAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCapR",L),N)
										elseif SN == "OUTDMGPRATP" then
											Result = CalcPercAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCap",L),N)
										end
									elseif SN < "ORCCMIT" then
										if SN == "NCPRCILVLFILTER" then
											Result = TranslateValue({0},{570},N)
										elseif SN == "NCPRT" then
											Result = EquSng(StatLinInter("PntMPNCPR","TraitPntSVital","ProgBEnergy","",L,N))
										elseif SN == "OFFSET" then
											Result = L+N
										end
									else
										Result = EquSng(StatLinInter("PntMPOrcCMit","ItemPntS","MitMediumPRatPB","AdjItemMit",L,N,2))
									end
								elseif SN > "OUTDMGPRATPA" then
									if SN > "OUTDMGPRATPCAPR" then
										if SN == "OUTHEAL" then
											Result = EquSng(StatLinInter("PntMPOutHeal","ItemPntS","OutHealPRatPB","AdjItemRat",L,N,2))
										elseif SN == "OUTHEALPPRAT" then
											Result = CalcRatAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCapR",L),N)
										elseif SN == "OUTHEALPRATP" then
											Result = CalcPercAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCap",L),N)
										end
									elseif SN < "OUTDMGPRATPCAPR" then
										if SN == "OUTDMGPRATPB" then
											Result = CalcStat("BRatExtra",L)
										elseif SN == "OUTDMGPRATPC" then
											Result = 0.5
										elseif SN == "OUTDMGPRATPCAP" then
											Result = 200.0
										end
									else
										Result = CalcStat("OutDmgPRatPB",L)*CalcStat("OutDmgPRatPC",L)
									end
								else
									Result = 600.0
								end
							else
								Result = 210.0
							end
						else
							Result = RoundDbl(StatLinInter("PntMPNCPRC","ItemPntSVital","ProgBEnergy","AdjCreepEnergy",L,N),1)
						end
					elseif SN < "MITHEAVYPRATPB" then
						if SN < "MINSTRELCDMIGHTTOCRITHIT" then
							if SN > "MINSTRELCDBASEICPR" then
								if SN < "MINSTRELCDCALCTYPECOMPHYMIT" then
									if SN > "MINSTRELCDBASENCPR" then
										if SN == "MINSTRELCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										elseif SN == "MINSTRELCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										elseif SN == "MINSTRELCDBASEWILL" then
											Result = CalcStat("ClassBaseWillH",L)
										end
									elseif SN < "MINSTRELCDBASENCPR" then
										if SN == "MINSTRELCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightL",L)
										elseif SN == "MINSTRELCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										elseif SN == "MINSTRELCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRL",L)
										end
									else
										Result = CalcStat("ClassBaseNCPR",L)
									end
								elseif SN > "MINSTRELCDCALCTYPECOMPHYMIT" then
									if SN > "MINSTRELCDFATETOICPR" then
										if SN == "MINSTRELCDFATETONCPR" then
											Result = 0.15
										elseif SN == "MINSTRELCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "MINSTRELCDHASPOWER" then
											Result = 1
										end
									elseif SN < "MINSTRELCDFATETOICPR" then
										if SN == "MINSTRELCDCALCTYPENONPHYMIT" then
											Result = 12
										elseif SN == "MINSTRELCDCALCTYPETACMIT" then
											Result = 25
										elseif SN == "MINSTRELCDCANBLOCK" then
											if 20 <= L then
												Result = 1
											end
										end
									else
										Result = 0.015
									end
								else
									Result = 12
								end
							elseif SN < "MINSTRELCDBASEICPR" then
								if SN < "MINSTRELCDAGILITYTOTACMAS" then
									if SN > "MINPIERCINGBALFINESSE" then
										if SN == "MINSTRELCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "MINSTRELCDAGILITYTOEVADE" then
											Result = 1.0
										elseif SN == "MINSTRELCDAGILITYTOFINESSE" then
											Result = 1.0
										end
									elseif SN < "MINPIERCINGBALFINESSE" then
										if SN == "MINECHOESBATTLERESIST" then
											Result = -CalcStat("SongResistT",L,1.0)
										elseif SN == "MINENDMORALE" then
											Result = CalcStat("MoraleT",L,CalcStat("Trait12345Choice",N)*0.8)
										end
									else
										Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4)
									end
								elseif SN > "MINSTRELCDAGILITYTOTACMAS" then
									if SN > "MINSTRELCDARMOURTYPE" then
										if SN == "MINSTRELCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityM",L)
										elseif SN == "MINSTRELCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										elseif SN == "MINSTRELCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRL",L)
										end
									elseif SN < "MINSTRELCDARMOURTYPE" then
										if SN == "MINSTRELCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "MINSTRELCDARMOURTONONPHYMIT" then
											Result = 0.2
										elseif SN == "MINSTRELCDARMOURTOTACMIT" then
											Result = 0.2
										end
									else
										Result = 1
									end
								else
									Result = 2.0
								end
							else
								Result = CalcStat("ClassBaseICPR",L)
							end
						elseif SN > "MINSTRELCDMIGHTTOCRITHIT" then
							if SN > "MINSTRELCDWILLTOTACMIT" then
								if SN < "MINTOTFINESSESEL" then
									if SN > "MINTOTCRITHITSEL" then
										if SN == "MINTOTFATE" then
											Result = CalcStat("FateT",L,CalcStat("MinToTFateSel",N))
										elseif SN == "MINTOTFATESEL" then
											if 1 <= L and L <= 5 then
												Result = DataTableValue({0.2,0.3,0.4,0.5,0.6},L)
											end
										elseif SN == "MINTOTFINESSE" then
											Result = CalcStat("FinesseT",L,CalcStat("MinToTFinesseSel",N))
										end
									elseif SN < "MINTOTCRITHITSEL" then
										if SN == "MINTACMAS" then
											Result = CalcStat("TacMasT",L,CalcStat("Trait123455Choice",N)*0.4)
										elseif SN == "MINTIMEECHOESBATTLERESIST" then
											Result = -CalcStat("SongResistT",L,0.6)
										elseif SN == "MINTOTCRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("MinToTCritHitSel",N))
										end
									else
										if 1 <= L and L <= 5 then
											Result = DataTableValue({0.0,0.0,0.0,0.4,0.6},L)
										end
									end
								elseif SN > "MINTOTFINESSESEL" then
									if SN > "MINTOTVITALITYSEL" then
										if SN == "MITHEAVYPPRAT" then
											Result = CalcRatAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCapR",L),N)
										elseif SN == "MITHEAVYPRATP" then
											Result = CalcPercAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCap",L),N)
										elseif SN == "MITHEAVYPRATPA" then
											Result = 180.0
										end
									elseif SN < "MINTOTVITALITYSEL" then
										if SN == "MINTOTRESIST" then
											Result = CalcStat("ResistT",L,CalcStat("MinToTResistSel",N))
										elseif SN == "MINTOTRESISTSEL" then
											if 1 <= L and L <= 5 then
												Result = DataTableValue({0.0,0.2,0.3,0.4,0.5},L)
											end
										elseif SN == "MINTOTVITALITY" then
											Result = CalcStat("VitalityT",L,CalcStat("MinToTVitalitySel",N))
										end
									else
										if 1 <= L and L <= 5 then
											Result = DataTableValue({0.0,0.0,0.0,0.0,0.4},L)
										end
									end
								else
									if 1 <= L and L <= 5 then
										Result = DataTableValue({0.0,0.0,0.2,0.4,0.6},L)
									end
								end
							elseif SN < "MINSTRELCDWILLTOTACMIT" then
								if SN < "MINSTRELCDVITALITYTOMORALE" then
									if SN > "MINSTRELCDPHYMITTOCOMPHYMIT" then
										if SN == "MINSTRELCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "MINSTRELCDTACMASTOOUTHEAL" then
											Result = 1.0
										elseif SN == "MINSTRELCDVITALITYTOICMR" then
											Result = 0.012
										end
									elseif SN < "MINSTRELCDPHYMITTOCOMPHYMIT" then
										if SN == "MINSTRELCDMIGHTTOOUTHEAL" then
											Result = 2.0
										elseif SN == "MINSTRELCDMIGHTTOTACMAS" then
											Result = 2.0
										elseif SN == "MINSTRELCDMIGHTTOTACMIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "MINSTRELCDVITALITYTOMORALE" then
									if SN > "MINSTRELCDWILLTOEVADE" then
										if SN == "MINSTRELCDWILLTOPHYMIT" then
											Result = 1.0
										elseif SN == "MINSTRELCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "MINSTRELCDWILLTOTACMAS" then
											Result = 3.0
										end
									elseif SN < "MINSTRELCDWILLTOEVADE" then
										if SN == "MINSTRELCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "MINSTRELCDWILLTOBLOCK" then
											Result = 1.0
										elseif SN == "MINSTRELCDWILLTOCRITHIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								else
									Result = 4.5
								end
							else
								Result = 1.0
							end
						else
							Result = 1.0
						end
					else
						Result = CalcStat("BRatMitHeavy",L)
					end
				elseif SN > "PARRYPRATPCAPR" then
					if SN > "PARTPARRYMITPBONUS" then
						if SN < "PHYMASC" then
							if SN > "PARTPARRYPRATPCAPR" then
								if SN < "PHYDMGPPRAT" then
									if SN > "PERKPHYMIT" then
										if SN == "PERKPOWER" then
											if 1 <= L and L <= 4 then
												Result = DataTableValue({10.0,20.0,30.0,40.0},L)
											end
										elseif SN == "PERKTACMIT" then
											Result = CalcStat("TacMitT",L,0.2*N)
										elseif SN == "PHYDMGPBONUS" then
											Result = CalcStat("OutDmgPBonus",L)
										end
									elseif SN < "PERKPHYMIT" then
										if SN == "PERKMORALE" then
											if 1 <= L and L <= 4 then
												Result = DataTableValue({10.0,20.0,30.0,40.0},L)
											end
										elseif SN == "PERKNCMR" then
											Result = CalcStat("FoodNCMRL",L)
										elseif SN == "PERKNCPR" then
											Result = CalcStat("FoodNCPRL",L)
										end
									else
										Result = CalcStat("PhyMitT",L,0.2*N)
									end
								elseif SN > "PHYDMGPPRAT" then
									if SN > "PHYDMGPRATPC" then
										if SN == "PHYDMGPRATPCAP" then
											Result = CalcStat("OutDmgPRatPCap",L)
										elseif SN == "PHYDMGPRATPCAPR" then
											Result = CalcStat("OutDmgPRatPCapR",L)
										elseif SN == "PHYMAS" then
											Result = CalcStat("Mastery",L,N)
										end
									elseif SN < "PHYDMGPRATPC" then
										if SN == "PHYDMGPRATP" then
											Result = CalcStat("OutDmgPRatP",L,N)
										elseif SN == "PHYDMGPRATPA" then
											Result = CalcStat("OutDmgPRatPA",L)
										elseif SN == "PHYDMGPRATPB" then
											Result = CalcStat("OutDmgPRatPB",L)
										end
									else
										Result = CalcStat("OutDmgPRatPC",L)
									end
								else
									Result = CalcStat("OutDmgPPRat",L,N)
								end
							elseif SN < "PARTPARRYPRATPCAPR" then
								if SN < "PARTPARRYMITPRATPCAPR" then
									if SN > "PARTPARRYMITPRATPA" then
										if SN == "PARTPARRYMITPRATPB" then
											Result = CalcStat("PartMitPRatPB",L)
										elseif SN == "PARTPARRYMITPRATPC" then
											Result = CalcStat("PartMitPRatPC",L)
										elseif SN == "PARTPARRYMITPRATPCAP" then
											Result = CalcStat("PartMitPRatPCap",L)
										end
									elseif SN < "PARTPARRYMITPRATPA" then
										if SN == "PARTPARRYMITPPRAT" then
											Result = CalcStat("PartMitPPRat",L,N)
										elseif SN == "PARTPARRYMITPRATP" then
											Result = CalcStat("PartMitPRatP",L,N)
										end
									else
										Result = CalcStat("PartMitPRatPA",L)
									end
								elseif SN > "PARTPARRYMITPRATPCAPR" then
									if SN > "PARTPARRYPRATPA" then
										if SN == "PARTPARRYPRATPB" then
											Result = CalcStat("PartBPEPRatPB",L)
										elseif SN == "PARTPARRYPRATPC" then
											Result = CalcStat("PartBPEPRatPC",L)
										elseif SN == "PARTPARRYPRATPCAP" then
											Result = CalcStat("PartBPEPRatPCap",L)
										end
									elseif SN < "PARTPARRYPRATPA" then
										if SN == "PARTPARRYPBONUS" then
											Result = CalcStat("PartBPEPBonus",L)
										elseif SN == "PARTPARRYPPRAT" then
											Result = CalcStat("PartBPEPPRat",L,N)
										elseif SN == "PARTPARRYPRATP" then
											Result = CalcStat("PartBPEPRatP",L,N)
										end
									else
										Result = CalcStat("PartBPEPRatPA",L)
									end
								else
									Result = CalcStat("PartMitPRatPCapR",L)
								end
							else
								Result = CalcStat("PartBPEPRatPCapR",L)
							end
						elseif SN > "PHYMASC" then
							if SN > "PHYMITLPBONUS" then
								if SN < "PHYMITMPBONUS" then
									if SN > "PHYMITLPRATPB" then
										if SN == "PHYMITLPRATPC" then
											Result = CalcStat("MitLightPRatPC",L)
										elseif SN == "PHYMITLPRATPCAP" then
											Result = CalcStat("MitLightPRatPCap",L)
										elseif SN == "PHYMITLPRATPCAPR" then
											Result = CalcStat("MitLightPRatPCapR",L)
										end
									elseif SN < "PHYMITLPRATPB" then
										if SN == "PHYMITLPPRAT" then
											Result = CalcStat("MitLightPPRat",L,N)
										elseif SN == "PHYMITLPRATP" then
											Result = CalcStat("MitLightPRatP",L,N)
										elseif SN == "PHYMITLPRATPA" then
											Result = CalcStat("MitLightPRatPA",L)
										end
									else
										Result = CalcStat("MitLightPRatPB",L)
									end
								elseif SN > "PHYMITMPBONUS" then
									if SN > "PHYMITMPRATPB" then
										if SN == "PHYMITMPRATPC" then
											Result = CalcStat("MitMediumPRatPC",L)
										elseif SN == "PHYMITMPRATPCAP" then
											Result = CalcStat("MitMediumPRatPCap",L)
										elseif SN == "PHYMITMPRATPCAPR" then
											Result = CalcStat("MitMediumPRatPCapR",L)
										end
									elseif SN < "PHYMITMPRATPB" then
										if SN == "PHYMITMPPRAT" then
											Result = CalcStat("MitMediumPPRat",L,N)
										elseif SN == "PHYMITMPRATP" then
											Result = CalcStat("MitMediumPRatP",L,N)
										elseif SN == "PHYMITMPRATPA" then
											Result = CalcStat("MitMediumPRatPA",L)
										end
									else
										Result = CalcStat("MitMediumPRatPB",L)
									end
								else
									Result = CalcStat("MitMediumPBonus",L)
								end
							elseif SN < "PHYMITLPBONUS" then
								if SN < "PHYMITHPBONUS" then
									if SN > "PHYMIT" then
										if SN == "PHYMITC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("PhyMitCI",CalcStat("PhyMitCILvlFilter",L,N),N),2)
										elseif SN == "PHYMITCI" then
											Result = RoundDblLotro(StatLinInter("PntMPPhyMitC","ItemPntS","MitMediumPRatPB","AdjCreepMit",L,N))
										elseif SN == "PHYMITCILVLFILTER" then
											Result = TranslateValue({2.8,3.8,8.2,14.4},{565,565,565,565,570},N)
										end
									elseif SN < "PHYMIT" then
										if SN == "PHYMASCI" then
											Result = CalcStat("MasteryCI",L,N)
										elseif SN == "PHYMASOLD" then
											Result = CalcStat("Mastery",L,N)
										elseif SN == "PHYMAST" then
											Result = CalcStat("MasteryT",L,N)
										end
									else
										Result = EquSng(StatLinInter("PntMPPhyMit","ItemPntS","MitMediumPRatPB","AdjItemMit",L,N,2))
									end
								elseif SN > "PHYMITHPBONUS" then
									if SN > "PHYMITHPRATPB" then
										if SN == "PHYMITHPRATPC" then
											Result = CalcStat("MitHeavyPRatPC",L)
										elseif SN == "PHYMITHPRATPCAP" then
											Result = CalcStat("MitHeavyPRatPCap",L)
										elseif SN == "PHYMITHPRATPCAPR" then
											Result = CalcStat("MitHeavyPRatPCapR",L)
										end
									elseif SN < "PHYMITHPRATPB" then
										if SN == "PHYMITHPPRAT" then
											Result = CalcStat("MitHeavyPPRat",L,N)
										elseif SN == "PHYMITHPRATP" then
											Result = CalcStat("MitHeavyPRatP",L,N)
										elseif SN == "PHYMITHPRATPA" then
											Result = CalcStat("MitHeavyPRatPA",L)
										end
									else
										Result = CalcStat("MitHeavyPRatPB",L)
									end
								else
									Result = CalcStat("MitHeavyPBonus",L)
								end
							else
								Result = CalcStat("MitLightPBonus",L)
							end
						else
							Result = CalcStat("MasteryC",L,N)
						end
					elseif SN < "PARTPARRYMITPBONUS" then
						if SN < "PARTEVADEMITPRATPCAP" then
							if SN > "PARTBLOCKPRATPC" then
								if SN < "PARTBPEPRATPCAP" then
									if SN > "PARTBPEPRATP" then
										if SN == "PARTBPEPRATPA" then
											Result = 75.0
										elseif SN == "PARTBPEPRATPB" then
											Result = CalcStat("BRatPartBPE",L)
										elseif SN == "PARTBPEPRATPC" then
											Result = 0.5
										end
									elseif SN < "PARTBPEPRATP" then
										if SN == "PARTBLOCKPRATPCAP" then
											Result = CalcStat("PartBPEPRatPCap",L)
										elseif SN == "PARTBLOCKPRATPCAPR" then
											Result = CalcStat("PartBPEPRatPCapR",L)
										elseif SN == "PARTBPEPPRAT" then
											Result = CalcRatAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCapR",L),N)
										end
									else
										Result = CalcPercAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCap",L),N)
									end
								elseif SN > "PARTBPEPRATPCAP" then
									if SN > "PARTEVADEMITPRATP" then
										if SN == "PARTEVADEMITPRATPA" then
											Result = CalcStat("PartMitPRatPA",L)
										elseif SN == "PARTEVADEMITPRATPB" then
											Result = CalcStat("PartMitPRatPB",L)
										elseif SN == "PARTEVADEMITPRATPC" then
											Result = CalcStat("PartMitPRatPC",L)
										end
									elseif SN < "PARTEVADEMITPRATP" then
										if SN == "PARTBPEPRATPCAPR" then
											Result = CalcStat("PartBPEPRatPB",L)*CalcStat("PartBPEPRatPC",L)
										elseif SN == "PARTEVADEMITPBONUS" then
											Result = CalcStat("PartMitPBonus",L)
										elseif SN == "PARTEVADEMITPPRAT" then
											Result = CalcStat("PartMitPPRat",L,N)
										end
									else
										Result = CalcStat("PartMitPRatP",L,N)
									end
								else
									Result = 25.0
								end
							elseif SN < "PARTBLOCKPRATPC" then
								if SN < "PARTBLOCKMITPRATPC" then
									if SN > "PARTBLOCKMITPPRAT" then
										if SN == "PARTBLOCKMITPRATP" then
											Result = CalcStat("PartMitPRatP",L,N)
										elseif SN == "PARTBLOCKMITPRATPA" then
											Result = CalcStat("PartMitPRatPA",L)
										elseif SN == "PARTBLOCKMITPRATPB" then
											Result = CalcStat("PartMitPRatPB",L)
										end
									elseif SN < "PARTBLOCKMITPPRAT" then
										if SN == "PARRYT" then
											Result = CalcStat("BPET",L,N)
										elseif SN == "PARTBLOCKMITPBONUS" then
											Result = CalcStat("PartMitPBonus",L)
										end
									else
										Result = CalcStat("PartMitPPRat",L,N)
									end
								elseif SN > "PARTBLOCKMITPRATPC" then
									if SN > "PARTBLOCKPPRAT" then
										if SN == "PARTBLOCKPRATP" then
											Result = CalcStat("PartBPEPRatP",L,N)
										elseif SN == "PARTBLOCKPRATPA" then
											Result = CalcStat("PartBPEPRatPA",L)
										elseif SN == "PARTBLOCKPRATPB" then
											Result = CalcStat("PartBPEPRatPB",L)
										end
									elseif SN < "PARTBLOCKPPRAT" then
										if SN == "PARTBLOCKMITPRATPCAP" then
											Result = CalcStat("PartMitPRatPCap",L)
										elseif SN == "PARTBLOCKMITPRATPCAPR" then
											Result = CalcStat("PartMitPRatPCapR",L)
										elseif SN == "PARTBLOCKPBONUS" then
											Result = CalcStat("PartBPEPBonus",L)
										end
									else
										Result = CalcStat("PartBPEPPRat",L,N)
									end
								else
									Result = CalcStat("PartMitPRatPC",L)
								end
							else
								Result = CalcStat("PartBPEPRatPC",L)
							end
						elseif SN > "PARTEVADEMITPRATPCAP" then
							if SN > "PARTFINESSEDMGPRATPCAPR" then
								if SN < "PARTMITPBONUS" then
									if SN > "PARTFINESSEPRATPB" then
										if SN == "PARTFINESSEPRATPC" then
											Result = 0.5
										elseif SN == "PARTFINESSEPRATPCAP" then
											Result = 50.0
										elseif SN == "PARTFINESSEPRATPCAPR" then
											Result = CalcStat("PartFinessePRatPB",L)*CalcStat("PartFinessePRatPC",L)
										end
									elseif SN < "PARTFINESSEPRATPB" then
										if SN == "PARTFINESSEPPRAT" then
											Result = CalcRatAB(CalcStat("PartFinessePRatPA",L),CalcStat("PartFinessePRatPB",L),CalcStat("PartFinessePRatPCapR",L),N)
										elseif SN == "PARTFINESSEPRATP" then
											Result = CalcPercAB(CalcStat("PartFinessePRatPA",L),CalcStat("PartFinessePRatPB",L),CalcStat("PartFinessePRatPCap",L),N)
										elseif SN == "PARTFINESSEPRATPA" then
											Result = 150.0
										end
									else
										Result = CalcStat("BRatStandard",L)
									end
								elseif SN > "PARTMITPBONUS" then
									if SN > "PARTMITPRATPB" then
										if SN == "PARTMITPRATPC" then
											Result = 0.5
										elseif SN == "PARTMITPRATPCAP" then
											Result = 35.0
										elseif SN == "PARTMITPRATPCAPR" then
											Result = CalcStat("PartMitPRatPB",L)*CalcStat("PartMitPRatPC",L)
										end
									elseif SN < "PARTMITPRATPB" then
										if SN == "PARTMITPPRAT" then
											Result = CalcRatAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCapR",L),N)
										elseif SN == "PARTMITPRATP" then
											Result = CalcPercAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCap",L),N)
										elseif SN == "PARTMITPRATPA" then
											Result = 105.0
										end
									else
										Result = CalcStat("BRatPartBPE",L)
									end
								else
									Result = 0.1
								end
							elseif SN < "PARTFINESSEDMGPRATPCAPR" then
								if SN < "PARTEVADEPRATPCAP" then
									if SN > "PARTEVADEPRATP" then
										if SN == "PARTEVADEPRATPA" then
											Result = CalcStat("PartBPEPRatPA",L)
										elseif SN == "PARTEVADEPRATPB" then
											Result = CalcStat("PartBPEPRatPB",L)
										elseif SN == "PARTEVADEPRATPC" then
											Result = CalcStat("PartBPEPRatPC",L)
										end
									elseif SN < "PARTEVADEPRATP" then
										if SN == "PARTEVADEMITPRATPCAPR" then
											Result = CalcStat("PartMitPRatPCapR",L)
										elseif SN == "PARTEVADEPBONUS" then
											Result = CalcStat("PartBPEPBonus",L)
										elseif SN == "PARTEVADEPPRAT" then
											Result = CalcStat("PartBPEPPRat",L,N)
										end
									else
										Result = CalcStat("PartBPEPRatP",L,N)
									end
								elseif SN > "PARTEVADEPRATPCAP" then
									if SN > "PARTFINESSEDMGPRATPA" then
										if SN == "PARTFINESSEDMGPRATPB" then
											Result = CalcStat("BRatStandard",L)
										elseif SN == "PARTFINESSEDMGPRATPC" then
											Result = 0.5
										elseif SN == "PARTFINESSEDMGPRATPCAP" then
											Result = 50.0
										end
									elseif SN < "PARTFINESSEDMGPRATPA" then
										if SN == "PARTEVADEPRATPCAPR" then
											Result = CalcStat("PartBPEPRatPCapR",L)
										elseif SN == "PARTFINESSEDMGPPRAT" then
											Result = CalcRatAB(CalcStat("PartFinesseDmgPRatPA",L),CalcStat("PartFinesseDmgPRatPB",L),CalcStat("PartFinesseDmgPRatPCapR",L),N)
										elseif SN == "PARTFINESSEDMGPRATP" then
											Result = CalcPercAB(CalcStat("PartFinesseDmgPRatPA",L),CalcStat("PartFinesseDmgPRatPB",L),CalcStat("PartFinesseDmgPRatPCap",L),N)
										end
									else
										Result = 150.0
									end
								else
									Result = CalcStat("PartBPEPRatPCap",L)
								end
							else
								Result = CalcStat("PartFinesseDmgPRatPB",L)*CalcStat("PartFinesseDmgPRatPC",L)
							end
						else
							Result = CalcStat("PartMitPRatPCap",L)
						end
					else
						Result = CalcStat("PartMitPBonus",L)
					end
				else
					Result = CalcStat("BPEPRatPCapR",L)
				end
			else
				Result = EquSng(StatLinInter("PntMPPhyMit","TraitPntS","MitMediumPRatPB","AdjTraitMit",L,N,2))
			end
		elseif SN > "TACMITMPRATPCAPR" then
			if SN > "WARDENCDWILLTOTACMIT" then
				if SN < "WORTHTABR" then
					if SN > "WORTHTABB" then
						if SN < "WORTHTABCD" then
							if SN > "WORTHTABBO" then
								if SN < "WORTHTABBW" then
									if SN > "WORTHTABBS" then
										if SN == "WORTHTABBT" then
											Result = 62500.0
										elseif SN == "WORTHTABBU" then
											if L <= 80 then
												Result = 20.0*L+300.0
											else
												Result = 10.0*L+1100.0
											end
										elseif SN == "WORTHTABBV" then
											if L <= 29 then
												Result = 1250.0
											else
												Result = RoundDbl(0.05*L-1.0,0)*2500.0
											end
										end
									elseif SN < "WORTHTABBS" then
										if SN == "WORTHTABBP" then
											if L <= 10 then
												Result = 156.25*L+1562.5
											elseif L <= 20 then
												Result = 312.5*L
											elseif L <= 30 then
												Result = 625.0*L-6250.0
											elseif L <= 40 then
												Result = 1250.0*L-25000.0
											else
												Result = 2500.0*L-75000.0
											end
										elseif SN == "WORTHTABBQ" then
											if L <= 1 then
												Result = 50.0
											elseif L <= 49 then
												Result = RoundDbl(2.5*L+100.0,0)
											else
												Result = 3.0*L+75.0
											end
										elseif SN == "WORTHTABBR" then
											if L <= 49 then
												Result = CalcStat("WorthTabBQ",L)*2.0
											else
												Result = 4.0*L+250.0
											end
										end
									else
										Result = CalcStat("WorthTabBR",L)*2.0
									end
								elseif SN > "WORTHTABBW" then
									if SN > "WORTHTABC" then
										if SN == "WORTHTABCA" then
											if L <= 10 then
												Result = 7.25*L+72.25
											elseif L <= 20 then
												Result = 14.49*L+0.11
											elseif L <= 30 then
												Result = 29.0*L-290.0
											elseif L <= 35 then
												Result = 57.99*L-1160.16
											elseif L <= 40 then
												Result = 57.99*L-1160.12
											elseif L <= 80 then
												Result = 115.94*L-3478.2
											else
												Result = 116.0*L-3483.0
											end
										elseif SN == "WORTHTABCB" then
											Result = 0.1
										elseif SN == "WORTHTABCC" then
											Result = CalcStat("WorthTabBK",L)*5.0
										end
									elseif SN < "WORTHTABC" then
										if SN == "WORTHTABBX" then
											if L <= 10 then
												Result = RoundDbl(0.1*L+0.45,0)*3.0
											elseif L <= 140 then
												Result = RoundDbl(0.1*L-0.6,0)*6.0
											else
												Result = RoundDbl(0.1*L+0.4,0)*4.0+22.0
											end
										elseif SN == "WORTHTABBY" then
											Result = 90000.0
										elseif SN == "WORTHTABBZ" then
											if L <= 10 then
												Result = 27.42*L+273.1
											elseif L <= 20 then
												Result = 54.69*L
											elseif L <= 30 then
												Result = 109.35*L-1093.0
											elseif L <= 40 then
												Result = 218.75*L-4375.0
											elseif L <= 80 then
												Result = 437.5*L-13125.0
											else
												Result = 437.0*L-13085.0
											end
										end
									else
										Result = CalcStat("WorthTabD",L)+20.0
									end
								else
									if L <= 1 then
										Result = 645.0
									elseif L <= 9 then
										Result = 20.0*L+980.0
									else
										Result = 50.0*L+920.0
									end
								end
							elseif SN < "WORTHTABBO" then
								if SN < "WORTHTABBG" then
									if SN > "WORTHTABBC" then
										if SN == "WORTHTABBD" then
											Result = CalcStat("WorthTabK",L)+1.0
										elseif SN == "WORTHTABBE" then
											if L <= 1 then
												Result = 60.0
											elseif L <= 7 then
												Result = RoundDbl(L/3.0,0)*40.0+30.0
											elseif L <= 13 then
												Result = RoundDbl(L/3.0,0)*130.0-210.0
											elseif L <= 19 then
												Result = RoundDbl(L/3.0,0)*60.0+140.0
											elseif L <= 25 then
												Result = RoundDbl(L/3.0,0)*10.0+480.0
											elseif L <= 46 then
												Result = RoundDbl(L/3.0,0)*10.0+490.0
											elseif L <= 50 then
												Result = 660.0
											else
												Result = 20.0*L-320.0
											end
										elseif SN == "WORTHTABBF" then
											Result = CalcStat("WorthTabAV",L)+20.0
										end
									elseif SN < "WORTHTABBC" then
										if SN == "WORTHTABBA" then
											Result = 5.0*L+385.0
										elseif SN == "WORTHTABBB" then
											if L <= 1 then
												Result = 40.0
											elseif L <= 10 then
												Result = RoundDbl(0.35*L-0.1,0)*20.0
											elseif L <= 13 then
												Result = 100.0
											elseif L <= 19 then
												Result = RoundDbl(0.35*L+1.6,0)*20.0
											elseif L <= 25 then
												Result = RoundDbl(2.0*L+150.0,-1)
											elseif L <= 40 then
												Result = RoundDbl(2.0*L+164.0,-1)
											elseif L <= 49 then
												Result = RoundDbl(1.0*L+201.0,-1)
											else
												Result = 20.0*L-740.0
											end
										end
									else
										if L <= 34 then
											Result = RoundDbl(L/15.0+0.8,0)*3750.0+1250.0
										elseif L <= 35 then
											Result = 100000.0
										else
											Result = 125500.0
										end
									end
								elseif SN > "WORTHTABBG" then
									if SN > "WORTHTABBK" then
										if SN == "WORTHTABBL" then
											if L <= 35 then
												Result = 126600.0
											elseif L <= 46 then
												Result = 150600.0
											elseif L <= 47 then
												Result = 180720.0
											else
												Result = 150600.0
											end
										elseif SN == "WORTHTABBM" then
											if L <= 1 then
												Result = 10.0
											else
												Result = 20.0*L-20.0
											end
										elseif SN == "WORTHTABBN" then
											if L <= 1 then
												Result = 400.0
											else
												Result = 20.0*L+800.0
											end
										end
									elseif SN < "WORTHTABBK" then
										if SN == "WORTHTABBH" then
											if L <= 80 then
												Result = RoundDbl(0.05*L-0.05,0)+RoundDbl(0.05*L+0.45,0)
											else
												Result = RoundDbl(0.05*L-0.1,0)+RoundDbl(0.05*L+0.45,0)
											end
										elseif SN == "WORTHTABBI" then
											Result = CalcStat("WorthTabG",L)-25.0
										elseif SN == "WORTHTABBJ" then
											Result = RoundDbl(0.1*L+0.45,0)*3.0
										end
									else
										if L <= 10 then
											Result = RoundDbl(0.1*L+0.45,0)
										else
											Result = RoundDbl(0.1*L-0.6,0)*2.0
										end
									end
								else
									if L <= 7 then
										Result = RoundDbl(0.2*L-0.4,0)*2.0+1.0
									elseif L <= 16 then
										Result = RoundDbl(L/3.0-2.0,0)*6.0
									elseif L <= 22 then
										Result = RoundDbl(L/3.0+1.0,0)*3.0
									elseif L <= 25 then
										Result = RoundDbl(L/3.0+1.0,0)*3.0-2.0
									elseif L <= 80 then
										Result = RoundDbl(L/3.0+18.0,0)-2.0
									else
										Result = 1.0*L-37.0
									end
								end
							else
								if L <= 10 then
									Result = 10.0
								elseif L <= 40 then
									Result = RoundDbl(0.1*L-0.55,0)*50.0-25.0
								elseif L <= 80 then
									Result = RoundDbl(0.1*L-0.55,0)*50.0
								else
									Result = RoundDbl(0.1*L-0.55,0)*25.0+175.0
								end
							end
						elseif SN > "WORTHTABCD" then
							if SN > "WORTHTABCT" then
								if SN < "WORTHTABJ" then
									if SN > "WORTHTABF" then
										if SN == "WORTHTABG" then
											if L <= 1 then
												Result = 50.0
											else
												Result = CalcStat("WorthTabAF",L)+100.0
											end
										elseif SN == "WORTHTABH" then
											if L <= 2 then
												Result = 1.0*L
											elseif L <= 9 then
												Result = 1.48*L-2.85
											elseif L <= 11 then
												Result = 2.5*L-13.0
											elseif L <= 24 then
												Result = 2.5*L-10.0
											else
												Result = 5*L-70.0
											end
										elseif SN == "WORTHTABI" then
											if L <= 4 then
												Result = 1.0
											elseif L <= 10 then
												Result = 0.7*L-1.0
											elseif L <= 15 then
												Result = 1.4*L-7.0
											elseif L <= 24 then
												Result = 1.25*L-5.0
											elseif L <= 49 then
												Result = 2.5*L-35.0
											else
												Result = 3.0*L-60.0
											end
										end
									elseif SN < "WORTHTABF" then
										if SN == "WORTHTABCU" then
											Result = 75000.0
										elseif SN == "WORTHTABD" then
											if L <= 49 then
												Result = 7.5*L
											else
												Result = 8.0*L-25.0
											end
										elseif SN == "WORTHTABE" then
											if L <= 9 then
												Result = 30.0*L+50.0
											else
												Result = 7.0*L+280.0
											end
										end
									else
										Result = 0.1
									end
								elseif SN > "WORTHTABJ" then
									if SN > "WORTHTABN" then
										if SN == "WORTHTABO" then
											Result = CalcStat("WorthTabB",L)+11.0
										elseif SN == "WORTHTABP" then
											Result = CalcStat("WorthTabE",L)
										elseif SN == "WORTHTABQ" then
											Result = 7.0*L+25.0
										end
									elseif SN < "WORTHTABN" then
										if SN == "WORTHTABK" then
											if L <= 9 then
												Result = 12.0*L+24.0
											else
												Result = 7.0*L+74.0
											end
										elseif SN == "WORTHTABL" then
											Result = CalcStat("WorthTabB",L)+19.25
										elseif SN == "WORTHTABM" then
											if L <= 9 then
												Result = 10.0*L+11.0
											elseif L <= 49 then
												Result = 4.0*L+65.0
											else
												Result = 5.0*L+15.0
											end
										end
									else
										Result = CalcStat("WorthTabAF",L)+25.0
									end
								else
									if L <= 4 then
										Result = 2.5*L+7.5
									elseif L <= 5 then
										Result = 23.0
									else
										Result = 4.0*L
									end
								end
							elseif SN < "WORTHTABCT" then
								if SN < "WORTHTABCL" then
									if SN > "WORTHTABCH" then
										if SN == "WORTHTABCI" then
											Result = 40000.0
										elseif SN == "WORTHTABCJ" then
											Result = 20000.0
										elseif SN == "WORTHTABCK" then
											Result = 15000.0
										end
									elseif SN < "WORTHTABCH" then
										if SN == "WORTHTABCE" then
											Result = CalcStat("WorthTabBN",L)*10.0
										elseif SN == "WORTHTABCF" then
											if L <= 20 then
												Result = RoundDbl(0.1*L-0.55,0)*600.0+200.0
											elseif L <= 40 then
												Result = RoundDbl(0.1*L-0.55,0)*1000.0-500.0
											elseif L <= 60 then
												Result = RoundDbl(0.1*L-0.55,0)*2000.0-4000.0
											elseif L <= 70 then
												Result = 8500.0
											elseif L <= 140 then
												Result = RoundDbl(0.1*L-0.55,0)*2500.0-7500.0
											elseif L <= 200 then
												Result = RoundDbl(0.1*L-0.55,0)*3000.0-14000.0
											else
												Result = RoundDbl(0.1*L-0.55,0)*2500.0-3500.0
											end
										elseif SN == "WORTHTABCG" then
											Result = 20.0
										end
									else
										Result = 50000.0
									end
								elseif SN > "WORTHTABCL" then
									if SN > "WORTHTABCP" then
										if SN == "WORTHTABCQ" then
											if L <= 10 then
												Result = RoundDbl(0.3*L+0.2,0)*2.0
											elseif L <= 16 then
												Result = RoundDbl(0.25*L-1.0,0)*6.0
											elseif L <= 22 then
												Result = RoundDbl(0.3*L+5.5,0)*2.0
											elseif L <= 50 then
												Result = RoundDbl((1.0/6.0)*L+8.75,0)*2.0
											elseif L <= 80 then
												Result = RoundDbl((1.0/3.0)*L-11.5,0)*6.0
											else
												Result = RoundDbl(0.25*L-4.6,0)*6.0
											end
										elseif SN == "WORTHTABCR" then
											Result = CalcStat("WorthTabM",L)-15.0
										elseif SN == "WORTHTABCS" then
											Result = CalcStat("WorthTabBR",L)*3.0
										end
									elseif SN < "WORTHTABCP" then
										if SN == "WORTHTABCM" then
											Result = 7500.0
										elseif SN == "WORTHTABCN" then
											Result = RoundDbl(0.1*L+0.5,0)*10000.0
										elseif SN == "WORTHTABCO" then
											Result = CalcStat("WorthTabAB",L)
										end
									else
										Result = 1.0
									end
								else
									Result = 12500.0
								end
							else
								Result = 100000.0
							end
						else
							Result = CalcStat("WorthTabBK",L)*25.0
						end
					elseif SN < "WORTHTABB" then
						if SN < "WORTHMPJ" then
							if SN > "WILL" then
								if SN < "WORTHMPB" then
									if SN > "WORTHEXT" then
										if SN == "WORTHEXT4LIN" then
											if L <= 501 then
												Result = CalcStat("WorthExt",L,C)
											elseif L <= 601 then
												Result = CalcStat("WorthExt",501,C)+(L-501)*4.0
											end
										elseif SN == "WORTHEXT8LIN" then
											if L <= 501 then
												Result = CalcStat("WorthExt",L,C)
											elseif L <= 601 then
												Result = CalcStat("WorthExt",501,C)+(L-501)*8.0
											end
										elseif SN == "WORTHMPA" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,1.1,1.15,1.2,1.3},L))
											end
										end
									elseif SN < "WORTHEXT" then
										if SN == "WILLC" then
											Result = CalcStat("MainC",L,N)
										elseif SN == "WILLCI" then
											Result = CalcStat("MainCI",L,N)
										elseif SN == "WILLT" then
											Result = CalcStat("MainT",L,N)
										end
									else
										if L <= 360 then
											Result = RoundDbl(CalcStat("StatC",L,C),0)
										elseif L <= 601 then
											Result = RoundDbl(CalcStat("StatC",L-1,C),0)
										end
									end
								elseif SN > "WORTHMPB" then
									if SN > "WORTHMPF" then
										if SN == "WORTHMPG" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,2.0,3.0,4.0,5.0},L))
											end
										elseif SN == "WORTHMPH" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,1.2,1.8,3.2,5.0},L))
											end
										elseif SN == "WORTHMPI" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,2.0,2.5,3.0,10.0},L))
											end
										end
									elseif SN < "WORTHMPF" then
										if SN == "WORTHMPC" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,1.0,1.0,1.0,1.0},L))
											end
										elseif SN == "WORTHMPD" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,1.0,1.0,2.0,3.0},L))
											end
										elseif SN == "WORTHMPE" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,1.1,1.15,1.2,1.25},L))
											end
										end
									else
										if 1 <= L and L <= 5 then
											Result = EquSng(DataTableValue({0.5,1.0,1.25,1.5,2.0},L))
										end
									end
								else
									if 1 <= L and L <= 5 then
										Result = EquSng(DataTableValue({1.0,1.2,2.0,3.0,4.0},L))
									end
								end
							elseif SN < "WILL" then
								if SN < "WARLEADERCDHASPOWER" then
									if SN > "WARLEADERCANBLOCK" then
										if SN == "WARLEADERCDCALCTYPECOMPHYMIT" then
											Result = 14
										elseif SN == "WARLEADERCDCALCTYPENONPHYMIT" then
											Result = 14
										elseif SN == "WARLEADERCDCALCTYPETACMIT" then
											Result = 27
										end
									elseif SN < "WARLEADERCANBLOCK" then
										if SN == "WARDINGLOREPHYMIT" then
											if L <= 105 then
												Result = CalcStat("Mitigation",L,1.6)
											elseif L == 120 or L == 130 then
												Result = CalcStat("PhyMitT",L,1.6)
											else
												Result = CalcStat("PhyMitT",L,1.2)
											end
										elseif SN == "WARDINGLORETACMIT" then
											if L <= 105 then
												Result = CalcStat("Mitigation",L,1.6)
											elseif L == 120 or L == 130 then
												Result = CalcStat("TacMitT",L,1.6)
											else
												Result = CalcStat("TacMitT",L,1.2)
											end
										end
									else
										Result = 1
									end
								elseif SN > "WARLEADERCDHASPOWER" then
									if SN > "WEAVERCDCALCTYPETACMIT" then
										if SN == "WEAVERCDHASPOWER" then
											Result = 1
										elseif SN == "WESTERNESSEMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										elseif SN == "WESTERNESSEMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										end
									elseif SN < "WEAVERCDCALCTYPETACMIT" then
										if SN == "WEAVERCANBLOCK" then
											Result = 1
										elseif SN == "WEAVERCDCALCTYPECOMPHYMIT" then
											Result = 13
										elseif SN == "WEAVERCDCALCTYPENONPHYMIT" then
											Result = 14
										end
									else
										Result = 27
									end
								else
									Result = 1
								end
							else
								Result = CalcStat("Main",L,N)
							end
						elseif SN > "WORTHMPJ" then
							if SN > "WORTHTABALBASE" then
								if SN < "WORTHTABAT" then
									if SN > "WORTHTABAP" then
										if SN == "WORTHTABAQ" then
											if L <= 10 then
												Result = 7.5*L+60.0
											elseif L <= 49 then
												Result = 5.5*L+80.0
											else
												Result = 6.0*L+55.0
											end
										elseif SN == "WORTHTABAR" then
											Result = CalcStat("WorthTabD",L)+37.5
										elseif SN == "WORTHTABAS" then
											Result = CalcStat("WorthTabU",L)
										end
									elseif SN < "WORTHTABAP" then
										if SN == "WORTHTABAM" then
											Result = CalcStat("WorthTabB",L)
										elseif SN == "WORTHTABAN" then
											if L <= 50 then
												Result = 8.25*L+27.75
											else
												Result = 8.0*L+40.0
											end
										elseif SN == "WORTHTABAO" then
											Result = CalcStat("WorthTabE",L)
										end
									else
										Result = CalcStat("WorthTabAQ",L)
									end
								elseif SN > "WORTHTABAT" then
									if SN > "WORTHTABAX" then
										if SN == "WORTHTABAY" then
											Result = 5.0*L
										elseif SN == "WORTHTABAZ" then
											if L <= 10 then
												Result = CalcStat("WorthTabAZBase",L)*62.5
											elseif L <= 65 then
												Result = CalcStat("WorthTabAZBase",L)*125.0
											else
												Result = CalcStat("WorthTabAZBase",L)*25.0
											end
										elseif SN == "WORTHTABAZBASE" then
											if L <= 44 then
												Result = RoundDbl(0.0525*L+0.7,0)
											elseif L <= 65 then
												Result = RoundDbl(0.19*L-4.85,0)
											elseif L <= 81 then
												Result = RoundDbl(0.19*L+28.15,0)
											else
												Result = RoundDbl(0.19*L+28.15+RoundDbl(L*0.05-4.55,0)*0.2,0)
											end
										end
									elseif SN < "WORTHTABAX" then
										if SN == "WORTHTABAU" then
											Result = CalcStat("WorthTabBN",L)*1.25
										elseif SN == "WORTHTABAV" then
											if L <= 4 then
												Result = RoundDbl(3.0*L+20.0,-1)
											elseif L <= 7 then
												Result = 70.0
											elseif L <= 10 then
												Result = 140.0
											elseif L <= 13 then
												Result = 270.0
											elseif L <= 16 then
												Result = 400.0
											elseif L <= 19 then
												Result = 460.0
											elseif L <= 25 then
												Result = RoundDbl(3.0*L+447.5,-1)
											elseif L <= 46 then
												Result = RoundDbl(3.2*L+455.0,-1)
											elseif L <= 50 then
												Result = 620.0
											else
												Result = 20.0*L-360.0
											end
										elseif SN == "WORTHTABAW" then
											if L <= 1 then
												Result = 50.0
											elseif L <= 49 then
												Result = 2.5*L+102.5
											elseif L <= 80 then
												Result = 3.0*L+78.0
											elseif L <= 120 then
												Result = 2.97*L+79.5
											else
												Result = 3.0*L+75.0
											end
										end
									else
										if L <= 16 then
											Result = 10.75*L+54.0
										elseif L <= 34 then
											Result = 10.75*L+53.7
										elseif L <= 35 then
											Result = 429.0
										elseif L <= 41 then
											Result = 10.65*L+57.1
										elseif L <= 49 then
											Result = 10.68*L+56.25
										else
											Result = 12.0*L-9.0
										end
									end
								else
									if L <= 4 then
										Result = RoundDbl(3.0*L+20.0,-1)
									elseif L <= 7 then
										Result = 60.0
									elseif L <= 10 then
										Result = 100.0
									elseif L <= 13 then
										Result = 180.0
									elseif L <= 16 then
										Result = 270.0
									elseif L <= 19 then
										Result = 310.0
									elseif L <= 40 then
										Result = RoundDbl(3.2*L+274.0,-1)
									elseif L <= 43 then
										Result = 400.0
									elseif L <= 53 then
										Result = RoundDbl(1.9*L+334.0,-1)
									elseif L <= 56 then
										Result = 460.0
									elseif L <= 59 then
										Result = 480.0
									else
										Result = 20.0*L-680.0
									end
								end
							elseif SN < "WORTHTABALBASE" then
								if SN < "WORTHTABAE" then
									if SN > "WORTHTABAA" then
										if SN == "WORTHTABAB" then
											Result = 7.0*L+50.0
										elseif SN == "WORTHTABAC" then
											Result = CalcStat("WorthTabE",L)-30.0
										elseif SN == "WORTHTABAD" then
											Result = 7.0*L+100.0
										end
									elseif SN < "WORTHTABAA" then
										if SN == "WORTHMPK" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({1.0,1.2,1.3,1.35,1.4},L))
											end
										elseif SN == "WORTHMPL" then
											if 1 <= L and L <= 5 then
												Result = EquSng(DataTableValue({2.0,2.0,2.0,2.0,2.0},L))
											end
										elseif SN == "WORTHTABA" then
											if L <= 1 then
												Result = 1.0
											else
												Result = CalcStat("WorthTabAF",L)
											end
										end
									else
										Result = CalcStat("WorthTabD",L)+20.0
									end
								elseif SN > "WORTHTABAE" then
									if SN > "WORTHTABAI" then
										if SN == "WORTHTABAJ" then
											Result = CalcStat("WorthTabAH",L)
										elseif SN == "WORTHTABAK" then
											if L <= 49 then
												Result = CalcStat("WorthTabALBase",L+1)
											else
												Result = 9.0*L+78.0
											end
										elseif SN == "WORTHTABAL" then
											if L <= 49 then
												Result = CalcStat("WorthTabALBase",L)
											else
												Result = 9.0*L+69.0
											end
										end
									elseif SN < "WORTHTABAI" then
										if SN == "WORTHTABAF" then
											if L <= 49 then
												Result = 2.5*L
											else
												Result = 3.0*L-25.0
											end
										elseif SN == "WORTHTABAG" then
											Result = CalcStat("WorthTabAF",L)+25.0
										elseif SN == "WORTHTABAH" then
											if L <= 49 then
												Result = CalcStat("WorthTabALBase",L+7)-66.0
											else
												Result = 9.0*L+72.0
											end
										end
									else
										if L <= 16 then
											Result = 10.73*L+54.3
										elseif L <= 34 then
											Result = 10.735*L+54.0
										elseif L <= 35 then
											Result = 429.0
										elseif L <= 41 then
											Result = 10.65*L+57.1
										elseif L <= 49 then
											Result = 10.7*L+55.3
										else
											Result = 9.0*L+141.0
										end
									end
								else
									Result = CalcStat("WorthTabE",L)
								end
							else
								Result = 9.86*L+23.51+RoundDbl(L*0.1+0.3,0)*0.4
							end
						else
							if 1 <= L and L <= 5 then
								Result = EquSng(DataTableValue({1.0,1.0,1.0,1.0,5.0},L))
							end
						end
					else
						if L <= 50 then
							Result = 8.25*L+22.25
						else
							Result = 8.0*L+35.0
						end
					end
				elseif SN > "WORTHTABR" then
					if SN > "WORTHVALC" then
						if SN < "WORTHVALM" then
							if SN > "WORTHVALCO" then
								if SN < "WORTHVALE" then
									if SN > "WORTHVALCS" then
										if SN == "WORTHVALCT" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCT"))
										elseif SN == "WORTHVALCU" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCU"))
										elseif SN == "WORTHVALD" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabD"))
										end
									elseif SN < "WORTHVALCS" then
										if SN == "WORTHVALCP" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCP"))
										elseif SN == "WORTHVALCQ" then
											Result = EquSng(CalcStat("WorthMpK",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCQ"))
										elseif SN == "WORTHVALCR" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCR"))
										end
									else
										Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCS"))
									end
								elseif SN > "WORTHVALE" then
									if SN > "WORTHVALI" then
										if SN == "WORTHVALJ" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabJ"))
										elseif SN == "WORTHVALK" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabK"))
										elseif SN == "WORTHVALL" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabL"))
										end
									elseif SN < "WORTHVALI" then
										if SN == "WORTHVALF" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthTabF",L))
										elseif SN == "WORTHVALG" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabG"))
										elseif SN == "WORTHVALH" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabH"))
										end
									else
										Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabI"))
									end
								else
									Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabE"))
								end
							elseif SN < "WORTHVALCO" then
								if SN < "WORTHVALCG" then
									if SN > "WORTHVALCC" then
										if SN == "WORTHVALCD" then
											Result = EquSng(CalcStat("WorthMpL",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabCD"))
										elseif SN == "WORTHVALCE" then
											Result = EquSng(CalcStat("WorthMpH",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCE"))
										elseif SN == "WORTHVALCF" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabCF"))
										end
									elseif SN < "WORTHVALCC" then
										if SN == "WORTHVALCA" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCA"))
										elseif SN == "WORTHVALCB" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthTabCB",L))
										end
									else
										Result = EquSng(CalcStat("WorthMpL",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabCC"))
									end
								elseif SN > "WORTHVALCG" then
									if SN > "WORTHVALCK" then
										if SN == "WORTHVALCL" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCL"))
										elseif SN == "WORTHVALCM" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCM"))
										elseif SN == "WORTHVALCN" then
											Result = EquSng(CalcStat("WorthMpI",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCN"))
										end
									elseif SN < "WORTHVALCK" then
										if SN == "WORTHVALCH" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCH"))
										elseif SN == "WORTHVALCI" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCI"))
										elseif SN == "WORTHVALCJ" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCJ"))
										end
									else
										Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCK"))
									end
								else
									Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCG"))
								end
							else
								Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabCO"))
							end
						elseif SN > "WORTHVALM" then
							if SN > "WPNDMGMAX" then
								if SN < "WRDFINESSE" then
									if SN > "WPNDPSQTYMP" then
										if SN == "WPNDPSVARIANCETYPE" then
											if 1 <= L and L <= 3 then
												Result = EquSng(DataTableValue({0.25,0.25,0.25},L))
											end
										elseif SN == "WRDBATSTRIKESCRITDEF" then
											Result = -CalcStat("CritDefT",L,CalcStat("Trait123Choice",N)*0.4)
										elseif SN == "WRDCRITDEF" then
											Result = CalcStat("CritDefT",L,1.0)
										end
									elseif SN < "WPNDPSQTYMP" then
										if SN == "WPNDMGMIN" then
											Result = EquSng(((2.0-2.0*CalcStat("WpnDPSVarianceType",EnumIndex(C,2,"OTB")))/(2.0-CalcStat("WpnDPSVarianceType",EnumIndex(C,2,"OTB"))))*CalcStat("WpnDPS",L,C))
										elseif SN == "WPNDPS" then
											Result = EquSng(CalcStat("CombatBasePhyDPS",L,CalcStat("WpnDPSCatMP",EnumIndex(C,1,"HLNSV")*4+EnumIndex(C,2,"OTB")))*CalcStat("WpnDPSQtyMP",EnumIndex(C,3,"WYPTG")))
										elseif SN == "WPNDPSCATMP" then
											if 1 <= L and L <= 23 then
												Result = DataTableValue({1.0,1.0,1.0,1.0,1.0,1.4,1.4,1.0,0.9,1.2,1.2,1.0,1.0,1.4,1.4,1.0,0.8,0.8,0.8,1.0,0.9,1.2,1.2},L)
											end
										end
									else
										if 1 <= L and L <= 5 then
											Result = EquSng(DataTableValue({1.0,1.02,1.04,1.08,1.12},L))
										end
									end
								elseif SN > "WRDFINESSE" then
									if SN > "WRDSHIELDMASBLOCK" then
										if SN == "WRDSHIELDTACTCRITDEF" then
											Result = CalcStat("CritDefT",L,2.0)
										elseif SN == "WRDSTDYOURGRBLOCK" then
											Result = CalcStat("BlockT",L,CalcStat("Trait1234Choice",N)*0.4)
										elseif SN == "WRDSTDYOURGRPARRY" then
											Result = CalcStat("ParryT",L,CalcStat("Trait1234Choice",N)*0.4)
										end
									elseif SN < "WRDSHIELDMASBLOCK" then
										if SN == "WRDIMPRBLADESPARRY" then
											Result = CalcStat("ParryT",L,2.8)
										elseif SN == "WRDPHYMAS" then
											Result = CalcStat("PhyMasT",L,CalcStat("Trait123455Choice",N)*0.4)
										elseif SN == "WRDRECKLESSNCRITHIT" then
											Result = CalcStat("CritHitT",L,2.4)
										end
									else
										Result = CalcStat("BlockT",L,2.8)
									end
								else
									Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4)
								end
							elseif SN < "WPNDMGMAX" then
								if SN < "WORTHVALU" then
									if SN > "WORTHVALQ" then
										if SN == "WORTHVALR" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabR"))
										elseif SN == "WORTHVALS" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabS"))
										elseif SN == "WORTHVALT" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt8Lin",L,"WorthTabT"))
										end
									elseif SN < "WORTHVALQ" then
										if SN == "WORTHVALN" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabN"))
										elseif SN == "WORTHVALO" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabO"))
										elseif SN == "WORTHVALP" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabP"))
										end
									else
										Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabQ"))
									end
								elseif SN > "WORTHVALU" then
									if SN > "WORTHVALY" then
										if SN == "WORTHVALZ" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabZ"))
										elseif SN == "WOUNDRESIST" then
											Result = CalcStat("ResistAdd",L,N)
										elseif SN == "WOUNDRESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										end
									elseif SN < "WORTHVALY" then
										if SN == "WORTHVALV" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabV"))
										elseif SN == "WORTHVALW" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabW"))
										elseif SN == "WORTHVALX" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabX"))
										end
									else
										Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabY"))
									end
								else
									Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabU"))
								end
							else
								Result = EquSng((2.0/(2.0-CalcStat("WpnDPSVarianceType",EnumIndex(C,2,"OTB"))))*CalcStat("WpnDPS",L,C))
							end
						else
							Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabM"))
						end
					elseif SN < "WORTHVALC" then
						if SN < "WORTHVALAV" then
							if SN > "WORTHVALAF" then
								if SN < "WORTHVALAN" then
									if SN > "WORTHVALAJ" then
										if SN == "WORTHVALAK" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt8Lin",L,"WorthTabAK"))
										elseif SN == "WORTHVALAL" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt8Lin",L,"WorthTabAL"))
										elseif SN == "WORTHVALAM" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAM"))
										end
									elseif SN < "WORTHVALAJ" then
										if SN == "WORTHVALAG" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAG"))
										elseif SN == "WORTHVALAH" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt8Lin",L,"WorthTabAH"))
										elseif SN == "WORTHVALAI" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt8Lin",L,"WorthTabAI"))
										end
									else
										Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt8Lin",L,"WorthTabAJ"))
									end
								elseif SN > "WORTHVALAN" then
									if SN > "WORTHVALAR" then
										if SN == "WORTHVALAS" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAS"))
										elseif SN == "WORTHVALAT" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAT"))
										elseif SN == "WORTHVALAU" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAU"))
										end
									elseif SN < "WORTHVALAR" then
										if SN == "WORTHVALAO" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAO"))
										elseif SN == "WORTHVALAP" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAP"))
										elseif SN == "WORTHVALAQ" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAQ"))
										end
									else
										Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAR"))
									end
								else
									Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAN"))
								end
							elseif SN < "WORTHVALAF" then
								if SN < "WORTHTABY" then
									if SN > "WORTHTABU" then
										if SN == "WORTHTABV" then
											Result = CalcStat("WorthTabB",L)-2.75
										elseif SN == "WORTHTABW" then
											Result = CalcStat("WorthTabD",L)+25.0
										elseif SN == "WORTHTABX" then
											Result = CalcStat("WorthTabAF",L)+75.0
										end
									elseif SN < "WORTHTABU" then
										if SN == "WORTHTABS" then
											Result = CalcStat("WorthTabD",L)+17.5
										elseif SN == "WORTHTABT" then
											if L <= 1 then
												Result = 54.0
											elseif L <= 17 then
												Result = 10.73*L+43.57
											elseif L <= 35 then
												Result = 10.735*L+43.265
											elseif L <= 36 then
												Result = 429.0
											elseif L <= 42 then
												Result = 10.65*L+46.45
											elseif L <= 49 then
												Result = 10.7*L+44.6
											else
												Result = 9.0*L+130.0
											end
										end
									else
										if L <= 10 then
											Result = 9.0*L+20.0
										elseif L <= 49 then
											Result = 5.5*L+55.0
										else
											Result = 6.0*L+30.0
										end
									end
								elseif SN > "WORTHTABY" then
									if SN > "WORTHVALAB" then
										if SN == "WORTHVALAC" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAC"))
										elseif SN == "WORTHVALAD" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAD"))
										elseif SN == "WORTHVALAE" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAE"))
										end
									elseif SN < "WORTHVALAB" then
										if SN == "WORTHTABZ" then
											Result = CalcStat("WorthTabR",L)-15.0
										elseif SN == "WORTHVALA" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabA"))
										elseif SN == "WORTHVALAA" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAA"))
										end
									else
										Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAB"))
									end
								else
									Result = CalcStat("WorthTabD",L)+30.0
								end
							else
								Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAF"))
							end
						elseif SN > "WORTHVALAV" then
							if SN > "WORTHVALBK" then
								if SN < "WORTHVALBS" then
									if SN > "WORTHVALBO" then
										if SN == "WORTHVALBP" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBP"))
										elseif SN == "WORTHVALBQ" then
											Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBQ"))
										elseif SN == "WORTHVALBR" then
											Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBR"))
										end
									elseif SN < "WORTHVALBO" then
										if SN == "WORTHVALBL" then
											Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBL"))
										elseif SN == "WORTHVALBM" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBM"))
										elseif SN == "WORTHVALBN" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBN"))
										end
									else
										Result = EquSng(CalcStat("WorthMpG",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBO"))
									end
								elseif SN > "WORTHVALBS" then
									if SN > "WORTHVALBW" then
										if SN == "WORTHVALBX" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBX"))
										elseif SN == "WORTHVALBY" then
											Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBY"))
										elseif SN == "WORTHVALBZ" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBZ"))
										end
									elseif SN < "WORTHVALBW" then
										if SN == "WORTHVALBT" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBT"))
										elseif SN == "WORTHVALBU" then
											Result = EquSng(CalcStat("WorthMpF",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBU"))
										elseif SN == "WORTHVALBV" then
											Result = EquSng(CalcStat("WorthMpD",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBV"))
										end
									else
										Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBW"))
									end
								else
									Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBS"))
								end
							elseif SN < "WORTHVALBK" then
								if SN < "WORTHVALBC" then
									if SN > "WORTHVALAZ" then
										if SN == "WORTHVALB" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabB"))
										elseif SN == "WORTHVALBA" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBA"))
										elseif SN == "WORTHVALBB" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBB"))
										end
									elseif SN < "WORTHVALAZ" then
										if SN == "WORTHVALAW" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAW"))
										elseif SN == "WORTHVALAX" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAX"))
										elseif SN == "WORTHVALAY" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabAY"))
										end
									else
										Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabAZ"))
									end
								elseif SN > "WORTHVALBC" then
									if SN > "WORTHVALBG" then
										if SN == "WORTHVALBH" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBH"))
										elseif SN == "WORTHVALBI" then
											Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBI"))
										elseif SN == "WORTHVALBJ" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBJ"))
										end
									elseif SN < "WORTHVALBG" then
										if SN == "WORTHVALBD" then
											Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBD"))
										elseif SN == "WORTHVALBE" then
											Result = EquSng(CalcStat("WorthMpJ",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBE"))
										elseif SN == "WORTHVALBF" then
											Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBF"))
										end
									else
										Result = EquSng(CalcStat("WorthMpA",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBG"))
									end
								else
									Result = EquSng(CalcStat("WorthMpE",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabBC"))
								end
							else
								Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt4Lin",L,"WorthTabBK"))
							end
						else
							Result = EquSng(CalcStat("WorthMpC",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabAV"))
						end
					else
						Result = EquSng(CalcStat("WorthMpB",EnumIndex(C,1,"WYPTG"))*CalcStat("WorthExt",L,"WorthTabC"))
					end
				else
					if L <= 9 then
						Result = 12.0*L+30.0
					else
						Result = 7.0*L+75.0
					end
				end
			elseif SN < "WARDENCDWILLTOTACMIT" then
				if SN < "VIRTZEALVPPHYMAS" then
					if SN > "VIRTFIDELITYVPMORALE" then
						if SN < "VIRTMERCYFATE" then
							if SN > "VIRTIDEALISMINHEAL" then
								if SN < "VIRTJUSTICEMORALE" then
									if SN > "VIRTINNOCENCERESIST" then
										if SN == "VIRTINNOCENCETACMIT" then
											Result = CalcStat("VSTacMitL",L)
										elseif SN == "VIRTINNOCENCEVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTJUSTICEICMR" then
											Result = CalcStat("VSICMRH",L)
										end
									elseif SN < "VIRTINNOCENCERESIST" then
										if SN == "VIRTIDEALISMMORALE" then
											Result = CalcStat("VSMoraleL",L)
										elseif SN == "VIRTIDEALISMVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTINNOCENCEPHYMIT" then
											Result = CalcStat("VSPhyMitH",L)
										end
									else
										Result = CalcStat("VSResistM",L)
									end
								elseif SN > "VIRTJUSTICEMORALE" then
									if SN > "VIRTLOYALTYINHEAL" then
										if SN == "VIRTLOYALTYVITALITY" then
											Result = CalcStat("VSVitalityH",L)
										elseif SN == "VIRTLOYALTYVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTMERCYEVADE" then
											Result = CalcStat("VSEvadeH",L)
										end
									elseif SN < "VIRTLOYALTYINHEAL" then
										if SN == "VIRTJUSTICETACMIT" then
											Result = CalcStat("VSTacMitL",L)
										elseif SN == "VIRTJUSTICEVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTLOYALTYARMOUR" then
											Result = CalcStat("VSArmourM",L)
										end
									else
										Result = CalcStat("VSInHealL",L)
									end
								else
									Result = CalcStat("VSMoraleM",L)
								end
							elseif SN < "VIRTIDEALISMINHEAL" then
								if SN < "VIRTHONESTYVPPHYMAS" then
									if SN > "VIRTFORTITUDERESIST" then
										if SN == "VIRTFORTITUDEVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTHONESTYCRITHIT" then
											Result = CalcStat("VSCritHitL",L)
										elseif SN == "VIRTHONESTYTACMAS" then
											Result = CalcStat("VSTacMasH",L)
										end
									elseif SN < "VIRTFORTITUDERESIST" then
										if SN == "VIRTFORTITUDECRITDEF" then
											Result = CalcStat("VSCritDefM",L)
										elseif SN == "VIRTFORTITUDEMORALE" then
											Result = CalcStat("VSMoraleH",L)
										end
									else
										Result = CalcStat("VSResistL",L)
									end
								elseif SN > "VIRTHONESTYVPPHYMAS" then
									if SN > "VIRTHONOURMORALE" then
										if SN == "VIRTHONOURTACMIT" then
											Result = CalcStat("VSTacMitM",L)
										elseif SN == "VIRTHONOURVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTIDEALISMFATE" then
											Result = CalcStat("VSFateH",L)
										end
									elseif SN < "VIRTHONOURMORALE" then
										if SN == "VIRTHONESTYVPTACMAS" then
											Result = CalcStat("VSVPTacMas",L)
										elseif SN == "VIRTHONESTYWILL" then
											Result = CalcStat("VSWillM",L)
										elseif SN == "VIRTHONOURCRITDEF" then
											Result = CalcStat("VSCritDefL",L)
										end
									else
										Result = CalcStat("VSMoraleH",L)
									end
								else
									Result = CalcStat("VSVPPhyMas",L)
								end
							else
								Result = CalcStat("VSInHealM",L)
							end
						elseif SN > "VIRTMERCYFATE" then
							if SN > "VIRTVALOURVPPHYMAS" then
								if SN < "VIRTWITFINESSE" then
									if SN > "VIRTWISDOMVPPHYMAS" then
										if SN == "VIRTWISDOMVPTACMAS" then
											Result = CalcStat("VSVPTacMas",L)
										elseif SN == "VIRTWISDOMWILL" then
											Result = CalcStat("VSWillH",L)
										elseif SN == "VIRTWITCRITHIT" then
											Result = CalcStat("VSCritHitM",L)
										end
									elseif SN < "VIRTWISDOMVPPHYMAS" then
										if SN == "VIRTVALOURVPTACMAS" then
											Result = CalcStat("VSVPTacMas",L)
										elseif SN == "VIRTWISDOMFINESSE" then
											Result = CalcStat("VSFinesseL",L)
										elseif SN == "VIRTWISDOMTACMAS" then
											Result = CalcStat("VSTacMasM",L)
										end
									else
										Result = CalcStat("VSVPPhyMas",L)
									end
								elseif SN > "VIRTWITFINESSE" then
									if SN > "VIRTWITVPTACMAS" then
										if SN == "VIRTZEALCRITHIT" then
											Result = CalcStat("VSCritHitL",L)
										elseif SN == "VIRTZEALMIGHT" then
											Result = CalcStat("VSMightH",L)
										elseif SN == "VIRTZEALPHYMAS" then
											Result = CalcStat("VSPhyMasM",L)
										end
									elseif SN < "VIRTWITVPTACMAS" then
										if SN == "VIRTWITPHYMAS" then
											Result = CalcStat("VSPhyMasL",L)
										elseif SN == "VIRTWITTACMAS" then
											Result = CalcStat("VSTacMasL",L)
										elseif SN == "VIRTWITVPPHYMAS" then
											Result = CalcStat("VSVPPhyMas",L)
										end
									else
										Result = CalcStat("VSVPTacMas",L)
									end
								else
									Result = CalcStat("VSFinesseH",L)
								end
							elseif SN < "VIRTVALOURVPPHYMAS" then
								if SN < "VIRTRNKCOSTTOT" then
									if SN > "VIRTPATIENCEEVADE" then
										if SN == "VIRTPATIENCEPOWER" then
											Result = CalcStat("VSPowerH",L)
										elseif SN == "VIRTPATIENCEVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTRNKCOST" then
											if L <= 0 then
												Result = 0
											elseif L <= 10 then
												Result = 1000
											elseif L <= 60 then
												Result = RoundDblDown(RoundDbl(18.0*L+878.0,-2))
											elseif L <= 73 then
												Result = RoundDblDown(RoundDbl(18.75*L+878.0,-2))
											elseif L <= 90 then
												Result = RoundDblDown(RoundDbl(17.45*L+878.0,-2))
											else
												Result = 2500
											end
										end
									elseif SN < "VIRTPATIENCEEVADE" then
										if SN == "VIRTMERCYVITALITY" then
											Result = CalcStat("VSVitalityL",L)
										elseif SN == "VIRTMERCYVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTPATIENCECRITHIT" then
											Result = CalcStat("VSCritHitL",L)
										end
									else
										Result = CalcStat("VSEvadeM",L)
									end
								elseif SN > "VIRTRNKCOSTTOT" then
									if SN > "VIRTTOLERANCEVPMORALE" then
										if SN == "VIRTVALOURCRITHIT" then
											Result = CalcStat("VSCritHitL",L)
										elseif SN == "VIRTVALOURFINESSE" then
											Result = CalcStat("VSFinesseM",L)
										elseif SN == "VIRTVALOURPHYMAS" then
											Result = CalcStat("VSPhyMasH",L)
										end
									elseif SN < "VIRTTOLERANCEVPMORALE" then
										if SN == "VIRTTOLERANCEPHYMIT" then
											Result = CalcStat("VSPhyMitL",L)
										elseif SN == "VIRTTOLERANCERESIST" then
											Result = CalcStat("VSResistM",L)
										elseif SN == "VIRTTOLERANCETACMIT" then
											Result = CalcStat("VSTacMitH",L)
										end
									else
										Result = CalcStat("VSVPMorale",L)
									end
								else
									if L <= 0 then
										Result = 0
									elseif 1 <= L then
										Result = CalcStat("VirtRnkCostTot",L-1)+CalcStat("VirtRnkCost",L)
									end
								end
							else
								Result = CalcStat("VSVPPhyMas",L)
							end
						else
							Result = CalcStat("VSFateM",L)
						end
					elseif SN < "VIRTFIDELITYVPMORALE" then
						if SN < "TRAITPNTS" then
							if SN > "TOMEVITALITY" then
								if SN < "TRAIT1234CHOICE" then
									if SN > "TPENCHOICE" then
										if SN == "TPENRESIST" then
											Result = -CalcStat("ResistT",L,CalcStat("TpenChoice",N)*2.0)
										elseif SN == "TRAIT123455CHOICE" then
											if 1 <= L and L <= 6 then
												Result = DataTableValue({1.0,2.0,3.0,4.0,5.0,5.0},L)
											end
										elseif SN == "TRAIT12345CHOICE" then
											if 1 <= L and L <= 5 then
												Result = DataTableValue({1.0,2.0,3.0,4.0,5.0},L)
											end
										end
									elseif SN < "TPENCHOICE" then
										if SN == "TOMEVITALITYDEC" then
											Result = CalcStat("TomeTotalVitalityDec",L)-CalcStat("TomeTotalVitalityDec",L-1)
										elseif SN == "TPENARMOUR" then
											Result = -CalcStat("ArmourPenT",L,CalcStat("TpenChoice",N))
										elseif SN == "TPENBPE" then
											Result = -CalcStat("BPET",L,CalcStat("TpenChoice",N))
										end
									else
										if 1 <= L then
											Result = DataTableValue({0.5,1.0,2.0},L)
										end
									end
								elseif SN > "TRAIT1234CHOICE" then
									if SN > "TRAIT357912CHOICE" then
										if SN == "TRAIT47101316CHOICE" then
											if 1 <= L and L <= 5 then
												Result = DataTableValue({4.0,7.0,10.0,13.0,16.0},L)
											end
										elseif SN == "TRAIT567810CHOICE" then
											if 1 <= L and L <= 5 then
												Result = DataTableValue({5.0,6.0,7.0,8.0,10.0},L)
											end
										elseif SN == "TRAIT58121620CHOICE" then
											if 1 <= L and L <= 5 then
												Result = DataTableValue({5.0,8.0,12.0,16.0,20.0},L)
											end
										end
									elseif SN < "TRAIT357912CHOICE" then
										if SN == "TRAIT123CHOICE" then
											if 1 <= L and L <= 3 then
												Result = DataTableValue({1.0,2.0,3.0},L)
											end
										elseif SN == "TRAIT13510CHOICE" then
											if 1 <= L and L <= 4 then
												Result = DataTableValue({1.0,3.0,5.0,10.0},L)
											end
										elseif SN == "TRAIT234CHOICE" then
											if 1 <= L and L <= 3 then
												Result = DataTableValue({2.0,3.0,4.0},L)
											end
										end
									else
										if 1 <= L and L <= 5 then
											Result = DataTableValue({3.0,5.0,7.0,9.0,12.0},L)
										end
									end
								else
									if 1 <= L and L <= 4 then
										Result = DataTableValue({1.0,2.0,3.0,4.0},L)
									end
								end
							elseif SN < "TOMEVITALITY" then
								if SN < "TOMEMAINDEC" then
									if SN > "TACRESISTT" then
										if SN == "TOMEFATE" then
											Result = CalcStat("TomeFateDec",RomanRankDecode(C))
										elseif SN == "TOMEFATEDEC" then
											Result = CalcStat("TomeTotalFateDec",L)-CalcStat("TomeTotalFateDec",L-1)
										elseif SN == "TOMEMAIN" then
											Result = CalcStat("TomeMainDec",RomanRankDecode(C))
										end
									elseif SN < "TACRESISTT" then
										if SN == "TACMITT" then
											Result = EquSng(StatLinInter("PntMPTacMit","TraitPntS","MitMediumPRatPB","AdjTraitMit",L,N,2))
										elseif SN == "TACRESIST" then
											Result = CalcStat("ResistAdd",L,N)
										end
									else
										Result = CalcStat("ResistAddT",L,N)
									end
								elseif SN > "TOMEMAINDEC" then
									if SN > "TOMETOTALMAIN" then
										if SN == "TOMETOTALMAINDEC" then
											Result = CalcStat("MainT",CalcStat("TomeTotalLevel",L),2.0)
										elseif SN == "TOMETOTALVITALITY" then
											Result = CalcStat("TomeTotalVitalityDec",RomanRankDecode(C))
										elseif SN == "TOMETOTALVITALITYDEC" then
											Result = CalcStat("VitalityT",CalcStat("TomeTotalLevel",L),2.0)
										end
									elseif SN < "TOMETOTALMAIN" then
										if SN == "TOMETOTALFATE" then
											Result = CalcStat("TomeTotalFateDec",RomanRankDecode(C))
										elseif SN == "TOMETOTALFATEDEC" then
											Result = CalcStat("FateT",CalcStat("TomeTotalLevel",L),2.0)
										elseif SN == "TOMETOTALLEVEL" then
											if 1 <= L and L <= 23 then
												Result = DataTableValue({4,15,27,38,48,54,60,63,67,71,75,78,85,90,95,98,101,104,106,110,114,116,121},L)
											end
										end
									else
										Result = CalcStat("TomeTotalMainDec",RomanRankDecode(C))
									end
								else
									Result = CalcStat("TomeTotalMainDec",L)-CalcStat("TomeTotalMainDec",L-1)
								end
							else
								Result = CalcStat("TomeVitalityDec",RomanRankDecode(C))
							end
						elseif SN > "TRAITPNTS" then
							if SN > "VIRTDETERMINATIONAGILITY" then
								if SN < "VIRTDISCIPLINEVPMORALE" then
									if SN > "VIRTDETERMINATIONVPTACMAS" then
										if SN == "VIRTDISCIPLINEINHEAL" then
											Result = CalcStat("VSInHealM",L)
										elseif SN == "VIRTDISCIPLINEPHYMIT" then
											Result = CalcStat("VSPhyMitL",L)
										elseif SN == "VIRTDISCIPLINERESIST" then
											Result = CalcStat("VSResistH",L)
										end
									elseif SN < "VIRTDETERMINATIONVPTACMAS" then
										if SN == "VIRTDETERMINATIONCRITHIT" then
											Result = CalcStat("VSCritHitL",L)
										elseif SN == "VIRTDETERMINATIONPHYMAS" then
											Result = CalcStat("VSPhyMasM",L)
										elseif SN == "VIRTDETERMINATIONVPPHYMAS" then
											Result = CalcStat("VSVPPhyMas",L)
										end
									else
										Result = CalcStat("VSVPTacMas",L)
									end
								elseif SN > "VIRTDISCIPLINEVPMORALE" then
									if SN > "VIRTEMPATHYVPMORALE" then
										if SN == "VIRTFIDELITYPHYMIT" then
											Result = CalcStat("VSPhyMitL",L)
										elseif SN == "VIRTFIDELITYTACMIT" then
											Result = CalcStat("VSTacMitH",L)
										elseif SN == "VIRTFIDELITYVITALITY" then
											Result = CalcStat("VSVitalityM",L)
										end
									elseif SN < "VIRTEMPATHYVPMORALE" then
										if SN == "VIRTEMPATHYARMOUR" then
											Result = CalcStat("VSArmourH",L)
										elseif SN == "VIRTEMPATHYCRITDEF" then
											Result = CalcStat("VSCritDefM",L)
										elseif SN == "VIRTEMPATHYRESIST" then
											Result = CalcStat("VSResistL",L)
										end
									else
										Result = CalcStat("VSVPMorale",L)
									end
								else
									Result = CalcStat("VSVPMorale",L)
								end
							elseif SN < "VIRTDETERMINATIONAGILITY" then
								if SN < "VIRTCOMPASSIONPHYMIT" then
									if SN > "VIRTCHARITYRESIST" then
										if SN == "VIRTCHARITYVITALITY" then
											Result = CalcStat("VSVitalityL",L)
										elseif SN == "VIRTCHARITYVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTCOMPASSIONARMOUR" then
											Result = CalcStat("VSArmourL",L)
										end
									elseif SN < "VIRTCHARITYRESIST" then
										if SN == "TRAITPNTSVITAL" then
											Result = {{1,25,50,60,65,75,85,95,100,105,115,120,130,140,141,150,151,160,161,170},{1,25,50,60,65,75,85,95,100,105,115,120,130,140,141,150,151,160,161,170}}
										elseif SN == "VARMOUR" then
											Result = RoundDbl(StatLinInter("PntMPArmourVirtues","ItemPntS","MitLightPRatPB","AdjItemMit",L,N,2),0)
										elseif SN == "VIRTCHARITYPHYMIT" then
											Result = CalcStat("VSPhyMitM",L)
										end
									else
										Result = CalcStat("VSResistH",L)
									end
								elseif SN > "VIRTCOMPASSIONPHYMIT" then
									if SN > "VIRTCONFIDENCEEVADE" then
										if SN == "VIRTCONFIDENCEFINESSE" then
											Result = CalcStat("VSFinesseM",L)
										elseif SN == "VIRTCONFIDENCEVPPHYMAS" then
											Result = CalcStat("VSVPPhyMas",L)
										elseif SN == "VIRTCONFIDENCEVPTACMAS" then
											Result = CalcStat("VSVPTacMas",L)
										end
									elseif SN < "VIRTCONFIDENCEEVADE" then
										if SN == "VIRTCOMPASSIONTACMIT" then
											Result = CalcStat("VSTacMitM",L)
										elseif SN == "VIRTCOMPASSIONVPMORALE" then
											Result = CalcStat("VSVPMorale",L)
										elseif SN == "VIRTCONFIDENCECRITHIT" then
											Result = CalcStat("VSCritHitH",L)
										end
									else
										Result = CalcStat("VSEvadeL",L)
									end
								else
									Result = CalcStat("VSPhyMitH",L)
								end
							else
								Result = CalcStat("VSAgilityH",L)
							end
						else
							Result = {{1,25,50,60,65,75,85,95,100,105,115,120,130,131,140,141,150,151,160},{1,25,50,60,65,75,85,95,100,105,115,120,130,131,140,141,150,151,160}}
						end
					else
						Result = CalcStat("VSVPMorale",L)
					end
				elseif SN > "VIRTZEALVPPHYMAS" then
					if SN > "VSRESISTL" then
						if SN < "WARDENCDBASEICPR" then
							if SN > "VSWILLL" then
								if SN < "WARDENCDAGILITYTOTACMIT" then
									if SN > "WARDENCDAGILITYTOOUTHEAL" then
										if SN == "WARDENCDAGILITYTOPARRY" then
											Result = 1.0
										elseif SN == "WARDENCDAGILITYTOPHYMAS" then
											Result = 3.0
										elseif SN == "WARDENCDAGILITYTOPHYMIT" then
											Result = 1.0
										end
									elseif SN < "WARDENCDAGILITYTOOUTHEAL" then
										if SN == "VSWILLM" then
											Result = CalcStat("VMMedium",L,"Will")
										elseif SN == "WARDENCDAGILITYTOBLOCK" then
											Result = 2.0
										elseif SN == "WARDENCDAGILITYTOCRITHIT" then
											Result = 1.0
										end
									else
										Result = 3.0
									end
								elseif SN > "WARDENCDAGILITYTOTACMIT" then
									if SN > "WARDENCDARMOURTYPE" then
										if SN == "WARDENCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityH",L)
										elseif SN == "WARDENCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										elseif SN == "WARDENCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRH",L)
										end
									elseif SN < "WARDENCDARMOURTYPE" then
										if SN == "WARDENCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "WARDENCDARMOURTONONPHYMIT" then
											Result = 0.2
										elseif SN == "WARDENCDARMOURTOTACMIT" then
											Result = 0.2
										end
									else
										Result = 2
									end
								else
									Result = 1.0
								end
							elseif SN < "VSWILLL" then
								if SN < "VSTACMITM" then
									if SN > "VSTACMASL" then
										if SN == "VSTACMASM" then
											Result = CalcStat("VMMedium",L,"TacMas")
										elseif SN == "VSTACMITH" then
											Result = CalcStat("VMHigh",L,"TacMit")
										elseif SN == "VSTACMITL" then
											Result = CalcStat("VMLow",L,"TacMit")
										end
									elseif SN < "VSTACMASL" then
										if SN == "VSRESISTM" then
											Result = CalcStat("VMMedium",L,"Resist")
										elseif SN == "VSTACMASH" then
											Result = CalcStat("VMHigh",L,"TacMas")
										end
									else
										Result = CalcStat("VMLow",L,"TacMas")
									end
								elseif SN > "VSTACMITM" then
									if SN > "VSVPMORALE" then
										if SN == "VSVPPHYMAS" then
											Result = CalcStat("VMMasteryPsv",L)
										elseif SN == "VSVPTACMAS" then
											Result = CalcStat("VMMasteryPsv",L)
										elseif SN == "VSWILLH" then
											Result = CalcStat("VMHigh",L,"Will")
										end
									elseif SN < "VSVPMORALE" then
										if SN == "VSVITALITYH" then
											Result = CalcStat("VMHigh",L,"Vitality")
										elseif SN == "VSVITALITYL" then
											Result = CalcStat("VMLow",L,"Vitality")
										elseif SN == "VSVITALITYM" then
											Result = CalcStat("VMMedium",L,"Vitality")
										end
									else
										Result = CalcStat("VMMoralePsv",L)
									end
								else
									Result = CalcStat("VMMedium",L,"TacMit")
								end
							else
								Result = CalcStat("VMLow",L,"Will")
							end
						elseif SN > "WARDENCDBASEICPR" then
							if SN > "WARDENCDMIGHTTOBLOCK" then
								if SN < "WARDENCDVITALITYTOICMR" then
									if SN > "WARDENCDMIGHTTOPHYMAS" then
										if SN == "WARDENCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "WARDENCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "WARDENCDTACMASTOOUTHEAL" then
											Result = 1.0
										end
									elseif SN < "WARDENCDMIGHTTOPHYMAS" then
										if SN == "WARDENCDMIGHTTOCRITHIT" then
											Result = 1.5
										elseif SN == "WARDENCDMIGHTTOFINESSE" then
											Result = 1.5
										elseif SN == "WARDENCDMIGHTTOOUTHEAL" then
											Result = 2.0
										end
									else
										Result = 2.0
									end
								elseif SN > "WARDENCDVITALITYTOICMR" then
									if SN > "WARDENCDWILLTOOUTHEAL" then
										if SN == "WARDENCDWILLTOPHYMAS" then
											Result = 1.0
										elseif SN == "WARDENCDWILLTOPHYMIT" then
											Result = 1.5
										elseif SN == "WARDENCDWILLTORESIST" then
											Result = 1.0
										end
									elseif SN < "WARDENCDWILLTOOUTHEAL" then
										if SN == "WARDENCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "WARDENCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "WARDENCDWILLTOFINESSE" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								else
									Result = 0.012
								end
							elseif SN < "WARDENCDMIGHTTOBLOCK" then
								if SN < "WARDENCDCALCTYPECOMPHYMIT" then
									if SN > "WARDENCDBASENCPR" then
										if SN == "WARDENCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										elseif SN == "WARDENCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										elseif SN == "WARDENCDBASEWILL" then
											Result = CalcStat("ClassBaseWillL",L)
										end
									elseif SN < "WARDENCDBASENCPR" then
										if SN == "WARDENCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										elseif SN == "WARDENCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										elseif SN == "WARDENCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRH",L)
										end
									else
										Result = CalcStat("ClassBaseNCPR",L)
									end
								elseif SN > "WARDENCDCALCTYPECOMPHYMIT" then
									if SN > "WARDENCDFATETOICPR" then
										if SN == "WARDENCDFATETONCPR" then
											Result = 0.15
										elseif SN == "WARDENCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "WARDENCDHASPOWER" then
											Result = 1
										end
									elseif SN < "WARDENCDFATETOICPR" then
										if SN == "WARDENCDCALCTYPENONPHYMIT" then
											Result = 13
										elseif SN == "WARDENCDCALCTYPETACMIT" then
											Result = 26
										elseif SN == "WARDENCDCANBLOCK" then
											Result = 1
										end
									else
										Result = 0.015
									end
								else
									Result = 13
								end
							else
								Result = 1.0
							end
						else
							Result = CalcStat("ClassBaseICPR",L)
						end
					elseif SN < "VSRESISTL" then
						if SN < "VSCRITHITM" then
							if SN > "VPSVMORALE" then
								if SN < "VSARMOURH" then
									if SN > "VRNKTOILVL" then
										if SN == "VSAGILITYH" then
											Result = CalcStat("VMHigh",L,"Agility")
										elseif SN == "VSAGILITYL" then
											Result = CalcStat("VMLow",L,"Agility")
										elseif SN == "VSAGILITYM" then
											Result = CalcStat("VMMedium",L,"Agility")
										end
									elseif SN < "VRNKTOILVL" then
										if SN == "VPSVMORALEADJ" then
											if 550 <= L and L <= 599 then
												Result = 1.39/1.5
											elseif 600 <= L and L <= 649 then
												Result = 1.35/1.5
											else
												Result = CalcStat("AdjVirtueMorale",L)
											end
										elseif SN == "VRNKCAP" then
											Result = 100
										elseif SN == "VRNKLVLCAP" then
											if L <= 4 then
												Result = 2.0
											elseif L <= 110 then
												Result = RoundDblDown(L/2.0,0)
											elseif L <= 139 then
												Result = 1.0*L-55.0
											elseif L <= 140 then
												Result = 1.0*L-54.0
											elseif L <= 149 then
												Result = 1.0*L-53.0
											elseif L <= 150 then
												Result = 1.0*L-52.0
											elseif L <= 159 then
												Result = RoundDbl(LinFmod(1.0,97.6,105.0,151,159,L),0)
											else
												Result = 108.0
											end
										end
									else
										if 1 <= L and L <= 160 then
											Result = RoundDbl(LinInter({{1,38,48,49,50,51,52,53,55,68,160},{4,78,178,190,210,222,236,260,292,396,856}},L))
										end
									end
								elseif SN > "VSARMOURH" then
									if SN > "VSCRITDEFL" then
										if SN == "VSCRITDEFM" then
											Result = CalcStat("VMMedium",L,"CritDef")
										elseif SN == "VSCRITHITH" then
											Result = CalcStat("VMHigh",L,"CritHit")
										elseif SN == "VSCRITHITL" then
											Result = CalcStat("VMLow",L,"CritHit")
										end
									elseif SN < "VSCRITDEFL" then
										if SN == "VSARMOURL" then
											Result = CalcStat("VMLow",L,"Varmour")
										elseif SN == "VSARMOURM" then
											Result = CalcStat("VMMedium",L,"Varmour")
										elseif SN == "VSCRITDEFH" then
											Result = CalcStat("VMHigh",L,"CritDef")
										end
									else
										Result = CalcStat("VMLow",L,"CritDef")
									end
								else
									Result = CalcStat("VMHigh",L,"Varmour")
								end
							elseif SN < "VPSVMORALE" then
								if SN < "VMASTERY" then
									if SN > "VITALITYC" then
										if SN == "VITALITYCI" then
											Result = RoundDblLotro(StatLinInter("PntMPVitalityC","ItemPntSVital","ProgBHealth","AdjCreepHealth",L,N))
										elseif SN == "VITALITYCILVLFILTER" then
											Result = TranslateValue({0},{570},N)
										elseif SN == "VITALITYT" then
											Result = RoundDblDown(StatLinInter("PntMPVitalityT","TraitPntSVital","ProgBHealth","AdjTraitHealth",L,N,2),0)
										end
									elseif SN < "VITALITYC" then
										if SN == "VIRTZEALVPTACMAS" then
											Result = CalcStat("VSVPTacMas",L)
										elseif SN == "VITALITY" then
											Result = RoundDblDown(StatLinInter("PntMPVitality","ItemPntSVital","ProgBHealth","AdjItemHealth",L,N,2),0)
										end
									else
										Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("VitalityCI",CalcStat("VitalityCILvlFilter",L,N),N),2)
									end
								elseif SN > "VMASTERY" then
									if SN > "VMMASTERYPSV" then
										if SN == "VMMEDIUM" then
											if 1 <= L then
												Result = CalcStat(C,CalcStat("VRnkToILvl",L),1.0)
											end
										elseif SN == "VMMORALEPSV" then
											if 1 <= L then
												Result = CalcStat("VPsvMorale",CalcStat("VRnkToILvl",L),0.3)
											end
										elseif SN == "VMORALE" then
											Result = EquSng(StatLinInter("PntMPMoraleVirtues","ItemPntSVirtueMorale","ProgBHealth","AdjVirtueMorale",L,N,2))
										end
									elseif SN < "VMMASTERYPSV" then
										if SN == "VMASTERYOLD" then
											Result = CalcStat("VMastery",L,N)
										elseif SN == "VMHIGH" then
											if 1 <= L then
												Result = CalcStat(C,CalcStat("VRnkToILvl",L),2.0)
											end
										elseif SN == "VMLOW" then
											if 1 <= L then
												Result = CalcStat(C,CalcStat("VRnkToILvl",L),0.6)
											end
										end
									else
										if 1 <= L then
											Result = CalcStat("VMastery",CalcStat("VRnkToILvl",L),0.2)
										end
									end
								else
									Result = EquSng(StatLinInter("PntMPMastery","ItemPntSVirtueMastery","OutDmgPRatPB","AdjVirtueMas",L,N,2))
								end
							else
								Result = EquSng(StatLinInter("PntMPMoraleVirtues","ItemPntSVirtueMorale","ProgBHealth","VPsvMoraleAdj",L,N,2))
							end
						elseif SN > "VSCRITHITM" then
							if SN > "VSMIGHTH" then
								if SN < "VSPHYMASM" then
									if SN > "VSMORALEL" then
										if SN == "VSMORALEM" then
											Result = CalcStat("VMMedium",L,"VMorale")
										elseif SN == "VSPHYMASH" then
											Result = CalcStat("VMHigh",L,"PhyMas")
										elseif SN == "VSPHYMASL" then
											Result = CalcStat("VMLow",L,"PhyMas")
										end
									elseif SN < "VSMORALEL" then
										if SN == "VSMIGHTL" then
											Result = CalcStat("VMLow",L,"Might")
										elseif SN == "VSMIGHTM" then
											Result = CalcStat("VMMedium",L,"Might")
										elseif SN == "VSMORALEH" then
											Result = CalcStat("VMHigh",L,"VMorale")
										end
									else
										Result = CalcStat("VMLow",L,"VMorale")
									end
								elseif SN > "VSPHYMASM" then
									if SN > "VSPOWERH" then
										if SN == "VSPOWERL" then
											Result = CalcStat("VMLow",L,"Power")
										elseif SN == "VSPOWERM" then
											Result = CalcStat("VMMedium",L,"Power")
										elseif SN == "VSRESISTH" then
											Result = CalcStat("VMHigh",L,"Resist")
										end
									elseif SN < "VSPOWERH" then
										if SN == "VSPHYMITH" then
											Result = CalcStat("VMHigh",L,"PhyMit")
										elseif SN == "VSPHYMITL" then
											Result = CalcStat("VMLow",L,"PhyMit")
										elseif SN == "VSPHYMITM" then
											Result = CalcStat("VMMedium",L,"PhyMit")
										end
									else
										Result = CalcStat("VMHigh",L,"Power")
									end
								else
									Result = CalcStat("VMMedium",L,"PhyMas")
								end
							elseif SN < "VSMIGHTH" then
								if SN < "VSFINESSEL" then
									if SN > "VSFATEH" then
										if SN == "VSFATEL" then
											Result = CalcStat("VMLow",L,"Fate")
										elseif SN == "VSFATEM" then
											Result = CalcStat("VMMedium",L,"Fate")
										elseif SN == "VSFINESSEH" then
											Result = CalcStat("VMHigh",L,"Finesse")
										end
									elseif SN < "VSFATEH" then
										if SN == "VSEVADEH" then
											Result = CalcStat("VMHigh",L,"Evade")
										elseif SN == "VSEVADEL" then
											Result = CalcStat("VMLow",L,"Evade")
										elseif SN == "VSEVADEM" then
											Result = CalcStat("VMMedium",L,"Evade")
										end
									else
										Result = CalcStat("VMHigh",L,"Fate")
									end
								elseif SN > "VSFINESSEL" then
									if SN > "VSICMRM" then
										if SN == "VSINHEALH" then
											Result = CalcStat("VMHigh",L,"InHeal")
										elseif SN == "VSINHEALL" then
											Result = CalcStat("VMLow",L,"InHeal")
										elseif SN == "VSINHEALM" then
											Result = CalcStat("VMMedium",L,"InHeal")
										end
									elseif SN < "VSICMRM" then
										if SN == "VSFINESSEM" then
											Result = CalcStat("VMMedium",L,"Finesse")
										elseif SN == "VSICMRH" then
											Result = CalcStat("VMHigh",L,"ICMR")
										elseif SN == "VSICMRL" then
											Result = CalcStat("VMLow",L,"ICMR")
										end
									else
										Result = CalcStat("VMMedium",L,"ICMR")
									end
								else
									Result = CalcStat("VMLow",L,"Finesse")
								end
							else
								Result = CalcStat("VMHigh",L,"Might")
							end
						else
							Result = CalcStat("VMMedium",L,"CritHit")
						end
					else
						Result = CalcStat("VMLow",L,"Resist")
					end
				else
					Result = CalcStat("VSVPPhyMas",L)
				end
			else
				Result = 1.5
			end
		else
			Result = CalcStat("MitMediumPRatPCapR",L)
		end
	elseif SN < "MINECHOESBATTLECRITDEF" then
		if SN < "COMMONMITT" then
			if SN > "BRAWLERCDMIGHTTOPHYMAS" then
				if SN < "CHAMPIONCDAGILITYTOOUTHEAL" then
					if SN > "BURGLARCDMIGHTTOPHYMAS" then
						if SN < "CAPTAINCDBASEPOWER" then
							if SN > "CAPTAINCDAGILITYTOFINESSE" then
								if SN < "CAPTAINCDBASEAGILITY" then
									if SN > "CAPTAINCDARMOURTOCOMPHYMIT" then
										if SN == "CAPTAINCDARMOURTONONPHYMIT" then
											Result = 0.2
										elseif SN == "CAPTAINCDARMOURTOTACMIT" then
											Result = 0.2
										elseif SN == "CAPTAINCDARMOURTYPE" then
											Result = 3
										end
									elseif SN < "CAPTAINCDARMOURTOCOMPHYMIT" then
										if SN == "CAPTAINCDAGILITYTOPARRY" then
											Result = 1.0
										elseif SN == "CAPTAINCDAGILITYTOPHYMAS" then
											Result = 2.0
										elseif SN == "CAPTAINCDAGILITYTOTACMAS" then
											Result = 2.0
										end
									else
										Result = 1.0
									end
								elseif SN > "CAPTAINCDBASEAGILITY" then
									if SN > "CAPTAINCDBASEMIGHT" then
										if SN == "CAPTAINCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										elseif SN == "CAPTAINCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRM",L)
										elseif SN == "CAPTAINCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										end
									elseif SN < "CAPTAINCDBASEMIGHT" then
										if SN == "CAPTAINCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										elseif SN == "CAPTAINCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRM",L)
										elseif SN == "CAPTAINCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										end
									else
										Result = CalcStat("ClassBaseMightH",L)
									end
								else
									Result = CalcStat("ClassBaseAgilityL",L)
								end
							elseif SN < "CAPTAINCDAGILITYTOFINESSE" then
								if SN < "BURGLARCDWILLTOCRITHIT" then
									if SN > "BURGLARCDTACMASTOOUTHEAL" then
										if SN == "BURGLARCDVITALITYTOICMR" then
											Result = 0.012
										elseif SN == "BURGLARCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "BURGLARCDVITALITYTONCMR" then
											Result = 0.12
										end
									elseif SN < "BURGLARCDTACMASTOOUTHEAL" then
										if SN == "BURGLARCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "BURGLARCDPHYMITTONONPHYMIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "BURGLARCDWILLTOCRITHIT" then
									if SN > "BURGLARCDWILLTOPHYMIT" then
										if SN == "BURGLARCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "C" then
											Result = C
										elseif SN == "CAPTAINCDAGILITYTOCRITHIT" then
											Result = 2.0
										end
									elseif SN < "BURGLARCDWILLTOPHYMIT" then
										if SN == "BURGLARCDWILLTOFINESSE" then
											Result = 1.5
										elseif SN == "BURGLARCDWILLTOOUTHEAL" then
											Result = 2.0
										elseif SN == "BURGLARCDWILLTOPHYMAS" then
											Result = 2.0
										end
									else
										Result = 1.0
									end
								else
									Result = 0.5
								end
							else
								Result = 1.0
							end
						elseif SN > "CAPTAINCDBASEPOWER" then
							if SN > "CAPTAINCDMIGHTTOTACMAS" then
								if SN < "CAPTAINCDWILLTOFINESSE" then
									if SN > "CAPTAINCDTACMASTOOUTHEAL" then
										if SN == "CAPTAINCDVITALITYTOICMR" then
											Result = 0.012
										elseif SN == "CAPTAINCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "CAPTAINCDVITALITYTONCMR" then
											Result = 0.12
										end
									elseif SN < "CAPTAINCDTACMASTOOUTHEAL" then
										if SN == "CAPTAINCDMIGHTTOTACMIT" then
											Result = 1.0
										elseif SN == "CAPTAINCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "CAPTAINCDPHYMITTONONPHYMIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "CAPTAINCDWILLTOFINESSE" then
									if SN > "CAPTAINCDWILLTOTACMAS" then
										if SN == "CAPTAINCDWILLTOTACMIT" then
											Result = 1.5
										elseif SN == "CHAMPIONCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "CHAMPIONCDAGILITYTOFINESSE" then
											Result = 1.0
										end
									elseif SN < "CAPTAINCDWILLTOTACMAS" then
										if SN == "CAPTAINCDWILLTOPHYMAS" then
											Result = 1.0
										elseif SN == "CAPTAINCDWILLTOPHYMIT" then
											Result = 1.5
										elseif SN == "CAPTAINCDWILLTORESIST" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								else
									Result = 1.0
								end
							elseif SN < "CAPTAINCDMIGHTTOTACMAS" then
								if SN < "CAPTAINCDFATETONCPR" then
									if SN > "CAPTAINCDCALCTYPENONPHYMIT" then
										if SN == "CAPTAINCDCALCTYPETACMIT" then
											Result = 27
										elseif SN == "CAPTAINCDCANBLOCK" then
											if 15 <= L then
												Result = 1
											end
										elseif SN == "CAPTAINCDFATETOICPR" then
											Result = 0.015
										end
									elseif SN < "CAPTAINCDCALCTYPENONPHYMIT" then
										if SN == "CAPTAINCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										elseif SN == "CAPTAINCDBASEWILL" then
											Result = CalcStat("ClassBaseWillM",L)
										elseif SN == "CAPTAINCDCALCTYPECOMPHYMIT" then
											Result = 14
										end
									else
										Result = 14
									end
								elseif SN > "CAPTAINCDFATETONCPR" then
									if SN > "CAPTAINCDMIGHTTOCRITHIT" then
										if SN == "CAPTAINCDMIGHTTOPARRY" then
											Result = 1.0
										elseif SN == "CAPTAINCDMIGHTTOPHYMAS" then
											Result = 3.0
										elseif SN == "CAPTAINCDMIGHTTOPHYMIT" then
											Result = 1.0
										end
									elseif SN < "CAPTAINCDMIGHTTOCRITHIT" then
										if SN == "CAPTAINCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "CAPTAINCDHASPOWER" then
											Result = 1
										elseif SN == "CAPTAINCDMIGHTTOBLOCK" then
											Result = 2.0
										end
									else
										Result = 1.0
									end
								else
									Result = 0.15
								end
							else
								Result = 3.0
							end
						else
							Result = CalcStat("ClassBasePower",L)
						end
					elseif SN < "BURGLARCDMIGHTTOPHYMAS" then
						if SN < "BURGLARCDAGILITYTOEVADE" then
							if SN > "BRGALLINFINESSE" then
								if SN < "BRWMIGHTINCREASE" then
									if SN > "BRWDEFPOSTUREPHYMAS" then
										if SN == "BRWINNSTRCLEVTECHFINESSE" then
											Result = CalcStat("FinesseT",L,CalcStat("Trait13510Choice",N)*0.2)
										elseif SN == "BRWINNSTRPRECISIONCRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("Trait13510Choice",N)*0.2)
										elseif SN == "BRWMAELSTROMMIGHT" then
											Result = CalcStat("MightT",L,2.0)
										end
									elseif SN < "BRWDEFPOSTUREPHYMAS" then
										if SN == "BRGREVWEAKNFINESSE" then
											Result = -CalcStat("FinesseT",L,0.4)
										elseif SN == "BRGSMALLSNAGFINESSE" then
											Result = -CalcStat("FinesseT",L,0.8)
										elseif SN == "BRWAGGPOSTUREPHYMIT" then
											Result = -CalcStat("PhyMitT",L,3.0)
										end
									else
										Result = -CalcStat("PhyMasT",L,4.0)
									end
								elseif SN > "BRWMIGHTINCREASE" then
									if SN > "BRWSHAREISHEAVYCRITHIT" then
										if SN == "BRWTACMIT" then
											Result = CalcStat("TacMitT",L,CalcStat("Trait12345Choice",N)*0.4)
										elseif SN == "BRWVITALITYINCREASE" then
											Result = CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4)
										elseif SN == "BURGLARCDAGILITYTOCRITHIT" then
											Result = 1.0
										end
									elseif SN < "BRWSHAREISHEAVYCRITHIT" then
										if SN == "BRWRETINTENSITYCRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("Trait234Choice",N))
										elseif SN == "BRWRETPRECISIONFINESSE" then
											Result = CalcStat("FinesseT",L,CalcStat("Trait234Choice",N))
										elseif SN == "BRWSHAREISBALANCEFINESSE" then
											Result = CalcStat("BrwInnStrClevTechFinesse",L,3)
										end
									else
										Result = CalcStat("BrwInnStrPrecisionCritHit",L,3)
									end
								else
									Result = CalcStat("MightT",L,CalcStat("Trait567810Choice",N)*0.4)
								end
							elseif SN < "BRGALLINFINESSE" then
								if SN < "BRAWLERCDVITALITYTOMORALE" then
									if SN > "BRAWLERCDPHYMITTOCOMPHYMIT" then
										if SN == "BRAWLERCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "BRAWLERCDTACMASTOOUTHEAL" then
											Result = 1.0
										elseif SN == "BRAWLERCDVITALITYTOICMR" then
											Result = 0.012
										end
									elseif SN < "BRAWLERCDPHYMITTOCOMPHYMIT" then
										if SN == "BRAWLERCDMIGHTTOPHYMIT" then
											Result = 1.0
										elseif SN == "BRAWLERCDMIGHTTOTACMIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "BRAWLERCDVITALITYTOMORALE" then
									if SN > "BRAWLERCDWILLTOPHYMAS" then
										if SN == "BRAWLERCDWILLTOPHYMIT" then
											Result = 1.5
										elseif SN == "BRAWLERCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "BRAWLERCDWILLTOTACMIT" then
											Result = 1.5
										end
									elseif SN < "BRAWLERCDWILLTOPHYMAS" then
										if SN == "BRAWLERCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "BRAWLERCDWILLTOFINESSE" then
											Result = 1.0
										elseif SN == "BRAWLERCDWILLTOOUTHEAL" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								else
									Result = 4.5
								end
							else
								Result = CalcStat("Finesse",L,2.0)
							end
						elseif SN > "BURGLARCDAGILITYTOEVADE" then
							if SN > "BURGLARCDBASENCMR" then
								if SN < "BURGLARCDFATETOICPR" then
									if SN > "BURGLARCDBASEWILL" then
										if SN == "BURGLARCDCALCTYPECOMPHYMIT" then
											Result = 13
										elseif SN == "BURGLARCDCALCTYPENONPHYMIT" then
											Result = 13
										elseif SN == "BURGLARCDCALCTYPETACMIT" then
											Result = 26
										end
									elseif SN < "BURGLARCDBASEWILL" then
										if SN == "BURGLARCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "BURGLARCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										elseif SN == "BURGLARCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										end
									else
										Result = CalcStat("ClassBaseWillL",L)
									end
								elseif SN > "BURGLARCDFATETOICPR" then
									if SN > "BURGLARCDMIGHTTOCRITHIT" then
										if SN == "BURGLARCDMIGHTTOEVADE" then
											Result = 1.0
										elseif SN == "BURGLARCDMIGHTTOFINESSE" then
											Result = 1.5
										elseif SN == "BURGLARCDMIGHTTOOUTHEAL" then
											Result = 2.0
										end
									elseif SN < "BURGLARCDMIGHTTOCRITHIT" then
										if SN == "BURGLARCDFATETONCPR" then
											Result = 0.15
										elseif SN == "BURGLARCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "BURGLARCDHASPOWER" then
											Result = 1
										end
									else
										Result = 1.5
									end
								else
									Result = 0.015
								end
							elseif SN < "BURGLARCDBASENCMR" then
								if SN < "BURGLARCDARMOURTOTACMIT" then
									if SN > "BURGLARCDAGILITYTOPHYMIT" then
										if SN == "BURGLARCDAGILITYTOTACMIT" then
											Result = 1.0
										elseif SN == "BURGLARCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "BURGLARCDARMOURTONONPHYMIT" then
											Result = 0.2
										end
									elseif SN < "BURGLARCDAGILITYTOPHYMIT" then
										if SN == "BURGLARCDAGILITYTOOUTHEAL" then
											Result = 3.0
										elseif SN == "BURGLARCDAGILITYTOPARRY" then
											Result = 1.0
										elseif SN == "BURGLARCDAGILITYTOPHYMAS" then
											Result = 3.0
										end
									else
										Result = 1.0
									end
								elseif SN > "BURGLARCDARMOURTOTACMIT" then
									if SN > "BURGLARCDBASEICMR" then
										if SN == "BURGLARCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "BURGLARCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										elseif SN == "BURGLARCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										end
									elseif SN < "BURGLARCDBASEICMR" then
										if SN == "BURGLARCDARMOURTYPE" then
											Result = 2
										elseif SN == "BURGLARCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityH",L)
										elseif SN == "BURGLARCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										end
									else
										Result = CalcStat("ClassBaseICMRL",L)
									end
								else
									Result = 0.2
								end
							else
								Result = CalcStat("ClassBaseNCMRL",L)
							end
						else
							Result = 2.0
						end
					else
						Result = 2.0
					end
				elseif SN > "CHAMPIONCDAGILITYTOOUTHEAL" then
					if SN > "CLASSBASEICPR" then
						if SN < "COMBATBASETACHPSBASE" then
							if SN > "CLASSNAME" then
								if SN < "COMBATBASETACDPSBASE" then
									if SN > "COMBATBASEPHYDPSITEMBASE" then
										if SN == "COMBATBASEPHYDPSITEMPNTS" then
											Result = {{1,50,60,65,75,125,175,200,222,300,301,350,351,400,401,450,451,500,501,550,551,600,601,650},{1,50,60,65,75,85,95,100,105,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170}}
										elseif SN == "COMBATBASEPHYDPSRAW" then
											if L <= 650 then
												Result = StatLinInter("","CombatBasePhyDPSItemPntS","CombatBasePhyDPSItemBase","",L,N)
											else
												Result = CalcStat("CombatBasePhyDPSRaw",650,N)
											end
										elseif SN == "COMBATBASETACDPS" then
											Result = EquSng(DecSng(CalcStat("CombatBaseTacDPSRaw",L)))
										end
									elseif SN < "COMBATBASEPHYDPSITEMBASE" then
										if SN == "CLOTHARMOUR" then
											if L <= 50 then
												Result = 1.0*L
											else
												Result = 50.0
											end
										elseif SN == "COMBATBASEPHYDPS" then
											Result = EquSng(DecSng(CalcStat("CombatBasePhyDPSRaw",L,N)))
										elseif SN == "COMBATBASEPHYDPSBASE" then
											Result = 1.08*CalcStat("ProgBDamage",L)
										end
									else
										Result = CalcStat("CombatBasePhyDPSBase",L)
									end
								elseif SN > "COMBATBASETACDPSBASE" then
									if SN > "COMBATBASETACDPSITEMPNTS" then
										if SN == "COMBATBASETACDPSNOCLASS" then
											if L <= 50 then
												Result = 1.0*L
											else
												Result = CalcStat("CombatBaseTacDPSNoClass",50)
											end
										elseif SN == "COMBATBASETACDPSRAW" then
											if L <= 46 then
												Result = CalcStat("CombatBaseTacDPSRaw",47)
											elseif 47 <= L and L <= 51 then
												Result = DataTableValue({0.5,0.6,0.7,0.8,1.0},L-46)
											elseif L <= 649 then
												Result = StatLinInter("","CombatBaseTacDPSItemPntS","CombatBaseTacDPSItemBase","",L,N)
											else
												Result = CalcStat("CombatBaseTacDPSRaw",649)
											end
										elseif SN == "COMBATBASETACHPS" then
											Result = EquSng(DecSng(CalcStat("CombatBaseTacHPSRaw",L)))
										end
									elseif SN < "COMBATBASETACDPSITEMPNTS" then
										if SN == "COMBATBASETACDPSBYLEVEL" then
											Result = EquSng(CalcStat("CombatBaseTacDPSByLevelRaw",L))
										elseif SN == "COMBATBASETACDPSBYLEVELRAW" then
											if L <= 50 then
												Result = CalcStat("CombatBaseTacDPSBase",L)
											else
												Result = CalcStat("CombatBaseTacDPSByLevelRaw",50)
											end
										elseif SN == "COMBATBASETACDPSITEMBASE" then
											Result = CalcStat("CombatBaseTacDPSBase",L)-CalcStat("CombatBaseTacDPSByLevelRaw",L)
										end
									else
										Result = {{1,50,60,65,75,125,175,200,222,299,300,349,350,399,400,449,450,499,500,549,550,599,600,649},{1,50,60,65,75,85,95,100,105,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170}}
									end
								else
									Result = CalcStat("ProgBDamage",L)
								end
							elseif SN < "CLASSNAME" then
								if SN < "CLASSBASENCMRM" then
									if SN > "CLASSBASEMIGHTM" then
										if SN == "CLASSBASEMORALE" then
											if L <= 95 then
												Result = RoundDblDown(CalcStat("DirectHealth",L,10.0))
											else
												Result = RoundDbl(CalcStat("DirectHealth",L,10.0))
											end
										elseif SN == "CLASSBASENCMRH" then
											Result = 2.0
										elseif SN == "CLASSBASENCMRL" then
											Result = 1.0
										end
									elseif SN < "CLASSBASEMIGHTM" then
										if SN == "CLASSBASEMIGHTH" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,1.5))
										elseif SN == "CLASSBASEMIGHTL" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,0.5))
										end
									else
										Result = RoundDbl(CalcStat("DirectRatingsOld",L,1.0))
									end
								elseif SN > "CLASSBASENCMRM" then
									if SN > "CLASSBASEVITALITY" then
										if SN == "CLASSBASEWILLH" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,1.5))
										elseif SN == "CLASSBASEWILLL" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,0.5))
										elseif SN == "CLASSBASEWILLM" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,1.0))
										end
									elseif SN < "CLASSBASEVITALITY" then
										if SN == "CLASSBASENCPR" then
											Result = EquSng(StatLinInter("PntMPClassBaseNCPR","ClassBasePowerRegenPntS","ProgBEnergy","AdjClassBasePowReg",L,N))
										elseif SN == "CLASSBASEPOWER" then
											if L <= 95 then
												Result = RoundDblDown(CalcStat("DirectEnergy",L,10.0))
											else
												Result = RoundDbl(CalcStat("DirectEnergy",L,10.0))
											end
										elseif SN == "CLASSBASEPOWERREGENPNTS" then
											Result = {{1,20,50,60,65,75,85,95,100,105,115,120,130,140,141,150,151,160,161,170},{1,20,50,60,65,75,85,95,100,105,115,120,130,140,141,150,151,160,161,170}}
										end
									else
										Result = RoundDbl(CalcStat("DirectHealth",L,1.5))
									end
								else
									Result = 1.0
								end
							else
								Result = TranslateValue({23,24,31,40,52,71,126,127,128,162,172,179,185,192,193,194,214,215,216,217},{"Guardian","Captain","Minstrel","Burglar","Warleader","Reaver","Stalker","Weaver","Defiler","Hunter","Champion","Blackarrow","LoreMaster","Chicken","RuneKeeper","Warden","Beorning","Brawler","Mariner","Sorceress",""},L)
							end
						elseif SN > "COMBATBASETACHPSBASE" then
							if SN > "COMBATDAMAGEMODHEALTHLOW" then
								if SN < "COMBATDAMAGEMODMPHEALALT" then
									if SN > "COMBATDAMAGEMODMPDMG" then
										if SN == "COMBATDAMAGEMODMPDMGADJ" then
											if L == 150 then
												Result = 0.82
											elseif 151 <= L and L <= 160 then
												Result = 0.78
											else
												Result = 1.0
											end
										elseif SN == "COMBATDAMAGEMODMPHEAL" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBHealth","CombatDamageModMPHealAdj",L,N,2))
										elseif SN == "COMBATDAMAGEMODMPHEALADJ" then
											if L == 150 then
												Result = 0.71
											elseif L == 151 then
												Result = 0.64
											elseif L == 160 then
												Result = 0.608
											else
												Result = 1.0
											end
										end
									elseif SN < "COMBATDAMAGEMODMPDMG" then
										if SN == "COMBATDAMAGEMODHEALTHLOWADJ" then
											if L <= 1 then
												Result = 0.144
											elseif L <= 25 then
												Result = 0.324
											elseif L <= 50 then
												Result = 0.576
											else
												Result = 0.9
											end
										elseif SN == "COMBATDAMAGEMODHEALTHMEDIUM" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBHealth","CombatDamageModHealthMediumAdj",L,N))
										elseif SN == "COMBATDAMAGEMODHEALTHMEDIUMADJ" then
											if L <= 1 then
												Result = 0.36
											elseif L <= 25 then
												Result = 0.54
											elseif L <= 50 then
												Result = 0.72
											else
												Result = 0.9
											end
										end
									else
										Result = EquSng(StatLinInter("","TraitPntSVital","ProgBDamageNoImp","CombatDamageModMPDmgAdj",L,N,2))
									end
								elseif SN > "COMBATDAMAGEMODMPHEALALT" then
									if SN > "COMBATDAMAGEMODPETSADJ" then
										if SN == "COMBATDAMAGEMODPETSRND" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBDamageNoImp","CombatDamageModPetsAdj",L,N,2))
										elseif SN == "COMBATINHEAL" then
											Result = CalcStat("InHeal",L,2.0)
										elseif SN == "COMMONMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										end
									elseif SN < "COMBATDAMAGEMODPETSADJ" then
										if SN == "COMBATDAMAGEMODMPHEALALTADJ" then
											if L == 1 then
												Result = 0.01
											else
												Result = CalcStat("CombatDamageModMPHealAdj",L)
											end
										elseif SN == "COMBATDAMAGEMODNPCS" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBDamageNoImp","",L,N))
										elseif SN == "COMBATDAMAGEMODPETS" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBDamageNoImp","CombatDamageModPetsAdj",L,N))
										end
									else
										if L <= 1 then
											Result = 1.0
										elseif L <= 25 then
											Result = 0.4
										elseif L <= 50 then
											Result = 0.5
										elseif L <= 60 then
											Result = 0.6
										elseif L <= 65 then
											Result = 0.7
										elseif L <= 75 then
											Result = 0.8
										elseif L <= 85 then
											Result = 0.85
										elseif L <= 95 then
											Result = 0.9
										elseif L <= 100 then
											Result = 0.95
										else
											Result = 1.0
										end
									end
								else
									Result = EquSng(StatLinInter("","TraitPntSVital","ProgBHealth","CombatDamageModMPHealAltAdj",L,N,2))
								end
							elseif SN < "COMBATDAMAGEMODHEALTHLOW" then
								if SN < "COMBATBASETACHPSRAW" then
									if SN > "COMBATBASETACHPSITEMPNTS" then
										if SN == "COMBATBASETACHPSLVLTOILVL" then
											Result = RoundDbl(LinInter({{1,75,100,101,104,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170},{1.0,75.0,200.0,201.3,214.3,222.0,300.0,349.0,350.0,399.0,400.0,449.0,450.0,499.0,500.0,549.0,550.0,599.0,600.0,649.0}},L))
										elseif SN == "COMBATBASETACHPSMAGNITUDE" then
											Result = LinInter({{1,25,50,999},{0.5,0.35,0.175,0.175}},L)
										elseif SN == "COMBATBASETACHPSNOCLASS" then
											Result = EquSng(CalcStat("CombatBaseTacHPSByLevelRaw",L)+CalcStat("CombatBaseTacHPSRaw",CalcStat("CombatBaseTacHPSLvlToILvl",L)))
										end
									elseif SN < "COMBATBASETACHPSITEMPNTS" then
										if SN == "COMBATBASETACHPSBYLEVEL" then
											Result = EquSng(CalcStat("CombatBaseTacHPSByLevelRaw",L))
										elseif SN == "COMBATBASETACHPSBYLEVELRAW" then
											if L <= 46 then
												Result = CalcStat("CombatBaseTacHPSBase",L)
											else
												Result = CalcStat("CombatBaseTacHPSByLevelRaw",46)
											end
										elseif SN == "COMBATBASETACHPSITEMBASE" then
											Result = CalcStat("CombatBaseTacHPSBase",L)-CalcStat("CombatBaseTacHPSByLevelRaw",L)
										end
									else
										Result = {{1,50,60,65,75,125,175,200,222,299,300,349,350,399,400,449,450,499,500,549,550,599,600,649},{1,50,60,65,75,85,95,100,105,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170}}
									end
								elseif SN > "COMBATBASETACHPSRAW" then
									if SN > "COMBATDAMAGEMODCONVDMGADJ" then
										if SN == "COMBATDAMAGEMODDAMAGEITEM" then
											Result = EquSng(StatLinInter("","ItemPntSVital","ProgBDamage","",L,N,2))
										elseif SN == "COMBATDAMAGEMODENERGY" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBEnergy","",L,N,2))
										elseif SN == "COMBATDAMAGEMODHEALTHITEM" then
											Result = EquSng(StatLinInter("","ItemPntSVital","ProgBHealth","",L,N,2))
										end
									elseif SN < "COMBATDAMAGEMODCONVDMGADJ" then
										if SN == "COMBATDAMAGEMOD" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBDamageNoImp","",L,N,2))
										elseif SN == "COMBATDAMAGEMODCAPPED" then
											if L <= 170 then
												Result = CalcStat("CombatDamageMod",L,N)
											else
												Result = CalcStat("CombatDamageMod",170,N)
											end
										elseif SN == "COMBATDAMAGEMODCONVDMG" then
											Result = EquSng(StatLinInter("","TraitPntSVital","ProgBDamageNoImp","CombatDamageModConvDmgAdj",L,N))
										end
									else
										if L <= 1 then
											Result = 0.8
										elseif L <= 25 then
											Result = 0.9
										else
											Result = 1.0
										end
									end
								else
									if L <= 49 then
										Result = CalcStat("CombatBaseTacHPSItemBase",L)
									elseif 50 <= L and L <= 55 then
										Result = DataTableValue({0.5,0.5,0.5,0.5,0.5,0.5},L-49)
									elseif L <= 649 then
										Result = StatLinInter("","CombatBaseTacHPSItemPntS","CombatBaseTacHPSItemBase","",L,N)
									else
										Result = CalcStat("CombatBaseTacHPSRaw",649)
									end
								end
							else
								Result = EquSng(StatLinInter("","TraitPntSVital","ProgBHealth","CombatDamageModHealthLowAdj",L,N))
							end
						else
							Result = CalcStat("CombatBaseTacHPSMagnitude",L)*CalcStat("ProgBHealth",L)
						end
					elseif SN < "CLASSBASEICPR" then
						if SN < "CHAMPIONCDMIGHTTOTACMIT" then
							if SN > "CHAMPIONCDBASEPOWER" then
								if SN < "CHAMPIONCDFATETONCPR" then
									if SN > "CHAMPIONCDCALCTYPENONPHYMIT" then
										if SN == "CHAMPIONCDCALCTYPETACMIT" then
											Result = 27
										elseif SN == "CHAMPIONCDCANBLOCK" then
											if 6 <= L then
												Result = 1
											end
										elseif SN == "CHAMPIONCDFATETOICPR" then
											Result = 0.015
										end
									elseif SN < "CHAMPIONCDCALCTYPENONPHYMIT" then
										if SN == "CHAMPIONCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										elseif SN == "CHAMPIONCDBASEWILL" then
											Result = CalcStat("ClassBaseWillL",L)
										elseif SN == "CHAMPIONCDCALCTYPECOMPHYMIT" then
											Result = 14
										end
									else
										Result = 14
									end
								elseif SN > "CHAMPIONCDFATETONCPR" then
									if SN > "CHAMPIONCDMIGHTTOOUTHEAL" then
										if SN == "CHAMPIONCDMIGHTTOPARRY" then
											Result = 3.0
										elseif SN == "CHAMPIONCDMIGHTTOPHYMAS" then
											Result = 3.0
										elseif SN == "CHAMPIONCDMIGHTTOPHYMIT" then
											Result = 1.0
										end
									elseif SN < "CHAMPIONCDMIGHTTOOUTHEAL" then
										if SN == "CHAMPIONCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "CHAMPIONCDHASPOWER" then
											Result = 1
										elseif SN == "CHAMPIONCDMIGHTTOCRITHIT" then
											Result = 1.0
										end
									else
										Result = 3.0
									end
								else
									Result = 0.15
								end
							elseif SN < "CHAMPIONCDBASEPOWER" then
								if SN < "CHAMPIONCDBASEAGILITY" then
									if SN > "CHAMPIONCDARMOURTOCOMPHYMIT" then
										if SN == "CHAMPIONCDARMOURTONONPHYMIT" then
											Result = 0.2
										elseif SN == "CHAMPIONCDARMOURTOTACMIT" then
											Result = 0.2
										elseif SN == "CHAMPIONCDARMOURTYPE" then
											Result = 3
										end
									elseif SN < "CHAMPIONCDARMOURTOCOMPHYMIT" then
										if SN == "CHAMPIONCDAGILITYTOPARRY" then
											Result = 1.0
										elseif SN == "CHAMPIONCDAGILITYTOPHYMAS" then
											Result = 2.0
										end
									else
										Result = 1.0
									end
								elseif SN > "CHAMPIONCDBASEAGILITY" then
									if SN > "CHAMPIONCDBASEMIGHT" then
										if SN == "CHAMPIONCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										elseif SN == "CHAMPIONCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRH",L)
										elseif SN == "CHAMPIONCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										end
									elseif SN < "CHAMPIONCDBASEMIGHT" then
										if SN == "CHAMPIONCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										elseif SN == "CHAMPIONCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRH",L)
										elseif SN == "CHAMPIONCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										end
									else
										Result = CalcStat("ClassBaseMightH",L)
									end
								else
									Result = CalcStat("ClassBaseAgilityM",L)
								end
							else
								Result = CalcStat("ClassBasePower",L)
							end
						elseif SN > "CHAMPIONCDMIGHTTOTACMIT" then
							if SN > "CHICKENCDCALCTYPETACMIT" then
								if SN < "CHPSTALWBLADEVITALITY" then
									if SN > "CHPCONTRBURNICPR" then
										if SN == "CHPFINESSEINCREASE" then
											Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4)
										elseif SN == "CHPFLURRYINCRCRITHIT" then
											Result = CalcStat("CritHitT",L,2.4)
										elseif SN == "CHPMIGHTINCREASE" then
											Result = CalcStat("MightT",L,CalcStat("Trait567810Choice",N)*0.4)
										end
									elseif SN < "CHPCONTRBURNICPR" then
										if SN == "CHICKENCDHASPOWER" then
											Result = 1
										elseif SN == "CHISELCRITHITH" then
											Result = EquSng(DecSng(CalcStat("DirectRatings",L,4088.0/1200.0)))
										elseif SN == "CHISELCRITHITL" then
											Result = EquSng(DecSng(CalcStat("DirectRatings",L,2726.0/1200.0)))
										end
									else
										Result = CalcStat("ICPRT",L,0.4)
									end
								elseif SN > "CHPSTALWBLADEVITALITY" then
									if SN > "CLASSBASEFATE" then
										if SN == "CLASSBASEICMRH" then
											Result = EquSng(0.2)
										elseif SN == "CLASSBASEICMRL" then
											Result = EquSng(0.15)
										elseif SN == "CLASSBASEICMRM" then
											Result = EquSng(0.175)
										end
									elseif SN < "CLASSBASEFATE" then
										if SN == "CLASSBASEAGILITYH" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,1.5))
										elseif SN == "CLASSBASEAGILITYL" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,0.5))
										elseif SN == "CLASSBASEAGILITYM" then
											Result = RoundDbl(CalcStat("DirectRatingsOld",L,1.0))
										end
									else
										Result = RoundDbl(CalcStat("DirectEnergy",L,5.0))
									end
								else
									Result = CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4)
								end
							elseif SN < "CHICKENCDCALCTYPETACMIT" then
								if SN < "CHAMPIONCDWILLTOOUTHEAL" then
									if SN > "CHAMPIONCDVITALITYTOICMR" then
										if SN == "CHAMPIONCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "CHAMPIONCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "CHAMPIONCDWILLTOFINESSE" then
											Result = 1.0
										end
									elseif SN < "CHAMPIONCDVITALITYTOICMR" then
										if SN == "CHAMPIONCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "CHAMPIONCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "CHAMPIONCDTACMASTOOUTHEAL" then
											Result = 1.0
										end
									else
										Result = 0.012
									end
								elseif SN > "CHAMPIONCDWILLTOOUTHEAL" then
									if SN > "CHAMPIONCDWILLTOTACMIT" then
										if SN == "CHICKENCANBLOCK" then
											Result = 1
										elseif SN == "CHICKENCDCALCTYPECOMPHYMIT" then
											Result = 14
										elseif SN == "CHICKENCDCALCTYPENONPHYMIT" then
											Result = 14
										end
									elseif SN < "CHAMPIONCDWILLTOTACMIT" then
										if SN == "CHAMPIONCDWILLTOPHYMAS" then
											Result = 1.0
										elseif SN == "CHAMPIONCDWILLTOPHYMIT" then
											Result = 1.5
										elseif SN == "CHAMPIONCDWILLTORESIST" then
											Result = 1.0
										end
									else
										Result = 1.5
									end
								else
									Result = 1.0
								end
							else
								Result = 27
							end
						else
							Result = 1.0
						end
					else
						Result = EquSng(StatLinInter("PntMPClassBaseICPR","ClassBasePowerRegenPntS","ProgBEnergy","AdjClassBasePowReg",L,N))
					end
				else
					Result = 2.0
				end
			elseif SN < "BRAWLERCDMIGHTTOPHYMAS" then
				if SN < "BEOMIGHTOFTHEWILDMIGHT" then
					if SN > "AWARDILVLCD" then
						if SN < "AWARDILVLH" then
							if SN > "AWARDILVLE" then
								if SN < "AWARDILVLFB" then
									if SN > "AWARDILVLED" then
										if SN == "AWARDILVLEE" then
											if 116 <= L and L <= 119 then
												Result = RoundDbl(LinFmod(1.0,350.0,366.0,116,120,L))
											elseif L == 120 then
												Result = CalcStat("AwardILvlE",120)+14
											else
												Result = CalcStat("AwardILvlE",L)
											end
										elseif SN == "AWARDILVLF" then
											if L <= 75 then
												Result = 0
											elseif L <= 84 then
												Result = RoundDbl(LinFmod(1.0,78.0,118.0,76,84,L))
											elseif L <= 85 then
												Result = 0
											elseif L <= 93 then
												Result = RoundDbl(LinFmod(1.0,129.4,163.0,86,93,L))
											elseif L <= 95 then
												Result = 0
											elseif L <= 100 then
												Result = RoundDbl(LinFmod(1.0,175.0,198.4,95,100,L))
											elseif L <= 104 then
												Result = RoundDbl(LinFmod(1.0,201.0,213.0,101,104,L))
											elseif L <= 105 then
												Result = 220
											elseif L <= 114 then
												Result = RoundDbl(LinFmod(1.0,300.0,323.0,106,114,L))
											elseif L <= 115 then
												Result = 324
											elseif L <= 119 then
												Result = RoundDbl(LinFmod(1.0,349.6,368.4,116,120,L))
											end
										elseif SN == "AWARDILVLFA" then
											if L <= 9 then
												Result = RoundDbl(LinFmod(1.0,0.5,4.5,1,9,L))
											elseif L <= 19 then
												Result = RoundDbl(LinFmod(1.0,6.0,15.0,10,19,L))
											elseif L <= 23 then
												Result = RoundDbl(LinFmod(1.0,15.5,17.0,20,23,L))
											elseif L <= 49 then
												Result = RoundDbl(LinFmod(1.0,18.0,43.0,24,49,L))
											elseif L <= 65 then
												Result = RoundDbl(LinFmod(1.0,43.0,58.0,50,65,L))
											elseif L <= 75 then
												Result = RoundDbl(LinFmod(1.0,60.0,69.0,66,75,L))
											elseif L <= 84 then
												Result = CalcStat("AwardILvlF",L)
											elseif L <= 85 then
												Result = 120
											elseif L <= 93 then
												Result = CalcStat("AwardILvlF",L)
											elseif L <= 95 then
												Result = RoundDbl(LinFmod(1.0,166.0,172.0,94,95,L))
											elseif L <= 119 then
												Result = CalcStat("AwardILvlF",L)
											elseif L <= 120 then
												Result = 368
											elseif L <= 129 then
												Result = RoundDbl(LinFmod(1.0,400.0,423.0,121,129,L))
											elseif L <= 130 then
												Result = 424
											elseif L <= 135 then
												Result = RoundDbl(LinFmod(1.0,450.0,462.0,131,135,L))
											elseif L <= 139 then
												Result = RoundDbl(LinFmod(1.0,463.0,472.0,136,139,L))
											elseif L <= 140 then
												Result = 473
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.4,520.4,141,150,L))
											elseif L <= 160 then
												Result = RoundDbl(LinFmod(1.0,550.4,550.4,151,160,L))
											else
												Result = CalcStat("AwardILvlFA",160)
											end
										end
									elseif SN < "AWARDILVLED" then
										if SN == "AWARDILVLEA" then
											if 116 <= L and L <= 119 then
												Result = RoundDbl(LinFmod(1.0,350.0,378.0,116,120,L))
											elseif L == 120 then
												Result = CalcStat("AwardILvlE",120)+26
											else
												Result = CalcStat("AwardILvlE",L)
											end
										elseif SN == "AWARDILVLEB" then
											if 116 <= L and L <= 119 then
												Result = RoundDbl(LinFmod(1.0,350.0,390.0,116,120,L))
											elseif L == 120 then
												Result = CalcStat("AwardILvlE",120)+38
											else
												Result = CalcStat("AwardILvlE",L)
											end
										elseif SN == "AWARDILVLEC" then
											if 116 <= L and L <= 120 then
												Result = RoundDbl(LinFmod(1.0,350.0,382.0,116,120,L))
											else
												Result = CalcStat("AwardILvlE",L)
											end
										end
									else
										if 116 <= L and L <= 120 then
											Result = RoundDbl(LinFmod(1.0,350.0,370.0,116,120,L))
										else
											Result = CalcStat("AwardILvlE",L)
										end
									end
								elseif SN > "AWARDILVLFB" then
									if SN > "AWARDILVLGC" then
										if SN == "AWARDILVLGD" then
											if 121 <= L and L <= 130 then
												Result = RoundDbl(LinFmod(1.0,400.4,426.4,121,130,L))
											else
												Result = CalcStat("AwardILvlG",L)
											end
										elseif SN == "AWARDILVLGE" then
											if 121 <= L and L <= 130 then
												Result = RoundDbl(LinFmod(1.0,400.4,434.4,121,130,L))
											else
												Result = CalcStat("AwardILvlG",L)
											end
										elseif SN == "AWARDILVLGF" then
											if 121 <= L and L <= 130 then
												Result = RoundDbl(LinFmod(1.0,400.4,440.4,121,130,L))
											else
												Result = CalcStat("AwardILvlG",L)
											end
										end
									elseif SN < "AWARDILVLGC" then
										if SN == "AWARDILVLG" then
											if L <= 120 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 130 then
												Result = 400
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLGA" then
											if 121 <= L and L <= 130 then
												Result = RoundDbl(LinFmod(1.0,400.4,412.4,121,130,L))
											else
												Result = CalcStat("AwardILvlG",L)
											end
										elseif SN == "AWARDILVLGB" then
											if 121 <= L and L <= 130 then
												Result = RoundDbl(LinFmod(1.0,400.4,418.4,121,130,L))
											else
												Result = CalcStat("AwardILvlG",L)
											end
										end
									else
										if 121 <= L and L <= 130 then
											Result = RoundDbl(LinFmod(1.0,400.4,408.3,121,130,L))
										else
											Result = CalcStat("AwardILvlG",L)
										end
									end
								else
									if L <= 40 then
										Result = RoundDbl(LinFmod(1.0,1.0,40.0,1,40,L))
									elseif L <= 45 then
										Result = RoundDbl(LinFmod(1.0,40.0,44.0,41,45,L))
									elseif L <= 50 then
										Result = RoundDbl(LinFmod(1.0,45.4,47.0,46,50,L))
									elseif L <= 55 then
										Result = RoundDbl(LinFmod(1.0,51.0,54.4,51,55,L))
									elseif L <= 60 then
										Result = RoundDbl(LinFmod(1.0,54.0,57.4,56,60,L))
									elseif L <= 75 then
										Result = RoundDbl(LinFmod(1.0,58.0,72.0,61,75,L))
									elseif L <= 84 then
										Result = CalcStat("AwardILvlF",L)
									elseif L <= 85 then
										Result = 122
									elseif L <= 93 then
										Result = CalcStat("AwardILvlF",L)
									elseif L <= 95 then
										Result = RoundDbl(LinFmod(1.0,168.0,174.0,94,95,L))
									elseif L <= 119 then
										Result = CalcStat("AwardILvlF",L)
									elseif L <= 120 then
										Result = 380
									elseif L <= 125 then
										Result = RoundDbl(LinFmod(1.0,400.0,416.0,121,125,L))
									elseif L <= 129 then
										Result = RoundDbl(LinFmod(1.0,418.0,430.0,126,129,L))
									elseif L <= 130 then
										Result = 432
									elseif L <= 135 then
										Result = RoundDbl(LinFmod(1.0,450.4,463.8,131,135,L))
									elseif L <= 138 then
										Result = RoundDbl(LinFmod(1.0,465.8,472.8,136,138,L))
									elseif L <= 140 then
										Result = 475
									elseif L <= 150 then
										Result = RoundDbl(LinFmod(1.0,500.4,526.4,141,150,L))
									elseif L <= 160 then
										Result = RoundDbl(LinFmod(1.0,550.4,567.4,151,160,L))
									else
										Result = CalcStat("AwardILvlFB",160)
									end
								end
							elseif SN < "AWARDILVLE" then
								if SN < "AWARDILVLD" then
									if SN > "AWARDILVLCG" then
										if SN == "AWARDILVLCH" then
											if L <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.4,525.4,141,150,L))
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLCI" then
											if L <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.4,530.4,141,150,L))
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLCJ" then
											if L <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.4,535.4,141,150,L))
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									elseif SN < "AWARDILVLCG" then
										if SN == "AWARDILVLCE" then
											if L <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.4,512.4,141,150,L))
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLCF" then
											if L <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.4,517.4,141,150,L))
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									else
										if L <= 140 then
											Result = CalcStat("AwardILvlC",L)
										elseif L <= 150 then
											Result = RoundDbl(LinFmod(1.0,500.4,520.4,141,150,L))
										else
											Result = CalcStat("AwardILvlA",L)
										end
									end
								elseif SN > "AWARDILVLD" then
									if SN > "AWARDILVLDD" then
										if SN == "AWARDILVLDE" then
											if 106 <= L and L <= 115 then
												Result = RoundDbl(LinFmod(1.0,300.4,326.4,106,115,L))
											else
												Result = CalcStat("AwardILvlD",L)
											end
										elseif SN == "AWARDILVLDF" then
											if 106 <= L and L <= 110 then
												Result = CalcStat("AwardILvlDF",111)
											elseif 111 <= L and L <= 115 then
												Result = RoundDbl(LinFmod(1.0,299.5,320.5,106,115,L))
											else
												Result = CalcStat("AwardILvlD",L)
											end
										elseif SN == "AWARDILVLDG" then
											if 106 <= L and L <= 114 then
												Result = RoundDbl(LinFmod(1.0,300.0,336.0,106,115,L))
											elseif L == 115 then
												Result = CalcStat("AwardILvlD",115)+40
											else
												Result = CalcStat("AwardILvlD",L)
											end
										end
									elseif SN < "AWARDILVLDD" then
										if SN == "AWARDILVLDA" then
											if 106 <= L and L <= 115 then
												Result = RoundDbl(LinFmod(1.0,300.0,336.5,106,115,L))
											else
												Result = CalcStat("AwardILvlD",L)
											end
										elseif SN == "AWARDILVLDB" then
											if 106 <= L and L <= 115 then
												Result = RoundDbl(LinFmod(1.0,300.0,345.0,106,115,L))
											else
												Result = CalcStat("AwardILvlD",L)
											end
										elseif SN == "AWARDILVLDC" then
											if 106 <= L and L <= 110 then
												Result = RoundDbl(LinFmod(1.0,300.0,320.0,106,115,L))
											elseif 111 <= L and L <= 115 then
												Result = CalcStat("AwardILvlDC",110)
											else
												Result = CalcStat("AwardILvlD",L)
											end
										end
									else
										if 106 <= L and L <= 114 then
											Result = RoundDbl(LinFmod(1.0,300.0,327.0,106,115,L))
										elseif L == 115 then
											Result = CalcStat("AwardILvlD",115)+30
										else
											Result = CalcStat("AwardILvlD",L)
										end
									end
								else
									if L <= 105 then
										Result = CalcStat("AwardILvlC",L)
									elseif L <= 115 then
										Result = 300
									else
										Result = CalcStat("AwardILvlA",L)
									end
								end
							else
								if L <= 115 then
									Result = CalcStat("AwardILvlC",L)
								elseif L <= 120 then
									Result = 350
								else
									Result = CalcStat("AwardILvlA",L)
								end
							end
						elseif SN > "AWARDILVLH" then
							if SN > "AWARDLVLTOILVL" then
								if SN < "BATTLELORETACMAS" then
									if SN > "BALANCEOFMANEVADE" then
										if SN == "BALANCEOFMANPARRY" then
											Result = CalcStat("ParryT",L,0.8)
										elseif SN == "BATTLELOREMAS" then
											if L <= 105 then
												Result = CalcStat("Mastery",L,2.5)
											elseif L == 120 or L == 130 then
												Result = CalcStat("MasteryT",L,1.6)
											else
												Result = CalcStat("MasteryT",L,1.2)
											end
										elseif SN == "BATTLELOREPHYMAS" then
											Result = CalcStat("BattleLoreMas",L)
										end
									elseif SN < "BALANCEOFMANEVADE" then
										if SN == "AXE2HARMOURREND" then
											Result = CalcStat("ArmourRend",L,-1.0)
										elseif SN == "AXEARMOURREND" then
											Result = CalcStat("ArmourRend",L,-0.5)
										elseif SN == "BALANCEOFMANBLOCK" then
											Result = CalcStat("BlockT",L,0.8)
										end
									else
										Result = CalcStat("EvadeT",L,1.0)
									end
								elseif SN > "BATTLELORETACMAS" then
									if SN > "BEOEMISSARYFATE" then
										if SN == "BEOFATE" then
											Result = CalcStat("FateT",L,CalcStat("Trait12345Choice",N)*0.4)
										elseif SN == "BEOFERALPRESFATE" then
											Result = CalcStat("FateT",L,1.0)
										elseif SN == "BEOFEWINNUMBERFATE" then
											Result = -CalcStat("FateT",L,0.4)
										end
									elseif SN < "BEOEMISSARYFATE" then
										if SN == "BELERIANDMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										elseif SN == "BELERIANDMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										elseif SN == "BEOBEARFORMCRITDEF" then
											Result = CalcStat("CritDefT",L,0.4)
										end
									else
										Result = CalcStat("FateT",L,1.0)
									end
								else
									Result = CalcStat("BattleLoreMas",L)
								end
							elseif SN < "AWARDLVLTOILVL" then
								if SN < "AWARDILVLK" then
									if SN > "AWARDILVLJA" then
										if SN == "AWARDILVLJB" then
											if 131 <= L and L <= 140 then
												Result = RoundDbl(LinFmod(1.0,450.4,470.4,131,140,L))
											else
												Result = CalcStat("AwardILvlJ",L)
											end
										elseif SN == "AWARDILVLJC" then
											if 131 <= L and L <= 140 then
												Result = RoundDbl(LinFmod(1.0,450.4,475.4,131,140,L))
											else
												Result = CalcStat("AwardILvlJ",L)
											end
										elseif SN == "AWARDILVLJD" then
											if 131 <= L and L <= 140 then
												Result = RoundDbl(LinFmod(1.0,450.4,480.4,131,140,L))
											else
												Result = CalcStat("AwardILvlJ",L)
											end
										end
									elseif SN < "AWARDILVLJA" then
										if SN == "AWARDILVLI" then
											if L <= 44 then
												Result = 1
											elseif L <= 55 then
												Result = 52
											elseif L <= 75 then
												Result = RoundDblDown((L-56)/5)*5+60
											elseif L <= 85 then
												Result = RoundDblDown((L-76)/5)*29+100
											elseif L <= 95 then
												Result = RoundDblDown((L-86)/5)*20+155
											elseif L <= 100 then
												Result = RoundDblDown((L-96)/4)*10+190
											elseif L <= 105 then
												Result = RoundDblDown((L-101)/4)*35+215
											elseif L <= 110 then
												Result = CalcStat("LvlToILvl",106)+15
											elseif L <= 115 then
												Result = CalcStat("LvlToILvl",115)
											elseif L <= 119 then
												Result = CalcStat("LvlToILvl",116)+15
											elseif L <= 120 then
												Result = CalcStat("LvlToILvl",120)
											elseif L <= 125 then
												Result = CalcStat("LvlToILvl",121)+15
											elseif L <= 130 then
												Result = CalcStat("LvlToILvl",130)
											elseif L <= 135 then
												Result = CalcStat("LvlToILvl",131)+15
											elseif L <= 140 then
												Result = CalcStat("LvlToILvl",140)
											elseif L <= 145 then
												Result = CalcStat("LvlToILvl",141)+15
											elseif L <= 150 then
												Result = CalcStat("LvlToILvl",150)
											elseif L <= 155 then
												Result = CalcStat("LvlToILvl",151)+15
											elseif L <= 160 then
												Result = CalcStat("LvlToILvl",160)
											else
												Result = CalcStat("AwardILvlI",160)
											end
										elseif SN == "AWARDILVLIA" then
											if L <= 44 then
												Result = CalcStat("AwardILvlI",L)
											elseif L <= 55 then
												Result = RoundDblDown((L-45)/6)+51
											elseif L <= 90 then
												Result = CalcStat("AwardILvlI",L)
											elseif L <= 104 then
												Result = RoundDblDown((L-91)/5)*25+165
											elseif L <= 105 then
												Result = CalcStat("LvlToILvl",L)
											elseif L <= 110 then
												Result = CalcStat("LvlToILvl",106)+15
											elseif L <= 115 then
												Result = CalcStat("LvlToILvl",115)-20
											elseif L <= 120 then
												Result = CalcStat("LvlToILvl",116)+15
											elseif L <= 125 then
												Result = CalcStat("LvlToILvl",121)+15
											elseif L <= 130 then
												Result = CalcStat("LvlToILvl",130)-20
											elseif L <= 135 then
												Result = CalcStat("LvlToILvl",131)+15
											elseif L <= 140 then
												Result = CalcStat("LvlToILvl",140)-4
											elseif L <= 150 then
												Result = CalcStat("LvlToILvl",141)+15
											else
												Result = CalcStat("AwardILvlIA",150)
											end
										elseif SN == "AWARDILVLJ" then
											if L <= 130 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 140 then
												Result = RoundDbl(LinFmod(1.0,450.4,460.4,131,140,L))
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									else
										if 131 <= L and L <= 140 then
											Result = RoundDbl(LinFmod(1.0,450.4,465.4,131,140,L))
										else
											Result = CalcStat("AwardILvlJ",L)
										end
									end
								elseif SN > "AWARDILVLK" then
									if SN > "AWARDILVLMA" then
										if SN == "AWARDILVLMB" then
											if L <= 150 then
												Result = CalcStat("AwardILvlM",L)
											elseif L <= 160 then
												Result = RoundDbl(LinFmod(1.0,550.4,570.4,151,160,L))
											else
												Result = CalcStat("AwardILvlMB",160)
											end
										elseif SN == "AWARDILVLMC" then
											if L <= 150 then
												Result = CalcStat("AwardILvlM",L)
											elseif L <= 160 then
												Result = RoundDbl(LinFmod(1.0,550.4,580.4,151,160,L))
											else
												Result = CalcStat("AwardILvlMC",160)
											end
										elseif SN == "AWARDLVLCAP" then
											Result = 160
										end
									elseif SN < "AWARDILVLMA" then
										if SN == "AWARDILVLL" then
											if L <= 50 then
												Result = CalcStat("AwardILvlB",L)
											elseif L <= 54 then
												Result = CalcStat("AwardILvlA",L)-3
											elseif L <= 74 then
												Result = CalcStat("AwardILvlA",L)-4
											elseif L <= 75 then
												Result = CalcStat("AwardILvlA",L)-5
											elseif L <= 95 then
												Result = CalcStat("AwardILvlA",L)-1
											elseif L <= 115 then
												Result = CalcStat("AwardILvlA",L)-2
											elseif L <= 120 then
												Result = CalcStat("AwardILvlA",L)
											elseif L <= 130 then
												Result = RoundDbl(LinFmod(1.0,397.0,400.0,121,130,L))
											elseif L <= 134 then
												Result = CalcStat("AwardILvlA",L)
											elseif L <= 137 then
												Result = DataTableValue({449,450,450},L-134)
											elseif L <= 140 then
												Result = CalcStat("AwardILvlL",L-3)
											elseif L <= 145 then
												Result = RoundDbl(LinFmod(1.0,495.4,500.4,141,145,L))
											elseif L <= 150 then
												Result = RoundDbl(LinFmod(1.0,500.5,502.0,146,150,L))
											elseif L <= 154 then
												Result = RoundDbl(LinFmod(1.0,545.4,549.4,151,154,L))
											elseif L <= 157 then
												Result = RoundDbl(LinFmod(1.0,549.0,550.0,155,157,L))
											elseif L <= 160 then
												Result = RoundDbl(LinFmod(1.0,550.0,550.0,158,160,L))
											else
												Result = CalcStat("AwardILvlL",160)
											end
										elseif SN == "AWARDILVLLA" then
											if 18 <= L and L <= 24 then
												Result = CalcStat("AwardILvlA",L)+2
											elseif 25 <= L and L <= 29 then
												Result = CalcStat("AwardILvlLA",24)
											else
												Result = CalcStat("AwardILvlL",L)
											end
										elseif SN == "AWARDILVLM" then
											if L <= 140 then
												Result = CalcStat("AwardILvlC",L)
											elseif L <= 150 then
												Result = CalcStat("AwardILvlC",L)-21
											elseif L <= 160 then
												Result = RoundDbl(LinFmod(1.0,550.4,565.4,151,160,L))
											else
												Result = CalcStat("AwardILvlM",160)
											end
										end
									else
										if L <= 150 then
											Result = CalcStat("AwardILvlM",L)
										elseif L <= 160 then
											Result = RoundDbl(LinFmod(1.0,550.4,560.4,151,160,L))
										else
											Result = CalcStat("AwardILvlMA",160)
										end
									end
								else
									Result = CalcStat("CombatBaseTacHPSLvlToILvl",L)
								end
							else
								Result = CalcStat("AwardILvlC",L)
							end
						else
							if L <= 4 then
								Result = CalcStat("AwardILvlA",1)
							elseif L <= 50 then
								Result = CalcStat("AwardILvlA",L-4)
							elseif L <= 54 then
								Result = CalcStat("AwardILvlA",51)
							elseif L <= 75 then
								Result = CalcStat("AwardILvlA",L-4)
							else
								Result = L-4
							end
						end
					elseif SN < "AWARDILVLCD" then
						if SN < "ARMOUR" then
							if SN > "ADJITEMRAT" then
								if SN < "AGILITY" then
									if SN > "ADJTRAITMIT" then
										if SN == "ADJTRAITRAT" then
											if 141 <= L and L <= 150 then
												Result = 0.9
											elseif 151 <= L and L <= 160 then
												Result = 0.8
											else
												Result = 1.0
											end
										elseif SN == "ADJVIRTUEMAS" then
											if L == 399 then
												Result = 18.666/17.0
											elseif L == 499 then
												Result = 0.9
											elseif 500 <= L and L <= 549 then
												Result = 14.0/17.0
											elseif L == 550 then
												Result = 0.75
											elseif L == 599 then
												Result = 0.7
											else
												Result = 1.0
											end
										elseif SN == "ADJVIRTUEMORALE" then
											if L == 50 then
												Result = 2.0
											elseif 60 <= L and L <= 80 then
												Result = 1.5
											elseif L == 499 then
												Result = 0.9475
											else
												Result = 1.0
											end
										end
									elseif SN < "ADJTRAITMIT" then
										if SN == "ADJTRAITHEALTH" then
											if L <= 25 then
												Result = 0.5
											elseif L <= 50 then
												Result = 0.6
											elseif L <= 60 then
												Result = 0.7
											elseif L <= 65 then
												Result = 0.8
											elseif L <= 75 then
												Result = 0.9
											else
												Result = 1.0
											end
										elseif SN == "ADJTRAITMAIN" then
											if 141 <= L and L <= 150 then
												Result = 0.9
											elseif 151 <= L and L <= 160 then
												Result = 0.85
											else
												Result = 1.0
											end
										elseif SN == "ADJTRAITMAS" then
											if L == 141 then
												Result = 0.9
											elseif L == 150 then
												Result = 14.0/17.0
											elseif 151 <= L and L <= 160 then
												Result = 0.78
											else
												Result = 1.0
											end
										end
									else
										if L == 141 then
											Result = 0.78
										elseif L == 150 then
											Result = 0.7
										elseif 151 <= L and L <= 160 then
											Result = 0.65
										else
											Result = 1.0
										end
									end
								elseif SN > "AGILITY" then
									if SN > "ALIGNMENTNAME" then
										if SN == "ANCIENTDWARFMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										elseif SN == "ANCIENTDWARFMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										elseif SN == "ARMCATPROGB" then
											if L == 1 then
												Result = CalcStat("MitHeavyPRatPB",N)
											elseif L == 2 then
												Result = CalcStat("MitMediumPRatPB",N)
											elseif L == 3 then
												Result = CalcStat("MitLightPRatPB",N)
											end
										end
									elseif SN < "ALIGNMENTNAME" then
										if SN == "AGILITYC" then
											Result = CalcStat("MainC",L,N)
										elseif SN == "AGILITYCI" then
											Result = CalcStat("MainCI",L,N)
										elseif SN == "AGILITYT" then
											Result = CalcStat("MainT",L,N)
										end
									else
										Result = TranslateValue({1,2,3},{"Good","Neutral","Evil",""},L)
									end
								else
									Result = CalcStat("Main",L,N)
								end
							elseif SN < "ADJITEMRAT" then
								if SN < "ADJCREEPHEALTH" then
									if SN > "ACIDMITT" then
										if SN == "ADJCLASSBASEPOWREG" then
											if L <= 1 then
												Result = 1.5
											elseif L <= 20 then
												Result = 1.1
											else
												Result = 1.0
											end
										elseif SN == "ADJCREEPENERGY" then
											if L == 500 then
												Result = 0.931
											elseif L == 550 then
												Result = 0.931
											else
												Result = 1.0
											end
										elseif SN == "ADJCREEPEXTRA" then
											if L == 500 then
												Result = 0.93145
											elseif L == 550 then
												Result = 0.952
											else
												Result = 1.0
											end
										end
									elseif SN < "ACIDMITT" then
										if SN == "-VERSION" then
											Result = "2.5.6f"
										elseif SN == "ACIDMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										end
									else
										Result = CalcStat("DmgTypeMitT",L,N)
									end
								elseif SN > "ADJCREEPHEALTH" then
									if SN > "ADJITEMHEALTH" then
										if SN == "ADJITEMMAIN" then
											if 499 <= L and L <= 549 then
												Result = 0.9
											elseif 550 <= L and L <= 599 then
												Result = 0.85
											else
												Result = 1.0
											end
										elseif SN == "ADJITEMMAS" then
											if L == 499 then
												Result = 0.9
											elseif 500 <= L and L <= 549 then
												Result = 14.0/17.0
											elseif 550 <= L and L <= 599 then
												Result = 0.78
											else
												Result = 1.0
											end
										elseif SN == "ADJITEMMIT" then
											if L == 499 then
												Result = 0.78
											elseif 500 <= L and L <= 549 then
												Result = 0.7
											elseif 550 <= L and L <= 599 then
												Result = 0.65
											else
												Result = 1.0
											end
										end
									elseif SN < "ADJITEMHEALTH" then
										if SN == "ADJCREEPMAIN" then
											if L == 500 then
												Result = 0.93
											elseif L == 550 then
												Result = 0.9465
											else
												Result = 1.0
											end
										elseif SN == "ADJCREEPMIT" then
											if L == 500 then
												Result = 0.93
											elseif L == 550 then
												Result = 0.9465
											else
												Result = 1.0
											end
										elseif SN == "ADJCREEPSTD" then
											if L == 500 then
												Result = 0.931
											elseif L == 550 then
												Result = 0.95
											else
												Result = 1.0
											end
										end
									else
										if L <= 25 then
											Result = 0.5
										elseif L <= 50 then
											Result = 0.6
										elseif L <= 60 then
											Result = 0.7
										elseif L <= 79 then
											Result = 0.8
										elseif L <= 80 then
											Result = 0.9
										else
											Result = 1.0
										end
									end
								else
									if L == 500 then
										Result = 0.931
									elseif L == 550 then
										Result = 0.931
									else
										Result = 1.0
									end
								end
							else
								if 499 <= L and L <= 549 then
									Result = 0.9
								elseif 550 <= L and L <= 599 then
									Result = 0.8
								else
									Result = 1.0
								end
							end
						elseif SN > "ARMOUR" then
							if SN > "ARMQTYRAREMP" then
								if SN < "AWARDILVLAOLD" then
									if SN > "AWARDILVLA" then
										if SN == "AWARDILVLAA" then
											if L == 75 then
												Result = CalcStat("AwardILvlA",L)+3
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLAB" then
											if L == 75 then
												Result = CalcStat("AwardILvlA",L)+1
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLAC" then
											if L == 75 then
												Result = CalcStat("AwardILvlA",L)+2
											else
												Result = CalcStat("AwardILvlA",L)
											end
										end
									elseif SN < "AWARDILVLA" then
										if SN == "ARMQTYUNCOMMP" then
											if 1 <= L and L <= 8 then
												Result = DataTableValue({7260.0,7260.0,8415.0,8415.0,8118.0,8469.0,8415.0,7425.0},L)
											end
										elseif SN == "ARMTYPEMP" then
											if 1 <= L and L <= 8 then
												Result = DataTableValue({990.0,990.0,2200.0,3300.0,1650.0,2739.0,1320.0,3600.0},L)
											end
										elseif SN == "AUTOLVLTOILVL" then
											Result = CalcStat("AwardILvlCC",L)
										end
									else
										if L <= 75 then
											Result = L
										elseif L <= 94 then
											Result = 5*L-304
										elseif L <= 95 then
											Result = 173
										elseif L <= 100 then
											Result = 5*L-304
										elseif L <= 101 then
											Result = 197
										elseif L <= 104 then
											Result = 4*L-206
										elseif L <= 105 then
											Result = 218
										elseif L <= 110 then
											Result = RoundDbl(LinFmod(1.0,295.0,303.8,106,110,L))
										elseif L <= 115 then
											Result = 304
										elseif L <= 119 then
											Result = RoundDbl(LinFmod(1.0,345.0,357.0,116,119,L))
										elseif L <= 120 then
											Result = 359
										elseif L <= 130 then
											Result = 395
										elseif L <= 140 then
											Result = RoundDbl(LinFmod(1.0,445.4,455.4,131,140,L))
										elseif L <= 150 then
											Result = RoundDbl(LinFmod(1.0,479.4,491.4,141,150,L))
										elseif L <= 160 then
											Result = RoundDbl(LinFmod(1.0,529.4,539.4,151,160,L))
										else
											Result = CalcStat("AwardILvlA",160)
										end
									end
								elseif SN > "AWARDILVLAOLD" then
									if SN > "AWARDILVLC" then
										if SN == "AWARDILVLCA" then
											if L <= 8 then
												Result = CalcStat("AwardILvlA",1)
											elseif L <= 85 then
												Result = CalcStat("AwardILvlA",L)-8
											elseif 96 <= L and L <= 100 then
												Result = CalcStat("AwardILvlA",L)+4
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLCB" then
											if L <= 10 then
												Result = CalcStat("AwardILvlA",1)
											elseif L <= 85 then
												Result = CalcStat("AwardILvlA",L)-10
											elseif 96 <= L and L <= 99 then
												Result = CalcStat("AwardILvlA",L)+4
											elseif L == 100 then
												Result = CalcStat("AwardILvlA",L)+6
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLCC" then
											Result = CalcStat("AwardILvlC",L)
										end
									elseif SN < "AWARDILVLC" then
										if SN == "AWARDILVLB" then
											if L <= 4 then
												Result = CalcStat("AwardILvlA",1)
											elseif L <= 50 then
												Result = CalcStat("AwardILvlA",L-4)
											elseif L <= 54 then
												Result = CalcStat("AwardILvlA",51)
											elseif L <= 75 then
												Result = CalcStat("AwardILvlA",L-4)
											elseif L <= 95 then
												Result = CalcStat("AwardILvlA",L)+4
											else
												Result = CalcStat("AwardILvlA",L)
											end
										elseif SN == "AWARDILVLBA" then
											Result = CalcStat("AwardILvlB",L)
										elseif SN == "AWARDILVLBOLD" then
											Result = CalcStat("AwardILvlB",L)
										end
									else
										if L <= 75 then
											Result = CalcStat("AwardILvlB",L)
										else
											Result = CalcStat("AwardILvlA",L)
										end
									end
								else
									Result = CalcStat("AwardILvlA",L)
								end
							elseif SN < "ARMQTYRAREMP" then
								if SN < "ARMOURPROGB" then
									if SN > "ARMOURLOW" then
										if SN == "ARMOURLOWPNTMP" then
											Result = CalcStat("ArmTypeMP",ArmCodeIndex(C,2))/82500.0
										elseif SN == "ARMOURPENT" then
											Result = EquSng(StatLinInter("PntMPArmourPenT","TraitPntS","MitMediumPRatPB","",L,N,2))
										elseif SN == "ARMOURPNTMP" then
											Result = (CalcStat("ArmTypeMP",ArmCodeIndex(C,2))/82500.0)*(CalcStat("ArmQtyMP",ArmCodeIndex(C,3),ArmCodeIndex(C,2))/3600.0)
										end
									elseif SN < "ARMOURLOW" then
										if SN == "ARMOURC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ArmourCI",CalcStat("ArmourCILvlFilter",L,N),N),2)
										elseif SN == "ARMOURCI" then
											Result = RoundDblLotro(StatLinInter("PntMPArmourC","ItemPntS","MitMediumPRatPB","AdjCreepMit",L,N))
										elseif SN == "ARMOURCILVLFILTER" then
											Result = TranslateValue({5.6},{565,570},N)
										end
									else
										Result = RoundDblDown(StatLinInter("ArmourLowPntMP","ItemPntS","ArmourProgB","AdjItemMit",L,C,2),0)
									end
								elseif SN > "ARMOURPROGB" then
									if SN > "ARMQTYCOMMMP" then
										if SN == "ARMQTYEPICMP" then
											if 1 <= L and L <= 8 then
												Result = DataTableValue({9900.0,9900.0,9900.0,9900.0,9900.0,9960.0,9900.0,9900.0},L)
											end
										elseif SN == "ARMQTYINCOMPMP" then
											if 1 <= L and L <= 8 then
												Result = DataTableValue({9240.0,9240.0,9405.0,9405.0,9306.0,9423.0,9405.0,9405.0},L)
											end
										elseif SN == "ARMQTYMP" then
											if L == 1 then
												Result = CalcStat("ArmQtyCommMP",N)
											elseif L == 2 then
												Result = CalcStat("ArmQtyUncomMP",N)
											elseif L == 3 then
												Result = CalcStat("ArmQtyRareMP",N)
											elseif L == 4 then
												Result = CalcStat("ArmQtyIncompMP",N)
											elseif L == 5 then
												Result = CalcStat("ArmQtyEpicMP",N)
											end
										end
									elseif SN < "ARMQTYCOMMMP" then
										if SN == "ARMOURREND" then
											Result = CalcStat("DmgTypeMit",L,N)
										elseif SN == "ARMOURRENDT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										elseif SN == "ARMOURT" then
											Result = EquSng(StatLinInter("PntMPArmourT","TraitPntS","MitMediumPRatPB","AdjTraitMit",L,N,2))
										end
									else
										if 1 <= L and L <= 8 then
											Result = DataTableValue({7260.0,7260.0,7920.0,7920.0,7524.0,7992.0,7920.0,6930.0},L)
										end
									end
								else
									Result = CalcStat("ArmCatProgB",ArmCodeIndex(C,1),L)
								end
							else
								if 1 <= L and L <= 8 then
									Result = DataTableValue({8580.0,8580.0,8910.0,8910.0,8712.0,8945.0,8910.0,7920.0},L)
								end
							end
						else
							Result = RoundDblDown(StatLinInter("ArmourPntMP","ItemPntS","ArmourProgB","AdjItemMit",L,C,2),0)
						end
					else
						if L <= 8 then
							Result = CalcStat("AwardILvlA",1)
						elseif L <= 85 then
							Result = CalcStat("AwardILvlA",L)-8
						elseif L <= 100 then
							Result = CalcStat("AwardILvlA",L)-4
						elseif L <= 105 then
							Result = CalcStat("AwardILvlA",L)+4
						else
							Result = CalcStat("AwardILvlA",L)
						end
					end
				elseif SN > "BEOMIGHTOFTHEWILDMIGHT" then
					if SN > "BLOCKPBONUS" then
						if SN < "BRATSTANDARD" then
							if SN > "BPEPRATPA" then
								if SN < "BRATEXTRA" then
									if SN > "BPEPRATPCAPR" then
										if SN == "BPET" then
											Result = EquSng(StatLinInter("PntMPBPE","TraitPntS","BPEPRatPB","AdjTraitRat",L,N,2))
										elseif SN == "BRATCRITMAGN" then
											Result = CalcStat("BRatRounded",L,CalcStat("StdProgRatings",L,600.0))
										elseif SN == "BRATDEVHIT" then
											Result = CalcStat("BRatRounded",L,CalcStat("StdProgRatings",L,400.0))
										end
									elseif SN < "BPEPRATPCAPR" then
										if SN == "BPEPRATPB" then
											Result = CalcStat("BRatStandard",L)
										elseif SN == "BPEPRATPC" then
											Result = 0.5
										elseif SN == "BPEPRATPCAP" then
											Result = 13.0
										end
									else
										Result = CalcStat("BPEPRatPB",L)*CalcStat("BPEPRatPC",L)
									end
								elseif SN > "BRATEXTRA" then
									if SN > "BRATMITMEDIUM" then
										if SN == "BRATOUTHEAL" then
											Result = CalcStat("BRatRounded",L,CalcStat("StdProgRatings",L,450.0))
										elseif SN == "BRATPARTBPE" then
											Result = CalcStat("BRatRounded",L,CalcStat("StdProgRatings",L,350.0))
										elseif SN == "BRATROUNDED" then
											if L <= 50 then
												Result = RoundDbl(N,0)
											elseif L <= 105 then
												Result = RoundDbl(N,-1)
											elseif L <= 115 then
												Result = RoundDbl(N,-2)
											elseif L <= 130 then
												Result = RoundDbl(N,-1)
											elseif L <= 160 then
												Result = RoundDbl(N,-2)
											else
												Result = RoundDbl(N,0)
											end
										end
									elseif SN < "BRATMITMEDIUM" then
										if SN == "BRATMITBASE" then
											Result = StatLinInter("","StdPntS","BRatStandard","",L,N,1)
										elseif SN == "BRATMITHEAVY" then
											if L <= 1 then
												Result = 200.0
											elseif 50 <= L then
												Result = CalcStat("BRatRounded",L,CalcStat("BRatMitBase",L,1.0))
											else
												Result = RoundDbl(LinFmod(1.0,CalcStat("BRatMitHeavy",1),CalcStat("BRatMitHeavy",50),1,50,L),0)
											end
										elseif SN == "BRATMITLIGHT" then
											if L <= 1 then
												Result = 105.0
											elseif 50 <= L then
												Result = CalcStat("BRatRounded",L,CalcStat("BRatMitBase",L,0.666))
											else
												Result = RoundDbl(LinFmod(1.0,CalcStat("BRatMitLight",1),CalcStat("BRatMitLight",50),1,50,L),0)
											end
										end
									else
										if L <= 1 then
											Result = 144.0
										elseif 50 <= L then
											Result = CalcStat("BRatRounded",L,CalcStat("BRatMitBase",L,0.833))
										else
											Result = RoundDbl(LinFmod(1.0,CalcStat("BRatMitMedium",1),CalcStat("BRatMitMedium",50),1,50,L),0)
										end
									end
								else
									Result = CalcStat("BRatRounded",L,CalcStat("StdProgRatings",L,300.0))
								end
							elseif SN < "BPEPRATPA" then
								if SN < "BLOCKPRATPCAPR" then
									if SN > "BLOCKPRATPA" then
										if SN == "BLOCKPRATPB" then
											Result = CalcStat("BPEPRatPB",L)
										elseif SN == "BLOCKPRATPC" then
											Result = CalcStat("BPEPRatPC",L)
										elseif SN == "BLOCKPRATPCAP" then
											Result = CalcStat("BPEPRatPCap",L)
										end
									elseif SN < "BLOCKPRATPA" then
										if SN == "BLOCKPPRAT" then
											Result = CalcStat("BPEPPRat",L,N)
										elseif SN == "BLOCKPRATP" then
											Result = CalcStat("BPEPRatP",L,N)
										end
									else
										Result = CalcStat("BPEPRatPA",L)
									end
								elseif SN > "BLOCKPRATPCAPR" then
									if SN > "BPECI" then
										if SN == "BPECILVLFILTER" then
											Result = TranslateValue({3.8,4.0,4.6,6.2,8.0,12.0},{565,565,565,565,565,565,570},N)
										elseif SN == "BPEPPRAT" then
											Result = CalcRatAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCapR",L),N)
										elseif SN == "BPEPRATP" then
											Result = CalcPercAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCap",L),N)
										end
									elseif SN < "BPECI" then
										if SN == "BLOCKT" then
											Result = CalcStat("BPET",L,N)
										elseif SN == "BPE" then
											Result = EquSng(StatLinInter("PntMPBPE","ItemPntS","BPEPRatPB","AdjItemRat",L,N,2))
										elseif SN == "BPEC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("BPECI",CalcStat("BPECILvlFilter",L,N),N),2)
										end
									else
										Result = RoundDblLotro(StatLinInter("PntMPBPEC","ItemPntS","BPEPRatPB","AdjCreepStd",L,N))
									end
								else
									Result = CalcStat("BPEPRatPCapR",L)
								end
							else
								Result = 39.0
							end
						elseif SN > "BRATSTANDARD" then
							if SN > "BRAWLERCDBASENCMR" then
								if SN < "BRAWLERCDFATETOICPR" then
									if SN > "BRAWLERCDBASEWILL" then
										if SN == "BRAWLERCDCALCTYPECOMPHYMIT" then
											Result = 14
										elseif SN == "BRAWLERCDCALCTYPENONPHYMIT" then
											Result = 14
										elseif SN == "BRAWLERCDCALCTYPETACMIT" then
											Result = 27
										end
									elseif SN < "BRAWLERCDBASEWILL" then
										if SN == "BRAWLERCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "BRAWLERCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										elseif SN == "BRAWLERCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										end
									else
										Result = CalcStat("ClassBaseWillL",L)
									end
								elseif SN > "BRAWLERCDFATETOICPR" then
									if SN > "BRAWLERCDMIGHTTOCRITHIT" then
										if SN == "BRAWLERCDMIGHTTOEVADE" then
											Result = 1.0
										elseif SN == "BRAWLERCDMIGHTTOOUTHEAL" then
											Result = 3.0
										elseif SN == "BRAWLERCDMIGHTTOPARRY" then
											Result = 1.0
										end
									elseif SN < "BRAWLERCDMIGHTTOCRITHIT" then
										if SN == "BRAWLERCDFATETONCPR" then
											Result = 0.15
										elseif SN == "BRAWLERCDFATETOPOWER" then
											Result = 1.5
										elseif SN == "BRAWLERCDHASPOWER" then
											Result = 1
										end
									else
										Result = 1.0
									end
								else
									Result = 0.015
								end
							elseif SN < "BRAWLERCDBASENCMR" then
								if SN < "BRAWLERCDARMOURTOTACMIT" then
									if SN > "BRAWLERCDAGILITYTOOUTHEAL" then
										if SN == "BRAWLERCDAGILITYTOPHYMAS" then
											Result = 2.0
										elseif SN == "BRAWLERCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "BRAWLERCDARMOURTONONPHYMIT" then
											Result = 0.2
										end
									elseif SN < "BRAWLERCDAGILITYTOOUTHEAL" then
										if SN == "BRAWLERCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "BRAWLERCDAGILITYTOEVADE" then
											Result = 2.0
										elseif SN == "BRAWLERCDAGILITYTOFINESSE" then
											Result = 1.0
										end
									else
										Result = 2.0
									end
								elseif SN > "BRAWLERCDARMOURTOTACMIT" then
									if SN > "BRAWLERCDBASEICMR" then
										if SN == "BRAWLERCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "BRAWLERCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightH",L)
										elseif SN == "BRAWLERCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										end
									elseif SN < "BRAWLERCDBASEICMR" then
										if SN == "BRAWLERCDARMOURTYPE" then
											Result = 3
										elseif SN == "BRAWLERCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityM",L)
										elseif SN == "BRAWLERCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										end
									else
										Result = CalcStat("ClassBaseICMRL",L)
									end
								else
									Result = 0.2
								end
							else
								Result = CalcStat("ClassBaseNCMRL",L)
							end
						else
							Result = CalcStat("BRatRounded",L,CalcStat("StdProgRatings",L,200.0))
						end
					elseif SN < "BLOCKPBONUS" then
						if SN < "BEORNINGCDMIGHTTOPARRY" then
							if SN > "BEORNINGCDBASEMORALE" then
								if SN < "BEORNINGCDCALCTYPETACMIT" then
									if SN > "BEORNINGCDBASEVITALITY" then
										if SN == "BEORNINGCDBASEWILL" then
											Result = CalcStat("ClassBaseWillM",L)
										elseif SN == "BEORNINGCDCALCTYPECOMPHYMIT" then
											Result = 14
										elseif SN == "BEORNINGCDCALCTYPENONPHYMIT" then
											Result = 14
										end
									elseif SN < "BEORNINGCDBASEVITALITY" then
										if SN == "BEORNINGCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRM",L)
										elseif SN == "BEORNINGCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "BEORNINGCDBASEPOWER" then
											Result = 10
										end
									else
										Result = CalcStat("ClassBaseVitality",L)
									end
								elseif SN > "BEORNINGCDCALCTYPETACMIT" then
									if SN > "BEORNINGCDFATETONCMR" then
										if SN == "BEORNINGCDMIGHTTOCRITHIT" then
											Result = 1.0
										elseif SN == "BEORNINGCDMIGHTTOEVADE" then
											Result = 2.0
										elseif SN == "BEORNINGCDMIGHTTOOUTHEAL" then
											Result = 3.0
										end
									elseif SN < "BEORNINGCDFATETONCMR" then
										if SN == "BEORNINGCDCANBLOCK" then
											if 6 <= L then
												Result = 1
											end
										elseif SN == "BEORNINGCDFATETOICMR" then
											Result = 0.1
										elseif SN == "BEORNINGCDFATETOMORALE" then
											Result = 1.0
										end
									else
										Result = 0.24
									end
								else
									Result = 27
								end
							elseif SN < "BEORNINGCDBASEMORALE" then
								if SN < "BEORNINGCDARMOURTONONPHYMIT" then
									if SN > "BEORNINGCDAGILITYTOFINESSE" then
										if SN == "BEORNINGCDAGILITYTOOUTHEAL" then
											Result = 2.0
										elseif SN == "BEORNINGCDAGILITYTOPHYMAS" then
											Result = 2.0
										elseif SN == "BEORNINGCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										end
									elseif SN < "BEORNINGCDAGILITYTOFINESSE" then
										if SN == "BEORNINGCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "BEORNINGCDAGILITYTOEVADE" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "BEORNINGCDARMOURTONONPHYMIT" then
									if SN > "BEORNINGCDBASEFATE" then
										if SN == "BEORNINGCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRM",L)
										elseif SN == "BEORNINGCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "BEORNINGCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										end
									elseif SN < "BEORNINGCDBASEFATE" then
										if SN == "BEORNINGCDARMOURTOTACMIT" then
											Result = 0.2
										elseif SN == "BEORNINGCDARMOURTYPE" then
											Result = 3
										elseif SN == "BEORNINGCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityM",L)
										end
									else
										Result = CalcStat("ClassBaseFate",L)
									end
								else
									Result = 0.2
								end
							else
								Result = CalcStat("ClassBaseMorale",L)
							end
						elseif SN > "BEORNINGCDMIGHTTOPARRY" then
							if SN > "BEORNINGRDPSVONEFATE" then
								if SN < "BLACKARROWCANBLOCK" then
									if SN > "BEORNINGRDTRAITMIGHT" then
										if SN == "BEORNINGRDTRAITVITALITY" then
											Result = CalcStat("BeoThickHideVitality",L)
										elseif SN == "BEOTHICKHIDEVITALITY" then
											Result = CalcStat("VitalityT",L,1.0)
										elseif SN == "BEOVITALITYINCREASE" then
											Result = CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4)
										end
									elseif SN < "BEORNINGRDTRAITMIGHT" then
										if SN == "BEORNINGRDPSVONENAME" then
											Result = "Emissary"
										elseif SN == "BEORNINGRDPSVTWONAME" then
											Result = ""
										elseif SN == "BEORNINGRDTRAITFATE" then
											Result = CalcStat("BeoFewinNumberFate",L)
										end
									else
										Result = CalcStat("BeoMightoftheWildMight",L)
									end
								elseif SN > "BLACKARROWCANBLOCK" then
									if SN > "BLACKARROWCDHASPOWER" then
										if SN == "BLOCK" then
											Result = CalcStat("BPE",L,N)
										elseif SN == "BLOCKC" then
											Result = CalcStat("BPEC",L,N)
										elseif SN == "BLOCKCI" then
											Result = CalcStat("BPECI",L,N)
										end
									elseif SN < "BLACKARROWCDHASPOWER" then
										if SN == "BLACKARROWCDCALCTYPECOMPHYMIT" then
											Result = 13
										elseif SN == "BLACKARROWCDCALCTYPENONPHYMIT" then
											Result = 14
										elseif SN == "BLACKARROWCDCALCTYPETACMIT" then
											Result = 27
										end
									else
										Result = 1
									end
								else
									Result = 1
								end
							elseif SN < "BEORNINGRDPSVONEFATE" then
								if SN < "BEORNINGCDVITALITYTOMORALE" then
									if SN > "BEORNINGCDPHYMITTOCOMPHYMIT" then
										if SN == "BEORNINGCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "BEORNINGCDTACMASTOOUTHEAL" then
											Result = 1.0
										elseif SN == "BEORNINGCDVITALITYTOICMR" then
											Result = 0.012
										end
									elseif SN < "BEORNINGCDPHYMITTOCOMPHYMIT" then
										if SN == "BEORNINGCDMIGHTTOPHYMAS" then
											Result = 3.0
										elseif SN == "BEORNINGCDMIGHTTOPHYMIT" then
											Result = 1.0
										elseif SN == "BEORNINGCDMIGHTTOTACMIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "BEORNINGCDVITALITYTOMORALE" then
									if SN > "BEORNINGCDWILLTOPHYMAS" then
										if SN == "BEORNINGCDWILLTOPHYMIT" then
											Result = 1.5
										elseif SN == "BEORNINGCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "BEORNINGCDWILLTOTACMIT" then
											Result = 1.5
										end
									elseif SN < "BEORNINGCDWILLTOPHYMAS" then
										if SN == "BEORNINGCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "BEORNINGCDWILLTOFINESSE" then
											Result = 1.0
										elseif SN == "BEORNINGCDWILLTOOUTHEAL" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								else
									Result = 4.5
								end
							else
								Result = CalcStat("BeoEmissaryFate",L)
							end
						else
							Result = 1.0
						end
					else
						Result = CalcStat("BPEPBonus",L)
					end
				else
					Result = CalcStat("MightT",L,1.0)
				end
			else
				Result = 3.0
			end
		elseif SN > "COMMONMITT" then
			if SN > "HIGHELFRDTRAITFATE" then
				if SN < "LOREMASTERCDAGILITYTOFINESSE" then
					if SN > "HUNTERCDWILLTOPHYMIT" then
						if SN < "ITEMPNTS" then
							if SN > "INDMGPRATPA" then
								if SN < "INHEALPRATPA" then
									if SN > "INDMGPRATPCAPR" then
										if SN == "INHEAL" then
											Result = EquSng(StatLinInter("PntMPInHeal","ItemPntS","InHealPRatPB","AdjItemRat",L,N,2))
										elseif SN == "INHEALPPRAT" then
											Result = CalcRatAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCapR",L),N)
										elseif SN == "INHEALPRATP" then
											Result = CalcPercAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCap",L),N)
										end
									elseif SN < "INDMGPRATPCAPR" then
										if SN == "INDMGPRATPB" then
											Result = CalcStat("BRatStandard",L)
										elseif SN == "INDMGPRATPC" then
											Result = 0.5
										elseif SN == "INDMGPRATPCAP" then
											Result = 400.0
										end
									else
										Result = CalcStat("InDmgPRatPB",L)*CalcStat("InDmgPRatPC",L)
									end
								elseif SN > "INHEALPRATPA" then
									if SN > "INHEALPRATPCAPR" then
										if SN == "INHEALT" then
											Result = EquSng(StatLinInter("PntMPInHeal","TraitPntS","InHealPRatPB","AdjTraitRat",L,N,2))
										elseif SN == "INSTRMORALE" then
											Result = RoundDblUp(CalcStat("DirectHealth",L,2783.646/1200.0),0)
										elseif SN == "INSTRPOWER" then
											Result = RoundDblUp(CalcStat("DirectEnergy",L,20805.0/1200.0),0)
										end
									elseif SN < "INHEALPRATPCAPR" then
										if SN == "INHEALPRATPB" then
											Result = CalcStat("BRatStandard",L)
										elseif SN == "INHEALPRATPC" then
											Result = 0.5
										elseif SN == "INHEALPRATPCAP" then
											Result = 25.0
										end
									else
										Result = CalcStat("InHealPRatPB",L)*CalcStat("InHealPRatPC",L)
									end
								else
									Result = 75.0
								end
							elseif SN < "INDMGPRATPA" then
								if SN < "ICMRT" then
									if SN > "ICMRC" then
										if SN == "ICMRCI" then
											Result = RoundDblProg(StatLinInter("PntMPICMRC","ItemPntSVital","ProgBHealth","AdjCreepHealth",L,N))
										elseif SN == "ICMRCILVLFILTER" then
											Result = TranslateValue({0},{570},N)
										elseif SN == "ICMRDEBUFFT" then
											Result = EquSng(StatLinInter("PntMPICMRDebuffT","TraitPntSVital","ProgBHealth","",L,N))
										end
									elseif SN < "ICMRC" then
										if SN == "HUNTERCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "ICMR" then
											Result = EquSng(StatLinInter("PntMPICMR","ItemPntSVital","ProgBHealth","",L,N,3))
										end
									else
										Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ICMRCI",CalcStat("ICMRCILvlFilter",L,N),N),2)
									end
								elseif SN > "ICMRT" then
									if SN > "ICPRCILVLFILTER" then
										if SN == "ICPRT" then
											Result = EquSng(StatLinInter("PntMPICPR","TraitPntSVital","ProgBEnergy","",L,N))
										elseif SN == "INDMGPPRAT" then
											Result = CalcRatAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCapR",L),N)
										elseif SN == "INDMGPRATP" then
											Result = CalcPercAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCap",L),N)
										end
									elseif SN < "ICPRCILVLFILTER" then
										if SN == "ICPR" then
											Result = EquSng(StatLinInter("PntMPICPR","ItemPntSVital","ProgBEnergy","",L,N))
										elseif SN == "ICPRC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("ICPRCI",CalcStat("ICPRCILvlFilter",L,N),N),2)
										elseif SN == "ICPRCI" then
											Result = RoundDbl(StatLinInter("PntMPICPRC","ItemPntSVital","ProgBEnergy","AdjCreepEnergy",L,N),1)
										end
									else
										Result = TranslateValue({0},{570},N)
									end
								else
									Result = EquSng(StatLinInter("PntMPICMR","TraitPntSVital","ProgBHealth","",L,N,3))
								end
							else
								Result = 1200.0
							end
						elseif SN > "ITEMPNTS" then
							if SN > "LI2WPNSOCKMASTERY" then
								if SN < "LMHEARTYDIETMORALECHOICE" then
									if SN > "LIGHTNINGMIT" then
										if SN == "LIGHTNINGMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										elseif SN == "LMANCIENTWISDOMWILL" then
											Result = RoundDblUp(CalcStat("DirectRatings",L,969.95/1200.0))
										elseif SN == "LMHEARTYDIETMORALE" then
											Result = CalcStat("Morale",L,CalcStat("LmHeartyDietMoraleChoice",N))
										end
									elseif SN < "LIGHTNINGMIT" then
										if SN == "LI2WPNSOCKPOWER" then
											Result = RoundDblDown(LinInter({{1,60,425,999},{0.0,1.0,2.0,2.0}},L))
										elseif SN == "LIGHTMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										elseif SN == "LIGHTMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										end
									else
										Result = CalcStat("DmgTypeMit",L,N)
									end
								elseif SN > "LMHEARTYDIETMORALECHOICE" then
									if SN > "LOE" then
										if SN == "LOEPASSIVE" then
											if 116 <= L and L <= 119 then
												Result = 20*L-2300
											elseif 120 <= L then
												Result = CalcStat("LoEPassive",119)
											end
										elseif SN == "LOREMASTERCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "LOREMASTERCDAGILITYTOEVADE" then
											Result = 1.0
										end
									elseif SN < "LOE" then
										if SN == "LMPREPFORWARTACMAS" then
											Result = CalcStat("TacMasT",L,CalcStat("Trait12345Choice",N)*0.4)
										elseif SN == "LMSWSTAFFBUGMORALE" then
											Result = RoundDblUp(CalcStat("DirectHealth",L,4580.1175/1200.0),0)
										elseif SN == "LMSWSTAFFBUGPARRY" then
											Result = EquSng(DecSng(CalcStat("DirectRatings",L,7493.0/1200.0)))
										end
									else
										Result = 2*N
									end
								else
									if 1 <= L and L <= 6 then
										Result = DataTableValue({0.4,1.0,1.6,2.4,3.2,3.2},L)
									end
								end
							elseif SN < "LI2WPNSOCKMASTERY" then
								if SN < "LI2CLISOCKMASTERY" then
									if SN > "L" then
										if SN == "LEVELCAP" then
											Result = 160
										elseif SN == "LI2CLISOCKCRAFT" then
											Result = RoundDblDown(LinInter({{1,50,330,999},{0.0,1.0,2.0,2.0}},L))
										elseif SN == "LI2CLISOCKHERALDIC" then
											Result = RoundDblDown(LinInter({{1,52,999},{0.0,1.0,1.0}},L))
										end
									elseif SN < "L" then
										if SN == "ITEMPNTSVIRTUEMASTERY" then
											Result = {{0,1,25,50,79,80,200,225,300,349,399,400,449,450,499,500,549,550,599},{0,1,25,50,75,76,100,105,106,115,116,121,130,131,140,141,150,151,160}}
										elseif SN == "ITEMPNTSVIRTUEMORALE" then
											Result = {{0,1,2,50,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599,600,649},{0,1,2,50,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170}}
										elseif SN == "ITEMPNTSVITAL" then
											Result = {{1,25,50,60,79,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599,600,649},{1,25,50,60,75,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170}}
										end
									else
										Result = L
									end
								elseif SN > "LI2CLISOCKMASTERY" then
									if SN > "LI2REFORGECOSTSEG" then
										if SN == "LI2REFORGEILVL" then
											Result = RoundDbl(CalcRatAB(N+N,CalcStat("AwardILvlI",L),N,N))
										elseif SN == "LI2WPNSOCKCRAFT" then
											Result = RoundDblDown(LinInter({{1,50,330,999},{0.0,1.0,2.0,2.0}},L))
										elseif SN == "LI2WPNSOCKHERALDIC" then
											Result = RoundDblDown(LinInter({{1,52,999},{0.0,1.0,1.0}},L))
										end
									elseif SN < "LI2REFORGECOSTSEG" then
										if SN == "LI2CLISOCKPOWER" then
											Result = RoundDblDown(LinInter({{1,60,175,425,999},{0.0,1.0,2.0,3.0,3.0}},L))
										elseif SN == "LI2ILVLCAP" then
											Result = 570
										elseif SN == "LI2REFORGECOST" then
											if L <= 150 then
												Result = RoundDbl(CalcStat("Li2ReforgeCostSeg",L)*(L+9)*12.5)
											else
												Result = CalcStat("Li2ReforgeCost",150)
											end
										end
									else
										if L <= 0 then
											Result = 0.0
										elseif 1 <= L and L <= 12 then
											Result = DataTableValue({1.0,1.2,1.4,1.7,2.1,2.5,3.0,3.6,4.3,5.1,6.4,7.5},L)
										elseif L <= 22 then
											Result = LinFmod(1.0,8.0,35.0,13,22,L)
										elseif L <= 41 then
											Result = LinFmod(1.0,35.7,48.3,23,41,L)
										elseif L <= 43 then
											Result = LinFmod(1.0,50.0,60.0,42,43,L)
										elseif L <= 48 then
											Result = RoundDbl(LinFmod(1.0,62.6,77.0,44,48,L),0)
										elseif L <= 53 then
											Result = RoundDbl(LinFmod(1.0,80.0,99.0,49,53,L),0)
										elseif L <= 55 then
											Result = LinFmod(1.0,103.5,109.0,54,55,L)
										elseif L <= 61 then
											Result = RoundDbl(LinFmod(1.0,113.6,145.0,56,61,L),0)
										elseif L <= 120 then
											Result = LinFmod(1.0,153.0,849.0,62,120,L)
										elseif L <= 130 then
											Result = LinFmod(1.0,855.0,909.0,121,130,L)
										else
											Result = LinFmod(1.0,914.0,1009.0,131,150,L)
										end
									end
								else
									Result = RoundDblDown(LinInter({{1,49,50,75,200,234,370,999},{0.0,0.0,2.0,3.0,4.0,5.0,6.0,6.0}},L))
								end
							else
								Result = RoundDblDown(LinInter({{1,49,50,75,200,234,370,999},{0.0,0.0,2.0,3.0,4.0,5.0,6.0,6.0}},L))
							end
						else
							Result = {{1,25,50,79,80,200,225,300,349,350,399,400,449,450,499,500,549,550,599},{1,25,50,75,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160}}
						end
					elseif SN < "HUNTERCDWILLTOPHYMIT" then
						if SN < "HUNTERCDBASEFATE" then
							if SN > "HOBHOBBITTOUGHNVITALITY" then
								if SN < "HUNTERCDAGILITYTOPHYMAS" then
									if SN > "HUNTERCDAGILITYTOCRITHIT" then
										if SN == "HUNTERCDAGILITYTOEVADE" then
											Result = 2.0
										elseif SN == "HUNTERCDAGILITYTOOUTHEAL" then
											Result = 3.0
										elseif SN == "HUNTERCDAGILITYTOPARRY" then
											Result = 1.0
										end
									elseif SN < "HUNTERCDAGILITYTOCRITHIT" then
										if SN == "HOBRAPIDRECOVERYNCMR" then
											Result = CalcStat("NCMRT",L,0.6)
										elseif SN == "HOBSMALLSIZEMIGHT" then
											Result = -CalcStat("MightT",L,0.4)
										elseif SN == "HOPEMORALEP" then
											if L <= 5 then
												Result = DataTableValue({-0.99,-0.97,-0.95,-0.9,-0.85,-0.8,-0.65,-0.6,-0.5,-0.4,-0.3,-0.2,-0.15,-0.1,-0.05,0.0,0.01,0.02,0.03,0.04,0.05},L+16)
											else
												Result = CalcStat("HopeMoraleP",5)
											end
										end
									else
										Result = 1.0
									end
								elseif SN > "HUNTERCDAGILITYTOPHYMAS" then
									if SN > "HUNTERCDARMOURTONONPHYMIT" then
										if SN == "HUNTERCDARMOURTOTACMIT" then
											Result = 0.2
										elseif SN == "HUNTERCDARMOURTYPE" then
											Result = 2
										elseif SN == "HUNTERCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityH",L)
										end
									elseif SN < "HUNTERCDARMOURTONONPHYMIT" then
										if SN == "HUNTERCDAGILITYTOPHYMIT" then
											Result = 1.0
										elseif SN == "HUNTERCDAGILITYTOTACMIT" then
											Result = 1.0
										elseif SN == "HUNTERCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										end
									else
										Result = 0.2
									end
								else
									Result = 3.0
								end
							elseif SN < "HOBHOBBITTOUGHNVITALITY" then
								if SN < "HNTPURGEPOISONRESIST" then
									if SN > "HIGHELFRDTRAITWILL" then
										if SN == "HNTBREACHFINDERRNGMIT" then
											Result = (-20.0)*L
										elseif SN == "HNTCAMPFIRENCMR" then
											Result = CalcStat("NCMRT",L,2.0)
										elseif SN == "HNTCAMPFIRENCPR" then
											Result = CalcStat("NCPRT",L,0.4)
										end
									elseif SN < "HIGHELFRDTRAITWILL" then
										if SN == "HIGHELFRDTRAITMORALE" then
											Result = CalcStat("HElfPeaceEldarMorale",L)
										elseif SN == "HIGHELFRDTRAITNCMR" then
											Result = CalcStat("HElfPeaceEldarNCMR",L)
										end
									else
										Result = CalcStat("HElfSorrowUndyingWill",L)
									end
								elseif SN > "HNTPURGEPOISONRESIST" then
									if SN > "HOBBITRDTRAITMIGHT" then
										if SN == "HOBBITRDTRAITNCMR" then
											Result = CalcStat("HobRapidRecoveryNCMR",L)
										elseif SN == "HOBBITRDTRAITVITALITY" then
											Result = CalcStat("HobHobbitToughnVitality",L)
										elseif SN == "HOBHOBBITSTATUREMIGHT" then
											Result = CalcStat("MightT",L,1.0)
										end
									elseif SN < "HOBBITRDTRAITMIGHT" then
										if SN == "HOBBITRDPSVONEMIGHT" then
											Result = CalcStat("HobHobbitStatureMight",L)
										elseif SN == "HOBBITRDPSVONENAME" then
											Result = "Hobbit-stature"
										elseif SN == "HOBBITRDPSVTWONAME" then
											Result = ""
										end
									else
										Result = CalcStat("HobSmallSizeMight",L)
									end
								else
									Result = CalcStat("PoisonResistT",L,4.0)
								end
							else
								Result = CalcStat("VitalityT",L,1.0)
							end
						elseif SN > "HUNTERCDBASEFATE" then
							if SN > "HUNTERCDHASPOWER" then
								if SN < "HUNTERCDTACMASTOOUTHEAL" then
									if SN > "HUNTERCDMIGHTTOOUTHEAL" then
										if SN == "HUNTERCDMIGHTTOPHYMAS" then
											Result = 2.0
										elseif SN == "HUNTERCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "HUNTERCDPHYMITTONONPHYMIT" then
											Result = 1.0
										end
									elseif SN < "HUNTERCDMIGHTTOOUTHEAL" then
										if SN == "HUNTERCDMIGHTTOCRITHIT" then
											Result = 1.5
										elseif SN == "HUNTERCDMIGHTTOEVADE" then
											Result = 1.0
										elseif SN == "HUNTERCDMIGHTTOFINESSE" then
											Result = 1.5
										end
									else
										Result = 2.0
									end
								elseif SN > "HUNTERCDTACMASTOOUTHEAL" then
									if SN > "HUNTERCDWILLTOCRITHIT" then
										if SN == "HUNTERCDWILLTOFINESSE" then
											Result = 1.5
										elseif SN == "HUNTERCDWILLTOOUTHEAL" then
											Result = 2.0
										elseif SN == "HUNTERCDWILLTOPHYMAS" then
											Result = 2.0
										end
									elseif SN < "HUNTERCDWILLTOCRITHIT" then
										if SN == "HUNTERCDVITALITYTOICMR" then
											Result = 0.012
										elseif SN == "HUNTERCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "HUNTERCDVITALITYTONCMR" then
											Result = 0.12
										end
									else
										Result = 0.5
									end
								else
									Result = 1.0
								end
							elseif SN < "HUNTERCDHASPOWER" then
								if SN < "HUNTERCDBASEVITALITY" then
									if SN > "HUNTERCDBASEMORALE" then
										if SN == "HUNTERCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRM",L)
										elseif SN == "HUNTERCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "HUNTERCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										end
									elseif SN < "HUNTERCDBASEMORALE" then
										if SN == "HUNTERCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRM",L)
										elseif SN == "HUNTERCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "HUNTERCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								elseif SN > "HUNTERCDBASEVITALITY" then
									if SN > "HUNTERCDCALCTYPETACMIT" then
										if SN == "HUNTERCDFATETOICPR" then
											Result = 0.015
										elseif SN == "HUNTERCDFATETONCPR" then
											Result = 0.15
										elseif SN == "HUNTERCDFATETOPOWER" then
											Result = 1.5
										end
									elseif SN < "HUNTERCDCALCTYPETACMIT" then
										if SN == "HUNTERCDBASEWILL" then
											Result = CalcStat("ClassBaseWillL",L)
										elseif SN == "HUNTERCDCALCTYPECOMPHYMIT" then
											Result = 13
										elseif SN == "HUNTERCDCALCTYPENONPHYMIT" then
											Result = 13
										end
									else
										Result = 26
									end
								else
									Result = CalcStat("ClassBaseVitality",L)
								end
							else
								Result = 1
							end
						else
							Result = CalcStat("ClassBaseFate",L)
						end
					else
						Result = 1.0
					end
				elseif SN > "LOREMASTERCDAGILITYTOFINESSE" then
					if SN > "MANRDTRAITINHEALP" then
						if SN < "MARINERCDHASPOWER" then
							if SN > "MARINERCDBASEFATE" then
								if SN < "MARINERCDBASEVITALITY" then
									if SN > "MARINERCDBASEMORALE" then
										if SN == "MARINERCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRL",L)
										elseif SN == "MARINERCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "MARINERCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										end
									elseif SN < "MARINERCDBASEMORALE" then
										if SN == "MARINERCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRL",L)
										elseif SN == "MARINERCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "MARINERCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								elseif SN > "MARINERCDBASEVITALITY" then
									if SN > "MARINERCDCALCTYPETACMIT" then
										if SN == "MARINERCDFATETOICPR" then
											Result = 0.015
										elseif SN == "MARINERCDFATETONCPR" then
											Result = 0.15
										elseif SN == "MARINERCDFATETOPOWER" then
											Result = 1.5
										end
									elseif SN < "MARINERCDCALCTYPETACMIT" then
										if SN == "MARINERCDBASEWILL" then
											Result = CalcStat("ClassBaseWillM",L)
										elseif SN == "MARINERCDCALCTYPECOMPHYMIT" then
											Result = 13
										elseif SN == "MARINERCDCALCTYPENONPHYMIT" then
											Result = 13
										end
									else
										Result = 26
									end
								else
									Result = CalcStat("ClassBaseVitality",L)
								end
							elseif SN < "MARINERCDBASEFATE" then
								if SN < "MARINERCDAGILITYTOPHYMAS" then
									if SN > "MANSTRONGMENMIGHT" then
										if SN == "MARINERCDAGILITYTOCRITHIT" then
											Result = 1.0
										elseif SN == "MARINERCDAGILITYTOOUTHEAL" then
											Result = 3.0
										elseif SN == "MARINERCDAGILITYTOPARRY" then
											Result = 3.0
										end
									elseif SN < "MANSTRONGMENMIGHT" then
										if SN == "MANRDTRAITMIGHT" then
											Result = CalcStat("ManStrongMenMight",L)
										elseif SN == "MANRDTRAITWILL" then
											Result = CalcStat("ManDimMankindWill",L)
										end
									else
										Result = CalcStat("MightT",L,1.0)
									end
								elseif SN > "MARINERCDAGILITYTOPHYMAS" then
									if SN > "MARINERCDARMOURTONONPHYMIT" then
										if SN == "MARINERCDARMOURTOTACMIT" then
											Result = 0.2
										elseif SN == "MARINERCDARMOURTYPE" then
											Result = 2
										elseif SN == "MARINERCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityM",L)
										end
									elseif SN < "MARINERCDARMOURTONONPHYMIT" then
										if SN == "MARINERCDAGILITYTOPHYMIT" then
											Result = 1.0
										elseif SN == "MARINERCDAGILITYTOTACMIT" then
											Result = 1.0
										elseif SN == "MARINERCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										end
									else
										Result = 0.2
									end
								else
									Result = 3.0
								end
							else
								Result = CalcStat("ClassBaseFate",L)
							end
						elseif SN > "MARINERCDHASPOWER" then
							if SN > "MARINERCDWILLTOPHYMIT" then
								if SN < "MATHOMLVLTOILVL" then
									if SN > "MASTERYCI" then
										if SN == "MASTERYCILVLFILTER" then
											Result = TranslateValue({4.6,4.8,7.0},{565,565,565,570},N)
										elseif SN == "MASTERYOLD" then
											Result = CalcStat("Mastery",L,N)
										elseif SN == "MASTERYT" then
											Result = EquSng(StatLinInter("PntMPMastery","TraitPntS","OutDmgPRatPB","AdjTraitMas",L,N,2))
										end
									elseif SN < "MASTERYCI" then
										if SN == "MARINERCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "MASTERY" then
											Result = EquSng(StatLinInter("PntMPMastery","ItemPntS","OutDmgPRatPB","AdjItemMas",L,N,2))
										elseif SN == "MASTERYC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("MasteryCI",CalcStat("MasteryCILvlFilter",L,N),N),2)
										end
									else
										Result = RoundDblLotro(StatLinInter("PntMPMasteryC","ItemPntS","OutDmgPRatPB","AdjCreepExtra",L,N))
									end
								elseif SN > "MATHOMLVLTOILVL" then
									if SN > "MIGHTT" then
										if SN == "MINCOMPOSURERESIST" then
											Result = CalcStat("ResistT",L,1.6)
										elseif SN == "MINCOMPOSURETACMIT" then
											Result = CalcStat("TacMitT",L,1.0)
										elseif SN == "MINCOURAGERESIST" then
											Result = CalcStat("FearResistT",L,1.0)
										end
									elseif SN < "MIGHTT" then
										if SN == "MIGHT" then
											Result = CalcStat("Main",L,N)
										elseif SN == "MIGHTC" then
											Result = CalcStat("MainC",L,N)
										elseif SN == "MIGHTCI" then
											Result = CalcStat("MainCI",L,N)
										end
									else
										Result = CalcStat("MainT",L,N)
									end
								else
									Result = CalcStat("AwardLvlToILvl",L)
								end
							elseif SN < "MARINERCDWILLTOPHYMIT" then
								if SN < "MARINERCDTACMASTOOUTHEAL" then
									if SN > "MARINERCDMIGHTTOPARRY" then
										if SN == "MARINERCDMIGHTTOPHYMAS" then
											Result = 2.0
										elseif SN == "MARINERCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "MARINERCDPHYMITTONONPHYMIT" then
											Result = 1.0
										end
									elseif SN < "MARINERCDMIGHTTOPARRY" then
										if SN == "MARINERCDMIGHTTOCRITHIT" then
											Result = 1.5
										elseif SN == "MARINERCDMIGHTTOFINESSE" then
											Result = 1.5
										elseif SN == "MARINERCDMIGHTTOOUTHEAL" then
											Result = 2.0
										end
									else
										Result = 1.0
									end
								elseif SN > "MARINERCDTACMASTOOUTHEAL" then
									if SN > "MARINERCDWILLTOCRITHIT" then
										if SN == "MARINERCDWILLTOFINESSE" then
											Result = 1.5
										elseif SN == "MARINERCDWILLTOOUTHEAL" then
											Result = 2.0
										elseif SN == "MARINERCDWILLTOPHYMAS" then
											Result = 2.0
										end
									elseif SN < "MARINERCDWILLTOCRITHIT" then
										if SN == "MARINERCDVITALITYTOICMR" then
											Result = 0.012
										elseif SN == "MARINERCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "MARINERCDVITALITYTONCMR" then
											Result = 0.12
										end
									else
										Result = 0.5
									end
								else
									Result = 1.0
								end
							else
								Result = 1.0
							end
						else
							Result = 1
						end
					elseif SN < "MANRDTRAITINHEALP" then
						if SN < "LOREMASTERCDVITALITYTOICMR" then
							if SN > "LOREMASTERCDBASEVITALITY" then
								if SN < "LOREMASTERCDHASPOWER" then
									if SN > "LOREMASTERCDCALCTYPETACMIT" then
										if SN == "LOREMASTERCDFATETOICPR" then
											Result = 0.015
										elseif SN == "LOREMASTERCDFATETONCPR" then
											Result = 0.15
										elseif SN == "LOREMASTERCDFATETOPOWER" then
											Result = 1.5
										end
									elseif SN < "LOREMASTERCDCALCTYPETACMIT" then
										if SN == "LOREMASTERCDBASEWILL" then
											Result = CalcStat("ClassBaseWillH",L)
										elseif SN == "LOREMASTERCDCALCTYPECOMPHYMIT" then
											Result = 12
										elseif SN == "LOREMASTERCDCALCTYPENONPHYMIT" then
											Result = 12
										end
									else
										Result = 25
									end
								elseif SN > "LOREMASTERCDHASPOWER" then
									if SN > "LOREMASTERCDMIGHTTOTACMAS" then
										if SN == "LOREMASTERCDPHYMITTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "LOREMASTERCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "LOREMASTERCDTACMASTOOUTHEAL" then
											Result = 1.0
										end
									elseif SN < "LOREMASTERCDMIGHTTOTACMAS" then
										if SN == "LOREMASTERCDMIGHTTOCRITHIT" then
											Result = 1.5
										elseif SN == "LOREMASTERCDMIGHTTOFINESSE" then
											Result = 1.5
										elseif SN == "LOREMASTERCDMIGHTTOPARRY" then
											Result = 1.0
										end
									else
										Result = 2.0
									end
								else
									Result = 1
								end
							elseif SN < "LOREMASTERCDBASEVITALITY" then
								if SN < "LOREMASTERCDBASEFATE" then
									if SN > "LOREMASTERCDARMOURTONONPHYMIT" then
										if SN == "LOREMASTERCDARMOURTOTACMIT" then
											Result = 0.2
										elseif SN == "LOREMASTERCDARMOURTYPE" then
											Result = 1
										elseif SN == "LOREMASTERCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityL",L)
										end
									elseif SN < "LOREMASTERCDARMOURTONONPHYMIT" then
										if SN == "LOREMASTERCDAGILITYTOTACMAS" then
											Result = 2.0
										elseif SN == "LOREMASTERCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										end
									else
										Result = 0.2
									end
								elseif SN > "LOREMASTERCDBASEFATE" then
									if SN > "LOREMASTERCDBASEMORALE" then
										if SN == "LOREMASTERCDBASENCMR" then
											Result = CalcStat("ClassBaseNCMRL",L)
										elseif SN == "LOREMASTERCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "LOREMASTERCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										end
									elseif SN < "LOREMASTERCDBASEMORALE" then
										if SN == "LOREMASTERCDBASEICMR" then
											Result = CalcStat("ClassBaseICMRL",L)
										elseif SN == "LOREMASTERCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "LOREMASTERCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightM",L)
										end
									else
										Result = CalcStat("ClassBaseMorale",L)
									end
								else
									Result = CalcStat("ClassBaseFate",L)
								end
							else
								Result = CalcStat("ClassBaseVitality",L)
							end
						elseif SN > "LOREMASTERCDVITALITYTOICMR" then
							if SN > "MAIN" then
								if SN < "MANGIFTOFMENFATE" then
									if SN > "MAINT" then
										if SN == "MANDIMMANKINDWILL" then
											Result = -CalcStat("WillT",L,0.4)
										elseif SN == "MANEASILYINSPINHEALP" then
											Result = 5.0
										elseif SN == "MANFOURTHAGEWILL" then
											Result = CalcStat("WillT",L,1.0)
										end
									elseif SN < "MAINT" then
										if SN == "MAINC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("MainCI",CalcStat("MainCILvlFilter",L,N),N),2)
										elseif SN == "MAINCI" then
											Result = RoundDblLotro(StatLinInter("PntMPMainC","ItemPntS","ProgBMain","AdjCreepMain",L,N))
										elseif SN == "MAINCILVLFILTER" then
											Result = TranslateValue({0.0},{570},N)
										end
									else
										Result = RoundDblDown(StatLinInter("PntMPMain","TraitPntS","ProgBMain","AdjTraitMain",L,N,2),0)
									end
								elseif SN > "MANGIFTOFMENFATE" then
									if SN > "MANRDPSVTWOEVADE" then
										if SN == "MANRDPSVTWONAME" then
											Result = "Balance of Man"
										elseif SN == "MANRDPSVTWOPARRY" then
											Result = CalcStat("BalanceOfManParry",L)
										elseif SN == "MANRDTRAITFATE" then
											Result = CalcStat("ManGiftOfMenFate",L)
										end
									elseif SN < "MANRDPSVTWOEVADE" then
										if SN == "MANRDPSVONENAME" then
											Result = "Man of the Fourth Age"
										elseif SN == "MANRDPSVONEWILL" then
											Result = CalcStat("ManFourthAgeWill",L)
										elseif SN == "MANRDPSVTWOBLOCK" then
											Result = CalcStat("BalanceOfManBlock",L)
										end
									else
										Result = CalcStat("BalanceOfManEvade",L)
									end
								else
									Result = CalcStat("FateT",L,1.0)
								end
							elseif SN < "MAIN" then
								if SN < "LOREMASTERCDWILLTOTACMIT" then
									if SN > "LOREMASTERCDWILLTOEVADE" then
										if SN == "LOREMASTERCDWILLTOPHYMIT" then
											Result = 1.0
										elseif SN == "LOREMASTERCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "LOREMASTERCDWILLTOTACMAS" then
											Result = 3.0
										end
									elseif SN < "LOREMASTERCDWILLTOEVADE" then
										if SN == "LOREMASTERCDVITALITYTOMORALE" then
											Result = 4.5
										elseif SN == "LOREMASTERCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "LOREMASTERCDWILLTOCRITHIT" then
											Result = 1.0
										end
									else
										Result = 2.0
									end
								elseif SN > "LOREMASTERCDWILLTOTACMIT" then
									if SN > "LVLBONUSTACDMG" then
										if SN == "LVLEXPCOST" then
											if L <= 1 then
												Result = 0
											elseif L <= 5 then
												Result = RoundDbl(12.5*L*L+12.5666666666667*L+24.8666666666667)
											elseif L <= 10 then
												Result = RoundDbl(33.8*L*L-179.48*L+452.6)
											elseif L <= 15 then
												Result = RoundDbl(55.05*L*L-583.77*L+2370.5)
											elseif L <= 20 then
												Result = RoundDbl(76.2*L*L-1196.96*L+6809)
											elseif L <= 25 then
												Result = RoundDbl(97.4*L*L-2023*L+14849.8)
											elseif L <= 30 then
												Result = RoundDbl(118.7*L*L-3066.02 *L+27612.8)
											elseif L <= 35 then
												Result = RoundDbl(139.95*L*L-4319.23*L+46084.1)
											elseif L <= 40 then
												Result = RoundDbl(161.2*L*L-5785.04*L+71356.2)
											elseif L <= 45 then
												Result = RoundDbl(182.5*L*L-7467.38*L+104569.8)
											elseif L <= 50 then
												Result = RoundDbl(203.8*L*L-9363.48*L+146761.8)
											elseif L <= 55 then
												Result = RoundDbl(225.05*L*L-11467.77*L+198851.3)
											elseif L <= 60 then
												Result = RoundDbl(246.3*L*L-13784.46*L+261988)
											elseif 61 <= L and L <= 70 then
												Result = RoundDbl(ExpFmod(CalcStat("LvlExpCost",60),61,5.071,L,3.485))
											elseif 71 <= L and L <= 75 then
												Result = RoundDbl(ExpFmod(CalcStat("LvlExpCost",70),71,5.072,L,-0.95))
											elseif 76 <= L then
												Result = RoundDbl(ExpFmod(CalcStat("LvlExpCost",75),76,5,L,-0.5,0))
											end
										elseif SN == "LVLEXPCOSTTOT" then
											if L <= 0 then
												Result = 0
											elseif 1 <= L then
												Result = CalcStat("LvlExpCostTot",L-1)+CalcStat("LvlExpCost",L)
											end
										elseif SN == "LVLTOILVL" then
											Result = RoundDbl(LinInter({{1,25,50,75,76,100,105,106,115,116,120,121,130,131,140,141,150,151,160,161,170},{1.0,25.0,50.0,79.0,80.0,200.0,225.0,300.0,349.0,350.0,399.0,400.0,449.0,450.0,499.0,500.0,549.0,550.0,599.0,600.0,649.0}},L))
										end
									elseif SN < "LVLBONUSTACDMG" then
										if SN == "LVLBONUSMORRES" then
											Result = EquSng(0.1)
										elseif SN == "LVLBONUSPHYDMG" then
											Result = EquSng(0.1)
										elseif SN == "LVLBONUSPOWRES" then
											Result = CalcStat("SkillPowerCost",L,N)
										end
									else
										Result = EquSng(0.1)
									end
								else
									Result = 1.0
								end
							else
								Result = RoundDblDown(StatLinInter("PntMPMain","ItemPntS","ProgBMain","AdjItemMain",L,N,2),0)
							end
						else
							Result = 0.012
						end
					else
						Result = CalcStat("ManEasilyInspInHealP",L)
					end
				else
					Result = 1.0
				end
			elseif SN < "HIGHELFRDTRAITFATE" then
				if SN < "ELFRDPSVTWONAME" then
					if SN > "CRITHITPRATPC" then
						if SN < "DMGTYPEMIT" then
							if SN > "DEFILERCDCALCTYPENONPHYMIT" then
								if SN < "DEVHITPRATPCAP" then
									if SN > "DEVHITPRATP" then
										if SN == "DEVHITPRATPA" then
											Result = 30.0
										elseif SN == "DEVHITPRATPB" then
											Result = CalcStat("BRatDevHit",L)
										elseif SN == "DEVHITPRATPC" then
											Result = 0.5
										end
									elseif SN < "DEVHITPRATP" then
										if SN == "DEFILERCDCALCTYPETACMIT" then
											Result = 27
										elseif SN == "DEFILERCDHASPOWER" then
											Result = 1
										elseif SN == "DEVHITPPRAT" then
											Result = CalcRatAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCapR",L),N)
										end
									else
										Result = CalcPercAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCap",L),N)
									end
								elseif SN > "DEVHITPRATPCAP" then
									if SN > "DIRECTRATINGS" then
										if SN == "DIRECTRATINGSOLD" then
											if L <= 95 then
												Result = CalcStat("ProgBMainOld",L)*N
											else
												Result = RoundDbl(CalcStat("ProgBMainOld",L),0)*N
											end
										elseif SN == "DISEASERESIST" then
											Result = CalcStat("ResistAdd",L,N)
										elseif SN == "DISEASERESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										end
									elseif SN < "DIRECTRATINGS" then
										if SN == "DEVHITPRATPCAPR" then
											Result = CalcStat("DevHitPRatPB",L)*CalcStat("DevHitPRatPC",L)
										elseif SN == "DIRECTENERGY" then
											if L <= 95 then
												Result = CalcStat("ProgBEnergy",L)*N
											else
												Result = RoundDbl(CalcStat("ProgBEnergy",L),1)*N
											end
										elseif SN == "DIRECTHEALTH" then
											if L <= 95 then
												Result = CalcStat("ProgBHealth",L)*N
											else
												Result = RoundDbl(CalcStat("ProgBHealth",L),0)*N
											end
										end
									else
										if L <= 95 then
											Result = CalcStat("ProgBMain",L)*N
										else
											Result = RoundDbl(CalcStat("ProgBMain",L),0)*N
										end
									end
								else
									Result = 10.0
								end
							elseif SN < "DEFILERCDCALCTYPENONPHYMIT" then
								if SN < "CRITMAGNPRATPB" then
									if SN > "CRITHITT" then
										if SN == "CRITMAGNPPRAT" then
											Result = CalcRatAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCapR",L),N)
										elseif SN == "CRITMAGNPRATP" then
											Result = CalcPercAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCap",L),N)
										elseif SN == "CRITMAGNPRATPA" then
											Result = 225.0
										end
									elseif SN < "CRITHITT" then
										if SN == "CRITHITPRATPCAP" then
											Result = 25.0
										elseif SN == "CRITHITPRATPCAPR" then
											Result = CalcStat("CritHitPRatPB",L)*CalcStat("CritHitPRatPC",L)
										end
									else
										Result = EquSng(StatLinInter("PntMPCritHit","TraitPntS","CritHitPRatPB","AdjTraitRat",L,N,2))
									end
								elseif SN > "CRITMAGNPRATPB" then
									if SN > "CRYRESIST" then
										if SN == "CRYRESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										elseif SN == "DEFILERCANBLOCK" then
											Result = 1
										elseif SN == "DEFILERCDCALCTYPECOMPHYMIT" then
											Result = 13
										end
									elseif SN < "CRYRESIST" then
										if SN == "CRITMAGNPRATPC" then
											Result = 0.5
										elseif SN == "CRITMAGNPRATPCAP" then
											Result = 75.0
										elseif SN == "CRITMAGNPRATPCAPR" then
											Result = CalcStat("CritMagnPRatPB",L)*CalcStat("CritMagnPRatPC",L)
										end
									else
										Result = CalcStat("ResistAdd",L,N)
									end
								else
									Result = CalcStat("BRatCritMagn",L)
								end
							else
								Result = 14
							end
						elseif SN > "DMGTYPEMIT" then
							if SN > "DWARFRDTRAITPHYMITP" then
								if SN < "DWARFUNWEARBATTLEICPR" then
									if SN > "DWARFSTURDINESSMIGHT" then
										if SN == "DWARFSTURDINESSPHYMITP" then
											Result = 1.0
										elseif SN == "DWARFSTURDINESSVITALITY" then
											Result = CalcStat("VitalityT",L,1.0)
										elseif SN == "DWARFUNWEARBATTLEICMR" then
											Result = CalcStat("ICMRT",L,0.6)
										end
									elseif SN < "DWARFSTURDINESSMIGHT" then
										if SN == "DWARFRDTRAITVITALITY" then
											Result = CalcStat("DwarfSturdinessVitality",L)
										elseif SN == "DWARFSHIELDBRWLBLOCK" then
											Result = CalcStat("BlockT",L,0.8)
										elseif SN == "DWARFSTOCKYAGILITY" then
											Result = -CalcStat("AgilityT",L,0.4)
										end
									else
										Result = CalcStat("MightT",L,1.0)
									end
								elseif SN > "DWARFUNWEARBATTLEICPR" then
									if SN > "ELFFADINGFIRSTBORNFATE" then
										if SN == "ELFFRIENDOFMANFATE" then
											Result = CalcStat("FateT",L,1.0)
										elseif SN == "ELFRDPSVONEFATE" then
											Result = CalcStat("ElfFriendOfManFate",L)
										elseif SN == "ELFRDPSVONENAME" then
											Result = "Friend Of Man"
										end
									elseif SN < "ELFFADINGFIRSTBORNFATE" then
										if SN == "DWARFUNWEARBATTLENCMR" then
											Result = -CalcStat("NCMRT",L,0.4)
										elseif SN == "DWARFUNWEARBATTLENCPR" then
											Result = -CalcStat("NCPRT",L,0.4)
										elseif SN == "ELFAGILITYWOODSAGILITY" then
											Result = CalcStat("AgilityT",L,1.0)
										end
									else
										Result = -CalcStat("FateT",L,0.4)
									end
								else
									Result = CalcStat("ICPRT",L,0.6)
								end
							elseif SN < "DWARFRDTRAITPHYMITP" then
								if SN < "DWARFRDPSVTWONAME" then
									if SN > "DWARFLOSTDWARFKDSFATE" then
										if SN == "DWARFRDPSVONEFATE" then
											Result = CalcStat("DwarfFatefulDwarfFate",L)
										elseif SN == "DWARFRDPSVONENAME" then
											Result = "Fateful Dwarf"
										elseif SN == "DWARFRDPSVTWOBLOCK" then
											Result = CalcStat("DwarfShieldBrwlBlock",L)
										end
									elseif SN < "DWARFLOSTDWARFKDSFATE" then
										if SN == "DMGTYPEMITT" then
											Result = EquSng(StatLinInter("PntMPDmgTypeMitT","TraitPntS","MitMediumPRatPB","AdjTraitMit",L,N,2))
										elseif SN == "DWARFENDURVITALITY" then
											Result = CalcStat("VitalityT",L,1.0)
										elseif SN == "DWARFFATEFULDWARFFATE" then
											Result = CalcStat("FateT",L,1.0)
										end
									else
										Result = -CalcStat("FateT",L,0.4)
									end
								elseif SN > "DWARFRDPSVTWONAME" then
									if SN > "DWARFRDTRAITICPR" then
										if SN == "DWARFRDTRAITMIGHT" then
											Result = CalcStat("DwarfSturdinessMight",L)
										elseif SN == "DWARFRDTRAITNCMR" then
											Result = CalcStat("DwarfUnwearBattleNCMR",L)
										elseif SN == "DWARFRDTRAITNCPR" then
											Result = CalcStat("DwarfUnwearBattleNCPR",L)
										end
									elseif SN < "DWARFRDTRAITICPR" then
										if SN == "DWARFRDTRAITAGILITY" then
											Result = CalcStat("DwarfStockyAgility",L)
										elseif SN == "DWARFRDTRAITFATE" then
											Result = CalcStat("DwarfLostDwarfKdsFate",L)
										elseif SN == "DWARFRDTRAITICMR" then
											Result = CalcStat("DwarfUnwearBattleICMR",L)
										end
									else
										Result = CalcStat("DwarfUnwearBattleICPR",L)
									end
								else
									Result = "Shield Brawler"
								end
							else
								Result = CalcStat("DwarfSturdinessPhyMitP",L)
							end
						else
							Result = EquSng(StatLinInter("PntMPDmgTypeMit","ItemPntS","MitMediumPRatPB","AdjItemMit",L,N,2))
						end
					elseif SN < "CRITHITPRATPC" then
						if SN < "CREEPAUDACITYTACDMGP" then
							if SN > "CPTSHIELDTACMAS" then
								if SN < "CREEPAUDACITYCOSTBASE" then
									if SN > "CPTSTANDALONEPHYMAS" then
										if SN == "CPTSTANDALONETACMAS" then
											Result = CalcStat("TacMasT",L,0.8)
										elseif SN == "CREEPAUDACITYCCDP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,16,17,36,60},{0.5,0.5,0.4,0.4,0.4}},L))
											end
										elseif SN == "CREEPAUDACITYCOST" then
											if 2 <= L then
												Result = CalcStat("CreepAudacityCostData",L)
											end
										end
									elseif SN < "CPTSTANDALONEPHYMAS" then
										if SN == "CPTSONGCRITDEF" then
											Result = CalcStat("CritDefT",L,0.8)
										elseif SN == "CPTSONGPHYMAS" then
											Result = CalcStat("PhyMasT",L,0.8)
										elseif SN == "CPTSONGTACMAS" then
											Result = CalcStat("TacMasT",L,1.2)
										end
									else
										Result = CalcStat("PhyMasT",L,1.2)
									end
								elseif SN > "CREEPAUDACITYCOSTBASE" then
									if SN > "CREEPAUDACITYMELREDP" then
										if SN == "CREEPAUDACITYREDP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,10,36,41,60},{0.5,0.5,0.5,0.5,0.5}},L))
											end
										elseif SN == "CREEPAUDACITYRNGDMGP" then
											Result = CalcStat("CreepAudacityDmgP",L)
										elseif SN == "CREEPAUDACITYRNGREDP" then
											Result = CalcStat("CreepAudacityRedP",L)
										end
									elseif SN < "CREEPAUDACITYMELREDP" then
										if SN == "CREEPAUDACITYCOSTDATA" then
											Result = CalcStat("CreepAudacityCostBase",L)*25.0
										elseif SN == "CREEPAUDACITYDMGP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,10,36,41,60},{1.0,1.2,1.25,1.3,1.25}},L))
											end
										elseif SN == "CREEPAUDACITYMELDMGP" then
											Result = CalcStat("CreepAudacityDmgP",L)
										end
									else
										Result = CalcStat("CreepAudacityRedP",L)
									end
								else
									if 1 <= L and L <= 2 then
										Result = 2.0*L
									elseif 3 <= L and L <= 9 then
										Result = 2.0*L-1.0
									elseif 10 <= L and L <= 15 then
										Result = 3.0*L
									elseif 16 <= L and L <= 25 then
										Result = 6.0*L
									elseif 26 <= L and L <= 29 then
										Result = 9.0*L
									elseif 30 <= L and L <= 36 then
										Result = 300.0
									end
								end
							elseif SN < "CPTSHIELDTACMAS" then
								if SN < "CPTCOVPHYMIT" then
									if SN > "CPTBLADEPHYMAS" then
										if SN == "CPTBLADETACMAS" then
											Result = CalcStat("TacMasT",L,0.8)
										elseif SN == "CPTCOVFATE" then
											Result = CalcStat("FateT",L,0.4)
										elseif SN == "CPTCOVMAIN" then
											Result = CalcStat("MainT",L,0.4)
										end
									elseif SN < "CPTBLADEPHYMAS" then
										if SN == "CONSTSTATC" then
											Result = CalcStat(C,1,L)
										elseif SN == "CPTBLADECRITDEF" then
											Result = CalcStat("CritDefT",L,0.8)
										end
									else
										Result = CalcStat("PhyMasT",L,1.2)
									end
								elseif SN > "CPTCOVPHYMIT" then
									if SN > "CPTIDOMEMAIN" then
										if SN == "CPTIDOMEVITALITY" then
											Result = CalcStat("VitalityT",L,0.4)
										elseif SN == "CPTSHIELDCRITDEF" then
											Result = CalcStat("CritDefT",L,1.2)
										elseif SN == "CPTSHIELDPHYMAS" then
											Result = CalcStat("PhyMasT",L,0.8)
										end
									elseif SN < "CPTIDOMEMAIN" then
										if SN == "CPTCOVVITALITY" then
											Result = CalcStat("VitalityT",L,0.4)
										elseif SN == "CPTCRITDEF" then
											Result = CalcStat("CritDef",L,0.6)
										elseif SN == "CPTIDOMEFATE" then
											Result = CalcStat("FateT",L,0.4)
										end
									else
										Result = CalcStat("MainT",L,0.4)
									end
								else
									Result = CalcStat("PhyMitT",L,2.4)
								end
							else
								Result = CalcStat("TacMasT",L,0.8)
							end
						elseif SN > "CREEPAUDACITYTACDMGP" then
							if SN > "CRITDEFPRATP" then
								if SN < "CRITHITC" then
									if SN > "CRITDEFPRATPCAP" then
										if SN == "CRITDEFPRATPCAPR" then
											Result = CalcStat("CritDefPRatPB",L)*CalcStat("CritDefPRatPC",L)
										elseif SN == "CRITDEFT" then
											Result = EquSng(StatLinInter("PntMPCritDef","TraitPntS","CritDefPRatPB","AdjTraitRat",L,N,2))
										elseif SN == "CRITHIT" then
											Result = EquSng(StatLinInter("PntMPCritHit","ItemPntS","CritHitPRatPB","AdjItemRat",L,N,2))
										end
									elseif SN < "CRITDEFPRATPCAP" then
										if SN == "CRITDEFPRATPA" then
											Result = 240.0
										elseif SN == "CRITDEFPRATPB" then
											Result = CalcStat("BRatStandard",L)
										elseif SN == "CRITDEFPRATPC" then
											Result = 0.5
										end
									else
										Result = 80.0
									end
								elseif SN > "CRITHITC" then
									if SN > "CRITHITPPRAT" then
										if SN == "CRITHITPRATP" then
											Result = CalcPercAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCap",L),N)
										elseif SN == "CRITHITPRATPA" then
											Result = 75.0
										elseif SN == "CRITHITPRATPB" then
											Result = CalcStat("BRatExtra",L)
										end
									elseif SN < "CRITHITPPRAT" then
										if SN == "CRITHITCI" then
											Result = RoundDblLotro(StatLinInter("PntMPCritHitC","ItemPntS","CritHitPRatPB","AdjCreepExtra",L,N))
										elseif SN == "CRITHITCILVLFILTER" then
											Result = TranslateValue({2.2,3.8,4.6,5.2},{565,565,565,565,570},N)
										elseif SN == "CRITHITOLD" then
											Result = CalcStat("CritHit",L,N)
										end
									else
										Result = CalcRatAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCapR",L),N)
									end
								else
									Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("CritHitCI",CalcStat("CritHitCILvlFilter",L,N),N),2)
								end
							elseif SN < "CRITDEFPRATP" then
								if SN < "CREEPILVLCURR" then
									if SN > "CREEPBATPROMOUTHEALP" then
										if SN == "CREEPBATPROMPOWERP" then
											if 1 <= L and L <= 15 then
												Result = EquSng(LinInter({{1,5,10,15},{1.1,1.15,1.18,1.2}},L))
											end
										elseif SN == "CREEPBATPROMRNGDMGP" then
											if 1 <= L and L <= 15 then
												Result = EquSng(LinInter({{1,5,10,15},{0.03,0.05,0.07,0.08}},L))
											end
										elseif SN == "CREEPBATPROMTACDMGP" then
											if 1 <= L and L <= 15 then
												Result = EquSng(LinInter({{1,5,10,15},{0.03,0.05,0.07,0.075}},L))
											end
										end
									elseif SN < "CREEPBATPROMOUTHEALP" then
										if SN == "CREEPAUDACITYTACREDP" then
											Result = CalcStat("CreepAudacityRedP",L)
										elseif SN == "CREEPBATPROMHEALTHP" then
											if 1 <= L and L <= 15 then
												Result = EquSng(LinInter({{1,5,10,15},{1.1,1.15,1.18,1.2}},L))
											end
										elseif SN == "CREEPBATPROMMELDMGP" then
											if 1 <= L and L <= 15 then
												Result = EquSng(LinInter({{1,5,10,15},{0.03,0.05,0.07,0.075}},L))
											end
										end
									else
										if 1 <= L and L <= 15 then
											Result = EquSng(LinInter({{1,5,10,15},{0.05,0.1,0.15,0.2}},L))
										end
									end
								elseif SN > "CREEPILVLCURR" then
									if SN > "CRITDEFC" then
										if SN == "CRITDEFCI" then
											Result = RoundDblLotro(StatLinInter("PntMPCritDefC","ItemPntS","CritDefPRatPB","AdjCreepStd",L,N))
										elseif SN == "CRITDEFCILVLFILTER" then
											Result = TranslateValue({2.8,4.0,4.6,5.6,6.2,8.4,11.2},{565,565,565,565,565,565,565,570},N)
										elseif SN == "CRITDEFPPRAT" then
											Result = CalcRatAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCapR",L),N)
										end
									elseif SN < "CRITDEFC" then
										if SN == "CREEPTRAITPNTS" then
											Result = {{1,160},{1,160}}
										elseif SN == "CREEPTRAITPROGB" then
											Result = LinFmod(1.0,0.01,1.0,1,160,L)
										elseif SN == "CRITDEF" then
											Result = EquSng(StatLinInter("PntMPCritDef","ItemPntS","CritDefPRatPB","AdjItemRat",L,N,2))
										end
									else
										Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("CritDefCI",CalcStat("CritDefCILvlFilter",L,N),N),2)
									end
								else
									Result = 570
								end
							else
								Result = CalcPercAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCap",L),N)
							end
						else
							Result = CalcStat("CreepAudacityDmgP",L)
						end
					else
						Result = 0.5
					end
				elseif SN > "ELFRDPSVTWONAME" then
					if SN > "GRDCRITDEF" then
						if SN < "GUARDIANCDCANBLOCK" then
							if SN > "GUARDIANCDARMOURTOTACMIT" then
								if SN < "GUARDIANCDBASENCMR" then
									if SN > "GUARDIANCDBASEICMR" then
										if SN == "GUARDIANCDBASEICPR" then
											Result = CalcStat("ClassBaseICPR",L)
										elseif SN == "GUARDIANCDBASEMIGHT" then
											Result = CalcStat("ClassBaseMightH",L)
										elseif SN == "GUARDIANCDBASEMORALE" then
											Result = CalcStat("ClassBaseMorale",L)
										end
									elseif SN < "GUARDIANCDBASEICMR" then
										if SN == "GUARDIANCDARMOURTYPE" then
											Result = 3
										elseif SN == "GUARDIANCDBASEAGILITY" then
											Result = CalcStat("ClassBaseAgilityM",L)
										elseif SN == "GUARDIANCDBASEFATE" then
											Result = CalcStat("ClassBaseFate",L)
										end
									else
										Result = CalcStat("ClassBaseICMRH",L)
									end
								elseif SN > "GUARDIANCDBASENCMR" then
									if SN > "GUARDIANCDBASEWILL" then
										if SN == "GUARDIANCDCALCTYPECOMPHYMIT" then
											Result = 14
										elseif SN == "GUARDIANCDCALCTYPENONPHYMIT" then
											Result = 14
										elseif SN == "GUARDIANCDCALCTYPETACMIT" then
											Result = 27
										end
									elseif SN < "GUARDIANCDBASEWILL" then
										if SN == "GUARDIANCDBASENCPR" then
											Result = CalcStat("ClassBaseNCPR",L)
										elseif SN == "GUARDIANCDBASEPOWER" then
											Result = CalcStat("ClassBasePower",L)
										elseif SN == "GUARDIANCDBASEVITALITY" then
											Result = CalcStat("ClassBaseVitality",L)
										end
									else
										Result = CalcStat("ClassBaseWillL",L)
									end
								else
									Result = CalcStat("ClassBaseNCMRH",L)
								end
							elseif SN < "GUARDIANCDARMOURTOTACMIT" then
								if SN < "GRDWARDTACTTACMIT" then
									if SN > "GRDTENDERIZET2CRITHIT" then
										if SN == "GRDTENDERIZET3CRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("Trait357912Choice",N)*0.2)
										elseif SN == "GRDTENDERIZET4CRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("Trait47101316Choice",N)*0.2)
										elseif SN == "GRDTENDERIZET5CRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("Trait58121620Choice",N)*0.2)
										end
									elseif SN < "GRDTENDERIZET2CRITHIT" then
										if SN == "GRDRELENTLASSFINESSE" then
											Result = CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.2)
										elseif SN == "GRDTENDERIZECRITHIT" then
											Result = CalcStat("CritHitT",L,CalcStat("Trait12345Choice",N)*0.2)
										end
									else
										Result = CalcStat("CritHitT",L,CalcStat("Trait12345Choice",N)*0.4)
									end
								elseif SN > "GRDWARDTACTTACMIT" then
									if SN > "GUARDIANCDAGILITYTOPARRY" then
										if SN == "GUARDIANCDAGILITYTOPHYMAS" then
											Result = 2.0
										elseif SN == "GUARDIANCDARMOURTOCOMPHYMIT" then
											Result = 1.0
										elseif SN == "GUARDIANCDARMOURTONONPHYMIT" then
											Result = 0.2
										end
									elseif SN < "GUARDIANCDAGILITYTOPARRY" then
										if SN == "GUARDIANCDAGILITYTOCRITHIT" then
											Result = 2.0
										elseif SN == "GUARDIANCDAGILITYTOFINESSE" then
											Result = 1.0
										elseif SN == "GUARDIANCDAGILITYTOOUTHEAL" then
											Result = 2.0
										end
									else
										Result = 1.0
									end
								else
									Result = CalcStat("TacMitT",L,CalcStat("Trait12345Choice",N)*0.2)
								end
							else
								Result = 0.2
							end
						elseif SN > "GUARDIANCDCANBLOCK" then
							if SN > "GUARDIANCDVITALITYTOMORALE" then
								if SN < "HELFFADINGFIRSTBORNFATE" then
									if SN > "GUARDIANCDWILLTOPHYMAS" then
										if SN == "GUARDIANCDWILLTOPHYMIT" then
											Result = 1.5
										elseif SN == "GUARDIANCDWILLTORESIST" then
											Result = 1.0
										elseif SN == "GUARDIANCDWILLTOTACMIT" then
											Result = 1.5
										end
									elseif SN < "GUARDIANCDWILLTOPHYMAS" then
										if SN == "GUARDIANCDVITALITYTONCMR" then
											Result = 0.12
										elseif SN == "GUARDIANCDWILLTOFINESSE" then
											Result = 1.0
										elseif SN == "GUARDIANCDWILLTOOUTHEAL" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								elseif SN > "HELFFADINGFIRSTBORNFATE" then
									if SN > "HELFTHOSEWHOREMAINWILL" then
										if SN == "HIGHELFRDPSVONENAME" then
											Result = "Those Who Remain"
										elseif SN == "HIGHELFRDPSVONEWILL" then
											Result = CalcStat("HElfThoseWhoRemainWill",L)
										elseif SN == "HIGHELFRDPSVTWONAME" then
											Result = ""
										end
									elseif SN < "HELFTHOSEWHOREMAINWILL" then
										if SN == "HELFPEACEELDARMORALE" then
											Result = CalcStat("MoraleT",L,1.0)
										elseif SN == "HELFPEACEELDARNCMR" then
											Result = CalcStat("NCMRT",L,0.6)
										elseif SN == "HELFSORROWUNDYINGWILL" then
											Result = -CalcStat("WillT",L,0.4)
										end
									else
										Result = CalcStat("WillT",L,1.0)
									end
								else
									Result = -CalcStat("FateT",L,0.4)
								end
							elseif SN < "GUARDIANCDVITALITYTOMORALE" then
								if SN < "GUARDIANCDMIGHTTOPARRY" then
									if SN > "GUARDIANCDHASPOWER" then
										if SN == "GUARDIANCDMIGHTTOBLOCK" then
											Result = 1.0
										elseif SN == "GUARDIANCDMIGHTTOCRITHIT" then
											Result = 1.0
										elseif SN == "GUARDIANCDMIGHTTOOUTHEAL" then
											Result = 3.0
										end
									elseif SN < "GUARDIANCDHASPOWER" then
										if SN == "GUARDIANCDFATETOICPR" then
											Result = 0.015
										elseif SN == "GUARDIANCDFATETONCPR" then
											Result = 0.15
										elseif SN == "GUARDIANCDFATETOPOWER" then
											Result = 1.5
										end
									else
										Result = 1
									end
								elseif SN > "GUARDIANCDMIGHTTOPARRY" then
									if SN > "GUARDIANCDPHYMITTOCOMPHYMIT" then
										if SN == "GUARDIANCDPHYMITTONONPHYMIT" then
											Result = 1.0
										elseif SN == "GUARDIANCDTACMASTOOUTHEAL" then
											Result = 1.0
										elseif SN == "GUARDIANCDVITALITYTOICMR" then
											Result = 0.012
										end
									elseif SN < "GUARDIANCDPHYMITTOCOMPHYMIT" then
										if SN == "GUARDIANCDMIGHTTOPHYMAS" then
											Result = 3.0
										elseif SN == "GUARDIANCDMIGHTTOPHYMIT" then
											Result = 1.0
										elseif SN == "GUARDIANCDMIGHTTOTACMIT" then
											Result = 1.0
										end
									else
										Result = 1.0
									end
								else
									Result = 2.0
								end
							else
								Result = 4.5
							end
						else
							Result = 1
						end
					elseif SN < "GRDCRITDEF" then
						if SN < "FINESSEPPRAT" then
							if SN > "EVADEPRATPC" then
								if SN < "FEARRESIST" then
									if SN > "FATE" then
										if SN == "FATEC" then
											Result = CalcStat("MainC",L,N)
										elseif SN == "FATECI" then
											Result = CalcStat("MainCI",L,N)
										elseif SN == "FATET" then
											Result = RoundDblDown(StatLinInter("PntMPFate","TraitPntSVital","ProgBEnergy","",L,N,2),0)
										end
									elseif SN < "FATE" then
										if SN == "EVADEPRATPCAP" then
											Result = CalcStat("BPEPRatPCap",L)
										elseif SN == "EVADEPRATPCAPR" then
											Result = CalcStat("BPEPRatPCapR",L)
										elseif SN == "EVADET" then
											Result = CalcStat("BPET",L,N)
										end
									else
										Result = RoundDblDown(StatLinInter("PntMPFate","ItemPntSVital","ProgBEnergy","",L,N,2),0)
									end
								elseif SN > "FEARRESIST" then
									if SN > "FINESSE" then
										if SN == "FINESSEC" then
											Result = StatLinInter("","CreepTraitPntS","CreepTraitProgB","",L,CalcStat("FinesseCI",CalcStat("FinesseCILvlFilter",L,N),N),2)
										elseif SN == "FINESSECI" then
											Result = RoundDblLotro(StatLinInter("PntMPFinesseC","ItemPntS","FinessePRatPB","AdjCreepStd",L,N))
										elseif SN == "FINESSECILVLFILTER" then
											Result = TranslateValue({3.0,3.6,6.2,7.2,10.8},{565,565,565,565,565,570},N)
										end
									elseif SN < "FINESSE" then
										if SN == "FEARRESISTT" then
											Result = CalcStat("ResistAddT",L,N)
										elseif SN == "FELLWMIT" then
											Result = EquSng(StatLinInter("PntMPFellWMit","ItemPntS","MitMediumPRatPB","AdjItemMit",L,N,2))
										elseif SN == "FELLWMITT" then
											Result = EquSng(StatLinInter("PntMPFellWMit","TraitPntS","MitMediumPRatPB","AdjTraitMit",L,N,2))
										end
									else
										Result = EquSng(StatLinInter("PntMPFinesse","ItemPntS","FinessePRatPB","AdjItemRat",L,N,2))
									end
								else
									Result = CalcStat("ResistAdd",L,N)
								end
							elseif SN < "EVADEPRATPC" then
								if SN < "EVADE" then
									if SN > "ELFRDTRAITMORALE" then
										if SN == "ELFRDTRAITNCMR" then
											Result = CalcStat("ElfSorrowFirstbornNCMR",L)
										elseif SN == "ELFSORROWFIRSTBORNMORALE" then
											Result = -CalcStat("MoraleT",L,0.4)
										elseif SN == "ELFSORROWFIRSTBORNNCMR" then
											Result = -CalcStat("NCMRT",L,0.4)
										end
									elseif SN < "ELFRDTRAITMORALE" then
										if SN == "ELFRDTRAITAGILITY" then
											Result = CalcStat("ElfAgilityWoodsAgility",L)
										elseif SN == "ELFRDTRAITFATE" then
											Result = CalcStat("ElfFadingFirstbornFate",L)
										end
									else
										Result = CalcStat("ElfSorrowFirstbornMorale",L)
									end
								elseif SN > "EVADE" then
									if SN > "EVADEPPRAT" then
										if SN == "EVADEPRATP" then
											Result = CalcStat("BPEPRatP",L,N)
										elseif SN == "EVADEPRATPA" then
											Result = CalcStat("BPEPRatPA",L)
										elseif SN == "EVADEPRATPB" then
											Result = CalcStat("BPEPRatPB",L)
										end
									elseif SN < "EVADEPPRAT" then
										if SN == "EVADEC" then
											Result = CalcStat("BPEC",L,N)
										elseif SN == "EVADECI" then
											Result = CalcStat("BPECI",L,N)
										elseif SN == "EVADEPBONUS" then
											Result = CalcStat("BPEPBonus",L)
										end
									else
										Result = CalcStat("BPEPPRat",L,N)
									end
								else
									Result = CalcStat("BPE",L,N)
								end
							else
								Result = CalcStat("BPEPRatPC",L)
							end
						elseif SN > "FINESSEPPRAT" then
							if SN > "FREEPAUDACITYMELREDP" then
								if SN < "FREEPBATPROMHEALTHP" then
									if SN > "FREEPAUDACITYRNGREDP" then
										if SN == "FREEPAUDACITYTACDMGP" then
											Result = CalcStat("FreepAudacityDmgP",L)
										elseif SN == "FREEPAUDACITYTACREDP" then
											Result = CalcStat("FreepAudacityRedP",L)
										elseif SN == "FREEPBATPROMDMGB" then
											if 1 <= L and L <= 15 then
												Result = RoundDbl(LinInter({{1,5,6,9,10,15},{10.0,10.0,12.0,12.0,12.6,14.6}},L),0)
											end
										end
									elseif SN < "FREEPAUDACITYRNGREDP" then
										if SN == "FREEPAUDACITYMORALEP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,16,17,36,41},{0.5,1.25,1.33,1.33,1.33}},L))
											end
										elseif SN == "FREEPAUDACITYREDP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,16,17,36,41},{1.5,1.5,0.5,0.5,0.5}},L))
											end
										elseif SN == "FREEPAUDACITYRNGDMGP" then
											Result = CalcStat("FreepAudacityDmgP",L)
										end
									else
										Result = CalcStat("FreepAudacityRedP",L)
									end
								elseif SN > "FREEPBATPROMHEALTHP" then
									if SN > "FREEPBATPROMTACDMGP" then
										if SN == "FREEPBATPROMVITALB" then
											if 1 <= L and L <= 15 then
												Result = RoundDbl(LinInter({{1,10,15},{110.0,115.0,120.0}},L),0)
											end
										elseif SN == "FROSTMIT" then
											Result = CalcStat("DmgTypeMit",L,N)
										elseif SN == "FROSTMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										end
									elseif SN < "FREEPBATPROMTACDMGP" then
										if SN == "FREEPBATPROMMELDMGP" then
											Result = EquSng(CalcStat("FreepBatPromDmgB",L)*0.005)
										elseif SN == "FREEPBATPROMPOWERP" then
											Result = EquSng(CalcStat("FreepBatPromVitalB",L)*0.01)
										elseif SN == "FREEPBATPROMRNGDMGP" then
											Result = EquSng(CalcStat("FreepBatPromDmgB",L)*0.005)
										end
									else
										Result = EquSng(CalcStat("FreepBatPromDmgB",L)*0.005)
									end
								else
									Result = EquSng(CalcStat("FreepBatPromVitalB",L)*0.01)
								end
							elseif SN < "FREEPAUDACITYMELREDP" then
								if SN < "FIREMIT" then
									if SN > "FINESSEPRATPC" then
										if SN == "FINESSEPRATPCAP" then
											Result = 50.0
										elseif SN == "FINESSEPRATPCAPR" then
											Result = CalcStat("FinessePRatPB",L)*CalcStat("FinessePRatPC",L)
										elseif SN == "FINESSET" then
											Result = EquSng(StatLinInter("PntMPFinesseT","TraitPntS","FinessePRatPB","AdjTraitRat",L,N,2))
										end
									elseif SN < "FINESSEPRATPC" then
										if SN == "FINESSEPRATP" then
											Result = CalcPercAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCap",L),N)
										elseif SN == "FINESSEPRATPA" then
											Result = 150.0
										elseif SN == "FINESSEPRATPB" then
											Result = CalcStat("BRatStandard",L)
										end
									else
										Result = 0.5
									end
								elseif SN > "FIREMIT" then
									if SN > "FOODRESIST" then
										if SN == "FREEPAUDACITYCCDP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,16,17,41,60},{0.5,0.5,0.4,0.4,0.4}},L))
											end
										elseif SN == "FREEPAUDACITYDMGP" then
											if 1 <= L and L <= 60 then
												Result = EquSng(LinInter({{1,16,17,36,41},{0.75,0.75,1.2,1.2,1.2}},L))
											end
										elseif SN == "FREEPAUDACITYMELDMGP" then
											Result = CalcStat("FreepAudacityDmgP",L)
										end
									elseif SN < "FOODRESIST" then
										if SN == "FIREMITT" then
											Result = CalcStat("DmgTypeMitT",L,N)
										elseif SN == "FOODNCMRL" then
											Result = CalcStat("NCMR",L,N*0.8)
										elseif SN == "FOODNCPRL" then
											Result = CalcStat("NCPR",L,N*1.2)
										end
									else
										Result = CalcStat("Resist",L,N*(30.0/36.0))
									end
								else
									Result = CalcStat("DmgTypeMit",L,N)
								end
							else
								Result = CalcStat("FreepAudacityRedP",L)
							end
						else
							Result = CalcRatAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCapR",L),N)
						end
					else
						Result = CalcStat("CritDef",L)
					end
				else
					Result = ""
				end
			else
				Result = CalcStat("HElfFadingFirstbornFate",L)
			end
		else
			Result = CalcStat("DmgTypeMitT",L,N)
		end
	else
		Result = -CalcStat("CritDefT",L,2.0)
	end

	return Result
end

-- to be used by other modules
-- misc.
p.trim = trim
-- floating point / rounding functions
p.DblCalcDev = DblCalcDev
p.RoundDbl = RoundDbl
p.RoundDblDown = RoundDblDown
p.RoundDblUp = RoundDblUp
p.RoundDblLotro = RoundDblLotro
p.RoundDblMorReg = RoundDblMorReg
p.RoundDblProg = RoundDblProg
p.EquSng = EquSng
p.DecSng = DecSng
-- calculation type functions
p.DataTableValue = DataTableValue
p.ExpFmod = ExpFmod
p.LinInter = LinInter
p.CalcPercAB = CalcPercAB
p.CalcRatAB = CalcRatAB
p.StatLinInter = StatLinInter
p.LinFmod = LinFmod
-- main function
p.CalcStat = CalcStat

-- ******************************* End CalcStat *******************************
