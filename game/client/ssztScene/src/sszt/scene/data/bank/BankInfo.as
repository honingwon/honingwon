package sszt.scene.data.bank
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class BankInfo extends EventDispatcher
	{
		public var InfoDic:Dictionary;
		public static const MONEY:Array = [100,500,1000,3000,5000,10000];
		
		public function BankInfo()
		{
			super();
			InfoDic = new Dictionary();
			var info:BankInfoItem;
			for(var i:int=0;i<MONEY.length;i++)
			{
				info = new BankInfoItem();
				info.type = i;
				info.money = MONEY[i];
				InfoDic[i] = info;
			}		
		}
		
		public function updateBankInfo():void
		{
			dispatchEvent(new BankInfoEvent(BankInfoEvent.BANK_INFO_UPDATE));
		}
	}
}