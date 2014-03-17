package sszt.firebox.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemSplitSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.firebox.events.FireBoxEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel2;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.DownBtnAsset;
	import ssztui.ui.UpBtnAsset;
	
	public class SplitPanel extends Sprite
	{
//		public function SplitPanel()
//		{
//			super();
//		}
		
//		private var countLabel:MAssetLabel;
		private var inputLabel:TextField;
//		private var certainBtn:MCacheAssetBtn1;
//		private var cancelBtn:MCacheAssetBtn1;
		private var _upBtn:MCacheAssetBtn2;
		private var _downBtn:MCacheAssetBtn2;
		private var _maxBtn:MCacheAssetBtn2;
		private var _bg:IMovieWrapper;
		private var _bg1:Bitmap;
//		private var _item:ItemInfo;
		private var itemCount:int;
//		private var _mediator:BagMediator;
		private static const TF:TextFormat = new TextFormat("SimSun",12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.CENTER);
//		public function SplitPanel(info:ItemInfo,mediator:BagMediator)
		public function SplitPanel()
		{
//			_item = info;
//			_mediator = mediator;
//			super(new MCacheTitle1(LanguageManager.getWord("ssztl.bag.splitItem")),true,-1,false);
			super();
			itemCount = 0;
			initialView();
			initEvent();
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		private function initialView():void
		{
//			configUI();
//			setContentSize(206,110);
			var x:int = 81;
			var y:int = 26;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(81 - x,26 - y,80,22)),
			]);
			addChild(_bg as DisplayObject);
			
			inputLabel = new TextField();
			inputLabel.type = TextFieldType.INPUT; 
			inputLabel.defaultTextFormat = TF;
			inputLabel.height = 20;
			inputLabel.width = 40;	
			inputLabel.maxChars = 3;
			inputLabel.x = 20;
			inputLabel.y = 2;
			inputLabel.text = "1";
			addChild(inputLabel);
			
//			cancelBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.cannel"));
//			cancelBtn.move(41,72);
//			addContent(cancelBtn);
//			certainBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.sure"));
//			certainBtn.move(106,72);
//			addContent(certainBtn);
			
			_downBtn = new MCacheAssetBtn2(1);
			addChild(_downBtn);
			_downBtn.move(2,2);
			_upBtn = new MCacheAssetBtn2(0);
			addChild(_upBtn);
			_upBtn.move(60,2);
			_maxBtn = new MCacheAssetBtn2(13);
			addChild(_maxBtn);
			_maxBtn.move(81,2);
			
		}
		
		private function initEvent():void
		{
//			certainBtn.addEventListener(MouseEvent.CLICK,certainHandler);
//			cancelBtn.addEventListener(MouseEvent.CLICK,cancelHandler);
			_upBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downClickHandler);
			_maxBtn.addEventListener(MouseEvent.CLICK,maxClickHandler);
			inputLabel.addEventListener(Event.CHANGE,changeNumHandler);
		}
		
		private function removeEvent():void
		{
//			certainBtn.removeEventListener(MouseEvent.CLICK,certainHandler);
//			cancelBtn.removeEventListener(MouseEvent.CLICK,cancelHandler);
			_upBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_maxBtn.removeEventListener(MouseEvent.CLICK,maxClickHandler);
			inputLabel.removeEventListener(Event.CHANGE,changeNumHandler);
		}
		
		private function changeNumHandler(e:Event):void
		{
			if(value < 0)
			{
				inputLabel.text = String(1);
			}
			if(value > itemCount)
			{
				inputLabel.text = String(itemCount);
			}
			dispatchEvent(new FireBoxEvent(FireBoxEvent.COMPOSE_NUMBER_UPDATE));
		}
		private function upClickHandler(evt:MouseEvent):void
		{
			if(value == itemCount) return;
			inputLabel.text = String(value+1);
			dispatchEvent(new FireBoxEvent(FireBoxEvent.COMPOSE_NUMBER_UPDATE));
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(value <= 1) return;
			inputLabel.text = String(value - 1);
			dispatchEvent(new FireBoxEvent(FireBoxEvent.COMPOSE_NUMBER_UPDATE));
		}
		private function maxClickHandler(evt:MouseEvent):void
		{
			if(value == itemCount) return;
			inputLabel.text = itemCount.toString();
			dispatchEvent(new FireBoxEvent(FireBoxEvent.COMPOSE_NUMBER_UPDATE));
		}
		
//		private function certainHandler(evt:MouseEvent):void
//		{
//			
//			if(value> _item.count)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.bag.overMaxNumber"));
//				return ;
//			}
//			ItemSplitSocketHandler.sendSplit(_item.place,value);
//			dispose();
//		}
//		
//		private function cancelHandler(evt:MouseEvent):void
//		{
//			dispose();
//		}
		
		
		public function get value():int
		{
			return int(inputLabel.text);
		}
		public function set maxValue(val:int):void
		{
			itemCount = val;
			inputLabel.text = itemCount.toString();
		}
		
		public function dispose():void{
			removeEvent();
//			if(certainBtn)
//			{
//				certainBtn.dispose();
//				certainBtn = null;
//			}
//			if(cancelBtn)
//			{
//				cancelBtn.dispose();
//				cancelBtn = null;
//			}
//			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_upBtn)
			{
				_upBtn.dispose();
				_upBtn = null;
			}
			if(_downBtn)
			{
				_downBtn.dispose();
				_downBtn = null;
			}
			if(_maxBtn)
			{
				_maxBtn.dispose();
				_maxBtn = null;
			}
//			countLabel = null;
			inputLabel = null;
//			_item = null;
//			_mediator = null;
//			dispose();
		}
		
	}
}