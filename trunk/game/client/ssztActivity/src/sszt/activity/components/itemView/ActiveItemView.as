package sszt.activity.components.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.ActiveTabPanel;
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.data.ActiveType;
	import sszt.activity.data.itemViewInfo.ActiveItemInfo;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveTemplateInfo;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.richTextField.TransferBitmapBtn;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	/**
	 * ‘活跃度’选项卡下活跃度列表项
	 * */
	public class ActiveItemView extends Sprite
	{
		//排序用 
		//1 可用  2已完成 3不可用
 		public var sortAttrEnable:int = 1;
		//排序用  最小等级
		public var sortAttrMinlevel:int;
		
		private var _mediator:ActivityMediator;
		private var _activeNameLabel:MAssetLabel;
		private var _activeTimeLabel:MAssetLabel;
		private var _countLabel:MAssetLabel;
		private var _activeNumLabel:MAssetLabel;
		private var _transferBtn:TransferBitmapBtn;
		private var _activeItemInfo:ActiveItemInfo;
		private var _selected:Boolean;
		private var _npcId:int;
		private var _complete:MAssetLabel;
		private var _disabledLabel:MAssetLabel;
		
		public function ActiveItemView(mediator:ActivityMediator, argItemInfo:ActiveItemInfo)
		{
			super();
			_mediator = mediator;
			_activeItemInfo = argItemInfo;
			sortAttrMinlevel = _activeItemInfo.activeTemplateInfo.minLevel;
			initialView();
			initialEvents();
			
		}
		
		private function initialView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<ActiveTabPanel.COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+ActiveTabPanel.COLWidth[i]:ActiveTabPanel.COLWidth[0]+i*2);
			}
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,584,30);
			graphics.endFill();
			
			_activeNameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7);
			_activeNameLabel.move(ActiveTabPanel.COLWidth[0]/2,7);
			addChild(_activeNameLabel);
			_activeNameLabel.setHtmlValue("<a href=\'event:0\'><u>"+_activeItemInfo.activeTemplateInfo.activeName+"</u></a>");
			_activeNameLabel.mouseEnabled = true;
			_activeNameLabel.selectable = false;
			
			_activeTimeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_activeTimeLabel.move(colX[0]+ActiveTabPanel.COLWidth[1]/2,7);
			addChild(_activeTimeLabel);
			_activeTimeLabel.setValue(_activeItemInfo.activeTemplateInfo.activeTime);
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_countLabel.move(colX[1]+ActiveTabPanel.COLWidth[2]/2,7);
			addChild(_countLabel);
			
			_activeNumLabel = new MAssetLabel( "",MAssetLabel.LABEL_TYPE22,TextFormatAlign.CENTER);
			_activeNumLabel.move(colX[2]+ActiveTabPanel.COLWidth[3]/2,7);
			addChild(_activeNumLabel);
			_activeNumLabel.setValue("+"+_activeItemInfo.activeTemplateInfo.activeNum.toString());
			
			_complete = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_complete.move(colX[3]+ActiveTabPanel.COLWidth[4]/2,7);
			_complete.textColor = 0x777164;
			addChild(_complete);
			_complete.setHtmlValue(LanguageManager.getWord("ssztl.common.hasFinished"));
			_complete.visible = false;
			
			_disabledLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_disabledLabel.move(colX[3]+ActiveTabPanel.COLWidth[4]/2,7);
			_disabledLabel.textColor = 0x777164;
			addChild(_disabledLabel);
			_disabledLabel.setHtmlValue(LanguageManager.getWord("ssztl.activity.nLevelAvailable",_activeItemInfo.activeTemplateInfo.minLevel));
			_disabledLabel.visible = false;
			
			var count:int = _activeItemInfo.activeTemplateInfo.count;
			var completedNum:int = _activeItemInfo.count;
			if(completedNum > count)
			{
				completedNum = count;
			}
			_countLabel.setValue(completedNum + "/" + count.toString());
			
