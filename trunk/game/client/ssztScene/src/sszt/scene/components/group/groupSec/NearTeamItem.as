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
	import sszt.scene.components.group.groupSec.NearPlayerView;
	import sszt.scene.components.nearly.NearlyPanel;
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	
	public class NearTeamItem extends Sprite
	{
		private var _info:BaseTeamInfo;
		private var _nameField:MAssetLabel;
		private var _emptyPosField:MAssetLabel;
		private var _levelField:MAssetLabel;
		private var _selected:Boolean;
		private var _shape:Shape;
		private var _icon:Bitmap;
		private var _joinBtn:MCacheAssetBtn1;
		
		public function NearTeamItem(info:BaseTeamInfo)
		{
			_info = info;
			super();
			init();
		}
		
		public function get info():BaseTeamInfo
		{
			return _info;
		}
		
		private function init():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,30,266,2),new BackgroundType.LINE_1));
			buttonMode = true;
			//背景
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,266,32);
			graphics.endFill();
			//队长ICON
//			_icon = new Bitmap(AssetUtil.getAsset("mhsm.common.IconDemoAsset2",BitmapData) as BitmapData);
//			_icon.x = 10;
//			_icon.y = 5;
//			addChild(_icon);
			//队长名字
			_nameField = new MAssetLabel(_info.name,MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);			
			_nameField.move(5,7);
			addChild(_nameField);
			//等级
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);			
			_levelField.move(123,7);
			addChild(_levelField);
			_levelField.setHtmlValue(_info.level.toString());
			//队伍人数
			_emptyPosField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);			
			_emptyPosField.move(175,7);
			addChild(_emptyPosField);
			_emptyPosField.setHtmlValue(_info.emptyPos + "/5");
			//加入队伍的Button
			if(_info.isAutoIn)
			{
				_joinBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.scene.jion"));
			}
			else
			{
				_joinBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.apply"));
			}
			_joinBtn.move(218,5);
			addChild(_joinBtn);	
			_joinBtn.addEventListener(MouseEvent.CLICK, joinClickHandler);
		}
		private function joinClickHandler(e:MouseEvent):void
		{
			TeamInviteSocketHandler.sendInvite(0,_info.name);
		}
		
//		public function set selected(value:Boolean):void
//		{
//			_selected = value;
////			if(_selected)
////			{
////				//				_shape.visible = true;
////				NearlyPanel.SelectBorder.move(2,-4);
////				addChild(NearlyPanel.SelectBorder);
////			}else
////			{
////				//				_shape.visible = false;
////				if(NearlyPanel.SelectBorder.parent == this)
////				{
////					removeChild(NearlyPanel.SelectBorder);
////				}
////			}
//		}
		
//		public function get selected():Boolean
//		{
//			return _selected;
//		}
		
		public function dispose():void
		{
			if(_joinBtn)
			{
				_joinBtn.removeEventListener(MouseEvent.CLICK, joinClickHandler);
				_joinBtn.dispose();
				_joinBtn = null;
			}
			
			_info = null;
		}
	}
}