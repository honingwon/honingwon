package sszt.club.components.clubMain.pop.manage
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.club.ClubInviteSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class InvitePanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _inviteBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _playerBox:ComboBox;
		private var _serverBox:ComboBox;
		
		public function InvitePanel(mediator:ClubMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1("",new Bitmap(new ClubInviteTitleAsset())),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(291,146);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,291,112))
			]);
			addContent(_bg as DisplayObject);
			
			var label:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.playerName") + "：",MAssetLabel.LABELTYPE4);
			label.move(20,47);
			addContent(label);
			
			_inviteBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.invite"));
			_inviteBtn.move(27,120);
			addContent(_inviteBtn);
			_cancelBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(198,120);
			addContent(_cancelBtn);
			
			_serverBox = new ComboBox();
			_serverBox.editable = false;
			_serverBox.setSize(51,20);
			_serverBox.move(79,45);
			addContent(_serverBox);
			var dp1:DataProvider = new DataProvider();
			var index:int = 0;
			for each(var id:int in GlobalData.serverList)
			{
				if(id == GlobalData.selfPlayer.serverId)index = GlobalData.serverList.indexOf(String(id));
				dp1.addItem({label:LanguageManager.getWord("ssztl.common.serverValue",id),serverId:id});
			}
			_serverBox.dataProvider = dp1;
			_serverBox.selectedIndex = index;
			
			_playerBox = new ComboBox();
			_playerBox.editable = true;
			_playerBox.setSize(148,20);
			_playerBox.move(132,45);
			addContent(_playerBox);
			var dp:DataProvider = new DataProvider();
			var list:Dictionary = GlobalData.imPlayList.friends;
			for each(var player:ImPlayerInfo in list)
			{
				if(player)
				{
					dp.addItem({label:player.info.nick,serverId:player.info.serverId});
				}
			}
			_playerBox.dataProvider = dp;
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_playerBox.addEventListener(Event.CHANGE,playerBoxChangeHandler);
			_inviteBtn.addEventListener(MouseEvent.CLICK,inviteClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		private function removeEvent():void
		{
			_playerBox.removeEventListener(Event.CHANGE,playerBoxChangeHandler);
			_inviteBtn.removeEventListener(MouseEvent.CLICK,inviteClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function playerBoxChangeHandler(e:Event):void
		{
			var serverId:int;
			if(_playerBox.selectedItem == null)
			{
				for each(var obj:Object in _playerBox.dataProvider.toArray())
				{
					if(_playerBox.text == obj.label)
					{
						serverId = obj.serverId;
						_serverBox.selectedIndex = GlobalData.serverList.indexOf(String(serverId));
					}
				}
			}
			else
			{
				serverId = _playerBox.selectedItem.serverId;
				_serverBox.selectedIndex = GlobalData.serverList.indexOf(String(serverId));
			}
		}
		
		private function inviteClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_playerBox.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.inputPlayerName"));
			}
			else
			{
				ClubInviteSocketHandler.send(_serverBox.selectedItem.serverId,_playerBox.text);
				dispose();
			}
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_inviteBtn)
			{
				_inviteBtn.dispose();
				_inviteBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_playerBox = null;
			_mediator = null;
		}
	}
}