package sszt.scene.components.nearly.nearlySec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.components.group.groupSec.NearPlayerView;
	import sszt.scene.components.nearly.NearlyPanel;
	import sszt.scene.data.team.BaseTeamInfo;
	
	public class NearTeamItem extends Sprite
	{
		private var _info:BaseTeamInfo;
		private var _nameField:MAssetLabel;
		private var _autoField:MAssetLabel;
		private var _selected:Boolean;
		private var _shape:Shape;
		private var _icon:Bitmap;
		
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
			buttonMode = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,280,22);
			graphics.endFill();
			
//			graphics.beginFill(0x00ff00,0.6);
//			graphics.drawRect(27,1,20,20);
//			graphics.endFill();
			_icon = new Bitmap(AssetUtil.getAsset("mhsm.common.IconDemoAsset2",BitmapData) as BitmapData);
			_icon.x = 27;
			_icon.y = 0;
			addChild(_icon);
			
//			_shape = new Shape();
//			_shape.graphics.lineStyle(1,0xffde00,2);
//			_shape.graphics.drawRect(2,0,275,22);
//			_shape.visible = false;
//			addChild(_shape);
			
			_nameField = new MAssetLabel(_info.name + "(" + _info.emptyPos + "/5)",MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
			addChild(_nameField);
			_nameField.move(49,0);
			
			if(_info.isAutoIn)
			{
				_autoField = new MAssetLabel(LanguageManager.getWord("ssztl.scene.autoInTeam2"),MAssetLabel.LABELTYPE4,TextFormatAlign.LEFT);
				
				_autoField.move(200,0);
				addChild(_autoField);
			}
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
//				_shape.visible = true;
				NearlyPanel.SelectBorder.move(2,-4);
				addChild(NearlyPanel.SelectBorder);
			}else
			{
//				_shape.visible = false;
				if(NearlyPanel.SelectBorder.parent == this)
				{
					removeChild(NearlyPanel.SelectBorder);
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function dispose():void
		{
			_info = null;
		}
	}
}