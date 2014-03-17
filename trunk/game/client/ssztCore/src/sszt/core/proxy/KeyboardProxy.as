package sszt.core.proxy
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.KeyType;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class KeyboardProxy
	{
		public static function setup():void
		{
			
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
		}
		
		private static function stageClickHandler(evt:MouseEvent):void
		{
			if(!(evt.target is TextField))
			{
				GlobalAPI.layerManager.getPopLayer().stage.focus = GlobalAPI.layerManager.getPopLayer().stage;
			}
		}
		
		private static function keyDownHandler(evt:KeyboardEvent):void
		{
			if(!(evt.target is TextField))
			{
				switch(evt.keyCode)
				{
					case KeyType.LEFT:
						ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.LEFT_PRESS));
						break;
					case KeyType.RIGHT:
						ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.RIGHT_PRESS));
						break;
					case KeyType.UP:
						ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UP_PRESS));
						break;
					case KeyType.DOWN:
						ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.DOWN_PRESS));
						break;
					case KeyType.A:
						//攻击目标
						break;
					case KeyType.B:
						SetModuleUtils.addBag();
						break;
					case KeyType.C:
						SetModuleUtils.addRole(GlobalData.selfPlayer.userId);
						break;
					case KeyType.D:
						SetModuleUtils.addMounts(new ToMountsData(0));
						break;
					case KeyType.E:
						SetModuleUtils.addMail(new ToMailData(true));
						break;
					case KeyType.F:
						ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_IMPANEL));
//						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NEARLY_PANEL));
						break;
					case KeyType.G:
						if(GlobalData.selfPlayer.clubId == 0) SetModuleUtils.addClub(3);
						else SetModuleUtils.addClub(3,1);
						break;
					case KeyType.H:
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.MOUNT_AVOID));
						break;
					case KeyType.I:
						SetModuleUtils.addBox(1);
						break;
					case KeyType.J:
						//观察
						break;
					case KeyType.K:
						SetModuleUtils.addFurnace();
						break;
					case KeyType.L:
						
						break;
					case KeyType.M:
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_BIGMAP_PANEL));
						break;
					case KeyType.O:
						SetModuleUtils.addActivity();
						break;
					case KeyType.P:
						//排行
						SetModuleUtils.addRank();
						break;
					case KeyType.Q:
						ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.SHOW_MAINPANEL));
						break;
					case KeyType.R:						
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.BREAKAWAY));
						break;
					case KeyType.S:
						SetModuleUtils.addStore(new ToStoreData(1));
						break;
					case KeyType.T:
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_GROUP_PANEL));
						break;
					case KeyType.V:
						SetModuleUtils.addSkill();
						break;
					case KeyType.W:
						SetModuleUtils.addPet();
						break;
					case KeyType.X:
						//打坐
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SIT));
						//						if(GlobalData.selfPlayer.isSit())
						//						{
						//							GlobalData.selfPlayer.setSit(false);
						//						}
						//						else
						//						{
						//							GlobalData.selfPlayer.setSit(true);
						//						}
						break;
					case KeyType.Z:
						//自动打怪
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.HANGUP));
						break;
					case KeyType.ESC:
						GlobalAPI.layerManager.escPress();
						break;
					case KeyType.KEY0:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,19));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,9));
						}
						break;
					case KeyType.KEY1:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,10));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,0));
						}
						break;
					case KeyType.KEY2:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,11));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,1));
						}
						break;
					case KeyType.KEY3:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,12));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,2));
						}
						break;
					case KeyType.KEY4:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,13));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,3));
						}
						break;
					case KeyType.KEY5:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,14));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,4));
						}
						break;
					case KeyType.KEY6:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,15));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,5));
						}
						break;
					case KeyType.KEY7:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,16));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,6));
						}
						break;
					case KeyType.KEY8:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,17));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,7));
						}
						break;
					case KeyType.KEY9:
						if(GlobalAPI.keyboardApi.keyIsDown(KeyType.CTRL))
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,18));
						}
						else
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.APPLY_SKILLBAR,8));
						}
						break;
					
					
					case KeyType.SPACE:
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.PICKUP_SPACE));
						break;
					case KeyType.F8:
						if(CommonConfig.isFull)
						{
							JSUtils.exitFullScene();
						}
						else
						{
							JSUtils.doFullScene();
						}
						CommonConfig.isFull = !CommonConfig.isFull;
						break;
					case KeyType.F9:
						//隐藏玩家
						SharedObjectManager.setHidePlayerCharacter(!SharedObjectManager.hidePlayerCharacter.value);
						break;
					case KeyType.CHANGETARGET:
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TARGET_CHANGE));
						break;
				}
			}
		}
	}
}