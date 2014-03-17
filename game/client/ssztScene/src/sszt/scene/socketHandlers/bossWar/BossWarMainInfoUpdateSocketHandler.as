package sszt.scene.socketHandlers.bossWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class BossWarMainInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function BossWarMainInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BOSS_WAR_MAIN_INFO;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			
			var ids:Array = [];
			var times:Array = [];
			if(result)
			{
				var bossType:int = _data.readInt();
				if(bossType == 3)
				{
					var len:int = _data.readInt();
					for(var i:int = 0;i<len;i++)
					{
						ids[i] = _data.readInt();
						times[i] = _data.readInt();
					}
					sceneModule.bossWarInfo.setAcrossData(ids,times);
				}
				else
				{
					var len1:int = _data.readInt();
					for(var j:int = 0;j<len1;j++)
					{
						ids[j] = _data.readInt();
						times[j] = _data.readInt();
					}
					sceneModule.bossWarInfo.setData(ids,times);
				}
			}
			else
			{
//				QuickTips.show("跨服地图未开启!");
				return;
			}
			handComplete();
		}
		
		public static function send(argBossType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BOSS_WAR_MAIN_INFO);
			pkg.writeInt(argBossType);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
	}
}