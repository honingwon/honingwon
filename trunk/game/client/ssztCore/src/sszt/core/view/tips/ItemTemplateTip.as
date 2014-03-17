package sszt.core.view.tips
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.constData.PropertyType;
	import sszt.core.caches.ToolTipCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.furnace.StrengInfo;
	import sszt.core.data.furnace.StrengParametersInfo;
	import sszt.core.data.furnace.StrengParametersTemplateList;
	import sszt.core.data.furnace.StrengTemplateList;
	import sszt.core.data.item.ItemFreeProperty;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.item.SuitNumberInfo;
	import sszt.core.data.item.SuitNumberList;
	import sszt.core.data.item.SuitTemplateInfo;
	import sszt.core.data.item.SuitTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.StringUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	

	public class ItemTemplateTip extends BaseDynamicTip
	{
		private var _info:ItemTemplateInfo;
		private var _otherinfo:ItemInfo;
		private var _price:int;
		private var _itemIcon:BaseCell;
		protected var _itemBitmap:Bitmap;
		private var _lineBg:Array;  //线条背景
		private var _qualityBg:Bitmap;
		private var _bingding:Bitmap;//绑定的ICON
		
		
		public function ItemTemplateTip()
		{
			super();
			_lineBg = new Array();  
		}
		
		public function setItemTemplate(info:ItemTemplateInfo,otherinfo:ItemInfo = null,price:int = 0,showBind:Boolean = true):void
		{
			clear();

			_info = info;
			_otherinfo = otherinfo;
			_price = price;
			_text.width = 198;
			_text.text = "";
			
			//tipsBG
			addQuilayBg();
			//tipsName
			addTipsName();
			//添加当前装备的ICON
			addItemIcon();
			//强化星级
			addStar();
			
			var typeLabel:String = getType(_info.categoryId);
			var len:int = StringUtils.checkLen(typeLabel);
			var tmpColor:int = 0xffffff;
			if(_info.needCareer > 0)
			{
				if(_info.needCareer == GlobalData.selfPlayer.career) tmpColor = 0xffffff;
				else tmpColor = 0xFF0000;
			}
			addStringToField(typeLabel,getTextFormat(tmpColor));
//			if(len < 12) 
//				addStringToField("\t\t\t\t ",getTextFormat(0),false);
//			else 
//				addStringToField("\t\t\t ",getTextFormat(0),false);
			//绑定
			showBindFunction();
			
			var levelLabel:String = getLevel(_info.needLevel);
			len = StringUtils.checkLen(levelLabel);
			if(_info.needLevel <= GlobalData.selfPlayer.level)
				addStringToField(levelLabel,getTextFormat(0xFFFFFF));
			else
				addStringToField(levelLabel,getTextFormat(0xFF0000));
//			if(len < 16) 
//				addStringToField("\t\t\t\t",getTextFormat(0),false);
//			else 
//				addStringToField("\t\t\t",getTextFormat(0),false);
		
			//装备评分
			addScore();
			
			addLineBG();
			
			addProperty();
			
			//套装属性
			addSuitProperty();
			
			//装备说明
			addDescritption();
			
			if(_price == 0)
			{
				if(_info.canSell)addStringToField(getSellPrice(_info.sellCopper),getTextFormat(0xFFFFFF));
				else addStringToField(LanguageManager.getWord("ssztl.common.noSellShop"),getTextFormat(0xFF0000));
			}
			if(!_info.canTrade)addStringToField(LanguageManager.getWord("ssztl.common.noExchange"),getTextFormat(0xFF0000));
			
			if(_price > 0)
				addStringToField(getPrice(_price),getTextFormat(0xFF0000));
			if (GlobalData.bagInfo.getItemById(_info.templateId).length)
			{
				if(CategoryType.isEquip(_info.categoryId) && _info.canRebuild) addStringToField(LanguageManager.getWord("ssztl.common.canFurnaceSplit"),getTextFormat(0x00ff00));
				if(_info.canUse) addStringToField(LanguageManager.getWord("ssztl.common.doubleClickToUse"),getTextFormat(0x777164));
				addStringToField(LanguageManager.getWord("ssztl.common.sendToChat"),getTextFormat(0x777164));
			}
		}
		
		protected function showBindFunction():void
		{
//			if (_bingding == null)
//			{
//				if (_info.bindType == 0) _bingding = new Bitmap(ToolTipCaches.tipBindingAsset[_info.bindType]);
//				else _bingding = new Bitmap(ToolTipCaches.tipBindingAsset[_info.bindType]);
//				
//				_bingding.x = 141;
//				_bingding.y = 53;
//				addChild(_bingding);
//			}
		}
		
		protected function addProperty():void
		{
			if (!CategoryType.isEquip(_info.categoryId)) return;
			//基础属性
			addStringToField(LanguageManager.getWord("ssztl.role.basicProperty"),getTextFormat(0xcea56a));
			//强化的百分比， 通过这个int(attack * add / 100)得到实际的强化值
			var add:int = 0/*StrengthenTemplateList.getStrengthenAddition(_iteminfo.strengthenLevel,_iteminfo.strengthenPerfect)*/;
			
			if(_info.attack > 0)
			{
				/**装备自带攻击力**/
				addStringToField("　　"+getAttack(_info.attack,add),getTextFormat(0xFFFFFF));
			}
			if(_info.defense > 0)
			{
				addStringToField("　　"+getDefence(_info.defense,add),getTextFormat(0xFFFFFF));
			}
			
			/**固定属性**/
			for each(var j:PropertyInfo in _info.regularPropertyList)
			{
				addStringToField("　　"+getRegularProperty(j,add),getTextFormat(0xFFFFFF));
			}
		}
		
		protected function addSuitProperty():void
		{
			if(_info.suitId > 0)
			{
				var suitNumberInfo:SuitNumberInfo = SuitNumberList.getSuitNumberInfo(_info.suitId);
				addStringToField(suitNumberInfo.suitName,getTextFormat(0xa85af0));
				getSuitComponent(suitNumberInfo.clothId);
				getSuitComponent(suitNumberInfo.armetId,false);
				getSuitComponent(suitNumberInfo.cuffId);
				if (suitNumberInfo.itemNum > 3)
				{					
					getSuitComponent(suitNumberInfo.shoesId,false);
					getSuitComponent(suitNumberInfo.caestusId);
					getSuitComponent(suitNumberInfo.necklaceId,false);					
				}
				
				var list:Array = SuitTemplateList.getSuitTemplateList(_info.suitId);
				for each(var i:SuitTemplateInfo in list)
				{
					addStringToField(getSuitProperty(i),getTextFormat(0x777164));
				}
			}
		}
		
		protected function getSuitComponent(id:int,wrap:Boolean = true):void
		{
//			if(_info.templateId == id)
//			{
//				addStringToField(ItemTemplateList.getTemplate(id).name + " ",getTextFormat(0xe05dac),wrap);
//			}else
//			{
//				addStringToField(ItemTemplateList.getTemplate(id).name + " ",getTextFormat(0x929292),wrap);
//			}
			addStringToField(ItemTemplateList.getTemplate(id).name + " ",getTextFormat(0x929292),wrap);
		}
		
		protected function getSuitProperty(suitTemplate:SuitTemplateInfo):String
		{
			var result:String = "";
			result += suitTemplate.descript + "：";
			for each(var i:PropertyInfo in suitTemplate.property)
			{
				result += PropertyType.getName(i.propertyId) + "+" + i.propertyValue + " ";
			}
			return result;
		}
		
		protected function getName(name:String):String
		{
			return name;
		}
		
		private function getNameColor(quality:int):uint
		{
			switch(quality)
			{
				case 0:return 0xFFFFFF;
				case 1:return 0x38FF18;
				case 2:return 0x00BAFF;
				case 3:return 0x9900FF;
			}
			return 0xFFFFFF;
		}
		
		protected function getBindType(type:int):String
		{
			switch(type)
			{
				case 0:return LanguageManager.getWord("ssztl.common.bindAfterWear");
				case 1:return LanguageManager.getWord("ssztl.common.binded");
				case 2:return LanguageManager.getWord("ssztl.common.unBind");
			}
			return "";
		}
		
		private function getType(categoryId:int):String
		{
			var type:String = CategoryType.getNameByType(categoryId);
			if(type == "")return "";
			return LanguageManager.getWord("ssztl.common.typeValue",type);
		}
		
		private function getLevel(level:int):String
		{
			if(level <= 0)return "";
			return LanguageManager.getWord("ssztl.common.useLvValue",level);
		}
		
		private function getCareer(career:int):String
		{
			if(career > 0)return LanguageManager.getWord("ssztl.common.careerValue",CareerType.getNameByCareer(career));
			
			return "";
		}
		
		protected function getAttack(attack:int,add:int = 0):String
		{
			if(attack <= 0)return "";	
			return LanguageManager.getWord("ssztl.common.attackValue", attack);
		}
		
		
		protected function addScore():void
		{
			
		}
		
		//品质背景
		protected function addQuilayBg():void
		{
			if (this._info.quality == 0)
				return;
			
			if( _qualityBg == null )
			{
				_qualityBg = new Bitmap(ToolTipCaches.toolTipBgCache[_info.quality]);
				_qualityBg.x = _qualityBg.y = 3;
				addChild(_qualityBg);
			}
		}
		
		protected function addTipsName():void
		{
			addStringToField(getName(_info.name),getTextFormatExLeading(14,CategoryType.getQualityColor(_info.quality),null,12),false);
		}
		
		//线条背景
		protected function addLineBG(d:int=0):void
		{
			var lineInterval:int = 18;
			var line:MCacheSplit2Line = new MCacheSplit2Line()
			line.x = 10;
			line.y = _text.textHeight+11 + Math.round((lineInterval+d)/2);
			addChild(line);
			_lineBg.push(line);
			addStringToField("\t ",getTextFormatExLeading(12,0x000000,null,lineInterval-16)); //默认行间隔 16(已算间隔4)
		}
		
		//显示ItemICON
		protected function addItemIcon():void
		{
			_itemBitmap = new Bitmap(CellCaches.getCellBg());
			_itemBitmap.x = 164;
			_itemBitmap.y = 8;
			addChild(_itemBitmap);
			
			_itemIcon = new BaseCell(null,false);
			_itemIcon.info = _info;
			_itemIcon.x = 164;
			_itemIcon.y = 8;
			addChild(_itemIcon);
		}
		//加载强化的星星
		protected function addStar():void
		{
		}
		
		//检测当前装备是否穿戴
		protected function addDressIcon():void
		{
			
		}
		
		//装备描述
		protected function addDescritption():void
		{
			
			if (_info.description != "")
			{
//				addStringToField(_info.description,getTextFormat(0x41D913));
				addStringToField("<font face=\'Tahoma\' color=\'#33ff00\' size=\'12\'>" + this._info.description + "</font>", null,false, true);
				
				addLineBG();
			}
			
		}
		
		protected function getStrengthProperty(argPropertyInfo:PropertyInfo,argItemInfo:ItemInfo):String
		{
			if(argPropertyInfo)
			{
				var name:String = PropertyType.getName(argPropertyInfo.propertyId);
				var strengthInfo:StrengParametersInfo = StrengParametersTemplateList.getStrengParametersInfoByQuality(argItemInfo.template.quality,argItemInfo.template.needLevel);
				if(strengthInfo)
				{
					var parameter:int = strengthInfo.equipParameter;
					var tmpValue:int = Math.ceil(argPropertyInfo.propertyValue * (parameter/100));
					return name + " +" +tmpValue+ LanguageManager.getWord("ssztl.common.strengthAnnotate");
				}
			}
			return "";
		}
		
		protected function getRegularProperty(argPropertyInfo:PropertyInfo,add:int = 0):String
		{
			if(argPropertyInfo)
			{
				var name:String = PropertyType.getName(argPropertyInfo.propertyId);
				var content:String = "";
				if(argPropertyInfo.propertyPercent != -1)
				{
//					content = name + " +" + (argPropertyInfo.propertyValue/100) + "%" + LanguageManager.getWord("ssztl.common.fixedAnnotate");
					content = name + " +" + (argPropertyInfo.propertyValue/100) + "%";
					
				}
				else
				{
//					content = name + " +" +argPropertyInfo.propertyValue + LanguageManager.getWord("ssztl.common.fixedAnnotate");
					content = name + " +" +argPropertyInfo.propertyValue;
				}
				return content;
			}
			return "";
		}
		
		protected function getRebuildProperty(argPropertyInfo:ItemFreeProperty,argItemInfo:ItemInfo):String
		{
			var content:String = "";
			if(argPropertyInfo && argPropertyInfo.lockState < ItemFreeProperty.UNLOCK_REBUILD)
			{
				var name:String = PropertyType.getName(argPropertyInfo.propertyId);
				var star:int = -1;
				for(var i:int = 0;i < argItemInfo.template.freePropertyList.length;i++)
				{
					if(argItemInfo.template.freePropertyList[i].propertyId == argPropertyInfo.propertyId)
					{
						if(argItemInfo.template.freePropertyList[i].propertyValue < 9)
						{
							star = argPropertyInfo.propertyValue;
						}
						else
						{
							star = Math.ceil(argPropertyInfo.propertyValue/(argItemInfo.template.freePropertyList[i].propertyValue / 9));
						}
						break;
					}
				}
				var len:int;
				if(star < 0)
				{
					content = name + " +" +argPropertyInfo.propertyValue ;
				}
				else
				{
					if(star > 9) star = 9;
					var color:String;
					if(star < 4 )
						color = "#00cc00";//lv
					else if(star < 7)
						color = "#00ccff";//lan
					else if(star < 9)
						color = "#cc00ff";//z
					else
						color = "#ff9900";//s
					
					if(argPropertyInfo.propertyValue > argItemInfo.template.freePropertyList[i].propertyValue)
					{
						content = name + " +" +argItemInfo.template.freePropertyList[i].propertyValue;
//						len = StringUtils.checkLen(content);
//							
//						if(len < 8) content = content +  "\t\t\t"+LanguageManager.getWord("ssztl.common.rebuildStarValue",star);
//						else if(len < 12) content = content + "\t\t"+LanguageManager.getWord("ssztl.common.rebuildStarValue",star);
//						else content = content +  "\t"+LanguageManager.getWord("ssztl.common.rebuildStarValue",star);
						
					}
					else
					{
						content = name + " +" +argPropertyInfo.propertyValue;
//						len = StringUtils.checkLen(content);
//						if(len < 8) content = content +  "\t\t\t"+LanguageManager.getWord("ssztl.common.rebuildStarValue",star);
//						else if(len < 12) content = content + "\t\t"+LanguageManager.getWord("ssztl.common.rebuildStarValue",star);
//						else content = content + "\t"+LanguageManager.getWord("ssztl.common.rebuildStarValue",star);
					}
					//content = "<font color=\'"+color+"\' size=\'12\'>" + content + "</font>";
				}
				return content;
			}
			return "";
		}
		protected function getRebuildPropertyColor(argPropertyInfo:ItemFreeProperty,argItemInfo:ItemInfo):int
		{
			var content:String = "";
			if(argPropertyInfo && argPropertyInfo.lockState < ItemFreeProperty.UNLOCK_REBUILD)
			{
				var name:String = PropertyType.getName(argPropertyInfo.propertyId);
				var star:int = -1;
				for(var i:int = 0;i < argItemInfo.template.freePropertyList.length;i++)
				{
					if(argItemInfo.template.freePropertyList[i].propertyId == argPropertyInfo.propertyId)
					{
						if(argItemInfo.template.freePropertyList[i].propertyValue < 9)
						{
							star = argPropertyInfo.propertyValue;
						}
						else
						{
							star = Math.ceil(argPropertyInfo.propertyValue/(argItemInfo.template.freePropertyList[i].propertyValue / 9));
						}
						break;
					}
				}
				var color:int
				if(star < 0)
				{
					color = 0xfffccc;//lv
				}
				else
				{
					if(star > 9) star = 9;
					if(star < 4 )
						color = 0x00cc00;
					else if(star < 7)
						color = 0x00ccff;
					else if(star < 9)
						color = 0xcc00ff;
					else
						color = 0xff9900;
				}
				return color;
			}
			return 0xfffccc;
		}
		
		protected function getDefence(def:int,add:int = 0):String
		{
			if(def <= 0)return "";
			return LanguageManager.getWord("ssztl.common.defenseValue",def);
			
		}
		
		protected function getDurable(durable:int):String
		{
			if(durable <= 0)return "";
			return LanguageManager.getWord("ssztl.common.endureValue",durable);
		}
		
		private function getSellPrice(price:int):String
		{
			if(price <= 0)return "";
			return LanguageManager.getWord("ssztl.common.sellShopPriceValue",price);
			
		}
		
		private function getPrice(price:int):String
		{
			if(price <= 0)return "";
			return LanguageManager.getWord("ssztl.common.priceValue",price);
		}
		
		protected function getTextFormat(color:uint,align:String = null):TextFormat
		{
			return new TextFormat("SimSun",12,color,null,null,null,null,null,align,null,null,null,4);
		}
		
		protected function getTextFormatEx(color:uint,align:String = null):TextFormat
		{
			return new TextFormat("SimSun",14,color,null,null,null,null,null,align,null,null,null,4);
		}
		
		protected function getTextFormatExLeading(fonting:int,color:uint,align:String = null,leading:int=3 ):TextFormat
		{
			return new TextFormat("SimSun",fonting,color,null,null,null,null,null,align,null,null,null,leading);
		}
		
		override protected function clear():void
		{
			super.clear();
			if(_itemIcon)
			{
				if(this.contains(_itemIcon)) this.removeChild(_itemIcon);
				_itemIcon.dispose();
				_itemIcon = null;
			}
			
			if(_itemBitmap)
			{
				if(this.contains(_itemBitmap)) this.removeChild(_itemBitmap);
				_itemBitmap = null;
			}
			if (_qualityBg)
			{
				if (this.contains(_qualityBg)) this.removeChild(_qualityBg);
				_qualityBg = null;
			}
			
			if (_lineBg && _lineBg.length > 0)
			{
				for(var j:int = 0; j <_lineBg.length; j++)
				{
					var line:MCacheSplit2Line = _lineBg[j];
					if (this.contains(line)) this.removeChild(line);
					line = null;
				}
				_lineBg = [];
			}
			_text.y = OFFSET+4;
		}
		
		
		override public function dispose():void
		{
			if(_itemIcon)
			{
				if(this.contains(_itemIcon)) this.removeChild(_itemIcon);
				_itemIcon.dispose();
				_itemIcon = null;
			}
			
			if(_itemBitmap)
			{
				if(this.contains(_itemBitmap)) this.removeChild(_itemBitmap);
				_itemBitmap = null;
			}
			if (_qualityBg)
			{
				if (this.contains(_qualityBg)) this.removeChild(_qualityBg);
				_qualityBg = null;
			}
			
			if (_lineBg && _lineBg.length > 0)
			{
				for(var j:int = 0; j <_lineBg.length; j++)
				{
					var line:MCacheSplit2Line = _lineBg[j];
					if (this.contains(line)) this.removeChild(line);
					line = null;
				}
				_lineBg = [];
			}
			
			super.dispose();
		}
	}
}