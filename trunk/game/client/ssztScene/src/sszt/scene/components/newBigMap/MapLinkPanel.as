package sszt.scene.components.newBigMap
{
    
    import fl.controls.ScrollPolicy;
    
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextFormatAlign;
    
    import sszt.core.data.GlobalData;
    import sszt.core.data.monster.MonsterTemplateInfo;
    import sszt.core.data.npc.NpcTemplateInfo;
    import sszt.core.data.npc.NpcTemplateList;
    import sszt.core.data.scene.DoorTemplateInfo;
    import sszt.core.data.scene.DoorTemplateList;
    import sszt.core.manager.LanguageManager;
    import sszt.interfaces.layer.IPanel;
    import sszt.interfaces.moviewrapper.IMovieWrapper;
    import sszt.scene.components.newBigMap.linkItems.DoorLinkItemView;
    import sszt.scene.components.newBigMap.linkItems.MonsterLinkItemView;
    import sszt.scene.components.newBigMap.linkItems.NpcLinkItemView;
    import sszt.scene.data.SceneMapInfoUpdateEvent;
    import sszt.scene.mediators.BigMapMediator;
    import sszt.ui.backgroundUtil.BackgroundInfo;
    import sszt.ui.backgroundUtil.BackgroundType;
    import sszt.ui.backgroundUtil.BackgroundUtils;
    import sszt.ui.container.MSprite;
    import sszt.ui.container.MTile;
    import sszt.ui.label.MAssetLabel;
    import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
    import sszt.ui.mcache.splits.MCacheCompartLine;

    public class MapLinkPanel extends MSprite implements IPanel
    {
		private var _bg:IMovieWrapper;
		
        private var _mediator:BigMapMediator;
        private var _jumpList:Array;
        private var _tile1:MTile;
        private var _npcList:Array;
        private var _tile2:MTile;
		
		private var _labels:Array;
		private var _btns:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
//        private var _monsterList:Array;
//        private var _tile3:MTile;

        public function MapLinkPanel(mediator:BigMapMediator)
        {
            _mediator = mediator;
            super();
        } 

        override protected function configUI() : void
        {
            super.configUI();
			
//			_bg = BackgroundUtils.setBackground([
//				
//			]);
//			addChild(_bg as DisplayObject);
			
			_labels = [LanguageManager.getWord("ssztl.common.NPCMap"),LanguageManager.getWord("ssztl.common.exitOfMap")];
			_btns = [];
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(4+i*69,-1);
				addChild(btn);
				_btns.push(btn);
			}
			
            _jumpList = [];
            _tile1 = new MTile(163,23);
            _tile1.setSize(177,256);
            _tile1.move(5, 27);
            _tile1.itemGapH = 0;
            _tile1.horizontalScrollPolicy = ScrollPolicy.OFF;
            _tile1.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_tile1);
			_tile1.visible = false;
			
            _npcList = [];
            _tile2 = new MTile(163,23);
            _tile2.setSize(177,256);
            _tile2.move(5,27);
            _tile2.itemGapH = 0;
            _tile2.horizontalScrollPolicy = ScrollPolicy.OFF;
            _tile2.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_tile2);
			_tile2.visible = false;
			
			_panels = [_tile2,_tile1];
			setIndex(0);
