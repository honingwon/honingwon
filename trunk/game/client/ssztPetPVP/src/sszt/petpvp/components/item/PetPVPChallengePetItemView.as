package sszt.petpvp.components.item
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.petpvp.components.cell.PetCell;
	import sszt.petpvp.components.cell.PetCellBig;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.petPVP.ItemCellAsset;
	import ssztui.petPVP.ItemOverAsset;
	import ssztui.petPVP.ItemRankAsset;
	
	public class PetPVPChallengePetItemView extends MSprite
	{
		private var _bgCell:Bitmap;
		private var _bgRank:Bitmap;
		private var _over:Bitmap;
		
		private var _selected:Boolean;
		private var _info:PetPVPPetItemInfo;
				
		private var _cell:PetCellBig;
		private var _nickLabel:MAssetLabel;
		private var _placeLabel:MAssetLabel;
		private var _fightLabel:MAssetLabel;
		private var _chanllengeLabel:MAssetLabel;
		private var _chanllengeBg:Sprite;
		
		public function PetPVPChallengePetItemView(info:PetPVPPetItemInfo)
		{
			_info = info;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			buttonMode = true;
			_bgCell = new Bitmap(new ItemCellAsset());
			_bgCell.x = _bgCell.y = 10;
			addChild(_bgCell);
			
			_cell = new PetCellBig();
			_cell.move(15,15);
			var petItemInfo:PetItemInfo = new PetItemInfo();
			petItemInfo.templateId = _info.templateId;
			addChild(_cell);
			_cell.petItemInfo = petItemInfo;
			
			_chanllengeBg = new Sprite();
			_chanllengeBg.graphics.beginFill(0x000000,0.4);
			_chanllengeBg.graphics.drawRect(16,16,48,48);
			_chanllengeBg.graphics.endFill();
			addChild(_chanllengeBg);
			_chanllengeBg.visible = false;
			
			_over = new Bitmap(new ItemOverAsset());
			_over.x = _over.y = 16;
			addChild(_over);
			_over.visible = false;
			
			_chanllengeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_chanllengeLabel.move(40,34);
			addChild(_chanllengeLabel);
			_chanllengeLabel.setHtmlValue(LanguageManager.getWord("ssztl.challenge.dare"));
			_chanllengeLabel.visible = false;
			
			_bgRank = new Bitmap(new ItemRankAsset());
			_bgRank.x = 20;
			_bgRank.y = 60;
			addChild(_bgRank);
			
			_nickLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_nickLabel.move(40,81);
			addChild(_nickLabel);
			_nickLabel.textColor = CategoryType.getQualityColor(_info.quality);
			_nickLabel.setHtmlValue(_info.nick);
			
			_placeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE8);
			_placeLabel.move(40,60);
			addChild(_placeLabel);
			_placeLabel.setHtmlValue(_info.place.toString());
			
			_fightLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_fightLabel.move(40,99);
			addChild(_fightLabel);
			_fightLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.fightValueTh") + "：" + _info.fight.toString());
			
			initEvent();
		}
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			_over.visible = true;
			_chanllengeLabel.visible = true;
			_chanllengeBg.visible = true;
			var tip:String = 
				"<font color='#" + CategoryType.getQualityColorString(_info.quality) + "'>" + _info.nick + "</font> " + 
				LanguageManager.getWord("ssztl.common.levelValue2",_info.level) + "\n" +
				LanguageManager.getWord("ssztl.scene.rank")  + "：" + _info.place + "\n" +
				LanguageManager.getWord("ssztl.sword.qualityLevel") + "：" + _info.stairs + "\n" +
				LanguageManager.getWord("ssztl.common.fightValue")  + "：" + _info.fight + "\n" +
				"<font color='#ff9900'>" + LanguageManager.getWord("ssztl.petpvp.winRate")  + "：" + int(info.win/info.total*100) + "%</font>"	;
			TipsUtil.getInstance().show(tip,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(e:MouseEvent):void
		{
			_over.visible = false;
			_chanllengeLabel.visible = false;
			_chanllengeBg.visible = false;
			TipsUtil.getInstance().hide();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			graphics.clear();
			if(_selected)
			{
			}
			else
			{
			}
		}
		
		public function get info():PetPVPPetItemInfo
		{
			return _info;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent()
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_over && _over.bitmapData)
			{
				_over.bitmapData.dispose();
				_over = null;
			}
			if(_bgRank && _bgRank.bitmapData)
			{
				_bgRank.bitmapData.dispose();
				_bgRank = null;
			}
			if(_bgCell && _bgCell.bitmapData)
			{
				_bgCell.bitmapData.dispose();
				_bgCell = null;
			}
			_fightLabel = null;
			_nickLabel = null;
			_placeLabel = null;
		}
	}
}