%% Author: Administrator
%% Created: 2011-3-21
%% Description: TODO: 系统信息
-module(pt_29).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 read/2,
		 write/2
		 ]).

%%
%% API Functions
%%

%%
%%客户端 -> 服务端 ----------------------------
%%

%% 获取目标列表
read(?PP_TARGET_LIST_UPDATE, _) ->
	{ok, []};

%% 获取某个目标奖励
read(?PP_TARGET_GET_AWARD, <<Id:32>>) ->
	{ok, [Id]};

read(?PP_TARGET_HISTORY_UPDATE,_) ->
	{ok,[]};

%% 发起求婚请求：用户id求婚类型
read(?PP_MARRY_REQUEST, <<Id:64,Type:16>>) ->
	{ok, [Id,Type]};
%% 返回求婚结果
read(?PP_MARRY_ECHO, <<Res:8>>) ->
	{ok, [Res]};
%%请求结婚礼堂信息
read(?PP_MARRY_HALL_INFO, _) ->
	{ok, []};
%% 发送请帖
read(?PP_SEND_INVITATION_CARD, <<N:16,Bin/binary>>) ->
	List = read_invitation_list(N,Bin,[]),
	{ok, [List]};
%% 送礼
read(?PP_GIVE_GIFT, <<Type:16, Id:64>>) ->
	{ok, [Type,Id]};
%% 查看礼单
read(?PP_SEE_GIFT_LIST, _) ->
	{ok,[]};
%% 收取礼金
read(?PP_GET_CASH_GIFT, _) ->
	{ok,[]};
%% 发送喜糖
read(?PP_SEND_CANDY, <<Type:16>>) ->
	{ok,[Type]};
%% 开始婚礼
read(?PP_START_MARRY, _) ->
	{ok,[]};
%% 离开礼堂  
read(?PP_QUIT_HALL, _) ->
	{ok,[]};
%% 结婚关系列表
read(?PP_MARRY_LIST, _) ->
	{ok,[]};
%% 离婚1普通，2强制收费		
read(?PP_DIVORCE, <<MarryId:64,Type:16>>) ->
	{ok,[MarryId,Type]};
%% 修改小妾为妻，原妻变妾10两
read(?PP_MARRY_CHANGE,<<MarryId:64>>) ->
	{ok, [MarryId]};
%% 普通离婚处理
read(?PP_DIVORCE_REPLY,<<MarryId:64,Res:8>>) ->
	{ok, [MarryId,Res]};

read(_Cmd, _) ->
	?DEBUG("pt_29 read cmd:~w is error",[_Cmd]),
	ok.

%%
%%服务端 -> 客户端 ----------------------------
%%
write(?PP_TARGET_LIST_UPDATE,[List,Num]) ->
	Len = length(List),
	F = fun(Info) ->
				<<
				  (Info#ets_users_targets.target_id):32,
				  (Info#ets_users_targets.data):32,
				  (Info#ets_users_targets.is_receive):8,
				  (Info#ets_users_targets.is_finish):8
				>>
		end,
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_TARGET_LIST_UPDATE,<<Len:16,Num:8,Bin/binary>>)};



write(?PP_TARGET_GET_AWARD,[Id,Num,Res]) ->
	{ok, pt:pack(?PP_TARGET_GET_AWARD,<<Id:32,Num:8,Res:8>>)};



write(?PP_TARGET_ACHIEVEMENT_UPDATE,[Num,Total_Num]) ->
	{ok, pt:pack(?PP_TARGET_ACHIEVEMENT_UPDATE,<<Num:32,Total_Num:32>>)};


write(?PP_TARGET_FINISH,[List]) ->
	Len = length(List),
	F = fun(Info) ->
				<<
				  (Info#ets_users_targets.target_id):32
				>>
		end,
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_TARGET_FINISH,<<Len:16,Bin/binary>>)};

write(?PP_TARGET_HISTORY_UPDATE,[List]) ->
	Len = length(List),
	F = fun(Info) ->
				<<
				  (Info#ets_users_targets.target_id):32
				>>
		end,
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_TARGET_HISTORY_UPDATE,<<Len:16,Bin/binary>>)};

%% 发起求婚请求返回
write(?PP_MARRY_REQUEST,Res) ->
	{ok, pt:pack(?PP_MARRY_REQUEST, <<Res:8>>)};
