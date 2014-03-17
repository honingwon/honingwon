package sszt.sevenActivity.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.SevenActivityUserItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.label.MAssetLabel;
	
	public class UserNameItemView extends Sprite implements IPanel
	{
		/**
		 * 第一天 冲级达人,武将积分,升级VIP,升级帮会,提升战斗力,坐骑评分,过关斩将
		 */
		private var _userName:MAssetLabel;
		private var _sevenActivityUserItemInfo:SevenActivityUserItemInfo;
		private var _index:int;
		private var _over:Sprite;
		private var _type:int;
		private var _isEnd:Boolean;
		private var _isCurrDay:Boolean;
		
		public function UserNameItemView(sevenActivityUserItemInfo:SevenActivityUserItemInfo,index:int,type:int,isEnd:Boolean,isCurrDay:Boolean)
		{
			super();
			_isEnd  = isEnd;
			_isCurrDay = isCurrDay;
			_index = index;
			_type = type;
			_sevenActivityUserItemInfo = sevenActivityUserItemInfo;
			initView();
			initEvent();
			initData()
		}
		public function initView():void
		{
			// TODO Auto Generated method stub
			_userName = new MAssetLabel("",MAssetLabel.LABEL_TYPE7);
			_userName.move(78,0);
			addChild(_userName);
			
			_over = new Sprite();
			_over.graphics.beginFill(0x23a5b59,0.2);
			_over.graphics.drawRect(0,0,156,16);
			_over.graphics.endFill();
			addChild(_over);
			_over.alpha = 0;
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			_userName.text = "";
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			clearData();
			if(_isEnd || (!_isEnd && _isCurrDay))
			{
				_userName.setHtmlValue(_sevenActivityUserItemInfo.userNick);
			}
			else
			{
				_userName.setHtmlValue("????");
			}
			
		}
		
		
		public function initEvent():void
		{
			_over.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_over.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		public function removeEvent():void
		{
			_over.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_over.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			if(_isEnd || (!_isEnd && _isCurrDay))
			{
				_over.alpha = 1;
				TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.sevenRankData"+_type, _sevenActivityUserItemInfo.userNum),null,new Rectangle(e.stageX,e.stageY,0,0));
			}
		}
		private function outHandler(e:MouseEvent):void
		{
			_over.alpha = 0;
			TipsUtil.getInstance().hide();
		}
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
//			clearData();
			removeEvent();
			
			_userName = null;
		}
	}
}