%%%-----------------------------------
%%% @Module  : pt
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 协议公共函数
%%%-----------------------------------



-module(pt).
-include("common.hrl").
%% -include("record.hrl").
-export([
            read_string/1,
			write_string/1,
		    pack/3,
            pack/2
        ]).

-export([
		 packet_item_list/1,
		 packet_base_player/1,
		 packet_tip_player/1,
		 packet_figure_player/1,
		 packet_detail_player/1,
		 packet_self_player/1,
		 packet_item/1,
		 writebuff/2,
		 writeveins/2
		 ]).

-define(EXP_BUFF_ID, 716501). 					%%多倍经验buff编号

%%读取字符串
read_string(Bin) ->
    case Bin of
        <<Len:16, Bin1/binary>> ->
            case Bin1 of
                <<Str:Len/binary-unit:8, Rest/binary>> ->
                    {binary_to_list(Str), Rest};
                _R1 ->
                    {[],<<>>}
            end;
        _R1 ->
            {[],<<>>}
    end.

write_string(Str) ->
	Bin = tool:to_binary(Str),
    Len = byte_size(Bin),	
	<<Len:16, Bin/binary>>.


%% 打包信息，添加消息头
pack(Cmd,Data)->
%% 	?DEBUG("send_to_sid:~p",[Cmd]),
	pack_stat(Cmd),
	if erlang:byte_size(Data) >=300 ->
		   DataCompress = zlib:compress(Data),
		   L = byte_size(DataCompress) + 3,
		   <<L:16, 1:8, Cmd:16, DataCompress/binary>>;
	   true ->
		   L = byte_size(Data) + 3,
		   <<L:16, 0:8, Cmd:16, Data/binary>>
	end.
%% 不压缩
pack(Cmd,Data,DataIsZip) ->
	pack_stat(Cmd),
	L = byte_size(Data) + 3,
	<<L:16, DataIsZip:8, Cmd:16, Data/binary>>.

%% 统计输出数据包 
pack_stat(Cmd) ->
%% 	if Cmd =/= 10006 andalso Cmd =/= ?PP_MAP_OBJECT_STARTMOVE ->
%% 		?INFO_MSG("~s_write_[~p] ",[misc:time_format(misc_timer:now()), Cmd]);
%%    		true -> no_out
%% 	end,
	[NowBeginTime, NowCount] = 
	case ets:match(?ETS_STAT_SOCKET,{Cmd, socket_out , '$3', '$4'}) of
		[[OldBeginTime, OldCount]] ->
			[OldBeginTime, OldCount+1];
		_ ->
			[misc_timer:now(),1]
	end,	
	ets:insert(?ETS_STAT_SOCKET, {Cmd, socket_out, NowBeginTime, NowCount}).





%% 多个模块使用包

