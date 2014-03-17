package sszt.scene.data.collects
{
	import sszt.scene.data.BaseActionInfo;
	
	public class CollectActionInfo extends BaseActionInfo
	{
		public var collectId:int;
		
		public function CollectActionInfo(collectId:int)
		{
			this.collectId = collectId;
			super();
		}
	}
}