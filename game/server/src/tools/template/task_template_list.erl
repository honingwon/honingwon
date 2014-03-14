%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to task_template_list
-module(task_template_list).

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


create([Infos,States,Awards]) ->
	Len = length(Infos),
	FInfo = fun(Info) ->
			Record = list_to_tuple([ets_task_template] ++ Info),
					
			ContentBin = create_template_all:write_string(Record#ets_task_template.content),
			TargetBin 	= create_template_all:write_string(Record#ets_task_template.target),
			TitleBin 	= create_template_all:write_string(Record#ets_task_template.title),
			
			PreTaskBin 	= create_template_all:write_string(Record#ets_task_template.pre_task_id),
			NextTaskBin = create_template_all:write_string(Record#ets_task_template.next_task_id),
			
			BeginDate = tool:date_to_unix(tool:to_list(Record#ets_task_template.begin_date)),
			EndDate = tool:date_to_unix(tool:to_list(Record#ets_task_template.end_date)),
			
			Accept_eventBin = create_template_all:deploy_string(tool:to_list(Record#ets_task_template.accept_event)),
			Finish_eventBin = create_template_all:deploy_string(tool:to_list(Record#ets_task_template.finish_event)),
           	InitTaskAwardBin  = initTaskAward((tool:to_list(Record#ets_task_template.task_award_id)),Awards),
			TaskStaticBin    =  taskStatic((Record#ets_task_template.task_id),States,Awards),
			
			
					<<(Record#ets_task_template.task_id):32/signed,
					  (Record#ets_task_template.award_copper):32/signed,
					  (Record#ets_task_template.award_exp):32/signed,
					  (Record#ets_task_template.award_yuan_bao):32/signed,
%% 					  (Record#ets_task_template.begin_date):32/signed,
					  BeginDate:32/signed,
					  (Record#ets_task_template.can_jump):8,
					  (Record#ets_task_template.can_repeat):8,
					  (Record#ets_task_template.can_reset):8,
					  (Record#ets_task_template.condition):32/signed,
					   ContentBin/binary,
%% 					  (Record#ets_task_template.end_date):32/signed,
					  EndDate:32/signed,
					  (Record#ets_task_template.max_level):32/signed,
					  (Record#ets_task_template.min_level):32/signed,
					  (Record#ets_task_template.min_guild_level):32/signed,
					  (Record#ets_task_template.max_guild_level):32/signed,
%% 					  (Record#ets_task_template.next_task_id):32/signed,
					  NextTaskBin/binary,
					  (Record#ets_task_template.npc):32/signed,
%% 					  (Record#ets_task_template.pre_task_id):32/signed,
					  PreTaskBin/binary,
					  (Record#ets_task_template.repeat_count):32/signed,
					  (Record#ets_task_template.repeat_day):32/signed,
					  TargetBin/binary,
					  (Record#ets_task_template.time_limit):8,
					  TitleBin/binary,
					  (Record#ets_task_template.type):32/signed,
					  (Record#ets_task_template.camp):32/signed,
					  (Record#ets_task_template.career):32/signed,
					  (Record#ets_task_template.sex):32/signed,
					  (Record#ets_task_template.can_entrust):8,
					  (Record#ets_task_template.entrust_time):32/signed,
					  (Record#ets_task_template.entrust_copper):32/signed,
					  (Record#ets_task_template.entrust_yuan_bao):32/signed,
					  (Record#ets_task_template.can_transfer):8,
					  (Record#ets_task_template.show_level):32,
					  (Record#ets_task_template.auto_accept):8,
					  (Record#ets_task_template.auto_finish):8,
 					  (Record#ets_task_template.need_item_id):32,
					  (Record#ets_task_template.need_copper):32,
					  Accept_eventBin/binary,
                      Finish_eventBin/binary,
					  InitTaskAwardBin/binary,
                      TaskStaticBin/binary
					  >>
			   end,
	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%


%%添加奖励物品
initTaskAward(TaskAwardID,Awards) -> 
	Fawr=fun(Awrinfo)->
			list_to_tuple([ets_task_award_template] ++ Awrinfo)
			end,
    Awards_list=lists:map(Fawr,Awards),
	
	TaskAwardIDs 	=string:tokens(TaskAwardID, ","),
	FTaskAwardInfo 	= fun(Info2,Acc)->
						AwardidInfo =tool: to_integer(Info2),
         				case lists:keyfind(AwardidInfo, 2, Awards_list) of
							false ->
								Acc;
							List  ->
								[List|Acc]
   						end
						end,
    TempAward=lists:foldl(FTaskAwardInfo, [], TaskAwardIDs), 
	
    TempLen = length(TempAward),
	TempAwardInfo = fun(AwardInfo)->
                Record1 = AwardInfo,
                    <<(Record1#ets_task_award_template.award_id):32/signed,
					  (Record1#ets_task_award_template.career):32/signed,
					  (Record1#ets_task_award_template.amount):32/signed,
					  (Record1#ets_task_award_template.is_bind):8,
					  (Record1#ets_task_award_template.sex):32/signed,
					  (Record1#ets_task_award_template.template_id):32/signed,
					  (Record1#ets_task_award_template.validate):32/signed>>
		             end,
		TempAwardBin = tool:to_binary([TempAwardInfo(X)||X <- TempAward]),
        <<TempLen:32/signed, TempAwardBin/binary>>.


taskStatic(Task_id,Statics,Awards) ->
     		Fst = fun(Static, Acc) ->
					StaticA	= list_to_tuple([ets_task_state_template] ++ Static),
					if Task_id=:=StaticA#ets_task_state_template.task_id ->
				  	 		[StaticA|Acc];
						true ->
							Acc
		    		end
				end,
	 StaticList = lists:foldr(Fst, [], Statics),
		 
    StaticLen = length(StaticList),
	FStaticInfo = fun(StaticInfo)->
                       Record2=StaticInfo,
					   BinAward = initTaskAward(tool:to_list(Record2#ets_task_state_template.task_award_id),Awards),
					   DataBin 	= create_template_all:write_string(Record2#ets_task_state_template.data),
					   TargetBin = create_template_all:write_string(Record2#ets_task_state_template.target),
					   ContentBin = create_template_all:write_string(Record2#ets_task_state_template.content),
					   
					   Unfinish_eventBin =create_template_all:deploy_string(tool:to_list(Record2#ets_task_state_template.unfinish_event)),
					   Finish_event1Bin  =create_template_all:deploy_string(tool:to_list(Record2#ets_task_state_template.finish_event1)),
					   Finish_event2Bin  =create_template_all:deploy_string(tool:to_list(Record2#ets_task_state_template.finish_event2)),
					   
                    <<(Record2#ets_task_state_template.award_copper):32/signed,
					  (Record2#ets_task_state_template.award_exp):32/signed,
					  (Record2#ets_task_state_template.award_yuan_bao):32/signed,
					  (Record2#ets_task_state_template.award_life_experience):32/signed,					  
					  (Record2#ets_task_state_template.award_bind_yuan_bao):32/signed,
					  (Record2#ets_task_state_template.award_bind_copper):32/signed,
					  (Record2#ets_task_state_template.award_contribution):32/signed,
					  (Record2#ets_task_state_template.award_money):32/signed,
					  (Record2#ets_task_state_template.award_activity):32/signed,
					  (Record2#ets_task_state_template.award_feats):32/signed,				  					  
					  (Record2#ets_task_state_template.condition):32/signed,
					  (Record2#ets_task_state_template.can_transfer):8,
					  					  					  
					   DataBin/binary,
					   TargetBin/binary,
					  (Record2#ets_task_state_template.npc):32/signed,
                       ContentBin/binary,
                       Unfinish_eventBin/binary,
                       Finish_event1Bin/binary,
                       Finish_event2Bin/binary,
                       BinAward/binary>>
                    end,
		StaticListBin = tool:to_binary([FStaticInfo(X)||X <- StaticList]),
        <<StaticLen:32/signed, StaticListBin/binary>>.


