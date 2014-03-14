%% Author: liaoxiaobo
%% Created: 2013-7-2
%% Description: TODO: Add description to lib_yellow
-module(lib_yellow).

%%
%% Include files
%%
-include("common.hrl").


-define(DAY_YELLOW_BOX,0). 			%% 每日礼包
-define(LEVEL_UP_BOX,1). 			%% 升级礼包
-define(NEW_PLAYER_YELLOW_BOX,2).	%% 新手礼包
-define(DAY_YEAR_YELLOW_BOX,3). 	%% 每日年费礼包
-define(LEVEL_UP_YELLOW_BOX,4). 	%% 升级黄钻礼包
-define(YELLOW_HIGH_VIP_BOX,5). 	%% 豪华礼包

%%
%% Exported Functions
%%
-export([
		 init_template/0,
		 init_user_yellow_box/1,
		 get_reward/2,
		 get_yellow_effect/2
		]).

%%
%% API Functions
%%


init_template() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_yellow_box_template] ++ (Info)),
				Awards = tool:split_string_to_intlist(Record#ets_yellow_box_template.awards),
				Other = #other_yellow_template{},
				NewRecord = Record#ets_yellow_box_template{awards = Awards,other_data = Other},
				if
					Record#ets_yellow_box_template.awards_type =:= 1 ->
						NewRecord1 = cale_attach_effect_loop(Awards,Other,NewRecord);
					true ->
						NewRecord1 = NewRecord
				end,
				ets:insert(?ETS_YELLOW_BOX_TEMPLATE, NewRecord1)
		end,
	case db_agent_template:get_yellow_box_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

cale_attach_effect_loop([], Other,Record) ->
    Record;

cale_attach_effect_loop([{K, V} | T],Other,Record) ->
			case K of
				?ATTACK_PHYSICS ->
					NewOther = Other#other_yellow_template{
													attack_physics = V
												   },
					NewRecord = Record#ets_yellow_box_template{
														  other_data = NewOther
														 },
                    cale_attach_effect_loop(T,NewOther,NewRecord);
				?DEFENCE_PHYSICS -> 
					NewOther = Other#other_yellow_template{
													defence_physics = V
												   },
					NewRecord = Record#ets_yellow_box_template{
														  other_data = NewOther
														 },
                    cale_attach_effect_loop(T,NewOther,NewRecord);
				?ATTR_HP -> 
					NewOther = Other#other_yellow_template{
													hp = V
												   },
					NewRecord = Record#ets_yellow_box_template{
														  other_data = NewOther
														 },
                    cale_attach_effect_loop(T,NewOther,NewRecord);
				_Other ->
					?WARNING_MSG("cale_attach_effect_loop:~w", [_Other]),
					cale_attach_effect_loop(T,Other,Record)
			end.


init_user_yellow_box(UserId) ->
	case db_agent_user:get_user_yellow_box(UserId) of
		[] ->
			db_agent_user:insert_user_yellow_box(UserId,0,0,0),
			[0,0,0];
		[_,Is_rece_new_pack,Rece_day_pack_date,Level_up_pack] ->
			[Is_rece_new_pack,Rece_day_pack_date,Level_up_pack]
	end.


%% 获取奖励
get_reward(PlayerStatus,Type) ->
	case Type of
		?DAY_YELLOW_BOX ->
			get_day_yellow_box(PlayerStatus);
		?LEVEL_UP_BOX ->
			get_level_up_box(PlayerStatus);
		?NEW_PLAYER_YELLOW_BOX ->
			get_new_player_yellow_box(PlayerStatus);
		_ ->
			get_day_yellow_box(PlayerStatus)
	end.

	
