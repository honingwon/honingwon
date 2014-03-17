package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.ui.container.MAlert;
	
	public class WeddingEndSocketHandler extends BaseSocketHandler
	{
		public function WeddingEndSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.END_WEDDING;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			if(success)
			{
				MAlert.show('婚礼已结束。');
			}
			handComplete();
		}
	}
}