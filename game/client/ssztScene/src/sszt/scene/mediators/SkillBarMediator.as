package sszt.scene.mediators
{
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.skill.PlayerDragSkillSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.skillBar.SkillBarView;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class SkillBarMediator extends Mediator
	{
		public static const NAME:String = "SkillBarMediator";
		
		public function SkillBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_MEDIATOR_START,
				SceneMediatorEvent.SCENE_MEDIATOR_APPLYSKILLBAR,
				SceneMediatorEvent.SHOW_DEATH_TIP,
				SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_MEDIATOR_START:
					initView();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE:
					dispose();
					break;
				case SceneMediatorEvent.SCENE_MEDIATOR_APPLYSKILLBAR:
					applySkill(int(notification.getBody()));
					break;
				case SceneMediatorEvent.SHOW_DEATH_TIP:
					showDeathTip();
					break;
			}
		}
		
		private function showDeathTip():void
		{
			if(sceneModule.skillBar)
			{
				sceneModule.skillBar.showDeathTip();
			}
		}
		
		private function initView():void
		{
			if(sceneModule.skillBar == null)
			{
				sceneModule.skillBar = new SkillBarView(this);
				GlobalAPI.layerManager.getPopLayer().addChild(sceneModule.skillBar);
			}
		}
		
		public function attack(skill:SkillItemInfo):void
		{
			if(!sceneModule.sceneInfo.playerList.self)return;
			if(sceneModule.sceneInfo.playerList.self.getIsDeadOrDizzy() )
			{
				sceneModule.addEventList(LanguageManager.getWord("ssztl.scene.unOperateInHitDownState"));
				return;
			}
//			if(skill.templateId != GlobalData.skillInfo.getDefaultSkill().templateId)
//			{
//				if(GlobalData.bagInfo.getItem(3) == null || GlobalData.bagInfo.getItem(3).template.categoryId != skill.getTemplate().activeItemCategoryId)
//				{
//					QuickTips.show(LanguageManager.getWord("ssztl.common.skillNeedWeaponType",CategoryType.getNameByType(skill.getTemplate().activeItemCategoryId)));
//					return;;
//				}
//			}
			if(int(skill.getTemplate().activeUseMp[skill.level - 1]) > GlobalData.selfPlayer.currentMP)
			{
				sceneModule.addEventList(LanguageManager.getWord("ssztl.common.MpNotEnough"));
				return;
			}
			if((GlobalData.systemDate.getSystemDate().getTime() - skill.lastUseTime) < (int(skill.getTemplate().coldDownTime[skill.level - 1]) + 200))
			{
				sceneModule.addEventList(LanguageManager.getWord("ssztl.scene.skillColdDown"));
				return;
			}
			sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SENDATTACK,skill);
		}
		
		public function useItem(templateId:int):void
		{
			if(!sceneModule || !sceneModule.sceneInfo || !sceneModule.sceneInfo.playerList || !sceneModule.sceneInfo.playerList.self)return;
			if(sceneModule.sceneInfo.playerList.self.getIsDeadOrDizzy())
			{
				sceneModule.addEventList(LanguageManager.getWord("ssztl.scene.unOperateInHitDownState"));
				return;
			}
			var template:ItemTemplateInfo = ItemTemplateList.getTemplate(templateId);
			if(template.needLevel > GlobalData.selfPlayer.level)
			{
				sceneModule.addEventList(LanguageManager.getWord("ssztl.common.levelNotEnough"));
				return;
			}
			if(CategoryType.isHpDrup(template.categoryId))
			{
				if(GlobalData.lastUseTime_hp != 0 && (getTimer() - GlobalData.lastUseTime_hp < template.cd))
				{
					sceneModule.addEventList(LanguageManager.getWord("ssztl.core.unColdDown"));
					return;
				}
				GlobalData.lastUseTime_hp = getTimer();
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPDATE_ITEM_CD,1));
			}
			else if(CategoryType.isMpDrup(template.categoryId))
			{
				if(GlobalData.lastUseTime_mp != 0 && (getTimer() - GlobalData.lastUseTime_mp < template.cd))
				{
					sceneModule.addEventList(LanguageManager.getWord("ssztl.core.unColdDown"));
					return;
				}
				GlobalData.lastUseTime_mp = getTimer();
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPDATE_ITEM_CD,2));
			}
			var list:Array = GlobalData.bagInfo.getItemById(templateId);
			var place:int = -1;
			for each(var info:ItemInfo in list)
			{
				if(info.isBind)
				{
					place = info.place;
					break;
				}
			}
			if(place == -1)
			{
				place = list[0].place;
			}
			ItemUseSocketHandler.sendItemUse(place);
		}
		
		public function dragItem(type:int,id:int,fromPlace:int,toPlace:int):void
		{
			PlayerDragSkillSocketHandler.send(type,id,fromPlace,toPlace);
		}
		
		private function applySkill(index:int):void
		{
			if(sceneModule.skillBar != null)
			{
				sceneModule.skillBar.applyItem(index);
			}
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}