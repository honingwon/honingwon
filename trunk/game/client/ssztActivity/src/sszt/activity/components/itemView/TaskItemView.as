package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.components.TaskTabPanel;
	import sszt.activity.data.ActivityRewardsType;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActivityTaskTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.activity.DotIconExpAsset;
	import ssztui.activity.DotIconItemAsset;
	import ssztui.activity.DotIconLifeExpAsset;
	import ssztui.activity.DotIconMoneyAsset;
	import ssztui.activity.RowOverBgAsset;
	
	public class TaskItemView extends Sprite
	{
		private var _taskInfo:ActivityTaskTemplateInfo;
		private var _taskTemplate:TaskTemplateInfo;
		private var _npcInfo:NpcTemplateInfo;
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _countLabel:MAssetLabel;
		private var _npcLabel:MAssetLabel;
		private var _spriteBtn:Sprite;
		private var _transferBtn:MBitmapButton;
		private var _tipIcon:Bitmap;
		private var _selected:Boolean;
		private var _enabled:Boolean;
		private var _takenCount:int=0;
		private var _publishCount:int=0;
		
		private var _bgOver:Bitmap;
		
		public function TaskItemView(info:ActivityTaskTemplateInfo)
		{
			super();
			_taskInfo = info;
			_taskTemplate = TaskTemplateList.getTaskTemplate(_taskInfo.taskId);
			_npcInfo = NpcTemplateList.getNpc(_taskTemplate.npc);
			
			initView();
			initEvent();
			setData();
		}
		
		private function initView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<TaskTabPanel.COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+TaskTabPanel.COLWidth[i]:TaskTabPanel.COLWidth[0]+i*2);
			}
			this.buttonMode = this.mouseChildren = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,420,34);
			graphics.endFill();
			
			_bgOver = new Bitmap(new RowOverBgAsset());
			_bgOver.x = _bgOver.y = 1;
			addChild(_bgOver);
			_bgOver.alpha = 0.4;
			_bgOver.visible = false;
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_nameLabel.move(42,10);
			addChild(_nameLabel);
			_nameLabel.setValue(_taskTemplate.title);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_levelLabel.move(colX[0]+TaskTabPanel.COLWidth[1]/2,10);
			addChild(_levelLabel);
			_levelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_taskTemplate.minLevel + "-" + _taskTemplate.maxLevel));
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_countLabel.move(colX[1]+TaskTabPanel.COLWidth[2]/2,10);
			addChild(_countLabel);
			
			_npcLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.RIGHT);
			_npcLabel.move(398,10);
			addChild(_npcLabel);
			_npcLabel.htmlText = "<u>" + _npcInfo.name + "</u>　　";
			
			_spriteBtn = new Sprite();
			_spriteBtn.graphics.beginFill(0,0);
			_spriteBtn.graphics.drawRect(398-_npcLabel.textWidth,18,_npcLabel.textWidth,_npcLabel.textHeight);
			_spriteBtn.graphics.endFill();
			addChild(_spriteBtn);
			_spriteBtn.buttonMode = true;
			
			_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
			_transferBtn.move(382,7);
			addChild(_transferBtn);
			
			_tipIcon = new Bitmap();
			_tipIcon.x = 10;
			_tipIcon.y = 3;
			addChild(_tipIcon);
			var bmd:BitmapData;
			var tip:String;
			switch(_taskInfo.type)
			{
				
				case ActivityRewardsType.ITEM :
				{
					bmd = new DotIconItemAsset();
					break;
				}
				case ActivityRewardsType.MONEY :
				{
					bmd = new DotIconMoneyAsset();
					break;
				}
					
				case ActivityRewardsType.EXP :
				{
					bmd = new DotIconExpAsset();
					break;
				}
				case ActivityRewardsType.LIFE_EXP :
				{
					bmd = new DotIconLifeExpAsset();
					break;
				}
			}
			_tipIcon.bitmapData = bmd;
			
		}
		
		private function setData():void
		{
			var taskItem:TaskItemInfo = GlobalData.taskInfo.getTaskByTemplateId(_taskInfo.taskId);
			var finishCount:int = 0;
			if(TaskTemplateList.getTaskTemplate(_taskInfo.taskId).type==11)
			{
				_countLabel.setValue(LanguageManager.getWord("ssztl.activity.taskGet")+ _takenCount + "/" + String(_taskTemplate.repeatCount)+"  "+LanguageManager.getWord("ssztl.activity.taskSend")+ _publishCount + "/" + String(_taskTemplate.repeatCount));
			}
			else
			{
				if(taskItem)
				{
					finishCount = _taskTemplate.repeatCount - taskItem.dayLeftCount;
					_countLabel.setValue(finishCount + "/" + String(_taskTemplate.repeatCount));
				}else
				{
					finishCount = 0;
					_countLabel.setValue( finishCount + "/" + String(_taskTemplate.repeatCount));
				}
			}
			if(TaskTemplateList.getTaskTemplate(_taskInfo.taskId).type==11)
			{
				if(_takenCount==5&&_publishCount==5)
					this.enabled = false;
			}
				
			if(finishCount == _taskTemplate.repeatCount)
			{
				this.enabled = false;
			}
			
		}
		
		public function updateActivity(e:*):void
		{
			_takenCount =int(GlobalData.tokenInfo.acceptArray[0]) + int(GlobalData.tokenInfo.acceptArray[1]) + int(GlobalData.tokenInfo.acceptArray[2]) + int(GlobalData.tokenInfo.acceptArray[3]);
			_publishCount = int(GlobalData.tokenInfo.publishArray[0]) + int(GlobalData.tokenInfo.publishArray[1]) + int(GlobalData.tokenInfo.publishArray[2]) + int(GlobalData.tokenInfo.publishArray[3])
			setData();
		}
		
		private function initEvent():void
		{
			_transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.addEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			if(TaskTemplateList.getTaskTemplate(_taskInfo.taskId).type==11)
			{
				GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,updateActivity);
				GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateActivity);
			}
			
