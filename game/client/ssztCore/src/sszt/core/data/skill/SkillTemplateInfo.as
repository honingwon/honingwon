package sszt.core.data.skill
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.LayerInfo;
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.manager.LanguageManager;
	
	public class SkillTemplateInfo extends LayerInfo
	{
		public var name:String;
		public var des:String;
		public var totalLevel:int;
		public var skillType:int;
		public var activeUseMp:Array;
		/**
		 * 起效方式：0主动，1被动，2辅助, 3宠物辅主，4宠物被动
		 */		
		public var activeType:int;
		/**
		 * 起效方向：0敌人，1自身，2自身团队
		 */		
		public var activeSide:int;
		/**
		 * 起效对象：0不区分，1玩家，2指定怪物
		 */		
		public var activeTargetType:int;
		/**
		 * 指定怪物有效
		 */		
		public var activeTargetMonsterList:Array;
		/**
		 * 指定装备种类
		 */		
		public var activeItemCategoryId:int;
		/**
		 * 指定装备
		 */		
		public var activeItemTemplateId:int;
		/**
		 * 冷却时间（毫秒）
		 */		
		public var coldDownTime:Array;
		/**
		 * 使用距离
		 */		
		public var range:Array;
		/**
		 * 攻击移动效果
		 */		
		public var attackEffect:Array;
		/**
		 * 被击效果
		 */		
		public var beattackEffect:Array;
		/**
		 * 是否默认技能
		 */		
		public var isDefault:Boolean;
		/**
		 * 吟唱时间
		 */		
		public var prepareTime:Array;
		/**
		 * 硬直时间
		 */		
		public var straightTime:Array;
		/**
		 * 位置
		 */		
		public var place:int;
		/**
		 * 职业
		 */		
		public var needCareer:int;
		/**
		 * 需要等级
		 */		
		public var needLevel:Array;
		/**
		 * 需要铜币
		 */		
		public var needCopper:Array;
		/**
		 * 需要历练
		 */		
		public var needLifeExp:Array;
		/**
		 * 作用半径
		 */
		public var radius:Array;
		/**
		 * 影响人数
		 */
		public var affectCount:Array;
		/**
		 *技能描述 
		 */
		public var descriptText:Array;
		/**
		 * 升级需要物品
		 */		
		public var needItemId:Array;
		
		/**
		 * 升级需要前置技能编号 
		 */		
		public var needSkillId:Array;
		
		public var needSkillLevel:Array;
		
		/**
		 * 需要贡献 
		 */		
		public var needFeats:Array;
		/**
		 * 技能效果
		 * 效果列表，#分割 （效果1，值1|效果2，值2#效果1，值1...)
		 */		
		public var skillEffectList:Array;
		/**
		 * 放法效果
		 */		
		public var actionEffect:String;
		/**
		 * 音效
		 */		
		public var sound:int;
		
		/**
		 * 是否单体攻击 
		 */		
		public var isSingleAttack:Boolean;
		/**
		 * 是否震动
		 */		
		public var isShake:Boolean;
		/**
		 * 状态类列表
		 */		
		public var buffList:Array;
		
		public function SkillTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			des = data.readUTF();
			templateId = data.readInt();
			activeUseMp = data.readUTF().split("|");//消耗MP组 |分割
			name = data.readUTF();
			picPath = data.readUTF();
			iconPath = picPath;
			activeItemCategoryId = data.readInt();
			activeItemTemplateId = data.readInt();
			activeSide = data.readInt();
			activeTargetMonsterList = data.readUTF().split("|");
			activeTargetType = data.readInt();
			activeType = data.readInt();
			skillType = data.readInt();
			coldDownTime = data.readUTF().split("|");
			attackEffect = data.readUTF().split("|");
			beattackEffect = data.readUTF().split("|");
			isDefault = data.readBoolean();
			range = data.readUTF().split("|");
			radius = data.readUTF().split("|");
			prepareTime = data.readUTF().split("|");
			straightTime = data.readUTF().split("|");
			place = data.readShort();
			needCareer = data.readByte();
			needCopper = data.readUTF().split("|");
			needLifeExp = data.readUTF().split("|");
			needLevel = data.readUTF().split("|");
			needItemId = data.readUTF().split("#");
			needSkillId = data.readUTF().split("|");
			needSkillLevel = data.readUTF().split("|");
			needFeats = data.readUTF().split("|");
			skillEffectList = data.readUTF().split("#");
			totalLevel = coldDownTime.length;
			affectCount = data.readUTF().split("|");
			descriptText = data.readUTF().split("|");
			actionEffect = data.readUTF();
			sound = data.readInt();
			isSingleAttack = data.readBoolean();
			isShake = data.readBoolean();
			buffList = data.readUTF().split("#");
		}
		
		/**
		 * 风位 
		 * @return 
		 * 
		 */		
		public function getActionEffect():Array
		{
			var ret:Array = actionEffect.split(",");
			if(ret.length >=0)
			{
				return [int(ret[0]),int(ret[1])];
			}
			else
			{
				return [0,0]; 
			}
			 
		}
		
		/**
		 * 攻击 
		 * @param level
		 * @return 
		 * 
		 */		
		public function getAttackEffect(level:int):Array
		{
			var str:String = attackEffect[level - 1];
			var array:Array = str.split(",");
			if(array.length == 2)
			{
				return array;
			}
			else
			{
				return [0,0]; 
			}
		}
		
		/**
		 * 被攻击 
		 * @param level
		 * @return 
		 * 
		 */		
		public function getBeAttackEffect(level:int):Array
		{
			var str:String = beattackEffect[level - 1];
			var array:Array = str.split(",");
			if(array.length == 2)
			{
				return array;
			}
			else
			{
				return [0,0]; 
			}
		}
		
		public function getPrepareTime(level:int):int
		{
			return int(prepareTime[level - 1]);
		}
		
		public function getRange(level:int):int
		{
			return int(range[level - 1]);
		}
		
		public function getTargetToString(level:int):String
		{
			var result:String = "";
			if(affectCount[level - 1]>1)
			{
				result = result + LanguageManager.getWord("ssztl.common.cloudCount",affectCount[level - 1]);
			}else
			{
				result = result + LanguageManager.getWord("ssztl.common.single");
			}
			return result;
		}
		
		public function getEffectToString(level:int, showBuff:Boolean = true):String
		{
			var str:String = skillEffectList[level-1];
			var result:String = "";
			var array1:Array = new Array();
			var array2:Array = new Array();
			var i:int;
			if(str != null && str != "undefined" && str != "")
			{
				array1 = str.split("|");
				for(i =0; i < array1.length; i++)
				{
					array2 = array1[i].split(",");
					if(array2[1] != 0)
					{
						if(result.length > 1)result += "\n";
						var nubStr:String = "";
						if(int(array2[0])==SkillAdditionType.ACTOR_ATTACK&&int(array2[1])>0)
						{
							result += LanguageManager.getWord("ssztl.common.attackAddition") + '+' + array2[1];
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ACTOR_MAGICATTACK&&int(array2[1])>0)
						{
							result += LanguageManager.getWord("ssztl.common.internalAttackAddition") + '+' + array2[1];
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ACTOR_MUMPATTACK&&int(array2[1])>0)
						{
							result += LanguageManager.getWord("ssztl.common.externalAttackAddition") + '+' + array2[1];
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ACTOR_FARATTACK&&int(array2[1])>0)
						{
							result += LanguageManager.getWord("ssztl.common.longDistanceAttackAddition") + '+' + array2[1];
							continue;
						}
						//加成类效果
						else if(int(array2[0])==SkillAdditionType.ATTR_PHYSICS_HURT_ADD)
						{
//							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
//							else
//								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.physicalAttack");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ATTR_MAGIC_HURT_ADD)
						{
//							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
//							else
//								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.internalAttack");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ATTR_VINDICTIVE_HURT_ADD)
						{
//							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
//							else
//								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.outAttack");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ATTR_RANGE_HURT_ADD)
						{
//							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
//							else
//								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.farHurt");
							continue;
						}
						else
							result += SkillAdditionType.getStringByType(array2[0]);
						if(SkillAdditionType.needShowNum(array2[0]))
						{
							if(array2[1] > 0)result += "+";
							result += array2[1];
//							已不用							
//							if(SkillAdditionType.needShowAdd(array2[0]))//加成类效果
//							{
//								if(array2[1] > 0)
//								{
//									result += "+" + (int(array2[1]) ) + "%";
//								}
//								else
//								{
//									result += (int(array2[1]) ) + "%";
//								}
//								
//							}
//							else
//							{
//								if(array2[1] > 0)result += "+";
//								result += array2[1];
//							}
						}
					}
				}
			}
			if(buffList[level-1] != "0" && showBuff)
			{
				var arr:Array = buffList[level-1].split("|");
				for(var j:int = 0; j < arr.length; j++)
				{
					var buffInfo:BuffTemplateInfo = BuffTemplateList.getBuff(int(arr[j]));
					if(buffInfo)
					{
						if(result.length > 1)result += "\n"; 
						result += buffInfo.descript;
//						var list:Array = buffInfo.skillEffectList;
//						for(i = 0; i < list.length; i++)
//						{
//							array2 = list[i].split(",");
//							if(array2[1] != 0)
//							{
//								if(result.length > 1)result += "\n";
//								result += LanguageManager.getWord("ssztl.common.target");
//								result += SkillAdditionType.getStringByType(array2[0]);
//								if(SkillAdditionType.needShowNum(array2[0]))
//								{
//									if(array2[1] > 0)result += "+";
//									if(array2.length > 2)result += array2[1] + "%";
//									else result += array2[1];
//										
//								}
//							}
//						}
					}
				}
			}
			return result;
		}
		
		public function unNeedTarget():Boolean
		{
			return activeSide == 1 || activeSide == 2;
		}
		public function isAttack():Boolean
		{
			return activeSide == 0;
		}
		
		public function isAssist():Boolean{
			return activeType == 2  ;
		}
		
		public function isActive():Boolean{
			return activeType == 0  ;
		}
		
		
		
	}
}