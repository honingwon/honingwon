package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.lifeExpSit.ExpSitPanel;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class PlayerSitSocketHandler extends BaseSocketHandler
	{
		public function PlayerSitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_SIT;
		}
		
		override public function handlePackage():void
		{
			//打坐状态：非打坐0，普通打坐1，历练专修2
//			var isSit:Boolean = _data.readBoolean();
			var id:Number = _data.readNumber();
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				var result:int = _data.readByte()
				if(!player.getIsDead())
				{
					if(result == 0)
					{
						player.setSit(false);
						player.setLifexpSit(false);
						if(sceneModule.sceneInfo.playerList.isSitParner(id))
						{
							if(id != GlobalData.selfPlayer.userId)
							{
								QuickTips.show(LanguageManager.getWord("ssztl.scene.doubleSitCannel"));
							}
							sceneModule.sceneInfo.playerList.clearDoubleSit();
						}
					}
					else if(result == 1)
					{
						player.setSit(true);
						player.setLifexpSit(false);
						if(id == GlobalData.selfPlayer.userId)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.scene.beInSit"));
//							QuickTips.show(LanguageManager.getWord("ssztl.scene.beNotInLifexpSit"));
								ExpSitPanel.getInstance().show(1);
						}
					}
					else if(result == 2)
					{
						player.setLifexpSit(true);
						if(id == GlobalData.selfPlayer.userId)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.scene.beInLifexpSit"));
								ExpSitPanel.getInstance().show(2);
						}
						
					}
				}
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(sit:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_SIT);
			pkg.writeBoolean(sit);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}