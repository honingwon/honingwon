package sszt.scene.data.collects
{
	import flash.events.Event;
	
	public class CollectItemListUpdateEvent extends Event
	{
		public static const ADD_ITEM:String = "addItem";
		public static const REMOVE_ITEM:String = "removeItem";
		
		public var data:Object;
		public var playRemoveEffect:Boolean;
		public var itemX:Number;
		public var itemY:Number;
		
		public function CollectItemListUpdateEvent(type:String,obj:Object = null,playRemoveEffect:Boolean = false,itemX:Number = 0,itemY:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			this.playRemoveEffect = playRemoveEffect;
			this.itemX = itemX;
			this.itemY = itemY;
			super(type, bubbles, cancelable);
		}
	}
}