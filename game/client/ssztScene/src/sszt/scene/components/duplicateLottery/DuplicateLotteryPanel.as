package sszt.scene.components.duplicateLottery
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.elementInfoView.BaseElementInfoView;
	import sszt.scene.mediators.DuplicateLotteryMediator;
	import sszt.scene.socketHandlers.duplicateLottery.DuplicateLotterySocketHandler;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.scene.FBCardAsset;
	import ssztui.scene.FBLotteryTitleAsset;
	
	public class DuplicateLotteryPanel extends MSprite implements IPanel
	{
		private static const CARD_COUNT:int = 4;
		
		private var _mediator:DuplicateLotteryMediator;
		private var _cardList:Array;
		private var _posxList:Array;
		
		private var _mask:MSprite;
		private var _cardContainer:MSprite;
		private var _clickedCard:MovieClip;
		private var _itemCell:DuplicateLotteryCell;
		private var _name:MAssetLabel;
		private var _amount:MAssetLabel;
		
		private var _moveAmount:int = 0;
		
		public function DuplicateLotteryPanel(mediator:DuplicateLotteryMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1('',new Bitmap(new FBLotteryTitleAsset())),true,-1,false);
			
			init();
			
		}
		
		protected function init():void
//		override protected  function configUI():void
		{
			super.configUI();
//			setContentSize(483,234);
			
			_mask = new MSprite();
			_mask.graphics.beginFill(0x000000,0.3);
			_mask.graphics.drawRect(0,0,10,10);
			_mask.graphics.endFill();
//			addChild(_mask);
//			TweenLite.from(_mask,0.5, {alpha:0});
			
			_cardContainer = new MSprite();
			addChild(_cardContainer);
			
			_cardList = [];			
			_posxList = [-324,-216,-108,0,108,216];
			for(var i:int = 0; i < CARD_COUNT; i++)
			{
				var card:MovieClip = new FBCardAsset();
				card.gotoAndStop(1);
				card.x = 140*i;
				addChild(card);
				_cardList.push(card);
//				card.alpha = (i==CARD_COUNT-1)?100:0;
//				TweenLite.to(card,0.5, {x:_posxList[i],y:-67,alpha:100,delay:0.1*i,onComplete:cardMoveComplete,onCompleteParams:[1]});
			}
			_name = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_name.move(51,68);
			
			_amount = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.RIGHT);
//			_amount.textColor = 0xcc0000;
			_amount.move(35,23);
			
			initEvent();
			setPanelPosition(null);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < CARD_COUNT; i++)
			{
				_cardList[i].buttonMode = true;
				_cardList[i].addEventListener(MouseEvent.CLICK, cardClickedHandler);
				_cardList[i].addEventListener(MouseEvent.MOUSE_OVER,cardOverHandler);
				_cardList[i].addEventListener(MouseEvent.MOUSE_OUT,cardOutHandler);
			}
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < CARD_COUNT; i++)
			{
				_cardList[i].removeEventListener(MouseEvent.CLICK, cardClickedHandler);
			}
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		public function getResult(itemInfo:ItemInfo):void
		{
			_itemCell = new DuplicateLotteryCell();
			_itemCell.itemInfo = itemInfo;
			_itemCell.move(2,2);
			_clickedCard.cell.addChild(_itemCell);
			
			_name.setHtmlValue(itemInfo.template.name);
			_name.textColor  = CategoryType.getQualityColor(itemInfo.template.quality);
			_amount.setHtmlValue(itemInfo.count>1?itemInfo.count.toString():"");
//			_clickedCard.cell.addChild(_name);
			_clickedCard.cell.addChild(_amount);
			_clickedCard.play();
			
			_moveAmount = 0;
//			TweenLite.to(_mask,0.5, {alpha:0,delay:2});
			for(var i:int = 0; i < CARD_COUNT; i++)
			{
//				TweenLite.to(_cardList[i],0.5, {x:-51,delay:2,alpha:0,onComplete:cardMoveComplete,onCompleteParams:[2]});
				
				_cardList[i].removeEventListener(MouseEvent.MOUSE_OVER,cardOverHandler);
				_cardList[i].removeEventListener(MouseEvent.MOUSE_OUT,cardOutHandler);
			}
			BaseElementInfoView.setBrightness(_clickedCard,0);
			_clickedCard.addEventListener(Event.ENTER_FRAME,frameHanlder);
		}
		private function frameHanlder(e:Event):void
		{
			if(_clickedCard.currentFrame == _clickedCard.totalFrames)
			{
				_clickedCard.removeEventListener(Event.ENTER_FRAME,frameHanlder);
				dispose();
			}
		}
		
		private function cardMoveComplete(argument1:int):void
		{
			_moveAmount++;
			
			if(_moveAmount != CARD_COUNT) return;
			switch(argument1)
			{
				case 1:
				{
					for(var i:int = 0; i < CARD_COUNT; i++)
					{
						_cardList[i]._obverse.buttonMode = true;
						_cardList[i].addEventListener(MouseEvent.CLICK, cardClickedHandler);
						_cardList[i].addEventListener(MouseEvent.MOUSE_OVER,cardOverHandler);
						_cardList[i].addEventListener(MouseEvent.MOUSE_OUT,cardOutHandler);
					}
					break;
				}
				case 2:
				{
					dispose();
					break;
				}
			}
				
		}
		
		private function setPanelPosition(e:Event):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH-this.width)/2), Math.round(CommonConfig.GAME_HEIGHT-350));
//			_mask.width = CommonConfig.GAME_WIDTH;
//			_mask.height = CommonConfig.GAME_HEIGHT;
		}
		
		public function autoGetDulicateLottery():void
		{
			if(!_clickedCard)
			{
				var index:int = Math.round(Math.random() * 3);
				_clickedCard = _cardList[index];
				DuplicateLotterySocketHandler.send();
			}
		}
		
		protected function cardClickedHandler(event:MouseEvent):void
		{
			if(!_clickedCard)
			{
				_clickedCard = event.currentTarget as MovieClip;
				DuplicateLotterySocketHandler.send();
			}
		}
		private function cardOverHandler(e:MouseEvent):void
		{
			var c:MovieClip = e.currentTarget as MovieClip;
//			c.back.gotoAndStop(2);
			BaseElementInfoView.setBrightness(c,0.15);
		}
		private function cardOutHandler(e:MouseEvent):void
		{
			var c:MovieClip = e.currentTarget as MovieClip;
//			c.back.gotoAndStop(1);
			BaseElementInfoView.setBrightness(c,0);
		}
		public function doEscHandler():void
		{
//			dispose();
		}
		override public function dispose():void
		{
			removeEvent();
			
			if(_mask)
			{
				_mask.dispose();
				_mask = null;
			}
			_name = null;
			_amount = null;
			for(var i:int = 0; i < CARD_COUNT; i++)
			{
				if(_cardList[i] &&_cardList[i].parent)
				{
					_cardList[i].parent.removeChild(_cardList[i]);
					_cardList[i] = null;
				}
			}
			_cardList = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}