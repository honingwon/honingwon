package sszt.welfare.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;

	public class GiftExchangeView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _content:MTextArea;
		private var _btnEnter:MCacheAssetBtn1;
		private var _inputTextField:TextField;
		
		public function GiftExchangeView()
		{
			initView();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(0,0,666,361)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(183,130,300,30)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(233,100,200,20),new MAssetLabel("请输入您的新手卡号：",MAssetLabel.LABEL_TYPE20)),
//				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(0,4,666,33)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(114,10,419,20),new Bitmap(new updateTitleAsset())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,38,650,315),new BoxBgAsset()),
			]);
			addChild(_bg as DisplayObject);	
			
			_inputTextField = new TextField();
			_inputTextField.defaultTextFormat = new TextFormat("Simsun",18,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_inputTextField.type = "input";
			_inputTextField.text = LanguageManager.getWord("ssztl.newPlayerCard.inputTitle");
			_inputTextField.maxChars = 64;
			_inputTextField.textColor = 0x5b8c8b;
			_inputTextField.x = 183;
			_inputTextField.y = 135;
			_inputTextField.width = 300;
			_inputTextField.height = 30;
			addChild(_inputTextField);
			
			_btnEnter = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.sure'));
			_btnEnter.move(287,170);
			addChild(_btnEnter);
			
			_btnEnter.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		protected function btnEnterClickHandler(event:MouseEvent):void
		{
			var cardSN:String = _inputTextField.text;
			var target:String = GlobalData.useCardPath;
			var userName:String = GlobalData.selfPlayer.userName;
			var request:URLRequest = new URLRequest(target+'?cardSN='+cardSN+'&ip='+GlobalData.tmpIp+'&userName='+GlobalData.tmpUserName);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.load(request);
		}
		
		private function completeHandler(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			trace(loader.data=='1');
			if(loader.data=='1')
			{
				QuickTips.show('兑换成功');
			}
			else
			{
				QuickTips.show('兑换失败');
			}
		}	
	}
}