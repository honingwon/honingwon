%% Author: liaoxiaobo
%% Created: 2013-8-20
%% Description: TODO: Add description to lib_tokey
-module(lib_tokey).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").

-define(APPID,100722626).							%% 应用编号
-define(APPKEY,"b095ca517d4d6e4956363908bd53321c&").	%% 应用Key
-define(APPMODE,2).									%% 1表示用户不可以修改物品数量，2表示用户可以选择购买物品的数量。 默认为2；



%%
%% Exported Functions
%%
-export([get_tokey/9]).

%%
%% API Functions
%%


get_tokey(PidSend,User_name,ShopItemID,Domain, ShopItemNum,ZoneID,OpenKey,Pf,PfKey) ->
	URI = "/v3/pay/buy_goods",
	URI_Encode = http_uri:encode(URI),
	{_,GoodsMeta,GoodsMeta1 ,GoodsPrice,Goodsurl} = data_goods:get(ShopItemID) ,
	PayItem = tool:to_list(ShopItemID) ++ "*" ++ tool:to_list(GoodsPrice) ++ "*" ++ tool:to_list(ShopItemNum),
	Now =  misc_timer:now_seconds(),
	
	ParamsURL = lists:concat(["appid=" , tool:to_list(?APPID) , "&appmode=" , tool:to_list(?APPMODE) , "&goodsmeta=", GoodsMeta1,
						   "&goodsurl=",Goodsurl,"&openid=" ,  tool:to_list(User_name) , "&openkey=" , OpenKey , "&payitem=" ,
						   PayItem , "&pf=" , Pf , "&pfkey=", PfKey ,"&ts=" , tool:to_list(Now), "&zoneid=" , tool:to_list(ZoneID)]) ,
	
	Params = lists:concat(["appid=" , tool:to_list(?APPID) , "&appmode=" , tool:to_list(?APPMODE) , "&goodsmeta="]),
	Params_Encode = http_uri:encode(Params),
	
	Params1 = lists:concat(["&goodsurl=",Goodsurl,"&openid=" ,  tool:to_list(User_name) , "&openkey=" , OpenKey , "&payitem=" ,
						   PayItem , "&pf=" , Pf , "&pfkey=", PfKey ,"&ts=" , tool:to_list(Now), "&zoneid=" , tool:to_list(ZoneID)]),
	Params1_Encode = http_uri:encode(Params1),
	NewParams_Encode = lists:concat([Params_Encode,tool:to_list(GoodsPrice),"%E9%93%B6%E4%B8%A4","*",tool:to_list(GoodsPrice),"%E9%93%B6%E4%B8%A4",Params1_Encode]),
	
	
	Data = lists:concat([ "GET&" , URI_Encode , "&" , NewParams_Encode]),
	Data1 = re:replace(Data ,"[ *]","%2A",[global,{return,list}]),
	
	Sig = get_sig(Data1),
	
	Sig_Encode = http_uri:encode(Sig),
	URL = lists:concat(["https://" , Domain , URI , "?" , ParamsURL , "&sig=" , Sig_Encode]),
	try
		List = misc:get_https_content(get,{URL, []}, [{ssl,[{verify,0}]},{timeout,3000},{connect_timeout,3000} ], []),
		{ok,Bin} = pt_20:write(?PP_QQ_BUY_GOODS,[List]),
		lib_send:send_to_sid(PidSend,<<Bin/binary>>)
	catch
		_:Reason ->
			?WARNING_MSG("get_tokey error: user_name:~s || url:~s",[User_name,URL])
	end.
	
	


get_sig(Data) -> 
	 base64:encode_to_string( crypto:sha_mac(?APPKEY , Data)).
	

%%
%% Local Functions
%%

