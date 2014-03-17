package sszt.core.data.scene
{
	import sszt.core.data.scene.BaseSceneObjInfo;

	public class MapElementInfo extends BaseSceneObjInfo
	{
		public var id:int;
		public var templateId:int;
		
		public function MapElementInfo()
		{
		}
		
		override public function getObjId():Number
		{
			return templateId;
		}
	}
}