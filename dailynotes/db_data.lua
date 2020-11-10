-- coding: utf-8

DailyNotes.DB_Zones ={
  [1]=9998,
  [2]=9998,
  [3]=9998,
  [4]=9998,
  [5]=9998,
  [358]=9998,
  [6]=9998,
  [7]=9998,
  [8]=9998,
  [9]=9998,
  [10]=9998,
  [11]=9998,
  [12]=9998,
  [13]=9997,
  [14]=9997,
  [15]=9997,
  [16]=9997,
  [17]=9997,
  [18]=9997,
  [19]=9997,
  [20]=9997,
  [21]=9997,
  [22]=9996,
  [23]=9996,
  [24]=9996,
  [25]=9996,
  [26]=9996,
  [27]=9995,
  [28]=9995,
  [29]=9995,
  [30]=9995,
  [31]=9999,
  [32]=9994,
  [33]=9994,
  [34]=9994,
  [35]=9994,
  [36]=9994,
  [37]=9994, 
  [38]=9994, 
  
  
  [10000]=2,
  [10001]=6,
  [100]=1,
  [101]=1,
  [102]=2,
  [103]=4,
  [104]=5,
  [105]=6,
  [106]=10,
  [107]=6,
  [108]=3,
  [110]=1,
  [113]=11,
  [114]=11,
  [115]=7, -- Ocean's Heart - Herz des Ozeans

  [670]=9998, -- Dummy: Ysta-Lab
  [201]=2,
  [202]=670,
  [203]=670,
  [204]=670,
  [205]=670,
  [206]=670,
  [207]=670,
  [209]=15,
  [250]=1,
  [251]=10,
  [252]=10,
  [301]=1,
  [302]=6,
  [304]=9999, -- Miller Ranch
  [401]=9999, -- Guild
  [-1] =9999, -- no zone (304 workaround)
}

---------------------------
-- NPCs
-- here DN caches all NPC-Information
-- this is only usfull for:
--  - adding sub-zones (TEXT identifier)
--  - if npc isn't listed in world-search
-- a full entry example (all attributes are optional):
--   [110102]= {map=6,name="Bulletin board in Obsidian Stronghold",x=41.8,y=52.4,map_name="Obisdian"},
---------------------------
DailyNotes.DB_NPC ={

[113046]={map_name="SC_207_GOTO_PP1"}, -- Blake Fos
[113062]={map_name="SC_205_GOTO_PP2"}, -- Lolin Caffey
[113063]={map_name="SC_205_GOTO_PP3"}, -- Jiner Bighead
[113064]={map_name="SC_205_GOTO_PP3"}, -- Shirley Higgens
[113068]={map_name="SC_205_GOTO_PP0"}, -- Waton Raydor
[113069]={map_name="SC_205_GOTO_PP2"}, -- Fra Gau
[113070]={map_name="SC_205_GOTO_PP1"}, -- Sai Kasrate
[113077]={map_name="SC_205_GOTO_PP0"}, -- Hylun Leard
[113082]={map_name="SC_206_GOTO_PP1"}, -- Jilo Anta
[113083]={map_name="SC_206_GOTO_PP3"}, -- Dalina Telo
[113084]={map_name="SC_206_GOTO_PP2"}, -- Koke Palsi
[113085]={map_name="SC_206_GOTO_PP4"}, -- Tiwo Sabya
[113037]={map=401,name=TEXT("Sys113037_name"),x=50,y=50,map_name=TEXT("QUEST_DIR_118")}, -- Guild Board
[113038]={map=401,name=TEXT("Sys113038_name"),x=50,y=50,map_name=TEXT("QUEST_DIR_118")}, -- Guild Board
[113039]={map=401,name=TEXT("Sys113039_name"),x=50,y=50,map_name=TEXT("QUEST_DIR_118")}, -- Guild Board

}
