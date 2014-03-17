package sszt.role.components
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.constData.PropertyType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.data.role.RoleInfoEvents;
	import sszt.core.data.veins.AcupointType;
	import sszt.core.data.veins.VeinsExtraTemplateInfo;
	import sszt.core.data.veins.VeinsExtraTemplateList;
	import sszt.core.data.veins.VeinsInfo;
	import sszt.core.data.veins.VeinsTemplateInfo;
	import sszt.core.data.veins.VeinsTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.role.components.btn.MRoleCacheSelectBtn;
	import sszt.role.mediator.RoleMediator;
	import sszt.role.socketHandlers.VeinsInfoSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	import ssztui.role.AcupointLeveAsset;
	import ssztui.role.XueweiBtnCurrentAsset;

	/**
	 * 其他玩家的穴位选项卡
	 * */
	public class VeinsOthersPanel extends Sprite implements IRolePanelView ,ITick
	{
		public static const limitLv:uint = 30; //经脉等级学习限制
		public static const MAX_GENGU_LEVEL:uint = 20;
		public static const STR_MAX_GENGU_LEVEL:String = "/20";
		public static const GENGU_SYMBOL_ID:int = 203024;
		public static const PLAYER_FRAME:int = 25; //播放帧数25每秒
		public static const VEINS_SPEED_UP_PRICE:int = 1;//1元宝3分钟
		
		public static const VEINS_SPEED_UP_CARD:int = 206088;//一小时加速卡编号
		
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		
		private var _sideBg:Bitmap;
		private var _contentGg:Bitmap;
		private var _timeTrack:Bitmap;
		
		private var _currExpPoint:MAssetLabel;
		
		private var _xuewei:MAssetLabel;
		private var _upTimeLable:MAssetLabel;
		
		private var _xueweiEffectView:MAssetLabel;
		private var _genguEffectView:MAssetLabel;
		private var _nextLvEffectView:MAssetLabel;
		private var _copperView:MAssetLabel;
		private var _expPointView:MAssetLabel;
		private var _limitVeinsView:MAssetLabel;
		private var _roleLvView:MAssetLabel;		
		private var _genguLvView:MAssetLabel;
		private var _luckyView:MAssetLabel;
		private var _successRateView:MAssetLabel;
		private var _propsCharm:MAssetLabel;
		private var _checkBoxList:Array;
		
		private var _speedUpNeedPrice:int;
		private var _speedUpPriceLable:MAssetLabel;
		private var _speedUpBtn:MCacheAssetBtn1;
		private var _genguUpBtn:MCacheAssetBtn1;
		/**
		 * 穴位修炼 
		 */		
		private var _veinsUpBtn:MCacheAssetBtn1;
		
		
		private var _luckyTipBtn:MSprite;
		
		private var _xueweiBtns:Array;   //穴位按钮
		private var _currentXuewei:int;
		private var _currentMoive:MovieClip;
		
		private var _leveeExtra:MovieClip;	//额外加成
		
		private var _upTimeView:MAssetLabel;
		private var _upTime:Number;
		private var _totalTime:int;		//需要总的时间
		private var _countDownView:CountDownView; //穴位升级时间
		
		private var _upContainer:MSprite;
		private var _upBg:Bitmap;
		
		
		
		private var _roleMediator:RoleMediator;	
		private var rolePlayerId:Number;
		private var _roleInfo:RoleInfo;
		
		public function VeinsOthersPanel(roleMediator:RoleMediator,argRolePlayerId:Number)
		{
			_roleMediator = roleMediator;
			rolePlayerId = argRolePlayerId;
			_roleInfo = _roleMediator.roleModule.roleInfoList[rolePlayerId];
			
			initialView();			
			initialEvents();
			
			VeinsInfoSocketHandler.sendPlayerId(rolePlayerId);
		}
		
		
		private function initialView():void
		{	
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,273,374)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(278,3,160,374)),
			]);
			addChild(_bg as DisplayObject);
			
			_contentGg = new Bitmap();
			_contentGg.x = _contentGg.y = 4;
			addChild(_contentGg as DisplayObject);
			
			_sideBg = new Bitmap();
			_sideBg.x = 279;
			_sideBg.y = 4;
			addChild(_sideBg);
			
			initalLabels();
			
			_veinsUpBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.role.veinsUp"));
			_veinsUpBtn.move(323,229);
			_veinsUpBtn.enabled = false;
			addChild(_veinsUpBtn);
			_genguUpBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.role.genguUp"));
			_genguUpBtn.move(323,343);
			addChild(_genguUpBtn);
			_genguUpBtn.enabled = false;
			
			//穴位升级
			_upContainer = new MSprite();
			_upContainer.move(279,3);
			addChild(_upContainer);
			_upContainer.visible = false;
			
			_upBg = new Bitmap();
			_upContainer.addChild(_upBg);
			var restTime:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.store.leftTime"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			restTime.textColor = 0xFFcc00;
			restTime.move(10,159);
			_upContainer.addChild(restTime);
			
			_countDownView = new CountDownView();
			_countDownView.setLabelType(new TextFormat("Tahoma",12,0x33ffcc,true));
			_countDownView.move(70,158);
			_upContainer.addChild(_countDownView);
			
			var yuanbaoIoc:Bitmap = new Bitmap(MoneyIconCaches.yuanBaoAsset);
			yuanbaoIoc.x = 136;
			yuanbaoIoc.y = 182;
			_upContainer.addChild(yuanbaoIoc as DisplayObject);
			
			var cb1:CheckBox = new CheckBox();
			var cb2:CheckBox = new CheckBox();
			cb1.label = LanguageManager.getWord("ssztl.common.finishRightNow");
			cb2.label = LanguageManager.getWord("ssztl.common.speedOneHour");
			cb1.setSize(100,20);
			cb2.setSize(100,20);
			cb1.move(10,182);
			cb2.move(10,200);
			cb1.addEventListener(MouseEvent.CLICK,checkBoxChange);
			cb2.addEventListener(MouseEvent.CLICK,checkBoxChange);
			_upContainer.addChild(cb1);
			_upContainer.addChild(cb2);
			cb1.selected = true;			
			_checkBoxList = [cb1,cb2];
			
			_speedUpPriceLable = new MAssetLabel("",MAssetLabel.LABEL_TYPE8,TextFormatAlign.RIGHT);			
			_speedUpPriceLable.move(134,183);
			_upContainer.addChild(_speedUpPriceLable);
			
			_speedUpBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.role.speedUp"));
			_speedUpBtn.move(44,226);
			_upContainer.addChild(_speedUpBtn);
			_speedUpBtn.enabled = false;
			
			_xueweiBtns = new Array();
			for(var i:int = 0;i < 8;i++)
			{
				var btn:MRoleCacheSelectBtn = new MRoleCacheSelectBtn(0,0);
				_xueweiBtns.push(btn);
				addChild(btn);	
			}
			_xueweiBtns[_currentXuewei].selected = true;			
			_xueweiBtns[0].move(129,90);
			_xueweiBtns[1].move(146,130);
			_xueweiBtns[2].move(171,90);
			_xueweiBtns[3].move(128,200);
			_xueweiBtns[4].move(128,226);
			_xueweiBtns[5].move(100,235);
			_xueweiBtns[6].move(51,266);
			_xueweiBtns[7].move(58,322);
			
			_currentMoive = new XueweiBtnCurrentAsset();
			_currentMoive.mouseEnabled = _currentMoive.mouseChildren = false;
			_currentMoive.x = _xueweiBtns[_currentXuewei].x+4;
			_currentMoive.y = _xueweiBtns[_currentXuewei].y+4;
			addChild(_currentMoive);
			
			_luckyTipBtn = new MSprite();
			_luckyTipBtn.move(285,306);
			_luckyTipBtn.graphics.beginFill(0,0);
			_luckyTipBtn.graphics.drawRect(0,0,147,18);
			_luckyTipBtn.graphics.endFill();
			addChild(_luckyTipBtn);
			
			_leveeExtra = new AcupointLeveAsset();
			_leveeExtra.x = 27;
			_leveeExtra.y = 25;
			addChild(_leveeExtra);
			_leveeExtra.gotoAndStop(1);
			
			
		}
		private function initalLabels():void
		{	
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(280,56,156,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(280,262,156,25),new MCacheCompartLine2()),
				
				//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(289,-48,140,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.veinsTitle"),MAssetLabel.LABEL_TYPE_TITLE)));
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,33,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.effect"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,65,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.nextLevel"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,83,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.effect"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,107,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.copperLabel"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,125,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.expPoint"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,143,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.limitVeins"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,161,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.roleLv"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,179,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.upTime"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,269,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.boneLabel"),MAssetLabel.LABEL_TYPE21B,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(331,272,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.level") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,289,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.extraAppend"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,307,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.lucky"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,327,35,14),new MAssetLabel(LanguageManager.getWord("ssztl.role.genguFu"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			//历练
			_currExpPoint = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_currExpPoint.setLabelType([new TextFormat("Arial",12,0x000000)]);
			_currExpPoint.move(160,24);
			addChild(_currExpPoint);	
			
			_xuewei = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B,TextFormatAlign.LEFT);
			//			_xuewei.setLabelType([new TextFormat("SimSun",13,0xFFcc00,true)]);
			_xuewei.move(289,11);
			addChild(_xuewei);
			
			_xueweiEffectView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_xueweiEffectView.move(325,33);
			_xueweiEffectView.setValue("");
			addChild(_xueweiEffectView);			
			_nextLvEffectView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_nextLvEffectView.move(325,83);
			_nextLvEffectView.setValue("");
			addChild(_nextLvEffectView);
			_copperView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_copperView.move(325,107);
			_copperView.setValue("");
			addChild(_copperView);
			_expPointView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_expPointView.move(325,125);
			_expPointView.setValue("");
			addChild(_expPointView);
			_limitVeinsView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_limitVeinsView.move(349,143);
			_limitVeinsView.setValue("");
			addChild(_limitVeinsView);
			_roleLvView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_roleLvView.move(349,161);
			_roleLvView.setValue("");
			addChild(_roleLvView);
			
			_upTimeView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_upTimeView.textColor = 0x00ff00;
			_upTimeView.move(349,179);
			_upTimeView.setValue("");
			addChild(_upTimeView);
			
			_genguLvView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_genguLvView.move(367,272);
			_genguLvView.setValue("");
			addChild(_genguLvView);
			_genguEffectView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_genguEffectView.move(349,289);
			_genguEffectView.setValue("");
			addChild(_genguEffectView);
			_successRateView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_successRateView.move(342,262);
			_successRateView.setValue("");
			//			addChild(_successRateView);
			_luckyView = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_luckyView.move(337,307);
			_luckyView.setValue("");
			addChild(_luckyView);
			_propsCharm = new MAssetLabel(LanguageManager.getWord(""),MAssetLabel.LABEL_TYPE8,TextFormatAlign.LEFT);
			_propsCharm.move(337,327);
			_propsCharm.setHtmlValue("-/-");
			addChild(_propsCharm);
		}
		
		private function initialData():void
		{
			var veins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(_currentXuewei + 1);
			_totalTime = veins.getNextXueweiTemplate().needTime * PLAYER_FRAME;
			
			var time:Number =	int(GlobalData.systemDate.getSystemDate().getTime() / 1000);
			_upTime = (_roleInfo.veins.veinsCD - time) * PLAYER_FRAME;
			if(_upTime > 0 )
			{
				_countDownView.start(_upTime / PLAYER_FRAME);
				GlobalAPI.tickManager.addTick(this);
				_upTimeView.setValue(timeChange(_upTime / PLAYER_FRAME));	
			}	
			
			var tveins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(AcupointType.YONGQUAN);
			//显示加成特效
			if(tveins)
				showVeinsExtra(tveins.acupointLv);
		}
		private function showVeinsExtra(level:int):void
		{
			var list:Array = VeinsExtraTemplateList.getVeinsExtraList(level);
			var num:int = list.length;
			if(num > 0)
			{
				_leveeExtra.gotoAndStop(2);
			}else
			{
				_leveeExtra.gotoAndStop(1);
			}
			
			/*
			for(var i:int = 0; i < num; i++)
			{
			_leveeArray[i].gotoAndStop(100);
			
			//Aron 3.18
			if(!_effectArray[i])
			{
			var fire:MovieClip = MovieCaches.getFireAsset();
			fire.x = _leveeArray[i].x - 7;
			fire.y = _leveeArray[i].y - 38;
			fire.mouseEnabled = false;
			fire.mouseChildren = false;
			addChild(fire);
			_effectArray.push(fire);
			}
			}
			if(num == 0)
			_leveeArray[num].gotoAndStop(Math.round(level/4 * 100));
			else if(num < 5)
			_leveeArray[num].gotoAndStop(Math.round((level - list[num - 1].needLevel)/4 * 100));
			
			*/
		}
		
		private function checkBoxChange(e:MouseEvent):void
		{			
			var index:int = _checkBoxList.indexOf(e.target);
			_checkBoxList[index].selected = true;
			if(index == 0)
			{					
				_checkBoxList[1].selected = false;
			}
			else
			{
				_checkBoxList[0].selected = false;
			}
			if(_upContainer.visible)
			{
				if(_checkBoxList[0].selected)
					updateSpeedUPPrice(_upTime / PLAYER_FRAME);
				else
					updateSpeedUPPrice(3600);
			}
			else
			{
				if(_checkBoxList[0].selected)
				{
					var veins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(_currentXuewei + 1);
					updateSpeedUPPrice(veins.getNextXueweiTemplate().needTime);
				}
				else
					updateSpeedUPPrice(3600);
			}
		}
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			
		}
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_upTime > 0)
			{
				_upTime--;
				if(_roleInfo.veins.getVeinsByAcupointType(_currentXuewei + 1).isUping)
				{
					if(_checkBoxList[0].selected)
						updateSpeedUPPrice(_upTime / PLAYER_FRAME);
				}
			}
			else
			{
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public function assetsCompleteHandler():void
		{
			
			_contentGg.bitmapData = AssetUtil.getAsset("ssztui.role.VeinsBgAsset",BitmapData) as BitmapData;
			_sideBg.bitmapData = AssetUtil.getAsset("ssztui.role.RoleSideBgAsset",BitmapData) as BitmapData;
			_upBg.bitmapData = AssetUtil.getAsset("ssztui.role.VeinsUpBgAsset",BitmapData) as BitmapData;
			//			var num:int = _effectArray.length;
			//			for(var i:int=0; i<5; i++)
			//			{
			//				var _mc:IMovieWrapper = MovieCaches.getFireAsset();//AssetUtil.getAsset("ssztui.role.EffectFireAsset",MovieClip) as MovieClip;
			//				_mc.x = 48 + 40*i -7;
			//				_mc.y = 312 - 38;
			//				_mc.play();
			//				_mc.visible = false;
			////				_mc.emouseEnabled = false;
			//				addChild(_mc as DisplayObject);
			//				if(num > i)
			//				{
			//					_mc.visible = true;
			//					_effectArray[i] = _mc;
			//				}
			//				else					
			//					_effectArray.push(_mc);
			//			}
		}
		
		private function getAttackType(career:int):String
		{
			switch(career)
			{
				case CareerType.SANWU :
					return LanguageManager.getWord("ssztl.role.mumpAttack2");
				case CareerType.XIAOYAO :
					return LanguageManager.getWord("ssztl.role.magicAttack2");
				case CareerType.LIUXING :
					return LanguageManager.getWord("ssztl.role.farAttack2");
			}
			return "";
		}
		
		private function getEffect(awardAttributeType:int):String
		{
			switch(awardAttributeType)
			{
				case PropertyType.ATTR_HP :
					return LanguageManager.getWord("ssztl.common.life");
				case PropertyType.ATTR_DEFENSE :
					return LanguageManager.getWord("ssztl.common.physicalDefense2");
				case PropertyType.ATTR_MUMPDEFENSE :
					return LanguageManager.getWord("ssztl.common.mumpDefence2");
				case PropertyType.ATTR_MAGICDEFENCE :
					return LanguageManager.getWord("ssztl.common.farDefence2");
				case PropertyType.ATTR_FARDEFENSE :
					return LanguageManager.getWord("ssztl.common.magicDefence2");
				case PropertyType.ATTR_ATTACK :
					return LanguageManager.getWord("ssztl.common.physicalAttack2");
				case PropertyType.ATTR_MUMPHURTATT :
					return getAttackType(_roleInfo.playerInfo.career);
				case PropertyType.ATTR_DAMAGE :
					return LanguageManager.getWord("ssztl.common.addOnHurt");	
			}
			return "";
		}
		
		/**
		 * 点击选中穴位事件 
		 * @param evt
		 * 
		 */
		private function changeXuewei(evt:Event):void
		{
			var index:int = _xueweiBtns.indexOf(evt.currentTarget);
			if(index == _currentXuewei)
				return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_roleInfo.veins.hasInit)
				setCurrentXueweiSelect(index);	
		}
		
		private function setCurrentXueweiSelect(xueweiIndex:int):void
		{
			_xueweiBtns[_currentXuewei].selected = false;
			_xueweiBtns[xueweiIndex].selected = true;
			_currentXuewei = xueweiIndex;
			var acupointType:int = xueweiIndex + 1;
			var veins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(acupointType);
			if(veins == null)
			{
				veins = new VeinsInfo();
				veins.acupointType = acupointType;
				veins.acupointLv = 0;
				veins.genguLv = 0;
				veins.luck = 0;
				_roleInfo.veins.addVeins(veins);
			}
			showSelectXueweiInfo(veins);			
		}
		private function setCurrentXueweiMoive(index:int):void
		{
			_currentMoive.x = _xueweiBtns[index].x+4;
			_currentMoive.y = _xueweiBtns[index].y+4;
		}
		
		private function veinsRefashHandler():void
		{
			setCurrentXueweiSelect(_roleInfo.veins.getDefaultSelectAcupoint());
			setCurrentXueweiMoive(_roleInfo.veins.getDefaultSelectAcupoint());
			for(var i:int=0; i<8; i++)
			{
				var veins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(i+1);
				if(veins == null)
				{					
					//					_xueweiBtns[i].filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
					_xueweiBtns[i].open = false;
				}else{
					if(veins.acupointLv == 0)
						//						_xueweiBtns[i].filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
						_xueweiBtns[i].open = false;
					else
						//						_xueweiBtns[i].filters = [];
						_xueweiBtns[i].open = true;
				}
			}
		}
		private function updateSpeedUPPrice(item:int):void
		{
			var price:int = Math.ceil(item / 60 / 3);
			if(price > 0)
				price = price * VEINS_SPEED_UP_PRICE;
			else
				price = VEINS_SPEED_UP_PRICE;
			_speedUpNeedPrice = price;
			_speedUpPriceLable.setValue(price.toString());
		}
		
		
		private function showSelectXueweiInfo(veins:VeinsInfo):void
		{
			var strName:String = "ssztl.role.xueweiName";
			var strXuewei:String = LanguageManager.getWord(strName.concat(veins.acupointType));
			_xuewei.setValue(strXuewei.concat(LanguageManager.getWord("ssztl.common.levelValue2",veins.acupointLv)));
			var strEffect:String = getEffect(veins.getTemplate().awardAttributeType);
			
			_xueweiEffectView.setValue(strEffect.concat("+",veins.getTemplate().acupointCountAward));
			_genguEffectView.setValue(strEffect.concat("+",
				getGenguEffect(veins.genguLv, veins.acupointType, veins.getTemplate().acupointCountAward)));
			
			var nextXuewei:VeinsTemplateInfo = veins.getNextXueweiTemplate();
			_nextLvEffectView.setValue(strEffect.concat("+",nextXuewei.acupointCountAward));
			var checkUpgrade:Boolean = true;
			if(veins.acupointLv >= VeinsTemplateList.getMaxLeve())
			{
				checkUpgrade = false;
			}
			_copperView.setLabelType(MAssetLabel.LABEL_TYPE20);
			_copperView.setValue(nextXuewei.needCopper.toString());
			_expPointView.setLabelType(MAssetLabel.LABEL_TYPE20);
			_expPointView.setValue(nextXuewei.needLifeExp.toString());  
			_currExpPoint.setHtmlValue(LanguageManager.getWord("ssztl.common.expPoint") +"<b>"+ "-" + "</b>");
			var limitXuewei:int = veins.getLimitXuewei();
			var limitXueweiLv:int = nextXuewei.totalLevel;
			var strLimitXuewei:String =  LanguageManager.getWord(strName.concat(limitXuewei));
			if (limitXuewei == AcupointType.YONGQUAN)
				limitXueweiLv --;
			
			if(_roleInfo.veins.getAcupointLvByAcupointType(limitXuewei) >= limitXueweiLv)
				_limitVeinsView.setLabelType(MAssetLabel.LABELTYPE4);
			else
			{
				_limitVeinsView.setLabelType(MAssetLabel.LABEL_TYPE6);
				checkUpgrade = false;
			}
			_limitVeinsView.setValue(strLimitXuewei.concat(LanguageManager.getWord("ssztl.common.levelValue", limitXueweiLv)));
			_roleLvView.setLabelType(MAssetLabel.LABELTYPE4);
			_roleLvView.setValue((limitLv + nextXuewei.totalLevel).toString());			
			if(veins.isUping)
			{
				_upContainer.visible = true;
				
				_countDownView.start(_upTime / PLAYER_FRAME);
				if(_checkBoxList[1].selected)
					updateSpeedUPPrice(3600);
				GlobalAPI.tickManager.addTick(this);
				//设计进度条
			}
			else
			{
				_upContainer.visible = false;
				if(_checkBoxList[0].selected)
					updateSpeedUPPrice(nextXuewei.needTime);
				else
					updateSpeedUPPrice(3600);
				_countDownView.start(nextXuewei.needTime);
				_countDownView.stop();
				_upTimeView.setValue(timeChange(nextXuewei.needTime));
				//设计进度条满
			}
			
			_genguLvView.setValue(veins.genguLv.toString() + STR_MAX_GENGU_LEVEL);
			//			_genguLvProgressBar.setValue(MAX_GENGU_LEVEL,veins.genguLv);
			_luckyView.setValue(veins.luck.toString());
			_successRateView.setValue(veins.getTemplate().successRate.toString());//具体值需要公式来运算
		}
		
		private function checkXueweiUpgrade(veins:VeinsTemplateInfo):Boolean
		{
			if (_roleInfo.veins.veinsCD > 0)
				return false;
			var limitLv:int = veins.totalLevel;
			if (veins.acupointType == AcupointType.BAIHUI)
			{
				if (veins.totalLevel == 1)
					return true;
				else
					limitLv = veins.totalLevel - 1;
			}
			var limitXuewei:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(getLimitXuewei(veins.acupointType))
			if (limitXuewei == null || limitXuewei.acupointLv < limitLv)
				return false;
			
			return true;
		}
		private function getLimitXuewei(acupointType:int):int
		{
			if(acupointType == AcupointType.BAIHUI)
				return AcupointType.YONGQUAN;
			else
				return acupointType - 1;
		}
		private function getGenguEffect(genguLv:int,xueweiType:int,xueweiAward:int):int
		{
			if(genguLv == 0) 
				return 0;
			var v:VeinsTemplateInfo = VeinsTemplateList.getVeins(xueweiType, genguLv);
			if(v)
				return Math.round(xueweiAward * v.genguAward / 100);
			else
				return 0;
		}
		
		private function initialEvents():void
		{
			_roleInfo.addEventListener(RoleInfoEvents.VEINS_UPDATE,veinsUpdateHandler);
			
			for(var i:int=0;i<8;i++)
			{
				_xueweiBtns[i].addEventListener(MouseEvent.CLICK,changeXuewei);
				_xueweiBtns[i].addEventListener(MouseEvent.MOUSE_OVER,onOverXuewei);
				_xueweiBtns[i].addEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
			}
				
			_leveeExtra.addEventListener(MouseEvent.MOUSE_OVER,showExtraAwardTipHandler);
			_leveeExtra.addEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
		}
		
		private function removeEvents():void
		{
			_roleInfo.addEventListener(RoleInfoEvents.VEINS_UPDATE,veinsUpdateHandler);
			
			for(var i:int=0;i<8;i++){
				_xueweiBtns[i].removeEventListener(MouseEvent.CLICK,changeXuewei);
				_xueweiBtns[i].removeEventListener(MouseEvent.MOUSE_OVER,onOverXuewei);
				_xueweiBtns[i].removeEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
			}

			_leveeExtra.removeEventListener(MouseEvent.MOUSE_OVER,showExtraAwardTipHandler);
			_leveeExtra.removeEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
		}
		
		private function veinsUpdateHandler(event:Event):void
		{
			veinsRefashHandler();
			initialData();
		}
		
		private function onOverXuewei(evt:MouseEvent):void
		{
			var index:int = _xueweiBtns.indexOf(evt.currentTarget);
			var veins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(index+1);
			if(veins)
			{
				var tip:String = "<font color='#ff9900'><b>"+ LanguageManager.getWord("ssztl.role.xueweiName" + veins.acupointType)+"</b></font>\n";
				tip += LanguageManager.getWord("ssztl.common.useLvValue",veins.acupointLv) + "\n";
				tip += LanguageManager.getWord("ssztl.common.effectlabel") + "：<font color='#33ff00'>" + getEffect(veins.getTemplate().awardAttributeType) +"+"+ veins.getTemplate().acupointCountAward + "</font>";
				TipsUtil.getInstance().show(tip,null,new Rectangle(evt.stageX,evt.stageY,0,0));
			}
			
		}
		
		private function showExtraAwardTipHandler(evt:MouseEvent):void
		{
			//			var i:int = _leveeArray.indexOf(evt.currentTarget);
			var tveins:VeinsInfo = _roleInfo.veins.getVeinsByAcupointType(AcupointType.YONGQUAN);
			var v:VeinsExtraTemplateInfo;
			var v2:VeinsExtraTemplateInfo;
			if(tveins)
			{
				var list:int = VeinsExtraTemplateList.getVeinsExtraList(tveins.acupointLv).length;			
				v = VeinsExtraTemplateList.getVeinsExtraById(list);
				v2 = VeinsExtraTemplateList.getVeinsExtraById(list+1);
			}else
			{
				v2 = VeinsExtraTemplateList.getVeinsExtraById(1);
			}
			
			var tipStr:String = "";
			if(v) tipStr += addExtraTip(v,true);
			if(v2) tipStr += addExtraTip(v2,false);
			
			tipStr += "</font><font color='#bb8050'>"+LanguageManager.getWord("ssztl.common.meridianAdditionExplain")+"</font>";
			
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function addExtraTip(v:VeinsExtraTemplateInfo,b:Boolean):String
		{
			var tipStr:String = "";
			if(!b)
			{
				tipStr += "<font color='#777164' size='14'><b>"+v.name+"</b></font>\n";
				tipStr += "<font color='#777164'><font color='#ff3333'>"+LanguageManager.getWord("ssztl.common.allMeridianToLevel",v.needLevel)+"</font>\n";
			}else{
				tipStr += "<font color='#ff9900' size='14'><b>"+v.name+"</b></font>\n";
				tipStr += "<font color='#33ff00'><font color='#0099ff'>["+LanguageManager.getWord("ssztl.activity.hasActivated")+"]</font>\n";
			}
			tipStr += LanguageManager.getWord("ssztl.common.life") + " +" + v.hp + "\n";
			tipStr += LanguageManager.getWord("ssztl.common.attack") + " +" + v.attack + "\n";				
			tipStr += LanguageManager.getWord("ssztl.common.defense") + " +" + v.defense + "\n";
			switch(_roleInfo.playerInfo.career)
			{
				case 1:
				{
					tipStr += LanguageManager.getWord("ssztl.role.mumpAttack2") + " +" + v.attributeAttack + "\n";
					tipStr += LanguageManager.getWord("ssztl.common.mumpDefence2") + " +" + v.mumpDefense + "\n";
					break;
				}
				case 2:
				{
					tipStr += LanguageManager.getWord("ssztl.role.magicAttack2") + " +" + v.attributeAttack + "\n";
					tipStr += LanguageManager.getWord("ssztl.common.magicDefence2") + " +" + v.magicDefense + "\n";
					break;
				}
				case 3:
				{
					tipStr += LanguageManager.getWord("ssztl.role.farAttack2") + " +" + v.attributeAttack + "\n";
					tipStr += LanguageManager.getWord("ssztl.common.shortFarDefense") + " +" + v.farDefense + "\n";
					break;
				}
			}
			return tipStr + "\n";
		}
		private function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function timeChange(n:Number):String
		{
			var _countdonwinfo:CountDownInfo = DateUtil.getCountDownByHour(0,n * 1000);
			return getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
		}
		private function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			hide();
			removeEvents();
			GlobalAPI.tickManager.removeTick(this);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_contentGg && _contentGg.bitmapData)
			{
				_contentGg.bitmapData.dispose();
				_contentGg = null;
			}
			if(_sideBg && _sideBg.bitmapData)
			{
				_sideBg.bitmapData.dispose();
				_sideBg = null;
			}
			if(_upBg && _upBg.bitmapData)
			{
				_upBg.bitmapData.dispose();
				_upBg = null;
			}
			if(_timeTrack && _timeTrack.bitmapData)
			{
				_timeTrack.bitmapData.dispose();
				_timeTrack = null;
			}
			_upContainer = null;
			_xuewei = null;			
			_upTimeLable = null; 
			_upTimeView = null;
			_xueweiEffectView = null;
			_genguEffectView = null; 
			_nextLvEffectView = null;
			_copperView = null;      
			_expPointView = null;    
			_limitVeinsView = null;  
			_roleLvView = null;      
			_genguLvView = null;     
			_luckyView = null;       
			_successRateView = null; 
			_currExpPoint = null;
			_propsCharm = null;
			_luckyTipBtn = null;
			if(_leveeExtra && _leveeExtra.parent)
			{
				_leveeExtra.parent.removeChild(_leveeExtra);
				_leveeExtra = null;
			}
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			if(_speedUpBtn)
			{
				_speedUpBtn.dispose();
				_speedUpBtn = null;
			}
			if(_genguUpBtn)
			{
				_genguUpBtn.dispose();
				_genguUpBtn = null;
			}
			if(_veinsUpBtn)
			{
				_veinsUpBtn.dispose();
				_veinsUpBtn = null;
			}
			if(_xueweiBtns)
			{
				for( var j:int=0;j<_xueweiBtns.length;j++)
				{
					_xueweiBtns[j].dispose();
				}
			}
			_xueweiBtns = null;
			_checkBoxList = null;
			_roleMediator = null;
		}
	}
}