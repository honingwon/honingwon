package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class CarCharacterLoader extends LayerCharacterLoader 
	{
		
		public function CarCharacterLoader(info:ICharacterInfo)
		{
			super(info, SourceClearType.CHANGESCENE_AND_TIME, 300000, 10);
		}
		override protected function layerCompleteHandler(layer:Object):void
		{
			super.layerCompleteHandler(layer);
			_completeCount++;
			if (_pathList == null){
				return;
			};
			var index:int = _pathList.indexOf(layer.path);
			if (index > -1){
				_loaders[index] = layer;
			};
			if (_completeCount >= _totalCount){
				loadComplete();
			};
		}
		override protected function initList(list:Array, idList:Array, needSexList:Array):void
		{
			list.push(CharacterManager.pathManager.getSceneCarItemPath(String(_info.style[0])));
			idList.push(_info.style[0]);
			needSexList.push(0);
		}
		override protected function getLayerType():String
		{
			return (LayerType.CAR);
		}
		
	}
}
