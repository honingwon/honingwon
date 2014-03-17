package sszt.mergeServer.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.midAutmn.ListItemAsset;
	import ssztui.midAutmn.ListItemOverAsset;
	import ssztui.midAutmn.ListItemiconAsset21;
	import ssztui.midAutmn.ListItemiconAsset22;
	import ssztui.midAutmn.ListItemiconAsset23;
	import ssztui.midAutmn.ListItemiconAsset24;
	import ssztui.openServer.ListItemiconAsset3;

	public class IndexItemView extends Sprite
	{
		private var _bg:Bitmap;
		private var _icon:Bitmap;
		
		private var _labelShow:MAssetLabel;
		private var _overBorder:Bitmap;
		private var _index:int;
		
		private var _btnNameArray:Array = [
			LanguageManager.getWord("ssztl.mergeServer.listLabel1"),
//			LanguageManager.getWord("ssztl.midAutumnActivity.listLabel2"),
			LanguageManager.getWord("ssztl.mergeServer.listLabel3"),
//			LanguageManager.getWord("ssztl.midAutumnActivity.listLabel4"),
			LanguageManager.getWord("ssztl.mergeServer.listLabel5")
		];
		private var _iconArray:Array = [
			ListItemiconAsset21,
//			ListItemiconAsset22,
			ListItemiconAsset3,
//			ListItemiconAsset23,
			ListItemiconAsset24
		];
		public function IndexItemView(index:int)
		{
			if(index.toString().length >= 2)
			{
				_index = int(index.toString().charAt(0))-1;
			}
			else
			{
				_index = index;
			}
			buttonMode = true;

			_bg = new Bitmap(new ListItemAsset());
			addChild(_bg);			
			
			_overBorder = new Bitmap(new ListItemOverAsset());
			addChild(_overBorder);
			_overBorder.visible = false;
			_overBorder.alpha = 0.3;
			
			_icon = new Bitmap(new _iconArray[_index]());
			_icon.x = _icon.y = 5;
			addChild(_icon);
				
			_labelShow = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_labelShow.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc00,null,null,null,null,null,null,null,null,null,6)]);
			_labelShow.x = 51;
			addChild(_labelShow);
			_labelShow.setHtmlValue(_btnNameArray[_index]);
			_labelShow.y = 52-_labelShow.textHeight >> 1;
			
			initEvent();
		}
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			_overBorder.visible = true;
		}
		private function outHandler(e:MouseEvent):void
		{
			_overBorder.visible = false;
		}
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		public function set selected(value:Boolean):void
		{
			_bg.bitmapData = value?new ListItemOverAsset():new ListItemAsset();
		}
		public function dispose():void
		{
			removeEvent();
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_icon && _icon.bitmapData)
			{
				_icon.bitmapData.dispose();
				_icon = null;
			}
			if(_overBorder && _overBorder.bitmapData)
			{
				_overBorder.bitmapData.dispose();
				_overBorder = null;
			}
			_labelShow = null;
		}
	}
}