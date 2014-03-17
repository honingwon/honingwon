package sszt.welfare.component.view
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
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
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.welfare.component.cell.VipAwardCell;
	
	/**
	 * vip用户界面 
	 * @author chendong
	 * 
	 */	
	public class YesVipView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _txtPrivilege:MAssetLabel;
		private var _transferCell:VipAwardCell;
		private var _speakerCell:VipAwardCell;
		private var _yuanbaoCell:VipAwardCell;
		private var _copperCell:VipAwardCell;
		private var _buffCell:VipAwardCell;
		
		private var _awardList:Array;
		
		public function YesVipView()
		{
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(19,83,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(62,83,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(105,83,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,83,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			var te:String = "";
			switch(GlobalData.selfPlayer.getVipType())
			{
				case 1:
					te = "<font color='#4cff22'>"+LanguageManager.getWord("ssztl.basic.normalVipPlayer")+"</font>";
					break;
				case 2:
					te = "<font color='#00ccff'>"+LanguageManager.getWord("ssztl.basic.hightVipPlayer")+"</font>";
					break;
				case 3:
					te = "<font color='#cc00ff'>"+LanguageManager.getWord("ssztl.basic.superVipPlayer")+"</font>";
					break;
			}
			_txtPrivilege = new MAssetLabel('', MAssetLabel.LABEL_TYPE20,'left');
			_txtPrivilege.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,12)]);
			_txtPrivilege.move(11,35);
			addChild(_txtPrivilege);
			_txtPrivilege.setHtmlValue(
				"<font color='#dbb163'>您是尊贵的</font>" + te + "\n" + 
				"VIP可每日领取<font color='#ffcc00'>返还福利：</font>"
				);
			
			_transferCell = new VipAwardCell(VipAwardType.FLY_COUNT);
			_transferCell.move(0,0);
//			addChild(_transferCell);
			
			_speakerCell = new VipAwardCell(VipAwardType.SPEAKER_COUNT);
			_speakerCell.move(0,50);
//			addChild(_speakerCell);
			
			_yuanbaoCell = new VipAwardCell(VipAwardType.BIND_YUANBAO);
			_yuanbaoCell.move(19,83);
			addChild(_yuanbaoCell);
			
			_copperCell = new VipAwardCell(VipAwardType.COPPER);
			_copperCell.move(62,83);
			addChild(_copperCell);
			
			_buffCell = new VipAwardCell(VipAwardType.BUFF);
			_buffCell.move(105,83);
			addChild(_buffCell);
			
		}
		
		private function initEvent():void
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
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
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
		}
	}
}