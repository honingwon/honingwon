package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	
	public class PlayerAttackSocketHandler extends BaseSocketHandler
	{
		public function PlayerAttackSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ATTACK;
		}
		
//		override public function handlePackage():void
//		{
//			//攻击无效
//			if(sceneModule.sceneInfo.playerList.self)
//				sceneModule.sceneInfo.playerList.self.attackBack();
//			handComplete();
//		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		/**
		 * 
		 * @param targetId 目标ID，如果没有目标则传0
		 * @param targetType 目标类型，如果没有目标则传0
		 * @param attackType 技能ID
		 * @param targetX 目标位置，某些技能需要位置
		 * @param targetY 
		 * 
		 */		
		public static function sendAttack(targetId:Number,targetType:int,attackType:int,targetX:int = 0,targetY:int = 0):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ATTACK);
			pkg.writeNumber(GlobalData.selfPlayer.userId);
			pkg.writeNumber(targetId);
			pkg.writeByte(targetType);
			pkg.writeInt(attackType);
			pkg.writeInt(targetX);
			pkg.writeInt(targetY);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}