//            _monsterList = [];
//            _tile3 = new MTile(146, 25);
//            _tile3.setSize(170, 130);
//            _tile3.move(7, 333);
//            _tile3.itemGapH = 0;
//            _tile3.horizontalScrollPolicy = ScrollPolicy.OFF;
//            _tile3.verticalScrollPolicy = ScrollPolicy.ON;
//            addContent(_tile3);
            initEvent();
            updateView(null);
        }

        private function initEvent() : void
        {
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,tabBtnHandler);
			}
            _mediator.sceneInfo.mapInfo.addEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE, updateView);
        }

        private function removeEvent() : void
        {
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,tabBtnHandler);
			}
            _mediator.sceneInfo.mapInfo.removeEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE, updateView);
        }
		private function tabBtnHandler(event:MouseEvent) : void
		{
			var _loc_2:* = _btns.indexOf(event.currentTarget);
			setIndex(_loc_2);
		}
		private function setIndex(index:int) : void
		{
			if(_currentIndex != -1)
			{
				_panels[_currentIndex].visible = false;
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_panels[_currentIndex].visible = true;
			_btns[_currentIndex].selected = true;
		}

        public function updateView(event:SceneMapInfoUpdateEvent) : void
        {
            var doorInfo:DoorTemplateInfo = null;
            var _loc_4:Array = null;
            var npcInfo:NpcTemplateInfo = null;
            var doorView:DoorLinkItemView = null;
            var npcView:NpcLinkItemView = null;
            var _loc_8:Array = null;
            var _loc_9:Array = null;
//            var _loc_10:MonsterTemplateInfo = null;
//            var _loc_11:MonsterLinkItemView = null;
            clearData();
            var doors:Array = DoorTemplateList.sceneDoorList[GlobalData.currentMapId];
            for each (doorInfo in doors)
            {
				doorView = new DoorLinkItemView(doorInfo, _mediator);
                _tile1.appendItem(doorView);
                _jumpList.push(doorView);
            }
			var npcs:Array = NpcTemplateList.sceneNpcs[GlobalData.currentMapId];
            for each (npcInfo in npcs)
            {
				npcView = new NpcLinkItemView(npcInfo, _mediator);
                _tile2.appendItem(npcView);
                _npcList.push(npcView);
            }
//            if (!CopyTemplateList.isTaoyuan(GlobalData.copyEnterCountList.inCopyId))
//            {
//                _loc_8 = _mediator.sceneInfo.mapInfo.getSceneMonsterIds();
//                _loc_9 = getExceptMonsterList();
//                for each (_loc_10 in _loc_8)
//                {
//                    
//                    if (_loc_9.indexOf(_loc_10.type) != -1)
//                    {
//                        continue;
//                    }
//                    _loc_11 = new MonsterLinkItemView(_loc_10, _mediator);
//                    _tile3.appendItem(_loc_11);
//                    _monsterList.push(_loc_11);
//                }
//            }
        }

//        private function getExceptMonsterList() : Array
//        {
//            if (CopyTemplateList.isZhuXianCopy(GlobalData.copyEnterCountList.inCopyId))
//            {
//                return MonsterTemplateList.ZHUXIAN_MONSTER_EXCEPT;
//            }
//            if (CopyTemplateList.isTrial(GlobalData.copyEnterCountList.inCopyId))
//            {
//                return MonsterTemplateList.TRIAL_MONSTER_EXCEPT;
//            }
//            return MonsterTemplateList.CRUISE_MONSTER_TYPE;
//        }
		
		
		public function doEscHandler():void
		{
		}

        private function clearData() : void
        {
            var i:int = 0;
            _tile1.clearItems();
            _tile2.clearItems();
//            _tile3.clearItems();
            if (_jumpList)
            {
                i = 0;
                while (i < _jumpList.length)
                {
                    
                    _jumpList[i].dispose();
                    i++;
                }
                _jumpList = [];
            }
            if (_npcList)
            {
                i = 0;
                while (i < _npcList.length)
                {
                    
                    _npcList[i].dispose();
					i++;
                }
                _npcList = [];
            }
//            if (_monsterList)
//            {
//                i = 0;
//                while (i < _monsterList.length)
//                {
//                    
//                    _monsterList[i].dispose();
//					i++;
//                }
//                _monsterList = [];
//            }
        }

        override public function dispose() : void
        {
            var i:int = 0;
            removeEvent();
            if (_tile1)
            {
                _tile1.dispose();
                _tile1 = null;
            }
            if (_tile2)
            {
                _tile2.dispose();
                _tile2 = null;
            }
//            if (_tile3)
//            {
//                _tile3.dispose();
//                _tile3 = null;
//            }
            if (_jumpList)
            {
                i = 0;
                while (i < _jumpList.length)
                {
                    
                    _jumpList[i].dispose();
                    i++;
                }
                _jumpList = null;
            }
            if (_npcList)
            {
                i = 0;
                while (i < _npcList.length)
                {
                    
                    _npcList[i].dispose();
					i++;
                }
                _npcList = null;
            }
//            if (_monsterList)
//            {
//                i = 0;
//                while (i < _monsterList.length)
//                {
//                    
//                    _monsterList[i].dispose();
//					i++;
//                }
//                _monsterList = null;
//            }
            super.dispose();
        }

    }
}
