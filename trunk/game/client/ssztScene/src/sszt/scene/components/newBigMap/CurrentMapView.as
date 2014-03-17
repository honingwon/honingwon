package sszt.scene.components.newBigMap
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.newBigMap.items.DoorView;
	import sszt.scene.components.newBigMap.items.MonsterPointView;
	import sszt.scene.components.newBigMap.items.MonsterView;
	import sszt.scene.components.newBigMap.items.NpcView;
	import sszt.scene.components.newBigMap.items.PartnerView;
	import sszt.scene.components.newBigMap.items.PlayerView;
	import sszt.scene.components.newBigMap.items.TransferBtn;
	import sszt.scene.data.SceneMapInfo;
	import sszt.scene.data.SceneMapInfoUpdateEvent;
	import sszt.scene.data.TeamPlayerList;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.BigMapMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.ui.SplitCompartLine2;

    public class CurrentMapView extends MSprite implements ITick
    {
        private var _mediator:BigMapMediator;
        private var _bg:IMovieWrapper;
		private var _container:Sprite;
        private var _currentMapName:MAssetLabel;
        private var _currentPos:MAssetLabel;
        private var _sendXTextField:TextField;
        private var _sendYTextField:TextField;
        private var _quickSendBtn:MCacheAssetBtn1;
        private var _currentMapId:int = -1;
        private var _map:Bitmap;
        private var _itemLayer:Sprite;
        private var _clickLayer:Sprite;
        private var _NPCCheckbox:CheckBox;
        private var _monsterCheckbox:CheckBox;
        private var _playerItem:PlayerView;
		private var _partnerItemList:Array;
        private var _npcItems:Array;
        private var _monsterItems:Array;
        private var _doorItems:Array;
        private var _monsterPointItems:Array;
        private var _teamPlayerItems:Array;
        private var _tickCount:int;
        private var _rate:Number;
        private var _currentSceneMapInfo:SceneMapInfo;
        private var _xOffset:Number;
        private var _yOffset:Number;
        private var _transferBitmapBtn:TransferBtn;
        private var _mapPath:String = "";
        private var _currentComplete:Boolean;
		private var _mapLinkPanel:MapLinkPanel;
		
        public static var playerPointAsset:BitmapData = AssetUtil.getAsset("ssztui.scene.MapPlayerPointAsset", BitmapData) as BitmapData;
        public static var jumpPointAsset:BitmapData = AssetUtil.getAsset("ssztui.scene.MapJumpPointAsset", BitmapData) as BitmapData;
        public static var npcPointAsset:BitmapData = AssetUtil.getAsset("ssztui.scene.BigmapLittleHumanAsset") as BitmapData;
        public static var teamPlayerPointAsset:BitmapData = AssetUtil.getAsset("ssztui.scene.MapPlayerPointAsset", BitmapData) as BitmapData;
        private static const small_x:int = 529;
        private static const small_y:int = 385;

        public function CurrentMapView(mediator:BigMapMediator)
        {
            _npcItems = [];
            _monsterItems = [];
            _doorItems = [];
            _monsterPointItems = [];
            _teamPlayerItems = [];
            _mediator = mediator;
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            _bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(0,0,539,395)), 
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(541,0,184,68)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(541,99,184,261)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(541,67,184,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(541,359,184,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(554,16,60,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.sceneModule"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(554,38,60,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.coordinate"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
            addChild(_bg as DisplayObject);
			
			_container = new Sprite();
			_container.x = _container.y = 5;
			addChild(_container);
			
            _map = new Bitmap();
			_container.addChild(_map);
            _clickLayer = new Sprite();
			_container.addChild(_clickLayer);
            _itemLayer = new Sprite();
			_container.addChild(_itemLayer);			
            _itemLayer.mouseEnabled = false;
			
			_mapLinkPanel = new MapLinkPanel(_mediator);
			_mapLinkPanel.move(541,74);
			addChild(_mapLinkPanel);
			
            _currentMapName = new MAssetLabel("", MAssetLabel.LABEL_TYPE22,TextFieldAutoSize.LEFT);
            _currentMapName.move(590,16);
            addChild(_currentMapName);
            _currentPos = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFieldAutoSize.LEFT);
            _currentPos.move(590,38);
            addChild(_currentPos);
			
            _sendXTextField = new TextField();
            _sendXTextField.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
            _sendXTextField.maxChars = 4;
            _sendXTextField.restrict = "0123456789";
            _sendXTextField.type = "input";
            _sendXTextField.x = 312;
            _sendXTextField.y = 340;
            _sendXTextField.width = 34;
            _sendXTextField.height = 16;
            _sendXTextField.autoSize = TextFieldAutoSize.CENTER;
//            addChild(_sendXTextField);
            _sendYTextField = new TextField();
            _sendYTextField.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
            _sendYTextField.maxChars = 4;
            _sendYTextField.restrict = "0123456789";
            _sendYTextField.type = "input";
            _sendYTextField.x = 354;
            _sendYTextField.y = 340;
            _sendYTextField.width = 34;
            _sendYTextField.height = 16;
            _sendYTextField.autoSize = TextFieldAutoSize.CENTER;
//            addChild(_sendYTextField);
            _quickSendBtn = new MCacheAssetBtn1(0,3, LanguageManager.getWord("ssztl.common.goRightNow"));
            _quickSendBtn.move(393,335);
//            addChild(_quickSendBtn);
			
            _NPCCheckbox = new CheckBox();
            _NPCCheckbox.height = 20;
            _NPCCheckbox.width = 80;
            _NPCCheckbox.label = LanguageManager.getWord("ssztl.common.NPC");
            _NPCCheckbox.move(554,368);
            addChild(_NPCCheckbox);
            _NPCCheckbox.selected = _mediator.sceneInfo.mapCheckBoxData[1];
            _monsterCheckbox = new CheckBox();
            _monsterCheckbox.height = 20;
            _monsterCheckbox.width = 80;
            _monsterCheckbox.label = LanguageManager.getWord("ssztl.common.monster");
            _monsterCheckbox.move(638,368);
            addChild(_monsterCheckbox);
            _monsterCheckbox.selected = _mediator.sceneInfo.mapCheckBoxData[2];
            _transferBitmapBtn = new TransferBtn();
            _itemLayer.addChild(_transferBitmapBtn);
            _transferBitmapBtn.visible = false;
			
			initEvent();
        }

        private function initEvent() : void
        {
            _quickSendBtn.addEventListener(MouseEvent.CLICK, quickSendHandler);
            _NPCCheckbox.addEventListener(Event.CHANGE, NPCCheckboxHandler);
            _monsterCheckbox.addEventListener(Event.CHANGE, monsterCheckboxHandler);
            _mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.ADDPLAYER, addPlayerHandler);
            _mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER, removePlayerHandler);
            _mediator.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER, addMonsterHandler);
            _mediator.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER, removeMonsterHandler);
            _mediator.sceneInfo.mapDatas.addEventListener(SceneMapInfoUpdateEvent.LOAD_DATA_COMPLETE, mapDataLoadComplete);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_PARTNER_POSITION, partnerPositionUpdateHandler);
