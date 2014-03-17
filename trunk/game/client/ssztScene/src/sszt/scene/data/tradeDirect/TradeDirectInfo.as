package sszt.scene.data.tradeDirect
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.scene.components.tradeDirect.TradeDirectCell;
	
	public class TradeDirectInfo extends EventDispatcher
	{
//		public var selfItems:Vector.<ItemInfo>;
//		public var otherItems:Vector.<ItemInfo>;
		public var selfItems:Array;
		public var otherItems:Array;
		public var selfLock:Boolean;
		public var otherLock:Boolean;
		public var selfSure:Boolean;
		public var otherSure:Boolean;
		public var otherCopper:int;
		
		public function TradeDirectInfo()
		{
//			selfItems = new Vector.<ItemInfo>();
//			otherItems = new Vector.<ItemInfo>();
			selfItems = [];
			otherItems = [];
			selfLock = false;
			otherLock = false;
			selfSure = false;
			otherSure = false;
		}
		
		public function addSelfItem(place:int):void
		{
			var item:ItemInfo = GlobalData.bagInfo.getItem(place);
			if(item)
			{
				item.tradeLock = true;
				if(selfItems.indexOf(item) == -1)
				{
					selfItems.push(item);
					dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.ADDSELFITEM,item));
				}
			}
		}
		public function removeSelfItem(id:Number):void
		{
			var item:ItemInfo;
			for(var i:int = 0; i < selfItems.length; i++)
			{
				if(selfItems[i].itemId == id)
				{
					item = selfItems.splice(i,1)[0];
					break;
				}
			}
			if(item)
			{
				dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.REMOVESELFITEM,id));
			}
		}
		public function setSelfLock(value:Boolean):void
		{
			if(selfLock == value)return;
			selfLock = value;
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.SELFLOCK_UPDATE));
		}
		public function setSelfSure(value:Boolean):void
		{
			if(selfSure == value)return;
			selfSure = value;
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.SELFSURE_UPDATE));
		}
		
		public function addOtherItem(item:ItemInfo):void
		{
			for each(var i:ItemInfo in otherItems)
			{
				if(i.itemId == item.itemId)return;
			}
			otherItems.push(item);
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.ADDOTHERITEM,item));
		}
		public function removeOtherItem(id:Number):void
		{
			var item:ItemInfo;
			for(var i:int = 0; i < otherItems.length; i++)
			{
				if(otherItems[i].itemId == id)
				{
					item = otherItems.splice(i,1)[0];
					break;
				}
			}
			if(item)
			{
				dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.REMOVEOTHERITEM,id));
			}
		}
		public function setOtherLock(value:Boolean):void
		{
//			if(otherLock == value)return;
			otherLock = value;
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.OTHERLOCK_UPDATE));
		}
		public function setOtherSure(value:Boolean):void
		{
//			if(otherSure == value)return;
			otherSure = value;
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.OTHERSURE_UPDATE));
		}
		public function setOtherCopper(value:int):void
		{
//			if(otherCopper == value)return;
			otherCopper = value;
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.OTHERCOPPER_CHANGE));
		}
		
		public function doCancel(type:int):void
		{
			doClear();
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.DOCANCEL,type));
		}
		
		public function doComplete():void
		{
			doClear();
			dispatchEvent(new TradeDirectInfoUpdateEvent(TradeDirectInfoUpdateEvent.DOCOMPLETE));
		}
		
		public function doClear():void
		{
			for(var i:int = 0; i < selfItems.length; i++)
			{
				selfItems[i].tradeLock = false;
			}
			selfItems.length = 0;
			otherItems.length = 0;
			selfLock = false;
			otherLock = false;
			selfSure = false;
			otherSure = false;
		}
	}
}