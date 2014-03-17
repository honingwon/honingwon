/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-26 下午3:40:08 
 * 
 */ 
package sszt.scene.components.elementInfoView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar1;
	
	public class PlayerElementInfoView extends BaseElementInfoView
	{
		
		
		public function PlayerElementInfoView(mediator:ElementInfoMediator)
		{
			super(mediator);
		}
		
		override protected function initBg():void
		{
			super.initBg();
			
			_bg.bitmapData = getBgAsset2();

			_mask = new Sprite();
			addChild(_mask);
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawCircle(0,0,30);
			_mask.graphics.endFill();
			_mask.x = 38;
			_mask.y = 54;
			_mask.buttonMode = true;
			_mask.tabEnabled = false;
			_mask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);

			initBitmapdatas();
		}
		/*
		protected function initBitmapdatas():void
		{
			if(headAssets1.length == 0)
			{
				headAssets1.push(AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset1") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset2") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset3") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset4") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset5") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset6") as BitmapData);
			}
		}
		*/
		
		private function headOverHandler(e:MouseEvent):void
		{
			if(_headAsset)
				setBrightness(_headAsset,0.15);
		}
		private function headOutHandler(e:MouseEvent):void
		{
			if(_headAsset)
				setBrightness(_headAsset,0);
		}
		
		override protected function initHead(change:Boolean = true):void
		{
			if(_headAsset && _headAsset.parent) _headAsset.parent.removeChild(_headAsset);
			_headAsset = new Bitmap(headAssets[CareerType.getHeadByCareerSex(_info.getCareer(),_info.getSex())],"auto",true);
			_headAsset.x = 6;
			_headAsset.y = 7;
			_headAsset.width = 65;
			_headAsset.height = 75;
			addChild(_headAsset);
		}
		
		override protected function initNameField():void
		{
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.CENTER);
			_nameField.textColor = 0xfffccc;
			_nameField.selectable = false;
			_nameField.mouseEnabled = false;
			addChild(_nameField);
		}
		
		override protected function initLevelField():void
		{
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_levelField.setLabelType([new TextFormat("Tahoma",11,0xFFFCCC)]);
			_levelField.selectable = false;
			_levelField.mouseEnabled = false;
			addChild(_levelField);
		}
		
		override protected function initProgressBar():void
		{
			_hpBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getHpBgAsset2()),1,1,122,13,true,false);
			addChild(_hpBar);
		}
		
		override protected function layout():void
		{
			_bg.y = 15;
			
			_hpBar.move(68,47);
			_levelField.move(74,28);			
			_nameField.move(130,27);
			_closeBtn.move(188,26);
		}
		
		
		override protected function initBuff():void
		{
			super.initBuff();
			_buffTile.move(70,65);
		}
		
		
		override public function elementType():int
		{
			return MapElementType.PLAYER;
		}
		
		
	}
}