package sszt.welfare.component.view
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.loginReward.LoginRewardExp;
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.welfare.component.cell.ExpCell;
	
	
	/**
	 * 单人、多人副本 ,离线 获得经验
	 * @author chendong
	 * 
	 */	
	public class GetExpView extends Sprite
	{
		private var _mtile:MTile;
		private var _cells:Array;
		
		/**
		 * 您已离线: 
		 */
		private var _offLine:MAssetLabel
		
		/**
		 * 10小时 
		 */
		private var _offLineHour:MAssetLabel;
		
		/**
		 * 免费获得单倍经验:
		 */
		private var _freeGetOneExp:MAssetLabel;
		
		/**
		 * 经验值：10000 
		 */
		private var _expValue:MAssetLabel;
		
		/**
		 * 单倍经验类型  
		 */
		private var _speciesNoExp:int = 3;
		
		public function GetExpView()
		{
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_offLine = new MAssetLabel(LanguageManager.getWord("ssztl.loginReward.offLine"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_offLine.move(11,35);
			addChild(_offLine);
			
			_offLineHour = new MAssetLabel("",MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_offLineHour.move(71,35);
			addChild(_offLineHour);
			
			_freeGetOneExp = new MAssetLabel(LanguageManager.getWord("ssztl.loginReward.freeGetExp"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_freeGetOneExp.move(11,53);
			addChild(_freeGetOneExp);
			
			_expValue = new MAssetLabel("0",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_expValue.move(119,53);
			addChild(_expValue);
			
			_mtile = new MTile(225,23,1);
			_mtile.itemGapW = _mtile.itemGapH = 4;
			_mtile.setSize(225,80);
			_mtile.move(11,81);
			_mtile.verticalScrollPolicy = _mtile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_mtile);
			
			_cells = [];
			for(var i:int=1;i<=3;i++)
			{
				var cell:ExpCell = new ExpCell(i);
				_cells.push(cell);
				_mtile.appendItem(cell);
			}
			
			initData();
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.EXCHANGE_EXP,setBtEnabled);
		}
		
		
		private function initData():void
		{
			_offLineHour.text = int(GlobalData.loginRewardData.offLineTimes / 3600).toString() + LanguageManager.getWord("ssztl.common.hourLabel");
			_expValue.text = int(int(GlobalData.loginRewardData.offLineTimes / 3600) * LoginRewardTemplateList.getExpTemplate(_speciesNoExp).basicsExp).toString();
		}
		
		public function setBtEnabled(evt:WelfareEvent):void
		{
			_offLineHour.text = int(int(evt.data.num) / 3600).toString() + LanguageManager.getWord("ssztl.common.hourLabel");
			_expValue.text = int(int(int(evt.data.num) / 3600) * LoginRewardTemplateList.getExpTemplate(_speciesNoExp).basicsExp).toString();
		
			GlobalData.loginRewardData.offLineTimes = int(evt.data.num); 
		}
		
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.EXCHANGE_EXP,setBtEnabled);
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