package sszt.character
{
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.constData.LayerType;
	import sszt.character.loaders.ShowMountsCharacterLoader;
	import sszt.interfaces.character.ICharacterLoader;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import sszt.events.CharacterEvent;
	
	public class ShowMountsCharacter extends LayerCharacter 
	{
		
		private var _currentStyle:Array;
		private var _getMounts:Boolean;
		
		public function ShowMountsCharacter(info:ICharacterInfo)
		{
			super(info);
			this._currentStyle = info.style.slice(0);
			this._getMounts = info.getMounts();
		}
		override protected function getLayerType():String
		{
			return (LayerType.SHOW_MOUNTS);
		}
		override protected function getLoader():ICharacterLoader
		{
			return (new ShowMountsCharacterLoader(_info));
		}
		override protected function init():void
		{
			var i:Bitmap;
			super.init();
			_layers = [new Bitmap(), new Bitmap(), new Bitmap()];
			for each (i in _layers) {
				addChild(i);
			};
			_datas = [];
		}
		override protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			var rects:Array = [];
			var datas:Array = [];
			if (_datas.length > 2){
				if (((_datas[0].datas) && (!((_datas[0].datas[frame] == null))))){
					rects.push(new Point(_datas[1].datas[frame].getX(), _datas[1].datas[frame].getY()), new Point(_datas[2].datas[frame].getX(), _datas[2].datas[frame].getY()), new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY()));
					datas.push(_datas[1].datas[frame].getBD(), _datas[2].datas[frame].getBD(), _datas[0].datas[frame].getBD());
				};
			} else {
				if (_datas.length > 1){
					if (((_datas[0].datas) && (!((_datas[0].datas[frame] == null))))){
						rects.push(new Point(_datas[1].datas[frame].getX(), _datas[1].datas[frame].getY()), new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY()));
						datas.push(_datas[1].datas[frame].getBD(), _datas[0].datas[frame].getBD());
					};
				} else {
					if (((_datas[0].datas) && (!((_datas[0].datas[frame] == null))))){
						rects.push(new Point(_datas[0].datas[frame].getX(), _datas[0].datas[frame].getY()));
						datas.push(_datas[0].datas[frame].getBD());
					};
				};
			};
			return ([rects, datas]);
		}
		override protected function canChange():Boolean
		{
			return (true);
		}
		override protected function characterUpdateHandler(evt:CharacterEvent):void
		{
			if (_info == null){
				return;
			};
			if (this._getMounts != _info.getMounts()){
				return;
			};
			if ((((((((this._currentStyle[0] == _info.style[0])) && ((this._currentStyle[1] == _info.style[1])))) && ((this._currentStyle[2] == _info.style[2])))) && ((this._currentStyle[3] == _info.style[3])))){
				return;
			};
			this._currentStyle = _info.style.slice(0);
			_actionController.stop();
			clearDatas();
			initLoadingAsset();
			_loader.load(showComplete);
		}
		
	}
}
