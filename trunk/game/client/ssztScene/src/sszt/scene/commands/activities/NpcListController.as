package sszt.scene.commands.activities
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.interfaces.scene.IScene;
	import sszt.scene.components.sceneObjs.BaseSceneNpc;
	import sszt.scene.data.SceneMapInfoUpdateEvent;
	import sszt.scene.data.roles.NpcRoleInfo;
	import sszt.scene.mediators.SceneMediator;
	
	import scene.events.BaseSceneObjectEvent;

	public class NpcListController
	{
		private var _mediator:SceneMediator;
		private var _scene:IScene;
		
		private var _npcList:Array;
		
		public function NpcListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_npcList = [];
			if(_mediator.sceneInfo.mapInfo.npcList != null)
				setDataCompleteHandler(null);
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.mapInfo.addEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
			_mediator.sceneInfo.mapInfo.addEventListener(SceneMapInfoUpdateEvent.SHOW_NPC_PANEL,showNpcPanelHandler);
		}
		private function removeEvent():void
		{
			_mediator.sceneInfo.mapInfo.removeEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
			_mediator.sceneInfo.mapInfo.removeEventListener(SceneMapInfoUpdateEvent.SHOW_NPC_PANEL,showNpcPanelHandler);
		}
		
		private function setDataCompleteHandler(evt:SceneMapInfoUpdateEvent):void
		{
			clear();
			var list:Array = _mediator.sceneInfo.mapInfo.npcList;
			for each(var i:NpcRoleInfo in list)
			{
				var npc:BaseSceneNpc = new BaseSceneNpc(i);
				_scene.addChild(npc);
				_npcList.push(npc);
//				npc.addEventListener(MouseEvent.CLICK,npcClickHandler);
				npc.addEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,npcClickHandler);
			}
		}
		
		private function showNpcPanelHandler(e:SceneMapInfoUpdateEvent):void
		{
			var npcId:int = e.data as int;
			_mediator.showNpcPanel(npcId);
		}
		
		private function npcClickHandler(evt:BaseSceneObjectEvent):void
		{
//			evt.stopImmediatePropagation();
			var npc:BaseSceneNpc = evt.currentTarget as BaseSceneNpc;
			_mediator.walkToNpc(npc.getNpcTempalte().templateId);
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneNpc in _npcList)
			{
//				i.removeEventListener(MouseEvent.CLICK,npcClickHandler);
				i.removeEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,npcClickHandler);
				i.dispose();
			}
			_npcList = [];
		}
	}
}