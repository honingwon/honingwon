package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.characterActions.UpdateBloodAction;
	import sszt.scene.data.fight.UpdateBloodActionInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	
	public class TargetUpdateBloodSocketHandler extends BaseSocketHandler
	{
		public function TargetUpdateBloodSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_UPDATE_BLOOD;
		}
		
		override public function handlePackage():void
		{
			var type:int = _data.readByte();
			var id:Number = _data.readNumber();
			var role:BaseRoleInfo = sceneModule.sceneInfo.getRoleInfo(type,id);
			if(role)
			{
				
				var playAction:Boolean = _data.readBoolean();
				var info:UpdateBloodActionInfo = new UpdateBloodActionInfo();
//				info.blood = _data.readInt();
//				info.mp = _data.readInt();
				if(id == GlobalData.selfPlayer.userId )
				{
					info.isSelf = true;
				}
				var blood:int = _data.readInt();
				var mp:int = _data.readInt();
				var currentHp:int = _data.readInt();
				var currentMp:int = _data.readInt();
				if(!role.getIsDead())
				{
					info.blood = blood;
					info.mp = mp;
					if(playAction)
						role.addAction(new UpdateBloodAction(info));
//					role.currentHp += info.blood;
//					role.currentMp += info.mp;
					role.currentHp = currentHp;
					role.currentMp = currentMp;
				}
				
				if(sceneModule.sceneInfo.teamData)
				{
					var teamplayer:TeamScenePlayerInfo = sceneModule.sceneInfo.teamData.getPlayer(id);
					if(teamplayer)
					{
						teamplayer.currentHp = role.currentHp;
						teamplayer.currentMp = role.currentMp;
					}
				}
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}