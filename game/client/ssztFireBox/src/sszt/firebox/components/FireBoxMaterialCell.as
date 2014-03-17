package sszt.firebox.components
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.firebox.data.FireBoxMaterialInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class FireBoxMaterialCell extends BaseCell
	{
		private var _materialInfo:FireBoxMaterialInfo;
		private var _countLabel:MAssetLabel;
		public function FireBoxMaterialCell()
		{
			super();
			_countLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_countLabel.move(28,20);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
			{
				TipsUtil.getInstance().show(
					ItemTemplateInfo(info),
					null,
					new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),
					false,0,false);
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		
		public function get materialInfo():FireBoxMaterialInfo
		{
			return _materialInfo;
		}
		
		public function set materialInfo(value:FireBoxMaterialInfo):void
		{
			_materialInfo = value;
			if(_materialInfo)
			{
				info = _materialInfo.tempalteInfo;
				if(_materialInfo.bagCount == 0)
				{
					_countLabel.text = "";
				}
				else
				{
					_countLabel.text = _materialInfo.bagCount.toString();
				}
			}
			else
			{
				info = null;
				_countLabel.text = "";
			}
		}
		
		public function updateCount():void
		{
			if(_materialInfo.bagCount == 0)
			{
				_countLabel.text = "";
			}
			else
			{
				_countLabel.text = _materialInfo.bagCount.toString();
			}
		}
		
		//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
		}
		
		override public function dispose():void
		{
			_materialInfo = null;
			_countLabel = null;
			super.dispose();
		}
	}
}