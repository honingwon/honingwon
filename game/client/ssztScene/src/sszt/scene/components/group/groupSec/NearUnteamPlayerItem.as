package sszt.scene.components.group.groupSec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.components.nearly.NearlyPanel;
	import sszt.scene.data.team.UnteamPlayerInfo;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class NearUnteamPlayerItem extends Sprite
	{
		private var _info:UnteamPlayerInfo;
		private var _nameField:MAssetLabel;
		private var _carrerField:MAssetLabel;
		private var _levelField:MAssetLabel;
		private var _powerField:MAssetLabel;
		private var _shape:Shape;
//		private var _selected:Boolean;
		private var _icon:Bitmap;
		private var _inviteBtn:MCacheAssetBtn1;
		
		public function NearUnteamPlayerItem(info:UnteamPlayerInfo)
		{
			_info = info;
			super();
			init();
		}
		
		public function get info():UnteamPlayerInfo
		{
			return _info;
		}
		
		private function init():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,30,266,2),new BackgroundType.LINE_1));
			buttonMode = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,266,30);
			graphics.endFill();
			
//			_icon = new Bitmap(/*AssetUtil.getAsset("mhsm.common.IconDemoAsset2",BitmapData) as BitmapData*/);
//			_icon.x = 8;
//			_icon.y = 5;
//			addChild(_icon);
			
			_nameField = new MAssetLabel(_info.name,MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			addChild(_nameField);
			_nameField.move(5,7);
			
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			addChild(_levelField);
			_levelField.move(164,7);
			_levelField.setValue(_info.level.toString());
			
			_carrerField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
//			addChild(_carrerField);
			_carrerField.move(175,8);
			_carrerField.setValue("??");
			
//			_powerField = new MAssetLabel("0",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
//			addChild(_powerField);
//			_powerField.move(222,8);
			
			_inviteBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.scene.invite"));		
			_inviteBtn.move(218,5);
			addChild(_inviteBtn);			
			_inviteBtn.addEventListener(MouseEvent.CLICK, invitClickHandler);
			
		}
		
		private function invitClickHandler(e:MouseEvent):void
		{
			TeamInviteSocketHandler.sendInvite(0,_info.name);
		}
		
//		public function set selected(value:Boolean):void
//		{
//			_selected = value;
//			if(_selected)
//			{
//				//				_shape.visible = true;
//				NearlyPanel.SelectBorder.move(2,-4);
//				addChild(NearlyPanel.SelectBorder);
//			}else
//			{
//				//				_shape.visible = false;
//				if(NearlyPanel.SelectBorder.parent == this)
//				{
//					removeChild(NearlyPanel.SelectBorder);
//				}
//			}
//		}
//		
//		public function get selected():Boolean
//		{
//			return _selected;
//		}
		
		public function dispose():void
		{
			if(_inviteBtn)
			{				
				_inviteBtn.removeEventListener(MouseEvent.CLICK, invitClickHandler);
				_inviteBtn.dispose();
				_inviteBtn = null;
			}
			_info = null;
		}
	}
}