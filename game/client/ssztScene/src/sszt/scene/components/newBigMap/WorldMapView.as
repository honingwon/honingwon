package sszt.scene.components.newBigMap
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.constData.SourceClearType;
    import sszt.core.data.GlobalAPI;
    import sszt.core.data.GlobalData;
    import sszt.core.utils.AssetUtil;
    import sszt.core.view.assets.AssetSource;
    import sszt.events.SceneModuleEvent;
    import sszt.interfaces.moviewrapper.IMovieWrapper;
    import sszt.module.ModuleEventDispatcher;
    import sszt.scene.components.newBigMap.items.BitmapBtn;
    import sszt.scene.components.newBigMap.items.PartnerView;
    import sszt.scene.data.TeamPlayerList;
    import sszt.scene.data.roles.TeamScenePlayerInfo;
    import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
    import sszt.scene.mediators.BigMapMediator;
    import sszt.ui.backgroundUtil.BackgroundInfo;
    import sszt.ui.backgroundUtil.BackgroundType;
    import sszt.ui.backgroundUtil.BackgroundUtils;
    import sszt.ui.container.MSprite;

    public class WorldMapView extends MSprite
    {
		private var _bg:IMovieWrapper;
        private var _mediator:BigMapMediator;
		private var _container:Sprite;
        private var _mapPoints:Array;
		private var _partnerPoints:Array;
        private var _mapIds:Array;
        private var _btns:Array;
        private var _btnClasses:Array;
        private var _worldMapPath:String = "";
        private var _worldMap:Bitmap;
        private var _myFace:MovieClip;
        private var _transBitmap:Bitmap;
		private var _partnerItemList:Array;

        public function WorldMapView(mediator:BigMapMediator)
        {
            _mediator = mediator;
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,725,395)),
			]);
			addChild(_bg as DisplayObject);
			
			_worldMap = new Bitmap();
			_worldMap.x = _worldMap.y = 2;
			addChild(_worldMap);
            _worldMapPath = GlobalAPI.pathManager.getAssetPath("bg_worldMap.jpg");
			
			_container = new Sprite();
			_container.x = 72;
			_container.y = 4;
			addChild(_container);
			
            GlobalAPI.loaderAPI.getPicFile(_worldMapPath, worldMapComplete, SourceClearType.CHANGESCENE_AND_TIME, 18000);
            _btnClasses = [
				"ssztui.scene.BgMapIconJiChengAsset", 
				"ssztui.scene.BgMapIconBaiHuaGuAsset", 
				"ssztui.scene.BgMapIconYueWangShanAsset", 
				"ssztui.scene.BgMapIconTangJiaBaoAsset", 
				"ssztui.scene.BgMapIconLuoShengHeAsset", 
				"ssztui.scene.BgMapIconWuMingCunLuoAsset", 
				"ssztui.scene.BgMapIconYuPingShanAsset", 
				"ssztui.scene.BgMapIconFengHuangShanZhuangAsset", 
				"ssztui.scene.BgMapIconCiGuangGeAsset" ,
				"ssztui.scene.BgMapIconFengDuShaAsset", 
				"ssztui.scene.BgMapIconYueXiuShanAsset", 
				"ssztui.scene.BgMapIconCanManCaoYuanAsset", 
				"ssztui.scene.BgMapIconDaLiAsset",
				"ssztui.scene.BgMapIconTianShanAsset"
			];
			_mapPoints = [
				//京城
				new Point(260,160),
				//百花谷
				new Point(114,250), 
				//岳王山
				new Point(148,161), 
				//唐家堡
				new Point(36,186),
				//罗生河
				new Point(215,214), 
				//无名村落
				new Point(229,83),
				//玉屏山
				new Point(379,203),
				//凤凰山庄
				new Point(205,286),
				//慈光阁
				new Point(333,285),
				//风沙渡
				new Point(139,73), 
				//越秀山
				new Point(389,59),
				//苍茫草原
				new Point(281,37),
				//大理
				new Point(63,311),
				//天山
				new Point(59,35)
				
			];
			
			_partnerPoints = [
				new Point(40,25),
				new Point(45,40),
				new Point(60,35),
				new Point(55,20)
				
			];
			
            _mapIds = [1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032];
            _btns = [];
            var i:int = 0;
			var btn:BitmapBtn = null;
            while (i < _btnClasses.length)
            {
				btn = new BitmapBtn(_btnClasses[i], _mapIds[i]);
				btn.move(_mapPoints[i].x, _mapPoints[i].y);
				btn.buttonMode = true;
				_container.addChild(btn);
                _btns.push(btn);
                i++;
            }
            _transBitmap = new Bitmap(AssetSource.getTransferShoes());
            _transBitmap.visible = false;
			_container.addChild(_transBitmap);
