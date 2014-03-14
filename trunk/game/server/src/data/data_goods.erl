%% Author: liaoxiaobo
%% Created: 2013-8-19
%% Description: TODO: Add description to data_goods
-module(data_goods).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([get/1]).

%%
%% API Functions
%%

get(9001) ->
	{9001,"100yuanbao*100yuanbao","100银两*100银两",100,"http://app100722626.imgcache.qzoneapp.com/app100722626/1000/store/206100.jpg"};

get(9002) ->
	{9002,"1000yuanbao*1000yuanbao","1000银两*1000银两",1000,"http://app100722626.imgcache.qzoneapp.com/app100722626/1000/store/206101.jpg"};

get(9003) ->
	{9003,"5000yuanbao*5000yuanbao","5000银两*5000银两",5000,"http://app100722626.imgcache.qzoneapp.com/app100722626/1000/store/206102.jpg"};

get(9004) ->
	{9004,"20000yuanbao*20000yuanbao","20000银两*20000银两",20000,"http://app100722626.imgcache.qzoneapp.com/app100722626/1000/store/206103.jpg"};

get(_) ->
	{9004,"20000yuanbao*20000yuanbao","20000银两*20000银两",20000,"http://app100722626.imgcache.qzoneapp.com/app100722626/1000/store/206103.jpg"}.



%%
%% Local Functions
%%

