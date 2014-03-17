package sszt.core.data.player
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import sszt.core.manager.LanguageManager;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class PlayerMoneyResInfo extends EventDispatcher
	{
		public var yuanBao:int;
		public var bindYuanBao:int;
		public var copper:int;
		public var bindCopper:int;
		public var bankCopper:int;
		
		public function parseData(data:ByteArray):void
		{
			yuanBao = data.readInt();
			copper = data.readInt();
			bindCopper = data.readInt();
			bankCopper = data.readInt();
			bindYuanBao = data.readInt();
		}
		
		public function get allCopper():int
		{
			return bindCopper + copper;
		}
		
		public function updateMoney(yuanbao:int,copper:int,bindCopper:int,bankCopper:int,bindYuanBao:int):void
		{
			
			updateYuanbao(yuanbao);
			updateCopper(copper);
			updateBindCopper(bindCopper);
			updateBindYuanBao(bindYuanBao);
//			this.yuanBao = yuanbao >= 0 ? yuanbao : 0;
//			this.copper = copper >= 0 ? copper : 0;
//			this.bindCopper = bindCopper >= 0 ? bindCopper : 0;
			this.bankCopper = bankCopper >= 0 ? bankCopper : 0;
//			this.bindYuanBao = bindYuanBao >= 0 ? bindYuanBao : 0;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.MONEYUPDATE));
		}
		
		private function updateYuanbao(value:int):void
		{
			if(yuanBao == value)return;
			var old:int = yuanBao;
			yuanBao = value >= 0 ? value : 0;
			var temp:int  = yuanBao - old;
			if(temp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainYuanbao",temp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		private function updateCopper(value:int):void
		{
			if(copper == value)return;
			var old:int = copper;
			copper = value >= 0 ? value : 0;
			var temp:int  = copper-old;
			if(temp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainCopper",temp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		private function updateBindCopper(value:int):void
		{
			if(bindCopper == value)return;
			var old:int = bindCopper;
			bindCopper = value >= 0 ? value : 0;
			var temp:int  = bindCopper-old;
			if(temp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainBindCopper",temp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		
		private function updateBindYuanBao(value:int):void
		{
			if(bindYuanBao == value)return;
			var old:int = bindYuanBao;
			bindYuanBao = value >= 0 ? value : 0;
			var temp:int  = bindYuanBao-old;
			if(temp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainBindYuanbao",temp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		
	}
}