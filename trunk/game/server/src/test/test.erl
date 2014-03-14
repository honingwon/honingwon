%% Author: liaoxiaobo
%% Created: 2012-9-11
%% Description: TODO: Add description to new_file
-module(test).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([cl/0,
		 start/0,
		test/0]).

%%
%% API Functions
%%



%%
%% Local Functions
%%


cl()->
	c:l(pt_21),
	c:l(pt_guild),
	c:l(lib_guild),
	c:l(mod_guild),

	ok.

start()->
	lib_guild:get_guild_list([],1,10,1),
	ok.

test() ->
	F = fun(Acc,Info) ->
				?DEBUG("~w",[Acc]),
				ok
		end,
	Acc = [],
	lists:foldl(F, Acc, [1,1]).






	
