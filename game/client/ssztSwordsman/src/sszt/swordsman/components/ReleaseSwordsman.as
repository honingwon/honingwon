package sszt.swordsman.components
{
	import flash.display.Sprite;
	
	import sszt.core.socketHandlers.swordsman.UserInfoSocketHandler;
	import sszt.swordsman.mediator.SwordsmanMediator;
	import sszt.swordsman.socketHandlers.TokenPubliskListSocketHandler;
	
	/**
	 * 发布江湖令
	 * @author chendong
	 * 
	 */	
	public class ReleaseSwordsman extends Sprite implements ISwordsmanPanelView
	{
		private var _mediator:SwordsmanMediator;
		/**
		 * 0:发布江湖令;1:领取江湖令 
		 */		
		private var _type:int = 0;
		
		/**
		 *  
		 */		
		private var _top:CommonTop;
		/**
		 *
		 */		
		private var _middle:CommonMiddle;
		/**
		 * 
		 */		
		private var _bottom:CommonBottom;
		
		public function ReleaseSwordsman(mediator:SwordsmanMediator)
		{
			super();
			_mediator = mediator;
			initView();
			initEvent();
			initData();
		}
		
		private function initView():void
		{
			_top = new CommonTop(_type,_mediator);
			_top.move(4,4);
			addChild(_top);
			
			_middle = new CommonMiddle(_type,_mediator);
			_middle.move(0,233);
			addChild(_middle);
			
			_bottom = new CommonBottom(_type);
			_bottom.move(0,365);
			addChild(_bottom);
		}
		
		private function initEvent():void
		{
			
		}
		
		private function initData():void
		{
			
		}
		
		private function removeEvent():void
		{
			
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
		
		public function assetsCompleteHandler():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);			
		}
		
		public function show():void
		{
			// TODO Auto Generated method stub
			UserInfoSocketHandler.send();
			TokenPubliskListSocketHandler.send();
		}
		
	}
}