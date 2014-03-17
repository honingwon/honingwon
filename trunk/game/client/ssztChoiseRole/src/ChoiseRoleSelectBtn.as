package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ChoiseRoleSelectBtn extends Sprite
	{
		private var _selected:Boolean;
		private var _selectBg:Bitmap;
		private var _icon:Bitmap;
		private var _name:TextField;
		private var _serverLabel:TextField;
		private var _sex:int;
		private var _career:int;
		private var _nick:String;
		private var _serverIndex:int;
		private var _id:Number;
			
		public function ChoiseRoleSelectBtn(career:int,sex:int,nick:String,serverIndex:int,id:Number)
		{
			_career = career;
			_sex = sex;
			_nick = nick;
			_serverIndex = serverIndex;
			_id = id;
			super();
			init();
		}
		
		private function init():void
		{
			buttonMode = true;
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,326,50);
			graphics.endFill();
			
			_selectBg = new Bitmap(new SelectedBg());
			addChild(_selectBg);
			_selectBg.visible = false;
			
			_icon = new Bitmap();
			_icon.bitmapData = RoleChoseView.headAsset[index];
			_icon.x = 50;
			_icon.y = 9;
			addChild(_icon);
			
			var format:TextFormat = new TextFormat("宋体",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER);
			_serverLabel = new TextField();
			_serverLabel.x = 110;
			_serverLabel.y = 16;
			_serverLabel.mouseEnabled = _serverLabel.mouseWheelEnabled = false;
			_serverLabel.width = 50;
			_serverLabel.height = 20;
			_serverLabel.defaultTextFormat = format;
			_serverLabel.setTextFormat(format);
			addChild(_serverLabel);
			_serverLabel.text = _serverIndex + "服";
			
			format = new TextFormat("宋体",12,0x00ffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_name = new TextField();
			_name.x = 180;
			_name.y = 16;
			_name.mouseEnabled = _name.mouseWheelEnabled = false;
			_name.width = 80;
			_name.height = 20;
			_name.defaultTextFormat = format;
			_name.setTextFormat(format);
			addChild(_name);
			_name.text = _nick;
		}
		
		private function getCareerName():String
		{
			switch(_career)
			{
				case 1:return "尚武门";
				case 2:return "逍遥阁";
				case 3:return "流星盟";
			}
			return "";
		}
		
		private function get index():int
		{
			switch(_career)
			{
				case 1:return _sex?1:0;
				case 2:return _sex?3:2;
				case 3:return _sex?5:4;
			}
			return 0;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected) _selectBg.visible = true;
			else _selectBg.visible = false;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get sex():int
		{
			return _sex;
		}
		
		public function get career():int
		{
			return _career;
		}
		
		public function get nick():String
		{
			return _nick;
		}
		
		public function get id():Number
		{
			return _id;
		}
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
		}
	}
}