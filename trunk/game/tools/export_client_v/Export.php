<?php
require_once(dirname(__FILE__).'/api/Provider.php');
require_once(dirname(__FILE__).'/lib/SqlResult.php');
require_once(dirname(__FILE__).'/Package/PackageIn.php');
require_once(dirname(__FILE__).'/Package/PHPPack.php');

ini_set("memory_limit","-1");

$fp = fopen("sm.data",'wb')or die("cannot open a.dat"); 
$str = pack("C",0); 		//v
fwrite($fp,$str);
$str = pack("C",0); 		//v
fwrite($fp,$str);
$str = pack("C",1); 		//v
fwrite($fp,$str);


$str = pack("C",63); 		//len

fwrite($fp,$str);

savaAll($fp);


fclose($fp);
echo "export suc","\n";

function savaAll($fp)
{
	$d = Provider::getInstance()->getDoorList();
	sava($d,$fp,5);
	
	$d = Provider::getInstance()->getBufList();
	sava($d,$fp,6);
	
	$d = Provider::getInstance()->getItemList();
	sava($d,$fp,7);
	
	$d = Provider::getInstance()->getMapList();
	sava($d,$fp,8);
	
	$d = Provider::getInstance()->getMonsterList();
	sava($d,$fp,9);
	
	$d = Provider::getInstance()->getMovieList();
	sava($d,$fp,10);
	
	$d = Provider::getInstance()->getNpcList();
	sava($d,$fp,11);
	
	$d = Provider::getInstance()->getExpList();
	sava($d,$fp,12);
	
	$d = Provider::getInstance()->getShopList();
	savaShopDetail($d,$fp,13);
	
	$d = Provider::getInstance()->getSkillList();
	sava($d,$fp,14);
	
	$d = Provider::getInstance()->getTaskList();
	savaTaskDetail($d,$fp,15);
	
	$d = Provider::getInstance()->getCollectList();
	sava($d,$fp,17);
	
	$d = Provider::getInstance()->getDuplicateList();
	sava($d,$fp,18);
	
	$d = Provider::getInstance()->getVeinsList();
	sava($d,$fp,19);
	
	$d = Provider::getInstance()->getGuildsTemplate();
	sava($d,$fp,20);
	
	$d = Provider::getInstance()->getGuildsFurnaceLevelTemplate();
	sava($d,$fp,21);
	
	$d = Provider::getInstance()->getGuildsShopLeveTemplate();
	sava($d,$fp,22);
	
	$d = Provider::getInstance()->getStrengthenTemplate();
	sava($d,$fp,23);
	
	$d = Provider::getInstance()->getItemStoneTemplate();
	sava($d,$fp,24);	
	
	$d = Provider::getInstance()->getPickStoneTemplate();
	sava($d,$fp,25);
		
	$d = Provider::getInstance()->getItem_Uplevel_Template();
	sava($d,$fp,26);
	
	$d = Provider::getInstance()->getItem_Upgrade_Template();
	sava($d,$fp,27);
	
	$d = Provider::getInstance()->getBoxTemplate();
	sava($d,$fp,28);
	
	$d = Provider::getInstance()->getFormulaTemplate();
	sava($d,$fp,29);
	
	$d = Provider::getInstance()->getFireBoxSortTemplate();
	sava($d,$fp,30);
	
	$d = Provider::getInstance()->getFormulaTableTemplate();
	sava($d,$fp,31);
	
	$d = Provider::getInstance()->getFormulaTemplate2();
	sava($d,$fp,32);
	
	$d = Provider::getInstance()->getSuitNumTemplate();
	sava($d,$fp,33);
	
	$d = Provider::getInstance()->getMountsExpTemplate();
	sava($d,$fp,34);
	
	$d = Provider::getInstance()->getMountsDiamondTemplate();
	sava($d,$fp,35);
	
	$d = Provider::getInstance()->getMountsStarTemplate();
	sava($d,$fp,36);
	
	$d = Provider::getInstance()->getMountsGrowUpTemplate();
	sava($d,$fp,37);
	
	$d = Provider::getInstance()->getMountsQualificationTemplate();
	sava($d,$fp,38);

	$d = Provider::getInstance()->getPetTemplate();
	sava($d,$fp,39);
	
	$d = Provider::getInstance()->getPetExpTemplate();
	sava($d,$fp,40);
	
	$d = Provider::getInstance()->getPetDiamondTemplate();
	sava($d,$fp,41);
	
	$d = Provider::getInstance()->getPetStarTemplate();
	sava($d,$fp,42);
	
	$d = Provider::getInstance()->getPetGrowUpTemplate();
	sava($d,$fp,43);
	
	$d = Provider::getInstance()->getPetQualificationTemplate();
	sava($d,$fp,44);
	
	$d = Provider::getInstance()->getPetGrowUpExpTemplate();
	sava($d,$fp,45);
	
	$d = Provider::getInstance()->getPetQualificationExpTemplate();
	sava($d,$fp,46);
		
	$d = Provider::getInstance()->getVipTemplate();
	sava($d,$fp,47);
	
	$d = Provider::getInstance()->getdecomposcopperTemplate();
	sava($d,$fp,48);
	
	$d = Provider::getInstance()->getenchasecopperTemplate();
	sava($d,$fp,49);
	
	$d = Provider::getInstance()->getcomposecopperTemplate();
	sava($d,$fp,50);
	
	$d = Provider::getInstance()->getDuplicateMissionList();
	sava($d,$fp,51);
	
	$d = Provider::getInstance()->getVeinsExtraList();
	sava($d,$fp,52);
	
	$d = Provider::getInstance()->getActiveTemplate();
	sava($d,$fp,53);
	
	$d = Provider::getInstance()->getActiveRewardsTemplate();
	sava($d,$fp,54);
	
	$d = Provider::getInstance()->getActivityTaskTemplate();
	sava($d,$fp,55);
	
	$d = Provider::getInstance()->getEquipStrengthenTemplate();
	sava($d,$fp,56);
	
	$d = Provider::getInstance()->getDailyAwardTemplate();
	sava($d,$fp,57);
	
	$d = Provider::getInstance()->getTwelfare();
	sava($d,$fp,58);
	
	$d = Provider::getInstance()->getTwelfareExp();
	sava($d,$fp,59);
	
	$d = Provider::getInstance()->getItemCategoryTemplate();
	sava($d,$fp,60);
	
	$d = Provider::getInstance()->getSuitPropsTemplate();
	sava($d,$fp,61);
	
	$d = Provider::getInstance()->getTokentask();
	sava($d,$fp,62);
	
	$d = Provider::getInstance()->getTarget();
	sava($d,$fp,63);
	
	$d = Provider::getInstance()->getTitle();
	sava($d,$fp,64);
	
	$d = Provider::getInstance()->getChallengeDup();
	sava($d,$fp,65);
	
	$d = Provider::getInstance()->getActivityPvpTemplate();
	sava($d,$fp,66);
	
	$d = Provider::getInstance()->getBossTemplate();
	sava($d,$fp,67);
	
	$d = Provider::getInstance()->getamityTemplate();
	sava($d,$fp,68);
	
}