//			_activeTimeLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc66),0,_activeTimeLabel.length);
//			_activeNumLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc66),0,_activeNumLabel.length);
//			_countLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc66),0,_countLabel.length);
			
			if(canTransferToNpc())
			{
				_transferBtn = new TransferBitmapBtn();
				_transferBtn.move(ActiveTabPanel.COLWidth[0]-30,7);
				addChild(_transferBtn);
				
				_npcId = getNpcId();
				var npcInfo:NpcTemplateInfo = NpcTemplateList.getNpc(_npcId);
				var deployInfo:DeployItemInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.TASK_TRANSFER;
				deployInfo.param1 = npcInfo.sceneId;
				var p:Point = npcInfo.getAPoint();
				deployInfo.param2 = int(p.x) * 10000 + int(p.y);
				deployInfo.param3 = 1;//传送至npc
				deployInfo.param = _npcId;
				
				_transferBtn.info = deployInfo;
			}
			
			if(completedNum >= count || GlobalData.selfPlayer.level < _activeItemInfo.activeTemplateInfo.minLevel)
			{
				this.enabled = false;
			}
		}
		
		private function getNpcId():int
		{
			var ret:int;
			var npcIdList:Array = _activeItemInfo.activeTemplateInfo.npcId;
			if(npcIdList.length == 1)
			{
				ret = npcIdList[0]
			}
			if(npcIdList.length == 3)
			{
				switch(GlobalData.selfPlayer.career)
				{
					case CareerType.SANWU :
						ret = npcIdList[0];
						break;
					case CareerType.XIAOYAO :
						ret = npcIdList[1];
						break;
					case CareerType.LIUXING :
						ret = npcIdList[2];
						break;
				}
			}
			return ret;
		}
		
		private function initialEvents():void
		{
			_activeNameLabel.addEventListener(MouseEvent.CLICK, activeNameClickHandler);
			_activeItemInfo.addEventListener(ActivityInfoEvents.ACTIVE_ITEM_UPDATE,updateCountHandler);
			
			if(_transferBtn) _transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function removeEvents():void
		{
			_activeNameLabel.addEventListener(MouseEvent.CLICK, activeNameClickHandler);
			_activeItemInfo.removeEventListener(ActivityInfoEvents.ACTIVE_ITEM_UPDATE,updateCountHandler);
			
			if(_transferBtn) _transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			ActivityPanel.SelectBorder.setSize(580,29);
			ActivityPanel.SelectBorder.alpha = 0.5;
			addChildAt(ActivityPanel.SelectBorder,0);
		}
		private function outHandler(e:MouseEvent):void
		{
			if(ActivityPanel.SelectBorder.parent == this)
			{
				removeChild(ActivityPanel.SelectBorder);
			}
			ActivityPanel.SelectBorder.alpha = 1;
			ActivityPanel.SelectBorder.setSize(420,33);
		}
		private function transferClickHandler(evt:MouseEvent):void
		{
			var npcInfo:NpcTemplateInfo = NpcTemplateList.getNpc(_npcId);
			if(!GlobalData.selfPlayer.canfly())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int = npcInfo.sceneId;
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:npcInfo.getAPoint(),npcId:npcInfo.templateId}));
			}
		}
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(103));
			}
		}
		
		private function activeNameClickHandler(event:MouseEvent):void
		{
			var activeTemplateInfo:ActiveTemplateInfo = _activeItemInfo.activeTemplateInfo;
			if(_npcId)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC, _npcId));
			}
		}
		
		private function updateCountHandler(e:ActivityInfoEvents):void
		{
			_countLabel.text = _activeItemInfo.count.toString() + "/" + _activeItemInfo.activeTemplateInfo.count;
			if(_activeItemInfo.count == _activeItemInfo.activeTemplateInfo.count)
			{
				_activeNumLabel.text = "+" + _activeItemInfo.activeTemplateInfo.activeNum;
				enabled = false;
			}
			else _activeNumLabel.text = _activeItemInfo.activeTemplateInfo.activeNum.toString();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set select(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
				ActivityPanel.SelectBorder.move(0,-2);
				addChild(ActivityPanel.SelectBorder);
			}else
			{
				if(ActivityPanel.SelectBorder.parent == this)
					removeChild(ActivityPanel.SelectBorder);
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			if(value)
			{
				_complete.visible = false;
				_disabledLabel.visible = false;
				_activeNameLabel.setLabelType(MAssetLabel.LABEL_TYPE7);
				_activeNameLabel.setHtmlValue("<a href=\'event:0\'><u>"+_activeItemInfo.activeTemplateInfo.activeName+"</u></a>");
				_activeNameLabel.mouseEnabled = true;
				_activeTimeLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff00),0,_activeTimeLabel.length);
				_countLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc00),0,_countLabel.length);
				_activeNumLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc00),0,_activeNumLabel.length);
//				buttonMode = mouseChildren = true;
			}
			else
			{
				if(GlobalData.selfPlayer.level < _activeItemInfo.activeTemplateInfo.minLevel)
				{
					_disabledLabel.visible = true;
					sortAttrEnable = 3;
				}
				else
				{
					_complete.visible = true;
					sortAttrEnable = 2;
				}
				
				_activeNameLabel.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x777164)]);
				_activeNameLabel.setHtmlValue("<u>"+_activeItemInfo.activeTemplateInfo.activeName+"</u>");
				_activeNameLabel.mouseEnabled = false;
				_activeTimeLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x777164),0,_activeTimeLabel.length);
				_countLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x777164),0,_countLabel.length);
				_activeNumLabel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x777164),0,_activeNumLabel.length);
//				buttonMode = mouseChildren = false;
			}
		}
		
		private function canTransferToNpc():Boolean
		{
			var ret:Boolean;
			var type:int = _activeItemInfo.activeTemplateInfo.type;
			if(type == ActiveType.ACTIVE_COPY || type == ActiveType.ACTIVE_TASK || type == ActiveType.ACTIVE_JIANGHULING)
			{
				ret =  true;
			}
			if(type == ActiveType.ACTIVE_ONLINE_TIME)
			{
				ret = false;
			}
			return ret;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(ActivityPanel.SelectBorder.parent == this)
				removeChild(ActivityPanel.SelectBorder);
			_activeNameLabel = null;
			_activeTimeLabel = null;
			_countLabel = null;
			_activeNumLabel = null;
			_activeItemInfo = null;
		}

	}
}