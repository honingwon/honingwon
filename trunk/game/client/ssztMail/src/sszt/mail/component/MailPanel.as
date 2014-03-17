package sszt.mail.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.mail.MailItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mail.mediator.MailMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.mail.MailTitleAsset;
	
	/**
	 * 修改：王鸿源  honingwon@gmail.com
	 * 日期：2012-10-22
	 * */
	public class MailPanel extends MPanel
	{
		private var _mediator:MailMediator;
		private var _bg:IMovieWrapper;
		private var _listPanel:ListPanel;
		private var _readPanel:ReadPanel;
		private var _writePanel:WritePanel;
		private var _currentPage:int = 0;
		
		public function MailPanel(mediator:MailMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new MailTitleAsset())),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(571,415);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,555,382)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,269,340)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(283,29,276,340)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(291,343,250,8),new MCacheCompartLine()),
				/*
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(17,34,261,46)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(17,80,261,46)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(17,126,261,46)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(17,172,261,46)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(17,218,261,46)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(17,264,261,46)),
				*/
				
				// 附件背景
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(335,281,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(298,291,50,16),new MAssetLabel(LanguageManager.getWord("ssztl.mail.attach") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(290,371,240,30),new MAssetLabel(LanguageManager.getWord("ssztl.mail.autoDeleteMail"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT))
				]);
			addContent(_bg as DisplayObject);
			
			//自动删除问题 文字提示。
			//未做析构。
//			new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(567,261,31,18),new MAssetLabel(LanguageManager.getWord("ssztl.mounts.mumpDefence")+ "：",MAssetLabel.LABEL_TYPE4,TextFormatAlign.LEFT)),
//			addContent(MBackgroundLabel.getDisplayObject(	new Rectangle(16, 317, 256, 16),
//				new MAssetLabel(LanguageManager.getWord("ssztl.mail.autoDeleteMail"),
//					MAssetLabel.LABEL_TYPE2,
//					TextFormatAlign.LEFT)));
			
			_listPanel = new ListPanel(_mediator);
			_listPanel.x = _listPanel.y = 0;
			addContent(_listPanel);
			
			showWritePanel(GlobalData.selfPlayer.serverId);
		}
		
		public function showWritePanel(serverId:int,nick:String = ""):void
		{
			if(_readPanel&& _readPanel.parent)
				_readPanel.parent.removeChild(_readPanel);
			if(_writePanel == null)
			{
				_writePanel = new WritePanel(_mediator);
			}
			addContent(_writePanel);
			_writePanel.move(283,29);
			_writePanel.write(serverId,nick);
		}
		
		public function showReadPanel(item:MailItemInfo):void
		{
			if(_writePanel&&_writePanel.parent)
			{
				_writePanel.parent.removeChild(_writePanel);
				GlobalData.clientBagInfo.clearMailList();
			}
			if(_readPanel == null)
			{
				_readPanel = new ReadPanel(_mediator);	
			}
			addContent(_readPanel);
			_readPanel.move(283,29);
			_readPanel.showMail(item, _listPanel.currrentPage, _listPanel.currentType);
		}
		
		public function showFirst():void
		{
			_listPanel.showFirst();
		}
		
		public function clearReadPanel():void
		{
			_readPanel.clear();	
		}
		
		public function load():void
		{
			_listPanel.loadData();
		}
		
		override public function dispose():void
		{
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_listPanel.dispose();
			_listPanel = null;
			if(_readPanel)
			{
				_readPanel.dispose();
				_readPanel = null;
			}
			if(_writePanel)
			{
				_writePanel.dispose();
				_writePanel = null;
			}
			super.dispose();
		}
	}
}