//            _myFace = new Bitmap(CurrentMapView.playerPointAsset);
			_myFace = AssetUtil.getAsset("ssztui.scene.BigmapLittleMeAsset", MovieClip) as MovieClip;
			_container.addChild(_myFace);
            changeSceneHandler(null);
			initPartner();
			initEvent();
        }		
		
		private function getMapPointIndex(mapID:int):int
		{
			var r:int = 0;
			switch (mapID)
			{
				case 1021:
					r = 0; break;
				case 1022: 
					r = 1; break;
				case 1023: 
					r = 2; break;
				case 1024: 
					r = 3; break;
				case 1025:
				case 251:
				case 252:
					r = 4; break;
				case 1026: 
				case 261:
				case 262:
					r = 5; break;
				case 1027: 
				case 271:
				case 272:
					r = 6; break;
				case 1028:
				case 281:
					r = 7; break;
				case 1029: 
				case 291:
					r = 8; break;
				case 1030: 
					r = 9; break;
				case 1031: 
					r = 10; break;
			}
			return r;
		}
		
		private function initPartner():void
		{
			for each(var p:PartnerView in _partnerItemList)
			{
				p.dispose();
			}
			_partnerItemList = [];
			for(var i:int = 0;i<4;i++)
			{
				var partnerItem:PartnerView = new PartnerView();
				_container.addChild(partnerItem);
				partnerItem.visible = false;
				_partnerItemList.push(partnerItem);
			}
		}

        private function worldMapComplete(data:BitmapData) : void
        {
            if (!_mediator)
            {
                return;
            }
            _worldMap.bitmapData = data;
        }

        public function hide() : void
        {
        }

        public function show() : void
        {
        }

        private function initEvent() : void
        {
            var btn:BitmapBtn = null;
            for each (btn in _btns)
            {
                
				btn.addEventListener(MouseEvent.CLICK, btnClickHandle);
            }
            ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_PARTNER_POSITION, partnerPositionUpdateHandler);
        }

        private function removeEvent() : void
        {
            var btn:BitmapBtn = null;
            for each (btn in _btns)
            {
                
				btn.removeEventListener(MouseEvent.CLICK, btnClickHandle);
            }
            ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE, changeSceneHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_PARTNER_POSITION, partnerPositionUpdateHandler);
        }

		private function partnerPositionUpdateHandler(event:SceneTeamPlayerListUpdateEvent) : void
		{
			var i:int = 0;
			var partner:TeamScenePlayerInfo;
			var partnerItem:PartnerView;
			var teamPlayerList:TeamPlayerList = _mediator.sceneInfo.teamData;
			for each(partner in teamPlayerList.teamPlayers)
			{
				var index:int = getMapPointIndex(partner.mapID);//地图中列表的位置
				if(partner != teamPlayerList.self && index != -1)
				{
					partnerItem = _partnerItemList[i];
					partnerItem.visible = true;
					partnerItem.setName(partner.getName());
					partnerItem.x = _mapPoints[index].x	+ _partnerPoints[i].x;
					partnerItem.y = _mapPoints[index].y	+ _partnerPoints[i].y;
					i++;
				}
			}
			for(i;i<4;i++)
			{
				partnerItem = _partnerItemList[i];
				partnerItem.visible = false;
			}
		}
		
        private function changeSceneHandler(event:SceneModuleEvent) : void
        {
            var i:int = getMapPointIndex(GlobalData.currentMapId);
            _myFace.x = _mapPoints[i].x + 50;
            _myFace.y = _mapPoints[i].y + 30;
        }

        private function btnClickHandle(event:MouseEvent) : void
        {
            var btn:BitmapBtn = event.currentTarget as BitmapBtn;
//            if (isCloseMap(_loc_3))
//            {
//                QuickTips.show(LanguageManager.getWord("mhsm.scene.mapClose"));
//                return;
//            }
            _mediator.sceneInfo.bigmapSelectedChange(btn.mapId);
        }

//        private function isCloseMap(mapId:int) : Boolean
//        {
//            if (mapId != 1009)
//            {
//            }
//            if (mapId == 1017)
//            {
//                return true;
//            }
//            return false;
//        }

        override public function dispose() : void
        {
            GlobalAPI.loaderAPI.removeAQuote(_worldMapPath,worldMapComplete);
            removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
            _mediator = null;
            super.dispose();
        }

    }
}
