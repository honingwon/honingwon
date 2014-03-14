%%Author: Administrator
%%Created: 2011-3-5
%%Description: 物品信息
-module(pt_14).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([read/2, write/2]).
-include("common.hrl").
-include("table_to_record.hrl").


%%
%%客户端 -> 服务端 ----------------------------
%%
 
%%道具摆摊
read(?PP_ITEM_STALL,<<Bin/binary>>) ->
	{Stallname,_} = pt:read_string(Bin),
	{ok,Stallname};

%%道具拆分
read(?PP_ITEM_SPLIT, <<Place:32, Count:32>>)->
	{ok ,[Place, Count]};

%%道具整理
read(?PP_ITEM_ARRANGE, <<BagType:32>>) ->
 	{ok, BagType};
 
%%道具回收
read(?PP_ITEM_RETRIEVE, <<Place:32, Count:32>>) ->
 	{ok,[Place,Count]};

%%背包扩充
read(?PP_BAG_EXTEND,<<BagType:8>>) ->
 	{ok,BagType};
 
%%移动物品
read(?PP_ITEM_MOVE,<<FromBagType:32, ResPlace:32, ToBagType:32, DesPlace:32/signed, Count:32>>) ->
 	{ok, [FromBagType, ResPlace, ToBagType, DesPlace, Count]};

%%道具强化
%% read(?PP_ITEM_STRENG,<<ItemPlace:32, StonePlace:32, LuckPlace:32, FailAcount:32,  LuckNum:32, Bin/binary>>) -> 
%% 	PlaceList = read_itemplace(LuckNum, [], Bin),
%% 	{ok, [ItemPlace, StonePlace, LuckPlace, FailAcount, LuckNum, PlaceList]};
read(?PP_ITEM_STRENG,<<ItemPlace:32, StonePlace:32, LuckPlace:32, AKey:8, PetId:64>>) -> 
	{ok, [ItemPlace, StonePlace, LuckPlace, AKey, PetId]};


%%道具合成
read(?PP_ITEM_COMPOSE, <<FormuleId:32,ComposeNum:32>>) ->
	{ok, [FormuleId,ComposeNum]};

%% 装备品质提升
read(?PP_ITME_UPGRADE, <<PetId:64,ItemPlace:32>>) ->
	{ok, [PetId,ItemPlace,0,0,0]};

%% 装备等级提升
read(?PP_ITEM_UPLEVEL, <<PetId:64,ItemPlace:32>>) ->
	{ok, [PetId,ItemPlace,0,0,0]};

%%宝石合成
read(?PP_STONE_COMPOSE, <<StoneId:32,ComposeNum:32,UseBind:8>>) ->
	{ok, [StoneId,ComposeNum,UseBind]};

%%宝石淬炼
read(?PP_STONE_QUENCH, <<StonePlace:32, QuenchPlace:32, IsYuanBao:8, IsBag:8, ItemPlace:32, HolePlace:32>>) ->
	{ok, [StonePlace, QuenchPlace, IsYuanBao, IsBag, ItemPlace, HolePlace]};

%%精致宝石分解
read(?PP_STONE_DECOMPOSE, <<StonePlace:32>>) ->
	{ok, StonePlace};

%%装备融合
read(?PP_ITEM_FUSION, <<BulePlace:32, PurplePlace1:32, PurplePlace2:32>>) ->
	{ok, [BulePlace, PurplePlace1, PurplePlace2]};

%%装备洗练
read(?PP_ITEM_REBUILD, <<PetId:64, ItemPlace:32, StonePlace:32, LockNum:16, Bin/binary>>) ->
	if LockNum > 0 ->
		[LockList,LockPlace] = read_rebulid_lock(LockNum,[],Bin),
		Lucks = {LockPlace,LockNum};
	true ->
		Lucks = {0,0},
		LockList = []	
	end,
	{ok, [PetId, ItemPlace, StonePlace, Lucks, LockList]};
