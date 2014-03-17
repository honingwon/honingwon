package sszt.core.data.club
{
	import flash.utils.ByteArray;
	
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.LayerInfo;
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.skill.SkillAdditionType;

	public class ClubSkillTemplate extends LayerInfo
	{
//		public var templateId:int;
		public var name:String;
		public var effect:Array;
		public var type:int;          //1buff，2被动
		public var needLevel:Array;
		public var totalLevel:int;
		public var needMoney:Array;   //帮会资金
		public var needTotalExploit:Array; //历史总贡献
		public var needSelfExploit:Array; //消耗贡献
		
		public var buffList:Array;
		
		
		public function ClubSkillTemplate()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			name = data.readUTF();
			picPath = data.readUTF();
//			picPath = "312201";
			iconPath = picPath;
			effect = data.readUTF().split("#");
			type = data.readInt();
			needLevel = data.readUTF().split("#");
			needMoney = data.readUTF().split("#");
			needTotalExploit = data.readUTF().split("#");
			needSelfExploit = data.readUTF().split("#");
			buffList = data.readUTF().split(",");
			totalLevel = needLevel.length;
		}
		
		public function getEffectToString(level:int):String
		{
			var str:String = effect[level-1];
			var result:String = "";
			var array1:Array = new Array();
			var array2:Array = new Array();
			var i:int;
			if(str != "undefined" && str != "")
			{
				array1 = str.split("|");
				for(i =0; i < array1.length; i++)
				{
					array2 = array1[i].split(",");
					if(array2[1] != 0)
					{
						if(result.length > 1)result += "\n";
						result += SkillAdditionType.getStringByType(array2[0]);
						if(array2[0] != SkillAdditionType.HITDOWN && array2[0] != SkillAdditionType.TARGET_RELIVE)
						{
							if(array2[1] > 0)result += "+";
							result += array2[1];
							if(array2[0] == SkillAdditionType.CLUB_EXP || array2[0] == SkillAdditionType.CLUB_TRANSPORT) result += "%";
						}
					}
				}
			}else
			{
				var buffInfo:BuffTemplateInfo = BuffTemplateList.getBuff(buffList[level-1]);
				if(buffInfo)
				{
					var list:Array = buffInfo.skillEffectList;
					for(i = 0; i < list.length; i++)
					{
						array2 = list[i].split(",");
						if(array2[1] != 0)
						{
							if(result.length > 1)result += "\n";
							result += SkillAdditionType.getStringByType(array2[0]);
							if(array2[0] != SkillAdditionType.HITDOWN && array2[0] != SkillAdditionType.TARGET_RELIVE)
							{
								if(array2[1] > 0)result += "+";
								result += array2[1];
								if(array2[0] == SkillAdditionType.ATTACK_ATTR) result += "%";
							}
						}
					}
				}
			}
			return result;
		}	
	}
}