/**
 * @author lxb
 *  2012-9-13 修改
 */
package sszt.ui.button
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sszt.ui.LabelCreator;
	import sszt.ui.UIManager;
	import sszt.ui.container.MSprite;
	
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	
	public class MAssetButton extends MSprite
	{
		public static const overFilter:Array = [
			new ColorMatrixFilter([1.91796132628669,-0.0284155505641657,-0.179545775722528,0,-10.885,-0.102071016959047,1.78406136149641,0.0280096554626413,0,-10.885,0.0573233273862934,-0.273505778966141,1.92618245157985,0,-10.885,0,0,0,1,0]),
			new GlowFilter(0x99FF00,1,5,5,2.5)
		];
		
		protected var _asset:DisplayObject;
		protected var _enabled:Boolean;
		protected var _source:Object;
		protected var _sourceWidth:Number;
		protected var _sourceHeight:Number;
		protected var _sourceXScale:Number;
		protected var _sourceYScale:Number;
		protected var _label:TextField;
		protected var _scale9Grid:Rectangle;
		protected var _labelXOffset:int = 0;
		protected var _labelYOffset:int = 2;
		protected var _labelX:Number;
		protected var _labelY:Number;
//		private var _overFilter:Array;
		
		public function MAssetButton(source:Object,label:String = "",width:Number = -1,height:Number = -1,xscale:Number = 1,yscale:Number = 1,scale9Grid:Rectangle = null,labelXOffset:int=0,labelYOffset:int=2)
		{
			_source = source;
			_sourceWidth = width;
			_sourceHeight = height;
			_sourceXScale = xscale;
			_sourceYScale = yscale;
			_scale9Grid = scale9Grid;
			_labelXOffset = labelXOffset;
			_labelYOffset = labelYOffset;
			_asset = createAsset();
			addChild(_asset);
			
			_label = createLabel(label);
			if(_label)addChild(_label);
//			_overFilter = overFilter;
			
			init();
			initEvent();
		}
		
		protected function createAsset():DisplayObject
		{
			var t:MovieClip;
			if(_source is Class)t = new _source() as MovieClip;
			else if(_source is MovieClip)t = _source as MovieClip;
			else
			{
				throw new Error("MAssetButton's asset must be MovieClip or MovieClip Class");
			}
			var m:IMovieWrapper;
			if(_sourceXScale == 1 && _sourceYScale == 1)
				m = UIManager.movieWrapperApi.getMovieWrapper(t,(_sourceWidth == -1 ? t.width : _sourceWidth),(_sourceHeight == -1 ? t.height : _sourceHeight));
			else
			{
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(t,1,(_sourceWidth == -1 ? t.width : _sourceWidth),(_sourceHeight == -1 ? t.height : _sourceHeight),1,_sourceXScale,_sourceYScale,_scale9Grid);
				m = UIManager.movieWrapperApi.getMovieWrapperByParam(param);
			}
			m.gotoAndStop(1);
			return m as DisplayObject;
		}
		
		protected function createLabel(str:String):TextField
		{
			if(str == null)return null;
			var t:TextField = LabelCreator.getLabel(str,null,null,false,TextFieldAutoSize.CENTER);
//			t.x = (_asset.width - t.width >> 1) + _labelXOffset;
//			t.y = (_asset.height - t.height >> 1) + _labelYOffset;
			t.x = (_asset.width - t.textWidth >> 1)-1;
			t.y = _asset.height - t.textHeight >> 1;
			_labelX = t.x;
			_labelY = t.y;
			return t;
		}
		
		protected function init():void
		{
			_enabled = true;
			buttonMode = true;
		}
		
//		public function setOverFilter(filters:Array):void
//		{
//			_overFilter = filters;
//		}
		
		protected function initEvent():void
		{
			addEventListener(MouseEvent.ROLL_OVER,overHandler);
			addEventListener(MouseEvent.ROLL_OUT,outHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			addEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		protected function removeEvent():void
		{
			removeEventListener(MouseEvent.ROLL_OVER,overHandler);
			removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		
		public function get labelField():TextField
		{
			return _label;
		}
		
		
		
		protected function overHandler(evt:MouseEvent):void
		{
//			_asset.filters = _overFilter;
		}
		protected function outHandler(evt:MouseEvent):void
		{
//			_asset.filters = [];
		}
		protected function downHandler(evt:MouseEvent):void
		{
			if(_asset)
				_asset.x = _asset.y = 1;
			if(_label)
			{
				_label.x = _labelX + 1;
				_label.y = _labelY + 1;
			}
			if(stage)stage.addEventListener(MouseEvent.MOUSE_UP,upHandler,false,0,true);
		}
		protected function upHandler(evt:MouseEvent):void
		{
			if(_asset)
				_asset.x = _asset.y = 0;
			if(_label)
			{
				_label.x = _labelX;
				_label.y = _labelY;
			}
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		public function set label(value:String):void
		{
			_label.text = value;
//			_label.x = (_asset.width - _label.width >> 1) + _labelXOffset;
//			_label.y = (_asset.height - _label.height >> 1) + _labelYOffset;
			_label.x = (_asset.width - _label.textWidth >> 1) - 1;
			_label.y = (_asset.height - _label.textHeight >> 1) - 2;
			_labelX = _label.x;
			_labelY = _label.y;
		}
		
		public function set enabled(value:Boolean):void
		{
			if(_enabled == value)return;
			_enabled = value;
			if(_enabled)
			{
				filters = [];				
				mouseEnabled = buttonMode = true;				
			}
			else
			{
				filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
				mouseEnabled = buttonMode = false;
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_asset)
			{
				if(_asset is IMovieWrapper)
				{
					(_asset as IMovieWrapper).dispose();
				}
				else
				{
					if(_asset.parent)_asset.parent.removeChild(_asset);
				}
				_asset = null;
			}
			if(parent)parent.removeChild(this);
			super.dispose();
		}
	}
}