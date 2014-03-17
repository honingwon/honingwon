package sszt.scene.components.eventList
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.AddBtnAsset;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.events.EventListUpdateEvent;
	import sszt.scene.mediators.EventMediator;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import ssztui.ui.AddBtnAsset;
	
	public class SceneEventView extends Sprite
	{
//		private var _content:MTextArea;
//		private var _contents:Vector.<TextField>;
		private var _contents:Array;
		private var _mediator:EventMediator;
		private var _showPanelBtn:MAssetButton1;
		
		public function SceneEventView(mediator:EventMediator)
		{
			super();
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
			gameSizeChangeHandler(null);
			mouseEnabled = false;
			
//			_contents = new Vector.<TextField>();
			_contents = [];
			for(var i:int = 0; i < 4; i++)
			{
				var item:TextField = new TextField();
				var itemFormat:TextFormat = new TextFormat("SimSun",12);
				itemFormat.align = TextFormatAlign.RIGHT;
				item.defaultTextFormat = itemFormat;
				item.mouseEnabled = item.mouseWheelEnabled = false;
				item.width = 178;
				item.height = 18;
				item.x = -178;
				item.y = i * 18 - 90;
				item.filters = [new GlowFilter(0,1,2,2,6)];
				item.textColor = getItemColor(i);				
				addChild(item);
				_contents.push(item);
			}
			
			_showPanelBtn = new MAssetButton1(ssztui.ui.AddBtnAsset);
//			_showPanelBtn.move(175,45);
			_showPanelBtn.move(-18,-16);
			addChild(_showPanelBtn);
		}
		
		private function getItemColor(index:int):int
		{
			if(index < 3)return 0xffffff;
			return 0xffff00;
		}
		
		private function initEvent():void
		{
			_showPanelBtn.addEventListener(MouseEvent.CLICK,showClickHandler);
			_showPanelBtn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_showPanelBtn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_mediator.sceneInfo.eventList.addEventListener(EventListUpdateEvent.ADDEVENT,addEventHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_showPanelBtn.removeEventListener(MouseEvent.CLICK,showClickHandler);
			_showPanelBtn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_showPanelBtn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_mediator.sceneInfo.eventList.removeEventListener(EventListUpdateEvent.ADDEVENT,addEventHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			//193,194   =170,120
			x = CommonConfig.GAME_WIDTH - 6;
			y = CommonConfig.GAME_HEIGHT - 25;
		}
		
		private function showClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showEventPanel();
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.seeMoreGameMsg"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function addEventHandler(e:EventListUpdateEvent):void
		{
			for(var i:int = 0; i < 3; i++)
			{
				_contents[i].text = _contents[i + 1].text;
			}
			_contents[3].text = String(e.data);
		}
	}
}