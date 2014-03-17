package sszt.navigation.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.expList.ExpList;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToSettingData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.navigation.mediators.NavigationMediator;
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	
	import ssztui.navigation.*;
	
	public class NavigationBar extends Sprite
	{
		private var _mediator:NavigationMediator;
		
		private var _bgAsset:Bitmap;
		private var _expBar:Bitmap;
		private var _expGrid:Bitmap;
		private var _expBarMask:Sprite;
		private var _showTip:Sprite;
		
		private var _expPercent:TextField;
//		private var _btns:Vector.<MBitmapButton>;
//		private var _classes:Vector.<Class>;
//		private var _poses:Vector.<Point>;
//		private var _handlers:Vector.<Function>;
//		private var _btnTips:Vector.<String>;
		private var _btns:Array;
		private var _classes:Array;
		private var _poses:Array;
		private var _handlers:Array;
		private var _btnTips:Array;
		
		private var _bagFullMov:MovieClip;
		private var _bagFullAlert:MPanel;
		
		public function NavigationBar(mediator:NavigationMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			gameSizeChangeHandler(null);
			mouseEnabled = false;
			
			_bgAsset = new Bitmap(new BgAsset(0,0));
			_bgAsset.y = -106;
			addChild(_bgAsset);
			
			
			_classes = [
				RoleBtnAsset,BagBtnAsset,SkillBtnAsset,PetBtnAsset,MountBtnAsset,GuildBtnAsset,FurnaceBtnAsset,GoldBtnAsset,
				//商城
				ShopBtnAsset,
				//充值
				FillBtnAsset,
				//脱离异常坐标，挂机，坐骑骑乘，打坐
				HCFunBtnAsset,GJFunBtnAsset,CQFunBtnAsset,DZFunBtnAsset,
				//设置
				SetBarAsset,
				//婚姻
				HYFunBtnAsset
			];
			_poses = [
				new Point(512,-57),new Point(553,-57),new Point(594,-57),new Point(635,-57),new Point(676,-57),new Point(717,-57),new Point(758,-57),new Point(801,-57),
				new Point(423,-86),
				new Point(366,20),
				new Point(603,-90),new Point(649,-90),new Point(695,-90),new Point(741,-90),
				new Point(485,-31),
				new Point(787,-90),
			];
			_handlers = [
				roleClickHandler,
				bagClickHandler,
				skillClickHandler,
				petClickHandler,
				mountClickHandler,
				societyClickHandler,
				furnaceClickHandler,
				goldClickHandler,
				//商城
				shopClickHandler,
				//充值
				fillClickHandler,
				//挂机，坐骑骑乘，打坐
				breakAwaryClickHandler,
				autoFightClickHandler,
				rideClickHandler,
				sitClickHandler,
				setClickHandler,
				marrClickHanler
			];
			
			_btnTips = [
				LanguageManager.getWord("ssztl.navigation.navigationTip1"),
				LanguageManager.getWord("ssztl.navigation.navigationTip2"),
				LanguageManager.getWord("ssztl.navigation.navigationTip3"),
				LanguageManager.getWord("ssztl.navigation.navigationTip4"),
				LanguageManager.getWord("ssztl.navigation.navigationTip10"),
				LanguageManager.getWord("ssztl.navigation.navigationTip5"),
				LanguageManager.getWord("ssztl.navigation.navigationTip6"),
				LanguageManager.getWord("ssztl.navigation.navigationTip7"),
				LanguageManager.getWord("ssztl.navigation.navigationTip8"),
				LanguageManager.getWord("ssztl.navigation.navigationTip9"),
				LanguageManager.getWord("ssztl.scene.breakAway"),
				LanguageManager.getWord("ssztl.scene.startHangup"),
				LanguageManager.getWord("ssztl.scene.toHorse"),
				LanguageManager.getWord("ssztl.scene.sitExplain"),
				LanguageManager.getWord("ssztl.scene.smallMapTip7"),
				LanguageManager.getWord("ssztl.marry.myMarriage"),
			];			
			_btns = [];
			for(var i:int = 0; i < _classes.length; i++)
			{
				var btn:MAssetButton1 = new MAssetButton1(_classes[i]);
				btn.move(_poses[i].x,_poses[i].y);
				addChild(btn);
				btn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
				btn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
				_btns.push(btn);
			}
			if(!GlobalData.canCharge) 
				_btns[6].enabled = false;
			
			initExpBar();
			setGuideTipHandler(null);
		}
		
		private function initExpBar():void
		{
			var exp:Number = 0;
			var total:Number = 0;
			if(ExpList.list[GlobalData.selfPlayer.level+1])
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
				total = ExpList.list[GlobalData.selfPlayer.level + 1].totalExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
			}
			_expBarMask = new Sprite();
			_expBarMask.graphics.beginFill(0,0);
			_expBarMask.graphics.drawRect(0,0,804,7);
			_expBarMask.graphics.endFill();
			_expBarMask.x = 37;
			_expBarMask.y = -10;
			_expBarMask.mouseEnabled = false;
			_expBarMask.mouseChildren = true;
			addChild(_expBarMask);
			
			_expBar = new Bitmap(new ExpBarAsset(0,0));
			_expBar.x = 37;
			_expBar.y = -10;
			_expBar.mask = _expBarMask;
			addChild(_expBar);
			
			_expBarMask.width = exp/total * 804;
			
			var per:int = exp/total * 100;
			
			_expPercent = new TextField();
			_expPercent.mouseEnabled = _expPercent.mouseWheelEnabled = false;
			_expPercent.filters = [new GlowFilter(0x1D250E,1,2,2,9)];
			_expPercent.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff);
			_expPercent.x = 450;
			_expPercent.y = -15;
			_expPercent.text = per + "%";
			_expPercent.mouseEnabled = false;
			addChild(_expPercent);
			
			_expGrid = new Bitmap(new BarGridAsset(0,0));
			_expGrid.x = 114;
			_expGrid.y = -11;
			addChild(_expGrid);
			
			_showTip = new Sprite();
			_showTip.graphics.beginFill(0,0);
			_showTip.graphics.drawRect(0,0,804,7);
			_showTip.graphics.endFill();
			_showTip.x = 37;
			_showTip.y = -10;
			addChild(_showTip);
			
			_showTip.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_showTip.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.EXPUPDATE,onExpUpdate);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.BAG_EXTEND,bagInfoUpdateHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.EXPUPDATE,onExpUpdate);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.BAG_EXTEND,bagInfoUpdateHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);			
		}
		private function bagInfoUpdateHandler(e:BagInfoUpdateEvent):void
		{
//			trace(GlobalData.bagInfo.currentSize + "、" + GlobalData.selfPlayer.bagMaxCount);
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				if(!_bagFullMov)
				{
					_bagFullMov = new BagFullMovAsset();
					_bagFullMov.x = _poses[1].x;
					_bagFullMov.y = _poses[1].y;
					_bagFullMov.mouseEnabled = _bagFullMov.mouseChildren = false;
					addChild(_bagFullMov);
				}
			}else
			{
				if(_bagFullMov && _bagFullMov.parent)
				{
					_bagFullMov.parent.removeChild(_bagFullMov);
					_bagFullMov = null;
				}
			}
			if(int(GlobalData.selfPlayer.bagMaxCount)-int(GlobalData.bagInfo.currentSize) == 1 )
			{
				if(BagFullAlert.getInstance().parent==null)
				{
					BagFullAlert.getInstance().show();
				}
			}
		}
		
		
