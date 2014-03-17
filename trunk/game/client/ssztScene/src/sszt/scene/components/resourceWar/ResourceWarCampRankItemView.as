package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CampType;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.resourceWar.ResourceWarCampRankItemInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.scene.DotaCampRankBgAsset1;
	import ssztui.scene.DotaCampRankBgAsset2;
	import ssztui.scene.DotaCampRankBgAsset3;
	
	public class ResourceWarCampRankItemView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _bgCamp:Bitmap;
		
		private var _totalPointLabel:MAssetLabel;
		private var _killPointLabel:MAssetLabel;
		private var _collectPointLabel:MAssetLabel;
		
		public function ResourceWarCampRankItemView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_bgCamp = new Bitmap();
			addChild(_bgCamp);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(63,10,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.allScore"),MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(63,30,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.killScore"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(141,30,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.collectionScore"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT))
				
			]);
			addChild(_bg as DisplayObject);
			
			_totalPointLabel =new MAssetLabel('',MAssetLabel.LABEL_TYPE21,'left');
			_totalPointLabel.move(111,10);
			addChild(_totalPointLabel);
			
			_killPointLabel =new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_killPointLabel.move(177,30);
			addChild(_killPointLabel);
			
			_collectPointLabel =new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_collectPointLabel.move(99,30);
			addChild(_collectPointLabel);
		}
		
		public function updateView(info:ResourceWarCampRankItemInfo):void
		{
			switch(info.campType)
			{
				case 1:
					_bgCamp.bitmapData = new DotaCampRankBgAsset1();
					break;
				case 2:
					_bgCamp.bitmapData = new DotaCampRankBgAsset2();
					break;
				case 3:
					_bgCamp.bitmapData = new DotaCampRankBgAsset3();
					break;
			}
			
//			_campNameLabel.setValue(CampType.getCampName(info.campType));
			_totalPointLabel.setValue(info.totalPoint.toString());
			_killPointLabel.setValue(info.killingPoint.toString());
			_collectPointLabel.setValue(info.collectingPoint.toString());
		}
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgCamp && _bgCamp.bitmapData)
			{
				_bgCamp.bitmapData.dispose();
				_bgCamp = null;
			}
			super.dispose();
			_totalPointLabel = null;
			_totalPointLabel = null;
			_collectPointLabel = null;
		}
	}
}