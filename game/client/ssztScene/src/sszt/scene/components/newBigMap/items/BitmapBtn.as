package sszt.scene.components.newBigMap.items
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.utils.AssetUtil;
	
	public class BitmapBtn extends Sprite
	{
		private var _info:MapTemplateInfo;
		private var _asset:Bitmap;
		private var _id:int;
		
		public function BitmapBtn(classPath:String, mapId:int)
		{
			this._id = mapId;
			this._asset = new Bitmap( AssetUtil.getAsset(classPath) as BitmapData);
			addChild(this._asset);
			this._info = MapTemplateList.getMapTemplate(mapId);
			if(this._id == 0)
			{
				filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
				mouseEnabled = buttonMode = false;
			}
			this.initEvent();
		}
		
		public function get mapId() : int
		{
			return this._id;
		}
		
		private function initEvent() : void
		{
			addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		}
		
		private function removeEvent() : void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
		}
		
		private function mouseOverHandler(event:MouseEvent) : void
		{
			if (this._asset && this._id != 0)
			{
				_asset.filters = [new GlowFilter(16776960, 1, 11, 11, 2.5)];
			}
		}
		
		private function mouseOutHandler(event:MouseEvent) : void
		{
			if (this._asset && this._id != 0)
			{
				_asset.filters = [];
			}
		}
		
		public function get info() : MapTemplateInfo
		{
			return this._info;
		}
		
		public function move(x:Number, y:Number) : void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose() : void
		{
			this.removeEvent();
			this._info = null;
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
	}
}
