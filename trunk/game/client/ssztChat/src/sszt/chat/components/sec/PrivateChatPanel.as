package sszt.chat.components.sec
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.chat.mediators.ChatMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class PrivateChatPanel extends MPanel
	{
		private var _mediator:ChatMediator;
		private var _bg:IMovieWrapper;
		private var _okBtn:MCacheAsset1Btn,_cancelBtn:MCacheAsset1Btn;
		private var _comboBox:ComboBox;
		
		public function PrivateChatPanel(mediator:ChatMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.common.privateChat")),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(260,144);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,260,107)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,44,40,17),new MAssetLabel("名称：",MAssetLabel.LABELTYPE1))
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,44,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.name2") + "：",MAssetLabel.LABELTYPE1))
			]);
			addContent(_bg as DisplayObject);
			
			_okBtn = new MCacheAsset1Btn(0,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(31,116);
			addContent(_okBtn);
			_cancelBtn = new MCacheAsset1Btn(0,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(157,116);
			addContent(_cancelBtn);
			
			_comboBox = new ComboBox();
			_comboBox.editable = true;
			_comboBox.setSize(176,22);
			_comboBox.move(59,42);
			addContent(_comboBox);
			
			var dp:DataProvider = new DataProvider();
			var list:Dictionary = GlobalData.imPlayList.friends;
			for each(var player:ImPlayerInfo in list)
			{
				if(player)
				{
					dp.addItem({label:player.info.getShowNick()});
				}
			}
			_comboBox.dataProvider = dp;
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _okBtn:
					if(_comboBox.text != "")
						_mediator.setToNick(_comboBox.text);
					dispose();
					break;
				case _cancelBtn:
					dispose();
					break;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_comboBox = null;
			_mediator = null;
		}
	}
}