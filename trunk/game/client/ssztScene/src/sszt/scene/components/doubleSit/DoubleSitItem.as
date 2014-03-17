package sszt.scene.components.doubleSit
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.ui.label.MAssetLabel;
	
	public class DoubleSitItem extends Sprite
	{
		private var _hit:Shape;
		private var _info:BaseScenePlayerInfo;
		private var _nameField:MAssetLabel;
		private var _careerField:MAssetLabel;
		private var _levelField:MAssetLabel;
		private var _selected:Boolean;
		
		public function DoubleSitItem(info:BaseScenePlayerInfo)
		{
			_info = info;
			super();
			init();
		}
		
		private function init():void
		{
			_hit = new Shape();
			_hit.graphics.beginFill(0x000000,0);
			_hit.graphics.drawRect(0,0,238,24);
			_hit.graphics.endFill();
			addChild(_hit);
			
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_nameField.move(4,4);
			addChild(_nameField);
			_careerField = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.CENTER);
			_careerField.move(157,4);
			addChild(_careerField);
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.CENTER);
			_levelField.move(208,4);
			addChild(_levelField);
			
			_nameField.setValue("[" + _info.info.serverId + "]" + _info.info.nick);
			_careerField.setValue(CareerType.getNameByCareer(_info.info.career));
			_levelField.setValue(String(_info.info.level));
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_selected)
			{
				DoubleSitPanel.SELECTEDBORDER.move(0,0);
				addChildAt(DoubleSitPanel.SELECTEDBORDER,0);
			}
			else
			{
				if(DoubleSitPanel.SELECTEDBORDER.parent == this)
				{
					DoubleSitPanel.SELECTEDBORDER.parent.removeChild(DoubleSitPanel.SELECTEDBORDER);
				}
			}
		}
		
		public function get info():BaseScenePlayerInfo
		{
			return _info;
		}
		
		public function dispose():void
		{
			_info = null;
			if(parent)parent.removeChild(this);
		}
	}
}