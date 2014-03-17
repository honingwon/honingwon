/** 
 * @author Aron 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-24 上午9:18:34 
 * 
 */ 
package sszt.club.components.clubMain.pop.sec.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.items.ClubApplyItem;
	import sszt.club.components.clubMain.pop.items.MClubCacheSelectBtn;
	import sszt.club.components.clubMain.pop.sec.IClubMainPanel;
	import sszt.club.datas.tryin.TryinItemInfo;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubDeviceUpdateEvent;
	import sszt.club.events.TryinUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubClearTryinPageSocketHandler;
	import sszt.club.socketHandlers.ClubClearTryinSocketHandler;
	import sszt.club.socketHandlers.ClubLevelUpSocketHandler;
	import sszt.club.socketHandlers.ClubUpgradeDeviceSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.ClubFurnaceLevelTemplate;
	import sszt.core.data.club.ClubFurnaceTemplateList;
	import sszt.core.data.club.ClubLevelTemplate;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.data.club.ClubShopLevelTemplate;
	import sszt.core.data.club.ClubShopLevelTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.icon.MCacheIcon1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	public class ApplyPanel extends MSprite implements IClubMainPanel
	{
		
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _rowBg:Shape;
		
		private var _tile:MTile;
		private var _list:Array;
		private var _pageView:PageView;
//		private var _clearCurrentBtn:MCacheAssetBtn1;
		private var _clearAllBtn:MCacheAssetBtn1;
		
		private const PAGESIZE:int = 11;
		
		public function ApplyPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initTryinInfo();
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,455,353)),				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,51,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,76,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,101,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,126,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,151,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,176,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,201,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,226,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,251,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,276,449,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(3,301,449,2)),
				
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,4,447,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(130,5,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(172,5,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(234,5,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(276,5,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,5,2,20),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,7,125,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyPlayerName"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(132,7,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(174,7,60,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(236,7,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.sex"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(278,7,80,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyTime"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(360,7,90,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2))
				
			]);
			addChild(_bg as DisplayObject);		
			_rowBg = new Shape();	
			_rowBg.graphics.beginFill(0x172527,1);
			_rowBg.graphics.drawRect(3,53,449,23);
			_rowBg.graphics.drawRect(3,103,449,23);
			_rowBg.graphics.drawRect(3,153,449,23);
			_rowBg.graphics.drawRect(3,203,449,23);
			_rowBg.graphics.drawRect(3,253,449,23);
			_rowBg.graphics.endFill();
			addChild(_rowBg);
			
			_list = [];
			_tile = new MTile(447,25);
			_tile.setSize(448,275);
			_tile.move(5,27);
			_tile.itemGapH = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			addChild(_tile);
			
			_pageView = new PageView(PAGESIZE);
			_pageView.move(142,314);
			addChild(_pageView);
			
//			_clearCurrentBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.cleanCurPage"));
//			_clearCurrentBtn.move(300,313);
//			addChild(_clearCurrentBtn);
			_clearAllBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.cleanAll"));
			_clearAllBtn.move(373,313);
			addChild(_clearAllBtn);
			
			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty))
			{
				//_clearAllBtn.enabled = _clearCurrentBtn.enabled = true;
				_clearAllBtn.visible = true;
			}
			else
			{
				//_clearAllBtn.enabled = _clearCurrentBtn.enabled = false;
				_clearAllBtn.visible = false;
			}
			
			getData();
			initEvent();
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function initEvent():void
		{
			_mediator.clubInfo.clubTryinInfo.addEventListener(TryinUpdateEvent.TRYIN_UPDATE,tryinUpdateHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
//			_clearCurrentBtn.addEventListener(MouseEvent.CLICK,clearCurrentClickHandler);
			_clearAllBtn.addEventListener(MouseEvent.CLICK,clearAllClickHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.clubInfo.clubTryinInfo.removeEventListener(TryinUpdateEvent.TRYIN_UPDATE,tryinUpdateHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
//			_clearCurrentBtn.removeEventListener(MouseEvent.CLICK,clearCurrentClickHandler);
			_clearAllBtn.removeEventListener(MouseEvent.CLICK,clearAllClickHandler);
		}
		
		private function tryinUpdateHandler(e:TryinUpdateEvent):void
		{
			_tile.clearItems();
			for each(var i:ClubApplyItem in _list)
			{
				i.dispose();
			}
			_list.length = 0;
			var list:Array = _mediator.clubInfo.clubTryinInfo.list;
			for each(var j:TryinItemInfo in list)
			{
				var item:ClubApplyItem  = new ClubApplyItem(j,acceptHandler,refuseHandler);
				_list.push(item);
				_tile.appendItem(item);
			}
			
			_pageView.totalRecord = _mediator.clubInfo.clubTryinInfo.totalListNum;
			if(list.length == 0)
			{
//				_clearCurrentBtn.visible = false;
				_clearAllBtn.visible = false;
			}else
			{
//				_clearCurrentBtn.visible = true;
				_clearAllBtn.visible = true;
			}
		}
		
		private function refuseHandler(info:TryinItemInfo):void
		{
			_mediator.refuseTryIn(info.id,_pageView.currentPage,PAGESIZE);
		}
		private function acceptHandler(info:TryinItemInfo):void
		{
			_mediator.acceptTryin(info.id,_pageView.currentPage,PAGESIZE);
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			getData();
		}
		
		private function clearCurrentClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ClubClearTryinPageSocketHandler.send(_pageView.currentPage,PAGESIZE);
		}
		
		private function clearAllClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ClubClearTryinSocketHandler.send();
		}
		
		private function getData():void
		{
			_mediator.getTryinData(_pageView.currentPage,PAGESIZE);
		}
		
		public function show():void
		{
			_pageView.setPage(1,false);
			getData();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_rowBg)
			{
				_rowBg = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_list)
			{
				for each(var item:ClubApplyItem in _list)
				{
					item.dispose();
				}
			}
			_list = null;
			_mediator.clubInfo.clearTryinInfo();
			_mediator = null;
			super.dispose();
		}
		
	}
}