package sszt.scene.components.relive
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class PrisonRelivePanel extends MPanel
	{
		private var _mediator:ReliveMediator;
		private var _bg:IMovieWrapper;
		private var _reliveBtn:MCacheAsset3Btn;
		private var _sendTime:int;
		
		public function PrisonRelivePanel(mediator:ReliveMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,0,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(256,100);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(9,4,238,148)),
			]);
			addContent(_bg as DisplayObject);
			
			_reliveBtn = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.backRelivePointRightNow"));
			_reliveBtn.move(28,32);
			addContent(_reliveBtn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_reliveBtn.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			_reliveBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(getTimer() - _sendTime < 1000)return;
			_mediator.relive(5);
			_sendTime = getTimer();
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_reliveBtn)
			{
				_reliveBtn.dispose();
				_reliveBtn = null;
			}
			super.dispose();
		}
	}
}