package sszt.furnace.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	import ssztui.furnace.CellSelectedAsset;
	
	public class FurnaceBaseCell extends BaseCell
	{
		private var _select:Boolean;
		private var _selectBg:Bitmap;
		private var _isShowBind:Boolean;
		public function FurnaceBaseCell(argIsShowBind:Boolean = false)
		{
			super();
			_isShowBind = argIsShowBind;
//			_selectBg = new Sprite();
//			_selectBg.graphics.lineStyle(0,0xff3000,1);
//			_selectBg.graphics.drawRect(0,0,36,36);
			_selectBg = new Bitmap(new CellSelectedAsset() as BitmapData);
			_selectBg.x = _selectBg.y = -6;
			addChild(_selectBg);
			_selectBg.visible = false;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
			{
				TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,_isShowBind);
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
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
		
		override public function dispose():void
		{
			super.dispose();
			if(_selectBg && _selectBg.bitmapData)
			{
				_selectBg.bitmapData.dispose();
				_selectBg = null;
			}
			
		}
	}
}