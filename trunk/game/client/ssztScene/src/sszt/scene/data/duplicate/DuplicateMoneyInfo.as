package sszt.scene.data.duplicate
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.MoneyType;
	import sszt.scene.events.SceneDuplicateMoneyUpdateEvent;
	
	public class DuplicateMoneyInfo extends EventDispatcher
	{
		public var state:int;			//当前状态战斗中或拾取中
		public var leftTime:int;
		public var pickUpTime:int;
		public var bindCopper:int;
		public var bindYuanbao:int;
		public var killNum:int;
		public var killBoss:int;
		public var maxBatterNum:int;
		public var cutterBatterNum:int;
		public var batterTickTime:int;
		
		public static var comboBatterAward:Array = [{num:100,value:10},{num:200,value:20},{num:300,value:30},{num:400,value:40},{num:500,value:50}];
		
		public function DuplicateMoneyInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function clearData():void
		{
			state = 0;
			leftTime = 0;
			pickUpTime = 0;
			bindCopper = 0;
			bindYuanbao = 0;
			killNum = 0;
			killBoss = 0;
			maxBatterNum = 0;
			cutterBatterNum = 0;
			batterTickTime = 0;
		}
		public function updataComboBatter(batterNum:int, tickTime:int, money:int):void//更新连击数 同时更新绑定铜币奖励与最高连击数
		{
			if(batterNum > 0)
			{
				batterTickTime = tickTime;
				bindCopper += money;
				killNum ++;
				if (batterNum > maxBatterNum)
				maxBatterNum  = batterNum;
			}
			cutterBatterNum = batterNum;
			dispatchEvent(new SceneDuplicateMoneyUpdateEvent(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO));
		}
		
		public function updateComboTickState():void
		{
			state = 0;
			dispatchEvent(new SceneDuplicateMoneyUpdateEvent(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO_STATE));
		}
		
		public function updateKillBoss(tTime:int):void//停止连斩计算时间
		{
			state = 1;
			killBoss ++;
			pickUpTime = tTime;
			dispatchEvent(new SceneDuplicateMoneyUpdateEvent(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_KILL_BOSS));
		}
		public function  randMoneyStop(num:int):void
		{
			dispatchEvent(new SceneDuplicateMoneyUpdateEvent(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_RAND_MONEY_STOP, num));
		}
			
		public function updatePickUpMoney(type:int, value:int):void//拾取货币时候更新
		{
			if(type == MoneyType.CURRENCY_TYPE_BIND_COPPER)
				bindCopper += value;
			else if(type == MoneyType.CURRENCY_TYPE_BIND_YUANBAO)
				bindYuanbao += value;
			dispatchEvent(new SceneDuplicateMoneyUpdateEvent(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_PICKUP_MONEY));
		}
	}
}