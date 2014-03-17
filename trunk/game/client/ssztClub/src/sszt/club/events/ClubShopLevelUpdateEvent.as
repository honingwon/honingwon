package sszt.club.events
{
	import sszt.events.ModuleEvent;
	
	/**
	 * 用于角色界面兑换功能，更新帮会等级，打开帮会商城 
	 * @author chendong
	 * 
	 */	
	public class ClubShopLevelUpdateEvent extends ModuleEvent
	{
		/**
		 * 选择成就分类按钮 
		 */		
		public static const UPDATE_SHOP_LEVEL:String = "updateShopLevel";
		
		public function ClubShopLevelUpdateEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, obj, bubbles, cancelable);
		}
	}
}