%% Author: Administrator
%% Created: 2011-3-26
%% Description: TODO: 防沉迷系统
-module(pt_26).

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

%%提交防沉迷信息
read(?PP_INFANT_POST,<<Bin/binary>>) ->
	{CardName, Bin1} = pt:read_string(Bin),
	{CardId, _} = pt:read_string(Bin1),
	{ok, [CardName, CardId]};
%%获取排行榜信息
read(?PP_TOP_LIST, _) ->
	{ok, []};

%% 获取副本排行榜信息
read(?PP_DUPLICATE_TOP_LIST,<<DuplicateId:32>>) ->
	{ok, [DuplicateId]};

%% 获取试炼副本霸主信息
read(?PP_CHALLENGE_TOP_INFO, <<DuplicateId:32,Index:32>>) ->
	{ok, [DuplicateId,Index]};

read(_Cmd, _) ->
	?DEBUG("pt_26 infant read cmd:~w is error",[_Cmd]),
	ok.

%%
%%服务端 -> 客户端 ----------------------------
%%
%%提交信息回复
write(?PP_INFANT_POST, [Result, Type]) ->
	{ok, pt:pack(?PP_INFANT_POST, <<Result:8, Type:8>>)};

%%填写信息通知
write(?PP_INFANT_NOTICE, [NeedAdd, OnlineTime]) ->
	{ok, pt:pack(?PP_INFANT_NOTICE,<<NeedAdd:8, OnlineTime:32>>)};

%%防沉迷下线通知
write(?PP_INFANT_OFF_LINE, Type) ->
	{ok, pt:pack(?PP_INFANT_OFF_LINE, <<Type:8>>)};

%%防沉迷状态更新通知
write(?PP_INFANT_SEND_STATE, [State, OnlineTime]) ->
	{ok, pt:pack(?PP_INFANT_SEND_STATE, <<State:16, OnlineTime:32>>)};

%%返回排行榜信息 
write(?PP_TOP_LIST, [Bin]) ->
	{ok, pt:pack(?PP_TOP_LIST, <<Bin/binary>>, 1)};
%%返回副本排行榜
write(?PP_DUPLICATE_TOP_LIST, [DuplicateId, TopList]) ->
	Bin = packet_dup_top_list(TopList),
	{ok, pt:pack(?PP_DUPLICATE_TOP_LIST, <<DuplicateId:32, Bin/binary>>)};

%% 返回试炼副本霸主信息
write(?PP_CHALLENGE_TOP_INFO, [Name, Time]) ->
	NameBin = pt:write_string(Name),
	{ok, pt:pack(?PP_CHALLENGE_TOP_INFO, <<NameBin/binary, Time:32>>)};

write(_Cmd, _) ->
	?DEBUG("pt_26 infant write cmd:~w is error",[_Cmd]),
	ok.

%%
%% Local Functions
%%
packet_dup_top_list(TopList) ->
	N = length(TopList),
	F = fun(Info) ->
		Name = pt:write_string(Info#top_duplicate_info.user_name),
		<<(Info#top_duplicate_info.pass_id):32,
			Name/binary,
			(Info#top_duplicate_info.use_time):32>>
		end,
	Bin = tool:to_binary([F(X)||X<-TopList]),
	<<N:32,Bin/binary>>.	


%% packet_top_list(TopList) ->
%% 	N = length(TopList),
%% 	F = fun(Info) ->
%% 			UserId = Info#top_user_info.user_id,
%% 			UserName = pt:write_string(Info#top_user_info.name),
%% 			Vip = Info#top_user_info.vip,
%% 			VipTime = Info#top_user_info.vip_time,
%% 			Sex = Info#top_user_info.sex,
%% 			Career = Info#top_user_info.career,
%% 			Value = Info#top_user_info.value,
%% 			GuildName = pt:write_string(Info#top_user_info.guild_name),
%% 			<<UserId:64,
%% 			UserName/binary,
%% 			Vip:16,
%% 			VipTime:32,
%% 			Sex:8,
%% 			Career:8,
%% 			Value:32,
%% 			GuildName/binary>>
%% 		end,
%% 	Bin = tool:to_binary([F(X)||X<-TopList]),
%% 	<<N:32,Bin/binary>>.	

