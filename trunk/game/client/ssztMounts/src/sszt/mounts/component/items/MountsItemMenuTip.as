package sszt.mounts.component.items
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.BaseMenuTip;
	import sszt.core.view.tips.MenuItem;
	import sszt.events.ChatModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class MountsItemMenuTip extends BaseMenuTip
	{
		private static var instance:MountsItemMenuTip;
		private var _timeoutIndex:int = -1;
		private var _mountsInfo:MountsItemInfo;
		
		public function MountsItemMenuTip()
		{
			super();
		}
		
		public static function getInstance():MountsItemMenuTip
		{
			if(instance == null)
			{
				instance = new MountsItemMenuTip();
			}
			return instance;
		}
		
		public function show(mounts:MountsItemInfo,pos:Point):void
		{
			_mountsInfo = mounts;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:MountsItemMenuTip = this;
			function showHandler():void
			{
				var tmpLabels:Array = [LanguageManager.getWord("ssztl.common.show")];
				var tmpIds:Array = [1];
				setLabels(tmpLabels,tmpIds);
				setPos(pos);
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function setPos(pos:Point):void
		{
			if(_bg.height + pos.y > CommonConfig.GAME_HEIGHT)
				this.y =  pos.y - _bg.height;
			else
				this.y = pos.y;
			if(_bg.width + pos.x >CommonConfig.GAME_WIDTH)
				this.x = pos.x - _bg.width;
			else
				this.x = pos.x;	
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			switch (item.id)
			{
				case 1:
					ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PET,_mountsInfo));
					break;
			}
		}
	}
}