<?php
	require_once(dirname(__FILE__).'/../lib/SqlResult.php');

	class Provider {
		private static $instance;
		private function __construct()
	    {}
	    
		public static function getInstance()
	    {
	        if(self::$instance == null)
	        {
	            self::$instance = new Provider();
	        }
	        return self::$instance;
	    }
		
		public function getMapList(){
	    	$sql = "SELECT 	map_id, 
	path, 
	TYPE, 
	NAME, 
	requirement, 
	music,
	`index`, 
	is_open, 
	default_point, 
	attack_path	
	FROM 
	t_map_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","byte","string","string","int","int","byte","string","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	    
	    public function getItemList(){
	    	$sql = "SELECT category_id,
	template_id, 
	NAME, 
	pic, 
	icon, 
	description, 
	quality, 
	need_level, 
	need_sex, 
	need_career, 
	max_count, 
	attack, 
	defense, 
	sell_copper, 
	sell_type, 
	suit_id, 
	repair_modulus, 
	bind_type, 
	durable_upper, 
	cd, 
	can_use, 
	can_strengthen, 
	can_enchase, 
	can_rebuild, 
	can_recycle, 
	can_improve, 
	can_unbind, 
	can_repair, 
	can_destroy, 
	can_sell, 
	can_trade, 
	can_feed,
	free_property, 
	regular_property, 
	hide_property, 
	attach_skill, 
	hide_attack, 
	hide_defense, 
	valid_time, 
	feed_count,
	script, 
	propert1, 
	propert2, 
	propert3, 
	propert4, 
	propert5, 
	propert6, 
	propert7, 
	propert8
	 
	FROM 
	t_item_template  ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","string","int","int",
				"string","int","int","int","int",
				"int","int","int","int","int",
				"int","int","int","int","int",
				"byte","byte","byte","byte","byte",
				"byte","byte","byte","byte","byte",
				"byte","byte","string","string","string",
				"string","int","int","int","int",
				"string","int","int","int","int",
				"int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	 public function getTaskList(){
	    	$sql = " SELECT 	
task_id, 
award_copper, 
award_exp, 
award_yuan_bao, 
UNIX_TIMESTAMP(begin_date), 

0, 
can_repeat, 
can_reset, 
`CONDITION`, 
content,
 
UNIX_TIMESTAMP(end_date), 
max_level, 
min_level, 
min_guild_level,
max_guild_level, 

next_task_id, 
npc, 
pre_task_id, 
repeat_count, 
repeat_day, 

target, 
time_limit, 
title, 
TYPE, 
camp, 

career, 
sex, 
can_entrust, 
entrust_time, 
entrust_copper, 

entrust_yuan_bao, 
can_transfer, 
show_level, 
auto_accept, 
auto_finish, 

need_item_id, 
need_copper,
accept_event,
finish_event
FROM 
t_task_template  ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int",
				"byte","byte","byte","int","string",
				"int","int","int","int","int",
				"string","int","string","int","int",
				"string","byte","string","int","int",
				"int","int","byte","int","int",
				"int","byte","int","byte","byte",
				"int","int","string","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	  
	 public function getTaskStateList($id){
	    	$sql = " SELECT 	
	award_copper, 
	award_exp, 
	award_yuan_bao, 
	award_life_experience, 
	award_bind_yuan_bao, 
	award_bind_copper, 
	award_contribution, 
	award_money, 
	award_activity, 
	award_feats,
	`condition`,
	can_transfer, 
	`DATA`, 
	target, 
	npc, 
	content, 
	unfinish_event, 
	finish_event1, 
	finish_event2,
	task_award_id
	FROM 
	t_task_state_template 
	WHERE task_id = ".$id;
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int",
				"int","int","int","int","int",
				"int","byte","string","string","int",
				"string","string","string","string","string",
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
		
	public function getTaskAwardList($task_award_ids){
		$count = count($task_award_ids);
		$o = array();
		$lable = array(
		"int",
		"int",
		"int",
		"int",
		"int",
		"int",
		"byte"
		);
		
		for($i = 0 ; $i < $count; $i++){
			$sql = " SELECT 	
			award_id,
			sex,
			career,
			template_id,
			amount,
			validate,
			is_bind
			FROM 
			t_task_award_template
			WHERE award_id = " . $task_award_ids[$i];
			$r = sql_fetch_rows($sql);
			if($r != ""){
				array_push($o,$r[0]);
			}
		}
		if(count($o) > 0)
		{
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else
		{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	    
	 public function getDoorList(){
	    	$sql = " SELECT door_id, 
	current_map_id, 
	next_map_id, 
	next_door_id, 
	pos_x, 
	pos_y, 
	other_data
	FROM 
	t_door_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","short",
				"short","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	    
	    
	 public function getNpcList(){
	    	$sql = "SELECT 	npc_id, 
	NAME, 
	function_name, 
	pic_path, 
	icon_path, 
	dialog,
	map_id, 
	pos_x, 
	pos_y,	 
	deploys,
	npc_width,
	npc_height,
	frame_rates
	FROM 
	t_npc_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","string","string","string","string",
				"int","short","short","string","int","int","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	public function getBufList(){
	    	$sql = "SELECT 	buff_id, 
	group_id, 
	NAME,
	pic_path, 
	description, 
	active_totaltime, 
	active_timespan, 	
	TYPE, 
	limit_totaltime, 
	skill_effect_list
	FROM 
	t_buff_template  ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","string","string","string",
				"int","int","int","int","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }

	    
	public function getMonsterList(){
	    	$sql = "SELECT 	monster_id, 
	NAME, 
	pic_path, 
	max_hp, 
	local_point, 
	map_id,
	LEVEL, 
	lbornl_points, 
	attack_physics,
	defanse_physics,
	type,
	camp,
	monster_width,
	monster_height,
	frame_rates	
	FROM 
	t_monster_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","string","int","string",
				"int","short","string","int","int",
				"int","short","int","int","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	public function getMovieList(){
	    	$sql = "SELECT move_id, 
	frame, 
	scale_x, 
	scale_y, 
	pic_path, 
	amount, 
	bound, 
	time, 
	add_mode, 
	is_move, 
	comp_effect
	FROM 
	t_movie_template  ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","int","int","int",
				"int","int","int","int","byte",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	public function getSkillList(){
	    	$sql = "SELECT 	
	description, 
	group_id, 
	GROUP_CONCAT(active_use_mp ORDER BY skill_id SEPARATOR '|'), 
	NAME, 
	pic_path, 
	active_item_category_id, 
	active_item_template_id, 
	active_side, 
	GROUP_CONCAT(active_target_monster_list ORDER BY skill_id SEPARATOR '|'), 
	active_target_type, 
	active_type, 
	category_id, 
	GROUP_CONCAT(cold_down_time ORDER BY skill_id SEPARATOR '|'), 
	GROUP_CONCAT(attack_effect ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(beattack_effect ORDER BY skill_id SEPARATOR '|'),
	default_skill, 
	GROUP_CONCAT(`RANGE` ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(radius ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(prepare_time ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(straight_time ORDER BY skill_id SEPARATOR '|'),
	place, 
	need_career, 
	GROUP_CONCAT(need_copper ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(update_life_experiences ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(need_level ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(need_item_id ORDER BY skill_id SEPARATOR '#'),
	GROUP_CONCAT(need_skill_id ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(need_skill_level ORDER BY skill_id SEPARATOR '|'),

	GROUP_CONCAT(need_feats ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(skill_effect_list ORDER BY skill_id SEPARATOR '#'),
	GROUP_CONCAT(effect_number ORDER BY skill_id SEPARATOR '|'),
	GROUP_CONCAT(description ORDER BY skill_id SEPARATOR '|'),
	wind_effect,
	sound, 
	is_single_attack,
	is_shake,
	GROUP_CONCAT(buff_list ORDER BY skill_id SEPARATOR '#')
	
	FROM 
	t_skill_template
	GROUP BY group_id
	 ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("string","int","string","string","string","int",
				"int","int","string","int","int",
				"int","string","string","string","byte",
				"string","string","string","string","short",
				"byte","string","string","string","string","string","string","string",
				"string","string","string","string","int",
				"byte","byte","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	public function getExpList(){
	    	$sql = "  SELECT LEVEL, 
	EXP, 
	total_exp
	FROM 
	t_exp_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	
	public function getVeinsList(){
				$sql = " SELECT acupoint_id,acupoint_name,acupoint_level,acupoint_type,need_cooper,need_life_exp,need_times,
				need_gengu_amulet,gengu_success_rate,award_attribute_type,award_acupoint,award_acupoint_count,award_gengu,award_gengu_count
				 from t_veins_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","int","int","int","int","int",
				"int","int","int","int","int","int","int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getVeinsExtraList(){
				$sql = "SELECT 	id, 
	NAME, 
	need_level, 
	hp, 
	defense, 
	mump_defense, 
	magic_defense, 
	far_defense, 
	attack, 
	attribute_attack, 
	damage
	 
	FROM 
	t_veins_extra_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","int","int","int","int","int",
				"int","int","int","int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getCollectList(){
	    	$sql = "  SELECT 	template_id, 
	NAME, 
	TYPE, 
	min_level, 
	max_level, 
	award_hp, 
	award_mp, 
	award_life_experiences, 
	award_exp, 
	award_yuan_bao, 
	award_bind_copper, 
	award_copper, 
	collect_time, 
	reborn_time, 
	pic_patch, 
	map_id, 
	local_point, 
	quality, 
	lbornl_points 
	 
	FROM 
	t_collect_template  ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","int","int","int",
				"int","int","int","int","int",
				"int","int","int","int","string",
				"int","string","int","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	    
	    
	    public function getShopList(){
	    $sql = " SELECT DISTINCT( shop_id) ,'' FROM t_shop_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("byte","string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
		public function getShopCategoryList($shopid){
	    	$sql = "  SELECT DISTINCT( b.category_id),b.name
FROM t_shop_template a,t_shop_category_template b
WHERE a.category_id = b.category_id AND a.shop_id =  ".$shopid." ORDER BY b.category_id;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    	    
	public function getShopItemsList($category_id,$shopid){
	    	$sql = " SELECT 	id, 
	    	state, 
	    	template_id, 
	    	pay_type, 
	    	price, 
	    	old_price,
	    	sale_num
	FROM 
	t_shop_template  where category_id = ".$category_id." and shop_id=".$shopid.";";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","byte","int","byte","int",
				"int","int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }

		public function getDuplicateList(){
			$sql = "select duplicate_id, name, description, day_times, npc, recommend, type, showtype, min_level, max_level, min_player, max_player,
						 need_yuan_bao,need_bind_yuan_bao, need_copper, need_bind_copper, need_item_id, total_time, mission, award_id, is_dynamic, task_id, 
						 is_show_in_activity, other_data from t_duplicate_template;";
			$r = sql_fetch_rows($sql);
		    	$o = array();
				if($r != ""){
					$count = count($r);
					$lable = array("int","string","string","short","int",
					"short","short","short","short","short",
					"short","short","int","int","int","int","int",
					"int","string","string","byte","int","byte","string"
					);
					for ($i = 0 ; $i < $count; $i++){
						$item = $r[$i];
						$o[] = $item;
					}
					return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
				}
				else{
					return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
				}
		}
		
		public function getDuplicateMissionList(){
			$sql = "SELECT b.map_id ,a.mission_id, a.duplicate_id, b.need_times,a.monster_num,a.total_exp,a.total_lilian, b.name,a.pass_info, b.award_id,a.dorp_id
FROM t_duplicate_mission_for_client a, t_duplicate_mission_template b
WHERE a.mission_id = b.mission_id";
			$r = sql_fetch_rows($sql);
		    	$o = array();
				if($r != ""){
					$count = count($r);
					$lable = array("int","int","int","int","int","int","int", "string","string","string","string"
					);
					for ($i = 0 ; $i < $count; $i++){
						$item = $r[$i];
						$o[] = $item;
					}
					return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
				}
				else{
					return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
				}
		}
		
		
		
		
		public function getGuildsTemplate(){
	    	$sql = "SELECT 	guild_level, 
	need_money, 
	vice_master_member, 
	honorary_member, 
	total_member, 
	maintain_fee,
	total_requests_number, 
	total_mails
	FROM 
	t_guilds_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	public function getGuildsShopLeveTemplate(){
	    	$sql = "SELECT 	shop_level, 
	need_club_level, 
	need_money
	 
	FROM 
	t_guilds_shop_leve_template  ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	    
	public function getGuildsFurnaceLevelTemplate(){
	    	$sql = "SELECT 	furnace_level, 
	need_club_level, 
	need_money,
	description
	FROM 
	t_guilds_furnace_leve_template ;";
	    	$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	    }
	    
	public function getStrengthenTemplate(){
		$sql = "SELECT 	strengthen_level, 
	min_strengthen_num, 
	max_strengthen_num, 
	success_rate, 
	need_copper, 
	need_stone, 
	perfect_stone, 
	grow_up,
	addition
	 
	FROM 
	t_strengthen_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getEquipStrengthenTemplate(){
		$sql = "SELECT 	LEVEL, 
	attack, 
	attr_attack, 
	mump_defence, 
	magic_defence,
	far_defence,
	hp
	 
	FROM 
	t_equip_strength_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getItemStoneTemplate(){
		$sql = "SELECT 	category_id, 
	stone_list
	 
	FROM 
	t_item_stone_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getPickStoneTemplate(){
		$sql = "SELECT 	stone_level, 
	copper_modulus, 
	success_rates
	 
	FROM 
	t_pick_stone_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getItem_Uplevel_Template(){
		$sql = "SELECT 	item_template_id, 
	uplevel_copper, 
	uplevel_material, 
	uplevel_target_id
	 
	FROM 
	t_item_uplevel_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","string","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getItem_Upgrade_Template(){
		$sql = "SELECT 	item_template_id, 
	upquality_copper, 
	upquality_material, 
	upquality_target_id
	 
	FROM 
	t_item_upgrade_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","string","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getBoxTemplate(){
		$sql = "SELECT TYPE ,GROUP_CONCAT(`item_id` ORDER BY place SEPARATOR ',')
FROM t_box_client_template
GROUP BY TYPE
ORDER BY TYPE;
";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getSuitNumTemplate(){
		$sql = "SELECT 	suit_num, 
	suit_name, 
	cloth_id, 
	armet_id, 
	cuff_id, 
	shoe_id, 
	caestus_id, 
	necklack_id
	 
	FROM 
	t_suit_num_template 
	ORDER BY suit_num;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
		public function getSuitPropsTemplate(){
		$sql = "SELECT 	id, 
	suit_num, 
	suit_amount, 
	suit_props, 
	suit_hide_props, 
	skill_id, 
	description
	FROM 
	t_suit_props_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","string","string","int","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
		
	public function getFormulaTemplate(){
		$sql = "SELECT 	formula_id, 
	a.TYPE, 
	b.type,
	create_id, 
	create_amount, 
	success_rate, 
	cost_copper, 
	item1, 
	amount1, 
	item2, 
	amount2, 
	item3, 
	amount3, 
	item4, 
	amount4, 
	item5, 
	amount5, 
	item6, 
	amount6
	 
	FROM 
	t_formula_template a, t_formula_name_template b
	WHERE a.type = b.id;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int","int","int",
				"int","int","int","int","int","int","int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getFireBoxSortTemplate(){
		$sql = "SELECT b.id,b.name,GROUP_CONCAT(CONCAT(a.id,',',a.NAME) ORDER BY a.id SEPARATOR '|' )
FROM t_formula_name_template a, t_formula_page_template b
WHERE a.type = b.id
GROUP BY b.id; ";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","string");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getFormulaTableTemplate(){
		$sql = "SELECT b.type,a.formulaid,a.create_id,a.create_name,a.type 
		FROM t_formula_table_template a,t_formula_name_template b
WHERE a.type = b.id;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","string","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getFormulaTemplate2(){
		$sql = "SELECT formula_id,NAME,create_id,create_name,create_amount,success_rate,cost_copper,
		item1,amount1,item2,amount2,item3,amount3,item4,amount4,item5,amount5,item6,amount6
FROM t_formula_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","string","int","string","int","int","int",
				"int","int","int","int","int","int","int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getMountsExpTemplate(){
		$sql = "SELECT 	LEVEL, 
	EXP, 
	total_exp
	FROM 
	t_mounts_exp_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	
	public function getMountsDiamondTemplate(){
		$sql = "SELECT 	template_id, 
	diamond, 
	total_hp, 
	total_mp, 
	attack, 
	defence
	FROM 
	t_mounts_diamond_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getMountsStarTemplate(){
		$sql = "SELECT 	template_id, 
	star, 
	magic_attack, 
	far_attack, 
	mump_attack, 
	magic_defense, 
	far_defense, 
	mump_defense
	FROM 
	t_mounts_star_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int",
				"int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getMountsGrowUpTemplate(){
		$sql = "SELECT 	template_id, 
	grow_up, 
	total_hp, 
	total_mp, 
	attack, 
	defence
	FROM 
	t_mounts_grow_up_template  ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int",
				"int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getMountsQualificationTemplate(){
		$sql = "SELECT 	template_id, 
	qualification, 
	magic_attack, 
	far_attack, 
	mump_attack, 
	magic_defense, 
	far_defense, 
	mump_defense
	FROM 
	t_mounts_qualification_template   ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int",
				"int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getVipTemplate(){
		$sql = 
		"SELECT 	
		vip_id, 
		vip_name, 
		effect_date, 
		yuanbao,
		money,
		buffs,
		tranfer_shoe,
		bugle,
		exp_rate,
		strength_rate,
		hole_rate,
		lifeexp_rate,
		mounts_stair_rate,
		pet_stair_rate,
		title_id,
		items
		FROM 
		t_vip_template   ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string",
				"int",
				"int",
				"int",
				"string",
				"int",				
				"int",
				"int",
				"int",
				"int",
				"int",
				"int",
				"int",
				"int",
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getPetTemplate(){
		$sql = 
		"SELECT template_id, 
	pic_path
	 
	FROM 
	t_pet_template_client  ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	
	
	public function getPetExpTemplate(){
		$sql = "SELECT 	LEVEL, 
	EXP, 
	total_exp
	FROM 
	t_pet_exp_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	
	public function getPetDiamondTemplate(){
		$sql = "SELECT 	template_id, 
	diamond, 
	magic_attack, 
	far_attack, 
	mump_attack, 
	power_hit
	FROM 
	t_pet_diamond_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getPetStarTemplate(){
		$sql = "SELECT 	template_id, 
	star, 
	attack, 
	hit
	FROM 
	t_pet_star_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	public function getPetGrowUpTemplate(){
		$sql = "SELECT 	template_id, 
	grow_up, 
	attack, 
	hit, 
	power_hit
	FROM 
	t_pet_grow_up_template  ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int" );
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getPetGrowUpExpTemplate(){
		$sql = "SELECT level,
						exp, 
						total_exp
				FROM 
					t_pet_grow_up_exp_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int",
								"int",
								"int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getPetQualificationTemplate(){
		$sql = "
SELECT 	template_id, 
	qualification, 
	magic_attack, 
	far_attack, 
	mump_attack, 
	hit, 
	power_hit
	FROM 
	t_pet_qualification_template   ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int","int","int",
				"int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getPetQualificationExpTemplate(){
		$sql = "SELECT level,
						exp, 
						total_exp
				FROM 
					t_pet_grow_up_exp_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getdecomposcopperTemplate(){
		$sql = "
SELECT 	quality, 
	needcopper
	FROM 
	t_decompose_copper_template   ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int",
				"int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
		public function getenchasecopperTemplate(){
		$sql = "
SELECT 	stone_level, 
	copper
	 
	FROM 
	t_enchase_template ;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int",
				"int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
			public function getcomposecopperTemplate(){
		$sql = "
SELECT 	stone_level, 
	copper
	 
	FROM 
	t_stone_compose_template;";
				$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array("int","int",
				"int","int");
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getActiveTemplate(){
		$sql = 
		"SELECT
		id,
		active_name,
		active_acount,
		active_time,
		npc_id,
		active,
		type,
		min_level
		FROM 
		t_active_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string",
				"int",
				"string",
				"string",
				"int",
				"int",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getActiveRewardsTemplate(){
		$sql = 
		"SELECT 	
		id,
		need_active,
		rewards_exp,
		bind_copper,
		bind_yuanbao,
		items
		FROM 
		t_active_rewards_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int",
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getActivityTaskTemplate(){
		$sql = 
		"SELECT 	
		task_id,
		description,
		days,
		award_id,
		type
		FROM 
		t_activity_task_template   ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string",
				"int",
				"string",
				"int"		
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getDailyAwardTemplate(){
		$sql = 
		"SELECT 	
		award_id,
		need_seconds,
		copper,
		bind_copper,
		yuan_bao,
		bind_yuan_bao,
		item_template_ids
		FROM 
		t_daily_award_template   ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int",
				"int",
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getTwelfare(){
		$sql = 
		"SELECT 	
		id,
		award,
		num1,
		vip_award,
		num2
		FROM 
		t_welfare_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getTwelfareExp(){
		$sql = 
		"SELECT 	
		id,
		award,
		copper,
		copper_award,
		yuanbao,
		yuanbao_award
		FROM 
		t_welfare_exp_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getItemCategoryTemplate(){
		$sql = 
		"SELECT 	item_category_id, 
	NAME, 
	place	 
	FROM 
	t_item_category_template ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	} 
	
	public function getFilterContent(){
		$sql = 
		"SELECT 	 
	content
	 
	FROM 
	t_filter_content_template ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	} 
	
	
	public function getTokentask(){
		$sql = 
		"SELECT 	
		type,
		copper,
		copper_bind,
		exp,
		other,
		item_id
		FROM 
		t_token_task_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getTarget(){
		$sql = 
		"SELECT 	
		target_id,
		pic,
		type,
		class,
		title,
		content,
		tip,
		awards,
		client_count,
		award_yuan_bao,
		award_achievement,
		award_data
		FROM 
		t_target_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"string",
				"string",
				"string",
				"string",
				"int",
				"int",
				"int",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getChallengeDup(){
		$sql = 
		"SELECT 	
		id,
		pic,
		limit_id,
		storey,
		gift,
		`drop`,
		duplicate_id,
		star_time
		FROM 
		t_challenge_duplicate_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int",
				"string",
				"int",
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getamityTemplate(){
		$sql = 
		"SELECT 	
		level,
		amity,
		total_amity,
		name,
		data
		FROM 
		t_amity_template;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"string",
				"string"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getActivityPayUse(){
		$sql = 
		"SELECT
		 id,
		 group_id,
		 is_open,
		 `type`,
		 time_type,
		 open_time,
		 start_time,
		 end_time,
		 need_num,
		 item
		 FROM 
		 t_activity_open_server_template where is_open=1;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"int",
				"int",
				"int",
				"int",
				"string",
				"int",
				"int",
				"int",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	
	public function getDescriptC(){
		$sql = 
		"SELECT 	id,  content from
	t_descript_template  ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",NULL,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	
	public function getTitle(){
		$sql = 
		"SELECT 	id, 
	NAME, 
	TYPE, 	
	`character`, 
	`data`,
	`describe`,	
	pic
	FROM 
	t_title_template  ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string",
				"int",
				"int",
				"string",
				"string",
				"string"				
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getActivityPvpTemplate(){
		$sql = 
		"SELECT 	id, 
	name, 
	min_level, 	
	open_time, 
	npc,
	description,
	awards_id,
	award_type
	FROM 
	t_activity_pvp_template  ;";
			$r = sql_fetch_rows($sql);
	    	$o = array();
			if($r != ""){
				$count = count($r);
				$lable = array(
				"int",
				"string",
				"int",
				"string",
				"int",
				"string",
				"string",
				"int"
				);
				for ($i = 0 ; $i < $count; $i++){
					$item = $r[$i];
					$o[] = $item;
				}
				return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
			}
			else{
				return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
			}
	}
	
	public function getBossTemplate()
	{
		$sql = 
		"SELECT 	
		boss_id, 
		boss_type,
		map_id,
		relive_time,
		relive_time2,
		name,
		level,
		remark,
		dorp,
		relive_position,
		transport_position
		FROM 
		t_boss_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"int",
			"int",
			"int",
			"string",
			"string",
			"int",
			"string",
			"string",
			"string",
			"string"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getActivityTemplate()
	{
		$sql = 
		"SELECT 	
		active_id,
		active_name,
		is_open,
		open_time,
		min_level,
		npc_id,
		descrition,
		award_id,
		award_type,
		maps_id
		FROM 
		t_activity_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"string",
			"byte",
			"string",
			"int",
			"int",
			"string",
			"string",
			"int",
			"string"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}

	public function getYellowBoxTemplate()
	{
		$sql = 
		"SELECT 	
		id,
		`type`,
		`level`,
		awards_type,
		awards
		FROM 
		t_yellow_box_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"int",
			"int",
			"int",
			"string"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getClubCampCallTemplate()
	{
		$sql = 
		"SELECT 	
		id,
		type,
		name,
		guild_level,
		dorp,
		guild_money
		FROM 
		t_guild_summon_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"int",
			"string",
			"int",
			"string",
			"int"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getActSevenTemplate()
	{
		$sql = 
		"SELECT 	
		id,
		title,
		content,
		awards,
		item,
		count,
		end_time
		FROM 
		t_activity_seven_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"string",
			"string",
			"string",
			"int",
			"int",
			"int"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getGuildPrayerTemplate()
	{
		$sql = 
		"SELECT 	
		id,
		item_id
		FROM 
		t_guild_prayer_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",			
			"int"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getEntrustmentTemplate()
	{
		$sql = 
		"SELECT 	
		id,
		duplicate_id,
		floor,
		level,
		fight,
		cost_copper,
		cost_time,
		cost_yuanbao,
		copper,
		exp,
		life_exp,
		item_ids
		FROM 
		t_shenyou_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",			
			"string"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getRefinedTemplate()
	{
		$sql = 
		"SELECT 	
		template_id,
		level,
		total_hp,
		total_mp,
		attack,
		defence,
		property_attack,
		magic_defense,
		far_defense,
		mump_defense
		FROM 
		t_mounts_refined_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int",
			"int"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
	
	public function getItemFusionTemplate()
	{
		$sql = 
		"SELECT 	
		item_template_id1,
		item_template_id2,
		fusion_num,
		fusion_template_id
		FROM 
		t_item_fusion_template;";
		$r = sql_fetch_rows($sql);
		$o = array();
		if($r != ""){
			$count = count($r);
			$lable = array(
			"int",
			"int",
			"int",
			"int"
			);
			for ($i = 0 ; $i < $count; $i++){
				$item = $r[$i];
				$o[] = $item;
			}
			return new DataResult(ResultStateLevel::SUCCESS,"1",$lable,$o);
		}
		else{
			return new DataResult(ResultStateLevel::ERROR,"0",NULL,NULL);
		}
	}
}
?>