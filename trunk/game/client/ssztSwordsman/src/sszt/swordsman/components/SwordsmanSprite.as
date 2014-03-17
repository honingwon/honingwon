package sszt.swordsman.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.swordsman.SwordsmanTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.swordsman.UserInfoSocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.mediator.SwordsmanMediator;
	import sszt.swordsman.socketHandlers.TaskAcceptSocketHandler;
	import sszt.swordsman.socketHandlers.TaskPublishSocketHandler;
	import sszt.swordsman.socketHandlers.TokenPubliskListSocketHandler;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class SwordsmanSprite extends Sprite implements IPanel
	{
		/**
		 * 0:发布江湖令;1:领取江湖令 
		 */		
		public var _type:int = 0;
		
		/**
		 * 江湖令类型 
		 */
		public var _swordsType:int = 0
		
		/**
		 * 江湖令图片 
		 */
		public var _swordsmanPic:Cell;
		
		/**
		 * 江湖令名称 :绿色江湖令
		 */
		private var _swordsmanName:MAssetLabel;
		
		/**
		 * 经验值: (10050经验) 
		 */
		private var _expValue:MAssetLabel;
		
		/**
		 * 发布(领取)江湖令按钮 
		 */
		private var _btn:MCacheAssetBtn1;
		
		/**
		 * 江湖令数量
		 */
		private var _amount:MAssetLabel;
		
		private var _itemplateIdArray:Array = [206001,206002,206003,206004];
		private var _swordsmanname:Array = [LanguageManager.getWord("ssztl.swordsMan.swordsman1"),LanguageManager.getWord("ssztl.swordsMan.swordsman2"),
			                                LanguageManager.getWord("ssztl.swordsMan.swordsman3"),LanguageManager.getWord("ssztl.swordsMan.swordsman4")]
			
		private var _mediator:SwordsmanMediator;
		
		/**
		 * 领取的江湖令 
		 */		
		private var countReceive:int = 0;
		
		public function SwordsmanSprite(type:int,swordsType:int,mediator:SwordsmanMediator)
		{
			super();
			_type = type;
			_swordsType = swordsType
			_mediator = mediator;
			initView();
			initEvent();
			initData(); 
		}
		
		public function initView():void
		{
			// TODO Auto Generated method stub
			
			_swordsmanPic = new Cell();
			_swordsmanPic.move(0,0);
			
			_amount = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.RIGHT);
			_amount.setLabelType([new TextFormat("SimSun",12,0xfffccc,true)])
			_amount.move(77,48);
			addChild(_amount);
			
			_swordsmanName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_swordsmanName.move(51,69);
			addChild(_swordsmanName);
			
			_expValue = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_expValue.move(51,88);
			addChild(_expValue);
			
			_btn = new MCacheAssetBtn1(0,3,"");
			_btn.move(21,116);
			addChild(_btn);
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			switch(_type)
			{
				case 0:
					if(GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]) != 0)
					{
						_amount.setValue(GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]).toString());
					}
					_expValue.setValue(LanguageManager.getWord("ssztl.swordsMan.expValue")+int(SwordsmanTemplateList.getSwordsmanTemplateInfoById(int(_swordsType+1)).exp*GlobalData.selfPlayer.level*GlobalData.selfPlayer.level*0.3))
					_btn.label = LanguageManager.getWord("ssztl.swordsMan.releaseThis");
					break;
				case 1:
					TokenPubliskListSocketHandler.send();
					break; 
			}
			
			switch(_swordsType)
			{
				case 0: // 绿
					_swordsmanName.textColor =  0x00ff00;
					break;
				case 1: // 蓝
					_swordsmanName.textColor =  0x00ccff;
					break;
				case 2: // 紫
					_swordsmanName.textColor =  0xff00ff;
					break;
				case 3: // 橙
					_swordsmanName.textColor =  0xff7200;
					break;
			}
			_swordsmanName.setValue(_swordsmanname[_swordsType]);
		}
		
		private function toShowSwordNum(evt:SwordsmanMediaEvents):void
		{
			if(GlobalData.tokenInfo.tokenNum[_swordsType] != 0)
			{
//				_amount.setValue(_mediator.swordsmanModule.tokenInfo.tokenNum[_swordsType]);
				_amount.text = GlobalData.tokenInfo.tokenNum[_swordsType].toString();
			}
			else
			{
				_btn.enabled = false;
			}
			_expValue.setValue(LanguageManager.getWord("ssztl.swordsMan.expValue")+SwordsmanTemplateList.getSwordsmanTemplateInfoById(int(_swordsType+1)).exp*GlobalData.selfPlayer.level*GlobalData.selfPlayer.level)
			_btn.label = LanguageManager.getWord("ssztl.swordsMan.receiveThis");
			_btn.enabled = getBoolen();
		}
		
		public function updateReceive(evt:SwordsmanMediaEvents):void
		{
			
			switch(_type)
			{
				case 0:
//					count = 5 - (int(GlobalData.tokenInfo.publishArray[0]) + int(GlobalData.tokenInfo.publishArray[1]) + int(GlobalData.tokenInfo.publishArray[2])
//						+ int(GlobalData.tokenInfo.publishArray[3]));
//					
					break;
				case 1:
					countReceive = 5 - (int(GlobalData.tokenInfo.acceptArray[0]) + int(GlobalData.tokenInfo.acceptArray[1]) + int(GlobalData.tokenInfo.acceptArray[2])
						+ int(GlobalData.tokenInfo.acceptArray[3]));
					if(countReceive <= 0)
					{
						_btn.enabled = false;
					}
					break;
			}
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			switch(_type)
			{
				case 0:
//					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,publishHander);
					GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,publishHander);
					GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
					break;
				case 1:
					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.TOKEN_TASK_ACCEPT,btnEnable);
					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.RIGHT_NOW_COMPLETE,btnEnableTrue);
