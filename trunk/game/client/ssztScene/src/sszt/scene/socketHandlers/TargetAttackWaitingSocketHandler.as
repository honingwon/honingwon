package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.characterActions.BaseCharacterAction;
	import sszt.scene.actions.characterActions.MonsterCancelAttackAction;
	import sszt.scene.actions.characterActions.MonsterWaitAttackAction;
	import sszt.scene.actions.characterActions.PetWaitAttackAction;
	import sszt.scene.actions.characterActions.PlayerCancelAttackAction;
	import sszt.scene.actions.characterActions.PlayerWaitAttackAction;
	import sszt.scene.data.BaseActionInfo;
	import sszt.scene.data.fight.AttackActionInfo;
	import sszt.scene.data.fight.CancelAttackActionInfo;
	import sszt.scene.data.fight.WaitAttackActionInfo;
	
	public class TargetAttackWaitingSocketHandler extends BaseSocketHandler
	{
		public function TargetAttackWaitingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_ATTACKED_WAITING;
		}
		
		override public function handlePackage():void
		{
			var roleType:int = _data.readByte();
			var id:Number = _data.readNumber();
//			if(MapElementType.isPlayer(roleType))
//			{
//				if(id == GlobalData.selfPlayer.userId)return;
//			}
			var player:BaseRoleInfo = sceneModule.sceneInfo.getRoleInfo(roleType,id);
			if(player)
			{
				//1蓄气，2打断
				var action:BaseCharacterAction;
				var state:int = _data.readByte();
				player.setAttackState(state);
				if(!player.getIsReady())
				{
					//玩家回复
					var cancelActionInfo:CancelAttackActionInfo = new CancelAttackActionInfo();
//					player.setNewAttackStateAttack();
//					player.setFightState();
					if(MapElementType.isPlayer(roleType))
					{
						action = new PlayerCancelAttackAction(cancelActionInfo);
					}
					else
					{
						action = new MonsterCancelAttackAction(cancelActionInfo);
					}
				}
				else
				{
					//玩家攻击
					var waitActionInfo:AttackActionInfo = new AttackActionInfo();
					waitActionInfo.skill = _data.readInt();
					waitActionInfo.level = _data.readByte();
					waitActionInfo.targetX = _data.readInt();
					waitActionInfo.targetY = _data.readInt();
//					player.setNewAttackReady();
//					player.setReadyState();
					if(MapElementType.isPlayer(roleType))
					{
						action = new PlayerWaitAttackAction(waitActionInfo);
					}
					if(MapElementType.isPet(roleType))
					{
						action = new PetWaitAttackAction(waitActionInfo);
					}
					else
					{
						action = new MonsterWaitAttackAction(waitActionInfo);
					}
				}
				if(id != GlobalData.selfPlayer.userId)player.addAction(action);
			}
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TARGET_ATTACKED_WAITING);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}