package sszt.core.data.openActivity
{
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;

	/**
	 * 
	 * @author chendong
	 */	
	public class OpenActivityUtils
	{
		/**
		 * 当前开服活动类型 1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级
		 */
		public static var currentType:int = 2;
		
		/**
		 * 返回模板数据
		 * @param type 
		 * @return 
		 * 
		 */		
		public static function getActivityArray(type:int):Array
		{
			var opAct:Array = [];
			switch(type)
			{
				case 1:
					opAct = OpenActivityTemplateList.activityTypeOneArray;
					break;
				case 2:
					opAct = OpenActivityTemplateList.activityTypeTwoArray;
					break;
				case 3:
					opAct = OpenActivityTemplateList.activityTypeThreeArray;
					break;
				case 41:
					opAct = OpenActivityTemplateList.activityTypeFour1Array;
					break;
				case 42:
					opAct = OpenActivityTemplateList.activityTypeFour2Array;
					break;
				case 43:
					opAct = OpenActivityTemplateList.activityTypeFour3Array;
					break;
				case 44:
					opAct = OpenActivityTemplateList.activityTypeFour4Array;
					break;
				case 51:
					opAct = OpenActivityTemplateList.activityTypeSixArray1;
					break;
				case 52:
					opAct = OpenActivityTemplateList.activityTypeSixArray2;
					break;
				case 53:
					opAct = OpenActivityTemplateList.activityTypeSixArray3;
					break;
				case 6:
					opAct = OpenActivityTemplateList.activityTypeSevenArray;
					break;
				case 71:
					opAct = OpenActivityTemplateList.activityTypeEightArray1;
					break;
				case 72:
					opAct = OpenActivityTemplateList.activityTypeEightArray2;
					break;
				case 73:
					opAct = OpenActivityTemplateList.activityTypeEightArray3;
					break;
				case 74:
					opAct = OpenActivityTemplateList.activityTypeEightArray4;
					break;
				case 81:
					opAct = OpenActivityTemplateList.activityTypeRecArray1;
					break;
				case 82:
					opAct = OpenActivityTemplateList.activityTypeRecArray2;
					break;
				case 83:
					opAct = OpenActivityTemplateList.activityTypeRecArray3;
					break;
				case 84:
					opAct = OpenActivityTemplateList.activityTypeRecArray4;
					break;
				case 85:
					opAct = OpenActivityTemplateList.activityTypeRecArray5;
					break;
				case 86:
					opAct = OpenActivityTemplateList.activityTypeRecArray6;
					break;
			}
			return opAct;
		}
		
		/**
		 * 获得获得奖励是否被领取 -1:不存在 0:不可领  1:可领取 2:已领 3：已经过期
		 * @param groupId 2:"充值礼包"，3："消费礼包",4："冲级礼包"
		 * @param activityId 活动id
		 * @param needNum 活动累计数量
		 */		
		public static function getedActivity(groupId:int,activityId:int,needNum:int):int
		{
			var returBoolean:Boolean;
			var state:int = 0; // -1:不存在,0:不可领  1:可领取 2:已领
			var obj:Object = GlobalData.openActivityInfo.activityDic[groupId];
			var tempGroupId:int = groupId/10;
			var now:int = GlobalData.systemDate.getSystemDate().valueOf()*0.001;
			if(obj)
			{
				if(int(obj.openTime) > now)
				{
					var idArray:Array = obj.idArray as Array;
					if(idArray.indexOf(activityId) > -1)
					{
						state = 2;
					}
					else
					{
						if(tempGroupId == 4)
						{
							if(obj.totalValue > 0)
							{
								state = 1;
							}
							else
							{
								state = 0;
							}
						}
						else
						{
							if(obj.totalValue >= needNum)
							{
								state = 1;
							}
							else
							{
								state = 0;
							}
						}
					}
				}
				else
				{
					state = 3;
				}
			}
			else
			{
				state = -1;
			}
			return state;
		}
		
		/**
		 * 获得当前最大值
		 * @param currentType 当前类型
		 * @param currentValue 当前值
		 */		
		public static function getCurrentMaxValue(currentType:int,currentValue:int):int
		{
			var opAct:Array = getActivityArray(currentType);
			var currctivityInfo:OpenActivityTemplateListInfo;
			var i:int = 0;
			for(;i<opAct.length;i++)
			{
				currctivityInfo = opAct[i];
				if(currentValue <= currctivityInfo.need_num)
				{
					break;
				}
			}
			return currctivityInfo.need_num;
		}
		
		public static function remainTimeString(timeNum:Number):String
		{
//			var remain:CountDownInfo = DateUtil.getCountDownByEndDay(timeNum * 1000);
			var remain:CountDownInfo = DateUtil.getCountDownByDay(GlobalData.systemDate.getSystemDate().valueOf(),timeNum * 1000);
			var result:String = "";
			
			remain.days > 0 ? result += LanguageManager.getWord("ssztl.common.dayValue",remain.days) : "";
			remain.hours > 0 ? result += LanguageManager.getWord("ssztl.common.hour",remain.hours): "";
			remain.minutes > 0 ? result += LanguageManager.getWord("ssztl.common.minuteValue",remain.minutes) : "";
			remain.seconds > 0 ? result += LanguageManager.getWord("ssztl.common.secondValue",remain.seconds) : "";
			if(result == "")
			{
				LanguageManager.getWord("ssztl.common.passDayLine");
			}
			return result;
		}
		
		public static function getEndTime(seconds:Number):String
		{
			var currMis:Number = seconds*1000;
			if(GlobalData.systemDate.getSystemDate().valueOf() > currMis)
			{
				return "已经过期";
			}
			var date:Date=new Date(currMis);
			var year:String=String(date.getFullYear());
			var month:String=String((date.getMonth()+1)<10?"0":"")+(date.getMonth()+1);
			var day:String=String(date.getDate()<10?"0":"")+(date.getDate());
			var hours:String=String(date.getHours()<10?"0":"")+date.getHours();
			var min:String=String(date.getMinutes()<10?"0":"")+date.getMinutes();
			var second:String=String(date.getSeconds()<10?"0":"")+date.getSeconds();
			return "至"+year+"年"+month+"月"+day+"日 "+hours+":"+min+":"+second;
		}
	}
}