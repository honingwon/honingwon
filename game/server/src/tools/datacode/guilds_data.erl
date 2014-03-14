%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to guilds_data
-module(guilds_data).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create/1]).

%%
%% API Functions
%%


create([Infos]) ->
	FInfo = fun(Info) ->
					list_to_tuple([ets_guilds_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_guilds_template", "get/1", "帮会升级模板数据表"),
    F =
    fun(GuildsInfo) ->
        Header = header(GuildsInfo#ets_guilds_template.guild_level),
        Body = body(GuildsInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_guilds_template{guild_level = GuildLevel,
					  need_contribute = NeedContribute,
        			  need_activity = NeedActivity,
					  need_money = NeedMoney,
					  honorary_member = HonoraryMember,
					  common_member = CommonMember,
					  associate_member = AssociateMember,
					  total_mails = TotalMails
    } = Info,
    io_lib:format(
    "    #ets_exp_template{guild_level = ~p,\n"
    "					  need_contribute = ~p,\n"
    " 					  need_activity = ~p,\n"
    " 					  need_money = ~p,\n"
    " 					  honorary_member = ~p,\n"
    " 					  common_member = ~p,\n"
	" 					  associate_member = ~p,\n"	
	" 					  total_mails = ~p\n"				 				 				 				 
    "    };\n",
    [GuildLevel, NeedContribute, NeedActivity, NeedMoney, HonoraryMember, CommonMember, 
	 AssociateMember, TotalMails]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

