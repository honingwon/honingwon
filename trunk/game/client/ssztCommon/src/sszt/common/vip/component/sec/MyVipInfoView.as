package sszt.common.vip.component.sec
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.common.vip.component.cell.VipAwardCell;
	import sszt.core.data.GlobalData;
	import sszt.core.data.vip.VipAwardType;
	import sszt.core.data.vip.VipCommonEvent;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.ui.SplitCompartLine2;
	import ssztui.vip.BoxBgAsset;
	
	public class MyVipInfoView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		public var _txtPrivilege:MAssetLabel;
		private var _transferCell:VipAwardCell;
		private var _speakerCell:VipAwardCell;
		private var _yuanbaoCell:VipAwardCell;
		private var _copperCell:VipAwardCell;
		private var _buffCell:VipAwardCell;
		
		private var _awardList:Array;
		
		private var _sp:MScrollPanel;
		private var _txtTag1:MAssetLabel;
		private var _txtTag:MAssetLabel;
		
		public function MyVipInfoView()
		{
			super();
			initView();
			initEvent();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(9,102,328,171), new BoxBgAsset() as MovieClip),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2,110,340,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(64,41,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(109,41,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(154,41,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(199,41,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(244,41,38,38), new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTag = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtTag.setLabelType([new TextFormat("Microsoft Yahei Font",14,0x66ff00,true)]);
			_txtTag.move(164,8);
			addChild(_txtTag); 
			_txtTag.setValue(LanguageManager.getWord("ssztl.common.vipDayReward"));
			
			_sp = new MScrollPanel();
			_sp.setSize(320,163);
			_sp.move(13,106);
			_sp.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_sp); 
			
			_txtTag1 = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,'left');
			_txtTag1.move(5,4);
			_sp.getContainer().addChild(_txtTag1);
			_txtTag1.setHtmlValue(LanguageManager.getWord('ssztl.vip.otherGiftTitle'));
			_sp.getContainer().height += _txtTag1.height;
			
			_txtPrivilege = new MAssetLabel('', MAssetLabel.LABEL_TYPE20,'left');
			_txtPrivilege.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtPrivilege.move(5,22);
			_sp.getContainer().addChild(_txtPrivilege);
			var vip_id:int = GlobalData.selfPlayer.vipType;
			switch (GlobalData.selfPlayer.getVipType())
			{
				case 1:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.weekVipDescript');
					break;
				case 2:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.monthVipDescript');
					break;
				case 3:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.superVipDescript');
					break;
			}
			_sp.getContainer().height += _txtPrivilege.height+5;
			
			_sp.update(-1,_sp.getContainer().height);
			
			_transferCell = new VipAwardCell(VipAwardType.FLY_COUNT);
			_transferCell.move(64,41);
			addChild(_transferCell);
			
			_speakerCell = new VipAwardCell(VipAwardType.SPEAKER_COUNT);
			_speakerCell.move(109,41);
			addChild(_speakerCell);
			
			_yuanbaoCell = new VipAwardCell(VipAwardType.BIND_YUANBAO);
			_yuanbaoCell.move(154,41);
			addChild(_yuanbaoCell);
			
			_copperCell = new VipAwardCell(VipAwardType.COPPER);
			_copperCell.move(199,41);
			addChild(_copperCell);
			
			_buffCell = new VipAwardCell(VipAwardType.BUFF);
			_buffCell.move(244,41);
			addChild(_buffCell);
			
		}
		
		public function initEvent():void
		{
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.AWARD_YUANBAO_STATECHANGE, yuanbaoGotHandler);
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.AWARD_COPPER_STATECHANGE, copperGotHandler);
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.AWARD_BUFF_STATECHANGE, buffGotHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.AWARD_YUANBAO_STATECHANGE, yuanbaoGotHandler);
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.AWARD_COPPER_STATECHANGE, copperGotHandler);
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.AWARD_BUFF_STATECHANGE, buffGotHandler);
		}
		
		private function buffGotHandler(event:Event):void
		{
			_buffCell.setData(GlobalData.selfPlayer.isVipBuffGot);
		}
		
		private function copperGotHandler(event:Event):void
		{
			_copperCell.setData(GlobalData.selfPlayer.isVipCopperGot);
		}
		
		private function yuanbaoGotHandler(event:Event):void
		{
			_yuanbaoCell.setData(GlobalData.selfPlayer.isVipBindYuanbaoGot);
		}
		
		public function setData(vipType:int):void
		{
			var vipTemplateInfo:VipTemplateInfo = VipTemplateList.getVipTemplateInfo(vipType);
			var transferTotal:int = vipTemplateInfo.shoesCount;
			var transferRemaining:int = GlobalData.selfPlayer.flyCount;
			_transferCell.setData(transferRemaining, transferTotal);
			var speakerTotal:int = vipTemplateInfo.bugleCount;
			var speakerRemaining:int = GlobalData.selfPlayer.bugle;
			_speakerCell.setData(speakerRemaining, speakerTotal);
			
			_yuanbaoCell.setData(GlobalData.selfPlayer.isVipBindYuanbaoGot);
			_copperCell.setData(GlobalData.selfPlayer.isVipCopperGot);
			_buffCell.setData(GlobalData.selfPlayer.isVipBuffGot);
			
			switch (GlobalData.selfPlayer.getVipType())
			{
				case 1:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.weekVipDescript');
					break;
				case 2:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.monthVipDescript');
					break;
				case 3:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.superVipDescript');
					break;
				case 4:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.weekVipDescript');
					break;
				case 5:	
					_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.monthVipDescript');
					break;
				
			}
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_txtPrivilege)
			{
				_txtPrivilege = null;
			}
			if(_sp)
			{
				_sp.dispose();
				_sp = null;
			}
			_txtTag = null;
			_txtTag1 = null;
			super.dispose();
		}
	}
}