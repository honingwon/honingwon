package sszt.petpvp.components.item
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.petpvp.components.cell.PetCellBig;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	public class PetPVPRankItemView extends MSprite
	{
		private var _info:PetPVPPetItemInfo;
		
		private var _cell:PetCellBig;
		private var _nickLabel:MAssetLabel;
		private var _placeLabel:MAssetLabel;
		
		public function PetPVPRankItemView(info:PetPVPPetItemInfo)
		{
			_info = info;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_cell = new PetCellBig();
			_cell.move(9,10);
			addChild(_cell);
			_cell.info = PetTemplateList.getPet(_info.templateId);
			_cell._petPvpPetItemInfo = _info;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,showTipHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
			_nickLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,'left');
			_nickLabel.move(66,36);
			addChild(_nickLabel);
			_nickLabel.textColor = CategoryType.getQualityColor(_info.quality);
			_nickLabel.setHtmlValue(_info.nick);
			
			_placeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,'left');
			_placeLabel.move(66,14);
			addChild(_placeLabel);
			_placeLabel.setHtmlValue(LanguageManager.getWord("ssztl.petpvp.tagRank"+_info.place));
		}
		
		private function showTipHandler(e:MouseEvent):void
		{
			if(_info)
			{
				//TipsUtil.getInstance().show(_petItemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));	
				var tip:String = 
					"<font color='#" + CategoryType.getQualityColorString(_info.quality) + "'>" + _info.nick + "</font> " + 
					LanguageManager.getWord("ssztl.common.levelValue2",_info.level) + "\n" +
					LanguageManager.getWord("ssztl.scene.rank")  + "：" + _info.place + "\n" +
					LanguageManager.getWord("ssztl.sword.qualityLevel") + "：" + _info.stairs + "\n" +
					LanguageManager.getWord("ssztl.common.fightValue")  + "：" + _info.fight + "\n" +
					"<font color='#ff9900'>" + LanguageManager.getWord("ssztl.petpvp.winRate")  + "：" + int(_info.win/_info.total*100) + "%</font>"	;
				TipsUtil.getInstance().show(tip,null,new Rectangle(e.stageX,e.stageY,0,0));
			}
			
		}
		
		private function hideTipHandler(evt:MouseEvent):void
		{
			if(_info)
			{
				TipsUtil.getInstance().hide();
			}
		}
		
		override public function dispose():void
		{			
			this.removeEventListener(MouseEvent.MOUSE_OVER,showTipHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
			super.dispose();
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			_nickLabel = null;
			_placeLabel = null;
		}
		
		
	}
}