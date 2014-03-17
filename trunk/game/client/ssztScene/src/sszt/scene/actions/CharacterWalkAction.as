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
	import sszt.core.utils.Geometry;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.socketHandlers.PlayerMoveStepSocketHandler;
	
	public class CharacterWalkAction extends BaseAction
	{
		private var _player:BaseRole;
		private var _path:Array;
		private var _currentPos:Point;
		private var _nextPos:Point;
		private var _walkComplete:Function;
		private var _lastSendPos:int;
		private var _isSelf:Boolean;
		private var _currentAngle:Number;
		private var _isComplete:Boolean;
		
		public function CharacterWalkAction(player:BaseRole,walkComplete:Function)
		{
			_player = player;
			_walkComplete = walkComplete;
			_isSelf = player is SelfScenePlayer;
			super(0);
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			var complete:Boolean = false;
			var sendSync:Array = [];
			for(var i:int = 0; i < times; i++)
			{
				var t:Object = walkAStep();
				if(t)
				{
					if(t["shouldSendSync"] != null)
					{
						PlayerMoveStepSocketHandler.send(t["shouldSendSync"].x,t["shouldSendSync"].y,0);
					}
					if(t["complete"])complete = true;
				}
			}
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
			_isComplete = false;
			_currentPos = new Point(_player.sceneX,_player.sceneY);
			_nextPos = _path[0];
			_path.splice(0,1);
			if(_currentPos.x != _nextPos.x || _currentPos.y != _nextPos.y)
			{
				//updateDir
				_player.updateDir(DirectType.checkDir(_currentPos,_nextPos));
				_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
			}
		}
		
		private function walkAStep():Object
		{
			if(_isComplete)return null;
			var speed:Number = _player.getBaseRoleInfo().speed;
			_player.doWalkAction();
			var result:Object = new Object();
			if(Point.distance(_currentPos,_nextPos) <= speed)
			{
				movePlayer(_nextPos);
				_currentPos = _nextPos;
				if(_path.length == 0)
				{
					if(_isSelf)
					{
//						PlayerMoveStepSocketHandler.send(_currentPos.x,_currentPos.y);
//						result["shouldSendSync"] = true;
						result["shouldSendSync"] = _currentPos.clone();
					}
					result["complete"] = true;
//					walkComplete();
				}
				else
				{
					_nextPos = _path[0];
					_path.splice(0,1);
					_player.updateDir(DirectType.checkDir(_currentPos,_nextPos));
					_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
				}
			}
			else
			{
				_currentAngle = Geometry.getRadian(_currentPos,_nextPos);
				var dx:Number = Math.cos(_currentAngle) * speed;
				var dy:Number = Math.sin(_currentAngle) * speed;
				_currentPos = new Point(_player.sceneX + dx,_player.sceneY + dy);
				movePlayer(_currentPos);
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
//						result["shouldSendSync"] = true;
//						result["shouldSendSync"].push(_currentPos);
						result["shouldSendSync"] = _currentPos.clone();
					}
				}
			}
			return result;
		}
		
		private function movePlayer(p:Point):void
		{
			if(_player.scene)
			{
				if(_isSelf)
				{
					var currentGridX:int = int(_player.sceneX / SceneConfig.BROST_WIDTH);
					var currentGridY:int = int(_player.sceneY / SceneConfig.BROST_HEIGHT);
					var nextGridX:int = int(p.x / SceneConfig.BROST_WIDTH);
					var nextGridY:int = int(p.y / SceneConfig.BROST_HEIGHT);
					if(currentGridX != nextGridX || currentGridY != nextGridY)
					{
						var sceneInfo:SceneInfo = _player.scene.mapData as SceneInfo;
						//删除怪
						sceneInfo.monsterList.removeOutBrostMonster(nextGridX,nextGridY,sceneInfo.mapInfo.maxServerGridCountX,sceneInfo.mapInfo.maxServerGridCountY);
						sceneInfo.dropItemList.removeOutBrostItem(nextGridX,nextGridY,sceneInfo.mapInfo.maxServerGridCountX,sceneInfo.mapInfo.maxServerGridCountY);
						sceneInfo.collectList.removeOutBrostItem(nextGridX,nextGridY,sceneInfo.mapInfo.maxServerGridCountX,sceneInfo.mapInfo.maxServerGridCountY);
					}
					_player.scene.getViewPort().focusPoint = new Point(_player.sceneX,_player.sceneY);
					_player.scene.mapData.dispatchRender();
				}
				_player.scene.move(_player,p);
				if((_player.scene.mapData as SceneInfo).mapInfo.isAlpha(_player.sceneX,_player.sceneY))
				{
					_player.alpha = 0.5;
				}
				else
				{
					_player.alpha = 1;
				}
			}
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