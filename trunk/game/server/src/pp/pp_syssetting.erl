%%%-------------------------------------------------------------------
%%% Module  : pp_syssetting
%%% Author  : 
%%% Description : 系统设置
%%%-------------------------------------------------------------------
-module(pp_syssetting).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================
handle(_Cmd, _Status, _Data) ->
    {error, "pp_syssetting no match"}.

%%====================================================================
%% Private functions
%%====================================================================

