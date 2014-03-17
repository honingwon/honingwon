package sszt.scene.components.quickIcon
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.quickIcon.iconInfo.ClubNewcomerIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.ClubNewcomerSocketHandler;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class ClubNewcomerPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _info:ClubNewcomerIconInfo;
		private var _label:MAssetLabel;
		private var _btn1:MCacheAssetBtn1;
		private var _btn2:MCacheAssetBtn1;
		private var _btn3:MCacheAssetBtn1;
		
		public function ClubNewcomerPanel(info:ClubNewcomerIconInfo)
		{
			_info = info;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,true,true);
			initEvent();
		}
		
		private function initEvent():void
		{
			_btn1.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn2.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn3.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			_btn1.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_btn3.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		protected function btnClickHandler(event:MouseEvent):void
		{
			var btn:MCacheAssetBtn1 = event.currentTarget as MCacheAssetBtn1;
			var type:int;
			switch(btn)
			{
				case _btn1 :
					type = 1;
					break;
				case _btn2 :
					type = 2;
					break;
				case _btn3 :
					type = 3;
					break;
			}
			ClubNewcomerSocketHandler.send(_info.id,type);
			dispose();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(280,120);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3, new Rectangle(10,4,260,71)),
			]);
			addContent(_bg as DisplayObject);
			
			_label = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_label.move(140,24);
			addContent(_label);
			_label.setHtmlValue(LanguageManager.getWord('ssztl.common.clubNewcomerAttention',_info.nick));
			
			_btn1 = new MCacheAssetBtn1(0,2,LanguageManager.getWord('ssztl.club.newcomerBtn1'));
			_btn1.move(43,81);
			addContent(_btn1);
			
			_btn2 = new MCacheAssetBtn1(0,2,LanguageManager.getWord('ssztl.club.newcomerBtn2'));
			_btn2.move(108,81);
			addContent(_btn2);
			
			_btn3 = new MCacheAssetBtn1(0,2,LanguageManager.getWord('ssztl.club.newcomerBtn3'));
			_btn3.move(173,81);
			addContent(_btn3);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_label=null;
			if(_btn1)
			{
				_btn1.dispose();
				_btn1=null;
			}
			if(_btn2)
			{
				_btn2.dispose();
				_btn2=null;
			}
			if(_btn3)
			{
				_btn3.dispose();
				_btn3=null;
			}
		}
	}
}