package sszt.scene.commands.activities
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import scene.events.BaseSceneObjectEvent;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.scene.IScene;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.sceneObjs.BaseSceneCollect;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.data.collects.CollectItemListUpdateEvent;
	import sszt.scene.mediators.SceneMediator;

	public class CollectListController
	{
		private var _mediator:SceneMediator;
		
		private var _scene:IScene;
		private var _collectList:Array;
		
		public function CollectListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
			_collectList = [];
			initCollects();
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.collectList.addEventListener(CollectItemListUpdateEvent.ADD_ITEM,addItemHandler);
			_mediator.sceneInfo.collectList.addEventListener(CollectItemListUpdateEvent.REMOVE_ITEM,removeItemHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.collectList.removeEventListener(CollectItemListUpdateEvent.ADD_ITEM,addItemHandler);
			_mediator.sceneInfo.collectList.removeEventListener(CollectItemListUpdateEvent.REMOVE_ITEM,removeItemHandler);
		}
		
		private function addItemHandler(evt:CollectItemListUpdateEvent):void
		{
			addCollect(evt.data as CollectItemInfo);
		}
		
		private function removeItemHandler(evt:CollectItemListUpdateEvent):void
		{
			var obj:BaseSceneCollect = popItemById(int(evt.data));
			if(obj)
			{
				if(evt.playRemoveEffect)
				{
					var deadEffect:BaseLoadEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.DEAD_EFFECT));
					deadEffect.move(evt.itemX,evt.itemY);
					deadEffect.play(SourceClearType.NEVER);
					_scene.addEffect(deadEffect);					
				}
				_scene.removeChild(obj);
			}
		}
		
		private function popItemById(id:int):BaseSceneCollect
		{
			for(var i:int = 0; i < _collectList.length; i++)
			{
				if(_collectList[i] && _collectList[i].getCollectItemInfo().id == id)
				{
					return _collectList.splice(i,1)[0];					
				}
			}
			return null;
		}
		
		private function initCollects():void
		{
			var list:Dictionary = _mediator.sceneInfo.collectList.list;
			for each(var i:CollectItemInfo in list)
			{
				addCollect(i);
			}
		}
		
		private function addCollect(info:CollectItemInfo):void
		{
			var collect:BaseSceneCollect = new BaseSceneCollect(info);
			_scene.addChild(collect);
			_collectList.push(collect);
//			collect.addEventListener(MouseEvent.CLICK,collectClickHandler);
			collect.addEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,collectClickHandler);
		}
		
		private function removeCollect(id:int):void
		{
			for(var i:int = 0; i < _collectList.length; i++)
			{
				if(_collectList[i].getCollectItemInfo().getObjId() == id)
				{
//					_collectList[i].removeEventListener(MouseEvent.CLICK,collectClickHandler);
					_collectList[i].removeEventListener(BaseSceneObjectEvent.SCENEOBJ_CLICK,collectClickHandler);
					_collectList[i].dispose();
					_collectList.splice(i,1);
					break;
				}
			}
		}
		
//		private function collectClickHandler(evt:MouseEvent):void
		private function collectClickHandler(evt:BaseSceneObjectEvent):void
		{
//			evt.stopImmediatePropagation();
			var collect:BaseSceneCollect = evt.currentTarget as BaseSceneCollect;
			var collectInfo:CollectItemInfo = collect.getCollectItemInfo();
			var collectId:int = collectInfo.id;
			if(!collectInfo.canCollect())
			{
				//不能采集
				return;
			}
			GlobalData.collectTarget = collectInfo.templateId;
			collectInfo = null;
//			_mediator.sceneInfo.playerList.self.setCollectState();
			
			WalkChecker.doWalkToCollect(collectId,collect.sceneX,collect.sceneY);
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneCollect in _collectList)
			{
				i.removeEventListener(MouseEvent.CLICK,collectClickHandler);
				i.dispose();
			}
			_collectList = [];
		}
	}
}