//			this.addEventListener(MouseEvent.MOUSE_OVER,overHanlder);
//			this.addEventListener(MouseEvent.MOUSE_OUT,outHanlder);
		}
		
		private function removeEvent():void
		{
			_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.removeEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			if(TaskTemplateList.getTaskTemplate(_taskInfo.taskId).type==11)
			{
				GlobalData.tokenInfo.removeEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,updateActivity);
				GlobalData.tokenInfo.removeEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateActivity);
			}
			
//			this.removeEventListener(MouseEvent.MOUSE_OVER,overHanlder);
//			this.removeEventListener(MouseEvent.MOUSE_OUT,outHanlder);
		}
		private function overHanlder(e:MouseEvent):void
		{
			var str:String = taskInfo.description;
			var awards:Array = taskInfo.awards;
			if(awards.length > 0)
			{
				str += "\n<font color='#78eb1c'>" + LanguageManager.getWord("ssztl.activity.ObtainMore");
				for(var i:int = 0; i < awards.length; i++)
				{
					str += ItemTemplateList.getTemplate(awards[i]).name + (i>=awards.length-1?"":"、");
				}
				str += "</font>";
			}
			
			TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
			_bgOver.visible = true;
		}
		private function outHanlder(e:MouseEvent):void
		{
			_bgOver.visible = false;
			TipsUtil.getInstance().hide();
		}
		private function spriteBtnClickHandler(evt:MouseEvent):void
		{
			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return ;
			}
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC,_npcInfo.templateId));
		}
		
		private function transferClickHandler(evt:MouseEvent):void
		{
			if(!GlobalData.selfPlayer.canfly())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int = _npcInfo.sceneId;
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:_npcInfo.getAPoint()}));
			}
		}
		
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(103));
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected)
			{
				ActivityPanel.SelectBorder.move(0,0);
				addChildAt(ActivityPanel.SelectBorder,0);
			}else
			{
				if(ActivityPanel.SelectBorder.parent == this)
				{
					removeChild(ActivityPanel.SelectBorder);
				}
			}
		}
		
		public function get taskInfo():ActivityTaskTemplateInfo
		{
			return _taskInfo;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(_enabled)
			{
				_nameLabel.setLabelType(MAssetLabel.LABEL_TYPE7); //textColor = 0xffcc66;
				_countLabel.setLabelType(MAssetLabel.LABEL_TYPE20)
				_npcLabel.setLabelType(MAssetLabel.LABEL_TYPE_TITLE2)
				_transferBtn.visible = true;
			}else
			{
				_nameLabel.textColor = _countLabel.textColor = _npcLabel.textColor = 0x777164;
				_npcLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.hasFinished"));
				_transferBtn.visible = false;
			}
		}
		
		public function dispose():void
		{
			removeEvent();		
			_npcInfo = null;
			_nameLabel = null;
			_levelLabel = null;
			_countLabel = null;
			_npcLabel = null;
			_spriteBtn = null;
			if(_transferBtn)
			{
				_transferBtn.dispose();
				_transferBtn = null;
			}
			if(_tipIcon && _tipIcon.bitmapData)
			{
				_tipIcon.bitmapData.dispose();
				_tipIcon = null;
			}
			if(ActivityPanel.SelectBorder.parent == this)
			{
				removeChild(ActivityPanel.SelectBorder);
			}
			if(_bgOver && _bgOver.bitmapData)
			{
				_bgOver.bitmapData.dispose();
				_bgOver = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}