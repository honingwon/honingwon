package sszt.swordsman.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.swordsman.UserInfoSocketHandler;
	import sszt.core.socketHandlers.task.TaskSubmitSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.mediator.SwordsmanMediator;
	import sszt.swordsman.socketHandlers.TokenTrustFinish;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.swordsman.TagAsset1;
	import ssztui.swordsman.TagAsset2;
	
	/**
	 * 公共中间部分 
	 * @author chendong
	 * 
	 */	
	public class CommonMiddle extends Sprite implements IPanel
	{
		
		private var _tagImg:Bitmap;
		/**
		 * 0:发布江湖令;1:领取江湖令 
		 */		
		private var _type:int = 0;
		
		/**
		 * 您现在拥有(您今日已领取):
		 */
		private var _hasSwords:MAssetLabel;
		
		/**
		 * 绿色江湖令：0个（已发布0个，被领取0个）      
		 */
		private var _hasGreenSwords:MAssetLabel;
		
		/**
		 * 蓝色江湖令：0个（已发布0个，被领取0个）      
		 */
		private var _hasBlueSwords:MAssetLabel;
		
		/**
		 * 紫色江湖令：0个（已发布0个，被领取0个）      
		 */
		private var _hasPurpleSwords:MAssetLabel;
		
		/**
		 * 橙色江湖令：0个（已发布0个，被领取0个）      
		 */
		private var _hasOrangeSwords:MAssetLabel;
		
		/**
		 * (领取他人发布的江湖令,可获得丰富的经验奖励)(发布的江湖令被他人领取可获得经验奖励)
		 */
		private var _description:MAssetLabel;
		
		/**
		 * 您今天还可以发布（领取）: 5/5 
		 */
		private var _swordsMan:MAssetLabel;
		/**
		 * 江湖令合成按钮 
		 */
		private var _synthesisBtn:MCacheAssetBtn1;
		/**
		 * 江湖令购买按钮
		 */
		private var _buyBtn:MCacheAssetBtn1;
		/**
		 * 完成任务按钮
		 */
		private var _finishBtn:MCacheAssetBtn1;
		
		private var _mediator:SwordsmanMediator;
		
		private var _greenId:int = 206001;
		private var _blueId:int = 206002;
		private var _purpleId:int = 206003;
		private var _orangeId:int = 206004;
		
		/**
		 * 任务类型 
		 */
		private var _taskType:int = 11;
		/**
		 * 发布或领取的江湖令 
		 */		
		private var count:int = 0;
		/**
		 * false任务未完成，true已完成 
		 */		
		private var _finishComplete:Boolean = false;
		
		/**
		 * 完成的江湖令令任务 
		 */
		private var _complateInfo:TaskItemInfo;
		
		public function CommonMiddle(type:int,mediator:SwordsmanMediator)
		{
			super();
			_type = type;
			_mediator = mediator
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			// TODO Auto Generated method stub
			_tagImg = new Bitmap();
			_tagImg.x = 19;
			_tagImg.y = 11;
			addChild(_tagImg);
			 
			_hasSwords = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hasSwords.move(0,0);
//			addChild(_hasSwords);
			
			_hasGreenSwords = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hasGreenSwords.textColor = 0x00ff00;
			addChild(_hasGreenSwords);
			
			_hasBlueSwords = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hasBlueSwords.textColor = 0x00ccff;
			addChild(_hasBlueSwords);
			
			_hasPurpleSwords = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hasPurpleSwords.textColor = 0xff00ff;
			addChild(_hasPurpleSwords);
			
			_hasOrangeSwords = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hasOrangeSwords.textColor = 0xff6600;
			addChild(_hasOrangeSwords);
			
			_description = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			addChild(_description);
			
			_swordsMan = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.RIGHT);
			_swordsMan.move(442,11);
			addChild(_swordsMan);
			
			_synthesisBtn = new MCacheAssetBtn1(0,4,LanguageManager.getWord("ssztl.swordsMan.synthesis"));
			_synthesisBtn.move(330,45);
			addChild(_synthesisBtn);
			_synthesisBtn.visible = false;
			
			_buyBtn = new MCacheAssetBtn1(0,4,LanguageManager.getWord("ssztl.swordsMan.buyBtn"));
			_buyBtn.move(330,75);
			addChild(_buyBtn);
			_buyBtn.visible = false;
			
			_finishBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.swordsMan.finishBtn"));
			_finishBtn.move(350,45);
			addChild(_finishBtn);
			_finishBtn.visible = false;
		}
		
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			switch(_type)
			{
				case 0:
					_tagImg.bitmapData = new TagAsset2() as BitmapData;
					_hasSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasSwords1"));
					_hasGreenSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasGreenSwords",GlobalData.bagInfo.getItemCountByItemplateId(_greenId),GlobalData.tokenInfo.publishArray[0],GlobalData.tokenInfo.tokenPublishArray[0]));
					_hasGreenSwords.move(35,36);
					_hasBlueSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasBlueSwords",GlobalData.bagInfo.getItemCountByItemplateId(_blueId),GlobalData.tokenInfo.publishArray[1],GlobalData.tokenInfo.tokenPublishArray[1]));
					_hasBlueSwords.move(35,54);
					_hasPurpleSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasPurpleSwords",GlobalData.bagInfo.getItemCountByItemplateId(_purpleId),GlobalData.tokenInfo.publishArray[2],GlobalData.tokenInfo.tokenPublishArray[2]));
					_hasPurpleSwords.move(35,72);
					_hasOrangeSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasOrangeSwords",GlobalData.bagInfo.getItemCountByItemplateId(_orangeId),GlobalData.tokenInfo.publishArray[3],GlobalData.tokenInfo.tokenPublishArray[3]));
					_hasOrangeSwords.move(35,90);
					_description.setValue(LanguageManager.getWord("ssztl.swordsMan.description1"));
					_description.move(35,108);
					
					
					_synthesisBtn.visible = true;
					_buyBtn.visible = true;
					_finishBtn.visible = false;
					break;
				case 1:
					_tagImg.bitmapData = new TagAsset1() as BitmapData;
					_hasSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasSwords2"));
					_hasGreenSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasGreenSwords1",GlobalData.tokenInfo.acceptArray[0]));
					_hasGreenSwords.move(35,44);
					_hasBlueSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasBlueSwords1",GlobalData.tokenInfo.acceptArray[1]));
					_hasBlueSwords.move(180,44);
					_hasPurpleSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasPurpleSwords1",GlobalData.tokenInfo.acceptArray[2]));
					_hasPurpleSwords.move(35,70);
					_hasOrangeSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasOrangeSwords1",GlobalData.tokenInfo.acceptArray[3]));
					_hasOrangeSwords.move(180,70);
					_description.setValue(LanguageManager.getWord("ssztl.swordsMan.description2"));
					_description.move(35,100);
					
					
					_synthesisBtn.visible = false;
					_buyBtn.visible = false;
					_finishBtn.visible = true;
					_finishBtn.enabled = false;
					
					_complateInfo = null; 
					var list:Array;
					var info:TaskItemInfo;
					//领取江湖令 完成的
					if(GlobalData.taskInfo.getTaskByTaskType(_taskType) != null)
					{
						list = GlobalData.taskInfo.getTaskByTaskType(_taskType);
						var flag:Boolean = false;
						for each(info in list)
						{
							if(info.isExist && !info.isFinish && GlobalData.taskInfo.taskStateChecker.checkStateComplete(info.getCurrentState(),info.requireCount) )
							{
								flag = true;
								_complateInfo = info;
								break;
							}
						}
						if(flag)
						{
							_finishBtn.enabled = true;
							_finishBtn.label = LanguageManager.getWord("ssztl.swordsMan.finishBtn"); 
							_finishComplete = true;
						}
						else
						{
							_finishBtn.label = LanguageManager.getWord("ssztl.swordsMan.finishNow");
							_finishComplete = false;
						}
					}
					else
					{
						_finishBtn.label = LanguageManager.getWord("ssztl.swordsMan.finishNow");
						_finishComplete = false;
					}
					
					
					//领取江湖令 未完成的
					if(GlobalData.taskInfo.getTaskByTaskType(_taskType) != null)
					{
						list = GlobalData.taskInfo.getTaskByTaskType(_taskType);
						var flag1:Boolean = false;
						for each(info in list)
						{
							if(info.isExist && !info.isFinish && !GlobalData.taskInfo.taskStateChecker.checkStateComplete(info.getCurrentState(),info.requireCount) )
							{
								flag1 = true;
								break;
							}
						}
						if(flag1)
						{
							_finishBtn.enabled = true;
						}
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
					_synthesisBtn.addEventListener(MouseEvent.CLICK,synthesisClick);
					_buyBtn.addEventListener(MouseEvent.CLICK,buyClick);
					
					GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,updatePublish);
					GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_TOKEN_PUBLISH,updateTokenPublish);
					GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
					break;
				case 1:
					_finishBtn.addEventListener(MouseEvent.CLICK,finishClick);
					GlobalData.tokenInfo.addEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateAccept);
					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.RIGHT_NOW_COMPLETE,rightNowComplete);
