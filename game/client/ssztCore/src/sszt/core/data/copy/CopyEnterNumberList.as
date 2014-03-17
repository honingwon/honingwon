package sszt.core.data.copy
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.map.MapTemplateList;

	public class CopyEnterNumberList extends EventDispatcher
	{
		public var list:Dictionary;         //当天进入副本次数列表
		public var list2:Dictionary;         //当天已经重置副本次数列表
		public var isApply:Boolean;         //是否申请了副本
		public var applyId:int;             //申请的副本ID
		public var lastCancelTime:Number;   //上次取消进入副本时间
		public var isInCopy:Boolean;        //是否已在副本中
		public var inCopyId:int;            //当前所在副本ID,模版ID
		
		public var currentLevel:int;        //当前波数
		public var total:int;               //总波数
		public var nextTime:int;            //下一波出现时间
		
		public var pkEnterTime:Number = 0;  //进入PK副本时间
		
		public static const SETDATACOMPLETE:String = "setDataComplete";
		
		public function CopyEnterNumberList()
		{
			list = new Dictionary();
			list2 = new Dictionary();
			isApply = false;
		}
		
		public function addItem(id:int,count:int):void
		{
			list[id] = count;
		}
		
		public function setData(ids:Array,counts:Array):void
		{
			for(var i:int = 0;i<ids.length;i++)
			{
				list[ids[i]] = counts[i];
			}
			dispatchEvent(new Event(SETDATACOMPLETE));
		}
		
		public function setResetCostTimeData(ids:Array,resetCostTimeArr:Array):void
		{
			for(var i:int = 0;i<ids.length;i++)
			{
				list2[ids[i]] = resetCostTimeArr[i];
			}
			dispatchEvent(new Event(SETDATACOMPLETE));
		}
		
		public function changeItem(id:int,count:int):void
		{
			list[id] = count;
		}
		
		public function getItemCount(id:int):int
		{
			if(list[id]) return list[id];
			return 0;
		}
		public function getItemResetCostCount(id:int):int
		{
			if(list2[id]) return list2[id];
			return 0;
		}
		
		public function apply(id:int):void
		{
			applyId = id;
			isApply = true;
			dispatchEvent(new CopyEvent(CopyEvent.COPYAPPLY,id));
		}
		
		/***************特殊处理*************************************/
		//是否删除广播格外的东西
		public function isRemoveOther():Boolean
		{
			if(isInCopy)
			{
				if(inCopyId == 518002)
				{
					return false;
				}
			}
			if(!MapTemplateList.needClearOutBrost())return false;
			return true;
		}
		/**
		 * 是否采集副本场景
		 * @return 
		 * 
		 */		
		public function isCopyCollectScene():Boolean
		{
			if(isInCopy && inCopyId == 518002)return true;
			return false;
		}
		
		/**
		 *是否pk副本 
		 * @return 
		 * 
		 */		
		public function isPKCopy():Boolean
		{
			if(isInCopy && inCopyId == 518004) return true;
			return false;
		}
		
		/**
		 *是否守塔副本 
		 */
		public function isTowerCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 3;
			else return false;
		}
		/**
		 *是否爬塔副本 
		 */
		public function isPassCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 4;
			else return false;
		}
		/**
		 *是否普通副本 
		 */
		public function isNormalCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 1;
			else return false;
		}
		public function isPVPCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 21;
			else return false;
		}
		public function isChallengeCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 8;
			else return false;
		}
		/**
		 *是否打钱副本 
		 */
		public function isMoneyCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 7;
			else return false;
		}
		/**
		 *是否藏宝副本 
		 */
		public function isTreasureCopy():Boolean
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(inCopyId);
			if(copy) return isInCopy && copy.type == 6;
			else return false;
		}
	}
}