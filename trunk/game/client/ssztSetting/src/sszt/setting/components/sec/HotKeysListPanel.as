package sszt.setting.components.sec
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.setting.mediators.SettingMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	
	import ssztui.setting.KeyAsset;
	
	public class HotKeysListPanel extends Sprite implements ISettingPanel
	{
		private var _mediator:SettingMediator;
		private var _bg:IMovieWrapper;
		private var _textfield:TextField;
		
		public function HotKeysListPanel(mediator:SettingMediator)
		{
			_mediator = mediator;
			super();
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,288,326)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,3,282,320),new Bitmap(new KeyAsset())),
			]);
			addChild(_bg as DisplayObject);
			
//			var ss:String = 
//				"角色属性\t\t<font color='#FDCD4D'>C</font>\t\t\t好友\t\t<font color='#FDCD4D'>R</font>\t\t\t\t隐藏玩家\t\t<font color='#FDCD4D'>P</font>\n" +
//				"背包\t\t\t<font color='#FDCD4D'>B</font>\t\t\t帮会\t\t<font color='#FDCD4D'>O</font>\t\t\t\t跟随玩家\t\t<font color='#FDCD4D'>G</font>\n" +
//				"任务\t\t\t<font color='#FDCD4D'>Q</font>\t\t\t邮件\t\t<font color='#FDCD4D'>L</font>\t\t\t\t附近玩家\t\t<font color='#FDCD4D'>F</font>\n" +
//				"商店\t\t\t<font color='#FDCD4D'>S</font>\t\t\t神炉\t\t<font color='#FDCD4D'>E</font>\t\t\t\t私聊\t\t\t<font color='#FDCD4D'>/+人名</font>\n" +
//				"技能\t\t\t<font color='#FDCD4D'>V</font>\t\t\t自定义\t\t<font color='#FDCD4D'>1~0</font>\t\t\t\t聊天输入\t\t<font color='#FDCD4D'>Enter</font>\n" +
//				"观察\t\t\t<font color='#FDCD4D'>J</font>\t\t\t拾取物品\t<font color='#FDCD4D'>空格键</font>\t\t\t聊天历史\t\t<font color='#FDCD4D'>↑↓</font>\n" +
//				"地图\t\t\t<font color='#FDCD4D'>M</font>\t\t\t自动打怪\t<font color='#FDCD4D'>Z</font>\t\t\t\t选择攻击目标\t<font color='#FDCD4D'>~</font>\n" +
//				"摆摊\t\t\t<font color='#FDCD4D'>K</font>\t\t\t系统设置\t<font color='#FDCD4D'>Esc</font>\t\t\t\t攻击选择目标\t<font color='#FDCD4D'>A</font>\n" +
//				"打坐\t\t\t<font color='#FDCD4D'>D</font>\t\t\t关闭界面\t<font color='#FDCD4D'>Esc</font>\t\t\t\t坐骑\t<font color='#FDCD4D'>T</font>";
			
			_textfield = new TextField();
			var percent:Number = 1;
			var str:String = LanguageManager.getWord("ssztl.common.wordSize");
			if(str && str != "")
			{
				percent = parseFloat(str);
			}
//			_textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,16);
			_textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,
				9);
			_textfield.width = 245;
			_textfield.height = 260;
			_textfield.x = 15;
			_textfield.y = 10;
			_textfield.mouseEnabled = false;
			_textfield.htmlText = LanguageManager.getWord("ssztl.setting.settingDetail");
//			_textfield.htmlText = ss;
//			addChild(_textfield);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_textfield = null;
			_mediator = null;
		}
	}
}