//		private function upgradeHandler(evt:CommonModuleEvent):void
//		{
//			if(GlobalData.selfPlayer.level >= 35)
//			{
//				_btns[6].enabled = true;
//				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
//			}
//		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.NAVIGATION)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 728 >> 1;
			y = CommonConfig.GAME_HEIGHT;
			GlobalData.bagIconPos = new Point(x + 553, y - 56)
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			var exp:Number = 0;
			var total:Number = 0;
			if(ExpList.list[GlobalData.selfPlayer.level+1])
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
				total = ExpList.list[GlobalData.selfPlayer.level + 1].totalExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
			}else
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level - 1].totalExp;
				total = ExpList.list[GlobalData.selfPlayer.level].exp;
			}
			var message:String = LanguageManager.getWord("ssztl.navigation.curExp") + String(exp) + "\n" 
				+ LanguageManager.getWord("ssztl.navigation.upgradeNeedExp") + String(total);
			
			TipsUtil.getInstance().show(message,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function btnOverHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MAssetButton1);
			var tip:String = "";
			switch(index)
			{
				case 2:
				{
					if(GlobalData.selfPlayer.level < 6) tip = LanguageManager.getWord("ssztl.common.sysOpenSkill");
					break;
				}
				case 5:
				{
					if(GlobalData.selfPlayer.level < 30) tip = LanguageManager.getWord("ssztl.common.sysOpenClub");
					break;
				}
				case 6:
				{
					if(GlobalData.selfPlayer.level < 16) tip = LanguageManager.getWord("ssztl.common.sysOpenFurnace");
					break;
				}
				case 7:
				{
					if(GlobalData.selfPlayer.level < 35) tip = LanguageManager.getWord("ssztl.common.sysOpenTaobao");
					break;
				}
			}
			if(tip == "") tip = _btnTips[index];
			if(_btnTips[index])
				TipsUtil.getInstance().show(tip,null,new Rectangle(e.stageX - 30,e.stageY - 30,0,0));
		}
		
		private function btnOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
			
		private function onExpUpdate(evt:SelfPlayerInfoUpdateEvent):void
		{
			var exp:Number = 0;
			var total:Number = 0;
			if(ExpList.list[GlobalData.selfPlayer.level+1])
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
				total = ExpList.list[GlobalData.selfPlayer.level + 1].totalExp - ExpList.list[GlobalData.selfPlayer.level].totalExp;
			}else
			{
				exp = GlobalData.selfPlayer.currentExp - ExpList.list[GlobalData.selfPlayer.level - 1].totalExp;
				total = ExpList.list[GlobalData.selfPlayer.level].exp;
			}
			_expBarMask.width = exp/total * 804;
			var per:int = exp/total * 100;
			_expPercent.text = per + "%";
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var index:int = _btns.indexOf(evt.currentTarget);
//			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_handlers[index]();
		}
		
		private function goldClickHandler():void
		{
//			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.COPY_ENTER,518002));
			SetModuleUtils.addBox(1);
//			if(GlobalData.selfPlayer.level > 40)
//			{
//				SetModuleUtils.addBox(1);
//			}else{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenTaobao"));
//			}
			
		}
		
		private function challengeClickHandler():void
		{
			SetModuleUtils.addChallenge();
		}
		
		private function shopClickHandler():void
		{
			SetModuleUtils.addStore(new ToStoreData(1));
		}
		