//            _mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER, updateTeamPlayerHandler);
//            _mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER, updateTeamPlayerHandler);
//            _mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_POS, updateTeamPlayerHandler);
            _clickLayer.addEventListener(MouseEvent.CLICK, clickHandler);
            _transferBitmapBtn.addEventListener(MouseEvent.CLICK, transferBitmapBtnClickHandler);
            _transferBitmapBtn.addEventListener(MouseEvent.ROLL_OVER, transferOverClickHandler);
            _transferBitmapBtn.addEventListener(MouseEvent.ROLL_OUT, transferOutClickHandler);
			
        }

        private function removeEvent() : void
        {
            _quickSendBtn.removeEventListener(MouseEvent.CLICK, quickSendHandler);
            _NPCCheckbox.removeEventListener(Event.CHANGE, NPCCheckboxHandler);
            _monsterCheckbox.removeEventListener(Event.CHANGE, monsterCheckboxHandler);
            _mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.ADDPLAYER, addPlayerHandler);
            _mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER, removePlayerHandler);
            _mediator.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER, addMonsterHandler);
            _mediator.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER, removeMonsterHandler);
            _mediator.sceneInfo.mapDatas.removeEventListener(SceneMapInfoUpdateEvent.LOAD_DATA_COMPLETE, mapDataLoadComplete);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_PARTNER_POSITION, partnerPositionUpdateHandler);
