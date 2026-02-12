------------------------------------------------------------------------------------------
-- CalcStat file
-- Written by Giseldah
-- Version 2.1
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

	if SN < "PARTBPEPBONUS" then
		if SN < "HUNTERCDARMOURTYPE" then
			if SN < "CRITDEFPRATPCAPR" then
				if SN < "BPEPRATPB" then
					if SN < "BLOCKPPRAT" then
						if SN < "ARMOURT" then
							if SN < "ADJTRAITPROGRATINGS" then
								if SN == "-VERSION" then
									return "2.1p";
								else
									return 0;
								end
							elseif SN > "ADJTRAITPROGRATINGS" then
								if SN > "ARMOURPENT" then
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
								elseif SN == "ARMOURPENT" then
									return StatLinInter("PntMPArmour","TraitProg","ProgBMitigation","ArmourPenTAdj",L,N);
								else
									return 0;
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
						elseif SN > "ARMOURT" then
							if SN < "BEORNINGCDARMOURTYPE" then
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
							elseif SN > "BEORNINGCDARMOURTYPE" then
								if SN > "BEORNINGCDCANBLOCK" then
									if SN == "BLOCKPBONUS" then
										return CalcStat("BPEPBonus",L);
									else
										return 0;
									end
								elseif SN == "BEORNINGCDCANBLOCK" then
									if Lm <= 5 then
										return 0;
									else
										return 1;
									end
								else
									return 0;
								end
							else
								return 3;
							end
						else
							return StatLinInter("PntMPArmour","TraitProg","ProgBMitigation","ArmourTAdj",L,N);
						end
					elseif SN > "BLOCKPPRAT" then
						if SN < "BLOCKPRATPCAP" then
							if SN < "BLOCKPRATPA" then
								if SN == "BLOCKPRATP" then
									return CalcStat("BPEPRatP",L,N);
								else
									return 0;
								end
							elseif SN > "BLOCKPRATPA" then
								if SN > "BLOCKPRATPB" then
									if SN == "BLOCKPRATPC" then
										return CalcStat("BPEPRatPC",L);
									else
										return 0;
									end
								elseif SN == "BLOCKPRATPB" then
									return CalcStat("BPEPRatPB",L);
								else
									return 0;
								end
							else
								return CalcStat("BPEPRatPA",L);
							end
						elseif SN > "BLOCKPRATPCAP" then
							if SN < "BPEPPRAT" then
								if SN > "BLOCKPRATPCAPR" then
									if SN == "BPEPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "BLOCKPRATPCAPR" then
									return CalcStat("BPEPRatPCapR",L);
								else
									return 0;
								end
							elseif SN > "BPEPPRAT" then
								if SN > "BPEPRATP" then
									if SN == "BPEPRATPA" then
										if Lm <= 130 then
											return 26;
										else
											return 39;
										end
									else
										return 0;
									end
								elseif SN == "BPEPRATP" then
									return CalcPercAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCap",L),N);
								else
									return 0;
								end
							else
								return CalcRatAB(CalcStat("BPEPRatPA",L),CalcStat("BPEPRatPB",L),CalcStat("BPEPRatPCapR",L),N);
							end
						else
							return CalcStat("BPEPRatPCap",L);
						end
					else
						return CalcStat("BPEPPRat",L,N);
					end
				elseif SN > "BPEPRATPB" then
					if SN < "CAPTAINCDCANBLOCK" then
						if SN < "BPETADJ" then
							if SN < "BPEPRATPCAP" then
								if SN == "BPEPRATPC" then
									if Lm <= 130 then
										return 1;
									else
										return 0.5;
									end
								else
									return 0;
								end
							elseif SN > "BPEPRATPCAP" then
								if SN > "BPEPRATPCAPR" then
									if SN == "BPET" then
										return StatLinInter("PntMPRatings","TraitProgAlt","ProgBLow","BPETAdj",L,N);
									else
										return 0;
									end
								elseif SN == "BPEPRATPCAPR" then
									return CalcStat("BPEPRatPB",L)*CalcStat("BPEPRatPC",L);
								else
									return 0;
								end
							else
								return 13;
							end
						elseif SN > "BPETADJ" then
							if SN < "BRAWLERCDARMOURTYPE" then
								if SN > "BRATPROG" then
									if SN == "BRATPROGALT" then
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
									else
										return 0;
									end
								elseif SN == "BRATPROG" then
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
							elseif SN > "BRAWLERCDARMOURTYPE" then
								if SN > "BURGLARCDARMOURTYPE" then
									if SN == "CAPTAINCDARMOURTYPE" then
										return 3;
									else
										return 0;
									end
								elseif SN == "BURGLARCDARMOURTYPE" then
									return 2;
								else
									return 0;
								end
							else
								return 3;
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
					elseif SN > "CAPTAINCDCANBLOCK" then
						if SN < "CRITDEFPPRAT" then
							if SN < "CHAMPIONCDCANBLOCK" then
								if SN == "CHAMPIONCDARMOURTYPE" then
									return 3;
								else
									return 0;
								end
							elseif SN > "CHAMPIONCDCANBLOCK" then
								if SN > "CORSAIRCDARMOURTYPE" then
									if SN == "CRITDEFPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "CORSAIRCDARMOURTYPE" then
									return 2;
								else
									return 0;
								end
							else
								if Lm <= 9 then
									return 0;
								else
									return 1;
								end
							end
						elseif SN > "CRITDEFPPRAT" then
							if SN < "CRITDEFPRATPB" then
								if SN > "CRITDEFPRATP" then
									if SN == "CRITDEFPRATPA" then
										if Lm <= 130 then
											return 160;
										else
											return 240;
										end
									else
										return 0;
									end
								elseif SN == "CRITDEFPRATP" then
									return CalcPercAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCap",L),N);
								else
									return 0;
								end
							elseif SN > "CRITDEFPRATPB" then
								if SN > "CRITDEFPRATPC" then
									if SN == "CRITDEFPRATPCAP" then
										return 80;
									else
										return 0;
									end
								elseif SN == "CRITDEFPRATPC" then
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
						else
							return CalcRatAB(CalcStat("CritDefPRatPA",L),CalcStat("CritDefPRatPB",L),CalcStat("CritDefPRatPCapR",L),N);
						end
					else
						if Lm <= 14 then
							return 0;
						else
							return 1;
						end
					end
				else
					if Lm <= 130 then
						return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
					else
						return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
					end
				end
			elseif SN > "CRITDEFPRATPCAPR" then
				if SN < "DEVHITPRATPB" then
					if SN < "CRITMAGNPPRAT" then
						if SN < "CRITHITPRATPB" then
							if SN < "CRITHITPPRAT" then
								if SN == "CRITHITPBONUS" then
									return 0;
								else
									return 0;
								end
							elseif SN > "CRITHITPPRAT" then
								if SN > "CRITHITPRATP" then
									if SN == "CRITHITPRATPA" then
										if Lm <= 130 then
											return 50;
										else
											return 75;
										end
									else
										return 0;
									end
								elseif SN == "CRITHITPRATP" then
									return CalcPercAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCap",L),N);
								else
									return 0;
								end
							else
								return CalcRatAB(CalcStat("CritHitPRatPA",L),CalcStat("CritHitPRatPB",L),CalcStat("CritHitPRatPCapR",L),N);
							end
						elseif SN > "CRITHITPRATPB" then
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
								if SN > "CRITHITPRATPCAPR" then
									if SN == "CRITMAGNPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "CRITHITPRATPCAPR" then
									return CalcStat("CritHitPRatPB",L)*CalcStat("CritHitPRatPC",L);
								else
									return 0;
								end
							else
								return 25;
							end
						else
							if Lm <= 130 then
								return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
							else
								return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
							end
						end
					elseif SN > "CRITMAGNPPRAT" then
						if SN < "CRITMAGNPRATPCAP" then
							if SN < "CRITMAGNPRATPA" then
								if SN == "CRITMAGNPRATP" then
									return CalcPercAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCap",L),N);
								else
									return 0;
								end
							elseif SN > "CRITMAGNPRATPA" then
								if SN > "CRITMAGNPRATPB" then
									if SN == "CRITMAGNPRATPC" then
										return CalcStat("CritMagnPRatPCAP",L)/(CalcStat("CritMagnPRatPA",L)-CalcStat("CritMagnPRatPCAP",L));
									else
										return 0;
									end
								elseif SN == "CRITMAGNPRATPB" then
									if Lm <= 130 then
										return CalcStat("BratProg",L,CalcStat("ProgBHigh",L));
									else
										return CalcStat("BratProg",L,CalcStat("ProgBHighNew",L));
									end
								else
									return 0;
								end
							else
								if Lm <= 120 then
									return 200;
								elseif Lm <= 127 then
									return (-5)*L+750;
								elseif Lm <= 130 then
									return 112.5;
								else
									return 225;
								end
							end
						elseif SN > "CRITMAGNPRATPCAP" then
							if SN < "DEVHITPPRAT" then
								if SN > "CRITMAGNPRATPCAPR" then
									if SN == "DEVHITPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "CRITMAGNPRATPCAPR" then
									return CalcStat("CritMagnPRatPB",L)*CalcStat("CritMagnPRatPC",L);
								else
									return 0;
								end
							elseif SN > "DEVHITPPRAT" then
								if SN > "DEVHITPRATP" then
									if SN == "DEVHITPRATPA" then
										if Lm <= 130 then
											return 20;
										else
											return 30;
										end
									else
										return 0;
									end
								elseif SN == "DEVHITPRATP" then
									return CalcPercAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCap",L),N);
								else
									return 0;
								end
							else
								return CalcRatAB(CalcStat("DevHitPRatPA",L),CalcStat("DevHitPRatPB",L),CalcStat("DevHitPRatPCapR",L),N);
							end
						else
							if Lm <= 120 then
								return 100;
							else
								return 75;
							end
						end
					else
						return CalcRatAB(CalcStat("CritMagnPRatPA",L),CalcStat("CritMagnPRatPB",L),CalcStat("CritMagnPRatPCapR",L),N);
					end
				elseif SN > "DEVHITPRATPB" then
					if SN < "EVADEPRATPCAPR" then
						if SN < "EVADEPPRAT" then
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
								if SN > "DEVHITPRATPCAPR" then
									if SN == "EVADEPBONUS" then
										return CalcStat("BPEPBonus",L);
									else
										return 0;
									end
								elseif SN == "DEVHITPRATPCAPR" then
									return CalcStat("DevHitPRatPB",L)*CalcStat("DevHitPRatPC",L);
								else
									return 0;
								end
							else
								return 10;
							end
						elseif SN > "EVADEPPRAT" then
							if SN < "EVADEPRATPB" then
								if SN > "EVADEPRATP" then
									if SN == "EVADEPRATPA" then
										return CalcStat("BPEPRatPA",L);
									else
										return 0;
									end
								elseif SN == "EVADEPRATP" then
									return CalcStat("BPEPRatP",L,N);
								else
									return 0;
								end
							elseif SN > "EVADEPRATPB" then
								if SN > "EVADEPRATPC" then
									if SN == "EVADEPRATPCAP" then
										return CalcStat("BPEPRatPCap",L);
									else
										return 0;
									end
								elseif SN == "EVADEPRATPC" then
									return CalcStat("BPEPRatPC",L);
								else
									return 0;
								end
							else
								return CalcStat("BPEPRatPB",L);
							end
						else
							return CalcStat("BPEPPRat",L,N);
						end
					elseif SN > "EVADEPRATPCAPR" then
						if SN < "FINESSEPRATPB" then
							if SN < "FINESSEPPRAT" then
								if SN == "FINESSEPBONUS" then
									return 0;
								else
									return 0;
								end
							elseif SN > "FINESSEPPRAT" then
								if SN > "FINESSEPRATP" then
									if SN == "FINESSEPRATPA" then
										if Lm <= 130 then
											return 100;
										else
											return 150;
										end
									else
										return 0;
									end
								elseif SN == "FINESSEPRATP" then
									return CalcPercAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCap",L),N);
								else
									return 0;
								end
							else
								return CalcRatAB(CalcStat("FinessePRatPA",L),CalcStat("FinessePRatPB",L),CalcStat("FinessePRatPCapR",L),N);
							end
						elseif SN > "FINESSEPRATPB" then
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
								if SN > "GUARDIANCDARMOURTYPE" then
									if SN == "GUARDIANCDCANBLOCK" then
										return 1;
									else
										return 0;
									end
								elseif SN == "GUARDIANCDARMOURTYPE" then
									return 3;
								else
									return 0;
								end
							else
								return CalcStat("FinessePRatPB",L)*CalcStat("FinessePRatPC",L);
							end
						else
							if Lm <= 130 then
								return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
							else
								return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
							end
						end
					else
						return CalcStat("BPEPRatPCapR",L);
					end
				else
					if Lm <= 130 then
						return CalcStat("BratProg",L,CalcStat("ProgBMedium",L));
					else
						return CalcStat("BratProg",L,CalcStat("ProgBMediumNew",L));
					end
				end
			else
				return CalcStat("CritDefPRatPB",L)*CalcStat("CritDefPRatPC",L);
			end
		elseif SN > "HUNTERCDARMOURTYPE" then
			if SN < "MITMEDIUMPRATPB" then
				if SN < "MINSTRELCDARMOURTYPE" then
					if SN < "INHEALPPRAT" then
						if SN < "INDMGPRATPB" then
							if SN < "INDMGPPRAT" then
								if SN == "INDMGPBONUS" then
									return 0;
								else
									return 0;
								end
							elseif SN > "INDMGPPRAT" then
								if SN > "INDMGPRATP" then
									if SN == "INDMGPRATPA" then
										if Lm <= 130 then
											return 800;
										else
											return 1200;
										end
									else
										return 0;
									end
								elseif SN == "INDMGPRATP" then
									return CalcPercAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCap",L),N);
								else
									return 0;
								end
							else
								return CalcRatAB(CalcStat("InDmgPRatPA",L),CalcStat("InDmgPRatPB",L),CalcStat("InDmgPRatPCapR",L),N);
							end
						elseif SN > "INDMGPRATPB" then
							if SN < "INDMGPRATPCAP" then
								if SN == "INDMGPRATPC" then
									if Lm <= 130 then
										return 1;
									else
										return 0.5;
									end
								else
									return 0;
								end
							elseif SN > "INDMGPRATPCAP" then
								if SN > "INDMGPRATPCAPR" then
									if SN == "INHEALPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "INDMGPRATPCAPR" then
									return CalcStat("InDmgPRatPB",L)*CalcStat("InDmgPRatPC",L);
								else
									return 0;
								end
							else
								return 400;
							end
						else
							if Lm <= 130 then
								return CalcStat("BratProg",L,CalcStat("ProgBDefence",L));
							else
								return CalcStat("BratProg",L,CalcStat("ProgBDefenceNew",L));
							end
						end
					elseif SN > "INHEALPPRAT" then
						if SN < "INHEALPRATPCAP" then
							if SN < "INHEALPRATPA" then
								if SN == "INHEALPRATP" then
									return CalcPercAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCap",L),N);
								else
									return 0;
								end
							elseif SN > "INHEALPRATPA" then
								if SN > "INHEALPRATPB" then
									if SN == "INHEALPRATPC" then
										if Lm <= 130 then
											return 1;
										else
											return 0.5;
										end
									else
										return 0;
									end
								elseif SN == "INHEALPRATPB" then
									if Lm <= 130 then
										return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
									else
										return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
									end
								else
									return 0;
								end
							else
								if Lm <= 130 then
									return 50;
								else
									return 75;
								end
							end
						elseif SN > "INHEALPRATPCAP" then
							if SN < "LOREMASTERCDARMOURTYPE" then
								if SN > "INHEALPRATPCAPR" then
									if SN == "LEVELCAP" then
										return 140;
									else
										return 0;
									end
								elseif SN == "INHEALPRATPCAPR" then
									return CalcStat("InHealPRatPB",L)*CalcStat("InHealPRatPC",L);
								else
									return 0;
								end
							elseif SN > "LOREMASTERCDARMOURTYPE" then
								if SN > "LVLEXPCOST" then
									if SN == "LVLEXPCOSTTOT" then
										if Lm <= 1 then
											return 0;
										else
											return CalcStat("LvlExpCostTot",L-1)+CalcStat("LvlExpCost",L);
										end
									else
										return 0;
									end
								elseif SN == "LVLEXPCOST" then
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
								return 1;
							end
						else
							return 25;
						end
					else
						return CalcRatAB(CalcStat("InHealPRatPA",L),CalcStat("InHealPRatPB",L),CalcStat("InHealPRatPCapR",L),N);
					end
				elseif SN > "MINSTRELCDARMOURTYPE" then
					if SN < "MITLIGHTPPRAT" then
						if SN < "MITHEAVYPRATPA" then
							if SN < "MITHEAVYPBONUS" then
								if SN == "MINSTRELCDCANBLOCK" then
									if Lm <= 19 then
										return 0;
									else
										return 1;
									end
								else
									return 0;
								end
							elseif SN > "MITHEAVYPBONUS" then
								if SN > "MITHEAVYPPRAT" then
									if SN == "MITHEAVYPRATP" then
										return CalcPercAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCap",L),N);
									else
										return 0;
									end
								elseif SN == "MITHEAVYPPRAT" then
									return CalcRatAB(CalcStat("MitHeavyPRatPA",L),CalcStat("MitHeavyPRatPB",L),CalcStat("MitHeavyPRatPCapR",L),N);
								else
									return 0;
								end
							else
								return 0;
							end
						elseif SN > "MITHEAVYPRATPA" then
							if SN < "MITHEAVYPRATPCAP" then
								if SN > "MITHEAVYPRATPB" then
									if SN == "MITHEAVYPRATPC" then
										if Lm <= 130 then
											return 1.2;
										else
											return 0.5;
										end
									else
										return 0;
									end
								elseif SN == "MITHEAVYPRATPB" then
									if Lm <= 130 then
										return CalcStat("BratProg",L,CalcStat("ProgBMitHeavy",L));
									else
										return CalcStat("BratProg",L,CalcStat("ProgBMitHeavyNew",L));
									end
								else
									return 0;
								end
							elseif SN > "MITHEAVYPRATPCAP" then
								if SN > "MITHEAVYPRATPCAPR" then
									if SN == "MITLIGHTPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "MITHEAVYPRATPCAPR" then
									return CalcStat("MitHeavyPRatPB",L)*CalcStat("MitHeavyPRatPC",L);
								else
									return 0;
								end
							else
								return 60;
							end
						else
							if Lm <= 130 then
								return 110;
							else
								return 180;
							end
						end
					elseif SN > "MITLIGHTPPRAT" then
						if SN < "MITLIGHTPRATPCAP" then
							if SN < "MITLIGHTPRATPA" then
								if SN == "MITLIGHTPRATP" then
									return CalcPercAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCap",L),N);
								else
									return 0;
								end
							elseif SN > "MITLIGHTPRATPA" then
								if SN > "MITLIGHTPRATPB" then
									if SN == "MITLIGHTPRATPC" then
										if Lm <= 130 then
											return 1.6;
										else
											return 0.5;
										end
									else
										return 0;
									end
								elseif SN == "MITLIGHTPRATPB" then
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
						elseif SN > "MITLIGHTPRATPCAP" then
							if SN < "MITMEDIUMPPRAT" then
								if SN > "MITLIGHTPRATPCAPR" then
									if SN == "MITMEDIUMPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "MITLIGHTPRATPCAPR" then
									return CalcStat("MitLightPRatPB",L)*CalcStat("MitLightPRatPC",L);
								else
									return 0;
								end
							elseif SN > "MITMEDIUMPPRAT" then
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
							else
								return CalcRatAB(CalcStat("MitMediumPRatPA",L),CalcStat("MitMediumPRatPB",L),CalcStat("MitMediumPRatPCapR",L),N);
							end
						else
							return 40;
						end
					else
						return CalcRatAB(CalcStat("MitLightPRatPA",L),CalcStat("MitLightPRatPB",L),CalcStat("MitLightPRatPCapR",L),N);
					end
				else
					return 1;
				end
			elseif SN > "MITMEDIUMPRATPB" then
				if SN < "PARRYPRATP" then
					if SN < "OUTDMGPRATPCAPR" then
						if SN < "OUTDMGPPRAT" then
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
								if SN > "MITMEDIUMPRATPCAPR" then
									if SN == "OUTDMGPBONUS" then
										return 0;
									else
										return 0;
									end
								elseif SN == "MITMEDIUMPRATPCAPR" then
									return CalcStat("MitMediumPRatPB",L)*CalcStat("MitMediumPRatPC",L);
								else
									return 0;
								end
							else
								return 50;
							end
						elseif SN > "OUTDMGPPRAT" then
							if SN < "OUTDMGPRATPB" then
								if SN > "OUTDMGPRATP" then
									if SN == "OUTDMGPRATPA" then
										if Lm <= 130 then
											return 400;
										else
											return 600;
										end
									else
										return 0;
									end
								elseif SN == "OUTDMGPRATP" then
									return CalcPercAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCap",L),N);
								else
									return 0;
								end
							elseif SN > "OUTDMGPRATPB" then
								if SN > "OUTDMGPRATPC" then
									if SN == "OUTDMGPRATPCAP" then
										return 200;
									else
										return 0;
									end
								elseif SN == "OUTDMGPRATPC" then
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
									return CalcStat("BratProg",L,CalcStat("ProgBMastery",L));
								else
									return CalcStat("BratProg",L,CalcStat("ProgBMasteryNew",L));
								end
							end
						else
							return CalcRatAB(CalcStat("OutDmgPRatPA",L),CalcStat("OutDmgPRatPB",L),CalcStat("OutDmgPRatPCapR",L),N);
						end
					elseif SN > "OUTDMGPRATPCAPR" then
						if SN < "OUTHEALPRATPB" then
							if SN < "OUTHEALPPRAT" then
								if SN == "OUTHEALPBONUS" then
									return 0;
								else
									return 0;
								end
							elseif SN > "OUTHEALPPRAT" then
								if SN > "OUTHEALPRATP" then
									if SN == "OUTHEALPRATPA" then
										if Lm <= 130 then
											return 140;
										else
											return 210;
										end
									else
										return 0;
									end
								elseif SN == "OUTHEALPRATP" then
									return CalcPercAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCap",L),N);
								else
									return 0;
								end
							else
								return CalcRatAB(CalcStat("OutHealPRatPA",L),CalcStat("OutHealPRatPB",L),CalcStat("OutHealPRatPCapR",L),N);
							end
						elseif SN > "OUTHEALPRATPB" then
							if SN < "OUTHEALPRATPCAPR" then
								if SN > "OUTHEALPRATPC" then
									if SN == "OUTHEALPRATPCAP" then
										return 70;
									else
										return 0;
									end
								elseif SN == "OUTHEALPRATPC" then
									if Lm <= 130 then
										return 1;
									else
										return 0.5;
									end
								else
									return 0;
								end
							elseif SN > "OUTHEALPRATPCAPR" then
								if SN > "PARRYPBONUS" then
									if SN == "PARRYPPRAT" then
										return CalcStat("BPEPPRat",L,N);
									else
										return 0;
									end
								elseif SN == "PARRYPBONUS" then
									return CalcStat("BPEPBonus",L);
								else
									return 0;
								end
							else
								return CalcStat("OutHealPRatPB",L)*CalcStat("OutHealPRatPC",L);
							end
						else
							if Lm <= 130 then
								return CalcStat("BratProg",L,CalcStat("ProgBMedium",L));
							else
								return CalcStat("BratProg",L,CalcStat("ProgBMediumNew",L));
							end
						end
					else
						return CalcStat("OutDmgPRatPB",L)*CalcStat("OutDmgPRatPC",L);
					end
				elseif SN > "PARRYPRATP" then
					if SN < "PARTBLOCKMITPRATPC" then
						if SN < "PARRYPRATPCAPR" then
							if SN < "PARRYPRATPB" then
								if SN == "PARRYPRATPA" then
									return CalcStat("BPEPRatPA",L);
								else
									return 0;
								end
							elseif SN > "PARRYPRATPB" then
								if SN > "PARRYPRATPC" then
									if SN == "PARRYPRATPCAP" then
										return CalcStat("BPEPRatPCap",L);
									else
										return 0;
									end
								elseif SN == "PARRYPRATPC" then
									return CalcStat("BPEPRatPC",L);
								else
									return 0;
								end
							else
								return CalcStat("BPEPRatPB",L);
							end
						elseif SN > "PARRYPRATPCAPR" then
							if SN < "PARTBLOCKMITPRATP" then
								if SN > "PARTBLOCKMITPBONUS" then
									if SN == "PARTBLOCKMITPPRAT" then
										return CalcStat("PartMitPPRat",L,N);
									else
										return 0;
									end
								elseif SN == "PARTBLOCKMITPBONUS" then
									return CalcStat("PartMitPBonus",L);
								else
									return 0;
								end
							elseif SN > "PARTBLOCKMITPRATP" then
								if SN > "PARTBLOCKMITPRATPA" then
									if SN == "PARTBLOCKMITPRATPB" then
										return CalcStat("PartMitPRatPB",L);
									else
										return 0;
									end
								elseif SN == "PARTBLOCKMITPRATPA" then
									return CalcStat("PartMitPRatPA",L);
								else
									return 0;
								end
							else
								return CalcStat("PartMitPRatP",L,N);
							end
						else
							return CalcStat("BPEPRatPCapR",L);
						end
					elseif SN > "PARTBLOCKMITPRATPC" then
						if SN < "PARTBLOCKPRATP" then
							if SN < "PARTBLOCKMITPRATPCAPR" then
								if SN == "PARTBLOCKMITPRATPCAP" then
									return CalcStat("PartMitPRatPCap",L);
								else
									return 0;
								end
							elseif SN > "PARTBLOCKMITPRATPCAPR" then
								if SN > "PARTBLOCKPBONUS" then
									if SN == "PARTBLOCKPPRAT" then
										return CalcStat("PartBPEPPRat",L,N);
									else
										return 0;
									end
								elseif SN == "PARTBLOCKPBONUS" then
									return CalcStat("PartBPEPBonus",L);
								else
									return 0;
								end
							else
								return CalcStat("PartMitPRatPCapR",L);
							end
						elseif SN > "PARTBLOCKPRATP" then
							if SN < "PARTBLOCKPRATPC" then
								if SN > "PARTBLOCKPRATPA" then
									if SN == "PARTBLOCKPRATPB" then
										return CalcStat("PartBPEPRatPB",L);
									else
										return 0;
									end
								elseif SN == "PARTBLOCKPRATPA" then
									return CalcStat("PartBPEPRatPA",L);
								else
									return 0;
								end
							elseif SN > "PARTBLOCKPRATPC" then
								if SN > "PARTBLOCKPRATPCAP" then
									if SN == "PARTBLOCKPRATPCAPR" then
										return CalcStat("PartBPEPRatPCapR",L);
									else
										return 0;
									end
								elseif SN == "PARTBLOCKPRATPCAP" then
									return CalcStat("PartBPEPRatPCap",L);
								else
									return 0;
								end
							else
								return CalcStat("PartBPEPRatPC",L);
							end
						else
							return CalcStat("PartBPEPRatP",L,N);
						end
					else
						return CalcStat("PartMitPRatPC",L);
					end
				else
					return CalcStat("BPEPRatP",L,N);
				end
			else
				if Lm <= 130 then
					return CalcStat("BratProg",L,CalcStat("ProgBMitMedium",L));
				else
					return CalcStat("BratProg",L,CalcStat("ProgBMitMediumNew",L));
				end
			end
		else
			return 2;
		end
	elseif SN > "PARTBPEPBONUS" then
		if SN < "PROGBLOWNEW" then
			if SN < "PARTPARRYPRATPA" then
				if SN < "PARTEVADEPRATPC" then
					if SN < "PARTEVADEMITPRATP" then
						if SN < "PARTBPEPRATPC" then
							if SN < "PARTBPEPRATP" then
								if SN == "PARTBPEPPRAT" then
									return CalcRatAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCapR",L),N);
								else
									return 0;
								end
							elseif SN > "PARTBPEPRATP" then
								if SN > "PARTBPEPRATPA" then
									if SN == "PARTBPEPRATPB" then
										if Lm <= 130 then
											return CalcStat("BratProgAlt",L,CalcStat("ProgBPartial",L));
										else
											return CalcStat("BratProgAlt",L,CalcStat("ProgBPartialNew",L));
										end
									else
										return 0;
									end
								elseif SN == "PARTBPEPRATPA" then
									if Lm <= 130 then
										return 70;
									else
										return 75;
									end
								else
									return 0;
								end
							else
								return CalcPercAB(CalcStat("PartBPEPRatPA",L),CalcStat("PartBPEPRatPB",L),CalcStat("PartBPEPRatPCap",L),N);
							end
						elseif SN > "PARTBPEPRATPC" then
							if SN < "PARTBPEPRATPCAPR" then
								if SN == "PARTBPEPRATPCAP" then
									if Lm <= 130 then
										return 35;
									else
										return 25;
									end
								else
									return 0;
								end
							elseif SN > "PARTBPEPRATPCAPR" then
								if SN > "PARTEVADEMITPBONUS" then
									if SN == "PARTEVADEMITPPRAT" then
										return CalcStat("PartMitPPRat",L,N);
									else
										return 0;
									end
								elseif SN == "PARTEVADEMITPBONUS" then
									return CalcStat("PartMitPBonus",L);
								else
									return 0;
								end
							else
								return CalcStat("PartBPEPRatPB",L)*CalcStat("PartBPEPRatPC",L);
							end
						else
							if Lm <= 130 then
								return 1;
							else
								return 0.5;
							end
						end
					elseif SN > "PARTEVADEMITPRATP" then
						if SN < "PARTEVADEMITPRATPCAPR" then
							if SN < "PARTEVADEMITPRATPB" then
								if SN == "PARTEVADEMITPRATPA" then
									return CalcStat("PartMitPRatPA",L);
								else
									return 0;
								end
							elseif SN > "PARTEVADEMITPRATPB" then
								if SN > "PARTEVADEMITPRATPC" then
									if SN == "PARTEVADEMITPRATPCAP" then
										return CalcStat("PartMitPRatPCap",L);
									else
										return 0;
									end
								elseif SN == "PARTEVADEMITPRATPC" then
									return CalcStat("PartMitPRatPC",L);
								else
									return 0;
								end
							else
								return CalcStat("PartMitPRatPB",L);
							end
						elseif SN > "PARTEVADEMITPRATPCAPR" then
							if SN < "PARTEVADEPRATP" then
								if SN > "PARTEVADEPBONUS" then
									if SN == "PARTEVADEPPRAT" then
										return CalcStat("PartBPEPPRat",L,N);
									else
										return 0;
									end
								elseif SN == "PARTEVADEPBONUS" then
									return CalcStat("PartBPEPBonus",L);
								else
									return 0;
								end
							elseif SN > "PARTEVADEPRATP" then
								if SN > "PARTEVADEPRATPA" then
									if SN == "PARTEVADEPRATPB" then
										return CalcStat("PartBPEPRatPB",L);
									else
										return 0;
									end
								elseif SN == "PARTEVADEPRATPA" then
									return CalcStat("PartBPEPRatPA",L);
								else
									return 0;
								end
							else
								return CalcStat("PartBPEPRatP",L,N);
							end
						else
							return CalcStat("PartMitPRatPCapR",L);
						end
					else
						return CalcStat("PartMitPRatP",L,N);
					end
				elseif SN > "PARTEVADEPRATPC" then
					if SN < "PARTPARRYMITPBONUS" then
						if SN < "PARTMITPRATP" then
							if SN < "PARTEVADEPRATPCAPR" then
								if SN == "PARTEVADEPRATPCAP" then
									return CalcStat("PartBPEPRatPCap",L);
								else
									return 0;
								end
							elseif SN > "PARTEVADEPRATPCAPR" then
								if SN > "PARTMITPBONUS" then
									if SN == "PARTMITPPRAT" then
										return CalcRatAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCapR",L),N);
									else
										return 0;
									end
								elseif SN == "PARTMITPBONUS" then
									return 0.1;
								else
									return 0;
								end
							else
								return CalcStat("PartBPEPRatPCapR",L);
							end
						elseif SN > "PARTMITPRATP" then
							if SN < "PARTMITPRATPC" then
								if SN > "PARTMITPRATPA" then
									if SN == "PARTMITPRATPB" then
										if Lm <= 130 then
											return CalcStat("BratProgAlt",L,CalcStat("ProgBPartial",L));
										else
											return CalcStat("BratProgAlt",L,CalcStat("ProgBPartialNew",L));
										end
									else
										return 0;
									end
								elseif SN == "PARTMITPRATPA" then
									if Lm <= 130 then
										return 100;
									else
										return 105;
									end
								else
									return 0;
								end
							elseif SN > "PARTMITPRATPC" then
								if SN > "PARTMITPRATPCAP" then
									if SN == "PARTMITPRATPCAPR" then
										return CalcStat("PartMitPRatPB",L)*CalcStat("PartMitPRatPC",L);
									else
										return 0;
									end
								elseif SN == "PARTMITPRATPCAP" then
									if Lm <= 130 then
										return 50;
									else
										return 35;
									end
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
							return CalcPercAB(CalcStat("PartMitPRatPA",L),CalcStat("PartMitPRatPB",L),CalcStat("PartMitPRatPCap",L),N);
						end
					elseif SN > "PARTPARRYMITPBONUS" then
						if SN < "PARTPARRYMITPRATPC" then
							if SN < "PARTPARRYMITPRATP" then
								if SN == "PARTPARRYMITPPRAT" then
									return CalcStat("PartMitPPRat",L,N);
								else
									return 0;
								end
							elseif SN > "PARTPARRYMITPRATP" then
								if SN > "PARTPARRYMITPRATPA" then
									if SN == "PARTPARRYMITPRATPB" then
										return CalcStat("PartMitPRatPB",L);
									else
										return 0;
									end
								elseif SN == "PARTPARRYMITPRATPA" then
									return CalcStat("PartMitPRatPA",L);
								else
									return 0;
								end
							else
								return CalcStat("PartMitPRatP",L,N);
							end
						elseif SN > "PARTPARRYMITPRATPC" then
							if SN < "PARTPARRYPBONUS" then
								if SN > "PARTPARRYMITPRATPCAP" then
									if SN == "PARTPARRYMITPRATPCAPR" then
										return CalcStat("PartMitPRatPCapR",L);
									else
										return 0;
									end
								elseif SN == "PARTPARRYMITPRATPCAP" then
									return CalcStat("PartMitPRatPCap",L);
								else
									return 0;
								end
							elseif SN > "PARTPARRYPBONUS" then
								if SN > "PARTPARRYPPRAT" then
									if SN == "PARTPARRYPRATP" then
										return CalcStat("PartBPEPRatP",L,N);
									else
										return 0;
									end
								elseif SN == "PARTPARRYPPRAT" then
									return CalcStat("PartBPEPPRat",L,N);
								else
									return 0;
								end
							else
								return CalcStat("PartBPEPBonus",L);
							end
						else
							return CalcStat("PartMitPRatPC",L);
						end
					else
						return CalcStat("PartMitPBonus",L);
					end
				else
					return CalcStat("PartBPEPRatPC",L);
				end
			elseif SN > "PARTPARRYPRATPA" then
				if SN < "PHYMITLPPRAT" then
					if SN < "PHYDMGPRATPCAP" then
						if SN < "PHYDMGPBONUS" then
							if SN < "PARTPARRYPRATPC" then
								if SN == "PARTPARRYPRATPB" then
									return CalcStat("PartBPEPRatPB",L);
								else
									return 0;
								end
							elseif SN > "PARTPARRYPRATPC" then
								if SN > "PARTPARRYPRATPCAP" then
									if SN == "PARTPARRYPRATPCAPR" then
										return CalcStat("PartBPEPRatPCapR",L);
									else
										return 0;
									end
								elseif SN == "PARTPARRYPRATPCAP" then
									return CalcStat("PartBPEPRatPCap",L);
								else
									return 0;
								end
							else
								return CalcStat("PartBPEPRatPC",L);
							end
						elseif SN > "PHYDMGPBONUS" then
							if SN < "PHYDMGPRATPA" then
								if SN > "PHYDMGPPRAT" then
									if SN == "PHYDMGPRATP" then
										return CalcStat("OutDmgPRatP",L,N);
									else
										return 0;
									end
								elseif SN == "PHYDMGPPRAT" then
									return CalcStat("OutDmgPPRat",L,N);
								else
									return 0;
								end
							elseif SN > "PHYDMGPRATPA" then
								if SN > "PHYDMGPRATPB" then
									if SN == "PHYDMGPRATPC" then
										return CalcStat("OutDmgPRatPC",L);
									else
										return 0;
									end
								elseif SN == "PHYDMGPRATPB" then
									return CalcStat("OutDmgPRatPB",L);
								else
									return 0;
								end
							else
								return CalcStat("OutDmgPRatPA",L);
							end
						else
							return CalcStat("OutDmgPBonus",L);
						end
					elseif SN > "PHYDMGPRATPCAP" then
						if SN < "PHYMITHPRATPA" then
							if SN < "PHYMITHPBONUS" then
								if SN == "PHYDMGPRATPCAPR" then
									return CalcStat("OutDmgPRatPCapR",L);
								else
									return 0;
								end
							elseif SN > "PHYMITHPBONUS" then
								if SN > "PHYMITHPPRAT" then
									if SN == "PHYMITHPRATP" then
										return CalcStat("MitHeavyPRatP",L,N);
									else
										return 0;
									end
								elseif SN == "PHYMITHPPRAT" then
									return CalcStat("MitHeavyPPRat",L,N);
								else
									return 0;
								end
							else
								return CalcStat("MitHeavyPBonus",L);
							end
						elseif SN > "PHYMITHPRATPA" then
							if SN < "PHYMITHPRATPCAP" then
								if SN > "PHYMITHPRATPB" then
									if SN == "PHYMITHPRATPC" then
										return CalcStat("MitHeavyPRatPC",L);
									else
										return 0;
									end
								elseif SN == "PHYMITHPRATPB" then
									return CalcStat("MitHeavyPRatPB",L);
								else
									return 0;
								end
							elseif SN > "PHYMITHPRATPCAP" then
								if SN > "PHYMITHPRATPCAPR" then
									if SN == "PHYMITLPBONUS" then
										return CalcStat("MitLightPBonus",L);
									else
										return 0;
									end
								elseif SN == "PHYMITHPRATPCAPR" then
									return CalcStat("MitHeavyPRatPCapR",L);
								else
									return 0;
								end
							else
								return CalcStat("MitHeavyPRatPCap",L);
							end
						else
							return CalcStat("MitHeavyPRatPA",L);
						end
					else
						return CalcStat("OutDmgPRatPCap",L);
					end
				elseif SN > "PHYMITLPPRAT" then
					if SN < "PHYMITMPRATPB" then
						if SN < "PHYMITLPRATPCAP" then
							if SN < "PHYMITLPRATPA" then
								if SN == "PHYMITLPRATP" then
									return CalcStat("MitLightPRatP",L,N);
								else
									return 0;
								end
							elseif SN > "PHYMITLPRATPA" then
								if SN > "PHYMITLPRATPB" then
									if SN == "PHYMITLPRATPC" then
										return CalcStat("MitLightPRatPC",L);
									else
										return 0;
									end
								elseif SN == "PHYMITLPRATPB" then
									return CalcStat("MitLightPRatPB",L);
								else
									return 0;
								end
							else
								return CalcStat("MitLightPRatPA",L);
							end
						elseif SN > "PHYMITLPRATPCAP" then
							if SN < "PHYMITMPPRAT" then
								if SN > "PHYMITLPRATPCAPR" then
									if SN == "PHYMITMPBONUS" then
										return CalcStat("MitMediumPBonus",L);
									else
										return 0;
									end
								elseif SN == "PHYMITLPRATPCAPR" then
									return CalcStat("MitLightPRatPCapR",L);
								else
									return 0;
								end
							elseif SN > "PHYMITMPPRAT" then
								if SN > "PHYMITMPRATP" then
									if SN == "PHYMITMPRATPA" then
										return CalcStat("MitMediumPRatPA",L);
									else
										return 0;
									end
								elseif SN == "PHYMITMPRATP" then
									return CalcStat("MitMediumPRatP",L,N);
								else
									return 0;
								end
							else
								return CalcStat("MitMediumPPRat",L,N);
							end
						else
							return CalcStat("MitLightPRatPCap",L);
						end
					elseif SN > "PHYMITMPRATPB" then
						if SN < "PNTMPRATINGS" then
							if SN < "PHYMITMPRATPCAP" then
								if SN == "PHYMITMPRATPC" then
									return CalcStat("MitMediumPRatPC",L);
								else
									return 0;
								end
							elseif SN > "PHYMITMPRATPCAP" then
								if SN > "PHYMITMPRATPCAPR" then
									if SN == "PNTMPARMOUR" then
										return 24375/247000;
									else
										return 0;
									end
								elseif SN == "PHYMITMPRATPCAPR" then
									return CalcStat("MitMediumPRatPCapR",L);
								else
									return 0;
								end
							else
								return CalcStat("MitMediumPRatPCap",L);
							end
						elseif SN > "PNTMPRATINGS" then
							if SN < "PROGBHIGH" then
								if SN > "PROGBDEFENCE" then
									if SN == "PROGBDEFENCENEW" then
										return 532;
									else
										return 0;
									end
								elseif SN == "PROGBDEFENCE" then
									return 266;
								else
									return 0;
								end
							elseif SN > "PROGBHIGH" then
								if SN > "PROGBHIGHNEW" then
									if SN == "PROGBLOW" then
										return 200;
									else
										return 0;
									end
								elseif SN == "PROGBHIGHNEW" then
									return 10000/6;
								else
									return 0;
								end
							else
								return 500;
							end
						else
							return 14820/247000;
						end
					else
						return CalcStat("MitMediumPRatPB",L);
					end
				else
					return CalcStat("MitLightPPRat",L,N);
				end
			else
				return CalcStat("PartBPEPRatPA",L);
			end
		elseif SN > "PROGBLOWNEW" then
			if SN < "TACDMGPBONUS" then
				if SN < "RESISTPRATPC" then
					if SN < "PROGBMITMEDIUM" then
						if SN < "PROGBMITHEAVY" then
							if SN < "PROGBMASTERYNEW" then
								if SN == "PROGBMASTERY" then
									return 270;
								else
									return 0;
								end
							elseif SN > "PROGBMASTERYNEW" then
								if SN > "PROGBMEDIUM" then
									if SN == "PROGBMEDIUMNEW" then
										return 800;
									else
										return 0;
									end
								elseif SN == "PROGBMEDIUM" then
									return 400;
								else
									return 0;
								end
							else
								return 540;
							end
						elseif SN > "PROGBMITHEAVY" then
							if SN < "PROGBMITIGATION" then
								if SN == "PROGBMITHEAVYNEW" then
									return 401.6;
								else
									return 0;
								end
							elseif SN > "PROGBMITIGATION" then
								if SN > "PROGBMITLIGHT" then
									if SN == "PROGBMITLIGHTNEW" then
										return 800/3;
									else
										return 0;
									end
								elseif SN == "PROGBMITLIGHT" then
									return 280/3;
								else
									return 0;
								end
							else
								return CalcStat("ProgBMitMedium",L);
							end
						else
							return 174;
						end
					elseif SN > "PROGBMITMEDIUM" then
						if SN < "PROGEXTCOMLOWRAW" then
							if SN < "PROGBPARTIAL" then
								if SN == "PROGBMITMEDIUMNEW" then
									return 7040/21;
								else
									return 0;
								end
							elseif SN > "PROGBPARTIAL" then
								if SN > "PROGBPARTIALNEW" then
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
								elseif SN == "PROGBPARTIALNEW" then
									return 500;
								else
									return 0;
								end
							else
								return 350;
							end
						elseif SN > "PROGEXTCOMLOWRAW" then
							if SN < "RESISTPRATP" then
								if SN > "RESISTPBONUS" then
									if SN == "RESISTPPRAT" then
										return CalcRatAB(CalcStat("ResistPRatPA",L),CalcStat("ResistPRatPB",L),CalcStat("ResistPRatPCapR",L),N);
									else
										return 0;
									end
								elseif SN == "RESISTPBONUS" then
									return 0;
								else
									return 0;
								end
							elseif SN > "RESISTPRATP" then
								if SN > "RESISTPRATPA" then
									if SN == "RESISTPRATPB" then
										if Lm <= 130 then
											return CalcStat("BratProgAlt",L,CalcStat("ProgBLow",L));
										else
											return CalcStat("BratProgAlt",L,CalcStat("ProgBLowNew",L));
										end
									else
										return 0;
									end
								elseif SN == "RESISTPRATPA" then
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
						else
							if Lm <= 116 then
								return ExpFmod(N,116,20,L,nil);
							elseif Lm <= 120 then
								return ExpFmod(CalcStat("ProgExtComLowRaw",116,N),117,5.5,L,nil);
							else
								return CalcStat("ProgExtComHighRaw",L,CalcStat("ProgExtComLowRaw",120,N));
							end
						end
					else
						return 382/3;
					end
				elseif SN > "RESISTPRATPC" then
					if SN < "STATPROGLPL" then
						if SN < "RUNEKEEPERCDARMOURTYPE" then
							if SN < "RESISTPRATPCAPR" then
								if SN == "RESISTPRATPCAP" then
									return 50;
								else
									return 0;
								end
							elseif SN > "RESISTPRATPCAPR" then
								if SN > "RESISTT" then
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
								elseif SN == "RESISTT" then
									return StatLinInter("PntMPRatings","TraitProgAlt","ProgBLow","ResistTAdj",L,N);
								else
									return 0;
								end
							else
								return CalcStat("ResistPRatPB",L)*CalcStat("ResistPRatPC",L);
							end
						elseif SN > "RUNEKEEPERCDARMOURTYPE" then
							if SN < "STATPROGALTLPH" then
								if SN > "STATPROG" then
									if SN == "STATPROGALT" then
										if Lm <= 75 then
											return LinFmod(RoundDbl(N),1,75,1,75,L);
										elseif Lm <= 76 then
											return LinFmod(1,RoundDbl(N)*75,CalcStat("StdProgAlt",76,N),75,76,L);
										else
											return CalcStat("StdProgAlt",L,N);
										end
									else
										return 0;
									end
								elseif SN == "STATPROG" then
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
							elseif SN > "STATPROGALTLPH" then
								if SN > "STATPROGALTLPL" then
									if SN == "STATPROGLPH" then
										return CalcStat("StdProgLPH",L);
									else
										return 0;
									end
								elseif SN == "STATPROGALTLPL" then
									return CalcStat("StdProgAltLPL",L);
								else
									return 0;
								end
							else
								return CalcStat("StdProgAltLPH",L);
							end
						else
							return 1;
						end
					elseif SN > "STATPROGLPL" then
						if SN < "STDPROGLPH" then
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
								if SN > "STDPROGALTLPH" then
									if SN == "STDPROGALTLPL" then
										return CalcStat("StdProgLPL",L);
									else
										return 0;
									end
								elseif SN == "STDPROGALTLPH" then
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
						elseif SN > "STDPROGLPH" then
							if SN < "T2PENBPE" then
								if SN > "STDPROGLPL" then
									if SN == "T2PENARMOUR" then
										return CalcStat("T2penMit",L);
									else
										return 0;
									end
								elseif SN == "STDPROGLPL" then
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
								else
									return 0;
								end
							elseif SN > "T2PENBPE" then
								if SN > "T2PENMIT" then
									if SN == "T2PENRESIST" then
										if Lm <= 115 then
											return (-90)*L;
										else
											return CalcStat("ProgExtComLowRaw",L,CalcStat("T2PenResist",115));
										end
									else
										return 0;
									end
								elseif SN == "T2PENMIT" then
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
						else
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
						end
					else
						return CalcStat("StdProgLPL",L);
					end
				else
					if Lm <= 130 then
						return 1;
					else
						return 0.5;
					end
				end
			elseif SN > "TACDMGPBONUS" then
				if SN < "TACMITLPRATPCAP" then
					if SN < "TACMITHPRATPA" then
						if SN < "TACDMGPRATPC" then
							if SN < "TACDMGPRATP" then
								if SN == "TACDMGPPRAT" then
									return CalcStat("OutDmgPPRat",L,N);
								else
									return 0;
								end
							elseif SN > "TACDMGPRATP" then
								if SN > "TACDMGPRATPA" then
									if SN == "TACDMGPRATPB" then
										return CalcStat("OutDmgPRatPB",L);
									else
										return 0;
									end
								elseif SN == "TACDMGPRATPA" then
									return CalcStat("OutDmgPRatPA",L);
								else
									return 0;
								end
							else
								return CalcStat("OutDmgPRatP",L,N);
							end
						elseif SN > "TACDMGPRATPC" then
							if SN < "TACMITHPBONUS" then
								if SN > "TACDMGPRATPCAP" then
									if SN == "TACDMGPRATPCAPR" then
										return CalcStat("OutDmgPRatPCapR",L);
									else
										return 0;
									end
								elseif SN == "TACDMGPRATPCAP" then
									return CalcStat("OutDmgPRatPCap",L);
								else
									return 0;
								end
							elseif SN > "TACMITHPBONUS" then
								if SN > "TACMITHPPRAT" then
									if SN == "TACMITHPRATP" then
										return CalcStat("MitHeavyPRatP",L,N);
									else
										return 0;
									end
								elseif SN == "TACMITHPPRAT" then
									return CalcStat("MitHeavyPPRat",L,N);
								else
									return 0;
								end
							else
								return CalcStat("MitHeavyPBonus",L);
							end
						else
							return CalcStat("OutDmgPRatPC",L);
						end
					elseif SN > "TACMITHPRATPA" then
						if SN < "TACMITLPBONUS" then
							if SN < "TACMITHPRATPC" then
								if SN == "TACMITHPRATPB" then
									return CalcStat("MitHeavyPRatPB",L);
								else
									return 0;
								end
							elseif SN > "TACMITHPRATPC" then
								if SN > "TACMITHPRATPCAP" then
									if SN == "TACMITHPRATPCAPR" then
										return CalcStat("MitHeavyPRatPCapR",L);
									else
										return 0;
									end
								elseif SN == "TACMITHPRATPCAP" then
									return CalcStat("MitHeavyPRatPCap",L);
								else
									return 0;
								end
							else
								return CalcStat("MitHeavyPRatPC",L);
							end
						elseif SN > "TACMITLPBONUS" then
							if SN < "TACMITLPRATPA" then
								if SN > "TACMITLPPRAT" then
									if SN == "TACMITLPRATP" then
										return CalcStat("MitLightPRatP",L,N);
									else
										return 0;
									end
								elseif SN == "TACMITLPPRAT" then
									return CalcStat("MitLightPPRat",L,N);
								else
									return 0;
								end
							elseif SN > "TACMITLPRATPA" then
								if SN > "TACMITLPRATPB" then
									if SN == "TACMITLPRATPC" then
										return CalcStat("MitLightPRatPC",L);
									else
										return 0;
									end
								elseif SN == "TACMITLPRATPB" then
									return CalcStat("MitLightPRatPB",L);
								else
									return 0;
								end
							else
								return CalcStat("MitLightPRatPA",L);
							end
						else
							return CalcStat("MitLightPBonus",L);
						end
					else
						return CalcStat("MitHeavyPRatPA",L);
					end
				elseif SN > "TACMITLPRATPCAP" then
					if SN < "TPENBPE" then
						if SN < "TACMITMPRATPA" then
							if SN < "TACMITMPBONUS" then
								if SN == "TACMITLPRATPCAPR" then
									return CalcStat("MitLightPRatPCapR",L);
								else
									return 0;
								end
							elseif SN > "TACMITMPBONUS" then
								if SN > "TACMITMPPRAT" then
									if SN == "TACMITMPRATP" then
										return CalcStat("MitMediumPRatP",L,N);
									else
										return 0;
									end
								elseif SN == "TACMITMPPRAT" then
									return CalcStat("MitMediumPPRat",L,N);
								else
									return 0;
								end
							else
								return CalcStat("MitMediumPBonus",L);
							end
						elseif SN > "TACMITMPRATPA" then
							if SN < "TACMITMPRATPCAP" then
								if SN > "TACMITMPRATPB" then
									if SN == "TACMITMPRATPC" then
										return CalcStat("MitMediumPRatPC",L);
									else
										return 0;
									end
								elseif SN == "TACMITMPRATPB" then
									return CalcStat("MitMediumPRatPB",L);
								else
									return 0;
								end
							elseif SN > "TACMITMPRATPCAP" then
								if SN > "TACMITMPRATPCAPR" then
									if SN == "TPENARMOUR" then
										return -CalcStat("ArmourPenT",L,CalcStat("TpenChoice",N)*2);
									else
										return 0;
									end
								elseif SN == "TACMITMPRATPCAPR" then
									return CalcStat("MitMediumPRatPCapR",L);
								else
									return 0;
								end
							else
								return CalcStat("MitMediumPRatPCap",L);
							end
						else
							return CalcStat("MitMediumPRatPA",L);
						end
					elseif SN > "TPENBPE" then
						if SN < "TRAITPROGALTLPH" then
							if SN < "TPENRESIST" then
								if SN == "TPENCHOICE" then
									return DataTableValue({0,1,2},L);
								else
									return 0;
								end
							elseif SN > "TPENRESIST" then
								if SN > "TRAITPROG" then
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
								elseif SN == "TRAITPROG" then
									if Lm <= 75 then
										return CalcStat("StatProg",L,N);
									elseif Lm <= 105 then
										return LinFmod(1,CalcStat("StatProg",75,N),CalcStat("StatProg",105,N),75,105,L);
									else
										return CalcStat("StatProg",L,N);
									end
								else
									return 0;
								end
							else
								return -CalcStat("ResistT",L,CalcStat("TpenChoice",N)*2);
							end
						elseif SN > "TRAITPROGALTLPH" then
							if SN < "TRAITPROGLPL" then
								if SN > "TRAITPROGALTLPL" then
									if SN == "TRAITPROGLPH" then
										if Lm <= 75 then
											return CalcStat("StatProgLPH",L);
										elseif Lm <= 105 then
											return 105;
										else
											return CalcStat("StatProgLPH",L);
										end
									else
										return 0;
									end
								elseif SN == "TRAITPROGALTLPL" then
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
							elseif SN > "TRAITPROGLPL" then
								if SN > "WARDENCDARMOURTYPE" then
									if SN == "WARDENCDCANBLOCK" then
										return 1;
									else
										return 0;
									end
								elseif SN == "WARDENCDARMOURTYPE" then
									return 2;
								else
									return 0;
								end
							else
								if Lm <= 75 then
									return CalcStat("StatProgLPL",L);
								elseif Lm <= 105 then
									return 75;
								else
									return CalcStat("StatProgLPL",L);
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
						return -CalcStat("BPET",L,CalcStat("TpenChoice",N));
					end
				else
					return CalcStat("MitLightPRatPCap",L);
				end
			else
				return CalcStat("OutDmgPBonus",L);
			end
		else
			return 400;
		end
	else
		return 0;
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

-- SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
-- StatLinInter: (Normalized) Stat Linear Interpolating

function StatLinInter(sPntMP, sProg, sProgB, sAdj, dLvl, vNorC)

	local dLvlLow = CalcStat(sProg.."LPL",dLvl);
	local dLvlHigh = CalcStat(sProg.."LPH",dLvl);
	local dValLow = CalcStat(sProg,dLvlLow,CalcStat(sProgB,dLvlLow,vNorC));
	local dValHigh = CalcStat(sProg,dLvlHigh,CalcStat(sProgB,dLvlHigh,vNorC));

	if type(vNorC) == "number" then
		-- with stat points
		return LinFmod(1,LotroDbl(CalcStat(sPntMP,dLvlLow)*dValLow*CalcStat(sAdj,dLvlLow)*vNorC),LotroDbl(CalcStat(sPntMP,dLvlHigh)*dValHigh*CalcStat(sAdj,dLvlHigh)*vNorC),dLvlLow,dLvlHigh,dLvl);
	else
		-- default
		return LinFmod(1,LotroDbl(CalcStat(sPntMP,dLvlLow,vNorC)*dValLow*CalcStat(sAdj,dLvlLow,vNorC)),LotroDbl(CalcStat(sPntMP,dLvlHigh,vNorC)*dValHigh*CalcStat(sAdj,dLvlHigh,vNorC)),dLvlLow,dLvlHigh,dLvl);
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

-- ******************************* End CalcStat *******************************