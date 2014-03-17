package sszt.scene.actions
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.DirectType;
	import sszt.constData.LayerIndex;
	import sszt.constData.SceneConfig;
	import sszt.core.action.BaseAction;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.utils.Geometry;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.socketHandlers.PlayerMoveStepSocketHandler;
	
	public class CharacterWalkActionII extends BaseAction
	{
//		private var _player:BaseRole;
		private var _player:BaseRoleInfo;
		private var _path:Array;
		private var _currentPos:Point;
		private var _nextPos:Point;
		private var _walkComplete:Function;
		private var _lastSendPos:int;
		private var _isSelf:Boolean;
		private var _currentAngle:Number;
		private var _isComplete:Boolean;
		private var _pathLen:int;
		
//		private var _tmpDir:int;
//		private var _tmpX:Number;
//		private var _tmpY:Number;
		
		public function CharacterWalkActionII()
		{
			super(0);
		}
		public function setPlayer(player:BaseRoleInfo):void
		{
			_player = player;
			_isSelf = player.getObjId() == GlobalData.selfPlayer.userId;
		}
		public function setWalkComplete(walkComplete:Function):void
		{
			_walkComplete = walkComplete;
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			var complete:Boolean = false;
			var sendSync:Array = [];
			//执行次数
			var round:int = (times <= 2) ? times : 1;
			//速度倍数
			var speedTimes:Number = round == 1 ? (dt / 40) : 1;
			var t:Object;
			if(dt > 55)
			{
				t = walkAStep(dt / 40);
			}
			else 
			{
				t = walkAStep(1);
			}
			if(t)
			{
				if(t["shouldSendSync"].length > 0)
				{
					var tx:int = 0;
					var ty:int = 0;
					for(var j:int = 0; j < t["shouldSendSync"].length; j++)
					{
						if(tx == int(t["shouldSendSync"][j].x) && ty == int(t["shouldSendSync"][j].y))continue;
						tx = int(t["shouldSendSync"][j].x);
						ty = int(t["shouldSendSync"][j].y);
						PlayerMoveStepSocketHandler.send(t["shouldSendSync"][j].x,t["shouldSendSync"][j].y,t["currentIndex"][j]);
					}
				}
				if(t["complete"])complete = true;
			}
			
//			for(var i:int = 0; i < round; i++)
//			{
//				var t:Object = walkAStep(speedTimes);
//				if(t)
//				{
////					if(t["shouldSendSync"] != null)
////					{
////						PlayerMoveStepSocketHandler.send(t["shouldSendSync"].x,t["shouldSendSync"].y,t["currentIndex"]);
////					}
//					if(t["shouldSendSync"].length > 0)
//					{
//						var tx:int = 0;
//						var ty:int = 0;
//						for(var j:int = 0; j < t["shouldSendSync"].length; j++)
//						{
//							if(tx == int(t["shouldSendSync"][j].x) && ty == int(t["shouldSendSync"][j].y))continue;
//							tx = int(t["shouldSendSync"][j].x);
//							ty = int(t["shouldSendSync"][j].y);
//							PlayerMoveStepSocketHandler.send(t["shouldSendSync"][j].x,t["shouldSendSync"][j].y,t["currentIndex"][j]);
//						}
//					}
//					if(t["complete"])complete = true;
//				}
//			}
			if(complete)
			{
				walkComplete();
			}
		}
		
		override public function configure(...args):void
		{
			_path = (args[0] as Array).slice();
			if(_path.length == 0)
			{
				walkComplete();
				return;
			}
			_pathLen = _path.length - 1;
			_isComplete = false;
			_currentPos = new Point(_player.sceneX,_player.sceneY);
			_nextPos = _path[0];
			_path.splice(0,1);
			if(_currentPos.x != _nextPos.x || _currentPos.y != _nextPos.y)
			{
				//updateDir,发事件
				_player.updateDir(DirectType.checkDir(_currentPos,_nextPos));
				_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
			}
		}
		
		private function walkAStep(speedTimes:Number):Object
		{
//			trace(speedTimes);
			if(_isComplete)return null;
//			var speed:Number = _player.speed * speedTimes;
			//发事件
			_player.doWalkAction();
			var result:Object = new Object();
			result["shouldSendSync"]  = [];
			result["currentIndex"] = [];
			var intTime:int = int(speedTimes);
			var targetPos:Point = _currentPos.clone();
			
			for(var i:int = 0; i < intTime + 1; i++)
			{
				var speed:Number = _player.speed * (i == intTime ? (speedTimes - intTime) : 1); 
				if(Point.distance(targetPos,_nextPos) <= speed)
				{
//					_player.setScenePos(_currentPos.x,_currentPos.y);
					targetPos = _nextPos;
//					_currentPos = _nextPos;
					if(_path.length == 0)
					{
						if(_isSelf)
						{
//							result["shouldSendSync"] = targetPos.clone();
//							result["currentIndex"] = _pathLen - _path.length;
							result["shouldSendSync"].push(targetPos.clone());
							result["currentIndex"].push((_pathLen - _path.length));
						}
						result["complete"] = true;
					}
					else
					{
						_nextPos = _path[0];
						_path.splice(0,1);
						//发事件
						_player.updateDir(DirectType.checkDir(_currentPos,_nextPos));
						_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
					}
				}
				else
				{
					_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
					var dx:Number = Math.cos(_currentAngle) * speed;
					var dy:Number = Math.sin(_currentAngle) * speed;
					targetPos = new Point(targetPos.x + dx,targetPos.y + dy);
//					_player.setScenePos(_currentPos.x,_currentPos.y);
				}
				if(_isSelf)
				{
					_lastSendPos += speed;
					if(_lastSendPos > CommonConfig.GRID_SIZE)
					{
						_lastSendPos = 0;
						//调用回调后不能再给服务器发同步点。避免出现转场景后还继续发点
						if(!_isComplete)
						{
//							result["shouldSendSync"] = _currentPos.clone();
//							result["currentIndex"] = _pathLen - _path.length;
							result["shouldSendSync"].push(targetPos.clone());
							result["currentIndex"].push((_pathLen - _path.length));
						}
					}
				}
			}
			_player.setScenePos(targetPos.x,targetPos.y);
			_currentPos = targetPos;
			
			
			
//			var speed:Number = _player.speed * speedTimes;
//			//发事件
//			_player.doWalkAction();
//			var result:Object = new Object();
//			if(Point.distance(_currentPos,_nextPos) <= speed)
//			{
//				_player.setScenePos(_currentPos.x,_currentPos.y);
//				_currentPos = _nextPos;
//				if(_path.length == 0)
//				{
//					if(_isSelf)
//					{
//						result["shouldSendSync"] = _currentPos.clone();
//						result["currentIndex"] = _pathLen - _path.length;
//					}
//					result["complete"] = true;
//				}
//				else
//				{
//					_nextPos = _path[0];
//					_path.splice(0,1);
//					//发事件
//					_player.updateDir(DirectType.checkDir(_currentPos,_nextPos));
//					_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
//				}
//			}
//			else
//			{
//				_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
//				var dx:Number = Math.cos(_currentAngle) * speed;
//				var dy:Number = Math.sin(_currentAngle) * speed;
//				_currentPos = new Point(_player.sceneX + dx,_player.sceneY + dy);
//				_player.setScenePos(_currentPos.x,_currentPos.y);
//			}
//			if(_isSelf)
//			{
//				_lastSendPos += speed;
//				if(_lastSendPos > CommonConfig.GRID_SIZE)
//				{
//					_lastSendPos = 0;
//					//调用回调后不能再给服务器发同步点。避免出现转场景后还继续发点
//					if(!_isComplete)
//					{
//						result["shouldSendSync"] = _currentPos.clone();
//						result["currentIndex"] = _pathLen - _path.length;
//					}
//				}
//			}
			return result;
		}
		
		public function walkStop():void
		{
			isFinished = true;
			_isComplete = true;
		}
		
		private function walkComplete():void
		{
			_isComplete = true;
			if(_walkComplete != null)
			{
				_walkComplete();
			}
		}
		
		override public function dispose():void
		{
			_player = null;
			_walkComplete = null;
			super.dispose();
		}
	}
}