package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class YuanBaoScoreUpdateSocketHandler extends BaseSocketHandler
	{
		public function YuanBaoScoreUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.YUANBAO_SCORE;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.updateYuanBaoScore(_data.readInt());
		}
	}
}