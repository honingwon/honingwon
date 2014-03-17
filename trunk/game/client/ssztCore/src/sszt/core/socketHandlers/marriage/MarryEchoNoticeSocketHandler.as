package sszt.core.socketHandlers.marriage
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.ui.container.MAlert;
	
	public class MarryEchoNoticeSocketHandler extends BaseSocketHandler
	{
		/**
		 * 通知求婚方求婚结果
		 * */
		public function MarryEchoNoticeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_ECHO_NOTICE;
		}
		
		override public function handlePackage():void
		{
			var nick:String = _data.readUTF();
			//1  同意2 拒绝 3 特殊拒绝
			var result:int = _data.readShort();
			if(result == 1)
			{
				MAlert.show('对方同意');
			}
			else if(result == 2)
			{
				MAlert.show('对方拒绝');
//				SetModuleUtils.addMarriage(new ToMarriageData(4));
			}
			else
			{
				MAlert.show('特殊拒绝，比如自己的钱不够');
			}
			handComplete();
		}
	}
}