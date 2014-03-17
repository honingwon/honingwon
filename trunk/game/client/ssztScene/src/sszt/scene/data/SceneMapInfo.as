package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SceneConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.activity.BossTemplateInfoList;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.scene.IMapData;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.roles.NpcRoleInfo;
	import sszt.scene.utils.MapDataType;
	
	public class SceneMapInfo extends EventDispatcher
	{
		public var mapId:int;
//		public var mapInfo:MapTemplateInfo;
		public var name:String;
		public var width:int;
		public var height:int;
		public var gridSource:Array;
		/**
		 * 走路格子数
		 */		
		public var maxGridCountX:int,maxGridCountY:int;
		/**
		 * 服务器广播格子数
		 */		
		public var maxServerGridCountX:int,maxServerGridCountY:int;
		
//		public var npcList:Vector.<NpcRoleInfo>;
		public var npcList:Array;
		
		public function SceneMapInfo(id:int)
		{
			mapId = id;
		}
		
		public function setMapId(id:int) : void
		{
			this.mapId = id;
			GlobalData.preMapId = GlobalData.currentMapId;
			GlobalData.currentMapId = id;
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */
		public function setData(data:ByteArray):void
		{
			data.uncompress();
			data.readInt();
			name = data.readUTF();
			width = data.readInt();
			height = data.readInt();
			
			maxGridCountX = data.readShort();
			maxGridCountY = data.readShort();
			maxServerGridCountX = Math.ceil(width / SceneConfig.BROST_WIDTH);
			maxServerGridCountY = Math.ceil(height / SceneConfig.BROST_HEIGHT);
			
			var i:int = 0;
			
			gridSource = new Array();
			for(i = 0; i < maxGridCountY; i++)
			{
				for(var j:int = 0; j < maxGridCountX; j++)
				{
					gridSource[i] == null ? gridSource[i] = [] : "";
					var dd:int = data.readByte();
					gridSource[i][j] = dd;
//					gridSource[i][j] = dd == 1 ? 0 : dd == 0 ? 1 : dd;
				}
			}
			
//			npcList = new Vector.<NpcRoleInfo>();
//			var npcs:Vector.<NpcTemplateInfo> = NpcTemplateList.sceneNpcs[mapId];
			npcList = [];
			var npcs:Array = NpcTemplateList.sceneNpcs[mapId];
			for each(var m:NpcTemplateInfo in npcs)
			{
				var npc:NpcRoleInfo = new NpcRoleInfo(m);
				npcList.push(npc);
			}
			dispatchEvent(new SceneMapInfoUpdateEvent(SceneMapInfoUpdateEvent.SETDATA_COMPLETE));
		}
		
		
		public function setInfo(info:SceneMapInfo) : void
		{
			this.name = info.name;
			this.width = info.width;
			this.height = info.height;
			this.maxGridCountX = info.maxGridCountX;
			this.maxGridCountY = info.maxGridCountY;
			this.maxServerGridCountX = info.maxServerGridCountX;
			this.maxServerGridCountY = info.maxServerGridCountY;
			this.gridSource = info.gridSource;
			this.npcList = info.npcList;
			this.loadComplete();
		}
		
		public function loadComplete() : void
		{
			dispatchEvent(new SceneMapInfoUpdateEvent(SceneMapInfoUpdateEvent.SETDATA_COMPLETE));
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.MAP_ENTER, this.mapId));
		}
		
		
		public function pixelToGrid(p:Point):Point
		{
			return new Point(int(p.x / CommonConfig.GRID_SIZE),int(p.y / CommonConfig.GRID_SIZE));
		}
		
		public function getSceneMonsterIds():Array
		{
			return MonsterTemplateList.mapMonsterList[mapId];
		}
		
		public function isAlpha(sceneX:int,sceneY:int):Boolean
		{
			var p:Point = pixelToGrid(new Point(sceneX,sceneY));
			if(gridSource == null)return false;
			if(p.y >= gridSource.length || p.y < 0)return false;
			return gridSource[p.y][p.x] == MapDataType.ALPHA;
		}
		
		public function updateNpcState(npcId:int = 0):void
		{
			if(npcList == null)return; //npc 等于102112时候不处理状态
			for(var i:int = 0; i < npcList.length; i++)
			{
				npcList[i].checkNotSubmitTask();
				if(npcList[i].taskState == 0)
					npcList[i].checkCanAcceptTask();
				if(npcList[i].template.templateId == npcId && (npcList[i].taskState == 1 || npcList[i].taskState == 2) 
					&& (GlobalData.taskCallback == null) && npcId != 102112)
					dispatchEvent(new SceneMapInfoUpdateEvent(SceneMapInfoUpdateEvent.SHOW_NPC_PANEL,npcId));
			}
		}
		
		public function clear():void
		{
			gridSource = [];
//			npcList = new Vector.<NpcRoleInfo>();
			npcList = [];
		}
		
		/***********场景特殊处理************************************/
		public function isShenmoDouScene():Boolean
		{
			if(mapId == 5001)return true;
			return false;
		}
		public function isPVP():Boolean
		{
			if(mapId == 1000000)return true;
			return false;
		}
		public function isResourceWar():Boolean
		{
			if(mapId == 9000001)return true;
			return false;
		}
		//天下第一pvp地图
		public function isPVP1():Boolean
		{
			if(mapId == 9000002)return true;
			return false;
		}
		
		public function isClubPointWarScene():Boolean
		{
			if(mapId == 5002)return true;
			return false;
		}
		
		public function isCrystalWarScene():Boolean
		{
			if(mapId == 5003)return true;
			return false;
		}
		
		public function isSpaScene():Boolean
		{
			if(mapId == 7001)return true;
			return false;
		}
		
		public function isClubFire():Boolean
		{
			if(mapId == 3001)return true;
			return false;
		}
		
		/**
		 * 是否是世界boss战
		 * */
		public function isBossWar():Boolean
		{
			return BossTemplateInfoList.isWorldBossMap(mapId);
		}
		
		public function getIsSafeArea():Boolean
		{
//			if(mapId == 1001 || mapId == 1002 || mapId == 1003 || mapId == 1005 || mapId == 1015 || mapId == 1016 || mapId == 1017 || mapId == 1019 || mapId == 1020 || mapId == 7001 || mapId == 9001)
//				return true;
//			return false;
			
			if(mapId == 1021)
				return true;
			return false;
		}
		
		public function getIsCopy():Boolean
		{
			return mapId > 2000;
		}
		
		//跨服地图信息
		public function isAcrossServer():Boolean
		{
			return false;//mapId > 9000;
		}
	}
}
