package sszt.core.data.veins
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	
	public class VeinsList extends EventDispatcher
	{
		private var _list:Array;
		private var _currentVeins:VeinsInfo;
		/**
		 * 正在升级穴位剩余时间
		 */
		public var veinsCD:Number;
		/**
		 * 正在升级的穴位的模版编号
		 */
		public var veinsAcupointUping:int;
		public var hasInit:Boolean;
		
		
		public function VeinsList()
		{
			_list = [];
			veinsCD = 0;
			veinsAcupointUping = 0;
		}
		
		public function addVeins(veins:VeinsInfo):void
		{
			_list.push(veins);			
			dispatchEvent(new VeinsListUpdateEvent(VeinsListUpdateEvent.ADD_VEINS,veins));
		}
		
		public function getDefaultSelectAcupoint():int//获取默认选择的穴位
		{
			if(veinsAcupointUping > 0 )//如果有穴位正在升级，那么选择该穴位
				return veinsAcupointUping - 1;
			else
			{
				var acupointType:int = 0;
				var lv:int = 0;
				for each(var i:VeinsInfo in _list)
				{
					if(i.acupointLv > 0 &&( lv < i.acupointLv || (acupointType < i.acupointType && lv <= i.acupointLv)))
					{
						acupointType = i.acupointType;
						lv = i.acupointLv;
					}
				}
				if(acupointType == AcupointType.YONGQUAN)
					acupointType = 0;
				return acupointType;
			}
		}
		
		public function getVeinsByAcupointType(type:int):VeinsInfo
		{
			for each(var i:VeinsInfo in _list)
			{
				if(i.acupointType == type)return i;
			}
			return null;
		}
		
		public function getTotalGengu():int
		{
			var ret:int = 0;
			for each(var i:VeinsInfo in _list)
			{
				ret += i.genguLv;
			}
			return ret;
		}
		
		public function getAcupointLvByAcupointType(type:int):int
		{
			for each(var i:VeinsInfo in _list)
			{
				if(i.acupointType == type)return i.acupointLv;
			}
			return 0;			
		}
		public function getCurrrntVeins():VeinsInfo
		{
			return _currentVeins;
		}		
		public function getVeinsList():Array
		{
			return _list;
		}
		
		//dispatchEvent
		public function dataUpdate(strEvt:String, obj:Object = null):void
		{
			dispatchEvent(new VeinsListUpdateEvent(strEvt, obj));
		}
	}
}