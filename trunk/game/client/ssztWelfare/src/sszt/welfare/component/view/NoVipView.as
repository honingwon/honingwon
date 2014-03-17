package sszt.welfare.component.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.welfare.mediator.WelfareMediator;
	
	import ssztui.welfare.BtnBuyAsset2;
	
	/**
	 * 非vip用户界面 
	 * @author chendong
	 * 
	 */	
	public class NoVipView extends Sprite
	{
		private var _becomeVipBt:MAssetButton1;
		
		private var _label1:MAssetLabel;
		private var _label2:MAssetLabel;
		private var _label3:MAssetLabel;
		
		private var _mediator:WelfareMediator;
		
		public function NoVipView(mediator:WelfareMediator)
		{
			_mediator = mediator;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_becomeVipBt = new MAssetButton1(new BtnBuyAsset2());
			_becomeVipBt.move(132,136);
			addChild(_becomeVipBt);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(132,138,66,12),new MAssetLabel(LanguageManager.getWord("ssztl.loginReward.becomeVIP"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER)));
			
			initalLabels(); 
		}
		
		private function initEvent():void
		{
			_becomeVipBt.addEventListener(MouseEvent.CLICK,becomeVipClick);
		}
		
		
		private function removeEvent():void
		{
			_becomeVipBt.removeEventListener(MouseEvent.CLICK,becomeVipClick);
		}
		
		private function becomeVipClick(e:MouseEvent):void
		{
//			JSUtils.gotoFill();
			
			SetModuleUtils.addVip(new ToVipData(1));
		}
		
		private function initalLabels():void
		{
			_label1 = new MAssetLabel(LanguageManager.getWord("ssztl.loginReward.noVip"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_label1.textColor = 0xff3300;
			_label1.move(11,35);
			addChild(_label1);
			
			_label2 = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_label2.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_label2.multiline = _label2.wordWrap = true;
			_label2.setSize(190,30);
			_label2.move(11,59);
			addChild(_label2);
			_label2.setHtmlValue(LanguageManager.getWord("ssztl.loginReward.descriptionLable"));
			
			_label3 = new MAssetLabel(LanguageManager.getWord("ssztl.loginReward.descriptionLable1"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_label3.setLabelType([new TextFormat("SimSun",12,0xffd800,null,null,null,null,null,null,null,null,null,4)]);
			_label3.move(20,107);
			addChild(_label3);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}