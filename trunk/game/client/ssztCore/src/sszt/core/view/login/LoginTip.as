package sszt.core.view.login
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.button.MBitmapButton;
	
	import sszt.constData.CareerType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.utils.AssetUtil;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.StatUtils;
	
	public class LoginTip extends Sprite
	{
		private var _bg:Bitmap;
		private var _okBtn:MBitmapButton;
		private var _content:TextField;
		private var _tipField:TextField;
		
		private static var instance:LoginTip;
		public static function getInstance():LoginTip
		{
			if(instance == null)
			{
				instance = new LoginTip();
			}
			return instance;
		}
		
		public function LoginTip()
		{
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			StatUtils.doStat(5);
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0,0);
			sp.graphics.drawRect(-1000,-1000,5000,5000);
			sp.graphics.endFill();
			addChild(sp);
			
			if(GlobalData.domain.hasDefinition("sszt.common.LoginAsset"))
			{
				_bg = new Bitmap(new (GlobalData.domain.getDefinition("sszt.common.LoginAsset") as Class)());
			}
			if(_bg)
			{
				addChild(_bg);
			}			
			
			_content = new TextField();
			_content.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,4);
			_content.filters = [new GlowFilter(0,1,4,4,4.5)];
			_content.mouseEnabled = _content.mouseWheelEnabled = false;
			_content.x = 270;
			_content.y = 100;
			_content.width = 310;
			_content.height = 90;
			_content.wordWrap = true;
			addChild(_content);
			_content.text = LanguageManager.getWord("ssztl.core.startGame");
			
			
			_tipField = new TextField();
			_tipField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x33CC00);
			_tipField.filters = [new GlowFilter(0,1,4,4,4.5)];
			_tipField.mouseEnabled = _tipField.mouseWheelEnabled = false;
			_tipField.x = 270;
			_tipField.y = 152;
			_tipField.width = 310;
			addChild(_tipField);
			_tipField.text = LanguageManager.getWord("ssztl.core.smallPrompt");
			
			_okBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.common.LoginBtnAsset", BitmapData) as BitmapData);
			_okBtn.move(507,180);
			addChild(_okBtn);
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var deploy:DeployItemInfo = new DeployItemInfo();
			deploy.type = DeployEventType.TASK_NPC;
			switch(GlobalData.selfPlayer.career)
			{
				case CareerType.SANWU:
					deploy.param1 = 102302;
					break;
				case CareerType.XIAOYAO:
					deploy.param1 = 102201;
					break;
				case CareerType.LIUXING:
					deploy.param1 = 102405;
					break;
			}
			DeployEventManager.handle(deploy);
			
			var deploy1:DeployItemInfo = new DeployItemInfo();
			deploy1.type = DeployEventType.TASK;
			deploy1.param1 = 5;
			deploy1.param2 = 1;
			DeployEventManager.handle(deploy1);
			
			var deploy2:DeployItemInfo = new DeployItemInfo();
			deploy2.type = DeployEventType.GUIDE_TIP;
			switch(GlobalData.selfPlayer.career)
			{
				case CareerType.SANWU:
					deploy2.descript = LanguageManager.getWord("ssztl.core.yanNeedHelp");
					break;
				case CareerType.XIAOYAO:
					deploy2.descript = LanguageManager.getWord("ssztl.core.jiNeedHelp");
					break;
				case CareerType.LIUXING:
					deploy2.descript = LanguageManager.getWord("ssztl.core.quNeedHelp");
					break;
			}
			deploy2.param1 = GuideTipDeployType.TASK_FOLLOW;
			deploy2.param2 = 2;
			deploy2.param3 = -155;
			deploy2.param4 = 57;
			DeployEventManager.handle(deploy2);
			
			var deploy3:DeployItemInfo = new DeployItemInfo();
			deploy3.type = DeployEventType.GUIDE_TIP;
			deploy3.descript = LanguageManager.getWord("ssztl.core.clickStartTask",GlobalData.GAME_NAME);
			deploy3.param1 = GuideTipDeployType.NPC_TASK;
			deploy3.param2 = 3;
			deploy3.param3 = 300;
			deploy3.param4 = 186;
			GlobalData.setGuideTipInfo(deploy3);
			
			dispose();
		}
		
		public function show():void
		{
			if(parent == null)
			{
				this.x = CommonConfig.GAME_WIDTH - 850;
				this.y = CommonConfig.GAME_HEIGHT - 450;
				
				GlobalAPI.layerManager.getTipLayer().addChild(this);
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			if(parent)parent.removeChild(this);
		}
	}
}