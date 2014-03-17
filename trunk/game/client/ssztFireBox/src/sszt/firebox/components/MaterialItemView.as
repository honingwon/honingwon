package sszt.firebox.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.firebox.data.FireBoxMaterialInfo;
	import sszt.firebox.events.FireBoxEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.furnace.SearchBtnAsset;
	
	public class MaterialItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _needCountLabel:MAssetLabel;
		private var _materialInfo:FireBoxMaterialInfo;
		private var _cell:FireBoxMaterialCell;
		private var _searchBtn:MBitmapButton;
		public function MaterialItemView()
		{
			super();
			initialView();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(-2,41,42,20))
			]);
			addChild(_bg as DisplayObject);
			_bg.visible = false;
			
			_cell = new FireBoxMaterialCell();
			_cell.move(0,0);
			addChild(_cell);
			
			_needCountLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_needCountLabel.move(19,43);
			addChild(_needCountLabel);
			
			_searchBtn = new MBitmapButton(new SearchBtnAsset());
			_searchBtn.move(41,43);
			_searchBtn.visible = false;
			addChild(_searchBtn);
			_searchBtn.addEventListener(MouseEvent.CLICK,clickSearchBtnHandler);
		}
		
		
		public function get materialInfo():FireBoxMaterialInfo
		{
			return _materialInfo;
		}
		
		public function set materialInfo(value:FireBoxMaterialInfo):void
		{
			_materialInfo = value;
			_cell.materialInfo = _materialInfo;
			if(_materialInfo && _materialInfo.needCount > 0)
			{
				updateItemCount();
//				_needCountLabel.text = _materialInfo.needCount.toString();
				_needCountLabel.text = _materialInfo.bagCount.toString() + "/" + _materialInfo.needCount.toString();
				_searchBtn.visible = true;
				_bg.visible = true;
				_materialInfo.addEventListener(FireBoxEvent.MATERIAL_CELL_UPDATE,cellUpdateHandler);
			}
			else
			{
				_needCountLabel.text = "";
			}
		}
		/**字体变色**/
		private function updateItemCount():void
		{
			if(_materialInfo.needCount > _materialInfo.bagCount)
			{
				_needCountLabel.textColor = 0xFF0000;
			}
			else
			{
				_needCountLabel.textColor = 0xFFFFFF;
			}
		}
		
		private function cellUpdateHandler(e:FireBoxEvent):void
		{
			if(_materialInfo && _materialInfo.needCount > 0)
			{
				updateItemCount();
				_needCountLabel.text = _materialInfo.bagCount.toString() + "/" + _materialInfo.needCount.toString();
				_searchBtn.visible = true;
				_bg.visible = true;
			}
			else
			{
				_needCountLabel.text = "";
				_searchBtn.visible = false;
				_bg.visible = false;
			}
		}
		private function clickSearchBtnHandler(e:MouseEvent):void
		{
			//打开拍卖行面板，并快速搜索
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			_searchBtn.removeEventListener(MouseEvent.CLICK,clickSearchBtnHandler);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_needCountLabel = null;
			_materialInfo = null;
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			_searchBtn = null;
			if(parent)parent.removeChild(this);
		}
	}
}