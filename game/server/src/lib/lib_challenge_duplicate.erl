%% Author: wangdahai
%% Created: 2013-5-22
%% Description: TODO: Add description to lib_challenge_duplicate
-module(lib_challenge_duplicate).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([init_challenge_duplicate/0,init_user_challenge_info/1,check_chanllenge_duplicate/2,update_chanllenge_star/3]).

-define(MAX_CHALLENGE_MISSION, 42).			%%最大可挑战关卡数
%%
%% API Functions
%%
init_challenge_duplicate() ->
	F = fun(Info) ->
			Record = list_to_tuple([ets_challenge_duplicate_template] ++ Info),
			StartTime = tool:split_string_to_intlist(Record#ets_challenge_duplicate_template.star_time),
			NewRecord = Record#ets_challenge_duplicate_template{star_time = StartTime},
			ets:insert(?ETS_CHALLENGE_DUPLICATE_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_challenge_duplicate_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

init_user_challenge_info({UserId,Now}) ->
	Record = case db_agent_user:get_user_challenge(UserId) of
		[] ->
			#r_user_challenge_info{user_id = UserId, 
				challenge_star = "000000000000000000000000000000000000000000"};
		Info ->
			Re = list_to_tuple([r_user_challenge_info]++ Info),
			NewStar = tool:to_list(Re#r_user_challenge_info.challenge_star),
			Re#r_user_challenge_info{challenge_star = NewStar}
	end,
	Day = misc_timer:get_day(Now),
	AchieveDay = misc_timer:get_day(Record#r_user_challenge_info.last_challenge_time),
	if
		AchieveDay =/= Day ->%%需要清空其它单天统计数据
			Record1 = Record#r_user_challenge_info{challenge_num = 0, last_challenge_time = 0},
			db_agent_user:update_user_challenge(UserId, Record1);
		true ->
			Record1 = Record			
	end,
	Record1.

%%验证该关卡是否已通关
check_chanllenge_duplicate(Index, Star) ->
	if
		Index < 1 orelse Index > ?MAX_CHALLENGE_MISSION ->
			false;
		true ->
			case data_agent:get_challenge_duplicate_template(Index) of
				[] ->
					false;
				Temp when Temp#ets_challenge_duplicate_template.limit_id =:= 0 ->
					true;
				Temp ->	
					case lists:nth(Temp#ets_challenge_duplicate_template.limit_id, Star) of
						48 ->
							false;
						_ ->
							true
					end
			end
	end.

update_chanllenge_star(Index, Info, Star) ->
	if
		Index =< ?MAX_CHALLENGE_MISSION ->
			case lists:nth(Index, Info#r_user_challenge_info.challenge_star) of
				Num when Num < 48 + Star ->
					NewStar = nthreplace(Info#r_user_challenge_info.challenge_star,Index,[],48 + Star),
					NewInfo = Info#r_user_challenge_info{challenge_star = NewStar},
					db_agent_user:update_user_challenge(Info#r_user_challenge_info.user_id, NewInfo),
					NewInfo;
				_ ->
					Info
			end;
		true ->
			Info
	end.
	

%%
%% Local Functions
%%

%%替换list中指定位置的数据
nthreplace([C|S],N,List,Star) when N > 1 ->
	nthreplace(S, N - 1, List ++ [C],Star);
nthreplace([_C|S],_N,List,Star) ->
	List ++ [Star|S].