%% 通知求婚请求
write(?PP_MARRY_REQUEST_NOTICE,[Type,NickName,Relation])->
	Name = pt:write_string(NickName),
	{ok, pt:pack(?PP_MARRY_REQUEST_NOTICE, <<Type:16,Name/binary,Relation:16>>)};
%% 返回求婚结果
write(?PP_MARRY_ECHO, Res) ->%%1表示同意，等被传送。0表示失败，关闭窗口
	{ok, pt:pack(?PP_MARRY_ECHO, <<Res:8>>)};
%% 通知求婚方求婚结果
write(?PP_MARRY_ECHO_NOTICE, [NickName, Res]) ->
	Name = pt:write_string(NickName),
	{ok, pt:pack(?PP_MARRY_ECHO_NOTICE, <<Name/binary,Res:16>>)};
%% 发送请帖
write(?PP_SEND_INVITATION_CARD, [NickName, NickName1,MarryType,Id]) ->
	Name = pt:write_string(NickName),
	Name1 = pt:write_string(NickName1),
	{ok, pt:pack(?PP_SEND_INVITATION_CARD, <<Name/binary,Name1/binary,MarryType:16,Id:64>>)};
%% 随礼
write(?PP_GIVE_GIFT, [Res]) ->	
	{ok, pt:pack(?PP_GIVE_GIFT, <<Res:8>>)};
%% 发糖返回
write(?PP_SEND_CANDY, [Res,Type]) ->
	{ok, pt:pack(?PP_SEND_CANDY,<<Res:8,Type:16>>)};
%% 查看礼单
write(?PP_SEE_GIFT_LIST, [ListBin]) ->	
	{ok, pt:pack(?PP_SEE_GIFT_LIST, <<ListBin/binary>>)};

%% 拜堂结束
write(?PP_START_MARRY, [_Res]) ->
	{ok, pt:pack(?PP_START_MARRY, <<1:8>>)};

%% 婚礼结束
write(?PP_MARRY_FINISH, [_Res]) ->
	{ok, pt:pack(?PP_MARRY_FINISH, <<1:8>>)};

%% 获取婚礼信息
write(?PP_MARRY_HALL_INFO, [UserId1,UserId2,STime,State,FreeNum,Name1,Name2]) ->
	N1 = pt:write_string(Name1),
	N2 = pt:write_string(Name2),
	{ok, pt:pack(?PP_MARRY_HALL_INFO, <<UserId1:64,UserId2:64,STime:32,State:16,FreeNum:16,N1/binary,N2/binary>>)};
%% 返回结婚关系列表
write(?PP_MARRY_LIST,[List]) ->
	N = length(List),
	Bin = read_marry_list(List,<<>>),
	{ok, pt:pack(?PP_MARRY_LIST,<<N:16,Bin/binary>>)};
%% 离婚1普通，2强制收费	
write(?PP_DIVORCE,[Res,Id]) ->
	{ok, pt:pack(?PP_DIVORCE,<<Res:8, Id:64>>)};

%% 提升小妾为妻
write(?PP_MARRY_CHANGE,[Res,Id]) ->
	{ok, pt:pack(?PP_MARRY_CHANGE, <<Res:8, Id:64>>)};

%% 普通离婚处理
write(?PP_DIVORCE_REPLY,[Res]) ->
	{ok, pt:pack(?PP_DIVORCE_REPLY, <<Res:8>>)};

write(_Cmd, _) ->
	?DEBUG("pt_29 write cmd:~w is error",[_Cmd]),
	ok.

read_marry_list([],Bin) -> Bin;
read_marry_list([H|T],Bin) -> 
	%?DEBUG("read_marry_list:~p",[H]),
	Name2 = pt:write_string(H#ets_user_marry.bride_name),
	NewBin =
	<<(H#ets_user_marry.user_id):64,
	  (H#ets_user_marry.marry_id):64,
	  (H#ets_user_marry.type):16,
	  (H#ets_user_marry.career):16,
	  (H#ets_user_marry.sex):16,
	  Name2/binary,
	  Bin/binary>>,
read_marry_list(T,NewBin).


read_invitation_list(0,_Bin,List) -> List;
read_invitation_list(N,Bin,List) ->
	case Bin of
		<<Id:64,B/binary>> ->
			read_invitation_list(N - 1,B,[Id|List]);
		_ ->
			?DEBUG("read_invitation_list error:~p",[Bin]),
			List
	end.

	