packet_base_player(User) ->
    NickBin = pt:write_string(User#ets_users.nick_name),
	Sex = User#ets_users.sex,
	Level = User#ets_users.level,
	<<NickBin/binary, Sex:8, Level:8>>.

packet_tip_player(User) ->
   packet_base_player(User).


packet_figure_player(User) ->
	TipBin = packet_tip_player(User),
%% 	StallNameBin = pt:write_string(User#ets_users.stallname),
	
	Camp = User#ets_users.camp,
	Career = User#ets_users.career, 
	IsHorse = User#ets_users.is_horse,
	SitState = User#ets_users.other_data#user_other.sit_state,
	StyleBin = case is_binary(User#ets_users.style_bin) of
		true ->
			 User#ets_users.style_bin;
		false ->
			 ?STYLE_DEFAULT
		end,
					   
	StallNameBin = pt:write_string(""),%%不摆摊
	ClubID = User#ets_users.club_id,
	
	ClubNameBin = pt:write_string(User#ets_users.other_data#user_other.club_name),
	ClubJob = User#ets_users.other_data#user_other.club_job,
	ClubLevel = User#ets_users.other_data#user_other.guild_level,
	FurnaceLevel = User#ets_users.other_data#user_other.guild_furnace_level,
	CurrentFeats = User#ets_users.other_data#user_other.current_feats,
	TotalFeats = User#ets_users.other_data#user_other.total_feats,
	PKMode = User#ets_users.pk_mode,
	PKValue = User#ets_users.pk_value,
	
	VipID = User#ets_users.vip_id,
	Title = User#ets_users.title,
	TitleIsHide = User#ets_users.is_hide,
	BuffTitleId = User#ets_users.other_data#user_other.buff_titleId,
	
		   <<TipBin/binary, 
			 Camp:8, 
			 Career:8, 
			 StyleBin/binary,
			 IsHorse:8,
			 SitState:8,
			 StallNameBin/binary,
			 ClubID:32, 
			 ClubNameBin/binary,
			 ClubJob:8,
			 ClubLevel:8,
			 FurnaceLevel:8,
	  		 CurrentFeats:32,
	  		 TotalFeats:32,
			 PKMode:8,
			 PKValue:32,
			 VipID:16,
			 Title:32,
			 TitleIsHide:8,
			 BuffTitleId:16
			>>.

packet_detail_player(User) ->
	FigureBin = packet_figure_player(User),
	TotalHP = User#ets_users.other_data#user_other.total_hp + User#ets_users.other_data#user_other.tmp_totalhp,
	TotalMP = User#ets_users.other_data#user_other.total_mp + User#ets_users.other_data#user_other.tmp_totalmp, 
	CurrentHP = User#ets_users.current_hp, 
	CurrentMP = User#ets_users.current_mp, 
	CurrentClubContribute = User#ets_users.current_club_contribute,
	Attack = User#ets_users.other_data#user_other.attack, 
	Defense = User#ets_users.other_data#user_other.defense, 
	HitTarget = User#ets_users.other_data#user_other.hit_target, 
	Duck = User#ets_users.other_data#user_other.duck,
	KeepOff = User#ets_users.other_data#user_other.keep_off, 
	PowerHit = User#ets_users.other_data#user_other.power_hit, 
	Deligency = User#ets_users.other_data#user_other.deligency, 
	MagicHurt = User#ets_users.other_data#user_other.magic_hurt,
	MagicDefense = User#ets_users.other_data#user_other.magic_defense, 
	MagicAvoidInHurt = User#ets_users.other_data#user_other.magic_avoid_in_hurt, 
	FarHurt = User#ets_users.other_data#user_other.far_hurt,
	FarDefense = User#ets_users.other_data#user_other.far_defense, 
	FarAvoidInHurt = User#ets_users.other_data#user_other.far_avoid_in_hurt,
	MumpHurt = User#ets_users.other_data#user_other.mump_hurt,
	MumpDefense = User#ets_users.other_data#user_other.mump_defense,
	MumpAvoidInHurt = User#ets_users.other_data#user_other.mump_avoid_in_hurt,
	GodRepute = User#ets_users.god_repute,
	GhostRepute = User#ets_users.ghost_repute,
	Honor = User#ets_users.honor,
	%PKValue = User#ets_users.pk_value,
	Title = User#ets_users.title,
	MaxPhysical = User#ets_users.other_data#user_other.max_physical,
	CurrentPhysical = User#ets_users.current_physical,
	
	LifeExperiences = User#ets_users.life_experiences,
	TotalLiftExperiences = User#ets_users.other_data#user_other.total_life_experiences,
	Fight = User#ets_users.fight,
	Damage = User#ets_users.other_data#user_other.damage,
	<<FigureBin/binary,  
	  TotalHP:32,
	  TotalMP:32, 
	  CurrentHP:32, 
	  CurrentMP:32, 
	  CurrentClubContribute:32,
	  Attack:32, 
	  Defense:32, 
	  HitTarget:32, 
	  Duck:32,
	  KeepOff:32, 
	  PowerHit:32, 
	  Deligency:32, 
	  MagicHurt:32,
	  MagicDefense:32, 
	  MagicAvoidInHurt:32, 
	  FarHurt:32,
	  FarDefense:32, 
	  FarAvoidInHurt:32,
	  MumpHurt:32,
	  MumpDefense:32,
	  MumpAvoidInHurt:32,
 	  LifeExperiences:32,
	  TotalLiftExperiences:32,
	  GodRepute:32,
	  GhostRepute:32,
	  Honor:32,
	  %PKValue:32,
	  Title:32,
	  MaxPhysical:32,
	  CurrentPhysical:32,
	  Fight:32,
	  Damage:32
		>>.

packet_parse_data(User) ->
	 YuanBao = User#ets_users.yuan_bao,
	 Copper = User#ets_users.copper,
	 BindCopper = User#ets_users.bind_copper,
	 DepotCopper = User#ets_users.depot_copper,
	 BindYuanBao = User#ets_users.bind_yuan_bao,
	<<YuanBao:32/signed,
	  Copper:32/signed,
	  BindCopper:32/signed,
	  DepotCopper:32/signed,
	  BindYuanBao:32/signed>>.
	  
%% packet_self_player(User, StyleBin) ->
packet_self_player(User) ->
	
	DetailBin = packet_detail_player(User),
	UserName = pt:write_string(User#ets_users.user_name),
%% 	CurrentExp = User#ets_users.current_exp,
	Exp = User#ets_users.exp,
	ParseData = packet_parse_data(User),
	Money = User#ets_users.money,
	Exploit = User#ets_users.other_data#user_other.exploit_info#user_exploit_info.exploit,
	BagMaxCount = User#ets_users.bag_max_count,
	DepotMaxCount = User#ets_users.depot_max_number,
	TotalClubContribute = User#ets_users.total_club_contribute,
	HPRevert = User#ets_users.other_data#user_other.hp_revert,
	MPRevert = User#ets_users.other_data#user_other.mp_revert,
	ExceptRate = User#ets_users.other_data#user_other.abnormal_rate,
	DefenseExceptRate = User#ets_users.other_data#user_other.anti_abnormal_rate,
	FitEquipType = User#ets_users.fit_equip_type,
	FitWeaponType = User#ets_users.fit_weapon_type,
	EspecialStatus = User#ets_users.especial_status,
%% 	LifeExperiences = User#ets_users.life_experiences,
%% 	TotalLiftExperiences = User#ets_users.total_life_experiences,
	ClientConfig = User#ets_users.client_config,	
%% 	PKMode = User#ets_users.pk_mode,			移动到figure
	PKModeChangeDate = User#ets_users.pk_mode_change_date,
		
	<<DetailBin/binary,
	  UserName/binary,
%% 	  Exp:32,
	  Exp:64,
	  ParseData/binary,
	  Money:32,
	  Exploit:32,
	  BagMaxCount:32,
	  DepotMaxCount:32,
	  TotalClubContribute:32,
	  HPRevert:32,
	  MPRevert:32,
	  ExceptRate:32,
	  DefenseExceptRate:32,
	  FitEquipType:32,
	  FitWeaponType:32,
	  EspecialStatus:32,
%% 	  LifeExperiences:32,
%% 	  TotalLiftExperiences:32,
	  ClientConfig:32,
%% 	  PKMode:8,
	  PKModeChangeDate:64
	  >>.

packet_item_list(ItemList) ->
	N = length(ItemList),
		FItem = fun(Info) ->
				ItemBin = packet_item(Info),
				<<(Info#ets_users_items.place):32,
				  ItemBin/binary>>
		end,
	ItemListBin = tool:to_binary([FItem(X)||X <- ItemList]),
	<<N:32, ItemListBin/binary>>.


%% 物品
packet_item(Info) ->
	PropBin = pt:write_string(Info#ets_users_items.data),
	<<
	  (Info#ets_users_items.id):64,
	  (Info#ets_users_items.template_id):32,
	  (Info#ets_users_items.is_bind):8,
	  (Info#ets_users_items.strengthen_level):32,
	  (Info#ets_users_items.amount):32,
	  (Info#ets_users_items.place):32,
	  (Info#ets_users_items.create_date):32,
	  (Info#ets_users_items.state):32,
	  (Info#ets_users_items.enchase1):32,
	  (Info#ets_users_items.enchase2):32,
	  (Info#ets_users_items.enchase3):32,
	  (Info#ets_users_items.enchase4):32,
	  (Info#ets_users_items.enchase5):32,
	  (Info#ets_users_items.enchase6):32,
 	  (Info#ets_users_items.durable):32, 
	  (Info#ets_users_items.fight):32,
	  PropBin/binary,
	  (Info#ets_users_items.other_data#item_other.sell_price):32>>.

%% %%打包buff信息
%% writebuff([],_UpdateType,BuffBin) -> BuffBin;
%% writebuff([H|T],UpdateType,BuffBin) ->
%% 	ID = H#ets_users_buffs.template_id,
%% 	EndDate = H#ets_users_buffs.end_date,
%% 	TotalValue = H#ets_users_buffs.total_value,
%% 	StopDate = H#ets_users_buffs.valid_date,
%% %% 	if
%% %% 		ID =:= ?EXP_BUFF_ID andalso H#ets_users_buffs.valid_date =/= 0 ->
%% %% 			IsStop = 1;
%% %% 		true ->
%% %% 			IsStop = 0
%% %% 	end,
%% 	NewBuffBin = if
%% 					 UpdateType =:= 1 ->
%% 						 << BuffBin/binary,
%% 						ID:32,
%% 						UpdateType:8,
%% 						EndDate:64,
%% 						0:8,
%% 						StopDate:64,
%% 						TotalValue:32>>;
%% 					 true ->
%% 						 << BuffBin/binary,
%% 							ID:32,
%% 							0:8>>
%% 				 end,
%% 						 
%% 	writebuff(T,UpdateType, NewBuffBin).

writebuff([],BuffBin) -> BuffBin;
writebuff([H|T], BuffBin) ->
	ID = H#ets_users_buffs.template_id,
	EndDate = H#ets_users_buffs.end_date,
	TotalValue = H#ets_users_buffs.total_value,
	StopDate = H#ets_users_buffs.valid_date,
	UpdateType = H#ets_users_buffs.is_exist,
%% 	if
%% 		ID =:= ?EXP_BUFF_ID andalso H#ets_users_buffs.valid_date =/= 0 ->
%% 			IsStop = 1;
%% 		true ->
%% 			IsStop = 0
%% 	end,
	NewBuffBin = if
					 UpdateType =:= 1 ->
						 <<BuffBin/binary,
						   ID:32,
						   UpdateType:8,
						   EndDate:64,
						   0:8,
						   StopDate:64,
						   TotalValue:32>>;
					 true ->
						 <<BuffBin/binary,
						   ID:32,
						   0:8>>
				 end,

	writebuff(T, NewBuffBin).

writeveins([], VeinsBin) -> VeinsBin;
writeveins([H | T], VeinsBin) ->
	NewVeinsBin = << VeinsBin/binary,
						(H#r_user_veins.acupoint_type):32,
						(H#r_user_veins.acupoint_level):32,
						(H#r_user_veins.gengu_level):32,
						(H#r_user_veins.luck):32
						>>,
writeveins(T, NewVeinsBin).