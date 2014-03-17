package sszt.rank.components.views
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.ui.label.MAssetLabel;
	
	public class EquipItemCell extends BaseItemInfoCell
	{
		private var _levelLabel:MAssetLabel;
		private var _equipList:Array;
		private var _isOther:Boolean;
		
		public function EquipItemCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
			_levelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_levelLabel.move(24,22);
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(_iteminfo)
			{
				if(_iteminfo.strengthenLevel > 0)
				{
					_levelLabel.text = "+" + String(_iteminfo.strengthenLevel);
				}
				else
				{
					_levelLabel.text = "";
				}
			}
			else
			{
				_levelLabel.text = "";
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
		
		override public function getSourceType():int
		{
			return CellType.ROLECELL;
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_levelLabel);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_levelLabel = null;
		}
	}
}