//					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.COMPLETE_TASK,complateTask);
					ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.TOKEN_TASK_ACCEPT,tokenTaskAccept);
					break;
			}
		}
		
		private function synthesisClick(evt:MouseEvent):void
		{
			SetModuleUtils.addFireBox(3,0);
		}
		
		private function buyClick(evt:MouseEvent):void
		{
			BuyPanel.getInstance().show([CategoryType.zistiandaoling,CategoryType.chengsetiandaoling],new ToStoreData(ShopID.STORE));
		}
		
		public function updatePublish(evt:SwordsmanMediaEvents):void
		{
			_hasGreenSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasGreenSwords",GlobalData.bagInfo.getItemCountByItemplateId(_greenId),GlobalData.tokenInfo.publishArray[0],GlobalData.tokenInfo.tokenPublishArray[0]));
			_hasBlueSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasBlueSwords",GlobalData.bagInfo.getItemCountByItemplateId(_blueId),GlobalData.tokenInfo.publishArray[1],GlobalData.tokenInfo.tokenPublishArray[1]));
			_hasPurpleSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasPurpleSwords",GlobalData.bagInfo.getItemCountByItemplateId(_purpleId),GlobalData.tokenInfo.publishArray[2],GlobalData.tokenInfo.tokenPublishArray[2]));
			_hasOrangeSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasOrangeSwords",GlobalData.bagInfo.getItemCountByItemplateId(_orangeId),GlobalData.tokenInfo.publishArray[3],GlobalData.tokenInfo.tokenPublishArray[3]));
		
			count = 5 - (int(GlobalData.tokenInfo.publishArray[0]) + int(GlobalData.tokenInfo.publishArray[1]) + int(GlobalData.tokenInfo.publishArray[2])
				+ int(GlobalData.tokenInfo.publishArray[3]));
			_swordsMan.setHtmlValue(LanguageManager.getWord("ssztl.swordsMan.toPublish",count));
		}
		
		public function updateTokenPublish(evt:SwordsmanMediaEvents):void
		{
			updatePublishDate();
		}
		public function bagInfoUpdateHandler(evt:BagInfoUpdateEvent):void
		{
			updatePublishDate();
		}
		public function updatePublishDate():void
		{
			_hasGreenSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasGreenSwords",GlobalData.bagInfo.getItemCountByItemplateId(_greenId),GlobalData.tokenInfo.publishArray[0],GlobalData.tokenInfo.tokenPublishArray[0]));
			_hasBlueSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasBlueSwords",GlobalData.bagInfo.getItemCountByItemplateId(_blueId),GlobalData.tokenInfo.publishArray[1],GlobalData.tokenInfo.tokenPublishArray[1]));
			_hasPurpleSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasPurpleSwords",GlobalData.bagInfo.getItemCountByItemplateId(_purpleId),GlobalData.tokenInfo.publishArray[2],GlobalData.tokenInfo.tokenPublishArray[2]));
			_hasOrangeSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasOrangeSwords",GlobalData.bagInfo.getItemCountByItemplateId(_orangeId),GlobalData.tokenInfo.publishArray[3],GlobalData.tokenInfo.tokenPublishArray[3]));
		}
		public function updateAccept(evt:SwordsmanMediaEvents):void
		{
			_hasGreenSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasGreenSwords1",GlobalData.tokenInfo.acceptArray[0]));
			_hasBlueSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasBlueSwords1",GlobalData.tokenInfo.acceptArray[1]));
			_hasPurpleSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasPurpleSwords1",GlobalData.tokenInfo.acceptArray[2]));
			_hasOrangeSwords.setValue(LanguageManager.getWord("ssztl.swordsMan.hasOrangeSwords1",GlobalData.tokenInfo.acceptArray[3]));
		
			count = 5 - (int(GlobalData.tokenInfo.acceptArray[0]) + int(GlobalData.tokenInfo.acceptArray[1]) + int(GlobalData.tokenInfo.acceptArray[2])
				+ int(GlobalData.tokenInfo.acceptArray[3]))
			_swordsMan.setHtmlValue(LanguageManager.getWord("ssztl.swordsMan.toAccept",count));
			
			
			
		}
		
		private function rightNowComplete(evt:SwordsmanMediaEvents):void
		{
			switch(_type)
			{
				case 0:
					break;
				case 1:
					_finishBtn.enabled = false;
					break;
			}
		}
		