//            _mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER, updateTeamPlayerHandler);
//            _mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER, updateTeamPlayerHandler);
//            _mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_POS, updateTeamPlayerHandler);
            _clickLayer.removeEventListener(MouseEvent.CLICK, clickHandler);
            _transferBitmapBtn.removeEventListener(MouseEvent.CLICK, transferBitmapBtnClickHandler);
            _transferBitmapBtn.removeEventListener(MouseEvent.ROLL_OVER, transferOverClickHandler);
            _transferBitmapBtn.removeEventListener(MouseEvent.ROLL_OUT, transferOutClickHandler);
			
        }
		
		

        private function initRate() : void
        {
            var rateX:Number = small_x / _currentSceneMapInfo.width;
            var rateY:Number = small_y / _currentSceneMapInfo.height;
            _rate = Math.min(rateX, rateY);
            var num:Number = Math.abs(rateX - rateY);
            if (rateX > rateY)
            {
                _xOffset = _currentSceneMapInfo.width * num / 2;
                _yOffset = 0;
            }
            else
            {
                _xOffset = 0;
                _yOffset = _currentSceneMapInfo.height * num / 2;
            }
            _clickLayer.graphics.clear();
            _clickLayer.graphics.beginFill(0, 0);
            _clickLayer.graphics.drawRect(0, 0, _currentSceneMapInfo.width * _rate, _currentSceneMapInfo.height * _rate);
            _clickLayer.graphics.endFill();
            _clickLayer.x = _xOffset;
            _clickLayer.y = _yOffset;
        }

        public function loadMap(id:int) : void
        {
            if (_currentMapId == id)
            {
                return;
            }
            _transferBitmapBtn.visible = false;
            _currentComplete = false;
            _itemLayer.graphics.clear();
            clearPlayer();
            clearMonster();
            clearNpc();
            clearDoor();
            clearMonsterPoints();
//            clearTeamPlayer();
            if (_currentMapId != -1 && _mapPath != "")
            {
                GlobalAPI.loaderAPI.removeAQuote(_mapPath,picLoadComplete);
                _map.bitmapData = null;
            }
            _mapPath = "";
            _currentMapId = id;
            if (_currentMapId != -1)
            {
                _mediator.sceneInfo.mapDatas.loadMapData(_currentMapId);
            }
            if (GlobalData.currentMapId == _currentMapId)
            {
                _tickCount = 100;
                GlobalAPI.tickManager.addTick(this);
            }
            else
            {
                GlobalAPI.tickManager.removeTick(this);
            }
        }
		
        private function mapDataLoadComplete(event:SceneMapInfoUpdateEvent) : void
        {
            if (_currentMapId == int(event.data) && !_currentComplete)
            {
				
                _currentSceneMapInfo = _mediator.sceneInfo.mapDatas.getMapInfo(_currentMapId);
				initRate();
                _mapPath = GlobalAPI.pathManager.getScenePreMapPath( MapTemplateList.getMapTemplate(_currentMapId).mapPath);
                GlobalAPI.loaderAPI.getPicFile(_mapPath, picLoadComplete, SourceClearType.CHANGESCENE_AND_TIME, 180000);
                initPlayer();
				initPartner();
                initMonster();
                initNpc();
                initDoor();
                initMonsterPoints();
//                initTeamPlayer();
                _itemLayer.addChild(_transferBitmapBtn);
                _currentComplete = true;
                _currentMapName.text = MapTemplateList.getMapTemplate(_currentMapId).name;
//				_currentPos.x = _currentMapName.x + _currentMapName.width;
            }
        }

        private function picLoadComplete(data:BitmapData) : void
        {
            _map.bitmapData = data;
			_map.x = _xOffset;
			_map.y = _yOffset;
			_map.width =  _map.bitmapData.width * _rate * 10;
			_map.height =  _map.bitmapData.height * _rate * 10;
        }

        private function playerCheckboxHandler(event:Event) : void
        {
        }

        private function NPCCheckboxHandler(event:Event) : void
        {
            var _loc_2:NpcView = null;
            var _loc_3:NpcView = null;
            _mediator.sceneInfo.mapCheckBoxData[1] = _NPCCheckbox.selected;
            if (_NPCCheckbox.selected)
            {
                for each (_loc_2 in _npcItems)
                {
                    
                    _loc_2.show(_itemLayer);
                }
            }
            else
            {
                for each (_loc_3 in _npcItems)
                {
                    
                    _loc_3.hide();
                }
            }
        }

        private function monsterCheckboxHandler(event:Event) : void
        {
            var view:MonsterView = null;
            _mediator.sceneInfo.mapCheckBoxData[2] = _monsterCheckbox.selected;
            if (_monsterCheckbox.selected)
            {
                for each (view in _monsterItems)
                {
                    
					view.show(_itemLayer);
                }
            }
            else
            {
                for each (view in _monsterItems)
                {
                    
					view.hide();
                }
            }
        }
		
		private function initPartner():void
		{
			//clearPartner();
			for each(var p:PartnerView in _partnerItemList)
			{
				p.dispose();
			}
			_partnerItemList = [];
			for(var i:int = 0;i<4;i++)
			{
				var partnerItem:PartnerView = new PartnerView();
				_itemLayer.addChild(partnerItem);
				partnerItem.visible = false;
				_partnerItemList.push(partnerItem);
			}
		}

        private function initPlayer() : void
        {
            clearPlayer();
            if (_mediator.sceneInfo.playerList.self && GlobalData.currentMapId == _currentMapId)
            {
                addPlayer(_mediator.sceneInfo.playerList.self);
            }
        }

        private function clearPlayer() : void
        {
            if (_mediator.sceneInfo.playerList.self)
            {
                removePlayer(_mediator.sceneInfo.playerList.self);
            }
        }

        private function addPlayerHandler(event:ScenePlayerListUpdateEvent) : void
        {
            if (GlobalData.currentMapId != _currentMapId)
            {
                return;
            }
            addPlayer(event.data as BaseScenePlayerInfo);
        }

        private function removePlayerHandler(event:ScenePlayerListUpdateEvent) : void
        {
            if (GlobalData.currentMapId != _currentMapId)
            {
                return;
            }
            removePlayer(event.data as BaseScenePlayerInfo);
        }

        private function addPlayer(player:BaseScenePlayerInfo) : void
        {
            if (player.getObjId() != GlobalData.selfPlayer.userId)
            {
                return;
            }
            player.addEventListener(BaseSceneObjInfoUpdateEvent.WALK_START, walkStartHandler, false, 0, true);
            player.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE, moveHandler, false, 0, true);
            _playerItem = new PlayerView(player);
            _playerItem.move(player.sceneX * _rate + _xOffset, player.sceneY * _rate + _yOffset);
            _itemLayer.addChild(_playerItem);
            _currentPos.text = int(_mediator.sceneInfo.playerList.self.sceneX) + "," + int(_mediator.sceneInfo.playerList.self.sceneY);
        }

        private function removePlayer(player:BaseScenePlayerInfo) : void
        {
            if (player.getObjId() != GlobalData.selfPlayer.userId)
            {
                return;
            }
            player.removeEventListener(BaseSceneObjInfoUpdateEvent.WALK_START, walkStartHandler);
            player.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE, moveHandler);
            if (_playerItem)
            {
                _playerItem.dispose();
                _playerItem = null;
            }
        }

        private function walkStartHandler(event:BaseSceneObjInfoUpdateEvent) : void
        {
            var i:int = 0;
            if (!_playerItem)
            {
                return;
            }
            var path:Array = event.data.path;
            if (_currentMapId == GlobalData.currentMapId)
            {
                _itemLayer.graphics.clear();
                _itemLayer.graphics.lineStyle(2, 16711680);
                _itemLayer.graphics.moveTo(_playerItem.x, _playerItem.y);
                i = 0;
                while (i < path.length)
                {
                    
                    _itemLayer.graphics.lineTo(path[i].x * _rate + _xOffset, path[i].y * _rate + _yOffset);
                    i++;
                }
            }
        }
		
		private function partnerPositionUpdateHandler(event:SceneTeamPlayerListUpdateEvent) : void
		{
			var i:int = 0;
			var partner:TeamScenePlayerInfo;
			var partnerItem:PartnerView;
			var teamPlayerList:TeamPlayerList = _mediator.sceneInfo.teamData;
			for each(partner in teamPlayerList.teamPlayers)
			{
				if(partner != teamPlayerList.self && partner.mapID == _currentMapId)
				{
					partnerItem = _partnerItemList[i];
					partnerItem.visible = true;
					partnerItem.setName(partner.getName());
					partnerItem.move(partner.mapX * _rate + _xOffset, partner.mapY * _rate + _yOffset);					
					i++;
				}
			}
			for(i;i<4;i++)
			{
				partnerItem = _partnerItemList[i];
				partnerItem.visible = false;
			}
		}
		
        private function moveHandler(event:BaseSceneObjInfoUpdateEvent) : void
        {
            var self:SelfScenePlayerInfo = _mediator.sceneInfo.playerList.self;
            if (self && _playerItem)
            {
                _playerItem.move(self.sceneX * _rate + _xOffset, self.sceneY * _rate + _yOffset);
                _currentPos.text = int(_mediator.sceneInfo.playerList.self.sceneX) + "," + int(_mediator.sceneInfo.playerList.self.sceneY);
            }
        }

