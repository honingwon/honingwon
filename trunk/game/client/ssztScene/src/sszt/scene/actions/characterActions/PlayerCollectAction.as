package sszt.scene.actions.characterActions
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import mhsm.ui.BarAsset3;
	
	import mx.messaging.AbstractConsumer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.BaseActionInfo;
	import sszt.scene.data.collects.CollectActionInfo;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.ui.BarAsset7;
	import ssztui.ui.PlayCollectBarAsset;
	import ssztui.ui.PlayCollectTrackAsset;
	
	public class PlayerCollectAction extends BaseCharacterAction
	{
		private var _medaitor:SceneMediator;
		private var _self:SelfScenePlayer;
		private var _collectId:int;
		private var _templateId:int;
		private var _startTime:Number;
		private var _totalTime:Number;
		private var _progressBar:ProgressBar1;
		private var _vessel:Sprite;
		private var _dot:MovieClip;
		
		public function PlayerCollectAction(self:SelfScenePlayer,mediator:SceneMediator)
		{
			_self = self;
			_medaitor = mediator;
			super(null,0);
		}
		
		override public function configure(...parameters):void
		{
			_collectId = int(parameters[0]);
			var collectItem:CollectItemInfo = _medaitor.sceneInfo.collectList.getItem(_collectId);
			_templateId = collectItem.templateId;
			_medaitor.startCollect(_collectId,_templateId);
			if(collectItem)
			{
				var collectTemplate:CollectTemplateInfo = CollectTemplateList.list[collectItem.templateId];
				_totalTime = collectTemplate.collectTime;
				_startTime = getTimer();
			}
			if(_vessel)
			{
				_progressBar.setCurrentValue(0);
				GlobalAPI.layerManager.getTipLayer().addChild(_vessel);
			}
			play();
		}
		
		override public function play():void
		{
			super.play();
			if(!_vessel)
			{
				var progressBg:Bitmap = new Bitmap(new PlayCollectTrackAsset() as BitmapData);
				progressBg.x = -14;
				progressBg.y = -5;				
				_progressBar = new ProgressBar1(new Bitmap(new PlayCollectBarAsset() as BitmapData),0,100,208,11,false,false,progressBg);
				_progressBar.setCurrentValue(0);
//				_progressBar.move(CommonConfig.GAME_WIDTH/2 - 104,CommonConfig.GAME_HEIGHT - 160);
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
				_vessel = new Sprite();	
				_vessel.addChild(_progressBar);
				_vessel.x = CommonConfig.GAME_WIDTH/2 - 104;
				_vessel.y = CommonConfig.GAME_HEIGHT - 160;
				_dot = MovieCaches.getFireAsset();
				_dot.blendMode = BlendMode.ADD;
				_dot.rotation -= 90; 
//				_dot.move(-47,25);
				_dot.x = -47;
				_dot.y = 25;
				_dot.play();
				_vessel.addChild(_dot as DisplayObject);
			}
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			if(_vessel)
			{
				_vessel.x = CommonConfig.GAME_WIDTH/2 - 104;
				_vessel.y = CommonConfig.GAME_HEIGHT - 160;
			}
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			var passTime:Number = getTimer() - _startTime;
			if(passTime >= _totalTime)
			{
				_medaitor.collect(_collectId,_templateId);
				_medaitor.sceneInfo.collectList.removeItem(_collectId,true);
				_self.selfScenePlayerInfo.setCollecting(-1);
			}
			else
			{
				if(!_vessel.parent)GlobalAPI.layerManager.getTipLayer().addChild(_vessel);
				_progressBar.setCurrentValue(int((passTime / _totalTime) * 100));
//				_dot.move(int((passTime / _totalTime)*208) - 47,25);
				_dot.x = int((passTime / _totalTime)*208-47);
				_dot.y = 25;
			}
		}
		
		public function getCollectActionInfo():CollectActionInfo
		{
			return _actionInfo as CollectActionInfo;
		}
		
		public function stopCollect():void
		{
			_medaitor.stopcollect();
			_collectId = -1;
			_startTime = 0;
			_totalTime = 0;
			if(_vessel && _vessel.parent)
				_vessel.parent.removeChild(_vessel);
		}
		
		override public function dispose():void
		{
			super.dispose();
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_self = null;
			_medaitor = null;
			if(_progressBar)
			{
				_progressBar.dispose();
				_progressBar = null;
			}
			if(_vessel  && _vessel.parent)
			{
				_vessel.parent.removeChild(_vessel);
				_vessel = null;
			}
			if(_dot){
//				_dot.dispose();
				_dot = null;
			}
			GlobalAPI.tickManager.removeTick(this);
		}
	}
}