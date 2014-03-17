package sszt.firebox.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class FireBoxBaseCell extends BaseCell
	{
		private var _select:Boolean;
		private var _selectBg:Sprite;
		private var _isShowBind:Boolean;
		public function FireBoxBaseCell(argIsShowBind:Boolean = false)
		{
			super();
			_isShowBind = argIsShowBind;
			_selectBg = new Sprite();
			_selectBg.graphics.lineStyle(0,0xff3000,1);
			_selectBg.graphics.drawRect(0,0,36,36);
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
			_selectBg = null;
		}
	}
}