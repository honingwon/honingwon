package sszt.scene.components.shenMoWar.ranking
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CommonConfig;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.shenMoWar.shenMoIcon.ShenMoIconView;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarResultUpdateSocketHandler;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ShenMoRankingTimePanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator;
		private var _counDownView:CountDownView;
		private var _shenLabelNum:MAssetLabel;
		private var _moLabelNum:MAssetLabel;
		
		public function ShenMoRankingTimePanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			_mediator.shenMoWarInfo.initShenMoWarResultInfo();
			initialView();
			initialEvents();
//			_mediator.sendResultList();
			ShenMoWarResultUpdateSocketHandler.send(argMediator.shenMoWarInfo.warSceneId);
		}
		
		private function initialView():void
		{
			mouseChildren = mouseEnabled = false;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,200,60)),
			]);
			
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.leftTime"),MAssetLabel.LABELTYPE14);
			label1.mouseEnabled = label1.mouseWheelEnabled = false;
			label1.move(20,5);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.shenSuccessValue"),MAssetLabel.LABELTYPE14);
			label2.mouseEnabled = label2.mouseWheelEnabled = false;
			label2.move(20,20);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.moSuccessValue"),MAssetLabel.LABELTYPE14);
			label3.mouseEnabled = label3.mouseWheelEnabled = false;
			label3.move(20,35);
			addChild(label3);
			
			_counDownView = new CountDownView();
			_counDownView.move(90,5);
			addChild(_counDownView);
			if(_mediator.sceneModule.shenMoWarIcon)
			{
				_counDownView.start(int(_mediator.sceneModule.shenMoWarIcon._countDown.getTimeToInt()));
			}
//			_counDownView.start(int(ShenMoIconView.getInstance()._countDown.getTimeToString()));
			
			_shenLabelNum = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_shenLabelNum.mouseEnabled = _shenLabelNum.mouseWheelEnabled = false;
			_shenLabelNum.move(120,20);
			addChild(_shenLabelNum);
			
			_moLabelNum = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_moLabelNum.mouseEnabled = _moLabelNum.mouseWheelEnabled = false;
			_moLabelNum.move(120,35);
			addChild(_moLabelNum);
			
			gameSizeChangeHandler(null);
			
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_mediator.shenMoWarInfo.shenMoWarResult.addEventListener(SceneShenMoWarUpdateEvent.SHENMO_RESULT_UPDATE,resultUpdateHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_mediator.shenMoWarInfo.shenMoWarResult.removeEventListener(SceneShenMoWarUpdateEvent.SHENMO_RESULT_UPDATE,resultUpdateHandler);
		}
		
		private function resultUpdateHandler(e:SceneShenMoWarUpdateEvent):void
		{
			_shenLabelNum.text = _mediator.shenMoWarInfo.shenMoWarResult.shenWinNum.toString();
			_moLabelNum.text =  _mediator.shenMoWarInfo.shenMoWarResult.moWinNum.toString();
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 600;
			y = 0;
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator.shenMoWarInfo.clearShenMoWarResultInfo();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_counDownView)
			{
				_counDownView.dispose();
				_counDownView = null;
			}
			_shenLabelNum = null;
			_moLabelNum = null;
			if(parent)parent.removeChild(this);
		}
	}
}