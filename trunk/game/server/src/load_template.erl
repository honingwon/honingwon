%% Author: wangdahai
%% Created: 2013-8-24
%% Description: TODO: Add description to load_template
-module(load_template).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([reload_template_veins/0,
		reload_item_template/0,
		 reload_active_open_server/0,
		 reload_guild_item/0,
		 get_guild_item_dic/1,
		 get_guild_dic/0,
		 change_t_users_titles/0]).

%%
%% API Functions
%%
reload_template_veins() ->
	ets:delete_all_objects(?ETS_VEINS_TEMPLATE),	
	ets:delete_all_objects(?ETS_VEINS_EXTRA_TEMPLATE),
	lib_veins:init_template_veins(),
	ok.



%%热更新物品信息
reload_item_template() ->
	ets:delete_all_objects(?ETS_ITEM_TEMPLATE),
	item_util:init_item_template1().


reload_active_open_server()->
	ets:delete_all_objects(?ETS_ACTIVITY_OPEN_SERVER_TEMPLATE),
	lib_active_open_server:init_template().


reload_guild_item() ->
	F = fun(Guild) ->
			DicWareName = lists:concat([guilds_warehouse_,Guild#ets_guilds.id]),
			db_agent_guild:delete_guild_item([{guild_id,Guild#ets_guilds.id}]),
			List =  gen_server:call(mod_guild:get_mod_guild_pid(),{apply_call,load_template,get_guild_item_dic,[DicWareName]}),
			F1 = fun(GuildItem) ->
					  db_agent_guild:create_guild_item(GuildItem)
				end,
			lists:foreach(F1, List)
		end,
	ListGuild = gen_server:call(mod_guild:get_mod_guild_pid(),{apply_call,load_template,get_guild_dic,[]}) ,
	lists:foreach(F, ListGuild).
	
change_t_users_titles() ->
	F = fun(Titles) ->
		[UserID,Titledata]  = Titles,
		TitleStr = tool:to_list(Titledata),
		case erlang:length(TitleStr) of
			0 ->
				skip;
		
			_ ->
				TitleList = string:tokens(TitleStr, ","),
					F1 = fun(X, L) ->
						{X1,_} = string:to_integer(X),
						[X1|L]
					end,
				NewTitleList = lists:foldl(F1, [], TitleList),
				F2 = fun(NewTitle) ->
					{NewTitle,0}
				end,
				NewList =  [ F2(X) || X <- NewTitleList],
				Str = tool:intlist_to_string(NewList),
				db_agent_user:update_users_title(UserID, Str)
		end
	end,
	Ret = ?DB_MODULE:select_all(t_users_titles, "user_id, titles", []),
	case Ret of 
		[] -> skip;
		_ -> 
			lists:foreach(F, Ret)
	end.



get_guild_item_dic(DicWareName) ->
	case get(DicWareName) of
			undefined ->
				[];
			DicL ->
				DicL
		end.

get_guild_dic() ->
	case get(?DIC_GUILDS) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.



%%
%% Local Functions
%%

