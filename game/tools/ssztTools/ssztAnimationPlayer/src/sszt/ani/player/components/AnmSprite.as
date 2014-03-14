package sszt.ani.player.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import spark.components.HSlider;
	import spark.components.NumericStepper;
	
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterLoader;
	import sszt.interfaces.dispose.IDispose;
	import sszt.interfaces.tick.ITick;
	import sszt.interfaces.tick.ITickManager;
	import sszt.loader.LoaderManager;
	import sszt.loader.fanm.FanmLoaderManager;
	

	public class AnmSprite extends Sprite implements ITick,IDispose
	{
		
		protected var _layers:Array;
		
		private var _datas:Array;
		
		protected var _currentFrame:int = 0;
		
		private var _fanmLoaderManager:FanmLoaderManager;
		private var _framRate:int = 3;
		private var _temp:int = 0;
		private var _tick:ITickManager;
		
		private var _state:int = 0 ;
		private var _slider:HSlider;
		public function AnmSprite(m:FanmLoaderManager,tick:ITickManager,slider:HSlider)
		{
			_fanmLoaderManager = m;
			var i:Bitmap;
			_layers = [new Bitmap()];
			for each (i in _layers) {
				addChild(i);
			}
			_datas = [];
			_tick = tick;
			_slider = slider;
			_tick.addTick(this);
		}
		
		public function load(path:String):void
		{
			this._fanmLoaderManager.getFile(path,layerCompleteHandler, SourceClearType.CHANGESCENE_AND_TIME);
		}
		
		public function set framRate(framRate:int):void
		{
			_framRate = framRate;
		}
		public function get framRate():int
		{
			return _framRate;
		}
		protected function layerCompleteHandler(datas:Object):void
		{
			this._datas = [datas];
			this._currentFrame = -1;
			setFrame(0);
			_slider.maximum = getFrameLen() -1 ;
		}
		
		public function getFrameLen():int
		{
			if(this._datas.length > 0)
			{
				return this._datas[0].count;
			}
			return 0;
		}
		
		protected function getFrameDatas(frame:int):Array
		{
			var arr:Array = new Array();
			if (_datas.length>0 && _datas[0].datas && _datas[0].datas.length > frame && _datas[0].datas[frame] != null){
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			}
			return arr;
		}
		
		
		private function setFrame(frame:int):void
		{
			_slider.value = frame;
			var b:Bitmap;
			var list:Array;
			var i:int;
			if (frame == 100000){
				for each (b in this._layers) {
					b.bitmapData = null;
				}
				return;
			}
//			if (frame < 0 || frame >= getFrameLen()){
//				frame = 0;
//			}
//			if (frame != this._currentFrame )
//			{
				list = this.getFrameDatas(frame);
				i = 0;
				if (list.length > 0){
					i = 0;
					while (i < list[0].length) {
						if (this._layers[i] != null || this._layers[i].bitmapData == null && list[1][i] == null)
						{
							this._layers[i].bitmapData = list[1][i];
							this._layers[i].y = -list[0][i].y;							
							this._layers[i].x = -list[0][i].x;
							
						}
						i++;
					}
				}
				while (i < this._layers.length) {
					if (this._layers[i] != null && this._layers[i].bitmapData != null){
						this._layers[i].bitmapData = null;
					}
					i++;
				}
//			}
		}
		
		public function setFrameValue(value:int):void
		{
			_currentFrame = value -1;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_state == 0)
				return;
			if(_temp >= _framRate)
			{
				this._currentFrame++;
				_temp = 0;
			}
			if (this._currentFrame < 0 || this._currentFrame >= getFrameLen()){
				this._currentFrame = 0;
			}
			this.setFrame(_currentFrame);
			_temp++;
			
		}
		
		public function set state(value:int):void
		{
			_state = value;
		}
		
		public function nextFrame():void
		{
			_currentFrame++;
			if (this._currentFrame < 0 || this._currentFrame >= getFrameLen()){
				this._currentFrame = 0;
			}
			this.setFrame(_currentFrame);
		}
		
		public function dispose():void
		{
			var i:Bitmap;
			if (this._layers){
				for each (i in this._layers) {
					if (i && i.parent){
						i.parent.removeChild(i);
					}
				}
				this._layers = null;
			}
			_tick.removeTick(this);
			if (this._datas){
				this._datas = null;
			}
		}
	}
}