package sszt.character.loaders
{
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.constData.CategoryType;
	import sszt.constData.CareerType;
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	
	public class ShowMountsRunCharacterLoader extends LayerCharacterLoader 
	{
		
		public function ShowMountsRunCharacterLoader(info:ICharacterInfo)
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
			var tmpPath:String;
			var strength:int;
			var tmpLayerType:String;
			var clothT:Boolean = false;
			if(_info.style[0] != 0){
				var temp:int = _info.style[0] / 1000;
				if(temp == 214 || temp == 215 ||temp == 216)
					clothT = true;
			}
			if (_info.style[0] == 0 || clothT || _info.getHideSuit())
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
				tmpLayerType = LayerType.SHOW_PLAYER + (info.getSex() == 1 ? "_1" : "_2");
			} 
			else {
				clothLayer = _info.getLayerInfoById(_info.style[0]);
				tmpLayerType =  LayerType.SHOW_PLAYER+"_"+info.getCareer()+ (info.getSex() == 1 ? "_1" : "_2");
			}
			list.push(CharacterManager.pathManager.getSceneItemsPath(clothLayer.picPath, tmpLayerType));
			idList.push(int(clothLayer.picPath));
			needSexList.push(getSex());
			
			if (_info.style[1] != -1 && _info.style[1] != 0)
			{
				tmpPath = "";
				tmpLayer = _info.getLayerInfoById(_info.style[1]);
				strength = _info.getWeaponStrength();
				if (strength >= 10){
					tmpPath = ("2" + tmpLayer.picPath);
				} 
				else {
					if (strength >= 7){
						tmpPath = ("1" + tmpLayer.picPath);
					} 
					else {
						tmpPath = tmpLayer.picPath;
					}
				}
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPath, LayerType.SHOW_PLAYER + (info.getSex() == 1 ? "_1" : "_2")));
				idList.push(int(tmpPath));
				needSexList.push(0);
			}
			else
			{
				list.push("");
				idList.push(0);
				needSexList.push(0);
			}
			if (_info.style[3] != -1 && _info.style[3] != 0){
				
				tmpLayer = _info.getLayerInfoById(_info.style[3]);
				tmpPath = tmpLayer.picPath;
				strength = _info.getWindStrength();
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPath, LayerType.SHOW_PLAYER ));
				idList.push(int(tmpLayer.picPath));
				needSexList.push(0);
			}
			else
			{
				list.push("");
				idList.push(0);
				needSexList.push(0);
			}
			if (_info.style[2] != -1 && _info.style[2] != 0)
			{
				tmpLayer = _info.getLayerInfoById(_info.style[2]);
				tmpPath = tmpLayer.picPath;
				strength = _info.getMountsStrengthLevel();
				if(strength < 15)
				{
					tmpLayerType =  LayerType.SHOW_MOUNTS;
				}
				else
				{
					tmpLayerType = LayerType.SHOW_MOUNTS + "_" + Math.floor(strength / 15);
				}
//				tmpLayer = _info.getLayerInfoById(_info.style[2]);
				list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPath,  tmpLayerType));
				idList.push(int(tmpLayer.picPath));
				needSexList.push(0);
			}
			else
			{
				list.push("");
				idList.push(0);
				needSexList.push(0);
			}
			
			
		}
		override protected function getLayerType():String
		{
			return LayerType.MOUNTS_RUN;
		}
		
	}
}