%% 每日礼包
get_day_yellow_box(PlayerStatus) ->
	Now = misc_timer:now_seconds(), 
	case util:is_same_date(PlayerStatus#ets_users.other_data#user_other.rece_day_pack_date,Now) of
		true ->
			{false,?_LANG_YELLOW_AWARD_DAY_ERROR};
		_ ->
			if
				PlayerStatus#ets_users.other_data#user_other.is_yellow_vip =:= 0 ->
					{false,?_LANG_YELLOW_AWARD_ERROR};
				true ->
					case  get_template_by_type_level(?DAY_YELLOW_BOX,PlayerStatus#ets_users.other_data#user_other.yellow_vip_level) of
						[] ->
							Items = [];
						[Tem] ->
							if
								PlayerStatus#ets_users.other_data#user_other.is_yellow_year_vip =:= 1 ->
									[Tem1] = get_template_by_type(?DAY_YEAR_YELLOW_BOX),
									Items = Tem#ets_yellow_box_template.awards ++ Tem1#ets_yellow_box_template.awards;
								true ->
									Items = Tem#ets_yellow_box_template.awards
							end
					end,
					NullCell = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'get_null_cells'}),
					if
						length(NullCell) < length(Items) ->
							{false,?_LANG_YELLOW_AWARD_ITEM_ERROR};
						true ->
							get_award_item(PlayerStatus,Items),
							db_agent_user:update_user_yellow_box(?DAY_YELLOW_BOX, PlayerStatus#ets_users.id,Now),
							Other = PlayerStatus#ets_users.other_data#user_other{rece_day_pack_date = Now},
							NewPlayerStatus = PlayerStatus#ets_users{other_data =  Other},
							{true,NewPlayerStatus}
					end
			end
	end.

%% 升级礼包
get_level_up_box(PlayerStatus) ->
	if
		PlayerStatus#ets_users.other_data#user_other.is_yellow_vip =:= 0 ->
			{false,?_LANG_YELLOW_AWARD_ERROR};
		true ->
			if
				PlayerStatus#ets_users.level =< PlayerStatus#ets_users.other_data#user_other.level_up_pack ->
					{false, ?_LANG_YELLOW_AWARD_LEVEL_ERROR};
				true ->
					case get_template_by_type_level1(?LEVEL_UP_BOX,PlayerStatus#ets_users.level,PlayerStatus#ets_users.other_data#user_other.level_up_pack) of
						[] ->
							{false,?_LANG_YELLOW_AWARD_LEVEL_ERROR};
						Tem ->
							if
								PlayerStatus#ets_users.other_data#user_other.level_up_pack >= Tem#ets_yellow_box_template.level ->
									{false,?_LANG_YELLOW_AWARD_LEVEL_ERROR};
								true ->
									if
										PlayerStatus#ets_users.other_data#user_other.is_yellow_vip =:= 1 ->
											[Tem1] = get_template_by_type(?LEVEL_UP_YELLOW_BOX),
											Items = Tem#ets_yellow_box_template.awards ++ Tem1#ets_yellow_box_template.awards;
										true ->
											Items = Tem#ets_yellow_box_template.awards
									end,
									NullCell = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'get_null_cells'}),
									if
										length(NullCell) < length(Items) ->
											{false,?_LANG_YELLOW_AWARD_ITEM_ERROR};
										true ->
											get_award_item(PlayerStatus,Items),
											db_agent_user:update_user_yellow_box(?LEVEL_UP_BOX, PlayerStatus#ets_users.id,Tem#ets_yellow_box_template.level),
											Other = PlayerStatus#ets_users.other_data#user_other{level_up_pack = Tem#ets_yellow_box_template.level},
											NewPlayerStatus = PlayerStatus#ets_users{other_data =  Other},
											{true,NewPlayerStatus}
									end
							end
					end
			end
	end.

%% 新手礼包 
get_new_player_yellow_box(PlayerStatus) ->
	if
		PlayerStatus#ets_users.other_data#user_other.is_yellow_vip =:= 0 ->
			{false,?_LANG_YELLOW_AWARD_ERROR};
		true ->
			if
				PlayerStatus#ets_users.other_data#user_other.is_rece_new_pack =:= 1 ->
					{false,?_LANG_YELLOW_AWARD_NEW_PLAYER_ERROR};
				true ->
					case get_template_by_type(?NEW_PLAYER_YELLOW_BOX) of
						[] ->
							{false,?_LANG_YELLOW_ERROR};
						[Tem] ->
							Items = Tem#ets_yellow_box_template.awards,
							NullCell = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'get_null_cells'}),
							if
								length(NullCell) < length(Items) ->
									{false,?_LANG_YELLOW_AWARD_ITEM_ERROR};
								true ->
									get_award_item(PlayerStatus,Items),
									db_agent_user:update_user_yellow_box(?NEW_PLAYER_YELLOW_BOX, PlayerStatus#ets_users.id,1),
									Other = PlayerStatus#ets_users.other_data#user_other{is_rece_new_pack = 1},
									NewPlayerStatus = PlayerStatus#ets_users{other_data =  Other},
									{true,NewPlayerStatus}
							end
					end
			end
	end.

%% 获取黄钻豪华
get_yellow_effect(IsHight,Level) ->
	if
		IsHight =:= 0  ->
			#other_yellow_template{};
		true ->
			case get_template_by_type_level(?YELLOW_HIGH_VIP_BOX,Level) of
				[] ->
					#other_yellow_template{};
				[H|_] ->
					H#ets_yellow_box_template.other_data
			end
	end.

%%
%% Local Functions
%%

get_template_by_type(Type) ->
	Pattern = #ets_yellow_box_template{type = Type, _='_'},
	L = ets:match_object(?ETS_YELLOW_BOX_TEMPLATE,Pattern),
	case is_list(L) of
        true -> L;
        false -> []
    end.
	
	
get_template_by_type_level(Type,Level) ->
	Pattern = #ets_yellow_box_template{type = Type,level = Level, _='_'},
	L = ets:match_object(?ETS_YELLOW_BOX_TEMPLATE,Pattern),
	case is_list(L) of
        true -> L;
        false -> []
    end.	


get_template_by_type_level1(Type,PlayerLevel,HasLevel) ->
	List = get_template_by_type(Type),
	F = fun(L1, L2) ->
				L1#ets_yellow_box_template.level < L2#ets_yellow_box_template.level
		end,
	List1 = lists:sort(F, List),
	get_template_level(List1,{PlayerLevel,HasLevel,[]}).

	
get_template_level([],{Level,HasLevel,Info}) ->
	Info;
get_template_level([H|T],{Level,HasLevel,Info}) ->
	if
		HasLevel < H#ets_yellow_box_template.level andalso H#ets_yellow_box_template.level =< Level  ->
			get_template_level([],{Level,HasLevel,H});
		true ->
			get_template_level(T,{Level,HasLevel,[]})
	end.
	
	

%% 物品奖励
get_award_item(PlayerStatus,Items) ->
	if
		length(Items) > 0 ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,
							{'target_add_item',
							Items,
							PlayerStatus#ets_users.other_data#user_other.pid_send });
		true ->
			skip
	end.



