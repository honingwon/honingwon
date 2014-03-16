/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-14 下午7:06:10 
 * 
 */ 
package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterInfo;

	public class BaseMountsRunCharacter  extends BaseSceneCharacter
	{
		protected var _currentFrame1:int = -1;
		protected var _dirUpdate1:Boolean;
		
		
		public function BaseMountsRunCharacter(info:ICharacterInfo)
		{
			super(info);
		}
		
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap(), new Bitmap(), new Bitmap(), new Bitmap()];
			for each (i in _layers) {
				addChild(i);
			}
			_datas = [];
		}
		
		
		protected function getMountsFrameLen():int
		{
			if(this._datas.length > 3 && this._datas[3])
			{
				return this._datas[3].count;
			}
			return 0;
		}
		
		
		override public function setFrame(frame:int,frame1:int=0,frame2:int=0):void
		{
//			trace(frame,frame1,frame2);
			var b:Bitmap;
			var list:Array;
			var i:int;
			if (frame == 100000){
				for each (b in this._layers) {
					b.bitmapData = null;
				}
				return;
			}
			if (frame < 0 || frame >= this.getFrameLen()){
				frame = 0;
			}
			if (frame != this._currentFrame || this._dirUpdate)
			{
				this._dirUpdate = false;
				this._currentFrame = frame;
				if (_figureVisible){
					list = getFrameDatas(frame,frame1,frame2);
					if (list.length > 0){
						while (i < list[0].length) {
							if (this._layers[i] != null || this._layers[i].bitmapData == null && list[1][i] == null)
							{
								this._layers[i].bitmapData = list[1][i];
								this._layers[i].y = -list[0][i].y;
								this._layers[i].scaleX = this.getDirScale();
								if (this._layers[i].scaleX == -1){
									this._layers[i].x = list[0][i].x ;
								} 
								else {
									this._layers[i].x = -list[0][i].x;
								}
							}
							i++;
						}
					}
					while (i < this._layers.length) 
					{
						if (this._layers[i] != null && this._layers[i].bitmapData != null){
							this._layers[i].bitmapData = null;
						}
						i++;
					}
				}
			}
			
		}
		
		override public function updateDir(dir:int):void
		{
			super.updateDir(dir);
			this._dirUpdate = true;
			this._dirUpdate1 = true;
			this._actionController.setDir(dir);
		}
		
		
	}
}