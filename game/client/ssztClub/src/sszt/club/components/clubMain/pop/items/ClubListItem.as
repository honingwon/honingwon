package sszt.club.components.clubMain.pop.items
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.datas.list.ClubListItemInfo;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubTryinSocketHandler;
	import sszt.constData.VipType;
	import sszt.core.caches.VipIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class ClubListItem extends MSprite
	{
		private var _mediator:ClubMediator;
		private var _info:ClubListItemInfo;
		private var _rank:int;
		private var _rankField:TextField,_clubField:TextField,_masterField:TextField;
		private var _levelField:TextField,_richField:TextField,_memberField:TextField;
		private var _checkBtn:MCacheAssetBtn1,_applyBtn:MCacheAssetBtn1;
		private var _asset:Bitmap;
		private var _wordType:String = "Tahoma";
		
		public function ClubListItem(mediator:ClubMediator,info:ClubListItemInfo,rank:int)
		{
			_mediator = mediator;
			_info = info;
			_rank = rank;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_rankField = new TextField();
			_rankField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_rankField.mouseEnabled = _rankField.mouseWheelEnabled = false;
			_rankField.width = 49;
			_rankField.x = 1;
			_rankField.y = 3;
			_rankField.text = String(_rank);
			addChild(_rankField);
			_clubField = new TextField();
			_clubField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT);
			_clubField.mouseEnabled = _clubField.mouseWheelEnabled = false;
			_clubField.width = 107;
			_clubField.x = 62;
			_clubField.y = 3;
			_clubField.text = _info.name;
			addChild(_clubField);
			
//			var type:int = VipType.getVipType(_info.masterType);
//			if(type != 0)
//			{
//				if(type == 1)_asset = new Bitmap(VipIconCaches.vipCache[1]);
//				else if(type == 2)_asset = new Bitmap(VipIconCaches.vipCache[2]);
//				else if(type == 3)_asset = new Bitmap(VipIconCaches.vipCache[3]);
//				_asset.x = 190;
//				_asset.y = 7;
//				addChild(_asset);
//			}
			
			_masterField = new TextField();
			_masterField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT);
			_masterField.mouseEnabled = _masterField.mouseWheelEnabled = false;
			_masterField.width = 111;
			_masterField.x = 217;
			_masterField.y = 3;
			_masterField.text = _info.masterName;
			addChild(_masterField);
			_levelField = new TextField();
			_levelField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_levelField.mouseEnabled = _levelField.mouseWheelEnabled = false;
			_levelField.width = 49;
			_levelField.x = 330;
			_levelField.y = 3;
			_levelField.text = String(_info.level);
			addChild(_levelField);
			_richField = new TextField();
			_richField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_richField.mouseEnabled = _richField.mouseWheelEnabled = false;
			_richField.width = 80;
			_richField.x = 380;
			_richField.y = 3;
			_richField.text = String(_info.rich);
			addChild(_richField);
			_memberField = new TextField();
			_memberField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_memberField.mouseEnabled = _memberField.mouseWheelEnabled = false;
			_memberField.width = 49;
			_memberField.x = 462;
			_memberField.y = 3;
			_memberField.text = _info.currentMember + "/" + _info.totalMember;
			addChild(_memberField);
			
			_checkBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.check"));
			_checkBtn.move(525,1);
			addChild(_checkBtn);
			_applyBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.apply"));
			_applyBtn.move(567,1);
			addChild(_applyBtn);
		}
		
		private function initEvent():void
		{
			_checkBtn.addEventListener(MouseEvent.CLICK,checkBtnClickHandler);
			_applyBtn.addEventListener(MouseEvent.CLICK,applyBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_checkBtn.removeEventListener(MouseEvent.CLICK,checkBtnClickHandler);
			_applyBtn.removeEventListener(MouseEvent.CLICK,applyBtnClickHandler);
		}
		
		private function checkBtnClickHandler(e:MouseEvent):void
		{
			_mediator.showInfoCheckPanel(_info,_rank);
		}
		
		private function applyBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.selfPlayer.clubName != "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.alreadyInClub"));
			}
			else if(GlobalData.selfPlayer.level < 30)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.unableJionClub"));
			}
			else
			{
				ClubTryinSocketHandler.send(_info.id);
			}
		}
		
		
		override public function dispose():void
		{
			removeEvent();
			if(_checkBtn)
			{
				_checkBtn.dispose();
				_checkBtn = null;
			}
			if(_applyBtn)
			{
				_applyBtn.dispose();
				_applyBtn = null;
			}
			_asset = null;
			
			_rankField = null;
			_clubField = null;
			_masterField = null;
			_levelField = null;
			_richField = null;
			_memberField = null;
			_info = null;
			_mediator = null;
			super.dispose();
		}
	}
}