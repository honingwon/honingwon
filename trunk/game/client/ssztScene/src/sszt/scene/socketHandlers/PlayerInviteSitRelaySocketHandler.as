package sszt.scene.socketHandlers
{
	import flash.geom.Point;
	
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.lifeExpSit.ExpSitPanel;
	import sszt.scene.components.sceneObjs.BaseScenePlayer;
	import sszt.scene.data.roles.BaseScenePlayerInfo;

	/**
	 * 成功双修返回
	 * @author Administrator
	 * 
	 */	
	public class PlayerInviteSitRelaySocketHandler extends BaseSocketHandler
	{
		public function PlayerInviteSitRelaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PALYER_INVITE_SIT_RELAY;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				var id1:Number = _data.readNumber();
				var id2:Number = _data.readNumber();
				var player1:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id1);
				var player2:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id2);
				if(player1)
				{
					player1.info.setSit(true);
				}
				if(player2)
				{
					player2.info.setSit(true);
				}
				if(player1 && player2)
				{
					var p1:Point = new Point(player1.sceneX,player1.sceneY);
					var p2:Point = new Point(player2.sceneX,player2.sceneY);
					sceneModule.sceneInit.playerListController.setPlayerDir(id1,DirectType.checkDir(p1,p2));
					sceneModule.sceneInit.playerListController.setPlayerDir(id2,DirectType.checkDir(p2,p1));
				}
				if(id1 == GlobalData.selfPlayer.userId || id2 == GlobalData.selfPlayer.userId)
				{
					sceneModule.sceneInfo.playerList.setDoubleSit(id1,id2);
					QuickTips.show(LanguageManager.getWord("ssztl.scene.beInDoubleSit"));
					ExpSitPanel.getInstance().show(1);
				}
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(result:Boolean,userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PALYER_INVITE_SIT_RELAY);
			pkg.writeBoolean(result);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}