%% Author: wangdahai
%% Created: 2014-1-3
%% Description: TODO: Add description to lib_world_data
-module(lib_world_data).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([update_world_level/0, get_world_level/0, set_world_level/1]).

%%
%% API Functions
%%
update_world_level() ->
	case lib_top:get_level_top_10() of
		Level1 when Level1 >= 40 ->
			Level = Level1 div 10 - 4;
		_ ->
			Level = ?MIN_WORLD_LEVEL
	end,
	?DEBUG("update_world_level:~p",[Level]),
	Record = #ets_world_data{key = ?WORLD_LEVEL, value = Level},
	ets:insert(?ETS_WORLD_DATA, Record).

set_world_level(Level) ->
	Record = #ets_world_data{key = ?WORLD_LEVEL, value = Level},
	ets:insert(?ETS_WORLD_DATA, Record).

get_world_level() ->
	case ets:lookup(?ETS_WORLD_DATA, ?WORLD_LEVEL) of
		[] ->
			?MIN_WORLD_LEVEL;
		[Record] ->
			Record#ets_world_data.value
	end.


%%
%% Local Functions
%%

