package sszt.scene.components.copyIsland
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.countDownView.CountUpView;
	import sszt.scene.data.collects.CollectItemList;
	import sszt.scene.data.copyIsland.CIConditionInfo;
	import sszt.scene.data.copyIsland.CIKingInfo;
	import sszt.scene.data.copyIsland.CIMaininfo;
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	import sszt.scene.mediators.SceneMediator;

	public class CIslandConditionPanel extends Sprite implements IcopyIslandPanel
	{
		private var _mediator:SceneMediator;
		private var _shape:Shape;
		private var _counDownView:CountDownView;
		private var _countUpView:CountUpView;
		private var _kingTimeInfo:CountDownInfo;
		
		private var _monsterLabel:MAssetLabel;
		private var _currentHeight:int;
		private var _allTimeLabel:MAssetLabel;
		private var _leftTimeLabel:MAssetLabel;
		private var _kingTimeLabel:MAssetLabel;
		private var _monsterCountLabel:MAssetLabel;
		private var _collectLabel:MAssetLabel;
		public static const LABEL_FORMAT:TextFormat = new TextFormat("宋体",12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		private var _kingStageList:Array = [3,6,9,10,13,16,19,20,23,26,29,30];
		private var _monsterExceptList:Array = [73,74,75];
		
		public function CIslandConditionPanel(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			mouseEnabled = mouseChildren = false;
			_shape = new Shape();
			_shape.graphics.beginFill(0,0.6);
			_shape.graphics.drawRect(0,0,200,100);
			_shape.graphics.endFill();
			_shape.x = 10;
			_shape.y = 0;
			addChild(_shape);
			
			_monsterLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_monsterLabel.textColor = 0x5aff5a;
			_monsterLabel.move(16,9);
			addChild(_monsterLabel);
			_monsterLabel.defaultTextFormat = LABEL_FORMAT;
			_monsterLabel.setTextFormat(LABEL_FORMAT);
			
			_allTimeLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.curFloorTotalTime"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_allTimeLabel.textColor = 0xff9d34;
			_allTimeLabel.move(16,9);
			addChild(_allTimeLabel);
			
			_leftTimeLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.curFloorLeftTime"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_leftTimeLabel.textColor = 0x5aff5a;
			_leftTimeLabel.move(16,9);
			addChild(_leftTimeLabel);
			
			_kingTimeLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.overGateTime"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_kingTimeLabel.textColor = 0x38d3ff;
			_kingTimeLabel.move(16,9);
			_collectLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.openShenxianBoxDescript"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_collectLabel.defaultTextFormat = LABEL_FORMAT;
			_collectLabel.setTextFormat(LABEL_FORMAT);
			_collectLabel.textColor = 0x5aff5a;
			_collectLabel.move(16,27);
			_monsterCountLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.tollGateLeftMonster"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_monsterCountLabel.move(16,45);
			addChild(_monsterCountLabel);
//			addChild(_kingTimeLabel);
//			var label0:MAssetLabel = new MAssetLabel("注意：",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
//			label0.move(16,9);
//			addChild(label0);
//			var label2:MAssetLabel = new MAssetLabel("本层累计时间：",MAssetLabel.LABELTYPE14,TextFormatAlign.LEFT);
//			label2.move(16,45);
//			addChild(label2);
//			var label3:MAssetLabel = new MAssetLabel("本层剩余时间：",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
//			label3.move(16,63);
//			addChild(label3);
//			var label4:MAssetLabel = new MAssetLabel("霸主通关时间：",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
//			label4.move(16,81);
//			addChild(label4);
//			var label5:MAssetLabel = new MAssetLabel("任务怪：",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
//			label5.move(16,100);
//			addChild(label5);
			
//			_kingTimeLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
//			_kingTimeLabel.move(110,81);
//			addChild(_kingTimeLabel);
			
			_countUpView = new CountUpView();
			_countUpView.setColor(0xff9d34);
			_countUpView.move(110,45);
			addChild(_countUpView);
			
			_counDownView = new CountDownView();
			_counDownView.setColor(0x5aff5a);
			_counDownView.move(110,63);
			addChild(_counDownView);
		}
		
		private function initEvents():void
		{
			cIMaininfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_MAININFO_UPDATE,updateHandler);
			cIMaininfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_LEFTTIME_UPDATE,updateTimeHandler);
			cIMaininfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_MONSTERCOUNT,updateMonsterCountHandler);
			cIKingInfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_KINGTIME_UPDATE,kingTimeUpdateHandler);
			_countUpView.addEventListener(Event.COMPLETE,countUpCompleteHandler);
			_counDownView.addEventListener(Event.COMPLETE,countDownCompleteHandler);
		}
		
		private function removeEvents():void
		{
			cIMaininfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_MAININFO_UPDATE,updateHandler);
			cIMaininfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_LEFTTIME_UPDATE,updateTimeHandler);
			cIMaininfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_MONSTERCOUNT,updateMonsterCountHandler);
			cIKingInfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_KINGTIME_UPDATE,kingTimeUpdateHandler);
			_countUpView.removeEventListener(Event.COMPLETE,countUpCompleteHandler);
			_counDownView.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
		}
		
		private function updateHandler(e:SceneCopyIslandUpdateEvent):void
		{
			_countUpView.start(cIMaininfo.leftTime);
			var tmpMonsterContent:String = "";
			for each(var i:MonsterTemplateInfo in MonsterTemplateList.mapMonsterList[_mediator.sceneInfo.mapInfo.mapId])
			{
				if(_monsterExceptList.indexOf(i.type) != -1)continue;
				tmpMonsterContent += LanguageManager.getWord("ssztl.scene.hitDownAll",i.name);
			}
			_monsterLabel.text = tmpMonsterContent;
			_currentHeight += _monsterLabel.textHeight + 20;
			
			var tmpCollectList:Array = CollectTemplateList.getMapCollects(_mediator.sceneInfo.mapInfo.mapId);
			if(tmpCollectList && tmpCollectList.length > 0)
			{
				_collectLabel.htmlText = LanguageManager.getWord("ssztl.scene.openBoxAttention");
				_collectLabel.move(16,_currentHeight);
				addChild(_collectLabel);
				_currentHeight += _collectLabel.textHeight + 5;
			}
			else
			{
				if(_collectLabel.parent)_collectLabel.parent.removeChild(_collectLabel);
			}
			_allTimeLabel.move(16,_currentHeight);
			_countUpView.move(110,_currentHeight);
			_currentHeight += _allTimeLabel.textHeight + 5;
			_leftTimeLabel.move(16,_currentHeight);
			_counDownView.move(110,_currentHeight);
			_currentHeight += _leftTimeLabel.textHeight + 5;
			if(_kingStageList.indexOf(cIMaininfo.stage) != -1)
			{
				_kingTimeInfo = DateUtil.getCountDownByHour(0,cIKingInfo.passTime * 1000);//不知道协议哪个先发，再取一次
				_kingTimeLabel.text = LanguageManager.getWord("ssztl.scene.overGateTime") +getIntToString(_kingTimeInfo.hours) + ":" + getIntToString(_kingTimeInfo.minutes) + ":" + getIntToString(_kingTimeInfo.seconds);
				
				_kingTimeLabel.move(16,_currentHeight);
				addChild(_kingTimeLabel);
				_currentHeight += _kingTimeLabel.textHeight + 5;
			}
			else
			{
				if(_kingTimeLabel.parent)_kingTimeLabel.parent.removeChild(_kingTimeLabel);
			}
			_monsterCountLabel.text = LanguageManager.getWord("ssztl.scene.tollGateLeftMonster")+"  "+cIMaininfo.leftMonsterCount+"/" +cIMaininfo.allMonsterCount;
			_monsterCountLabel.move(16,_currentHeight);
			_currentHeight += _monsterCountLabel.textHeight + 5;
			_shape.height = _currentHeight + 25;
			_currentHeight = 0;
		}
		
		private function updateTimeHandler(e:Event):void
		{
			_counDownView.start(cIMaininfo.leftTime);
		}
		
		private function updateMonsterCountHandler(e:Event):void
		{
			_monsterCountLabel.text = LanguageManager.getWord("ssztl.scene.tollGateLeftMonster")+cIMaininfo.leftMonsterCount+"/" +cIMaininfo.allMonsterCount;
		}
		
		private function kingTimeUpdateHandler(e:Event):void
		{
			_kingTimeInfo = DateUtil.getCountDownByHour(0,cIKingInfo.passTime * 1000);
			_kingTimeLabel.text =LanguageManager.getWord("ssztl.scene.overGateTime")+ "  " +getIntToString(_kingTimeInfo.hours) + ":" + getIntToString(_kingTimeInfo.minutes) + ":" + getIntToString(_kingTimeInfo.seconds);
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		
		private function countUpCompleteHandler(e:Event):void
		{
			
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			
		}
		
		public function updateTime(argTime:int):void
		{
			
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		
		public function get cIMaininfo():CIMaininfo
		{
			return _mediator.copyIslandInfo.cIMainInfo;
		}
		
		public function get cIKingInfo():CIKingInfo
		{
			return _mediator.copyIslandInfo.cIKingInfo;
		}
		
		public function move(argX:int, argY:int):void
		{
			this.x = argX;
			this.y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			_shape = null;
			if(_counDownView)
			{
				_counDownView.dispose();
				_counDownView = null;
			}
			if(_countUpView)
			{
				_countUpView.dispose();
				_countUpView = null;
			}
			_kingTimeInfo = null;
			_monsterLabel = null;
			_allTimeLabel = null;
			_leftTimeLabel = null;
			_kingTimeLabel = null;
			_monsterCountLabel = null;
			_collectLabel = null;
			_kingStageList = null;
			_monsterExceptList = null;
			if(parent)parent.removeChild(this);
		}

	}
}