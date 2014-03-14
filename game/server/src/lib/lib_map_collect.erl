%% Author: Administrator
%% Created: 2011-5-5
%% Description: TODO: Add description to lib_map_collect
-module(lib_map_collect).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 create_collect/6,
		 collect/3,
		 loop/0
		]).

-define(DIC_COLLECT_TEMPLATE, dic_collect_template). %% 采集模板进程字典
%%
%% API Functions
%%

%% 更新采集模板
update_collect_template_dic(Template) ->
	put({?DIC_COLLECT_TEMPLATE, Template#ets_collect_template.template_id}, Template),
	ok.
get_collect_template_dic(Id) ->
	get({?DIC_COLLECT_TEMPLATE, Id}).

%% 创建采集
create_collect(CollectTemplate, MapId, X, Y, AutoID,Now) ->
	NewAutoID = 
		if AutoID > ?MON_LIMIT_NUM ->		%是否超过怪物数量限制
		   	    1;
	   		true -> 
				AutoID
                %StateID + 1
		end,
	create_collect_item(NewAutoID,CollectTemplate,MapId,X,Y,Now).
	%case data_agent:collect_get(TemplateId) of
     %   [] ->
    %        skip;
    %    Template ->
	%		create_collect_item(NewAutoID, Template, MapId, X, Y)
	%end,
	%NewAutoID.

%% 创建采集物品
create_collect_item(Id, Template, MapId, X, Y,Now) ->
	DestructTime = if Template#ets_collect_template.destruct_time =:= 0 -> 0 ;
						true ->	Now + Template#ets_collect_template.destruct_time
					end,
	Info = #r_collect_info{
							 id = Id,			%% id
							 template_id = Template#ets_collect_template.template_id,	%% 模板Id
							 can_reborn = Template#ets_collect_template.can_reborn,
							 destruct_time = DestructTime,
							 x = X,				%% X位置
							 y = Y,				%% Y位置
							 state = 1,			%% 0消亡 ，1正常，
						  	 map_id = MapId		%% 地图id
							},
	update_collect_template_dic(Template),
	lib_map:update_collect_dic(Info),
	Info.

%% 采集物品
collect(CollectId,TemplateId,PlayerPid) ->
	List = lib_map:get_collect_dic(),
	case lists:keyfind(CollectId, #r_collect_info.id, List) of
		false ->
			skip;
		State when State#r_collect_info.template_id =:= TemplateId ->
			collect1(State, PlayerPid);
		_ ->
			skip
	end.

collect1(State, PlayerPid) ->
	if State#r_collect_info.state =/= 0 ->
		    Template = get_collect_template_dic(State#r_collect_info.template_id),
			if	Template#ets_collect_template.type =/= 2 ->
		   			NewState = State#r_collect_info{state=0, dead_time=misc_timer:now_milseconds()},
					lib_map:update_collect_dic(NewState),
					{ok, BinData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, [NewState]),
					mod_map_agent:send_to_map_scene(NewState#r_collect_info.map_id, 
											NewState#r_collect_info.x, 
											NewState#r_collect_info.y, 
											BinData);
				true ->
					skip
			end,
 			 
			gen_server:cast(PlayerPid, {'collect', 
										Template#ets_collect_template.template_id, 
										Template#ets_collect_template.award_hp,
										Template#ets_collect_template.award_mp, 
										Template#ets_collect_template.award_exp, 
										Template#ets_collect_template.award_life_experiences, 
										Template#ets_collect_template.award_yuan_bao, 
										Template#ets_collect_template.award_bind_yuan_bao, 
										Template#ets_collect_template.award_bind_copper, 
										Template#ets_collect_template.award_copper,
										Template#ets_collect_template.award_item});
	   true ->
				skip
	end.

%% 循环
loop() ->
	try
		List = lib_map:get_collect_dic(),
		Now = misc_timer:now_milseconds(),
		NewList = loop1(List, [], Now),
		lib_map:update_all_collect_dic(NewList)
	catch 
		
		Error:Reason ->
			?WARNING_MSG("loop:~w~n,~w~n",[Error, Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			error
	end.
%% 	List = lib_map:get_collect_dic(),
%% 	NewList = loop1(List, []),
%% 	lib_map:update_all_collect_dic(NewList).

loop1([], NewList, _Now) ->
	NewList;
loop1([State|List], NewLsit, Now) ->
	if State#r_collect_info.state =:= 0  ->
		   Template = get_collect_template_dic(State#r_collect_info.template_id),
		   if 
				State#r_collect_info.can_reborn =:= 0 ->
					loop1(List, NewLsit, Now);
				Template#ets_collect_template.reborn_time =:= 0 ->
					loop1(List, [State|NewLsit], Now);
				State#r_collect_info.dead_time + Template#ets_collect_template.reborn_time < Now ->
				  NewState = State#r_collect_info{state=Template#ets_collect_template.type},
				  %lib_map:update_collect_dic(NewState, Template),
				  {ok, BinData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, [NewState]),
				  
				  %% todo 优化成一次发送，不要分多次
				  mod_map_agent:send_to_map_scene(NewState#r_collect_info.map_id, 
											NewState#r_collect_info.x, 
											NewState#r_collect_info.y, 
											BinData),
				  loop1(List, [NewState|NewLsit], Now);
			  true ->
				   loop1(List, [State|NewLsit], Now)
		   end;
	   State#r_collect_info.destruct_time > 0 andalso State#r_collect_info.destruct_time < Now div 1000 ->
				  NewState = State#r_collect_info{state = 0},
				  %lib_map:update_collect_dic(NewState, Template),
				  {ok, BinData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, [NewState]),
				  mod_map_agent:send_to_map_scene(NewState#r_collect_info.map_id, 
											NewState#r_collect_info.x, 
											NewState#r_collect_info.y, 
											BinData),
			loop1(List, NewLsit, Now);
	   true ->
		   loop1(List, [State|NewLsit], Now)
	end.

%%
%% Local Functions
%%