%%替换洗炼属性
read(?PP_ITEM_REPLACE_REBUILD, <<PetId:64, ItemPlace:32>>) ->
	{ok, [PetId, ItemPlace]};

%%道具分解
read(?PP_ITEM_DECOMPOSE, <<ItemPlace:32>>) ->
	{ok, ItemPlace};

%%装备强化等级与洗炼属性转移
read(?PP_ITEM_TRANSFORM, <<OpType:32,ItemPlace1:32,ItemPlace2:32>>) ->
	{ok,[OpType,ItemPlace1,ItemPlace2]};

%%装备熔炼 ItemPlace1:主装备位置, ItemPlace2:副装备位置, ItemID3:熔炼符ID
read(?PP_EQUIP_FUSION, <<ItemPlace1:32, ItemPlace2:32, ItemID3:32>>) ->
	{ok,[ItemPlace1, ItemPlace2, ItemID3]};

%%道具使用
read(?PP_ITEM_USE,<<ItemPlace:32>>) ->
	{ok, ItemPlace};

%%道具购买
read(?PP_ITEM_BUY,<<ShopItemID:32, Count:32,BuyAndUse:8>>) ->
	{ok, [ShopItemID, Count,BuyAndUse]};

%%道具回购
read(?PP_ITEM_BUY_BACK, <<ItemPlace:32>>) ->
	{ok, ItemPlace};

%%道具镶嵌
read(?PP_ITEM_ENCHASE,<<ItemPlace:32, StonePlace:32, HolePlace:32>>) ->
	{ok, [ItemPlace, StonePlace, HolePlace]};

%%装备开孔
read(?PP_ITEM_TAP,<<ItemPlace:32, TapPlace:32>>) ->
	{ok, [ItemPlace, TapPlace]};

%%道具修理
read(?PP_ITEM_REPAIR,<<ItemPlace:32>>) ->
	{ok, ItemPlace};

%%道具出售
read(?PP_ITEM_SELL,<<ItemPlace:32, Count:32>>) ->
	{ok, [ItemPlace, Count]};

%%宝石摘取
read(?PP_ITEM_STONE_PICK, <<ItemPlace:32, PickPlace:32, HolePlace:32>>) ->
	{ok, [ItemPlace, PickPlace, HolePlace]};

%%使用快捷栏的道具
%% read(?PP_SKILLBAR_ITEM_USE,<<TemplateID:32>>) ->
%% 	{ok, [TemplateID]};

%%仓库物品更新
read(?PP_DEPOT_ITEM_UPDATE, <<BagType:32>>) ->
    {ok, BagType};

%%仓库存款 取款操作
read(?PP_DEPOT_MONEY_OPERATE, <<Type:32, Copper:32>>) ->
	{ok, [Type, Copper]};

%%物品查询
read(?PP_ITEM_REFER, <<UserId:64, ItemId:64>>) ->
	{ok, [UserId, ItemId]};

%%使用飞天鞋
read(?PP_USE_TRANSFER_SHOE, <<MapId:32, Pos_X:32, Pos_Y:32>>) ->
	{ok, [MapId, Pos_X, Pos_Y]};

%%神魔令保存任务
read(?PP_SHENMO_SAVE_TASK, <<ItemId:64, TaskId:32>>) ->
	{ok, [ItemId, TaskId]};

%%神魔令保存品质
read(?PP_SHENMO_REFRESH_STATE, <<ShenmoId:64, LingLongId:64>>) ->
	{ok, [ShenmoId, LingLongId]};

%%测试用自动买物品
read(?PP_ITEM_BUY_AUTO, <<TemplateId:32, Amount:32>>) ->
	{ok, [TemplateId, Amount]};

%%每天优惠抢购商品
read(?PP_ITEM_DISCOUNT, <<>>) ->
	{ok, []};

%%开箱子
read(?PP_OPEN_BOX, <<Box_Type:32>>) ->
	{ok, [Box_Type]};

read(?PP_BOX_ALL_DATA, <<>>) ->
	{ok, []};

