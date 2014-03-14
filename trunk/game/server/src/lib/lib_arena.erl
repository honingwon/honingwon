%% Author: Administrator
%% Created: 2011-3-7
%% Description: TODO: Add description to lib_arena
-module(lib_arena).
-include("common.hrl").
%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([is_arena_scene/1]).

%%
%% API Functions
%%


%% 是否竞技场场景
is_arena_scene(MapId) ->
	MapId < 0.

%%
%% Local Functions
%%

