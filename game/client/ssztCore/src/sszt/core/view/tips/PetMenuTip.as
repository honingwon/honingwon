package sszt.core.view.tips
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;

	public class PetMenuTip extends BaseMenuTip
	{
		private static var instance:PetMenuTip;
		private var id:Number;
		private var _timeoutIndex:int = -1;
		
		public static function getInstance():PetMenuTip
		{
			if(instance == null)
			{
				instance = new PetMenuTip();
			}
			return instance;
		}
		
		/**
		 * 
		 * @param pos 鼠标点下位置
		 * 
		 */		
		public function show(id:Number,pos:Point):void
		{
			this.id = id;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:PetMenuTip = this;
			function showHandler():void
			{
//				setLabels(["喂食","召回"],[1,2]);
				setLabels([LanguageManager.getWord("ssztl.scene.giveEat"),
					LanguageManager.getWord("ssztl.common.callBack")],[1,2]);
				
				setFilter();
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
			this.x = pos.x;
			this.y = pos.y;
		}
		
		private function setFilter():void
		{
			for(var i:int = 0;i<_menus.length;i++)
			{
				if(_menus[i].id == 1 || _menus[i].id == 3 || _menus[i].id == 4 || _menus[i].id == 5)
				{
					_menus[i].enabled = false;
					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
				}
			}
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			switch (item.id)
			{
				case 1:
					break;
				case 2:
//					PetStateChangeSocketHandler.send(id,0);
					break;
			}
		}
	}
}