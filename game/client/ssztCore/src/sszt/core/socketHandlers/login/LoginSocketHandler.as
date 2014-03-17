package sszt.core.socketHandlers.login
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.CarInfo;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.PkgRecord;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.characterActionInfos.SceneCarActionInfo;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.characterActionInfos.SceneMountsActionInfo;
	import sszt.core.data.characterActionInfos.ScenePetCharacterActions;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.FaceManager;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.proxy.KeyboardProxy;
	import sszt.core.proxy.LoadLoginDataProxy;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.scene.MapEnterSocketHandler;
	import sszt.core.utils.GCUtil;
	import sszt.core.utils.Geometry;
	import sszt.core.utils.PackageUtil;
	import sszt.core.utils.RotateUtils;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.effects.BaseLoadEffectPool;
	import sszt.core.view.effects.BaseLoadMoveEffect;
	import sszt.core.view.prompt.PromptPanel;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.events.ChatModuleEvent;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	
	public class LoginSocketHandler extends BaseSocketHandler
	{
		public function LoginSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.LOGIN;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer = new SelfPlayerInfo();
			GlobalData.selfPlayer.userId = _data.readNumber();
			
//			GlobalData.selfPlayer.vipLastGetAwardDate = _data.readDate();
			PackageUtil.readSelfPlayer(GlobalData.selfPlayer,_data);
			
			MapEnterSocketHandler.sendMapEnter(-1);
			SkillTemplateList.setCareerList();
			KeyboardProxy.setup();
			PromptPanel.getInstance();
			
			
			
//			GlobalAPI.layerManager.getTipLayer().stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
			
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(1001),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
			
			
//			var t:Timer = new Timer(4);
//			t.addEventListener(TimerEvent.TIMER,memberTest2);
//			t.start();
			
//			var tt:Timer = new Timer(30000);
//			tt.addEventListener(TimerEvent.TIMER,ttTimerHandler);
//			tt.start();
			
			
			
//			var start:Point = new Point(100,400);
//			var end:Point = new Point(50,200);
//			var startIcon:Shape = new Shape();
//			startIcon.graphics.beginFill(0xff0000);
//			startIcon.graphics.drawRect(0,0,5,5);
//			startIcon.graphics.endFill();
//			startIcon.x = start.x;
//			startIcon.y = start.y;
//			GlobalAPI.layerManager.getTipLayer().addChild(startIcon);
//			var endIcon:Shape = new Shape();
//			endIcon.graphics.beginFill(0xff0000);
//			endIcon.graphics.drawRect(0,0,5,5);
//			endIcon.graphics.endFill();
//			endIcon.x = end.x;
//			endIcon.y = end.y;
//			GlobalAPI.layerManager.getTipLayer().addChild(endIcon);
//			
//			GlobalAPI.layerManager.getTipLayer().stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
//			function clickHandler(evt:MouseEvent):void
//			{
//				c.dispose();
//				c = null;
				
//				var t:MovieTemplateInfo = new MovieTemplateInfo();
//				t.id = 1;
//				t.frames = [0];
////				t.xoffset = -100;
////				t.yoffset = -17;
//				t.picPath = "20016";
//				t.count = 1;
//				t.addMode = 1;
//				t.time = 1000000;
//				var tt:BaseLoadMoveEffect = new BaseLoadMoveEffect(t,Point.distance(start,end));
//				
//				var pp:Sprite = new Sprite();
//				pp.addChild(tt);
//				pp.x = start.x - 15;
//				pp.y = start.y - 17;
//				
//				var angle:int = Geometry.getDegrees(start,end);
//				RotateUtils.setRotation(pp,new Point(start.x,start.y),angle);
//				GlobalAPI.layerManager.getPopLayer().addChild(pp);
//				tt.play(SourceClearType.NEVER);
//			}
			
//			var timeEffect:TimerEffect = new TimerEffect(10000,new Rectangle(0,0,100,100));
//			GlobalAPI.layerManager.getPopLayer().addChild(timeEffect);
//			
//			timeEffect.begin();
//			
//			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
//			function clickHandler(evt:MouseEvent):void
//			{
//				timeEffect.setTime(10000);
//				timeEffect.begin();
//			}
						
			handComplete();
		}
		
		private var _movieList:Array = [];
		private function memberTest2(evt:TimerEvent):void
		{
			var id:int = int(Math.random() * 30);
			(id == 16 || id == 17 || id == 0) ? id = 19 : "";
			id += 20000;
			var info:MovieTemplateInfo = MovieTemplateList.getMovie(id);
			var t:BaseLoadEffect = new BaseLoadEffect(info);
			t.play(SourceClearType.IMMEDIAT);
			t.move(Math.random() * 600 + 200,Math.random() * 300 + 200);
			GlobalAPI.layerManager.getTipLayer().addChild(t as DisplayObject);
			_movieList.push(t);
			if(_movieList.length > 50)
			{
				var m:BaseLoadEffect = _movieList.shift();
				m.dispose();
			}
		}
		
