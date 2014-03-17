package sszt.activity.socketHandlers
{
	import flash.utils.Dictionary;
	
	import sszt.activity.ActivityModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PlayerActiveStateSocketHandler extends BaseSocketHandler
	{
		public function PlayerActiveStateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ACTIVE_REWARDS_STATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readByte();
			var info:Dictionary = new Dictionary();
			var id:int;
			var isGet:Boolean;
			for(var i:int = 0; i < len; i++)
			{
				id = _data.readByte();
				isGet = _data.readBoolean();
				info[id.toString()] = isGet;
			}
			module.activityInfo.updateActiveRewardsStateInfo(info);
			handComplete();
		}
		
		private function get module():ActivityModule
		{
			return _handlerData as ActivityModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ACTIVE_REWARDS_STATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}