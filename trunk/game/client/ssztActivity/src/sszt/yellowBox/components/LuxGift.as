package sszt.yellowBox.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.label.MAssetLabel;
	
	/**
	 * 豪华礼包 
	 * @author chendong
	 * 
	 */	
	public class LuxGift extends Sprite implements IPanel,IYellowPanelView
	{
		private var _bgImg:Bitmap;
		/**
		 * 1.生命上限:500+200*黄钻等级
		 * 2.普通攻击:30+20*黄钻等级
		 * 3.普通防御:30+20*黄钻等级
		 */
		private var _descLabel:MAssetLabel;
		
		/**
		 * 类型,0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包
		 */		
		private var _type:int = 2;
		
		public function LuxGift(type:int=0)
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bgImg = new Bitmap();
			_bgImg.x = _bgImg.y = 2;
			addChild(_bgImg);
			
			_descLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_descLabel.textColor = 0x8aff00;
			_descLabel.setLabelType([new TextFormat("Tahoma",14,0x8aff00,null,null,null,null,null,null,null,null,null,6)]);
			_descLabel.move(170,135);
			addChild(_descLabel);
			
		}
		
		public function initEvent():void
		{
		}
		
		public function initData():void
		{
			_descLabel.setValue(LanguageManager.getWord("ssztl.yellowBox.luxGifDesc"));
		}
		
		public function clearData():void
		{
			
		}
		
		public function removeEvent():void
		{
			
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.yellowVip.BgAsset2",BitmapData) as BitmapData;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
			_bgImg = null;
			_descLabel = null;
		}
		
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		
		public function show():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}