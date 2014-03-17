package sszt.petpvp.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.LayerType;
	import sszt.core.caches.CellAssetCaches;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.mcache.cells.CellCaches;

	public class PetSkillCell extends BaseCell
	{
		private var _bg:IMovieWrapper;
		
		private var _levelLabel:TextField;
		private var _skillInfo:PetSkillInfo;
		private var _over:Bitmap;
		private var _selectBg:Bitmap;
		
		public function PetSkillCell()
		{
			super();
			init();
		}
		
		private function init():void
		{	
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,38,38),new Bitmap(CellCaches.getCellBg())),
			]); 
			addChild(_bg as DisplayObject);	
			
			_levelLabel = new TextField();
			_levelLabel.x = 10;
			_levelLabel.y = 21;
			_levelLabel.width = 28;
			_levelLabel.height = 18;
			_levelLabel.mouseEnabled = _levelLabel.mouseWheelEnabled = false;
			_levelLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			var t:TextFormat  = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,TextFormatAlign.RIGHT);
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
		
		public function set skillInfo(skillInfo:PetSkillInfo):void
		{
			if(_skillInfo == skillInfo) return;
				_skillInfo = skillInfo;
			if(_skillInfo)
			{
				super.info = _skillInfo.getTemplate();
				_levelLabel.text = 'Lv.' + _skillInfo.level;
				addChild(_levelLabel);
			}else
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
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_skillInfo && _skillInfo.templateId > 0)
				TipsUtil.getInstance().show(_skillInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function getLayerType():String
		{
			return LayerType.SKILL_ICON + '_' + _skillInfo.level;
		}
		
		public function set skillTemplateID(value:int):void
		{
			var skillItem:PetSkillInfo;
			skillItem = new PetSkillInfo();
			skillItem.templateId = value / 100;
			skillItem.level = value % 10 + 1;
			skillInfo = skillItem;
		}
		
		public function get skillTemplate():PetSkillInfo
		{
			return _skillInfo as PetSkillInfo;
		}
	}
}