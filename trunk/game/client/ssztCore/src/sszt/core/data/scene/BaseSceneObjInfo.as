package sszt.core.data.scene
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.utils.LineUtils;
	
	public class BaseSceneObjInfo extends EventDispatcher
	{
		private var _sceneX:Number;
		private var _sceneY:Number;
		protected var _walkComplete:Function;
		
		private var _selected:Boolean;
		
		/**
		 * 移动状态
		 * 站立，移动，打坐
		 */		
		private var _moveType:int;
		/**
		 * 是否在安全区
		 */		
		private var _isInSafe:Boolean;
		
		protected var _path:Array;
		public var dir:int; 
		
		public function BaseSceneObjInfo()
		{
			dir = 0;
		}
		
		
		/********移动状态**************************************************/
		public function get moveType():int
		{
			return _moveType;
		}
		public function set moveType(value:int):void
		{
			if(_moveType == value)return;
			_moveType = value;
			dispatchEvent(new BaseSceneObjInfoUpdateEvent(BaseSceneObjInfoUpdateEvent.MOVETYPE_UPDATE));
		}
		public function setMoving():void
		{
			moveType = MoveType.WALK;
		}
		public function setStand():void
		{
			moveType = MoveType.STAND;
		}
		/**********************************************************/
		
		/**
		 * 
		 * @param path
		 * @param walkComplete
		 * @param stopAtDistance
		 * @param allPath是否自动截路径
		 * 
		 */		
		public function setPath(path:Array,walkComplete:Function = null,stopAtDistance:Number = 0,allPath:Boolean = false):void
		{
			if(!allPath)
			{
				_path = LineUtils.checkPath(path,new Point(sceneX,sceneY));
			}
			else
			{
				_path = path;
			}
			_walkComplete = walkComplete;
			dispatchEvent(new BaseSceneObjInfoUpdateEvent(BaseSceneObjInfoUpdateEvent.WALK_START,{path:_path,walkComplete:walkComplete,stopAtDistance:stopAtDistance}));
			startWalk();
		}
		
		protected function startWalk():void
		{
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			dispatchEvent(new BaseSceneObjInfoUpdateEvent(BaseSceneObjInfoUpdateEvent.SELECTED_CHANGE));
		}
		
		public function get sceneX():Number
		{
			return _sceneX;
		}
		
		public function get sceneY():Number
		{
			return _sceneY;
		}
		
		
		public function setScenePos(x:Number,y:Number):void
		{
			_sceneX = int(x);
			_sceneY = int(y);
			dispatchEvent(new BaseSceneObjInfoUpdateEvent(BaseSceneObjInfoUpdateEvent.MOVE));
		}
		
		public function setScenePosWhitoutDispath(x:Number,y:Number):void
		{
			_sceneX = x;
			_sceneY = y;
		}
		
		public function get isInSafe():Boolean
		{
			return _isInSafe;
		}
		public function set isInSafe(value:Boolean):void
		{
			if(_isInSafe == value)return;
			_isInSafe = value;
		}
		
		public function get path():Array
		{
			return _path;
		}
		
		public function set path(value:Array):void
		{
			_path = value;
		}

		
		public function getCanAttack():Boolean
		{
			if(!MapElementType.attackAble(getObjType()))return false;
			return true;
		}
		
		/**
		 * 从场景上删除
		 * 
		 */		
		public function sceneRemove():void
		{
			dispatchEvent(new BaseSceneObjInfoUpdateEvent(BaseSceneObjInfoUpdateEvent.SCENEREMOVE));
		}
		
		public function getDistance(targetPos:Point):Number
		{
			return Point.distance(targetPos,new Point(sceneX,sceneY));
		}
		
		/**
		 * 子类重载
		 * @return 
		 * 
		 */		
		public function getObjType():int{return 0;}
		public function getObjId():Number{return 0;}
		public function getServerId():int{return 0;}
		public function getName():String{return "";}
		public function setName(name:String):void{}
		public function getLevel():int{return 0;}

		public function dispose():void
		{
			_walkComplete = null;
		}
	}
}