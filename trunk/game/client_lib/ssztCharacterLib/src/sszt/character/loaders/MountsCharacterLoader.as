package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.constData.CategoryType;
	import sszt.constData.CareerType;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class MountsCharacterLoader extends LayerCharacterLoader 
	{
		
		public function MountsCharacterLoader(info:ICharacterInfo)
		{
			super(info, SourceClearType.TIME, 300000, 2);
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
			var clothLayer:ILayerInfo;
			var tmpLayer:ILayerInfo;
			var tmpPathW:String;
			var strengthW:int;
			if (_info.style[0] == 0)
			{
				switch (_info.getCareer())
				{
					case CareerType.SANWU:
						clothLayer = _info.getDefaultLayer(CategoryType.CLOTH_SHANGWU);
						break;
					case CareerType.XIAOYAO:
						clothLayer = _info.getDefaultLayer(CategoryType.CLOTH_XIAOYAO);
						break;
					case CareerType.LIUXING:
						clothLayer = _info.getDefaultLayer(CategoryType.CLOTH_LIUXING);
						break;
				}
			} 
			else {
				clothLayer = _info.getLayerInfoById(_info.style[0]);
			}
			list.push(CharacterManager.pathManager.getSceneItemsPath(clothLayer.picPath, (LayerType.SCENE_MOUNTS + (((info.getSex() == 1)) ? "_1" : "_2"))));
			idList.push(int(clothLayer.picPath));
			needSexList.push(getSex());
			
			if (_info.style[2] != -1 && _info.style[2] != 0)
			{
				tmpLayer = _info.getLayerInfoById(_info.style[2]);
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpLayer.picPath, LayerType.SCENE_MOUNTS));
				idList.push(int(tmpLayer.picPath));
				needSexList.push(0);
			}
			if (_info.style[3] != -1 && _info.style[3] != 0){
				tmpLayer = _info.getLayerInfoById(_info.style[3]);
				tmpPathW = tmpLayer.picPath;
				strengthW = _info.getWindStrength();
				if (strengthW >= 10){
					tmpPathW = ("1" + tmpLayer.picPath);
				}
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPathW, LayerType.SCENE_MOUNTS));
				idList.push(int(tmpLayer.picPath));
				needSexList.push(0);
			}
		}
		override protected function getLayerType():String
		{
			return LayerType.SCENE_MOUNTS;
		}
		
	}
}
