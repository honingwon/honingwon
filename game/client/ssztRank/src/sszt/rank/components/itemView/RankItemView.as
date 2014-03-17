package sszt.rank.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.ui.BarAsset3;
	
	public class RankItemView extends Sprite
	{
		protected var _select:Boolean;
		protected static var SELECTED_BITMAP:Sprite;
		{
			SELECTED_BITMAP = MBackgroundLabel.getDisplayObject(new Rectangle(0,1,475,26),new BarAsset3()) as Sprite;
			SELECTED_BITMAP.mouseEnabled = false;
			SELECTED_BITMAP.mouseChildren = false;
		}
		protected static var OVER_BITMAP:Sprite;
		{
			OVER_BITMAP = MBackgroundLabel.getDisplayObject(new Rectangle(0,1,475,26),new BarAsset3()) as Sprite;
			OVER_BITMAP.mouseEnabled = false;
			OVER_BITMAP.mouseChildren = false;
			OVER_BITMAP.alpha = 0.7;
		}		
		public function RankItemView()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			addChildAt(OVER_BITMAP,0);
		}
		private function outHandler(e:MouseEvent):void
		{
			if(OVER_BITMAP.parent)
				OVER_BITMAP.parent.removeChild(OVER_BITMAP);
		}
		public function set select(value:Boolean):void
		{
			_select = value;
			if(_select)
			{
				addChildAt(SELECTED_BITMAP,0);
			}
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
	}
}