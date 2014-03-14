%% Author: liaoxiaobo
%% Created: 2012-11-6
%% Description: TODO: Add description to pt_28
-module(pt_28).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%

-export([read/2, write/2]).


%%
%% API Functions
%%

read(?PP_MOUNT_LIST_UPDATE,<<ID:64>>) ->
	{ok, []}; 

read(?PP_MOUNT_STATE_CHANGE,<<ID:64,State:8>>) ->
	{ok, [ID,State]}; 

read(?PP_MOUNT_UPGRADE,<<ID:64,Count:8,Bin/binary>>) ->
	L = read_item(Count,[],Bin),
	{ok, [ID,L]}; 

read(?PP_MOUNT_STAIRS_UPDATE,<<ID:64>>) ->
	{ok, [ID]}; 

read(?PP_MOUNT_GROW_UPDATE,<<ID:64,IsProt:8>>) ->
	{ok, [ID,IsProt]};

read(?PP_MOUNT_QUALITY_UPDATE,<<ID:64,IsProt:8>>) ->
	{ok, [ID,IsProt]}; 

read(?PP_MOUNT_RELEASE,<<ID:64>>) ->
	{ok, [ID]}; 

read(?PP_MOUNT_REMOVE_SKILL,<<ID:64,GroupSkillId:32>>) ->
	{ok, [ID,GroupSkillId]}; 

read(?PP_MOUNT_SKILL_ITEM_REFRESH,<<Type:8>>) ->
	{ok, [Type]}; 

read(?PP_MOUNT_SKILL_ITEM_GET,<<Place:8>>) ->
	{ok, [Place]}; 

read(?PP_MOUNT_REMOVE_SKILL1,<<ID:64,GroupSkillId:32>>) ->
	{ok, [ID,GroupSkillId]}; 

read(?PP_MOUNT_GET_SKILL_BOOK_LIST,<<>>) ->
	{ok, []}; 

read(?PP_MOUNT_GET_OTHER_MOUNTS,<<UserID:64,MountsID:64>>) ->
	{ok, [UserID,MountsID]}; 

read(?PP_MOUNT_INHERIT,<<MainID:64,MasterID:64>>) ->
	{ok, [MainID,MasterID]}; 

read(?PP_MOUNT_REFINED_UPDATE, <<ID:64, IsYuanBao:8>>) ->
	{ok, [ID, IsYuanBao]};
	
read(Cmd, _R) ->
	?WARNING_MSG("pt_28 read:~w", [Cmd]),
    {error, no_match}.

