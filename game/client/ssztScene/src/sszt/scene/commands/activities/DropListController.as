package sszt.scene.commands.activities
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.scene.IScene;
	import sszt.scene.components.sceneObjs.BaseSceneDropObj;
	import sszt.scene.data.dropItem.DropItemInfo;
	import sszt.scene.data.dropItem.DropItemListUpdateEvent;
	import sszt.scene.data.dropItem.DropItemStateType;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerGetDropItemSocketHandler;
	
	import scene.events.BaseSceneObjectEvent;

	public class DropListController
	{
		private var _mediator:SceneMediator;
		
		private var _scene:IScene;
//		private var _dropList:Vector.<BaseSceneDropObj>;
		private var _dropList:Array;
		
		public function DropListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_dropList = new Vector.<BaseSceneDropObj>();
			_dropList = [];
			initDrops();
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.dropItemList.addEventListener(DropItemListUpdateEvent.ADD_ITEM,addItemHandler);
			_mediator.sceneInfo.dropItemList.addEventListener(DropItemListUpdateEvent.REMOVE_ITEM,removeItemHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.dropItemList.removeEventListener(DropItemListUpdateEvent.ADD_ITEM,addItemHandler);
			_mediator.sceneInfo.dropItemList.removeEventListener(DropItemListUpdateEvent.REMOVE_ITEM,removeItemHandler);
		}
		
		private function addItemHandler(evt:DropItemListUpdateEvent):void
		{
			addDrop(evt.data as DropItemInfo);
		}
		
		private function removeItemHandler(evt:DropItemListUpdateEvent):void
		{
			var obj:BaseSceneDropObj = popItemById(int(evt.data));
			if(obj)
				_scene.removeChild(obj);
		}
		
		private function popItemById(id:int):BaseSceneDropObj
		{
			for(var i:int = 0; i < _dropList.length; i++)
			{
				if(_dropList[i] && _dropList[i].getDropItemInfo().id == id)
				{
					return _dropList.splice(i,1)[0];
				}
			}
			return null;
		}
		
		private function initDrops():void
		{
			var list:Dictionary = _mediator.sceneInfo.dropItemList.list;
			for each(var i:DropItemInfo in list)
			{
				addDrop(i);
			}
		}
		
		private function addDrop(info:DropItemInfo):void
		{
			var drop:BaseSceneDropObj = new BaseSceneDropObj(info);
			_scene.addChild(drop);
			_dropList.push(drop);
//			drop.addEventListener(MouseEvent.CLICK,dropClickHandler);
			drop.addEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,dropClickHandler);
		}
		
		private function removeDrop(id:int):void
		{
			for(var i:int = 0; i < _dropList.length; i++)
			{
				if(_dropList[i].getDropItemInfo().getObjId() == id)
				{
//					_dropList[i].removeEventListener(MouseEvent.CLICK,dropClickHandler);
					_dropList[i].removeEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,dropClickHandler);
					_dropList[i].dispose();
					_dropList.splice(i,1);
					break;
				}
			}
		}
		
		private function dropClickHandler(evt:BaseSceneObjectEvent):void
		{
//			evt.stopImmediatePropagation();
			if(!GlobalData.bagInfo.getHasPos(1))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unPickUp"));
				return;
			}
			var drop:BaseSceneDropObj = evt.currentTarget as BaseSceneDropObj;
			var dropInfo:DropItemInfo = drop.getDropItemInfo();
			if(!dropInfo.canPick(_mediator.sceneInfo.teamData.teamPlayers))
			{
				//不能拾取
				return;
			}
			_mediator.walk(_mediator.sceneInfo.getSceneId(),new Point(drop.sceneX,drop.sceneY),doDrop,30);
			function doDrop():void
			{
				_mediator.pickup(dropInfo.id);
			}
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneDropObj in _dropList)
			{
				i.removeEventListener(MouseEvent.CLICK,dropClickHandler);
				i.dispose();
			}
//			_dropList = new Vector.<BaseSceneDropObj>();
			_dropList = [];
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}