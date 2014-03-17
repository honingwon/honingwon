package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.constData.CategoryType;
	import sszt.constData.CareerType;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class ShowMountsCharacterLoader extends LayerCharacterLoader 
	{
		
		public function ShowMountsCharacterLoader(info:ICharacterInfo)
		{
			super(info, SourceClearType.CHANGESCENE_AND_TIME, 300000, 1);
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
			var clothLayer:ILayerInfo;
			var tmpLayer:ILayerInfo;
			var clothT:Boolean = false;
			if(_info.style[0] != 0){
				var temp:int = _info.style[0] / 1000;
				if(temp == 214 || temp == 215 ||temp == 216)
					clothT = true;
			}
			if (_info.style[0] == 0 || clothT || _info.getHideSuit())
			{
				switch (_info.getCareer()){
					case CareerType.SANWU:
						clothLayer = _info.getDefaultLayer(CategoryType.CLOTH_SHANGWU);
						break;
					case CareerType.XIAOYAO:
						clothLayer = _info.getDefaultLayer(CategoryType.CLOTH_XIAOYAO);
						break;
					case CareerType.LIUXING:
						clothLayer = _info.getDefaultLayer(CategoryType.CLOTH_LIUXING);
						break;
				};
			} else {
				clothLayer = _info.getLayerInfoById(_info.style[0]);
			};
			list.push(CharacterManager.pathManager.getSceneItemsPath(clothLayer.picPath, (LayerType.SHOW_MOUNTS + (((info.getSex() == 1)) ? "_1" : "_2"))));
			idList.push(int(clothLayer.picPath));
			needSexList.push(getSex());
			if (((!((_info.style[2] == -1))) && (!((_info.style[2] == 0))))){
				tmpLayer = _info.getLayerInfoById(_info.style[2]);
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpLayer.picPath, LayerType.SHOW_MOUNTS));
				idList.push(int(tmpLayer.picPath));
				needSexList.push(0);
			};
			if (((!((_info.style[3] == -1))) && (!((_info.style[3] == 0))))){
				tmpLayer = _info.getLayerInfoById(_info.style[3]);
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpLayer.picPath, LayerType.SHOW_MOUNTS));
				idList.push(int(tmpLayer.picPath));
				needSexList.push(0);
			};
		}
		override protected function getLayerType():String
		{
			return (LayerType.SHOW_MOUNTS);
		}
		
	}
}
