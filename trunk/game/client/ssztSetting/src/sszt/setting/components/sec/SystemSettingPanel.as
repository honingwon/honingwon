package sszt.setting.components.sec
{
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.SharedObjectInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.manager.SoundManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.setting.mediators.SettingMediator;
	import sszt.setting.socketHandlers.ConfigSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	import ssztui.setting.TagAsset;
	
	public class SystemSettingPanel extends Sprite implements ISettingPanel
	{
		private var _mediator:SettingMediator;
		private var _bgasset:IMovieWrapper;
//		private var _labels:Vector.<String>;
//		private var _checkboxList:Vector.<CheckBox>;
		private var _labels:Array;
		private var _checkboxList:Array;
		private var _resetBtn:MCacheAssetBtn1;
		private var _saveBtn:MCacheAssetBtn1;
//		private var _checkboxInfos:Vector.<SharedObjectInfo>;
		private var _checkboxInfos:Array;
		private var _musicSlider:Slider;
		private var _soundSlider:Slider;
		
		public function SystemSettingPanel(mediator:SettingMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bgasset = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,288,289)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,15,276,187),new Bitmap(new TagAsset())),
			]);
			addChild(_bgasset as DisplayObject);
			
			/*
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.setting.soundSetting"),MAssetLabel.LABEL_TYPE_TITLE);
			label2.move(384,5);
			addChild(label2);
			*/
			
//			_labels = Vector.<String>([
//				"屏蔽他人造型显示","屏蔽他人名字信息","屏蔽其他玩家称号","屏蔽怪物造型显示","最低同屏人数配置","关闭技能特效",
//				"拒绝交易请求","拒绝好友请求","拒绝私聊请求","拒绝组队邀请","拒绝帮会邀请","拒绝切磋邀请",
//				"开启背景音乐","开启动作音效"
//			]);
//			var poses:Vector.<Point> = Vector.<Point>([
//				new Point(12,38),new Point(146,38),new Point(12,70),new Point(146,70),new Point(12,102),new Point(146,102),
//				new Point(12,166),new Point(146,166),new Point(12,198),new Point(146,198),new Point(12,230),new Point(146,230),
//				new Point(312,66),new Point(312,150)
//			]);
//			_checkboxInfos = Vector.<SharedObjectInfo>([
//				SharedObjectManager.hidePlayerCharacter,
//				SharedObjectManager.hidePlayerName,
//				SharedObjectManager.hidePlayerTitle,
//				SharedObjectManager.hideMonsterCharacter,
//				SharedObjectManager.playerCharacterLimit,
//				SharedObjectManager.hideSkillEffect,
//				SharedObjectManager.tradeUnable,
//				SharedObjectManager.friendUnable,
//				SharedObjectManager.privateChatUnable,
//				SharedObjectManager.groupInviteUnable,
//				SharedObjectManager.clubInviteUnable,
//				SharedObjectManager.frightInviteUnable,
//				SharedObjectManager.musicEnable,
//				SharedObjectManager.soundEnable
//			]);
//			_checkboxList = new Vector.<CheckBox>();

			_labels = [
				LanguageManager.getWord("ssztl.setting.label1"),
				LanguageManager.getWord("ssztl.setting.label2"),
				LanguageManager.getWord("ssztl.setting.label3"),
				LanguageManager.getWord("ssztl.setting.label4"),
				LanguageManager.getWord("ssztl.setting.label5"),
				LanguageManager.getWord("ssztl.setting.label6"),
				LanguageManager.getWord("ssztl.setting.label7"),
				LanguageManager.getWord("ssztl.setting.label8"),
				LanguageManager.getWord("ssztl.setting.label9"),
				LanguageManager.getWord("ssztl.setting.label10"),
				LanguageManager.getWord("ssztl.setting.label11"),
				LanguageManager.getWord("ssztl.setting.label12"),
				LanguageManager.getWord("ssztl.setting.label13"),
				LanguageManager.getWord("ssztl.setting.label14")
			];
			
			var poses:Array = [
				new Point(11,106),new Point(147,106),new Point(11,128),new Point(147,128),new Point(11,150),new Point(147,150),
				new Point(11,213),new Point(147,213),new Point(11,235),new Point(147,235),new Point(11,257),new Point(147,257),
				new Point(11,43),new Point(147,43)
			];
			_checkboxInfos = [
				SharedObjectManager.hidePlayerCharacter,
				SharedObjectManager.hidePlayerName,
				SharedObjectManager.hidePlayerTitle,
				SharedObjectManager.hideMonsterCharacter,
				SharedObjectManager.playerCharacterLimit,
				SharedObjectManager.hideSkillEffect,
				SharedObjectManager.tradeUnable,
				SharedObjectManager.friendUnable,
				SharedObjectManager.privateChatUnable,
				SharedObjectManager.groupInviteUnable,
				SharedObjectManager.clubInviteUnable,
				SharedObjectManager.frightInviteUnable,
				SharedObjectManager.musicEnable,
				SharedObjectManager.soundEnable
			];
			_checkboxList = [];
			for(var j:int = 0; j < _labels.length; j++)
			{
				var checkbox:CheckBox = new CheckBox();
				checkbox.width = 140;
				checkbox.height = 17;
				checkbox.move(poses[j].x,poses[j].y);
				checkbox.label = _labels[j];
				if(j == 6)checkbox.selected = !GlobalData.selfPlayer.getAllowTrade();
				else if(j == 7)checkbox.selected = !GlobalData.selfPlayer.getAllowAddFriend();
				else if(j == 8)checkbox.selected = !GlobalData.selfPlayer.getAllowPrivateChat();
				else if(j == 9)checkbox.selected = !GlobalData.selfPlayer.getAllowGroupInvite();
				else if(j == 10)checkbox.selected = !GlobalData.selfPlayer.getAllowClubInvite();
				else if(j == 11)checkbox.selected = !GlobalData.selfPlayer.getAllowFrightInvite();
				else checkbox.selected = _checkboxInfos[j].value as Boolean;
				addChild(checkbox);
				_checkboxList.push(checkbox);
			}
			
			_musicSlider = new Slider();
			_musicSlider.move(124,16);
			_musicSlider.width = 135;
			_musicSlider.maximum = 10;
			_musicSlider.value = SharedObjectManager.musicVolumn.value as Number;
