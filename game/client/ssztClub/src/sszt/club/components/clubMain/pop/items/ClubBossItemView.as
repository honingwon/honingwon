package sszt.club.components.clubMain.pop.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.club.camp.ClubBossTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.club.CampItemAsset;
	import ssztui.club.CampItemOverAsset;
	
	public class ClubBossItemView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _overBorder:Bitmap;
		
		private var _bossInfo:ClubBossTemplateInfo;
		private var _callingBossHandler:Function;
		
		private var _nameLable:MAssetLabel;
		private var _callBtn:MCacheAssetBtn1;
		
		private var _selected:Boolean;
		
		public function ClubBossItemView(bossInfo:ClubBossTemplateInfo,callingBossHandler:Function)
		{
			_bossInfo = bossInfo;
			_callingBossHandler = callingBossHandler;
			
			super();
			
			initEvent();
		}
		override protected function configUI():void
		{
			super.configUI();
			buttonMode = true;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1,0,97,138),new Bitmap(new CampItemAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_overBorder = new Bitmap();
			_overBorder.x = 3;
			_overBorder.y = 2;
			addChild(_overBorder);
			
			_nameLable = new MAssetLabel("",MAssetLabel.LABEL_TYPE22);
			_nameLable.move(47,87);
			addChild(_nameLable);
			_nameLable.setHtmlValue(_bossInfo.name);
			
			_callBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.pet.beckon'));
			_callBtn.move(14,104);
			addChild(_callBtn);
		}
		
		private function initEvent():void
		{
			_callBtn.addEventListener(MouseEvent.CLICK,callBtnClicked);
		}
		
		private function removeEvent():void
		{
			_callBtn.removeEventListener(MouseEvent.CLICK,callBtnClicked);
		}
		
		private function callBtnClicked(event:MouseEvent):void
		{
			_callingBossHandler(_bossInfo);
		}
		
		public function get bossInfo():ClubBossTemplateInfo
		{
			return _bossInfo;
		}
		
		public function set selected(value:Boolean):void
		{
			if(value == _selected) return;
			_selected = value;
			if(_selected)
			{
				_overBorder.bitmapData = new CampItemOverAsset() as BitmapData;
			}
			else
			{
				if(_overBorder && _overBorder.bitmapData) _overBorder.bitmapData.dispose();
			}
		}
		
		public function get callBtn():MCacheAssetBtn1
		{
			return _callBtn;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			
			_bossInfo = null;
			_callingBossHandler = null;
			
			_nameLable = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_callBtn)
			{
				_callBtn.dispose();
				_callBtn = null;
			}
		}
	}
}