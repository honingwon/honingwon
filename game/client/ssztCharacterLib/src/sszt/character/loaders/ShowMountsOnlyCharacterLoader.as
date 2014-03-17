package sszt.character.loaders
{
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class ShowMountsOnlyCharacterLoader extends LayerCharacterLoader 
	{
		
		public function ShowMountsOnlyCharacterLoader(info:ICharacterInfo)
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
			if (_completeCount >= _totalCount){
				loadComplete();
			}
		}
		override protected function initList(list:Array, idList:Array, needSexList:Array):void
		{
			var tmpLayer:ILayerInfo;
			var tmpPath:String;
			var strength:int;
			
			tmpLayer = _info.getLayerInfoById(_info.style[0]);
			tmpPath = tmpLayer.picPath;
			strength = _info.getMountsStrengthLevel();
			var tmpLayerType:String;
			if(strength < 15)
			{
				tmpLayerType =  LayerType.SHOW_MOUNTS;
			}
			else
			{
				tmpLayerType = LayerType.SHOW_MOUNTS + "_" + Math.floor(strength  / 15);
			}
			list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPath,  tmpLayerType));
			idList.push(int(_info.style[0]));
			needSexList.push(0);
		}
		
		
		override protected function getLayerType():String
		{
			return LayerType.SHOW_MOUNTS;
		}
		
	}
}
