package sszt.core.data.mounts.mountsSkill
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.skill.SkillAdditionType;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	
	public class MountsSkillInfo extends SkillItemInfo
	{
		public var mountsId:Number;
		public var place:int;
		
		public function MountsSkillInfo()
		{
		}
		
		public function getEffectToString(level:int, showBuff:Boolean = true):String
		{
			var templateInfo:SkillTemplateInfo = getTemplate();
			var str:String = templateInfo.skillEffectList[level-1];
			var result:String = "";
			var i:int;
			var array1:Array = [] ;
			var array2:Array = [];
			
			//fuck 蹩脚的数据库配置信息 把 4,x|5,x|6.x 改为 26,x
			var tmpArray:Array = str.split("|");
			var tmpArray2:Array = [];
			var add:Boolean;
			for(i = 0; i < tmpArray.length; i++)
			{
				tmpArray2 = String(tmpArray[i]).split(',');
				
				if(tmpArray2[0] != '4' && tmpArray2[0] != '5' && tmpArray2[0] != '6' )
				{
					array1.push(tmpArray[i]);
				}
				else
				{
					if(!add)
					{
						
						array1.push('26,' + tmpArray2[1]);
						add = true;
					}
				}
			}
			
			
			if(str != null && str != "undefined" && str != "")
			{
				for(i =0; i < array1.length; i++)
				{
					array2 = array1[i].split(",");
					if(array2[1] != 0)
					{
						if(result.length > 1)result += "\n";
						var nubStr:String = "";
						
						//添加‘主人’ 前缀
						result += LanguageManager.getWord('ssztl.common.employer');
						
						if(int(array2[0])==SkillAdditionType.ACTOR_ATTACK&&int(array2[1])>0)
						{
							result += LanguageManager.getWord("ssztl.common.attackAddition") + '+' + array2[1];
							continue;
						}
//						else if(int(array2[0])==SkillAdditionType.ACTOR_MAGICATTACK&&int(array2[1])>0)
//						{
//							result += LanguageManager.getWord("ssztl.common.internalAttackAdd",array2[1]);
//							continue;
//						}
//						else if(int(array2[0])==SkillAdditionType.ACTOR_MUMPATTACK&&int(array2[1])>0)
//						{
//							result += LanguageManager.getWord("ssztl.common.outAttackAdd",array2[1]);
//							continue;
//						}
//						else if(int(array2[0])==SkillAdditionType.ACTOR_FARATTACK&&int(array2[1])>0)
//						{
//							result += LanguageManager.getWord("ssztl.common.farAttackAdd",array2[1]);
//							continue;
//						}
							//加成类效果
						else if(int(array2[0])==SkillAdditionType.ATTR_PHYSICS_HURT_ADD)
						{
							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
							else
								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.physicalAttack");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ATTR_MAGIC_HURT_ADD)
						{
							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
							else
								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.internalAttack");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ATTR_VINDICTIVE_HURT_ADD)
						{
							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
							else
								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.outAttack");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.ATTR_RANGE_HURT_ADD)
						{
							if(int(array2[1])<0)
								nubStr = (int(array2[1])+100).toString();
							else
								nubStr = array2[1].toString()
							result += nubStr+"%"+LanguageManager.getWord("ssztl.common.farHurt");
							continue;
						}
						else if(int(array2[0])==SkillAdditionType.HP_BACK_SPEED)
						{
							result = LanguageManager.getWord("ssztl.common.lifeBackSpeed",array2[1]);
							continue;
						}
						else
							result += SkillAdditionType.getStringByType(array2[0]);
						if(SkillAdditionType.needShowNum(array2[0]))
						{
							if(array2[1] > 0)result += "+";
							result += array2[1];
						}
					}
				}
			}
			if(templateInfo.buffList[level-1] != "0" && showBuff)
			{
				var arr:Array = templateInfo.buffList[level-1].split("|");
				for(var j:int = 0; j < arr.length; j++)
				{
					var buffInfo:BuffTemplateInfo = BuffTemplateList.getBuff(int(arr[j]));
					if(buffInfo)
					{
						if(result.length > 1)result += "\n"; 
						result += buffInfo.descript;
					}
				}
			}
			return result;
		}
	}
}