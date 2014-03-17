package sszt.scene.components.target
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MTile;
	
	public class TargetFinishPanel extends Sprite
	{
		private var _tile:MTile;
		private var _itemDic:Dictionary;
		
		public function TargetFinishPanel()
		{
			super();
			initialView();
			initialEvents();
			gameSizeChangeHandler(null);
		}
		
		private function initialView():void
		{
			_tile = new MTile(289,67,1);
			_tile.setSize(289,68);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = 2;
			addChild(_tile);
			
			_itemDic = new Dictionary();
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.FINISH_TARGET,finishTarget);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAch);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.CLEAR_FINISH_TARGET,clearItem);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			_tile.move(CommonConfig.GAME_WIDTH - 290 >> 1,CommonConfig.GAME_HEIGHT-230);
		}
		
		
		private function finishTarget(evt:ModuleEvent):void
		{
			var itemInfo:TargetTemplatInfo = TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId));
			if(itemInfo.type == TargetUtils.ACH_TYPE)
			{
				var item:AchItemView = new AchItemView(itemInfo);
				_tile.appendItem(item);
				_itemDic[itemInfo.target_id] = item;
				//计时开始
				GlobalData.targetInfo.start();
			}
		}
		
		private function getAch(evt:ModuleEvent):void
		{
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.ACH_TYPE)
			{
				var item:AchItemView = _itemDic[int(evt.data.targetId)];
				if(item)
				{
					_tile.removeItem(item);
					item.dispose();
					delete _itemDic[int(evt.data.targetId)];
				}
			}
		} 
		
		private function clearItem(evt:ModuleEvent):void
		{
			if(_tile)
			{
				_tile.disposeItems();
				//计时结束
				GlobalData.targetInfo.stop();
			}
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.FINISH_TARGET,finishTarget);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAch);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.CLEAR_FINISH_TARGET,clearItem);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			_itemDic = null;
		}
	}
}