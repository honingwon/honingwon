package sszt.character
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import sszt.character.loaders.NPCCharacterLoader;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	public class NPCCharacter extends LayerCharacter 
	{
		
		public function NPCCharacter(info:ICharacterInfo)
		{
			super(info);
		}
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap()];
			for each (i in _layers) 
			{
				addChild(i);
			}
			_datas = [];
		}
		override protected function getLayerType():String
		{
			return LayerType.SCENE_NPC;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new NPCCharacterLoader(_info);
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var arr:Array = new Array();
			if (_datas[0].datas && _datas[0].datas.length > frame && _datas[0].datas[frame] != null)
			{
				arr.push([new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY())], [_datas[0].datas[frame].getBD()]);
			}
			return (arr);
		}
		
		
		override public function setFrame(frame:int,frame1:int=0,frame2:int=0):void
		{
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
					list = this.getFrameDatas(frame);
					i = 0;
					if (list.length > 0){
						i = 0;
						while (i < list[0].length) {
							if (this._layers[i] != null || this._layers[i].bitmapData == null && list[1][i] == null)
							{
								this._layers[i].bitmapData = list[1][i];
								this._layers[i].y = -list[0][i].y;
								this._layers[i].scaleX = this._datas[0].sX == 0 ? 1 : this._datas[0].sX;
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
		
		override protected function actionControllerStart(type:int):void
		{
			var frameRate:int = _info.getFrameRate(type);
			var obj:Object = this._datas[0];
			var start:int = (obj.actionSE[0]);
			var end:int = (obj.actionSE[1]);
			
			this._actionController.setDefaultAction(SceneCharacterActions.createActionInfo(this.getLayerType(),type,start,end,obj.directType,frameRate));
			
			this._actionController.start();
		}
		
		
	}
}
