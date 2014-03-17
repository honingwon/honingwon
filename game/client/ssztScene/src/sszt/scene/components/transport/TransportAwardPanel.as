package sszt.scene.components.transport
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class TransportAwardPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _itemViewList:Array;
		private var _taskTemplate:TaskTemplateInfo;
		public function TransportAwardPanel(taskTemplate:TaskTemplateInfo)
		{
			_taskTemplate = taskTemplate;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.scene.TransportAwardTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.scene.TransportAwardTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1, true, true);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(318,166);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,318,166)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,5,307,154)),
				new BackgroundInfo(BackgroundType.BAR_1, new Rectangle(11,10,298,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(73,12,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(171,12,11,17),new MCacheSplit3Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,59,299,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,89,299,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,119,299,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,149,299,2),new MCacheSplit2Line())
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,13,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.transportQuality"),MAssetLabel.LABELTYPE14)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(102,13,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.expAward"),MAssetLabel.LABELTYPE14)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(193,13,112,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copperAward"),MAssetLabel.LABELTYPE14)));
			
			_tile = new MTile(318,30,1);
			_tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = 0;
			_tile.itemGapW = 0;
			_tile.move(0,35);
			_tile.setSize(318,133);
			addContent(_tile);
			
			var stateList:Array = _taskTemplate.states;
			if(stateList && stateList.length>0)
			{
				_itemViewList = [];
				for(var i:int=0;i<stateList.length;i++)
				{
					var item:TransportAwardItemView = new TransportAwardItemView(stateList[i],i);
					_itemViewList.push(item);
					_tile.appendItem(item);
				}
			}
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_itemViewList)
			{
				for each(var item:TransportAwardItemView in _itemViewList)
				{
					item.dispose();
					item = null;
				}
				_itemViewList = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			_taskTemplate = null;
			super.dispose();
		}
	}
}













