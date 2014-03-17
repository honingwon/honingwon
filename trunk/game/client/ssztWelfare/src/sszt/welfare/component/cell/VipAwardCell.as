package sszt.welfare.component.cell
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.vip.VipAwardType;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.vip.PlayerVipAwardSocketHandler;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.ui.label.MAssetLabel;
	
	public class VipAwardCell extends BaseCell
	{
		private var _type:int;
		private var _itemTemplateInfo:ItemTemplateInfo;
		
		private var _txtCount:TextField;
		private var _txtGet:MAssetLabel;
		private var _txtGot:MAssetLabel;
		
		public function VipAwardCell(type:int)
		{
			_type = type;
			super();
			setItemInfo();
		}
		
		private function setItemInfo():void
		{
//			var vipType:int = GlobalData.selfPlayer.getVipType();
//			switch(_type)
//			{
//				
//			}
			switch(_type)
			{
				case VipAwardType.FLY_COUNT :
					_itemTemplateInfo = ItemTemplateList.getTemplate(CategoryType.TRANSFER);
					break;
				case VipAwardType.SPEAKER_COUNT :
					_itemTemplateInfo = ItemTemplateList.getTemplate(CategoryType.SPEAKER_ID);
					break;
				case VipAwardType.BIND_YUANBAO :
					_itemTemplateInfo = ItemTemplateList.getTemplate(CategoryType.BIND_YUANBAO);
					break;
				case VipAwardType.COPPER :
					_itemTemplateInfo = ItemTemplateList.getTemplate(CategoryType.COPPER);
					break;
				case VipAwardType.BUFF :
					_itemTemplateInfo = ItemTemplateList.getTemplate(280003);
					break;
			}
			super.info = _itemTemplateInfo;
		}
		
		public function setData(... args):void
		{
			if(_type == VipAwardType.FLY_COUNT || _type == VipAwardType.SPEAKER_COUNT)
			{
				var remaining:int = args[0]; 
				var total:int = args[1];
				var txt:String;
				if(_type == VipAwardType.FLY_COUNT && GlobalData.selfPlayer.getVipType() == VipType.BESTVIP)
				{
					txt = LanguageManager.getWord('ssztl.common.noLimitTime');
				}
				else
				{
					txt = (total - remaining) + '/' + total;
				}
				_txtCount.text = txt;
			}
			else
			{
				var isGot:Boolean = args[0];
				_txtGet.visible = !isGot;
				_txtGot.visible = isGot;
			}
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_txtCount = new TextField();
			_txtCount.textColor = 0xffffff;
			_txtCount.x = 0;
			_txtCount.y = 19;
			_txtCount.width = 36;
			_txtCount.height = 25;
			_txtCount.mouseEnabled = _txtCount.mouseWheelEnabled = false;
			_txtCount.filters = [new GlowFilter(0x000000,1,2,2,10)];
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
			_txtCount.defaultTextFormat = t;
			_txtCount.setTextFormat(t);
			addChild(_txtCount);
			
			_txtGet = new MAssetLabel("",MAssetLabel.LABEL_TYPE7);
			_txtGet.move(19,38);
			_txtGet.setHtmlValue("<a href=\'event:0\'><u>"+LanguageManager.getWord("ssztl.club.getWelFare")+"</u></a>");
			addChild(_txtGet);
			
			_txtGot = new MAssetLabel("",MAssetLabel.LABEL_TYPE7);
			_txtGot.move(19,38);
			_txtGot.setHtmlValue("<font color='#5b6a68'>"+LanguageManager.getWord("ssztl.activity.hasGotten")+"</font>");
			addChild(_txtGot);
			_txtGet.mouseEnabled = true;
			_txtGet.visible = _txtGot.visible = false;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_txtGet.addEventListener(MouseEvent.CLICK, getAward);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_txtGet.removeEventListener(MouseEvent.CLICK, getAward);
		}
		
		private function getAward(e:Event):void
		{
			PlayerVipAwardSocketHandler.send(_type);
		}		
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			if(_txtCount)
			{
				addChild(_txtCount);
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			var vipType:int = GlobalData.selfPlayer.getVipType();
			var vipTemplateInfo:VipTemplateInfo = VipTemplateList.getVipTemplateInfo(vipType);
			var transferTotal:int = vipTemplateInfo.shoesCount;
			var speakerTotal:int = vipTemplateInfo.bugleCount;
			var yuanbaoTotal:int = vipTemplateInfo.yuanBao;
			var moneyTotal:int = vipTemplateInfo.money;
			
			var tip:String;
			switch(_type)
			{
				case VipAwardType.FLY_COUNT :
					if(vipType == VipType.BESTVIP)
					{
						tip = LanguageManager.getWord('ssztl.vip.vipTipShoe', 
							LanguageManager.getWord('ssztl.common.noLimitTime')
						);
					}
					else
					{
						tip = LanguageManager.getWord('ssztl.vip.vipTipShoe', transferTotal);
					}
					break;
				case VipAwardType.SPEAKER_COUNT :
					tip = LanguageManager.getWord('ssztl.vip.vipTipSpeaker', speakerTotal);
					break;
				case VipAwardType.BIND_YUANBAO :
					tip = LanguageManager.getWord('ssztl.vip.vipTipYuanbao', yuanbaoTotal);
					break;
				case VipAwardType.COPPER :
					tip = LanguageManager.getWord('ssztl.vip.vipTipCopper', moneyTotal);
					break;
				case VipAwardType.BUFF :
					tip = LanguageManager.getWord('ssztl.vip.vipTipBuff')+"\n"+BuffTemplateList.getBuff(int(vipTemplateInfo.buffs)).name+"\n"+BuffTemplateList.getBuff(int(vipTemplateInfo.buffs)).descript;
					break;
			}
			
			if(tip)
			{
				TipsUtil.getInstance().show(tip,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_txtCount)
			{
				_txtCount = null;
			}
		}
		
		
	}
}