package sszt.club.datas.deviceInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubDeviceUpdateEvent;
	
	public class ClubDeviceInfo extends EventDispatcher
	{
		public var shopLevel:int;                //商城等级
		public var furnaceLevel:int;             //神炉等级
		public var shop1Exploit:int;             //1级商店需求贡献
		public var shop2Exploit:int;             //2级商店需求贡献
		public var shop3Exploit:int;             //3级商店需求贡献
		public var shop4Exploit:int;             //4级商店需求贡献
		public var shop5Exploit:int;             //5级商店需求贡献
		public var furnaceExploit:int;           //神炉需求贡献
		
		public function ClubDeviceInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new ClubDeviceUpdateEvent(ClubDeviceUpdateEvent.DEVICE_UPDATE));
		}
	}
}