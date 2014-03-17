package sszt.core.data.mounts
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MountShowInfo extends EventDispatcher
	{
		public var mountShowItemInfo:MountsItemInfo;
		
		public function MountShowInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function updateMountShowItemInfo(mountItemInfo:MountsItemInfo):void
		{
			if(mountShowItemInfo)
			{
				mountShowItemInfo = null;
			}
			mountShowItemInfo = mountItemInfo;
			dispatchEvent(new MountShowInfoUpdateEvent(MountShowInfoUpdateEvent.MOUNT_SHOW_INFO_LOAD_COMPLETE));
		}
	}
}