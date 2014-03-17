package sszt.scene.commands.activities
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.interfaces.scene.IScene;
	import sszt.scene.components.jumpPoints.JumpPoints;
	import sszt.scene.data.SceneMapInfoUpdateEvent;
	import sszt.scene.mediators.SceneMediator;

	public class DoorListController
	{
		private var _mediator:SceneMediator;
		private var _scene:IScene;
		
//		private var _doorList:Vector.<JumpPoints>;
		private var _doorList:Array;
		
		public function DoorListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_doorList = new Vector.<JumpPoints>();
			_doorList = [];
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.mapInfo.addEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
		}
		private function removeEvent():void
		{
			_mediator.sceneInfo.mapInfo.removeEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
		}
		
		private function setDataCompleteHandler(evt:SceneMapInfoUpdateEvent):void
		{
//			var doors:Vector.<DoorTemplateInfo> = DoorTemplateList.sceneDoorList[_mediator.sceneInfo.getSceneId()];
			var doors:Array = DoorTemplateList.sceneDoorList[_mediator.sceneInfo.getSceneId()];
			for each(var i:DoorTemplateInfo in doors)
			{
				addDoor(i);
			}
		}
		
		private function addDoor(info:DoorTemplateInfo):void
		{
			var door:JumpPoints = new JumpPoints(info);
			door.canSort = false;
			_doorList.push(door);
			_scene.addChild(door);
			door.addEventListener(MouseEvent.CLICK,doorClickHandler);
		}
		
		private function doorClickHandler(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			var door:JumpPoints = evt.currentTarget as JumpPoints;
			_mediator.walkToDoor(door.getJumpTemplate().templateId);
		}
		
		public function clear():void
		{
			for each(var i:JumpPoints in _doorList)
			{
				i.removeEventListener(MouseEvent.CLICK,doorClickHandler);
				i.dispose();
			}
			_doorList.length = 0;
		}
	}
}