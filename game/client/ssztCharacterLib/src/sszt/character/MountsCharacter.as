package sszt.character
{
	import sszt.interfaces.character.ICharacterInfo;
	import flash.display.Bitmap;
	import sszt.constData.LayerType;
	import sszt.character.loaders.MountsCharacterLoader;
	import sszt.interfaces.character.ICharacterLoader;
	import sszt.constData.DirectType;
	import flash.geom.Point;
	import sszt.events.CharacterEvent;
	
	public class MountsCharacter extends LayerCharacter 
	{
		
		private var _currentStyle:Array;
		private var _getMounts:Boolean;
		private var _windStrengthLevel:int;
		
		public function MountsCharacter(info:ICharacterInfo)
		{
			super(info);
			this._currentStyle = info.style.slice(0);
			this._getMounts = info.getMounts();
			this._windStrengthLevel = info.getWindStrength();
		}
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap(), new Bitmap(), new Bitmap()];
			for each (i in _layers) {
				addChild(i);
			}
			_datas = [];
		}
		override protected function getLayerType():String
		{
			return LayerType.SCENE_MOUNTS;
		}
		override protected function getLoader():ICharacterLoader
		{
			return new MountsCharacterLoader(_info);
		}
		
		/**
		 * data [衣服，骑宠，翅膀] 
		 * @param frame
		 * @return 
		 * 
		 */		
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			
			var rects:Array = [];
			var datas:Array = [];
			if (_dir == DirectType.TOP || _dir == DirectType.LEFT_TOP || _dir == DirectType.RIGHT_TOP || _dir == DirectType.LEFT || _dir == DirectType.RIGHT)
			{
				if (_datas.length > 1)
				{
					if (_datas[1].datas && _datas[1].datas.length > frame && _datas[1].datas[frame] != null)
					{
						rects.push(new Point(_datas[1].datas[frame].getX(), _datas[1].datas[frame].getY()));
						datas.push(_datas[1].datas[frame].getBD());
					}
				}
				if (_datas.length > 0){
					if (_datas[0].datas && _datas[0].datas.length > frame && _datas[0].datas[frame] != null)
					{
						rects.push(new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY()));
						datas.push(_datas[0].datas[frame].getBD());
					}
				}
				if (_datas.length > 2){
					if (_datas[2].datas && _datas[2].datas.length > frame && _datas[2].datas[frame] != null)
					{
						rects.push(new Point(_datas[2].datas[frame].getX(), _datas[2].datas[frame].getY()));
						datas.push(_datas[2].datas[frame].getBD());
					}
				}
			} 
			else {
				if (_dir == DirectType.LEFT_BOTTOM || _dir == DirectType.RIGHT_BOTTOM )
				{
					if (_datas.length > 1)
					{
						if (_datas[1].datas && _datas[1].datas.length > frame && _datas[1].datas[frame] != null)
						{
							rects.push(new Point(_datas[1].datas[frame].getX(), _datas[1].datas[frame].getY()));
							datas.push(_datas[1].datas[frame].getBD());
						}
					}
					if (_datas.length > 2)
					{
						if (_datas[2].datas && _datas[2].datas.length > frame && _datas[2].datas[frame] != null)
						{
							rects.push(new Point(_datas[2].datas[frame].getX(), _datas[2].datas[frame].getY()));
							datas.push(_datas[2].datas[frame].getBD());
						}
					}
					if (_datas.length > 0)
					{
						if (_datas[0].datas && _datas[0].datas.length > frame && _datas[0].datas[frame] != null)
						{
							rects.push(new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY()));
							datas.push(_datas[0].datas[frame].getBD());
						}
					}
				}
				else
				{
					if (_datas.length > 2){
						if (_datas[2].datas && _datas[2].datas.length > frame && _datas[2].datas[frame] != null){
							rects.push(new Point(_datas[2].datas[frame].getX(), _datas[2].datas[frame].getY()));
							datas.push(_datas[2].datas[frame].getBD());
						}
					}
					if (_datas.length > 0){
						if (_datas[0].datas && _datas[0].datas.length > frame && _datas[0].datas[frame] != null){
							rects.push(new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY()));
							datas.push(_datas[0].datas[frame].getBD());
						}
					}
					if (_datas.length > 1)
					{
						if (_datas[1].datas && _datas[1].datas.length > frame && _datas[1].datas[frame]!= null ){
							rects.push(new Point(_datas[1].datas[frame].getX(), _datas[1].datas[frame].getY()));
							datas.push(_datas[1].datas[frame].getBD());
						}
					}
				}
			}
			return ([rects, datas]);
		}
		
		override protected function canChange():Boolean
		{
			return true;
		}
		override protected function characterUpdateHandler(evt:CharacterEvent):void
		{
			if (_info == null || this._getMounts != _info.getMounts()){
				return;
			}
			if (this._currentStyle[0] == _info.style[0]
				&& this._currentStyle[1] == _info.style[1] 
				&& this._currentStyle[2] == _info.style[2] 
				&& this._currentStyle[3] == _info.style[3] 
				&& this._windStrengthLevel == _info.getWindStrength()){
				return;
			}
			this._currentStyle = _info.style.slice(0);
			this._windStrengthLevel = _info.getWindStrength();
			_actionController.stop();
			clearDatas();
			initLoadingAsset();
			_loader.load(showComplete);
		}
		
	}
}
