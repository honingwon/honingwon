package sszt.task.components.items
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.components.NPCTaskPanel;
	import sszt.task.components.sec.items.TaskAwardCell;
	import sszt.task.mediators.TaskMediator;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.task.NpcTaskAwardTitleAsset;
	
	public class NpcTaskSubmitView extends MScrollPanel
	{
		private const PLAYER_NAME:String = "<%name%>";
		private const CAREER_NAME:String = "<%career%>";
		
		private var _mediator:TaskMediator;
		private var _taskInfo:TaskItemInfo;
		private var _currentState:TaskStateTemplateInfo;
		private var _currentTaskDescriptionIndex:int;
		private var _isEnd:Boolean;
		private var _hadDoSubmit:Boolean;
		
		private var _bg:Bitmap;
		
		private var _txtTaskName:MAssetLabel;
		private var _txtTaskDescription:TextField;
		private var _txtTaskAwards:TextField;
		private var _itemAwardsList:Array;
		private var _tileItemAwards:MTile;
		private var _submitBtn:MCacheAssetBtn1;
		private var _nextBtn:MCacheAssetBtn1;
		
		public function NpcTaskSubmitView(taskInfo:TaskItemInfo,mediator:TaskMediator)
		{
			_mediator = mediator;
			_taskInfo = taskInfo;
			super();
			
			_currentState = _taskInfo.getCurrentState();
			_currentTaskDescriptionIndex = 0;
			
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			mouseEnabled = false;
			width = NPCTaskPanel.CONTENT_RECT.width;
			height = NPCTaskPanel.CONTENT_RECT.height;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			
			getContainer().addChild(MBackgroundLabel.getDisplayObject(new Rectangle(10,1,344,26),new BackgroundType.BAR_2));
			
			_bg = new Bitmap(new NpcTaskAwardTitleAsset);
			_bg.x = 13;
			_bg.y = 80;
			getContainer().addChild(_bg);
			_bg.visible = false;
			
			_txtTaskName = new MAssetLabel('', MAssetLabel.LABEL_TYPE_B14);
			_txtTaskName.move(182,5);
			_txtTaskName.textColor = 0xffcc67;
			_txtTaskName.text = _taskInfo.getTemplate().title;		
			getContainer().addChild(_txtTaskName);
			
			_txtTaskDescription = new TextField;
			_txtTaskDescription.defaultTextFormat = createTextFormat(0xFFFFFF);
			_txtTaskDescription.width = 340;
			_txtTaskDescription.x = 12;
			_txtTaskDescription.y = 28;
			_txtTaskDescription.mouseEnabled = false;
			_txtTaskDescription.wordWrap = true;
			getContainer().addChild(_txtTaskDescription);
			
			_txtTaskAwards = new TextField;
			_txtTaskAwards.defaultTextFormat = createTextFormat(0xffcc00);
			_txtTaskAwards.width = 340;
			_txtTaskAwards.x = 12;
			_txtTaskAwards.y = 101;
			_txtTaskAwards.mouseEnabled = false;
			_txtTaskAwards.wordWrap = true;
			getContainer().addChild(_txtTaskAwards);
			
			_itemAwardsList = [];
			_tileItemAwards = new MTile(38,38,2);
			_tileItemAwards.itemGapW = 4;
			_tileItemAwards.itemGapH = 8;
			_tileItemAwards.verticalScrollPolicy = _tileItemAwards.horizontalScrollPolicy = "off";
			getContainer().addChild(_tileItemAwards);
			
			_submitBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.task.finishTask"));
			_submitBtn.move(254,131);
			getContainer().addChild(_submitBtn);
			
//			_nextBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.nextPage"));
//			_nextBtn.move(317, 104);
//			getContainer().addChild(_nextBtn);
			
			if(GlobalData.taskInfo.taskStateChecker.checkStateComplete(_taskInfo.getCurrentState(),_taskInfo.requireCount))
				_submitBtn.enabled = true;
			else
				_submitBtn.enabled = false;
			
			initAcceptView();
			_submitBtn.visible = true;
			
//			else
//			{
//				var content:String = _currentState.content[_currentTaskDescriptionIndex];
//				content = content.split(PLAYER_NAME).join(GlobalData.selfPlayer.nick);
//				content = content.split(CAREER_NAME).join(CareerType.getNameByCareer(GlobalData.selfPlayer.career));
//				_txtTaskDescription.text = content;
//				
//				_nextBtn.visible = true;
//				_submitBtn.visible = false;
//			}
			
			setGuideTipHandler(null);
		}
		
		private function initEvent():void
		{
			_submitBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
//			_nextBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvent():void
		{
			_submitBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
//			_nextBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.NPC_TASK)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			switch(e.currentTarget)
			{
				case _submitBtn:
					if(!GlobalAPI.checker1 || GlobalAPI.checker1.doCheck({type:"c",param:e}))
					{
						if(GlobalData.bagInfo.getHasPos(_itemAwardsList.length))
						{
							_hadDoSubmit = true;
							_mediator.submitTask(_taskInfo.taskId);
						}
						else
						{
							QuickTips.show(LanguageManager.getWord("ssztl.task.bagNotEnough"));	
						}
					}
					_mediator.closeNpcTaskPanel();
					break;
//				case _nextBtn:
//					if(!GlobalAPI.checker1 || GlobalAPI.checker1.doCheck({type:"d",param:e}))
//					{
//						checkAtEnd();
//					}
//					break;
			}
		}
		
		private function checkAtEnd():void
		{
//			_currentTaskDescriptionIndex++;
//			
//			if(_currentTaskDescriptionIndex >= _currentState.content.length - 1)
//			{
//				_isEnd = true;
//				initAcceptView();
//				
//				_submitBtn.visible = true;
//				_nextBtn.visible = false;
//			}
//			else
//			{
//				_txtTaskDescription.text = "";
//				_txtTaskDescription.text = _currentState.content[_currentTaskDescriptionIndex];
//				
//				_submitBtn.visible = false;
//				_nextBtn.visible = true;
//			}
		}
		
		private function initAcceptView():void
		{
			_bg.visible = true;
			
			var str_txt:String="";
			//当前任务已经完成了
			if (_taskInfo.isFinish)
			{
				var content:String = _currentState.content[0];
				content = content.split(PLAYER_NAME).join(GlobalData.selfPlayer.nick);
				content = content.split(CAREER_NAME).join(CareerType.getNameByCareer(GlobalData.selfPlayer.career));
				str_txt = str_txt + content;
			}
			else//当前任务已经接了但是未完成
			{	
				var contents:String = "";
				if ( _currentState.content.length > 1 )
					contents = _currentState.content[1];
				else
				{
					if (_currentState.content.length == 1)
						contents = _currentState.content[0];
				}
				
				contents = contents.split(PLAYER_NAME).join(GlobalData.selfPlayer.nick);
				contents = contents.split(CAREER_NAME).join(CareerType.getNameByCareer(GlobalData.selfPlayer.career));
				str_txt = str_txt + contents;
			}
			_txtTaskDescription.text = str_txt;
			
			var awardList:Array = _currentState.getSelfAwardList();
			for(var i:int = 0; i < awardList.length; i++)
			{
				var cell:TaskAwardCell = new TaskAwardCell();
				cell.taskAwardInfo = awardList[i];
				_tileItemAwards.appendItem(cell);
				_itemAwardsList.push(cell);
			}
			_tileItemAwards.setSize(84,46 * Math.ceil(_itemAwardsList.length /2));
			_tileItemAwards.move(13,123);
			var _tmpMode:String = "<font color='#d9ad60'>{0}：</font><font color='#00ff00'>{1}</font>\t";
			var _t:String = "";
			var _tmpText:String = "";
			if(_currentState.awardYuanBao > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.yuanBao") + "：" + _currentState.awardYuanBao + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.yuanBao"));
				_tmpText += _t.replace("{1}",_currentState.awardYuanBao);
			}
			if(_currentState.awardBindYuanBao > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.bindYuanBao2") + "：" + _currentState.awardBindYuanBao + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.bindYuanBao2"));
				_tmpText += _t.replace("{1}",_currentState.awardBindYuanBao);
			}
			if(_currentState.awardCopper > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.copper2") + "：" + _currentState.awardCopper + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.copper2"));
				_tmpText += _t.replace("{1}",_currentState.awardCopper);
			}
			if(_currentState.awardBindCopper > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.bindCopper2") + "：" + _currentState.awardBindCopper + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.bindCopper2"));
				_tmpText += _t.replace("{1}",_currentState.awardBindCopper);
			}
			if(_currentState.awardExp > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.experience") + "：" + _currentState.awardExp + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.experience"));
				_tmpText += _t.replace("{1}",_currentState.awardExp);
			}
			if(_currentState.awardLifeExp > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.liftExp3") + "：" + _currentState.awardLifeExp + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.liftExp3"));
				_tmpText += _t.replace("{1}",_currentState.awardLifeExp);
			}
			if(_currentState.contribution > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.clubMoney") + "：" + _currentState.contribution + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.clubMoney"));
				_tmpText += _t.replace("{1}",_currentState.contribution);
			}
			if(_currentState.active > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.clubActiveDegree") + "：" + _currentState.active + "\t");
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.clubActiveDegree"));
				_tmpText += _t.replace("{1}",_currentState.active);
			}
			if(_currentState.exploit > 0)
			{
//				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.personalContribute") + "：" + _currentState.exploit);
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.club.personalContribute"));
				_tmpText += _t.replace("{1}",_currentState.exploit);
			}
			_txtTaskAwards.htmlText = _tmpText;
		}
		
		
