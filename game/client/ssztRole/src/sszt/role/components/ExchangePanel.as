package sszt.role.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.role.mediator.RoleMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;

	public class ExchangePanel extends Sprite implements IRolePanelView
	{
		private var _roleMediator:RoleMediator;	
		private var rolePlayerId:Number;
		
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _items:Array;
		
		public function ExchangePanel(roleMediator:RoleMediator,argRolePlayerId:Number)
		{
			_roleMediator = roleMediator;
			rolePlayerId = argRolePlayerId;
			
			initView();
			initEvents();
		}
		
		private function initView():void
		{	
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(4,3,434,92)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(4,97,434,92)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(4,191,434,92)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(4,285,434,92)),
			]);
			addChild(_bg as DisplayObject);
			
			_items = [];
			_tile = new MTile(434,92,1);
			_tile.itemGapW = 0;
			_tile.itemGapH = 2;
			_tile.setSize(434,374);
			_tile.move(4,3);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			
			for(var i:int=0; i<4; i++)
			{
				var item:ExchangeItemView = new ExchangeItemView(i);
				_tile.appendItem(item);
				_items.push(item);
			}
		}
		private function initEvents():void
		{
			
		}
		private function removeEvents():void
		{
			
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
			
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvents();
		}
	}
}