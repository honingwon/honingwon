package sszt.personal.components.itemView
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.personal.PersonalDynamicType;
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.TaskAcceptSocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.core.view.tips.PlayerTip;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.personal.mediators.PersonalMediator;
	
	public class PersonalDynamicItemView extends Sprite
	{
		private var _mediator:PersonalMediator;
		private var _info:PersonalDynamicItemInfo;
		private var _descriptionLabel:MAssetLabel;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,6);

		public function PersonalDynamicItemView(argMeidator:PersonalMediator,argInfo:PersonalDynamicItemInfo)
		{
			_mediator = argMeidator;
			_info = argInfo;
			super();
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_descriptionLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_descriptionLabel.mouseEnabled = _descriptionLabel.mouseWheelEnabled = true;
			_descriptionLabel.move(5,10);
			_descriptionLabel.width = 416;
			_descriptionLabel.defaultTextFormat = LABEL_FORMAT;
			_descriptionLabel.setTextFormat(LABEL_FORMAT);
			_descriptionLabel.wordWrap = true;
			_descriptionLabel.multiline = true;
			addChild(_descriptionLabel);
			_descriptionLabel.htmlText = createDescriptionText();
		}
		
		private function createDescriptionText():String
		{
			var tmpText:String = "";
			switch(_info.typeId)
			{
				case PersonalDynamicType.FRIEND_UPGRADE:
//					tmpText = "恭喜<font color='#FFFDA5'><u><a href='event:1'>"+_info.name+"</a></u></font>玩家，等级提升到<font color='#FFFDA5'>" +_info.parm1.toString() +"</font>级，可谓升级神速。";
					tmpText = LanguageManager.getWord("ssztl.personal.playerLevelUpgrade",_info.name,_info.parm1.toString());
					
					break;
				case PersonalDynamicType.FRIEND_TASK_SHARE:
//					tmpText = "你的好友<font color='#FFFDA5'><u><a href='event:2'>" +_info.name+"</a></u></font>发布<font color='#FFFDA5'>"+_info.parm5+"</font>共享任务，<font color='#FFFDA5'><u><a href='event:3'>接取任务</a></u></font>可获得丰富奖励哦，组队将会更容易完成任务哦。";
					tmpText = LanguageManager.getWord("ssztl.personal.friendShareTask",_info.name,_info.parm5);
					break;
				case PersonalDynamicType.FRIEND_DEAD:
//					tmpText = "天啊!!!<font color='#FFFDA5'><u><a href='event:1'>" +_info.name+"</a></u></font>玩家被<font color='#FFFDA5'><u><a href='event:2'>" +_info.parm5+"</a></u></font>玩家击败，你要去支援吗？点击<font color='#FFFDA5'><u><a href='event:4'>传送</a></u></font>即可支援。";
					tmpText = LanguageManager.getWord("ssztl.personal.playerBeHitDown",_info.name,_info.parm5);
					break;
				case PersonalDynamicType.CLUB_UPGRADE:
//					tmpText = "恭喜本帮派提升为<font color='#FFFDA5'>"+_info.parm1.toString()+"</font>级，大家继续努力。";
					tmpText = LanguageManager.getWord("ssztl.personal.clubUpgrade",_info.parm1);
					break;
				case PersonalDynamicType.CLUBMATE_DEAD:
//					tmpText = "天啊!!!<font color='#FFFDA5'><u><a href='event:1'>" +_info.name+"</a></u></font>帮会成员被<font color='#FFFDA5'><u><a href='event:2'>" +_info.parm5+"</a></u></font>玩家击败，你要去支援吗？点击<font color='#FFFDA5'><u><a href='event:4'>传送</a></u></font>即可支援。";
					tmpText = LanguageManager.getWord("ssztl.personal.cluberBeHitDown",_info.name,_info.parm5);
					break;
				case PersonalDynamicType.CLUBMATE_UPGRADE:
//					tmpText = "恭喜<font color='#FFFDA5'><u><a href='event:1'>"+_info.name+"</a></u></font>帮会成员，等级提升到<font color='#FFFDA5'>" +_info.parm1.toString() +"</font>级，可谓升级神速。";
					tmpText = LanguageManager.getWord("ssztl.personal.cluberLevelUpgrade",_info.name,_info.parm1);
					
					break;
				case PersonalDynamicType.CLUBTASK_SHARE:
//					tmpText = "你的帮会成员<font color='#FFFDA5'><u><a href='event:2'>" +_info.name+"</a></u></font>发布<font color='#FFFDA5'>"+_info.parm5+"</font>共享任务，<font color='#FFFDA5'><u><a href='event:3'>接取任务</a></u></font>可获得丰富奖励哦，组队将会更容易完成任务哦。";
					tmpText = LanguageManager.getWord("ssztl.personal.cluberShareTask",_info.name,_info.parm5);
					break;
			}
			return tmpText;
		}
		
		private function initEvents():void
		{
			addEventListener(TextEvent.LINK,linkClickHandler);
		}
		
		private function removeEvents():void
		{
			removeEventListener(TextEvent.LINK,linkClickHandler);
		}
		
		private function linkClickHandler(e:TextEvent):void
		{
			switch(e.text)
			{
				case "1":
					ChatPlayerTip.getInstance().show(_info.serverId,_info.userId,_info.name,this.localToGlobal(new Point(this.mouseX,this.mouseY)));
					break;
				case "2":
					ChatPlayerTip.getInstance().show(_info.serverId,_info.parm1,_info.parm5,this.localToGlobal(new Point(this.mouseX,this.mouseY)));
					break;
				case "3":
					TaskAcceptSocketHandler.sendAccept(_info.parm1);
					break;
//				case "4":
//					ChatPlayerTip.getInstance().show(_info.userId,_info.name,this.localToGlobal(new Point(this.mouseX,this.mouseY)));
//					break;
//				case "5":
//					ChatPlayerTip.getInstance().show(_info.parm1,_info.parm5,this.localToGlobal(new Point(this.mouseX,this.mouseY)));
//					break;
				case "4":
					fly();
					break;
			}
		}
		
		private function fly():void
		{
			if(!GlobalData.selfPlayer.canfly())
			{
//				MAlert.show("飞天神靴不足，是否马上购买？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int = _info.parm2;
				var sceneX:int = _info.parm3;
				var sceneY:int = _info.parm4;
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:new Point(sceneX,sceneY)}));
			}
		}
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(103));
			}
		}
		
		public function dispose():void
		{
			_mediator = null;
			_info =  null;
			_descriptionLabel = null;
		}
	}
}