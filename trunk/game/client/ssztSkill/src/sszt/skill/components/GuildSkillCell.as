package sszt.skill.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseSkillItemCell;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.skill.components.items.MSkillCacheAssetBtn;
	import sszt.skill.events.CellEvent;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.skill.SkillItemOverAsset;
	import ssztui.skill.SkillItemUpAsset;
	import ssztui.skill.SkillLevelAsset;
	import ssztui.skill.SkillSelectedAsset;
	import ssztui.ui.BorderAsset15;
	
	public class GuildSkillCell extends BaseSkillItemCell
	{
		private var _canUpgrade:Boolean;
		private var _asset:MCacheAssetBtn1;
		private var _selected:Boolean;
		private var _selectIco:Bitmap;
		private var _bg:Bitmap;
		private var _level:MAssetLabel,_skillName:MAssetLabel,_need:MAssetLabel;
		private var _sp:Sprite;
		
		private static const leveBitmapData:BitmapData = new SkillLevelAsset();
		public function GuildSkillCell()
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,252,53);
			graphics.endFill();
			buttonMode = true;
			
			
			_bg = new Bitmap(new SkillItemUpAsset());
			addChild(_bg);
			super();
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(7,7,38,38),new Bitmap(CellCaches.getCellBg())));
			
			_level = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_level.textColor = 0xffcc00;
			_level.move(195,9);			
			_skillName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_skillName.textColor = 0x66ff00; 
			_skillName.move(53,9);
			_need = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_need.textColor = 0xfffccc;
			_need.move(53,27);
			_asset = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.upgrade"));
			_asset.addEventListener(MouseEvent.CLICK,upgradeBtnHandler);
			_asset.move(190,13);
			//			_asset.enabled = false;
			mouseEnabled = true;
		}
		
		public function set canUpgrade(value:Boolean):void
		{
			if(_canUpgrade == value) return;
			_canUpgrade = value;
				
			_asset.enabled = _canUpgrade;
		}
		
		private function checkUpgrade():Boolean
		{
			var level:int = 0;
			var template:SkillTemplateInfo;
			if(super.skillInfo) level = super.skillInfo.level;
			template = super.info as SkillTemplateInfo;
			if(level >= template.totalLevel) return false;
			if(GlobalData.selfPlayer.level < template.needLevel[level]) return false;
			if((GlobalData.selfPlayer.userMoney.copper + GlobalData.selfPlayer.userMoney.bindCopper) < template.needCopper[level]) return false;
			if(GlobalData.selfPlayer.lifeExperiences < template.needLifeExp[level]) return false;
			if(template.needSkillId[level] != 0 && GlobalData.skillInfo.getSkillByLevel(template.needSkillId[level],template.needSkillLevel[level]) == null) return false;
			if(template.needFeats[level] != 0 && GlobalData.selfPlayer.selfExploit < template.needFeats[level]) return false;
			if(ItemTemplateList.getTemplate(template.needItemId[level]))
			{
				if(GlobalData.bagInfo.getItemById(template.needItemId[level]) == null) return false;
			}
			return true;
		}
		
		override public function set skillInfo(value:SkillItemInfo):void
		{
			if(super.skillInfo) super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			super.skillInfo = value;
			canUpgrade = checkUpgrade();
			if(value) 
			{
				super.skillInfo.addEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				_level.text = "("+LanguageManager.getWord("ssztl.common.levelValue",super.skillInfo.level)+")";
				var level:int = 0;
				if(super.skillInfo) level = super.skillInfo.level;
				var template:SkillTemplateInfo;
				template = super.info as SkillTemplateInfo;
				if(level >= template.totalLevel)
				{
					_asset.enabled = false;
					_asset.label =  LanguageManager.getWord("ssztl.common.overLevel");
					_need.text = LanguageManager.getWord("ssztl.common.none");
				}
				else
				{
					_asset.label = LanguageManager.getWord("ssztl.common.upgrade");
					_need.text = LanguageManager.getWord("ssztl.skill.guildSkillNedd",super.skillInfo.getTemplate().needFeats[super.skillInfo.level],super.skillInfo.getTemplate().needCopper[super.skillInfo.level]);
				}					
			}
			
		}
		
		override public function set info(value:ILayerInfo):void
		{
			super.info = value;
			if(super.info)
			{
				canUpgrade = checkUpgrade();
				addChild(_asset);
				addChild(_level);
				addChild(_skillName);
				addChild(_need);
				var skill:SkillTemplateInfo = super.info as SkillTemplateInfo;
				
				_level.text = "("+LanguageManager.getWord("ssztl.common.levelValue",0)+")";
				_skillName.setHtmlValue("<b>"+skill.name+"</b>");
				_level.x = _skillName.x + _skillName.textWidth + 3;
				_need.text = LanguageManager.getWord("ssztl.skill.guildSkillNedd",skill.needFeats[0],skill.needCopper[0]);
			}
		}
		
		private function upgradeBtnHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this.dispatchEvent(new CellEvent(CellEvent.UPGRADE_CLICK,(super.info as SkillTemplateInfo).templateId));
		}
		
		private function upgradeHandler(evt:SkillItemInfoUpdateEvent):void
		{
			canUpgrade = checkUpgrade();
		}
		
		public function get canUpgrade():Boolean
		{
			return _canUpgrade;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(10,10,32,32);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_bg)
				_bg.bitmapData = new SkillItemUpAsset();
			if(_selected)
			{
				if(_bg) _bg.bitmapData = new SkillItemOverAsset();
			}
			
			/*
			if(_selectIco)
			{
				if(_selectIco && _selectIco.parent)
				{
					removeChild(_selectIco);
				}
				_selectIco.bitmapData.dispose();
				_selectIco = null;
			}
			if(_selected)
			{
				_selectIco = new Bitmap(new SkillItemOverAsset());
				addChild(_selectIco);
			}
			*/
			
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			
		}
		
		override public function dispose():void
		{
			if(_asset)
			{
				_asset.removeEventListener(MouseEvent.CLICK,upgradeBtnHandler);
				_asset.dispose();
				_asset = null;
			}
			if(_selectIco && _selectIco.bitmapData)
			{
				_selectIco.bitmapData.dispose();
				_selectIco = null;
			}
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			_level = null;
			if(super.skillInfo)
			{
				super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,lockUpdateHandler);
				super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,cooldownUpdateHandler);
				super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			}
			
				
			super.dispose();
		}
		
	}
}