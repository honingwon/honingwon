package sszt.scene.components.guide
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.richTextField.RichTextField;
	
	public class GuideItemView extends Sprite
	{
//		private var _title:MAssetLabel;
		private var _select:Boolean;
		private var _icon:Bitmap;
		private var _seletedBg:Bitmap;
		private var _title:RichTextField;
		
		public function GuideItemView(text:String,format:Array)
		{
			super();
			initView(text,format);
		}
		
		private function initView(text:String,format:Array):void
		{
			buttonMode = true;
//			_seletedBg = new Bitmap(new ItemBgAsset());
			_seletedBg = new Bitmap(AssetUtil.getAsset("mhsm.scene.ItemBgAsset") as BitmapData);
			_seletedBg.x = 0;
			_seletedBg.y = 0;
			_seletedBg.visible = false;
			addChild(_seletedBg);
			
//			_icon = new Bitmap(new ItemIconAsset());
			_icon = new Bitmap(AssetUtil.getAsset("mhsm.scene.ItemIconAsset") as BitmapData);
			_icon.x = 0;
			_icon.y = 4;
			addChild(_icon);
			
//			_title = new MAssetLabel(text,MAssetLabel.LABELTYPE3);
//			_title.setSize(196,18);
//			_title.move(17,3);
//			addChild(_title);
			
			_title = new RichTextField(196);
			_title.appendMessage(text,[],format);
			_title.x = 17;
			_title.y = 3;
			addChild(_title);
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(value:Boolean):void
		{
			_select = value;
			if(_select)
			{
				_seletedBg.visible = true;
			}
			else
			{
				_seletedBg.visible = false;
			}
		}
		
		public function dispose():void
		{
//			if(_title && _title.parent)
//			{
//				_title.parent.removeChild(_title);
//			}
//			_title = null;
			if(_title)
			{
				_title.dispose();
				_title = null;
			}
			if(_icon && _icon.parent)
			{
				_icon.parent.removeChild(_icon);
			}
			_icon = null;
			if(_seletedBg && _seletedBg.parent)
			{
				_seletedBg.parent.removeChild(_seletedBg);
			}
			_seletedBg = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}