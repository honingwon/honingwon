package sszt.pet.component.cells
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.tips.TipsUtil;
	import sszt.ui.label.MAssetLabel;
	
	public class PetEquipCell extends BaseItemInfoCell implements IDoubleClick
	{
		private var _clickHandler:Function;
		private var _doubleClickHandler:Function;
		
		private var _equipList:Array;
		private var _isOther:Boolean;
		
		private var _countLabel:MAssetLabel;
		
		public function PetEquipCell(clickHandler:Function,doubleClickHandler:Function)
		{
			_clickHandler = clickHandler;
			_doubleClickHandler = doubleClickHandler;
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.RIGHT);
			_countLabel.move(34,22);
		}
		
		public function click():void
		{
			if(_clickHandler != null)
			{
				_clickHandler(this);
			}
		}
		
		public function doubleClick():void
		{
			if(_doubleClickHandler != null)
			{
				_doubleClickHandler(this);
			}
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(_iteminfo)
			{
				if(_iteminfo.strengthenLevel > 0)
				{
					_countLabel.text = "+" + String(_iteminfo.strengthenLevel);
				}
				else
				{
					_countLabel.text = "";
				}
			}
			else
			{
				_countLabel.text = "";
			}
		}
		
		public function set equipList(value:Array):void
		{
			_equipList = value;
		}
		
		public function set isOther(value:Boolean):void
		{
			_isOther = value;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_iteminfo)
			{
				TipsUtil.getInstance().show(itemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,true,false,_isOther,_equipList);
			}
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
		}
		
		override public function getSourceType():int
		{
			return CellType.PET_EQUIP;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_countLabel = null;
		}
	}
}