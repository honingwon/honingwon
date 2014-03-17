package sszt.pet.component.items
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.pet.component.cells.PetSkillBookCell;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.socketHandler.PetGetSkillBookItemSocketHandler;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class PetSkillBookItemView extends Sprite
	{
		private var _mediator:PetMediator;
		private var _info:ItemInfo;
		
		private var _cell:PetSkillBookCell;
		private var _btnGet:MCacheAssetBtn1;
		private var _txtName:MAssetLabel;
		
		public function PetSkillBookItemView(mediator:PetMediator)
		{
			_mediator = mediator;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_cell = new PetSkillBookCell();
			_cell.move(11, 9);
			addChild(_cell);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE7, TextFieldAutoSize.LEFT);
			_txtName.move(12, 56);
			addChild(_txtName);
			
			_btnGet = new MCacheAssetBtn1(1, 1, LanguageManager.getWord('ssztl.common.get'));
			_btnGet.move(14,77);
			addChild(_btnGet);
			
			this.visible = false;
			_btnGet.mouseEnabled = false;
		}
		
		private function initEvent():void
		{
			_btnGet.addEventListener(MouseEvent.CLICK, sendGetRequest);
		}
		private function removeEvent():void
		{
			_btnGet.removeEventListener(MouseEvent.CLICK, sendGetRequest);
		}
		
		private function sendGetRequest(event:MouseEvent):void
		{
			PetGetSkillBookItemSocketHandler.send(_info.place);
			_mediator.module.petsInfo.petRefreshSkillBooksInfo.gotbooksPlace = _info.place;
		}
		
		public function get btnGet():MCacheAssetBtn1
		{
			return _btnGet;
		}
		
		public function get info():ItemInfo
		{
			return _info;
		}
		
		public function set info(_itemInfo:ItemInfo):void
		{
			_info = _itemInfo;
			if(_info)
			{
				_cell.skillBookInfo = _info;
				if(_info.templateId == 260027)
				{
					_txtName.setValue(LanguageManager.getWord('ssztl.pet.skillBookFragment'));
				}
				else
				{
					_txtName.setValue(_info.template.name);
				}
				_txtName.textColor = CategoryType.getQualityColor(_info.template.quality);
				this.visible = true;
				_btnGet.mouseEnabled = true;
				_btnGet.enabled = true;
			}
			else
			{
				_cell.skillBookInfo = null;
				this.visible = false;
				_btnGet.mouseEnabled = false;
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_info)
			{
				_info = null;
			}
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_btnGet)
			{
				_btnGet.dispose();
				_btnGet = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
		}
	}
}