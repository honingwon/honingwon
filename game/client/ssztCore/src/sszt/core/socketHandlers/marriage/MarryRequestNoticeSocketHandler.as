package sszt.core.socketHandlers.marriage
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.marriage.MarryRequestInfo;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	
	/**
	 * 被求婚者处理求婚请求面板
	 * */
	public class MarryRequestNoticeSocketHandler extends BaseSocketHandler
	{
		public function MarryRequestNoticeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_REQUEST_NOTICE
		}
		
		override public function handlePackage():void
		{
			var info:MarryRequestInfo = new MarryRequestInfo();
			info.weddingType = _data.readShort();
			info.nick = _data.readUTF();
			info.relation = _data.readShort();//1正房 妻 2偏房 妾
			SetModuleUtils.addMarriage(new ToMarriageData(1,info))
			handComplete();
		}
	}
}