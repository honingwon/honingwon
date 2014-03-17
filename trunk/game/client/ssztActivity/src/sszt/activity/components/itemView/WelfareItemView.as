package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.activity.GitfIconAsset;
	import sszt.activity.components.cell.AwardCell;
	import sszt.activity.components.cell.WelfFareCell;
	import sszt.activity.data.itemViewInfo.GiftItemInfo;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.constData.PlatType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.WelfareTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class WelfareItemView extends Sprite
	{
		private var _mediator:ActivityMediator;
		private var _giftInfo:GiftItemInfo;
		private var _descriptionLabel:TextField;
		private var _cardBtn:MCacheAsset1Btn;
		private var _getBtn:MCacheAsset1Btn;
		private var _bg:IMovieWrapper;
		private var _gift:Bitmap;
		
		public function WelfareItemView(item:GiftItemInfo,argMediator:ActivityMediator)
		{
			super();
			_giftInfo = item;
			_mediator = argMediator;
			initialView();
			_mediator.searchWelf(_giftInfo.id);
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
									new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,591,102)),
									new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(3,3,586,22))
			]);
			addChild(_bg as DisplayObject);
			
			if(_giftInfo.title == "")
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(265,6,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.rookieGift"),MAssetLabel.LABELTYPE1)));
			}else
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(265,6,52,16),new MAssetLabel(_giftInfo.title,MAssetLabel.LABELTYPE1)));
			}
			
			_gift = new Bitmap(new GitfIconAsset());
			_gift.x = 18;
			_gift.y = 36;
			addChild(_gift);
			
			_cardBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.activity.getRookieCard"));
			_cardBtn.move(495,31);
			addChild(_cardBtn);
			
			_getBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.activity.exchangeRookieGift"));
			_getBtn.move(495,64);
			addChild(_getBtn);
			_getBtn.enabled = false;
			
			initLinkView();		
			initialEvents();
		}
		
		private function initLinkView():void
		{
			var currentH:int = 33;
			var currentW:int = 96;		
			var str:String = _giftInfo.descript;
			var strArray:Array = str.split("#");
			var ids:Array = strArray[1].split(",");
			var counts:Array = strArray[2].split(",");
			
			_descriptionLabel = new TextField();
			_descriptionLabel.textColor = 0xffffff;
			_descriptionLabel.mouseEnabled = _descriptionLabel.mouseWheelEnabled = false;
			_descriptionLabel.x = currentW;
			_descriptionLabel.y = currentH;
			_descriptionLabel.width = 400;
			_descriptionLabel.height = 60;
			_descriptionLabel.wordWrap = true;
			_descriptionLabel.multiline = true;
			_descriptionLabel.text = strArray[0];
			addChild(_descriptionLabel);
			
			currentW = currentW + _descriptionLabel.textWidth;
			
			for(var i:int = 0;i<ids.length;i++)
			{
				var obg:LinkItemView = new LinkItemView(ids[i],counts[i]);
				addChild(obg);
				if(currentW + obg.getWidth() > 496)
				{
					currentW = 96;
					currentH = currentH + 20;
					obg.x = currentW;
					obg.y = currentH;
				}else
				{
					obg.x = currentW;
					obg.y = currentH;
				}
				currentW = currentW + obg.getWidth();
			}
		}
		
		private function initialEvents():void
		{
			_cardBtn.addEventListener(MouseEvent.CLICK,cardClickHandler);
			_getBtn.addEventListener(MouseEvent.CLICK,getBtnHandler);
			_giftInfo.addEventListener(ActivityInfoEvents.CHANGE_STATE,changeHandler);
		}
		
		private function removeEvents():void
		{
			_cardBtn.removeEventListener(MouseEvent.CLICK,cardClickHandler);
			_getBtn.removeEventListener(MouseEvent.CLICK,getBtnHandler);
			_giftInfo.removeEventListener(ActivityInfoEvents.CHANGE_STATE,changeHandler);
		}
		
		private function changeHandler(evt:ActivityInfoEvents):void
		{
			if(!_giftInfo.isGet)
			{
				_getBtn.enabled = true;
			}
			else
			{
				_getBtn.enabled = false;
				_getBtn.labelField.text = LanguageManager.getWord("ssztl.activity.hasGotten");
			}
		}
		
		private function cardClickHandler(evt:MouseEvent):void
		{
			JSUtils.gotoActivityCode();
		}
		
		private function getBtnHandler(e:MouseEvent):void
		{
			_mediator.showCodeEnterPanel(_giftInfo.id);
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			_giftInfo = null;
			_descriptionLabel = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			} 
			if(_getBtn)
			{
				_getBtn.dispose();
				_getBtn = null;
			}
			if(_cardBtn)
			{
				_cardBtn.dispose();
				_cardBtn = null;
			}
			_gift = null;
			if(parent) parent.removeChild(this);
		}
	}
}