function sava($d,$fp,$type){
	$pk = new PackageIn();

	$r = $d->DataList;
	$count = count($r);
	$lable = $d->Tag;
	$pk->writeInt($count);
	for ($i = 0 ; $i < $count; $i++){
		foreach($r[$i] as $key=>$value){
			switch($lable[$key]){
				case "int" :
					$pk->writeInt($value);
					break;
				case "string" :
					$pk->writeUTF($value);
					break;
				case "byte" :
					$pk->writeByte($value);
					break;
				case "short" :
					$pk->writeShort($value);
					break;
			}
		}	
	}
	
	$str = pack("C",$type); 		//type
	fwrite($fp,$str);
	$str = pack("N",$pk->len); 	//len
	fwrite($fp,$str);
	mypack($fp,$pk->data->format,$pk->data->params);
	
}


function savaTaskDetail($d,$fp,$type){
	$pk = new PackageIn();
	
	$r = $d->DataList;
	$count = count($r);
	$lable = $d->Tag;
	$pk->writeInt($count);
	for ($i = 0 ; $i < $count; $i++){
		foreach($r[$i] as $key=>$value){
			switch($lable[$key]){
				case "int" :
					$pk->writeInt($value);
					break;
				case "string" :
					$pk->writeUTF($value);
					break;
				case "byte" :
					$pk->writeByte($value);
					break;
				case "short" :
					$pk->writeShort($value);
					break;
			}
		}
	
		//所有状态任务的物品奖励之和
		//目前数据库中数据没填充完成
		
		$pk->writeInt(0);
		
		//单个任务状态信息包含单轮任务奖励信息。
		$d1 = Provider::getInstance()->getTaskStateList($r[$i][0]);
		$r1 = $d1->DataList;
		$count1 = count($r1);
		$lable1 = $d1->Tag;
		$pk->writeInt($count1);
		
		for ($j = 0 ; $j < $count1; $j++){
			foreach($r1[$j] as $key1=>$value1){
				switch($lable1[$key1]){
					case "int" :
						$pk->writeInt($value1);
						break;
					case "string" :
						$pk->writeUTF($value1);
						break;
					case "byte" :
						$pk->writeByte($value1);
						break;
					case "short" :
						$pk->writeShort($value1);
						break;
				}
			}
			//如果task_award_id为空
			if($r1[$j][19] == "")
			{
				$pk->writeInt(0);
			}
			else
			{
				//获取状态表中task_award_id字段，并转为数组
				$task_award_ids = explode(",", $r1[$j][19]);
				$d2 = Provider::getInstance()->getTaskAwardList($task_award_ids);
				$r2 = $d2->DataList;
				$count2 = count($r2);
				$lable2 = $d2->Tag;
				$pk->writeInt($count2);
				for ($k = 0 ; $k < $count2; $k++){
					foreach($r2[$k] as $key2=>$value2){
						switch($lable2[$key2]){
							case "int" :
								$pk->writeInt($value2);
								break;
							case "string" :
								$pk->writeUTF($value2);
								break;
							case "byte" :
								$pk->writeByte($value2);
								break;
							case "short" :
								$pk->writeShort($value2);
								break;
						}
					}
				}
			}
		}
	}
	
	$str = pack("C",$type); 		//type
	fwrite($fp,$str);
	$str = pack("N",$pk->len); 	//len
	fwrite($fp,$str);
	mypack($fp,$pk->data->format,$pk->data->params);
	
}


