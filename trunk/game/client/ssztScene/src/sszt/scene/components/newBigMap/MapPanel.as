package sszt.scene.components.newBigMap
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.constData.CommonConfig;
    import sszt.core.data.GlobalData;
    import sszt.core.manager.LanguageManager;
    import sszt.core.utils.AssetUtil;
    import sszt.events.CommonModuleEvent;
    import sszt.interfaces.layer.IPanel;
    import sszt.interfaces.moviewrapper.IMovieWrapper;
    import sszt.module.ModuleEventDispatcher;
    import sszt.scene.events.SceneInfoUpdateEvent;
    import sszt.scene.mediators.BigMapMediator;
    import sszt.ui.backgroundUtil.BackgroundInfo;
    import sszt.ui.backgroundUtil.BackgroundType;
    import sszt.ui.backgroundUtil.BackgroundUtils;
    import sszt.ui.button.MAssetButton;
    import sszt.ui.container.MPanel;
    import sszt.ui.container.MSprite;
    import sszt.ui.mcache.btns.MCacheAssetBtn1;
    import sszt.ui.mcache.btns.MCacheCloseBtn;
    import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
    import sszt.ui.mcache.titles.MCacheTitle1;

    public class MapPanel extends MPanel
    {
		private var _bg:IMovieWrapper;
		
        private var _mediator:BigMapMediator;
        private var _classes:Array;
        private var _panels:Array;
        private var _labels:Array;
        private var _btns:Array;
        private var _currentIndex:int = -1;
		
        public function MapPanel(mediator:BigMapMediator)
        {
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.bigMap.WinTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.bigMap.WinTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1,true,true);
        } 

		override protected function configUI():void
		{
			super.configUI();
			setContentSize(749,436);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,733,403)),
			]);
			addContent(_bg as DisplayObject);
			
			_labels = [LanguageManager.getWord("ssztl.scene.curMap"),LanguageManager.getWord("ssztl.scene.worldMap")];
			var poses:Array = [new Point(15,0),new Point(84,0)];
			_btns = [];
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				_btns.push(btn);
				btn.move(poses[i].x,poses[i].y);
				addContent(btn);
			}	
			
            _classes = [CurrentMapView, WorldMapView];
            _panels = new Array(_classes.length);
			
            setIndex(0);
			initEvent();
        }

        private function initEvent() : void
        {
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,tabBtnHandler);
			}
            _mediator.sceneInfo.addEventListener(SceneInfoUpdateEvent.BIGMAP_SELECT_CHANGE, bigMapSelectChangeHandler);
        }

        private function removeEvent() : void
        {
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,tabBtnHandler);
			}
            _mediator.sceneInfo.removeEventListener(SceneInfoUpdateEvent.BIGMAP_SELECT_CHANGE, bigMapSelectChangeHandler);
        }

        private function setIndex(index:int, mapId:int = -1) : void
        {
            if (_currentIndex > -1 && _panels[_currentIndex] && _panels[_currentIndex].parent)
            {
				_panels[_currentIndex].parent.removeChild(_panels[_currentIndex] as DisplayObject);
            }
            _currentIndex = index;
            if (_panels[_currentIndex] == null)
            {
                _panels[_currentIndex] = new _classes[_currentIndex](_mediator);
            }
            if (_currentIndex == 0)
            {
                _panels[_currentIndex].show(mapId);
            }
            else
            {
                _panels[_currentIndex].show();
            }
			_panels[_currentIndex].move(12,29);
			addContent(_panels[_currentIndex] as DisplayObject);
        }

        private function tabBtnHandler(event:MouseEvent) : void
        {
            var _loc_2:* = _btns.indexOf(event.currentTarget);
            setIndex(_loc_2);
        }

        private function bigMapSelectChangeHandler(event:SceneInfoUpdateEvent) : void
        {
            if (_panels[1] && _panels[1].parent == this)
            {
				removeChild(_panels[1]);
            }
            setIndex(0, int(event.data));
        }

        override public function dispose() : void
        {
			removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
            var btn:MCacheTabBtn1 = null;
            var i:int = 0;
           
            _mediator = null;
            for each (btn in _btns)
            {
                
				btn.removeEventListener(MouseEvent.CLICK, tabBtnHandler);
				btn.dispose();
				btn = null;
            }
            _btns = null;
            _classes = null;
            if (_panels)
            {
                i = 0;
                while (i < _panels.length)
                {
                    
                    if (_panels[i] != null)
                    {
                        _panels[i].dispose();
                    }
                    i++;
                }
                _panels = null;
            }
            
            super.dispose();
//			dispatchEvent(new Event(Event.CLOSE));
        }

    }
}
