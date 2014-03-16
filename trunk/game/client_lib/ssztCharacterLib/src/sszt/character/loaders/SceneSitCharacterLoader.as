package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.constData.CategoryType;
	import sszt.constData.CareerType;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class SceneSitCharacterLoader extends LayerCharacterLoader 
	{
		
		public function SceneSitCharacterLoader(info:ICharacterInfo)
		{
			super(info, SourceClearType.TIME, 300000, 2);
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
			var tmpLayer:ILayerInfo;
			var strength:int;
			var tmpPathW:String;
			var strengthW:int;
			
			var clothLayer:ILayerInfo;
			var tmpLayerType:String;
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
				}
				tmpLayerType = LayerType.SCENE_SIT + (info.getSex() == 1 ? "_1" : "_2");
			} else {
				clothLayer = _info.getLayerInfoById(_info.style[0]);
				tmpLayerType =  LayerType.SCENE_SIT+"_"+info.getCareer()+ (info.getSex() == 1 ? "_1" : "_2");
			}
			list.push(CharacterManager.pathManager.getSceneItemsPath(clothLayer.picPath, tmpLayerType));
			idList.push(int(clothLayer.picPath));
			needSexList.push(getSex());
			
//			if (_info.style[3] != -1 && _info.style[3] != 0)
//			{
//				tmpLayer = _info.getLayerInfoById(_info.style[3]);
//				tmpPathW = tmpLayer.picPath;
//				strengthW = _info.getWindStrength();
//				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPathW, LayerType.SCENE_SIT+("_"+info.getCareer()) + (info.getSex() == 1 ? "_1" : "_2")+ ( strengthW >= 10 ? "_1":"")));
//				idList.push(int(tmpLayer.picPath));
//				needSexList.push(0);
//			}
//			else
//			{
//				list.push("");
//				idList.push(0);
//				needSexList.push(0);
//			}
			
		}
		override protected function getLayerType():String
		{
			return (LayerType.SCENE_SIT);
		}
		
	}
}
