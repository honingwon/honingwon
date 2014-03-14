%% Author: wangdahai
%% Created: 2013-6-7
%% Description: TODO: Add description to lib_active_question
-module(lib_active_question).

%%
%% Include files
%%
-include("common.hrl"). 
%%
%% Exported Functions
%%
-export([init_question_bank_template/0,init_active_question_list/0,next_question/2,send_answer_award/3]).

%%
%% API Functions
%%
init_question_bank_template() ->
	F = fun(Info) ->
			Record = list_to_tuple([ets_question_bank_template] ++ Info),
			ets:insert(?ETS_QUESTION_BANK_TEMPLATE, Record)
		end,
	case db_agent_template:get_question_bank_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip 
	end.

init_active_question_list() ->
	MaxId = ets:info(?ETS_QUESTION_BANK_TEMPLATE, size),
	active_question_list(?MAX_ACTIVE_QUESTION_NUMBER,MaxId,[]).

send_answer_award(Index, Question,List) ->
	F = fun(Info,L) ->
			{T,V} = Info,
			[{T,V bsl 1}|L]
		end,
	List2 = lists:foldl(F, [], List),
	mod_map_agent:send_question_answer(?QUESTION_ACTIVE_MAP_ID,
		?QUESTION_ACTIVE_ANSWER_LIMIT_COORDINATE,Index,Question#ets_question_bank_template.key,List,List2).

next_question(Index, Question) ->
	{ok, Bin} = pt_23:write(?PP_ACTIVE_QUESTION_ANSWER, [Index, Question]),
	mod_map_agent:send_to_scene(?QUESTION_ACTIVE_MAP_ID, Bin).

%%
%% Local Functions
%%
active_question_list(0,_MaxId,List) ->
	List;
active_question_list(Num,MaxId,List) ->	
	ActiveId = util:rand(1, MaxId),
	case lists:keyfind(ActiveId, #ets_question_bank_template.id, List) of
		false ->
			case ets:lookup(?ETS_QUESTION_BANK_TEMPLATE, ActiveId) of
				[] ->
					?DEBUG("active_question_list error:~p",[ActiveId]),
					active_question_list(Num,MaxId,List);
				[TempInfo] ->
					active_question_list(Num - 1,MaxId,[TempInfo|List])	
			end;			
		_ ->
			active_question_list(Num,MaxId,List)
	end.
