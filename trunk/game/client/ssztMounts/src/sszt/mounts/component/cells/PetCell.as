package sszt.mounts.component.cells
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.mounts.MountsItemInfo;
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
		protected var _petItemInfo:MountsItemInfo;
		private var _bg:IMovieWrapper;
		private var _selectBg:IMovieWrapper;
		
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
			
			_selectBg = BackgroundUtils.setBackground([	
				new BackgroundInfo(BackgroundType.BORDER_15,new Rectangle(0,0,38,38))
			]);
			addChild(_selectBg as DisplayObject);
			_selectBg.visible = false;
		}
		
		public function get mountsItemInfo():MountsItemInfo
		{
			return _petItemInfo;
		}
		
		public function set mountsItemInfo(value:MountsItemInfo):void
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
		
		public function set selected(value:Boolean):void
		{
			_selectBg.visible = value;
		}
		
		override protected function getLayerType():String
		{
			return LayerType.ICON;
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