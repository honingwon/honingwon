package sszt.pvp.components
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.pvp.BgResultAsset;
	import ssztui.pvp.ResultTitleAsset;

	/**
	 * 战斗结果 
	 * @author chendong
	 */	
	public class PVPResultPanel extends MSprite implements IPanel,ITick
	{
		private var _bg:Bitmap;
		private var _title:MovieClip;
		
		private var _addExploit:MAssetLabel;
		private var _addExtra:MAssetLabel;
		private var _btnSure:MCacheAssetBtn1;
		
		public static const DEFAULT_WIDTH:int = 483;
		public static const DEFAULT_HEIGHT:int = 173;
		
		private var _result:int = 0; // 0:平局，1：胜利，2：失败
		private var _count1:int = 0; //功勋
		private var _count2:int = 0; //奖励
		private var _count:int = 0;                      
		private var _seconds:int = 3;
		
		public function PVPResultPanel(data:Object)
		{
			switch(int(data.result))
			{
				case 0:
					_result = 2;
					break;
				case 1:
					_result = 1;
					break;
				case 2:
					_result = 3;
					break;
			}
			_count1 = int(data.count1);
			_count2 = int(data.count2);
			init();
			initEvent();
		}
		protected function init():void
		{
			setPanelPosition(null);
			
			_bg = new Bitmap(new BgResultAsset());
			addChild(_bg);
			
			_title = new ResultTitleAsset();
			_title.x = 245;
			_title.y = -17;
			addChild(_title);
			_title.gotoAndStop(_result);		//1:胜利　2:平局 　3:失败
			
			_addExploit = new MAssetLabel("",MAssetLabel.LABEL_TYPE_EN);
			_addExploit.setLabelType([new TextFormat("Thoma",20,0xffcc00,true)]);
			_addExploit.move(245,78);
			addChild(_addExploit);
			_addExploit.setHtmlValue("功勋+"+(_count1+_count2));
			
			_addExtra = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_addExtra.move(245,110);
			addChild(_addExtra);
			_addExtra.setHtmlValue("<font color='#66ff00'>击杀奖励　功勋+"+ _count1 +"</font>\n<font color='#ffbd5e'>人品奖励　功勋+"+ _count2 +"</font>");
			
			
			_btnSure = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.sure") + "("+ _seconds +")");
			_btnSure.move(212,152);
			addChild(_btnSure);
			GlobalAPI.tickManager.addTick(this);
		}
		public function assetsCompleteHandler():void
		{	
		}
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_btnSure.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			// TODO Auto Generated method stub
			_count++;
			if(_count >= 25)
			{
				_seconds --;
				if(_seconds == 0)
				{
					doEscHandler();
				}
				else
				{
					if(_btnSure)
					{
						_btnSure.labelField.text = LanguageManager.getWord("ssztl.common.sure") + "("+ _seconds +")";
					}
				}
				_count = 0;
			}
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_btnSure.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{			
			doEscHandler();
		}
		public function doEscHandler():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.COPY_LEAVE_EVENT));			
			dispose();
//			SetModuleUtils.addPVP1();
//			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.OPEN_PVP_MAINPANEL));
		}
		
		
		override public function dispose():void
		{
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_title && _title.parent)
			{
				_title.parent.removeChild(_title);
				_title = null;
			}
			if(_btnSure)
			{
				_btnSure.dispose();
				_btnSure = null;
			}
			_addExploit = null;
			_addExtra = null;
			super.dispose();
//			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}