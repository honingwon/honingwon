package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftBOSSCallSocketHandler extends BaseSocketHandler
	{
		public function CityCraftBOSSCallSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var isSuccessful:Boolean  = _data.readBoolean();
			var errorCode:int = _data.readInt();
			if(isSuccessful)
			{
				QuickTips.show('操作成功');
			}
			else
			{
				switch(errorCode)
				{
					case 51 :
						QuickTips.show('权限不足。');
						break;
					case 61 :
						QuickTips.show('帮会财富不足。');
						break;
					case 21095 :
						QuickTips.show('无法开启，请过一段时间之后再试。');
						break;
					case 21096 :
						QuickTips.show('剩余次数为0。');
						break;
				}
			}			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_SUMMON;
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_SUMMON);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}