write(?PP_MOUNT_LIST_UPDATE,[List]) ->
	Len = length(List),
	F = fun(Info) ->
				case Info#ets_users_mounts.is_exit =:= 0 of
					true ->
						<<(Info#ets_users_mounts.id):64,0:8>>;
					_ ->
						NameBin = pt:write_string(Info#ets_users_mounts.name),
						SL = length(Info#ets_users_mounts.other_data#mounts_other.skill_list),
						SkillBin = write_skill(Info#ets_users_mounts.other_data#mounts_other.skill_list,<<>>),
						UBin = write_mounts_att_update(Info),
						<<
						  (Info#ets_users_mounts.id):64,
						  1:8,
						  (Info#ets_users_mounts.template_id):32,
						  (Info#ets_users_mounts.state):8,
						  (Info#ets_users_mounts.other_data#mounts_other.diamond):8,
						  (Info#ets_users_mounts.other_data#mounts_other.star):8,
						  NameBin/binary,
						  (Info#ets_users_mounts.stairs):8,
						  (Info#ets_users_mounts.level):8,
						  (Info#ets_users_mounts.exp):32,
						  (Info#ets_users_mounts.other_data#mounts_other.speed):8,
						  (Info#ets_users_mounts.current_grow_up):8,
						  (Info#ets_users_mounts.current_quality):8,
						  (Info#ets_users_mounts.current_refined):8,
				  		  (Info#ets_users_mounts.other_data#mounts_other.total_hp3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.total_mp3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.attack3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.defence3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.property_attack3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.magic_defence3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.far_defence3):16,
				  		  (Info#ets_users_mounts.other_data#mounts_other.mump_defence3):16,
						  UBin/binary,	
						  SL:8,		  
						  SkillBin/binary
						  >>
				end
		end,
	
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_MOUNT_LIST_UPDATE,<<Len:8,Bin/binary>>)};

write(?PP_MOUNT_GET_OTHER_MOUNTS,[Info]) ->
	Bin = case Info#ets_users_mounts.is_exit =:= 0 of
			  true ->
				  <<(Info#ets_users_mounts.id):64,0:8>>;
			  _ ->
				  NameBin = pt:write_string(Info#ets_users_mounts.name),
				  SL = length(Info#ets_users_mounts.other_data#mounts_other.skill_list),
				  SkillBin = write_skill(Info#ets_users_mounts.other_data#mounts_other.skill_list,<<>>),
				  UBin = write_mounts_att_update(Info),
				  <<
				  (Info#ets_users_mounts.id):64,
				  1:8,
				  (Info#ets_users_mounts.template_id):32,
				  (Info#ets_users_mounts.state):8,
				  (Info#ets_users_mounts.other_data#mounts_other.diamond):8,
				  (Info#ets_users_mounts.other_data#mounts_other.star):8,
				  NameBin/binary,
				  (Info#ets_users_mounts.stairs):8,
				  (Info#ets_users_mounts.level):8,
				  (Info#ets_users_mounts.exp):32,
				  (Info#ets_users_mounts.other_data#mounts_other.speed):8,
				  (Info#ets_users_mounts.current_grow_up):8,
				  (Info#ets_users_mounts.current_quality):8,
				  (Info#ets_users_mounts.current_refined):8,
				  UBin/binary,	
				  SL:8,		  
				  SkillBin/binary
				  >>
		  end,
	{ok, pt:pack(?PP_MOUNT_GET_OTHER_MOUNTS,Bin)};


write(?PP_MOUNT_RELEASE,[ID]) ->
	{ok, pt:pack(?PP_MOUNT_RELEASE,<<ID:64>>)};

write(?PP_MOUNT_SKILL_UPDATE,[ID,SkillList]) ->
	SL = length(SkillList),
	SkillBin = write_skill(SkillList,<<>>),
	{ok, pt:pack(?PP_MOUNT_SKILL_UPDATE,<<ID:64,SL:8,SkillBin/binary>>)};

write(?PP_MOUNT_STATE_CHANGE,[List]) ->
	Len = length(List),
	F = fun(Info) ->
				<<
				  (Info#ets_users_mounts.id):64,
				  (Info#ets_users_mounts.state):8
				>>
		end,
	Bin =  tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_MOUNT_STATE_CHANGE,<<Len:8,Bin/binary>>)};

%% 进阶
write(?PP_MOUNT_STAIRS_UPDATE,[Res]) ->
	{ok, pt:pack(?PP_MOUNT_STAIRS_UPDATE,<<Res:8>>)};

%% 进化
write(?PP_MOUNT_GROW_UPDATE,[Res]) ->
	{ok, pt:pack(?PP_MOUNT_GROW_UPDATE,<<Res:8>>)};

%% 提升
write(?PP_MOUNT_QUALITY_UPDATE,[Res]) ->
	{ok, pt:pack(?PP_MOUNT_QUALITY_UPDATE,<<Res:8>>)};

%% 洗练
write(?PP_MOUNT_REFINED_UPDATE,[Info]) ->
	Bin = <<
			(Info#ets_users_mounts.id):64,
			(Info#ets_users_mounts.current_refined):8,
			(Info#ets_users_mounts.other_data#mounts_other.total_hp3):16,
			(Info#ets_users_mounts.other_data#mounts_other.total_mp3):16,
			(Info#ets_users_mounts.other_data#mounts_other.attack3):16,
			(Info#ets_users_mounts.other_data#mounts_other.defence3):16,
			(Info#ets_users_mounts.other_data#mounts_other.property_attack3):16,
			(Info#ets_users_mounts.other_data#mounts_other.magic_defence3):16,
			(Info#ets_users_mounts.other_data#mounts_other.far_defence3):16,
			(Info#ets_users_mounts.other_data#mounts_other.mump_defence3):16
			>>,
	{ok, pt:pack(?PP_MOUNT_REFINED_UPDATE,Bin)};

%% 属性更新
write(?PP_MOUNT_ATT_UPDATE,[Info]) ->
	UBin = write_mounts_att_update(Info), 
	Bin = <<
			(Info#ets_users_mounts.id):64,
			(Info#ets_users_mounts.other_data#mounts_other.diamond):8,
			(Info#ets_users_mounts.other_data#mounts_other.star):8,
			(Info#ets_users_mounts.stairs):8,
			(Info#ets_users_mounts.current_grow_up):8,
			(Info#ets_users_mounts.current_quality):8,
			UBin/binary
		  >>,
	{ok, pt:pack(?PP_MOUNT_ATT_UPDATE,Bin)};


%% 经验更改
write(?PP_MOUNT_EXP_UPDATE,[Info]) ->
	Bin = <<
			(Info#ets_users_mounts.id):64,
			(Info#ets_users_mounts.level):8,
			(Info#ets_users_mounts.exp):64
		  >>,
	{ok, pt:pack(?PP_MOUNT_EXP_UPDATE,Bin)};



write(?PP_MOUNT_REMOVE_SKILL,[Res]) ->
	{ok, pt:pack(?PP_MOUNT_REMOVE_SKILL,<<Res:8>>)};

write(?PP_MOUNT_REMOVE_SKILL1,[Res]) ->
	{ok, pt:pack(?PP_MOUNT_REMOVE_SKILL1,<<Res:8>>)};

write(?PP_MOUNT_GET_SKILL_BOOK_LIST,[List,Luck]) ->
	Len = length(List),
	F = fun({Place,ItemId,Bind,_Type}) ->
				<<
				  (Place):32,
				  (ItemId):32,
				  (Bind):8
				>>
		end,
	Bin =  tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_MOUNT_GET_SKILL_BOOK_LIST,<<Luck:16,Len:8,Bin/binary>>)};


write(?PP_MOUNT_SKILL_ITEM_GET,[Res,Luck]) ->
	{ok, pt:pack(?PP_MOUNT_SKILL_ITEM_GET,<<Res:8,Luck:16>>)};


write(?PP_MOUNT_INHERIT,[Res]) ->
	{ok, pt:pack(?PP_MOUNT_INHERIT,<<Res:8>>)};


write(Cmd, _R) ->
	?WARNING_MSG("pt_28,write:~w",[Cmd]),
	{ok, pt:pack(0, <<>>)}.
%%
%% Local Functions
%%



read_item(0,L,<<_Bin/binary>>) ->
	L;

read_item(Count,L, <<Place:32,Bin/binary>>) ->
	L1 = L ++ [Place],
	read_item(Count - 1, L1, Bin).

write_skill([],<<Bin/binary>>) -> Bin;
write_skill([H|T],<<Bin/binary>>)->
	NewBin = <<
			   Bin/binary,
			   (H#r_use_skill.skill_group):32,
			   (H#r_use_skill.skill_lv):8
			   >>,
	write_skill(T, NewBin).

write_mounts_att_update(Info) ->	
	<<
	  (Info#ets_users_mounts.other_data#mounts_other.fight):32,
	  (Info#ets_users_mounts.other_data#mounts_other.skill_cell_num):8,
	  (Info#ets_users_mounts.other_data#mounts_other.up_grow_up  + Info#ets_users_mounts.other_data#mounts_other.up_grow_up2):8,
	  (Info#ets_users_mounts.other_data#mounts_other.up_quality  + Info#ets_users_mounts.other_data#mounts_other.up_quality2):8,
	  (Info#ets_users_mounts.other_data#mounts_other.total_hp ):32,
	  (Info#ets_users_mounts.other_data#mounts_other.total_hp2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.total_mp ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.total_mp2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.attack ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.attack2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.defence ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.defence2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.magic_attack ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.magic_attack2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.far_attack ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.far_attack2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.mump_attack ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.mump_attack2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.magic_defense ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.magic_defense2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.far_defense ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.far_defense2):16,
	  (Info#ets_users_mounts.other_data#mounts_other.mump_defense ):16,
	  (Info#ets_users_mounts.other_data#mounts_other.mump_defense2):16
	  >>.
	
