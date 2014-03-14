%% Created: 2011-3-8

%% Description: TODO: Add description to goods_uti
-module(item_util).


-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-export([
		 init_item_template/0,
		 init_item_template1/0,
		 init_item_online/2,
		 get_null_cells/2,
		 get_item_list/1,
		 get_item_list/2,
		 check_shop_has_template/2,
		 get_shop_sale_list/1,
		 get_shop_template/2,
		 get_user_item_by_place/2,
		 get_user_item_by_place/3,
		 get_user_item_by_id/2,
		 get_equip_cell/1,
		 get_equip_list/1,
		 get_pet_equip_list/1,
		 get_bag_list/1,
		 calc_equip_num/2,
		 sort/2,
		 calc_equip_fight/1,
		 calc_equip_properties/3,
		 calc_pet_equip_properties/2,
		 calc_equip_properties/1,
		 update_stylebin/3,
		 item_offline/0,
		 get_null_temp_cells/1,
		 open_item_script/2,
		 get_count_by_templateid/2,
		 get_count_by_templateid/3,
		 get_count_by_categoryid/3,
		 get_user_item_by_templateid/2,
		 get_user_item_by_templateid/3,
		 get_pet_enchase1/2,
		 get_nullcells_in_depot/2,
		 create_new_item/4,
		 create_new_item/6,
		 create_new_item/7,
		 get_depot_bag_list/1,
		 get_nullcells_in_box/1,
		 update_item_to_bag/1,
		 delete_dic/1,
		 auto_buy_need/1,
		 get_item_name/1,
		 save_dic/0,	
		 delete_dic/2,
		 delete_dic_thorough/1, 
		 get_offline_equip_list/1,
		 get_offline_pet_equip_list/2,
		 check_enough_material/2,
		 add_item_consume_log/8,
	
	     remove_itemnum/4,

		 add_item_and_get_id/1,
		 
		 init_smshop_info/1,
		 update_smshop_info/1,
		 get_ref_smshop_info/0,
		 get_pet_equip_by_place/2
		]).


-define(DIC_USERS_ITEMS, dic_users_items). %% 玩家物品字典
-define(DIC_ITEMS_DEL, dic_items_del). 	   %% 删除物品字典
-define(DIC_ITEMS_DEL_LOG, dic_item_del_log).	%%玩家物品消耗日志字典
-define(DIC_SMSHIP_ITEMS, dic_smship_items).%% 玩家神秘商让商品字典

-define(ITEM_LOG_FILTER_LIST,[{206027},{206028},{206029},{206030},{206031},{206032},{206057},{206056},{206018},{206019},{206020},
								{206021},{206001},{206002},{201025},{201026},{202001}]).
%%
%% API Functions
%%
 
init_item_template() ->
	ok = init_item_template1(),
	ok = init_item_category_template(),
	ok = init_shop_template(),
	ok = init_equip_enchase_template(),
	ok = init_equip_strength_template(),
	ok = init_strengthen_template(),
	ok = init_hole_template(),
	ok = init_enchase_template(),
%%  ok = init_all_function_template(),
    ok = init_enchase_stone_template(),
	ok = init_pick_stone_template(),
%%	ok = init_item_rebuild_template(),
    ok = init_streng_rate_template(),
	ok = init_item_upgrade_template(),
	ok = init_item_uplevel_template(),
	ok = init_formula_template(),
	ok = init_decompose_template(),
	ok = init_stone_compose_template(),
	ok = init_rebuild_prop_template(),
	ok = init_streng_addsuccrate_template(),
	ok = init_streng_copper_template(),
	ok = init_decompose_copper_template(),
	ok = init_streng_modulus_template(),
	ok = init_box_template(),
	ok = init_smshop_template(),
	ok = init_suit_props_template(),
	ok = init_item_fusion_template(),
	ok.



%% 初始化物品类型列表
init_item_template1() ->
    F = fun(Info) ->
				NewInfo = list_to_tuple([ets_item_template] ++ (Info)),
				if
					NewInfo#ets_item_template.category_id >= ?SMALLITEMCATE andalso NewInfo#ets_item_template.category_id =< ?MAXITEMCATE ->	                      				
						%%固定属性
						RegularList = tool:split_string_to_intlist(NewInfo#ets_item_template.regular_property),
						%%隐藏属性
						HidePropList = tool:split_string_to_intlist(NewInfo#ets_item_template.hide_property),
						
						%%自由属性
						FreeProperty = tool:split_string_to_intlist(NewInfo#ets_item_template.free_property),
						Record = #other_item_template{},
   					    NewRecord1 = calc_equip_properties_by_property(Record, lists:append(RegularList, HidePropList)),				
						
 						if
 							erlang:length(FreeProperty) =:= 0 ->
								NewRecord = NewRecord1;
 							true ->
 								NewRecord = calc_rebuild_free_property(NewRecord1, FreeProperty)
 						end,	
						NewInfo1 = NewInfo#ets_item_template{other_data=NewRecord},
										
						ets:insert(?ETS_ITEM_TEMPLATE, NewInfo1);

				true ->								
						Record = #other_item_template{},
						NewInfo1 = NewInfo#ets_item_template{other_data=Record},
						ets:insert(?ETS_ITEM_TEMPLATE, NewInfo1)
					end
		end,

	case db_agent_template:get_item_template_info() of
		[] -> 
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_item_category_template() ->
    F = fun(Info) ->
				
				  Record = list_to_tuple([ets_item_category_template] ++ Info),
                  ets:insert(?ETS_ITEM_CATEGORY_TEMPLATE, Record)
           end,
    case db_agent_template:get_item_category_template_info() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.


init_shop_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_shop_template] ++ Info),
				  %%Key = {Record#ets_shop_template.shop_id, Record#ets_shop_template.template_id, Record#ets_shop_template.pay_type},
				  %%NewRecord = Record#ets_shop_template{shop_id=Key},
                  ets:insert(?ETS_SHOP_TEMPLATE, Record)
           end,
    case db_agent_template:get_shop_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.

init_equip_enchase_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_equip_enchase_template] ++ Info),
				  L = tool:split_string_to_intlist(Record#ets_equip_enchase_template.add_properties),
				  NewRecord = Record#ets_equip_enchase_template{add_properties = L},
                  ets:insert(?ETS_EQUIP_ENCHASE_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_equip_enchase_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.	

init_equip_strength_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_equip_strength_template] ++ Info),
                  ets:insert(?ETS_EQUIP_STRENGTH_TEMPLATE, Record)
           end,
    case db_agent_template:get_equip_strength_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.	

init_strengthen_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_strengthen_template] ++ Info),
                  ets:insert(?ETS_STRENGTHEN_TEMPLATE, Record)
           end,
    case db_agent_template:get_strengthen_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.

init_rebuild_prop_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_rebuild_prop_template] ++ Info),
				  
				  NewRcord =  Record#ets_rebuild_prop_template{quality = {Record#ets_rebuild_prop_template.quality,
																		  Record#ets_rebuild_prop_template.prop_num}},
                  ets:insert(?ETS_REBUILD_PROP_TEMPLATE, NewRcord)
           end,
    case db_agent_template:get_rebuild_prop_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.


init_stone_compose_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_stone_compose_template] ++ Info),
                  ets:insert(?ETS_STONE_COMPOSE_TEMPLATE, Record)
           end,
    case db_agent_template:get_stone_compose_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.

init_suit_props_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_suit_props_template] ++ Info),
				  Suit_props = tool:split_string_to_intlist(Record#ets_suit_props_template.suit_props),
				  NewRecord = Record#ets_suit_props_template{
															 id = {Record#ets_suit_props_template.suit_num,
																   Record#ets_suit_props_template.suit_amount},
															 suit_props = Suit_props
															 },
				  				  
                  ets:insert(?ETS_SUIT_PROPS_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_suit_props_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.




%%初始化箱子数据
init_box_template() ->
	F = fun(Info, List) ->
 				  Record = list_to_tuple([ets_box_template] ++ Info),

				  case lists:keyfind({Record#ets_box_template.box_type, Record#ets_box_template.career}, 1, List) of
					  false ->
						  BoxData = {Record#ets_box_template.rate, Record#ets_box_template.item_id, 
						   Record#ets_box_template.amount, Record#ets_box_template.streng_level, Record#ets_box_template.is_bind,Record#ets_box_template.modulus},
						  [{{Record#ets_box_template.box_type, Record#ets_box_template.career}, [BoxData], Record#ets_box_template.rate} |  List];
					  
					  Old ->
						  {Id, Data, Rate} = Old,
						  List1 = lists:keydelete(Id, 1, List),						 
						  BoxData = {Record#ets_box_template.rate+Rate, Record#ets_box_template.item_id, 
						   Record#ets_box_template.amount, Record#ets_box_template.streng_level, Record#ets_box_template.is_bind, Record#ets_box_template.modulus},											  
						  [{Id, lists:append(Data, [BoxData]), Rate+Record#ets_box_template.rate} | List1]
				  end
		end,
	  
    case db_agent_template:get_box_template() of
         [] -> 
			 skip;
         TemplateList when is_list(TemplateList) ->
			 NewList = lists:foldl(F , [], TemplateList),			 			 
			 F1 = fun(BoxInfo) ->
						BoxRecord = list_to_tuple([ets_box_data] ++ tuple_to_list(BoxInfo)),						
						ets:insert(?ETS_BOX_DATA, BoxRecord)
				  end,
			 lists:foreach(F1, NewList);
			   
         _ -> 
			 skip
	end,
	ok.

init_smshop_template() ->
	F = fun(Info, Rate) ->
 				  Record = list_to_tuple([ets_smshop_template] ++ Info),
				  NewRate = Record#ets_smshop_template.rate+Rate,
				  NewRecord = Record#ets_smshop_template{rate = NewRate},
				  ets:insert(?ETS_SMSHOP_TEMPLATE, NewRecord),
				  NewRate
		end,
	  
    case db_agent_template:get_smshop_template() of
         [] -> 
			 skip;
         TemplateList when is_list(TemplateList) ->
			 lists:foldl(F , 0, TemplateList);
         _ -> 
			 skip
	end,
	ok.

init_hole_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_hole_template] ++ Info),
				 ets:insert(?ETS_HOLE_TEMPLATE, Record)
		
		 end,
	case db_agent_template:get_hole_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_enchase_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_enchase_template] ++ Info),

				 ets:insert(?ETS_ENCHASE_TEMPLATE, Record)
		 end,
	case db_agent_template:get_enchase_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

%% init_all_function_template() ->
%% 	F = fun(Info) ->
%% 				 Record = list_to_tuple([ets_all_function_template] ++ Info),
%% 				
%% 				 NewRcord =  Record#ets_all_function_template{id = {Record#ets_all_function_template.type,
%% 															        Record#ets_all_function_template.quality}},
%% 				 ets:insert(?ETS_ALL_FUNCTION_TEMPLATE, NewRcord)
%% 		 end,
%% 	case db_agent_template:get_all_function_template() of
%% 		[] -> skip;
%% 		List when is_list(List) ->
%% 			lists:foreach(F, List);
%% 		_ -> skip
%% 	end,
%% 	ok.



init_streng_copper_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_streng_copper_template] ++ Info),
				 ets:insert(?ETS_STRENG_COPPER_TEMPLATE, Record)
		 end,
	case db_agent_template:get_streng_copper_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_decompose_copper_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_decompose_copper_template] ++ Info),
				 ets:insert(?ETS_DECOMPOSE_COPPER_TEMPLATE, Record)
		 end,
	case db_agent_template:get_decompose_copper_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.


init_pick_stone_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_pick_stone_template] ++ Info),
				
				 ets:insert(?ETS_PICK_STONE_TEMPLATE, Record)
		 end,
	case db_agent_template:get_pick_stone_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

%% init_item_rebuild_template() ->
%% 	F = fun(Info) ->
%% 				 Record = list_to_tuple([ets_rebuild_template] ++ Info),
%% 
%% 				 NewRcord =  Record#ets_rebuild_template{id = {Record#ets_rebuild_template.category_id,
%% 															   Record#ets_rebuild_template.quality}},
%% 				 ets:insert(?ETS_REBUILD_TEMPLATE, NewRcord)
%% 		 end,
%% 	case db_agent_template:get_item_rebuild_template() of
%% 		[] -> skip;
%% 		List when is_list(List) ->
%% 			lists:foreach(F, List);
%% 		_ -> skip
%% 	end,
%% 	ok.

init_streng_rate_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_streng_rate_template] ++ Info),

				 NewRcord =  Record#ets_streng_rate_template{id = {Record#ets_streng_rate_template.category_id,
															       Record#ets_streng_rate_template.streng_level}},
				 ets:insert(?ETS_STRENG_RATE_TEMPLATE, NewRcord)
		 end,
	case db_agent_template:get_streng_rate_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_streng_modulus_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_streng_modulus_template] ++ Info),
				 
				 NewRcord =  Record#ets_streng_modulus_template{id = {Record#ets_streng_modulus_template.quality,
															          Record#ets_streng_modulus_template.max_level}},
				 
				 ets:insert(?ETS_STRENG_MODULUS_TEMPLATE, NewRcord)
		 end,
	case db_agent_template:get_streng_mudulus_template() of
		[] -> 
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.


