%%%-------------------------------------------------------------------
%%% Module  : pp_npc
%%% Author  : 
%%% Description : Npc
%%%-------------------------------------------------------------------
-module(pp_npc).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================
handle(_Cmd, _State, _Data) ->
    {error, "pp_npc no match"}.

%%====================================================================
%% Private functions
%%====================================================================


