package sszt.rank.components.views.individual
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CareerType;
	import sszt.constData.DirectType;
	import sszt.constData.PropertyType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.equipStrength.EquipStrengthTemplate;
	import sszt.core.data.equipStrength.EquipStrengthTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.data.role.RoleInfoEvents;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.role.RoleInfoSocketHandler;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.character.ICharacterWrapper;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.rank.components.views.EquipItemCell;
	import sszt.rank.data.item.IndividualRankItem;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.rank.FightNumberAsset0;
	import ssztui.rank.FightNumberAsset1;
	import ssztui.rank.FightNumberAsset2;
	import ssztui.rank.FightNumberAsset3;
	import ssztui.rank.FightNumberAsset4;
	import ssztui.rank.FightNumberAsset5;
	import ssztui.rank.FightNumberAsset6;
	import ssztui.rank.FightNumberAsset7;
	import ssztui.rank.FightNumberAsset8;
	import ssztui.rank.FightNumberAsset9;
	import ssztui.rank.IconStrengthAsset;
	import ssztui.rank.RankEquipAsset;
	import ssztui.rank.RoleBgAsset;
	import ssztui.ui.TagFightAsset;
	
	public class RankRoleView extends Sprite
	{
		private var _currUserId:Number;
		private var _roleInfo:RoleInfo = new RoleInfo();
		
		private var _bg0:IMovieWrapper;
		private var _bg:IMovieWrapper;
		private var _characterBox:Sprite;
		private var _character:ICharacterWrapper;
		
		private var _txtUsername:MAssetLabel;
		private var _txtLevel:MAssetLabel;
		private var _txtClub:MAssetLabel;
		
		private var _fightFireEffect:BaseLoadEffect;
		private var _fightTextBox:MSprite;
		private var _numClass:Array = [
			FightNumberAsset0,FightNumberAsset1,FightNumberAsset2,FightNumberAsset3,
			FightNumberAsset4,FightNumberAsset5,FightNumberAsset6,FightNumberAsset7,
			FightNumberAsset8,FightNumberAsset9];
		
		private var _poses:Array;
		private var _equipCellList:Array;
		
		private var _strengthIcon:MovieClip;
		
		public function RankRoleView()
		{
			super();
			configUI();
			initEvent();
		}
		
		private function configUI():void
		{
			setSize(261,395);
			_bg0 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,261,395)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(9,11,243,374), new Bitmap(new RoleBgAsset())),
			]);
			addChild(_bg0 as DisplayObject);
			
			_fightFireEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.ROLE_FIGHT_EFFECT));
			_fightFireEffect.move(103,248);
			_fightFireEffect.play(SourceClearType.TIME,300000);
			addChild(_fightFireEffect);
			
			_characterBox = new Sprite();
			addChild(_characterBox);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,96,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,136,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,176,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,216,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,256,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(206,96,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(206,136,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(206,176,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(206,216,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(206,256,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(71,294,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(111,294,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(152,294,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,96,227,236),new Bitmap(new RankEquipAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(52,352,67,23),new Bitmap(new TagFightAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtLevel = new MAssetLabel('', MAssetLabel.LABEL_TYPE1);
			_txtLevel.move(130, 35);
			addChild(_txtLevel);
			
			_txtClub = new MAssetLabel('', MAssetLabel.LABEL_TYPE1);
			_txtClub.textColor = 0x00ff00;
			_txtClub.move(130, 53);
			addChild(_txtClub);
			
			_txtUsername = new MAssetLabel('', MAssetLabel.LABEL_TYPE1);
			_txtUsername.textColor = 0xff6600;
			_txtUsername.move(130, 17);
			addChild(_txtUsername);
			
			_poses = [
				new Point(17,96),new Point(17,136),new Point(17,176),new Point(17,216),new Point(17,256),
				new Point(206,96),new Point(206,136),new Point(206,176),new Point(206,216),new Point(206,256),
				new Point(71,294),new Point(111,294),new Point(152,294)
			];
			
			_equipCellList = new Array();
			for(var i:int=0;i<_poses.length;i++)
			{
				var equipCell:EquipItemCell = new EquipItemCell();
				equipCell.move(_poses[i].x,_poses[i].y);
				addChild(equipCell);
				_equipCellList.push(equipCell);
			}
			
			_fightTextBox = new MSprite();
			_fightTextBox.move(122,350);
			addChild(_fightTextBox);
			
			_strengthIcon = new IconStrengthAsset();
			_strengthIcon.x = 190;
			_strengthIcon.y = 22;
			addChild(_strengthIcon);
			_strengthIcon._number.visible = false;
			_strengthIcon.gotoAndStop(1);
		}
		
		private function initEvent():void
		{
			_roleInfo.addEventListener(RoleInfoEvents.ROLEINFO_INITIAL,setData);
			
			_strengthIcon.addEventListener(MouseEvent.MOUSE_OVER,strengthOverHandler);
			_strengthIcon.addEventListener(MouseEvent.MOUSE_OUT,strengthOutHandler);
		}
		
		private function removeEvent():void
		{
			_roleInfo.removeEventListener(RoleInfoEvents.ROLEINFO_INITIAL,setData);
			
			_strengthIcon.addEventListener(MouseEvent.MOUSE_OVER,strengthOverHandler);
			_strengthIcon.addEventListener(MouseEvent.MOUSE_OUT,strengthOutHandler);
			
		}
		
		private function setData(event:Event):void
		{
			if(!_character)
			{
				_character = GlobalAPI.characterManager.createShowCharacterWrapper(_roleInfo.playerInfo);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM,this._characterBox);
				if(_roleInfo.playerInfo.getMounts())
				{
					_character.move(130,252);
				}
				else
				{
					_character.move(130,282);
				}
			}
			
			for each(var i:ItemInfo in _roleInfo.equipList)
			{
				if(i != null && (i.place >= 0 && i.place < _equipCellList.length))
				{
					_equipCellList[i.place].itemInfo = i;
					_equipCellList[i.place].isOther = true;
					_equipCellList[i.place].equipList = _roleInfo.equipList;
				}
			}
			
			var playerInfo:DetailPlayerInfo = _roleInfo.playerInfo;
			_txtUsername.setValue(playerInfo.nick);
			var careerWordId:String;
			switch(playerInfo.career)
			{
				case 1 : 
					careerWordId = 'ssztl.common.yuewangzong';
					break;
				case 3 : 
					careerWordId = 'ssztl.common.tangmen';
					break;
				case 2 : 
					careerWordId = 'ssztl.common.baihuagu';
					break;
			}
			_txtLevel.setValue(LanguageManager.getWord('ssztl.common.levelValue', playerInfo.level) + "  " + LanguageManager.getWord(careerWordId));
			if(playerInfo.clubName != "")
				_txtClub.setValue("[" + LanguageManager.getWord("ssztl.common.club") + "] " +playerInfo.clubName);
			else
				_txtClub.setValue("");
			
			checkStrength();
			setNumbers(playerInfo.fight);
		}
		private function checkStrength():int
		{
			for(var i:int = 6;i<13;i++){
				if(i==7) continue;
				var count:int = equipStrengthChecker(i);
				if(count != 9) break;
			}
			if(i==6){
				_strengthIcon.gotoAndStop(1);
				_strengthIcon._number.visible = false;
				return 6;
			}else{
				var ct:int = i==8?6:i-1;
				_strengthIcon.gotoAndStop(2);
				_strengthIcon._number.visible = true;
				_strengthIcon._number.gotoAndStop(ct-5);
				return ct;
			}
		}
		private function equipStrengthChecker(level:int):int
		{
			var count:int = 0;
			var equipList:Array = _roleInfo.equipList;
			for(var i:int = 0;i<equipList.length;i++)
			{
				if(equipList[i] && equipList[i].place != 4 && equipList[i].place < 10)
				{
					if(equipList[i].strengthenLevel > level || (equipList[i].strengthenLevel == level && equipList[i].strengthenPerfect == 100)) 
						count++;
				}
			}
			return count;
		}
		
		 private function setNumbers(n:int):void
		 {
			 while(_fightTextBox.numChildren>0){
				 _fightTextBox.removeChildAt(0);
			 }
			 var f:String = n.toString();
			 for(var i:int=0; i<f.length; i++)
			 {
				 var mc:Bitmap = new Bitmap(new _numClass[int(f.charAt(i))] as BitmapData);
				 mc.x = i*17; //_fightTextBox.width - i*3;
				 _fightTextBox.addChild(mc);
			 }
		 }
		 private function strengthOverHandler(evt:MouseEvent):void
		 {
			 var level:int = checkStrength();  //_strengthTipsSprites.indexOf(evt.currentTarget as Sprite) + 7;
			 var count:int = equipStrengthChecker(level);
			 var career:int;
			 career = _roleInfo.playerInfo.career;
			 
			 var tipStr:String = "";
			 tipStr += addExtraTip(level,count,career);
			 if(count >= 9)
			 {
				 if(level == 6)
					 level = 8;
				 else
					 level = level + 1;				
				 count = equipStrengthChecker(level);
				 if(level <13) tipStr += addExtraTip(level,count,career,true);
			 }
			 tipStr += "<font color='#bb8050'>" + LanguageManager.getWord("ssztl.common.attentionDetail",level) + "</font>";
			 
			 TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		 }
		 private function addExtraTip(level:int,upCount:int,career:int,second:Boolean = false):String
		 {
			 var tipStr:String = "";
			 if(upCount >= 9)
			 {
				 tipStr += "<font color='#ff9900' size='13'><b>" + LanguageManager.getWord("ssztl.common.allEquipUp",level) + "(" + upCount + "/9)</b></font>\n";
				 tipStr += "<font color='#0099ff'>" + LanguageManager.getWord("ssztl.activity.hasActivated") + "</font>\n";
				 tipStr += "<font color='#cc00ff'>";
			 }else
			 {
				 tipStr += "<font color='#777164' size='13'><b>" + LanguageManager.getWord("ssztl.common.allEquipUp",level) + "(" + upCount + "/9)</b></font>\n";
				 if(!second) tipStr += "<font color='#ff3333'>" + LanguageManager.getWord("ssztl.common.unActivity") + "</font>\n";
				 tipStr += "<font color='#777164'>";
			 }
			 var type:int;
			 var type1:int;
			 if(career == CareerType.SANWU) 
			 {
				 type = PropertyType.ATTR_MUMPHURTATT;
				 type1 = PropertyType.ATTR_MUMPDEFENSE;
			 }
			 if(career == CareerType.XIAOYAO) 
			 {
				 type = PropertyType.ATTR_MAGICHURTATT;
				 type1 = PropertyType.ATTR_MAGICDEFENCE;
			 }
			 if(career == CareerType.LIUXING) 
			 {
				 type = PropertyType.ATTR_FARHURTATT;
				 type1 = PropertyType.ATTR_FARDEFENSE;
			 }
			 var strengthInfo:EquipStrengthTemplate = EquipStrengthTemplateList.getTemplate(level);
			 if(strengthInfo)
			 {
				 if(strengthInfo.attack > 0) tipStr += PropertyType.getName(PropertyType.ATTR_ATTACK) + " +" +  strengthInfo.attack + "\n";
				 if(strengthInfo.defence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_DEFENSE) + " +" +  strengthInfo.defence + "\n";
				 if(strengthInfo.attrAttack > 0) tipStr += PropertyType.getName(type) + " +" +  strengthInfo.attrAttack + "\n";
				 if(strengthInfo.attrDefence > 0) tipStr += PropertyType.getName(type1) + " +" +  strengthInfo.attrDefence + "\n";
				 if(strengthInfo.hp > 0) tipStr += PropertyType.getName(PropertyType.ATTR_HP) + " +" +  strengthInfo.hp + "\n";
				 if(strengthInfo.mp > 0) tipStr += PropertyType.getName(PropertyType.ATTR_MP) + " +" +  strengthInfo.mp + "\n";
				 if(strengthInfo.defenceSuppress > 0) tipStr += PropertyType.getName(PropertyType.ATTR_SUPPRESSIVE_DEFEN) + " +" +  strengthInfo.defenceSuppress + "\n";
				 if(strengthInfo.attrAttackPer > 0) tipStr += PropertyType.getName(type) + " +" + strengthInfo.attrAttackPer/100 + "%" + "\n";
				 if(strengthInfo.mumpDefence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_MUMPDEFENSE) + " +" + strengthInfo.mumpDefence + "\n";
				 if(strengthInfo.magicDefence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_MAGICDEFENCE)+ " +" + strengthInfo.magicDefence + "\n";
				 if(strengthInfo.farDefence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_FARDEFENSE)+ " +" + strengthInfo.farDefence + "\n";
			 }
			 tipStr += "</font>\n"
			 
			 return tipStr;
		 }
		 
		 private function strengthOutHandler(evt:MouseEvent):void
		 {
			 //			EquipStrengthTip.getInstance().hide();
			 TipsUtil.getInstance().hide();
		 }
		 
		 private function setSize(width:int, height:int):void
		 {
			 graphics.beginFill(0,0);
			 graphics.drawRect(0,0,width,height);
			 graphics.endFill();
		 }
		 
		public function updateInfo(info:IndividualRankItem):void
		{
			if(!info)return;
			if(_currUserId == info.userId)return;
			
			_currUserId = info.userId;
			
			clearView();
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.ROLEINFO_UPDATE, handleRoleInfoUpdate);
			RoleInfoSocketHandler.sendPlayerId(_currUserId);
		}
		
		private function clearView():void
		{
			_txtUsername.setValue('');
			_txtLevel.setValue('');
			_txtClub.setValue('');
			
			for each(var i:EquipItemCell in _equipCellList)
			{
				i.itemInfo = null;
				i.equipList = null;
			}
			
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
		}
		
		private function handleRoleInfoUpdate(e:CommonModuleEvent):void
		{ 
			var data:RoleInfo = e.data as RoleInfo;
			if(_currUserId != data.playerInfo.userId) return;
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.ROLEINFO_UPDATE, handleRoleInfoUpdate);
			_roleInfo.equipList = data.equipList;
			_roleInfo.playerInfo = data.playerInfo;
		}
		
		public function show():void
		{
			visible = true;
		}
		
		public function hide():void
		{
			visible = false;
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_roleInfo = null; 
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			if(_equipCellList)
			{
				for each(var equipItem:EquipItemCell in _equipCellList)
				{
					equipItem.dispose();
					equipItem = null;
				}
				_equipCellList = null;
			}
			
			if(_fightFireEffect)
			{
				_fightFireEffect.dispose();
				_fightFireEffect = null;
			}
		}
	}
}