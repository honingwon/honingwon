package sszt.scene.components.lifeExpSit
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import mx.controls.Text;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.sit.SitTemplateList;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	public class ExpSitPanel extends Sprite implements ITick
	{
		private static var _instance:ExpSitPanel;
		private var _bg:IMovieWrapper;
		private var _titleLab:MAssetLabel;
		private var _sitTimeTxt:MAssetLabel;
		private var _getExpTxt:MAssetLabel;
		private var _getLiftExpTxt:MAssetLabel;
		private var _timer:Timer;
		private var _timeCount:int;
		private var _type:int;
		private var _timeCount1:int;
		private var _timeCount2:int;
		public function ExpSitPanel(title:DisplayObject=null, dragable:Boolean=true, mode:Number=0.5, closeable:Boolean=true, toCenter:Boolean=true, rect:Rectangle=null)
		{
			super();
			mouseEnabled = false;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,185,114)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(74,32,92,22)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(74,54,92,22)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(74,76,92,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(63,9,58,20),new Bitmap(AssetUtil.getAsset("ssztui.common.TipSitTitleAsset",BitmapData) as BitmapData)),
			]);
			addChild(_bg as DisplayObject);
//			this.x = GlobalData.bagIconPos.x + 108;
//			this.y = GlobalData.bagIconPos.y - 150;
			
			_titleLab = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_titleLab.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,10)]);
			_titleLab.move(15,35);
			addChild(_titleLab);
			_titleLab.setValue(
				LanguageManager.getWord("ssztl.scene.sitTime") + "\n" +
				LanguageManager.getWord("ssztl.scene.sitGetExp") + "\n" +
				LanguageManager.getWord("ssztl.scene.sitGetLifeExp")
			);
			
			_sitTimeTxt = new MAssetLabel("00:00:00",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_sitTimeTxt.move(80,35);
			addChild(_sitTimeTxt);
			
			_getExpTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_getExpTxt.move(80,57);
			addChild(_getExpTxt);
			
			_getLiftExpTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_getLiftExpTxt.move(80,79);
			addChild(_getLiftExpTxt);
			
			initEvent();
			
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		
		public static function getInstance():ExpSitPanel{
			if (_instance == null){
				_instance = new (ExpSitPanel)();
			};
			return (_instance);
		}
		
		
		public function show(type:int):void
		{
			if(type==_type)return;
			_type = type;
			_timeCount1 = 0;
			_timeCount2 = 0;
			if(ExpSitPanel.getInstance().parent==null)
			{
				if(!_timer)
				{
					_timer = new Timer(1000);
					_timer.start();
					_timer.addEventListener(TimerEvent.TIMER,updateByTime);
					_timeCount = 0;
				}
				GlobalAPI.layerManager.getPopLayer().addChild(this);
				this.x = CommonConfig.GAME_WIDTH - (CommonConfig.GAME_WIDTH-(GlobalData.bagIconPos.x + 108));
				this.y = CommonConfig.GAME_HEIGHT;
				GlobalAPI.tickManager.addTick(this);
			}
			var t:ExpSitPanel = this;
			addEventListener(Event.ENTER_FRAME,function():void{
				GlobalAPI.tickManager.addTick( t);
			});
				
			
		}
		private function updateByTime(e:TimerEvent):void
		{
			_timeCount++;
			var str:String = DateUtil.getLeftTime(_timeCount);
			var str1:String ;
			var str2:String ;
			_sitTimeTxt.setValue(str);
			if(_type==1)
				_timeCount1++;
			else
				_timeCount2++;
			
			if(_type==1&&_timeCount1>20&&_timeCount1%20==2)
			{
				str1= (int(_getExpTxt.text)+GlobalData.selfPlayer.tmpExp).toString();
				_getExpTxt.setValue(str1);
				
				str2= (int(_getLiftExpTxt.text)+GlobalData.selfPlayer.dle).toString();
				_getLiftExpTxt.setValue(str2);
			}
			else if(_type==2&&_timeCount2>20&&_timeCount2%20==2)
			{
				str2= (int(_getLiftExpTxt.text)+GlobalData.selfPlayer.dle).toString();
				_getLiftExpTxt.setValue(str2);
			}
			
			
		}
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			GlobalAPI.tickManager.removeTick(this);
			x = CommonConfig.GAME_WIDTH - (CommonConfig.GAME_WIDTH-(GlobalData.bagIconPos.x + 108));
			y = CommonConfig.GAME_HEIGHT ;
//			y = CommonConfig.GAME_HEIGHT - (CommonConfig.GAME_HEIGHT-(GlobalData.bagIconPos.y - 150));
		}
		
		public function hide():void
		{
			removeEvent();
			if(parent)
			{
				parent.removeChild(this);
			}
			_sitTimeTxt.setValue("00:00:00");
			_getExpTxt.setValue("0");
			_getLiftExpTxt.setValue("0");
			_timer.reset();
			_timer = null;
			_type = 0;
			_instance = null;
		}
		
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(y <= CommonConfig.GAME_HEIGHT - 210)
			{
				GlobalAPI.tickManager.removeTick(this);
			}
			else
			{
				y -= 5;
			}
		}
	}
}