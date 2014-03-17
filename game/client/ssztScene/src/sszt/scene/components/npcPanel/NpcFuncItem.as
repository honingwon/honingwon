package sszt.scene.components.npcPanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.PopUpDeployType;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.ui.NpcPanelItemOverAsset;
	
	public class NpcFuncItem extends Sprite implements INPCItem
	{
		private var _info:DeployItemInfo;
		private var _label:MAssetLabel;
		private var _flagIcon:Bitmap;
		private var _hitBg:Shape;
		public var copyEnterEnabled:Boolean;	//副本进入次数为0
		private var _bgOver:Bitmap;
		
		public function NpcFuncItem(info:DeployItemInfo)
		{
			_info = info;
			super();
			init();
			copyEnterEnabled = true;
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
			_label = new MAssetLabel(_info.descript,MAssetLabel.LABEL_TYPE20,"left");
			_label.textColor = 0xff9900;
			_label.mouseEnabled = false;
			showCopyEnterNum();
			addChild(_label);
			
//			if(_info.param1 == PopUpDeployType.NPC_COPY_ENTER)
//			{
				_flagIcon = new Bitmap();	
				_flagIcon.x = 5;
				_flagIcon.y = 2;
				addChild(_flagIcon);
				_label.x = 25;
				_label.y = 3;
				var t:BitmapData = AssetUtil.getAsset("ssztui.scene.NTalkIconFunAsset") as BitmapData;
				if(t) _flagIcon.bitmapData = t;
				else ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE,playerIconAssetComplete);
//			}
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
		private function showCopyEnterNum():void
		{
			if(_info.param1 == 101)
			{
				var copyItem:CopyTemplateItem = CopyTemplateList.getCopyByNpc(_info.param2);
				if(copyItem && copyItem.dayTimes < 99)
				{
					var num:int = GlobalData.copyEnterCountList.getItemCount(copyItem.id);
					_label.setValue(_info.descript + "("+ num +"/"+ copyItem.dayTimes +")");
					if(num >= copyItem.dayTimes)
					{
						_label.textColor = 0x999999;
						copyEnterEnabled = false;
					}
				}
			}
		}
		
		private function playerIconAssetComplete(evt:CommonModuleEvent):void
		{
			_flagIcon.bitmapData = AssetUtil.getAsset("ssztui.scene.NTalkIconFunAsset") as BitmapData;
		}
		
		public function get info():DeployItemInfo
		{
			return _info;
		}
		
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			_info = null;
			_flagIcon = null;
			if(_hitBg)
			{
				_hitBg.graphics.clear();
				_hitBg = null;
			}
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE,playerIconAssetComplete);
			if(parent)parent.removeChild(this);
		}
	}
}