//        private function updateTeamPlayerHandler(event:SceneTeamPlayerListUpdateEvent) : void
//        {
//            initTeamPlayer();
//        }
//
//        private function initTeamPlayer() : void
//        {
//            var team:TeamScenePlayerInfo = null;
//            var _loc_2:Bitmap = null;
//            if (GlobalData.currentMapId != _currentMapId)
//            {
//                return;
//            }
//            clearTeamPlayer();
//            for each (team in _mediator.sceneInfo.teamData.teamPlayers)
//            {
//                
//                if (team.getObjId() != GlobalData.selfPlayer.userId && team.mapPos != null)
//                {
//                    _loc_2 = new Bitmap(teamPlayerPointAsset);
//                    _loc_2.x = team.mapPos.x * _rate + _xOffset - 13;
//                    _loc_2.y = team.mapPos.y * _rate + _yOffset - 13;
//                    _itemLayer.addChild(_loc_2);
//                    _teamPlayerItems.push(_loc_2);
//                }
//            }
//        }
//
//        private function clearTeamPlayer() : void
//        {
//            var bitmap:Bitmap = null;
//            for each (bitmap in _teamPlayerItems)
//            {
//                
//                if (bitmap.parent)
//                {
//					bitmap.parent.removeChild(bitmap);
//                }
//            }
//            _teamPlayerItems.length = 0;
//        }

        private function initMonster() : void
        {
            var dic:Dictionary = null;
            var info:BaseSceneMonsterInfo = null;
            clearMonster();
            if (_currentMapId != GlobalData.currentMapId)
            {
                return;
            }
            if (!_monsterCheckbox.selected)
            {
                return;
            }
//            if (CopyTemplateList.isDota(GlobalData.copyEnterCountList.inCopyId))
//            {
//                WanfoMapTowerStateSocketHandler.send();
//            }
//            else
//            {
			dic = _mediator.sceneInfo.monsterList.getMonsters();
            for each (info in dic)
            {
                addMonster(info);
            }
//            }
        }

        private function addMonsterHandler(event:SceneMonsterListUpdateEvent) : void
        {
            if (_currentMapId != GlobalData.currentMapId)
            {
                return;
            }
//            if (CopyTemplateList.isDota(GlobalData.copyEnterCountList.inCopyId))
//            {
//                return;
//            }
            addMonster(event.data as BaseSceneMonsterInfo);
        }

        private function removeMonsterHandler(event:SceneMonsterListUpdateEvent) : void
        {
            if (_currentMapId != GlobalData.currentMapId)
            {
                return;
            }
            removeMonster(event.data as BaseSceneMonsterInfo);
        }

        private function addMonster(monster:BaseSceneMonsterInfo) : void
        {
//            if (MapTemplateList.isHongMengMap(GlobalData.currentMapId))
//            {
//                MapTemplateList.isHongMengMap(GlobalData.currentMapId);
//            }
//            if (MonsterTemplateList.CRUISE_MONSTER_TYPE.indexOf(monster.template.type) != -1)
//            {
//                return;
//            }
            var view:MonsterView = new MonsterView(monster);
            _monsterItems.push(view);
			view.move(monster.sceneX * _rate + _xOffset, monster.sceneY * _rate + _yOffset);
            if (!_monsterCheckbox.selected)
            {
                return;
            }
            _itemLayer.addChild(view);
        }

        private function removeMonster(monster:BaseSceneMonsterInfo) : void
        {
            var view:MonsterView = null;
            var i:int = 0;
            while (i < _monsterItems.length)
            {
                
                if (_monsterItems[i].monsterId == monster.getObjId())
                {
					view = _monsterItems[i];
                    _monsterItems.splice(i, 1);
                    break;
                }
                i++;
            }
            if (view)
            {
				view.dispose();
            }
        }


        private function initNpc() : void
        {
            var npcInfo:NpcTemplateInfo = null;
            var view:NpcView = null;
            clearNpc();
            var npcs:Array = NpcTemplateList.sceneNpcs[_currentMapId];
            if (npcs)
            {
                for each (npcInfo in npcs)
                {
                    
					view = new NpcView(npcInfo);
                    _npcItems.push(view);
					view.move(npcInfo.sceneX * _rate + _xOffset, npcInfo.sceneY * _rate + _yOffset);
					view.addEventListener(MouseEvent.CLICK, npcClickHandler);
                    if (!_NPCCheckbox.selected)
                    {
                        return;
                    }
                    _itemLayer.addChild(view);
                }
            }
        }

        private function initDoor() : void
        {
            var doorInfo:DoorTemplateInfo = null;
            var view:DoorView = null;
            clearDoor();
            var doors:Array = DoorTemplateList.sceneDoorList[_currentMapId];
            if (doors)
            {
                for each (doorInfo in doors)
                {
					view = new DoorView(doorInfo);
					view.move(doorInfo.sceneX * _rate + _xOffset, doorInfo.sceneY * _rate + _yOffset);
					view.addEventListener(MouseEvent.CLICK, doorClickHandler);
                    _itemLayer.addChild(view);
                    _doorItems.push(view);
                }
            }
        }

        private function npcClickHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            var view:NpcView = event.currentTarget as NpcView;
            doWalk(view.getSceneX(), view.getSceneY(), view.x, view.y);
        }

        private function doorClickHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            var view:DoorView = event.currentTarget as DoorView;
            doWalk(view.getSceneX(), view.getSceneY(), view.x, view.y);
        }

        private function clickHandler(event:MouseEvent) : void
        {
            if (!_currentSceneMapInfo)
            {
                return;
            }
//            if (!GlobalData.isInCruise)
//            {
//            }
//            if (GlobalData.isInWedding)
//            {
//                return;
//            }
//            if (GlobalData.selfPlayer.isMountSecond())
//            {
//                return;
//            }
            var vx:int = event.localX / _clickLayer.width * _currentSceneMapInfo.width;
            var vy:int = event.localY / _clickLayer.height * _currentSceneMapInfo.height;
            doWalk(vx, vy, event.localX + _clickLayer.x, event.localY + _clickLayer.y);
        }

        private function doWalk(sceneX:int, sceneY:int, btnX:int = -1, btnY:int = -1) : void
        {
            if (sceneX <= _currentSceneMapInfo.width && sceneX > 0 && sceneY < _currentSceneMapInfo.height && sceneY > 0)
            {
                WalkChecker.doWalk(_currentMapId, new Point(sceneX, sceneY));
                _mediator.sceneInfo.playerList.self.state.setFindPath(true);
            }
            if (btnX != -1)
            {
                _transferBitmapBtn.show(_currentMapId, sceneX, sceneY, btnX, btnY);
            }
        }

        private function initMonsterPoints() : void
        {
            var montsList:Array = null;
            var _loc_2:Array = null;
            var info:MonsterTemplateInfo = null;
            var view:MonsterPointView = null;
            clearMonsterPoints();
//            if (!CopyTemplateList.isTaoyuan(GlobalData.copyEnterCountList.inCopyId))
//            {
//            }
//            if (!CopyTemplateList.isDota(GlobalData.copyEnterCountList.inCopyId))
//            {
			montsList = MonsterTemplateList.mapMonsterList[_currentMapId] ;
            if (montsList)
            {
                for each (info in montsList)
                {
					if(info.centerX !=0 && info.centerY !=0)
					{
						view = new MonsterPointView(info);
						view.move(info.centerX * _rate + _xOffset, info.centerY * _rate + _yOffset);
						_itemLayer.addChild(view);
						_monsterPointItems.push(view);
					}
                }
            }
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
//            return [];
//        }

        private function transferBitmapBtnClickHandler(event:MouseEvent) : void
        {
            _transferBitmapBtn.visible = false;
            event.stopImmediatePropagation();
            ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {sceneId:_transferBitmapBtn.mapId, target:new Point(_transferBitmapBtn.sceneX, _transferBitmapBtn.sceneY), checkItem:true, checkWalkField:true, type:4}));
        }

        private function transferOverClickHandler(event:MouseEvent) : void
        {
            TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.transferBtnTips"), null, new Rectangle(stage.mouseX, stage.mouseY));
        }

        private function transferOutClickHandler(event:MouseEvent) : void
        {
            TipsUtil.getInstance().hide();
        }

        private function quickSendHandler(event:MouseEvent) : void
        {
            var _loc_2:* = int(_sendXTextField.text);
            var _loc_3:* = int(_sendYTextField.text);
            doWalk(_loc_2, _loc_3);
        }

        public function update(times:int, dt:Number = 0.04) : void
        {
            if (_tickCount < 100)
            {
				_tickCount++;
            }
            else
            {
//                if (_mediator.sceneInfo.teamData.teamPlayers.length > 1)
//                {
//                    TeamMemberPosSocketHandler.send();
//                }
                _tickCount = 0;
            }
        }

        public function show(mapId:int = -1) : void
        {
            if (mapId == -1)
            {
                loadMap(GlobalData.currentMapId);
            }
            else
            {
                loadMap(mapId);
            }
        }

        public function hide() : void
        {
        }

        private function clearNpc() : void
        {
            var _loc_1:NpcView = null;
            if (_npcItems)
            {
                for each (_loc_1 in _npcItems)
                {
                    
                    _loc_1.removeEventListener(MouseEvent.CLICK, npcClickHandler);
                    _loc_1.dispose();
                }
                _npcItems = [];
            }
        }

        private function clearMonster() : void
        {
            var _loc_1:MonsterView = null;
            if (_monsterItems)
            {
                for each (_loc_1 in _monsterItems)
                {
                    
                    _loc_1.dispose();
                }
                _monsterItems = [];
            }
        }

        private function clearDoor() : void
        {
            var _loc_1:DoorView = null;
            if (_doorItems)
            {
                for each (_loc_1 in _doorItems)
                {
                    
                    _loc_1.removeEventListener(MouseEvent.CLICK, doorClickHandler);
                    _loc_1.dispose();
                }
                _doorItems = [];
            }
        }

        private function clearMonsterPoints() : void
        {
            var _loc_1:MonsterPointView = null;
            if (_monsterPointItems)
            {
                for each (_loc_1 in _monsterPointItems)
                {
                    
                    _loc_1.dispose();
                }
                _monsterPointItems = [];
            }
        }

        override public function dispose() : void
        {
            GlobalAPI.tickManager.removeTick(this);
            removeEvent();
            if (_mapPath != "")
            {
                GlobalAPI.loaderAPI.removeAQuote(_mapPath,picLoadComplete);
            }
            if (_mediator.sceneInfo.playerList.self)
            {
                _mediator.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.WALK_START, walkStartHandler);
                _mediator.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE, moveHandler);
            }
            if (_bg)
            {
                _bg.dispose();
                _bg = null;
            }
            if (_quickSendBtn)
            {
                _quickSendBtn.dispose();
                _quickSendBtn = null;
            }
            if (_transferBitmapBtn)
            {
                _transferBitmapBtn.dispose();
                _transferBitmapBtn = null;
            }
			if (_mapLinkPanel)
			{
				_mapLinkPanel.dispose();
				_mapLinkPanel = null;
			}
            clearPlayer();
            clearMonster();
            clearNpc();
            clearDoor();
            clearMonsterPoints();
//            clearTeamPlayer();
            _mediator = null;
            _sendXTextField = null;
            _sendYTextField = null;
            _map = null;
            _itemLayer = null;
            _clickLayer = null;
            _NPCCheckbox = null;
            _monsterCheckbox = null;
            super.dispose();
        }

    }
}
