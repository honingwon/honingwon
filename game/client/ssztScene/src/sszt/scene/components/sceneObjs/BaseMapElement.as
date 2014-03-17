package sszt.scene.components.sceneObjs
{
	import sszt.core.data.scene.MapElementInfo;
	
	import scene.sceneObjs.BaseSceneObj;

	/**
	 * 地图场景元素
	 * @author Administrator
	 * 
	 */	
	public class BaseMapElement extends BaseSceneObj
	{		
		public function BaseMapElement(info:MapElementInfo)
		{
			super(info);
		}
		
		public function getMapElementInfo():MapElementInfo
		{
			return _info as MapElementInfo;
		}
	}
}