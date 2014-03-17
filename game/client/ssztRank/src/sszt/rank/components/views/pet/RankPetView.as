package sszt.rank.components.views.pet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetShowInfoUpdateEvent;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pet.PetGetPetShowItemSocketHandler;
	import sszt.core.view.tips.PetDiamondTip;
	import sszt.core.view.tips.PetStarLevelTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.rank.data.item.OtherRankItem;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
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
	import ssztui.rank.IconDiamondAsset;
	import ssztui.rank.IconStarAsset;
	import ssztui.rank.PetBgAsset;
	import ssztui.ui.TagFightAsset;
	
	public class RankPetView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _currId:Number;
		private var _rankItemInfo:OtherRankItem;
		private var _petItemInfo:PetItemInfo;
		
		private var _userNameLabel:MAssetLabel;
		private var _petLevelLabel:MAssetLabel;
		
		private var _petStairLabel:MAssetLabel;
		private var _petQualityLabel:MAssetLabel;
		private var _petGrowLabel:MAssetLabel;
		
		private var _fightTextBox:MSprite;
		private var _numClass:Array = [
			FightNumberAsset0,FightNumberAsset1,FightNumberAsset2,FightNumberAsset3,
			FightNumberAsset4,FightNumberAsset5,FightNumberAsset6,FightNumberAsset7,
			FightNumberAsset8,FightNumberAsset9];
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _tipBgList:Array;
		private var _characterCon:MSprite;
		private var _character:ICharacter;
		
		public function RankPetView()
		{
			super();
			configUI();
			initEvent();
		}
		
		private function configUI():void
		{
			
			var tag:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			tag.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			tag.setValue(
				LanguageManager.getWord("ssztl.common.employer") + "：\n" + 
				LanguageManager.getWord("ssztl.common.level") + "：\n" + 
				LanguageManager.getWord("ssztl.sword.qualityLevel") + "：\n" + 
				LanguageManager.getWord("ssztl.common.qualityLabel") + "：\n" + 
				LanguageManager.getWord("ssztl.common.growLabel") + "："
			);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,261,395)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(9,11,243,374), new Bitmap(new PetBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(25,27,50,70),tag),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(52,352,67,23),new Bitmap(new TagFightAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_characterCon = new MSprite();
			_characterCon.move(130,270);
			_characterCon.mouseEnabled = _characterCon.mouseChildren = false;
			addChild(_characterCon);
			
			_userNameLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_userNameLabel.move(61,27);
			addChild(_userNameLabel);
			
			_petLevelLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_petLevelLabel.move(61,47);
			addChild(_petLevelLabel);
			
			_petStairLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE9,'left');
			_petStairLabel.move(61,67);
			addChild(_petStairLabel);
			
			_petQualityLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_petQualityLabel.move(61,87);
			addChild(_petQualityLabel);
			
			_petGrowLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_petGrowLabel.move(61,107);
			addChild(_petGrowLabel);
			
			_fightTextBox = new MSprite();
			_fightTextBox.move(122,350);
			addChild(_fightTextBox);
			
			_starBg = new IconStarAsset();
			_starBg.x = 165;
			_starBg.y = 25;
			addChild(_starBg);
			
			_diamondBg = new IconDiamondAsset();
			_diamondBg.x = 202;
			_diamondBg.y = 25;
			addChild(_diamondBg);
			_starBg.gotoAndStop(1);
			_diamondBg.gotoAndStop(1);
			
			_tipBgList = [_starBg,_diamondBg];
			
		}
		
		private function initEvent():void
		{
			for(var j:int = 0 ;j< _tipBgList.length ; ++j)
			{
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var j:int = 0 ;j< _tipBgList.length ; ++j)
			{
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
			
		}
		private function overHandler(evt:MouseEvent):void
		{
			if(!_petItemInfo) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			var petType:int = _petItemInfo.type;
			var templateId:int = _petItemInfo.templateId;
			var starLevel:int = _petItemInfo.star;
			var diamond:int = _petItemInfo.diamond;
			var tipStr:String;
			if (index == 0 )
			{
				tipStr = PetStarLevelTip.getInstance().getDataStr(templateId,starLevel);
			}
			else if ( index == 1)
			{
				tipStr = PetDiamondTip.getInstance().getDataStr(petType, templateId, diamond);
			}
			
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
			
		}
		public function updateInfo(info:OtherRankItem):void
		{
			if(!info)return;
			_rankItemInfo = info;
			
			_currId = _rankItemInfo.itemId;
			
			clearView();
			
			PetGetPetShowItemSocketHandler.send(_rankItemInfo.userId, _currId);
			
			GlobalData.petShowInfo.addEventListener(PetShowInfoUpdateEvent.PET_SHOW_INFO_LOAD_COMPLETE,handlePetShowInfoUpdate);
		}
		
		private function handlePetShowInfoUpdate(e:PetShowInfoUpdateEvent):void
		{ 
			var info:PetItemInfo = GlobalData.petShowInfo.petShowItemInfo;
			if(_currId !=info.id) return;
			
			_petItemInfo = info;
			
			GlobalData.mountShowInfo.addEventListener(PetShowInfoUpdateEvent.PET_SHOW_INFO_LOAD_COMPLETE,handlePetShowInfoUpdate);
			
			_userNameLabel.setValue(_rankItemInfo.nick);
			_petLevelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_petItemInfo.level.toString()));
			
			_petStairLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_petItemInfo.stairs));
			_petQualityLabel.setValue(_petItemInfo.quality + "/" + _petItemInfo.upQuality);
			_petGrowLabel.setValue(_petItemInfo.grow + "/" + _petItemInfo.upGrow);
			
			setNumbers(_petItemInfo.fight);
			if(_petItemInfo.star>-1) _starBg.gotoAndStop(_petItemInfo.star+1);
			if(_petItemInfo.diamond>-1) _diamondBg.gotoAndStop(_petItemInfo.diamond+1);
			
			if(_character){_character.dispose();_character = null;}
			var tmp:PetTemplateInfo;
			if(_petItemInfo)
			{
				if(_petItemInfo.styleId == 0 || _petItemInfo.styleId == -1)
				{
					tmp = _petItemInfo.template;
				}
				else
				{
					tmp = PetTemplateList.getPet(_petItemInfo.styleId);
					if(!tmp)tmp = _petItemInfo.template;
				}
				_character = GlobalAPI.characterManager.createPetCharacter( tmp);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM);
				_characterCon.addChild(_character as DisplayObject);
			}
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
		
		private function clearView():void
		{
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
			_petItemInfo = null; 
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_fightTextBox && _fightTextBox.parent)
			{
				while(_fightTextBox.numChildren>0){
					_fightTextBox.removeChildAt(0);
				}
				_fightTextBox.parent.removeChild(_fightTextBox);
				_fightTextBox = null;
			}
			_userNameLabel = null;
			_petLevelLabel = null;
			_petStairLabel = null;
			_petQualityLabel = null;
			_petGrowLabel = null;
			
			
		}
	}
}