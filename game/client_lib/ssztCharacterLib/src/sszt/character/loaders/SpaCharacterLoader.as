package sszt.character.loaders
{
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class SpaCharacterLoader extends LayerCharacterLoader 
	{
		
		public function SpaCharacterLoader(info:ICharacterInfo)
		{
			super(info);
		}
		override protected function layerCompleteHandler(layer:Object):void
		{
			if (_pathList == null){
				return;
			};
			super.layerCompleteHandler(layer);
			_completeCount++;
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
			list.push(CharacterManager.pathManager.getSceneSpaPath(_info.getSex()));
			idList.push(int(_info.style[0]));
			needSexList.push(_info.getSex());
		}
		override protected function getLayerType():String
		{
			return (LayerType.SPA);
		}
		
	}
}