//		private function settingClickHandler():void
//		{
//			SetModuleUtils.addSetting(new ToSettingData(1));
//		}
		
		private function roleClickHandler():void
		{
			SetModuleUtils.addRole(GlobalData.selfPlayer.userId);
//			SetModuleUtils.addTemplate();
		}
		
		private function skillClickHandler():void
		{
			if(GlobalData.selfPlayer.level > 5)
			{
				SetModuleUtils.addSkill();
			}else{
				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenSkill"));
			}
		}
		
		private function bagClickHandler():void
		{
			SetModuleUtils.addBag();
		}
		
//		private function taskClickHandler():void
//		{
//			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.SHOW_MAINPANEL));
//		}
		
		private function furnaceClickHandler():void
		{
			SetModuleUtils.addFurnace();
//			if(GlobalData.selfPlayer.level > 15)
//			{
//				SetModuleUtils.addFurnace();
//			}else{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenFurnace"));
//			}
		}
		
		private function petClickHandler():void
		{
//			if(GlobalData.petList.getList().length > 0)
//			{
				SetModuleUtils.addPet();
//			}else{
//				QuickTips.show(LanguageManager.getWord("ssztl.pet.hasNoPet"));
//			}
			
//			if(GlobalData.petList.petCount == 0)
//				SetModuleUtils.addPet(new ToPetData(1));
//			else
//				SetModuleUtils.addPet(new ToPetData());
		}
		private function mountClickHandler():void
		{
//			if(GlobalData.mountsList.getList().length > 0)
//			{
				SetModuleUtils.addMounts(new ToMountsData(0));
//			}else{
//				QuickTips.show(LanguageManager.getWord("ssztl.mounts.none"));
//			}
		}
//		private function vipClickHandler():void
//		{
//			SetModuleUtils.addVip();
//		}
//		
//		private function teamClickHandler():void
//		{
//			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_GROUP_PANEL));
//		}
//		
//		private function friendClickHandler():void
//		{
//			ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_IMPANEL));
//		}
		
		private function societyClickHandler():void
		{
//			if(GlobalData.selfPlayer.clubId == 0)
//				SetModuleUtils.addClub(2);
//			else
//				SetModuleUtils.addClub(3);
			
			SetModuleUtils.addClub(3,1);
//			if(GlobalData.selfPlayer.level > 29)
//			{
//				if(GlobalData.selfPlayer.clubId == 0) SetModuleUtils.addClub(3);
//				else SetModuleUtils.addClub(3,1);
//			}else{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.sysOpenClub"));
//			}
			
		}
		
		private function fillClickHandler():void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.canCharge)
			{
				JSUtils.gotoFill();	
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.navigation.unOpenCharge"));
			}
		}
		private function sitClickHandler():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SIT));
		}		
		private function rideClickHandler():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.MOUNT_AVOID));
		}
		private function autoFightClickHandler():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.HANGUP));
		}
		private function breakAwaryClickHandler():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.BREAKAWAY));
		}		
		private function setClickHandler():void
		{
			//ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SIT));
			SetModuleUtils.addSetting(new ToSettingData(0));
		}
		private function marrClickHanler():void
		{
//			QuickTips.show('功能尚未开放，敬请期待！');
			SetModuleUtils.addMarriage(new ToMarriageData(5));
		}
	}
}