//		private function complateTask(evt:SwordsmanMediaEvents):void
//		{
//			switch(_type)
//			{
//				case 0:
//					break;
//				case 1:
//					_finishBtn.enabled = false;
//					_finishComplete = false;
//					
//					UserInfoSocketHandler.send();
//					break;
//			}
//		}
		
		private function tokenTaskAccept(evt:SwordsmanMediaEvents):void
		{
			switch(_type)
			{
				case 0:
					break;
				case 1:
					_finishBtn.label = LanguageManager.getWord("ssztl.swordsMan.finishNow");
					_finishBtn.enabled = true;
					_finishComplete = false;
					break;
			}
		}
		
		private function finishClick(evt:MouseEvent):void
		{
			if(_finishComplete)
			{
				TaskSubmitSocketHandler.sendSubmit(_complateInfo.taskId);
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.swordsMan.buySwordsMan"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,finishTask);
				
			}
		}
		
		private function finishTask(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				if(2 <= GlobalData.selfPlayer.userMoney.yuanBao)
				{
					TokenTrustFinish.send();
				}
				else
				{
					//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,goingCharge);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
				}
				
			}
		}
		
		private function goingCharge(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				JSUtils.gotoFill();
			}
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			switch(_type)
			{
				case 0:
					_synthesisBtn.removeEventListener(MouseEvent.CLICK,synthesisClick);
					_buyBtn.removeEventListener(MouseEvent.CLICK,buyClick);
//					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.UPDATE_PUBLISH,updatePublish);
					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.UPDATE_TOKEN_PUBLISH,updateTokenPublish);
					GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
					break;
				case 1:
					_finishBtn.removeEventListener(MouseEvent.CLICK,finishClick);
					GlobalData.tokenInfo.removeEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateAccept);
//					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.UPDATE_ACCEPT,updateAccept);
					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.RIGHT_NOW_COMPLETE,rightNowComplete);
//					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.COMPLETE_TASK,complateTask);
					ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.TOKEN_TASK_ACCEPT,tokenTaskAccept);
					break;
			}
		}
		public function dispose():void
		{
			// TODO Auto Generated method stub
		}
	}
}