function savaShopDetail($d,$fp,$type){
	$pk = new PackageIn();
	
	$r = $d->DataList;
	$count = count($r);
	$lable = $d->Tag;
	$pk->writeByte($count);
	for ($i = 0 ; $i < $count; $i++){
		foreach($r[$i] as $key=>$value){
			switch($lable[$key]){
				case "int" :
					$pk->writeInt($value);
					break;
				case "string" :
					$pk->writeUTF($value);
					break;
				case "byte" :
					$pk->writeByte($value);
					break;
				case "short" :
					$pk->writeShort($value);
					break;
			}
		}
		
		$d1 = Provider::getInstance()->getShopCategoryList($r[$i][0]);
		
		$r1 = $d1->DataList;
		$count1 = count($r1);
		$lable1 = $d1->Tag;
		$pk->writeByte($count1);
		
		for ($j = 0 ; $j < $count1; $j++){
			$pk->writeUTF($r1[$j][1]);
			
			$d2 = Provider::getInstance()->getShopItemsList($r1[$j][0],$r[$i][0]);
		
			$r2 = $d2->DataList;
			$count2 = count($r2);
			$lable2 = $d2->Tag;
			$pk->writeShort($count2);
			
			for ($j1 = 0 ; $j1 < $count2; $j1++){
				foreach($r2[$j1] as $key1=>$value1){
					switch($lable2[$key1]){
						case "int" :
							$pk->writeInt($value1);
							break;
						case "string" :
							$pk->writeUTF($value1);
							break;
						case "byte" :
							$pk->writeByte($value1);
							break;
						case "short" :
							$pk->writeShort($value1);
							break;
					}
				}	
			}
			
		}
		
	}
	
	$str = pack("C",$type); 		//type
	fwrite($fp,$str);
	$str = pack("N",$pk->len); 	//len
	fwrite($fp,$str);
	mypack($fp,$pk->data->format,$pk->data->params);
	
}


function mypack($fp,$format,$params)
{
	
	
	$fun = "\$str = pack('".$format."',".join(",",$params).");";
	
	eval ($fun);  
  	
	fwrite($fp,$str);
	
}

?>