//					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.COMPLETE_TASK,btnEnableTrue1);
					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.TO_SHOW_RELEASE_SOWRDMAN_NUM,toShowSwordNum);
					GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateReceive);
					break;
			}
			_btn.addEventListener(MouseEvent.CLICK,btnClick);
		}
		
		private function getBoolen():Boolean
		{
			var boolean:Boolean = true;
			var _taskType:int = 11;
			var list:Array;
			var info:TaskItemInfo;
			//领取江湖令 未提交的 （完成未提交，领取未完成）
			if(GlobalData.taskInfo.getTaskByTaskType(_taskType) != null)
			{
				list = GlobalData.taskInfo.getTaskByTaskType(_taskType);
				var flag:Boolean = false;
				for each(info in list)
				{
					if(info.isExist && !info.isFinish)
					{
						flag = true;
						break;
					}
				}
				if(flag)
				{
					boolean = false; 
				}
			}
			else
			{
				boolean = true;
			}
			return boolean;
		}
		public function publishHander(evt:SwordsmanMediaEvents):void
		{
			updatePublish();
		}
		
		public function bagInfoUpdateHandler(evt:BagInfoUpdateEvent):void
		{
			updatePublish();
		}
		
		public function updatePublish():void
		{
			var countStr:String = "";
			var count:int = 0;
			switch(_type)
			{
				case 0:
					countStr = GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]) != 0 ? GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]).toString() : "";
					_amount.setValue(countStr); 
					
					//当发不完当天的江湖令次数，按钮不能点击
					count = 5 - (int(GlobalData.tokenInfo.publishArray[0]) + int(GlobalData.tokenInfo.publishArray[1]) + int(GlobalData.tokenInfo.publishArray[2])
						+ int(GlobalData.tokenInfo.publishArray[3]));
					if(count == 0)
					{
						_btn.enabled = false;
					}
					break;
				case 1:
					break; 
			}
		}
		
		public function btnEnable(evt:SwordsmanMediaEvents):void
		{
			switch(_type)
			{
				case 0:
					break;
				case 1:
					_btn.enabled = false;
					break;
			}
		}
		
		private function btnEnableTrue(evt:SwordsmanMediaEvents):void
		{
			switch(_type)
			{
				case 0:
					break;
				case 1:
//					_btn.enabled = true;
					countReceive = 5 - (int(GlobalData.tokenInfo.acceptArray[0]) + int(GlobalData.tokenInfo.acceptArray[1]) + int(GlobalData.tokenInfo.acceptArray[2])
						+ int(GlobalData.tokenInfo.acceptArray[3]));
					if(countReceive <= 0)
					{
						_btn.enabled = false;
					}
					else
					{
						_btn.enabled = true;
					}
					break;
			}
		}
		
//		private function btnEnableTrue1(evt:SwordsmanMediaEvents):void
//		{
//			switch(_type)
//			{
//				case 0:
//					break;
//				case 1:
//					_btn.enabled = true;
//					break;
//			}
//		}
		
		public function btnClick(evt:MouseEvent):void
		{
			switch(_type)
			{
				case 0:
					
					//发布此令
					if(_swordsType == 2 && GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]) <= 0) //紫色
					{
//						BuyPanel.getInstance().dispose();
						BuyPanel.getInstance().show([CategoryType.zistiandaoling],new ToStoreData(ShopID.STORE));
						return;
					}
					if(_swordsType == 3 && GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]) <= 0) //橙色
					{
//						BuyPanel.getInstance().dispose();
						BuyPanel.getInstance().show([CategoryType.chengsetiandaoling],new ToStoreData(ShopID.STORE));
						return;
					}
					if(GlobalData.bagInfo.getItemCountByItemplateId(_itemplateIdArray[_swordsType]) <= 0)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.swordsMan.swordmanNotEn"));
						return;
					}
					TaskPublishSocketHandler.send(int(_swordsType+1));
					break;
				case 1:
					//领取此令
					TaskAcceptSocketHandler.sendType(int(_swordsType+1));
					break;
			}
		}
		
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			switch(_type)
			{
				case 0:
//					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,publishHander);
					break;
				case 1:
					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.TOKEN_TASK_ACCEPT,btnEnable);
					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.RIGHT_NOW_COMPLETE,btnEnableTrue);
//					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.COMPLETE_TASK,btnEnableTrue1);
					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.TO_SHOW_RELEASE_SOWRDMAN_NUM,toShowSwordNum);
					GlobalData.tokenInfo.removeEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateReceive);
					break;
			}
			_btn.removeEventListener(MouseEvent.CLICK,btnClick);
		}
	}
}