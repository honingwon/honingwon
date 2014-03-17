package sszt.core.view.petSkill
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BtnAsset4;
	
	import mx.containers.HBox;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.ui.BarAsset3;
	
	public class SkillItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _info:Object;
		private var _selected:Boolean;
		private var _itemField:TextField;
		private var _selectedBorder:Sprite;
		private var _itemMTile:MTile;
		private var _skillName:MAssetLabel;
		private var _skillDes:MAssetLabel;
		
		public function SkillItemView(obj:Object)
		{
			_info = obj;
			init();
			initEvents();
			super();
		}
		
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14, new Rectangle(0,0,426,80)),
			]);
			addChild(_bg as DisplayObject);
			
			_skillName = new MAssetLabel(_info.name,MAssetLabel.LABEL_TYPE21B,TextFormatAlign.LEFT);
			_skillName.move(12,31);
			addChild(_skillName)
			_skillDes = new MAssetLabel(_info.des,MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_skillDes.wordWrap = true;
			_skillDes.setSize(100,_skillDes.textHeight+4);
			_skillDes.move(318,80-_skillDes.textHeight >> 1);
			addChild(_skillDes)
			
			_itemMTile = new MTile(50,50,5);
			_itemMTile.itemGapH =0;
			_itemMTile.itemGapW = 2;
			_itemMTile.setSize(258,50);
			_itemMTile.move(54,15);
			addChild(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollBar.lineScrollSize = 26;
			for (var i:int = 1;i <= 5 ;i++)
			{
				var skillCell:PetSkillBookCell = new PetSkillBookCell();
				var skillInfo:SkillItemInfo = new SkillItemInfo();
				skillInfo.templateId = _info.templateId;
				skillInfo.level = i;
				skillCell.skillBookInfo = skillInfo;
				_itemMTile.appendItem(skillCell);
			}
			
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.CLICK, onClickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.CLICK, onClickHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, onOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, onOutHandler);
		}
		
		private function onClickHandler(evt:MouseEvent):void
		{
		}
		private function onOverHandler(evt:MouseEvent):void
		{
//			if(!selected) _selectedBorder.visible = true;
		}
		private function onOutHandler(evt:MouseEvent):void
		{
//			if(!selected) _selectedBorder.visible = false;
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
				_itemField.textColor = 0xff9900;
				_selectedBorder.visible = true;
			}
			else
			{
				_itemField.textColor = 0xfff4d3;
				_selectedBorder.visible = false;
			}
		}

		public function get info():Object
		{
			return _info;
		}

		public function set info(value:Object):void
		{
			_info = value;
		}
		
		public function dispose():void
		{
			removeEvents();
			_info = null;
			if(_itemField && _itemField.parent)
			{
				_itemField.parent.removeChild(_itemField);
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_selectedBorder && _selectedBorder.parent)
			{
				_selectedBorder.parent.removeChild(_selectedBorder);
				_selectedBorder = null;
			}
			_itemField = null;
			if(parent)
				parent.removeChild(this);
		}
	}
}