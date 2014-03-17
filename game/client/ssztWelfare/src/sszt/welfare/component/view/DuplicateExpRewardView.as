package sszt.welfare.component.view
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.welfare.socket.LoginRewardExchangeSocketHandler;
	
	import ssztui.ui.SplitCompartLine;
	
	public class DuplicateExpRewardView extends MSprite
	{
		private var _txtSingleDuplicate:MAssetLabel;
		private var _txtMultiDuplicate:MAssetLabel;
		private var _txtTimesSingleDuplicate:MAssetLabel;
		private var _txtTimesMultiDuplicate:MAssetLabel;
		
		private var _getExpSingle:MAssetLabel;
		private var _getExpMulti:MAssetLabel;
		
		private var _btnGetSingleDuplicate:MCacheAssetBtn1;
		private var _btnGetMultiDuplicate:MCacheAssetBtn1;
		
		public function DuplicateExpRewardView()
		{
			super();
			setData();
			initEvent();
		}
		
		private function setData():void
		{
			_txtTimesSingleDuplicate.setHtmlValue(
				LanguageManager.getWord('ssztl.common.totalTime',
										"<font color='#ff9900'><b>"+GlobalData.loginRewardData.duplicateNum+"</b></font>")
			);
			_getExpSingle.setHtmlValue(
				LanguageManager.getWord('ssztl.common.canGetExp',
										"<font color='#00ccff'><b>"+LoginRewardTemplateList.getExpTemplate(1).basicsExp * GlobalData.loginRewardData.duplicateNum +"</b></font>")
			);
			
			_txtTimesMultiDuplicate.setHtmlValue(
				LanguageManager.getWord('ssztl.common.totalTime',
										"<font color='#ff9900'><b>"+GlobalData.loginRewardData.multiDuplicateNum+"</b></font>")
			);
			_getExpMulti.setHtmlValue(
				LanguageManager.getWord('ssztl.common.canGetExp',
										"<font color='#00ccff'><b>"+LoginRewardTemplateList.getExpTemplate(2).basicsExp * GlobalData.loginRewardData.multiDuplicateNum+"</b></font>")
			);
			_btnGetSingleDuplicate.enabled = !!GlobalData.loginRewardData.duplicateNum;
			_btnGetMultiDuplicate.enabled = !!GlobalData.loginRewardData.multiDuplicateNum;
		}
		
		private function initEvent():void
		{
			_btnGetSingleDuplicate.addEventListener(MouseEvent.CLICK,btnGetSingleDuplicateClickHandler);
			_btnGetMultiDuplicate.addEventListener(MouseEvent.CLICK,btnGetMultiDuplicateClickHandler);
		}
		
		private function removeEvent():void
		{
			_btnGetSingleDuplicate.removeEventListener(MouseEvent.CLICK,btnGetSingleDuplicateClickHandler);
			_btnGetMultiDuplicate.removeEventListener(MouseEvent.CLICK,btnGetMultiDuplicateClickHandler);
		}
		
		private function btnGetMultiDuplicateClickHandler(e:MouseEvent):void
		{
			LoginRewardExchangeSocketHandler.send(2,0,0);
		}
		
		private function btnGetSingleDuplicateClickHandler(e:MouseEvent):void
		{
			LoginRewardExchangeSocketHandler.send(1,0,0);
		}
		
		public function getSingleDuplicateSuccess():void
		{
			QuickTips.show(LanguageManager.getWord('ssztl.common.getOfflineExp',LoginRewardTemplateList.getExpTemplate(1).basicsExp * GlobalData.loginRewardData.duplicateNum));
			GlobalData.loginRewardData.duplicateNum = 0;
			_txtTimesSingleDuplicate.setHtmlValue(
				LanguageManager.getWord('ssztl.common.totalTime',
					"<font color='#ff9900'><b>"+GlobalData.loginRewardData.duplicateNum+"</b></font>")
			);
			_getExpSingle.setHtmlValue(
				LanguageManager.getWord('ssztl.common.canGetExp',
					"<font color='#00ccff'><b>"+LoginRewardTemplateList.getExpTemplate(1).basicsExp * GlobalData.loginRewardData.duplicateNum +"</b></font>")
			);
			
			_btnGetSingleDuplicate.enabled = !!GlobalData.loginRewardData.duplicateNum;
			GlobalData.loginRewardData.gotDuplicate = !GlobalData.loginRewardData.duplicateNum;
		}
		
		public function getMutiDuplicateSuccess():void
		{
			QuickTips.show(LanguageManager.getWord('ssztl.common.getOfflineExp',LoginRewardTemplateList.getExpTemplate(2).basicsExp * GlobalData.loginRewardData.multiDuplicateNum));
			GlobalData.loginRewardData.multiDuplicateNum = 0;
			_txtTimesMultiDuplicate.setHtmlValue(
				LanguageManager.getWord('ssztl.common.totalTime',
					"<font color='#ff9900'><b>"+GlobalData.loginRewardData.multiDuplicateNum+"</b></font>")
			);
			_getExpMulti.setHtmlValue(
				LanguageManager.getWord('ssztl.common.canGetExp',
					"<font color='#00ccff'><b>"+LoginRewardTemplateList.getExpTemplate(2).basicsExp * GlobalData.loginRewardData.multiDuplicateNum+"</b></font>")
			);
			_btnGetMultiDuplicate.enabled = !!GlobalData.loginRewardData.multiDuplicateNum;
			GlobalData.loginRewardData.gotMultiDuplicateNum = !GlobalData.loginRewardData.multiDuplicateNum;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(3,56,202,11),new Bitmap(new SplitCompartLine())));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(3,116,202,11),new Bitmap(new SplitCompartLine())));
				
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(11,35,190,15),new MAssetLabel(LanguageManager.getWord("ssztl.welfare.getCopyAward"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
			
			_txtSingleDuplicate = new MAssetLabel(LanguageManager.getWord('ssztl.welfare.singleCopy'),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_txtSingleDuplicate.move(11,66);
			addChild(_txtSingleDuplicate);
			_txtTimesSingleDuplicate = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTimesSingleDuplicate.move(85,66);
			addChild(_txtTimesSingleDuplicate);
			_getExpSingle = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_getExpSingle.move(83,94);
			addChild(_getExpSingle);
			
			_txtMultiDuplicate = new MAssetLabel(LanguageManager.getWord('ssztl.welfare.multiCopy'),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_txtMultiDuplicate.move(11,124);
			addChild(_txtMultiDuplicate);
			_txtTimesMultiDuplicate = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTimesMultiDuplicate.move(85,124);
			addChild(_txtTimesMultiDuplicate);
			_getExpMulti = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_getExpMulti.move(83,152);
			addChild(_getExpMulti);
			
			_btnGetSingleDuplicate = new MCacheAssetBtn1(1,1,LanguageManager.getWord('ssztl.common.getLabel'));
			_btnGetSingleDuplicate.move(157,89);
			addChild(_btnGetSingleDuplicate);
			_btnGetMultiDuplicate = new MCacheAssetBtn1(1,1,LanguageManager.getWord('ssztl.common.getLabel'));
			_btnGetMultiDuplicate.move(157,150);
			addChild(_btnGetMultiDuplicate);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeEvent();
			
			_txtSingleDuplicate = null;
			_txtMultiDuplicate = null;
			_txtTimesSingleDuplicate = null;
			_txtTimesMultiDuplicate = null;
			
			if(_btnGetSingleDuplicate)
			{
				_btnGetSingleDuplicate.dispose();
				_btnGetSingleDuplicate = null;
			}
			if(_btnGetMultiDuplicate)
			{
				_btnGetMultiDuplicate.dispose();
				_btnGetMultiDuplicate = null;
			}
		}
	}
}