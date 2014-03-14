%% Author: Administrator
%% Created: 2011-6-7
%% Description: TODO: Add description to vip_data
-module(vip_data).

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
					list_to_tuple([ets_vip_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_vip_template", "get/1", "VIP模板数据表"),
    F =
    fun(VipInfo) ->
        Header = header(VipInfo#ets_vip_template.vip_id),
        Body = body(VipInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_vip_template{vip_id = VipId,
					  effect_date = EffectDate,
        			  yuanbao = YuanBao,
					  tranfer_shoe = TranferShoe,
					  exp_rate = ExpRate,
					  strength_rate = StrengthRate,
					  hole_rate = HoleRate,
					  lifeexp_rate = LifeexpRate,
					  title_id = TitleId
    } = Info,	
	
    io_lib:format(
    "    #ets_exp_template{vip_id = ~p,\n"
    "					  effect_date = ~p,\n"
    " 					  yuanbao = ~p,\n"
    " 					  tranfer_shoe = ~p,\n"
    " 					  exp_rate = ~p,\n"
    " 					  strength_rate = ~p,\n"
	"					  hole_rate = ~p,\n"
    " 					  lifeexp_rate = ~p,\n"
	" 					  title_id = ~p\n"				 				 				 				 
    "    };\n",
    [VipId, EffectDate, YuanBao, TranferShoe, ExpRate, StrengthRate, HoleRate, LifeexpRate, TitleId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

