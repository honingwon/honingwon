package sszt.scene.components.bank
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.bank.bankTabPanel.BankTabPanel;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class BankMainPanel extends MPanel
	{
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _picPath:String;
		private var _bankTabPanel:BankTabPanel;
		
		
		public function BankMainPanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.BankAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.BankAsset") as Class)());
			}
			super(new MCacheTitle1('',title), true, -1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(606,376);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,590,343)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgLayout = new Bitmap();
			_bgLayout.x = 13;
			_bgLayout.y = 7;
			addContent(_bgLayout);
//			_picPath = GlobalAPI.pathManager.getBannerPath("cityFightBg.jpg");
//			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
//			_bg2 = BackgroundUtils.setBackground([
//				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(259,221,38,38),new Bitmap(CellCaches.getCellBg())),
////				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(309,221,38,38),new Bitmap(CellCaches.getCellBg())),
//			]);
//			addContent(_bg2 as DisplayObject);
			
//			_enterBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.cityCraft.joinActive'));
//			_enterBtn.move(253,323);
//			if(!MapTemplateList.isResourceWarMap())
//			{
//				addContent(_enterBtn);
//			}			
			
			_bankTabPanel = new BankTabPanel(_mediator);
			_bankTabPanel.move(9,26);
			addContent(_bankTabPanel);
			
//			updateNickAndDays();
//			
//			var itemId:int;
//			var itemTemplateInfo:ItemTemplateInfo;
//			var cell:ResourceWarRewardCell;
//			var i:int = 0;
//			var pos:Point;
//			for each(itemId in _itemList)
//			{
//				itemTemplateInfo = ItemTemplateList.getTemplate(itemId);
//				cell = new ResourceWarRewardCell();
//				addContent(cell);
//				pos = CELL_POS[i];
//				cell.move(pos.x, pos.y)
//				cell.info = itemTemplateInfo;
//				_cellList.push(cell);
//				i++;
//			}
		}

		
		private function initEvent():void
		{
//			GlobalData.cityCraftInfo.addEventListener(CityCraftEvent.DAYS_UPDATE,daysUpdateHandler);
//			CityCraftDaysInfoSocketHandler.send();
//			_enterBtn.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
		}
		
		private function removeEvent():void
		{
//			_enterBtn.removeEventListener(MouseEvent.CLICK,btnEnterClickHandler);
//			GlobalData.cityCraftInfo.removeEventListener(CityCraftEvent.DAYS_UPDATE,daysUpdateHandler);
		}
		
		private function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.cityCraft.joinRules"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
		}
		
		override public function dispose():void
		{
			removeEvent();
			_bgLayout = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
//			if(_enterBtn)
//			{
//				_enterBtn.dispose();
//				_enterBtn = null;
//			}
			super.dispose();
		}
	}
}