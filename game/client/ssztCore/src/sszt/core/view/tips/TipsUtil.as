package sszt.core.view.tips
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.core.mx_internal;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.mountsSkill.MountsSkillInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.socketHandlers.bag.ItemReferSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;

	public class TipsUtil
	{
		private var _soul:Sprite;
		private static const OFFSET:int = 10;
		
		private var _tip1:BaseDynamicTip;
		private var _tip2:BaseDynamicTip;
		
		private var _showTimeoutIndex:int = -1;
		private var _tempTimeoutIndex:int = -1;
		
		private static var instance:TipsUtil;
		public static function getInstance():TipsUtil
		{
			if(instance == null)
			{
				instance = new TipsUtil();
			}
			return instance;
		}
		
		public function TipsUtil()
		{
			_soul = new Sprite();
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SHOW_ITEMTIP,showItemTipHandler);
			GlobalAPI.layerManager.getTipLayer().stage.addEventListener(MouseEvent.CLICK,hideTipHandler);
		}
		
		private function showItemTipHandler(e:CommonModuleEvent):void
		{
			var obj:Object = e.data as Object;
			var userId:Number = obj.userId;
			var itemId:Number = obj.itemId;
			var posX:int = obj.posX;
			var posY:int = obj.posY;
			var p:Boolean = true;
			var itemTempId:int = obj.itemTempId;
			if(itemId<=0)
			{
				var itemTemplate:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
				if(itemTemplate)
				{
					_tempTimeoutIndex = setTimeout(showTempTip,100);
				}
			}
			else
			{
				_showTimeoutIndex = setTimeout(showTip,100);
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.LOAD_ITEMINFO_COMPLETE,loadCompleteHandler);
				ItemReferSocketHandler.send(userId,itemId);
			}
			function showTempTip():void
			{
				show(itemTemplate,null,new Rectangle(posX,posY,0,0));
				if(_tempTimeoutIndex != -1)
				{
					clearTimeout(_tempTimeoutIndex);
				}
			}
			function showTip():void
			{
				if(p)show(null,null,new Rectangle(posX,posY,0,0));
				if(_showTimeoutIndex != -1)
				{
					clearTimeout(_showTimeoutIndex);
				}
			}
			
			function loadCompleteHandler(e:CommonModuleEvent):void
			{
				var itemInfo:ItemInfo = e.data as ItemInfo;
				show(itemInfo,null,new Rectangle(posX,posY,0,0));
				p = false;
			}
		}
		
		private function hideTipHandler(e:MouseEvent):void
		{
			hide();
		}
		/**
		 * 
		 * @param info1
		 * @param info2
		 * @param rect
		 * @param isUsing
		 * @param param
		 * @param showTemplateBind模版tips是否显示绑定类型
		 * 
		 */		
		public function show(info1:Object,info2:Object,rect:Rectangle,isUsing:Boolean = false,param:int = 0,showTemplateBind:Boolean = true,hidePetProperty:Boolean = false,isOther:Boolean = false,otherList:Array = null):void
		{
			if(info1 is SkillTemplateInfo && info2 == null)
			{
				setSkillTemplateTip(info1 as SkillTemplateInfo);
			}
			//普通技能的tips
			else if(info1 is SkillItemInfo && info2 == null && !(info1 is PetSkillInfo) && !(info1 is MountsSkillInfo))
			{
				setSkillItemTip(info1 as SkillItemInfo);
			}
			//宠物技能tips
			else if(info1 is PetSkillInfo && info2 == null)
			{
				setPetSkillItemTip(info1 as PetSkillInfo);
			}
				//坐骑技能tips
			else if(info1 is MountsSkillInfo && info2 == null)
			{
				setMountsSkillItemTip(info1 as MountsSkillInfo);
			}
			
			else if(info1 is PetItemInfo)
			{
				setPetItemInfo(info1 as PetItemInfo,hidePetProperty);
			}
			
			else if(info1 is MountsItemInfo)
			{
				setMountItemInfo(info1 as MountsItemInfo,hidePetProperty);
			}
			
			else if(info1 is ItemTemplateInfo && CategoryType.isPet((info1 as ItemTemplateInfo).categoryId))
			{
				setPetTemplate(info1 as ItemTemplateInfo);
			}
			else if(info1 is ItemTemplateInfo)
			{
				setItemTemplateTip(info1 as ItemTemplateInfo,info2 as ItemInfo,param,showTemplateBind);
			}
			//装备的tips
			else if(info1 is ItemInfo)
			{
				setItemInfoTip(info1 as ItemInfo,info2 as ItemInfo,param,isOther,otherList);
			}
			else if(info1 is BuffItemInfo)
			{
				setBuffItemInfo(info1 as BuffItemInfo);
			}
			//按钮Tips
			else if(info1 is String)
			{
				setBaseTip(info1 as String);
			}
			else if(info1 == null)
			{
				setBaseTip("\n\n   Loading...\n\n\n");
			}
			_soul.addEventListener(Event.ENTER_FRAME,movehs);
			setTipPos(rect);
		}
		
		public function hide():void
		{
			if(_tip1)_tip1.hide();
			if(_tip2)_tip2.hide();
			_soul.removeEventListener(Event.ENTER_FRAME,movehs);
		}
		
		private function setPetTemplate(info1:ItemTemplateInfo):void
		{
			if(!(_tip1 is PetTemplateTip))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new PetTemplateTip();
			}
			(_tip1 as PetTemplateTip).setPetTemplate(info1);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setPetItemInfo(info1:PetItemInfo,hidePetProperty:Boolean):void
		{
			if(!(_tip1 is PetTip))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new PetTip();
			}
			(_tip1 as PetTip).setPetInfo(info1,hidePetProperty);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setMountItemInfo(info1:MountsItemInfo,hidePetProperty:Boolean):void
		{
			if(!(_tip1 is MountsTip))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new MountsTip();
			}
			(_tip1 as MountsTip).setMountsInfo(info1,hidePetProperty);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setSkillTemplateTip(info1:SkillTemplateInfo):void
		{
			if(!(_tip1 is SkillTemplateTip && !(_tip1 is SkillItemTip)))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new SkillTemplateTip();
			}
			(_tip1 as SkillTemplateTip).setSkillTemplate(info1);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setSkillItemTip(info1:SkillItemInfo):void
		{
			if(!(_tip1 is SkillItemTip && !(_tip1 is PetSkillItemTip) && !(_tip1 is MountsSkillItemTip)))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new SkillItemTip();
			}
			(_tip1 as SkillItemTip).setSkillIteminfo(info1);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setPetSkillItemTip(info1:PetSkillInfo):void
		{
			if(!(_tip1 is PetSkillItemTip))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new PetSkillItemTip();
			}
			(_tip1 as PetSkillItemTip).setPetSkillIteminfo(info1);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setMountsSkillItemTip(info1:MountsSkillInfo):void
		{
			if(!(_tip1 is MountsSkillItemTip))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new MountsSkillItemTip();
			}
			(_tip1 as MountsSkillItemTip).setMountsSkillIteminfo(info1);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setBuffItemInfo(info1:BuffItemInfo):void
		{
			if(!(_tip1 is BuffItemInfo))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new BuffTip();
			}
			(_tip1 as BuffTip).setBuff(info1);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		
		private function setItemTemplateTip(info1:ItemTemplateInfo,info2:ItemInfo,price:int = 0,showTemplateBind:Boolean = true):void
		{
			if(!(_tip1 is ItemTemplateTip && !(_tip1 is ItemInfoTip)))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new ItemTemplateTip();
			}
			(_tip1 as ItemTemplateTip).setItemTemplate(info1,info2,price,showTemplateBind);
			_tip1.show();
			
			if(info2 != null && info2 is ItemInfo)
			{
				if(!(_tip2 is ItemInfoTip))
				{
					if(_tip2 != null)_tip2.hide();
					_tip2 = new ItemInfoTip();
				}
				(_tip2 as ItemInfoTip).setItemInfo(info2);
				_tip2.show();
			}
			else
			{
				if(_tip2)_tip2.hide();
				_tip2 = null;
			}
		}
		
		private function setItemInfoTip(info1:ItemInfo,info2:ItemInfo,price:int = 0,isOther:Boolean = false,otherList:Array = null):void
		{
			if(!(_tip1 is ItemInfoTip))
			{
				if(_tip1 != null)_tip1.hide();
				_tip1 = new ItemInfoTip();
			}
			(_tip1 as ItemInfoTip).setItemInfo(info1,info2,price,false,isOther,otherList);
			_tip1.show();
			
			if(info2 != null && info2 is ItemInfo)
			{
				if(!(_tip2 is ItemInfoTip))
				{
					if(_tip2 != null)_tip2.hide();
					_tip2 = new ItemInfoTip();
				}
				(_tip2 as ItemInfoTip).setItemInfo(info2,null,0,true);
				_tip2.show();
			}
			else
			{
				if(_tip2)_tip2.hide();
				_tip2 = null;
			}
		}
		
		private function setBaseTip(mes:String):void
		{
			if(_tip1 != null)_tip1.hide();
			_tip1 = new BaseDynamicTip();
			_tip1.setTips(mes);
			_tip1.show();
			if(_tip2)_tip2.hide();
			_tip2 = null;
		}
		private function movehs(e:Event):void {
			setTipPos(new Rectangle(_soul.mouseX,_soul.mouseY,0,0));
		}
		private function setTipPos(rect:Rectangle):void
		{
			var width:int = _tip1.width;
			if(_tip2 != null)width += _tip2.width;
			var height:int = _tip1.height;
			if(_tip2 != null)height = _tip1.height > _tip2.height ? _tip1.height : _tip2.height;
			
			if(width + rect.x + rect.width + OFFSET > CommonConfig.GAME_WIDTH)
			{
				if(_tip1)_tip1.x = rect.x - _tip1.width - OFFSET;
				if(_tip2) _tip2.x = rect.x - _tip1.width - _tip2.width - OFFSET;
			}
			else
			{
				if(_tip1)_tip1.x = rect.x + rect.width + OFFSET;
				if(_tip2)_tip2.x = rect.x + rect.width + _tip1.width + OFFSET;
			}
			if(height + rect.y + rect.height + OFFSET > CommonConfig.GAME_HEIGHT)
			{
				if(_tip1)_tip1.y = rect.y - height;
				if(_tip1.y < 0) _tip1.y = 0;
				if(_tip2)_tip2.y = _tip1.y;
			}
			else
			{
				if(_tip1)_tip1.y = rect.y + rect.height + OFFSET;
				if(_tip2)_tip2.y = _tip1.y;
			}
		}
	}
}