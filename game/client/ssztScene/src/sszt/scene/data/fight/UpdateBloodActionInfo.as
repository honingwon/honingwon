package sszt.scene.data.fight
{
	import sszt.scene.data.BaseActionInfo;
	
	public class UpdateBloodActionInfo extends BaseActionInfo
	{
		public var blood:int;
		public var mp:int;
		public var isSelf:Boolean = false;
		public function UpdateBloodActionInfo()
		{
			super();
		}
	}
}