init_streng_addsuccrate_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_streng_addsuccrate_template] ++ Info),
				 ets:insert(?ETS_STRENG_ADDSUCCRATE_TEMPLATE, Record)
		 end,
	case db_agent_template:get_streng_addsuccrate_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_formula_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_formula_template] ++ Info),
				 ets:insert(?ETS_FORMULA_TEMPLATE, Record)
		 end,
	case db_agent_template:get_formula_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_item_upgrade_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_item_upgrade_template] ++ Info),
%% 				 UpLevelMaterial = tool:split_string_to_intlist(Record#ets_item_uplevel_template.uplevel_material),
				 UpQualityMaterial = tool:split_string_to_intlist(Record#ets_item_upgrade_template.upquality_material),
%% 				 NewRcord = Record#ets_item_uplevel_template{uplevel_material = UpLevelMaterial, upquality_material = UpQualityMaterial},
				 NewRcord = Record#ets_item_upgrade_template{upquality_material = UpQualityMaterial},
				 ets:insert(?ETS_ITEM_UPGRADE_TEMPLATE, NewRcord)
		 end,
	case db_agent_template:get_item_upgrade_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_item_uplevel_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_item_uplevel_template] ++ Info),
				 UpQualityMaterial = tool:split_string_to_intlist(Record#ets_item_uplevel_template.uplevel_material),
	
				 NewRcord = Record#ets_item_uplevel_template{uplevel_material = UpQualityMaterial},
			
				 ets:insert(?ETS_ITEM_UPLEVEL_TEMPLATE, NewRcord)
		 end,
	case db_agent_template:get_item_uplevel_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.


init_decompose_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_decompose_template] ++ Info),
				 ets:insert(?ETS_DECOMPOSE_TEMPLATE, Record)
		 end,
	case db_agent_template:get_decompose_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_enchase_stone_template() ->
	F = fun(Info) ->
				 Record = list_to_tuple([ets_item_stone_template] ++ Info),
				 ets:insert(?ETS_ITEM_STONE_TEMPLATE, Record)
		 end,
	case db_agent_template:get_enchase_stone_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_item_fusion_template() ->
	F = fun(Info) ->
			Record = list_to_tuple([ets_item_fusion_template] ++ Info),
			NewRecord = Record#ets_item_fusion_template{item_template_id1 = {Record#ets_item_fusion_template.item_template_id1,
													Record#ets_item_fusion_template.item_template_id2}},
			ets:insert(?ETS_ITEM_FUSION_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_item_fusion_template() of
		[] -> skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

%% 取物品类型信息
%% @spec get_ets_info(Tab, Id) -> record()
%% get_ets_info(Tab, Id) ->
%%     L = case is_integer(Id) of
%%             true -> 
%% 				ets:lookup(Tab, Id);
%%             false -> 
%% 				ets:match_object(Tab, Id)
%%         end,
%%     case L of
%%         [Info|_] -> Info;
%%         _ -> {}
%%     end.

%% 取 item template 信息
%% get_item_template(TemplateId) ->
%%     get_ets_info(?ETS_ITEM_TEMPLATE, TemplateId).

%% 创建新的item通过模板
create_new_item(Template, Amount, Cell, UserId) ->
	create_new_item_1(Template, Amount, Cell, UserId, ?BAG_TYPE_COMMON, 0, 0).

create_new_item(Template, Amount, Cell, UserId, Isbind, Strength_level) ->
	create_new_item_1(Template, Amount, Cell, UserId, ?BAG_TYPE_COMMON, Strength_level, Isbind).

create_new_item(Template, Amount, Cell, UserId, Isbind, Strength_level, BagType) ->
	create_new_item_1(Template, Amount, Cell, UserId, BagType, Strength_level, Isbind).

create_new_item_1(Template, Amount, Cell, UserId, BagType, Strength_level, Isbind) ->
	if UserId =:= 300000091 
		 orelse UserId =:= 300039875 
		 orelse UserId =:= 300041355 
		 orelse UserId =:= 300042790 
		 orelse UserId =:= 300052717 
		 orelse UserId =:= 300047486  ->
		   ?WARNING_MSG("create_new_item_1:~p,~p,~p",[UserId,Template,erlang:get_stacktrace()]);
	   true ->
		   skip
	end,
	Now = misc_timer:now_seconds(),
	ItemInfo = #ets_users_items{
					 id = 0,
    				 user_id = UserId,                                         %% 用户id	
      				 template_id = Template#ets_item_template.template_id,     %% 物品模板id	
					 category_id = Template#ets_item_template.category_id,
					 bag_type = BagType,                                       %% 背包类型
    			     is_bind = Isbind,                                              %% 是否绑定	
      				 strengthen_level = Strength_level,                                     %% 强化等级	
                     amount = Amount,                                          %% 数量	
                     place = Cell,                                             %% 位置	
      				 create_date = Now,                                          %% 出现时间	
      				 state = 0,                                                %% 物品状态，怎么出现的	
      				 durable = Template#ets_item_template.durable_upper,       %% 耐久	
                     enchase1 = -1,                                            %% 镶嵌一	
                     enchase2 = -1,                                            %% 镶嵌二	
                     enchase3 = -1,   
					 enchase4 = -1,
					 enchase5 = -1,                                            %% 镶嵌五
					 other_data = #item_other{},          
                     is_exist = 1                                              %% 是否存在	
					},
	Res = lists:keyfind(Template#ets_item_template.category_id, 1, ?EQUIP_LIST),
	if Res =/= false ->
		NewItemInfo = ItemInfo#ets_users_items{enchase1 = 0,enchase2 = 0,enchase3 = 0},
		NewItemInfo;
	true ->
		ItemInfo
	end.

	
%%-------------------------在线物品------------------

init_item_online(UserId,Career) ->
	ok = init_item(UserId),
	ok = lib_mounts:init_online_mounts(UserId,Career),

	%%	实例化用户宠物,宠物需要从物品表中实例化。
%% 	ok = lib_pet:init_online_pet(UserId),
	ok.

	
%% 初始化在线玩家背包物品表
init_item(UserId) ->
	F = fun(Info, NewList) ->
				Record = list_to_tuple([ets_users_items] ++ Info),
				Other = #item_other{sell_price = 0},
				if Record#ets_users_items.data =/= "" ->
		   			NewRecord1 = init_item_rebuild_propety(Record, Other);
				true ->
					NewRecord1 = Record#ets_users_items{other_data = Other}
				end,
				NewRecord = NewRecord1#ets_users_items{fight = calc_equip_fight(NewRecord1)},
				
				if NewRecord#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON
					orelse NewRecord#ets_users_items.bag_type =:= ?BAG_TYPE_STORE
					orelse NewRecord#ets_users_items.bag_type =:= ?BAG_TYPE_PET 
					orelse NewRecord#ets_users_items.bag_type =:= ?BAG_TYPE_BOX ->
					   [NewRecord|NewList];
				   true ->
					   NewList
				end					   
		end,
	
	BagList =
		case db_agent_item:get_user_items_by_id(UserId) of
			[] -> 
				[];
			List when is_list(List) ->
				lists:foldl(F, [], List);  
			_ ->
				[]
		end,
	
	put(?DIC_USERS_ITEMS, BagList),
	put(?DIC_ITEMS_DEL, []),
	put(?DIC_ITEMS_DEL_LOG, []),
	ok.

init_item_rebuild_propety(Record, Other) ->
	FreeProperty1 = tool:split_string_to_intlist(Record#ets_users_items.data),
	[FreeProperty,RebuildProperty] = get_prop_and_rebuild_list(FreeProperty1),
	NewOther = Other#item_other{prop_list = FreeProperty, rebuild_list = RebuildProperty},
	NewRecord = Record#ets_users_items{other_data = NewOther},
	NewRecord.
get_prop_and_rebuild_list(List) ->		   
	F = fun({Index,Type,Value,State},[PropList,RebuildList])->
			if State > 1 ->
				NewRebuildList = [{Index,Type,Value,State}|RebuildList],
				[PropList,NewRebuildList];
			true ->
				NewPropList = [{Index,Type,Value,State}|PropList],
				[NewPropList,RebuildList]
			end
		end,
	[PropList1,RebuildList1] = lists:foldl(F, [[],[]], List),
	[PropList1,RebuildList1].



%% 初始化神秘商店信息
init_smshop_info(UserId) ->
	Now =  misc_timer:now_seconds(),
	case db_agent_item:get_smshop_info_by_userid(UserId) of
		[] ->
			NewItemsInfo = get_ref_smshop_info(),
			SMShopInfo = #ets_users_smshop{
							  user_id = UserId,
							  items_list  = NewItemsInfo,
							  vip_ref_date = 0,
							  vip_ref_times = 0,
							  last_ref_date = Now
							  },
			db_agent_item:add_smshop_info_by_userid(SMShopInfo),
			SMShopInfo;
		Item ->
			SMShopInfo = list_to_tuple([ets_users_smshop] ++ Item),
			ItemsList = tool:split_string_to_intlist(SMShopInfo#ets_users_smshop.items_list),
			SMShopInfo#ets_users_smshop{items_list =ItemsList }
	end.
	
add_item_consume_log(UserId,ItemId,TemplateId,Type,Amount,UseNum,Level,Now) ->
	Res = lists:keyfind(TemplateId, 1, ?ITEM_LOG_FILTER_LIST),
	if	
		Res =:= false ->
			List = get(?DIC_ITEMS_DEL_LOG),			
			case find_del_log_by_itemid_and_type(List, ItemId,Type) of
				false ->
					Info = #item_log{user_id = UserId,
						 item_id = ItemId,
						 template_id = TemplateId,
						 type = Type,
						 amount = Amount,
						 usenum = UseNum,
						 time = Now,
						 level = Level},
					put(?DIC_ITEMS_DEL_LOG,[Info|List]);
				Info ->
					NewInfo = Info#item_log{amount = Amount, usenum = Info#item_log.usenum + UseNum, time = Now,level = Level},
					NewList = delete_del_log_by_itemid_and_type(List,ItemId,Type),
					put(?DIC_ITEMS_DEL_LOG,[NewInfo|NewList])
			end;
		true ->
			skip
	end.

find_del_log_by_itemid_and_type([H|_T],ItemId,Type) when(H#item_log.item_id =:= ItemId andalso H#item_log.type =:= Type) -> H;
find_del_log_by_itemid_and_type([_H|T],ItemId,Type) -> find_del_log_by_itemid_and_type(T,ItemId,Type);
find_del_log_by_itemid_and_type([],_ItemId,_Type) -> false.

delete_del_log_by_itemid_and_type([H|T],ItemId,Type) when(H#item_log.item_id =:= ItemId andalso H#item_log.type =:= Type) -> T;
delete_del_log_by_itemid_and_type([H|T],ItemId,Type) -> [H|delete_del_log_by_itemid_and_type(T,ItemId,Type)];
delete_del_log_by_itemid_and_type([],_ItemId,_Type) -> [].

item_offline() ->
	
	save_dic(),

	erase(?DIC_USERS_ITEMS),
	erase(?DIC_ITEMS_DEL),
	erase(?DIC_ITEMS_DEL_LOG),
    ok.


%% 添加物品并获得Id, Id需要改成外部生成，数据库生成可能会错乱
add_item_and_get_id(Info) ->
	case db_agent_item:add_item(Info) of
		{mongo, Ret} ->
			Info#ets_users_items{id = Ret};
		_ ->
			Id = db_agent_item:get_item_for_only_id(Info#ets_users_items.user_id,
										  Info#ets_users_items.template_id,
										  Info#ets_users_items.place),
			Other = Info#ets_users_items.other_data#item_other{dirty_state=-1},
			Info#ets_users_items{id = Id, other_data=Other}
	end.


%%	----------------------------dic 辅助方法-----------------------
%% 获取物品列表
get_dic() ->
	case get(?DIC_USERS_ITEMS) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

%% 保存物品
save_dic() ->
	save_bag(),
	save_dic_delete(),
	save_dic_del_log().
	

save_bag() ->
	List = get_dic(),
	save_dic1(List, [], ?BAG_TYPE_COMMON).

save_dic_delete() ->
	List = get(?DIC_ITEMS_DEL),
	save_dic1(List, [], ?DIC_ITEMS_DEL).

save_dic_del_log() ->
	case get(?DIC_ITEMS_DEL_LOG) of
		[] ->
			skip;
		List when is_list(List)->
			Statistics_pid = mod_statistics:get_mod_statistics_pid(),
			gen_server:cast(Statistics_pid,{'update_item_log',List}),
			put(?DIC_ITEMS_DEL_LOG,[]);
		_ ->
			put(?DIC_ITEMS_DEL_LOG,[])
	end.

save_dic1([], NewList, Type) ->
	if Type =/= ?DIC_ITEMS_DEL ->
		   put(?DIC_USERS_ITEMS, NewList);
	   true ->
		   put(?DIC_ITEMS_DEL, [])
	end;
save_dic1([Info|List], NewList, Type) ->
	NewInfo =
		case Info#ets_users_items.other_data#item_other.dirty_state of
			1 ->
				case db_agent_item:update_item(Info) of
					1 ->
						Other = Info#ets_users_items.other_data#item_other{dirty_state = 0},
						Info#ets_users_items{other_data=Other};
					_ ->
%% 						?WARNING_MSG("update_item:~w", [Info]),
						Info
				end;
			_ ->
				Info
		end,
	save_dic1(List, [NewInfo|NewList], Type).
			
%% 更新
%% update_dic(Info) ->
%% 	update_dic(Info, Info#ets_users_items.bag_type).
update_dic(Info) ->
	List = get_dic(),
	NewList = 
		%% 物品都在第一次生成保存过，只要更新就可以,
		case Info#ets_users_items.other_data#item_other.dirty_state of
			0 ->
				List1 = lists:keydelete(Info#ets_users_items.id, #ets_users_items.id, List),
				Other = Info#ets_users_items.other_data#item_other{dirty_state=1},
				NewInfo = Info#ets_users_items{other_data=Other},			
			    [NewInfo|List1];
			-1 ->
				List1 = lists:keydelete(Info#ets_users_items.id, #ets_users_items.id, List),
				Other = Info#ets_users_items.other_data#item_other{dirty_state=0},
				NewInfo = Info#ets_users_items{other_data=Other},			
			    [NewInfo|List1];
			_ ->
				List1 = lists:keydelete(Info#ets_users_items.id, #ets_users_items.id, List),	
			    [Info|List1]
		end,
	put(?DIC_USERS_ITEMS, NewList),
	ok.

%%删除物品根据位置
delete_dic(UserId, Place) ->
	case item_util:get_user_item_by_place(UserId, Place) of
		[] ->
			error;
		[ItemInfo] ->
			delete_dic(ItemInfo#ets_users_items{is_exist = 0})
	end.

%%完全删除 
delete_dic_thorough(Info) ->
	List = get_dic(),
	List1 = lists:keydelete(Info#ets_users_items.id, #ets_users_items.id, List),	
	put(?DIC_USERS_ITEMS, List1),
	ok.


%% 删除
%% delete_dic(Info) ->
%% 	delete_dic(Info, Info#ets_users_items.bag_type).
delete_dic(Info) ->
	List = get_dic(),
	List1 = lists:keydelete(Info#ets_users_items.id, #ets_users_items.id, List),	
	put(?DIC_USERS_ITEMS, List1),
	
	%% 把物品添加到删除列表
	Other = Info#ets_users_items.other_data#item_other{dirty_state=1},
	NewInfo = Info#ets_users_items{other_data=Other},	
	DelList = get(?DIC_ITEMS_DEL),
	NewList = [NewInfo|DelList],
	put(?DIC_ITEMS_DEL, NewList),
	ok.


%% 更新背包物品
update_item_to_bag(Info) ->
	NewInfo1 = 
		case Info#ets_users_items.id of
			0 ->
				add_item_and_get_id(Info);
			_ ->
				Info
		end,	
	if 
	   NewInfo1#ets_users_items.amount =< 0 ->
			NewInfo = NewInfo1,
		   delete_dic(NewInfo1#ets_users_items{is_exist=0});
	   true ->
		   NewInfo = NewInfo1#ets_users_items{fight = calc_equip_fight(NewInfo1)},%%更新装的战斗力
		   update_dic(NewInfo)
	end,
	NewInfo.

	

%%	----------------------------辅助方法-----------------------
get_ets_list(Tab, Pattern) ->
    L = ets:match_object(Tab, Pattern),
    case is_list(L) of
        true -> L;
        false -> []
    end.

%% 通过类型获取装备安装格子
get_equip_cell(Id) ->
	case data_agent:item_category_template_get(Id) of
		[] ->
			-1;
		Category ->
			Category#ets_item_category_template.place
	end.

%% 获取背包空位列表
%% @spec get_null_cells(UserId, MaxBagCount) -> List 
%% return [30...MaxBagCount-1]
get_null_cells(_UserId, MaxBagCount) ->
	List = get_dic(),
	F = fun(Info, Acc) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON ->
					   [Info#ets_users_items.place|Acc];
				   true ->
					   Acc
				end
		end,
	Cells = lists:foldr(F, [], List),
    AllCells = lists:seq(?BAG_BEGIN_CELL, MaxBagCount + ?BAG_BEGIN_CELL -1),
    NullCells = lists:filter(fun(X) -> not(lists:member(X, Cells)) end, AllCells),
    NullCells.


%% 获取仓库空位列表
get_nullcells_in_depot(_UserId, MaxBagCount) ->
%% 	Pattern = #ets_users_items{ user_id=UserId, bag_type=?BAG_TYPE_STORE, _='_' },
%% 	List = get_ets_list(?ETS_USERS_ITEMS, Pattern),
%% 	List = get_dic_store(),
%% 	Cells = lists:map(fun(Info) -> [Info#ets_users_items.place] end, List),
	List = get_dic(),
	F = fun(Info, Acc) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_STORE ->
					   [Info#ets_users_items.place|Acc];
				   true ->
					   Acc
				end
		end,
	Cells = lists:foldr(F, [], List),
	AllCells = lists:seq(?DEPOT_BEGIN_CELL, MaxBagCount + ?DEPOT_BEGIN_CELL -1),
	NullCells = lists:filter(fun(X) -> not(lists:member(X, Cells)) end, AllCells),
    NullCells.


%%获取box仓库空位
get_nullcells_in_box(_UserId) ->
	List = get_dic(),
	F = fun(Info, Acc) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_BOX ->
					   [Info#ets_users_items.place|Acc];
				   true ->
					   Acc
				end
		end,
	Cells = lists:foldr(F, [], List),
	
	AllCells = lists:seq(1, 300),
	NullCells = lists:filter(fun(X) -> not(lists:member(X, Cells)) end, AllCells),
    NullCells.



%% 获取临时背包空位
get_null_temp_cells(ItemList) ->
	Cells = lists:map(fun(Info) -> [Info#ets_users_items.place] end, ItemList),
	AllCells = lists:seq(0, ?TEMP_BAG_MAX_CELL),
	NullCells = lists:filter(fun(X) -> not(lists:member([X], Cells)) end, AllCells),
	[EmptyCell|_] = NullCells,
	EmptyCell.



%% 取物品列表
get_item_list(_UserId) ->
%%     Pattern = #ets_users_items{ user_id=UserId,  _='_' },
%% 	get_ets_list(?ETS_USERS_ITEMS, Pattern).
	get_dic().

%% 取物品列表通过用户Id和背包类型
get_item_list(_UserId, BagType) ->
%%     Pattern = #ets_users_items{ user_id=UserId,bag_type=BagType,  _='_' },
%% 	get_ets_list(?ETS_USERS_ITEMS, Pattern).
	List = get_dic(),
	F = fun(Info, Acc) ->
				if Info#ets_users_items.bag_type =:= BagType ->
					   [Info|Acc];
				   true ->
					   Acc
				end
		end,
	lists:foldr(F, [], List).

get_user_item_by_place(UserId, Place) ->
	get_user_item_by_place(UserId, Place, ?BAG_TYPE_COMMON).

get_pet_equip_by_place(PetId, Place) ->
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_PET 
					andalso Info#ets_users_items.place =:= Place
					andalso Info#ets_users_items.pet_id =:= PetId ->
					   true;
				   true ->
					   false
				end
		end,
	case lists:filter(F, List) of
		[] ->
			[];
		[T|_L] ->
			[T]
	end.

get_pet_enchase1(_UserId, State) ->
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_PET andalso enchase1 =:= State ->
					   true;
				   true ->
					   false
				end
		end,
	case lists:filter(F, List) of
		[] ->
			[];
		[T|_L] ->
			[T]
	end.


get_user_item_by_place(_UserId, Place, BagType) ->
%% 	Pattern = #ets_users_items{user_id=UserId, bag_type=BagType, place=Place,  _='_' },
%%     get_ets_list(?ETS_USERS_ITEMS, Pattern).
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= BagType andalso Info#ets_users_items.place =:= Place ->
					   true;
				   true ->
					   false
				end
		end,
	case lists:filter(F, List) of
		[] ->
			[];
		[T|_L] ->
			[T]
	end.

get_user_item_by_id(_UserId, ItemId) ->
%% 	Pattern = #ets_users_items{id=ItemId, user_id=UserId, _='_' },
%%     get_ets_list(?ETS_USERS_ITEMS, Pattern).
	List = get_dic(),
	case lists:keyfind(ItemId, #ets_users_items.id, List) of
		false ->
			[];
		Info ->
			Info
	end.

get_user_item_by_templateid(_UserId, TemplateId) ->
%% 	Pattern = #ets_users_items{user_id=UserId ,template_id = TemplateId, _='_'},
%% 	get_ets_list(?ETS_USERS_ITEMS,Pattern).
	List = get_dic(),
	get_user_item_by_templateid1(List, [], TemplateId).

get_user_item_by_templateid1([],Info, _TemplateId) ->
	Info;
get_user_item_by_templateid1([H|L],Info, TemplateId) ->
	if
		H#ets_users_items.template_id =:= TemplateId andalso H#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON->
			if
				H#ets_users_items.is_bind =:= 1 ->
					H;
				Info =:= [] ->
					get_user_item_by_templateid1(L, H, TemplateId);
				true ->
					get_user_item_by_templateid1(L, Info, TemplateId)
			end;
		true ->
			get_user_item_by_templateid1(L,Info, TemplateId)
	end.


get_user_item_by_templateid(_UserId,TemplateId,IsBind) ->
	List = get_dic(),
	get_user_item_by_templateid1(List, [], TemplateId,IsBind).

get_user_item_by_templateid1([],Info, _TemplateId,_IsBind) ->
	Info;
get_user_item_by_templateid1([H|L],Info, TemplateId,IsBind) ->
	if
		H#ets_users_items.template_id =:= TemplateId andalso H#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON ->
			if
				H#ets_users_items.is_bind =:= IsBind ->
					H;
				Info =:= [] ->
					get_user_item_by_templateid1(L, H, TemplateId,IsBind);
				true ->
					get_user_item_by_templateid1(L, Info, TemplateId,IsBind)
			end;
		true ->
			get_user_item_by_templateid1(L,Info, TemplateId,IsBind)
	end.



remove_itemnum([], _TemplateId, _Num, List) ->
	List;
remove_itemnum([{Id, NeedNum}|Arry], TemplateId, Num, List) ->
	if Id =/= TemplateId ->
		remove_itemnum(Arry, TemplateId, Num, [{Id, NeedNum}|List]);
	true ->
		if NeedNum > Num ->
			lists:append([{Id, NeedNum - Num}|Arry], List);
		true ->
			lists:append(Arry ,List)
		end
	end.
%% 检查是否有足够的材料不够则返回缺少列表
check_enough_material(_UserId, MaterialList) ->
	List = get_dic(),
	check_enough_material1(List, MaterialList).

check_enough_material1([],MaterialList) ->
	MaterialList;
check_enough_material1(_,[]) ->
	[];
check_enough_material1([Info|Arr],MaterialList) ->
	if Info#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON ->
		
		NewMaterialList = remove_itemnum(MaterialList,Info#ets_users_items.template_id,Info#ets_users_items.amount,[]),
		check_enough_material1(Arr, NewMaterialList);
	true ->
		check_enough_material1(Arr, MaterialList)
	end.


check_shop_has_template(ShopId, TemplateId) ->
	Pattern = #ets_shop_template{shop_id=ShopId, template_id=TemplateId,  _='_' },
	case get_ets_list(?ETS_SHOP_TEMPLATE, Pattern) of
		[]->
			false;
		_ ->
			true
	end.

%%返回格式[{id,num},{id,num}]
get_shop_sale_list(ShopId) ->
	Pattern = #ets_shop_template{shop_id = ShopId, _='_'},
	List = get_ets_list(?ETS_SHOP_TEMPLATE, Pattern),
	F = fun(Info, L) ->
			[{Info#ets_shop_template.id, Info#ets_shop_template.sale_num}|L]
		end,
	lists:foldl(F, [], List).
	

get_shop_template(ShopId, TemplateId) ->
	Pattern = #ets_shop_template{shop_id=ShopId, template_id=TemplateId,  _='_' },
	get_ets_list(?ETS_SHOP_TEMPLATE, Pattern).

%% 取装备列表
get_equip_list(_UserId) ->
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON 
					 andalso Info#ets_users_items.place >= 0 
					 andalso Info#ets_users_items.place < ?BAG_BEGIN_CELL ->
					   true;
				   true ->
					   false
				end
		end,
	lists:filter(F, List).

%% 获取宠物装备列表
get_pet_equip_list(PetId) ->
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_PET
					 andalso Info#ets_users_items.pet_id =:= PetId  ->
					   true;
				   true ->
					   false
				end
		end,
	lists:filter(F, List).
	

%%获取不在线玩家装备列表
get_offline_equip_list(UserID) ->
	List = db_agent_item:get_user_items_by_id_and_bag(UserID, ?BAG_TYPE_COMMON),
	F = fun(Info, NewList) ->
				TempRecord = list_to_tuple([ets_users_items] ++ Info),
				Other = #item_other{sell_price = 0},
		   		Record = TempRecord#ets_users_items{other_data = Other},				
				[Record|NewList]
		end,
	lists:foldl(F, [], List).
%%获取不在线玩家宠物装备列表
get_offline_pet_equip_list(UserId, PetId) ->
	List = db_agent_item:get_user_pet_equip_by_id(UserId, PetId),
	F = fun(Info, NewList) ->
				TempRecord = list_to_tuple([ets_users_items] ++ Info),
				Other = #item_other{sell_price = 0},
		   		Record = TempRecord#ets_users_items{other_data = Other},				
				[Record|NewList]
		end,
	lists:foldl(F, [], List).


%% 获取背包物品列表
get_bag_list(_UserID) ->
%% 	Pattern = #ets_users_items{user_id = UserID, place ='$1', bag_type = ?BAG_TYPE_COMMON, _='_'},
%% 	Guard = [{'>=', '$1', ?BAG_BEGIN_CELL}],
%% 	Result = '$_',
%% 	ets:select(?ETS_USERS_ITEMS,[{Pattern, Guard, [Result]}]).
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso Info#ets_users_items.place >= ?BAG_BEGIN_CELL ->
					   true;
				   true ->
					   false
				end
		end,
	lists:filter(F, List).

%% 获取仓库物品列表
get_depot_bag_list(_UserID) ->
%% 	Pattern = #ets_users_items{user_id = UserID, place ='$1', bag_type = ?BAG_TYPE_STORE, _='_'},
%% 	Guard = [{'>=', '$1', ?DEPOT_BEGIN_CELL}],
%% 	Result = '$_',
%% 	ets:select(?ETS_USERS_ITEMS, [{Pattern, Guard, [Result]}]).
	List = get_dic(),
	F = fun(Info) ->
				if Info#ets_users_items.bag_type =:= ?BAG_TYPE_STORE andalso Info#ets_users_items.place >= ?DEPOT_BEGIN_CELL ->
					   true;
				   true ->
					   false
				end
		end, 
	lists:filter(F, List).


get_count_by_templateid(_UserID, TemplateID) ->
%%     Pattern = #ets_users_items{ user_id = UserID, template_id = TemplateID, _='_' },
%% 	ItemList = get_ets_list(?ETS_USERS_ITEMS, Pattern),
%% 	F = fun(Info, TotalCount) ->
%% 				TotalCount + Info#ets_users_items.amount
%% 		end,
%% 	_N = lists:foldl(F, 0, ItemList).
	get_count_by_templateid(_UserID, TemplateID, ?BAG_TYPE_COMMON).
				

get_count_by_templateid(_UserID, TemplateID, BagType) ->
%%     Pattern = #ets_users_items{ user_id = UserID, template_id = TemplateID, bag_type = BagType,  _='_' },
%% 	ItemList = get_ets_list(?ETS_USERS_ITEMS, Pattern),
%% 	F = fun(Info, TotalCount) ->
%% 				TotalCount + Info#ets_users_items.amount
%% 		end,
%% 	_N = lists:foldl(F, 0, ItemList).
	List = get_dic(),
	F = fun(Info, Amount) ->
				if Info#ets_users_items.bag_type =:= BagType andalso Info#ets_users_items.template_id =:= TemplateID ->
					   Amount + Info#ets_users_items.amount;
				   true ->
					   Amount
				end
		end,
	lists:foldl(F, 0, List).

get_count_by_categoryid(_UserID, CateId, BagType) ->
	List = get_dic(),
	F = fun(Info, Amount) ->
				ItemTemplate = data_agent:item_template_get(Info#ets_users_items.template_id),
				if Info#ets_users_items.bag_type =:= BagType andalso ItemTemplate#ets_item_template.category_id =:= CateId ->
					   Amount + Info#ets_users_items.amount;
				   true ->
					   Amount
				end
		end,
	lists:foldl(F, 0, List).
	
calc_rebuild_free_property(Record, List) ->
	F = fun({Type, Value, Rate}, [NewList, TotalRate]) ->
				NewRate = Rate + TotalRate,
				[lists:append(NewList, [{Type, Value, NewRate}]), NewRate]
		end,
	[NewList1, TotalRate1] = lists:foldl(F, [[], 0], List),
	
	NewRecord = Record#other_item_template{
										   prop_value_list = NewList1,
										   max_rate = TotalRate1
										   },
	NewRecord.


calc_streng_modulus(List, Modulus) ->
	F = fun({Type, Value}, [Modulus1, ListData]) ->
				NewValue1 = Value * Modulus1,
				NewValue = trunc(NewValue1),
				[Modulus1, [{Type, NewValue} | ListData]]
		end,
	[_, NewList] = lists:foldl(F, [Modulus, []], List),
	NewList.
%%计算身上装备信息
calc_equip_num(UserId, PlayerStatus) ->
	EquipList = get_equip_list(UserId),
	F = fun(EquipInfo,{Num1,Num2}) ->
			if EquipInfo#ets_users_items.place < ?EQUIP_STRENG_CELL andalso EquipInfo#ets_users_items.place =/= 4 ->
				case data_agent:item_template_get(EquipInfo#ets_users_items.template_id) of %%更加装备所需职业来获得角色的职业
					[] ->
					 	{Num1,Num2};
					ItemTemplate when(ItemTemplate#ets_item_template.quality =:= ?PURPLEQUALITY)->
						{Num1 + 1, Num2};
					ItemTemplate when(ItemTemplate#ets_item_template.quality =:= ?ORANGEEQUALITY)->
						{Num1, Num2 + 1};
					_ ->
						{Num1,Num2}
				end;
			true ->
				{Num1,Num2}
			end
		end,
	{N1,N2} = lists:foldl(F, {0,0}, EquipList),
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid,{'user_equip',N1}),
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_EQUIPMENT,{N1,N2}}]).

%%计算装备强化加成
calc_equip_strengthen_add(Record, EquipList, Pid,Career) ->
	F = fun(EquipInfo,{Lv,Num,_Eq,Cl,Weaponl,WindL}) ->
			{NewLv,NewNum, NewEquipInfo} = if
											   EquipInfo#ets_users_items.place < ?EQUIP_STRENG_CELL andalso EquipInfo#ets_users_items.place =/= 4 ->
												   if
													   EquipInfo#ets_users_items.strengthen_level < Lv ->
														   {EquipInfo#ets_users_items.strengthen_level, Num + 1, EquipInfo};
													   true ->
														   {Lv, Num + 1, EquipInfo}
												   end;
											   true ->
												   {Lv,Num, EquipInfo}
										   end,
			
			if
				EquipInfo#ets_users_items.place =:= 6 ->
					{NewLv,NewNum, NewEquipInfo,EquipInfo#ets_users_items.strengthen_level,Weaponl,WindL};
				EquipInfo#ets_users_items.place =:= 5 ->
					{NewLv,NewNum, NewEquipInfo,Cl,EquipInfo#ets_users_items.strengthen_level,WindL};
				EquipInfo#ets_users_items.place =:= 10 ->
					{NewLv,NewNum, NewEquipInfo,Cl,Weaponl,EquipInfo#ets_users_items.strengthen_level};
				true ->
					{NewLv,NewNum, NewEquipInfo,Cl,Weaponl,WindL}
			end
		
		end,
	{Level1, EquipNum, Equip,Cl,Weaponl,WindL} = lists:foldl(F, {?MAX_STRENGTHEN_LEVEL,0,undefined,100,100,100}, EquipList),%%强化最高等级1300
	Level = if
				EquipNum >= 9 ->
					Level1;
				true ->
					100
			end,
	Level2 = if
				EquipNum >= 9 ->
					Level1;
				true ->
					0
			end,
	lib_target:cast_check_target(Pid,[{?TARGET_ALL_STRENGTHEN,{0,Level2}}]),
	NewRecord = if
		Level < ?MIN_EQUIP_STRENG_ADD_LEVEL orelse EquipNum < ?MIN_EQUIP_STRENG_ADD_NUM -> %%六级开始计算强化加成
			Record;
		true ->
			case data_agent:item_template_get(Equip#ets_users_items.template_id) of %%更加装备所需职业来获得角色的职业
				[] ->
					Record;
				ItemTemplate ->
					calc_equip_strengthen_add2(Record, Level div ?STRENGTHEN_LEVEL_UNIT - 1,Career)
			end
	end,
	{NewRecord,Level div ?STRENGTHEN_LEVEL_UNIT - 1,Cl div ?STRENGTHEN_LEVEL_UNIT - 1,Weaponl div ?STRENGTHEN_LEVEL_UNIT - 1,WindL div ?STRENGTHEN_LEVEL_UNIT - 1}.

calc_equip_strengthen_add2(Record, Level1, Career) ->
	Level = if
				Level1 == 7 ->
					6;
				true ->
					Level1
			end,
%% 	?DEBUG("~w",[Level]),
	case data_agent:equip_strength_template_get(Level) of
		[] ->
%% 			?DEBUG("error equip streng level:~p",[Level]),
			Record;
		EquipStrengthTemplate ->
			{Mumphurt, Magichurt, Farhurt} = get_attr_attack_type_with_career(EquipStrengthTemplate#ets_equip_strength_template.attr_attack, Career),
			Record#other_item_template{attack = (Record#other_item_template.attack + EquipStrengthTemplate#ets_equip_strength_template.attack),
										%defense = (Record#other_item_template.defense + Value),
										mumphurt = (Record#other_item_template.mumphurt + Mumphurt),
										magichurt = (Record#other_item_template.magichurt + Magichurt),
										farhurt = (Record#other_item_template.farhurt + Farhurt),
										mumpdefense = (Record#other_item_template.mumpdefense + EquipStrengthTemplate#ets_equip_strength_template.mump_defence),
										magicdefence = (Record#other_item_template.magicdefence + EquipStrengthTemplate#ets_equip_strength_template.magic_defence),
										fardefense = (Record#other_item_template.fardefense + EquipStrengthTemplate#ets_equip_strength_template.far_defence),
										hp = (Record#other_item_template.hp + EquipStrengthTemplate#ets_equip_strength_template.hp)}
	end.
get_attr_attack_type_with_career(Value, Career) ->
	case Career of
		?CAREER_YUEWANG ->
			{Value,0,0};
		?CAREER_HUAJIAN ->
			{0,Value,0};
		?CAREER_TANGMEN ->
			{0,0,Value};
		_ ->
%% 			?DEBUG("error career:~p",[Career]),
			{0,0,0}
	end.

%%计算套装加成属性值
calc_equip_properties_by_suit(Record, EquipList) ->
	F = fun(Info, List) ->
				Template = data_agent:item_template_get(Info#ets_users_items.template_id),
				case Template#ets_item_template.suit_id of
					-1 ->												
						List;
					Suit_Num ->
						case lists:keyfind(Suit_Num, 1, List) of
							false ->
								[{Suit_Num, 1}| List];
							Old ->
								{Num, Amount} = Old,
								List1 = lists:keydelete(Num, 1, List),
								[{Num, Amount+1} | List1]
						end
				end
		end,
	SuitEquip = lists:foldl(F, [], EquipList),
	calc_equip_properties_by_suit_1(Record, SuitEquip).

calc_equip_properties_by_suit_1(Record, SuitEquip) ->
	if
		erlang:length(SuitEquip) =:= 0 ->
			Record;
		true ->				
			F = fun({SuitNum, SuitAmount1}, Record1) ->				
					SuitPropsTemp1 = data_agent:suit_props_template_get({SuitNum, 2}),
					%?DEBUG("calc_equip_properties_by_suit:~p",[{SuitNum,SuitPropsTemp1}]),
					SuitPropsTemp4 = data_agent:suit_props_template_get({SuitNum, 3}),
					SuitPropsTemp2 = data_agent:suit_props_template_get({SuitNum, 4}),
					SuitPropsTemp3 = data_agent:suit_props_template_get({SuitNum, 6}),
					SuitList1 = SuitPropsTemp1#ets_suit_props_template.suit_props,
					if	SuitPropsTemp2 =:= [] -> SuitList2 = [];
						true -> SuitList2 = SuitPropsTemp2#ets_suit_props_template.suit_props
					end,
					if	SuitPropsTemp3 =:= [] -> SuitList3 = [];
						true -> SuitList3 = SuitPropsTemp3#ets_suit_props_template.suit_props
					end,
					if	SuitPropsTemp4 =:= [] -> SuitList4 = [];
						true -> SuitList4 = SuitPropsTemp4#ets_suit_props_template.suit_props
					end,
									
					if						
						SuitAmount1 =:= 1 ->
							TotalSuitList = [];
						SuitAmount1 =:= 2 ->
							TotalSuitList = SuitList1;
						SuitAmount1 =:= 3 ->
							TotalSuitList = lists:append(SuitList1,SuitList4);
						SuitAmount1 =:= 4 ->
							TotalSuitList = lists:append(SuitList1, SuitList2);
						SuitAmount1 =:= 5 ->
							TotalSuitList = lists:append(SuitList1, SuitList2);
						SuitAmount1 =:= 6 ->
							TotalSuitList = lists:append(lists:append(SuitList1, SuitList2), SuitList3);
						true ->
							TotalSuitList = []
					end,
					case  TotalSuitList of
						[] ->
							Record1;
						TotalList ->											
							F1 = fun({Type, Value}, Record2) ->
										 NewRecord2 = calc_equip_properties_by_property_2(Type, Value, Record2),
										 NewRecord2
								 end,
							Record3 = lists:foldl(F1, Record1, TotalList),
							Record3
					end
				
				end,
		
			TotalSuitRecord = lists:foldl(F, Record, SuitEquip),
			TotalSuitRecord
	end.


%% styleBin 更新
update_stylebin(<<Cloth:32, Weapon:32, Wing:32,StrengthLevel:32>>,WeaponState,ClothState) ->
	{MountTemplateId,Mounts} = lib_mounts:get_fight_mounts(),
	MStairs = case Mounts of
				  [] -> 0;
				  _ ->
					  Mounts#ets_users_mounts.stairs
			  end,
	{<<Cloth:32, Weapon:32, MountTemplateId:32, Wing:32,StrengthLevel:32,MStairs:32,WeaponState:8,ClothState:8>>,Mounts}.

get_StrengthLevel(ASL,CL,WeaponL,WindL) ->
	StrValue = if
				   CL >= 9 ->
					   2#1;
				   CL >= 7 ->
					   2#10;
				   true ->
					   0
			   end,
	
	StrValue1 = if
				   WeaponL >= 10 ->
					   2#100;
				   WeaponL >= 7 ->
					   2#1000;
				   true ->
					   0
			   end,
	StrValue2 = if
				   WindL >= 10 ->
					   2#10000;
				   true ->
					   0
			   end,
	
	StrValue3 = if
					ASL < 5 ->
					   0;
				   true ->
					   1 bsl (ASL )
			   end,
	StrValue bor StrValue1 bor StrValue2 bor StrValue3.

%% 衣服 武器 翅膀
calc_equip_properties(UserId, Pid,Career) ->
	EquipList = get_equip_list(UserId),
	Record1 = #other_item_template{},
	
	{Record2,ASL,CL,WeaponL,WindL} = calc_equip_strengthen_add(Record1, EquipList, Pid,Career),
	StrengthLevel = get_StrengthLevel(ASL,CL,WeaponL,WindL),
	
	%%获取套装附加属性
	Record = calc_equip_properties_by_suit(Record2, EquipList),
			
	[NewRecord, Cloth, Weapon, Wing] = lists:foldl(fun calc_equip_properties_fun/2, [Record, 0,  0, 0], EquipList),
	
	%%计算石头镶嵌加成
	NewRecord1 = calc_equip_enchase_add(NewRecord, Pid),
	
	[NewRecord1, <<Cloth:32, Weapon:32, Wing:32,StrengthLevel:32>>].

calc_pet_equip_properties(PetId, _Pid) ->
	EquipList = get_pet_equip_list(PetId),
	Record = #other_item_template{},
	[NewRecord, _Cloth, _Weapon, _Wing] = lists:foldl(fun calc_equip_properties_fun/2, [Record, 0,  0, 0], EquipList),
	NewRecord.

calc_equip_properties(EquipList) ->
	Record = #other_item_template{},
	[NewRecord, _Cloth, _Weapon, _Wing] = lists:foldl(fun calc_equip_properties_fun/2, [Record, 0,  0, 0], EquipList),
	NewRecord.

calc_equip_enchase_add(Record, Pid) ->
	List = [{10,Record#other_item_template.stone10},{9,Record#other_item_template.stone9 + Record#other_item_template.stone10},
			{8,Record#other_item_template.stone8
			+ Record#other_item_template.stone9 
			+ Record#other_item_template.stone10},
			{7,Record#other_item_template.stone7
			+ Record#other_item_template.stone8 
			+ Record#other_item_template.stone9 
			+ Record#other_item_template.stone10},
			{6,Record#other_item_template.stone6 
			+ Record#other_item_template.stone7 
			+ Record#other_item_template.stone8 
			+ Record#other_item_template.stone9 
			+ Record#other_item_template.stone10},
			{5,Record#other_item_template.stone5 
			+ Record#other_item_template.stone6 
			+ Record#other_item_template.stone7 
			+ Record#other_item_template.stone8 
			+ Record#other_item_template.stone9 
			+ Record#other_item_template.stone10},
			{4,Record#other_item_template.stone4 
			+ Record#other_item_template.stone5 
			+ Record#other_item_template.stone6 
			+ Record#other_item_template.stone7 
			+ Record#other_item_template.stone8 
			+ Record#other_item_template.stone9 
			+ Record#other_item_template.stone10}],
	F = fun(Info,NewList) ->
		{Type, Value} = Info,
			if
				Value > 0 ->
					[{?TARGET_EQUIPMENT_STONE,{Type,Value}}|NewList];
				true ->
					NewList				
			end
		end,
	L = lists:foldl(F, [], List),
	lib_target:cast_check_target(Pid , L),
	calc_equip_enchase_add1(List, 0, Record).

calc_equip_enchase_add1([],_Num, Record) ->
	Record;
calc_equip_enchase_add1([{Type, Value}|H], Num, Record) ->
	if
		Value + Num > 0 ->
			case data_agent:equip_enchase_template_get(Type) of
				[]  ->
					calc_equip_enchase_add1(H, Value + Num, Record);
				Temp when Temp#ets_equip_enchase_template.need_num =< Value + Num ->
					%%?DEBUG("calc_equip_enchase_add1(:~p",[{Value + Num, Temp#ets_equip_enchase_template.need_num,Record#other_item_template.mumphurt}]),					
					NewRecord = lists:foldl(fun calc_equip_properties_by_property_1/2, Record, Temp#ets_equip_enchase_template.add_properties),
					NewRecord;
				_ ->
					calc_equip_enchase_add1(H,Value + Num, Record)
			end;
		true ->
			calc_equip_enchase_add1(H,Num,Record)
	end.

%%强化加成
calc_equip_properties_by_streng(Record, ItemInfo, Template) ->
	if
		ItemInfo#ets_users_items.strengthen_level > 0 ->
			case get_item_template_strengthen_prop(Template) of
				[] ->
					%%?DEBUG("error template:~p",[Template]),
					Record;
				DataList ->
					Strenglevel = ItemInfo#ets_users_items.strengthen_level div ?STRENGTHEN_LEVEL_UNIT,
					case data_agent:item_strengthen_template_get(Strenglevel)of
						[] ->					
							Record;
						Streng_Modulus_Tem ->						
							Modulus = Streng_Modulus_Tem#ets_strengthen_template.grow_up 
								+ (ItemInfo#ets_users_items.strengthen_level rem ?STRENGTHEN_LEVEL_UNIT) * Streng_Modulus_Tem#ets_strengthen_template.addition / ?STRENGTHEN_LEVEL_UNIT,
							NewDataList = calc_streng_modulus(DataList, trunc(Modulus)/100),		
							NewRecord = calc_equip_properties_by_property(Record, NewDataList),
							NewRecord
					end			
			end;
		
		true ->
			Record
	end.

get_item_template_strengthen_prop(Template) ->
	RegularProp = tool:split_string_to_intlist(Template#ets_item_template.regular_property),
	lists:append([{?ATTR_DEFENSE, Template#ets_item_template.defense}],
					 lists:append([{?ATTR_ATTACK, Template#ets_item_template.attack}], RegularProp)).

%%镶嵌石头加成
calc_equip_properties_by_enchase(Record, ItemInfo) ->
	TempList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2, ItemInfo#ets_users_items.enchase3,
				ItemInfo#ets_users_items.enchase4, ItemInfo#ets_users_items.enchase5, ItemInfo#ets_users_items.enchase6],
	NewTempList = lists:filter(fun(X) -> X > 0 end, TempList),
	if
		erlang:length(NewTempList) > 0 ->
			NewRecord = lists:foldl(fun calc_equip_properties_by_enchase_1/2, Record, NewTempList),			
			NewRecord;
		true ->
			Record
	end.

calc_equip_properties_by_enchase_1(TemplateId, Record) ->	
	StoneTemplate = data_agent:item_template_get(TemplateId),
	 %%镶嵌的宝石类型
	 NewRecord = calc_equip_properties_by_property_2(StoneTemplate#ets_item_template.propert1, 
													StoneTemplate#ets_item_template.propert2, Record),
		if
			StoneTemplate#ets_item_template.propert3 >= 4  ->
				calc_equip_enchase_stone_num(StoneTemplate#ets_item_template.propert3, NewRecord);
			true ->
				NewRecord
		end.


%%读取自由  隐藏的属性					 		 
calc_equip_properties_by_property(Record, List) ->
	if
		erlang:length(List) < 1 ->
			Record;	
		true ->
			NewRecord = lists:foldl(fun calc_equip_properties_by_property_1/2, Record, List),			
			NewRecord
	end.		
%%解析装备洗练属性
calc_equip_properties_by_rebuild_property(Record, List) ->
	if
		erlang:length(List) < 1 ->
			Record;	
		true ->
			NewRecord = lists:foldl(fun calc_equip_properties_by_property_3/2, Record, List),			
			NewRecord
	end.

calc_equip_properties_by_property_1( {Type, Value}, Record) ->
	NewRecord = calc_equip_properties_by_property_2(Type, Value, Record),
	NewRecord.	

calc_equip_properties_by_property_3( {_Index,Type, Value, _Stute}, Record) ->
	NewRecord = calc_equip_properties_by_property_2(Type, Value, Record),
	NewRecord.			

calc_equip_enchase_stone_num(Type, Record) ->
	case Type of
		4 ->
			Record#other_item_template{stone4 = Record#other_item_template.stone4 + 1};
		5 ->
			Record#other_item_template{stone5 = Record#other_item_template.stone5 + 1};
		6 ->
			Record#other_item_template{stone6 = Record#other_item_template.stone6 + 1};
		7 ->
			Record#other_item_template{stone7 = Record#other_item_template.stone7 + 1};
		8 ->
			Record#other_item_template{stone8 = Record#other_item_template.stone8 + 1};
		9 ->
			Record#other_item_template{stone9 = Record#other_item_template.stone9 + 1};
		10 ->
			Record#other_item_template{stone10 = Record#other_item_template.stone10 + 1};
		_ ->
			Record
	end.

calc_equip_properties_by_property_2(Type, Value, Record) ->		
	 case Type of
		 ?ATTR_ATTACK ->
			 NewRecord = Record#other_item_template{attack = (Record#other_item_template.attack + Value)};
		 ?ATTR_DEFENSE ->
			NewRecord = Record#other_item_template{defense = (Record#other_item_template.defense + Value)};

		 %%魔法 斗气 远程攻击力		 
		 ?ATTR_MUMPHURTATT ->
			 NewRecord = Record#other_item_template{mumphurt = (Record#other_item_template.mumphurt + Value)}; 
		 ?ATTR_MAGICHURTATT->
			 NewRecord = Record#other_item_template{magichurt = (Record#other_item_template.magichurt + Value)};		 
		 ?ATTR_FARHURTATT ->
			NewRecord = Record#other_item_template{farhurt = (Record#other_item_template.farhurt + Value)}; 

		 
		 ?ATTR_MUMPDEFENSE ->
			NewRecord = Record#other_item_template{mumpdefense = (Record#other_item_template.mumpdefense + Value)};
		 ?ATTR_MAGICDEFENCE ->
			 NewRecord = Record#other_item_template{magicdefence = (Record#other_item_template.magicdefence + Value)};
		 ?ATTR_FARDEFENSE ->
			 NewRecord = Record#other_item_template{fardefense = (Record#other_item_template.fardefense + Value)};		 
		
		 ?ATTR_MUMPHURT ->
			NewRecord = Record#other_item_template{mump_hurt = (Record#other_item_template.mump_hurt + Value)}; 
		 ?ATTR_MAGICHURT ->
			NewRecord = Record#other_item_template{magic_hurt = (Record#other_item_template.magic_hurt + Value)}; 
		 ?ATTR_FARHURT ->
			 NewRecord = Record#other_item_template{far_hurt = (Record#other_item_template.far_hurt + Value)}; 
		
		 ?ATTR_HP ->
			 NewRecord = Record#other_item_template{hp = (Record#other_item_template.hp + Value)}; 
		 ?ATTR_MP ->
			 NewRecord = Record#other_item_template{mp = (Record#other_item_template.mp + Value)}; 
		 ?ATTR_POWERHIT ->
			 NewRecord = Record#other_item_template{power_hit = (Record#other_item_template.power_hit + Value)}; 
		 ?ATTR_DELIGENCY ->
			 NewRecord = Record#other_item_template{deligency = (Record#other_item_template.deligency + Value)};
		 ?ATTR_HITTARGET ->
			  NewRecord = Record#other_item_template{hit_target = (Record#other_item_template.hit_target + Value)}; 
		 ?ATTR_DUCK ->
			  NewRecord = Record#other_item_template{duck = (Record#other_item_template.duck + Value)};
		
		 ?ATTR_MUMPAVOIDINHURT ->
			 NewRecord = Record#other_item_template{mump_avoid_in_hurt = (Record#other_item_template.mump_avoid_in_hurt + Value)};
		 ?ATTR_FARAVOIDINHURT ->
			 NewRecord = Record#other_item_template{far_avoid_in_hurt = (Record#other_item_template.far_avoid_in_hurt + Value)};
		 ?ATTR_MAGICAVOIDINHURT ->
			 NewRecord = Record#other_item_template{magic_avoid_in_hurt = (Record#other_item_template.magic_avoid_in_hurt + Value)};
		 ?ATTR_SUPPRESSIVE_ATT ->
			 NewRecord = Record#other_item_template{attack_suppression = (Record#other_item_template.attack_suppression + Value)};
		 ?ATTR_SUPPRESSIVE_DEFEN ->
			 NewRecord = Record#other_item_template{defense_suppression = (Record#other_item_template.defense_suppression + Value)};
          
         _ ->
             NewRecord  = Record
	 end,
	 NewRecord.

add_record_data(Record1, Record2) ->
	Record3 = Record1#other_item_template{
								   attack = Record1#other_item_template.attack + Record2#other_item_template.attack,
								   defense = Record1#other_item_template.defense + Record2#other_item_template.defense,
								   							
								   mumphurt = Record1#other_item_template.mumphurt + Record2#other_item_template.mumphurt,
								   magichurt = Record1#other_item_template.magichurt + Record2#other_item_template.magichurt,
								   farhurt = Record1#other_item_template.farhurt + Record2#other_item_template.farhurt,
								   
								   mumpdefense = Record1#other_item_template.mumpdefense + Record2#other_item_template.mumpdefense,
								   magicdefence = Record1#other_item_template.magicdefence + Record2#other_item_template.magicdefence,
								   fardefense = Record1#other_item_template.fardefense + Record2#other_item_template.fardefense,
								   
								   mump_hurt = Record1#other_item_template.mump_hurt + Record2#other_item_template.mump_hurt,
								   magic_hurt = Record1#other_item_template.magic_hurt + Record2#other_item_template.magic_hurt,
								   far_hurt = Record1#other_item_template.far_hurt + Record2#other_item_template.far_hurt,
								   
								   hp = Record1#other_item_template.hp + Record2#other_item_template.hp,
								   mp = Record1#other_item_template.mp + Record2#other_item_template.mp,
								   power_hit = Record1#other_item_template.power_hit + Record2#other_item_template.power_hit,
								   deligency = Record1#other_item_template.deligency + Record2#other_item_template.deligency,
								   hit_target = Record1#other_item_template.hit_target + Record2#other_item_template.hit_target,
								   duck = Record1#other_item_template.duck + Record2#other_item_template.duck,
								   
								   mump_avoid_in_hurt = Record1#other_item_template.mump_avoid_in_hurt + Record2#other_item_template.mump_avoid_in_hurt,
								   far_avoid_in_hurt = Record1#other_item_template.far_avoid_in_hurt + Record2#other_item_template.far_avoid_in_hurt,
								   magic_avoid_in_hurt = Record1#other_item_template.magic_avoid_in_hurt + Record2#other_item_template.magic_avoid_in_hurt,
								   
								   attack_suppression = Record1#other_item_template.attack_suppression + Record2#other_item_template.attack_suppression,
								   defense_suppression = Record1#other_item_template.defense_suppression + Record2#other_item_template.defense_suppression
								          
								   },
	Record3.

%%计算装备战斗力
calc_equip_fight(ItemInfo) ->
	Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	if
		Template#ets_item_template.can_strengthen =:= 1 ->		
	Record = #other_item_template{},
	[NewRecord, _Cloth, _Weapon, _Wing] = calc_equip_properties_fun(ItemInfo,[Record,0,0,0]),
	Fight = NewRecord#other_item_template.attack +
	NewRecord#other_item_template.defense +
	NewRecord#other_item_template.hp * ?FIGHT_CALC_RATIO_02 +
	(NewRecord#other_item_template.magichurt +
	NewRecord#other_item_template.mumphurt + 
	NewRecord#other_item_template.farhurt) * ?FIGHT_CALC_RATIO_15 +
	(NewRecord#other_item_template.magicdefence + 
	NewRecord#other_item_template.mumpdefense + 
	NewRecord#other_item_template.fardefense) * ?FIGHT_CALC_RATIO_05 +
	(NewRecord#other_item_template.power_hit + 
	NewRecord#other_item_template.hit_target + 
	NewRecord#other_item_template.duck + 
	NewRecord#other_item_template.deligency) * ?FIGHT_CALC_RATIO_50,
	round(Fight);
		true ->
			0
	end.
	
%% 累加装备属性信息 	
calc_equip_properties_fun(ItemInfo, [Record, Cloth, Weapon, Wing]) ->
	Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	if
		ItemInfo#ets_users_items.durable =/= 0 ->
			
			NewRecord = Record#other_item_template{attack = (Record#other_item_template.attack 
															 + Template#ets_item_template.attack
															+ Template#ets_item_template.hide_attack),
												   defense = (Record#other_item_template.defense
															 + Template#ets_item_template.defense 
															 + Template#ets_item_template.hide_defense)},			
			%%读取强化属性
			NewRecord1 = calc_equip_properties_by_streng(NewRecord, ItemInfo, Template),
			%%读取镶嵌宝石属性
			NewRecord2 = calc_equip_properties_by_enchase(NewRecord1, ItemInfo),
			%%读取洗练属性
%% 			DataList = tool:split_string_to_intlist(ItemInfo#ets_users_items.data),
			NewRecord3 = calc_equip_properties_by_rebuild_property(NewRecord2, ItemInfo#ets_users_items.other_data#item_other.prop_list),
			%%读取装备固定属性 隐藏属性
			NewRecord4 = add_record_data(NewRecord3, Template#ets_item_template.other_data),
			IsCloth = lists:member((Template#ets_item_template.category_id), ?CATEGORY_CLOTH),
			case Template#ets_item_template.category_id of
				_CLOTH when IsCloth =:= true ->
						if Cloth == 0 ->
						 	  [NewRecord4, Template#ets_item_template.template_id, Weapon,  Wing];
						   true ->
							   [NewRecord4, Cloth, Weapon, Wing]
						end;
				?CATEGORY_SUIT ->
					[NewRecord4, Template#ets_item_template.template_id, Weapon,  Wing];
				?CATEGORY_WING ->
					[NewRecord4, Cloth, Weapon, Template#ets_item_template.template_id];
				_ ->
					case lists:member((Template#ets_item_template.category_id), ?CATEGORY_WEAPON) of
						true ->
							[NewRecord4, Cloth, Template#ets_item_template.template_id,  Wing];
						false ->
							[NewRecord4, Cloth, Weapon,  Wing]
					end
			end;		
		true ->
			[Record, Cloth, Weapon, Wing]
	end.

%% 物品排序
sort(ItemList, Type) ->
    case Type of
        template_id -> 
			F = fun(L1, L2) -> 
						L1#ets_users_items.template_id < L2#ets_users_items.template_id 
				end;
        _ -> 
			F = fun(L1, L2) -> 
						L1#ets_users_items.place < L2#ets_users_items.place 
				end
    end,
    lists:sort(F, ItemList).

%%--------------------------------修改打开脚本----------------------------------
open_item_script(Script, State) ->
	Property_List = tool:split_string_to_intlist(Script),
	if
		length(Property_List) > 0 ->
			[TotalRate, [ItemList1, ItemList2, ItemList3],  _State] =
				lists:foldl(fun open_item_script_1/2, [0, [[],[],[]], State], Property_List),
			
			open_item_script_3(TotalRate, [ItemList1, ItemList2, ItemList3], State);
		true ->
			{error, "script is error"}
	end.


open_item_script_1(InfoTuple, [TotalRate, [ItemList1, ItemList2, ItemList3], State]) ->
	InfoList = erlang:tuple_to_list(InfoTuple),	
	if
		length(InfoList) =:= 6 -> 
			AddType = lists:nth(1, InfoList),
			Template_id = lists:nth(3, InfoList),
			Amount = lists:nth(4, InfoList),
			StrengLevel = lists:nth(5, InfoList),
			Is_bind = lists:nth(6, InfoList),
			
			case AddType of
				0 ->
					NewItemList1 = lists:append(ItemList1, [{Template_id, Amount, StrengLevel, Is_bind}]),
					[TotalRate,  [NewItemList1, ItemList2, ItemList3], State];
				
				1 ->
					ItemRandom = lists:nth(2, InfoList),
					Random = util:rand(0, 100000),
					if
						ItemRandom > Random ->
							NewItemList2 = lists:append(ItemList2, [{Template_id, Amount, StrengLevel, Is_bind}]);
						true ->
							NewItemList2 = ItemList2
					end,
					[TotalRate,  [ItemList1, NewItemList2, ItemList3], State];
				
				2 ->
					Value = lists:nth(2, InfoList),
					NewTotalRate = TotalRate + Value,
					NewItemList3 = lists:append(ItemList3, [{NewTotalRate, Template_id, Amount, StrengLevel, Is_bind}]),
					[NewTotalRate,  [ItemList1, ItemList2, NewItemList3], State];
					
				_ ->
					[TotalRate,  [ItemList1, ItemList2, ItemList3], State]
			end;
				
		true ->
			[TotalRate, [ItemList1, ItemList2, ItemList3], State]
	end.

open_item_script_3(TotalRate, [ItemList1, ItemList2, ItemList3], State) ->
	if
		TotalRate =/= 0 ->
			NewItemList3 = open_item_script_4(TotalRate, ItemList3),
			open_item_script_5(lists:append(ItemList1, lists:append(ItemList2, NewItemList3)), State);
		true ->
		
			open_item_script_5(lists:append(ItemList1, ItemList2), State)
	end.

%%总和概率处理
open_item_script_4(TotalRate, ItemList3) ->
	Random = util:rand(0, TotalRate),
	NewItemList3 = open_item_script_6(ItemList3, Random, []),
	NewItemList3.


open_item_script_6([], _Random, NewItemList3) ->
	NewItemList3;
open_item_script_6([{Nthvalue, NTemplate, Amount, StrengLevel, Is_bind} | ItemList], Random, NewItemList3) ->
	if
		Random =< Nthvalue ->
			open_item_script_6([], Random, [{NTemplate, Amount, StrengLevel, Is_bind}]);
		true ->
			open_item_script_6(ItemList, Random, NewItemList3)
	end.
						

open_item_script_5(AllItemTempList, State) ->
	[AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList, MailItemList,NewState] =
		lists:foldl(fun open_item_script_7/2 , [0,0,0,0,[],[],State], AllItemTempList),
	{ok, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList, MailItemList,NewState]}.
	

open_item_script_7(ItemInfoTuple, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList, MailItemList, State]) ->
	ItemInfo = erlang:tuple_to_list(ItemInfoTuple),

	Amount = lists:nth(2, ItemInfo),
	IsBind = lists:nth(4, ItemInfo),
	Streng_Level = lists:nth(3, ItemInfo),
	case lists:nth(1, ItemInfo) of
		?CURRENCY_TYPE_YUANBO ->
			%%元宝
			[AddCopper, AddBindCopper, AddYuanBao+Amount, AddBindYuanBao, ItemList, MailItemList,State];
		?CURRENCY_TYPE_BIND_YUANBAO ->
			%%绑定元宝
			[AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao+Amount, ItemList, MailItemList,State];
		?CURRENCY_TYPE_COPPER ->
			%%铜币
			[AddCopper+Amount, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList, MailItemList,State];
		?CURRENCY_TYPE_BIND_COPPER ->
			%%绑定铜币
			[AddCopper, AddBindCopper+Amount, AddYuanBao, AddBindYuanBao, ItemList, MailItemList,State];
		Template_id ->
			case data_agent:item_template_get(Template_id) of
				Template when is_record(Template, ets_item_template) ->
					%lib_statistics:add_item_log(Template_id, ?ITEM_USER, Amount),							
					{L,M,N} = lib_item:add_item_amount_summation(Template, Amount, State, [], IsBind, ?CANSUMMATION),
					F = fun(Item, List) ->
								NewItem = Item#ets_users_items{strengthen_level=Streng_Level},
								[NewItem | List]
						end,
					NewItemList = lists:foldl(F, [], M),
						
					if
						N > 0 ->
							%%剩余物品通过邮件发给自己
%% 							MailItem1 = item_util:create_new_item(Template, Amount, 0, L#item_status.user_id, IsBind, Streng_Level),
							MailItem1 = create_new_item(Template, Amount, 0, 0, IsBind, Streng_Level, ?BAG_TYPE_MAIL),
							MailItem = item_util:add_item_and_get_id(MailItem1),

							[AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, lists:append(ItemList, NewItemList), [MailItem | MailItemList], L];
						true ->
							[AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, lists:append(ItemList, NewItemList), MailItemList, L]
					end;
					
				_ ->
					[AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList, MailItemList, State]
			end
	end.


%%-----------------------------------------------------------------------------

%% %% 打开脚本
%% open_item_script(Script, State) ->
%% 	Property_List = util:explode("|",Script),
%% 	if
%% 		length(Property_List) > 0 ->
%% 			[Value, AddBindCopper, AddCopper, AddYuanBao, AddBindYuanBao, ItemList, _State] = lists:foldl(fun open_item_script1/2, [0, 0, 0, 0, 0, [], State], Property_List),            
%% 			if
%% 				length(ItemList) > 0 ->
%% 					Random = util:rand(0, Value),
%% 					[_Flag, _Random, _State, [BindCopper, Copper, YuanBao, BindYuanBao, ItemList1]] = list:foldl(fun rand_add/2, [0, Random, State, {}], ItemList),
%% 					{ok, [AddCopper + Copper, AddBindCopper + BindCopper, AddYuanBao + YuanBao, AddBindYuanBao + BindYuanBao, [ItemList|[ItemList1]]]};
%% 				true ->					
%% 					{ok, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList]}
%% 			end;
%% 		
%% 		true ->
%% 			{error}
%% 	end.
%% 
%% 
%% %% 添加脚本物品,script脚本，value总概率，
%% open_item_script1(Script, [Value, AddBindCopper, AddCopper, AddYuanBao, AddBindYuanBao, ItemList, State]) ->		
%% 		InfoList = util:explode(",",Script,int),
%% 		if
%% 			length(InfoList) =:= 6 ->
%% 				AddType = lists:nth(1,InfoList),				
%% 				case AddType of
%% 					0 -> 
%% 						Is_Add = true,
%% 						NewValue = Value;
%% 					1 -> 
%% 						ItemRandom = lists:nth(2, InfoList),
%% 						Random = util:rand(0, 10000),
%% 						if
%% 							ItemRandom > Random -> 
%% 								Is_Add = true;
%% 							true -> 
%% 								Is_Add = flase
%% 						end,
%% 						NewValue = Value;
%% 					2 ->
%% 						Temp_Value = lists:nth(3, InfoList),
%% 						NewValue = Temp_Value + Value,
%% 						Is_Add = flase,
%% 						[[NewValue|[Script]]|ItemList];
%% 						
%% 					_ -> 
%% 						Is_Add = flase, 
%% 						NewValue = Value				
%% 				end,				
%% 				case Is_Add of
%% 					true ->
%% 						[BindCopper, Copper, YuanBao, BindYuanBao, ItemList] = init_script_item(InfoList, State),
%% 						[NewValue, BindCopper + AddBindCopper, Copper + AddCopper, YuanBao + AddYuanBao, 
%% 						 BindYuanBao + AddBindYuanBao, ItemList, State];
%% 					_ ->
%% 						[NewValue, AddBindCopper, AddCopper, AddYuanBao, AddBindYuanBao, ItemList, State]
%% 				end;
%% 								
%% 			true ->    				
%% 				[Value, AddBindCopper, AddCopper, AddYuanBao, AddBindYuanBao, ItemList, State]
%% 		end.
%% 
%% init_script_item(Data, State) ->
%% 	Amount = list:nth(4, Data),
%% 	case list:nth(3, Data) of
%% 		-100 ->
%% 			[0, 0, 0, 0, []];
%% 		-200 ->
%% 			[0, 0, 0, 0, []];
%% 		_ ->
%% 			case data_agent:item_template_get(list:nth(3, Data)) of
%% 				Template when is_record(Template, ets_item_template)->
%% 					ItemList = lib_item:add_item_amount(Template, Amount, State, []),
%% 					F = fun(Info) -> 
%% 								if
%% 									is_record(Info, ets_users_items) ->
%% 										Info#ets_users_items{
%% 															 is_bind = list:nth(6, Data),
%% 															 strengthen_level = list:nth(5, Data)  												 
%% 															};
%% 									true ->
%% 										skip
%% 								end
%% 						end,
%% 					[F(X)||X <- ItemList],
%% 					[0, 0, 0, 0, ItemList];
%% 				_ ->
%% 					[0, 0, 0, 0, []]
%% 			end
%% 		end.
%% 
%% rand_add(ListInfo, [Flag, Random_Value, State, Info])->
%% 	[Random|Data] = ListInfo,
%% 	if 
%% 		Random > Random_Value andalso Flag =:= 0 ->
%% 			[BindCopper, Copper, YuanBao, BindYuanBao, ItemList] = init_script_item(Data, State),
%% 			[1, Random_Value, State, [BindCopper, Copper, YuanBao, BindYuanBao, ItemList]];
%% 		true -> 
%% 			[Flag, Random_Value, State, Info]
%% 	end.

%% 取物品名称
get_item_name(TemplateId) ->
	Template = data_agent:item_template_get(TemplateId),
	case is_record(Template, ets_item_template) of
		true ->
			Template#ets_item_template.name;
		false ->
			<<>>
	end.


%%
%% Local Functions
%%


%% 自动购买需要的参数
auto_buy_need(TemplateId) ->
	Pattern = #ets_shop_template{template_id = TemplateId, _='_'},
	case ets:match_object(?ETS_SHOP_TEMPLATE, Pattern) of
		[] ->
			0;
		List ->
			case is_list(List) of
				true ->
					[Info|_T] = List;
				false ->
					[Info] = List
			end,
			Info#ets_shop_template.id
%% 			{ShopId, _, PayType} = Info#ets_shop_template.shop_id,
%% 			[ShopId, PayType]
	end.


update_smshop_info(OldInfo) ->
	NewItemsList = get_ref_smshop_info(),
	
	OldInfo#ets_users_smshop{items_list  = NewItemsList}.


get_ref_smshop_info() ->
	List = ets:tab2list(?ETS_SMSHOP_TEMPLATE),
	List1 = lists:sort(fun(X1,X2)->X1#ets_smshop_template.rate < X2#ets_smshop_template.rate end, List),
	case open_ref_smshop_info(6, [], List1) of
		[] ->
			[];
		OpenList ->
			OpenList
	end.

	
open_ref_smshop_info(0, OpenList, _List) ->
	OpenList;
open_ref_smshop_info(Times, OpenList, List) ->
	Random = util:rand(1, 10000),
	Place = Times-1,
	NewItem = open_ref_smshop_info1(List, Random,Place, []),
	open_ref_smshop_info(Place, lists:append(OpenList, NewItem), List).

open_ref_smshop_info1([], _Random,_Place ,Item) ->
	Item;
open_ref_smshop_info1([ H | T], Random,Place, Item) ->
	if
		Random =< H#ets_smshop_template.rate ->
			open_ref_smshop_info1([], Random, Place,[{Place,H#ets_smshop_template.id,0}]);
		true ->
			open_ref_smshop_info1(T, Random,Place, Item )
	end.
		
