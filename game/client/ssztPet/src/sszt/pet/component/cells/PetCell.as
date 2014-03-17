package sszt.pet.component.cells
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class PetCell extends BaseCell
	{
		protected var _petItemInfo:PetItemInfo;
		private var _bg:IMovieWrapper;
		private var _selectBg:Bitmap;
		
		public function PetCell()
		{
			super();
			createBg();
		}
		
		protected function createBg():void
		{
			_bg = BackgroundUtils.setBackground([	
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,38,38),new Bitmap(CellCaches.getCellBg()))
			]);
			addChild(_bg as DisplayObject);
			_bg.visible = false;
			
			_selectBg = new Bitmap(CellCaches.getCellSelectedBox() as BitmapData);
			addChild(_selectBg);
			_selectBg.visible = false;
		}
		
		public function get petItemInfo():PetItemInfo
		{
			return _petItemInfo;
		}
		
		public function set petItemInfo(value:PetItemInfo):void
		{
			if(_petItemInfo == value)return;
			_petItemInfo = value;
			if(_petItemInfo)
			{
				info = _petItemInfo.template;
				if(_bg)
				{
					_bg.visible = true;
				}
			}
			else
			{
				info = null;
				if(_bg)
				{
					_bg.visible = false;
				}
			}
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
//			setChildIndex(_selectBg,numChildren-1);
		}
		public function set selected(value:Boolean):void
		{
			_selectBg.visible = value;
		}
		
		override protected function getLayerType():String
		{
			return LayerType.PET_AVATAR;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_petItemInfo)
			{
				TipsUtil.getInstance().show(_petItemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_petItemInfo)
			{
				TipsUtil.getInstance().hide();
			}
		}
		
		override public function dispose():void
		{
			hideTipHandler(null);
			_petItemInfo = null;
			super.dispose();
		}
	}
}