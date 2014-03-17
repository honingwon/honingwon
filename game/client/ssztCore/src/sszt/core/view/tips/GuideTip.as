package sszt.core.view.tips
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	
	public class GuideTip extends Sprite
	{
		private var _asset1:MovieClip;
		
		private var _arrowAsset:MovieClip; //IMovieWrapper;
		
		private var _asset2:Bitmap;
		private var _field:TextField;
		
		private static var instance:GuideTip;
		public static function getInstance():GuideTip
		{
			if(instance == null)
			{
				instance = new GuideTip();
			}
			return instance;
		}
		
		public function GuideTip()
		{
			super();
			init();
		}
		
		private function init():void
		{
			mouseEnabled = mouseChildren = false;
			
			_asset1 = AssetUtil.getAsset("ssztui.common.GuideTipAsset1",MovieClip) as MovieClip;
			_asset1.mouseEnabled = _asset1.mouseChildren = false;
			
			
			_asset2 = new Bitmap(AssetUtil.getAsset("ssztui.common.GuideTipAsset2",BitmapData) as BitmapData);
			
			
			_field = new TextField();
			_field.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,4);
			_field.mouseEnabled = _field.mouseWheelEnabled = false;
			_field.width = 200;
			_field.wordWrap = true;
			_field.x = 10;
			_field.y = 8;
			
			_arrowAsset = MovieCaches.getArrowAsset();
		}
		
		/**
		 * dir为箭头方向，1为左上，2为右上，3为左下，4为右下
		 * @param mes
		 * @param dir
		 * 
		 */		
		public function show(mes:String,dir:int,point:Point,addTo:Function):void
		{
			hide();
			this.x = point.x;
			this.y = point.y;
			if (dir < 5)
			{
				_field.htmlText = mes;
				_field.height = _field.textHeight + 4;
				_field.width = Math.min(_field.textWidth+6,200);
				_asset1.width = _field.width + 20;
				_asset1.height = _field.height + 14;
			
				switch(dir)
				{
					case 1:
						_asset2.scaleX = -1;
						_asset2.scaleY = 1;
						_asset2.x = _asset2.width;
						_asset2.y = -_asset2.height + 2;
						break;
					case 2:
						_asset2.scaleX = 1;
						_asset2.scaleY = 1;
						_asset2.x = _asset1.width - _asset2.width;
						_asset2.y = -_asset2.height + 2;
						break;
					case 3:
						_asset2.scaleX = _asset2.scaleY = -1;
						_asset2.x = _asset2.width;
						_asset2.y = _asset1.height + _asset2.height - 2;
						break;
					case 4:
						_asset2.scaleX = 1;
						_asset2.scaleY = -1;
						_asset2.x = _asset1.width - _asset2.width;
						_asset2.y = _asset1.height + _asset2.height - 2;
						break;
				}
				
				addChild(_asset1);
				addChild(_asset2);
				addChild(_field);
			}
			else
			{
				this._arrowAsset.rotation = 90 * (dir - 4);
				this._arrowAsset.play();
				addChild(this._arrowAsset as DisplayObject);
			}
			
			addTo(this);
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
			if (this._field.parent)
			{
				this._field.parent.removeChild(this._field);
			}
			if (this._asset1.parent)
			{
				this._asset1.parent.removeChild(this._asset1);
			}
			if (this._asset2.parent)
			{
				this._asset2.parent.removeChild(this._asset2);
			}
			if (this._arrowAsset.parent)
			{
				this._arrowAsset.parent.removeChild(this._arrowAsset as DisplayObject);
			}
		}
		
		public function dispose():void
		{
			if (this._arrowAsset)
			{
				this._arrowAsset.dispose();
				this._arrowAsset = null;
			}
			_field = null;
		}
	}
}