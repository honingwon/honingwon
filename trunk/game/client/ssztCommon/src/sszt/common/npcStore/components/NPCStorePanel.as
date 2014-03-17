package sszt.common.npcStore.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.common.npcStore.controllers.NPCStoreController;
	import sszt.common.npcStore.events.NPCStoreEvent;
	import sszt.constData.CommonConfig;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.shop.BuyBackInfoUpdateEvent;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.data.shop.ShopTemplateInfo;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemRepairSocketHandler;
	import sszt.core.socketHandlers.common.ItemSellSocketHandler;
	import sszt.core.socketHandlers.store.ItemBuyBackSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	public class NPCStorePanel extends MPanel
	{
		private var _controller:NPCStoreController;
		private var _shopType:int = 0;
		private var _defaultPlace:int;
		private var _defaultCount:int;
		private var _npcInfo:NpcTemplateInfo;

		private var _bg:IMovieWrapper;

		
		private var _buyPanel:BuyPanel;
		private var _sellPanel:SellPanel;
		
		public function NPCStorePanel(control:NPCStoreController,data:ToNpcStoreData)
		{
			if(data)
			{
				_shopType = data.type;
				_defaultPlace = data.defaultPlace;
				_defaultCount = data.defaultCount;
				_npcInfo = NpcTemplateList.getNpc(data.npcId);
			}
			_controller = control;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.NPCStoreTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.NPCStoreTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title), true, -1,true,false);
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.NPC_STORE));
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(365,415);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8, 4, 349, 403)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13, 9, 339, 332)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13, 343, 339, 59)),
				
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(20, 16, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(183, 16, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(20, 74, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(183, 74, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(20, 132, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(183, 132, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(20, 190, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(183, 190, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(20, 248, 162, 56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(183, 248, 162, 56)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(28, 25, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191, 25, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(28, 83, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191, 83, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(28, 141, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191, 141, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(28, 199, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191, 199, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(28, 257, 38, 38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191, 257, 38, 38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(85, 363, 60, 22)),
//				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(141, 275, 88, 20)),
				//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(192, 367, 16, 14), new Bitmap(MoneyIconCaches.bingCopperAsset)),
			]);
			addContent(_bg as DisplayObject);
			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(10,313,285,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.sellItemList"),MAssetLabel.LABEL_TYPE_TITLE2)));
			
			_sellPanel = new SellPanel(_controller,_shopType, _defaultPlace, _defaultCount);
			_sellPanel.move(13,9);
			addContent(_sellPanel);
			
//			_buyPanel = new BuyPanel(_controller,_shopType);
//			_buyPanel.move(8, 308);
//			addContent(_buyPanel);
			
			move(214,62);
			initEvent();
			
			setGuideTipHandler(null);
		}
		
		private function initEvent():void
		{
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.CLEAR_SELL_CELL,clearCellList);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
			_sellPanel.addEventListener(NPCStoreEvent.CLOSE_PANEL,closePanelHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.CLEAR_SELL_CELL,clearCellList);
			_sellPanel.removeEventListener(NPCStoreEvent.CLOSE_PANEL,closePanelHandler);
		}
		
		private function closePanelHandler(e:NPCStoreEvent):void
		{
			dispose();
		}
		
		private function changeSceneHandler(e:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.NPC_STORE)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
		private function clearCellList(e:CommonModuleEvent):void
		{
//			_buyPanel.clearCellList();
		}
		
		private function selfMoveHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			if(_npcInfo == null)return;
			var selfInfo:BaseSceneObjInfo = e.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_controller = null;
			_npcInfo = null;
			if(_sellPanel)
			{
				_sellPanel.dispose();
				_sellPanel = null;
			}
			if(_buyPanel)
			{
				_buyPanel.dispose();
				_buyPanel = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			super.dispose();
			
		}
	}
}