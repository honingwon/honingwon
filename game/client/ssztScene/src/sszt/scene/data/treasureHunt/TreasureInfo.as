/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-24 下午3:15:53 
 * 
 */ 
package sszt.scene.data.treasureHunt
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.scene.events.TreasureUpdateEvent;

	public class TreasureInfo extends EventDispatcher
	{
		public var treasureMap:ItemInfo;
		
		public function TreasureInfo(target:IEventDispatcher = null)
		{
			super(target);
		} 
		
		public function openMapUpdate(item:ItemInfo) : void
		{
			this.treasureMap = item;
			dispatchEvent(new TreasureUpdateEvent(TreasureUpdateEvent.OPEN_MAP_UPDATE));
		} 
		
		public function identifyMapUpdate(item:ItemInfo) : void
		{
			this.treasureMap = item;
			dispatchEvent(new TreasureUpdateEvent(TreasureUpdateEvent.IDENTIFY_MAP_UPDATE));
		} 
	}
}