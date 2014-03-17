package sszt.core.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MTextButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;
	
	public class MayaCopyEntranceView extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _itemTemplate:ItemTemplateInfo;
		private var _itemCount:int;
		private var _btnEnter:MCacheAssetBtn1;
		private var _btnEnterClickHandler:Function;
		private var _cell:MayaCopyEntranceViewCell;
		private var _tip:MTextButton;
		
		public function MayaCopyEntranceView()
		{
			_itemTemplate = ItemTemplateList.getTemplate(206115);
			_itemCount =GlobalData.bagInfo.getItemCountByItemplateId(206115);
			super(new MCacheTitle1(""),true,-1);
		}
		
		private static var instance:MayaCopyEntranceView;
		public static function getInstance():MayaCopyEntranceView
		{
			if(instance == null)
			{
				instance = new MayaCopyEntranceView();
			}
			return instance;
		}
		
		public function show(btnEnterClickHandler:Function):void
		{
			_btnEnterClickHandler = btnEnterClickHandler;
			GlobalAPI.layerManager.addPanel(this);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(230,210);
			
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,140,210,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,18,230,148),new MAssetLabel("进入场景需要道具：",MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(98,55,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addContent(_bg as DisplayObject);
			
			_btnEnter = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.scene.enter'));
			_btnEnter.move(80,160);
			addContent(_btnEnter);
			
			_cell = new MayaCopyEntranceViewCell();
			_cell.move(98,55);
			_cell.info = _itemTemplate;
			_cell.count = _itemCount;
			addContent(_cell);
			
			_tip = new MTextButton(LanguageManager.getWord("ssztl.common.ruleIntro"),0xffcc00);
			_tip.move(93,103);
			addContent(_tip);
			
			if(_itemCount < 1) 
			{
				_btnEnter.enabled = false;
				//_cell.setTextFormat();
			}
			
			setPos();
			
			initEvent();
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_btnEnter.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
			
			_tip.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_tip.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_btnEnter.removeEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
			
			_tip.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_tip.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function changeSceneHandler(e:Event):void
		{
			this.dispose();
		}
		
		protected function btnEnterClickHandler(event:MouseEvent):void
		{
			_btnEnterClickHandler();
			_btnEnter.enabled = false;
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("1.进入圣地需要消耗1入场券，每张入场券可以可以在圣地待1个小时。\n2.完成每天的帮会任务可以获得1张“圣地入场券”。\n3.圣地的怪物经验丰厚，并且精英和BOSS均会掉落稀有物品。",null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			setPos();
		}
		
		private function setPos():void
		{
			this.x = (CommonConfig.GAME_WIDTH - 200)/2;
			this.y = (CommonConfig.GAME_HEIGHT - 200)/2;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			instance = null;
			_itemTemplate = null;
			if(_btnEnter)
			{
				_btnEnter.dispose();
				_btnEnter = null;
			}
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			
			_btnEnterClickHandler = null;
		}
				
	}
}