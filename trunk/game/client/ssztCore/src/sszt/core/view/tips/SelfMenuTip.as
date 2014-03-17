package sszt.core.view.tips
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;

	public class SelfMenuTip extends BaseMenuTip
	{
		private var id:Number;
		private var nick:String;
		private var _autoInTeam:Boolean;
		private var _allocationType:int;
		private var _timeoutIndex:int = -1;
		private var _state:int;
	
		private static var selfMenuTip:SelfMenuTip;
		public static function getInstance():SelfMenuTip
		{
			if(selfMenuTip == null)
			{
				selfMenuTip = new SelfMenuTip();
			}
			return selfMenuTip;
		}
		/**
		 * 
		 * @param id
		 * @param nick
		 * @param state 0无队伍，1队伍普通队员，队长 
		 * @param pos 鼠标点下位置
		 * 
		 */			
		public function show(id:Number,nick:String,state:int,autoInTeam:Boolean,allocationType:int,pos:Point):void
		{
			this.id = id;
			this.nick = nick;
			_state = state;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:SelfMenuTip = this;
			function showHandler():void
			{
				if(state == 0)
				{
					setLabels(
						[LanguageManager.getWord("ssztl.common.copyName"),
						 LanguageManager.getWord("ssztl.scene.createTeam")],
						[7,9]);
					
				}
				else if(state == 1)
				{
//					setLabels(["更换头像","退出队伍","复制名称"],[1,2,8]);
					setLabels([
//						LanguageManager.getWord("ssztl.common.changeHead"),
						LanguageManager.getWord("ssztl.scene.exitTeam"),
						LanguageManager.getWord("ssztl.common.copyName")],[1,7]);
				}else if(state == 2)
				{
//					setLabels(["更换头像","退出队伍","解散队伍","队员跟随","自由拾取","自动分配","自动入队","复制名称"],[1,2,3,4,5,6,7,8]);
					setLabels([
//						LanguageManager.getWord("ssztl.common.changeHead"),
						LanguageManager.getWord("ssztl.scene.exitTeam"),
						LanguageManager.getWord("ssztl.scene.disposeTeam"),
//						LanguageManager.getWord("ssztl.common.goWithTeamPlayer"),
//						LanguageManager.getWord("ssztl.scene.autoPick"),
//						LanguageManager.getWord("ssztl.scene.autoAssign"),
						LanguageManager.getWord("ssztl.scene.autoInTeam2"),
						LanguageManager.getWord("ssztl.common.copyName")],[1,2,6,7]);
					setSelect(autoInTeam,allocationType);
					_autoInTeam = autoInTeam;
					_allocationType = allocationType;
				}
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);
				setFilter();
				setPos(pos);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function setSelect(aotuInTeam:Boolean,allocationType:int):void
		{
			if(aotuInTeam)
			{
				for(var i:int = 0;i<_menus.length;i++)
				{
					if(_menus[i].id == 6)
					{
						_menus[i].selected = true;
					}
				}
			}
			for(i = 0;i<_menus.length;i++)
			{
				if(_menus[i].id == 5)
				{
					if(allocationType == 0) _menus[i].selected = true;
				}else if(_menus[i].id == 5)
				{
					if(allocationType == 1) _menus[i].selected = true;
				}
			}
			
		}
		
		private function setFilter():void
		{
			for(var i:int = 0;i<_menus.length;i++)
			{
				if(_menus[i].id == 1&&_state == 2)
				{
					_menus[i].enabled = false;
					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
				}
			}
		}
		
		private function setPos(pos:Point):void
		{
			if(_bg.height + pos.y > CommonConfig.GAME_HEIGHT)
				this.y =  pos.y - _bg.height;
			else
				this.y = pos.y;
			if(_bg.width + pos.x >CommonConfig.GAME_WIDTH)
				this.x = pos.x - _bg.width;
			else
				this.x = pos.x;
		}
		
	
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			switch (item.id)
			{
				case 1:
//					if(GlobalData.copyEnterCountList.isInCopy)
//					{
//						MAlert.show("退出队伍将会自动传出副本，确定\n进行此操作吗？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
//					}else
//					{
//						MAlert.show("您确定要离开本队伍吗？\n离开队伍后将不能获得队伍加成。",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
//					}
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:2,id:id}));
					break;
				case 2:
					if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
						return;
					}
					MAlert.show(LanguageManager.getWord("ssztl.common.isSureDisposeTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,disposeCloseHandler);
					break
				case 3:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.FOLLOW_PLAYER,id));
					break;
				case 4:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_SETTING_CHANGE,{inTeam:_autoInTeam,allocation:0}));
					break;
				case 5:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_SETTING_CHANGE,{inTeam:_autoInTeam,allocation:1}));
					break;
				case 6:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_SETTING_CHANGE,{inTeam:!_autoInTeam,allocation:_allocationType}));
					break;
				case 7:
					System.setClipboard(nick);
					break;
				case 9:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CREATE_TEAM));
					break;
			}
			if(parent) parent.removeChild(this);
		}
		
		private function leaveCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:2,id:id}));	
		}
		
		private function disposeCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:4,id:id}));
		}
	}
}