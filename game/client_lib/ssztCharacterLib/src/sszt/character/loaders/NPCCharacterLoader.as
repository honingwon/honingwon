package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class NPCCharacterLoader extends LayerCharacterLoader 
	{
		
		public function NPCCharacterLoader(info:ICharacterInfo)
		{
			super(info, SourceClearType.CHANGESCENE_AND_TIME, 500000, 20);
		}
		override protected function layerCompleteHandler(layer:Object):void
		{
			super.layerCompleteHandler(layer);
			_completeCount++;
			if (_pathList == null){
				return;
			}
			var index:int = _pathList.indexOf(layer.path);
			if (index > -1){
				_loaders[index] = layer;
			}
			if (_completeCount >= _totalCount){
				loadComplete();
			}
		}
		override protected function initList(list:Array, idList:Array, needSexList:Array):void
		{
			list.push(CharacterManager.pathManager.getSceneNpcItemsPath(String(_info.style[0])));
			idList.push(_info.style[0]);
			needSexList.push(0);
		}
		override protected function getLayerType():String
		{
			return (LayerType.SCENE_NPC);
		}
		
	}
}
