package sszt.core.view.tips
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	
	import ssztui.ui.BorderAsset4;
	
	public class BaseMenuTip extends Sprite
	{
		protected var _bg:BorderAsset4;
		protected var _labels:Array;
		protected var _btnIds:Array;
//		protected var _menus:Vector.<MenuItem>;
		protected var _menus:Array;
		
		public function BaseMenuTip()
		{
			super();
		}
		
		public function setLabels(labels:Array,ids:Array = null):void
		{
			_labels = labels;
			_btnIds = ids;
			if(_menus)
			{
				for(var i:int =0;i<_menus.length;i++)
				{
					_menus[i].dispose();
				}
				_menus = null;
			}
//			_menus = new Vector.<MenuItem>();
			_menus = [];
			initView();
			initEvent();
		}
		
		private function initView():void
		{	
			if(!_bg) _bg = new BorderAsset4();
			_bg.width = 78;
//			if(ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty))//是否是帮主
				_bg.height = _labels.length * 18+14;
//			else
//				_bg.height = (_labels.length - 1) * 18+14;
			addChild(_bg);	
			
			for(var i:int =0;i<_labels.length;i++)
			{
//				if(i==6&& ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty)==false)//是否是帮主
//					continue;
				
				var menuItem:MenuItem = new MenuItem(_labels[i],_btnIds[i]);
//				if(ClubDutyType.getIsMaster(GlobalData.selfPlayer.clubDuty)==false&&i>6)
//					menuItem.move(3,7+18*(i-1));
//				else
					menuItem.move(3,7+18*i);
				addChild(menuItem);
				_menus.push(menuItem);
			}
		}
		
		protected function initEvent():void
		{
			for(var i:int =0;i<_menus.length;i++)
			{
				_menus[i].addEventListener(MouseEvent.CLICK,clickHandler);
			}
			GlobalAPI.layerManager.getTipLayer().stage.addEventListener(MouseEvent.CLICK,disposeHandler);
		}
		
		protected function removeEvent():void
		{
			for(var i:int =0;i<_menus.length;i++)
			{
				_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
			}
			GlobalAPI.layerManager.getTipLayer().stage.removeEventListener(MouseEvent.CLICK,disposeHandler);
		}
		
		private function disposeHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		protected function clickHandler(evt:MouseEvent):void
		{
			
		}
		
		public function dispose():void
		{
			_labels = null;
			removeEvent();
			if(_menus)
			{
				for(var i:int =0;i<_menus.length;i++)
				{
					_menus[i].dispose();
				}
				_menus = [];
			}
			if(_bg&&_bg.parent) removeChild(_bg);
			_bg = null;
			if(parent) parent.removeChild(this);
		}
	}
}