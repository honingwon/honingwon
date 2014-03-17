package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CampType;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.resourceWar.ResourceWarUserRankItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.scene.DotaCampRankBgAsset1;
	import ssztui.scene.DotaCampRankBgAsset2;
	import ssztui.scene.DotaCampRankBgAsset3;
	
	public class ResourceWarUserRankItemView extends MSprite
	{
		private var _rankIndex:MAssetLabel;
		private var _campNameLabel:MAssetLabel;
		private var _pointLabel:MAssetLabel;
		private var _nickLabel:MAssetLabel;
		
		public function ResourceWarUserRankItemView()
		{
			
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			var colX:Array = [];
			for(var i:int=0; i<ResourceWarUserRankView.COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+ResourceWarUserRankView.COLWidth[i]:ResourceWarUserRankView.COLWidth[0]+i*2);
			}
			_rankIndex = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_rankIndex.move(ResourceWarUserRankView.COLWidth[0]/2,6);
			addChild(_rankIndex);
			
			_nickLabel =new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_nickLabel.move(colX[0]+ResourceWarUserRankView.COLWidth[1]/2,6);
			addChild(_nickLabel);
			
			_campNameLabel =new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_campNameLabel.move(colX[1]+ResourceWarUserRankView.COLWidth[2]/2,6);
			addChild(_campNameLabel);
			
			_pointLabel =new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_pointLabel.move(colX[2]+ResourceWarUserRankView.COLWidth[3]/2,6);
			addChild(_pointLabel);
		}
		
		public function updateView(info:ResourceWarUserRankItemInfo,index:int):void
		{
			_rankIndex.setValue(info.place.toString());
			_pointLabel.setValue(info.totalPoint.toString());
			_campNameLabel.setValue(CampType.getCampName(info.campType));
			_nickLabel.setValue(info.nick);
			switch(info.campType)
			{
				case 1:
					_campNameLabel.textColor = 0x00a9e8;
					break;
				case 2:
					_campNameLabel.textColor = 0xffcc00;
					break;
				case 3:
					_campNameLabel.textColor = 0x00cc00;
					break;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_pointLabel = null;
			_nickLabel = null;
			_campNameLabel = null;
			_rankIndex = null;
		}
	}
}