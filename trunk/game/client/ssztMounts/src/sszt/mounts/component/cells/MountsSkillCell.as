package sszt.mounts.component.cells
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.LayerType;
	import sszt.core.data.mounts.mountsSkill.MountsSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseSkillCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.pet.luckedCellBgAsset;
	
	public class MountsSkillCell extends BaseSkillCell
	{
		private var _place:int;
		private var _closeLabel:TextField;
		private var _levelLabel:TextField;
		private var _lockCellBg:Bitmap;
		private var _isOpen:Boolean;
		private var _selected:Boolean;
		private var _skillInfo:SkillItemInfo;
		private var _over:Bitmap;
		private var _selectBg:Bitmap;
		
		public function MountsSkillCell(place:int)
		{
			_place = place;
			super();
			init();
		}
		
		private function init():void
		{
			_closeLabel = new TextField();
			_closeLabel.text = LanguageManager.getWord("ssztl.pet.clickOpen");
			_closeLabel.x = 6;
			_closeLabel.y = 4;
			_closeLabel.width = 28;
			_closeLabel.height = 38;
			_closeLabel.mouseEnabled = _closeLabel.mouseWheelEnabled = false;
			_closeLabel.multiline = _closeLabel.wordWrap = true;
			_closeLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x6F7773,null,null,null,null,null,TextFormatAlign.RIGHT);
			_closeLabel.defaultTextFormat = t;
			_closeLabel.setTextFormat(t);
//			addChild(_closeLabel);
			_lockCellBg = new Bitmap(new luckedCellBgAsset() as BitmapData);
			addChild(_lockCellBg);
			
			_levelLabel = new TextField();
			_levelLabel.x = 10;
			_levelLabel.y = 21;
			_levelLabel.width = 28;
			_levelLabel.height = 18;
			_levelLabel.mouseEnabled = _levelLabel.mouseWheelEnabled = false;
			_levelLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			t = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,TextFormatAlign.RIGHT);
			_levelLabel.defaultTextFormat = t;
			_levelLabel.setTextFormat(t);
			
			buttonMode = true;
			_selectBg = new Bitmap(CellCaches.getCellSelectedBox() as BitmapData);
			addChild(_selectBg);
			_selectBg.visible = false;
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.visible = false;
			addChild(_over);
		}
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		
		public function set skillInfo(skillInfo:SkillItemInfo):void
		{
			if(_skillInfo == skillInfo) return;
			_skillInfo = skillInfo;
			if(_skillInfo)
			{
				super.info = _skillInfo.getTemplate();
				_levelLabel.text = 'Lv.' + _skillInfo.level;
				addChild(_levelLabel);
			}
			else
			{
				super.info = null;
				if(_levelLabel && _levelLabel.parent) 
				{
					_levelLabel.parent.removeChild(_levelLabel);
				}
			}
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_levelLabel);
			setChildIndex(_selectBg,numChildren - 1);
			setChildIndex(_over,numChildren - 1);
		}
		
		public function get skillInfo():SkillItemInfo
		{
			return _skillInfo;
		}
		
		public function set place(value:int):void
		{
			_place = value;
		}
		
		public function get place():int
		{
			return _place;
		}
		
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
			if(_isOpen)
			{
//				if(_closeLabel && _closeLabel.parent) removeChild(_closeLabel);
				if(_lockCellBg && _lockCellBg.parent) removeChild(_lockCellBg);
			}
			else
			{
				addChild(_lockCellBg);
			}
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_selected)
			{
//				filters = [new GlowFilter(0xffffff,1,4,4,4.5)];
				_selectBg.visible = true;
			}
			else
			{
				_selectBg.visible = false;
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_skillInfo && _skillInfo.templateId > 0)
			{
				var mountsSkillInfo:MountsSkillInfo = new MountsSkillInfo();
				mountsSkillInfo.templateId = _skillInfo.templateId;
				mountsSkillInfo.level = _skillInfo.level;
				TipsUtil.getInstance().show(mountsSkillInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
			else if(!_isOpen)
			{
				TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.mounts.qualityOverValue"),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function getLayerType():String
		{
			return LayerType.SKILL_ICON + '_' + _skillInfo.level;
		}
		
		override public function dispose():void
		{
			if(_lockCellBg)
			{
				_lockCellBg.bitmapData.dispose();
				_lockCellBg = null;
			}
			if(_over)
			{
				_over.bitmapData.dispose();
				_over = null;
			}
			if(_selectBg && _selectBg.bitmapData)
			{
				_selectBg.bitmapData.dispose();
				_selectBg = null;
			}
			_closeLabel = null;
			_skillInfo = null;
			super.dispose();
		}
	}
}