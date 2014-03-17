package sszt.firebox.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.furnace.FormulaInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
//	import ssztui.furnace.ItemSelectBgAsset;
	
	public class TargetItemView extends Sprite
	{
		private var _nameLabel:MAssetLabel;
		private var _cell:FireBoxBaseCell;
//		private var _selectBg:Shape;
		private var _select:Boolean;
		private var _info:FormulaInfo;
		private var _selectBg:IMovieWrapper;
		
		/**
		 * 可合成数 
		 */		
		private var _numLabel:MAssetLabel;
		
		private var _num:int;
		
		public function TargetItemView(argInfo:FormulaInfo)
		{
			super();
			buttonMode = true;
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,183,42);
			graphics.endFill();
			_info = argInfo;
			initialView();
		}
		
		public function get num():int
		{
			return _num;
		}

		/**
		 *  可合成数  
		 * @param value
		 * 
		 */		
		public function set num(value:int):void
		{
			_num = value;
			_numLabel.setValue("("+_num.toString()+")");
		}

		private function initialView():void
		{
			
//			_selectBg = new Shape();
//			_selectBg.graphics.beginFill(0x7AC900,0.5);
//			_selectBg.graphics.drawRect(0,0,255,50);
//			_selectBg.graphics.endFill();
//			addChild(_selectBg);
//			_selectBg.visible = false;
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,42,183,2),new MCacheSplit2Line()));
			_selectBg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_15,new Rectangle(0,0,166,42)),
			]);
			_selectBg.visible = false;
			
			var _bgCell:Bitmap = new Bitmap(CellCaches.getCellBg());
			_bgCell.x = 4;
			_bgCell.y = 2;
			addChild(_bgCell);
			
			_cell = new FireBoxBaseCell();
			_cell.info = _info.getTempalteInfo();
			_cell.x = 4;
			_cell.y = 2;
			addChild(_cell);
			
			_nameLabel = new MAssetLabel(_info.outputName,MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			var _color:int = CategoryType.getQualityColor(_info.getTempalteInfo().quality);
			_nameLabel.textColor = _color;
			_nameLabel.move(50,14);
			addChild(_nameLabel);
			
			
			_numLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_numLabel.move(_nameLabel.width+_cell.width+10,14);
			addChild(_numLabel);
			
			addChild(_selectBg as DisplayObject);
		}
		
		
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(value:Boolean):void
		{
			_select = value;
			if(_select)
			{
				_selectBg.visible = true;
			}
			else
			{
				_selectBg.visible = false;
			}
		}
		
		public function get info():FormulaInfo
		{
			return _info;
		}
		
		public function set info(value:FormulaInfo):void
		{
			_info = value;
		}
		
		public function dispose():void
		{
			_nameLabel = null;
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
//			_selectBg = null;
			if(_selectBg)
			{
				_selectBg.dispose();
				_selectBg = null;
			}
			_info = null;
			_numLabel = null;
			if(parent)parent.removeChild(this);
		}
	}
}