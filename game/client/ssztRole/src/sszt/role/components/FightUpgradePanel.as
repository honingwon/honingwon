package sszt.role.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.DirectType;
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToRoleData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.character.ICharacterWrapper;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.role.FightPanelBtnAsset1;
	import ssztui.role.FightPanelBtnAsset2;
	import ssztui.role.FightPanelBtnAsset3;
	import ssztui.role.FightPanelBtnAsset4;
	import ssztui.role.FightPanelBtnAsset5;
	import ssztui.role.FightPanelBtnAsset6;
	import ssztui.role.FightPanelTagAsset1;
	import ssztui.role.FightPanelTagAsset2;
	import ssztui.role.FightPanelTagAsset3;
	import ssztui.role.FightPanelTagAsset4;
	import ssztui.role.FightPanelTagAsset5;
	import ssztui.role.FightPanelTagAsset6;
	import ssztui.role.FightPanelTitleAsset;

	public class FightUpgradePanel extends MPanel
	{
		private static var _instance:FightUpgradePanel;
		
		private var _toRoleData:ToRoleData;
		private var _bg:IMovieWrapper;
		private var _cBg:Bitmap;
		private var _holeBg:Bitmap;
		private var _tip:MAssetLabel;
		private var _character:ICharacterWrapper;
		private var _imageLayout:MSprite;
		
		private var _icons:Array;
		private var _tags:Array;
		
		private var _numAssets:Array = [];
		private var _fightTextBox:MSprite;
		
		public function FightUpgradePanel(data:ToRoleData)
		{
			super(new MCacheTitle1("",new Bitmap(new FightPanelTitleAsset())),true,-1,true,false);
			_toRoleData = data;
		}
		public static function getInstance():FightUpgradePanel{
			if (_instance == null){
				_instance = new (FightUpgradePanel)();
			};
			return (_instance);
		}
		
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(508,329);
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,4,492,317)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,8,484,309)),
				]);
			addContent(_bg as DisplayObject);
			
			_cBg = new Bitmap();
			_cBg.x = 14;
			_cBg.y = 11;
			addContent(_cBg);
			
			_imageLayout = new MSprite();
			addContent(_imageLayout);			
			if(!_character)
			{
				_character = GlobalAPI.characterManager.createShowCharacterWrapper(GlobalData.selfPlayer);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM,this._imageLayout);
				if(GlobalData.selfPlayer.getMounts())
				{
					_character.move(252,232);
				}
				else
				{
					_character.move(252,262);
				}
			}
			
			_holeBg = new Bitmap();
			_holeBg.x = 41;
			_holeBg.y = 68;
			addContent(_holeBg);
			
			_icons = [];
			var iconPoint:Array = [new Point(196,71),new Point(166,112),new Point(150,165),new Point(163,217),new Point(285,72),new Point(315,106)];
			var iconClass:Array = [FightPanelBtnAsset1,FightPanelBtnAsset2,FightPanelBtnAsset3,FightPanelBtnAsset4,FightPanelBtnAsset5,FightPanelBtnAsset6];
			
			_tags = [];
			var tagPoint:Array = [new Point(90,50),new Point(64,101),new Point(58,184),new Point(74,240),new Point(340,48),new Point(367,100)];
			var tagClass:Array = [FightPanelTagAsset1,FightPanelTagAsset2,FightPanelTagAsset3,FightPanelTagAsset4,FightPanelTagAsset5,FightPanelTagAsset6];
			
			for(var i:int=0; i<6; i++)
			{
				var btn:MBitmapButton = new MBitmapButton(new iconClass[i]() as BitmapData);
				btn.move(iconPoint[i].x,iconPoint[i].y);
				addContent(btn);
				_icons.push(btn);
				
				var tag:MBitmapButton = new MBitmapButton(new tagClass[i]() as BitmapData);
				tag.move(tagPoint[i].x,tagPoint[i].y);
				addContent(tag);
				_tags.push(tag); 
			}
			//战斗力
			_numAssets.push(
				AssetUtil.getAsset("ssztui.scene.NumberAsset0") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset6") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset7") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset8") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset9") as BitmapData
			);
			_fightTextBox = new MSprite();
			_fightTextBox.move(254,33);
			addContent(_fightTextBox);
			updatePropertyHandler(null);
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_tip.move(254,289);
			addContent(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.role.fightUpTip"));
			
			initEvent();
			
		}
		public function assetsCompleteHandler():void
		{
			_cBg.bitmapData = AssetUtil.getAsset("ssztui.role.FightBgAsset",BitmapData) as BitmapData;
			_holeBg.bitmapData = AssetUtil.getAsset("ssztui.role.FightHoleBgAsset",BitmapData) as BitmapData;
		}
		private function initEvent():void
		{
			for(var i:int=0; i<6; i++)
			{
				_icons[i].addEventListener(MouseEvent.CLICK,linkClickHandler);
				_tags[i].addEventListener(MouseEvent.CLICK,linkClickHandler);
			}
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,updatePropertyHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		private function removeEvent():void
		{
			for(var i:int=0; i<6; i++)
			{
				_icons[i].removeEventListener(MouseEvent.CLICK,linkClickHandler);
				_tags[i].removeEventListener(MouseEvent.CLICK,linkClickHandler);
			}
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,updatePropertyHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			
		}
		private function linkClickHandler(evt:MouseEvent):void
		{
			var argument:int = _icons.indexOf(evt.target);
			if(argument == -1) argument = _tags.indexOf(evt.target);
			switch(argument)
			{
				case 0:			//技能
					SetModuleUtils.addSkill();
					break;
				case 1:			//强化
					SetModuleUtils.addFurnace();
					break;
				case 2:			//坐骑
					SetModuleUtils.addMounts(new ToMountsData(0));
					break;
				case 3:			//宠物
					SetModuleUtils.addPet();
					break;
				case 4:			//副本(活动)
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.MAIN,2));
					break;
				case 5:			//穴位
					SetModuleUtils.addRole(GlobalData.selfPlayer.userId,1);
					break;
			}
		}
		//战斗力数据更新处理
		private function updatePropertyHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			setNumbers(GlobalData.selfPlayer.fight);
		}
		private function setNumbers(n:int,sp:int = 15):void
		{
			while(_fightTextBox && _fightTextBox.numChildren>0){
				_fightTextBox.removeChildAt(0);
			}
			var f:String = n.toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(_numAssets[int(f.charAt(i))]);
				mc.x = i*sp; 
				_fightTextBox.addChild(mc);
			}
			
			_fightTextBox.x = 254-Math.round(_fightTextBox.width/2);
		}
		private function setPanelPosition(e:Event):void
		{
			move( Math.round((CommonConfig.GAME_WIDTH - 508)/2), Math.round((CommonConfig.GAME_HEIGHT - 329)/2));
		}
		
		override public function dispose():void
		{
			removeEvent();
			_instance = null;
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_cBg && _cBg.bitmapData)
			{
				_cBg.bitmapData.dispose();
				_cBg = null;
			}
			if(_holeBg && _holeBg.bitmapData)
			{
				_holeBg.bitmapData.dispose();
				_holeBg = null;
			}
			if(_fightTextBox && _fightTextBox.parent)
			{
				while(_fightTextBox && _fightTextBox.numChildren>0){
					_fightTextBox.removeChildAt(0);
				}
				_fightTextBox.parent.removeChild(_fightTextBox);
				_fightTextBox = null;
			}
			_tags = null;
			_icons = null;
			_tags = null;
			_numAssets = null;
			_tip = null;
			if(_character){_character.dispose();_character = null;}
			if(_imageLayout){_imageLayout.dispose();_imageLayout = null;}
			super.dispose();
		}
	}
}