package sszt.welfare.component.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.welfare.component.cell.RewardItem;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.welfare.ShowAllBgAsset;

	public class ShowAllRewards extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _closeBtn:MAssetButton1;
		private var _showAllTip:MAssetLabel;
		private var _mtile:MTile;
		private var _tip:MAssetLabel;
		
		private var _pos:Point;
		
		public function ShowAllRewards()
		{
			initialView();
			initEvent();
		}
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,0,262,361),new Bitmap(new ShowAllBgAsset())),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(14,35,234,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,36,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(175,36,2,20),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,38,99,16),new MAssetLabel(LanguageManager.getWord('ssztl.common.loginDayslabel'), MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,38,60,16),new MAssetLabel(LanguageManager.getWord('ssztl.welfare.unChargeAward'), MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(177,38,71,16),new MAssetLabel(LanguageManager.getWord('ssztl.welfare.chargeAward'), MAssetLabel.LABEL_TYPE_TITLE2)),
			]);
			addChild(_bg as DisplayObject);
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_tip.move(131,335);
			addChild(_tip);
			_tip.setHtmlValue(LanguageManager.getWord('ssztl.welfare.loginAwardExplain'));
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(239,1);
			addChild(_closeBtn);
			
			_mtile = new MTile(234,44,1);
			_mtile.itemGapW = _mtile.itemGapH = 0;
			_mtile.setSize(234,44*6);
			_mtile.move(14,58);
			_mtile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_mtile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mtile.verticalLineScrollSize = 44;
			addChild(_mtile);
			
			for(var dayIndex:int = 1; dayIndex<= LoginRewardTemplateList.length(); dayIndex++)
			{
				var item:RewardItem = new RewardItem(dayIndex);
				_mtile.appendItem(item);
			}
			
			_pos = new Point(0,0);
		}
		private function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
		}
		private function removeEvent():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			hide();
		}
		public function show(ix:Number=0,iy:Number=0):void
		{
			_pos.x = ix;
			_pos.y = iy;
			TweenLite.from(this,0.5,{scaleX:0,scaleY:0,x:ix,y:iy,ease:Cubic.easeOut});
		}
		public function hide():void
		{
			TweenLite.to(this,0.5,{scaleX:0,scaleY:0,x:_pos.x,y:_pos.y, alpha:0, ease:Cubic.easeOut, onComplete:dispose});
			
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_mtile)
			{
				_mtile.dispose();
				_mtile = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
			}
			_tip = null;
			removeEvent();
		}
	}
}