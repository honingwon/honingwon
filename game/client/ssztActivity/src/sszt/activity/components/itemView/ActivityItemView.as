package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.components.ActivityTabPanel;
	import sszt.activity.data.ActivityRewardsType;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActivityTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
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
	import ssztui.activity.DotIconMedalAsset;
	import ssztui.activity.DotIconMoneyAsset;
	import ssztui.activity.RowOverBgAsset;
	
	public class ActivityItemView extends Sprite
	{
		private var _info:ActivityTemplateInfo;
		private var _npcInfo:NpcTemplateInfo;
		
		private var _selected:Boolean;
		
		private var _tipIcon:Bitmap;
		private var _nameLabel:MAssetLabel;
		private var _minLevelLabel:MAssetLabel;
		private var _timeLabel:MAssetLabel;
		private var _actionLabel:MAssetLabel;
		
		private var _transferBtn:MBitmapButton;		
		private var _spriteBtn:Sprite;
		
		private var _bgOver:Bitmap;
		
		public function ActivityItemView(info:ActivityTemplateInfo)
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
			for(var i:int=0; i<ActivityTabPanel.COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+ActivityTabPanel.COLWidth[i]:ActivityTabPanel.COLWidth[0]+i*2);
			}
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,420,34);
			graphics.endFill();
			
			_bgOver = new Bitmap(new RowOverBgAsset());
			_bgOver.x = _bgOver.y = 1;
			addChild(_bgOver);
			_bgOver.alpha = 0.4;
			_bgOver.visible = false;
			
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
			
			_minLevelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_minLevelLabel.move(colX[0]+ActivityTabPanel.COLWidth[1]/2,10);
			addChild(_minLevelLabel);
			_minLevelLabel.setValue( LanguageManager.getWord("ssztl.common.levelValue",_info.minLevel.toString()));
			
			_timeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_timeLabel.move(colX[1]+ActivityTabPanel.COLWidth[2]/2,10);
			addChild(_timeLabel);
			_timeLabel.setValue(_info.openTime);
			
			_actionLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.RIGHT);
			_actionLabel.move(398,10);
			addChild(_actionLabel);
			
			if(!_info.maps && !_npcInfo)
			{
//				_actionLabel.htmlText = "<font color='#cc3300'>" + LanguageManager.getWord("ssztl.activity.NotStarted") + "</font>";
				_actionLabel.htmlText = "<font color='#cc3300'>" + '-' + "</font>";
			}
			else if(_info.maps && !_npcInfo)
			{
				var map:MapTemplateInfo = MapTemplateList.list[_info.maps[0]];
				if(map)
				{
					_actionLabel.htmlText = "<u>" + map.name + "</u>　　";
					
					_spriteBtn = new Sprite();
					_spriteBtn.graphics.beginFill(0,0);
					_spriteBtn.graphics.drawRect(398-_actionLabel.textWidth,6,_actionLabel.textWidth,_actionLabel.textHeight);
					_spriteBtn.graphics.endFill();
					addChild(_spriteBtn);
					_spriteBtn.buttonMode = true;
					
					_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
					_transferBtn.move(382,7);
					addChild(_transferBtn);
				}
			}
			else if(!_info.maps && _npcInfo)
			{
				_actionLabel.htmlText = "<u>" + _npcInfo.name + "</u>　　";
				
				_spriteBtn = new Sprite();
				_spriteBtn.graphics.beginFill(0,0);
				_spriteBtn.graphics.drawRect(398-_actionLabel.textWidth,6,_actionLabel.textWidth,_actionLabel.textHeight);
				_spriteBtn.graphics.endFill();
				addChild(_spriteBtn);
				_spriteBtn.buttonMode = true;
				
				_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
				_transferBtn.move(382,7);
				addChild(_transferBtn);
			}
			if(GlobalData.selfPlayer.level < _info.minLevel)
			{
				if(_spriteBtn) _spriteBtn.visible = false;
				if(_transferBtn) _transferBtn.visible = false;
				_actionLabel.htmlText = "<font color='#777164'>" + LanguageManager.getWord("ssztl.activity.NotLevel") + "</font>";
			}
		}
		
		private function initEvent():void
		{
			if(_transferBtn) _transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			if(_spriteBtn) _spriteBtn.addEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			
//			this.addEventListener(MouseEvent.MOUSE_OVER,overHanlder);
//			this.addEventListener(MouseEvent.MOUSE_OUT,outHanlder);
		}
		
		private function removeEvent():void
		{
			if(_transferBtn) _transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			if(_spriteBtn) _spriteBtn.removeEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			
//			this.removeEventListener(MouseEvent.MOUSE_OVER,overHanlder);
//			this.removeEventListener(MouseEvent.MOUSE_OUT,outHanlder);
		}
		private function overHanlder(e:MouseEvent):void
		{
			var str:String = info.description + (info.description == ""?"":"\n");
			var awards:Array = info.awards;
			if(awards.length > 0)
			{
				str += "<font color='#78eb1c'>" + LanguageManager.getWord("ssztl.activity.ObtainMore");
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
			if(_npcInfo)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC,_npcInfo.templateId));
			}
			
			
			if(_info.maps)
			{
				var map:MapTemplateInfo = MapTemplateList.list[_info.maps[0]];
				if(map)
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:map.mapId,target:map.defalutPoint}));
				}
			}
		}
		
		private function transferClickHandler(evt:MouseEvent):void
		{
			if(!GlobalData.selfPlayer.canfly())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int;
				var point:Point;
				if(_npcInfo)
				{
					sceneId = _npcInfo.sceneId;
					point= _npcInfo.getAPoint();
				}
				
				if(_info.maps)
				{
					var map:MapTemplateInfo = MapTemplateList.list[_info.maps[0]];
					sceneId = map.mapId;
					point = map.defalutPoint;
				}
				
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:point}));
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
		
		public function get info():ActivityTemplateInfo
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
			if(_bgOver && _bgOver.bitmapData)
			{
				_bgOver.bitmapData.dispose();
				_bgOver = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}