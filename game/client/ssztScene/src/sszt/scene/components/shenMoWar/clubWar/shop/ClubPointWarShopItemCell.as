package sszt.scene.components.shenMoWar.clubWar.shop
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.shop.ShopItemInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class ClubPointWarShopItemCell extends BaseCell
	{
		private var _shopItemInfo:ShopItemInfo;
		private var _selected:Boolean;
		private var _selectedBg:Shape;
		
		public function ClubPointWarShopItemCell()
		{
			super();
			mouseChildren = mouseEnabled = false;
		}
		
		public function get shopItemInfo():ShopItemInfo
		{
			return _shopItemInfo;
		}
		public function set shopItemInfo(value:ShopItemInfo):void
		{
			if(_shopItemInfo == value)return;
			_shopItemInfo = value;
			if(_shopItemInfo)
			{
				info = _shopItemInfo.template;
				mouseChildren = mouseEnabled = true;
			}
			else
			{
				info = null;
				mouseChildren = mouseEnabled = false;
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
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
				_selectedBg = new Shape();
				_selectedBg.graphics.lineStyle(2,0xFFFFFF,1);
				_selectedBg.graphics.drawRoundRect(1,1,42,42,8,8);
				_selectedBg.graphics.endFill();
				addChildAt(_selectedBg,0);
			}
			else
			{
				if(_selectedBg && _selectedBg.parent)
				{
					_selectedBg.parent.removeChild(_selectedBg);
					_selectedBg = null;
				}
			}
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(4,4,36,36);
		}
		
		override public function dispose():void
		{
			_shopItemInfo = null;
			_selectedBg = null;
			super.dispose();
		}
	}
}