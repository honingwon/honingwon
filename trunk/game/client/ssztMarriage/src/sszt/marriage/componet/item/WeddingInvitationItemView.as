package sszt.marriage.componet.item
{
	import flash.events.MouseEvent;
	
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class WeddingInvitationItemView extends MSprite
	{
		private var _inviteHandler:Function;
		
		private var _data:ImPlayerInfo;
		
		private var _sexLabel:MAssetLabel;
		private var _nickLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _friendPointLabel:MAssetLabel;
		
		private var _btnInvite:MCacheAssetBtn1;
		
		public function WeddingInvitationItemView(data:ImPlayerInfo,inviteHandler:Function)
		{
			_inviteHandler = inviteHandler;
			_data = data;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,340,30);
			graphics.endFill();
			
			_sexLabel = new MAssetLabel(int(_data.info.sex).toString(), MAssetLabel.LABEL_TYPE1, 'left');
//			addChild(_sexLabel);
			
			var sex:String = _data.info.sex?"<font color='#00baff'>♂</font>":"<font color='#ff66ff'>♀</font>";
			_nickLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, 'left');
			_nickLabel.move(10,7);
			addChild(_nickLabel);
			_nickLabel.setHtmlValue(sex + _data.info.nick);
			
			_levelLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_levelLabel.move(157,7);
			addChild(_levelLabel);
			_levelLabel.setValue(_data.info.level.toString());
			
			_friendPointLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_friendPointLabel.move(219,7);
			addChild(_friendPointLabel);
			_friendPointLabel.setValue(_data.amity.toString());
			
			_btnInvite = new MCacheAssetBtn1(1,2,LanguageManager.getWord('ssztl.common.invite'));
			_btnInvite.move(264,5);
			addChild(_btnInvite);
			
			_btnInvite.addEventListener(MouseEvent.CLICK,inviteHandler);
		}
		
		protected function inviteHandler(event:MouseEvent):void
		{
			_inviteHandler(_data);
			disableBtn();
		}
		
		public function disableBtn():void
		{
			_btnInvite.enabled = false;
			_btnInvite.label = LanguageManager.getWord('ssztl.marry.invited');
		}
		
		override public function dispose():void
		{
			_btnInvite.removeEventListener(MouseEvent.CLICK,inviteHandler);
			super.dispose();
			
			_inviteHandler = null;
			_data = null;
			_sexLabel = null;
			_nickLabel = null;
			_levelLabel = null;
			_friendPointLabel = null;
			if(_btnInvite)
			{
				_btnInvite.dispose();
				_btnInvite= null;
			}
		}
	}
}