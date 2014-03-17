package sszt.core.view.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class BaseBuffCell extends BaseCell
	{
		private static var _buffBorder:BitmapData;
		
		private static function getBuffBorder():BitmapData
		{
			if(!_buffBorder)
			{
				_buffBorder = AssetUtil.getAsset("ssztui.scene.BuffBorderImgAsset") as BitmapData;
			}
			return _buffBorder;
		}
		
		private var _buffItemInfo:BuffItemInfo;
		
		public function BaseBuffCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
			var border:Bitmap = new Bitmap(getBuffBorder());
			this.addChild(border);
		}
		public function get buffItemInfo():BuffItemInfo
		{
			return _buffItemInfo;
		}
		public function set buffItemInfo(value:BuffItemInfo):void
		{
			if(_buffItemInfo == value)return;
			_buffItemInfo = value;
			if(_buffItemInfo)
			{
				info = _buffItemInfo.getTemplate();
			}
			else
			{
				info = null;
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			var p:Point = this.localToGlobal(new Point(_figureBound.x,_figureBound.y));
			if(_buffItemInfo)TipsUtil.getInstance().show(_buffItemInfo,null,new Rectangle(p.x,p.y,_figureBound.width,_figureBound.height));
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(2,2,18,18);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_buffItemInfo)TipsUtil.getInstance().hide();
		}
		
//		override protected function createPicComplete(data:BitmapData):void
//		{
//			
//		}
		
		override protected function getLayerType():String
		{
			return LayerType.BUFF_ICON;
		}
	}
}