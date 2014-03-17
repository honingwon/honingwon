package sszt.rank.components.views.mount
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
	import sszt.core.data.mounts.MountShowInfoUpdateEvent;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.mounts.MountsGetMountShowItemSocketHandler;
	import sszt.core.view.tips.MountsDiamondTip;
	import sszt.core.view.tips.MountsStarLevelTip;
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
	
	public class RankMountView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _currId:Number;
		private var _rankItemInfo:OtherRankItem;
		private var _mountsItemInfo:MountsItemInfo;
		
		private var _userNameLabel:MAssetLabel;
		private var _mountLevelLabel:MAssetLabel;
		
		private var _mountStairLabel:MAssetLabel;
		private var _mountQualityLabel:MAssetLabel;
		private var _mountGrowLabel:MAssetLabel;
		private var _mountRefinedLabel:MAssetLabel;		
		private var _mountSpeedLabel:MAssetLabel;
		
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
		
		public function RankMountView()
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
				LanguageManager.getWord("ssztl.common.speed") + "：\n" + 
				LanguageManager.getWord("ssztl.sword.qualityLevel") + "：\n" + 
				LanguageManager.getWord("ssztl.common.qualityLabel") + "：\n" + 
				LanguageManager.getWord("ssztl.common.growLabel") + "：\n"  +
				LanguageManager.getWord("ssztl.common.refinedLabel")+ "："
			);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,261,395)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(9,11,243,374), new Bitmap(new PetBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(25,27,50,70),tag),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(52,352,67,23),new Bitmap(new TagFightAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_characterCon = new MSprite();
			_characterCon.move(130,240);
			_characterCon.mouseEnabled = _characterCon.mouseChildren = false;
			addChild(_characterCon);
			
			_userNameLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_userNameLabel.move(61,27);
			addChild(_userNameLabel);
			
			_mountLevelLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_mountLevelLabel.move(61,47);
			addChild(_mountLevelLabel);
			
			_mountSpeedLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7,'left');
			_mountSpeedLabel.move(61,67);
			addChild(_mountSpeedLabel);
			
			_mountStairLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE9,'left');
			_mountStairLabel.move(61,87);
			addChild(_mountStairLabel);
			
			_mountQualityLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_mountQualityLabel.move(61,107);
			addChild(_mountQualityLabel);
			
			_mountGrowLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_mountGrowLabel.move(61,127);
			addChild(_mountGrowLabel);
			
			_mountRefinedLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_mountRefinedLabel.move(61,147);
			addChild(_mountRefinedLabel);
			
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
			if(!_mountsItemInfo) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			var template_id:int = this._mountsItemInfo.templateId;
			var star_level:int = this._mountsItemInfo.star;
			var diamond:int = this._mountsItemInfo.diamond;
			var tipStr:String;
			if (index == 0 )
				tipStr = MountsStarLevelTip.getInstance().getDataStr(template_id,star_level);
			else if ( index == 1)
				tipStr = MountsDiamondTip.getInstance().getDataStr(template_id, diamond);
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
			
			MountsGetMountShowItemSocketHandler.send(_rankItemInfo.userId, _currId);
			
			GlobalData.mountShowInfo.addEventListener(MountShowInfoUpdateEvent.MOUNT_SHOW_INFO_LOAD_COMPLETE,handleMountInfoUpdate);
		}
		
		private function handleMountInfoUpdate(e:MountShowInfoUpdateEvent):void
		{ 
			var info:MountsItemInfo = GlobalData.mountShowInfo.mountShowItemInfo;
			if(_currId !=info.id) return;
			
			_mountsItemInfo = info;
			
			GlobalData.mountShowInfo.addEventListener(MountShowInfoUpdateEvent.MOUNT_SHOW_INFO_LOAD_COMPLETE,handleMountInfoUpdate);
			
			_userNameLabel.setValue(_rankItemInfo.nick);
			_mountLevelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_mountsItemInfo.level.toString()));
			_mountSpeedLabel.setValue(_mountsItemInfo.speed + "%");
			
			_mountStairLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_mountsItemInfo.stairs));
			_mountQualityLabel.setValue(_mountsItemInfo.quality + "/" + _mountsItemInfo.upQuality);
			_mountGrowLabel.setValue(_mountsItemInfo.grow + "/" + _mountsItemInfo.upGrow);
			_mountRefinedLabel.setValue(_mountsItemInfo.refined + "/" + _mountsItemInfo.level);
			
			setNumbers(_mountsItemInfo.fight);
			if(_mountsItemInfo.star>-1) _starBg.gotoAndStop(_mountsItemInfo.star+1);
			if(_mountsItemInfo.diamond>-1) _diamondBg.gotoAndStop(_mountsItemInfo.diamond+1);
			
			if(_character){_character.dispose();_character = null;}
			if(_mountsItemInfo)
			{
				_character = GlobalAPI.characterManager.createShowMountsOnlyCharacter(_mountsItemInfo);
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
			_mountsItemInfo = null; 
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
			_mountLevelLabel = null;
			_mountSpeedLabel = null;
			_mountStairLabel = null;
			_mountQualityLabel = null;
			_mountGrowLabel = null;
			_mountRefinedLabel = null;
		}
	}
}