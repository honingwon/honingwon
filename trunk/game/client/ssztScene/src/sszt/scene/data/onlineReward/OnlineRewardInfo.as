package sszt.scene.data.onlineReward
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class OnlineRewardInfo extends EventDispatcher
	{
		public var list:Array;
		public var code:String;
		public var seconds:int;
		public var lastGotRewardId:int;
		public function OnlineRewardInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update(list:Array,seconds:int):void
		{
			this.list = list;
			this.seconds = seconds;
			dispatchEvent(new OnlineRewardInfoUpdateEvent(OnlineRewardInfoUpdateEvent.UPDATE));
		}
		
		public function rewardGot(id:int):void
		{
			lastGotRewardId = id;
			
			if(id==0)
			{
				for(var i:int=0;i<list.length;i++)
				{
					if(list[i]==0)
					{
						list[i] = 1;
					}
				}
			}
			else
			{
				list[id-1] = 1;
			}
			
			dispatchEvent(new OnlineRewardInfoUpdateEvent(OnlineRewardInfoUpdateEvent.UPDATE));
		}
	}
}