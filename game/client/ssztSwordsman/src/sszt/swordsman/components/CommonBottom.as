package sszt.swordsman.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.swordsman.socketHandlers.TokenPubliskListSocketHandler;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	/**
	 * 公共底部 
	 * @author chendong
	 * 
	 */	
	public class CommonBottom extends Sprite implements IPanel
	{
		/**
		 * 0:发布江湖令;1:领取江湖令 
		 */		
		private var _type:int = 0;
		
		/**
		 * 江湖令发布和领取时间:00:30 --  23:30
		 */
		private var _releaseAndReceiveTime:MAssetLabel;
		
		/**
		 * 刷新按钮 
		 */
		private var _refresh:MCacheAssetBtn1;
		
		public function CommonBottom(type:int)
		{
			super();
			_type = type;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_releaseAndReceiveTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_releaseAndReceiveTime.move(230,8);
			addChild(_releaseAndReceiveTime);
			
			_refresh = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.swordsMan.flush"));
			_refresh.move(350,5);
			addChild(_refresh);
			_refresh.visible = false;
		}
		
		public function initEvent():void
		{
			_refresh.addEventListener(MouseEvent.CLICK,refreshClick);
		}
		
		public function initData():void
		{
			switch(_type)
			{
				case 0:
					break;
				case 1:
					_refresh.visible = true;
					break;
			}
			_releaseAndReceiveTime.setValue(LanguageManager.getWord("ssztl.swordsMan.releaseTime"));
		}
		
		private function refreshClick(evt:MouseEvent):void
		{
			TokenPubliskListSocketHandler.send();
		}
		
		public function removeEvent():void
		{
			_refresh.removeEventListener(MouseEvent.CLICK,refreshClick);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}