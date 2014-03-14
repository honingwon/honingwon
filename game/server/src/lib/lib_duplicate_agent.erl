%% Author: Administrator
%% Created: 2011-5-20
%% Description: TODO: Add description to lib_duplicate_agent
-module(lib_duplicate_agent).

%%
%% Include files
%%
-include("common.hrl").
-define(DIC_TEAM_DUPLICATE, dic_team_duplicate). 
-define(DIC_SINGLE_DUPLICATE, dic_single_duplicate).

%%
%% Exported Functions
%%
-export([
		 init_dic_enroll/0,
		 update_teammate_dic/2,
		 update_team_dic/1,
		 update_single_dic/1
		 
		 
		 ]).

%%
%% API Functions
%%
init_dic_enroll() ->
	put(?DIC_TEAM_DUPLICATE, []),
    put(?DIC_SINGLE_DUPLICATE, []),
	ok.


%% make_a_match() ->
%% 	case get_team_dic() of
%% 		[] ->
%% 			make_a_match_in_single();
%% 		
%% 		TeamList ->
%% 			make_a_match_in_team(TeamList)
%% 	end.
%% 
%% make_a_match_in_single() ->
%% 	case get_single_dic() of
%% 		[] ->
%% 			error;
%% 		SingleList when erlang:length(SingleList) >= 6->
%% 			%%随机6个人组成一个队伍,尽量不同门派
%% 			
%% 			
%% 			ok;
%% 		
%% 		_ ->
%% 			error
%% 	end.
%% 
%% make_a_match_in_team(TeamList) ->
%% 	case get_single_dic() of
%% 		[] ->
%% 			error;
%% 		SingleList ->
%% 			%%个人报名随机到队伍报名中
%% 			[NewSingleList, NewTeamList] = make_a_match_in_team(TeamList, SingleList, TeamList),
%% 			if
%% 				erlang:length(NewSingleList) >= 6 ->
%% 					%%随机6个人组成一个队伍,尽量不同门派
%% 					
%% 					
%% 					ok;
%% 				true ->
%% 					[NewTeamList]
%% 			end	
%% 	end.
%% 
%%  make_a_match_in_team([], SList, NewTList) ->
%%  	%%队伍报名列表为空 
%%  	[SList, NewTList];
%%  make_a_match_in_team(_TList, [], NewTList) ->
%%  	%%个人报名列表为空
%%  	[[], NewTList];
%%  make_a_match_in_team([TeamInfo | TeamList], SList, NewTList) ->
%%  	TeammateInfo = TeamInfo#r_team_enroll.team_enroll_member,
%%  	if
%%  		erlang:length(TeammateInfo) >= 6 ->
%%  			[TeamList, SList, NewTList];
%% 		
%%  		true ->
%%  			%%队伍不足六人,从个人报名列表中随机分配到队伍中
%% 			[NewTeamInfo, NewSList] =  make_a_match_join(erlang:length(TeammateInfo), SList, TeamInfo, SList),
%% 			NewTList1 = lists:keydelete(TeamInfo#r_team_enroll.id, #r_team_enroll.id, NewTList),
%% 			%%更新进程字典
%% 			update_team_dic(NewTeamInfo),
%% 			make_a_match_in_team(TeamList, NewSList, [NewTeamInfo | NewTList1])
%% 	end.
%% 												
%% make_a_match_join(6, _SList, TeamInfo, NewSList) ->
%% 	[TeamInfo, NewSList];
%% make_a_match_join(_N, [], TeamInfo, NewSList) ->
%% 	[TeamInfo, NewSList];
%% make_a_match_join(N, [SingleInfo | SList1], TeamInfo, NewSList) ->
%% 	if
%% 		SingleInfo#r_single_enroll.duplicate_id =/= TeamInfo#r_team_enroll.duplicate_id ->
%% 			make_a_match_join(N, SList1, TeamInfo, NewSList);
%% 		true ->
%% 			TmateInfo = TeamInfo#r_team_enroll.team_enroll_member,
%% 			NewSList1 = lists:keydelete(SingleInfo#r_single_enroll.id, #r_single_enroll.id, NewSList),
%% 			%%更新进程字典
%% 			update_single_dic(SingleInfo#r_single_enroll.id),
%% 			
%% 			%%符合条件 加入队伍
%% 			case SingleInfo#r_single_enroll.team_pid of
%% 				underfined ->
%% 					gen_server:cast(TeamInfo#r_team_enroll.team_pid, {join_team,
%% 																	  SingleInfo#r_single_enroll.id, SingleInfo#r_single_enroll.pid,
%% 																	  SingleInfo#r_single_enroll.nick_name, SingleInfo#r_single_enroll.current_map_id, 
%% 																	  SingleInfo#r_single_enroll.userinfo});
%% 				OtherTeamPid ->
%% 					%%有队伍的从原队伍退出，加入到新的队伍中
%% 					gen_server:cast(OtherTeamPid, {team_quit,  SingleInfo#r_single_enroll.id}),
%% 					gen_server:cast(TeamInfo#r_team_enroll.team_pid, {join_team,
%% 																	  SingleInfo#r_single_enroll.id, SingleInfo#r_single_enroll.pid,
%% 																	  SingleInfo#r_single_enroll.nick_name, SingleInfo#r_single_enroll.current_map_id, 
%% 																	  SingleInfo#r_single_enroll.userinfo})
%% 			end,
%% 			
%% 			make_a_match_join(N, SList1, TeamInfo#r_team_enroll{team_enroll_member=[SingleInfo|TmateInfo]}, NewSList1)
%% 	end.
%% 							 
						
			
	
%%
%% Local Functions
%%


%%	----------------------------辅助方法-----------------------
%% 获取个人报名列表
get_single_dic() ->
	case get(?DIC_SINGLE_DUPLICATE) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

%% 获取队伍报名列表
get_team_dic() ->
	case get(?DIC_TEAM_DUPLICATE) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

%%更新队伍报名队员信息
update_teammate_dic(Info, Team_id) ->
%%	List = get_team_dic(),
	case get_teaminfo_by_id(Team_id) of
		[] ->
			ship;
		TeamInfo ->
			case is_record(Info, r_single_enroll) of
				true ->
					NewList1 = TeamInfo#r_team_enroll.team_enroll_member,
					NewList = 
						case lists:keyfind(Info#r_single_enroll.id, #r_single_enroll.id, NewList1) of
							false ->
								[Info|NewList1];
							true ->
								NewList2 = lists:keydelete(Info#r_single_enroll.id, #r_single_enroll.id, NewList1),
								[Info|NewList2]
						end,
					update_team_dic(TeamInfo#r_team_enroll{team_enroll_member=NewList});
				
				User_id when is_integer(User_id) ->
					NewList1 = TeamInfo#r_team_enroll.team_enroll_member,
					NewList = lists:keydelete(User_id, #r_single_enroll.id, NewList1),
					update_team_dic(TeamInfo#r_team_enroll{team_enroll_member=NewList});
				
				
				_ ->
					?WARNING_MSG("update_teammate_dic:~w", [Info]),
					skip
			end
	end.
							
%%更新队伍报名信息						
update_team_dic(Info) ->
	List = get_team_dic(),
	case is_record(Info, r_team_enroll) of
		true ->
			NewList = 
				case lists:keyfind(Info#r_team_enroll.id, #r_team_enroll.id, List) of
					false ->
 						[Info|List];
					
					_Old ->
						List1 = lists:keydelete(Info#r_team_enroll.id, #r_team_enroll.id, List),
						[Info|List1]
				end,
			put(?DIC_TEAM_DUPLICATE, NewList),
			ok;

		Team_id when is_integer(Team_id) ->
			NewList = lists:keydelete(Team_id, #r_team_enroll.id, List),
			put(?DIC_TEAM_DUPLICATE, NewList),
			ok;
			
		_ ->
			?WARNING_MSG("update_team_dic:~w", [Info]),
			skip
	end.


%% 更新个人报名信息
update_single_dic(Info) ->
	List = get_single_dic(),
	case is_record(Info, r_single_enroll) of
		true ->
			NewList = 
				case lists:keyfind(Info#r_single_enroll.id, #r_single_enroll.id, List) of
					false ->
						[Info|List];
					
					_Old  ->
						List1 = lists:keydelete(Info#r_single_enroll.id, #r_single_enroll.id, List),
						[Info|List1]
				end,
			put(?DIC_SINGLE_DUPLICATE, NewList),
			ok;
		
		User_id when is_integer(User_id) ->
			NewList = lists:keydelete(User_id, #r_single_enroll.id, List),
			put(?DIC_SINGLE_DUPLICATE, NewList),
			ok;
		
		_ ->					
			?WARNING_MSG("update_single_dic:~w", [Info]),
			skip
	end.

 
%%根据报名队伍的获取报名队伍信息
get_teaminfo_by_id(Team_id) ->
	case get_team_dic() of
		[] ->
			[];
		List ->
			case lists:keyfind(Team_id, #r_team_enroll.id, List) of
				false ->
					[];
				Info ->
					Info
			end
	end.

%%根据userid获取个人报名信息
get_singleinfo_by_id(User_id) ->
	case get_single_dic() of
		[] ->
			[];
		List ->
			case lists:keyfind(User_id, #r_single_enroll.id, List) of
				false ->
					[];
				Info ->
					Info
			end
	end.
