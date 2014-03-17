package sszt.activity.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.activity.mediators.ActivityMediator;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class EnterCodePanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ActivityMediator;
		private var _btn:MCacheAsset1Btn;
		private var _input:TextField;
		private var _id:int;
		
		public function EnterCodePanel(mediator:ActivityMediator,id:int)
		{
			_mediator = mediator;
			_id = id;
			super(new MCacheTitle1("",new Bitmap(AssetUtil.getAsset("mhsm.common.EnthralTitle2Asset",BitmapData) as BitmapData)),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(288,121);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,288,91)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,5,278,81)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(42,43,208,29))
				]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(20,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.inputActivationNo"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			_input = new TextField();
			_input.textColor = 0xffffff;
			_input.maxChars = 32;
			_input.x = 45;
			_input.y = 46;
			_input.width = 203;
			_input.height = 29;
			_input.type = TextFieldType.INPUT;
			addContent(_input);
			
			_btn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.getAward"));
			_btn.move(117,95);
			addContent(_btn);
			_btn.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			_mediator.sendGetWelfare(_id,_input.text);
		}
		
		override public function dispose():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,clickHandler);
			_btn.dispose();
			_btn = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			super.dispose();
		}
	}
}