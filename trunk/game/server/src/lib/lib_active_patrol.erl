%% Author: wangdahai
%% Created: 2013-6-17
%% Description: TODO: Add description to lib_active_patrol
-module(lib_active_patrol).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([send_start_patrol/3]).

%%
%% API Functions
%%

send_start_patrol(Group,Award,List) ->
	F = fun(Info) ->
			{UserId,Pid} = Info,
			gen_server:cast(Pid, {start_patrol,UserId,Group,Award})
		end,
	lists:foreach(F, List).

%%
%% Local Functions
%%