//		private function addStringToField(tip:String,format:TextFormat,wrap:Boolean = true):void
//		{
//			if(tip != "")
//			{
//				tip = tip.split(PLAYER_NAME).join("[" + GlobalData.selfPlayer.serverId + "]" + GlobalData.selfPlayer.nick);
//				tip = tip.split(CAREER_NAME).join(CareerType.getNameByCareer(GlobalData.selfPlayer.career));
//				if(_contentField.length > 0 && wrap)_contentField.appendText("\n");
//				_contentField.appendText(tip);
//			}
//		}
		
		private function createTextFormat(color:uint):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color,null,null,null,null,null,null,null,null,null,6);
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(_taskInfo.getTemplate().autoSubmit && !_hadDoSubmit && GlobalData.bagInfo.getHasPos(_itemAwardsList.length) && _taskInfo.isFinish)
				_mediator.submitTask(_taskInfo.taskId);
			
			_mediator = null;
			_currentState = null;
			_taskInfo = null;
			if(_itemAwardsList)
			{
				for each(var cell:TaskAwardCell in _itemAwardsList)
				{
					if(cell)cell.dispose();
				}
			}
			_itemAwardsList = null;
			
			if(_bg && _bg.bitmapData )
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			
			if(_txtTaskName)
			{
				_txtTaskName = null;
			}
			if(_txtTaskDescription)
			{
				_txtTaskDescription = null;
			}
			if(_txtTaskAwards)
			{
				_txtTaskAwards = null;
			}
			if(_tileItemAwards)
			{
				_tileItemAwards.dispose();
				_tileItemAwards = null;
			}
//			if(_nextBtn)
//			{
//				_nextBtn.dispose();
//				_nextBtn = null;
//			}
			if(_submitBtn)
			{
				_submitBtn.dispose();
				_submitBtn = null;
			}
			
			super.dispose();
		}
	}
}