read(?PP_MOVE_BOX_DATA, <<Type:32, ItemId:64>>) ->
	{ok, [Type, ItemId]};

read(?PP_ALL_WORLD_BOXDATA, <<>>) ->
	{ok, []};
	
%%实时获取优惠抢购商品剩余数量和时间
read(?PP_ITEM_REAL_TIME, <<GoodsId:32>>) ->
	{ok, [GoodsId]};

%%购买优惠商品
read(?PP_ITEM_DISCOUNT_BUY, <<ShopItemID:32, Count:32>>) ->
	{ok, [ShopItemID, Count]};

%%购买功勋商品
read(?PP_ITEM_EXPLOIT_BUY, <<ShopItemID:32, Count:32>>) ->
	{ok, [ShopItemID, Count]};

%%神木蚕丝兑换道具
read(?PP_ITEM_EXCHANG_BUY, <<ShopItemID:32, Count:32>>) ->
	{ok, [ShopItemID, Count]};


%% 玫瑰播放
read(?PP_ROSE_PLAY,<<UserId:64, Type:8, Amount:16, IsAuto:8, Bin/binary>>) ->
	{Nick,_} = pt:read_string(Bin),
	{ok,[UserId,Type,Amount,IsAuto,Nick]};

	
%% 批量使用数据
read(?PP_ITEM_BATCH_USE, <<Place:32, Count:32>>) ->
	{ok, [Place, Count]};

%% 玩家购买帮会商品
read(?PP_ITEM_USER_GUILD_SHOP, <<>>) ->
	{ok, []};

%% 帮会商品购买
read(?PP_ITEM_GUILD_SHOP_BUY, <<ShopItemID:32, Count:32>>) ->
	{ok, [ShopItemID, Count]};

%% 神秘商店商品实时信息
read(?PP_MYSTERY_SHOP_INFO, <<>>) ->
	{ok, []};

%% 神秘商店商品主动刷新
read(?PP_MYSTERY_SHOP_REFRESH, <<>>) ->
	{ok, []};

%% 最近神秘商店记录
read(?PP_MYSTERY_SHOP_ALL_WORLD_DATA,<<>>) ->
	{ok, []};

%% 神秘商店商品购买
read(?PP_MYSTERY_SHOP_BUY,<<Place:8>>) ->
	{ok, [Place]};

%% 请求宠物装备信息
read(?PP_ITEM_PET_PLACE_UPDATE,<<PetId:64>>) ->
	{ok, [PetId]};

read(Cmd, _R) ->
	<<ItemPlace:32, StonePlace:32, LuckPlace:32, AKey:8>> = _R,
	?WARNING_MSG("pt_14 read:~p", [{Cmd,ItemPlace,StonePlace,LuckPlace,AKey}]),
    {error, no_match}.
	
%% 
%%服务端 -> 客户端 ----------------------------
%%

%%道具摆摊
write(?PP_ITEM_STALL, IsSucc) ->
 	{ok, pt:pack(?PP_ITEM_STALL,<<IsSucc:8>>)};

%%背包扩充
write(?PP_BAG_EXTEND, [ExtendCount, DepotExptend]) ->
	Data = <<ExtendCount:32, DepotExptend:32>>,
	{ok,pt:pack(?PP_BAG_EXTEND, Data)};

