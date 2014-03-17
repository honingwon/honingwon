package sszt.scene.components.copyGroup.sec
{
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	
	public class GroupTitleView extends Sprite
	{
		private var _title:MAssetLabel;
		
		public function GroupTitleView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,161,25);
			graphics.endFill();
			
			_title = new MAssetLabel(LanguageManager.getWord("ssztl.scene.noTeamPlayer"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT);
			_title.move(0,5);
			addChild(_title);
			mouseChildren = mouseEnabled = false;
		}
		
		override public function get height():Number
		{
			return 25;	
		}
		
		public function dispose():void
		{
			_title = null;
			if(parent) parent.removeChild(this);
		}
	}
}