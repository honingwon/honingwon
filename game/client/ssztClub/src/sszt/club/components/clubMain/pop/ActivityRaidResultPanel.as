package sszt.club.components.clubMain.pop
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;

	public class ActivityRaidResultPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _label:MAssetLabel;
		private var _data:MAssetLabel;
		private var _confirmBtn:MCacheAssetBtn1;
		
		
		public function ActivityRaidResultPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.GetRewardAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.GetRewardAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			initView();
			initEvent();
		}
		private function initView():void
		{
			setContentSize(255,225);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,2,235,172)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(103,31,120,26)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(103,61,120,26)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(103,91,120,26)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(103,121,120,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,173,235,25),new Bitmap(new SplitCompartLine2())),
			]);
			addContent(_bg as DisplayObject);
			
			var tf:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xd9ad60,null,null,null,null,null,null,null,null,null,18);
			
			_label = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_label.setLabelType([tf]);
			_label.move(33,37);
			addContent(_label);
			_label.setValue("击杀怪物：\n帮会财富：\n个人贡献：\n采集宝箱：");
			
			_data = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_data.setLabelType([tf]);
			_data.textColor = 0xfffccc;
			_data.move(163,37);
			addContent(_data);
			_data.setValue("1524\n182\n352\n521");
			
			_confirmBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.sure"));
			_confirmBtn.move(93,184);
			addContent(_confirmBtn);
		}
		private function initEvent():void
		{
			_confirmBtn.addEventListener(MouseEvent.CLICK,confirmHandler);
		}
		
		private function removeEvent():void
		{
			_confirmBtn.removeEventListener(MouseEvent.CLICK,confirmHandler);
		}
		private function confirmHandler(e:MouseEvent):void
		{
			dispose();
		}
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_confirmBtn)
			{
				_confirmBtn.dispose();
				_confirmBtn = null;
			}
			_label = null;
			_data = null;
			super.dispose();
		}
	}
}