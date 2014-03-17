package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.components.CopyTabPanel;
	import sszt.activity.components.panels.EntrustmentPanel;
	import sszt.activity.data.ActivityRewardsType;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyType;
	import sszt.core.data.entrustment.EntrustmentInfoEvent;
	import sszt.core.data.entrustment.EntrustmentItemInfo;
	import sszt.core.data.entrustment.EntrustmentTemplateItem;
	import sszt.core.data.entrustment.EntrustmentTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.DotIconExpAsset;
	import ssztui.activity.DotIconItemAsset;
	import ssztui.activity.DotIconLifeExpAsset;
	import ssztui.activity.DotIconMoneyAsset;
	
	public class CopyItemView extends Sprite
	{
		private var _entrustable:Boolean;
		private var _copyTemplateInfo:CopyTemplateItem;
		private var _entrustmentFightNeed:int;
		private var _npcInfo:NpcTemplateInfo;
		private var _mediator:ActivityMediator;
		private var _copyNameLabel:MAssetLabel;
		private var _copyLevelLabel:MAssetLabel;
		private var _copyProgressLabel:MAssetLabel;
		private var _copyCopperateLabel:MAssetLabel;
		private var _spriteBtn:Sprite;
		private var _transferBtn:MBitmapButton;
		private var _tipIcon:Bitmap;
		private var _select:Boolean;
		private var _enabled:Boolean;
		private var _btnEntrust:MCacheAssetBtn1;
		
		public function CopyItemView(argCopyTemplateInfo:CopyTemplateItem,argMediator:ActivityMediator)
		{
			super();
			_copyTemplateInfo = argCopyTemplateInfo;
			_entrustmentFightNeed = EntrustmentTemplateList.getFightNeed(_copyTemplateInfo.id,1);
			_entrustable = EntrustmentTemplateList.getEntrustable(_copyTemplateInfo.id)
			_npcInfo = NpcTemplateList.getNpc(_copyTemplateInfo.npcId);
			_mediator = argMediator;
			if(!_npcInfo) return;
			buttonMode = true;
			initialView();
			initialEvents();			
		}
		
		private function initialView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<CopyTabPanel.COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+CopyTabPanel.COLWidth[i]:CopyTabPanel.COLWidth[0]+i*2);
			}
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,420,34);
			graphics.endFill();
			
			_copyNameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_copyNameLabel.move(42,10);
			addChild(_copyNameLabel);
			_copyNameLabel.setValue(_copyTemplateInfo.name);
			
			_copyLevelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_copyLevelLabel.move(colX[0]+CopyTabPanel.COLWidth[1]/2,10);
			addChild(_copyLevelLabel);
			_copyLevelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_copyTemplateInfo.minLevel));
			
			_copyProgressLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_copyProgressLabel.move(colX[1]+CopyTabPanel.COLWidth[2]/2,10);
			addChild(_copyProgressLabel);
			var num:int = GlobalData.copyEnterCountList.getItemCount(_copyTemplateInfo.id);
			_copyProgressLabel.setValue(num + "/" + _copyTemplateInfo.dayTimes);
			
			_copyCopperateLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			_copyCopperateLabel.move(320,10);
			addChild(_copyCopperateLabel);
			_copyCopperateLabel.htmlText = "<u>" + LanguageManager.getWord("ssztl.common.goTo") + "</u>"; //_npcInfo.name
			
			_spriteBtn = new Sprite();
			_spriteBtn.graphics.beginFill(0,0);
			_spriteBtn.graphics.drawRect(320,8,_copyCopperateLabel.textWidth,_copyCopperateLabel.textHeight);
			_spriteBtn.graphics.endFill();
			addChild(_spriteBtn);
			_spriteBtn.buttonMode = true;
			
			_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
			_transferBtn.move(348,7);
			addChild(_transferBtn);
			
			_tipIcon = new Bitmap();
			_tipIcon.x = 10;
			_tipIcon.y = 3;
			addChild(_tipIcon);
			var bmd:BitmapData;
			var tip:String;
			switch(_copyTemplateInfo.showType)
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
			
			_btnEntrust = new MCacheAssetBtn1(1,1,LanguageManager.getWord('ssztl.activity.entrustmentTitle'));
			_btnEntrust.move(375,7);
			
			if(_entrustable)
			{
				addChild(_btnEntrust);
			}
			
			if(GlobalData.selfPlayer.level < _copyTemplateInfo.minLevel || num ==  _copyTemplateInfo.dayTimes) 
			{
				this.enabled = false;
				_btnEntrust.enabled = false;
			}
			
			if(_entrustmentFightNeed > GlobalData.selfPlayer.fight) 
			{
//				_btnEntrust.enabled = false;
			}
			
			if(_entrustable)
			{
				var entrustmentInfo:EntrustmentItemInfo = GlobalData.entrustmentInfo.currentEntrustment;
				var entrustmenTemplatetInfo:EntrustmentTemplateItem;
				if(entrustmentInfo && GlobalData.entrustmentInfo.isInEntrusting)
				{
					entrustmenTemplatetInfo = EntrustmentTemplateList.getTemplateById(entrustmentInfo.templateId);
					if(entrustmenTemplatetInfo.duplicateId == _copyTemplateInfo.id)
					{
						_btnEntrust.label = LanguageManager.getWord('ssztl.activity.entrustmentTitle2');
						_btnEntrust.enabled = false;
					}
					else
					{
						_btnEntrust.enabled = false;
					}
				}
			}
		}
		
		private function initialEvents():void
		{
			_transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.addEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			_btnEntrust.addEventListener(MouseEvent.CLICK,btnEntrustClickedHandler);
			if(_entrustable)
			{
				GlobalData.entrustmentInfo.addEventListener(EntrustmentInfoEvent.IS_IN_ENTRUSTING,isInEntrustingHandler);
			}
		}
		
		private function removeEvents():void
		{
			_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.removeEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			_btnEntrust.removeEventListener(MouseEvent.CLICK,btnEntrustClickedHandler);
			if(_entrustable)
			{
				GlobalData.entrustmentInfo.removeEventListener(EntrustmentInfoEvent.IS_IN_ENTRUSTING,isInEntrustingHandler);
			}
		}
		
		protected function isInEntrustingHandler(event:Event):void
		{
			if(GlobalData.entrustmentInfo.isInEntrusting)
			{
				var entrustmentInfo:EntrustmentItemInfo = GlobalData.entrustmentInfo.currentEntrustment;
				var entrustmenTemplatetInfo:EntrustmentTemplateItem;
				if(entrustmentInfo)
				{
					entrustmenTemplatetInfo = EntrustmentTemplateList.getTemplateById(entrustmentInfo.templateId);
					if(entrustmenTemplatetInfo.duplicateId == _copyTemplateInfo.id)
					{
						_btnEntrust.label = LanguageManager.getWord('ssztl.activity.entrustmentTitle2');
						_btnEntrust.enabled = false;
					}
					else
					{
						_btnEntrust.enabled = false;
					}
				}
			}
			else
			{
				_btnEntrust.label = LanguageManager.getWord('ssztl.activity.entrustmentTitle');
				_btnEntrust.enabled = true;
				
				var num:int = GlobalData.copyEnterCountList.getItemCount(_copyTemplateInfo.id);
				if(GlobalData.selfPlayer.level < _copyTemplateInfo.minLevel || num ==  _copyTemplateInfo.dayTimes) 
				{
					this.enabled = false;
					_btnEntrust.enabled = false;
				}
				
				if(_entrustmentFightNeed > GlobalData.selfPlayer.fight) 
				{
					_btnEntrust.enabled = false;
				}
			}
		}
		
		protected function btnEntrustClickedHandler(event:MouseEvent):void
		{
			_mediator.showEntrustmentPanel(_copyTemplateInfo.id);
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
		
		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			if(_select == value) return;
			_select = value;
			if(_select)
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
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(_enabled)
			{
				_copyNameLabel.setLabelType(MAssetLabel.LABEL_TYPE7);
				_copyLevelLabel.setLabelType(MAssetLabel.LABEL_TYPE20);
				_copyProgressLabel.setLabelType(MAssetLabel.LABEL_TYPE20);
				_copyCopperateLabel.setLabelType(MAssetLabel.LABEL_TYPE_TITLE2);
				_transferBtn.visible = _spriteBtn.visible =  true;
				_copyCopperateLabel.setHtmlValue("<u>" + _npcInfo.name + "</u>");
			}
			else
			{
				_copyNameLabel.textColor = _copyLevelLabel.textColor = _copyProgressLabel.textColor = _copyCopperateLabel.textColor = 0x777164;
				_transferBtn.visible = _spriteBtn.visible = false;
				if(GlobalData.selfPlayer.level < _copyTemplateInfo.minLevel)
					_copyCopperateLabel.setHtmlValue(LanguageManager.getWord("ssztl.activity.NotLevel"));
			}
		}

		public function get copyTemplateInfo():CopyTemplateItem
		{
			return _copyTemplateInfo;
		}

		public function set copyTemplateInfo(value:CopyTemplateItem):void
		{
			_copyTemplateInfo = value;
		}

		public function dispose():void
		{
			removeEvents();
			_copyTemplateInfo = null;
			_npcInfo = null;
			_mediator = null;

			_copyNameLabel = null;
			_copyLevelLabel = null;
			_copyProgressLabel = null;
			_copyCopperateLabel = null;
			_spriteBtn = null;
			if(_btnEntrust)
			{
				_btnEntrust.dispose();
				_btnEntrust = null;
			}
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
			if(parent) parent.removeChild(this);
		}
	}
}