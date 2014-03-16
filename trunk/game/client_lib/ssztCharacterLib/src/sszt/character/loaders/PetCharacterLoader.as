package sszt.character.loaders
{
	import sszt.character.CharacterManager;
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class PetCharacterLoader extends LayerCharacterLoader 
	{
		
		public function PetCharacterLoader(info:ICharacterInfo)
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
			var tmpPathW:String;
			var strengthW:int;
			var tmpLayer:ILayerInfo =  _info.getLayerInfoById(_info.style[0]);
			tmpPathW = tmpLayer.picPath;
//			strengthW = _info.getMountsStrength();
//			if(strengthW ==0) strengthW = 1;
//			tmpPathW = (Math.ceil( strengthW / 4)+"_" + tmpLayer.picPath);
			
			list.push(CharacterManager.pathManager.getSceneItemsPath(tmpPathW, this.getLayerType()));
			
			idList.push(int(tmpLayer.picPath));
			needSexList.push(0);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.PET;
		}
		
		
		
	}
}
