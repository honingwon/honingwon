package sszt.scene.components.lifeExpSit
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.PlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.LifeExpSitMediator;
	import sszt.scene.socketHandlers.PlayerLifeExpSitSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class LifeExpSitPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _depict:MAssetLabel;
		private var _mediator:LifeExpSitMediator;
		private var _btnStart:MCacheAssetBtn1;
		private var _btnEnd:MCacheAssetBtn1;
		
		public function LifeExpSitPanel(mediator:LifeExpSitMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.LilianSitTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.LilianSitTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(260,135);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(8,4,244,92)),
				]);
			addContent(_bg as DisplayObject);
			
			_depict = new MAssetLabel(LanguageManager.getWord("ssztl.scene.SimpleSitDepict"),MAssetLabel.LABEL_TYPE20,"left");
			_depict.move(20,17);
			addContent(_depict);
			
			_btnStart = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.startSimpleSit"));
			_btnStart.move(95, 100);
			addContent(_btnStart);
			
			_btnEnd = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.cancelSimpleSit"));
			_btnEnd.move(95, 100);
			addContent(_btnEnd);
			
			_btnEnd.visible = false;
			
			if(GlobalData.selfPlayer.isLifexpSitState)
			{
				_btnEnd.visible = true;
				_btnStart.visible = false;
			}
			else
			{
				_btnEnd.visible = false;
				_btnStart.visible = true;
			}
		}
		
		private function initEvent():void
		{
			GlobalData.selfPlayer.addEventListener(PlayerInfoUpdateEvent.LIFE_EXP_SIT_STATE_UPDATE, lifeExpSitStateUpdateHandler);
			_btnStart.addEventListener(MouseEvent.CLICK, startHandler)
			_btnEnd.addEventListener(MouseEvent.CLICK, endHandler)
		}
		
		private function removeEvent():void
		{
			GlobalData.selfPlayer.removeEventListener(PlayerInfoUpdateEvent.LIFE_EXP_SIT_STATE_UPDATE, lifeExpSitStateUpdateHandler);
			_btnStart.removeEventListener(MouseEvent.CLICK, startHandler)
			_btnEnd.removeEventListener(MouseEvent.CLICK, endHandler)
		}
		
		private function lifeExpSitStateUpdateHandler(e:Event):void
		{
			if(GlobalData.selfPlayer.isLifexpSitState)
			{
				_btnEnd.visible = true;
				_btnStart.visible = false;
			}
			else
			{
				_btnEnd.visible = false;
				_btnStart.visible = true;
			}
			if(!GlobalData.selfPlayer.isSit())
			{
				this.dispose();
			}
		}
		
		private function startHandler(event:MouseEvent):void
		{
			if(GlobalData.selfPlayer.isSit())
			{
				PlayerLifeExpSitSocketHandler.send(1);
			}
		}
		
		private function endHandler(event:MouseEvent):void
		{
			if(GlobalData.selfPlayer.isSit())
			{
				PlayerLifeExpSitSocketHandler.send(0);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btnStart)
			{
				_btnStart.dispose();
				_btnStart = null;
			}
			if(_btnEnd)
			{
				_btnEnd.dispose();
				_btnEnd = null;
			}
			_depict = null;
		}
	}
}