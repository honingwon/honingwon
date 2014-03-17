package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.components.ActivityPvPTabPanel;
	import sszt.activity.data.ActivityRewardsType;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActivityPvpTemplateInfo;
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
	
	import ssztui.activity.DotIconExpAsset;
	import ssztui.activity.DotIconItemAsset;
	import ssztui.activity.DotIconLifeExpAsset;
	import ssztui.activity.DotIconMedalAsset;
	import ssztui.activity.DotIconMoneyAsset;
	
	public class PvPItemView extends Sprite
	{
		private var _info:ActivityPvpTemplateInfo;
		private var _npcInfo:NpcTemplateInfo;
		
		private var _selected:Boolean;
		
		private var _tipIcon:Bitmap;
		private var _nameLabel:MAssetLabel;
		private var _minLevelLabel:MAssetLabel;
		private var _timeLabel:MAssetLabel;
		private var _actionLabel:MAssetLabel;
		private var _transferBtn:MBitmapButton;
		
		private var _spriteBtn:Sprite;
		private var _enabled:Boolean;
		
		public function PvPItemView(info:ActivityPvpTemplateInfo)
		{
			super();
			
			_info = info;
			_npcInfo = NpcTemplateList.getNpc(_info.npcId);
			
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			this.buttonMode = this.mouseChildren = true;
			
			var colX:Array = [];
			for(var i:int=0; i<ActivityPvPTabPanel.COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+ActivityPvPTabPanel.COLWidth[i]:ActivityPvPTabPanel.COLWidth[0]+i*2);
			}
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,420,34);
			graphics.endFill();
			
			_tipIcon = new Bitmap();
			_tipIcon.x = 10;
			_tipIcon.y = 3;
			addChild(_tipIcon);
			var bmd:BitmapData;
			var tip:String;
			switch(_info.awardType)
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
				case ActivityRewardsType.PVP_EXPLPIT :
				{
					bmd = new DotIconMedalAsset();
					break;
				}
			}
			_tipIcon.bitmapData = bmd;
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_nameLabel.move(42,10);
			addChild(_nameLabel);
			_nameLabel.setValue(_info.name);
			
			_minLevelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_minLevelLabel.move(colX[0]+ActivityPvPTabPanel.COLWidth[1]/2,10);
			addChild(_minLevelLabel);
			_minLevelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_info.minLevel.toString()));
			
			_timeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_timeLabel.move(colX[1]+ActivityPvPTabPanel.COLWidth[2]/2,10);
			addChild(_timeLabel);
			_timeLabel.setValue(_info.openTime);
			
			_actionLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.RIGHT);
			_actionLabel.move(378,10);
			addChild(_actionLabel);
			_actionLabel.htmlText = "<u>" + _npcInfo.name + "</u>";
			
			_spriteBtn = new Sprite();
			_spriteBtn.graphics.beginFill(0,0);
			_spriteBtn.graphics.drawRect(380-_actionLabel.textWidth,6,_actionLabel.textWidth,_actionLabel.textHeight);
			_spriteBtn.graphics.endFill();
			addChild(_spriteBtn);
			
			_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
			_transferBtn.move(382,7);
			addChild(_transferBtn);
			
			if(GlobalData.selfPlayer.level < _info.minLevel) 
				this.enabled = false;
		}
		
		private function initEvent():void
		{
			_transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.addEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.removeEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
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
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(_enabled)
			{
				_nameLabel.setLabelType(MAssetLabel.LABEL_TYPE7);
				_minLevelLabel.setLabelType(MAssetLabel.LABEL_TYPE20);
				_timeLabel.setLabelType(MAssetLabel.LABEL_TYPE20);
				_actionLabel.setLabelType(MAssetLabel.LABEL_TYPE_TITLE2);
				_transferBtn.visible = _spriteBtn.visible =  true;
				_actionLabel.setHtmlValue("<u>" + _npcInfo.name + "</u>");
			}
			else
			{
				_nameLabel.textColor = _minLevelLabel.textColor = _timeLabel.textColor = _actionLabel.textColor = 0x777164;
				_transferBtn.visible = _spriteBtn.visible = false;
				if(GlobalData.selfPlayer.level < _info.minLevel)
					_actionLabel.setHtmlValue(LanguageManager.getWord("ssztl.activity.NotLevel"));
			}
		}
		
		public function get info():ActivityPvpTemplateInfo
		{
			return _info;
		}
		
		public function dispose():void
		{
			removeEvent();		
			_npcInfo = null;
			_nameLabel = null;
			_minLevelLabel = null;
			_actionLabel = null;
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
			if(parent) parent.removeChild(this);
		}
	}
}