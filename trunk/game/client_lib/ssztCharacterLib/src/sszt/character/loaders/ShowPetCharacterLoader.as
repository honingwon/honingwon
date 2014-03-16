package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class ShowPetCharacterLoader extends LayerCharacterLoader 
	{
		
		public function ShowPetCharacterLoader(info:ICharacterInfo)
		{
			super(info, SourceClearType.TIME, 300000, 5);
		}
		override protected function layerCompleteHandler(layer:Object):void
		{
			if (_pathList == null){
				return;
			}
			super.layerCompleteHandler(layer);
			_completeCount++;
			var index:int = _pathList.indexOf(layer.path);
			if (index > -1){
				_loaders[index] = layer;
			}
			if (_completeCount >= _totalCount)
			{
				loadComplete();
			}
		}
		override protected function initList(list:Array, idList:Array, needSexList:Array):void
		{
			list.push(CharacterManager.pathManager.getSceneItemsPath(String(_info.style[0]), this.getLayerType()));
			idList.push(int(_info.style[0]));
			needSexList.push(0);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.PET;
		}
		
	}
}
