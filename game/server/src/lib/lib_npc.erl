%%%-------------------------------------------------------------------
%%% Module  : lib_npc
%%% Author  : 
%%% Description : Npc
%%%-------------------------------------------------------------------
-module(lib_npc).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
		 init_template_npc/0, 
		 get_npc/1
		]).

%%====================================================================
%% External functions
%%====================================================================
%%初始化NPC模板
init_template_npc() -> 
	F = fun(Npc) ->
		NpcInfo = list_to_tuple([ets_npc_template] ++ Npc),		
  		ets:insert(?ETS_NPC_TEMPLATE, NpcInfo)
	end,
	L = db_agent_template:get_npc_template(),
	lists:foreach(F, L),
	ok.


%%根据NpcID获取信息
get_npc(NpcID) ->
	MS = ets:fun2ms(fun(T) when T#ets_npc_template.npc_id == NpcID -> T end),
   	case ets:select(?ETS_NPC_TEMPLATE, MS)	of
  		[] -> [];
   		[H | _] -> [H]
    end.

%%====================================================================
%% Private functions
%%====================================================================


