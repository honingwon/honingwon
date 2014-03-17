package sszt.scene.components.npcPanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.PopUpDeployType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.ui.NpcPanelItemOverAsset;
	
	public class NpcReturnItem extends Sprite implements INPCItem
	{
		private var _label:MAssetLabel;
		private var _flagIcon:Bitmap;
		private var _hitBg:Shape;
		private var _bgOver:Bitmap;
		
		public function NpcReturnItem()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_bgOver = new Bitmap(new NpcPanelItemOverAsset());
			addChild(_bgOver);	
			_bgOver.visible = false;
			
			_hitBg = new Shape();
			_hitBg.graphics.beginFill(0xffffff,0);
			_hitBg.graphics.drawRect(0,0,275,22);
			_hitBg.graphics.endFill();
			addChild(_hitBg);
			
			buttonMode = true;
			_label = new MAssetLabel(LanguageManager.getWord("ssztl.common.return"),MAssetLabel.LABEL_TYPE20,"left");
			_label.textColor = 0xff9900;
			_label.mouseEnabled = false;
			_label.x = 25;
			_label.y = 3;
			addChild(_label);
			
			_flagIcon = new Bitmap(AssetUtil.getAsset("ssztui.scene.NTalkIconReturnAsset") as BitmapData);	
			_flagIcon.x = 5;
			_flagIcon.y = 2;
			addChild(_flagIcon);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			_bgOver.visible = true;
			
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			_bgOver.visible = false;
		}
		private function playerIconAssetComplete(evt:CommonModuleEvent):void
		{
			_flagIcon.bitmapData = AssetUtil.getAsset("ssztui.scene.NTalkIconReturnAsset") as BitmapData;
		}
		
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			_flagIcon = null;
			if(_hitBg)
			{
				_hitBg.graphics.clear();
				_hitBg = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}