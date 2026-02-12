------------------------------------------------------------------------------------------
-- CalcStat file
-- Written by Giseldah
-- Version 1.8.0
------------------------------------------------------------------------------------------
local DblCalcDev = 0.00000001;

function CalcStat(SName, SLvl, SParam)

	-- process parameters and parameter defaults

	if type(SName) ~= "string" then
		return "Missing stat name";
	end
	local SN = string.match(SName:upper(),"^%s*(-?%a+%d*%a+)%s*$"); -- allow nested digits in stat name and a starting -
	if SN == nil then
		SN = string.match(SName,"^%s*(-?%a+)%s*$"); -- to allow single character stat name
		if SN == nil then
			return "Illegal stat name";
		end
	end
	SN = string.upper(SN);

	local L = 1; -- default L
	if type(SLvl) == "number" then
		L = SLvl;
	elseif type(SLvl) ~= "nil" then
		return "Illegal level";
	end
	local Lm = L-DblCalcDev;
	local Lp = L+DblCalcDev;

	local N = 1; -- default N
	local C = ""; -- default C
	if type(SParam) == "number" then
		N = SParam;
	elseif type(SParam) == "string" then
		C = SParam;
	elseif type(SParam) ~= "nil" then
		return "Illegal N or C";
	end

	-- binary search tree (generated code)

	if SN < "MITHEAVYPRATPB" then
		if SN < "CRITHIT" then
			if SN < "BURGLARCDBASEFATE" then
				if SN < "BEORNINGCDMIGHTTOOUTHEAL" then
					if SN < "AWARDILVLEC" then
						if SN < "ARMQTYINCOMPMP" then
							if SN < "ARMCATNEWMP" then
								if SN < "ADJITEMPROGRATINGS" then
									if SN < "ACIDMITT" then
										if SN > "-VERSION" then
											if SN == "ACIDMIT" then
												return CalcStat("DmgTypeMit",L,N);
											else
												return 0;
											end
										elseif SN == "-VERSION" then
											return "2.0.2f";
										else
											return 0;
										end
									elseif SN > "ACIDMITT" then
										if SN < "ADJITEMPROGMORREG" then
											if SN == "ADJITEMPROGLOW" then
												if Lm <= 25 then
													return 0.5;
												else
													return 1;
												end
											else
												return 0;
											end
										elseif SN > "ADJITEMPROGMORREG" then
											if SN == "ADJITEMPROGPOWER" then
												if Lm <= 349 then
													return 1;
												elseif Lm <= 350 then
													return 12/11.0;
												elseif Lm <= 399 then
													return 0.8;
												elseif Lm <= 400 then
													return 22/35;
												elseif Lm <= 449 then
													return 1/3.0;
												elseif Lm <= 450 then
													return 200/567;
												elseif Lm <= 499 then
													return 184/998;
												elseif Lm <= 500 then
													return 92/599;
												else
													return 92/998;
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 1;
											elseif Lm <= 79 then
												return 1.04;
											elseif Lm <= 349 then
												return 1;
											elseif Lm <= 350 then
												return 95/99;
											elseif Lm <= 399 then
												return 38/45;
											elseif Lm <= 400 then
												return 76/105;
											elseif Lm <= 449 then
												return 38/63;
											elseif Lm <= 450 then
												return 191/300;
											else
												return 0.5026;
											end
										end
									else
										return CalcStat("DmgTypeMitT",L,N);
									end
								elseif SN > "ADJITEMPROGRATINGS" then
									if SN < "ADJTRAITPROGRATINGS" then
										if SN < "ADJTRAITPROGMORREG" then
											if SN == "ADJTRAITPROGMORALE" then
												if Lm <= 1 then
													return 1;
												elseif Lm <= 75 then
													return 1.04;
												elseif Lm <= 115 then
													return 1;
												elseif Lm <= 116 then
													return 95/99;
												elseif Lm <= 120 then
													return 38/45;
												elseif Lm <= 121 then
													return 76/105;
												elseif Lm <= 130 then
													return 38/63;
												elseif Lm <= 131 then
													return 0.67;
												else
													return 0.670335;
												end
											else
												return 0;
											end
										elseif SN > "ADJTRAITPROGMORREG" then
											if SN == "ADJTRAITPROGPOWER" then
												if Lm <= 115 then
													return 1;
												elseif Lm <= 116 then
													return 12/11.0;
												elseif Lm <= 120 then
													return 0.8;
												elseif Lm <= 121 then
													return 22/35;
												elseif Lm <= 130 then
													return 1/3.0;
												elseif Lm <= 131 then
													return 200/567;
												elseif Lm <= 140 then
													return 184/998;
												elseif Lm <= 141 then
													return 92/599;
												else
													return 92/998;
												end
											else
												return 0;
											end
										else
											if Lm <= 121 then
												return CalcStat("AdjTraitProgMorale",L);
											elseif Lm <= 130 then
												return 1.14*0.5026;
											elseif Lm <= 131 then
												return 1.2*0.5026;
											else
												return 0.5026;
											end
										end
									elseif SN > "ADJTRAITPROGRATINGS" then
										if SN < "AGILITYT" then
											if SN == "AGILITY" then
												return CalcStat("Main",L,N);
											else
												return 0;
											end
										elseif SN > "AGILITYT" then
											if SN == "ARMCATMP" then
												if Lm <= 449 then
													return CalcStat("ArmCatOldMP",N);
												else
													return CalcStat("ArmCatNewMP",N);
												end
											else
												return 0;
											end
										else
											return CalcStat("MainT",L,N);
										end
									else
										if Lm <= 75 then
											return 1;
										elseif Lm <= 105 then
											return 0.8;
										elseif Lm <= 121 then
											return 1;
										else
											return 0.9;
										end
									end
								else
									if Lm <= 25 then
										return 0.5;
									elseif Lm <= 200 then
										return 0.8;
									elseif Lm <= 400 then
										return 1;
									else
										return 0.9;
									end
								end
							elseif SN > "ARMCATNEWMP" then
								if SN < "ARMOURPENT" then
									if SN < "ARMOUR" then
										if SN > "ARMCATOLDMP" then
											if SN == "ARMCATPROGB" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 1 then
													return CalcStat("ProgBMitHeavy",L);
												elseif Lm <= 2 then
													return CalcStat("ProgBMitMedium",L);
												else
													return CalcStat("ProgBMitLight",L);
												end
											else
												return 0;
											end
										elseif SN == "ARMCATOLDMP" then
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({3/260,3/228,3/210},L);
											end
										else
											return 0;
										end
									elseif SN > "ARMOUR" then
										if SN < "ARMOURLOW" then
											if SN == "ARMOURADJ" then
												if Lm <= 399 then
													return 1;
												elseif Lm <= 449 then
													return 0.9;
												elseif Lm <= 450 then
													return 83/90;
												else
													return 60/90;
												end
											else
												return 0;
											end
										elseif SN > "ARMOURLOW" then
											if SN == "ARMOURLOWPNTMP" then
												return CalcStat("ArmTypeMP",ArmCodeIndex(C,2))*CalcStat("ArmQtyLowMP",ArmCodeIndex(C,2))*CalcStat("ArmCatMP",L,ArmCodeIndex(C,1));
											else
												return 0;
											end
										else
											return FloorDbl(LinFmod(1,LotroDbl(CalcStat("ArmourLowPntMP",CalcStat("ItemMedProgLPL",L),C)*CalcStat("ItemMedProgVPL",L,CalcStat("ArmourProgB",L,C))*CalcStat("ArmourAdj",CalcStat("ItemMedProgLPL",L))),LotroDbl(CalcStat("ArmourLowPntMP",CalcStat("ItemMedProgLPH",L),C)*CalcStat("ItemMedProgVPH",L,CalcStat("ArmourProgB",L,C))*CalcStat("ArmourAdj",CalcStat("ItemMedProgLPH",L))),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L));
										end
									else
										return FloorDbl(LinFmod(1,LotroDbl(CalcStat("ArmourPntMP",CalcStat("ItemMedProgLPL",L),C)*CalcStat("ItemMedProgVPL",L,CalcStat("ArmourProgB",L,C))*CalcStat("ArmourAdj",CalcStat("ItemMedProgLPL",L))),LotroDbl(CalcStat("ArmourPntMP",CalcStat("ItemMedProgLPH",L),C)*CalcStat("ItemMedProgVPH",L,CalcStat("ArmourProgB",L,C))*CalcStat("ArmourAdj",CalcStat("ItemMedProgLPH",L))),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L));
									end
								elseif SN > "ARMOURPENT" then
									if SN < "ARMOURT" then
										if SN < "ARMOURPNTMP" then
											if SN == "ARMOURPENTADJ" then
												if Lm <= 75 then
													return 1;
												elseif Lm <= 105 then
													return 0.8;
												elseif Lm <= 121 then
													return 1;
												elseif Lm <= 130 then
													return 0.9;
												elseif Lm <= 140 then
													return 80/90;
												else
													return 70/90;
												end
											else
												return 0;
											end
										elseif SN > "ARMOURPNTMP" then
											if SN == "ARMOURPROGB" then
												return CalcStat("ArmCatProgB",ArmCodeIndex(C,1));
											else
												return 0;
											end
										else
											return CalcStat("ArmTypeMP",ArmCodeIndex(C,2))*CalcStat("ArmQtyMP",ArmCodeIndex(C,3),ArmCodeIndex(C,2))*CalcStat("ArmCatMP",L,ArmCodeIndex(C,1));
										end
									elseif SN > "ARMOURT" then
										if SN < "ARMQTYCOMMMP" then
											if SN == "ARMOURTADJ" then
												if Lm <= 75 then
													return 1;
												elseif Lm <= 105 then
													return 0.9;
												elseif Lm <= 106 then
													return 1;
												elseif Lm <= 115 then
													return 0.9;
												elseif Lm <= 116 then
													return 1;
												elseif Lm <= 120 then
													return 0.82;
												elseif Lm <= 121 then
													return 0.9;
												elseif Lm <= 130 then
													return 0.747;
												elseif Lm <= 131 then
													return 83/90;
												elseif Lm <= 140 then
													return 0.5464;
												elseif Lm <= 141 then
													return 60/90;
												else
													return 48/90;
												end
											else
												return 0;
											end
										elseif SN > "ARMQTYCOMMMP" then
											if SN == "ARMQTYEPICMP" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1,1,1,1,1.002,1,1},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({22/30,22/30,0.8,0.8,0.76,0.804,0.8,0.7},L);
											end
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPArmour",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("ArmourTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPArmour",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("ArmourTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
									end
								else
									return LinFmod(1,LotroDbl(CalcStat("PntMPArmour",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("ArmourPenTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPArmour",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("ArmourPenTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
								end
							else
								if Lm <= 0 then
									return 0;
								else
									return DataTableValue({3/260.04,3/227.997,3/209.901},L);
								end
							end
						elseif SN > "ARMQTYINCOMPMP" then
							if SN < "AWARDILVLC" then
								if SN < "AWARDILVLA" then
									if SN < "ARMQTYRAREMP" then
										if SN > "ARMQTYLOWMP" then
											if SN == "ARMQTYMP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 1 then
													return CalcStat("ArmQtyCommMP",N);
												elseif Lm <= 2 then
													return CalcStat("ArmQtyUncomMP",N);
												elseif Lm <= 3 then
													return CalcStat("ArmQtyRareMP",N);
												elseif Lm <= 4 then
													return CalcStat("ArmQtyIncompMP",N);
												else
													return CalcStat("ArmQtyEpicMP",N);
												end
											else
												return 0;
											end
										elseif SN == "ARMQTYLOWMP" then
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({0.4,0.4,0.4,0.4,0.4,0.3984,0.4,0.4},L);
											end
										else
											return 0;
										end
									elseif SN > "ARMQTYRAREMP" then
										if SN < "ARMTYPEMP" then
											if SN == "ARMQTYUNCOMMP" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({22/30,22/30,0.85,0.85,0.82,0.852,0.85,0.75},L);
												end
											else
												return 0;
											end
										elseif SN > "ARMTYPEMP" then
											if SN == "AUTOLVLTOILVL" then
												return CalcStat("AwardILvlCC",L);
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({9,9,21,30,15,25,12,36},L);
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return DataTableValue({26/30,26/30,0.9,0.9,0.88,0.9,0.9,0.8},L);
										end
									end
								elseif SN > "AWARDILVLA" then
									if SN < "AWARDILVLAOLD" then
										if SN < "AWARDILVLAB" then
											if SN == "AWARDILVLAA" then
												if Lm <= 74 then
													return CalcStat("AwardILvlAOld",L);
												elseif Lm <= 75 then
													return CalcStat("AwardILvlAOld",L)+3;
												else
													return CalcStat("AwardILvlAOld",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLAB" then
											if SN == "AWARDILVLAC" then
												if Lm <= 74 then
													return CalcStat("AwardILvlA",L);
												elseif Lm <= 75 then
													return CalcStat("AwardILvlA",L)+2;
												else
													return CalcStat("AwardILvlA",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 74 then
												return CalcStat("AwardILvlA",L);
											elseif Lm <= 75 then
												return CalcStat("AwardILvlA",L)+1;
											else
												return CalcStat("AwardILvlA",L);
											end
										end
									elseif SN > "AWARDILVLAOLD" then
										if SN < "AWARDILVLBA" then
											if SN == "AWARDILVLB" then
												if Lm <= 95 then
													return CalcStat("AwardILvlBOld",L);
												elseif Lm <= 96 then
													return CalcStat("AwardILvlBOld",95);
												else
													return CalcStat("AwardILvlBOld",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLBA" then
											if SN == "AWARDILVLBOLD" then
												if Lm <= 4 then
													return CalcStat("AwardILvlA",1);
												elseif Lm <= 50 then
													return CalcStat("AwardILvlA",L-4);
												elseif Lm <= 54 then
													return CalcStat("AwardILvlA",51);
												elseif Lm <= 75 then
													return CalcStat("AwardILvlA",L-4);
												elseif Lm <= 95 then
													return CalcStat("AwardILvlA",L)+4;
												elseif Lm <= 130 then
													return CalcStat("AwardILvlA",L);
												elseif Lm <= 135 then
													return RoundDbl(LinFmod(1,438.4,443.4,131,135,L));
												elseif Lm <= 140 then
													return RoundDbl(LinFmod(1,444.4,446.4,136,140,L));
												else
													return CalcStat("AwardILvlBOld",140);
												end
											else
												return 0;
											end
										else
											return CalcStat("AwardILvlB",L);
										end
									else
										if Lm <= 120 then
											return CalcStat("AwardILvlA",L);
										elseif Lm <= 130 then
											return RoundDbl((14/15)*L+4081/15);
										elseif Lm <= 140 then
											return RoundDbl(LinFmod(1,435.4,445.4,131,140,L));
										else
											return CalcStat("AwardILvlAOld",140);
										end
									end
								else
									if Lm <= 75 then
										return L;
									elseif Lm <= 94 then
										return 5*L-304;
									elseif Lm <= 95 then
										return 173;
									elseif Lm <= 100 then
										return 5*L-304;
									elseif Lm <= 101 then
										return 197;
									elseif Lm <= 104 then
										return 4*L-206;
									elseif Lm <= 105 then
										return 218;
									elseif Lm <= 114 then
										return 3*L-30;
									elseif Lm <= 115 then
										return 314;
									elseif Lm <= 120 then
										return 5*L-245;
									elseif Lm <= 130 then
										return 2*L+143;
									elseif Lm <= 140 then
										return RoundDbl(LinFmod(1,435.4,445.4,131,140,L));
									else
										return CalcStat("AwardILvlA",140);
									end
								end
							elseif SN > "AWARDILVLC" then
								if SN < "AWARDILVLDC" then
									if SN < "AWARDILVLCD" then
										if SN < "AWARDILVLCB" then
											if SN == "AWARDILVLCA" then
												if Lm <= 95 then
													return CalcStat("AwardILvlC",L);
												elseif Lm <= 100 then
													return CalcStat("AwardILvlC",L)+4;
												else
													return CalcStat("AwardILvlC",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLCB" then
											if SN == "AWARDILVLCC" then
												if Lm <= 75 then
													return CalcStat("AwardILvlC",L);
												elseif Lm <= 95 then
													return CalcStat("AwardILvlC",L)+2;
												else
													return CalcStat("AwardILvlC",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 95 then
												return CalcStat("AwardILvlC",L);
											elseif Lm <= 99 then
												return CalcStat("AwardILvlC",L)+4;
											elseif Lm <= 100 then
												return CalcStat("AwardILvlC",L)+6;
											else
												return CalcStat("AwardILvlC",L);
											end
										end
									elseif SN > "AWARDILVLCD" then
										if SN < "AWARDILVLDA" then
											if SN == "AWARDILVLD" then
												if Lm <= 105 then
													return CalcStat("AwardILvlC",L);
												elseif Lm <= 115 then
													return 300;
												elseif Lm <= 130 then
													return CalcStat("AwardILvlC",L)+3;
												else
													return CalcStat("AwardILvlC",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLDA" then
											if SN == "AWARDILVLDB" then
												if Lm <= 105 then
													return CalcStat("AwardILvlD",L);
												elseif Lm <= 115 then
													return RoundDbl(LinFmod(1,300,345,106,115,L));
												else
													return CalcStat("AwardILvlD",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return CalcStat("AwardILvlD",L);
											elseif Lm <= 115 then
												return RoundDbl(LinFmod(1,300,336.5,106,115,L));
											else
												return CalcStat("AwardILvlD",L);
											end
										end
									else
										if Lm <= 100 then
											return CalcStat("AwardILvlC",L);
										elseif Lm <= 105 then
											return CalcStat("AwardILvlC",L)+4;
										else
											return CalcStat("AwardILvlC",L);
										end
									end
								elseif SN > "AWARDILVLDC" then
									if SN < "AWARDILVLDG" then
										if SN < "AWARDILVLDE" then
											if SN == "AWARDILVLDD" then
												if Lm <= 105 then
													return CalcStat("AwardILvlD",L);
												elseif Lm <= 114 then
													return RoundDbl(LinFmod(1,300,327,106,115,L));
												elseif Lm <= 115 then
													return CalcStat("AwardILvlD",115)+30;
												else
													return CalcStat("AwardILvlD",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLDE" then
											if SN == "AWARDILVLDF" then
												if Lm <= 105 then
													return CalcStat("AwardILvlD",L);
												elseif Lm <= 110 then
													return CalcStat("AwardILvlDF",111);
												elseif Lm <= 115 then
													return RoundDbl(LinFmod(1,299.5,320.5,106,115,L));
												else
													return CalcStat("AwardILvlD",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return CalcStat("AwardILvlD",L);
											elseif Lm <= 115 then
												return RoundDbl(LinFmod(1,300.4,326.4,106,115,L));
											else
												return CalcStat("AwardILvlD",L);
											end
										end
									elseif SN > "AWARDILVLDG" then
										if SN < "AWARDILVLEA" then
											if SN == "AWARDILVLE" then
												if Lm <= 115 then
													return CalcStat("AwardILvlC",L);
												elseif Lm <= 120 then
													return 350;
												else
													return CalcStat("AwardILvlD",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLEA" then
											if SN == "AWARDILVLEB" then
												if Lm <= 115 then
													return CalcStat("AwardILvlE",L);
												elseif Lm <= 119 then
													return RoundDbl(LinFmod(1,350,390,116,120,L));
												elseif Lm <= 120 then
													return CalcStat("AwardILvlE",120)+38;
												else
													return CalcStat("AwardILvlE",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 115 then
												return CalcStat("AwardILvlE",L);
											elseif Lm <= 119 then
												return RoundDbl(LinFmod(1,350,378,116,120,L));
											elseif Lm <= 120 then
												return CalcStat("AwardILvlE",120)+26;
											else
												return CalcStat("AwardILvlE",L);
											end
										end
									else
										if Lm <= 105 then
											return CalcStat("AwardILvlD",L);
										elseif Lm <= 114 then
											return RoundDbl(LinFmod(1,300,336,106,115,L));
										elseif Lm <= 115 then
											return CalcStat("AwardILvlD",115)+40;
										else
											return CalcStat("AwardILvlD",L);
										end
									end
								else
									if Lm <= 105 then
										return CalcStat("AwardILvlD",L);
									elseif Lm <= 110 then
										return RoundDbl(LinFmod(1,300,320,106,115,L));
									elseif Lm <= 115 then
										return CalcStat("AwardILvlDC",110);
									else
										return CalcStat("AwardILvlD",L);
									end
								end
							else
								if Lm <= 75 then
									return CalcStat("AwardILvlBOld",L);
								elseif Lm <= 95 then
									return CalcStat("AwardILvlA",L);
								else
									return CalcStat("AwardILvlBOld",L);
								end
							end
						else
							if Lm <= 0 then
								return 0;
							else
								return DataTableValue({28/30,28/30,0.95,0.95,0.94,0.948,0.95,0.95},L);
							end
						end
					elseif SN > "AWARDILVLEC" then
						if SN < "BEOFATE" then
							if SN < "AWARDILVLIA" then
								if SN < "AWARDILVLGA" then
									if SN < "AWARDILVLF" then
										if SN > "AWARDILVLED" then
											if SN == "AWARDILVLEE" then
												if Lm <= 115 then
													return CalcStat("AwardILvlE",L);
												elseif Lm <= 119 then
													return RoundDbl(LinFmod(1,350,366,116,120,L));
												elseif Lm <= 120 then
													return CalcStat("AwardILvlE",120)+14;
												else
													return CalcStat("AwardILvlE",L);
												end
											else
												return 0;
											end
										elseif SN == "AWARDILVLED" then
											if Lm <= 115 then
												return CalcStat("AwardILvlE",L);
											elseif Lm <= 120 then
												return RoundDbl(LinFmod(1,350,370,116,120,L));
											else
												return CalcStat("AwardILvlE",L);
											end
										else
											return 0;
										end
									elseif SN > "AWARDILVLF" then
										if SN < "AWARDILVLFB" then
											if SN == "AWARDILVLFA" then
												if Lm <= 130 then
													return CalcStat("AwardILvlF",L);
												elseif Lm <= 140 then
													return RoundDbl(LinFmod(1,438.4,447.4,131,140,L));
												else
													return CalcStat("AwardILvlFA",140);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLFB" then
											if SN == "AWARDILVLG" then
												if Lm <= 115 then
													return CalcStat("AwardILvlC",L);
												elseif Lm <= 120 then
													return CalcStat("AwardILvlC",L)+3;
												elseif Lm <= 130 then
													return 400;
												else
													return CalcStat("AwardILvlC",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 119 then
												return CalcStat("AwardILvlF",L);
											elseif Lm <= 120 then
												return 380;
											elseif Lm <= 129 then
												return CalcStat("AwardILvlF",L);
											elseif Lm <= 130 then
												return 432;
											elseif Lm <= 140 then
												return RoundDbl(LinFmod(1,450.4,470.4,131,140,L));
											else
												return CalcStat("AwardILvlFB",140);
											end
										end
									else
										if Lm <= 40 then
											return LinFmod(1,1,40,1,40,L);
										elseif Lm <= 41 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 49 then
											return LinFmod(1,41,48,42,49,L);
										elseif Lm <= 50 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 55 then
											return LinFmod(1,51,55,51,55,L);
										elseif Lm <= 56 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 59 then
											return LinFmod(1,56,58,57,59,L);
										elseif Lm <= 60 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 64 then
											return RoundDbl(LinFmod(1,60.6,63,61,64,L));
										elseif Lm <= 65 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 70 then
											return LinFmod(1,66,70,66,70,L);
										elseif Lm <= 71 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 74 then
											return LinFmod(1,71,73,72,74,L);
										elseif Lm <= 75 then
											return CalcStat("AwardILvlF",L-1);
										elseif Lm <= 85 then
											return RoundDbl(LinFmod(1,80.4,123.4,76,85,L));
										elseif Lm <= 94 then
											return RoundDbl(LinFmod(1,130,169,86,94,L));
										elseif Lm <= 100 then
											return RoundDbl(LinFmod(1,175,198.4,95,100,L));
										elseif Lm <= 104 then
											return LinFmod(1,201,213,101,104,L);
										elseif Lm <= 105 then
											return 220;
										elseif Lm <= 114 then
											return RoundDbl(LinFmod(1,300,323,106,114,L));
										elseif Lm <= 115 then
											return 324;
										elseif Lm <= 120 then
											return RoundDbl(LinFmod(1,349.6,368.4,116,120,L));
										elseif Lm <= 130 then
											return RoundDbl(LinFmod(1,400.4,416.4,121,130,L));
										else
											return CalcStat("AwardILvlF",130);
										end
									end
								elseif SN > "AWARDILVLGA" then
									if SN < "AWARDILVLGE" then
										if SN < "AWARDILVLGC" then
											if SN == "AWARDILVLGB" then
												if Lm <= 120 then
													return CalcStat("AwardILvlG",L);
												elseif Lm <= 130 then
													return RoundDbl(LinFmod(1,400.4,418.4,121,130,L));
												else
													return CalcStat("AwardILvlG",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLGC" then
											if SN == "AWARDILVLGD" then
												if Lm <= 120 then
													return CalcStat("AwardILvlG",L);
												elseif Lm <= 130 then
													return RoundDbl(LinFmod(1,400.4,426.4,121,130,L));
												else
													return CalcStat("AwardILvlG",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 120 then
												return CalcStat("AwardILvlG",L);
											elseif Lm <= 130 then
												return RoundDbl(LinFmod(1,400.4,408.3,121,130,L));
											else
												return CalcStat("AwardILvlG",L);
											end
										end
									elseif SN > "AWARDILVLGE" then
										if SN < "AWARDILVLH" then
											if SN == "AWARDILVLGF" then
												if Lm <= 120 then
													return CalcStat("AwardILvlG",L);
												elseif Lm <= 130 then
													return RoundDbl(LinFmod(1,400.4,440.4,121,130,L));
												else
													return CalcStat("AwardILvlG",L);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLH" then
											if SN == "AWARDILVLI" then
												if Lm <= 44 then
													return 1;
												elseif Lm <= 55 then
													return 52;
												elseif Lm <= 75 then
													return FloorDbl((L-56)/5)*5+60;
												elseif Lm <= 85 then
													return FloorDbl((L-76)/5)*29+100;
												elseif Lm <= 95 then
													return FloorDbl((L-86)/5)*20+155;
												elseif Lm <= 100 then
													return FloorDbl((L-96)/4)*10+190;
												elseif Lm <= 105 then
													return FloorDbl((L-101)/4)*35+215;
												elseif Lm <= 110 then
													return CalcStat("LvlToILvl",106)+15;
												elseif Lm <= 115 then
													return CalcStat("LvlToILvl",115);
												elseif Lm <= 119 then
													return CalcStat("LvlToILvl",116)+15;
												elseif Lm <= 120 then
													return CalcStat("LvlToILvl",120);
												elseif Lm <= 125 then
													return CalcStat("LvlToILvl",121)+15;
												elseif Lm <= 130 then
													return CalcStat("LvlToILvl",130);
												elseif Lm <= 135 then
													return CalcStat("LvlToILvl",131)+15;
												elseif Lm <= 140 then
													return CalcStat("LvlToILvl",140);
												else
													return CalcStat("AwardILvlI",140);
												end
											else
												return 0;
											end
										else
											if Lm <= 4 then
												return CalcStat("AwardILvlA",1);
											elseif Lm <= 50 then
												return CalcStat("AwardILvlA",L-4);
											elseif Lm <= 54 then
												return CalcStat("AwardILvlA",51);
											elseif Lm <= 75 then
												return CalcStat("AwardILvlA",L-4);
											else
												return L-4;
											end
										end
									else
										if Lm <= 120 then
											return CalcStat("AwardILvlG",L);
										elseif Lm <= 130 then
											return RoundDbl(LinFmod(1,400.4,434.4,121,130,L));
										else
											return CalcStat("AwardILvlG",L);
										end
									end
								else
									if Lm <= 120 then
										return CalcStat("AwardILvlG",L);
									elseif Lm <= 130 then
										return RoundDbl(LinFmod(1,400.4,412.4,121,130,L));
									else
										return CalcStat("AwardILvlG",L);
									end
								end
							elseif SN > "AWARDILVLIA" then
								if SN < "AWARDLVLTOILVL" then
									if SN < "AWARDILVLJB" then
										if SN > "AWARDILVLJ" then
											if SN == "AWARDILVLJA" then
												if Lm <= 130 then
													return CalcStat("AwardILvlJ",L);
												elseif Lm <= 140 then
													return RoundDbl(LinFmod(1,450.4,465.4,131,140,L));
												else
													return CalcStat("AwardILvlJA",140);
												end
											else
												return 0;
											end
										elseif SN == "AWARDILVLJ" then
											if Lm <= 19 then
												return CalcStat("AwardILvlB",L);
											elseif Lm <= 40 then
												return CalcStat("AwardILvlA",L);
											elseif Lm <= 50 then
												return RoundDbl(LinFmod(1,40.4,47.6,41,50,L));
											elseif Lm <= 120 then
												return CalcStat("AwardILvlG",L);
											elseif Lm <= 130 then
												return CalcStat("AwardILvlD",L);
											elseif Lm <= 140 then
												return RoundDbl(LinFmod(1,450.4,460.4,131,140,L));
											else
												return CalcStat("AwardILvlJ",140);
											end
										else
											return 0;
										end
									elseif SN > "AWARDILVLJB" then
										if SN < "AWARDILVLJD" then
											if SN == "AWARDILVLJC" then
												if Lm <= 130 then
													return CalcStat("AwardILvlJ",L);
												elseif Lm <= 140 then
													return RoundDbl(LinFmod(1,450.4,475.4,131,140,L));
												else
													return CalcStat("AwardILvlJC",140);
												end
											else
												return 0;
											end
										elseif SN > "AWARDILVLJD" then
											if SN == "AWARDLVLCAP" then
												return 140;
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return CalcStat("AwardILvlJ",L);
											elseif Lm <= 140 then
												return RoundDbl(LinFmod(1,450.4,480.4,131,140,L));
											else
												return CalcStat("AwardILvlJD",140);
											end
										end
									else
										if Lm <= 130 then
											return CalcStat("AwardILvlJ",L);
										elseif Lm <= 140 then
											return RoundDbl(LinFmod(1,450.4,470.4,131,140,L));
										else
											return CalcStat("AwardILvlJB",140);
										end
									end
								elseif SN > "AWARDLVLTOILVL" then
									if SN < "BATTLELOREMAS" then
										if SN < "AXEARMRENDPOS" then
											if SN == "AXEARMOURREND" then
												return -CalcStat("AxeArmRendPos",L);
											else
												return 0;
											end
										elseif SN > "AXEARMRENDPOS" then
											if SN == "BALANCEOFMANAVOID" then
												if Lm <= 105 then
													return RoundDbl(8.08*L);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("BalanceOfManAvoid",105));
												end
											else
												return 0;
											end
										else
											if Lm <= 7 then
												return RoundDbl(LinFmod(1,0.5,3.25,1,7,L));
											elseif Lm <= 14 then
												return RoundDbl(LinFmod(1,3.75,8.5,8,14,L));
											elseif Lm <= 30 then
												return RoundDbl(LinFmod(1,9,24.7,15,30,L));
											elseif Lm <= 39 then
												return RoundDbl(LinFmod(1,26.5,37,31,39,L));
											elseif Lm <= 50 then
												return RoundDbl(LinFmod(1,38.5,53,40,50,L));
											elseif Lm <= 52 then
												return 53;
											elseif Lm <= 60 then
												return RoundDbl(LinFmod(1,53.2,64.8,53,60,L));
											elseif Lm <= 77 then
												return RoundDbl(LinFmod(1,66.15,94.8,61,77,L));
											elseif Lm <= 113 then
												return RoundDbl(RoundDbl(L/3-0.5)*1.95+44.1);
											elseif Lm <= 141 then
												return 116;
											elseif Lm <= 181 then
												return RoundDbl(RoundDbl(L/4)*2+46);
											elseif Lm <= 217 then
												return RoundDbl(RoundDbl(L/4)*2+45);
											elseif Lm <= 221 then
												return 153;
											elseif Lm <= 299 then
												return 155;
											elseif Lm <= 308 then
												return RoundDbl(RoundDbl(L/2.6-0.4)*2-73);
											elseif Lm <= 317 then
												return RoundDbl(RoundDbl(L/2.74-0.75)*2-60);
											elseif Lm <= 325 then
												return 172;
											elseif Lm <= 326 then
												return 174;
											elseif Lm <= 500 then
												return ExpFmod(CalcStat("AxeArmRendPos",326),327,1,L,1);
											else
												return CalcStat("AxeArmRendPos",500);
											end
										end
									elseif SN > "BATTLELOREMAS" then
										if SN < "BATTLELORETACMAS" then
											if SN == "BATTLELOREPHYMAS" then
												return CalcStat("BattleLoreMas",L);
											else
												return 0;
											end
										elseif SN > "BATTLELORETACMAS" then
											if SN == "BEOEMISSARYFATE" then
												return CalcStat("FateT",L,1.0);
											else
												return 0;
											end
										else
											return CalcStat("BattleLoreMas",L);
										end
									else
										if Lm <= 105 then
											return CalcStat("Mastery",L,2.5);
										elseif Lm <= 119 then
											return CalcStat("MasteryT",L,1.2);
										elseif Lm <= 120 then
											return CalcStat("MasteryT",L,1.6);
										elseif Lm <= 129 then
											return CalcStat("MasteryT",L,1.2);
										else
											return CalcStat("MasteryT",L,1.6);
										end
									end
								else
									return CalcStat("AwardILvlC",L);
								end
							else
								if Lm <= 44 then
									return CalcStat("AwardILvlI",L);
								elseif Lm <= 55 then
									return FloorDbl((L-45)/6)+51;
								elseif Lm <= 90 then
									return CalcStat("AwardILvlI",L);
								elseif Lm <= 104 then
									return FloorDbl((L-91)/5)*25+165;
								elseif Lm <= 105 then
									return CalcStat("LvlToILvl",L);
								elseif Lm <= 110 then
									return CalcStat("LvlToILvl",106)+15;
								elseif Lm <= 115 then
									return CalcStat("LvlToILvl",115)-20;
								elseif Lm <= 120 then
									return CalcStat("LvlToILvl",116)+15;
								elseif Lm <= 125 then
									return CalcStat("LvlToILvl",121)+15;
								elseif Lm <= 130 then
									return CalcStat("LvlToILvl",130)-20;
								elseif Lm <= 135 then
									return CalcStat("LvlToILvl",131)+15;
								elseif Lm <= 140 then
									return CalcStat("LvlToILvl",140)-24;
								else
									return CalcStat("AwardILvlIA",140);
								end
							end
						elseif SN > "BEOFATE" then
							if SN < "BEORNINGCDBASEMIGHT" then
								if SN < "BEORNINGCDARMOURTOOFMIT" then
									if SN < "BEOMIGHTOFTHEWILDMIGHT" then
										if SN > "BEOFERALPRESFATE" then
											if SN == "BEOFEWINNUMBERFATE" then
												return -7;
											else
												return 0;
											end
										elseif SN == "BEOFERALPRESFATE" then
											if Lm <= 105 then
												return RoundDbl(1.6*L+0.4);
											else
												return CalcStat("ProgExtMpExpRnd",L,CalcStat("BeoFeralPresFate",105));
											end
										else
											return 0;
										end
									elseif SN > "BEOMIGHTOFTHEWILDMIGHT" then
										if SN < "BEORNINGCDAGILITYTOEVADE" then
											if SN == "BEORNINGCDAGILITYTOCRITHIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDAGILITYTOEVADE" then
											if SN == "BEORNINGCDAGILITYTOPHYMAS" then
												return 2;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 15;
									end
								elseif SN > "BEORNINGCDARMOURTOOFMIT" then
									if SN < "BEORNINGCDBASEAGILITY" then
										if SN < "BEORNINGCDARMOURTOTACMIT" then
											if SN == "BEORNINGCDARMOURTOPHYMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDARMOURTOTACMIT" then
											if SN == "BEORNINGCDARMOURTYPE" then
												return 3;
											else
												return 0;
											end
										else
											return 0.2;
										end
									elseif SN > "BEORNINGCDBASEAGILITY" then
										if SN < "BEORNINGCDBASEICMR" then
											if SN == "BEORNINGCDBASEFATE" then
												return CalcStat("ClassBaseMainJ",L);
											else
												return 0;
											end
										elseif SN > "BEORNINGCDBASEICMR" then
											if SN == "BEORNINGCDBASEICPR" then
												return 0;
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICMRM",L);
										end
									else
										return CalcStat("ClassBaseMainA",L);
									end
								else
									return 0.2;
								end
							elseif SN > "BEORNINGCDBASEMIGHT" then
								if SN < "BEORNINGCDFATETOCRITHIT" then
									if SN < "BEORNINGCDBASEPOWER" then
										if SN < "BEORNINGCDBASENCMR" then
											if SN == "BEORNINGCDBASEMORALE" then
												return CalcStat("ClassBaseMoraleMb",L);
											else
												return 0;
											end
										elseif SN > "BEORNINGCDBASENCMR" then
											if SN == "BEORNINGCDBASENCPR" then
												return 0;
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseNCMRM",L);
										end
									elseif SN > "BEORNINGCDBASEPOWER" then
										if SN < "BEORNINGCDBASEWILL" then
											if SN == "BEORNINGCDBASEVITALITY" then
												return CalcStat("ClassBaseMainC",L);
											else
												return 0;
											end
										elseif SN > "BEORNINGCDBASEWILL" then
											if SN == "BEORNINGCDCANBLOCK" then
												if Lm <= 5 then
													return 0;
												else
													return 1;
												end
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainF",L);
										end
									else
										return 20;
									end
								elseif SN > "BEORNINGCDFATETOCRITHIT" then
									if SN < "BEORNINGCDFATETOTACMIT" then
										if SN < "BEORNINGCDFATETOICMR" then
											if SN == "BEORNINGCDFATETOFINESSE" then
												return 0.5;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDFATETOICMR" then
											if SN == "BEORNINGCDFATETORESIST" then
												return 1;
											else
												return 0;
											end
										else
											return 3;
										end
									elseif SN > "BEORNINGCDFATETOTACMIT" then
										if SN < "BEORNINGCDMIGHTTOCRITHIT" then
											if SN == "BEORNINGCDMIGHTTOBLOCK" then
												return 2;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDMIGHTTOCRITHIT" then
											if SN == "BEORNINGCDMIGHTTOEVADE" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 2;
									end
								else
									return 2.5;
								end
							else
								return CalcStat("ClassBaseMainH",L);
							end
						else
							return CalcStat("FateT",L,CalcStat("Trait567810Choice",N)*0.4);
						end
					else
						if Lm <= 115 then
							return CalcStat("AwardILvlE",L);
						elseif Lm <= 120 then
							return RoundDbl(LinFmod(1,350,382,116,120,L));
						else
							return CalcStat("AwardILvlE",L);
						end
					end
				elseif SN > "BEORNINGCDMIGHTTOOUTHEAL" then
					if SN < "BRAWLERCDBASEVITALITY" then
						if SN < "BLOCKPRATPCAPR" then
							if SN < "BEORNINGRDPSVONENAME" then
								if SN < "BEORNINGCDVITALITYTONCMR" then
									if SN < "BEORNINGCDMIGHTTOTACMAS" then
										if SN > "BEORNINGCDMIGHTTOPARRY" then
											if SN == "BEORNINGCDMIGHTTOPHYMAS" then
												return 2.5;
											else
												return 0;
											end
										elseif SN == "BEORNINGCDMIGHTTOPARRY" then
											return 3;
										else
											return 0;
										end
									elseif SN > "BEORNINGCDMIGHTTOTACMAS" then
										if SN < "BEORNINGCDTACMASTOOUTHEAL" then
											if SN == "BEORNINGCDPHYMITTOOFMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDTACMASTOOUTHEAL" then
											if SN == "BEORNINGCDVITALITYTOMORALE" then
												return 4.8;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 2.5;
									end
								elseif SN > "BEORNINGCDVITALITYTONCMR" then
									if SN < "BEORNINGCDWILLTORESIST" then
										if SN < "BEORNINGCDWILLTOEVADE" then
											if SN == "BEORNINGCDVITALITYTORESIST" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDWILLTOEVADE" then
											if SN == "BEORNINGCDWILLTOOUTHEAL" then
												return 2;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "BEORNINGCDWILLTORESIST" then
										if SN < "BEORNINGCDWILLTOTACMIT" then
											if SN == "BEORNINGCDWILLTOTACMAS" then
												return 2;
											else
												return 0;
											end
										elseif SN > "BEORNINGCDWILLTOTACMIT" then
											if SN == "BEORNINGRDPSVONEFATE" then
												return CalcStat("BeoEmissaryFate",L);
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 1;
									end
								else
									return 7.2;
								end
							elseif SN > "BEORNINGRDPSVONENAME" then
								if SN < "BLOCK" then
									if SN < "BEORNINGRDTRAITMIGHT" then
										if SN > "BEORNINGRDPSVTWONAME" then
											if SN == "BEORNINGRDTRAITFATE" then
												return CalcStat("BeoFewinNumberFate",L);
											else
												return 0;
											end
										elseif SN == "BEORNINGRDPSVTWONAME" then
											return "";
										else
											return 0;
										end
									elseif SN > "BEORNINGRDTRAITMIGHT" then
										if SN < "BEOTHICKHIDEVITALITY" then
											if SN == "BEORNINGRDTRAITVITALITY" then
												return CalcStat("BeoThickHideVitality",L);
											else
												return 0;
											end
										elseif SN > "BEOTHICKHIDEVITALITY" then
											if SN == "BEOVITALITYINCREASE" then
												return CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4);
											else
												return 0;
											end
										else
											return 15;
										end
									else
										return CalcStat("BeoMightoftheWildMight",L);
									end
								elseif SN > "BLOCK" then
									if SN < "BLOCKPRATPA" then
										if SN < "BLOCKPPRAT" then
											if SN == "BLOCKPBONUS" then
												return CalcStat("BPEPBonus",L);
											else
												return 0;
											end
										elseif SN > "BLOCKPPRAT" then
											if SN == "BLOCKPRATP" then
												return CalcStat("BPEPRatP",L,N);
											else
												return 0;
											end
										else
											return CalcStat("BPEPPRat",L,N);
										end
									elseif SN > "BLOCKPRATPA" then
										if SN < "BLOCKPRATPC" then
											if SN == "BLOCKPRATPB" then
												return CalcStat("BPEPRatPB",L);
											else
												return 0;
											end
										elseif SN > "BLOCKPRATPC" then
											if SN == "BLOCKPRATPCAP" then
												return CalcStat("BPEPRatPCap",L);
											else
												return 0;
											end
										else
											return CalcStat("BPEPRatPC",L);
										end
									else
										return CalcStat("BPEPRatPA",L);
									end
								else
									return CalcStat("BPE",L,N);
								end
							else
								return "Emissary";
							end
						elseif SN > "BLOCKPRATPCAPR" then
							if SN < "BRATPROGALT" then
								if SN < "BPEPRATPA" then
									if SN < "BPEADJ" then
										if SN > "BLOCKT" then
											if SN == "BPE" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("BPEAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("BPEAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
											else
												return 0;
											end
										elseif SN == "BLOCKT" then
											return CalcStat("BPET",L,N);
										else
											return 0;
										end
									elseif SN > "BPEADJ" then
										if SN < "BPEPPRAT" then
											if SN == "BPEPBONUS" then
												return 0;
											else
												return 0;
											end
										elseif SN > "BPEPPRAT" then
											if SN == "BPEPRATP" then
												return CalcPercAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCap",L),N);
											else
												return 0;
											end
										else
											return CalcRatAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCapR",L),N);
										end
									else
										if Lm <= 449 then
											return CalcStat("AdjItemProgRatings",L);
										elseif Lm <= 450 then
											return 1;
										else
											return 40/30;
										end
									end
								elseif SN > "BPEPRATPA" then
									if SN < "BPEPRATPCAPR" then
										if SN < "BPEPRATPC" then
											if SN == "BPEPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
												else
													return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
												end
											else
												return 0;
											end
										elseif SN > "BPEPRATPC" then
											if SN == "BPEPRATPCAP" then
												return 13;
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 1;
											else
												return 0.5;
											end
										end
									elseif SN > "BPEPRATPCAPR" then
										if SN < "BPETADJ" then
											if SN == "BPET" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("BPETAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("BPETAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
											else
												return 0;
											end
										elseif SN > "BPETADJ" then
											if SN == "BRATPROG" then
												if Lm <= 75 then
													return LinFmod(RoundDbl(N),1,75,1,75,L);
												elseif Lm <= 76 then
													return LinFmod(1,RoundDbl(N)*75,CalcStat("StdProg",76,N),75,76,L);
												elseif Lm <= 100 then
													return LinFmod(1,CalcStat("StdProg",76,N),CalcStat("StdProg",100,N),75,100,L,-1);
												elseif Lm <= 101 then
													return CalcStat("StdProg",L,N);
												elseif Lm <= 105 then
													return LinFmod(1,CalcStat("StdProg",101,N),CalcStat("StdProg",105,N),100,105,L,-1);
												elseif Lm <= 106 then
													return CalcStat("StdProg",L,N);
												elseif Lm <= 115 then
													return LinFmod(1,CalcStat("StdProg",106,N),CalcStat("StdProg",115,N),106,115,L,-1);
												elseif Lm <= 116 then
													return CalcStat("StdProg",L,N);
												elseif Lm <= 120 then
													return LinFmod(1,CalcStat("StdProg",116,N),CalcStat("StdProg",120,N),116,120,L,-1);
												elseif Lm <= 121 then
													return CalcStat("StdProg",L,N);
												elseif Lm <= 130 then
													return LinFmod(1,CalcStat("StdProg",121,N),CalcStat("StdProg",130,N),121,130,L,-1);
												elseif Lm <= 131 then
													return LinFmod(1,CalcStat("StdProg",130,N),RoundDbl(CalcStat("StdProg",131,N),-3),130,131,L);
												else
													return LinFmod(1,RoundDbl(CalcStat("StdProg",131,N),-3),RoundDbl(CalcStat("StdProg",131,N),-3)*2,131,140,L,-1);
												end
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return CalcStat("AdjTraitProgRatings",L);
											elseif Lm <= 131 then
												return 11/9.0;
											else
												return 40/30;
											end
										end
									else
										return CalcStat("BPEPRatPB",L)*CalcStat("BPEPRatPC",L);
									end
								else
									if Lm <= 130 then
										return 26;
									else
										return 39;
									end
								end
							elseif SN > "BRATPROGALT" then
								if SN < "BRAWLERCDBASEFATE" then
									if SN < "BRAWLERCDARMOURTOPHYMIT" then
										if SN < "BRAWLERCDAGILITYTOPARRY" then
											if SN == "BRAWLERCDAGILITYTOEVADE" then
												return 3;
											else
												return 0;
											end
										elseif SN > "BRAWLERCDAGILITYTOPARRY" then
											if SN == "BRAWLERCDARMOURTOOFMIT" then
												return 0.2;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "BRAWLERCDARMOURTOPHYMIT" then
										if SN < "BRAWLERCDARMOURTYPE" then
											if SN == "BRAWLERCDARMOURTOTACMIT" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "BRAWLERCDARMOURTYPE" then
											if SN == "BRAWLERCDBASEAGILITY" then
												return CalcStat("ClassBaseMainC",L);
											else
												return 0;
											end
										else
											return 3;
										end
									else
										return 1;
									end
								elseif SN > "BRAWLERCDBASEFATE" then
									if SN < "BRAWLERCDBASEMORALE" then
										if SN < "BRAWLERCDBASEICPR" then
											if SN == "BRAWLERCDBASEICMR" then
												return CalcStat("ClassBaseICMRL",L);
											else
												return 0;
											end
										elseif SN > "BRAWLERCDBASEICPR" then
											if SN == "BRAWLERCDBASEMIGHT" then
												return CalcStat("ClassBaseMainH",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICPR",L);
										end
									elseif SN > "BRAWLERCDBASEMORALE" then
										if SN < "BRAWLERCDBASENCPR" then
											if SN == "BRAWLERCDBASENCMR" then
												return CalcStat("ClassBaseNCMRL",L);
											else
												return 0;
											end
										elseif SN > "BRAWLERCDBASENCPR" then
											if SN == "BRAWLERCDBASEPOWER" then
												if Lm <= 120 then
													return CalcStat("ClassBasePowerL",L);
												else
													return CalcStat("ClassBasePowerL",120);
												end
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseNCPR",L);
										end
									else
										if Lm <= 120 then
											return CalcStat("ClassBaseMoraleMa",L);
										else
											return CalcStat("ClassBaseMoraleMa",120);
										end
									end
								else
									return CalcStat("ClassBaseMainC",L);
								end
							else
								if Lm <= 75 then
									return LinFmod(RoundDbl(N),1,75,1,75,L);
								elseif Lm <= 76 then
									return LinFmod(1,RoundDbl(N)*75,CalcStat("StdProgAlt",76,N),75,76,L);
								elseif Lm <= 100 then
									return LinFmod(1,CalcStat("StdProgAlt",76,N),CalcStat("StdProgAlt",100,N),75,100,L,-1);
								elseif Lm <= 101 then
									return CalcStat("StdProgAlt",L,N);
								elseif Lm <= 105 then
									return LinFmod(1,CalcStat("StdProgAlt",101,N),CalcStat("StdProgAlt",105,N),100,105,L,-1);
								elseif Lm <= 106 then
									return CalcStat("StdProgAlt",L,N);
								elseif Lm <= 115 then
									return LinFmod(1,CalcStat("StdProgAlt",106,N),CalcStat("StdProgAlt",115,N),106,115,L,-1);
								elseif Lm <= 116 then
									return CalcStat("StdProgAlt",L,N);
								elseif Lm <= 120 then
									return LinFmod(1,CalcStat("StdProgAlt",116,N),CalcStat("StdProgAlt",120,N),116,120,L,-1);
								elseif Lm <= 121 then
									return CalcStat("StdProgAlt",L,N);
								elseif Lm <= 130 then
									return LinFmod(1,CalcStat("StdProgAlt",121,N),CalcStat("StdProgAlt",130,N),121,130,L,-1);
								elseif Lm <= 131 then
									return CalcStat("StdProgAlt",L,N);
								else
									return LinFmod(1,CalcStat("StdProgAlt",131,N),CalcStat("StdProgAlt",131,N)*2,131,140,L,-1);
								end
							end
						else
							return CalcStat("BPEPRatPCapR",L);
						end
					elseif SN > "BRAWLERCDBASEVITALITY" then
						if SN < "BRGLEAFWALKERSTEALTH" then
							if SN < "BRAWLERCDTACMASTOOUTHEAL" then
								if SN < "BRAWLERCDFATETORESIST" then
									if SN < "BRAWLERCDFATETOFINESSE" then
										if SN > "BRAWLERCDBASEWILL" then
											if SN == "BRAWLERCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										elseif SN == "BRAWLERCDBASEWILL" then
											return CalcStat("ClassBaseMainF",L);
										else
											return 0;
										end
									elseif SN > "BRAWLERCDFATETOFINESSE" then
										if SN < "BRAWLERCDFATETOICPR" then
											if SN == "BRAWLERCDFATETOICMR" then
												return 1.5;
											else
												return 0;
											end
										elseif SN > "BRAWLERCDFATETOICPR" then
											if SN == "BRAWLERCDFATETONCPR" then
												return 24;
											else
												return 0;
											end
										else
											return 1.71;
										end
									else
										return 1;
									end
								elseif SN > "BRAWLERCDFATETORESIST" then
									if SN < "BRAWLERCDMIGHTTOFINESSE" then
										if SN < "BRAWLERCDHASPOWER" then
											if SN == "BRAWLERCDFATETOTACMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BRAWLERCDHASPOWER" then
											if SN == "BRAWLERCDMIGHTTOEVADE" then
												return 3;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "BRAWLERCDMIGHTTOFINESSE" then
										if SN < "BRAWLERCDMIGHTTOPHYMAS" then
											if SN == "BRAWLERCDMIGHTTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN > "BRAWLERCDMIGHTTOPHYMAS" then
											if SN == "BRAWLERCDPHYMITTOOFMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 3;
										end
									else
										return 1;
									end
								else
									return 1;
								end
							elseif SN > "BRAWLERCDTACMASTOOUTHEAL" then
								if SN < "BRAWLERCDWILLTOTACMIT" then
									if SN < "BRAWLERCDVITALITYTORESIST" then
										if SN > "BRAWLERCDVITALITYTOMORALE" then
											if SN == "BRAWLERCDVITALITYTONCMR" then
												return 7.2;
											else
												return 0;
											end
										elseif SN == "BRAWLERCDVITALITYTOMORALE" then
											return 5;
										else
											return 0;
										end
									elseif SN > "BRAWLERCDVITALITYTORESIST" then
										if SN < "BRAWLERCDWILLTORESIST" then
											if SN == "BRAWLERCDWILLTOOUTHEAL" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BRAWLERCDWILLTORESIST" then
											if SN == "BRAWLERCDWILLTOTACMAS" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 1;
									end
								elseif SN > "BRAWLERCDWILLTOTACMIT" then
									if SN < "BRGFOOTPADRUNSPEED" then
										if SN < "BRGALLINONEXPFINESSE" then
											if SN == "BRGALLINFINESSE" then
												return CalcStat("Finesse",L,2);
											else
												return 0;
											end
										elseif SN > "BRGALLINONEXPFINESSE" then
											if SN == "BRGDEFTSTRIKESMELCRITP" then
												return CalcStat("Trait12345Choice",N)*0.01;
											else
												return 0;
											end
										else
											return -CalcStat("FinesseT",L,2);
										end
									elseif SN > "BRGFOOTPADRUNSPEED" then
										if SN < "BRGHEARTPRMORALEP" then
											if SN == "BRGFOOTPADSTEALTH" then
												return CalcStat("Trait2345Choice",N);
											else
												return 0;
											end
										elseif SN > "BRGHEARTPRMORALEP" then
											if SN == "BRGLEAFWALKERRUNSPEED" then
												return CalcStat("Trait12345Choice",N)*0.04;
											else
												return 0;
											end
										else
											return CalcStat("Trait12345Choice",N)*0.02;
										end
									else
										return CalcStat("Trait1235Choice",N)*0.02;
									end
								else
									return 2;
								end
							else
								return 1;
							end
						elseif SN > "BRGLEAFWALKERSTEALTH" then
							if SN < "BRWRETINTENSITYCRITHIT" then
								if SN < "BRGTRICKCNTDEFBPE" then
									if SN < "BRGREVWEAKNRESIST" then
										if SN > "BRGREVWEAKNCRITDEF" then
											if SN == "BRGREVWEAKNFINESSE" then
												return -CalcStat("FinesseT",L,0.4);
											else
												return 0;
											end
										elseif SN == "BRGREVWEAKNCRITDEF" then
											return -CalcStat("CritDefT",L,0.4);
										else
											return 0;
										end
									elseif SN > "BRGREVWEAKNRESIST" then
										if SN < "BRGRTDMELDMGP" then
											if SN == "BRGRTDMELCRITP" then
												return CalcStat("Trait000001Choice",N)*0.025;
											else
												return 0;
											end
										elseif SN > "BRGRTDMELDMGP" then
											if SN == "BRGSTICKMOVEEVADEP" then
												return CalcStat("Trait12345Choice",N)*0.01;
											else
												return 0;
											end
										else
											return CalcStat("Trait12345Choice",N)*0.01;
										end
									else
										return -CalcStat("ResistT",L,0.4);
									end
								elseif SN > "BRGTRICKCNTDEFBPE" then
									if SN < "BRWINNSTRCLEVTECHFINESSE" then
										if SN < "BRWAGGPOSTUREPHYMIT" then
											if SN == "BRGTRICKCNTDEFCRITDEF" then
												return -CalcStat("CritDefT",L,0.8);
											else
												return 0;
											end
										elseif SN > "BRWAGGPOSTUREPHYMIT" then
											if SN == "BRWDEFPOSTUREPHYMAS" then
												return -CalcStat("PhyMasT",L,4);
											else
												return 0;
											end
										else
											return -CalcStat("PhyMitT",L,3);
										end
									elseif SN > "BRWINNSTRCLEVTECHFINESSE" then
										if SN < "BRWMAELSTROMMIGHT" then
											if SN == "BRWINNSTRPRECISIONCRITHIT" then
												return CalcStat("CritHitT",L,CalcStat("Trait13510Choice",N)*0.2);
											else
												return 0;
											end
										elseif SN > "BRWMAELSTROMMIGHT" then
											if SN == "BRWMIGHTINCREASE" then
												return CalcStat("MightT",L,CalcStat("Trait567810Choice",N)*0.4);
											else
												return 0;
											end
										else
											return CalcStat("MightT",L,2);
										end
									else
										return CalcStat("FinesseT",L,CalcStat("Trait13510Choice",N)*0.2);
									end
								else
									return -CalcStat("BPET",L,1.2);
								end
							elseif SN > "BRWRETINTENSITYCRITHIT" then
								if SN < "BURGLARCDAGILITYTOEVADE" then
									if SN < "BRWSHATTFISTARMOUR" then
										if SN < "BRWSHAREISBALANCEFINESSE" then
											if SN == "BRWRETPRECISIONFINESSE" then
												return CalcStat("FinesseT",L,CalcStat("Trait123Choice",N)+1);
											else
												return 0;
											end
										elseif SN > "BRWSHAREISBALANCEFINESSE" then
											if SN == "BRWSHAREISHEAVYCRITHIT" then
												return CalcStat("BrwInnStrPrecisionCritHit",L,3);
											else
												return 0;
											end
										else
											return CalcStat("BrwInnStrClevTechFinesse",L,3);
										end
									elseif SN > "BRWSHATTFISTARMOUR" then
										if SN < "BRWVITALITYINCREASE" then
											if SN == "BRWTACMIT" then
												return CalcStat("TacMitT",L,CalcStat("Trait12345Choice",N)*0.4);
											else
												return 0;
											end
										elseif SN > "BRWVITALITYINCREASE" then
											if SN == "BURGLARCDAGILITYTOCRITHIT" then
												return 1;
											else
												return 0;
											end
										else
											return CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4);
										end
									else
										return -CalcStat("ArmourT",L,1.6);
									end
								elseif SN > "BURGLARCDAGILITYTOEVADE" then
									if SN < "BURGLARCDARMOURTOPHYMIT" then
										if SN < "BURGLARCDAGILITYTOPHYMAS" then
											if SN == "BURGLARCDAGILITYTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN > "BURGLARCDAGILITYTOPHYMAS" then
											if SN == "BURGLARCDARMOURTOOFMIT" then
												return 0.2;
											else
												return 0;
											end
										else
											return 3;
										end
									elseif SN > "BURGLARCDARMOURTOPHYMIT" then
										if SN < "BURGLARCDARMOURTYPE" then
											if SN == "BURGLARCDARMOURTOTACMIT" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "BURGLARCDARMOURTYPE" then
											if SN == "BURGLARCDBASEAGILITY" then
												return CalcStat("ClassBaseMainJ",L);
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 1;
									end
								else
									return 3;
								end
							else
								return CalcStat("CritHitT",L,CalcStat("Trait123Choice",N)+1);
							end
						else
							return CalcStat("Trait2345Choice",N);
						end
					else
						return CalcStat("ClassBaseMainJ",L);
					end
				else
					return 2.5;
				end
			elseif SN > "BURGLARCDBASEFATE" then
				if SN < "CHPSTALWBLADEPARRYP" then
					if SN < "CAPTAINCDPHYMITTOOFMIT" then
						if SN < "CAPTAINCDAGILITYTOCRITHIT" then
							if SN < "BURGLARCDFATETORESIST" then
								if SN < "BURGLARCDBASEPOWER" then
									if SN < "BURGLARCDBASEMIGHT" then
										if SN > "BURGLARCDBASEICMR" then
											if SN == "BURGLARCDBASEICPR" then
												return CalcStat("ClassBaseICPR",L);
											else
												return 0;
											end
										elseif SN == "BURGLARCDBASEICMR" then
											return CalcStat("ClassBaseICMRL",L);
										else
											return 0;
										end
									elseif SN > "BURGLARCDBASEMIGHT" then
										if SN < "BURGLARCDBASENCMR" then
											if SN == "BURGLARCDBASEMORALE" then
												if Lm <= 120 then
													return CalcStat("ClassBaseMoraleMa",L);
												else
													return CalcStat("ClassBaseMoraleMa",120);
												end
											else
												return 0;
											end
										elseif SN > "BURGLARCDBASENCMR" then
											if SN == "BURGLARCDBASENCPR" then
												return CalcStat("ClassBaseNCPR",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseNCMRL",L);
										end
									else
										return CalcStat("ClassBaseMainH",L);
									end
								elseif SN > "BURGLARCDBASEPOWER" then
									if SN < "BURGLARCDFATETOFINESSE" then
										if SN < "BURGLARCDBASEWILL" then
											if SN == "BURGLARCDBASEVITALITY" then
												return CalcStat("ClassBaseMainA",L);
											else
												return 0;
											end
										elseif SN > "BURGLARCDBASEWILL" then
											if SN == "BURGLARCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainF",L);
										end
									elseif SN > "BURGLARCDFATETOFINESSE" then
										if SN < "BURGLARCDFATETOICPR" then
											if SN == "BURGLARCDFATETOICMR" then
												return 1.5;
											else
												return 0;
											end
										elseif SN > "BURGLARCDFATETOICPR" then
											if SN == "BURGLARCDFATETONCPR" then
												return 24;
											else
												return 0;
											end
										else
											return 1.71;
										end
									else
										return 1;
									end
								else
									if Lm <= 120 then
										return CalcStat("ClassBasePowerL",L);
									else
										return CalcStat("ClassBasePowerL",120);
									end
								end
							elseif SN > "BURGLARCDFATETORESIST" then
								if SN < "BURGLARCDVITALITYTOMORALE" then
									if SN < "BURGLARCDMIGHTTOBLOCK" then
										if SN > "BURGLARCDFATETOTACMIT" then
											if SN == "BURGLARCDHASPOWER" then
												return 1;
											else
												return 0;
											end
										elseif SN == "BURGLARCDFATETOTACMIT" then
											return 1;
										else
											return 0;
										end
									elseif SN > "BURGLARCDMIGHTTOBLOCK" then
										if SN < "BURGLARCDPHYMITTOOFMIT" then
											if SN == "BURGLARCDMIGHTTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN > "BURGLARCDPHYMITTOOFMIT" then
											if SN == "BURGLARCDTACMASTOOUTHEAL" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 3;
									end
								elseif SN > "BURGLARCDVITALITYTOMORALE" then
									if SN < "BURGLARCDWILLTORESIST" then
										if SN < "BURGLARCDVITALITYTORESIST" then
											if SN == "BURGLARCDVITALITYTONCMR" then
												return 7.2;
											else
												return 0;
											end
										elseif SN > "BURGLARCDVITALITYTORESIST" then
											if SN == "BURGLARCDWILLTOOUTHEAL" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "BURGLARCDWILLTORESIST" then
										if SN < "BURGLARCDWILLTOTACMIT" then
											if SN == "BURGLARCDWILLTOTACMAS" then
												return 1;
											else
												return 0;
											end
										elseif SN > "BURGLARCDWILLTOTACMIT" then
											if SN == "C" then
												return C;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 2;
									end
								else
									return 4.5;
								end
							else
								return 1;
							end
						elseif SN > "CAPTAINCDAGILITYTOCRITHIT" then
							if SN < "CAPTAINCDBASEPOWER" then
								if SN < "CAPTAINCDBASEAGILITY" then
									if SN < "CAPTAINCDARMOURTOOFMIT" then
										if SN > "CAPTAINCDAGILITYTOEVADE" then
											if SN == "CAPTAINCDAGILITYTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN == "CAPTAINCDAGILITYTOEVADE" then
											return 3;
										else
											return 0;
										end
									elseif SN > "CAPTAINCDARMOURTOOFMIT" then
										if SN < "CAPTAINCDARMOURTOTACMIT" then
											if SN == "CAPTAINCDARMOURTOPHYMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CAPTAINCDARMOURTOTACMIT" then
											if SN == "CAPTAINCDARMOURTYPE" then
												return 3;
											else
												return 0;
											end
										else
											return 0.2;
										end
									else
										return 0.2;
									end
								elseif SN > "CAPTAINCDBASEAGILITY" then
									if SN < "CAPTAINCDBASEMIGHT" then
										if SN < "CAPTAINCDBASEICMR" then
											if SN == "CAPTAINCDBASEFATE" then
												return CalcStat("ClassBaseMainJ",L);
											else
												return 0;
											end
										elseif SN > "CAPTAINCDBASEICMR" then
											if SN == "CAPTAINCDBASEICPR" then
												return CalcStat("ClassBaseICPR",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICMRM",L);
										end
									elseif SN > "CAPTAINCDBASEMIGHT" then
										if SN < "CAPTAINCDBASENCMR" then
											if SN == "CAPTAINCDBASEMORALE" then
												if Lm <= 120 then
													return CalcStat("ClassBaseMoraleMb",L);
												else
													return CalcStat("ClassBaseMoraleMb",120);
												end
											else
												return 0;
											end
										elseif SN > "CAPTAINCDBASENCMR" then
											if SN == "CAPTAINCDBASENCPR" then
												return CalcStat("ClassBaseNCPR",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseNCMRM",L);
										end
									else
										return CalcStat("ClassBaseMainH",L);
									end
								else
									return CalcStat("ClassBaseMainA",L);
								end
							elseif SN > "CAPTAINCDBASEPOWER" then
								if SN < "CAPTAINCDFATETONCPR" then
									if SN < "CAPTAINCDFATETOCRITHIT" then
										if SN < "CAPTAINCDBASEWILL" then
											if SN == "CAPTAINCDBASEVITALITY" then
												return CalcStat("ClassBaseMainC",L);
											else
												return 0;
											end
										elseif SN > "CAPTAINCDBASEWILL" then
											if SN == "CAPTAINCDCANBLOCK" then
												if Lm <= 14 then
													return 0;
												else
													return 1;
												end
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainF",L);
										end
									elseif SN > "CAPTAINCDFATETOCRITHIT" then
										if SN < "CAPTAINCDFATETOICMR" then
											if SN == "CAPTAINCDFATETOFINESSE" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CAPTAINCDFATETOICMR" then
											if SN == "CAPTAINCDFATETOICPR" then
												return 1.71;
											else
												return 0;
											end
										else
											return 1.5;
										end
									else
										return 2.5;
									end
								elseif SN > "CAPTAINCDFATETONCPR" then
									if SN < "CAPTAINCDMIGHTTOOUTHEAL" then
										if SN < "CAPTAINCDHASPOWER" then
											if SN == "CAPTAINCDFATETOTACMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CAPTAINCDHASPOWER" then
											if SN == "CAPTAINCDMIGHTTOBLOCK" then
												return 3;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "CAPTAINCDMIGHTTOOUTHEAL" then
										if SN < "CAPTAINCDMIGHTTOPHYMAS" then
											if SN == "CAPTAINCDMIGHTTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN > "CAPTAINCDMIGHTTOPHYMAS" then
											if SN == "CAPTAINCDMIGHTTOTACMAS" then
												return 2.5;
											else
												return 0;
											end
										else
											return 2.5;
										end
									else
										return 2.5;
									end
								else
									return 24;
								end
							else
								if Lm <= 120 then
									return CalcStat("ClassBasePowerL",L);
								else
									return CalcStat("ClassBasePowerL",120);
								end
							end
						else
							return 1;
						end
					elseif SN > "CAPTAINCDPHYMITTOOFMIT" then
						if SN < "CHAMPIONCDFATETOICPR" then
							if SN < "CHAMPIONCDBASEAGILITY" then
								if SN < "CATMINTBEARARMOUR" then
									if SN < "CAPTAINCDVITALITYTONCMR" then
										if SN > "CAPTAINCDTACMASTOOUTHEAL" then
											if SN == "CAPTAINCDVITALITYTOMORALE" then
												return 4.5;
											else
												return 0;
											end
										elseif SN == "CAPTAINCDTACMASTOOUTHEAL" then
											return 1;
										else
											return 0;
										end
									elseif SN > "CAPTAINCDVITALITYTONCMR" then
										if SN < "CAPTAINCDWILLTORESIST" then
											if SN == "CAPTAINCDVITALITYTORESIST" then
												return 2;
											else
												return 0;
											end
										elseif SN > "CAPTAINCDWILLTORESIST" then
											if SN == "CAPTAINCDWILLTOTACMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 7.2;
									end
								elseif SN > "CATMINTBEARARMOUR" then
									if SN < "CHAMPIONCDARMOURTOOFMIT" then
										if SN < "CHAMPIONCDAGILITYTOEVADE" then
											if SN == "CHAMPIONCDAGILITYTOCRITHIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDAGILITYTOEVADE" then
											if SN == "CHAMPIONCDAGILITYTOPARRY" then
												return 2;
											else
												return 0;
											end
										else
											return 3;
										end
									elseif SN > "CHAMPIONCDARMOURTOOFMIT" then
										if SN < "CHAMPIONCDARMOURTOTACMIT" then
											if SN == "CHAMPIONCDARMOURTOPHYMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDARMOURTOTACMIT" then
											if SN == "CHAMPIONCDARMOURTYPE" then
												return 3;
											else
												return 0;
											end
										else
											return 0.2;
										end
									else
										return 0.2;
									end
								else
									return CalcStat("LMCatmintBearArmour",L);
								end
							elseif SN > "CHAMPIONCDBASEAGILITY" then
								if SN < "CHAMPIONCDBASENCPR" then
									if SN < "CHAMPIONCDBASEICPR" then
										if SN > "CHAMPIONCDBASEFATE" then
											if SN == "CHAMPIONCDBASEICMR" then
												return CalcStat("ClassBaseICMRH",L);
											else
												return 0;
											end
										elseif SN == "CHAMPIONCDBASEFATE" then
											return CalcStat("ClassBaseMainG",L);
										else
											return 0;
										end
									elseif SN > "CHAMPIONCDBASEICPR" then
										if SN < "CHAMPIONCDBASEMORALE" then
											if SN == "CHAMPIONCDBASEMIGHT" then
												return CalcStat("ClassBaseMainJ",L);
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDBASEMORALE" then
											if SN == "CHAMPIONCDBASENCMR" then
												return CalcStat("ClassBaseNCMRH",L);
											else
												return 0;
											end
										else
											if Lm <= 120 then
												return CalcStat("ClassBaseMoraleHa",L);
											else
												return CalcStat("ClassBaseMoraleHa",120);
											end
										end
									else
										return CalcStat("ClassBaseICPR",L);
									end
								elseif SN > "CHAMPIONCDBASENCPR" then
									if SN < "CHAMPIONCDCANBLOCK" then
										if SN < "CHAMPIONCDBASEVITALITY" then
											if SN == "CHAMPIONCDBASEPOWER" then
												if Lm <= 120 then
													return CalcStat("ClassBasePowerL",L);
												else
													return CalcStat("ClassBasePowerL",120);
												end
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDBASEVITALITY" then
											if SN == "CHAMPIONCDBASEWILL" then
												return CalcStat("ClassBaseMainB",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainC",L);
										end
									elseif SN > "CHAMPIONCDCANBLOCK" then
										if SN < "CHAMPIONCDFATETOFINESSE" then
											if SN == "CHAMPIONCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDFATETOFINESSE" then
											if SN == "CHAMPIONCDFATETOICMR" then
												return 1.5;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										if Lm <= 9 then
											return 0;
										else
											return 1;
										end
									end
								else
									return CalcStat("ClassBaseNCPR",L);
								end
							else
								return CalcStat("ClassBaseMainH",L);
							end
						elseif SN > "CHAMPIONCDFATETOICPR" then
							if SN < "CHAMPIONCDVITALITYTORESIST" then
								if SN < "CHAMPIONCDMIGHTTOPARRY" then
									if SN < "CHAMPIONCDFATETOTACMIT" then
										if SN > "CHAMPIONCDFATETONCPR" then
											if SN == "CHAMPIONCDFATETORESIST" then
												return 1;
											else
												return 0;
											end
										elseif SN == "CHAMPIONCDFATETONCPR" then
											return 24;
										else
											return 0;
										end
									elseif SN > "CHAMPIONCDFATETOTACMIT" then
										if SN < "CHAMPIONCDMIGHTTOCRITHIT" then
											if SN == "CHAMPIONCDHASPOWER" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDMIGHTTOCRITHIT" then
											if SN == "CHAMPIONCDMIGHTTOEVADE" then
												return 2;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 1;
									end
								elseif SN > "CHAMPIONCDMIGHTTOPARRY" then
									if SN < "CHAMPIONCDTACMASTOOUTHEAL" then
										if SN < "CHAMPIONCDMIGHTTOPHYMIT" then
											if SN == "CHAMPIONCDMIGHTTOPHYMAS" then
												return 3;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDMIGHTTOPHYMIT" then
											if SN == "CHAMPIONCDPHYMITTOOFMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "CHAMPIONCDTACMASTOOUTHEAL" then
										if SN < "CHAMPIONCDVITALITYTOMORALE" then
											if SN == "CHAMPIONCDVITALITYTOBLOCK" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDVITALITYTOMORALE" then
											if SN == "CHAMPIONCDVITALITYTONCMR" then
												return 7.2;
											else
												return 0;
											end
										else
											return 4.5;
										end
									else
										return 1;
									end
								else
									return 2;
								end
							elseif SN > "CHAMPIONCDVITALITYTORESIST" then
								if SN < "CHISELFINESSEL" then
									if SN < "CHAMPIONCDWILLTOTACMIT" then
										if SN < "CHAMPIONCDWILLTORESIST" then
											if SN == "CHAMPIONCDWILLTOOUTHEAL" then
												return 1;
											else
												return 0;
											end
										elseif SN > "CHAMPIONCDWILLTORESIST" then
											if SN == "CHAMPIONCDWILLTOTACMAS" then
												return 1;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "CHAMPIONCDWILLTOTACMIT" then
										if SN < "CHISELCRITHITL" then
											if SN == "CHISELCRITHITH" then
												if Lm <= 105 then
													return RoundDbl(24.24*L);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("ChiselCritHitH",105));
												end
											else
												return 0;
											end
										elseif SN > "CHISELCRITHITL" then
											if SN == "CHISELFINESSEH" then
												if Lm <= 105 then
													return RoundDbl(8.08*L);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("ChiselFinesseH",105));
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(16.16*L);
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("ChiselCritHitL",105));
											end
										end
									else
										return 1;
									end
								elseif SN > "CHISELFINESSEL" then
									if SN < "CHPCONTRBURNICPR" then
										if SN < "CHISELICPRL" then
											if SN == "CHISELICPRH" then
												if Lm <= 8 then
													return 0;
												elseif Lm <= 31 then
													return 60;
												elseif Lm <= 55 then
													return 120;
												elseif Lm <= 79 then
													return 180;
												elseif Lm <= 104 then
													return 240;
												else
													return 300;
												end
											else
												return 0;
											end
										elseif SN > "CHISELICPRL" then
											if SN == "CHP2HWPNBLOCK" then
												return CalcStat("BlockT",L,4);
											else
												return 0;
											end
										else
											if Lm <= 10 then
												return 0;
											elseif Lm <= 40 then
												return 60;
											elseif Lm <= 70 then
												return 120;
											elseif Lm <= 100 then
												return 180;
											else
												return 240;
											end
										end
									elseif SN > "CHPCONTRBURNICPR" then
										if SN < "CHPFLURRYINCRCRITHIT" then
											if SN == "CHPFINESSEINCREASE" then
												return CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4);
											else
												return 0;
											end
										elseif SN > "CHPFLURRYINCRCRITHIT" then
											if SN == "CHPMIGHTINCREASE" then
												return CalcStat("MightT",L,CalcStat("Trait567810Choice",N)*0.4);
											else
												return 0;
											end
										else
											if Lm <= 80 then
												return RoundDbl(16.16*L);
											else
												return CalcStat("ChpFlurryIncrCritHit",80);
											end
										end
									else
										return CalcStat("ICPRT",L,0.4);
									end
								else
									if Lm <= 105 then
										return RoundDbl(4.04*L);
									else
										return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("ChiselFinesseL",105));
									end
								end
							else
								return 1;
							end
						else
							return 1.71;
						end
					else
						return 1;
					end
				elseif SN > "CHPSTALWBLADEPARRYP" then
					if SN < "CPTRELENTLESSCRITHIT" then
						if SN < "CLASSBASENCMRM" then
							if SN < "CLASSBASEMAINE" then
								if SN < "CLASSBASEICMRLBASE" then
									if SN < "CLASSBASEICMRBASE" then
										if SN > "CHPSTALWBLADEVITALITY" then
											if SN == "CHPUNBREAKTACMIT" then
												return CalcStat("TacMitT",L,0.4);
											else
												return 0;
											end
										elseif SN == "CHPSTALWBLADEVITALITY" then
											return CalcStat("VitalityT",L,CalcStat("Trait567810Choice",N)*0.4);
										else
											return 0;
										end
									elseif SN > "CLASSBASEICMRBASE" then
										if SN < "CLASSBASEICMRHBASE" then
											if SN == "CLASSBASEICMRH" then
												return CalcStat("ClassBaseICMRHBase",L)*60;
											else
												return 0;
											end
										elseif SN > "CLASSBASEICMRHBASE" then
											if SN == "CLASSBASEICMRL" then
												return CalcStat("ClassBaseICMRLBase",L)*60;
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return RoundDbl(((L+1.53)/((L+1.53)+20.75))*(9/3),2);
											elseif Lm <= 120 then
												return CalcStat("ClassBaseICMRHBase",50)+(L-50)/80;
											else
												return CalcStat("ClassBaseICMRBase",L);
											end
										end
									else
										return 2.5;
									end
								elseif SN > "CLASSBASEICMRLBASE" then
									if SN < "CLASSBASEMAINA" then
										if SN < "CLASSBASEICMRMBASE" then
											if SN == "CLASSBASEICMRM" then
												return CalcStat("ClassBaseICMRMBase",L)*60;
											else
												return 0;
											end
										elseif SN > "CLASSBASEICMRMBASE" then
											if SN == "CLASSBASEICPR" then
												return 240;
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return RoundDbl(((L+1.39)/((L+1.39)+20.75))*(8/3),2);
											elseif Lm <= 120 then
												return CalcStat("ClassBaseICMRMBase",50)+(L-50)/90;
											else
												return CalcStat("ClassBaseICMRBase",L);
											end
										end
									elseif SN > "CLASSBASEMAINA" then
										if SN < "CLASSBASEMAINC" then
											if SN == "CLASSBASEMAINB" then
												if Lm <= 50 then
													return L+7;
												else
													return 58;
												end
											else
												return 0;
											end
										elseif SN > "CLASSBASEMAINC" then
											if SN == "CLASSBASEMAIND" then
												if Lm <= 50 then
													return L+9;
												else
													return 60;
												end
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return L+9;
											else
												return 59;
											end
										end
									else
										if Lm <= 50 then
											return L+7;
										else
											return 57;
										end
									end
								else
									if Lm <= 50 then
										return RoundDbl(((L+1.56)/((L+1.56)+20.75))*(7/3),2);
									elseif Lm <= 120 then
										return CalcStat("ClassBaseICMRLBase",50)+(L-50)/100;
									else
										return CalcStat("ClassBaseICMRBase",L);
									end
								end
							elseif SN > "CLASSBASEMAINE" then
								if SN < "CLASSBASEMAINL" then
									if SN < "CLASSBASEMAINH" then
										if SN > "CLASSBASEMAINF" then
											if SN == "CLASSBASEMAING" then
												if Lm <= 50 then
													return RoundDbl(1.4*L+9.6);
												else
													return 81;
												end
											else
												return 0;
											end
										elseif SN == "CLASSBASEMAINF" then
											if Lm <= 50 then
												return RoundDbl(1.4*L+9.6);
											else
												return 80;
											end
										else
											return 0;
										end
									elseif SN > "CLASSBASEMAINH" then
										if SN < "CLASSBASEMAINJ" then
											if SN == "CLASSBASEMAINI" then
												if Lm <= 50 then
													return RoundDbl(1.4*L+12.6);
												else
													return 84;
												end
											else
												return 0;
											end
										elseif SN > "CLASSBASEMAINJ" then
											if SN == "CLASSBASEMAINK" then
												if Lm <= 29 then
													return 2*L+12;
												elseif Lm <= 50 then
													return RoundDbl(1.05*L+39.65);
												else
													return 93;
												end
											else
												return 0;
											end
										else
											if Lm <= 29 then
												return 2*L+12;
											elseif Lm <= 50 then
												return RoundDbl(1.05*L+39.65);
											else
												return 92;
											end
										end
									else
										if Lm <= 50 then
											return RoundDbl(1.4*L+12.6);
										else
											return 83;
										end
									end
								elseif SN > "CLASSBASEMAINL" then
									if SN < "CLASSBASEMORALEMA" then
										if SN < "CLASSBASEMORALEHB" then
											if SN == "CLASSBASEMORALEHA" then
												if Lm <= 10 then
													return 39*L+61;
												elseif Lm <= 20 then
													return 39*L+46;
												elseif Lm <= 50 then
													return 27*L+286;
												elseif Lm <= 65 then
													return 27*L+274;
												elseif Lm <= 71 then
													return DataTableValue({2062,2102,2149,2203,2263,2330},L-65);
												else
													return 81*L-3428;
												end
											else
												return 0;
											end
										elseif SN > "CLASSBASEMORALEHB" then
											if SN == "CLASSBASEMORALEL" then
												if Lm <= 20 then
													return 22*L+53;
												elseif Lm <= 65 then
													return 15*L+193;
												elseif Lm <= 71 then
													return DataTableValue({1186,1208,1234,1264,1297,1334},L-65);
												else
													return 45*L-1865;
												end
											else
												return 0;
											end
										else
											if Lm <= 20 then
												return 39*L+61;
											elseif Lm <= 65 then
												return 27*L+301;
											elseif Lm <= 71 then
												return DataTableValue({2089,2129,2176,2230,2290,2357},L-65);
											else
												return 81*L-3401;
											end
										end
									elseif SN > "CLASSBASEMORALEMA" then
										if SN < "CLASSBASENCMRH" then
											if SN == "CLASSBASEMORALEMB" then
												if Lm <= 10 then
													return 34*L+51;
												elseif Lm <= 20 then
													return 34*L+36;
												elseif Lm <= 65 then
													return 22*L+276;
												elseif Lm <= 71 then
													return DataTableValue({1733,1766,1804,1848,1897,1952},L-65);
												else
													return 66*L-2740;
												end
											else
												return 0;
											end
										elseif SN > "CLASSBASENCMRH" then
											if SN == "CLASSBASENCMRL" then
												if Lm <= 4 then
													return 60;
												else
													return 120;
												end
											else
												return 0;
											end
										else
											if Lm <= 3 then
												return 120;
											elseif Lm <= 9 then
												return 180;
											elseif Lm <= 30 then
												return 240;
											else
												return 300;
											end
										end
									else
										if Lm <= 20 then
											return 29*L+46;
										elseif Lm <= 65 then
											return 22*L+186;
										elseif Lm <= 71 then
											return DataTableValue({1643,1676,1714,1758,1807,1862},L-65);
										else
											return 66*L-2830;
										end
									end
								else
									if Lm <= 50 then
										return 2*L+12;
									else
										return 112;
									end
								end
							else
								if Lm <= 50 then
									return L+10;
								else
									return 60;
								end
							end
						elseif SN > "CLASSBASENCMRM" then
							if SN < "COMBATINHEAL" then
								if SN < "COMBATBASEH" then
									if SN < "CLASSBASEPOWERL" then
										if SN > "CLASSBASENCPR" then
											if SN == "CLASSBASEPOWERH" then
												return 65*L;
											else
												return 0;
											end
										elseif SN == "CLASSBASENCPR" then
											if Lm <= 2 then
												return 75;
											elseif Lm <= 7 then
												return 90;
											elseif Lm <= 25 then
												return 105;
											else
												return 120;
											end
										else
											return 0;
										end
									elseif SN > "CLASSBASEPOWERL" then
										if SN < "COMBATBASE" then
											if SN == "CLOTHARMOUR" then
												if Lm <= 50 then
													return L;
												else
													return 50;
												end
											else
												return 0;
											end
										elseif SN > "COMBATBASE" then
											if SN == "COMBATBASECAT" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 1 then
													return CalcStat("CombatBaseH",N);
												else
													return CalcStat("CombatBaseL",N);
												end
											else
												return 0;
											end
										else
											return CalcStat("CombatBaseCat",WpnCodeIndex(C,1),L)*CalcStat("CombatBaseTypeMP",WpnCodeIndex(C,2))*CalcStat("CombatBaseQtyMPCat",WpnCodeIndex(C,1),WpnCodeIndex(C,3));
										end
									else
										return 50*L;
									end
								elseif SN > "COMBATBASEH" then
									if SN < "COMBATBASEQTYMPCAT" then
										if SN < "COMBATBASEL" then
											if SN == "COMBATBASEHQTYMP" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1.02,1.04,1.08,1.12},L);
												end
											else
												return 0;
											end
										elseif SN > "COMBATBASEL" then
											if SN == "COMBATBASELQTYMP" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1,1,1,1},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return L+3;
											elseif Lm <= 56 then
												return RoundDbl(2.2*L-58.6);
											elseif Lm <= 58 then
												return 4*L-160;
											elseif Lm <= 64 then
												return 2*L-43;
											elseif Lm <= 69 then
												return RoundDbl(3.8*L-158.5);
											elseif Lm <= 71 then
												return 3*L-99;
											elseif Lm <= 72 then
												return 120;
											elseif Lm <= 85 then
												return RoundDbl(4.69*L-216.5);
											elseif Lm <= 86 then
												return 183;
											elseif Lm <= 258 then
												return RoundDbl(1.434*L+60.35);
											elseif Lm <= 259 then
												return 433;
											elseif Lm <= 300 then
												return RoundDbl(1.435*L+58.65);
											elseif Lm <= 309 then
												return RoundDbl(6.15*L-1313.5);
											elseif Lm <= 317 then
												return RoundDbl(6.725*L-1491.25);
											elseif Lm <= 324 then
												return RoundDbl(7.39*L-1702.5);
											elseif Lm <= 326 then
												return 7*L-1575;
											elseif Lm <= 335 then
												return RoundDbl(8.19*L-1963.6);
											elseif Lm <= 337 then
												return 9*L-2235;
											elseif Lm <= 346 then
												return RoundDbl(9.3*L-2337.9);
											elseif Lm <= 351 then
												return 880;
											elseif Lm <= 359 then
												return RoundDbl(9.19*L-2346.35);
											elseif Lm <= 368 then
												return RoundDbl(9.99*L-2633.9);
											elseif Lm <= 377 then
												return RoundDbl(10.99*L-3002.81);
											elseif Lm <= 383 then
												return RoundDbl(11.6*L-3233.3);
											elseif Lm <= 388 then
												return RoundDbl(12.49*L-3574.14);
											elseif Lm <= 396 then
												return RoundDbl(13.19*L-3846.4);
											elseif Lm <= 400 then
												return RoundDbl(13.9*L-4127);
											elseif Lm <= 450 then
												return LinFmod(1,1440,2400,401,450,L);
											else
												return RoundDbl(CalcStat("CombatBaseH",L)*0.8);
											end
										end
									elseif SN > "COMBATBASEQTYMPCAT" then
										if SN < "COMBATBASETACHPS" then
											if SN == "COMBATBASETACDPS" then
												if Lm <= 258 then
													return 0.74*CalcStat("CombatBaseH",L);
												elseif Lm <= 449 then
													return 0.74*CalcStat("CombatBaseH",L+1);
												else
													return 0.74*1.1*CalcStat("CombatBaseH",L+1);
												end
											else
												return 0;
											end
										elseif SN > "COMBATBASETACHPS" then
											if SN == "COMBATBASETYPEMP" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1.4,1.4},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 84 then
												return 0.47*1.02*CalcStat("CombatBaseH",L);
											elseif Lm <= 180 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L));
											elseif Lm <= 182 then
												return 0.47*1.02*CalcStat("CombatBaseH",L);
											elseif Lm <= 200 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L));
											elseif Lm <= 202 then
												return 0.47*1.02*CalcStat("CombatBaseH",L);
											elseif Lm <= 258 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L));
											elseif Lm <= 298 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L+1));
											elseif Lm <= 300 then
												return 0.47*1.02*CalcStat("CombatBaseH",L+1);
											elseif Lm <= 348 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L+1));
											elseif Lm <= 350 then
												return 0.47*1.02*CalcStat("CombatBaseH",L+1);
											elseif Lm <= 398 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L+1));
											elseif Lm <= 400 then
												return 0.47*1.02*CalcStat("CombatBaseH",L+1);
											elseif Lm <= 448 then
												return 0.47*RoundDbl(1.02*CalcStat("CombatBaseH",L+1));
											elseif Lm <= 449 then
												return 0.47*1.02*CalcStat("CombatBaseH",L+1);
											elseif Lm <= 499 then
												return RoundDbl(LinFmod(1,1450,2100,450,499,L));
											else
												return 2200;
											end
										end
									else
										if Lm <= 0 then
											return 0;
										elseif Lm <= 1 then
											return CalcStat("CombatBaseHQtyMP",N);
										else
											return CalcStat("CombatBaseLQtyMP",N);
										end
									end
								else
									if Lm <= 50 then
										return LinFmod(1,5.01313176,66,1,50,L);
									elseif Lm <= 68 then
										return LinFmod(1,67,124,51,68,L);
									elseif Lm <= 83 then
										return LinFmod(1,130,215,69,83,L);
									elseif Lm <= 181 then
										return RoundDbl(LinFmod(1,220,400,84,181,L));
									elseif Lm <= 201 then
										return RoundDbl(LinFmod(1,401,436,182,201,L));
									elseif Lm <= 258 then
										return RoundDbl(LinFmod(1,438,537.3,202,258,L));
									elseif Lm <= 259 then
										return 541;
									elseif Lm <= 300 then
										return RoundDbl(LinFmod(1,539,610,260,300,L));
									elseif Lm <= 350 then
										return RoundDbl(LinFmod(1,672,1100,301,350,L));
									elseif Lm <= 400 then
										return RoundDbl(LinFmod(1,1110,1790,351,400,L));
									elseif Lm <= 450 then
										return RoundDbl(LinFmod(1,1800,3000,401,450,L));
									elseif Lm <= 500 then
										return RoundDbl(LinFmod(1,3025,5000,451,500,L));
									else
										return 5100;
									end
								end
							elseif SN > "COMBATINHEAL" then
								if SN < "CPTCOVPHYMIT" then
									if SN < "CPTBLADEPHYMAS" then
										if SN < "CPTARMOURRENDPHYMIT" then
											if SN == "CONSTSTATC" then
												return CalcStat(C,1,L);
											else
												return 0;
											end
										elseif SN > "CPTARMOURRENDPHYMIT" then
											if SN == "CPTBLADECRITDEF" then
												return CalcStat("CritDefT",L,0.8);
											else
												return 0;
											end
										else
											return -CalcStat("PhyMitT",L,1.6);
										end
									elseif SN > "CPTBLADEPHYMAS" then
										if SN < "CPTCOVATTDURP" then
											if SN == "CPTBLADETACMAS" then
												return CalcStat("TacMasT",L,0.8);
											else
												return 0;
											end
										elseif SN > "CPTCOVATTDURP" then
											if SN == "CPTCOVMAIN" then
												return CalcStat("MainT",L,0.4);
											else
												return 0;
											end
										else
											return -0.25;
										end
									else
										return CalcStat("PhyMasT",L,1.2);
									end
								elseif SN > "CPTCOVPHYMIT" then
									if SN < "CPTIDOMEMAIN" then
										if SN < "CPTCRITDEF" then
											if SN == "CPTCOVVITALITY" then
												return CalcStat("VitalityT",L,0.4);
											else
												return 0;
											end
										elseif SN > "CPTCRITDEF" then
											if SN == "CPTDEFENDINGARMOUR" then
												return CalcStat("PhyMitT",L,0.8);
											else
												return 0;
											end
										else
											return CalcStat("CritDef",L,0.6);
										end
									elseif SN > "CPTIDOMEMAIN" then
										if SN < "CPTMOTIVATEDMORALEP" then
											if SN == "CPTIDOMEVITALITY" then
												return CalcStat("VitalityT",L,0.4);
											else
												return 0;
											end
										elseif SN > "CPTMOTIVATEDMORALEP" then
											if SN == "CPTONGUARDPARRY" then
												return CalcStat("ParryT",L,0.8);
											else
												return 0;
											end
										else
											return 0.1;
										end
									else
										return CalcStat("MainT",L,0.4);
									end
								else
									return CalcStat("PhyMitT",L,2.4);
								end
							else
								return CalcStat("InHeal",L,2.0);
							end
						else
							if Lm <= 1 then
								return 60;
							elseif Lm <= 5 then
								return 120;
							elseif Lm <= 15 then
								return 180;
							else
								return 240;
							end
						end
					elseif SN > "CPTRELENTLESSCRITHIT" then
						if SN < "CREEPBATPROMTACDMGP" then
							if SN < "CREEPAUDACITYREDP" then
								if SN < "CPTSONGPHYMAS" then
									if SN < "CPTSHIELDCRITDEF" then
										if SN > "CPTRELENTLESSPHYMAS" then
											if SN == "CPTRELENTLESSTACMAS" then
												return CalcStat("TacMasT",L,0.8);
											else
												return 0;
											end
										elseif SN == "CPTRELENTLESSPHYMAS" then
											return CalcStat("PhyMasT",L,0.8);
										else
											return 0;
										end
									elseif SN > "CPTSHIELDCRITDEF" then
										if SN < "CPTSHIELDTACMAS" then
											if SN == "CPTSHIELDPHYMAS" then
												return CalcStat("PhyMasT",L,0.8);
											else
												return 0;
											end
										elseif SN > "CPTSHIELDTACMAS" then
											if SN == "CPTSONGCRITDEF" then
												return CalcStat("CritDefT",L,0.8);
											else
												return 0;
											end
										else
											return CalcStat("TacMasT",L,0.8);
										end
									else
										return CalcStat("CritDefT",L,1.2);
									end
								elseif SN > "CPTSONGPHYMAS" then
									if SN < "CREEPAUDACITYCOSTBASE" then
										if SN < "CREEPAUDACITYCCDP" then
											if SN == "CPTSONGTACMAS" then
												return CalcStat("TacMasT",L,1.2);
											else
												return 0;
											end
										elseif SN > "CREEPAUDACITYCCDP" then
											if SN == "CREEPAUDACITYCOST" then
												return CalcStat("CreepAudacityCostBase",L)*25;
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											elseif Lm <= 25 then
												return LinFmod(1,0.95,0.5,1,25,L);
											elseif Lm <= 36 then
												return LinFmod(1,0.5,0.4,25,36,L);
											elseif Lm <= 41 then
												return LinFmod(1,0.4,0.35,36,41,L);
											elseif Lm <= 60 then
												return LinFmod(1,0.35,0.25,41,60,L);
											else
												return CalcStat("CreepAudacityCCDP",60);
											end
										end
									elseif SN > "CREEPAUDACITYCOSTBASE" then
										if SN < "CREEPAUDACITYMELDMGP" then
											if SN == "CREEPAUDACITYDMGP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 25 then
													return LinFmod(1,0.1,0.23,1,25,L);
												elseif Lm <= 36 then
													return LinFmod(1,0.23,0.38,25,36,L);
												elseif Lm <= 41 then
													return LinFmod(1,0.38,0.4,36,41,L);
												elseif Lm <= 60 then
													return LinFmod(1,0.4,0.45,41,60,L);
												else
													return CalcStat("CreepAudacityDmgP",60);
												end
											else
												return 0;
											end
										elseif SN > "CREEPAUDACITYMELDMGP" then
											if SN == "CREEPAUDACITYMELREDP" then
												return CalcStat("CreepAudacityRedP",L);
											else
												return 0;
											end
										else
											return CalcStat("CreepAudacityDmgP",L);
										end
									else
										if Lm <= 0 then
											return 0;
										elseif Lm <= 2 then
											return 2*L;
										elseif Lm <= 9 then
											return 2*L-1;
										elseif Lm <= 15 then
											return 3*L;
										elseif Lm <= 25 then
											return 6*L;
										elseif Lm <= 29 then
											return 9*L;
										elseif Lm <= 36 then
											return 300;
										else
											return 0;
										end
									end
								else
									return CalcStat("PhyMasT",L,0.8);
								end
							elseif SN > "CREEPAUDACITYREDP" then
								if SN < "CREEPBATPROMFINESSE" then
									if SN < "CREEPAUDACITYTACDMGP" then
										if SN > "CREEPAUDACITYRNGDMGP" then
											if SN == "CREEPAUDACITYRNGREDP" then
												return CalcStat("CreepAudacityRedP",L);
											else
												return 0;
											end
										elseif SN == "CREEPAUDACITYRNGDMGP" then
											return CalcStat("CreepAudacityDmgP",L);
										else
											return 0;
										end
									elseif SN > "CREEPAUDACITYTACDMGP" then
										if SN < "CREEPBASEPROG" then
											if SN == "CREEPAUDACITYTACREDP" then
												return CalcStat("CreepAudacityRedP",L);
											else
												return 0;
											end
										elseif SN > "CREEPBASEPROG" then
											if SN == "CREEPBATPROMDMGP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 20 then
													return LinFmod(1,0.01,0.2,1,20,L);
												else
													return CalcStat("CreepBatPromDmgP",20);
												end
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(N),LotroDbl(100*N),1,140,L);
										end
									else
										return CalcStat("CreepAudacityDmgP",L);
									end
								elseif SN > "CREEPBATPROMFINESSE" then
									if SN < "CREEPBATPROMMORALEP" then
										if SN < "CREEPBATPROMINHEALP" then
											if SN == "CREEPBATPROMHEALTHP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 20 then
													return LinFmod(1,0.01,0.2,1,20,L);
												else
													return CalcStat("CreepBatPromHealthP",20);
												end
											else
												return 0;
											end
										elseif SN > "CREEPBATPROMINHEALP" then
											if SN == "CREEPBATPROMMELDMGP" then
												return CalcStat("CreepBatPromDmgP",L);
											else
												return 0;
											end
										else
											return 0;
										end
									elseif SN > "CREEPBATPROMMORALEP" then
										if SN < "CREEPBATPROMPOWERP" then
											if SN == "CREEPBATPROMOUTHEALP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 20 then
													return LinFmod(1,0.01,0.2,1,20,L);
												else
													return CalcStat("CreepBatPromOutHealP",20);
												end
											else
												return 0;
											end
										elseif SN > "CREEPBATPROMPOWERP" then
											if SN == "CREEPBATPROMRNGDMGP" then
												return CalcStat("CreepBatPromDmgP",L);
											else
												return 0;
											end
										else
											return CalcStat("CreepBatPromHealthP",L);
										end
									else
										return CalcStat("CreepBatPromHealthP",L);
									end
								else
									return 0;
								end
							else
								if Lm <= 0 then
									return 0;
								elseif Lm <= 25 then
									return LinFmod(1,-0.35,-0.38,1,25,L);
								elseif Lm <= 36 then
									return LinFmod(1,-0.38,-0.4,25,36,L);
								elseif Lm <= 41 then
									return LinFmod(1,-0.4,-0.42,36,41,L);
								elseif Lm <= 60 then
									return LinFmod(1,-0.42,-0.45,41,60,L);
								else
									return CalcStat("CreepAudacityRedP",60);
								end
							end
						elseif SN > "CREEPBATPROMTACDMGP" then
							if SN < "CRFTACMAS" then
								if SN < "CRFBASICVITALITY" then
									if SN < "CRFBASICFATE" then
										if SN > "CRFAGILITY" then
											if SN == "CRFBASICAGILITY" then
												return (L-40)*N;
											else
												return 0;
											end
										elseif SN == "CRFAGILITY" then
											if Lm <= 64 then
												return 0;
											else
												return (L-55)*N;
											end
										else
											return 0;
										end
									elseif SN > "CRFBASICFATE" then
										if SN < "CRFBASICMORALE" then
											if SN == "CRFBASICMIGHT" then
												return (L-40)*N;
											else
												return 0;
											end
										elseif SN > "CRFBASICMORALE" then
											if SN == "CRFBASICPOWER" then
												return (5*L-200)*N;
											else
												return 0;
											end
										else
											return (5*L-200)*N;
										end
									else
										return (L-40)*N;
									end
								elseif SN > "CRFBASICVITALITY" then
									if SN < "CRFFATE" then
										if SN < "CRFCRITDEF" then
											if SN == "CRFBASICWILL" then
												return (L-40)*N;
											else
												return 0;
											end
										elseif SN > "CRFCRITDEF" then
											if SN == "CRFCRITHIT" then
												return (10*L-210)*N;
											else
												return 0;
											end
										else
											return (10*L-210)*N;
										end
									elseif SN > "CRFFATE" then
										if SN < "CRFPHYMAS" then
											if SN == "CRFMIGHT" then
												if Lm <= 64 then
													return 0;
												else
													return (L-55)*N;
												end
											else
												return 0;
											end
										elseif SN > "CRFPHYMAS" then
											if SN == "CRFPHYMIT" then
												return (10*L-210)*N;
											else
												return 0;
											end
										else
											return (10*L-210)*N;
										end
									else
										if Lm <= 64 then
											return 0;
										else
											return (L-55)*N;
										end
									end
								else
									return (L-40)*N;
								end
							elseif SN > "CRFTACMAS" then
								if SN < "CRITDEFPRATP" then
									if SN < "CRITDEF" then
										if SN < "CRFVITALITY" then
											if SN == "CRFTACMIT" then
												return (10*L-210)*N;
											else
												return 0;
											end
										elseif SN > "CRFVITALITY" then
											if SN == "CRFWILL" then
												if Lm <= 64 then
													return 0;
												else
													return (L-55)*N;
												end
											else
												return 0;
											end
										else
											if Lm <= 64 then
												return 0;
											else
												return (L-55)*N;
											end
										end
									elseif SN > "CRITDEF" then
										if SN < "CRITDEFPBONUS" then
											if SN == "CRITDEFADJ" then
												if Lm <= 449 then
													return CalcStat("AdjItemProgRatings",L);
												else
													return 100/90;
												end
											else
												return 0;
											end
										elseif SN > "CRITDEFPBONUS" then
											if SN == "CRITDEFPPRAT" then
												return CalcRatAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCapR",L),N);
											else
												return 0;
											end
										else
											return 0;
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("CritDefAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("CritDefAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
									end
								elseif SN > "CRITDEFPRATP" then
									if SN < "CRITDEFPRATPCAP" then
										if SN < "CRITDEFPRATPB" then
											if SN == "CRITDEFPRATPA" then
												if Lm <= 130 then
													return 160;
												else
													return 240;
												end
											else
												return 0;
											end
										elseif SN > "CRITDEFPRATPB" then
											if SN == "CRITDEFPRATPC" then
												if Lm <= 130 then
													return 1;
												else
													return 0.5;
												end
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
											else
												return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
											end
										end
									elseif SN > "CRITDEFPRATPCAP" then
										if SN < "CRITDEFT" then
											if SN == "CRITDEFPRATPCAPR" then
												return CalcStat("CritDefPRatPB",L)*CalcStat("CritDefPRatPC",L);
											else
												return 0;
											end
										elseif SN > "CRITDEFT" then
											if SN == "CRITDEFTADJ" then
												if Lm <= 1 then
													return 1;
												elseif Lm <= 75 then
													return 0.8;
												elseif Lm <= 121 then
													return 1;
												elseif Lm <= 130 then
													return 0.9;
												else
													return 100/90;
												end
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("CritDefTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("CritDefTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
										end
									else
										return 80;
									end
								else
									return CalcPercAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCap",L),N);
								end
							else
								return (10*L-210)*N;
							end
						else
							return CalcStat("CreepBatPromDmgP",L);
						end
					else
						return CalcStat("CritHitT",L,1.4);
					end
				else
					return CalcStat("Trait12345Choice",N)*0.01;
				end
			else
				return CalcStat("ClassBaseMainC",L);
			end
		elseif SN > "CRITHIT" then
			if SN < "HUNTERCDTACMASTOOUTHEAL" then
				if SN < "FREEPAUDACITYMELREDP" then
					if SN < "ELFFADINGFIRSTBORNFATE" then
						if SN < "DISEASERESISTT" then
							if SN < "CRITMAGNPRATP" then
								if SN < "CRITHITPRATPB" then
									if SN < "CRITHITPBONUS" then
										if SN > "CRITHITADJ" then
											if SN == "CRITHITOLD" then
												return CalcStat("CritHit",L,N);
											else
												return 0;
											end
										elseif SN == "CRITHITADJ" then
											if Lm <= 449 then
												return CalcStat("AdjItemProgRatings",L);
											elseif Lm <= 450 then
												return 83/90;
											else
												return 70/90;
											end
										else
											return 0;
										end
									elseif SN > "CRITHITPBONUS" then
										if SN < "CRITHITPRATP" then
											if SN == "CRITHITPPRAT" then
												return CalcRatAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCapR",L),N);
											else
												return 0;
											end
										elseif SN > "CRITHITPRATP" then
											if SN == "CRITHITPRATPA" then
												if Lm <= 130 then
													return 50;
												else
													return 75;
												end
											else
												return 0;
											end
										else
											return CalcPercAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCap",L),N);
										end
									else
										return 0;
									end
								elseif SN > "CRITHITPRATPB" then
									if SN < "CRITHITT" then
										if SN < "CRITHITPRATPCAP" then
											if SN == "CRITHITPRATPC" then
												if Lm <= 130 then
													return 1;
												else
													return 0.5;
												end
											else
												return 0;
											end
										elseif SN > "CRITHITPRATPCAP" then
											if SN == "CRITHITPRATPCAPR" then
												return CalcStat("CritHitPRatPB",L)*CalcStat("CritHitPRatPC",L);
											else
												return 0;
											end
										else
											return 25;
										end
									elseif SN > "CRITHITT" then
										if SN < "CRITMAGNPBONUS" then
											if SN == "CRITHITTADJ" then
												if Lm <= 130 then
													return 1;
												else
													return 80/90;
												end
											else
												return 0;
											end
										elseif SN > "CRITMAGNPBONUS" then
											if SN == "CRITMAGNPPRAT" then
												return CalcRatAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCapR",L),N);
											else
												return 0;
											end
										else
											return 0;
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPCritHit",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("CritHitTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPCritHit",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("CritHitTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
									end
								else
									if Lm <= 130 then
										return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
									else
										return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
									end
								end
							elseif SN > "CRITMAGNPRATP" then
								if SN < "DEVHITPBONUS" then
									if SN < "CRITMAGNPRATPC" then
										if SN > "CRITMAGNPRATPA" then
											if SN == "CRITMAGNPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProg",L,CalcStat("ProgBHigh",L));
												else
													return CalcStat("BratProg",L,CalcStat("ProgBHighNew",L));
												end
											else
												return 0;
											end
										elseif SN == "CRITMAGNPRATPA" then
											if Lm <= 120 then
												return 200;
											elseif Lm <= 127 then
												return (-5)*L+750;
											elseif Lm <= 130 then
												return 112.5;
											else
												return 225;
											end
										else
											return 0;
										end
									elseif SN > "CRITMAGNPRATPC" then
										if SN < "CRITMAGNPRATPCAPR" then
											if SN == "CRITMAGNPRATPCAP" then
												if Lm <= 120 then
													return 100;
												else
													return 75;
												end
											else
												return 0;
											end
										elseif SN > "CRITMAGNPRATPCAPR" then
											if SN == "CRYRESISTT" then
												return CalcStat("ResistAddT",L,N);
											else
												return 0;
											end
										else
											return CalcStat("CritMagnPRatPB",L)*CalcStat("CritMagnPRatPC",L);
										end
									else
										return CalcStat("CritMagnPRatPCAP",L)/(CalcStat("CritMagnPRatPA",L)-CalcStat("CritMagnPRatPCAP",L));
									end
								elseif SN > "DEVHITPBONUS" then
									if SN < "DEVHITPRATPB" then
										if SN < "DEVHITPRATP" then
											if SN == "DEVHITPPRAT" then
												return CalcRatAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCapR",L),N);
											else
												return 0;
											end
										elseif SN > "DEVHITPRATP" then
											if SN == "DEVHITPRATPA" then
												if Lm <= 130 then
													return 20;
												else
													return 30;
												end
											else
												return 0;
											end
										else
											return CalcPercAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCap",L),N);
										end
									elseif SN > "DEVHITPRATPB" then
										if SN < "DEVHITPRATPCAP" then
											if SN == "DEVHITPRATPC" then
												if Lm <= 130 then
													return 1;
												else
													return 0.5;
												end
											else
												return 0;
											end
										elseif SN > "DEVHITPRATPCAP" then
											if SN == "DEVHITPRATPCAPR" then
												return CalcStat("DevHitPRatPB",L)*CalcStat("DevHitPRatPC",L);
											else
												return 0;
											end
										else
											return 10;
										end
									else
										if Lm <= 130 then
											return CalcStat("BratProg",L,CalcStat("ProgBMedium",L));
										else
											return CalcStat("BratProg",L,CalcStat("ProgBMediumNew",L));
										end
									end
								else
									return 0;
								end
							else
								return CalcPercAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCap",L),N);
							end
						elseif SN > "DISEASERESISTT" then
							if SN < "DWARFRDTRAITICPR" then
								if SN < "DWARFLOSTDWARFKDSFATE" then
									if SN < "DMGTYPEMITT" then
										if SN > "DMGTYPEMIT" then
											if SN == "DMGTYPEMITADJ" then
												if Lm <= 449 then
													return CalcStat("AdjItemProgLow",L);
												else
													return 10/9.0;
												end
											else
												return 0;
											end
										elseif SN == "DMGTYPEMIT" then
											return LinFmod(1,LotroDbl(CalcStat("PntMPDmgTypeMit",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("DmgTypeMitAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("PntMPDmgTypeMit",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("DmgTypeMitAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L);
										else
											return 0;
										end
									elseif SN > "DMGTYPEMITT" then
										if SN < "DWARFENDURVITALITY" then
											if SN == "DMGTYPEMITTADJ" then
												if Lm <= 130 then
													return 1;
												else
													return 10/9.0;
												end
											else
												return 0;
											end
										elseif SN > "DWARFENDURVITALITY" then
											if SN == "DWARFFATEFULDWARFFATE" then
												return CalcStat("FateT",L,1.0);
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(1.2*L);
											else
												return CalcStat("ProgExtMpExpRnd",L,CalcStat("DwarfEndurVitality",105));
											end
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPDmgTypeMit",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("DmgTypeMitTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPDmgTypeMit",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("DmgTypeMitTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
									end
								elseif SN > "DWARFLOSTDWARFKDSFATE" then
									if SN < "DWARFRDPSVTWONAME" then
										if SN < "DWARFRDPSVONENAME" then
											if SN == "DWARFRDPSVONEFATE" then
												return CalcStat("DwarfFatefulDwarfFate",L);
											else
												return 0;
											end
										elseif SN > "DWARFRDPSVONENAME" then
											if SN == "DWARFRDPSVTWOBLOCK" then
												return CalcStat("DwarfShieldBrwlBlock",L);
											else
												return 0;
											end
										else
											return "Fateful Dwarf";
										end
									elseif SN > "DWARFRDPSVTWONAME" then
										if SN < "DWARFRDTRAITFATE" then
											if SN == "DWARFRDTRAITAGILITY" then
												return CalcStat("DwarfStockyAgility",L);
											else
												return 0;
											end
										elseif SN > "DWARFRDTRAITFATE" then
											if SN == "DWARFRDTRAITICMR" then
												return CalcStat("DwarfUnwearBattleICMR",L);
											else
												return 0;
											end
										else
											return CalcStat("DwarfLostDwarfKdsFate",L);
										end
									else
										return "Shield Brawler";
									end
								else
									return -7;
								end
							elseif SN > "DWARFRDTRAITICPR" then
								if SN < "DWARFSTURDINESSMIGHT" then
									if SN < "DWARFRDTRAITPHYMITP" then
										if SN < "DWARFRDTRAITNCMR" then
											if SN == "DWARFRDTRAITMIGHT" then
												return CalcStat("DwarfSturdinessMight",L);
											else
												return 0;
											end
										elseif SN > "DWARFRDTRAITNCMR" then
											if SN == "DWARFRDTRAITNCPR" then
												return CalcStat("DwarfUnwearBattleNCPR",L);
											else
												return 0;
											end
										else
											return CalcStat("DwarfUnwearBattleNCMR",L);
										end
									elseif SN > "DWARFRDTRAITPHYMITP" then
										if SN < "DWARFSHIELDBRWLBLOCK" then
											if SN == "DWARFRDTRAITVITALITY" then
												return CalcStat("DwarfSturdinessVitality",L);
											else
												return 0;
											end
										elseif SN > "DWARFSHIELDBRWLBLOCK" then
											if SN == "DWARFSTOCKYAGILITY" then
												return -7;
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(20.2*L);
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("DwarfShieldBrwlBlock",105));
											end
										end
									else
										return CalcStat("DwarfSturdinessPhyMitP",L);
									end
								elseif SN > "DWARFSTURDINESSMIGHT" then
									if SN < "DWARFUNWEARBATTLEICPR" then
										if SN < "DWARFSTURDINESSVITALITY" then
											if SN == "DWARFSTURDINESSPHYMITP" then
												return 1;
											else
												return 0;
											end
										elseif SN > "DWARFSTURDINESSVITALITY" then
											if SN == "DWARFUNWEARBATTLEICMR" then
												return 30;
											else
												return 0;
											end
										else
											return 10;
										end
									elseif SN > "DWARFUNWEARBATTLEICPR" then
										if SN < "DWARFUNWEARBATTLENCPR" then
											if SN == "DWARFUNWEARBATTLENCMR" then
												return -60;
											else
												return 0;
											end
										elseif SN > "DWARFUNWEARBATTLENCPR" then
											if SN == "ELFAGILITYWOODSAGILITY" then
												return 15;
											else
												return 0;
											end
										else
											return -30;
										end
									else
										return 30;
									end
								else
									return 15;
								end
							else
								return CalcStat("DwarfUnwearBattleICPR",L);
							end
						else
							return CalcStat("ResistAddT",L,N);
						end
					elseif SN > "ELFFADINGFIRSTBORNFATE" then
						if SN < "FINESSEPRATPB" then
							if SN < "EVADEPRATPA" then
								if SN < "ELFRDTRAITMORALE" then
									if SN < "ELFRDPSVONENAME" then
										if SN > "ELFFRIENDOFMANFATE" then
											if SN == "ELFRDPSVONEFATE" then
												return CalcStat("ElfFriendOfManFate",L);
											else
												return 0;
											end
										elseif SN == "ELFFRIENDOFMANFATE" then
											return CalcStat("FateT",L,1.0);
										else
											return 0;
										end
									elseif SN > "ELFRDPSVONENAME" then
										if SN < "ELFRDTRAITAGILITY" then
											if SN == "ELFRDPSVTWONAME" then
												return "";
											else
												return 0;
											end
										elseif SN > "ELFRDTRAITAGILITY" then
											if SN == "ELFRDTRAITFATE" then
												return CalcStat("ElfFadingFirstbornFate",L);
											else
												return 0;
											end
										else
											return CalcStat("ElfAgilityWoodsAgility",L);
										end
									else
										return "Friend Of Man";
									end
								elseif SN > "ELFRDTRAITMORALE" then
									if SN < "EVADE" then
										if SN < "ELFSORROWFIRSTBORNMORALE" then
											if SN == "ELFRDTRAITNCMR" then
												return CalcStat("ElfSorrowFirstbornNCMR",L);
											else
												return 0;
											end
										elseif SN > "ELFSORROWFIRSTBORNMORALE" then
											if SN == "ELFSORROWFIRSTBORNNCMR" then
												return -60;
											else
												return 0;
											end
										else
											return -20;
										end
									elseif SN > "EVADE" then
										if SN < "EVADEPPRAT" then
											if SN == "EVADEPBONUS" then
												return CalcStat("BPEPBonus",L);
											else
												return 0;
											end
										elseif SN > "EVADEPPRAT" then
											if SN == "EVADEPRATP" then
												return CalcStat("BPEPRatP",L,N);
											else
												return 0;
											end
										else
											return CalcStat("BPEPPRat",L,N);
										end
									else
										return CalcStat("BPE",L,N);
									end
								else
									return CalcStat("ElfSorrowFirstbornMorale",L);
								end
							elseif SN > "EVADEPRATPA" then
								if SN < "FATET" then
									if SN < "EVADEPRATPCAP" then
										if SN > "EVADEPRATPB" then
											if SN == "EVADEPRATPC" then
												return CalcStat("BPEPRatPC",L);
											else
												return 0;
											end
										elseif SN == "EVADEPRATPB" then
											return CalcStat("BPEPRatPB",L);
										else
											return 0;
										end
									elseif SN > "EVADEPRATPCAP" then
										if SN < "EVADET" then
											if SN == "EVADEPRATPCAPR" then
												return CalcStat("BPEPRatPCapR",L);
											else
												return 0;
											end
										elseif SN > "EVADET" then
											if SN == "FATE" then
												return CalcStat("Main",L,N);
											else
												return 0;
											end
										else
											return CalcStat("BPET",L,N);
										end
									else
										return CalcStat("BPEPRatPCap",L);
									end
								elseif SN > "FATET" then
									if SN < "FINESSEPBONUS" then
										if SN < "FINESSE" then
											if SN == "FEARRESISTT" then
												return CalcStat("ResistAddT",L,N);
											else
												return 0;
											end
										elseif SN > "FINESSE" then
											if SN == "FINESSEADJ" then
												if Lm <= 449 then
													return CalcStat("AdjItemProgRatings",L);
												elseif Lm <= 450 then
													return 83/90;
												elseif Lm <= 499 then
													return 100/90;
												else
													return 1;
												end
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("FinesseAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("FinesseAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
										end
									elseif SN > "FINESSEPBONUS" then
										if SN < "FINESSEPRATP" then
											if SN == "FINESSEPPRAT" then
												return CalcRatAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCapR",L),N);
											else
												return 0;
											end
										elseif SN > "FINESSEPRATP" then
											if SN == "FINESSEPRATPA" then
												if Lm <= 130 then
													return 100;
												else
													return 150;
												end
											else
												return 0;
											end
										else
											return CalcPercAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCap",L),N);
										end
									else
										return 0;
									end
								else
									return CalcStat("MainT",L,N);
								end
							else
								return CalcStat("BPEPRatPA",L);
							end
						elseif SN > "FINESSEPRATPB" then
							if SN < "FOODICRPROG" then
								if SN < "FIREMITT" then
									if SN < "FINESSEPRATPCAPR" then
										if SN > "FINESSEPRATPC" then
											if SN == "FINESSEPRATPCAP" then
												return 50;
											else
												return 0;
											end
										elseif SN == "FINESSEPRATPC" then
											if Lm <= 130 then
												return 1;
											else
												return 0.5;
											end
										else
											return 0;
										end
									elseif SN > "FINESSEPRATPCAPR" then
										if SN < "FINESSETADJ" then
											if SN == "FINESSET" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("FinesseTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("FinesseTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
											else
												return 0;
											end
										elseif SN > "FINESSETADJ" then
											if SN == "FIREMIT" then
												return CalcStat("DmgTypeMit",L,N);
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return CalcStat("AdjTraitProgRatings",L);
											elseif Lm <= 131 then
												return 80/90;
											else
												return 1;
											end
										end
									else
										return CalcStat("FinessePRatPB",L)*CalcStat("FinessePRatPC",L);
									end
								elseif SN > "FIREMITT" then
									if SN < "FOODICPRH" then
										if SN < "FOODICMRL" then
											if SN == "FOODICMRH" then
												return CalcStat("FoodICRProg",L,1)*0.6*N;
											else
												return 0;
											end
										elseif SN > "FOODICMRL" then
											if SN == "FOODICMRM" then
												return CalcStat("FoodICRProg",L,3)*0.6*N;
											else
												return 0;
											end
										else
											return CalcStat("FoodICRProg",L,2)*0.6*N;
										end
									elseif SN > "FOODICPRH" then
										if SN < "FOODICPRM" then
											if SN == "FOODICPRL" then
												return CalcStat("FoodICRProg",L,5)*0.6*N;
											else
												return 0;
											end
										elseif SN > "FOODICPRM" then
											if SN == "FOODICRBASEPROG" then
												if Lm <= 1 then
													return (N*700+1100)/60;
												elseif Lm <= 2 then
													return (N*699.6+1101)/120;
												elseif Lm <= 3 then
													return (N*700+1100)/90;
												elseif Lm <= 4 then
													return (N*500+2000)/60;
												elseif Lm <= 5 then
													return (N*500.1+1997)/120;
												else
													return (N*500+2000)/90;
												end
											else
												return 0;
											end
										else
											return CalcStat("FoodICRProg",L,6)*0.6*N;
										end
									else
										return CalcStat("FoodICRProg",L,4)*0.6*N;
									end
								else
									return CalcStat("DmgTypeMitT",L,N);
								end
							elseif SN > "FOODICRPROG" then
								if SN < "FOODNCPRL" then
									if SN < "FOODNCMRM" then
										if SN < "FOODNCMRH" then
											if SN == "FOODNCMRBASEPROG" then
												if Lm <= 1 then
													return (N*70.2+210)/60;
												elseif Lm <= 2 then
													return (N*84+216)/120;
												else
													return (N*83.7+270)/90;
												end
											else
												return 0;
											end
										elseif SN > "FOODNCMRH" then
											if SN == "FOODNCMRL" then
												return CalcStat("FoodNCMRProg",L,2)*60*N;
											else
												return 0;
											end
										else
											return CalcStat("FoodNCMRProg",L,1)*60*N;
										end
									elseif SN > "FOODNCMRM" then
										if SN < "FOODNCPRBASEPROG" then
											if SN == "FOODNCMRPROG" then
												if Lm <= 50 then
													return CalcStat("FoodNCMRBaseProg",N,L);
												elseif Lm <= 52 then
													return CalcStat("FoodNCMRBaseProg",N,50);
												elseif Lm <= 77 then
													return CalcStat("FoodNCMRBaseProg",N,L-3);
												elseif Lm <= 111 then
													return CalcStat("FoodNCMRBaseProg",N,RoundDbl((L+143)/3));
												elseif Lm <= 140 then
													return CalcStat("FoodNCMRBaseProg",N,85);
												elseif Lm <= 217 then
													return CalcStat("FoodNCMRBaseProg",N,RoundDbl((L+200)/4));
												elseif Lm <= 221 then
													return CalcStat("FoodNCMRBaseProg",N,104);
												elseif Lm <= 299 then
													return CalcStat("FoodNCMRBaseProg",N,105);
												elseif Lm <= 320 then
													return CalcStat("FoodNCMRBaseProg",N,RoundDbl((L-53)/(7/3)));
												elseif Lm <= 325 then
													return CalcStat("FoodNCMRBaseProg",N,114);
												elseif Lm <= 326 then
													return CalcStat("FoodNCMRBaseProg",N,115);
												else
													return ExpFmod(CalcStat("FoodNCMRProg",326,N),327,1,L,1);
												end
											else
												return 0;
											end
										elseif SN > "FOODNCPRBASEPROG" then
											if SN == "FOODNCPRH" then
												return CalcStat("FoodNCPRProg",L,1)*60*N;
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return (N*75+300)/60;
											elseif Lm <= 2 then
												return (N*100+350)/120;
											else
												return (N*90+337.5)/90;
											end
										end
									else
										return CalcStat("FoodNCMRProg",L,3)*60*N;
									end
								elseif SN > "FOODNCPRL" then
									if SN < "FOODRESISTADJ" then
										if SN < "FOODNCPRPROG" then
											if SN == "FOODNCPRM" then
												return CalcStat("FoodNCPRProg",L,3)*60*N;
											else
												return 0;
											end
										elseif SN > "FOODNCPRPROG" then
											if SN == "FOODRESIST" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("FoodResistAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("FoodResistAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return CalcStat("FoodNCPRBaseProg",N,L);
											elseif Lm <= 6 then
												return CalcStat("FoodNCPRBaseProg",N,L)-0.25;
											elseif Lm <= 24 then
												return CalcStat("FoodNCPRBaseProg",N,L)-0.5;
											elseif Lm <= 48 then
												return CalcStat("FoodNCPRBaseProg",N,L)-0.75;
											elseif Lm <= 61 then
												return FloorDbl(CalcStat("FoodNCPRProg",48,N))+1;
											elseif Lm <= 66 then
												return FloorDbl(CalcStat("FoodNCPRProg",48,N))+2;
											elseif Lm <= 72 then
												return FloorDbl(CalcStat("FoodNCPRProg",48,N))+3;
											elseif Lm <= 326 then
												return FloorDbl(CalcStat("FoodNCPRProg",48,N))+4;
											else
												return ExpFmod(CalcStat("FoodNCPRProg",326,N),327,1,L,1);
											end
										end
									elseif SN > "FOODRESISTADJ" then
										if SN < "FREEPAUDACITYDMGP" then
											if SN == "FREEPAUDACITYCCDP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 25 then
													return LinFmod(1,0.95,0.5,1,25,L);
												elseif Lm <= 36 then
													return LinFmod(1,0.5,0.4,25,36,L);
												elseif Lm <= 41 then
													return LinFmod(1,0.4,0.35,36,41,L);
												elseif Lm <= 60 then
													return LinFmod(1,0.35,0.25,41,60,L);
												else
													return CalcStat("FreepAudacityCCDP",60);
												end
											else
												return 0;
											end
										elseif SN > "FREEPAUDACITYDMGP" then
											if SN == "FREEPAUDACITYMELDMGP" then
												return CalcStat("FreepAudacityDmgP",L);
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											elseif Lm <= 25 then
												return LinFmod(1,0,0.02,1,25,L);
											elseif Lm <= 36 then
												return LinFmod(1,0.02,0.45,25,36,L);
											elseif Lm <= 41 then
												return LinFmod(1,0.45,0.5,36,41,L);
											elseif Lm <= 60 then
												return LinFmod(1,0.5,0.45,41,60,L);
											else
												return CalcStat("FreepAudacityDmgP",60);
											end
										end
									else
										if Lm <= 399 then
											return 1;
										elseif Lm <= 449 then
											return 0.9;
										elseif Lm <= 450 then
											return 1;
										else
											return 100/90;
										end
									end
								else
									return CalcStat("FoodNCPRProg",L,2)*60*N;
								end
							else
								if Lm <= 105 then
									return RoundDbl(CalcStat("FoodICRBaseProg",N,L));
								else
									return RoundDbl(CalcStat("ProgExtMpExpRaw",L,CalcStat("FoodICRProg",105,N)));
								end
							end
						else
							if Lm <= 130 then
								return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
							else
								return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
							end
						end
					else
						return -7;
					end
				elseif SN > "FREEPAUDACITYMELREDP" then
					if SN < "HELFSORROWUNDYINGWILL" then
						if SN < "GUARDIANCDBASEMIGHT" then
							if SN < "GRDCRITDEF" then
								if SN < "FREEPBATPROMHEALTHP" then
									if SN < "FREEPAUDACITYRNGREDP" then
										if SN > "FREEPAUDACITYREDP" then
											if SN == "FREEPAUDACITYRNGDMGP" then
												return CalcStat("FreepAudacityDmgP",L);
											else
												return 0;
											end
										elseif SN == "FREEPAUDACITYREDP" then
											if Lm <= 0 then
												return 0;
											elseif Lm <= 25 then
												return LinFmod(1,0,-0.05,1,25,L);
											elseif Lm <= 36 then
												return LinFmod(1,-0.05,-0.3,25,36,L);
											elseif Lm <= 41 then
												return LinFmod(1,-0.3,-0.32,36,41,L);
											elseif Lm <= 60 then
												return LinFmod(1,-0.32,-0.35,41,60,L);
											else
												return CalcStat("FreepAudacityRedP",60);
											end
										else
											return 0;
										end
									elseif SN > "FREEPAUDACITYRNGREDP" then
										if SN < "FREEPAUDACITYTACREDP" then
											if SN == "FREEPAUDACITYTACDMGP" then
												return CalcStat("FreepAudacityDmgP",L);
											else
												return 0;
											end
										elseif SN > "FREEPAUDACITYTACREDP" then
											if SN == "FREEPBATPROMDMGP" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 8 then
													return RoundDbl(LinFmod(1,0.005,0.07,1,8,L),2);
												elseif Lm <= 15 then
													return RoundDbl(LinFmod(1,0.07,0.145,8,15,L),2);
												else
													return CalcStat("FreepBatPromDmgP",15);
												end
											else
												return 0;
											end
										else
											return CalcStat("FreepAudacityRedP",L);
										end
									else
										return CalcStat("FreepAudacityRedP",L);
									end
								elseif SN > "FREEPBATPROMHEALTHP" then
									if SN < "FREEPBATPROMRNGDMGP" then
										if SN < "FREEPBATPROMMORALEP" then
											if SN == "FREEPBATPROMMELDMGP" then
												return CalcStat("FreepBatPromDmgP",L);
											else
												return 0;
											end
										elseif SN > "FREEPBATPROMMORALEP" then
											if SN == "FREEPBATPROMPOWERP" then
												return CalcStat("FreepBatPromHealthP",L);
											else
												return 0;
											end
										else
											return CalcStat("FreepBatPromHealthP",L);
										end
									elseif SN > "FREEPBATPROMRNGDMGP" then
										if SN < "FROSTMIT" then
											if SN == "FREEPBATPROMTACDMGP" then
												return CalcStat("FreepBatPromDmgP",L);
											else
												return 0;
											end
										elseif SN > "FROSTMIT" then
											if SN == "FROSTMITT" then
												return CalcStat("DmgTypeMitT",L,N);
											else
												return 0;
											end
										else
											return CalcStat("DmgTypeMit",L,N);
										end
									else
										return CalcStat("FreepBatPromDmgP",L);
									end
								else
									if Lm <= 0 then
										return 0;
									elseif Lm <= 8 then
										return RoundDbl(LinFmod(1,0.005,0.09,1,8,L),2);
									elseif Lm <= 15 then
										return RoundDbl(LinFmod(1,0.09,0.2,8,15,L),2);
									else
										return CalcStat("FreepBatPromHealthP",15);
									end
								end
							elseif SN > "GRDCRITDEF" then
								if SN < "GUARDIANCDARMOURTOOFMIT" then
									if SN < "GRDWARDTACTTACMIT" then
										if SN > "GRDTENDERIZECRITHIT" then
											if SN == "GRDWARDTACTBASE" then
												return (3.6*L+0.2)*N;
											else
												return 0;
											end
										elseif SN == "GRDTENDERIZECRITHIT" then
											return CalcStat("CritHitT",L,CalcStat("Trait12345Choice",N)*0.2);
										else
											return 0;
										end
									elseif SN > "GRDWARDTACTTACMIT" then
										if SN < "GUARDIANCDAGILITYTOEVADE" then
											if SN == "GUARDIANCDAGILITYTOCRITHIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDAGILITYTOEVADE" then
											if SN == "GUARDIANCDAGILITYTOPARRY" then
												return 2;
											else
												return 0;
											end
										else
											return 3;
										end
									else
										if Lm <= 105 then
											return RoundDbl(CalcStat("GrdWardTactBase",L,CalcStat("Trait56789Choice",N)));
										else
											return CalcStat("ProgExtHighLinExpRaw",L,CalcStat("GrdWardTactTacMit",105,N));
										end
									end
								elseif SN > "GUARDIANCDARMOURTOOFMIT" then
									if SN < "GUARDIANCDBASEAGILITY" then
										if SN < "GUARDIANCDARMOURTOTACMIT" then
											if SN == "GUARDIANCDARMOURTOPHYMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDARMOURTOTACMIT" then
											if SN == "GUARDIANCDARMOURTYPE" then
												return 3;
											else
												return 0;
											end
										else
											return 0.2;
										end
									elseif SN > "GUARDIANCDBASEAGILITY" then
										if SN < "GUARDIANCDBASEICMR" then
											if SN == "GUARDIANCDBASEFATE" then
												return CalcStat("ClassBaseMainA",L);
											else
												return 0;
											end
										elseif SN > "GUARDIANCDBASEICMR" then
											if SN == "GUARDIANCDBASEICPR" then
												return CalcStat("ClassBaseICPR",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICMRH",L);
										end
									else
										return CalcStat("ClassBaseMainC",L);
									end
								else
									return 0.2;
								end
							else
								return CalcStat("CritDef",L);
							end
						elseif SN > "GUARDIANCDBASEMIGHT" then
							if SN < "GUARDIANCDHASPOWER" then
								if SN < "GUARDIANCDCANBLOCK" then
									if SN < "GUARDIANCDBASENCPR" then
										if SN > "GUARDIANCDBASEMORALE" then
											if SN == "GUARDIANCDBASENCMR" then
												return CalcStat("ClassBaseNCMRH",L);
											else
												return 0;
											end
										elseif SN == "GUARDIANCDBASEMORALE" then
											if Lm <= 120 then
												return CalcStat("ClassBaseMoraleHb",L);
											else
												return CalcStat("ClassBaseMoraleHb",120);
											end
										else
											return 0;
										end
									elseif SN > "GUARDIANCDBASENCPR" then
										if SN < "GUARDIANCDBASEVITALITY" then
											if SN == "GUARDIANCDBASEPOWER" then
												if Lm <= 120 then
													return CalcStat("ClassBasePowerL",L);
												else
													return CalcStat("ClassBasePowerL",120);
												end
											else
												return 0;
											end
										elseif SN > "GUARDIANCDBASEVITALITY" then
											if SN == "GUARDIANCDBASEWILL" then
												return CalcStat("ClassBaseMainF",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainJ",L);
										end
									else
										return CalcStat("ClassBaseNCPR",L);
									end
								elseif SN > "GUARDIANCDCANBLOCK" then
									if SN < "GUARDIANCDFATETOICPR" then
										if SN < "GUARDIANCDFATETOFINESSE" then
											if SN == "GUARDIANCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDFATETOFINESSE" then
											if SN == "GUARDIANCDFATETOICMR" then
												return 1.5;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "GUARDIANCDFATETOICPR" then
										if SN < "GUARDIANCDFATETORESIST" then
											if SN == "GUARDIANCDFATETONCPR" then
												return 24;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDFATETORESIST" then
											if SN == "GUARDIANCDFATETOTACMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 1.71;
									end
								else
									return 1;
								end
							elseif SN > "GUARDIANCDHASPOWER" then
								if SN < "GUARDIANCDVITALITYTORESIST" then
									if SN < "GUARDIANCDPHYMITTOOFMIT" then
										if SN < "GUARDIANCDMIGHTTOPARRY" then
											if SN == "GUARDIANCDMIGHTTOBLOCK" then
												return 3;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDMIGHTTOPARRY" then
											if SN == "GUARDIANCDMIGHTTOPHYMAS" then
												return 3;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "GUARDIANCDPHYMITTOOFMIT" then
										if SN < "GUARDIANCDVITALITYTOMORALE" then
											if SN == "GUARDIANCDTACMASTOOUTHEAL" then
												return 1;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDVITALITYTOMORALE" then
											if SN == "GUARDIANCDVITALITYTONCMR" then
												return 7.2;
											else
												return 0;
											end
										else
											return 4.8;
										end
									else
										return 1;
									end
								elseif SN > "GUARDIANCDVITALITYTORESIST" then
									if SN < "GUARDIANCDWILLTOTACMIT" then
										if SN < "GUARDIANCDWILLTORESIST" then
											if SN == "GUARDIANCDWILLTOOUTHEAL" then
												return 1;
											else
												return 0;
											end
										elseif SN > "GUARDIANCDWILLTORESIST" then
											if SN == "GUARDIANCDWILLTOTACMAS" then
												return 1;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "GUARDIANCDWILLTOTACMIT" then
										if SN < "HELFPEACEELDARMORALE" then
											if SN == "HELFFADINGFIRSTBORNFATE" then
												return -7;
											else
												return 0;
											end
										elseif SN > "HELFPEACEELDARMORALE" then
											if SN == "HELFPEACEELDARNCMR" then
												return 60;
											else
												return 0;
											end
										else
											return 20;
										end
									else
										return 1;
									end
								else
									return 1;
								end
							else
								return 1;
							end
						else
							return CalcStat("ClassBaseMainH",L);
						end
					elseif SN > "HELFSORROWUNDYINGWILL" then
						if SN < "HOPEMORALEP" then
							if SN < "HNTFOEFINDEREVADE" then
								if SN < "HIGHELFRDTRAITNCMR" then
									if SN < "HIGHELFRDPSVONEWILL" then
										if SN > "HELFTHOSEWHOREMAINWILL" then
											if SN == "HIGHELFRDPSVONENAME" then
												return "Those Who Remain";
											else
												return 0;
											end
										elseif SN == "HELFTHOSEWHOREMAINWILL" then
											return CalcStat("WillT",L,1.0);
										else
											return 0;
										end
									elseif SN > "HIGHELFRDPSVONEWILL" then
										if SN < "HIGHELFRDTRAITFATE" then
											if SN == "HIGHELFRDPSVTWONAME" then
												return "";
											else
												return 0;
											end
										elseif SN > "HIGHELFRDTRAITFATE" then
											if SN == "HIGHELFRDTRAITMORALE" then
												return CalcStat("HElfPeaceEldarMorale",L);
											else
												return 0;
											end
										else
											return CalcStat("HElfFadingFirstbornFate",L);
										end
									else
										return CalcStat("HElfThoseWhoRemainWill",L);
									end
								elseif SN > "HIGHELFRDTRAITNCMR" then
									if SN < "HNTARMOURRENDPARRY" then
										if SN < "HNTARMOURRENDBLOCK" then
											if SN == "HIGHELFRDTRAITWILL" then
												return CalcStat("HElfSorrowUndyingWill",L);
											else
												return 0;
											end
										elseif SN > "HNTARMOURRENDBLOCK" then
											if SN == "HNTARMOURRENDEVADE" then
												return -CalcStat("EvadeT",L,CalcStat("Trait23456Choice",N)*0.4);
											else
												return 0;
											end
										else
											return -CalcStat("Block",L,CalcStat("Trait23456Choice",N)*0.66);
										end
									elseif SN > "HNTARMOURRENDPARRY" then
										if SN < "HNTCRITEYERNGCRITP" then
											if SN == "HNTBREACHFINDERRNGMIT" then
												return (-20)*L;
											else
												return 0;
											end
										elseif SN > "HNTCRITEYERNGCRITP" then
											if SN == "HNTELUSIVEEVADEP" then
												return CalcStat("Trait12345Choice",N)*0.01;
											else
												return 0;
											end
										else
											return CalcStat("Trait12345Choice",N)*0.01;
										end
									else
										return -CalcStat("ParryT",L,CalcStat("Trait23456Choice",N)*0.4);
									end
								else
									return CalcStat("HElfPeaceEldarNCMR",L);
								end
							elseif SN > "HNTFOEFINDEREVADE" then
								if SN < "HOBBITRDPSVTWONAME" then
									if SN < "HNTSURVGEARPHYMITP" then
										if SN > "HNTIMPARRRNGDMGP" then
											if SN == "HNTSHIELDBANEBLOCK" then
												if Lm <= 50 then
													return (-4)*L+12;
												elseif Lm <= 53 then
													return -212;
												else
													return (-4)*L;
												end
											else
												return 0;
											end
										elseif SN == "HNTIMPARRRNGDMGP" then
											return CalcStat("Trait12345Choice",N)*0.01;
										else
											return 0;
										end
									elseif SN > "HNTSURVGEARPHYMITP" then
										if SN < "HOBBITRDPSVONEMIGHT" then
											if SN == "HNTSURVGEARTACMITP" then
												return CalcStat("Trait123458Choice",N)*0.01;
											else
												return 0;
											end
										elseif SN > "HOBBITRDPSVONEMIGHT" then
											if SN == "HOBBITRDPSVONENAME" then
												return "Hobbit-stature";
											else
												return 0;
											end
										else
											return CalcStat("HobHobbitStatureMight",L);
										end
									else
										return CalcStat("Trait123458Choice",N)*0.01;
									end
								elseif SN > "HOBBITRDPSVTWONAME" then
									if SN < "HOBHOBBITSTATUREMIGHT" then
										if SN < "HOBBITRDTRAITNCMR" then
											if SN == "HOBBITRDTRAITMIGHT" then
												return CalcStat("HobSmallSizeMight",L);
											else
												return 0;
											end
										elseif SN > "HOBBITRDTRAITNCMR" then
											if SN == "HOBBITRDTRAITVITALITY" then
												return CalcStat("HobHobbitToughnVitality",L);
											else
												return 0;
											end
										else
											return CalcStat("HobRapidRecoveryNCMR",L);
										end
									elseif SN > "HOBHOBBITSTATUREMIGHT" then
										if SN < "HOBRAPIDRECOVERYNCMR" then
											if SN == "HOBHOBBITTOUGHNVITALITY" then
												return 15;
											else
												return 0;
											end
										elseif SN > "HOBRAPIDRECOVERYNCMR" then
											if SN == "HOBSMALLSIZEMIGHT" then
												return -7;
											else
												return 0;
											end
										else
											return 60;
										end
									else
										return CalcStat("MightT",L,1.0);
									end
								else
									return "";
								end
							else
								if Lm <= 50 then
									return (-4)*L+12;
								elseif Lm <= 53 then
									return -212;
								else
									return (-4)*L;
								end
							end
						elseif SN > "HOPEMORALEP" then
							if SN < "HUNTERCDBASENCMR" then
								if SN < "HUNTERCDARMOURTOTACMIT" then
									if SN < "HUNTERCDAGILITYTOPARRY" then
										if SN > "HUNTERCDAGILITYTOCRITHIT" then
											if SN == "HUNTERCDAGILITYTOEVADE" then
												return 3;
											else
												return 0;
											end
										elseif SN == "HUNTERCDAGILITYTOCRITHIT" then
											return 1;
										else
											return 0;
										end
									elseif SN > "HUNTERCDAGILITYTOPARRY" then
										if SN < "HUNTERCDARMOURTOOFMIT" then
											if SN == "HUNTERCDAGILITYTOPHYMAS" then
												return 3;
											else
												return 0;
											end
										elseif SN > "HUNTERCDARMOURTOOFMIT" then
											if SN == "HUNTERCDARMOURTOPHYMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 0.2;
										end
									else
										return 2;
									end
								elseif SN > "HUNTERCDARMOURTOTACMIT" then
									if SN < "HUNTERCDBASEICMR" then
										if SN < "HUNTERCDBASEAGILITY" then
											if SN == "HUNTERCDARMOURTYPE" then
												return 2;
											else
												return 0;
											end
										elseif SN > "HUNTERCDBASEAGILITY" then
											if SN == "HUNTERCDBASEFATE" then
												return CalcStat("ClassBaseMainE",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainL",L);
										end
									elseif SN > "HUNTERCDBASEICMR" then
										if SN < "HUNTERCDBASEMIGHT" then
											if SN == "HUNTERCDBASEICPR" then
												return CalcStat("ClassBaseICPR",L);
											else
												return 0;
											end
										elseif SN > "HUNTERCDBASEMIGHT" then
											if SN == "HUNTERCDBASEMORALE" then
												if Lm <= 120 then
													return CalcStat("ClassBaseMoraleMa",L);
												else
													return CalcStat("ClassBaseMoraleMa",120);
												end
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainA",L);
										end
									else
										return CalcStat("ClassBaseICMRM",L);
									end
								else
									return 0.2;
								end
							elseif SN > "HUNTERCDBASENCMR" then
								if SN < "HUNTERCDFATETOICPR" then
									if SN < "HUNTERCDBASEWILL" then
										if SN < "HUNTERCDBASEPOWER" then
											if SN == "HUNTERCDBASENCPR" then
												return CalcStat("ClassBaseNCPR",L);
											else
												return 0;
											end
										elseif SN > "HUNTERCDBASEPOWER" then
											if SN == "HUNTERCDBASEVITALITY" then
												return CalcStat("ClassBaseMainC",L);
											else
												return 0;
											end
										else
											if Lm <= 120 then
												return CalcStat("ClassBasePowerL",L);
											else
												return CalcStat("ClassBasePowerL",120);
											end
										end
									elseif SN > "HUNTERCDBASEWILL" then
										if SN < "HUNTERCDFATETOFINESSE" then
											if SN == "HUNTERCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										elseif SN > "HUNTERCDFATETOFINESSE" then
											if SN == "HUNTERCDFATETOICMR" then
												return 1.5;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return CalcStat("ClassBaseMainH",L);
									end
								elseif SN > "HUNTERCDFATETOICPR" then
									if SN < "HUNTERCDHASPOWER" then
										if SN < "HUNTERCDFATETORESIST" then
											if SN == "HUNTERCDFATETONCPR" then
												return 24;
											else
												return 0;
											end
										elseif SN > "HUNTERCDFATETORESIST" then
											if SN == "HUNTERCDFATETOTACMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "HUNTERCDHASPOWER" then
										if SN < "HUNTERCDMIGHTTOPARRY" then
											if SN == "HUNTERCDMIGHTTOBLOCK" then
												return 3;
											else
												return 0;
											end
										elseif SN > "HUNTERCDMIGHTTOPARRY" then
											if SN == "HUNTERCDPHYMITTOOFMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 1;
									end
								else
									return 1.71;
								end
							else
								return CalcStat("ClassBaseNCMRM",L);
							end
						else
							if Lm <= 5 then
								return DataTableValue({-0.99,-0.97,-0.95,-0.9,-0.85,-0.8,-0.65,-0.6,-0.5,-0.4,-0.3,-0.2,-0.15,-0.1,-0.05,0,0.01,0.02,0.03,0.04,0.05},L+16);
							else
								return 0.05;
							end
						end
					else
						return -7;
					end
				else
					return CalcStat("FreepAudacityRedP",L);
				end
			elseif SN > "HUNTERCDTACMASTOOUTHEAL" then
				if SN < "LOREMASTERCDBASEMORALE" then
					if SN < "ITEMLOWPROGALT" then
						if SN < "INDMGPRATP" then
							if SN < "ICPR" then
								if SN < "HUNTERCDWILLTOTACMAS" then
									if SN < "HUNTERCDVITALITYTORESIST" then
										if SN > "HUNTERCDVITALITYTOMORALE" then
											if SN == "HUNTERCDVITALITYTONCMR" then
												return 7.2;
											else
												return 0;
											end
										elseif SN == "HUNTERCDVITALITYTOMORALE" then
											return 4;
										else
											return 0;
										end
									elseif SN > "HUNTERCDVITALITYTORESIST" then
										if SN < "HUNTERCDWILLTOOUTHEAL" then
											if SN == "HUNTERCDVITALITYTOTACMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "HUNTERCDWILLTOOUTHEAL" then
											if SN == "HUNTERCDWILLTORESIST" then
												return 2;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 1;
									end
								elseif SN > "HUNTERCDWILLTOTACMAS" then
									if SN < "ICMRRAWADJ" then
										if SN < "ICMR" then
											if SN == "HUNTERCDWILLTOTACMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "ICMR" then
											if SN == "ICMRRAW" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPICMR",L)*CalcStat("ItemHighProgVPL",L,CalcStat("ProgBMorReg",L))*CalcStat("ICMRrawAdj",CalcStat("ItemHighProgLPL",L))*N),LotroDbl(CalcStat("PntMPICMR",L)*CalcStat("ItemHighProgVPH",L,CalcStat("ProgBMorReg",L))*CalcStat("ICMRrawAdj",CalcStat("ItemHighProgLPH",L))*N),CalcStat("ItemHighProgLPL",L),CalcStat("ItemHighProgLPH",L),L);
											else
												return 0;
											end
										else
											return 60*CalcStat("ICMRraw",L,N);
										end
									elseif SN > "ICMRRAWADJ" then
										if SN < "ICMRTRAW" then
											if SN == "ICMRT" then
												return 60*CalcStat("ICMRTraw",L,N);
											else
												return 0;
											end
										elseif SN > "ICMRTRAW" then
											if SN == "ICMRTRAWADJ" then
												return CalcStat("AdjTraitProgMorReg",L);
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(CalcStat("PntMPICMR",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMorReg",L))*CalcStat("ICMRTrawAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPICMR",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMorReg",L))*CalcStat("ICMRTrawAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
										end
									else
										return CalcStat("AdjItemProgMorReg",L);
									end
								else
									return 1;
								end
							elseif SN > "ICPR" then
								if SN < "IMBCOMBATBASE" then
									if SN < "ICPRT" then
										if SN > "ICPRRAW" then
											if SN == "ICPRRAWADJ" then
												return CalcStat("AdjItemProgPower",L);
											else
												return 0;
											end
										elseif SN == "ICPRRAW" then
											return LinFmod(1,LotroDbl(CalcStat("PntMPICPR",L)*CalcStat("ItemHighProgVPL",L,CalcStat("ProgBPowReg",L))*CalcStat("ICPRrawAdj",CalcStat("ItemHighProgLPL",L))*N),LotroDbl(CalcStat("PntMPICPR",L)*CalcStat("ItemHighProgVPH",L,CalcStat("ProgBPowReg",L))*CalcStat("ICPRrawAdj",CalcStat("ItemHighProgLPH",L))*N),CalcStat("ItemHighProgLPL",L),CalcStat("ItemHighProgLPH",L),L);
										else
											return 0;
										end
									elseif SN > "ICPRT" then
										if SN < "ICPRTRAWADJ" then
											if SN == "ICPRTRAW" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPICPR",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBPowReg",L))*CalcStat("ICPRTrawAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPICPR",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBPowReg",L))*CalcStat("ICPRTrawAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
											else
												return 0;
											end
										elseif SN > "ICPRTRAWADJ" then
											if SN == "ILVLTOLVL" then
												if Lm <= 79 then
													return LinFmod(1,1,75,1,79,L);
												elseif Lm <= 80 then
													return LinFmod(1,75,76,79,80,L);
												elseif Lm <= 200 then
													return LinFmod(1,76,100,80,200,L);
												elseif Lm <= 205 then
													return LinFmod(1,100,101,200,205,L);
												elseif Lm <= 225 then
													return LinFmod(1,101,105,205,225,L);
												elseif Lm <= 300 then
													return LinFmod(1,105,106,225,300,L);
												elseif Lm <= 349 then
													return LinFmod(1,106,115,300,349,L);
												elseif Lm <= 350 then
													return LinFmod(1,115,116,349,350,L);
												elseif Lm <= 399 then
													return LinFmod(1,116,120,350,399,L);
												elseif Lm <= 400 then
													return LinFmod(1,120,121,399,400,L);
												elseif Lm <= 449 then
													return LinFmod(1,121,130,400,449,L);
												elseif Lm <= 450 then
													return LinFmod(1,130,131,449,450,L);
												elseif Lm <= 499 then
													return LinFmod(1,131,140,450,499,L);
												elseif Lm <= 500 then
													return LinFmod(1,140,141,499,500,L);
												else
													return LinFmod(1,141,150,500,549,L);
												end
											else
												return 0;
											end
										else
											return CalcStat("AdjTraitProgPower",L);
										end
									else
										return 60*CalcStat("ICPRTraw",L,N);
									end
								elseif SN > "IMBCOMBATBASE" then
									if SN < "IMBCOMBATBASETABLE" then
										if SN < "IMBCOMBATBASEMP" then
											if SN == "IMBCOMBATBASEINITIAL" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({214.79,338.18,339,639.8},L);
												end
											else
												return 0;
											end
										elseif SN > "IMBCOMBATBASEMP" then
											if SN == "IMBCOMBATBASERUNEMP" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({0.5,0.75,1,1},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({0.47,0.74,1,1.4},L);
											end
										end
									elseif SN > "IMBCOMBATBASETABLE" then
										if SN < "INDMGPBONUS" then
											if SN == "IMBCOMBATBILVL" then
												if Lm <= 48 then
													return 0;
												elseif Lm <= 49 then
													return 226;
												elseif Lm <= 53 then
													return 5*L+56;
												elseif Lm <= 57 then
													return RoundDbl((100/30)*L+145);
												elseif Lm <= 74 then
													return 6*L-8;
												elseif Lm <= 79 then
													return 5*L+80;
												else
													return 500;
												end
											else
												return 0;
											end
										elseif SN > "INDMGPBONUS" then
											if SN == "INDMGPPRAT" then
												return CalcRatAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCapR",L),N);
											else
												return 0;
											end
										else
											return 0;
										end
									else
										if Lm <= 1 then
											return 0;
										else
											return DataTableValue({461,464,469,473.04,477,481,485,488,492,496,500,503,508,511,515,519,523,527,530,535,538,542,545,550,553,557,562,565,569,572,577,580,584,588,592,595,599,604,607,611,615,619,622,626,630,642,653,735,782,829,877,923,961,990,1028,1056,1103,1160,1229,1319,1408,1499,1589,1678,1768,1859,1944,2103,2262,2420,2579,2738,2897,3485,3702,3920,4137,4356,5508},L-1);
										end
									end
								else
									if Lm <= 1 then
										return CalcStat("ImbCombatBaseInitial",N);
									elseif Lm <= 48 then
										return CalcStat("ImbCombatBaseMP",N)*CalcStat("ImbCombatBaseTable",L);
									elseif Lm <= 49 then
										return CalcStat("ImbCombatBaseMP",N)*CalcStat("ImbCombatBaseTable",L)-CalcStat("ImbCombatBaseRuneMP",N)*CalcStat("RuneCombatModBase",CalcStat("ImbCombatBILvl",L));
									else
										return CalcStat("ImbCombatBaseMP",N)*CalcStat("ImbCombatBaseTable",L);
									end
								end
							else
								return 60*CalcStat("ICPRraw",L,N);
							end
						elseif SN > "INDMGPRATP" then
							if SN < "INHEALPRATPCAPR" then
								if SN < "INHEALADJ" then
									if SN < "INDMGPRATPC" then
										if SN > "INDMGPRATPA" then
											if SN == "INDMGPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProg",L,CalcStat("ProgBDefence",L));
												else
													return CalcStat("BratProg",L,CalcStat("ProgBDefenceNew",L));
												end
											else
												return 0;
											end
										elseif SN == "INDMGPRATPA" then
											if Lm <= 130 then
												return 800;
											else
												return 1200;
											end
										else
											return 0;
										end
									elseif SN > "INDMGPRATPC" then
										if SN < "INDMGPRATPCAPR" then
											if SN == "INDMGPRATPCAP" then
												return 400;
											else
												return 0;
											end
										elseif SN > "INDMGPRATPCAPR" then
											if SN == "INHEAL" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("InHealAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("InHealAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
											else
												return 0;
											end
										else
											return CalcStat("InDmgPRatPB",L)*CalcStat("InDmgPRatPC",L);
										end
									else
										if Lm <= 130 then
											return 1;
										else
											return 0.5;
										end
									end
								elseif SN > "INHEALADJ" then
									if SN < "INHEALPRATPA" then
										if SN < "INHEALPPRAT" then
											if SN == "INHEALPBONUS" then
												return 0;
											else
												return 0;
											end
										elseif SN > "INHEALPPRAT" then
											if SN == "INHEALPRATP" then
												return CalcPercAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCap",L),N);
											else
												return 0;
											end
										else
											return CalcRatAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCapR",L),N);
										end
									elseif SN > "INHEALPRATPA" then
										if SN < "INHEALPRATPC" then
											if SN == "INHEALPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
												else
													return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
												end
											else
												return 0;
											end
										elseif SN > "INHEALPRATPC" then
											if SN == "INHEALPRATPCAP" then
												return 25;
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 1;
											else
												return 0.5;
											end
										end
									else
										if Lm <= 130 then
											return 50;
										else
											return 75;
										end
									end
								else
									if Lm <= 449 then
										return CalcStat("AdjItemProgRatings",L);
									else
										return 11/9.0;
									end
								end
							elseif SN > "INHEALPRATPCAPR" then
								if SN < "ITEMHIGHPROGALTLPL" then
									if SN < "INSTRPOWER" then
										if SN < "INHEALTADJ" then
											if SN == "INHEALT" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("InHealTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("InHealTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
											else
												return 0;
											end
										elseif SN > "INHEALTADJ" then
											if SN == "INSTRMORALE" then
												if Lm <= 105 then
													return RoundDbl(4.04*L);
												else
													return CalcStat("ProgExtLowExpRnd",L,CalcStat("InstrMorale",105));
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 1;
											elseif Lm <= 75 then
												return 0.8;
											elseif Lm <= 121 then
												return 1;
											elseif Lm <= 130 then
												return 0.9;
											else
												return 11/9.0;
											end
										end
									elseif SN > "INSTRPOWER" then
										if SN < "ITEMHIGHPROGALT" then
											if SN == "ITEMHIGHPROG" then
												return CalcStat("ItemProg",L,N);
											else
												return 0;
											end
										elseif SN > "ITEMHIGHPROGALT" then
											if SN == "ITEMHIGHPROGALTLPH" then
												return CalcStat("ItemProgAltLPH",L);
											else
												return 0;
											end
										else
											return CalcStat("ItemProgAlt",L,N);
										end
									else
										if Lm <= 9 then
											return RoundDbl(0.95*L+12.6);
										elseif Lm <= 18 then
											return RoundDbl(1.95*L+3);
										elseif Lm <= 26 then
											return RoundDbl(2.95*L-15.55);
										elseif Lm <= 35 then
											return RoundDbl(3.95*L-42.15);
										elseif Lm <= 42 then
											return RoundDbl(4.95*L-77.7);
										elseif Lm <= 45 then
											return RoundDbl(5.95*L-120.35);
										elseif Lm <= 105 then
											return RoundDbl(6*L-124);
										else
											return CalcStat("ProgExtMpExpRnd",L,CalcStat("InstrPower",105));
										end
									end
								elseif SN > "ITEMHIGHPROGALTLPL" then
									if SN < "ITEMHIGHPROGLPL" then
										if SN < "ITEMHIGHPROGALTVPL" then
											if SN == "ITEMHIGHPROGALTVPH" then
												return CalcStat("ItemHighProgAlt",CalcStat("ItemHighProgAltLPH",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMHIGHPROGALTVPL" then
											if SN == "ITEMHIGHPROGLPH" then
												return CalcStat("ItemProgLPH",L);
											else
												return 0;
											end
										else
											return CalcStat("ItemHighProgAlt",CalcStat("ItemHighProgAltLPL",L),N);
										end
									elseif SN > "ITEMHIGHPROGLPL" then
										if SN < "ITEMHIGHPROGVPL" then
											if SN == "ITEMHIGHPROGVPH" then
												return CalcStat("ItemHighProg",CalcStat("ItemHighProgLPH",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMHIGHPROGVPL" then
											if SN == "ITEMLOWPROG" then
												if Lm <= 25 then
													return LinFmod(1,CalcStat("ItemProg",1,N),RoundDbl(N)*15.2,1,25,L);
												elseif Lm <= 50 then
													return LinFmod(RoundDbl(N),15.2,30,25,50,L);
												elseif Lm <= 80 then
													return LinFmod(1,RoundDbl(N)*30,CalcStat("ItemProg",80,N),50,80,L);
												else
													return CalcStat("ItemProg",L,N);
												end
											else
												return 0;
											end
										else
											return CalcStat("ItemHighProg",CalcStat("ItemHighProgLPL",L),N);
										end
									else
										return CalcStat("ItemProgLPL",L);
									end
								else
									return CalcStat("ItemProgAltLPL",L);
								end
							else
								return CalcStat("InHealPRatPB",L)*CalcStat("InHealPRatPC",L);
							end
						else
							return CalcPercAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCap",L),N);
						end
					elseif SN > "ITEMLOWPROGALT" then
						if SN < "LEVELCAP" then
							if SN < "ITEMMEDPROGLPH" then
								if SN < "ITEMLOWPROGVPH" then
									if SN < "ITEMLOWPROGALTVPH" then
										if SN > "ITEMLOWPROGALTLPH" then
											if SN == "ITEMLOWPROGALTLPL" then
												if Lm <= 25 then
													return 1;
												elseif Lm <= 50 then
													return 25;
												elseif Lm <= 80 then
													return 50;
												else
													return CalcStat("ItemProgAltLPL",L);
												end
											else
												return 0;
											end
										elseif SN == "ITEMLOWPROGALTLPH" then
											if Lm <= 25 then
												return 25;
											elseif Lm <= 50 then
												return 50;
											elseif Lm <= 80 then
												return 80;
											else
												return CalcStat("ItemProgAltLPH",L);
											end
										else
											return 0;
										end
									elseif SN > "ITEMLOWPROGALTVPH" then
										if SN < "ITEMLOWPROGLPH" then
											if SN == "ITEMLOWPROGALTVPL" then
												return CalcStat("ItemLowProgAlt",CalcStat("ItemLowProgAltLPL",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMLOWPROGLPH" then
											if SN == "ITEMLOWPROGLPL" then
												if Lm <= 25 then
													return 1;
												elseif Lm <= 50 then
													return 25;
												elseif Lm <= 80 then
													return 50;
												else
													return CalcStat("ItemProgLPL",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 25 then
												return 25;
											elseif Lm <= 50 then
												return 50;
											elseif Lm <= 80 then
												return 80;
											else
												return CalcStat("ItemProgLPH",L);
											end
										end
									else
										return CalcStat("ItemLowProgAlt",CalcStat("ItemLowProgAltLPH",L),N);
									end
								elseif SN > "ITEMLOWPROGVPH" then
									if SN < "ITEMMEDPROGALTLPH" then
										if SN < "ITEMMEDPROG" then
											if SN == "ITEMLOWPROGVPL" then
												return CalcStat("ItemLowProg",CalcStat("ItemLowProgLPL",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMMEDPROG" then
											if SN == "ITEMMEDPROGALT" then
												if Lm <= 25 then
													return LinFmod(1,CalcStat("ItemProgAlt",1,N),RoundDbl(N)*25,1,25,L);
												elseif Lm <= 79 then
													return LinFmod(1,RoundDbl(N)*25,CalcStat("ItemProgAlt",79,N),25,79,L);
												else
													return CalcStat("ItemProgAlt",L,N);
												end
											else
												return 0;
											end
										else
											if Lm <= 25 then
												return LinFmod(1,CalcStat("ItemProg",1,N),RoundDbl(N)*25,1,25,L);
											elseif Lm <= 79 then
												return LinFmod(1,RoundDbl(N)*25,CalcStat("ItemProg",79,N),25,79,L);
											else
												return CalcStat("ItemProg",L,N);
											end
										end
									elseif SN > "ITEMMEDPROGALTLPH" then
										if SN < "ITEMMEDPROGALTVPH" then
											if SN == "ITEMMEDPROGALTLPL" then
												if Lm <= 25 then
													return 1;
												elseif Lm <= 79 then
													return 25;
												else
													return CalcStat("ItemProgAltLPL",L);
												end
											else
												return 0;
											end
										elseif SN > "ITEMMEDPROGALTVPH" then
											if SN == "ITEMMEDPROGALTVPL" then
												return CalcStat("ItemMedProgAlt",CalcStat("ItemMedProgAltLPL",L),N);
											else
												return 0;
											end
										else
											return CalcStat("ItemMedProgAlt",CalcStat("ItemMedProgAltLPH",L),N);
										end
									else
										if Lm <= 25 then
											return 25;
										elseif Lm <= 79 then
											return 79;
										else
											return CalcStat("ItemProgAltLPH",L);
										end
									end
								else
									return CalcStat("ItemLowProg",CalcStat("ItemLowProgLPH",L),N);
								end
							elseif SN > "ITEMMEDPROGLPH" then
								if SN < "ITEMPROGALTLPL" then
									if SN < "ITEMMEDPROGVPL" then
										if SN > "ITEMMEDPROGLPL" then
											if SN == "ITEMMEDPROGVPH" then
												return CalcStat("ItemMedProg",CalcStat("ItemMedProgLPH",L),N);
											else
												return 0;
											end
										elseif SN == "ITEMMEDPROGLPL" then
											if Lm <= 25 then
												return 1;
											elseif Lm <= 79 then
												return 25;
											else
												return CalcStat("ItemProgLPL",L);
											end
										else
											return 0;
										end
									elseif SN > "ITEMMEDPROGVPL" then
										if SN < "ITEMPROGALT" then
											if SN == "ITEMPROG" then
												return CalcStat("StatProg",CalcStat("ILvlToLvl",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMPROGALT" then
											if SN == "ITEMPROGALTLPH" then
												return CalcStat("ItemProgLPH",L);
											else
												return 0;
											end
										else
											return CalcStat("StatProgAlt",CalcStat("ILvlToLvl",L),N);
										end
									else
										return CalcStat("ItemMedProg",CalcStat("ItemMedProgLPL",L),N);
									end
								elseif SN > "ITEMPROGALTLPL" then
									if SN < "ITEMPROGLPL" then
										if SN < "ITEMPROGALTVPL" then
											if SN == "ITEMPROGALTVPH" then
												return CalcStat("ItemProgAlt",CalcStat("ItemProgAltLPH",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMPROGALTVPL" then
											if SN == "ITEMPROGLPH" then
												if Lm <= 79 then
													return 79;
												elseif Lm <= 80 then
													return 80;
												elseif Lm <= 200 then
													return 200;
												elseif Lm <= 225 then
													return 225;
												elseif Lm <= 300 then
													return 300;
												elseif Lm <= 349 then
													return 349;
												elseif Lm <= 350 then
													return 350;
												elseif Lm <= 399 then
													return 399;
												elseif Lm <= 400 then
													return 400;
												elseif Lm <= 449 then
													return 449;
												elseif Lm <= 450 then
													return 450;
												elseif Lm <= 499 then
													return 499;
												elseif Lm <= 500 then
													return 500;
												else
													return 549;
												end
											else
												return 0;
											end
										else
											return CalcStat("ItemProgAlt",CalcStat("ItemProgAltLPL",L),N);
										end
									elseif SN > "ITEMPROGLPL" then
										if SN < "ITEMPROGVPL" then
											if SN == "ITEMPROGVPH" then
												return CalcStat("ItemProg",CalcStat("ItemProgLPH",L),N);
											else
												return 0;
											end
										elseif SN > "ITEMPROGVPL" then
											if SN == "L" then
												return L;
											else
												return 0;
											end
										else
											return CalcStat("ItemProg",CalcStat("ItemProgLPL",L),N);
										end
									else
										if Lm <= 79 then
											return 1;
										elseif Lm <= 80 then
											return 79;
										elseif Lm <= 200 then
											return 80;
										elseif Lm <= 225 then
											return 200;
										elseif Lm <= 300 then
											return 225;
										elseif Lm <= 349 then
											return 300;
										elseif Lm <= 350 then
											return 349;
										elseif Lm <= 399 then
											return 350;
										elseif Lm <= 400 then
											return 399;
										elseif Lm <= 449 then
											return 400;
										elseif Lm <= 450 then
											return 449;
										elseif Lm <= 499 then
											return 450;
										elseif Lm <= 500 then
											return 499;
										else
											return 500;
										end
									end
								else
									return CalcStat("ItemProgLPL",L);
								end
							else
								if Lm <= 25 then
									return 25;
								elseif Lm <= 79 then
									return 79;
								else
									return CalcStat("ItemProgLPH",L);
								end
							end
						elseif SN > "LEVELCAP" then
							if SN < "LMSWSTAFFBUGMORALE" then
								if SN < "LMANCIENTWISDOMWILL" then
									if SN < "LIGHTMITT" then
										if SN > "LI2REFORGEILVL" then
											if SN == "LIGHTMIT" then
												return CalcStat("DmgTypeMit",L,N);
											else
												return 0;
											end
										elseif SN == "LI2REFORGEILVL" then
											if Lm <= 135 then
												return CalcStat("AwardILvlI",L);
											else
												return 480;
											end
										else
											return 0;
										end
									elseif SN > "LIGHTMITT" then
										if SN < "LIGHTNINGMITT" then
											if SN == "LIGHTNINGMIT" then
												return CalcStat("DmgTypeMit",L,N);
											else
												return 0;
											end
										elseif SN > "LIGHTNINGMITT" then
											if SN == "LINEAR1TOCAP" then
												return LinFmod(1,1,N,1,CalcStat("LevelCap",L),L);
											else
												return 0;
											end
										else
											return CalcStat("DmgTypeMitT",L,N);
										end
									else
										return CalcStat("DmgTypeMitT",L,N);
									end
								elseif SN > "LMANCIENTWISDOMWILL" then
									if SN < "LMPREPFORWARTACMAS" then
										if SN < "LMHEARTYDIETBASE" then
											if SN == "LMCATMINTBEARARMOUR" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 105 then
													return 27*L;
												elseif Lm <= 115 then
													return LinFmod(27,210,408,106,115,L,-1);
												elseif Lm <= 116 then
													return ExpFmod(CalcStat("LMCatmintBearArmour",115),116,20,L,0);
												elseif Lm <= 120 then
													return ExpFmod(CalcStat("LMCatmintBearArmour",116),117,10,L,0);
												elseif Lm <= 121 then
													return ExpFmod(CalcStat("LMCatmintBearArmour",120),121,20,L,0);
												elseif Lm <= 130 then
													return ExpFmod(CalcStat("LMCatmintBearArmour",121),122,5.5,L,0);
												elseif Lm <= 131 then
													return ExpFmod(CalcStat("LMCatmintBearArmour",130),131,20,L,0);
												elseif Lm <= 140 then
													return ExpFmod(CalcStat("LMCatmintBearArmour",131),132,5.5,L,0);
												else
													return CalcStat("LMCatmintBearArmour",140);
												end
											else
												return 0;
											end
										elseif SN > "LMHEARTYDIETBASE" then
											if SN == "LMHEARTYDIETMORALE" then
												if Lm <= 105 then
													return CalcStat("LmHeartyDietBase",L,CalcStat("Trait23456Choice",N));
												else
													return CalcStat("ProgExtLowExpRaw",L,CalcStat("LmHeartyDietMorale",105,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return RoundDbl((0.8982*L+0.605)*N);
											else
												return RoundDbl((4*L-154.5)*N);
											end
										end
									elseif SN > "LMPREPFORWARTACMAS" then
										if SN < "LMRINGOFFIREEVADE" then
											if SN == "LMRINGOFFIREBLOCK" then
												return -CalcStat("BlockT",L,2.4);
											else
												return 0;
											end
										elseif SN > "LMRINGOFFIREEVADE" then
											if SN == "LMRINGOFFIREPARRY" then
												return -CalcStat("ParryT",L,2.4);
											else
												return 0;
											end
										else
											return -CalcStat("EvadeT",L,2.4);
										end
									else
										if Lm <= 105 then
											return CalcStat("Trait23456Choice",N)*4*L;
										else
											return CalcStat("ProgExtLowLinExpRaw",L,CalcStat("LmPrepforWarTacMas",105,N));
										end
									end
								else
									if Lm <= 105 then
										return RoundDbl(1.1*L);
									else
										return CalcStat("ProgExtLowExpRnd",L,CalcStat("LmAncientWisdomWill",105));
									end
								end
							elseif SN > "LMSWSTAFFBUGMORALE" then
								if SN < "LOREMASTERCDARMOURTOPHYMIT" then
									if SN < "LOREMASTERCDAGILITYTOCRITHIT" then
										if SN < "LOE" then
											if SN == "LMSWSTAFFBUGPARRY" then
												if Lm <= 105 then
													return RoundDbl(44.44*L);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("LmSwStaffBugParry",105));
												end
											else
												return 0;
											end
										elseif SN > "LOE" then
											if SN == "LOEPASSIVE" then
												if Lm <= 115 then
													return 0;
												elseif Lm <= 119 then
													return 20*L-2300;
												else
													return CalcStat("LoEPassive",119);
												end
											else
												return 0;
											end
										else
											return 2*N;
										end
									elseif SN > "LOREMASTERCDAGILITYTOCRITHIT" then
										if SN < "LOREMASTERCDAGILITYTOPARRY" then
											if SN == "LOREMASTERCDAGILITYTOEVADE" then
												return 3;
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDAGILITYTOPARRY" then
											if SN == "LOREMASTERCDARMOURTOOFMIT" then
												return 0.2;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 1;
									end
								elseif SN > "LOREMASTERCDARMOURTOPHYMIT" then
									if SN < "LOREMASTERCDBASEFATE" then
										if SN < "LOREMASTERCDARMOURTYPE" then
											if SN == "LOREMASTERCDARMOURTOTACMIT" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDARMOURTYPE" then
											if SN == "LOREMASTERCDBASEAGILITY" then
												return CalcStat("ClassBaseMainF",L);
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "LOREMASTERCDBASEFATE" then
										if SN < "LOREMASTERCDBASEICPR" then
											if SN == "LOREMASTERCDBASEICMR" then
												return CalcStat("ClassBaseICMRL",L);
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDBASEICPR" then
											if SN == "LOREMASTERCDBASEMIGHT" then
												return CalcStat("ClassBaseMainA",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICPR",L);
										end
									else
										return CalcStat("ClassBaseMainJ",L);
									end
								else
									return 1;
								end
							else
								if Lm <= 105 then
									return RoundDbl(LinFmod(1,16.2,696.9,1,105,L));
								else
									return CalcStat("ProgExtLowExpRnd",L,CalcStat("LmSwStaffBugMorale",105));
								end
							end
						else
							return 140;
						end
					else
						if Lm <= 25 then
							return LinFmod(1,CalcStat("ItemProgAlt",1,N),RoundDbl(N)*15.2,1,25,L);
						elseif Lm <= 50 then
							return LinFmod(RoundDbl(N),15.2,30,25,50,L);
						elseif Lm <= 80 then
							return LinFmod(1,RoundDbl(N)*30,CalcStat("ItemProgAlt",80,N),50,80,L);
						else
							return CalcStat("ItemProgAlt",L,N);
						end
					end
				elseif SN > "LOREMASTERCDBASEMORALE" then
					if SN < "MIGHTT" then
						if SN < "LVLBONUSMORRES" then
							if SN < "LOREMASTERCDPHYMITTOOFMIT" then
								if SN < "LOREMASTERCDFATETOICMR" then
									if SN < "LOREMASTERCDBASEPOWER" then
										if SN > "LOREMASTERCDBASENCMR" then
											if SN == "LOREMASTERCDBASENCPR" then
												return CalcStat("ClassBaseNCPR",L);
											else
												return 0;
											end
										elseif SN == "LOREMASTERCDBASENCMR" then
											return CalcStat("ClassBaseNCMRL",L);
										else
											return 0;
										end
									elseif SN > "LOREMASTERCDBASEPOWER" then
										if SN < "LOREMASTERCDBASEWILL" then
											if SN == "LOREMASTERCDBASEVITALITY" then
												return CalcStat("ClassBaseMainC",L);
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDBASEWILL" then
											if SN == "LOREMASTERCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainH",L);
										end
									else
										if Lm <= 120 then
											return CalcStat("ClassBasePowerH",L);
										else
											return CalcStat("ClassBasePowerH",120);
										end
									end
								elseif SN > "LOREMASTERCDFATETOICMR" then
									if SN < "LOREMASTERCDFATETOTACMIT" then
										if SN < "LOREMASTERCDFATETONCPR" then
											if SN == "LOREMASTERCDFATETOICPR" then
												return 1.71;
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDFATETONCPR" then
											if SN == "LOREMASTERCDFATETORESIST" then
												return 1;
											else
												return 0;
											end
										else
											return 24;
										end
									elseif SN > "LOREMASTERCDFATETOTACMIT" then
										if SN < "LOREMASTERCDMIGHTTOBLOCK" then
											if SN == "LOREMASTERCDHASPOWER" then
												return 1;
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDMIGHTTOBLOCK" then
											if SN == "LOREMASTERCDMIGHTTOPARRY" then
												return 2;
											else
												return 0;
											end
										else
											return 3;
										end
									else
										return 1;
									end
								else
									return 1.5;
								end
							elseif SN > "LOREMASTERCDPHYMITTOOFMIT" then
								if SN < "LOREMASTERCDWILLTOFINESSE" then
									if SN < "LOREMASTERCDVITALITYTONCMR" then
										if SN > "LOREMASTERCDTACMASTOOUTHEAL" then
											if SN == "LOREMASTERCDVITALITYTOMORALE" then
												return 4;
											else
												return 0;
											end
										elseif SN == "LOREMASTERCDTACMASTOOUTHEAL" then
											return 1;
										else
											return 0;
										end
									elseif SN > "LOREMASTERCDVITALITYTONCMR" then
										if SN < "LOREMASTERCDVITALITYTOTACMIT" then
											if SN == "LOREMASTERCDVITALITYTORESIST" then
												return 1;
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDVITALITYTOTACMIT" then
											if SN == "LOREMASTERCDWILLTOEVADE" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 7.2;
									end
								elseif SN > "LOREMASTERCDWILLTOFINESSE" then
									if SN < "LOREMASTERCDWILLTOTACMIT" then
										if SN < "LOREMASTERCDWILLTORESIST" then
											if SN == "LOREMASTERCDWILLTOOUTHEAL" then
												return 3;
											else
												return 0;
											end
										elseif SN > "LOREMASTERCDWILLTORESIST" then
											if SN == "LOREMASTERCDWILLTOTACMAS" then
												return 3;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "LOREMASTERCDWILLTOTACMIT" then
										if SN < "LVLBONUS116SEC" then
											if SN == "LVLBONUS106SEC" then
												return 7*L-639;
											else
												return 0;
											end
										elseif SN > "LVLBONUS116SEC" then
											if SN == "LVLBONUS121SEC" then
												if Lm <= 121 then
													return ExpFmod(N,121,30,L,nil);
												elseif Lm <= 125 then
													return ExpFmod(CalcStat("LvlBonus121Sec",121,N),122,5.5,L,nil);
												elseif Lm <= 126 then
													return ExpFmod(CalcStat("LvlBonus121Sec",125,N),126,30,L,nil);
												else
													return ExpFmod(CalcStat("LvlBonus121Sec",126,N),127,5.5,L,nil);
												end
											else
												return 0;
											end
										else
											if Lm <= 116 then
												return ExpFmod(N,116,30,L,nil);
											elseif Lm <= 120 then
												return ExpFmod(CalcStat("LvlBonus116Sec",116,N),117,5.5,L,nil);
											else
												return CalcStat("LvlBonus121Sec",L,CalcStat("LvlBonus116Sec",120,N));
											end
										end
									else
										return 1;
									end
								else
									return 1;
								end
							else
								return 1;
							end
						elseif SN > "LVLBONUSMORRES" then
							if SN < "MANRDPSVONEWILL" then
								if SN < "LVLEXPCOSTTOT" then
									if SN < "LVLBONUSPOWRESA" then
										if SN > "LVLBONUSPHYDMG" then
											if SN == "LVLBONUSPOWRES" then
												if Lm <= 50 then
													return (0.01964*L+0.40936)*N;
												elseif Lm <= 105 then
													return CalcStat("LvlBonusPowRes",50,N)+(L-50)*CalcStat("LvlBonusPowResA",N);
												elseif Lm <= 106 then
													return ExpFmod(CalcStat("LvlBonusPowRes",105,N),106,10,L,nil);
												elseif Lm <= 115 then
													return ExpFmod(CalcStat("LvlBonusPowRes",106,N),107,5.5,L,nil);
												else
													return CalcStat("ProgExtComLowRaw",L,CalcStat("LvlBonusPowRes",115,N));
												end
											else
												return 0;
											end
										elseif SN == "LVLBONUSPHYDMG" then
											if Lm <= 1 then
												return 1;
											elseif Lm <= 50 then
												return 0.94*L;
											elseif Lm <= 75 then
												return LinFmod(1,48,70,51,75,L);
											elseif Lm <= 105 then
												return LinFmod(1,74,94,76,105,L);
											elseif Lm <= 115 then
												return CalcStat("LvlBonus106Sec",L);
											else
												return CalcStat("LvlBonus116Sec",L,CalcStat("LvlBonusPhyDmg",115));
											end
										else
											return 0;
										end
									elseif SN > "LVLBONUSPOWRESA" then
										if SN < "LVLBONUSTACDMG" then
											if SN == "LVLBONUSRUNEOFRES" then
												if Lm <= 105 then
													return (0.14639*L+0.25361)*N;
												elseif Lm <= 106 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",105,N),106,10,L,nil);
												elseif Lm <= 115 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",106,N),107,5.5,L,nil);
												elseif Lm <= 116 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",115,N),116,20,L,nil);
												elseif Lm <= 120 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",116,N),117,10,L,nil);
												elseif Lm <= 121 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",120,N),121,20,L,nil);
												elseif Lm <= 130 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",121,N),122,5.5,L,nil);
												elseif Lm <= 131 then
													return ExpFmod(CalcStat("LvlBonusRuneofRes",130,N),131,20,L,nil);
												else
													return ExpFmod(CalcStat("LvlBonusRuneofRes",131,N),132,5.5,L,nil);
												end
											else
												return 0;
											end
										elseif SN > "LVLBONUSTACDMG" then
											if SN == "LVLEXPCOST" then
												if Lm <= 1 then
													return 0;
												elseif Lm <= 5 then
													return RoundDbl(12.5*L*L+12.5666666666667*L+24.8666666666667);
												elseif Lm <= 10 then
													return RoundDbl(33.8*L*L-179.48*L+452.6);
												elseif Lm <= 15 then
													return RoundDbl(55.05*L*L-583.77*L+2370.5);
												elseif Lm <= 20 then
													return RoundDbl(76.2*L*L-1196.96*L+6809);
												elseif Lm <= 25 then
													return RoundDbl(97.4*L*L-2023*L+14849.8);
												elseif Lm <= 30 then
													return RoundDbl(118.7*L*L-3066.02 *L+27612.8);
												elseif Lm <= 35 then
													return RoundDbl(139.95*L*L-4319.23*L+46084.1);
												elseif Lm <= 40 then
													return RoundDbl(161.2*L*L-5785.04*L+71356.2);
												elseif Lm <= 45 then
													return RoundDbl(182.5*L*L-7467.38*L+104569.8);
												elseif Lm <= 50 then
													return RoundDbl(203.8*L*L-9363.48*L+146761.8);
												elseif Lm <= 55 then
													return RoundDbl(225.05*L*L-11467.77*L+198851.3);
												elseif Lm <= 60 then
													return RoundDbl(246.3*L*L-13784.46*L+261988);
												elseif Lm <= 70 then
													return RoundDbl(ExpFmod(CalcStat("LvlExpCost",60),61,5.071,L,nil,3.485));
												elseif Lm <= 75 then
													return RoundDbl(ExpFmod(CalcStat("LvlExpCost",70),71,5.072,L,nil,-0.95));
												else
													return ExpFmod(CalcStat("LvlExpCost",75),76,5,L,0,-0.5);
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 0.2;
											elseif Lm <= 50 then
												return 0.2*L;
											elseif Lm <= 75 then
												return LinFmod(1,10.5,50,51,75,L);
											elseif Lm <= 105 then
												return LinFmod(1,52,94,76,105,L);
											elseif Lm <= 115 then
												return CalcStat("LvlBonus106Sec",L);
											elseif Lm <= 130 then
												return CalcStat("LvlBonus116Sec",L,CalcStat("LvlBonusTacDmg",115));
											elseif Lm <= 131 then
												return ExpFmod(CalcStat("LvlBonusTacDmg",130),131,2.75,L,nil);
											else
												return ExpFmod(CalcStat("LvlBonusTacDmg",131),132,5.5,L,nil);
											end
										end
									else
										if 1 <= Lp and Lm <= 1 then
											return 0.00818;
										else
											return RoundDbl(CalcStat("LvlBonusPowResA",1)*L,4);
										end
									end
								elseif SN > "LVLEXPCOSTTOT" then
									if SN < "MAINT" then
										if SN < "MAIN" then
											if SN == "LVLTOILVL" then
												if Lm <= 75 then
													return LinFmod(1,1,79,1,75,L);
												elseif Lm <= 76 then
													return LinFmod(1,79,80,75,76,L);
												elseif Lm <= 100 then
													return LinFmod(1,80,200,76,100,L);
												elseif Lm <= 101 then
													return LinFmod(1,200,205,100,101,L);
												elseif Lm <= 105 then
													return LinFmod(1,205,225,101,105,L);
												elseif Lm <= 106 then
													return LinFmod(1,225,300,105,106,L);
												elseif Lm <= 115 then
													return LinFmod(1,300,349,106,115,L);
												elseif Lm <= 116 then
													return LinFmod(1,349,350,115,116,L);
												elseif Lm <= 120 then
													return LinFmod(1,350,399,116,120,L);
												elseif Lm <= 121 then
													return LinFmod(1,399,400,120,121,L);
												elseif Lm <= 130 then
													return LinFmod(1,400,449,121,130,L);
												elseif Lm <= 131 then
													return LinFmod(1,449,450,130,131,L);
												elseif Lm <= 140 then
													return LinFmod(1,450,499,131,140,L);
												elseif Lm <= 141 then
													return LinFmod(1,499,500,140,141,L);
												else
													return LinFmod(1,500,549,141,150,L);
												end
											else
												return 0;
											end
										elseif SN > "MAIN" then
											if SN == "MAINADJ" then
												if Lm <= 25 then
													return 0.5;
												elseif Lm <= 200 then
													return 0.8;
												elseif Lm <= 400 then
													return 1;
												elseif Lm <= 449 then
													return 0.9;
												else
													return 100/90;
												end
											else
												return 0;
											end
										else
											return FloorDbl(LinFmod(1,LotroDbl(CalcStat("PntMPMain",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBMain",L))*CalcStat("MainAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPMain",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBMain",L))*CalcStat("MainAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L));
										end
									elseif SN > "MAINT" then
										if SN < "MANFOURTHAGEWILL" then
											if SN == "MAINTADJ" then
												if Lm <= 1 then
													return 1;
												elseif Lm <= 75 then
													return 0.85;
												elseif Lm <= 105 then
													return 0.9;
												elseif Lm <= 121 then
													return 1;
												elseif Lm <= 130 then
													return 0.9;
												else
													return 100/90;
												end
											else
												return 0;
											end
										elseif SN > "MANFOURTHAGEWILL" then
											if SN == "MANRDPSVONENAME" then
												return "Man of the Fourth Age";
											else
												return 0;
											end
										else
											return CalcStat("WillT",L,1.0);
										end
									else
										return FloorDbl(LinFmod(1,LotroDbl(CalcStat("PntMPMain",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBMain",L))*CalcStat("MainTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPMain",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBMain",L))*CalcStat("MainTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L));
									end
								else
									if Lm <= 1 then
										return 0;
									else
										return CalcStat("LvlExpCostTot",L-1)+CalcStat("LvlExpCost",L);
									end
								end
							elseif SN > "MANRDPSVONEWILL" then
								if SN < "MANRDTRAITWILL" then
									if SN < "MANRDPSVTWOPARRY" then
										if SN < "MANRDPSVTWOEVADE" then
											if SN == "MANRDPSVTWOBLOCK" then
												return CalcStat("BalanceOfManAvoid",L);
											else
												return 0;
											end
										elseif SN > "MANRDPSVTWOEVADE" then
											if SN == "MANRDPSVTWONAME" then
												return "Balance of Man";
											else
												return 0;
											end
										else
											return CalcStat("BalanceOfManAvoid",L);
										end
									elseif SN > "MANRDPSVTWOPARRY" then
										if SN < "MANRDTRAITINHEALP" then
											if SN == "MANRDTRAITFATE" then
												return 15;
											else
												return 0;
											end
										elseif SN > "MANRDTRAITINHEALP" then
											if SN == "MANRDTRAITMIGHT" then
												return 15;
											else
												return 0;
											end
										else
											return 5;
										end
									else
										return CalcStat("BalanceOfManAvoid",L);
									end
								elseif SN > "MANRDTRAITWILL" then
									if SN < "MASTERYT" then
										if SN < "MASTERYADJ" then
											if SN == "MASTERY" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPMastery",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMastery",L))*CalcStat("MasteryAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("PntMPMastery",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMastery",L))*CalcStat("MasteryAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L);
											else
												return 0;
											end
										elseif SN > "MASTERYADJ" then
											if SN == "MASTERYOLD" then
												return CalcStat("Mastery",L,N);
											else
												return 0;
											end
										else
											if Lm <= 449 then
												return CalcStat("AdjItemProgRatings",L);
											elseif Lm <= 450 then
												return 83/90;
											else
												return 70/90;
											end
										end
									elseif SN > "MASTERYT" then
										if SN < "MATHOMLVLTOILVL" then
											if SN == "MASTERYTADJ" then
												if Lm <= 1 then
													return 1;
												elseif Lm <= 75 then
													return 0.8;
												elseif Lm <= 121 then
													return 1;
												elseif Lm <= 130 then
													return 0.9;
												else
													return 70/90;
												end
											else
												return 0;
											end
										elseif SN > "MATHOMLVLTOILVL" then
											if SN == "MIGHT" then
												return CalcStat("Main",L,N);
											else
												return 0;
											end
										else
											return CalcStat("AwardLvlToILvl",L);
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPMastery",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMastery",L))*CalcStat("MasteryTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPMastery",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMastery",L))*CalcStat("MasteryTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
									end
								else
									return -7;
								end
							else
								return CalcStat("ManFourthAgeWill",L);
							end
						else
							if Lm <= 1 then
								return 0.2;
							elseif Lm <= 50 then
								return 0.2*L;
							elseif Lm <= 75 then
								return LinFmod(1,10.5,50,51,75,L);
							elseif Lm <= 105 then
								return LinFmod(1,52,94,76,105,L);
							elseif Lm <= 115 then
								return CalcStat("LvlBonus106Sec",L);
							elseif Lm <= 120 then
								return CalcStat("LvlBonusMorRes",115);
							elseif Lm <= 130 then
								return CalcStat("LvlBonus121Sec",L,CalcStat("LvlBonusMorRes",120));
							elseif Lm <= 131 then
								return ExpFmod(CalcStat("LvlBonusMorRes",130),131,2.75,L,nil);
							else
								return LinFmod(1,CalcStat("LvlBonusMorRes",131),600,131,140,L,0);
							end
						end
					elseif SN > "MIGHTT" then
						if SN < "MINSTRELCDFATETOICMR" then
							if SN < "MINSTRELCDARMOURTOPHYMIT" then
								if SN < "MINECHOESBATTLECRITDEF" then
									if SN < "MINCALLOROMEMELLIGHTMIT" then
										if SN > "MINCALLEARENDILLIGHTMIT" then
											if SN == "MINCALLOROMELIGHTMIT" then
												return -CalcStat("LightMitT",L,1.2);
											else
												return 0;
											end
										elseif SN == "MINCALLEARENDILLIGHTMIT" then
											return -CalcStat("LightMitT",L,1.2);
										else
											return 0;
										end
									elseif SN > "MINCALLOROMEMELLIGHTMIT" then
										if SN < "MINCOMPOSURETACMIT" then
											if SN == "MINCOMPOSURERESIST" then
												return CalcStat("ResistT",L,1.6);
											else
												return 0;
											end
										elseif SN > "MINCOMPOSURETACMIT" then
											if SN == "MINCOURAGERESIST" then
												return CalcStat("FearResistT",L,1.0);
											else
												return 0;
											end
										else
											return CalcStat("TacMitT",L,1.0);
										end
									else
										return -CalcStat("LightMitT",L,1.4);
									end
								elseif SN > "MINECHOESBATTLECRITDEF" then
									if SN < "MINSTRELCDAGILITYTOCRITHIT" then
										if SN < "MINENDMORALE" then
											if SN == "MINECHOESBATTLERESIST" then
												return -CalcStat("SongResistT",L,1.0);
											else
												return 0;
											end
										elseif SN > "MINENDMORALE" then
											if SN == "MINPIERCINGBALFINESSE" then
												return CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4);
											else
												return 0;
											end
										else
											return CalcStat("MoraleT",L,CalcStat("Trait12345Choice",N)*0.8);
										end
									elseif SN > "MINSTRELCDAGILITYTOCRITHIT" then
										if SN < "MINSTRELCDAGILITYTOPARRY" then
											if SN == "MINSTRELCDAGILITYTOEVADE" then
												return 3;
											else
												return 0;
											end
										elseif SN > "MINSTRELCDAGILITYTOPARRY" then
											if SN == "MINSTRELCDARMOURTOOFMIT" then
												return 0.2;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 1;
									end
								else
									return -CalcStat("CritDefT",L,2.0);
								end
							elseif SN > "MINSTRELCDARMOURTOPHYMIT" then
								if SN < "MINSTRELCDBASEMORALE" then
									if SN < "MINSTRELCDBASEFATE" then
										if SN < "MINSTRELCDARMOURTYPE" then
											if SN == "MINSTRELCDARMOURTOTACMIT" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "MINSTRELCDARMOURTYPE" then
											if SN == "MINSTRELCDBASEAGILITY" then
												return CalcStat("ClassBaseMainA",L);
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "MINSTRELCDBASEFATE" then
										if SN < "MINSTRELCDBASEICPR" then
											if SN == "MINSTRELCDBASEICMR" then
												return CalcStat("ClassBaseICMRL",L);
											else
												return 0;
											end
										elseif SN > "MINSTRELCDBASEICPR" then
											if SN == "MINSTRELCDBASEMIGHT" then
												return CalcStat("ClassBaseMainF",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICPR",L);
										end
									else
										return CalcStat("ClassBaseMainH",L);
									end
								elseif SN > "MINSTRELCDBASEMORALE" then
									if SN < "MINSTRELCDBASEVITALITY" then
										if SN < "MINSTRELCDBASENCPR" then
											if SN == "MINSTRELCDBASENCMR" then
												return CalcStat("ClassBaseNCMRL",L);
											else
												return 0;
											end
										elseif SN > "MINSTRELCDBASENCPR" then
											if SN == "MINSTRELCDBASEPOWER" then
												if Lm <= 120 then
													return CalcStat("ClassBasePowerH",L);
												else
													return CalcStat("ClassBasePowerH",120);
												end
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseNCPR",L);
										end
									elseif SN > "MINSTRELCDBASEVITALITY" then
										if SN < "MINSTRELCDCANBLOCK" then
											if SN == "MINSTRELCDBASEWILL" then
												return CalcStat("ClassBaseMainJ",L);
											else
												return 0;
											end
										elseif SN > "MINSTRELCDCANBLOCK" then
											if SN == "MINSTRELCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										else
											if Lm <= 19 then
												return 0;
											else
												return 1;
											end
										end
									else
										return CalcStat("ClassBaseMainC",L);
									end
								else
									if Lm <= 120 then
										return CalcStat("ClassBaseMoraleL",L);
									else
										return CalcStat("ClassBaseMoraleL",120);
									end
								end
							else
								return 1;
							end
						elseif SN > "MINSTRELCDFATETOICMR" then
							if SN < "MINSTRELCDWILLTOFINESSE" then
								if SN < "MINSTRELCDMIGHTTOPARRY" then
									if SN < "MINSTRELCDFATETORESIST" then
										if SN > "MINSTRELCDFATETOICPR" then
											if SN == "MINSTRELCDFATETONCPR" then
												return 24;
											else
												return 0;
											end
										elseif SN == "MINSTRELCDFATETOICPR" then
											return 1.71;
										else
											return 0;
										end
									elseif SN > "MINSTRELCDFATETORESIST" then
										if SN < "MINSTRELCDHASPOWER" then
											if SN == "MINSTRELCDFATETOTACMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "MINSTRELCDHASPOWER" then
											if SN == "MINSTRELCDMIGHTTOBLOCK" then
												return 3;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 1;
									end
								elseif SN > "MINSTRELCDMIGHTTOPARRY" then
									if SN < "MINSTRELCDVITALITYTONCMR" then
										if SN < "MINSTRELCDTACMASTOOUTHEAL" then
											if SN == "MINSTRELCDPHYMITTOOFMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "MINSTRELCDTACMASTOOUTHEAL" then
											if SN == "MINSTRELCDVITALITYTOMORALE" then
												return 4;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "MINSTRELCDVITALITYTONCMR" then
										if SN < "MINSTRELCDVITALITYTOTACMIT" then
											if SN == "MINSTRELCDVITALITYTORESIST" then
												return 1;
											else
												return 0;
											end
										elseif SN > "MINSTRELCDVITALITYTOTACMIT" then
											if SN == "MINSTRELCDWILLTOEVADE" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 7.2;
									end
								else
									return 2;
								end
							elseif SN > "MINSTRELCDWILLTOFINESSE" then
								if SN < "MINTOTFATE" then
									if SN < "MINSTRELCDWILLTOTACMIT" then
										if SN < "MINSTRELCDWILLTORESIST" then
											if SN == "MINSTRELCDWILLTOOUTHEAL" then
												return 3;
											else
												return 0;
											end
										elseif SN > "MINSTRELCDWILLTORESIST" then
											if SN == "MINSTRELCDWILLTOTACMAS" then
												return 3;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "MINSTRELCDWILLTOTACMIT" then
										if SN < "MINTIMEECHOESBATTLERESIST" then
											if SN == "MINTACMAS" then
												return CalcStat("TacMasT",L,CalcStat("Trait12345Choice",N)*0.4);
											else
												return 0;
											end
										elseif SN > "MINTIMEECHOESBATTLERESIST" then
											if SN == "MINTOTCRITHIT" then
												return CalcStat("CritHitT",L,CalcStat("Trait23456Choice",N-3)*0.2);
											else
												return 0;
											end
										else
											return -CalcStat("SongResistT",L,0.6);
										end
									else
										return 1;
									end
								elseif SN > "MINTOTFATE" then
									if SN < "MITHEAVYPBONUS" then
										if SN < "MINTOTRESIST" then
											if SN == "MINTOTFINESSE" then
												return CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N-2)*0.2);
											else
												return 0;
											end
										elseif SN > "MINTOTRESIST" then
											if SN == "MINTOTVITALITY" then
												return CalcStat("VitalityT",L,CalcStat("Trait23456Choice",N-4)*0.2);
											else
												return 0;
											end
										else
											return CalcStat("ResistT",L,CalcStat("Trait23456Choice",N-1)*0.1);
										end
									elseif SN > "MITHEAVYPBONUS" then
										if SN < "MITHEAVYPRATP" then
											if SN == "MITHEAVYPPRAT" then
												return CalcRatAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCapR",L),N);
											else
												return 0;
											end
										elseif SN > "MITHEAVYPRATP" then
											if SN == "MITHEAVYPRATPA" then
												if Lm <= 130 then
													return 110;
												else
													return 180;
												end
											else
												return 0;
											end
										else
											return CalcPercAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCap",L),N);
										end
									else
										return 0;
									end
								else
									return CalcStat("FateT",L,CalcStat("Trait23456Choice",N)*0.1);
								end
							else
								return 1;
							end
						else
							return 1.5;
						end
					else
						return CalcStat("MainT",L,N);
					end
				else
					if Lm <= 120 then
						return CalcStat("ClassBaseMoraleL",L);
					else
						return CalcStat("ClassBaseMoraleL",120);
					end
				end
			else
				return 1;
			end
		else
			return LinFmod(1,LotroDbl(CalcStat("PntMPCritHit",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("CritHitAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPCritHit",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("CritHitAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
		end
	elseif SN > "MITHEAVYPRATPB" then
		if SN < "TRAITVITALITYPROG" then
			if SN < "RELBLOCK" then
				if SN < "PARTPARRYMITPRATPB" then
					if SN < "PARRYPBONUS" then
						if SN < "NCMRT" then
							if SN < "MITMEDIUMPPRAT" then
								if SN < "MITLIGHTPPRAT" then
									if SN < "MITHEAVYPRATPCAPR" then
										if SN > "MITHEAVYPRATPC" then
											if SN == "MITHEAVYPRATPCAP" then
												return 60;
											else
												return 0;
											end
										elseif SN == "MITHEAVYPRATPC" then
											if Lm <= 130 then
												return 1.2;
											else
												return 0.5;
											end
										else
											return 0;
										end
									elseif SN > "MITHEAVYPRATPCAPR" then
										if SN < "MITIGATIONADJ" then
											if SN == "MITIGATION" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPMitigation",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("MitigationAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("PntMPMitigation",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("MitigationAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L);
											else
												return 0;
											end
										elseif SN > "MITIGATIONADJ" then
											if SN == "MITLIGHTPBONUS" then
												return 0;
											else
												return 0;
											end
										else
											if Lm <= 400 then
												return CalcStat("AdjItemProgLow",L);
											elseif Lm <= 449 then
												return 0.9;
											elseif Lm <= 450 then
												return 83/90;
											elseif Lm <= 499 then
												return 80/90;
											elseif Lm <= 500 then
												return 70/90;
											else
												return 60/90;
											end
										end
									else
										return CalcStat("MitHeavyPRatPB",L)*CalcStat("MitHeavyPRatPC",L);
									end
								elseif SN > "MITLIGHTPPRAT" then
									if SN < "MITLIGHTPRATPC" then
										if SN < "MITLIGHTPRATPA" then
											if SN == "MITLIGHTPRATP" then
												return CalcPercAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCap",L),N);
											else
												return 0;
											end
										elseif SN > "MITLIGHTPRATPA" then
											if SN == "MITLIGHTPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProg",L,CalcStat("ProgBMitLight",L));
												else
													return CalcStat("BratProg",L,CalcStat("ProgBMitLightNew",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 65;
											else
												return 120;
											end
										end
									elseif SN > "MITLIGHTPRATPC" then
										if SN < "MITLIGHTPRATPCAPR" then
											if SN == "MITLIGHTPRATPCAP" then
												return 40;
											else
												return 0;
											end
										elseif SN > "MITLIGHTPRATPCAPR" then
											if SN == "MITMEDIUMPBONUS" then
												return 0;
											else
												return 0;
											end
										else
											return CalcStat("MitLightPRatPB",L)*CalcStat("MitLightPRatPC",L);
										end
									else
										if Lm <= 130 then
											return 1.6;
										else
											return 0.5;
										end
									end
								else
									return CalcRatAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCapR",L),N);
								end
							elseif SN > "MITMEDIUMPPRAT" then
								if SN < "MORALE" then
									if SN < "MITMEDIUMPRATPB" then
										if SN > "MITMEDIUMPRATP" then
											if SN == "MITMEDIUMPRATPA" then
												if Lm <= 130 then
													return 85;
												else
													return 150;
												end
											else
												return 0;
											end
										elseif SN == "MITMEDIUMPRATP" then
											return CalcPercAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCap",L),N);
										else
											return 0;
										end
									elseif SN > "MITMEDIUMPRATPB" then
										if SN < "MITMEDIUMPRATPCAP" then
											if SN == "MITMEDIUMPRATPC" then
												if Lm <= 130 then
													return 100/70;
												else
													return 0.5;
												end
											else
												return 0;
											end
										elseif SN > "MITMEDIUMPRATPCAP" then
											if SN == "MITMEDIUMPRATPCAPR" then
												return CalcStat("MitMediumPRatPB",L)*CalcStat("MitMediumPRatPC",L);
											else
												return 0;
											end
										else
											return 50;
										end
									else
										if Lm <= 130 then
											return CalcStat("BratProg",L,CalcStat("ProgBMitMedium",L));
										else
											return CalcStat("BratProg",L,CalcStat("ProgBMitMediumNew",L));
										end
									end
								elseif SN > "MORALE" then
									if SN < "N" then
										if SN < "MORALET" then
											if SN == "MORALEADJ" then
												if Lm <= 25 then
													return 0.5;
												elseif Lm <= 350 then
													return 1;
												elseif Lm <= 399 then
													return 0.8;
												elseif Lm <= 400 then
													return 22/35;
												elseif Lm <= 449 then
													return 40/70;
												elseif Lm <= 450 then
													return 0.582;
												elseif Lm <= 499 then
													return 0.635;
												elseif Lm <= 500 then
													return 0.582;
												else
													return 0.635;
												end
											else
												return 0;
											end
										elseif SN > "MORALET" then
											if SN == "MORALETADJ" then
												return CalcStat("AdjTraitProgMorale",L);
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(CalcStat("PntMPMorale",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMorale",L))*CalcStat("MoraleTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPMorale",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMorale",L))*CalcStat("MoraleTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
										end
									elseif SN > "N" then
										if SN < "NCMRRAW" then
											if SN == "NCMR" then
												return 60*CalcStat("NCMRraw",L,N);
											else
												return 0;
											end
										elseif SN > "NCMRRAW" then
											if SN == "NCMRRAWADJ" then
												return CalcStat("AdjItemProgMorReg",L);
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(CalcStat("PntMPNCMR",L)*CalcStat("ItemHighProgVPL",L,CalcStat("ProgBMorReg",L))*CalcStat("NCMRrawAdj",CalcStat("ItemHighProgLPL",L))*N),LotroDbl(CalcStat("PntMPNCMR",L)*CalcStat("ItemHighProgVPH",L,CalcStat("ProgBMorReg",L))*CalcStat("NCMRrawAdj",CalcStat("ItemHighProgLPH",L))*N),CalcStat("ItemHighProgLPL",L),CalcStat("ItemHighProgLPH",L),L);
										end
									else
										return N;
									end
								else
									return LinFmod(1,LotroDbl(CalcStat("PntMPMorale",L)*CalcStat("ItemLowProgVPL",L,CalcStat("ProgBMorale",L))*CalcStat("MoraleAdj",CalcStat("ItemLowProgLPL",L))*N),LotroDbl(CalcStat("PntMPMorale",L)*CalcStat("ItemLowProgVPH",L,CalcStat("ProgBMorale",L))*CalcStat("MoraleAdj",CalcStat("ItemLowProgLPH",L))*N),CalcStat("ItemLowProgLPL",L),CalcStat("ItemLowProgLPH",L),L);
								end
							else
								return CalcRatAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCapR",L),N);
							end
						elseif SN > "NCMRT" then
							if SN < "OUTDMGPRATPC" then
								if SN < "NCPRTRAW" then
									if SN < "NCPR" then
										if SN > "NCMRTRAW" then
											if SN == "NCMRTRAWADJ" then
												return CalcStat("AdjTraitProgMorReg",L);
											else
												return 0;
											end
										elseif SN == "NCMRTRAW" then
											return LinFmod(1,LotroDbl(CalcStat("PntMPNCMR",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMorReg",L))*CalcStat("NCMRTrawAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPNCMR",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMorReg",L))*CalcStat("NCMRTrawAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
										else
											return 0;
										end
									elseif SN > "NCPR" then
										if SN < "NCPRRAWADJ" then
											if SN == "NCPRRAW" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPNCPR",L)*CalcStat("ItemHighProgVPL",L,CalcStat("ProgBPowReg",L))*CalcStat("NCPRrawAdj",CalcStat("ItemHighProgLPL",L))*N),LotroDbl(CalcStat("PntMPNCPR",L)*CalcStat("ItemHighProgVPH",L,CalcStat("ProgBPowReg",L))*CalcStat("NCPRrawAdj",CalcStat("ItemHighProgLPH",L))*N),CalcStat("ItemHighProgLPL",L),CalcStat("ItemHighProgLPH",L),L);
											else
												return 0;
											end
										elseif SN > "NCPRRAWADJ" then
											if SN == "NCPRT" then
												return 60*CalcStat("NCPRTraw",L,N);
											else
												return 0;
											end
										else
											return CalcStat("AdjItemProgPower",L);
										end
									else
										return 60*CalcStat("NCPRraw",L,N);
									end
								elseif SN > "NCPRTRAW" then
									if SN < "OUTDMGPPRAT" then
										if SN < "OFFSET" then
											if SN == "NCPRTRAWADJ" then
												return CalcStat("AdjTraitProgPower",L);
											else
												return 0;
											end
										elseif SN > "OFFSET" then
											if SN == "OUTDMGPBONUS" then
												return 0;
											else
												return 0;
											end
										else
											return L+N;
										end
									elseif SN > "OUTDMGPPRAT" then
										if SN < "OUTDMGPRATPA" then
											if SN == "OUTDMGPRATP" then
												return CalcPercAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCap",L),N);
											else
												return 0;
											end
										elseif SN > "OUTDMGPRATPA" then
											if SN == "OUTDMGPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProg",L,CalcStat("ProgBMastery",L));
												else
													return CalcStat("BratProg",L,CalcStat("ProgBMasteryNew",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 400;
											else
												return 600;
											end
										end
									else
										return CalcRatAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCapR",L),N);
									end
								else
									return LinFmod(1,LotroDbl(CalcStat("PntMPNCPR",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBPowReg",L))*CalcStat("NCPRTrawAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPNCPR",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBPowReg",L))*CalcStat("NCPRTrawAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
								end
							elseif SN > "OUTDMGPRATPC" then
								if SN < "OUTHEALPRATPA" then
									if SN < "OUTHEALADJ" then
										if SN < "OUTDMGPRATPCAPR" then
											if SN == "OUTDMGPRATPCAP" then
												return 200;
											else
												return 0;
											end
										elseif SN > "OUTDMGPRATPCAPR" then
											if SN == "OUTHEAL" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPratings",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMedium",L))*CalcStat("OutHealAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("PntMPratings",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMedium",L))*CalcStat("OutHealAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L);
											else
												return 0;
											end
										else
											return CalcStat("OutDmgPRatPB",L)*CalcStat("OutDmgPRatPC",L);
										end
									elseif SN > "OUTHEALADJ" then
										if SN < "OUTHEALPPRAT" then
											if SN == "OUTHEALPBONUS" then
												return 0;
											else
												return 0;
											end
										elseif SN > "OUTHEALPPRAT" then
											if SN == "OUTHEALPRATP" then
												return CalcPercAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCap",L),N);
											else
												return 0;
											end
										else
											return CalcRatAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCapR",L),N);
										end
									else
										if Lm <= 449 then
											return CalcStat("AdjItemProgRatings",L);
										elseif Lm <= 450 then
											return 83/90;
										else
											return 0.778;
										end
									end
								elseif SN > "OUTHEALPRATPA" then
									if SN < "OUTHEALPRATPCAPR" then
										if SN < "OUTHEALPRATPC" then
											if SN == "OUTHEALPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProg",L,CalcStat("ProgBMedium",L));
												else
													return CalcStat("BratProg",L,CalcStat("ProgBMediumNew",L));
												end
											else
												return 0;
											end
										elseif SN > "OUTHEALPRATPC" then
											if SN == "OUTHEALPRATPCAP" then
												return 70;
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 1;
											else
												return 0.5;
											end
										end
									elseif SN > "OUTHEALPRATPCAPR" then
										if SN < "OUTHEALTADJ" then
											if SN == "OUTHEALT" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMedium",L))*CalcStat("OutHealTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMedium",L))*CalcStat("OutHealTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
											else
												return 0;
											end
										elseif SN > "OUTHEALTADJ" then
											if SN == "PARRY" then
												return CalcStat("BPE",L,N);
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 1;
											elseif Lm <= 75 then
												return 0.8;
											elseif Lm <= 121 then
												return 1;
											elseif Lm <= 130 then
												return 0.9;
											else
												return 70/90;
											end
										end
									else
										return CalcStat("OutHealPRatPB",L)*CalcStat("OutHealPRatPC",L);
									end
								else
									if Lm <= 130 then
										return 140;
									else
										return 210;
									end
								end
							else
								if Lm <= 130 then
									return 1;
								else
									return 0.5;
								end
							end
						else
							return 60*CalcStat("NCMRTraw",L,N);
						end
					elseif SN > "PARRYPBONUS" then
						if SN < "PARTBPEPRATPC" then
							if SN < "PARTBLOCKMITPRATPCAP" then
								if SN < "PARRYPRATPCAPR" then
									if SN < "PARRYPRATPA" then
										if SN > "PARRYPPRAT" then
											if SN == "PARRYPRATP" then
												return CalcStat("BPEPRatP",L,N);
											else
												return 0;
											end
										elseif SN == "PARRYPPRAT" then
											return CalcStat("BPEPPRat",L,N);
										else
											return 0;
										end
									elseif SN > "PARRYPRATPA" then
										if SN < "PARRYPRATPC" then
											if SN == "PARRYPRATPB" then
												return CalcStat("BPEPRatPB",L);
											else
												return 0;
											end
										elseif SN > "PARRYPRATPC" then
											if SN == "PARRYPRATPCAP" then
												return CalcStat("BPEPRatPCap",L);
											else
												return 0;
											end
										else
											return CalcStat("BPEPRatPC",L);
										end
									else
										return CalcStat("BPEPRatPA",L);
									end
								elseif SN > "PARRYPRATPCAPR" then
									if SN < "PARTBLOCKMITPRATP" then
										if SN < "PARTBLOCKMITPBONUS" then
											if SN == "PARRYT" then
												return CalcStat("BPET",L,N);
											else
												return 0;
											end
										elseif SN > "PARTBLOCKMITPBONUS" then
											if SN == "PARTBLOCKMITPPRAT" then
												return CalcStat("PartMitPPRat",L,N);
											else
												return 0;
											end
										else
											return CalcStat("PartMitPBonus",L);
										end
									elseif SN > "PARTBLOCKMITPRATP" then
										if SN < "PARTBLOCKMITPRATPB" then
											if SN == "PARTBLOCKMITPRATPA" then
												return CalcStat("PartMitPRatPA",L);
											else
												return 0;
											end
										elseif SN > "PARTBLOCKMITPRATPB" then
											if SN == "PARTBLOCKMITPRATPC" then
												return CalcStat("PartMitPRatPC",L);
											else
												return 0;
											end
										else
											return CalcStat("PartMitPRatPB",L);
										end
									else
										return CalcStat("PartMitPRatP",L,N);
									end
								else
									return CalcStat("BPEPRatPCapR",L);
								end
							elseif SN > "PARTBLOCKMITPRATPCAP" then
								if SN < "PARTBLOCKPRATPC" then
									if SN < "PARTBLOCKPPRAT" then
										if SN > "PARTBLOCKMITPRATPCAPR" then
											if SN == "PARTBLOCKPBONUS" then
												return CalcStat("PartBPEPBonus",L);
											else
												return 0;
											end
										elseif SN == "PARTBLOCKMITPRATPCAPR" then
											return CalcStat("PartMitPRatPCapR",L);
										else
											return 0;
										end
									elseif SN > "PARTBLOCKPPRAT" then
										if SN < "PARTBLOCKPRATPA" then
											if SN == "PARTBLOCKPRATP" then
												return CalcStat("PartBPEPRatP",L,N);
											else
												return 0;
											end
										elseif SN > "PARTBLOCKPRATPA" then
											if SN == "PARTBLOCKPRATPB" then
												return CalcStat("PartBPEPRatPB",L);
											else
												return 0;
											end
										else
											return CalcStat("PartBPEPRatPA",L);
										end
									else
										return CalcStat("PartBPEPPRat",L,N);
									end
								elseif SN > "PARTBLOCKPRATPC" then
									if SN < "PARTBPEPPRAT" then
										if SN < "PARTBLOCKPRATPCAPR" then
											if SN == "PARTBLOCKPRATPCAP" then
												return CalcStat("PartBPEPRatPCap",L);
											else
												return 0;
											end
										elseif SN > "PARTBLOCKPRATPCAPR" then
											if SN == "PARTBPEPBONUS" then
												return 0;
											else
												return 0;
											end
										else
											return CalcStat("PartBPEPRatPCapR",L);
										end
									elseif SN > "PARTBPEPPRAT" then
										if SN < "PARTBPEPRATPA" then
											if SN == "PARTBPEPRATP" then
												return CalcPercAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCap",L),N);
											else
												return 0;
											end
										elseif SN > "PARTBPEPRATPA" then
											if SN == "PARTBPEPRATPB" then
												if Lm <= 130 then
													return CalcStat("BratProgAlt",L,CalcStat("ProgBPartial",L));
												else
													return CalcStat("BratProgAlt",L,CalcStat("ProgBPartialNew",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 70;
											else
												return 75;
											end
										end
									else
										return CalcRatAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCapR",L),N);
									end
								else
									return CalcStat("PartBPEPRatPC",L);
								end
							else
								return CalcStat("PartMitPRatPCap",L);
							end
						elseif SN > "PARTBPEPRATPC" then
							if SN < "PARTEVADEPRATPB" then
								if SN < "PARTEVADEMITPRATPB" then
									if SN < "PARTEVADEMITPBONUS" then
										if SN > "PARTBPEPRATPCAP" then
											if SN == "PARTBPEPRATPCAPR" then
												return CalcStat("PartBPEPRatPB",L)*CalcStat("PartBPEPRatPC",L);
											else
												return 0;
											end
										elseif SN == "PARTBPEPRATPCAP" then
											if Lm <= 130 then
												return 35;
											else
												return 25;
											end
										else
											return 0;
										end
									elseif SN > "PARTEVADEMITPBONUS" then
										if SN < "PARTEVADEMITPRATP" then
											if SN == "PARTEVADEMITPPRAT" then
												return CalcStat("PartMitPPRat",L,N);
											else
												return 0;
											end
										elseif SN > "PARTEVADEMITPRATP" then
											if SN == "PARTEVADEMITPRATPA" then
												return CalcStat("PartMitPRatPA",L);
											else
												return 0;
											end
										else
											return CalcStat("PartMitPRatP",L,N);
										end
									else
										return CalcStat("PartMitPBonus",L);
									end
								elseif SN > "PARTEVADEMITPRATPB" then
									if SN < "PARTEVADEPBONUS" then
										if SN < "PARTEVADEMITPRATPCAP" then
											if SN == "PARTEVADEMITPRATPC" then
												return CalcStat("PartMitPRatPC",L);
											else
												return 0;
											end
										elseif SN > "PARTEVADEMITPRATPCAP" then
											if SN == "PARTEVADEMITPRATPCAPR" then
												return CalcStat("PartMitPRatPCapR",L);
											else
												return 0;
											end
										else
											return CalcStat("PartMitPRatPCap",L);
										end
									elseif SN > "PARTEVADEPBONUS" then
										if SN < "PARTEVADEPRATP" then
											if SN == "PARTEVADEPPRAT" then
												return CalcStat("PartBPEPPRat",L,N);
											else
												return 0;
											end
										elseif SN > "PARTEVADEPRATP" then
											if SN == "PARTEVADEPRATPA" then
												return CalcStat("PartBPEPRatPA",L);
											else
												return 0;
											end
										else
											return CalcStat("PartBPEPRatP",L,N);
										end
									else
										return CalcStat("PartBPEPBonus",L);
									end
								else
									return CalcStat("PartMitPRatPB",L);
								end
							elseif SN > "PARTEVADEPRATPB" then
								if SN < "PARTMITPRATPB" then
									if SN < "PARTMITPBONUS" then
										if SN < "PARTEVADEPRATPCAP" then
											if SN == "PARTEVADEPRATPC" then
												return CalcStat("PartBPEPRatPC",L);
											else
												return 0;
											end
										elseif SN > "PARTEVADEPRATPCAP" then
											if SN == "PARTEVADEPRATPCAPR" then
												return CalcStat("PartBPEPRatPCapR",L);
											else
												return 0;
											end
										else
											return CalcStat("PartBPEPRatPCap",L);
										end
									elseif SN > "PARTMITPBONUS" then
										if SN < "PARTMITPRATP" then
											if SN == "PARTMITPPRAT" then
												return CalcRatAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCapR",L),N);
											else
												return 0;
											end
										elseif SN > "PARTMITPRATP" then
											if SN == "PARTMITPRATPA" then
												if Lm <= 130 then
													return 100;
												else
													return 105;
												end
											else
												return 0;
											end
										else
											return CalcPercAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCap",L),N);
										end
									else
										return 0.1;
									end
								elseif SN > "PARTMITPRATPB" then
									if SN < "PARTPARRYMITPBONUS" then
										if SN < "PARTMITPRATPCAP" then
											if SN == "PARTMITPRATPC" then
												if Lm <= 130 then
													return 1;
												else
													return 0.5;
												end
											else
												return 0;
											end
										elseif SN > "PARTMITPRATPCAP" then
											if SN == "PARTMITPRATPCAPR" then
												return CalcStat("PartMitPRatPB",L)*CalcStat("PartMitPRatPC",L);
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return 50;
											else
												return 35;
											end
										end
									elseif SN > "PARTPARRYMITPBONUS" then
										if SN < "PARTPARRYMITPRATP" then
											if SN == "PARTPARRYMITPPRAT" then
												return CalcStat("PartMitPPRat",L,N);
											else
												return 0;
											end
										elseif SN > "PARTPARRYMITPRATP" then
											if SN == "PARTPARRYMITPRATPA" then
												return CalcStat("PartMitPRatPA",L);
											else
												return 0;
											end
										else
											return CalcStat("PartMitPRatP",L,N);
										end
									else
										return CalcStat("PartMitPBonus",L);
									end
								else
									if Lm <= 130 then
										return CalcStat("BratProgAlt",L,CalcStat("ProgBPartial",L));
									else
										return CalcStat("BratProgAlt",L,CalcStat("ProgBPartialNew",L));
									end
								end
							else
								return CalcStat("PartBPEPRatPB",L);
							end
						else
							if Lm <= 130 then
								return 1;
							else
								return 0.5;
							end
						end
					else
						return CalcStat("BPEPBonus",L);
					end
				elseif SN > "PARTPARRYMITPRATPB" then
					if SN < "PNTMPICMR" then
						if SN < "PHYMITADJ" then
							if SN < "PERKPHYMIT" then
								if SN < "PARTPARRYPRATPA" then
									if SN < "PARTPARRYMITPRATPCAPR" then
										if SN > "PARTPARRYMITPRATPC" then
											if SN == "PARTPARRYMITPRATPCAP" then
												return CalcStat("PartMitPRatPCap",L);
											else
												return 0;
											end
										elseif SN == "PARTPARRYMITPRATPC" then
											return CalcStat("PartMitPRatPC",L);
										else
											return 0;
										end
									elseif SN > "PARTPARRYMITPRATPCAPR" then
										if SN < "PARTPARRYPPRAT" then
											if SN == "PARTPARRYPBONUS" then
												return CalcStat("PartBPEPBonus",L);
											else
												return 0;
											end
										elseif SN > "PARTPARRYPPRAT" then
											if SN == "PARTPARRYPRATP" then
												return CalcStat("PartBPEPRatP",L,N);
											else
												return 0;
											end
										else
											return CalcStat("PartBPEPPRat",L,N);
										end
									else
										return CalcStat("PartMitPRatPCapR",L);
									end
								elseif SN > "PARTPARRYPRATPA" then
									if SN < "PARTPARRYPRATPCAPR" then
										if SN < "PARTPARRYPRATPC" then
											if SN == "PARTPARRYPRATPB" then
												return CalcStat("PartBPEPRatPB",L);
											else
												return 0;
											end
										elseif SN > "PARTPARRYPRATPC" then
											if SN == "PARTPARRYPRATPCAP" then
												return CalcStat("PartBPEPRatPCap",L);
											else
												return 0;
											end
										else
											return CalcStat("PartBPEPRatPC",L);
										end
									elseif SN > "PARTPARRYPRATPCAPR" then
										if SN < "PERKNCMR" then
											if SN == "PERKMORALE" then
												return DataTableValue({149,215,246,262},L);
											else
												return 0;
											end
										elseif SN > "PERKNCMR" then
											if SN == "PERKNCPR" then
												return CalcStat("FoodNCPRL",L);
											else
												return 0;
											end
										else
											return CalcStat("FoodNCMRL",L);
										end
									else
										return CalcStat("PartBPEPRatPCapR",L);
									end
								else
									return CalcStat("PartBPEPRatPA",L);
								end
							elseif SN > "PERKPHYMIT" then
								if SN < "PHYDMGPRATPB" then
									if SN < "PHYDMGPBONUS" then
										if SN > "PERKPOWER" then
											if SN == "PERKTACMIT" then
												return CalcStat("TacMitT",L,0.2*N);
											else
												return 0;
											end
										elseif SN == "PERKPOWER" then
											return DataTableValue({95,131,146,153},L);
										else
											return 0;
										end
									elseif SN > "PHYDMGPBONUS" then
										if SN < "PHYDMGPRATP" then
											if SN == "PHYDMGPPRAT" then
												return CalcStat("OutDmgPPRat",L,N);
											else
												return 0;
											end
										elseif SN > "PHYDMGPRATP" then
											if SN == "PHYDMGPRATPA" then
												return CalcStat("OutDmgPRatPA",L);
											else
												return 0;
											end
										else
											return CalcStat("OutDmgPRatP",L,N);
										end
									else
										return CalcStat("OutDmgPBonus",L);
									end
								elseif SN > "PHYDMGPRATPB" then
									if SN < "PHYMAS" then
										if SN < "PHYDMGPRATPCAP" then
											if SN == "PHYDMGPRATPC" then
												return CalcStat("OutDmgPRatPC",L);
											else
												return 0;
											end
										elseif SN > "PHYDMGPRATPCAP" then
											if SN == "PHYDMGPRATPCAPR" then
												return CalcStat("OutDmgPRatPCapR",L);
											else
												return 0;
											end
										else
											return CalcStat("OutDmgPRatPCap",L);
										end
									elseif SN > "PHYMAS" then
										if SN < "PHYMAST" then
											if SN == "PHYMASOLD" then
												return CalcStat("Mastery",L,N);
											else
												return 0;
											end
										elseif SN > "PHYMAST" then
											if SN == "PHYMIT" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPPhyMit",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("PhyMitAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("PntMPPhyMit",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("PhyMitAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L);
											else
												return 0;
											end
										else
											return CalcStat("MasteryT",L,N);
										end
									else
										return CalcStat("Mastery",L,N);
									end
								else
									return CalcStat("OutDmgPRatPB",L);
								end
							else
								return CalcStat("PhyMitT",L,0.2*N);
							end
						elseif SN > "PHYMITADJ" then
							if SN < "PHYMITLPRATPCAP" then
								if SN < "PHYMITHPRATPCAP" then
									if SN < "PHYMITHPRATP" then
										if SN > "PHYMITHPBONUS" then
											if SN == "PHYMITHPPRAT" then
												return CalcStat("MitHeavyPPRat",L,N);
											else
												return 0;
											end
										elseif SN == "PHYMITHPBONUS" then
											return CalcStat("MitHeavyPBonus",L);
										else
											return 0;
										end
									elseif SN > "PHYMITHPRATP" then
										if SN < "PHYMITHPRATPB" then
											if SN == "PHYMITHPRATPA" then
												return CalcStat("MitHeavyPRatPA",L);
											else
												return 0;
											end
										elseif SN > "PHYMITHPRATPB" then
											if SN == "PHYMITHPRATPC" then
												return CalcStat("MitHeavyPRatPC",L);
											else
												return 0;
											end
										else
											return CalcStat("MitHeavyPRatPB",L);
										end
									else
										return CalcStat("MitHeavyPRatP",L,N);
									end
								elseif SN > "PHYMITHPRATPCAP" then
									if SN < "PHYMITLPRATP" then
										if SN < "PHYMITLPBONUS" then
											if SN == "PHYMITHPRATPCAPR" then
												return CalcStat("MitHeavyPRatPCapR",L);
											else
												return 0;
											end
										elseif SN > "PHYMITLPBONUS" then
											if SN == "PHYMITLPPRAT" then
												return CalcStat("MitLightPPRat",L,N);
											else
												return 0;
											end
										else
											return CalcStat("MitLightPBonus",L);
										end
									elseif SN > "PHYMITLPRATP" then
										if SN < "PHYMITLPRATPB" then
											if SN == "PHYMITLPRATPA" then
												return CalcStat("MitLightPRatPA",L);
											else
												return 0;
											end
										elseif SN > "PHYMITLPRATPB" then
											if SN == "PHYMITLPRATPC" then
												return CalcStat("MitLightPRatPC",L);
											else
												return 0;
											end
										else
											return CalcStat("MitLightPRatPB",L);
										end
									else
										return CalcStat("MitLightPRatP",L,N);
									end
								else
									return CalcStat("MitHeavyPRatPCap",L);
								end
							elseif SN > "PHYMITLPRATPCAP" then
								if SN < "PHYMITMPRATPCAP" then
									if SN < "PHYMITMPRATP" then
										if SN < "PHYMITMPBONUS" then
											if SN == "PHYMITLPRATPCAPR" then
												return CalcStat("MitLightPRatPCapR",L);
											else
												return 0;
											end
										elseif SN > "PHYMITMPBONUS" then
											if SN == "PHYMITMPPRAT" then
												return CalcStat("MitMediumPPRat",L,N);
											else
												return 0;
											end
										else
											return CalcStat("MitMediumPBonus",L);
										end
									elseif SN > "PHYMITMPRATP" then
										if SN < "PHYMITMPRATPB" then
											if SN == "PHYMITMPRATPA" then
												return CalcStat("MitMediumPRatPA",L);
											else
												return 0;
											end
										elseif SN > "PHYMITMPRATPB" then
											if SN == "PHYMITMPRATPC" then
												return CalcStat("MitMediumPRatPC",L);
											else
												return 0;
											end
										else
											return CalcStat("MitMediumPRatPB",L);
										end
									else
										return CalcStat("MitMediumPRatP",L,N);
									end
								elseif SN > "PHYMITMPRATPCAP" then
									if SN < "PHYRESISTT" then
										if SN < "PHYMITT" then
											if SN == "PHYMITMPRATPCAPR" then
												return CalcStat("MitMediumPRatPCapR",L);
											else
												return 0;
											end
										elseif SN > "PHYMITT" then
											if SN == "PHYMITTADJ" then
												if Lm <= 130 then
													return CalcStat("AdjTraitProgRatings",L);
												elseif Lm <= 131 then
													return 70/90;
												else
													return 60/90;
												end
											else
												return 0;
											end
										else
											return LinFmod(1,LotroDbl(CalcStat("PntMPPhyMit",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("PhyMitTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPPhyMit",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("PhyMitTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
										end
									elseif SN > "PHYRESISTT" then
										if SN < "PNTMPCRITHIT" then
											if SN == "PNTMPARMOUR" then
												return 24375/247000;
											else
												return 0;
											end
										elseif SN > "PNTMPCRITHIT" then
											if SN == "PNTMPDMGTYPEMIT" then
												return 39000/247000;
											else
												return 0;
											end
										else
											return 12597/247000;
										end
									else
										return CalcStat("ResistAddT",L,N);
									end
								else
									return CalcStat("MitMediumPRatPCap",L);
								end
							else
								return CalcStat("MitLightPRatPCap",L);
							end
						else
							if Lm <= 80 then
								return CalcStat("AdjItemProgRatings",L);
							elseif Lm <= 399 then
								return 1;
							elseif Lm <= 449 then
								return 0.9;
							elseif Lm <= 450 then
								return 83/90;
							else
								return 60/90;
							end
						end
					elseif SN > "PNTMPICMR" then
						if SN < "PROGBMITHEAVY" then
							if SN < "POWER" then
								if SN < "PNTMPNCPR" then
									if SN < "PNTMPMASTERY" then
										if SN > "PNTMPICPR" then
											if SN == "PNTMPMAIN" then
												return 6669/247000;
											else
												return 0;
											end
										elseif SN == "PNTMPICPR" then
											return 3087.5/247000;
										else
											return 0;
										end
									elseif SN > "PNTMPMASTERY" then
										if SN < "PNTMPMORALE" then
											if SN == "PNTMPMITIGATION" then
												return 17550/247000;
											else
												return 0;
											end
										elseif SN > "PNTMPMORALE" then
											if SN == "PNTMPNCMR" then
												return 24700/247000;
											else
												return 0;
											end
										else
											return 7600/247000;
										end
									else
										return 8892/247000;
									end
								elseif SN > "PNTMPNCPR" then
									if SN < "PNTMPRATINGS" then
										if SN < "PNTMPPOWER" then
											if SN == "PNTMPPHYMIT" then
												return 29250/247000;
											else
												return 0;
											end
										elseif SN > "PNTMPPOWER" then
											if SN == "PNTMPRATADD" then
												return 23267.4/247000;
											else
												return 0;
											end
										else
											return 12350/247000;
										end
									elseif SN > "PNTMPRATINGS" then
										if SN < "PNTMPVITALITY" then
											if SN == "PNTMPTACMIT" then
												return 21450/247000;
											else
												return 0;
											end
										elseif SN > "PNTMPVITALITY" then
											if SN == "POISONRESISTT" then
												return CalcStat("ResistAddT",L,N);
											else
												return 0;
											end
										else
											return 30875/247000;
										end
									else
										return 14820/247000;
									end
								else
									return 12350/247000;
								end
							elseif SN > "POWER" then
								if SN < "PROGBHIGHNEW" then
									if SN < "POWERTADJ" then
										if SN > "POWERADJ" then
											if SN == "POWERT" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPPower",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBPower",L))*CalcStat("PowerTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPPower",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBPower",L))*CalcStat("PowerTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
											else
												return 0;
											end
										elseif SN == "POWERADJ" then
											return CalcStat("AdjItemProgPower",L);
										else
											return 0;
										end
									elseif SN > "POWERTADJ" then
										if SN < "PROGBDEFENCENEW" then
											if SN == "PROGBDEFENCE" then
												return 266;
											else
												return 0;
											end
										elseif SN > "PROGBDEFENCENEW" then
											if SN == "PROGBHIGH" then
												return 500;
											else
												return 0;
											end
										else
											return 532;
										end
									else
										return CalcStat("AdjTraitProgPower",L);
									end
								elseif SN > "PROGBHIGHNEW" then
									if SN < "PROGBMASTERY" then
										if SN < "PROGBLOWNEW" then
											if SN == "PROGBLOW" then
												return 200;
											else
												return 0;
											end
										elseif SN > "PROGBLOWNEW" then
											if SN == "PROGBMAIN" then
												return 40;
											else
												return 0;
											end
										else
											return 400;
										end
									elseif SN > "PROGBMASTERY" then
										if SN < "PROGBMEDIUM" then
											if SN == "PROGBMASTERYNEW" then
												return 540;
											else
												return 0;
											end
										elseif SN > "PROGBMEDIUM" then
											if SN == "PROGBMEDIUMNEW" then
												return 800;
											else
												return 0;
											end
										else
											return 400;
										end
									else
										return 270;
									end
								else
									return 10000/6;
								end
							else
								return LinFmod(1,LotroDbl(CalcStat("PntMPPower",L)*CalcStat("ItemHighProgVPL",L,CalcStat("ProgBPower",L))*CalcStat("PowerAdj",CalcStat("ItemHighProgLPL",L))*N),LotroDbl(CalcStat("PntMPPower",L)*CalcStat("ItemHighProgVPH",L,CalcStat("ProgBPower",L))*CalcStat("PowerAdj",CalcStat("ItemHighProgLPH",L))*N),CalcStat("ItemHighProgLPL",L),CalcStat("ItemHighProgLPH",L),L);
							end
						elseif SN > "PROGBMITHEAVY" then
							if SN < "PROGEXTCOMHIGHRND" then
								if SN < "PROGBMORALE" then
									if SN < "PROGBMITLIGHT" then
										if SN > "PROGBMITHEAVYNEW" then
											if SN == "PROGBMITIGATION" then
												return CalcStat("ProgBMitMedium",L);
											else
												return 0;
											end
										elseif SN == "PROGBMITHEAVYNEW" then
											return 401.6;
										else
											return 0;
										end
									elseif SN > "PROGBMITLIGHT" then
										if SN < "PROGBMITMEDIUM" then
											if SN == "PROGBMITLIGHTNEW" then
												return 800/3;
											else
												return 0;
											end
										elseif SN > "PROGBMITMEDIUM" then
											if SN == "PROGBMITMEDIUMNEW" then
												return 7040/21;
											else
												return 0;
											end
										else
											return 382/3;
										end
									else
										return 280/3;
									end
								elseif SN > "PROGBMORALE" then
									if SN < "PROGBPOWER" then
										if SN < "PROGBPARTIAL" then
											if SN == "PROGBMORREG" then
												return 10;
											else
												return 0;
											end
										elseif SN > "PROGBPARTIAL" then
											if SN == "PROGBPARTIALNEW" then
												return 500;
											else
												return 0;
											end
										else
											return 350;
										end
									elseif SN > "PROGBPOWER" then
										if SN < "PROGBVITALITY" then
											if SN == "PROGBPOWREG" then
												return 20;
											else
												return 0;
											end
										elseif SN > "PROGBVITALITY" then
											if SN == "PROGEXTCOMHIGHRAW" then
												if Lm <= 121 then
													return ExpFmod(N,121,20,L,nil);
												elseif Lm <= 125 then
													return ExpFmod(CalcStat("ProgExtComHighRaw",121,N),122,5.5,L,nil);
												elseif Lm <= 126 then
													return ExpFmod(CalcStat("ProgExtComHighRaw",125,N),126,20,L,nil);
												elseif Lm <= 130 then
													return ExpFmod(CalcStat("ProgExtComHighRaw",126,N),127,5.5,L,nil);
												elseif Lm <= 131 then
													return ExpFmod(CalcStat("ProgExtComHighRaw",130,N),131,20,L,nil);
												elseif Lm <= 140 then
													return ExpFmod(CalcStat("ProgExtComHighRaw",131,N),132,5.5,L,nil);
												else
													return CalcStat("ProgExtComHighRaw",140,N);
												end
											else
												return 0;
											end
										else
											return 10;
										end
									else
										return 20;
									end
								else
									return 130;
								end
							elseif SN > "PROGEXTCOMHIGHRND" then
								if SN < "PROGEXTLOWEXPRAW" then
									if SN < "PROGEXTHIGHEXPRND" then
										if SN < "PROGEXTCOMLOWRND" then
											if SN == "PROGEXTCOMLOWRAW" then
												if Lm <= 116 then
													return ExpFmod(N,116,20,L,nil);
												elseif Lm <= 120 then
													return ExpFmod(CalcStat("ProgExtComLowRaw",116,N),117,5.5,L,nil);
												else
													return CalcStat("ProgExtComHighRaw",L,CalcStat("ProgExtComLowRaw",120,N));
												end
											else
												return 0;
											end
										elseif SN > "PROGEXTCOMLOWRND" then
											if SN == "PROGEXTHIGHEXPRAW" then
												if Lm <= 106 then
													return ExpFmod(N,106,20,L,nil);
												elseif Lm <= 115 then
													return ExpFmod(CalcStat("ProgExtHighExpRaw",106,N),107,5.5,L,nil);
												else
													return CalcStat("ProgExtComLowRaw",L,CalcStat("ProgExtHighExpRaw",115,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 116 then
												return ExpFmod(N,116,20,L,0);
											elseif Lm <= 120 then
												return ExpFmod(CalcStat("ProgExtComLowRnd",116,N),117,5.5,L,0);
											else
												return CalcStat("ProgExtComHighRnd",L,CalcStat("ProgExtComLowRnd",120,N));
											end
										end
									elseif SN > "PROGEXTHIGHEXPRND" then
										if SN < "PROGEXTHIGHLINEXPRAW" then
											if SN == "PROGEXTHIGHLINEXPDECA" then
												if Lm <= 115 then
													return LinFmod(N,2,4,106,115,L,-1);
												else
													return CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtHighLinExpDeca",115,N)/10)*10;
												end
											else
												return 0;
											end
										elseif SN > "PROGEXTHIGHLINEXPRAW" then
											if SN == "PROGEXTHIGHLINEXPRND" then
												if Lm <= 115 then
													return LinFmod(N,2,4,106,115,L,-1);
												else
													return CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtHighLinExpRnd",115,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 115 then
												return LinFmod(N,2,4,106,115,L,-1);
											else
												return CalcStat("ProgExtComLowRaw",L,CalcStat("ProgExtHighLinExpRaw",115,N));
											end
										end
									else
										if Lm <= 106 then
											return ExpFmod(N,106,20,L,0);
										elseif Lm <= 115 then
											return ExpFmod(CalcStat("ProgExtHighExpRnd",106,N),107,5.5,L,0);
										else
											return CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtHighExpRnd",115,N));
										end
									end
								elseif SN > "PROGEXTLOWEXPRAW" then
									if SN < "PROGEXTMPEXPRAW" then
										if SN < "PROGEXTLOWLINEXPRAW" then
											if SN == "PROGEXTLOWEXPRND" then
												if Lm <= 115 then
													return ExpFmod(N,106,5.5,L,0);
												else
													return CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtLowExpRnd",115,N));
												end
											else
												return 0;
											end
										elseif SN > "PROGEXTLOWLINEXPRAW" then
											if SN == "PROGEXTLOWLINEXPRND" then
												if Lm <= 115 then
													return LinFmod(N,1.25,1.5,106,115,L,-1);
												else
													return CalcStat("ProgExtComLowRnd",L,CalcStat("ProgExtLowLinExpRnd",115,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 115 then
												return LinFmod(N,1.25,1.5,106,115,L,-1);
											else
												return CalcStat("ProgExtComLowRaw",L,CalcStat("ProgExtLowLinExpRaw",115,N));
											end
										end
									elseif SN > "PROGEXTMPEXPRAW" then
										if SN < "RELAGILITY" then
											if SN == "PROGEXTMPEXPRND" then
												if Lm <= 114 then
													return ExpFmod(N,106,7.5,L,0);
												elseif Lm <= 115 then
													return 2*N;
												elseif Lm <= 119 then
													return ExpFmod(CalcStat("ProgExtMpExpRnd",115,N),116,25,L,0);
												elseif Lm <= 120 then
													return RoundDbl((16/3)*N);
												else
													return CalcStat("ProgExtComHighRnd",L,CalcStat("ProgExtMpExpRnd",120,N));
												end
											else
												return 0;
											end
										elseif SN > "RELAGILITY" then
											if SN == "RELAVOID" then
												if Lm <= 105 then
													return RoundDbl(8.08*L*N);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("RelAvoid",105,N));
												end
											else
												return 0;
											end
										else
											return CalcStat("RelMain",L,N);
										end
									else
										if Lm <= 114 then
											return ExpFmod(N,106,7.5,L,nil);
										elseif Lm <= 115 then
											return 2*N;
										elseif Lm <= 119 then
											return ExpFmod(CalcStat("ProgExtMpExpRaw",115,N),116,25,L,nil);
										elseif Lm <= 120 then
											return (16/3)*N;
										else
											return CalcStat("ProgExtComHighRaw",L,CalcStat("ProgExtMpExpRaw",120,N));
										end
									end
								else
									if Lm <= 115 then
										return ExpFmod(N,106,5.5,L,nil);
									else
										return CalcStat("ProgExtComLowRaw",L,CalcStat("ProgExtLowExpRaw",115,N));
									end
								end
							else
								if Lm <= 121 then
									return ExpFmod(N,121,20,L,0);
								elseif Lm <= 125 then
									return ExpFmod(CalcStat("ProgExtComHighRnd",121,N),122,5.5,L,0);
								elseif Lm <= 126 then
									return ExpFmod(CalcStat("ProgExtComHighRnd",125,N),126,20,L,0);
								elseif Lm <= 130 then
									return ExpFmod(CalcStat("ProgExtComHighRnd",126,N),127,5.5,L,0);
								elseif Lm <= 131 then
									return ExpFmod(CalcStat("ProgExtComHighRnd",130,N),131,20,L,0);
								elseif Lm <= 140 then
									return ExpFmod(CalcStat("ProgExtComHighRnd",131,N),132,5.5,L,0);
								else
									return CalcStat("ProgExtComHighRnd",140,N);
								end
							end
						else
							return 174;
						end
					else
						return 2470/247000;
					end
				else
					return CalcStat("PartMitPRatPB",L);
				end
			elseif SN > "RELBLOCK" then
				if SN < "STDMORALERAW" then
					if SN < "RUNECOMBATMODSEL" then
						if SN < "REPMAINH" then
							if SN < "RELPARRY" then
								if SN < "RELICPR" then
									if SN < "RELEVADE" then
										if SN > "RELCRITDEF" then
											if SN == "RELCRITHIT" then
												if Lm <= 105 then
													return RoundDbl(8.08*L*N);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("RelCritHit",105,N));
												end
											else
												return 0;
											end
										elseif SN == "RELCRITDEF" then
											if Lm <= 105 then
												return RoundDbl(8.08*L*N);
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("RelCritDef",105,N));
											end
										else
											return 0;
										end
									elseif SN > "RELEVADE" then
										if SN < "RELICMR" then
											if SN == "RELFATE" then
												return CalcStat("RelMain",L,N);
											else
												return 0;
											end
										elseif SN > "RELICMR" then
											if SN == "RELICMRRAW" then
												if Lm <= 49 then
													return CalcStat("RelICPRRaw",50,N);
												elseif Lm <= 105 then
													return ((13/300)*L-260/300)*N;
												else
													return CalcStat("ProgExtHighExpRaw",L,CalcStat("RelICMRRaw",105,N));
												end
											else
												return 0;
											end
										else
											return CalcStat("RelICMRRaw",L,N)*60;
										end
									else
										return CalcStat("RelAvoid",L,N);
									end
								elseif SN > "RELICPR" then
									if SN < "RELMASTERY" then
										if SN < "RELINHEAL" then
											if SN == "RELICPRRAW" then
												if Lm <= 49 then
													return CalcStat("RelICPRRaw",50,N);
												elseif Lm <= 105 then
													return ((12/300)*L-225/300)*N;
												else
													return CalcStat("ProgExtHighExpRaw",L,CalcStat("RelICPRRaw",105,N));
												end
											else
												return 0;
											end
										elseif SN > "RELINHEAL" then
											if SN == "RELMAIN" then
												if Lm <= 49 then
													return CalcStat("RelMain",50,N);
												elseif Lm <= 105 then
													return RoundDbl((0.5*L-10.25)*N);
												else
													return CalcStat("ProgExtHighExpRnd",L,CalcStat("RelMain",105,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(8.08*L*N);
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("RelInHeal",105,N));
											end
										end
									elseif SN > "RELMASTERY" then
										if SN < "RELMITIGATION" then
											if SN == "RELMIGHT" then
												return CalcStat("RelMain",L,N);
											else
												return 0;
											end
										elseif SN > "RELMITIGATION" then
											if SN == "RELMORALE" then
												if Lm <= 49 then
													return CalcStat("RelMorale",50,N);
												elseif Lm <= 105 then
													return RoundDbl(((20/3)*L-611/3)*N);
												else
													return CalcStat("ProgExtHighExpRnd",L,CalcStat("RelMorale",105,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(3.03*L*N);
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("RelMitigation",105,N));
											end
										end
									else
										if Lm <= 105 then
											return RoundDbl(8.08*L*N);
										else
											return CalcStat("ProgExtLowLinExpRnd",L,CalcStat("RelMastery",105,N));
										end
									end
								else
									return CalcStat("RelICPRRaw",L,N)*60;
								end
							elseif SN > "RELPARRY" then
								if SN < "RELWILL" then
									if SN < "RELPOWER" then
										if SN > "RELPHYMAS" then
											if SN == "RELPHYMIT" then
												return CalcStat("RelMitigation",L,N);
											else
												return 0;
											end
										elseif SN == "RELPHYMAS" then
											return CalcStat("RelMastery",L,N);
										else
											return 0;
										end
									elseif SN > "RELPOWER" then
										if SN < "RELTACMIT" then
											if SN == "RELTACMAS" then
												return CalcStat("RelMastery",L,N);
											else
												return 0;
											end
										elseif SN > "RELTACMIT" then
											if SN == "RELVITALITY" then
												return CalcStat("RelMain",L,N);
											else
												return 0;
											end
										else
											return CalcStat("RelMitigation",L,N);
										end
									else
										if Lm <= 49 then
											return CalcStat("RelPower",50,N);
										elseif Lm <= 105 then
											return RoundDbl(((20/3)*L-671/3)*N);
										else
											return CalcStat("ProgExtHighExpRnd",L,CalcStat("RelPower",105,N));
										end
									end
								elseif SN > "RELWILL" then
									if SN < "REPCRITHIT" then
										if SN < "REPAGILITYL" then
											if SN == "REPAGILITYH" then
												return CalcStat("RepMainH",L);
											else
												return 0;
											end
										elseif SN > "REPAGILITYL" then
											if SN == "REPCRITDEF" then
												if Lm <= 50 then
													return LinFmod(1,900,1488,1,50,L);
												elseif Lm <= 85 then
													return LinFmod(1,1488,1908,50,85,L);
												elseif Lm <= 105 then
													return LinFmod(1,1908,2148,85,105,L);
												else
													return LinFmod(1,2148,2328,105,120,L);
												end
											else
												return 0;
											end
										else
											return CalcStat("RepMainL",L);
										end
									elseif SN > "REPCRITHIT" then
										if SN < "REPFATEL" then
											if SN == "REPFATEH" then
												return CalcStat("RepMainH",L);
											else
												return 0;
											end
										elseif SN > "REPFATEL" then
											if SN == "REPFINESSE" then
												if Lm <= 50 then
													return LinFmod(1,322,557,1,50,L);
												elseif Lm <= 85 then
													return LinFmod(1,557,749.9477,50,85,L);
												elseif Lm <= 105 then
													return LinFmod(1,749.9477,859.1634,85,105,L);
												else
													return LinFmod(1,859.1634,939.2549,105,120,L);
												end
											else
												return 0;
											end
										else
											return CalcStat("RepMainL",L);
										end
									else
										if Lm <= 50 then
											return LinFmod(1,300,496,1,50,L);
										elseif Lm <= 85 then
											return LinFmod(1,496,636,50,85,L);
										elseif Lm <= 105 then
											return LinFmod(1,636,716,85,105,L);
										else
											return LinFmod(1,716,776,105,120,L);
										end
									end
								else
									return CalcStat("RelMain",L,N);
								end
							else
								return CalcStat("RelAvoid",L,N);
							end
						elseif SN > "REPMAINH" then
							if SN < "RESISTPBONUS" then
								if SN < "REPVITALITYH" then
									if SN < "REPMIGHTL" then
										if SN > "REPMAINL" then
											if SN == "REPMIGHTH" then
												return CalcStat("RepMainH",L);
											else
												return 0;
											end
										elseif SN == "REPMAINL" then
											if Lm <= 50 then
												return FloorDbl(LinFmod(1,53,102,1,50,L));
											elseif Lm <= 85 then
												return FloorDbl(LinFmod(1,102,137,50,85,L));
											elseif Lm <= 105 then
												return FloorDbl(LinFmod(1,137,157,85,105,L));
											else
												return FloorDbl(LinFmod(1,157,172,105,120,L));
											end
										else
											return 0;
										end
									elseif SN > "REPMIGHTL" then
										if SN < "REPPOWER" then
											if SN == "REPMORALE" then
												if Lm <= 50 then
													return LinFmod(1,187,427,1,50,L);
												elseif Lm <= 85 then
													return LinFmod(1,427,599,50,85,L);
												elseif Lm <= 105 then
													return LinFmod(1,599,697,85,105,L);
												else
													return LinFmod(1,697,770,105,120,L);
												end
											else
												return 0;
											end
										elseif SN > "REPPOWER" then
											if SN == "REPTACMIT" then
												if Lm <= 50 then
													return LinFmod(1,675,1116,1,50,L);
												elseif Lm <= 85 then
													return LinFmod(1,1116,1431,50,85,L);
												elseif Lm <= 105 then
													return LinFmod(1,1431,1611,85,105,L);
												else
													return LinFmod(1,1611,1746,105,120,L);
												end
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return LinFmod(1,94,212,1,50,L);
											elseif Lm <= 85 then
												return LinFmod(1,212,296,50,85,L);
											elseif Lm <= 105 then
												return LinFmod(1,296,344,85,105,L);
											else
												return LinFmod(1,344,380,105,120,L);
											end
										end
									else
										return CalcStat("RepMainL",L);
									end
								elseif SN > "REPVITALITYH" then
									if SN < "RESIST" then
										if SN < "REPWILLH" then
											if SN == "REPVITALITYL" then
												return CalcStat("RepMainL",L);
											else
												return 0;
											end
										elseif SN > "REPWILLH" then
											if SN == "REPWILLL" then
												return CalcStat("RepMainL",L);
											else
												return 0;
											end
										else
											return CalcStat("RepMainH",L);
										end
									elseif SN > "RESIST" then
										if SN < "RESISTADDTADJ" then
											if SN == "RESISTADDT" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPRatAdd",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("ResistAddTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatAdd",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("ResistAddTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
											else
												return 0;
											end
										elseif SN > "RESISTADDTADJ" then
											if SN == "RESISTADJ" then
												if Lm <= 449 then
													return CalcStat("AdjItemProgRatings",L);
												elseif Lm <= 450 then
													return 1;
												else
													return 40/30;
												end
											else
												return 0;
											end
										else
											if Lm <= 121 then
												return CalcStat("AdjTraitProgRatings",L);
											elseif Lm <= 130 then
												return 1;
											elseif Lm <= 131 then
												return 11/9.0;
											else
												return 12/9.0;
											end
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("ResistAdj",CalcStat("ItemMedProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("ItemMedProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("ResistAdj",CalcStat("ItemMedProgAltLPH",L))*N),CalcStat("ItemMedProgAltLPL",L),CalcStat("ItemMedProgAltLPH",L),L);
									end
								else
									return CalcStat("RepMainH",L);
								end
							elseif SN > "RESISTPBONUS" then
								if SN < "RESISTT" then
									if SN < "RESISTPRATPB" then
										if SN < "RESISTPRATP" then
											if SN == "RESISTPPRAT" then
												return CalcRatAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCapR",L),N);
											else
												return 0;
											end
										elseif SN > "RESISTPRATP" then
											if SN == "RESISTPRATPA" then
												if Lm <= 130 then
													return 100;
												else
													return 150;
												end
											else
												return 0;
											end
										else
											return CalcPercAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCap",L),N);
										end
									elseif SN > "RESISTPRATPB" then
										if SN < "RESISTPRATPCAP" then
											if SN == "RESISTPRATPC" then
												if Lm <= 130 then
													return 1;
												else
													return 0.5;
												end
											else
												return 0;
											end
										elseif SN > "RESISTPRATPCAP" then
											if SN == "RESISTPRATPCAPR" then
												return CalcStat("ResistPRatPB",L)*CalcStat("ResistPRatPC",L);
											else
												return 0;
											end
										else
											return 50;
										end
									else
										if Lm <= 130 then
											return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
										else
											return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
										end
									end
								elseif SN > "RESISTT" then
									if SN < "RKFORTUNESMILESFATE" then
										if SN < "REVERSE" then
											if SN == "RESISTTADJ" then
												if Lm <= 130 then
													return CalcStat("AdjTraitProgRatings",L);
												elseif Lm <= 131 then
													return 11/9.0;
												else
													return 12/9.0;
												end
											else
												return 0;
											end
										elseif SN > "REVERSE" then
											if SN == "RKDETERMINATIONWILL" then
												return CalcStat("WillT",L,CalcStat("Trait567810Choice",N)*0.4);
											else
												return 0;
											end
										else
											return ReverseCalc(C,L);
										end
									elseif SN > "RKFORTUNESMILESFATE" then
										if SN < "RUNECOMBATMODBASE" then
											if SN == "RUNECOMBATMOD" then
												return CalcStat("RuneCombatModSel",N,L);
											else
												return 0;
											end
										elseif SN > "RUNECOMBATMODBASE" then
											if SN == "RUNECOMBATMODPHYDPS" then
												return CalcStat("RuneCombatModBase",L);
											else
												return 0;
											end
										else
											if Lm <= 281 then
												return RoundDbl(LinFmod(1,RoundDbl(N*1),RoundDbl(N*93),1,281,L));
											elseif Lm <= 299 then
												return RoundDbl(LinFmod(1,RoundDbl(N*93),RoundDbl(N*98),282,299,L));
											elseif Lm <= 349 then
												return RoundDbl(LinFmod(1,RoundDbl(N*108),RoundDbl(N*176),300,349,L));
											elseif Lm <= 399 then
												return RoundDbl(LinFmod(1,RoundDbl(N*178),RoundDbl(N*287),350,399,L));
											elseif Lm <= 449 then
												return RoundDbl(LinFmod(1,RoundDbl(N*288),RoundDbl(N*480),400,449,L));
											elseif Lm <= 499 then
												return RoundDbl(LinFmod(1,RoundDbl(N*484),RoundDbl(N*800),450,499,L));
											else
												return RoundDbl(LinFmod(1,RoundDbl(N*816),RoundDbl(N*(4000/3)),500,549,L));
											end
										end
									else
										return CalcStat("FateT",L,CalcStat("Trait567810Choice",N)*0.4);
									end
								else
									return LinFmod(1,LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPL",L,CalcStat("ProgBLow",L))*CalcStat("ResistTAdj",CalcStat("TraitProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPRatings",L)*CalcStat("TraitProgAltVPH",L,CalcStat("ProgBLow",L))*CalcStat("ResistTAdj",CalcStat("TraitProgAltLPH",L))*N),CalcStat("TraitProgAltLPL",L),CalcStat("TraitProgAltLPH",L),L);
								end
							else
								return 0;
							end
						else
							if Lm <= 50 then
								return FloorDbl(LinFmod(1,80,153,1,50,L));
							elseif Lm <= 85 then
								return FloorDbl(LinFmod(1,153,206,50,85,L));
							elseif Lm <= 105 then
								return FloorDbl(LinFmod(1,206,236,85,105,L));
							else
								return FloorDbl(LinFmod(1,236,258,105,120,L));
							end
						end
					elseif SN > "RUNECOMBATMODSEL" then
						if SN < "RUNEKEEPERCDPHYMITTOOFMIT" then
							if SN < "RUNEKEEPERCDBASEMORALE" then
								if SN < "RUNEKEEPERCDARMOURTOPHYMIT" then
									if SN < "RUNEKEEPERCDAGILITYTOCRITHIT" then
										if SN > "RUNECOMBATMODTACDPS" then
											if SN == "RUNECOMBATMODTACHPS" then
												if Lm <= 449 then
													return CalcStat("RuneCombatModBase",L,0.5);
												elseif Lm <= 499 then
													return RoundDbl(LinFmod(1,245,260,450,499,L));
												else
													return RoundDbl(LinFmod(1,270,1300/3,500,549,L));
												end
											else
												return 0;
											end
										elseif SN == "RUNECOMBATMODTACDPS" then
											return CalcStat("RuneCombatModBase",L,0.75);
										else
											return 0;
										end
									elseif SN > "RUNEKEEPERCDAGILITYTOCRITHIT" then
										if SN < "RUNEKEEPERCDAGILITYTOPARRY" then
											if SN == "RUNEKEEPERCDAGILITYTOEVADE" then
												return 3;
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDAGILITYTOPARRY" then
											if SN == "RUNEKEEPERCDARMOURTOOFMIT" then
												return 0.2;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 1;
									end
								elseif SN > "RUNEKEEPERCDARMOURTOPHYMIT" then
									if SN < "RUNEKEEPERCDBASEFATE" then
										if SN < "RUNEKEEPERCDARMOURTYPE" then
											if SN == "RUNEKEEPERCDARMOURTOTACMIT" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDARMOURTYPE" then
											if SN == "RUNEKEEPERCDBASEAGILITY" then
												return CalcStat("ClassBaseMainG",L);
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "RUNEKEEPERCDBASEFATE" then
										if SN < "RUNEKEEPERCDBASEICPR" then
											if SN == "RUNEKEEPERCDBASEICMR" then
												return CalcStat("ClassBaseICMRL",L);
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDBASEICPR" then
											if SN == "RUNEKEEPERCDBASEMIGHT" then
												return CalcStat("ClassBaseMainB",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseICPR",L);
										end
									else
										return CalcStat("ClassBaseMainK",L);
									end
								else
									return 1;
								end
							elseif SN > "RUNEKEEPERCDBASEMORALE" then
								if SN < "RUNEKEEPERCDFATETOICMR" then
									if SN < "RUNEKEEPERCDBASEPOWER" then
										if SN > "RUNEKEEPERCDBASENCMR" then
											if SN == "RUNEKEEPERCDBASENCPR" then
												return CalcStat("ClassBaseNCPR",L);
											else
												return 0;
											end
										elseif SN == "RUNEKEEPERCDBASENCMR" then
											return CalcStat("ClassBaseNCMRL",L);
										else
											return 0;
										end
									elseif SN > "RUNEKEEPERCDBASEPOWER" then
										if SN < "RUNEKEEPERCDBASEWILL" then
											if SN == "RUNEKEEPERCDBASEVITALITY" then
												return CalcStat("ClassBaseMainD",L);
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDBASEWILL" then
											if SN == "RUNEKEEPERCDFATETOCRITHIT" then
												return 2.5;
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainI",L);
										end
									else
										if Lm <= 120 then
											return CalcStat("ClassBasePowerH",L);
										else
											return CalcStat("ClassBasePowerH",120);
										end
									end
								elseif SN > "RUNEKEEPERCDFATETOICMR" then
									if SN < "RUNEKEEPERCDFATETOTACMIT" then
										if SN < "RUNEKEEPERCDFATETONCPR" then
											if SN == "RUNEKEEPERCDFATETOICPR" then
												return 1.71;
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDFATETONCPR" then
											if SN == "RUNEKEEPERCDFATETORESIST" then
												return 1;
											else
												return 0;
											end
										else
											return 24;
										end
									elseif SN > "RUNEKEEPERCDFATETOTACMIT" then
										if SN < "RUNEKEEPERCDMIGHTTOBLOCK" then
											if SN == "RUNEKEEPERCDHASPOWER" then
												return 1;
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDMIGHTTOBLOCK" then
											if SN == "RUNEKEEPERCDMIGHTTOPARRY" then
												return 2;
											else
												return 0;
											end
										else
											return 3;
										end
									else
										return 1;
									end
								else
									return 1.5;
								end
							else
								if Lm <= 120 then
									return CalcStat("ClassBaseMoraleL",L);
								else
									return CalcStat("ClassBaseMoraleL",120);
								end
							end
						elseif SN > "RUNEKEEPERCDPHYMITTOOFMIT" then
							if SN < "SKILLPOWERCOST" then
								if SN < "RUNEKEEPERCDWILLTOFINESSE" then
									if SN < "RUNEKEEPERCDVITALITYTONCMR" then
										if SN > "RUNEKEEPERCDTACMASTOOUTHEAL" then
											if SN == "RUNEKEEPERCDVITALITYTOMORALE" then
												return 4;
											else
												return 0;
											end
										elseif SN == "RUNEKEEPERCDTACMASTOOUTHEAL" then
											return 1;
										else
											return 0;
										end
									elseif SN > "RUNEKEEPERCDVITALITYTONCMR" then
										if SN < "RUNEKEEPERCDVITALITYTOTACMIT" then
											if SN == "RUNEKEEPERCDVITALITYTORESIST" then
												return 1;
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDVITALITYTOTACMIT" then
											if SN == "RUNEKEEPERCDWILLTOEVADE" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 7.2;
									end
								elseif SN > "RUNEKEEPERCDWILLTOFINESSE" then
									if SN < "RUNEKEEPERCDWILLTOTACMIT" then
										if SN < "RUNEKEEPERCDWILLTORESIST" then
											if SN == "RUNEKEEPERCDWILLTOOUTHEAL" then
												return 3;
											else
												return 0;
											end
										elseif SN > "RUNEKEEPERCDWILLTORESIST" then
											if SN == "RUNEKEEPERCDWILLTOTACMAS" then
												return 3;
											else
												return 0;
											end
										else
											return 2;
										end
									elseif SN > "RUNEKEEPERCDWILLTOTACMIT" then
										if SN < "SHADOWMITT" then
											if SN == "SHADOWMIT" then
												return CalcStat("DmgTypeMit",L,N);
											else
												return 0;
											end
										elseif SN > "SHADOWMITT" then
											if SN == "SHIELDBRAWLERBLOCK" then
												return CalcStat("DwarfShieldBrwlBlock",L);
											else
												return 0;
											end
										else
											return CalcStat("DmgTypeMitT",L,N);
										end
									else
										return 1;
									end
								else
									return 1;
								end
							elseif SN > "SKILLPOWERCOST" then
								if SN < "STATPROGALTVPL" then
									if SN < "STATPROGALT" then
										if SN < "STATC" then
											if SN == "SONGRESISTT" then
												return CalcStat("ResistAddT",L,N);
											else
												return 0;
											end
										elseif SN > "STATC" then
											if SN == "STATPROG" then
												if Lm <= 75 then
													return LinFmod(RoundDbl(N),1,75,1,75,L);
												elseif Lm <= 76 then
													return LinFmod(1,RoundDbl(N)*75,CalcStat("StdProg",76,N),75,76,L);
												else
													return CalcStat("StdProg",L,N);
												end
											else
												return 0;
											end
										else
											return CalcStat(C,L);
										end
									elseif SN > "STATPROGALT" then
										if SN < "STATPROGALTLPL" then
											if SN == "STATPROGALTLPH" then
												return CalcStat("StdProgAltLPH",L);
											else
												return 0;
											end
										elseif SN > "STATPROGALTLPL" then
											if SN == "STATPROGALTVPH" then
												return CalcStat("StatProgAlt",CalcStat("StatProgAltLPH",L),N);
											else
												return 0;
											end
										else
											return CalcStat("StdProgAltLPL",L);
										end
									else
										if Lm <= 75 then
											return LinFmod(RoundDbl(N),1,75,1,75,L);
										elseif Lm <= 76 then
											return LinFmod(1,RoundDbl(N)*75,CalcStat("StdProgAlt",76,N),75,76,L);
										else
											return CalcStat("StdProgAlt",L,N);
										end
									end
								elseif SN > "STATPROGALTVPL" then
									if SN < "STATPROGVPL" then
										if SN < "STATPROGLPL" then
											if SN == "STATPROGLPH" then
												return CalcStat("StdProgLPH",L);
											else
												return 0;
											end
										elseif SN > "STATPROGLPL" then
											if SN == "STATPROGVPH" then
												return CalcStat("StatProg",CalcStat("StatProgLPH",L),N);
											else
												return 0;
											end
										else
											return CalcStat("StdProgLPL",L);
										end
									elseif SN > "STATPROGVPL" then
										if SN < "STDMORALEL" then
											if SN == "STDMORALEH" then
												if Lm <= 105 then
													return RoundDbl(2*CalcStat("StdMoraleRaw",L));
												else
													return CalcStat("ProgExtLowExpRnd",L,CalcStat("StdMoraleH",105));
												end
											else
												return 0;
											end
										elseif SN > "STDMORALEL" then
											if SN == "STDMORALEM" then
												if Lm <= 105 then
													return RoundDbl(1.5*CalcStat("StdMoraleRaw",L));
												else
													return CalcStat("ProgExtLowExpRnd",L,CalcStat("StdMoraleM",105));
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(CalcStat("StdMoraleRaw",L));
											else
												return CalcStat("ProgExtLowExpRnd",L,CalcStat("StdMoraleL",105));
											end
										end
									else
										return CalcStat("StatProg",CalcStat("StatProgLPL",L),N);
									end
								else
									return CalcStat("StatProgAlt",CalcStat("StatProgAltLPL",L),N);
								end
							else
								if Lm <= 115 then
									return RoundDbl(N*L);
								elseif Lm <= 120 then
									return ExpFmod(CalcStat("SkillPowerCost",115,N),116,5.5,L,nil);
								else
									return ExpFmod(CalcStat("SkillPowerCost",120,N),121,1,L,nil);
								end
							end
						else
							return 1;
						end
					else
						if Lm <= 0 then
							return 0;
						elseif Lm <= 1 then
							return CalcStat("RuneCombatModTacHPS",N);
						elseif Lm <= 2 then
							return CalcStat("RuneCombatModTacDPS",N);
						elseif Lm <= 3 then
							return CalcStat("RuneCombatModPhyDPS",N);
						elseif Lm <= 4 then
							return CalcStat("RuneCombatModPhyDPS",N);
						else
							return 0;
						end
					end
				elseif SN > "STDMORALERAW" then
					if SN < "TACMITMPRATPC" then
						if SN < "TACDMGPRATPA" then
							if SN < "STOUTAXERDPSVONEVITALITY" then
								if SN < "STDPROGALTLPL" then
									if SN < "STDPOWERRAW" then
										if SN > "STDPOWERH" then
											if SN == "STDPOWERL" then
												if Lm <= 105 then
													return RoundDbl(CalcStat("StdPowerRaw",L));
												else
													return CalcStat("ProgExtLowExpRnd",L,CalcStat("StdPowerL",105));
												end
											else
												return 0;
											end
										elseif SN == "STDPOWERH" then
											if Lm <= 105 then
												return RoundDbl(2*CalcStat("StdPowerRaw",L));
											else
												return CalcStat("ProgExtLowExpRnd",L,CalcStat("StdPowerH",105));
											end
										else
											return 0;
										end
									elseif SN > "STDPOWERRAW" then
										if SN < "STDPROGALT" then
											if SN == "STDPROG" then
												if Lm <= 75 then
													return LinFmod(N,1,75,1,75,L);
												elseif Lm <= 76 then
													return LinFmod(1,N*75,RoundDbl(N*82.5,-2),75,76,L);
												elseif Lm <= 100 then
													return LinFmod(1,RoundDbl(N*82.5,-2),N*150,76,100,L);
												elseif Lm <= 101 then
													return LinFmod(N,150,165,100,101,L);
												elseif Lm <= 105 then
													return LinFmod(N,165,225,101,105,L);
												elseif Lm <= 106 then
													return LinFmod(N,225,270,105,106,L);
												elseif Lm <= 115 then
													return LinFmod(N,270,450,106,115,L);
												elseif Lm <= 116 then
													return LinFmod(N,450,495,115,116,L);
												elseif Lm <= 120 then
													return LinFmod(N,495,1125,116,120,L);
												elseif Lm <= 121 then
													return LinFmod(N,1125,1575,120,121,L);
												elseif Lm <= 130 then
													return LinFmod(N,1575,3150,121,130,L);
												elseif Lm <= 131 then
													return LinFmod(N,3150,3118.5,130,131,L);
												elseif Lm <= 140 then
													return LinFmod(N,3118.5,6237,131,140,L);
												elseif Lm <= 141 then
													return LinFmod(N,6237,7484.4,140,141,L);
												else
													return LinFmod(N,7484.4,12474,141,150,L);
												end
											else
												return 0;
											end
										elseif SN > "STDPROGALT" then
											if SN == "STDPROGALTLPH" then
												return CalcStat("StdProgLPH",L);
											else
												return 0;
											end
										else
											if Lm <= 130 then
												return CalcStat("StdProg",L,N);
											elseif Lm <= 131 then
												return LinFmod(N,3150,3117.5,130,131,L);
											elseif Lm <= 140 then
												return LinFmod(N,3117.5,6235,131,140,L);
											elseif Lm <= 141 then
												return LinFmod(N,6235,7482,140,141,L);
											else
												return LinFmod(N,7482,12470,141,150,L);
											end
										end
									else
										if Lm <= 50 then
											return LinFmod(1,3,91.0375,1,50,L);
										else
											return LinFmod(1,91.0375,421,50,105,L);
										end
									end
								elseif SN > "STDPROGALTLPL" then
									if SN < "STDPROGLPL" then
										if SN < "STDPROGALTVPL" then
											if SN == "STDPROGALTVPH" then
												return CalcStat("StdProgAlt",CalcStat("StdProgAltLPH",L),N);
											else
												return 0;
											end
										elseif SN > "STDPROGALTVPL" then
											if SN == "STDPROGLPH" then
												if Lm <= 75 then
													return 75;
												elseif Lm <= 76 then
													return 76;
												elseif Lm <= 100 then
													return 100;
												elseif Lm <= 101 then
													return 101;
												elseif Lm <= 105 then
													return 105;
												elseif Lm <= 106 then
													return 106;
												elseif Lm <= 115 then
													return 115;
												elseif Lm <= 116 then
													return 116;
												elseif Lm <= 120 then
													return 120;
												elseif Lm <= 121 then
													return 121;
												elseif Lm <= 130 then
													return 130;
												elseif Lm <= 131 then
													return 131;
												elseif Lm <= 140 then
													return 140;
												elseif Lm <= 141 then
													return 141;
												else
													return 150;
												end
											else
												return 0;
											end
										else
											return CalcStat("StdProgAlt",CalcStat("StdProgAltLPL",L),N);
										end
									elseif SN > "STDPROGLPL" then
										if SN < "STDPROGVPL" then
											if SN == "STDPROGVPH" then
												return CalcStat("StdProg",CalcStat("StdProgLPH",L),N);
											else
												return 0;
											end
										elseif SN > "STDPROGVPL" then
											if SN == "STOUTAXERDPSVONENAME" then
												return "Unwritten Destiny";
											else
												return 0;
											end
										else
											return CalcStat("StdProg",CalcStat("StdProgLPL",L),N);
										end
									else
										if Lm <= 75 then
											return 1;
										elseif Lm <= 76 then
											return 75;
										elseif Lm <= 100 then
											return 76;
										elseif Lm <= 101 then
											return 100;
										elseif Lm <= 105 then
											return 101;
										elseif Lm <= 106 then
											return 105;
										elseif Lm <= 115 then
											return 106;
										elseif Lm <= 116 then
											return 115;
										elseif Lm <= 120 then
											return 116;
										elseif Lm <= 121 then
											return 120;
										elseif Lm <= 130 then
											return 121;
										elseif Lm <= 131 then
											return 130;
										elseif Lm <= 140 then
											return 131;
										elseif Lm <= 141 then
											return 140;
										else
											return 141;
										end
									end
								else
									return CalcStat("StdProgLPL",L);
								end
							elseif SN > "STOUTAXERDPSVONEVITALITY" then
								if SN < "STOUTAXERDTRAITWILL" then
									if SN < "STOUTAXERDTRAITFATE" then
										if SN > "STOUTAXERDPSVTWONAME" then
											if SN == "STOUTAXERDTRAITAGILITY" then
												return 5;
											else
												return 0;
											end
										elseif SN == "STOUTAXERDPSVTWONAME" then
											return "";
										else
											return 0;
										end
									elseif SN > "STOUTAXERDTRAITFATE" then
										if SN < "STOUTAXERDTRAITPHYMITP" then
											if SN == "STOUTAXERDTRAITMIGHT" then
												return 15;
											else
												return 0;
											end
										elseif SN > "STOUTAXERDTRAITPHYMITP" then
											if SN == "STOUTAXERDTRAITVITALITY" then
												return 3;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return -10;
									end
								elseif SN > "STOUTAXERDTRAITWILL" then
									if SN < "T2PENRESIST" then
										if SN < "T2PENBPE" then
											if SN == "T2PENARMOUR" then
												return CalcStat("T2penMit",L);
											else
												return 0;
											end
										elseif SN > "T2PENBPE" then
											if SN == "T2PENMIT" then
												if Lm <= 115 then
													return FloorDbl(L*13.5)*-5;
												else
													return CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenMit",115));
												end
											else
												return 0;
											end
										else
											if Lm <= 115 then
												return (-40)*L;
											else
												return CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenBPE",115));
											end
										end
									elseif SN > "T2PENRESIST" then
										if SN < "TACDMGPPRAT" then
											if SN == "TACDMGPBONUS" then
												return CalcStat("OutDmgPBonus",L);
											else
												return 0;
											end
										elseif SN > "TACDMGPPRAT" then
											if SN == "TACDMGPRATP" then
												return CalcStat("OutDmgPRatP",L,N);
											else
												return 0;
											end
										else
											return CalcStat("OutDmgPPRat",L,N);
										end
									else
										if Lm <= 115 then
											return (-90)*L;
										else
											return CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenResist",115));
										end
									end
								else
									return 15;
								end
							else
								return CalcStat("VitalityT",L,1.0);
							end
						elseif SN > "TACDMGPRATPA" then
							if SN < "TACMITHPRATPC" then
								if SN < "TACMAST" then
									if SN < "TACDMGPRATPCAP" then
										if SN > "TACDMGPRATPB" then
											if SN == "TACDMGPRATPC" then
												return CalcStat("OutDmgPRatPC",L);
											else
												return 0;
											end
										elseif SN == "TACDMGPRATPB" then
											return CalcStat("OutDmgPRatPB",L);
										else
											return 0;
										end
									elseif SN > "TACDMGPRATPCAP" then
										if SN < "TACMAS" then
											if SN == "TACDMGPRATPCAPR" then
												return CalcStat("OutDmgPRatPCapR",L);
											else
												return 0;
											end
										elseif SN > "TACMAS" then
											if SN == "TACMASOLD" then
												return CalcStat("Mastery",L,N);
											else
												return 0;
											end
										else
											return CalcStat("Mastery",L,N);
										end
									else
										return CalcStat("OutDmgPRatPCap",L);
									end
								elseif SN > "TACMAST" then
									if SN < "TACMITHPPRAT" then
										if SN < "TACMITADJ" then
											if SN == "TACMIT" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPTacMit",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("TacMitAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("PntMPTacMit",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("TacMitAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L);
											else
												return 0;
											end
										elseif SN > "TACMITADJ" then
											if SN == "TACMITHPBONUS" then
												return CalcStat("MitHeavyPBonus",L);
											else
												return 0;
											end
										else
											if Lm <= 449 then
												return CalcStat("AdjItemProgRatings",L);
											elseif Lm <= 450 then
												return 1;
											elseif Lm <= 499 then
												return 85/90;
											elseif Lm <= 500 then
												return 75/90;
											else
												return 60/90;
											end
										end
									elseif SN > "TACMITHPPRAT" then
										if SN < "TACMITHPRATPA" then
											if SN == "TACMITHPRATP" then
												return CalcStat("MitHeavyPRatP",L,N);
											else
												return 0;
											end
										elseif SN > "TACMITHPRATPA" then
											if SN == "TACMITHPRATPB" then
												return CalcStat("MitHeavyPRatPB",L);
											else
												return 0;
											end
										else
											return CalcStat("MitHeavyPRatPA",L);
										end
									else
										return CalcStat("MitHeavyPPRat",L,N);
									end
								else
									return CalcStat("MasteryT",L,N);
								end
							elseif SN > "TACMITHPRATPC" then
								if SN < "TACMITLPRATPC" then
									if SN < "TACMITLPPRAT" then
										if SN < "TACMITHPRATPCAPR" then
											if SN == "TACMITHPRATPCAP" then
												return CalcStat("MitHeavyPRatPCap",L);
											else
												return 0;
											end
										elseif SN > "TACMITHPRATPCAPR" then
											if SN == "TACMITLPBONUS" then
												return CalcStat("MitLightPBonus",L);
											else
												return 0;
											end
										else
											return CalcStat("MitHeavyPRatPCapR",L);
										end
									elseif SN > "TACMITLPPRAT" then
										if SN < "TACMITLPRATPA" then
											if SN == "TACMITLPRATP" then
												return CalcStat("MitLightPRatP",L,N);
											else
												return 0;
											end
										elseif SN > "TACMITLPRATPA" then
											if SN == "TACMITLPRATPB" then
												return CalcStat("MitLightPRatPB",L);
											else
												return 0;
											end
										else
											return CalcStat("MitLightPRatPA",L);
										end
									else
										return CalcStat("MitLightPPRat",L,N);
									end
								elseif SN > "TACMITLPRATPC" then
									if SN < "TACMITMPPRAT" then
										if SN < "TACMITLPRATPCAPR" then
											if SN == "TACMITLPRATPCAP" then
												return CalcStat("MitLightPRatPCap",L);
											else
												return 0;
											end
										elseif SN > "TACMITLPRATPCAPR" then
											if SN == "TACMITMPBONUS" then
												return CalcStat("MitMediumPBonus",L);
											else
												return 0;
											end
										else
											return CalcStat("MitLightPRatPCapR",L);
										end
									elseif SN > "TACMITMPPRAT" then
										if SN < "TACMITMPRATPA" then
											if SN == "TACMITMPRATP" then
												return CalcStat("MitMediumPRatP",L,N);
											else
												return 0;
											end
										elseif SN > "TACMITMPRATPA" then
											if SN == "TACMITMPRATPB" then
												return CalcStat("MitMediumPRatPB",L);
											else
												return 0;
											end
										else
											return CalcStat("MitMediumPRatPA",L);
										end
									else
										return CalcStat("MitMediumPPRat",L,N);
									end
								else
									return CalcStat("MitLightPRatPC",L);
								end
							else
								return CalcStat("MitHeavyPRatPC",L);
							end
						else
							return CalcStat("OutDmgPRatPA",L);
						end
					elseif SN > "TACMITMPRATPC" then
						if SN < "TOMETOTALMAINDEC" then
							if SN < "TITLOWPHYMITRANK" then
								if SN < "TITBLOCK" then
									if SN < "TACMITT" then
										if SN > "TACMITMPRATPCAP" then
											if SN == "TACMITMPRATPCAPR" then
												return CalcStat("MitMediumPRatPCapR",L);
											else
												return 0;
											end
										elseif SN == "TACMITMPRATPCAP" then
											return CalcStat("MitMediumPRatPCap",L);
										else
											return 0;
										end
									elseif SN > "TACMITT" then
										if SN < "TACRESISTT" then
											if SN == "TACMITTADJ" then
												if Lm <= 121 then
													return 1;
												elseif Lm <= 130 then
													return 0.9;
												elseif Lm <= 131 then
													return 1;
												elseif Lm <= 140 then
													return 80/90;
												elseif Lm <= 141 then
													return 70/90;
												else
													return 60/90;
												end
											else
												return 0;
											end
										elseif SN > "TACRESISTT" then
											if SN == "TITAGILITY" then
												return CalcStat("Agility",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										else
											return CalcStat("ResistAddT",L,N);
										end
									else
										return LinFmod(1,LotroDbl(CalcStat("PntMPTacMit",L)*CalcStat("TraitProgVPL",L,CalcStat("ProgBMitigation",L))*CalcStat("TacMitTAdj",CalcStat("TraitProgLPL",L))*N),LotroDbl(CalcStat("PntMPTacMit",L)*CalcStat("TraitProgVPH",L,CalcStat("ProgBMitigation",L))*CalcStat("TacMitTAdj",CalcStat("TraitProgLPH",L))*N),CalcStat("TraitProgLPL",L),CalcStat("TraitProgLPH",L),L);
									end
								elseif SN > "TITBLOCK" then
									if SN < "TITFATE" then
										if SN < "TITCRITHIT" then
											if SN == "TITCRITDEF" then
												return CalcStat("CritDef",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										elseif SN > "TITCRITHIT" then
											if SN == "TITEVADE" then
												return CalcStat("Evade",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										else
											return CalcStat("CritHit",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
										end
									elseif SN > "TITFATE" then
										if SN < "TITFINESSERANK" then
											if SN == "TITFINESSE" then
												return CalcStat("TitFinesseRank",RomanRankDecode(C));
											else
												return 0;
											end
										elseif SN > "TITFINESSERANK" then
											if SN == "TITLOWPHYMIT" then
												return CalcStat("TitLowPhyMitRank",RomanRankDecode(C));
											else
												return 0;
											end
										else
											if Lm <= 3 then
												return CalcStat("Finesse",CalcStat("TitRnkToILvl",L),0.4);
											else
												return CalcStat("Finesse",CalcStat("TitRnkToILvl",L));
											end
										end
									else
										return CalcStat("Fate",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
									end
								else
									return CalcStat("Block",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
								end
							elseif SN > "TITLOWPHYMITRANK" then
								if SN < "TITTACMAS" then
									if SN < "TITPARRY" then
										if SN < "TITLOWTACMITRANK" then
											if SN == "TITLOWTACMIT" then
												return CalcStat("TitLowTacMitRank",RomanRankDecode(C));
											else
												return 0;
											end
										elseif SN > "TITLOWTACMITRANK" then
											if SN == "TITMIGHT" then
												return CalcStat("Might",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return CalcStat("TacMit",48,0.6);
											elseif Lm <= 2 then
												return CalcStat("TacMit",65,0.8);
											else
												return CalcStat("TacMit",CalcStat("TitRnkToILvl",L-2),L*0.2+0.4);
											end
										end
									elseif SN > "TITPARRY" then
										if SN < "TITPHYMIT" then
											if SN == "TITPHYMAS" then
												return 2*CalcStat("PhyMas",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										elseif SN > "TITPHYMIT" then
											if SN == "TITRNKTOILVL" then
												return DataTableValue({81,178,326,406},L);
											else
												return 0;
											end
										else
											return CalcStat("PhyMit",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
										end
									else
										return CalcStat("Parry",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
									end
								elseif SN > "TITTACMAS" then
									if SN < "TOMEMAIN" then
										if SN < "TITVITALITY" then
											if SN == "TITTACMIT" then
												return CalcStat("TacMit",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										elseif SN > "TITVITALITY" then
											if SN == "TITWILL" then
												return CalcStat("Will",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
											else
												return 0;
											end
										else
											return CalcStat("Vitality",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
										end
									elseif SN > "TOMEMAIN" then
										if SN < "TOMETOTALLEVEL" then
											if SN == "TOMEMAINDEC" then
												return CalcStat("TomeTotalMainDec",L)-CalcStat("TomeTotalMainDec",L-1);
											else
												return 0;
											end
										elseif SN > "TOMETOTALLEVEL" then
											if SN == "TOMETOTALMAIN" then
												return CalcStat("TomeTotalMainDec",RomanRankDecode(C));
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											elseif Lm <= 3 then
												return 6*L+1;
											elseif Lm <= 10 then
												return 5*L+5;
											elseif Lm <= 11 then
												return 5*L+10;
											elseif Lm <= 18 then
												return 5*L+15;
											elseif Lm <= 22 then
												return RoundDbl(3.2*L+45.4);
											else
												return 0*L+118;
											end
										end
									else
										return CalcStat("TomeMainDec",RomanRankDecode(C));
									end
								else
									return 2*CalcStat("TacMas",CalcStat("TitRnkToILvl",RomanRankDecode(C)));
								end
							else
								if Lm <= 1 then
									return CalcStat("PhyMit",48,0.6);
								elseif Lm <= 2 then
									return CalcStat("PhyMit",65,0.8);
								else
									return CalcStat("PhyMit",CalcStat("TitRnkToILvl",L-2),L*0.2+0.4);
								end
							end
						elseif SN > "TOMETOTALMAINDEC" then
							if SN < "TRAIT123CHOICE" then
								if SN < "TPENCHOICE" then
									if SN < "TOMEVITALITY" then
										if SN > "TOMETOTALVITALITY" then
											if SN == "TOMETOTALVITALITYDEC" then
												return CalcStat("VitalityT",CalcStat("TomeTotalLevel",L),2.0);
											else
												return 0;
											end
										elseif SN == "TOMETOTALVITALITY" then
											return CalcStat("TomeTotalVitalityDec",RomanRankDecode(C));
										else
											return 0;
										end
									elseif SN > "TOMEVITALITY" then
										if SN < "TPENARMOUR" then
											if SN == "TOMEVITALITYDEC" then
												return CalcStat("TomeTotalVitalityDec",L)-CalcStat("TomeTotalVitalityDec",L-1);
											else
												return 0;
											end
										elseif SN > "TPENARMOUR" then
											if SN == "TPENBPE" then
												return -CalcStat("BPET",L,CalcStat("TpenChoice",N));
											else
												return 0;
											end
										else
											return -CalcStat("ArmourPenT",L,CalcStat("TpenChoice",N)*2);
										end
									else
										return CalcStat("TomeVitalityDec",RomanRankDecode(C));
									end
								elseif SN > "TPENCHOICE" then
									if SN < "TRAIT123458CHOICE" then
										if SN < "TRAIT000001CHOICE" then
											if SN == "TPENRESIST" then
												return -CalcStat("ResistT",L,CalcStat("TpenChoice",N)*2);
											else
												return 0;
											end
										elseif SN > "TRAIT000001CHOICE" then
											if SN == "TRAIT1012151720CHOICE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({10,12,15,17,20},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 5 then
												return 0;
											else
												return 1;
											end
										end
									elseif SN > "TRAIT123458CHOICE" then
										if SN < "TRAIT12347CHOICE" then
											if SN == "TRAIT12345CHOICE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,2,3,4,5},L);
												end
											else
												return 0;
											end
										elseif SN > "TRAIT12347CHOICE" then
											if SN == "TRAIT1235CHOICE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,2,3,5},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({1,2,3,4,7},L);
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return DataTableValue({1,2,3,4,5,8},L);
										end
									end
								else
									return DataTableValue({0,1,2},L);
								end
							elseif SN > "TRAIT123CHOICE" then
								if SN < "TRAITPROGALTLPH" then
									if SN < "TRAIT567810CHOICE" then
										if SN < "TRAIT23456CHOICE" then
											if SN == "TRAIT13510CHOICE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,3,5,10},L);
												end
											else
												return 0;
											end
										elseif SN > "TRAIT23456CHOICE" then
											if SN == "TRAIT2345CHOICE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({2,3,4,5},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({2,3,4,5,6},L);
											end
										end
									elseif SN > "TRAIT567810CHOICE" then
										if SN < "TRAITPROG" then
											if SN == "TRAIT56789CHOICE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({5,6,7,8,9},L);
												end
											else
												return 0;
											end
										elseif SN > "TRAITPROG" then
											if SN == "TRAITPROGALT" then
												if Lm <= 75 then
													return CalcStat("StatProgAlt",L,N);
												elseif Lm <= 105 then
													return LinFmod(1,CalcStat("StatProgAlt",75,N),CalcStat("StatProgAlt",105,N),75,105,L);
												else
													return CalcStat("StatProgAlt",L,N);
												end
											else
												return 0;
											end
										else
											if Lm <= 75 then
												return CalcStat("StatProg",L,N);
											elseif Lm <= 105 then
												return LinFmod(1,CalcStat("StatProg",75,N),CalcStat("StatProg",105,N),75,105,L);
											else
												return CalcStat("StatProg",L,N);
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return DataTableValue({5,6,7,8,10},L);
										end
									end
								elseif SN > "TRAITPROGALTLPH" then
									if SN < "TRAITPROGLPH" then
										if SN < "TRAITPROGALTVPH" then
											if SN == "TRAITPROGALTLPL" then
												if Lm <= 75 then
													return CalcStat("StatProgAltLPL",L);
												elseif Lm <= 105 then
													return 75;
												else
													return CalcStat("StatProgAltLPL",L);
												end
											else
												return 0;
											end
										elseif SN > "TRAITPROGALTVPH" then
											if SN == "TRAITPROGALTVPL" then
												return CalcStat("TraitProgAlt",CalcStat("TraitProgAltLPL",L),N);
											else
												return 0;
											end
										else
											return CalcStat("TraitProgAlt",CalcStat("TraitProgAltLPH",L),N);
										end
									elseif SN > "TRAITPROGLPH" then
										if SN < "TRAITPROGVPH" then
											if SN == "TRAITPROGLPL" then
												if Lm <= 75 then
													return CalcStat("StatProgLPL",L);
												elseif Lm <= 105 then
													return 75;
												else
													return CalcStat("StatProgLPL",L);
												end
											else
												return 0;
											end
										elseif SN > "TRAITPROGVPH" then
											if SN == "TRAITPROGVPL" then
												return CalcStat("TraitProg",CalcStat("TraitProgLPL",L),N);
											else
												return 0;
											end
										else
											return CalcStat("TraitProg",CalcStat("TraitProgLPH",L),N);
										end
									else
										if Lm <= 75 then
											return CalcStat("StatProgLPH",L);
										elseif Lm <= 105 then
											return 105;
										else
											return CalcStat("StatProgLPH",L);
										end
									end
								else
									if Lm <= 75 then
										return CalcStat("StatProgAltLPH",L);
									elseif Lm <= 105 then
										return 105;
									else
										return CalcStat("StatProgAltLPH",L);
									end
								end
							else
								if Lm <= 0 then
									return 0;
								else
									return DataTableValue({1,2,3},L);
								end
							end
						else
							return CalcStat("MainT",CalcStat("TomeTotalLevel",L),2.0);
						end
					else
						return CalcStat("MitMediumPRatPC",L);
					end
				else
					if Lm <= 50 then
						return LinFmod(1,7.51,227.59,1,50,L);
					else
						return LinFmod(1,227.59,1327.5,50,105,L);
					end
				end
			else
				return CalcStat("RelAvoid",L,N);
			end
		elseif SN > "TRAITVITALITYPROG" then
			if SN < "WILL" then
				if SN < "VMASTERYADJ" then
					if SN < "VIRTINNOCENCERESIST" then
						if SN < "VIRTDETERMINATIONVPTACMAS" then
							if SN < "VIRTCHARITYVITALITY" then
								if SN < "TRAITVITALITYPROGLPL" then
									if SN < "TRAITVITALITYPROGALTLPL" then
										if SN > "TRAITVITALITYPROGALT" then
											if SN == "TRAITVITALITYPROGALTLPH" then
												if Lm <= 50 then
													return 50;
												elseif Lm <= 105 then
													return 105;
												else
													return CalcStat("StatProgAltLPH",L);
												end
											else
												return 0;
											end
										elseif SN == "TRAITVITALITYPROGALT" then
											if Lm <= 50 then
												return LinFmod(1,CalcStat("StatProgAlt",1,N),RoundDbl(N)*30,1,50,L);
											elseif Lm <= 105 then
												return LinFmod(1,RoundDbl(N)*30,CalcStat("StatProgAlt",105,N),50,105,L);
											else
												return CalcStat("StatProgAlt",L,N);
											end
										else
											return 0;
										end
									elseif SN > "TRAITVITALITYPROGALTLPL" then
										if SN < "TRAITVITALITYPROGALTVPL" then
											if SN == "TRAITVITALITYPROGALTVPH" then
												return CalcStat("TraitVitalityProgAlt",CalcStat("TraitVitalityProgAltLPH",L),N);
											else
												return 0;
											end
										elseif SN > "TRAITVITALITYPROGALTVPL" then
											if SN == "TRAITVITALITYPROGLPH" then
												if Lm <= 50 then
													return 50;
												elseif Lm <= 105 then
													return 105;
												else
													return CalcStat("StatProgLPH",L);
												end
											else
												return 0;
											end
										else
											return CalcStat("TraitVitalityProgAlt",CalcStat("TraitVitalityProgAltLPL",L),N);
										end
									else
										if Lm <= 50 then
											return 1;
										elseif Lm <= 105 then
											return 50;
										else
											return CalcStat("StatProgAltLPL",L);
										end
									end
								elseif SN > "TRAITVITALITYPROGLPL" then
									if SN < "VARMOURADJ" then
										if SN < "TRAITVITALITYPROGVPL" then
											if SN == "TRAITVITALITYPROGVPH" then
												return CalcStat("TraitVitalityProg",CalcStat("TraitVitalityProgLPH",L),N);
											else
												return 0;
											end
										elseif SN > "TRAITVITALITYPROGVPL" then
											if SN == "VARMOUR" then
												return RoundDbl(LinFmod(1,LotroDbl(CalcStat("VarmourPntMP",L)*CalcStat("ItemMedProgVPL",L,CalcStat("ProgBMitLight",L))*CalcStat("VarmourAdj",CalcStat("ItemMedProgLPL",L))*N),LotroDbl(CalcStat("VarmourPntMP",L)*CalcStat("ItemMedProgVPH",L,CalcStat("ProgBMitLight",L))*CalcStat("VarmourAdj",CalcStat("ItemMedProgLPH",L))*N),CalcStat("ItemMedProgLPL",L),CalcStat("ItemMedProgLPH",L),L));
											else
												return 0;
											end
										else
											return CalcStat("TraitVitalityProg",CalcStat("TraitVitalityProgLPL",L),N);
										end
									elseif SN > "VARMOURADJ" then
										if SN < "VIRTCHARITYPHYMIT" then
											if SN == "VARMOURPNTMP" then
												return 3/35;
											else
												return 0;
											end
										elseif SN > "VIRTCHARITYPHYMIT" then
											if SN == "VIRTCHARITYRESIST" then
												return CalcStat("VSResistH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSPhyMitM",L);
										end
									else
										return CalcStat("ArmourAdj",L);
									end
								else
									if Lm <= 50 then
										return 1;
									elseif Lm <= 105 then
										return 50;
									else
										return CalcStat("StatProgLPL",L);
									end
								end
							elseif SN > "VIRTCHARITYVITALITY" then
								if SN < "VIRTCONFIDENCEEVADE" then
									if SN < "VIRTCOMPASSIONPHYMIT" then
										if SN > "VIRTCHARITYVPMORALE" then
											if SN == "VIRTCOMPASSIONARMOUR" then
												return CalcStat("VSArmourL",L);
											else
												return 0;
											end
										elseif SN == "VIRTCHARITYVPMORALE" then
											return CalcStat("VSVPMorale",L);
										else
											return 0;
										end
									elseif SN > "VIRTCOMPASSIONPHYMIT" then
										if SN < "VIRTCOMPASSIONVPMORALE" then
											if SN == "VIRTCOMPASSIONTACMIT" then
												return CalcStat("VSTacMitM",L);
											else
												return 0;
											end
										elseif SN > "VIRTCOMPASSIONVPMORALE" then
											if SN == "VIRTCONFIDENCECRITHIT" then
												return CalcStat("VSCritHitH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPMorale",L);
										end
									else
										return CalcStat("VSPhyMitH",L);
									end
								elseif SN > "VIRTCONFIDENCEEVADE" then
									if SN < "VIRTDETERMINATIONAGILITY" then
										if SN < "VIRTCONFIDENCEVPPHYMAS" then
											if SN == "VIRTCONFIDENCEFINESSE" then
												return CalcStat("VSFinesseM",L);
											else
												return 0;
											end
										elseif SN > "VIRTCONFIDENCEVPPHYMAS" then
											if SN == "VIRTCONFIDENCEVPTACMAS" then
												return CalcStat("VSVPTacMas",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPPhyMas",L);
										end
									elseif SN > "VIRTDETERMINATIONAGILITY" then
										if SN < "VIRTDETERMINATIONPHYMAS" then
											if SN == "VIRTDETERMINATIONCRITHIT" then
												return CalcStat("VSCritHitL",L);
											else
												return 0;
											end
										elseif SN > "VIRTDETERMINATIONPHYMAS" then
											if SN == "VIRTDETERMINATIONVPPHYMAS" then
												return CalcStat("VSVPPhyMas",L);
											else
												return 0;
											end
										else
											return CalcStat("VSPhyMasM",L);
										end
									else
										return CalcStat("VSAgilityH",L);
									end
								else
									return CalcStat("VSEvadeL",L);
								end
							else
								return CalcStat("VSVitalityL",L);
							end
						elseif SN > "VIRTDETERMINATIONVPTACMAS" then
							if SN < "VIRTFORTITUDERESIST" then
								if SN < "VIRTEMPATHYRESIST" then
									if SN < "VIRTDISCIPLINERESIST" then
										if SN > "VIRTDISCIPLINEINHEAL" then
											if SN == "VIRTDISCIPLINEPHYMIT" then
												return CalcStat("VSPhyMitL",L);
											else
												return 0;
											end
										elseif SN == "VIRTDISCIPLINEINHEAL" then
											return CalcStat("VSInHealM",L);
										else
											return 0;
										end
									elseif SN > "VIRTDISCIPLINERESIST" then
										if SN < "VIRTEMPATHYARMOUR" then
											if SN == "VIRTDISCIPLINEVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										elseif SN > "VIRTEMPATHYARMOUR" then
											if SN == "VIRTEMPATHYCRITDEF" then
												return CalcStat("VSCritDefM",L);
											else
												return 0;
											end
										else
											return CalcStat("VSArmourH",L);
										end
									else
										return CalcStat("VSResistH",L);
									end
								elseif SN > "VIRTEMPATHYRESIST" then
									if SN < "VIRTFIDELITYVITALITY" then
										if SN < "VIRTFIDELITYPHYMIT" then
											if SN == "VIRTEMPATHYVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										elseif SN > "VIRTFIDELITYPHYMIT" then
											if SN == "VIRTFIDELITYTACMIT" then
												return CalcStat("VSTacMitH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSPhyMitL",L);
										end
									elseif SN > "VIRTFIDELITYVITALITY" then
										if SN < "VIRTFORTITUDECRITDEF" then
											if SN == "VIRTFIDELITYVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										elseif SN > "VIRTFORTITUDECRITDEF" then
											if SN == "VIRTFORTITUDEMORALE" then
												return CalcStat("VSMoraleH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSCritDefM",L);
										end
									else
										return CalcStat("VSVitalityM",L);
									end
								else
									return CalcStat("VSResistL",L);
								end
							elseif SN > "VIRTFORTITUDERESIST" then
								if SN < "VIRTHONOURMORALE" then
									if SN < "VIRTHONESTYVPPHYMAS" then
										if SN < "VIRTHONESTYCRITHIT" then
											if SN == "VIRTFORTITUDEVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										elseif SN > "VIRTHONESTYCRITHIT" then
											if SN == "VIRTHONESTYTACMAS" then
												return CalcStat("VSTacMasH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSCritHitL",L);
										end
									elseif SN > "VIRTHONESTYVPPHYMAS" then
										if SN < "VIRTHONESTYWILL" then
											if SN == "VIRTHONESTYVPTACMAS" then
												return CalcStat("VSVPTacMas",L);
											else
												return 0;
											end
										elseif SN > "VIRTHONESTYWILL" then
											if SN == "VIRTHONOURCRITDEF" then
												return CalcStat("VSCritDefL",L);
											else
												return 0;
											end
										else
											return CalcStat("VSWillM",L);
										end
									else
										return CalcStat("VSVPPhyMas",L);
									end
								elseif SN > "VIRTHONOURMORALE" then
									if SN < "VIRTIDEALISMINHEAL" then
										if SN < "VIRTHONOURVPMORALE" then
											if SN == "VIRTHONOURTACMIT" then
												return CalcStat("VSTacMitM",L);
											else
												return 0;
											end
										elseif SN > "VIRTHONOURVPMORALE" then
											if SN == "VIRTIDEALISMFATE" then
												return CalcStat("VSFateH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPMorale",L);
										end
									elseif SN > "VIRTIDEALISMINHEAL" then
										if SN < "VIRTIDEALISMVPMORALE" then
											if SN == "VIRTIDEALISMMORALE" then
												return CalcStat("VSMoraleL",L);
											else
												return 0;
											end
										elseif SN > "VIRTIDEALISMVPMORALE" then
											if SN == "VIRTINNOCENCEPHYMIT" then
												return CalcStat("VSPhyMitH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPMorale",L);
										end
									else
										return CalcStat("VSInHealM",L);
									end
								else
									return CalcStat("VSMoraleH",L);
								end
							else
								return CalcStat("VSResistL",L);
							end
						else
							return CalcStat("VSVPTacMas",L);
						end
					elseif SN > "VIRTINNOCENCERESIST" then
						if SN < "VIRTWISDOMFINESSE" then
							if SN < "VIRTPATIENCECRITHIT" then
								if SN < "VIRTLOYALTYARMOUR" then
									if SN < "VIRTJUSTICEICMR" then
										if SN > "VIRTINNOCENCETACMIT" then
											if SN == "VIRTINNOCENCEVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										elseif SN == "VIRTINNOCENCETACMIT" then
											return CalcStat("VSTacMitL",L);
										else
											return 0;
										end
									elseif SN > "VIRTJUSTICEICMR" then
										if SN < "VIRTJUSTICETACMIT" then
											if SN == "VIRTJUSTICEMORALE" then
												return CalcStat("VSMoraleM",L);
											else
												return 0;
											end
										elseif SN > "VIRTJUSTICETACMIT" then
											if SN == "VIRTJUSTICEVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										else
											return CalcStat("VSTacMitL",L);
										end
									else
										return CalcStat("VSICMRH",L);
									end
								elseif SN > "VIRTLOYALTYARMOUR" then
									if SN < "VIRTMERCYEVADE" then
										if SN < "VIRTLOYALTYVITALITY" then
											if SN == "VIRTLOYALTYINHEAL" then
												return CalcStat("VSInHealL",L);
											else
												return 0;
											end
										elseif SN > "VIRTLOYALTYVITALITY" then
											if SN == "VIRTLOYALTYVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVitalityH",L);
										end
									elseif SN > "VIRTMERCYEVADE" then
										if SN < "VIRTMERCYVITALITY" then
											if SN == "VIRTMERCYFATE" then
												return CalcStat("VSFateM",L);
											else
												return 0;
											end
										elseif SN > "VIRTMERCYVITALITY" then
											if SN == "VIRTMERCYVPMORALE" then
												return CalcStat("VSVPMorale",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVitalityL",L);
										end
									else
										return CalcStat("VSEvadeH",L);
									end
								else
									return CalcStat("VSArmourM",L);
								end
							elseif SN > "VIRTPATIENCECRITHIT" then
								if SN < "VIRTTOLERANCERESIST" then
									if SN < "VIRTPATIENCEVPMORALE" then
										if SN > "VIRTPATIENCEEVADE" then
											if SN == "VIRTPATIENCEPOWER" then
												return CalcStat("VSPowerH",L);
											else
												return 0;
											end
										elseif SN == "VIRTPATIENCEEVADE" then
											return CalcStat("VSEvadeM",L);
										else
											return 0;
										end
									elseif SN > "VIRTPATIENCEVPMORALE" then
										if SN < "VIRTRNKCOSTTOT" then
											if SN == "VIRTRNKCOST" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 10 then
													return 1000;
												elseif Lm <= 60 then
													return RoundDbl(18*L+878,-2);
												elseif Lm <= 73 then
													return RoundDbl(18.75*L+878,-2);
												else
													return RoundDbl(17.45*L+878,-2);
												end
											else
												return 0;
											end
										elseif SN > "VIRTRNKCOSTTOT" then
											if SN == "VIRTTOLERANCEPHYMIT" then
												return CalcStat("VSPhyMitL",L);
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("VirtRnkCostTot",L-1)+CalcStat("VirtRnkCost",L);
											end
										end
									else
										return CalcStat("VSVPMorale",L);
									end
								elseif SN > "VIRTTOLERANCERESIST" then
									if SN < "VIRTVALOURFINESSE" then
										if SN < "VIRTTOLERANCEVPMORALE" then
											if SN == "VIRTTOLERANCETACMIT" then
												return CalcStat("VSTacMitH",L);
											else
												return 0;
											end
										elseif SN > "VIRTTOLERANCEVPMORALE" then
											if SN == "VIRTVALOURCRITHIT" then
												return CalcStat("VSCritHitL",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPMorale",L);
										end
									elseif SN > "VIRTVALOURFINESSE" then
										if SN < "VIRTVALOURVPPHYMAS" then
											if SN == "VIRTVALOURPHYMAS" then
												return CalcStat("VSPhyMasH",L);
											else
												return 0;
											end
										elseif SN > "VIRTVALOURVPPHYMAS" then
											if SN == "VIRTVALOURVPTACMAS" then
												return CalcStat("VSVPTacMas",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPPhyMas",L);
										end
									else
										return CalcStat("VSFinesseM",L);
									end
								else
									return CalcStat("VSResistM",L);
								end
							else
								return CalcStat("VSCritHitL",L);
							end
						elseif SN > "VIRTWISDOMFINESSE" then
							if SN < "VIRTZEALVPTACMAS" then
								if SN < "VIRTWITPHYMAS" then
									if SN < "VIRTWISDOMVPTACMAS" then
										if SN > "VIRTWISDOMTACMAS" then
											if SN == "VIRTWISDOMVPPHYMAS" then
												return CalcStat("VSVPPhyMas",L);
											else
												return 0;
											end
										elseif SN == "VIRTWISDOMTACMAS" then
											return CalcStat("VSTacMasM",L);
										else
											return 0;
										end
									elseif SN > "VIRTWISDOMVPTACMAS" then
										if SN < "VIRTWITCRITHIT" then
											if SN == "VIRTWISDOMWILL" then
												return CalcStat("VSWillH",L);
											else
												return 0;
											end
										elseif SN > "VIRTWITCRITHIT" then
											if SN == "VIRTWITFINESSE" then
												return CalcStat("VSFinesseH",L);
											else
												return 0;
											end
										else
											return CalcStat("VSCritHitM",L);
										end
									else
										return CalcStat("VSVPTacMas",L);
									end
								elseif SN > "VIRTWITPHYMAS" then
									if SN < "VIRTZEALCRITHIT" then
										if SN < "VIRTWITVPPHYMAS" then
											if SN == "VIRTWITTACMAS" then
												return CalcStat("VSTacMasL",L);
											else
												return 0;
											end
										elseif SN > "VIRTWITVPPHYMAS" then
											if SN == "VIRTWITVPTACMAS" then
												return CalcStat("VSVPTacMas",L);
											else
												return 0;
											end
										else
											return CalcStat("VSVPPhyMas",L);
										end
									elseif SN > "VIRTZEALCRITHIT" then
										if SN < "VIRTZEALPHYMAS" then
											if SN == "VIRTZEALMIGHT" then
												return CalcStat("VSMightH",L);
											else
												return 0;
											end
										elseif SN > "VIRTZEALPHYMAS" then
											if SN == "VIRTZEALVPPHYMAS" then
												return CalcStat("VSVPPhyMas",L);
											else
												return 0;
											end
										else
											return CalcStat("VSPhyMasM",L);
										end
									else
										return CalcStat("VSCritHitL",L);
									end
								else
									return CalcStat("VSPhyMasL",L);
								end
							elseif SN > "VIRTZEALVPTACMAS" then
								if SN < "VMASPROGALTLPL" then
									if SN < "VITALITYTADJ" then
										if SN < "VITALITYADJ" then
											if SN == "VITALITY" then
												return FloorDbl(LinFmod(1,LotroDbl(CalcStat("PntMPVitality",L)*CalcStat("ItemLowProgAltVPL",L,CalcStat("ProgBVitality",L))*CalcStat("VitalityAdj",CalcStat("ItemLowProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPVitality",L)*CalcStat("ItemLowProgAltVPH",L,CalcStat("ProgBVitality",L))*CalcStat("VitalityAdj",CalcStat("ItemLowProgAltLPH",L))*N),CalcStat("ItemLowProgAltLPL",L),CalcStat("ItemLowProgAltLPH",L),L));
											else
												return 0;
											end
										elseif SN > "VITALITYADJ" then
											if SN == "VITALITYT" then
												return FloorDbl(LinFmod(1,LotroDbl(CalcStat("PntMPVitality",L)*CalcStat("TraitVitalityProgAltVPL",L,CalcStat("ProgBVitality",L))*CalcStat("VitalityTAdj",CalcStat("TraitVitalityProgAltLPL",L))*N),LotroDbl(CalcStat("PntMPVitality",L)*CalcStat("TraitVitalityProgAltVPH",L,CalcStat("ProgBVitality",L))*CalcStat("VitalityTAdj",CalcStat("TraitVitalityProgAltLPH",L))*N),CalcStat("TraitVitalityProgAltLPL",L),CalcStat("TraitVitalityProgAltLPH",L),L));
											else
												return 0;
											end
										else
											if Lm <= 25 then
												return 0.5;
											elseif Lm <= 349 then
												return 1;
											elseif Lm <= 350 then
												return 95/99;
											elseif Lm <= 399 then
												return 38/45;
											elseif Lm <= 400 then
												return 76/105;
											elseif Lm <= 449 then
												return 38/63;
											elseif Lm <= 499 then
												return 1.0055;
											elseif Lm <= 500 then
												return 0.8715;
											else
												return 0.8045;
											end
										end
									elseif SN > "VITALITYTADJ" then
										if SN < "VMASPROGALT" then
											if SN == "VMASPROG" then
												if Lm <= 1 then
													return LinFmod(1,0,CalcStat("ItemProg",1,N),0,1,L);
												elseif Lm <= 25 then
													return LinFmod(1,CalcStat("ItemProg",1,N),RoundDbl(N)*25,1,25,L);
												elseif Lm <= 79 then
													return LinFmod(1,RoundDbl(N)*25,CalcStat("ItemProg",79,N),25,79,L);
												elseif Lm <= 350 then
													return CalcStat("ItemProg",L,N);
												elseif Lm <= 400 then
													return LinFmod(1,CalcStat("ItemProg",350,N),CalcStat("ItemProg",400,N),350,400,L);
												else
													return CalcStat("ItemProg",L,N);
												end
											else
												return 0;
											end
										elseif SN > "VMASPROGALT" then
											if SN == "VMASPROGALTLPH" then
												if Lm <= 1 then
													return 1;
												elseif Lm <= 25 then
													return 25;
												elseif Lm <= 79 then
													return 79;
												elseif Lm <= 350 then
													return CalcStat("ItemProgAltLPH",L);
												elseif Lm <= 400 then
													return 400;
												else
													return CalcStat("ItemProgAltLPH",L);
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return LinFmod(1,0,CalcStat("ItemProgAlt",1,N),0,1,L);
											elseif Lm <= 25 then
												return LinFmod(1,CalcStat("ItemProgAlt",1,N),RoundDbl(N)*25,1,25,L);
											elseif Lm <= 79 then
												return LinFmod(1,RoundDbl(N)*25,CalcStat("ItemProgAlt",79,N),25,79,L);
											elseif Lm <= 350 then
												return CalcStat("ItemProgAlt",L,N);
											elseif Lm <= 400 then
												return LinFmod(1,CalcStat("ItemProgAlt",350,N),CalcStat("ItemProgAlt",400,N),350,400,L);
											else
												return CalcStat("ItemProgAlt",L,N);
											end
										end
									else
										if Lm <= 115 then
											return 1;
										elseif Lm <= 116 then
											return 95/99;
										elseif Lm <= 120 then
											return 0.8;
										elseif Lm <= 121 then
											return 0.6878;
										elseif Lm <= 130 then
											return 0.573;
										else
											return 0.6368;
										end
									end
								elseif SN > "VMASPROGALTLPL" then
									if SN < "VMASPROGLPL" then
										if SN < "VMASPROGALTVPL" then
											if SN == "VMASPROGALTVPH" then
												return CalcStat("VMasProgAlt",CalcStat("VMasProgAltLPH",L),N);
											else
												return 0;
											end
										elseif SN > "VMASPROGALTVPL" then
											if SN == "VMASPROGLPH" then
												if Lm <= 1 then
													return 1;
												elseif Lm <= 25 then
													return 25;
												elseif Lm <= 79 then
													return 79;
												elseif Lm <= 350 then
													return CalcStat("ItemProgLPH",L);
												elseif Lm <= 400 then
													return 400;
												else
													return CalcStat("ItemProgLPH",L);
												end
											else
												return 0;
											end
										else
											return CalcStat("VMasProgAlt",CalcStat("VMasProgAltLPL",L),N);
										end
									elseif SN > "VMASPROGLPL" then
										if SN < "VMASPROGVPL" then
											if SN == "VMASPROGVPH" then
												return CalcStat("VMasProg",CalcStat("VMasProgLPH",L),N);
											else
												return 0;
											end
										elseif SN > "VMASPROGVPL" then
											if SN == "VMASTERY" then
												return LinFmod(1,LotroDbl(CalcStat("PntMPMastery",L)*CalcStat("VmasProgVPL",L,CalcStat("ProgBMastery",L))*CalcStat("VmasteryAdj",CalcStat("VmasProgLPL",L))*N),LotroDbl(CalcStat("PntMPMastery",L)*CalcStat("VmasProgVPH",L,CalcStat("ProgBMastery",L))*CalcStat("VmasteryAdj",CalcStat("VmasProgLPH",L))*N),CalcStat("VmasProgLPL",L),CalcStat("VmasProgLPH",L),L);
											else
												return 0;
											end
										else
											return CalcStat("VMasProg",CalcStat("VMasProgLPL",L),N);
										end
									else
										if Lm <= 1 then
											return 0;
										elseif Lm <= 25 then
											return 1;
										elseif Lm <= 79 then
											return 25;
										elseif Lm <= 350 then
											return CalcStat("ItemProgLPL",L);
										elseif Lm <= 400 then
											return 350;
										else
											return CalcStat("ItemProgLPL",L);
										end
									end
								else
									if Lm <= 1 then
										return 0;
									elseif Lm <= 25 then
										return 1;
									elseif Lm <= 79 then
										return 25;
									elseif Lm <= 350 then
										return CalcStat("ItemProgAltLPL",L);
									elseif Lm <= 400 then
										return 350;
									else
										return CalcStat("ItemProgAltLPL",L);
									end
								end
							else
								return CalcStat("VSVPTacMas",L);
							end
						else
							return CalcStat("VSFinesseL",L);
						end
					else
						return CalcStat("VSResistM",L);
					end
				elseif SN > "VMASTERYADJ" then
					if SN < "VSPOWERH" then
						if SN < "VSCRITDEFM" then
							if SN < "VMORPROGLPH" then
								if SN < "VMORALE" then
									if SN < "VMLOW" then
										if SN > "VMASTERYOLD" then
											if SN == "VMHIGH" then
												return 2;
											else
												return 0;
											end
										elseif SN == "VMASTERYOLD" then
											return CalcStat("VMastery",L,N);
										else
											return 0;
										end
									elseif SN > "VMLOW" then
										if SN < "VMMEDIUM" then
											if SN == "VMMASTERYPSV" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "VMMEDIUM" then
											if SN == "VMMORALEPSV" then
												return 0.3;
											else
												return 0;
											end
										else
											return 1;
										end
									else
										return 0.6;
									end
								elseif SN > "VMORALE" then
									if SN < "VMORPROGALTLPH" then
										if SN < "VMORPROG" then
											if SN == "VMORALEADJ" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 350 then
													return 1;
												elseif Lm <= 399 then
													return 0.8;
												elseif Lm <= 400 then
													return 22/35;
												elseif Lm <= 449 then
													return 40/70;
												elseif Lm <= 450 then
													return 0.582;
												elseif Lm <= 499 then
													return 0.635;
												elseif Lm <= 500 then
													return 0.582;
												else
													return 0.635;
												end
											else
												return 0;
											end
										elseif SN > "VMORPROG" then
											if SN == "VMORPROGALT" then
												if Lm <= 1 then
													return LinFmod(1,0,CalcStat("ItemProgAlt",1,N),0,1,L);
												elseif Lm <= 2 then
													return LinFmod(1,CalcStat("ItemProgAlt",1,N),RoundDbl(N)*1.6,1,2,L);
												elseif Lm <= 50 then
													return LinFmod(1,RoundDbl(N)*1.6,RoundDbl(N)*45,2,50,L);
												elseif Lm <= 80 then
													return LinFmod(1,RoundDbl(N)*45,CalcStat("ItemProgAlt",80,N),50,80,L);
												else
													return CalcStat("ItemProgAlt",L,N);
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return LinFmod(1,0,CalcStat("ItemProg",1,N),0,1,L);
											elseif Lm <= 2 then
												return LinFmod(1,CalcStat("ItemProg",1,N),RoundDbl(N)*1.6,1,2,L);
											elseif Lm <= 50 then
												return LinFmod(1,RoundDbl(N)*1.6,RoundDbl(N)*45,2,50,L);
											elseif Lm <= 80 then
												return LinFmod(1,RoundDbl(N)*45,CalcStat("ItemProg",80,N),50,80,L);
											else
												return CalcStat("ItemProg",L,N);
											end
										end
									elseif SN > "VMORPROGALTLPH" then
										if SN < "VMORPROGALTVPH" then
											if SN == "VMORPROGALTLPL" then
												if Lm <= 1 then
													return 0;
												elseif Lm <= 2 then
													return 1;
												elseif Lm <= 50 then
													return 2;
												elseif Lm <= 80 then
													return 50;
												else
													return CalcStat("ItemProgAltLPL",L);
												end
											else
												return 0;
											end
										elseif SN > "VMORPROGALTVPH" then
											if SN == "VMORPROGALTVPL" then
												return CalcStat("VMorProgAlt",CalcStat("VMorProgAltLPL",L),N);
											else
												return 0;
											end
										else
											return CalcStat("VMorProgAlt",CalcStat("VMorProgAltLPH",L),N);
										end
									else
										if Lm <= 1 then
											return 1;
										elseif Lm <= 2 then
											return 2;
										elseif Lm <= 50 then
											return 50;
										elseif Lm <= 80 then
											return 80;
										else
											return CalcStat("ItemProgAltLPH",L);
										end
									end
								else
									return LinFmod(1,LotroDbl(CalcStat("PntMPMorale",L)*CalcStat("VmorProgVPL",L,CalcStat("ProgBMorale",L))*CalcStat("VmoraleAdj",CalcStat("VmorProgLPL",L))*N),LotroDbl(CalcStat("PntMPMorale",L)*CalcStat("VmorProgVPH",L,CalcStat("ProgBMorale",L))*CalcStat("VmoraleAdj",CalcStat("VmorProgLPH",L))*N),CalcStat("VmorProgLPL",L),CalcStat("VmorProgLPH",L),L);
								end
							elseif SN > "VMORPROGLPH" then
								if SN < "VSAGILITYH" then
									if SN < "VMORPROGVPL" then
										if SN > "VMORPROGLPL" then
											if SN == "VMORPROGVPH" then
												return CalcStat("VMorProg",CalcStat("VMorProgLPH",L),N);
											else
												return 0;
											end
										elseif SN == "VMORPROGLPL" then
											if Lm <= 1 then
												return 0;
											elseif Lm <= 2 then
												return 1;
											elseif Lm <= 50 then
												return 2;
											elseif Lm <= 80 then
												return 50;
											else
												return CalcStat("ItemProgLPL",L);
											end
										else
											return 0;
										end
									elseif SN > "VMORPROGVPL" then
										if SN < "VRNKLVLCAP" then
											if SN == "VRNKCAP" then
												return 84;
											else
												return 0;
											end
										elseif SN > "VRNKLVLCAP" then
											if SN == "VRNKTOILVL" then
												if Lm <= 0 then
													return 0;
												elseif Lm <= 38 then
													return LinFmod(1,4,78,1,38,L)*N;
												elseif Lm <= 48 then
													return LinFmod(1,78,178,38,48,L)*N;
												elseif Lm <= 49 then
													return LinFmod(1,178,190,48,49,L)*N;
												elseif Lm <= 50 then
													return LinFmod(1,190,210,49,50,L)*N;
												elseif Lm <= 51 then
													return LinFmod(1,210,222,50,51,L)*N;
												elseif Lm <= 52 then
													return LinFmod(1,222,236,51,52,L)*N;
												elseif Lm <= 53 then
													return LinFmod(1,236,260,52,53,L)*N;
												elseif Lm <= 55 then
													return LinFmod(1,260,292,53,55,L)*N;
												elseif Lm <= 68 then
													return LinFmod(1,292,396,55,68,L)*N;
												else
													return LinFmod(1,396,706,68,130,L)*N;
												end
											else
												return 0;
											end
										else
											if Lm <= 4 then
												return 2;
											elseif Lm <= 110 then
												return FloorDbl(L/2);
											else
												return L-55;
											end
										end
									else
										return CalcStat("VMorProg",CalcStat("VMorProgLPL",L),N);
									end
								elseif SN > "VSAGILITYH" then
									if SN < "VSARMOURL" then
										if SN < "VSAGILITYM" then
											if SN == "VSAGILITYL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Agility",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										elseif SN > "VSAGILITYM" then
											if SN == "VSARMOURH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Varmour",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Agility",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
											end
										end
									elseif SN > "VSARMOURL" then
										if SN < "VSCRITDEFH" then
											if SN == "VSARMOURM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Varmour",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										elseif SN > "VSCRITDEFH" then
											if SN == "VSCRITDEFL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("CritDef",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("CritDef",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("Varmour",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
										end
									end
								else
									if Lm <= 0 then
										return 0;
									else
										return CalcStat("Agility",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
									end
								end
							else
								if Lm <= 1 then
									return 1;
								elseif Lm <= 2 then
									return 2;
								elseif Lm <= 50 then
									return 50;
								elseif Lm <= 80 then
									return 80;
								else
									return CalcStat("ItemProgLPH",L);
								end
							end
						elseif SN > "VSCRITDEFM" then
							if SN < "VSICMRM" then
								if SN < "VSFATEH" then
									if SN < "VSCRITHITM" then
										if SN > "VSCRITHITH" then
											if SN == "VSCRITHITL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("CritHit",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										elseif SN == "VSCRITHITH" then
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("CritHit",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
											end
										else
											return 0;
										end
									elseif SN > "VSCRITHITM" then
										if SN < "VSEVADEL" then
											if SN == "VSEVADEH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Evade",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										elseif SN > "VSEVADEL" then
											if SN == "VSEVADEM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Evade",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Evade",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("CritHit",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
										end
									end
								elseif SN > "VSFATEH" then
									if SN < "VSFINESSEL" then
										if SN < "VSFATEM" then
											if SN == "VSFATEL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Fate",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										elseif SN > "VSFATEM" then
											if SN == "VSFINESSEH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Finesse",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Fate",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
											end
										end
									elseif SN > "VSFINESSEL" then
										if SN < "VSICMRH" then
											if SN == "VSFINESSEM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Finesse",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										elseif SN > "VSICMRH" then
											if SN == "VSICMRL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("ICMR",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("ICMR",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("Finesse",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
										end
									end
								else
									if Lm <= 0 then
										return 0;
									else
										return CalcStat("Fate",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
									end
								end
							elseif SN > "VSICMRM" then
								if SN < "VSMORALEL" then
									if SN < "VSMIGHTH" then
										if SN < "VSINHEALL" then
											if SN == "VSINHEALH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("InHeal",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										elseif SN > "VSINHEALL" then
											if SN == "VSINHEALM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("InHeal",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("InHeal",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
											end
										end
									elseif SN > "VSMIGHTH" then
										if SN < "VSMIGHTM" then
											if SN == "VSMIGHTL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Might",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										elseif SN > "VSMIGHTM" then
											if SN == "VSMORALEH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Vmorale",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Might",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("Might",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
										end
									end
								elseif SN > "VSMORALEL" then
									if SN < "VSPHYMASM" then
										if SN < "VSPHYMASH" then
											if SN == "VSMORALEM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Vmorale",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										elseif SN > "VSPHYMASH" then
											if SN == "VSPHYMASL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("PhyMas",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("PhyMas",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
											end
										end
									elseif SN > "VSPHYMASM" then
										if SN < "VSPHYMITL" then
											if SN == "VSPHYMITH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("PhyMit",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										elseif SN > "VSPHYMITL" then
											if SN == "VSPHYMITM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("PhyMit",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("PhyMit",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("PhyMas",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
										end
									end
								else
									if Lm <= 0 then
										return 0;
									else
										return CalcStat("Vmorale",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
									end
								end
							else
								if Lm <= 0 then
									return 0;
								else
									return CalcStat("ICMR",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
								end
							end
						else
							if Lm <= 0 then
								return 0;
							else
								return CalcStat("CritDef",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
							end
						end
					elseif SN > "VSPOWERH" then
						if SN < "WARDENCDBASEFATE" then
							if SN < "VSVPMORALE" then
								if SN < "VSTACMASL" then
									if SN < "VSRESISTH" then
										if SN > "VSPOWERL" then
											if SN == "VSPOWERM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Power",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										elseif SN == "VSPOWERL" then
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Power",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
											end
										else
											return 0;
										end
									elseif SN > "VSRESISTH" then
										if SN < "VSRESISTM" then
											if SN == "VSRESISTL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Resist",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										elseif SN > "VSRESISTM" then
											if SN == "VSTACMASH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("TacMas",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Resist",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("Resist",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
										end
									end
								elseif SN > "VSTACMASL" then
									if SN < "VSTACMITM" then
										if SN < "VSTACMITH" then
											if SN == "VSTACMASM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("TacMas",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										elseif SN > "VSTACMITH" then
											if SN == "VSTACMITL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("TacMit",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("TacMit",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
											end
										end
									elseif SN > "VSTACMITM" then
										if SN < "VSVITALITYL" then
											if SN == "VSVITALITYH" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Vitality",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
												end
											else
												return 0;
											end
										elseif SN > "VSVITALITYL" then
											if SN == "VSVITALITYM" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Vitality",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Vitality",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("TacMit",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
										end
									end
								else
									if Lm <= 0 then
										return 0;
									else
										return CalcStat("TacMas",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
									end
								end
							elseif SN > "VSVPMORALE" then
								if SN < "WARDENCDAGILITYTOEVADE" then
									if SN < "VSWILLH" then
										if SN > "VSVPPHYMAS" then
											if SN == "VSVPTACMAS" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Vmastery",CalcStat("VRnkToILvl",L),CalcStat("VMMasteryPsv",L));
												end
											else
												return 0;
											end
										elseif SN == "VSVPPHYMAS" then
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Vmastery",CalcStat("VRnkToILvl",L),CalcStat("VMMasteryPsv",L));
											end
										else
											return 0;
										end
									elseif SN > "VSWILLH" then
										if SN < "VSWILLM" then
											if SN == "VSWILLL" then
												if Lm <= 0 then
													return 0;
												else
													return CalcStat("Will",CalcStat("VRnkToILvl",L),CalcStat("VMLow",L));
												end
											else
												return 0;
											end
										elseif SN > "VSWILLM" then
											if SN == "WARDENCDAGILITYTOCRITHIT" then
												return 1;
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return CalcStat("Will",CalcStat("VRnkToILvl",L),CalcStat("VMMedium",L));
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return CalcStat("Will",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
										end
									end
								elseif SN > "WARDENCDAGILITYTOEVADE" then
									if SN < "WARDENCDARMOURTOPHYMIT" then
										if SN < "WARDENCDAGILITYTOPHYMAS" then
											if SN == "WARDENCDAGILITYTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN > "WARDENCDAGILITYTOPHYMAS" then
											if SN == "WARDENCDARMOURTOOFMIT" then
												return 0.2;
											else
												return 0;
											end
										else
											return 3;
										end
									elseif SN > "WARDENCDARMOURTOPHYMIT" then
										if SN < "WARDENCDARMOURTYPE" then
											if SN == "WARDENCDARMOURTOTACMIT" then
												return 0.2;
											else
												return 0;
											end
										elseif SN > "WARDENCDARMOURTYPE" then
											if SN == "WARDENCDBASEAGILITY" then
												return CalcStat("ClassBaseMainJ",L);
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 1;
									end
								else
									return 3;
								end
							else
								if Lm <= 0 then
									return 0;
								else
									return CalcStat("Vmorale",CalcStat("VRnkToILvl",L),CalcStat("VMMoralePsv",L));
								end
							end
						elseif SN > "WARDENCDBASEFATE" then
							if SN < "WARDENCDFATETONCPR" then
								if SN < "WARDENCDBASEPOWER" then
									if SN < "WARDENCDBASEMIGHT" then
										if SN > "WARDENCDBASEICMR" then
											if SN == "WARDENCDBASEICPR" then
												return CalcStat("ClassBaseICPR",L);
											else
												return 0;
											end
										elseif SN == "WARDENCDBASEICMR" then
											return CalcStat("ClassBaseICMRH",L);
										else
											return 0;
										end
									elseif SN > "WARDENCDBASEMIGHT" then
										if SN < "WARDENCDBASENCMR" then
											if SN == "WARDENCDBASEMORALE" then
												if Lm <= 120 then
													return CalcStat("ClassBaseMoraleHb",L);
												else
													return CalcStat("ClassBaseMoraleHb",120);
												end
											else
												return 0;
											end
										elseif SN > "WARDENCDBASENCMR" then
											if SN == "WARDENCDBASENCPR" then
												return CalcStat("ClassBaseNCPR",L);
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseNCMRH",L);
										end
									else
										return CalcStat("ClassBaseMainH",L);
									end
								elseif SN > "WARDENCDBASEPOWER" then
									if SN < "WARDENCDFATETOCRITHIT" then
										if SN < "WARDENCDBASEWILL" then
											if SN == "WARDENCDBASEVITALITY" then
												return CalcStat("ClassBaseMainC",L);
											else
												return 0;
											end
										elseif SN > "WARDENCDBASEWILL" then
											if SN == "WARDENCDCANBLOCK" then
												return 1;
											else
												return 0;
											end
										else
											return CalcStat("ClassBaseMainA",L);
										end
									elseif SN > "WARDENCDFATETOCRITHIT" then
										if SN < "WARDENCDFATETOICMR" then
											if SN == "WARDENCDFATETOFINESSE" then
												return 1;
											else
												return 0;
											end
										elseif SN > "WARDENCDFATETOICMR" then
											if SN == "WARDENCDFATETOICPR" then
												return 1.71;
											else
												return 0;
											end
										else
											return 1.5;
										end
									else
										return 2.5;
									end
								else
									if Lm <= 120 then
										return CalcStat("ClassBasePowerL",L);
									else
										return CalcStat("ClassBasePowerL",120);
									end
								end
							elseif SN > "WARDENCDFATETONCPR" then
								if SN < "WARDENCDTACMASTOOUTHEAL" then
									if SN < "WARDENCDMIGHTTOBLOCK" then
										if SN < "WARDENCDFATETOTACMIT" then
											if SN == "WARDENCDFATETORESIST" then
												return 1;
											else
												return 0;
											end
										elseif SN > "WARDENCDFATETOTACMIT" then
											if SN == "WARDENCDHASPOWER" then
												return 1;
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "WARDENCDMIGHTTOBLOCK" then
										if SN < "WARDENCDMIGHTTOPHYMAS" then
											if SN == "WARDENCDMIGHTTOPARRY" then
												return 2;
											else
												return 0;
											end
										elseif SN > "WARDENCDMIGHTTOPHYMAS" then
											if SN == "WARDENCDPHYMITTOOFMIT" then
												return 1;
											else
												return 0;
											end
										else
											return 2;
										end
									else
										return 3;
									end
								elseif SN > "WARDENCDTACMASTOOUTHEAL" then
									if SN < "WARDENCDWILLTORESIST" then
										if SN < "WARDENCDVITALITYTONCMR" then
											if SN == "WARDENCDVITALITYTOMORALE" then
												return 4.8;
											else
												return 0;
											end
										elseif SN > "WARDENCDVITALITYTONCMR" then
											if SN == "WARDENCDVITALITYTORESIST" then
												return 1;
											else
												return 0;
											end
										else
											return 7.2;
										end
									elseif SN > "WARDENCDWILLTORESIST" then
										if SN < "WARDINGLOREPHYMIT" then
											if SN == "WARDENCDWILLTOTACMIT" then
												return 1;
											else
												return 0;
											end
										elseif SN > "WARDINGLOREPHYMIT" then
											if SN == "WARDINGLORETACMIT" then
												if Lm <= 105 then
													return CalcStat("Mitigation",L,1.6);
												elseif Lm <= 119 then
													return CalcStat("TacMitT",L,1.2);
												elseif Lm <= 120 then
													return CalcStat("TacMitT",L,1.6);
												elseif Lm <= 129 then
													return CalcStat("TacMitT",L,1.2);
												else
													return CalcStat("TacMitT",L,1.6);
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return CalcStat("Mitigation",L,1.6);
											elseif Lm <= 119 then
												return CalcStat("PhyMitT",L,1.2);
											elseif Lm <= 120 then
												return CalcStat("PhyMitT",L,1.6);
											elseif Lm <= 129 then
												return CalcStat("PhyMitT",L,1.2);
											else
												return CalcStat("PhyMitT",L,1.6);
											end
										end
									else
										return 2;
									end
								else
									return 1;
								end
							else
								return 24;
							end
						else
							return CalcStat("ClassBaseMainF",L);
						end
					else
						if Lm <= 0 then
							return 0;
						else
							return CalcStat("Power",CalcStat("VRnkToILvl",L),CalcStat("VMHigh",L));
						end
					end
				else
					if Lm <= 0 then
						return 0;
					elseif Lm <= 1 then
						return 0.5;
					elseif Lm <= 80 then
						return 0.8;
					elseif Lm <= 400 then
						return 1;
					elseif Lm <= 449 then
						return 0.9;
					elseif Lm <= 450 then
						return 83/90;
					else
						return 70/90;
					end
				end
			elseif SN > "WILL" then
				if SN < "WORTHVALAM" then
					if SN < "WORTHTABBS" then
						if SN < "WORTHTABAP" then
							if SN < "WORTHTABAB" then
								if SN < "WORTHMPE" then
									if SN < "WORTHMPA" then
										if SN > "WILLT" then
											if SN == "WORTHEXT" then
												if Lm <= 360 then
													return RoundDbl(CalcStat("StatC",L,C));
												elseif Lm <= 501 then
													return RoundDbl(CalcStat("StatC",L-1,C));
												else
													return 0;
												end
											else
												return 0;
											end
										elseif SN == "WILLT" then
											return CalcStat("MainT",L,N);
										else
											return 0;
										end
									elseif SN > "WORTHMPA" then
										if SN < "WORTHMPC" then
											if SN == "WORTHMPB" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1.2,2,3,4},L);
												end
											else
												return 0;
											end
										elseif SN > "WORTHMPC" then
											if SN == "WORTHMPD" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1,1,2,3},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return 1;
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return DataTableValue({1,1.1,1.15,1.2,1.3},L);
										end
									end
								elseif SN > "WORTHMPE" then
									if SN < "WORTHMPI" then
										if SN < "WORTHMPG" then
											if SN == "WORTHMPF" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({0.5,1,1.25,1.5,2},L);
												end
											else
												return 0;
											end
										elseif SN > "WORTHMPG" then
											if SN == "WORTHMPH" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1.2,1.8,3.2,5},L);
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											else
												return DataTableValue({1,2,3,4,5},L);
											end
										end
									elseif SN > "WORTHMPI" then
										if SN < "WORTHTABA" then
											if SN == "WORTHMPJ" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1,1,1,1,5},L);
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABA" then
											if SN == "WORTHTABAA" then
												return CalcStat("WorthTabD",L)+20;
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 1;
											else
												return CalcStat("WorthTabAF",L);
											end
										end
									else
										if Lm <= 0 then
											return 0;
										else
											return DataTableValue({1,2,2.5,3,10},L);
										end
									end
								else
									if Lm <= 0 then
										return 0;
									else
										return DataTableValue({1,1.1,1.15,1.2,1.25},L);
									end
								end
							elseif SN > "WORTHTABAB" then
								if SN < "WORTHTABAI" then
									if SN < "WORTHTABAE" then
										if SN > "WORTHTABAC" then
											if SN == "WORTHTABAD" then
												return 7*L+100;
											else
												return 0;
											end
										elseif SN == "WORTHTABAC" then
											return CalcStat("WorthTabE",L)-30;
										else
											return 0;
										end
									elseif SN > "WORTHTABAE" then
										if SN < "WORTHTABAG" then
											if SN == "WORTHTABAF" then
												if Lm <= 49 then
													return 2.5*L;
												else
													return 3*L-25;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABAG" then
											if SN == "WORTHTABAH" then
												if Lm <= 49 then
													return CalcStat("WorthTabALBase",L+7)-66;
												else
													return 9*L+72;
												end
											else
												return 0;
											end
										else
											return CalcStat("WorthTabAF",L)+25;
										end
									else
										return CalcStat("WorthTabE",L);
									end
								elseif SN > "WORTHTABAI" then
									if SN < "WORTHTABALBASE" then
										if SN < "WORTHTABAK" then
											if SN == "WORTHTABAJ" then
												return CalcStat("WorthTabAH",L);
											else
												return 0;
											end
										elseif SN > "WORTHTABAK" then
											if SN == "WORTHTABAL" then
												if Lm <= 49 then
													return CalcStat("WorthTabALBase",L);
												else
													return 9*L+69;
												end
											else
												return 0;
											end
										else
											if Lm <= 49 then
												return CalcStat("WorthTabALBase",L+1);
											else
												return 9*L+78;
											end
										end
									elseif SN > "WORTHTABALBASE" then
										if SN < "WORTHTABAN" then
											if SN == "WORTHTABAM" then
												return CalcStat("WorthTabB",L);
											else
												return 0;
											end
										elseif SN > "WORTHTABAN" then
											if SN == "WORTHTABAO" then
												return CalcStat("WorthTabE",L);
											else
												return 0;
											end
										else
											if Lm <= 50 then
												return 8.25*L+27.75;
											else
												return 8*L+40;
											end
										end
									else
										return 9.86*L+23.51+RoundDbl(L*0.1+0.3)*0.4;
									end
								else
									if Lm <= 16 then
										return 10.73*L+54.3;
									elseif Lm <= 34 then
										return 10.735*L+54;
									elseif Lm <= 35 then
										return 429;
									elseif Lm <= 41 then
										return 10.65*L+57.1;
									elseif Lm <= 49 then
										return 10.7*L+55.3;
									else
										return 9*L+141;
									end
								end
							else
								return 7*L+50;
							end
						elseif SN > "WORTHTABAP" then
							if SN < "WORTHTABBC" then
								if SN < "WORTHTABAW" then
									if SN < "WORTHTABAS" then
										if SN > "WORTHTABAQ" then
											if SN == "WORTHTABAR" then
												return CalcStat("WorthTabD",L)+37.5;
											else
												return 0;
											end
										elseif SN == "WORTHTABAQ" then
											if Lm <= 10 then
												return 7.5*L+60;
											elseif Lm <= 49 then
												return 5.5*L+80;
											else
												return 6*L+55;
											end
										else
											return 0;
										end
									elseif SN > "WORTHTABAS" then
										if SN < "WORTHTABAU" then
											if SN == "WORTHTABAT" then
												if Lm <= 4 then
													return RoundDbl(3*L+20,-1);
												elseif Lm <= 7 then
													return 60;
												elseif Lm <= 10 then
													return 100;
												elseif Lm <= 13 then
													return 180;
												elseif Lm <= 16 then
													return 270;
												elseif Lm <= 19 then
													return 310;
												elseif Lm <= 40 then
													return RoundDbl(3.2*L+274,-1);
												elseif Lm <= 43 then
													return 400;
												elseif Lm <= 53 then
													return RoundDbl(1.9*L+334,-1);
												elseif Lm <= 56 then
													return 460;
												elseif Lm <= 59 then
													return 480;
												else
													return 20*L-680;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABAU" then
											if SN == "WORTHTABAV" then
												if Lm <= 4 then
													return RoundDbl(3*L+20,-1);
												elseif Lm <= 7 then
													return 70;
												elseif Lm <= 10 then
													return 140;
												elseif Lm <= 13 then
													return 270;
												elseif Lm <= 16 then
													return 400;
												elseif Lm <= 19 then
													return 460;
												elseif Lm <= 25 then
													return RoundDbl(3*L+447.5,-1);
												elseif Lm <= 46 then
													return RoundDbl(3.2*L+455,-1);
												elseif Lm <= 50 then
													return 620;
												else
													return 20*L-360;
												end
											else
												return 0;
											end
										else
											return CalcStat("WorthTabBN",L)*1.25;
										end
									else
										return CalcStat("WorthTabU",L);
									end
								elseif SN > "WORTHTABAW" then
									if SN < "WORTHTABAZBASE" then
										if SN < "WORTHTABAY" then
											if SN == "WORTHTABAX" then
												if Lm <= 16 then
													return 10.75*L+54;
												elseif Lm <= 34 then
													return 10.75*L+53.7;
												elseif Lm <= 35 then
													return 429;
												elseif Lm <= 41 then
													return 10.65*L+57.1;
												elseif Lm <= 49 then
													return 10.68*L+56.25;
												else
													return 12*L-9;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABAY" then
											if SN == "WORTHTABAZ" then
												if Lm <= 10 then
													return CalcStat("WorthTabAZBase",L)*62.5;
												elseif Lm <= 65 then
													return CalcStat("WorthTabAZBase",L)*125;
												else
													return CalcStat("WorthTabAZBase",L)*25;
												end
											else
												return 0;
											end
										else
											return 5*L;
										end
									elseif SN > "WORTHTABAZBASE" then
										if SN < "WORTHTABBA" then
											if SN == "WORTHTABB" then
												if Lm <= 50 then
													return 8.25*L+22.25;
												else
													return 8*L+35;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABBA" then
											if SN == "WORTHTABBB" then
												if Lm <= 1 then
													return 40;
												elseif Lm <= 10 then
													return RoundDbl(0.35*L-0.1)*20;
												elseif Lm <= 13 then
													return 100;
												elseif Lm <= 19 then
													return RoundDbl(0.35*L+1.6)*20;
												elseif Lm <= 25 then
													return RoundDbl(2*L+150,-1);
												elseif Lm <= 40 then
													return RoundDbl(2*L+164,-1);
												elseif Lm <= 49 then
													return RoundDbl(L+201,-1);
												else
													return 20*L-740;
												end
											else
												return 0;
											end
										else
											return 5*L+385;
										end
									else
										if Lm <= 44 then
											return RoundDbl(0.0525*L+0.7);
										elseif Lm <= 65 then
											return RoundDbl(0.19*L-4.85);
										elseif Lm <= 81 then
											return RoundDbl(0.19*L+28.15);
										else
											return RoundDbl(0.19*L+28.15+RoundDbl(L*0.05-4.55)*0.2);
										end
									end
								else
									if Lm <= 1 then
										return 50;
									elseif Lm <= 49 then
										return 2.5*L+102.5;
									elseif Lm <= 80 then
										return 3*L+78;
									elseif Lm <= 120 then
										return 2.97*L+79.5;
									else
										return 3*L+75;
									end
								end
							elseif SN > "WORTHTABBC" then
								if SN < "WORTHTABBK" then
									if SN < "WORTHTABBG" then
										if SN < "WORTHTABBE" then
											if SN == "WORTHTABBD" then
												return CalcStat("WorthTabK",L)+1;
											else
												return 0;
											end
										elseif SN > "WORTHTABBE" then
											if SN == "WORTHTABBF" then
												return CalcStat("WorthTabAV",L)+20;
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 60;
											elseif Lm <= 7 then
												return RoundDbl(L/3)*40+30;
											elseif Lm <= 13 then
												return RoundDbl(L/3)*130-210;
											elseif Lm <= 19 then
												return RoundDbl(L/3)*60+140;
											elseif Lm <= 25 then
												return RoundDbl(L/3)*10+480;
											elseif Lm <= 46 then
												return RoundDbl(L/3)*10+490;
											elseif Lm <= 50 then
												return 660;
											else
												return 20*L-320;
											end
										end
									elseif SN > "WORTHTABBG" then
										if SN < "WORTHTABBI" then
											if SN == "WORTHTABBH" then
												if Lm <= 80 then
													return RoundDbl(0.05*L-0.05)+RoundDbl(0.05*L+0.45);
												else
													return RoundDbl(0.05*L-0.1)+RoundDbl(0.05*L+0.45);
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABBI" then
											if SN == "WORTHTABBJ" then
												return RoundDbl(0.1*L+0.45)*3;
											else
												return 0;
											end
										else
											return CalcStat("WorthTabG",L)-25;
										end
									else
										if Lm <= 7 then
											return RoundDbl(0.2*L-0.4)*2+1;
										elseif Lm <= 16 then
											return RoundDbl(L/3-2)*6;
										elseif Lm <= 22 then
											return RoundDbl(L/3+1)*3;
										elseif Lm <= 25 then
											return RoundDbl(L/3+1)*3-2;
										elseif Lm <= 80 then
											return RoundDbl(L/3+18)-2;
										else
											return L-37;
										end
									end
								elseif SN > "WORTHTABBK" then
									if SN < "WORTHTABBO" then
										if SN < "WORTHTABBM" then
											if SN == "WORTHTABBL" then
												if Lm <= 35 then
													return 126600;
												elseif Lm <= 46 then
													return 150600;
												elseif Lm <= 47 then
													return 180720;
												else
													return 150600;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABBM" then
											if SN == "WORTHTABBN" then
												if Lm <= 1 then
													return 400;
												else
													return 20*L+800;
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 10;
											else
												return 20*L-20;
											end
										end
									elseif SN > "WORTHTABBO" then
										if SN < "WORTHTABBQ" then
											if SN == "WORTHTABBP" then
												if Lm <= 10 then
													return 156.25*L+1562.5;
												elseif Lm <= 20 then
													return 312.5*L;
												elseif Lm <= 30 then
													return 625*L-6250;
												elseif Lm <= 40 then
													return 1250*L-25000;
												else
													return 2500*L-75000;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABBQ" then
											if SN == "WORTHTABBR" then
												if Lm <= 49 then
													return CalcStat("WorthTabBQ",L)*2;
												else
													return 4*L+250;
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 50;
											elseif Lm <= 49 then
												return RoundDbl(2.5*L+100);
											else
												return 3*L+75;
											end
										end
									else
										if Lm <= 10 then
											return 10;
										elseif Lm <= 40 then
											return RoundDbl(0.1*L-0.55)*50-25;
										elseif Lm <= 80 then
											return RoundDbl(0.1*L-0.55)*50;
										else
											return RoundDbl(0.1*L-0.55)*25+175;
										end
									end
								else
									if Lm <= 10 then
										return RoundDbl(0.1*L+0.45);
									else
										return RoundDbl(0.1*L-0.6)*2;
									end
								end
							else
								if Lm <= 34 then
									return RoundDbl(L/15+0.8)*3750+1250;
								elseif Lm <= 35 then
									return 100000;
								else
									return 125500;
								end
							end
						else
							return CalcStat("WorthTabAQ",L);
						end
					elseif SN > "WORTHTABBS" then
						if SN < "WORTHTABI" then
							if SN < "WORTHTABCG" then
								if SN < "WORTHTABBZ" then
									if SN < "WORTHTABBV" then
										if SN > "WORTHTABBT" then
											if SN == "WORTHTABBU" then
												if Lm <= 80 then
													return 20*L+300;
												else
													return 10*L+1100;
												end
											else
												return 0;
											end
										elseif SN == "WORTHTABBT" then
											return 62500;
										else
											return 0;
										end
									elseif SN > "WORTHTABBV" then
										if SN < "WORTHTABBX" then
											if SN == "WORTHTABBW" then
												if Lm <= 1 then
													return 645;
												elseif Lm <= 9 then
													return 20*L+980;
												else
													return 50*L+920;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABBX" then
											if SN == "WORTHTABBY" then
												return 90000;
											else
												return 0;
											end
										else
											if Lm <= 10 then
												return RoundDbl(0.1*L+0.45)*3;
											elseif Lm <= 140 then
												return RoundDbl(0.1*L-0.6)*6;
											else
												return RoundDbl(0.1*L+0.4)*4+22;
											end
										end
									else
										if Lm <= 29 then
											return 1250;
										else
											return RoundDbl(0.05*L-1)*2500;
										end
									end
								elseif SN > "WORTHTABBZ" then
									if SN < "WORTHTABCC" then
										if SN < "WORTHTABCA" then
											if SN == "WORTHTABC" then
												return CalcStat("WorthTabD",L)+20;
											else
												return 0;
											end
										elseif SN > "WORTHTABCA" then
											if SN == "WORTHTABCB" then
												return 0.1;
											else
												return 0;
											end
										else
											if Lm <= 10 then
												return 7.25*L+72.25;
											elseif Lm <= 20 then
												return 14.49*L+0.11;
											elseif Lm <= 30 then
												return 29*L-290;
											elseif Lm <= 35 then
												return 57.99*L-1160.16;
											elseif Lm <= 40 then
												return 57.99*L-1160.12;
											elseif Lm <= 80 then
												return 115.94*L-3478.2;
											else
												return 116*L-3483;
											end
										end
									elseif SN > "WORTHTABCC" then
										if SN < "WORTHTABCE" then
											if SN == "WORTHTABCD" then
												return CalcStat("WorthTabBK",L)*25;
											else
												return 0;
											end
										elseif SN > "WORTHTABCE" then
											if SN == "WORTHTABCF" then
												if Lm <= 20 then
													return RoundDbl(0.1*L-0.55)*600+200;
												elseif Lm <= 40 then
													return RoundDbl(0.1*L-0.55)*1000-500;
												elseif Lm <= 60 then
													return RoundDbl(0.1*L-0.55)*2000-4000;
												elseif Lm <= 70 then
													return 8500;
												elseif Lm <= 140 then
													return RoundDbl(0.1*L-0.55)*2500-7500;
												elseif Lm <= 200 then
													return RoundDbl(0.1*L-0.55)*3000-14000;
												else
													return RoundDbl(0.1*L-0.55)*2500-3500;
												end
											else
												return 0;
											end
										else
											return CalcStat("WorthTabBN",L)*10;
										end
									else
										return CalcStat("WorthTabBK",L)*5;
									end
								else
									if Lm <= 10 then
										return 27.42*L+273.1;
									elseif Lm <= 20 then
										return 54.69*L;
									elseif Lm <= 30 then
										return 109.35*L-1093;
									elseif Lm <= 40 then
										return 218.75*L-4375;
									elseif Lm <= 80 then
										return 437.5*L-13125;
									else
										return 437*L-13085;
									end
								end
							elseif SN > "WORTHTABCG" then
								if SN < "WORTHTABCN" then
									if SN < "WORTHTABCJ" then
										if SN > "WORTHTABCH" then
											if SN == "WORTHTABCI" then
												return 40000;
											else
												return 0;
											end
										elseif SN == "WORTHTABCH" then
											return 50000;
										else
											return 0;
										end
									elseif SN > "WORTHTABCJ" then
										if SN < "WORTHTABCL" then
											if SN == "WORTHTABCK" then
												return 15000;
											else
												return 0;
											end
										elseif SN > "WORTHTABCL" then
											if SN == "WORTHTABCM" then
												return 7500;
											else
												return 0;
											end
										else
											return 12500;
										end
									else
										return 20000;
									end
								elseif SN > "WORTHTABCN" then
									if SN < "WORTHTABE" then
										if SN < "WORTHTABCP" then
											if SN == "WORTHTABCO" then
												return CalcStat("WorthTabAB",L);
											else
												return 0;
											end
										elseif SN > "WORTHTABCP" then
											if SN == "WORTHTABD" then
												if Lm <= 49 then
													return 7.5*L;
												else
													return 8*L-25;
												end
											else
												return 0;
											end
										else
											return 1;
										end
									elseif SN > "WORTHTABE" then
										if SN < "WORTHTABG" then
											if SN == "WORTHTABF" then
												return 0.1;
											else
												return 0;
											end
										elseif SN > "WORTHTABG" then
											if SN == "WORTHTABH" then
												if Lm <= 2 then
													return L;
												elseif Lm <= 9 then
													return 1.48*L-2.85;
												elseif Lm <= 11 then
													return 2.5*L-13;
												elseif Lm <= 24 then
													return 2.5*L-10;
												else
													return 5*L-70;
												end
											else
												return 0;
											end
										else
											if Lm <= 1 then
												return 50;
											else
												return CalcStat("WorthTabAF",L)+100;
											end
										end
									else
										if Lm <= 9 then
											return 30*L+50;
										else
											return 7*L+280;
										end
									end
								else
									return RoundDbl(0.1*L+0.5)*10000;
								end
							else
								return 20;
							end
						elseif SN > "WORTHTABI" then
							if SN < "WORTHTABX" then
								if SN < "WORTHTABP" then
									if SN < "WORTHTABL" then
										if SN > "WORTHTABJ" then
											if SN == "WORTHTABK" then
												if Lm <= 9 then
													return 12*L+24;
												else
													return 7*L+74;
												end
											else
												return 0;
											end
										elseif SN == "WORTHTABJ" then
											if Lm <= 4 then
												return 2.5*L+7.5;
											elseif Lm <= 5 then
												return 23;
											else
												return 4*L;
											end
										else
											return 0;
										end
									elseif SN > "WORTHTABL" then
										if SN < "WORTHTABN" then
											if SN == "WORTHTABM" then
												if Lm <= 9 then
													return 10*L+11;
												elseif Lm <= 49 then
													return 4*L+65;
												else
													return 5*L+15;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABN" then
											if SN == "WORTHTABO" then
												return CalcStat("WorthTabB",L)+11;
											else
												return 0;
											end
										else
											return CalcStat("WorthTabAF",L)+25;
										end
									else
										return CalcStat("WorthTabB",L)+19.25;
									end
								elseif SN > "WORTHTABP" then
									if SN < "WORTHTABT" then
										if SN < "WORTHTABR" then
											if SN == "WORTHTABQ" then
												return 7*L+25;
											else
												return 0;
											end
										elseif SN > "WORTHTABR" then
											if SN == "WORTHTABS" then
												return CalcStat("WorthTabD",L)+17.5;
											else
												return 0;
											end
										else
											if Lm <= 9 then
												return 12*L+30;
											else
												return 7*L+75;
											end
										end
									elseif SN > "WORTHTABT" then
										if SN < "WORTHTABV" then
											if SN == "WORTHTABU" then
												if Lm <= 10 then
													return 9*L+20;
												elseif Lm <= 49 then
													return 5.5*L+55;
												else
													return 6*L+30;
												end
											else
												return 0;
											end
										elseif SN > "WORTHTABV" then
											if SN == "WORTHTABW" then
												return CalcStat("WorthTabD",L)+25;
											else
												return 0;
											end
										else
											return CalcStat("WorthTabB",L)-2.75;
										end
									else
										if Lm <= 1 then
											return 54;
										elseif Lm <= 17 then
											return 10.73*L+43.57;
										elseif Lm <= 35 then
											return 10.735*L+43.265;
										elseif Lm <= 36 then
											return 429;
										elseif Lm <= 42 then
											return 10.65*L+46.45;
										elseif Lm <= 49 then
											return 10.7*L+44.6;
										else
											return 9*L+130;
										end
									end
								else
									return CalcStat("WorthTabE",L);
								end
							elseif SN > "WORTHTABX" then
								if SN < "WORTHVALAE" then
									if SN < "WORTHVALAA" then
										if SN < "WORTHTABZ" then
											if SN == "WORTHTABY" then
												return CalcStat("WorthTabD",L)+30;
											else
												return 0;
											end
										elseif SN > "WORTHTABZ" then
											if SN == "WORTHVALA" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabA"));
											else
												return 0;
											end
										else
											return CalcStat("WorthTabR",L)-15;
										end
									elseif SN > "WORTHVALAA" then
										if SN < "WORTHVALAC" then
											if SN == "WORTHVALAB" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAB"));
											else
												return 0;
											end
										elseif SN > "WORTHVALAC" then
											if SN == "WORTHVALAD" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAD"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAC"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAA"));
									end
								elseif SN > "WORTHVALAE" then
									if SN < "WORTHVALAI" then
										if SN < "WORTHVALAG" then
											if SN == "WORTHVALAF" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAF"));
											else
												return 0;
											end
										elseif SN > "WORTHVALAG" then
											if SN == "WORTHVALAH" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAH"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAG"));
										end
									elseif SN > "WORTHVALAI" then
										if SN < "WORTHVALAK" then
											if SN == "WORTHVALAJ" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAJ"));
											else
												return 0;
											end
										elseif SN > "WORTHVALAK" then
											if SN == "WORTHVALAL" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAL"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAK"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAI"));
									end
								else
									return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAE"));
								end
							else
								return CalcStat("WorthTabAF",L)+75;
							end
						else
							if Lm <= 4 then
								return 1;
							elseif Lm <= 10 then
								return 0.7*L-1;
							elseif Lm <= 15 then
								return 1.4*L-7;
							elseif Lm <= 24 then
								return 1.25*L-5;
							elseif Lm <= 49 then
								return 2.5*L-35;
							else
								return 3*L-60;
							end
						end
					else
						return CalcStat("WorthTabBR",L)*2;
					end
				elseif SN > "WORTHVALAM" then
					if SN < "WORTHVALG" then
						if SN < "WORTHVALBP" then
							if SN < "WORTHVALBA" then
								if SN < "WORTHVALAT" then
									if SN < "WORTHVALAP" then
										if SN > "WORTHVALAN" then
											if SN == "WORTHVALAO" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAO"));
											else
												return 0;
											end
										elseif SN == "WORTHVALAN" then
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAN"));
										else
											return 0;
										end
									elseif SN > "WORTHVALAP" then
										if SN < "WORTHVALAR" then
											if SN == "WORTHVALAQ" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAQ"));
											else
												return 0;
											end
										elseif SN > "WORTHVALAR" then
											if SN == "WORTHVALAS" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAS"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAR"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAP"));
									end
								elseif SN > "WORTHVALAT" then
									if SN < "WORTHVALAX" then
										if SN < "WORTHVALAV" then
											if SN == "WORTHVALAU" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAU"));
											else
												return 0;
											end
										elseif SN > "WORTHVALAV" then
											if SN == "WORTHVALAW" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAW"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAV"));
										end
									elseif SN > "WORTHVALAX" then
										if SN < "WORTHVALAZ" then
											if SN == "WORTHVALAY" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAY"));
											else
												return 0;
											end
										elseif SN > "WORTHVALAZ" then
											if SN == "WORTHVALB" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabB"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAZ"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAX"));
									end
								else
									return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAT"));
								end
							elseif SN > "WORTHVALBA" then
								if SN < "WORTHVALBH" then
									if SN < "WORTHVALBD" then
										if SN > "WORTHVALBB" then
											if SN == "WORTHVALBC" then
												return RoundDbl(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBC"));
											else
												return 0;
											end
										elseif SN == "WORTHVALBB" then
											return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBB"));
										else
											return 0;
										end
									elseif SN > "WORTHVALBD" then
										if SN < "WORTHVALBF" then
											if SN == "WORTHVALBE" then
												return RoundDbl(CalcStat("WorthMpJ",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBE"));
											else
												return 0;
											end
										elseif SN > "WORTHVALBF" then
											if SN == "WORTHVALBG" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBG"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBF"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBD"));
									end
								elseif SN > "WORTHVALBH" then
									if SN < "WORTHVALBL" then
										if SN < "WORTHVALBJ" then
											if SN == "WORTHVALBI" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBI"));
											else
												return 0;
											end
										elseif SN > "WORTHVALBJ" then
											if SN == "WORTHVALBK" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBK"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBJ"));
										end
									elseif SN > "WORTHVALBL" then
										if SN < "WORTHVALBN" then
											if SN == "WORTHVALBM" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBM"));
											else
												return 0;
											end
										elseif SN > "WORTHVALBN" then
											if SN == "WORTHVALBO" then
												return RoundDbl(CalcStat("WorthMpG",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBO"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBN"));
										end
									else
										return RoundDbl(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBL"));
									end
								else
									return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBH"));
								end
							else
								return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBA"));
							end
						elseif SN > "WORTHVALBP" then
							if SN < "WORTHVALCD" then
								if SN < "WORTHVALBW" then
									if SN < "WORTHVALBS" then
										if SN > "WORTHVALBQ" then
											if SN == "WORTHVALBR" then
												return RoundDbl(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBR"));
											else
												return 0;
											end
										elseif SN == "WORTHVALBQ" then
											return RoundDbl(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBQ"));
										else
											return 0;
										end
									elseif SN > "WORTHVALBS" then
										if SN < "WORTHVALBU" then
											if SN == "WORTHVALBT" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBT"));
											else
												return 0;
											end
										elseif SN > "WORTHVALBU" then
											if SN == "WORTHVALBV" then
												return RoundDbl(CalcStat("WorthMpD",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBV"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpF",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBU"));
										end
									else
										return RoundDbl(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBS"));
									end
								elseif SN > "WORTHVALBW" then
									if SN < "WORTHVALC" then
										if SN < "WORTHVALBY" then
											if SN == "WORTHVALBX" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBX"));
											else
												return 0;
											end
										elseif SN > "WORTHVALBY" then
											if SN == "WORTHVALBZ" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBZ"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpE",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBY"));
										end
									elseif SN > "WORTHVALC" then
										if SN < "WORTHVALCB" then
											if SN == "WORTHVALCA" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCA"));
											else
												return 0;
											end
										elseif SN > "WORTHVALCB" then
											if SN == "WORTHVALCC" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCC"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCB"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabC"));
									end
								else
									return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBW"));
								end
							elseif SN > "WORTHVALCD" then
								if SN < "WORTHVALCL" then
									if SN < "WORTHVALCH" then
										if SN < "WORTHVALCF" then
											if SN == "WORTHVALCE" then
												return RoundDbl(CalcStat("WorthMpH",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCE"));
											else
												return 0;
											end
										elseif SN > "WORTHVALCF" then
											if SN == "WORTHVALCG" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCG"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCF"));
										end
									elseif SN > "WORTHVALCH" then
										if SN < "WORTHVALCJ" then
											if SN == "WORTHVALCI" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCI"));
											else
												return 0;
											end
										elseif SN > "WORTHVALCJ" then
											if SN == "WORTHVALCK" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCK"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCJ"));
										end
									else
										return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCH"));
									end
								elseif SN > "WORTHVALCL" then
									if SN < "WORTHVALCP" then
										if SN < "WORTHVALCN" then
											if SN == "WORTHVALCM" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCM"));
											else
												return 0;
											end
										elseif SN > "WORTHVALCN" then
											if SN == "WORTHVALCO" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCO"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpI",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCN"));
										end
									elseif SN > "WORTHVALCP" then
										if SN < "WORTHVALE" then
											if SN == "WORTHVALD" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabD"));
											else
												return 0;
											end
										elseif SN > "WORTHVALE" then
											if SN == "WORTHVALF" then
												return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabF"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabE"));
										end
									else
										return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCP"));
									end
								else
									return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCL"));
								end
							else
								return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabCD"));
							end
						else
							return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabBP"));
						end
					elseif SN > "WORTHVALG" then
						if SN < "WRDBATSTRPCTOSSCRITDEF" then
							if SN < "WORTHVALV" then
								if SN < "WORTHVALN" then
									if SN < "WORTHVALJ" then
										if SN > "WORTHVALH" then
											if SN == "WORTHVALI" then
												return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabI"));
											else
												return 0;
											end
										elseif SN == "WORTHVALH" then
											return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabH"));
										else
											return 0;
										end
									elseif SN > "WORTHVALJ" then
										if SN < "WORTHVALL" then
											if SN == "WORTHVALK" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabK"));
											else
												return 0;
											end
										elseif SN > "WORTHVALL" then
											if SN == "WORTHVALM" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabM"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabL"));
										end
									else
										return RoundDbl(CalcStat("WorthMpA",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabJ"));
									end
								elseif SN > "WORTHVALN" then
									if SN < "WORTHVALR" then
										if SN < "WORTHVALP" then
											if SN == "WORTHVALO" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabO"));
											else
												return 0;
											end
										elseif SN > "WORTHVALP" then
											if SN == "WORTHVALQ" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabQ"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabP"));
										end
									elseif SN > "WORTHVALR" then
										if SN < "WORTHVALT" then
											if SN == "WORTHVALS" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabS"));
											else
												return 0;
											end
										elseif SN > "WORTHVALT" then
											if SN == "WORTHVALU" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabU"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabT"));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabR"));
									end
								else
									return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabN"));
								end
							elseif SN > "WORTHVALV" then
								if SN < "WPNDMGMIN" then
									if SN < "WORTHVALZ" then
										if SN < "WORTHVALX" then
											if SN == "WORTHVALW" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabW"));
											else
												return 0;
											end
										elseif SN > "WORTHVALX" then
											if SN == "WORTHVALY" then
												return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabY"));
											else
												return 0;
											end
										else
											return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabX"));
										end
									elseif SN > "WORTHVALZ" then
										if SN < "WPNDMGMAX" then
											if SN == "WOUNDRESISTT" then
												return CalcStat("ResistAddT",L,N);
											else
												return 0;
											end
										elseif SN > "WPNDMGMAX" then
											if SN == "WPNDMGMAXMPTYPE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({1.25,1.25,40/31},L);
												end
											else
												return 0;
											end
										else
											return CalcStat("CombatBase",L,C)*CalcStat("WpnDmgMaxMPType",WpnCodeIndex(C,2));
										end
									else
										return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabZ"));
									end
								elseif SN > "WPNDMGMIN" then
									if SN < "WRDBATSTRIKES2BASE" then
										if SN < "WPNDPS" then
											if SN == "WPNDMGMINMPTYPE" then
												if Lm <= 0 then
													return 0;
												else
													return DataTableValue({0.75,0.75,22/31},L);
												end
											else
												return 0;
											end
										elseif SN > "WPNDPS" then
											if SN == "WRDBATSTRIKES1BASE" then
												if Lm <= 1 then
													return 4;
												elseif Lm <= 104 then
													return RoundDbl(1.336*L+1.336);
												elseif Lm <= 105 then
													return RoundDbl(CalcStat("WrdBatStrikes1Base",104)*6.0645*2/3);
												elseif Lm <= 114 then
													return RoundDbl(LinFmod(CalcStat("WrdBatStrikes1Base",105),1.5,2.995,106,115,L,0));
												elseif Lm <= 115 then
													return RoundDbl(CalcStat("WrdBatStrikes1Base",105)*3);
												else
													return 0;
												end
											else
												return 0;
											end
										else
											return CalcStat("CombatBase",L,C);
										end
									elseif SN > "WRDBATSTRIKES2BASE" then
										if SN < "WRDBATSTRIKESBASE" then
											if SN == "WRDBATSTRIKES3BASE" then
												if Lm <= 1 then
													return 12;
												elseif Lm <= 104 then
													return 4*L+4;
												elseif Lm <= 105 then
													return RoundDbl(CalcStat("WrdBatStrikes3Base",104)*6.0645);
												elseif Lm <= 115 then
													return RoundDbl(LinFmod(CalcStat("WrdBatStrikes3Base",105),1,2,106,115,L,0));
												else
													return 0;
												end
											else
												return 0;
											end
										elseif SN > "WRDBATSTRIKESBASE" then
											if SN == "WRDBATSTRJAVIRTCRITDEF" then
												if Lm <= 115 then
													return 1.2*1.2*CalcStat("WrdBatStrikesBase",N,L);
												else
													return CalcStat("ProgExtComLowRnd",L,CalcStat("WrdBatStrJaVirtCritDef",115,N));
												end
											else
												return 0;
											end
										else
											if Lm <= 0 then
												return 0;
											elseif Lm <= 1 then
												return CalcStat("WrdBatStrikes1Base",N);
											elseif Lm <= 2 then
												return CalcStat("WrdBatStrikes2Base",N);
											else
												return CalcStat("WrdBatStrikes3Base",N);
											end
										end
									else
										if Lm <= 1 then
											return 8;
										elseif Lm <= 104 then
											return RoundDbl(2.664*L+2.664);
										elseif Lm <= 105 then
											return RoundDbl(CalcStat("WrdBatStrikes2Base",104)*6.0645);
										elseif Lm <= 114 then
											return RoundDbl(LinFmod(CalcStat("WrdBatStrikes2Base",105),1,2.002,106,115,L,0));
										elseif Lm <= 115 then
											return RoundDbl(CalcStat("WrdBatStrikes2Base",105)*2);
										else
											return 0;
										end
									end
								else
									return CalcStat("CombatBase",L,C)*CalcStat("WpnDmgMinMPType",WpnCodeIndex(C,2));
								end
							else
								return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabV"));
							end
						elseif SN > "WRDBATSTRPCTOSSCRITDEF" then
							if SN < "WRDIMPRFLOURPHYMIT" then
								if SN < "WRDCRITPROTCRITDEFP" then
									if SN < "WRDCAREFSHWPERSBLOCK" then
										if SN > "WRDBATSTRPRTHRWCRITDEF" then
											if SN == "WRDCAREFSHWPERSBASE" then
												return ((6.464/5)*L)*N;
											else
												return 0;
											end
										elseif SN == "WRDBATSTRPRTHRWCRITDEF" then
											if Lm <= 115 then
												return CalcStat("WrdBatStrikesBase",N,L);
											else
												return CalcStat("ProgExtComLowRnd",L,CalcStat("WrdBatStrPrThrwCritDef",115,N));
											end
										else
											return 0;
										end
									elseif SN > "WRDCAREFSHWPERSBLOCK" then
										if SN < "WRDCAREFSHWSAFEGBLOCK" then
											if SN == "WRDCAREFSHWSAFEGBASE" then
												return ((9.696/5)*L)*N;
											else
												return 0;
											end
										elseif SN > "WRDCAREFSHWSAFEGBLOCK" then
											if SN == "WRDCRITDEF" then
												if Lm <= 105 then
													return RoundDbl(20.2*L);
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdCritDef",105));
												end
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(CalcStat("WrdCarefShwSafegBase",L,CalcStat("Trait12345Choice",N)));
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdCarefShwSafegBlock",105,N));
											end
										end
									else
										if Lm <= 105 then
											return RoundDbl(CalcStat("WrdCarefShwPersBase",L,CalcStat("Trait12345Choice",N)));
										else
											return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdCarefShwPersBlock",105,N));
										end
									end
								elseif SN > "WRDCRITPROTCRITDEFP" then
									if SN < "WRDFIREATWILLTACMAS" then
										if SN < "WRDFINESSE" then
											if SN == "WRDELEGANTFINSODBP" then
												if Lm <= 105 then
													return 16*L;
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdElegantFinSoDBP",105));
												end
											else
												return 0;
											end
										elseif SN > "WRDFINESSE" then
											if SN == "WRDFIREATWILLPHYMAS" then
												return CalcStat("PhyMasT",L,0.8);
											else
												return 0;
											end
										else
											return CalcStat("FinesseT",L,CalcStat("Trait12345Choice",N)*0.4);
										end
									elseif SN > "WRDFIREATWILLTACMAS" then
										if SN < "WRDIMPRFLOURCRITDEF" then
											if SN == "WRDIMPRFLOURCRITDBASE" then
												return ((3.232/5)*L)*N;
											else
												return 0;
											end
										elseif SN > "WRDIMPRFLOURCRITDEF" then
											if SN == "WRDIMPRFLOURMITBASE" then
												return ((2.424/5)*L)*N;
											else
												return 0;
											end
										else
											if Lm <= 105 then
												return RoundDbl(CalcStat("WrdImprFlourCritDBase",L,CalcStat("Trait12345Choice",N)));
											else
												return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdImprFlourCritDef",105,N));
											end
										end
									else
										return CalcStat("TacMasT",L,0.8);
									end
								else
									return CalcStat("Trait12347Choice",N)*0.01;
								end
							elseif SN > "WRDIMPRFLOURPHYMIT" then
								if SN < "WRDSHIELDTACTICSTACMIT" then
									if SN < "WRDPIERCINGJAVBASE" then
										if SN < "WRDPHYMAS" then
											if SN == "WRDIMPRFLOURTACMIT" then
												if Lm <= 105 then
													return RoundDbl(CalcStat("WrdImprFlourMitBase",L,CalcStat("Trait12345Choice",N)));
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdImprFlourTacMit",105,N));
												end
											else
												return 0;
											end
										elseif SN > "WRDPHYMAS" then
											if SN == "WRDPIERCINGJAVARMOUR" then
												if Lm <= 105 then
													return RoundDbl(CalcStat("WrdPiercingJavBase",L,CalcStat("Trait123Choice",N)));
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdPiercingJavArmour",105,N));
												end
											else
												return 0;
											end
										else
											return CalcStat("PhyMasT",L,CalcStat("Trait12345Choice",N)*0.4);
										end
									elseif SN > "WRDPIERCINGJAVBASE" then
										if SN < "WRDSHIELDMASBLOCK" then
											if SN == "WRDRECKLESSNCRITHIT" then
												return CalcStat("CritHitT",L,2.4);
											else
												return 0;
											end
										elseif SN > "WRDSHIELDMASBLOCK" then
											if SN == "WRDSHIELDMASEVADE" then
												return CalcStat("EvadeT",L,2.4);
											else
												return 0;
											end
										else
											return CalcStat("BlockT",L,2.8);
										end
									else
										return ((20.4525/5)*L)*N;
									end
								elseif SN > "WRDSHIELDTACTICSTACMIT" then
									if SN < "WRDSTDYOURGREVADE" then
										if SN < "WRDSTDYOURGRBASE" then
											if SN == "WRDSSSHPIERCERBLOCK" then
												return -CalcStat("BlockT",L,4);
											else
												return 0;
											end
										elseif SN > "WRDSTDYOURGRBASE" then
											if SN == "WRDSTDYOURGRBLOCK" then
												if Lm <= 105 then
													return CalcStat("WrdStdYourGrBase",L,CalcStat("Trait123Choice",N));
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdStdYourGrBlock",105,N));
												end
											else
												return 0;
											end
										else
											return 4*L*N;
										end
									elseif SN > "WRDSTDYOURGREVADE" then
										if SN < "WRDWARCRYBASE" then
											if SN == "WRDSTDYOURGRPARRY" then
												if Lm <= 105 then
													return CalcStat("WrdStdYourGrBase",L,CalcStat("Trait123Choice",N));
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdStdYourGrParry",105,N));
												end
											else
												return 0;
											end
										elseif SN > "WRDWARCRYBASE" then
											if SN == "WRDWARCRYEVADE" then
												if Lm <= 105 then
													return RoundDbl(CalcStat("WrdWarcryBase",L,CalcStat("Trait12345Choice",N)));
												else
													return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdWarcryEvade",105,N));
												end
											else
												return 0;
											end
										else
											return ((6.464/5)*L)*N;
										end
									else
										if Lm <= 105 then
											return -CalcStat("WrdStdYourGrBase",L,CalcStat("Trait123Choice",N));
										else
											return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdStdYourGrEvade",105,N));
										end
									end
								else
									return CalcStat("TacMitT",L,2);
								end
							else
								if Lm <= 105 then
									return RoundDbl(CalcStat("WrdImprFlourMitBase",L,CalcStat("Trait12345Choice",N)));
								else
									return CalcStat("ProgExtHighLinExpRnd",L,CalcStat("WrdImprFlourPhyMit",105,N));
								end
							end
						else
							if Lm <= 115 then
								return 1.2*CalcStat("WrdBatStrikesBase",N,L);
							else
								return CalcStat("ProgExtComLowRnd",L,CalcStat("WrdBatStrPcTossCritDef",115,N));
							end
						end
					else
						return RoundDbl(CalcStat("WorthMpC",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabG"));
					end
				else
					return RoundDbl(CalcStat("WorthMpB",QualityCodeIndex(C))*CalcStat("WorthExt",L,"WorthTabAM"));
				end
			else
				return CalcStat("Main",L,N);
			end
		else
			if Lm <= 50 then
				return LinFmod(1,CalcStat("StatProg",1,N),RoundDbl(N)*30,1,50,L);
			elseif Lm <= 105 then
				return LinFmod(1,RoundDbl(N)*30,CalcStat("StatProg",105,N),50,105,L);
			else
				return CalcStat("StatProg",L,N);
			end
		end
	else
		if Lm <= 130 then
			return CalcStat("BratProg",L,CalcStat("ProgBMitHeavy",L));
		else
			return CalcStat("BratProg",L,CalcStat("ProgBMitHeavyNew",L));
		end
	end

end

-- Support functions for CalcStat. These consist of implementations of more complex calculation types, decode methods for parameter "C" and rounding/min/max/compare functions for floating point numbers.

-- ****************** Calculation Type support functions ******************

-- DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
-- DataTableValue: Takes a value from an array table.

function DataTableValue(vDataArray, lIndex)

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
			local dDec;
			if -DblCalcDev <= vDec and vDec <= DblCalcDev then
				dDec = 1;
			else
				dDec = 10^vDec;
			end
			dFac = dFac*dDec;
			dAdd = dAdd*dDec+0.5+DblCalcDev;
			local dL = dLstart-DblCalcDev;
			while dL <= dLvl do
				dResult = math.floor(dResult*dFac+dAdd)/dDec;
				dL = dL+1;
			end
			return dResult;
		end
	end

end

-- PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
-- CalcPercAB: Calculates the percentage out of a rating based on the AB formula.

function CalcPercAB(dA, dB, dPCap, dR)

	if dR <= DblCalcDev then
		return 0;
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
		return 0;
	else
		local dResult = dB/(dA/dP-1);
		if dResult >= dCapR-DblCalcDev then
			return dCapR;
		else
			return dResult;
		end
	end

end

-- TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
-- LinFmod: Linear line function between 2 points with some optional modifications.
-- Connects point (dLstart,dVal*dFstart) with (dLend,dVal*dFend).
-- Usually used with dVal=1 and dFstart/dFend containing unrelated points or dVal=# and dFstart/dFend containing multiplier factors.
-- Modification for in-between points on the line: rounding.

function LinFmod(dVal, dFstart, dFend, dLstart, dLend, dLvl, vDec)

	if dLstart-DblCalcDev <= dLvl and dLvl <= dLstart+DblCalcDev then
		return dVal*dFstart;
	elseif dLend-DblCalcDev <= dLvl and dLvl <= dLend+DblCalcDev then
		return dVal*dFend;
	elseif vDec == nil then
		return dVal*(dFstart*(dLend-dLvl)+(dLvl-dLstart)*dFend)/(dLend-dLstart);
	elseif -DblCalcDev <= vDec and vDec <= DblCalcDevl then
		return math.floor(dVal*(dFstart*(dLend-dLvl)+(dLvl-dLstart)*dFend)/(dLend-dLstart)+0.5+DblCalcDev);
	else
		return math.floor((dVal*(dFstart*(dLend-dLvl)+(dLvl-dLstart)*dFend)/(dLend-dLstart))*10^vDec+0.5+DblCalcDev)/10^vDec;
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
		local minlvl = 1;
		local maxlvl = 500;
		local devlvl = 3;
	
		local left = minlvl-1;
		local right = maxlvl;
		local middle;
		
		local count = minlvl;

		while right > left+1 and count <= maxlvl do
			count = count+1;
			middle = math.floor((left+right)/2+DblCalcDev);
			if CalcStat(sStat,middle)+DblCalcDev >= dNum then
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
			if  dNum-DblCalcDev <= dFound and dFound <= dNum+DblCalcDev then
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

	if vDec == nil or (-DblCalcDev <= vDec and vDec <= DblCalcDev) then
		return math.floor(dNum+0.5+DblCalcDev);
	else
		return math.floor(dNum*10^vDec+0.5+DblCalcDev)/10^vDec;
	end
	
end

function FloorDbl(dNum, vDec)

	if vDec == nil or (-DblCalcDev <= vDec and vDec <= DblCalcDev) then
		return math.floor(dNum+DblCalcDev);
	else
		return math.floor(dNum*10^vDec+DblCalcDev)/10^vDec;
	end

end

function CeilDbl(dNum, vDec)

	if vDec == nil or (-DblCalcDev <= vDec and vDec <= DblCalcDev) then
		return math.floor(dNum+1-DblCalcDev);
	else
		return math.floor(dNum*10^vDec+1-DblCalcDev)/10^vDec;
	end
	
end

function LotroDbl(dNum)

	local dNumCeiled = CeilDbl(dNum,0);

	if -DblCalcDev <= dNumCeiled and dNumCeiled <= DblCalcDev then
		return 0;
	else
		local dLen;
		if dNumCeiled > DblCalcDev then
			dLen = math.floor(math.log10(dNumCeiled)+DblCalcDev)+1;
		else
			dLen = math.floor(math.log10(-dNumCeiled)+DblCalcDev)+1;
		end
		local dDec = 3-dLen;
		if dDec < -DblCalcDev then 
			return CeilDbl(dNum,dDec);
		else
			return dNumCeiled;
		end
	end

end
