package sszt.bag.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.bag.event.BagCellEvent;
	import sszt.bag.mediator.BagMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemSplitSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.bag.SplitBgAsset;
	import ssztui.ui.DownBtnAsset;
	import ssztui.ui.UpBtnAsset;
	
	/**
	 * 分割面板 
	 * @author lxb
	 * 
	 */	
	public class BagSplitPanel extends MPanel
	{
		private var countLabel:MAssetLabel;
		private var inputLabel:TextField;
		private var certainBtn:MCacheAssetBtn1;
		private var cancelBtn:MCacheAssetBtn1;
		private var _upBtn:MCacheAssetBtn2;
		private var _downBtn:MCacheAssetBtn2;
		private var _bg:IMovieWrapper;
		private var _bg1:Bitmap;
		private var _item:ItemInfo;
		private var _mediator:BagMediator;
		private static const TF:TextFormat = new TextFormat("Tahoma",12,0xFFD700,null,null,null,null,null,TextFormatAlign.CENTER);
		public function BagSplitPanel(info:ItemInfo,mediator:BagMediator)
		{
			_item = info;
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.BagSplitAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.BagSplitAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1,false);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(270,112);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(11,7,248,64)),
				new BackgroundInfo(BackgroundType.BORDER_7,new Rectangle(109,27,94,24))
				]);
			addContent(_bg as DisplayObject);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(66,30,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.bag.number") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			_bg1 = new Bitmap(new SplitBgAsset(0,0));
			_bg1.x = 21;
			_bg1.y = 26;
			//addContent(_bg1);			
		
			inputLabel = new TextField();
			inputLabel.type = TextFieldType.INPUT; 
			inputLabel.textColor = 0xffd700;
			inputLabel.defaultTextFormat = TF;
			inputLabel.setTextFormat(TF);
			inputLabel.height = 16;
			inputLabel.width = 54;	
			inputLabel.maxChars = 3;
			inputLabel.x = 130;
			inputLabel.y = 30;
			inputLabel.text = "1";
			addContent(inputLabel);
			
			cancelBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.cannel"));
			cancelBtn.move(138,76);
			addContent(cancelBtn);
			certainBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.sure"));
			certainBtn.move(72,76);
			addContent(certainBtn);
			
			_downBtn = new MCacheAssetBtn2(1);
			addContent(_downBtn);
			_downBtn.move(112,30);
			_upBtn = new MCacheAssetBtn2(0);
			addContent(_upBtn);
			_upBtn.move(184,30);
			
		}
		
		private function initEvent():void
		{
			certainBtn.addEventListener(MouseEvent.CLICK,certainHandler);
			cancelBtn.addEventListener(MouseEvent.CLICK,cancelHandler);
			_upBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downClickHandler);		
		}
		
		private function removeEvent():void
		{
			certainBtn.removeEventListener(MouseEvent.CLICK,certainHandler);
			cancelBtn.removeEventListener(MouseEvent.CLICK,cancelHandler);
			_upBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downClickHandler);
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(value == _item.count) return;
			inputLabel.text = String(value+1);
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(value == 1) return;
			inputLabel.text = String(value - 1);
		}
		
		private function certainHandler(evt:MouseEvent):void
		{
			
			if(value> _item.count)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.bag.overMaxNumber"));
				return ;
			}
			ItemSplitSocketHandler.sendSplit(_item.place,value);
            dispose();
		}
		
		private function cancelHandler(evt:MouseEvent):void
		{
            dispose();
		}
		

		public function get value():int
		{
			return int(inputLabel.text);
		}
		
		override public function dispose():void{
			removeEvent();
			if(certainBtn)
			{
				certainBtn.dispose();
				certainBtn = null;
			}
			if(cancelBtn)
			{
				cancelBtn.dispose();
				cancelBtn = null;
			}
			
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
			countLabel = null;
			inputLabel = null;
			_item = null;
			_mediator = null;
			super.dispose();
		}
		
	}
}