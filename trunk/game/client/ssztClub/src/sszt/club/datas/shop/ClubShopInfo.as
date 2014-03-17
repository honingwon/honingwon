package sszt.club.datas.shop
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubShopInfoUpdateEvent;
	
	public class ClubShopInfo extends EventDispatcher
	{
		public var selfExploit:int;
		
		public function ClubShopInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update(exploit:int):void
		{
			if(selfExploit == exploit)return;
			selfExploit = exploit;
			dispatchEvent(new ClubShopInfoUpdateEvent(ClubShopInfoUpdateEvent.SELF_EXPLOIT_UPDATE));
		}
	}
}