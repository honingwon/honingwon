package sszt.skill.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseSkillItemCell;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	
	import ssztui.skill.SkillLevelAsset;
	import ssztui.skill.SkillSelectedAsset;
	
	public class SkillCell extends BaseSkillItemCell
	{
		private static const leveBitmapData:BitmapData = new SkillLevelAsset();
		public static const UPGRADE_CLICK:String = "UPGRADE_CLICK";
		
		private var _canUpgrade:Boolean;
		private var _selected:Boolean;
		
		private var _level:MAssetLabel;
		
		private var _asset:MCacheAssetBtn2;
		
		private var _selectIco:Bitmap;
		private var _levelBg:Bitmap;
		private var _over:Bitmap;
		
		public function SkillCell()
		{
			super();
			buttonMode = true;
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.x = _over.y = -3;
			_over.visible = false;
			addChild(_over);
			
			_levelBg = new Bitmap();
			_levelBg.x = -6;
			_levelBg.y = 22;
			addChild(_levelBg);
			_level = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_level.move(-2,22);
			addChild(_level);
			
		}
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		
		public function set canUpgrade(value:Boolean):void
		{
			if(_canUpgrade == value) return;
			_canUpgrade = value;
			if(_canUpgrade)
			{
				_asset = new MCacheAssetBtn2(7);
				_asset.addEventListener(MouseEvent.CLICK,upgradeBtnHandler);
				_asset.x = 20;
				_asset.y = 22;
				addChild(_asset);
			}
			else
			{
				if(_asset && _asset.parent)
				{
					removeChild(_asset);
					_asset = null;
				}
			}
		}
		
		public function checkUpgrade():Boolean
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
				if(super.skillInfo.level > 0)
				{
					if(_levelBg.bitmapData == null)
					{
						_levelBg.bitmapData = leveBitmapData;
					}
					if(super.skillInfo.level>10)
					{
						_level.x = -7;
					}
					else
					{
						_level.x = -2;
					}
					_level.text = super.skillInfo.level.toString();
				}
			}
		}
		
		override public function set info(value:ILayerInfo):void
		{
			super.info = value;
			if(super.info)
			{
				canUpgrade = checkUpgrade();
			}
		}
		
		private function upgradeBtnHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			this.dispatchEvent(new Event(UPGRADE_CLICK));
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
			_figureBound = new Rectangle(0,0,32,32);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
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
				_selectIco = new Bitmap(new SkillSelectedAsset());
				_selectIco.x = -7;
				_selectIco.y = -7;
				addChildAt(_selectIco,0);
			}
			
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			//Aron.ADD 2013.3.5
			setChildIndex(_over,numChildren - 1);
			if(_asset)
			{
				setChildIndex(_asset,numChildren - 1);
			}
			if(_levelBg)
			{
				setChildIndex(_levelBg,numChildren - 1);
			}
			if(_level)
			{
				setChildIndex(_level,numChildren - 1);
			}
			
		}
		
		override public function dispose():void
		{
			if(_asset)
			{
				_asset.removeEventListener(MouseEvent.CLICK,upgradeBtnHandler);
				_asset.dispose();
				_asset = null;
			}
			if(_selectIco)
			{
				_selectIco.bitmapData.dispose();
				_selectIco = null;
			}
			if(_levelBg)
			{
				_levelBg = null;
			}
			_level = null;
			if(super.skillInfo)
			{
				super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,lockUpdateHandler);
				super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,cooldownUpdateHandler);
				super.skillInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			}
			if(_over){
				_over.bitmapData.dispose();
				_over = null;
			}
				
			super.dispose();
		}
		
	}
}