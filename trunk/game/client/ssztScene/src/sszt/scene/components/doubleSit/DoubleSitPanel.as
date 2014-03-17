package sszt.scene.components.doubleSit
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.commands.activities.PlayerListController;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.mediators.DoubleSitMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	public class DoubleSitPanel extends MPanel
	{
		private static const PAGESIZE:int = 7;
		public static var SELECTEDBORDER:SelectedBorder;
		
		private var _mediator:DoubleSitMediator;
		private var _bg:IMovieWrapper;
		private var _pageView:PageView;
		private var _tile:MTile;
//		private var _items:Vector.<DoubleSitItem>;
//		private var _source:Vector.<BaseScenePlayerInfo>;
		private var _items:Array;
		private var _source:Array;
		private var _currentItem:DoubleSitItem;
		private var _refleshListBtn:MCacheAssetBtn1;
		private var _introBtn:MCacheAssetBtn1;
		private var _inviteBtn:MCacheAssetBtn1;
		
		public function DoubleSitPanel(mediator:DoubleSitMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.PlayerListTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.PlayerListTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			SELECTEDBORDER = new SelectedBorder();
			SELECTEDBORDER.setSize(238,24);
			
			var _rowBg:Shape = new Shape();	
			_rowBg.graphics.beginFill(0x172527,1);
			_rowBg.graphics.drawRect(16,58,238,22);
			_rowBg.graphics.drawRect(16,106,238,22);
			_rowBg.graphics.drawRect(16,154,238,22);
			_rowBg.graphics.endFill();
			super.configUI();
			
			setContentSize(270,288);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,3,254,246)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,7,246,238)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(15,10,240,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(146,11,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(198,11,2,20),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,56,238,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,80,238,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,104,238,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,128,238,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,152,238,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,176,238,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,200,238,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,238,118),_rowBg),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,13,130,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.applyPlayerName"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,13,50,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(200,13,54,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2)),
			]);
			addContent(_bg as DisplayObject);
			
//			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.nearPlayer2") + "：",MAssetLabel.LABELTYPE3);
//			label1.move(9,8);
//			addContent(label1);
//			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.playerName"),MAssetLabel.LABELTYPE3);
//			label2.move(47,35);
//			addContent(label2);
//			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABELTYPE3);
//			label3.move(152,35);
//			addContent(label3);
//			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE3);
//			label4.move(212,35);
//			addContent(label4);
			
			_pageView = new PageView(PAGESIZE,false,100);
			_pageView.move(76,209);
			addContent(_pageView);
			
			_tile = new MTile(238,24);
//			_tile.marginWidth = 5;
//			_tile.marginHeight = 5;
			_tile.move(16,33);
			_tile.setSize(238,168);
			_tile.itemGapH = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile);
//			_items = new Vector.<DoubleSitItem>();
			_items = [];
			
//			_source = new Vector.<BaseScenePlayerInfo>();
			_source = [];
			var list:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
			for each(var i:BaseScenePlayerInfo in list)
			{
				if(i != _mediator.sceneInfo.playerList.self)
					_source.push(i);
			}
			_pageView.totalRecord = _source.length;
			
			_refleshListBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.refreshList"));
			_refleshListBtn.move(27,254);
			addContent(_refleshListBtn);
			
			_introBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.doubleSitExplain"));
			_introBtn.move(100,254);
			addContent(_introBtn);
			
			_inviteBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.inviteDoubleSit"));
			_inviteBtn.move(173,254);
			addContent(_inviteBtn);
			doubleSitChangeHandler(null);
			
			setData();
			initEvent();
		}
		
		private function setData():void
		{
			for each(var j:DoubleSitItem in _items)
			{
				j.removeEventListener(MouseEvent.CLICK,itemClickhandler);
			}
			_tile.disposeItems();
			_items.length = 0;
			var currentPage:int = _pageView.currentPage;
//			var tmp:Vector.<BaseScenePlayerInfo> = _source.slice(( currentPage - 1) * PAGESIZE,currentPage * PAGESIZE);
			var tmp:Array = _source.slice(( currentPage - 1) * PAGESIZE,currentPage * PAGESIZE);
			for each(var i:BaseScenePlayerInfo in tmp)
			{
				var item:DoubleSitItem = new DoubleSitItem(i);
				_items.push(item);
				_tile.appendItem(item);
				item.addEventListener(MouseEvent.CLICK,itemClickhandler);
			}
		}
		
		private function initEvent():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_refleshListBtn.addEventListener(MouseEvent.CLICK,refleshClickHandler);
			_introBtn.addEventListener(MouseEvent.CLICK,introClickHandler);
			_inviteBtn.addEventListener(MouseEvent.CLICK,inviteClickHandler);
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.DOUBLESIT_CHANGE,doubleSitChangeHandler);
		}
		
		private function removeEvent():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_refleshListBtn.removeEventListener(MouseEvent.CLICK,refleshClickHandler);
			_introBtn.removeEventListener(MouseEvent.CLICK,introClickHandler);
			_inviteBtn.removeEventListener(MouseEvent.CLICK,inviteClickHandler);
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.DOUBLESIT_CHANGE,doubleSitChangeHandler);
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			setData();
		}
		
		private function doubleSitChangeHandler(evt:ScenePlayerListUpdateEvent):void
		{
			_inviteBtn.enabled = !_mediator.sceneInfo.playerList.isDoubleSit();
		}
		
		private function refleshClickHandler(evt:MouseEvent):void
		{
			_pageView.currentPage = 1;
//			_source = new Vector.<BaseScenePlayerInfo>();
			_source = [];
			var list:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
			for each(var i:BaseScenePlayerInfo in list)
			{
				if(i != _mediator.sceneInfo.playerList.self)
					_source.push(i);
			}
			_pageView.totalRecord = _source.length;
			setData();
		}
		private function introClickHandler(evt:MouseEvent):void
		{
			_mediator.showDoubleSitIntro();
		}
		private function inviteClickHandler(evt:MouseEvent):void
		{
			if(_currentItem && _currentItem.info && _currentItem.info.info)
			{
				if(_currentItem.info == _mediator.sceneInfo.playerList.getPlayer(_currentItem.info.info.userId))
				{
					_mediator.inviteSit(_currentItem.info.info.serverId,_currentItem.info.info.nick,_currentItem.info.info.userId);
				}
			}
		}
		
		private function itemClickhandler(evt:MouseEvent):void
		{
			if(_currentItem)
			{
				_currentItem.selected = false;
			}
			var item:DoubleSitItem = evt.currentTarget as DoubleSitItem;
			if(item)
			{
				_currentItem = item;
			}
			_currentItem.selected = true;
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(SELECTEDBORDER && SELECTEDBORDER.parent)
			{
				SELECTEDBORDER.parent.removeChild(SELECTEDBORDER);
				SELECTEDBORDER = null;
			}
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			for(var i:int = _items.length - 1; i >= 0; i--)
			{
				if(_items[i])_items[i].dispose();
			}
			_items = null;
			_source = null;
			_currentItem = null;
			if(_refleshListBtn)
			{
				_refleshListBtn.dispose();
				_refleshListBtn = null;
			}
			if(_introBtn)
			{
				_introBtn.dispose();
				_introBtn = null;
			}
			if(_inviteBtn)
			{
				_inviteBtn.dispose();
				_inviteBtn = null;
			}
			super.dispose();
		}
	}
}