%%更新背包物品
write(?PP_ITEM_PLACE_UPDATE, [PickType,ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,PickType),
	{ok, pt:pack(?PP_ITEM_PLACE_UPDATE, DataBin)};
%%更新宠物背包装备
write(?PP_ITEM_PET_PLACE_UPDATE, [PetId,PickType,ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,PickType),
	NewBin = <<PetId:64,DataBin/binary>>,
	{ok, pt:pack(?PP_ITEM_PET_PLACE_UPDATE, NewBin)};

%%仓库物品更新
write(?PP_DEPOT_ITEM_UPDATE, [ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,?ITEM_PICK_NONE),
 	{ok, pt:pack(?PP_DEPOT_ITEM_UPDATE, DataBin)};

%%回购物品更新
write(?PP_ITEM_BUY_BACK_UPDATE, [ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,?ITEM_PICK_NONE),
 	{ok, pt:pack(?PP_ITEM_BUY_BACK_UPDATE, DataBin)};


%%开出箱子物品更新
write(?PP_OPEN_BOX_SINGLE, [ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,?ITEM_PICK_NONE),
 	{ok, pt:pack(?PP_OPEN_BOX_SINGLE, DataBin)};

%%箱子所有物品更新
write(?PP_BOX_ALL_DATA, [ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,?ITEM_PICK_NONE),
 	{ok, pt:pack(?PP_BOX_ALL_DATA, DataBin)};

%%移动箱子物品到背包
write(?PP_MOVE_BOX_DATA, [IsSucc, Type, ItemId]) ->
	{ok, pt:pack(?PP_MOVE_BOX_DATA, <<IsSucc:8, Type:32, ItemId:64>>)};
	
%%开箱子临时数据
write(?PP_BOX_CLIENT_DATA, [ItemList, DeleteList]) ->
	DataBin = packet_item_list(ItemList, DeleteList,?ITEM_PICK_NONE),
 	{ok, pt:pack(?PP_BOX_CLIENT_DATA, DataBin)};

write(?PP_BOX_DATA_TO_WORLD, [{NickName, Type, TemplateId}]) ->
	NameBin = pt:write_string(NickName),
	Data = <<
			 NameBin/binary,
			 Type:32,
			 TemplateId:32
			 >>,
	{ok, pt:pack(?PP_BOX_DATA_TO_WORLD, Data)};

write(?PP_ALL_WORLD_BOXDATA, List) ->
	N = length(List),
	F = fun({NickName, Type, TemplateId}) ->
				NameBin = pt:write_string(NickName),
				<<
				  NameBin/binary,
				  Type:32,
				  TemplateId:32
				  >>
		end,	
	Bin = tool:to_binary([F(X)||X <- List]),
	Data = <<N:32, Bin/binary>>,
	{ok, pt:pack(?PP_ALL_WORLD_BOXDATA, Data)};

	
%%摊位状态
%%write(?PP_ITEM_STALL_STATE_REPLY, [UserID,Isexist,StallName,PosX,PosY]) ->
%%	StallBin = pt:write_string(StallName),
%%	Data = <<UserID:64,
%%			 Isexist:8,
%%			 StallBin/binary,
%%			 PosX:32,
%%			 PosY:32>>,
%% 	{ok, pt:pack(?PP_ITEM_STALL,Data)};

%% 道具使用
write(?PP_ITEM_USE, IsSucc) ->
 	{ok, pt:pack(?PP_ITEM_USE,<<IsSucc:8>>)};
	
%% 道具购买
write(?PP_ITEM_BUY, IsSucc) ->
 	{ok, pt:pack(?PP_ITEM_BUY,<<IsSucc:8>>)};

%% 道具回购
write(?PP_ITEM_BUY_BACK, IsSucc) ->
 	{ok, pt:pack(?PP_ITEM_BUY_BACK,<<IsSucc:8>>)};

%% 道具强化
write(?PP_ITEM_STRENG, [IsSucc, ItemId]) ->
	{ok, pt:pack(?PP_ITEM_STRENG,<<IsSucc:8, ItemId:64>>)};


%% 道具镶嵌
write(?PP_ITEM_ENCHASE, [IsSucc, ItemId]) ->
    {ok, pt:pack(?PP_ITEM_ENCHASE, <<IsSucc:8, ItemId:64>>)};     

%% 道具合成
write(?PP_ITEM_COMPOSE, IsSucc) ->
	{ok, pt:pack(?PP_ITEM_COMPOSE, <<IsSucc:8>>)};

%% 道具等级提升
write(?PP_ITEM_UPLEVEL, IsSucc) ->
	{ok, pt:pack(?PP_ITEM_UPLEVEL, <<IsSucc:8>>)};

%% 道具品质提升
write(?PP_ITME_UPGRADE, IsSucc) ->
	{ok, pt:pack(?PP_ITME_UPGRADE, <<IsSucc:8>>)};

%% 装备融合
write(?PP_ITEM_FUSION, IsSucc) ->
	{ok, pt:pack(?PP_ITEM_FUSION, <<IsSucc:8>>)};

%% 装备洗练
write(?PP_ITEM_REBUILD, [IsSucc, ItemId]) ->
	{ok, pt:pack(?PP_ITEM_REBUILD, <<IsSucc:8, ItemId:64>>)};

%% 装备洗练属性替换
write(?PP_ITEM_REPLACE_REBUILD, [IsSucc, ItemId]) ->
	{ok, pt:pack(?PP_ITEM_REPLACE_REBUILD, <<IsSucc:8, ItemId:64>>)};

%% 宝石合成
write(?PP_STONE_COMPOSE, IsSucc) ->
	{ok, pt:pack(?PP_STONE_COMPOSE, <<IsSucc:8>>)};

%% 精致宝石分解
write(?PP_STONE_DECOMPOSE, IsSucc) ->
	{ok, pt:pack(?PP_STONE_DECOMPOSE, <<IsSucc:8>>)};

%% 宝石淬炼
write(?PP_STONE_QUENCH, IsSucc) ->
	{ok, pt:pack(?PP_STONE_QUENCH, <<IsSucc:8>>)};

%% 转移
write(?PP_ITEM_TRANSFORM, IsSucc) ->
	{ok, pt:pack(?PP_ITEM_TRANSFORM, <<IsSucc:8,0:64,0:64>>)};

%% 道具分解
write(?PP_ITEM_DECOMPOSE, IsSucc) ->
	{ok, pt:pack(?PP_ITEM_DECOMPOSE, <<IsSucc:8>>)};

%% 道具宝石摘取
write(?PP_ITEM_STONE_PICK, [IsSucc, ItemId]) ->
	{ok, pt:pack(?PP_ITEM_STONE_PICK, <<IsSucc:8, ItemId:64>>)};

%% 装备开孔
write(?PP_ITEM_TAP, [IsSucc, ItemId]) ->
 	{ok, pt:pack(?PP_ITEM_TAP,<<IsSucc:8, ItemId:64>>)};

%% 熔炼
write(?PP_EQUIP_FUSION, IsSucc) ->
	{ok, pt:pack(?PP_EQUIP_FUSION, <<IsSucc:8>>)};

%% 道具出售
write(?PP_ITEM_SELL, IsSucc) ->
 	{ok, pt:pack(?PP_ITEM_SELL, <<IsSucc:8>>)};

%% 仓库存款 取款操作
write(?PP_DEPOT_MONEY_OPERATE, IsSucc) ->
	{ok, pt:pack(?PP_DEPOT_MONEY_OPERATE, <<IsSucc:8>>)}; 

%% 物品查询 
write(?PP_ITEM_REFER, Info) ->
	Bin = pt:packet_item(Info),
	{ok, pt:pack(?PP_ITEM_REFER, Bin)}; 
	
%% 使用飞天鞋
write(?PP_USE_TRANSFER_SHOE, IsSucc) ->
	{ok, pt:pack(?PP_USE_TRANSFER_SHOE, <<IsSucc:8>>)}; 

%%神魔令
write(?PP_SHENMO_SAVE_TASK, ItemId) ->
	{ok, pt:pack(?PP_SHENMO_SAVE_TASK, <<ItemId:64>>)};
%%神魔令品质更新
write(?PP_SHENMO_REFRESH_STATE, TaskState) ->
	{ok, pt:pack(?PP_SHENMO_REFRESH_STATE, <<TaskState:8>>)};

%%优惠商品抢购
write(?PP_ITEM_DISCOUNT, GoodsList) ->
	DataBin = packet_goods_list(GoodsList),
	{ok, pt:pack(?PP_ITEM_DISCOUNT, DataBin)};
%%实时获取优惠商品的数量
write(?PP_ITEM_REAL_TIME, [GoodsId, CurrCount,LimitCount]) ->
	{ok, pt:pack(?PP_ITEM_REAL_TIME, <<GoodsId:32, CurrCount:32,LimitCount:8>>)};

%%购买优惠商品
write(?PP_ITEM_DISCOUNT_BUY, [IsSucc, GoodsId, CurrCount,LimitCount]) ->
	{ok, pt:pack(?PP_ITEM_DISCOUNT_BUY,<<IsSucc:8, GoodsId:32, CurrCount:32,LimitCount:8>>)};

%%购买功勋商品
write(?PP_ITEM_EXPLOIT_BUY, [IsSucc, UseExploit ,CurrExploit]) ->
	{ok, pt:pack(?PP_ITEM_EXPLOIT_BUY,<<IsSucc:8, UseExploit:32, CurrExploit:32>>)};

%%神木蚕丝兑换道具
write(?PP_ITEM_EXCHANG_BUY, [IsSucc, Pr]) ->
	{ok, pt:pack(?PP_ITEM_EXCHANG_BUY, <<IsSucc:8, Pr:32>>)};

%% 玫瑰花播放
write(?PP_ROSE_PLAY,[SendUserID,SendName,Sex,ReceivedID,ReceiverName,Type,Count] ) ->
	SendNameBin = pt:write_string(SendName),
	ReceiverNameBin = pt:write_string(ReceiverName),
	{ok, pt:pack(?PP_ROSE_PLAY, <<SendUserID:64,SendNameBin/binary,Sex:8, ReceivedID:64,ReceiverNameBin/binary,Type:8,Count:16>>)};

 %% 玩家购买帮会商品记录
write(?PP_ITEM_USER_GUILD_SHOP,[GoodsList]) ->
	DataBin = packet_goods_list1(GoodsList),
	{ok, pt:pack(?PP_ITEM_USER_GUILD_SHOP, DataBin)};

%% 帮会商品购买
write(?PP_ITEM_GUILD_SHOP_BUY, [IsSucc,DiscountItem]) ->
	{ok, pt:pack(?PP_ITEM_GUILD_SHOP_BUY,<<IsSucc:8, 
										   (DiscountItem#discount_items.item_id):32, 
										   (DiscountItem#discount_items.item_count):8,
										   (DiscountItem#discount_items.finish_time):32>>)};

%% 神秘商店更新时间
write(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER, [LastDate,VIPTimes]) ->
	{ok, pt:pack(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER,<<LastDate:64,VIPTimes:8>>)};

%%神秘商店商品实时信息
write(?PP_MYSTERY_SHOP_INFO, [List]) ->
	N = length(List),
	F = fun({Place,Id, State}) ->
			case data_agent:smshop_template_get(Id) of
				[] ->
					<<Place:8,0:32, 1:8,0:8,0:32,0:8>>;
				Template ->
					<<Place:8,
					  (Template#ets_smshop_template.template_id):32, 
					  State:8,
					  (Template#ets_smshop_template.amount):8,
					  (Template#ets_smshop_template.price):32,
					  (Template#ets_smshop_template.pay_type):8>>
			end
		end,	
	Bin = tool:to_binary([F(X)||X <- List]),
	Data = <<N:32, Bin/binary>>,
	{ok, pt:pack(?PP_MYSTERY_SHOP_INFO,Data)};

%% 神秘商店商品刷新返回
write(?PP_MYSTERY_SHOP_REFRESH, [Re]) ->
	{ok, pt:pack(?PP_MYSTERY_SHOP_REFRESH,<<Re:8>>)};

%% 神秘商店出极品并广播
write(?PP_MYSTERY_SHOP_DATA_TO_WORLD, [{NickName,  TemplateId}]) ->
	NameBin = pt:write_string(NickName),
	Data = <<
			 NameBin/binary,
			 TemplateId:32
			 >>,
	{ok, pt:pack(?PP_MYSTERY_SHOP_DATA_TO_WORLD, Data)};

%% 最近神秘商店记录
write(?PP_MYSTERY_SHOP_ALL_WORLD_DATA, List) ->
	N = length(List),
	F = fun({NickName, TemplateId}) ->
				NameBin = pt:write_string(NickName),
				<<
				  NameBin/binary,
				  TemplateId:32
				  >>
		end,	
	Bin = tool:to_binary([F(X)||X <- List]),
	Data = <<N:32, Bin/binary>>,
	{ok, pt:pack(?PP_MYSTERY_SHOP_ALL_WORLD_DATA, Data)};

write(?PP_MYSTERY_SHOP_BUY, [Re]) ->
	{ok, pt:pack(?PP_MYSTERY_SHOP_BUY, <<Re:8>>)};


write(Cmd, _R) ->
	?WARNING_MSG("pt_14,write:~w",[Cmd]),
 	{ok, pt:pack(0, <<>>)}.

%% 
%% -----------------------------------私有函数---------------------------------------
%%

%%物品列表
packet_item_list(ItemList, DeleteList,PickType) ->
	N = length(ItemList) + length(DeleteList),

	FDel = fun(Place) ->
				   <<Place:32,
					 0:8>>
		   end,	
	DelListBin = tool:to_binary([FDel(X)||X <- DeleteList]),
	%%?DEBUG("dhwang_test--DelListBin:~p",[DelListBin]),
	FItem = fun(Info) ->
				case Info#ets_users_items.is_exist of
					1 ->
						BinItem = pt:packet_item(Info),
						<<(Info#ets_users_items.place):32,
						  1:8,
						  PickType:8,
						  BinItem/binary>>;
					_ ->
						<<(Info#ets_users_items.place):32,
						  0:8>>
				end
		end,
	ItemListBin = tool:to_binary([FItem(X)||X <- ItemList]),
	
	<<N:32, DelListBin/binary, ItemListBin/binary>>.



%%获取物品位置列表
read_itemplace(0, L, _) -> 
	L;
read_itemplace(Count, L, <<Place:32, Bin/binary>>) -> 
	L1 = L ++ [Place],
	read_itemplace(Count - 1, L1, Bin).

%%获取洗练锁位置列表
read_rebulid_lock(0,L,<<Place:32>>) ->
	[L,Place];
read_rebulid_lock(Count,L, <<Place:32, Bin/binary>>) ->
	L1 = L ++ [Place],
	read_rebulid_lock(Count - 1, L1, Bin).

%%优惠商品信息
packet_goods_list(GoodsList) ->
	Len = length(GoodsList),
	GFun = fun(Goods) ->
		 <<(Goods#ets_shop_discount_template.id):32,
		 	(Goods#ets_shop_discount_template.state):8,
		   (Goods#ets_shop_discount_template.template_id):32,
		   (Goods#ets_shop_discount_template.pay_type):8,
		   (Goods#ets_shop_discount_template.price):32,
		   (Goods#ets_shop_discount_template.old_price):32,
		   (Goods#ets_shop_discount_template.other_data#other_discount.cheap_type):32,
		   (Goods#ets_shop_discount_template.other_data#other_discount.left_time):32,
		   (Goods#ets_shop_discount_template.other_data#other_discount.left_count):32,
		   (Goods#ets_shop_discount_template.limit_count):8,
		   (Goods#ets_shop_discount_template.max_count):32
		 >>
	end, 
	GoodsListBin = tool:to_binary([GFun(X)||X <- GoodsList]),
	<<Len:32, GoodsListBin/binary>>.


%%玩家购买帮会商品记录
packet_goods_list1(GoodsList) ->
	Len = length(GoodsList),
	GFun = fun(Goods) ->
		 <<
		   (Goods#discount_items.item_id):32,
		   (Goods#discount_items.item_count):8,
		   (Goods#discount_items.finish_time):32
		 >>
	end, 
	GoodsListBin = tool:to_binary([GFun(X)||X <- GoodsList]),
	<<Len:32, GoodsListBin/binary>>.


