package sszt.ui.progress
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	
	public class ProgressBar extends Sprite
	{
		protected var _asset:DisplayObject;
		protected var _currentValue:int;
		protected var _totalValue:int;
		private var _isShowTxt:Boolean;
		private var numTextField:TextField;
		protected var _width:int;
		protected var _height:int;
		private var _isShowPercent:Boolean = false;
		private var _background:DisplayObject;
		protected var _mask:Sprite;
		
		public function ProgressBar(asset:DisplayObject,currentValue:int,totalValue:int,width:int,height:int,isShowTxt:Boolean,isShowPercent:Boolean,background:DisplayObject=null)
		{
			super();
			this._asset = asset;
			this._currentValue = currentValue;
			this._totalValue = totalValue;
			this._width= width;
			this._height = height;
			this._isShowTxt = isShowTxt;
			this._isShowPercent = isShowPercent;
			this._background = background;
			numTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			
			draw();
		}

		public function draw(isShowToOthers:Boolean = true):void
		{
			if(_background!= null)
			{
				addChildAt(_background,0);
			}
			
			updateAssetWidth();
			
			if(!_asset.parent)
				addChild(_asset);
			
			if(_isShowTxt)
			{
				if(_isShowPercent)
				{
					numTextField.text = Math.round((_currentValue/_totalValue)*100)+"%";
				}
				else
				{
					if(isShowToOthers)
					{
					 	numTextField.text = _currentValue.toString()+"/"+_totalValue.toString();
					}
					else
					{
//						numTextField.text = "??????"+"/"+"??????";
					}
				}
//				numTextField.setTextFormat(new TextFormat("宋体",10,0xFFFFFF));
				numTextField.autoSize = TextFieldAutoSize.CENTER;
				numTextField.width = numTextField.textWidth + 4;
				numTextField.height = numTextField.textHeight + 4;
				numTextField.x = (_width-numTextField.width)/2+_asset.x;
				numTextField.y = (_height-numTextField.height)/2+_asset.y;
				numTextField.mouseEnabled = false;
				addChild(numTextField);
			}
		}
		
		protected function updateAssetWidth():void
		{
			_asset.width = _currentValue/_totalValue*_width;
			_asset.height = _height;
		}
		

		public function setCurrentValue(value:int):void
		{
			if(value>_totalValue)
			{
				_currentValue = _totalValue;
			}
			else
			{
				_currentValue = value;
			}
			draw();
		}
		
		public function setTotalValue(value:int):void
		{
			_totalValue = value;
			draw();
		}
		
		public function setValue(totalValue:int,currentValue:int,isShowToOthers:Boolean = true):void
		{
			_totalValue = totalValue;
			if(currentValue>_totalValue)
			{
				_currentValue = _totalValue;
			}
			else
			{
				_currentValue = currentValue;
				if(_currentValue < 0)
				{
					_currentValue = 0;
				}
			}
			draw(isShowToOthers);
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			_asset = null;
			numTextField = null;
			_background = null;
			_mask = null;
			if(parent)parent.removeChild(this);
		}
	}
}