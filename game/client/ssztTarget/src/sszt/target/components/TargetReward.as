package sszt.target.components
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.target.TargetGetAwardSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.target.SealHasAsset;
	
	/**
	 * 目标奖励 
	 * @author chendong
	 * 
	 */	
	public class TargetReward extends Sprite implements IPanel
	{
		/**
		 * 目标图片 
		 */
		public var _targetRewardPic:Cell;
		
		/**
		 * 领取奖励按钮 
		 */
		private var _btn:MCacheAssetBtn1;
		
		/**
		 * 目标内容标题:
		 */
		private var _targetContentTitle:MAssetLabel;
		/**
		 * 目标内容:
		 */
		private var _targetContent:MAssetLabel;
		
		/**
		 * 温馨提示标题:
		 */
		private var _warmPromptTitle:MAssetLabel;
		/**
		 * 温馨提示:
		 */
		private var _warmPrompt:MAssetLabel;
		/**
		 * 已领印章
		 */
		private var _sealHas:Bitmap;
		
		/**
		 * 当前所选择目标
		 */
		private var _selecteditem:TargetTemplatInfo;
		
		/**
		 * 当前选择的目标类型 
		 */
		private var _currentType:int;
		
		public function TargetReward(currentType:int=1)
		{
			super();
			_currentType = currentType;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			// TODO Auto Generated method stub
			_targetRewardPic = new Cell();
			_targetRewardPic.move(6,112);
			addChild(_targetRewardPic);
			
			_btn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.getLabel"));
			_btn.move(143,124);
			addChild(_btn);
			
			_targetContentTitle = new MAssetLabel(LanguageManager.getWord("ssztl.target.targetContent"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_targetContentTitle.textColor = 0x000000;
			_targetContentTitle.move(25,14);
//			addChild(_targetContentTitle);
			
			_targetContent = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_targetContent.textColor = 0xff9900;
			_targetContent.move(0,14);
			addChild(_targetContent);
			
			_warmPromptTitle = new MAssetLabel(LanguageManager.getWord("ssztl.target.warmPrompt"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_warmPromptTitle.textColor = 0xffcc66;
			_warmPromptTitle.move(0,40);
			addChild(_warmPromptTitle);
			
			_warmPrompt = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_warmPrompt.wordWrap = true;
			_warmPrompt.textColor = 0xfffCCC;
			_warmPrompt.setSize(225,40);
			_warmPrompt.move(0,60);
			addChild(_warmPrompt);
			
			_sealHas = new Bitmap(new SealHasAsset());
			_sealHas.x = 48;
			_sealHas.y = 107;
			addChild(_sealHas);
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			if(getArrayData().length > 0)
			{
				_selecteditem = getArrayData()[0];
			}
			else
			{
				_selecteditem = TargetUtils.getTargetTemplateData(_currentType)[0];
			}
			setinitData();
		}
		
		private function getArrayData():Array
		{
			clearData();
			var targetArray:Array = [];
			targetArray = TargetUtils.getTargetArray(_currentType);
			return targetArray;
		}
		
//		private function getTargetArray(currentType:int):Array
//		{
//			var targetArray:Array = [];
//			var targetInfo:TargetTemplatInfo;
//			var targetTemplateArray:Array = TargetUtils.getTargetTemplateData(currentType);
//			var targetData:TargetData = null;
//			//完成未领取
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(targetData && targetData.isFinish && !targetData.isReceive)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			
//			//在完成过程当中
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(targetData && !targetData.isFinish && !targetData.isReceive)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			
//			//未完成未领取
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(!targetData)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			
//			//完成已领取
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(targetData && targetData.isFinish && targetData.isReceive)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			return targetArray;
//		}
		
		public function setinitData():void
		{
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _selecteditem.awardsId;
			itemInfo.count = _selecteditem.awardsNum;
			_targetRewardPic.itemInfo = itemInfo;
			_targetContent.setHtmlValue("<b>"+_selecteditem.title+"</b>");
			_warmPrompt.setHtmlValue(_selecteditem.tip);
			
			var targetData:TargetData;
			if(!GlobalData.targetInfo.targetByIdDic[_selecteditem.target_id])
			{
				// 未完成
				_btn.enabled = false;
				_sealHas.visible = false;
			}
			else if(GlobalData.targetInfo.targetByIdDic[_selecteditem.target_id])
			{
				targetData = GlobalData.targetInfo.targetByIdDic[_selecteditem.target_id];
				if(targetData.isFinish && targetData.isReceive)
				{
					// 已领取奖励
					_btn.enabled = false;
					_sealHas.visible = true;
				}
				else if(!targetData.isFinish && !targetData.isReceive)
				{
					//在完成过程当中
					_btn.enabled = false;
					_sealHas.visible = false;
				}
				else if(targetData.isFinish && !targetData.isReceive)
				{
					// 已完成 未领取奖励
					_btn.enabled = true;
					_sealHas.visible = false;
				}
			}
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			_btn.addEventListener(MouseEvent.CLICK,getTargetReward);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.CLICK_TARGET,clickTargetItem);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardT);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.CLICK_TARGET_TYPE,clickTargetType);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListT);
		}
		
		private function getTargetReward(evt:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.bagFull"));
				return;
			}
			TargetGetAwardSocketHandler.getTargetAwardById(_selecteditem.target_id);
		}
		
		private function clickTargetItem(evt:ModuleEvent):void
		{
			_selecteditem = evt.data.item as TargetTemplatInfo;
			setinitData();
		}
		
		private function getTargetAwardT(evt:ModuleEvent):void
		{
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.TARGET_TYPE)
			{
				_btn.enabled = false;
				_sealHas.visible = true;
				initData()
			}
		} 
		
		private function clickTargetType(evt:ModuleEvent):void
		{
			_currentType = int(evt.data.type);
			initData()
		}
		
		private function updateTargetListT(evt:ModuleEvent):void
		{
			setinitData();
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			_btn.removeEventListener(MouseEvent.CLICK,getTargetReward);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.CLICK_TARGET,clickTargetItem);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardT);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.CLICK_TARGET_TYPE,clickTargetType);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListT);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			_targetRewardPic.itemInfo = null;
			_targetContent.setValue("");
			_warmPrompt.setValue("");
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}