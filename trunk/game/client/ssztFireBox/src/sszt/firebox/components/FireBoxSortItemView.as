package sszt.firebox.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.BarAsset1;
	
	import sszt.core.data.furnace.ForgeCorrespondInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.furnace.TreeHeadBgAsset;
	
	public class FireBoxSortItemView extends Sprite
	{
		private var _bg:Bitmap;
		private var _info:ForgeCorrespondInfo;
		public function FireBoxSortItemView(argInfo:ForgeCorrespondInfo)
		{
			super();
			_info = argInfo;
			initView();
		}
		
		private function initView():void
		{
			buttonMode = true;
//			_bg = BackgroundUtils.setBackground([
//																		new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(0,0,203,22))
//			]);
			_bg = new Bitmap(new TreeHeadBgAsset());
			addChild(_bg as DisplayObject);
			
			var nameLabel:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER);
			nameLabel.move(92,4);
			nameLabel.text = _info.sortName;
			addChild(nameLabel);
		}
		
		private function initEvent():void
		{
			
		}
		
		private function removeEvent():void
		{
			
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function get info():ForgeCorrespondInfo
		{
			return _info;
		}

		public function set info(value:ForgeCorrespondInfo):void
		{
			_info = value;
		}
		
		public function dispose():void
		{
			_info = null;
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}