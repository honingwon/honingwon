package sszt.club.components.clubMain.pop.lottery
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.club.datas.lottery.ClubLotteryInfo;
	import sszt.club.events.ClubLotteryInfoUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubLotteryGetTimesSocketHandler;
	import sszt.club.socketHandlers.ClubLotterySocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubLotteryTemplateInfo;
	import sszt.core.data.club.ClubLotteryTemplateList;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubLotterBtnAsset;
	import ssztui.club.ClubTitleLotteryAsset;

	public class ClubLotteryPanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		private var _btnStart:MAssetButton1;
		private var _amount:MAssetLabel;
		private var _cost:MAssetLabel;
		private var _have:MAssetLabel;
		
		private var _itemList:Dictionary;
		private var _cellList:Dictionary = new Dictionary();
		
		private var _cellPos:Array = [
					new Point(142,44),
					new Point(211,74),
					new Point(241,143),
					new Point(211,212),
					new Point(142,242),
					new Point(73,212),
					new Point(43,143),
					new Point(73,74),
		];
		
		private var _currCell:ClubLotteryCell;
		
		public function ClubLotteryPanel(mediator:ClubMediator)
		{
			_itemList = ClubLotteryTemplateList.list;
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new ClubTitleLotteryAsset())),true,-1);
			initView();
			initEvent();
			
			ClubLotteryGetTimesSocketHandler.send();
		}
		private function initView():void
		{
			setContentSize(334,402);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,318,392)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,310,384)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgImg = new Bitmap();
			_bgImg.x = 14;
			_bgImg.y = 8;
			addContent(_bgImg);
			
			_btnStart = new MAssetButton1(new ClubLotterBtnAsset() as MovieClip);
			_btnStart.move(118,119);
			addContent(_btnStart);
			
			_amount = new MAssetLabel("",MAssetLabel.LABEL_TYPE22);
			_amount.move(167,185);
			addContent(_amount);
			
			_cost = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_cost.move(167,347);
			addContent(_cost);
			
			_have = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_have.move(167,365);
			addContent(_have);
			
			var itemId:ClubLotteryTemplateInfo;
			var itemTemplateInfo:ItemTemplateInfo;
			var cell:ClubLotteryCell;
			var i:int = 0;
			var pos:Point;
			for each(itemId in _itemList)
			{
				itemTemplateInfo = ItemTemplateList.getTemplate(itemId.itemTemplateId);
				cell = new ClubLotteryCell();
				addContent(cell);
				pos = _cellPos[i];
				cell.move(pos.x, pos.y)
				cell.info = itemTemplateInfo;
				_cellList[itemId.itemTemplateId] = cell;
				i++
			}
			
			_amount.setHtmlValue("loading...");
			_cost.setHtmlValue(LanguageManager.getWord("ssztl.club.costExploit")+"10");
			_have.setHtmlValue(LanguageManager.getWord("ssztl.club.currentExploit")+GlobalData.selfPlayer.selfExploit.toString());
		}
		private function initEvent():void
		{
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			_btnStart.addEventListener(MouseEvent.CLICK,clickHandler);
			_mediator.clubInfo.clubLotteryInfo.addEventListener(ClubLotteryInfoUpdateEvent.UPDATE_TIMES,updateTimesHandler);
			_mediator.clubInfo.clubLotteryInfo.addEventListener(ClubLotteryInfoUpdateEvent.UPDATE_ITEM_ID,updateItemIdHandler);
		}
		
		private function removeEvent():void
		{
			_btnStart.removeEventListener(MouseEvent.CLICK,clickHandler)
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			_mediator.clubInfo.clubLotteryInfo.removeEventListener(ClubLotteryInfoUpdateEvent.UPDATE_TIMES,updateTimesHandler);
			_mediator.clubInfo.clubLotteryInfo.removeEventListener(ClubLotteryInfoUpdateEvent.UPDATE_ITEM_ID,updateItemIdHandler);
		}
		
		private function updateItemIdHandler(event:Event):void
		{
			var itemTemplateId:int = _mediator.clubInfo.clubLotteryInfo.itemTemplateId;
			_currCell = _cellList[itemTemplateId];
			if(_currCell)_currCell.selected = true;
		}
		
		private function updateTimesHandler(event:Event):void
		{
			_amount.setHtmlValue(_mediator.clubInfo.clubLotteryInfo.times + "/" + ClubLotteryInfo.TIMES_MAX);
		}
		
		private function exploitUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_have.setHtmlValue(LanguageManager.getWord("ssztl.club.currentExploit")+GlobalData.selfPlayer.selfExploit.toString());
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if(_currCell) _currCell.selected = false;
			ClubLotterySocketHandler.send();
		}
		
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.club.ClubLotteryBgAsset",BitmapData) as BitmapData;
		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgImg && _bgImg.bitmapData)
			{
				_bgImg.bitmapData.dispose();
				_bgImg = null;
			}
			_mediator = null;
		}
	}
}