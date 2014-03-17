package
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class RoleChoseView extends Sprite
	{
		private var _bg:Bitmap;
		private var _currentItem:ChoiseRoleSelectBtn;
		private var _btns:Array;
		private var _data:Object;
		private var _players:Array;
		private var _callBack:Function;
		private var _enterBg:Bitmap;
		private var _enterSp:Sprite;
		public static var headAsset:Array;
		
		public function RoleChoseView(data:Object)
		{
			_data = data;
			_players = data["players"];
			_callBack = data["callback"];
			super();
			headAsset = [new IconAsset1(),new IconAsset2(),new IconAsset3(),new IconAsset4(),new IconAsset5(),new IconAsset6()];
			init();
			initEvent();			
		}
		
		private function init():void
		{
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(-500,-500,3000,3000);
			mask.graphics.endFill();
			addChild(mask);
			
			_bg = new Bitmap(new BgAsset());
			_bg.x = 330;
			_bg.y = 70;
			addChild(_bg);
			
			_btns = [];
			for(var i:int = 0;i<_players.length;i++)
			{
				var btn:ChoiseRoleSelectBtn = new ChoiseRoleSelectBtn(_players[i]["career"],_players[i]["sex"],_players[i]["nickName"],_players[i]["serverIndex"],_players[i]["id"]);
				_btns.push(btn);
				btn.x = 350;
				btn.y = i * 55 + 120;
				addChild(btn);
				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				btn.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			}
			
			if(_btns.length > 0)
			{
				_currentItem = _btns[0];
				_currentItem.selected = true;
			}
			
			_enterBg = new Bitmap(new EnterGameBtn());
			_enterBg.x = 427;
			_enterBg.y = 473;
			addChild(_enterBg);
			_enterSp = new Sprite();
			_enterSp.graphics.beginFill(0,0);
			_enterSp.graphics.drawRect(427,473,170,41);
			_enterSp.graphics.endFill();
			_enterSp.buttonMode = true;
			addChild(_enterSp);
		}
		
		private function initEvent():void
		{
			_enterSp.addEventListener(MouseEvent.CLICK,enterClickHandler);
		}
		
		private function removeEvent():void
		{
			_enterSp.removeEventListener(MouseEvent.CLICK,enterClickHandler);
		}
		
		private function enterClickHandler(evt:MouseEvent):void
		{
			if(_currentItem == null) return;
			_callBack(_currentItem.nick,_currentItem.id);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var item:ChoiseRoleSelectBtn = evt.currentTarget as ChoiseRoleSelectBtn;
			if(_currentItem == item) return;
			if(_currentItem) _currentItem.selected = false;
			_currentItem = item;
			_currentItem.selected = true;
			
		}
		
		private function mouseOverHandler(evt:MouseEvent):void
		{
			
		}
		
		private function mouseOutHandler(evt:MouseEvent):void
		{
			
		}
		
		public function dispose():void
		{
			removeEvent();
			for each(var i:ChoiseRoleSelectBtn in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				i.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				i.dispose();
			}
			headAsset = null;
			if(parent)parent.removeChild(this);
		}
	}
}