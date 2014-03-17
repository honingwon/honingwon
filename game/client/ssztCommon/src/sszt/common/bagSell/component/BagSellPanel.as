package sszt.common.bagSell.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.common.bagSell.BagSellController;
	import sszt.common.npcStore.components.BuyPanel;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.vip.TitleAsset;
	import ssztui.vip.TopInfoBgAsset;
	
	public class BagSellPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _buyPanel:SellPanel;
		private var _controller:BagSellController;
		
		public function BagSellPanel(controller:BagSellController)
		{
			_controller = controller;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.SellTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.SellTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1,true,true);
//			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.NPC_STORE));
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			setContentSize(275,148);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,259,138)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,251,130)),
			]);
			addContent(_bg as DisplayObject);
			
			_buyPanel = new SellPanel(_controller,1);
			_buyPanel.move(9, 4);
			addContent(_buyPanel);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.CLEAR_SELL_CELL,clearCellList);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.CLEAR_SELL_CELL,clearCellList);
		}
		
		
		private function clearCellList(e:CommonModuleEvent):void
		{
			_buyPanel.clearCellList();
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
			_controller = null;
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