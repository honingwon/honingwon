/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-24 下午3:16:41 
 * 
 */ 
package sszt.scene.events
{
	import flash.events.Event;

	public class TreasureUpdateEvent extends Event
	{
		
		public var data:Object;
		public static const OPEN_MAP_UPDATE:String = "openMapUpdate";
		public static const IDENTIFY_MAP_UPDATE:String = "identifyMapUpdate";
		
		public function TreasureUpdateEvent(type:String, obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.data = obj;
			super(type, bubbles, cancelable);
		}
	}
}