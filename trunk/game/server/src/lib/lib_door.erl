%% Author: Administrator
%% Created: 2011-3-17
%% Description: TODO: Add description to lib_door
-module(lib_door).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 init_template_door/0
		 ]).

%%
%% API Functions
%%

%%	初始化门模板 
init_template_door() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_door_template] ++ Info),
				ets:insert(?ETS_DOOR_TEMPLATE, Record)
		end,
	case db_agent_template:get_door_template() of
		[] -> 
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	%%ok = init_template_door_next_door(),%%增加了目标坐标xy，所以不需要计算nex——door
	ok.

init_template_door_next_door() ->
	DoorList = ets:tab2list(?ETS_DOOR_TEMPLATE),
	F = fun(Info) ->
				NextInfo = lists:keyfind(Info#ets_door_template.next_door_id, 2, DoorList),
				Record = Info#ets_door_template{other_data=NextInfo},
%% 				?PRINT("init_template_door_next_door:~w~n",[Record]),
				ets:insert(?ETS_DOOR_TEMPLATE, Record)
		end,
	case DoorList of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.





%%
%% Local Functions
%%

