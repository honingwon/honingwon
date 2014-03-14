%% Author: Administrator
%% Created: 2011-5-4
%% Description: TODO: Add description to pp_sysinfo
-module(pp_sysinfo).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([handle/3]).

%%
%% API Functions
%%
%% GM发送反馈信息
handle(?PP_GM_SEND_MESSAGE, PlayerStatus, [Mtype, Mtitle, Content]) ->
	{Res} = lib_player:send_to_message_to_gm(PlayerStatus, Mtype, Mtitle, Content),
	
	
	{ok, ResData} = pt_30:write(?PP_GM_SEND_MESSAGE, Res),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResData),
	ok;


handle(Cmd, _, _) ->
	?DEBUG("pp_sysinfo cmd is not : ~w",[Cmd]),
	ok.


%%
%% Local Functions
%%

