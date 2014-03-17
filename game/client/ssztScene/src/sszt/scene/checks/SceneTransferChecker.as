/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-15 下午2:15:22 
 * 
 */ 
package sszt.scene.checks
{
	import flash.geom.Point;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.PK.PKType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.UseTransferShoeSocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.SceneMapInfo;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;

	public class SceneTransferChecker
	{
		private static var _mediator:SceneMediator;
		private static var _sceneInfo:SceneInfo;
		
		public static function setup(mediator:SceneMediator):void{
			_mediator = mediator;
			_sceneInfo = _mediator.sceneInfo;
		}
		
		public static function doTransfer(sceneId:int, target:Point, npcId:int=0, checkItem:Boolean=true, checkWalkField:Boolean=false, type:int=0, targetId:int=0):void{
			
			function doTrans():void{
				if (npcId != 0){
					GlobalData.npcId = npcId;
				}
				var self:SelfScenePlayerInfo = _mediator.sceneInfo.playerList.self;
				if (self == null)
				{
					return;
				}
				if (_mediator.sceneModule.sceneInit.playerListController.getSelf() == null )
				{
					return;
				}
				var selfPoint:Point = new Point(self.sceneX, self.sceneY);
				if (self.isSit){
					_mediator.selfSit(false);
				}
				if(GlobalData.currentMapId != 1033 && sceneId ==1033)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.cityCraft.cantFly"));
					return;
				}
				_mediator.stopMoving();
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
				GlobalData.transferType = type;
				GlobalData.transferTarget = targetId;
				UseTransferShoeSocketHandler.send(sceneId, target.x, target.y);
			}
			
			if (npcId != 0){
				type = 1;
				targetId = npcId;
			}
			
			if (checkTransfer(sceneId, target, true, checkItem, checkWalkField, type, targetId)){
				DoubleSitChecker.cancelDoubleSit(doTrans);
			}
		}
		
//		public static function doEnterVip(type:int):void{
//			var doTrans:Function;
//			var type:int = type;
//			doTrans = function ():void{
//				var self:SelfScenePlayerInfo = _mediator.sceneInfo.playerList.self;
//				if (self == null){
//					return;
//				};
//				if ((((_mediator.sceneModule.sceneInit.playerListController.getSelf() == null)) && ((_mediator.sceneModule.sceneInit.mountPlayerListController.getSelf() == null)))){
//					return;
//				};
//				if (self.isSit){
//					_mediator.selfSit(false);
//				};
//				_mediator.stopMoving();
//				GlobalData.selfPlayer.scenePath = null;
//				GlobalData.selfPlayer.scenePathTarget = null;
//				GlobalData.selfPlayer.scenePathCallback = null;
//				VipMapEnterSocketHandler.send(type);
//			};
//			if (((GlobalData.isInCruise) || (GlobalData.isInWedding))){
//				QuickTips.show(LanguageManager.getWord("mhsm.scene.cannotOperate"));
//				return;
//			};
//			if (GlobalData.selfPlayer.isDoubleMount()){
//				QuickTips.show(LanguageManager.getWord("mhsm.scene.doubleMountState"));
//				return;
//			};
//			if (VipType.isVIP(GlobalData.selfPlayer.getVipType())){
//				DoubleSitChecker.cancelDoubleSit(doTrans);
//			};
//		}
		
		private static function checkTransfer(sceneId:int, target:Point, showTip:Boolean=true, checkItem:Boolean=true, checkWalkField:Boolean=false,
											  type:int=0, targetId:int=0):Boolean{
			
			var collectItem:CollectItemInfo;
			var sceneMapInfo:SceneMapInfo;
			var self:SelfScenePlayerInfo = _mediator.sceneInfo.playerList.self;
			
			if (self == null){
				return false;
			}
			
			if (_mediator.sceneModule.sceneInit.playerListController.getSelf() == null)
			{
				return false;
			}
			
			if (sceneId == GlobalData.currentMapId && Point.distance(target, new Point(self.sceneX, self.sceneY)) < 600)
			{
				if (type == 1)
				{
					WalkChecker.doWalkToNpc(targetId);
				} 
				else {
					if (type == 2){
						WalkChecker.doWalkToHangup(targetId);
					} else {
						if (type == 3){
							collectItem = _mediator.sceneInfo.collectList.getNearlyItemByTemplateId(targetId, new Point(self.sceneX, self.sceneY));
							if (collectItem){
								WalkChecker.doWalkToCenterCollect(targetId);
							}
						} 
						else {
							if (type == 4){
								WalkChecker.doWalk(sceneId, target);
							}
						}
					}
				}
				return false;
			}
			
			if(!checkSceneTransfer(showTip))
			{
				return false;
			}
			
			return true;
		}
		
		public static function checkSceneTransfer(showTip:Boolean=true,checkItem:Boolean=true):Boolean
		{
			if(MapTemplateList.getIsPrison())
			{
				if (showTip)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				}
				return false;
			}
			if(_mediator.sceneModule.sceneInit.playerListController.getSelf() == null)
			{
				return false;
			}
			if(GlobalData.copyEnterCountList.isInCopy || _sceneInfo.mapInfo.isBossWar() || _sceneInfo.mapInfo.isSpaScene() || MapTemplateList.isClubWarMap() || MapTemplateList.isShenMoMap() || MapTemplateList.isPerWarMap())
			{
				if (showTip)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				}
				return false;
			}
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				if (showTip)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.cannotUseTransfer"));
				}
				return false;
			}
			if(!_sceneInfo.playerList.self.getIsCommon() && GlobalData.selfPlayer.PKMode != PKType.PEACE)
			{
				if (showTip)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
				}
				return false;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				if (showTip)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				}
				return false;
			}
			if(MapTemplateList.getIsPrison())
			{
				if (showTip)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.sceneUnoperatable"));
				}
				return false;
			}
			if (checkItem && !GlobalData.selfPlayer.canfly())
			{
				if (showTip)
				{
					BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(ShopID.QUICK_BUY));
				}
				return false;
			}
			return true;
		}
	}
}
	