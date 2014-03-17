package sszt.scene.components.cityCraft
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CampType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.cityCraft.CityCraftEnterSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;

	public class CityCraftJoinPanel extends MSprite implements IPanel
	{
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _picPath:String;
		private var _attackBtn:MCacheAssetBtn1;
		private var _defenseBtn:MCacheAssetBtn1;
		
		private const CELL_POS:Array = [
			new Point(33,224),
			new Point(72,224),
			new Point(111,224),
			new Point(184,224),
			new Point(223,224),
			new Point(262,224),
			new Point(184,263),
			new Point(223,263),
			new Point(371,224)
		];
		
		private var _itemList:Array;
		private var _cellList:Array;
		private var _guildLabel1:MAssetLabel;
		private var _guildLabel2:MAssetLabel;
		
		public function CityCraftJoinPanel(mediator:SceneMediator)
		{			
			_mediator = mediator;
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_bgLayout = new Bitmap();
			addChild(_bgLayout);
			_picPath = GlobalAPI.pathManager.getBannerPath("cityFightMask.png");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,172,580,20),new MAssetLabel("以个人名义助援",MAssetLabel.LABEL_TYPE_YAHEI)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,195,580,20),new MAssetLabel("选择助援方",MAssetLabel.LABEL_TYPE_YAHEI)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(68,70,65,20),new MAssetLabel(GlobalData.cityCraftInfo.attackGuild,MAssetLabel.LABEL_TYPE_YAHEI)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(195,70,65,20),new MAssetLabel(GlobalData.cityCraftInfo.defenseGuild,MAssetLabel.LABEL_TYPE_YAHEI)),
			]);
			addChild(_bg as DisplayObject);
			
			_attackBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.cityCraft.joinAttack'));
			_attackBtn.move(97,242);
			_defenseBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.cityCraft.joinDefense'));
			_defenseBtn.move(417,242);
			if(!MapTemplateList.isResourceWarMap())
			{
				addChild(_attackBtn);
				addChild(_defenseBtn);
			}			
						
//			_guildLabel1 = new MAssetLabel(GlobalData.cityCraftInfo.attackGuild,MAssetLabel.LABEL_TYPE_TAG,"left");
//			_guildLabel1.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,9)]);
//			_guildLabel1.move(100,100);
//			addChild(_guildLabel1);
//			
//			_guildLabel2 = new MAssetLabel(GlobalData.cityCraftInfo.defenseGuild,MAssetLabel.LABEL_TYPE_TAG,"left");
//			_guildLabel2.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,9)]);
//			_guildLabel2.move(150,100);	
//			addChild(_guildLabel2);
			
			initEvent();
			
		}
		private function initEvent():void
		{
			_attackBtn.addEventListener(MouseEvent.CLICK,btnAttackClickHandler);
			_defenseBtn.addEventListener(MouseEvent.CLICK,btnDefenseClickHandler);
		}
		
		private function removeEvent():void
		{
			_attackBtn.removeEventListener(MouseEvent.CLICK,btnAttackClickHandler);
			_defenseBtn.removeEventListener(MouseEvent.CLICK,btnDefenseClickHandler);
		}
		
		private function btnAttackClickHandler(event:MouseEvent):void
		{			
			CityCraftEnterSocketHandler.send(CampType.ATK_CITY);
			dispose();
		}
		
		private function btnDefenseClickHandler(event:MouseEvent):void
		{
			CityCraftEnterSocketHandler.send(CampType.DEF_CITY);
			dispose();
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
		}		
		public function doEscHandler():void
		{
			dispose();
		}
		override public function dispose():void
		{
			removeEvent();
			_bgLayout = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_attackBtn)
			{
				_attackBtn.dispose();
				_attackBtn = null;
			}
			if(_defenseBtn)
			{
				_defenseBtn.dispose();
				_defenseBtn = null;
			}
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}