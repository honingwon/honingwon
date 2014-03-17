package sszt.activity.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheCloseBtn;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	import ssztui.activity.EntrustTitleAsset;
	import ssztui.activity.FBNameBgAsset;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;

	public class CopyEntrustPanel extends MSprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _closeBtn:MCacheCloseBtn;
		
		private var _name:MAssetLabel;
		private var _needFight:MAssetLabel;
		private var _getExp:MAssetLabel;
		private var _entrustCost:MAssetLabel;
		private var _entrustMore:TextField;
		private var _upBtn:MBitmapButton;
		private var _downBtn:MBitmapButton;
		private var _startEntrust:MCacheAssetBtn1;
		
		
		public function CopyEntrustPanel()
		{
			super();
		}
		override protected function configUI():void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([				
				new BackgroundInfo(BackgroundType.REELWIN,new Rectangle(0,0,282,345)),
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(23,31,236,285)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(28,36,226,275)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(29,144,224,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(103,5,75,17),new Bitmap(new EntrustTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(39,61,205,11),new Bitmap(new FBNameBgAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(114,182,80,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(114,207,49,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(114,232,49,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(42,97,198,25),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustExplain"),MAssetLabel.LABEL_TYPE7)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,155,100,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustNeedFight"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,185,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustGetExp"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,210,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustCost"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,235,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustMore"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(166,235,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustAmount"),MAssetLabel.LABEL_TYPE20,"left")),
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,282,28);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_closeBtn = new MCacheCloseBtn();
			_closeBtn.move(240,2);
			addChild(_closeBtn);
			
			var freeText:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.activity.vipEntrustFree"),MAssetLabel.LABEL_TYPE20,"left");
			freeText.textColor = 0xff00f6;
			freeText.move(166,210);
			addChild(freeText);
			
			_name = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B);
			_name.move(141,58);
			addChild(_name);
			_name.setHtmlValue("雪山冰原[单人]");
			
			_needFight = new MAssetLabel("10086",MAssetLabel.LABEL_TYPE21B,"left");
			_needFight.move(152,155);
			addChild(_needFight);
			
			_getExp = new MAssetLabel("50000",MAssetLabel.LABEL_TYPE7,"left");
			_getExp.move(120,185);
			addChild(_getExp);
			
			_entrustCost = new MAssetLabel("20元宝",MAssetLabel.LABEL_TYPE21,"left");
			_entrustCost.move(120,210);
			addChild(_entrustCost);
			
			_entrustMore = new TextField();
			_entrustMore.type = TextFieldType.INPUT; 
			_entrustMore.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_entrustMore.restrict = "0123456789";
			_entrustMore.selectable = true;
			_entrustMore.width = 30;
			_entrustMore.height = 18;
			_entrustMore.x = 120;
			_entrustMore.y = 235;
			_entrustMore.text = "1";
			addChild(_entrustMore);
			
			_upBtn = new MBitmapButton(new SmallBtnAmountUpAsset());
			_upBtn.move(141,234);
			addChild(_upBtn);
			
			_downBtn = new MBitmapButton(new SmallBtnAmountDownAsset());
			_downBtn.move(141,243);
			addChild(_downBtn);
			
			_startEntrust = new MCacheAssetBtn1(2, 0, LanguageManager.getWord('ssztl.activity.startExplain'));
			_startEntrust.move(91,268);
			addChild(_startEntrust);
			
			this.initEvent();
		}
		
		private function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		private function removeEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - 282,parent.stage.stageHeight - 345));
		}
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function cancelClickHandler(evt:MouseEvent):void{
			this.dispose();
		}
		
		public function doEscHandler():void
		{
			dispose();
			
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		override public function dispose():void{
			this.removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_dragArea)
			{
				_dragArea.graphics.clear();
				_dragArea = null;
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
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			_name = null;
			_needFight = null;
			_getExp = null;
			_entrustCost = null;
			_entrustMore = null;
			super.dispose();
		}
	}
}