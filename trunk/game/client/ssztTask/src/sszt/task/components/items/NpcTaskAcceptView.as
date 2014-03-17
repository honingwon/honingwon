package sszt.task.components.items
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
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
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
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
	
	public class NpcTaskAcceptView extends MScrollPanel
	{
		private const PLAYER_NAME:String = "<%name%>";
		private const CAREER_NAME:String = "<%career%>";
		private var _pattern:RegExp = /{[^}]*}/g;
		
		private var _mediator:TaskMediator;
		private var _taskInfo:TaskTemplateInfo;
		private var _currentTaskDescriptionIndex:int;
		private var _isEnd:Boolean;
		private var _hadAccept:Boolean;
		
		private var _bg:Bitmap;
//		private var _bgTxtAwards:MAssetLabel;
		
		private var _txtTaskName:MAssetLabel;
		private var _txtTaskDescription:TextField;
		private var _txtTaskAwards:TextField;
		private var _itemAwardsList:Array;
		private var _tileItemAwards:MTile;
		private var _nextBtn:MCacheAssetBtn1;
		private var _acceptBtn:MCacheAssetBtn1;
		
		public function NpcTaskAcceptView(taskInfo:TaskTemplateInfo, mediator:TaskMediator)
		{
			_taskInfo = taskInfo;
			_mediator = mediator;
			super();
			
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
			
//			_bgTxtAwards = new MAssetLabel(LanguageManager.getWord('ssztl.core.taskAward'), MAssetLabel.LABEL_TYPE8, TextFieldAutoSize.LEFT);
//			_bgTxtAwards.move(334, 6);
//			getContainer().addChild(_bgTxtAwards);
//			_bgTxtAwards.visible = false;
			
			_txtTaskName = new MAssetLabel('', MAssetLabel.LABEL_TYPE_B14);
			_txtTaskName.move(182,5);
			_txtTaskName.textColor = 0xffcc67;
			_txtTaskName.htmlText = _taskInfo.title;
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
			
//			_nextBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.nextPage"));
//			_nextBtn.move(317, 104);
//			getContainer().addChild(_nextBtn);
			
			_acceptBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.core.acceptTask"));
			_acceptBtn.move(254,131);
			getContainer().addChild(_acceptBtn);
			
			initAcceptView();
			setGuideTipHandler(null);
			//?????
//			if(_taskInfo.acceptContent.length == 0)
//			{
			
//			var str_txt:String ="";
//			for(var i:int=0; i < _taskInfo.acceptContent.length;i++ )
//			{
//				str_txt = str_txt  + _taskInfo.acceptContent[i];
//			}
//			_txtTaskDescription.text = str_txt;
//				_nextBtn.visible = false;
//			}
//			else
//			{
//				_txtTaskDescription.text = (_taskInfo.acceptContent[_currentTaskDescriptionIndex]);
//				_acceptBtn.visible = false;
//				_nextBtn.visible = true;
//			}
		}
		
		private function initEvent():void
		{
//			_nextBtn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			_acceptBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvent():void
		{
//			_nextBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_acceptBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
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
//				case _nextBtn:
//					if(!GlobalAPI.checker1 || GlobalAPI.checker1.doCheck({type:"e",param:e}))
//					{
//						checkAtEnd();
//					}
//					break;
				case _acceptBtn:
					if(!GlobalAPI.checker1 || GlobalAPI.checker1.doCheck({type:"f",param:e}))
					{
						_hadAccept = true;
						_mediator.acceptTask(_taskInfo.taskId);
						_mediator.closeNpcTaskPanel();
					}
					break;
			}
		}
		
		private function checkAtEnd():void
		{
//			_currentTaskDescriptionIndex++;
//			
//			if(_currentTaskDescriptionIndex >= _taskInfo.acceptContent.length)
//			{
//				_isEnd = true;
//				initAcceptView();
//				
//				_acceptBtn.visible = true;
//				_nextBtn.visible = false;
//			}
//			else
//			{
//				_txtTaskDescription.text = "";
//				_acceptBtn.visible = false;
//				_nextBtn.visible = true;
//			}
		}
		
		private function initAcceptView():void
		{
			_bg.visible = true;
			//打开NPC界面显示的未接的任务数据
			
			var str_txt:String ="";
			for(var i:int=0; i < _taskInfo.acceptContent.length;i++ )
			{
				str_txt = str_txt  + _taskInfo.acceptContent[i];
			}
			var content:String = str_txt
			content = content.split(PLAYER_NAME).join(GlobalData.selfPlayer.nick);
			content = content.split(CAREER_NAME).join(CareerType.getNameByCareer(GlobalData.selfPlayer.career));
			_txtTaskDescription.text = content;
			var awardList:Array = _taskInfo.states[0].getSelfAwardList();
			for(i = 0; i < awardList.length; i++)
			{
				var cell:TaskAwardCell = new TaskAwardCell();
				cell.taskAwardInfo = awardList[i];
				_tileItemAwards.appendItem(cell);
				_itemAwardsList.push(cell);
			}
			_tileItemAwards.setSize(84,46 * Math.ceil(_itemAwardsList.length /2));
			_tileItemAwards.move(13,123);
			/*
			if(_taskInfo.states[0].awardYuanBao > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.yuanBao") + "：" + _taskInfo.states[0].awardYuanBao + "\t");
			}
			if(_taskInfo.states[0].awardBindYuanBao > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.bindYuanBao2") + "：" + _taskInfo.states[0].awardBindYuanBao + "\t");
			}
			if(_taskInfo.states[0].awardCopper > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.copper2") + "：" + _taskInfo.states[0].awardCopper + "\t");
			}
			if(_taskInfo.states[0].awardBindCopper > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.bindCopper2") + "：" + _taskInfo.states[0].awardBindCopper + "\t");
			}
			if(_taskInfo.states[0].awardExp > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.experience") + "：" + _taskInfo.states[0].awardExp + "\t");
			}
			if(_taskInfo.states[0].awardLifeExp > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.liftExp3") + "：" + _taskInfo.states[0].awardLifeExp + "\t");
			}
			if(_taskInfo.states[0].contribution > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.clubMoney") + "：" + _taskInfo.states[0].contribution + "\t");
			}
			if(_taskInfo.states[0].active > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.clubActiveDegree") + "：" + _taskInfo.states[0].active + "\t");
			}
			if(_taskInfo.states[0].exploit > 0)
			{
				_txtTaskAwards.appendText(LanguageManager.getWord("ssztl.common.personalContribute") + "：" + _taskInfo.states[0].exploit);
			}*/
			var _tmpMode:String = "<font color='#d9ad60'>{0}：</font><font color='#00ff00'>{1}</font>\t";
			var _t:String = "";
			var _tmpText:String = "";
			if(_taskInfo.states[0].awardYuanBao > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.yuanBao"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].awardYuanBao);
			}
			if(_taskInfo.states[0].awardBindYuanBao > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.bindYuanBao2"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].awardBindYuanBao);
			}
			if(_taskInfo.states[0].awardCopper > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.copper2"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].awardCopper);
			}
			if(_taskInfo.states[0].awardBindCopper > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.bindCopper2"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].awardBindCopper);
			}
			if(_taskInfo.states[0].awardExp > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.experience"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].awardExp);
			}
			if(_taskInfo.states[0].awardLifeExp > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.liftExp3"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].awardLifeExp);
			}
			if(_taskInfo.states[0].contribution > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.clubMoney"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].contribution);
			}
			if(_taskInfo.states[0].active > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.common.clubActiveDegree"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].active);
			}
			if(_taskInfo.states[0].exploit > 0)
			{
				_t =  _tmpMode.replace("{0}",LanguageManager.getWord("ssztl.club.personalContribute"));
				_tmpText += _t.replace("{1}",_taskInfo.states[0].exploit);
			}
			_txtTaskAwards.htmlText = _tmpText;
		}
		
		private function createTextFormat(color:uint):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color,null,null,null,null,null,null,null,null,null,6);
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(_taskInfo.autoAccept && !_hadAccept)_mediator.acceptTask(_taskInfo.taskId);
			
			_mediator = null;
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
			if(_nextBtn)
			{
				_nextBtn.dispose();
				_nextBtn = null;
			}
			if(_acceptBtn)
			{
				_acceptBtn.dispose();
				_acceptBtn = null;
			}
			
			super.dispose();
		}
	}
}