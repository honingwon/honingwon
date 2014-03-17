package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.iconInfo.DoubleSitIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class DoubleSitIconBtn extends BaseIconBtn
	{
		private var _doubleSitIconBtn:MBitmapButton;
		public function DoubleSitIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipDouble");
		}
		
		override protected function initView():void
		{
			super.initView();
			_doubleSitIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconSitAsset") as BitmapData);
			addChild(_doubleSitIconBtn);
		}
		
		override protected  function btnClickHandler(e:MouseEvent):void
		{
			var tmpDoubleTopInfo:DoubleSitIconInfo;
			GlobalAPI.tickManager.removeTick(GlobalData.quickIconInfo);
			if(GlobalData.quickIconInfo.doubleSitIconInfoList.length > 0)
			{
				tmpDoubleTopInfo = GlobalData.quickIconInfo.doubleSitIconInfoList[0];
			}
			else
			{
				return;
			}
			
			if(_quickIconMediator.sceneModule.sitInvitePanel)
			{
				_quickIconMediator.sceneModule.sitInvitePanel.dispose();
			}
//			_quickIconMediator.sceneModule.sitInvitePanel = MTimerAlert.show(30,MAlert.REFUSE,"[" + tmpDoubleTopInfo.serverId + "]" + tmpDoubleTopInfo.nick + LanguageManager.getWord("ssztl.scene.isAcceptDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,sitInviteClose);
			_quickIconMediator.sceneModule.sitInvitePanel = MTimerAlert.show(30,MAlert.REFUSE,LanguageManager.getWord("ssztl.scene.isAcceptDoubleSit",tmpDoubleTopInfo.serverId,tmpDoubleTopInfo.nick),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,sitInviteClose);
			
			function sitInviteClose(evt:CloseEvent):void
			{
				_quickIconMediator.sceneModule.sitInvitePanel = null;
				if(evt.detail == MAlert.AGREE)
				{
					walkToDoubleSit(tmpDoubleTopInfo.serverId,tmpDoubleTopInfo.nick,tmpDoubleTopInfo.id,tmpDoubleTopInfo.x,tmpDoubleTopInfo.y);
					GlobalData.quickIconInfo.removeAllDoubleSitList();
				}
				else
				{
					_quickIconMediator.sendDoubleSitAccept(tmpDoubleTopInfo.id,false);
					GlobalData.quickIconInfo.removeFromDoubleSitList(tmpDoubleTopInfo.id);
				}
				GlobalAPI.tickManager.addTick(GlobalData.quickIconInfo);
			}
		}
		
		private function walkToDoubleSit(serverId:int,nick:String,id:Number,x:Number,y:Number):void
		{
			WalkChecker.doWalkToDoubleSit(serverId,nick,id,x,y);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_doubleSitIconBtn)
			{
				_doubleSitIconBtn.dispose();
				_doubleSitIconBtn = null;
			}
		}
	}
}