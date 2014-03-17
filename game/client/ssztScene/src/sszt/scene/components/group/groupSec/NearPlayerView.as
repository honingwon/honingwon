package sszt.scene.components.group.groupSec
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class NearPlayerView extends Sprite
	{
		private var _info:BaseScenePlayerInfo;
		private var _nick:TextField;
		private var _job:TextField;
		private var _level:TextField;
		
		public function NearPlayerView(info:BaseScenePlayerInfo)
		{
			_info = info;
			super();
			initView();			
		}
		
		public function get info():BaseScenePlayerInfo
		{
			return _info;
		}
		
		private function initView():void
		{
			buttonMode = true;
			tabEnabled = false;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,230,18);
			graphics.endFill();
			
			_nick = new TextField();
			_nick.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_nick.width = 86;
			_nick.mouseEnabled = _nick.mouseWheelEnabled = false;
			_nick.text = "[" + info.info.serverId + "]" + info.getName();
			addChild(_nick);
			
			_job = new TextField();
			_job.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_job.width = 70;
			_job.x = 93;
			_job.mouseEnabled = _job.mouseWheelEnabled = false;
			_job.text = CareerType.getNameByCareer(info.getCareer());
			addChild(_job);
			
			
			_level = new TextField();
			_level.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_level.width = 30;
			_level.x = 190;
			_level.mouseEnabled = _level.mouseWheelEnabled = false;
			_level.text = String(info.getLevel());
			addChild(_level);
		}
		
		public function dispose():void
		{
			_info = null;
			if(parent) parent.removeChild(this);
		}
	}
}