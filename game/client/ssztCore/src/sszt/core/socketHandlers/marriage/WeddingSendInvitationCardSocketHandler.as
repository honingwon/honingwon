package sszt.core.socketHandlers.marriage
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.marriage.WeddingInvitationInfo;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WeddingSendInvitationCardSocketHandler extends BaseSocketHandler
	{
		public function WeddingSendInvitationCardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SEND_INVITATION_CARD;
		}
		
		override public function handlePackage():void
		{
			var info:WeddingInvitationInfo = new WeddingInvitationInfo();
			info.nick1 = _data.readUTF();
			info.nick2 = _data.readUTF();
			info.type =_data.readShort();
			info.userId =_data.readNumber();
			if(!MapTemplateList.isWeddingMap())
			{
				SetModuleUtils.addMarriage(new ToMarriageData(3,null,info));
			}
			handComplete();
		}
		
		public static function send(list:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SEND_INVITATION_CARD);
			pkg.writeShort(list.length);
			var useId:Number;
			for each(useId in list)
			{
				pkg.writeNumber(useId);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}