//		private var _effectList:Array = [];
		private var _characterList:Array = [];
		private var _count:int = 0;
		private function timerHandler(evt:TimerEvent):void
		{
//			_count++;
//			if(_count > 5)
//			{
//				_count = 0;
//				var id:int = int(Math.random() * 30);
//				(id == 16 || id == 17 || id == 0) ? id = 19 : "";
//				id += 20000;
//				var info:MovieTemplateInfo = MovieTemplateList.getMovie(id);
//				var t:BaseLoadEffect = new BaseLoadEffect(info);
//				t.play(SourceClearType.CHANGE_SCENE);
//				t.move(Math.random() * 600 + 200,Math.random() * 300 + 200);
//				GlobalAPI.layerManager.getTipLayer().addChild(t as DisplayObject);
//			}
//			var c:ICharacter;
//			var rnd:Number = Math.random();
//			if(rnd > 0.3)
//			{
//				c = GlobalAPI.characterManager.createMountsChatacter(GlobalData.selfPlayer);
//				if(Math.random() > 0.5)
//				{
//					c.doAction(SceneMountsActionInfo.WALK);
//				}
//			}
//			else if(rnd > 0.7)
//			{
//				c = GlobalAPI.characterManager.createSceneCharacter(GlobalData.selfPlayer);
//				if(Math.random() > 0.5)
//				{
//					c.doAction(SceneCharacterActions.WALK);
//				}
//			}
//			else
//			{
//				c = GlobalAPI.characterManager.createSceneSitCharacter(GlobalData.selfPlayer);
//			}
//			c.show(DirectType.getRandomDir());
//			c.move(Math.random() * 800 - 100,Math.random() * 500 - 100);
//			GlobalAPI.layerManager.getTipLayer().addChild(c as DisplayObject);
//			_characterList.push(c);
//			if(_characterList.length > 200)
//			{
//				var m:ICharacter = _characterList.shift();
//				m.dispose();
//			}
			
//			var loader:ILoader = GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getScenePreMapPath(id),mapPreLoadComplete,3);
//			loader.loadSync();
			
//			var map:BitmapData = GlobalAPI.loaderAPI.getObjectByClassPath(GlobalAPI.pathManager.getScenePreMapClassPath(1001)) as BitmapData;
//			var t:Bitmap = new Bitmap(map);
//			t.x = Math.random() * 500;
//			t.y = Math.random() * 300;
//			GlobalAPI.layerManager.getTipLayer().addChild(t);
//			_mapList.push(t);
//			if(_mapList.length > 200)
//			{
//				var m:Bitmap = _mapList.shift();
//				m.parent.removeChild(m);
//				m.bitmapData.dispose();
//			}
		}
		
		private var _mapList:Array = [];
		private function mapPreLoadComplete(loader:ILoader):void
		{
			trace("preComplete");
//			loader.dispose();
		}
		private function needMapLoadComplete(loader:ILoader):void
		{
			trace("needComplete");
//			loader.dispose();
		}
		
		private function ttTimerHandler(evt:TimerEvent):void
		{
			GCUtil.gc();
//			trace("gc");
		}
		
		
		public function stageClickHandler(evt:MouseEvent):void
		{
//			GCUtil.gc();
//			panelTest();
			systemMessTest();
		}
		
		private function systemMessTest():void
		{
			var itemInfo:ChatItemInfo = new ChatItemInfo();
			itemInfo.type = MessageType.SYSTEM;
			itemInfo.fromNick = "";
			itemInfo.fromId = 0;
			itemInfo.fromSex = 0;
			itemInfo.toNick = "";
			itemInfo.toId = 0;
			itemInfo.message = "asdasdasdasdasdasdasdyuasidyasuoyduasyduiasyduiasoydouid" + Math.random();
			ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.APPEND_MESSAGE,itemInfo));
		}
		
		private function panelTest():void
		{
			if(_list.length == 0)
			{
				for(var i:int = 0; i < 10; i++)
				{
					var p:TestPanel = new TestPanel();
					GlobalAPI.layerManager.addPanel(p);
					_list.push(p);
				}
			}
			else
			{
				for each(var j:TestPanel in _list)
				{
					if(j)j.dispose();
				}
				_list.length = 0;
//				GCUtil.gc();
			}
		}
		
		private var _list:Array = [];
		private function memberTest():void
		{
			if(_list && _list.length == 0)
			{
				var i:int = 101;
				for(i = 101; i < 113; i++)
				{
					GlobalAPI.loaderAPI.getPackageFile(GlobalAPI.pathManager.getMoviePath(String(i)),loadComplete,SourceClearType.CHANGE_SCENE);
				}
				for(i = 10001; i < 10006; i++)
				{
					GlobalAPI.loaderAPI.getPackageFile(GlobalAPI.pathManager.getMoviePath(String(i)),loadComplete,SourceClearType.CHANGE_SCENE);
				}
				for(i = 20001; i < 20039; i++)
				{
					if(i != 20033)
						GlobalAPI.loaderAPI.getPackageFile(GlobalAPI.pathManager.getMoviePath(String(i)),loadComplete,SourceClearType.CHANGE_SCENE);
				}
				_list = null;
			}
			else
			{
				GlobalAPI.loaderAPI.changeSceneClear();
				_list = null;
				GCUtil.gc();
			}
			
			function loadCompelteHandler(evt:Event):void{}
			
			function loadComplete(data:Object):void
			{
				trace(0);
			}
		}
		
		public static function sendLogin():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.LOGIN);
			pkg.writeInt(CommonConfig.PROTOCOLKEY);
			pkg.writeNumber(GlobalData.tmpId);
			pkg.writeInt(GlobalData.version);
			pkg.writeInt(int(Math.random() * 1000));
			pkg.writeBoolean(GlobalData.isVisitor);
			if(!GlobalData.isVisitor)
			{
				pkg.writeString(GlobalData.tmpUserName);
				pkg.writeString(GlobalData.tmpSite);
				pkg.writeShort(GlobalData.tmpServerId);
				pkg.writeString(GlobalData.tmpTick);
				pkg.writeString(GlobalData.tmpSign);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}