//			addChild(_musicSlider);
			_soundSlider = new Slider();
			_soundSlider.move(124,39);
			_soundSlider.width = 135;
			_soundSlider.maximum = 10;
			_soundSlider.value = SharedObjectManager.soundVolumn.value as Number;
//			addChild(_soundSlider);			
			
			//_resetBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.setting.backDefault"));
			_resetBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.setting.backDefault"));
			_resetBtn.move(72,296);
			addChild(_resetBtn);
			
			//_saveBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.saveConfigure"));
			_saveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.save"));
			_saveBtn.move(146,296);
			addChild(_saveBtn);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _checkboxList.length; i++)
			{
				_checkboxList[i].addEventListener(Event.CHANGE,checkBoxChangeHandler);
			}
			_musicSlider.addEventListener(Event.CHANGE,musicSliderChangeHandler);
			_soundSlider.addEventListener(Event.CHANGE,soundSliderChangeHandler);
			_resetBtn.addEventListener(MouseEvent.CLICK,resetBtnClickHandler);
			_saveBtn.addEventListener(MouseEvent.CLICK,saveBtnClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.VOICE_CHANGE,voiceChangeHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _checkboxList.length; i++)
			{
				_checkboxList[i].removeEventListener(Event.CHANGE,checkBoxChangeHandler);
			}
			_musicSlider.removeEventListener(Event.CHANGE,musicSliderChangeHandler);
			_soundSlider.removeEventListener(Event.CHANGE,soundSliderChangeHandler);
			_resetBtn.removeEventListener(MouseEvent.CLICK,resetBtnClickHandler);
			_saveBtn.removeEventListener(MouseEvent.CLICK,saveBtnClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.VOICE_CHANGE,voiceChangeHandler);
		}
		
		private function voiceChangeHandler(evt:CommonModuleEvent):void
		{
			_checkboxList[12].selected = SharedObjectManager.musicEnable.value;
			_checkboxList[13].selected = SharedObjectManager.soundEnable.value;
		}
		
		private function checkBoxChangeHandler(e:Event):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var checkbox:CheckBox = e.currentTarget as CheckBox;
			var index:int = _checkboxList.indexOf(checkbox);
			switch(index)
			{
				case 0:
					SharedObjectManager.setHidePlayerCharacter(checkbox.selected);
					break;
				case 1:
					SharedObjectManager.setHidePlayerName(checkbox.selected);
					break;
				case 2:
					SharedObjectManager.setHidePlayerTitle(checkbox.selected);
					break;
				case 3:
					SharedObjectManager.setHideMonsterCharacter(checkbox.selected);
					break;
				case 4:
					SharedObjectManager.setPlayerCharacterLimit(checkbox.selected);
					break;
				case 5:
					SharedObjectManager.setHideSkillEffect(checkbox.selected);
					break;
				case 12:
					_musicSlider.enabled = checkbox.selected;
					SharedObjectManager.setMusicEnable(checkbox.selected);
					SoundManager.instance.setMusicMute(!checkbox.selected);
					break;
				case 13:
					_soundSlider.enabled = checkbox.selected;
					SharedObjectManager.setSoundEnable(checkbox.selected);
					SoundManager.instance.setSoundMute(!checkbox.selected);
					break;
				default:
					_checkboxInfos[index].value = checkbox.selected;
					break;
			}
		}
		
		private function musicSliderChangeHandler(e:Event):void
		{
			SharedObjectManager.setMusicVolumn(_musicSlider.value);
		}
		
		private function soundSliderChangeHandler(e:Event):void
		{
			SharedObjectManager.setSoundVolumn(_soundSlider.value);
		}
		
		private function resetBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			SharedObjectManager.resetSystemSetting();
			
			for(var i:int = 0; i < _checkboxList.length; i++)
			{
				_checkboxList[i].selected = _checkboxInfos[i].value as Boolean;
			}
			_musicSlider.value = SharedObjectManager.musicVolumn.value as Number;
			_soundSlider.value = SharedObjectManager.soundVolumn.value as Number;
		}
		
		private function saveBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			for(var i:int = 0; i < _checkboxList.length; i++)
			{
				_checkboxInfos[i].update();
			}
			SharedObjectManager.musicVolumn.update();
			SharedObjectManager.soundVolumn.update();
			SharedObjectManager.save();
			
			var c1:int = _checkboxList[6].selected ? 1 : 0;
			var c2:int = _checkboxList[7].selected ? 2 : 0;
			var c3:int = _checkboxList[8].selected ? 4 : 0;
			var c4:int = _checkboxList[9].selected ? 8 : 0;
			var c5:int = _checkboxList[10].selected ? 16 : 0;
			var c6:int = _checkboxList[11].selected ? 32 : 0;
			GlobalData.selfPlayer.clientConfig = c1 + c2 + c3 + c4 + c5 + c6;
			ConfigSocketHandler.sendConfig(c1 + c2 + c3 + c4 + c5 + c6);
		}
		
		private function createTitleField(label:String):TextField
		{
			var textfield:TextField = new TextField();
			textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60);
			textfield.width = 60;
			textfield.height = 18;
			textfield.text = label;
			return textfield;
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			SharedObjectManager.musicVolumn.reset();
			SharedObjectManager.soundVolumn.reset();
			if(_checkboxInfos)
			{
				for(var i:int = 0; i < _checkboxInfos.length; i++)
				{
					_checkboxInfos[i].reset();
				}
			}
			_checkboxInfos = null;
			if(_bgasset)
			{
				_bgasset.dispose();
				_bgasset = null;
			}
			if(_resetBtn)
			{
				_resetBtn.dispose();
				_resetBtn = null;
			}
			if(_saveBtn)
			{
				_saveBtn.dispose();
				_saveBtn = null;
			}
			_checkboxList = null;
			_labels = null;
			_mediator = null;
		}
	}
}