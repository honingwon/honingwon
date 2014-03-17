package sszt.core.view.tips
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.PropertyType;
	import sszt.core.caches.ToolTipCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.furnace.CuiLianTemplateInfo;
	import sszt.core.data.furnace.CuiLianTemplateList;
	import sszt.core.data.furnace.StrengInfo;
	import sszt.core.data.furnace.StrengTemplateList;
	import sszt.core.data.furnace.StrengthenTemplateList;
	import sszt.core.data.item.ItemFreeProperty;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.PlaceCategoryTemaplteList;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.item.SuitNumberInfo;
	import sszt.core.data.item.SuitNumberList;
	import sszt.core.data.item.SuitTemplateInfo;
	import sszt.core.data.item.SuitTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.StringUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	
	public class ItemInfoTip extends ItemTemplateTip
	{
		private var _iteminfo:ItemInfo;
		private var _otheriteminfo:ItemInfo;
//		private var _enchaseList:Vector.<Bitmap>;
		private var _enchaseList:Array;
		private var _usingField:TextField;
		private var _isOther:Boolean;
		private var _otherList:Array;  //其他人的装备列表
		private var _wuHunIcon:Bitmap;
		private var _star:Bitmap;	//强化星星
		private var _star1:Bitmap;	//强化星星
		private var _starMask:Sprite;	//强化星星
		private var _isDress:Sprite;//是否装备
		private var _isDressIcon:Bitmap;
		private var _qualityBg:Bitmap;
		private var _riseIcon:Bitmap;//上升ICON
		private var _descendIcon:Bitmap;//下降ICON
		private var _lineBg:Array;  //线条背景
		private var _bingding:Bitmap;//绑定的ICON
		private var _itemIcon:BaseItemInfoCell;
		
		private var _strengExtraText:MAssetLabel;
		
		public function ItemInfoTip()
		{
//			_enchaseList = new Vector.<Bitmap>();
			_starMask = new Sprite;
			_enchaseList = [];
			_lineBg = new Array();  
			super();
		}
		
		//0xEC7E13		
		public function setItemInfo(iteminfo:ItemInfo,otheriteminfo:ItemInfo = null, price:int = 0,isUsing:Boolean = false,isOther:Boolean = false,otherList:Array = null):void
		{
			if(iteminfo == null)return;
			_iteminfo = iteminfo;
			_otheriteminfo = otheriteminfo;
			_isOther = isOther;
			_otherList = otherList;
			super.setItemTemplate(_iteminfo.template,otheriteminfo,price);
			//当前装备是否已经穿戴
			if(isUsing)addDressIcon();
		}
	
		override  protected function addItemIcon():void
		{
			if(_itemBitmap && this.contains(_itemBitmap) )
			{
				removeChild(_itemBitmap);
			}
			_itemBitmap = new Bitmap(CellCaches.getCellBg());
			_itemBitmap.x = 164;
			_itemBitmap.y = 8;
			addChild(_itemBitmap);
			
			if(_itemIcon && this.contains(_itemIcon) )
			{
				removeChild(_itemIcon);
			}
			
			_itemIcon = new BaseItemInfoCell();
			_itemIcon.itemInfo = _iteminfo;
			_itemIcon.x = 164;
			_itemIcon.y = 8;
			addChild(_itemIcon);
		}
		override protected function showBindFunction():void
		{			
			if (_bingding == null)
			{
				if(_iteminfo.isBind)//如果是绑定，那么显示绑定
				{
					_bingding = new Bitmap(ToolTipCaches.tipBindingAsset[2]);
				}
				else//如果是非绑或者装备绑定
				{
					if(_iteminfo.template.bindType == 0)//如果是装备后绑定
					{
						_bingding = new Bitmap(ToolTipCaches.tipBindingAsset[_iteminfo.template.bindType]);
					}
					else//如果是非绑
					{
						_bingding = new Bitmap(ToolTipCaches.tipBindingAsset[1]);
					}
				}
				_bingding.x = 141;
				_bingding.y = 53;
				addChild(_bingding);
			}
		}
		
		override protected function addScore():void
		{
			if (!CategoryType.isEquip(_iteminfo.template.categoryId)) return;
			
			if(_iteminfo && _iteminfo.score != 0)
			{
				addStringToField(LanguageManager.getWord("ssztl.common.fightValueEx") + _iteminfo.score.toString(),getTextFormat(0xff9900));
				var space:String = "";
				// 15 Space
				for(var i:int=0; i<15 - _iteminfo.score.toString().length; i++)
				{
					space += " ";
				}				
				if(_otheriteminfo)
				{
					if(_iteminfo.score > _otheriteminfo.score )
					{
						if (_riseIcon == null)
						{
							_riseIcon = new Bitmap(ToolTipCaches.tipRiseIconAsset);
							_riseIcon.x = 127;
							_riseIcon.y = 75;
							addChild(_riseIcon);
							
						}
//						var len:int = StringUtils.checkLen(LanguageManager.getWord("ssztl.common.fightValueEx") + _iteminfo.score.toString());
//						if (len < 12)addStringToField("\t\t\t  "+(_iteminfo.score -_otheriteminfo.score).toString(),getTextFormat(0x41D913),false);
//						else addStringToField("\t\t  "+(_iteminfo.score -_otheriteminfo.score).toString(),getTextFormat(0x41D913),false);
						addStringToField(space+(_iteminfo.score -_otheriteminfo.score).toString(),getTextFormat(0x41D913),false);
					}
					else if (_iteminfo.score < _otheriteminfo.score)
					{
						if (_descendIcon == null)
						{
							_descendIcon = new Bitmap(ToolTipCaches.tipDescendIconAsset);
							_descendIcon.x = 127;
							_descendIcon.y = 80;
							addChild(_descendIcon);
						}
//						var lenth:int = StringUtils.checkLen(LanguageManager.getWord("ssztl.common.fightValueEx") + _iteminfo.score.toString());
//						if (lenth < 12)addStringToField("\t\t\t  "+(Math.abs(_iteminfo.score -_otheriteminfo.score)).toString(),getTextFormat(0xFF0000),false);
//						else addStringToField("\t\t  "+(Math.abs(_iteminfo.score -_otheriteminfo.score)).toString(),getTextFormat(0xFF0000),false);
						addStringToField(space+(Math.abs(_iteminfo.score -_otheriteminfo.score)).toString(),getTextFormat(0xFF0000),false);
					}
				}
			}
		}
		
		override protected function addProperty():void
		{
			if (!CategoryType.isEquip(_iteminfo.template.categoryId)) return;
			//基础属性
			addStringToField(LanguageManager.getWord("ssztl.role.basicProperty"),getTextFormat(0xcea56a));
			//强化的百分比， 通过这个int(attack * add / 100)得到实际的强化值
			var add:int = StrengthenTemplateList.getStrengthenAddition(_iteminfo.strengthenLevel,_iteminfo.strengthenPerfect);
			
			if(_iteminfo.template.attack > 0)
			{
				/**装备自带攻击力**/
				addStringToField("　　"+getAttack(_iteminfo.template.attack,add),getTextFormat(0xFFFFFF));
			}
			if(_iteminfo.template.defense > 0)
			{
				addStringToField("　　"+getDefence(_iteminfo.template.defense,add),getTextFormat(0xFFFFFF));
			}
			
			/**固定属性**/
			for each(var j:PropertyInfo in _iteminfo.template.regularPropertyList)
			{
				addStringToField("　　"+getRegularProperty(j,add),getTextFormat(0xFFFFFF));
			}
			
			/*if(_iteminfo.strengthenLevel > 0)
			{
				if(tmpStrengInfo && tmpStrengInfo.propertyInfoList)
				{
					for(var o:int = 0;o<tmpStrengInfo.propertyInfoList.length;o++)
					{
						addStringToField(getStrengthProperty(tmpStrengInfo.propertyInfoList[o],_iteminfo),getTextFormat(0xE5E40D));
					}
				}
				if(CategoryType.getIsPurple(_iteminfo.template.quality) && tmpStrengInfo && tmpStrengInfo.purpleList)
				{
					for(o = 0;o< tmpStrengInfo.purpleList.length;o++)
					{
						addStringToField(getAdditionStrengthProperty(tmpStrengInfo.purpleList[o]),getTextFormat(CategoryType.getQualityColor(_iteminfo.template.quality)));
					}
				}
				if(CategoryType.getIsOrange(_iteminfo.template.quality) && tmpStrengInfo && tmpStrengInfo.orangeList)
				{
					for(o = 0;o< tmpStrengInfo.orangeList.length;o++)
					{
						addStringToField(getAdditionStrengthProperty(tmpStrengInfo.orangeList[o]),getTextFormat(CategoryType.getQualityColor(_iteminfo.template.quality)));
					}
				}
			}*/
			addWuHun();
			
			var freeList:Array = _iteminfo.freePropertyVector;
			
			//洗练附加属性
			if (_iteminfo.freePropertyVector.length > 0)
				addStringToField(LanguageManager.getWord("ssztl.role.refinedProperty"),getTextFormat(0xcea56a));
			
			for each(var m:ItemFreeProperty in _iteminfo.freePropertyVector)
			{
				if(m.lockState < ItemFreeProperty.UNLOCK_REBUILD)
					addStringToField("　　"+getRebuildProperty(m,_iteminfo),getTextFormat(getRebuildPropertyColor(m,_iteminfo)));
			}
			addLineBG();
			if(CategoryType.isCanEnchaseEquip(_iteminfo.template.categoryId))
			{
			//宝石属性
				addStringToField(LanguageManager.getWord("ssztl.role.gemstoneProperty"),getTextFormatExLeading(12,0xcea56a,null,9));
				var asset:Bitmap;
				var rect:Rectangle;
			
				for(var i:int = 1; i < 4; i++)
				{
					if(_iteminfo["enchase" + i] == 0)
					{
	//					addStringToField(" ",getTextFormatExLeading(0,0,null,9));
						rect = getCharBoundaries(_text.length - 1);
						asset = new Bitmap(ToolTipCaches.tipHoleOnAsset);
	//					asset.x = _text.x + rect.x + 3;
	//					asset.y = _text.y + rect.y - 2;
						asset.x = _text.x+2+24;
						asset.y = _text.textHeight+16;
						addChild(asset);
						_enchaseList.push(asset);
						addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.noEncharseStone"),getTextFormatExLeading(12,0x777164,null,9));
					}
					else if(_iteminfo["enchase" + i] > 0)
					{
						if(_iteminfo.template.categoryId == CategoryType.SHENMOLINE)
						{
							return;
						}
	//					addStringToField(" ",getTextFormatExLeading(0,0,null,9));
						rect = getCharBoundaries(_text.length - 1);
						//rect = getCharBoundaries(33);
						//宝石框ICON
						asset = new Bitmap(getStonePath(ItemTemplateList.getTemplate(_iteminfo["enchase" + i]).categoryId));
	//					asset.x = _text.x + rect.x + 3;
	//					asset.y = _text.y + rect.y - 2;
						asset.x = _text.x+2+24;
						asset.y = _text.textHeight+16;
						addChild(asset);
						_enchaseList.push(asset);
						addStringToField("　　　　" + getEnchase(_iteminfo["enchase" + i]),getTextFormatExLeading(12,0xa85af0,null,9));
					}
				}
				addSevenHole();
				addEightHole();
				addTenHole();
				addLineBG(5);
			}
		}
		
		private function addWuHun():void
		{
			if(CategoryType.getIsOrange(_iteminfo.template.quality) && CategoryType.isWuHun(_iteminfo.template.categoryId))
			{
				if(_iteminfo.strengthenLevel >= 10)
				{
					var wuhunTemplate:CuiLianTemplateInfo;
					if(_iteminfo.wuHunId > 0)
					{
						wuhunTemplate = CuiLianTemplateList.getCuiLianTemplateInfo(_iteminfo.wuHunId);
					}else
					{
						var place:int = PlaceCategoryTemaplteList.categoryToPlace(_iteminfo.template.categoryId);
						wuhunTemplate =  CuiLianTemplateList.getCuiLianByCategoryId(place,1);
					}
					if(wuhunTemplate)
					{
						_wuHunIcon = new Bitmap();
						_wuHunIcon.x = 160;
						_wuHunIcon.y = 50;
						addChild(_wuHunIcon);
						_wuHunIcon.bitmapData = AssetUtil.getAsset(CategoryType.getAssetNameByCategory(_iteminfo.template.categoryId)) as BitmapData;
						//					addStringToField("[武魂]" + wuhunTemplate.name,getTextFormat(0xff0000));
						addStringToField(LanguageManager.getWord("ssztl.common.WuHunTip") + wuhunTemplate.name,getTextFormat(0xff0000));
						addStringToField(wuhunTemplate.description,getTextFormat(0xff0000));
					}
				}else
				{
					if(_iteminfo.wuHunId > 0)
					{
						wuhunTemplate = CuiLianTemplateList.getCuiLianTemplateInfo(_iteminfo.wuHunId);
					}
					if(wuhunTemplate)
					{
						_wuHunIcon = new Bitmap();
						_wuHunIcon.x = 160;
						_wuHunIcon.y = 50;
						addChild(_wuHunIcon);
						_wuHunIcon.bitmapData = AssetUtil.getAsset(CategoryType.getAssetNameByCategory(_iteminfo.template.categoryId)) as BitmapData;
						addStringToField(LanguageManager.getWord("ssztl.common.WuHunTip") + wuhunTemplate.name,getTextFormat(0x939393));
						addStringToField(wuhunTemplate.description,getTextFormat(0x939393));
					}
				}
			}
		}
		
		private function getAdditionStrengthProperty(property:PropertyInfo):String
		{
			var result:String = "";
//			result = result + "[强化+" + _iteminfo.strengthenLevel + "奖励]";
			result = result + LanguageManager.getWord("ssztl.common.strengthAward",_iteminfo.strengthenLevel);
			result = result + PropertyType.getName(property.propertyId);
			result = result + "+" + property.propertyValue/100 + "%";
			return result;
		}
		
		//强6孔
		private function addSevenHole():void
		{
			if(!_iteminfo.template.canEnchase) return;
			
			var asset:Bitmap = new Bitmap();
			asset.x = _text.x+26;
			asset.y = _text.textHeight+16;
			addChild(asset);
			_enchaseList.push(asset);
			
			if(_iteminfo["enchase4"] > 0)	//已镶嵌
			{
				
				asset.bitmapData = getStonePath(ItemTemplateList.getTemplate(_iteminfo["enchase4"]).categoryId);
				addStringToField("　　　　" + getEnchase(_iteminfo["enchase4"]),getTextFormatExLeading(12,0xa85af0,null,9));
			}else
			{
				if(_iteminfo.strengthenLevel >= 6)	//未镶嵌
				{
					asset.bitmapData = ToolTipCaches.tipHoleOnAsset;
					addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.strength6Hole"),getTextFormatExLeading(12,0x777164,null,9));
				}else								//未开启
				{
					asset.bitmapData = ToolTipCaches.tipHoleOffAsset;
					addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.strength6HoleOff"),getTextFormatExLeading(12,0xcc0000,null,9));
				}
			}
		}
		//强8孔
		private function addEightHole():void
		{
			if(!_iteminfo.template.canEnchase) return;
			
			var asset:Bitmap = new Bitmap();
			asset.x = _text.x+26;
			asset.y = _text.textHeight+16;
			addChild(asset);
			_enchaseList.push(asset);
			
			if(_iteminfo["enchase5"] > 0)	//已镶嵌
			{
				
				asset.bitmapData = getStonePath(ItemTemplateList.getTemplate(_iteminfo["enchase5"]).categoryId);
				addStringToField("　　　　" + getEnchase(_iteminfo["enchase5"]),getTextFormatExLeading(12,0xa85af0,null,9));
			}else
			{
				if(_iteminfo.strengthenLevel >= 8)	//未镶嵌 	cea56a
				{
					asset.bitmapData = ToolTipCaches.tipHoleOnAsset;
					addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.strength8Hole"),getTextFormatExLeading(12,0x777164,null,9));
				}else								//未开启
				{
					asset.bitmapData = ToolTipCaches.tipHoleOffAsset;
					addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.strength8HoleOff"),getTextFormatExLeading(12,0xcc0000,null,9));
				}
			}
			
			
		}
		
		//强10孔
		private function addTenHole():void
		{
			if(!_iteminfo.template.canEnchase) return;
			var asset:Bitmap = new Bitmap();
			asset.x = _text.x+26;
			asset.y = _text.textHeight+16;
			addChild(asset);
			_enchaseList.push(asset);
			
			if(_iteminfo["enchase6"] > 0)	//已镶嵌
			{
				
				asset.bitmapData = getStonePath(ItemTemplateList.getTemplate(_iteminfo["enchase6"]).categoryId);
				addStringToField("　　　　" + getEnchase(_iteminfo["enchase6"]),getTextFormatExLeading(12,0xa85af0,null,9));
			}else
			{
				if(_iteminfo.strengthenLevel >= 10)	//未镶嵌
				{
					asset.bitmapData = ToolTipCaches.tipHoleOnAsset;
					addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.strength10Hole"),getTextFormatExLeading(12,0x777164,null,9));
				}else								//未开启
				{
					asset.bitmapData = ToolTipCaches.tipHoleOffAsset;
					addStringToField("　　　　"+LanguageManager.getWord("ssztl.common.strength10HoleOff"),getTextFormatExLeading(12,0xcc0000,null,9));
				}
			}
		}
		
		override protected function addSuitProperty():void
		{
			if(_iteminfo.template.suitId > 0)
			{
				var suitNumberInfo:SuitNumberInfo = SuitNumberList.getSuitNumberInfo(_iteminfo.template.suitId);
				var list:Array;
				if(!_isOther) list = GlobalData.bagInfo.getSuitList(suitNumberInfo);
				else list = getSuitList(suitNumberInfo);
				addStringToField(suitNumberInfo.suitName + "(" + list.length + "/"+ suitNumberInfo.itemNum +")",getTextFormat(0xffcc00));
				
				getSuitComponent(suitNumberInfo.clothId);
				addStringToField(".",getTextFormat(0xcea56a),false);
				getSuitComponent(suitNumberInfo.armetId,false);
				addStringToField(".",getTextFormat(0xcea56a),false);
				getSuitComponent(suitNumberInfo.cuffId,false);
				if (suitNumberInfo.itemNum > 3)
				{
					addStringToField(".",getTextFormat(0xcea56a),false);
					getSuitComponent(suitNumberInfo.shoesId,false);
					addStringToField(".",getTextFormat(0xcea56a),false);
					getSuitComponent(suitNumberInfo.caestusId,false);
					addStringToField(".",getTextFormat(0xcea56a),false);
					getSuitComponent(suitNumberInfo.necklaceId,false);
					
				}				
				var list2:Array = SuitTemplateList.getSuitTemplateList(_iteminfo.template.suitId);
				for each(var i:SuitTemplateInfo in list2)
				{
					if(list.length >= i.count)
					{
						addStringToField(getSuitProperty(i),getTextFormat(0xa85af0));
					}else
					{
						addStringToField(getSuitProperty(i),getTextFormat(0x777164));
					}
				}
				addLineBG();
			}
		}
			
		override protected function getSuitComponent(id:int, wrap:Boolean=true):void
		{
			if(_isOther)
			{
				if(hasSuitComponent(id))
				{
					addStringToField(CategoryType.getNameByTypeTwo(ItemTemplateList.getTemplate(id).categoryId),getTextFormat(0xffcc00),wrap);
				}else
				{
					addStringToField(CategoryType.getNameByTypeTwo(ItemTemplateList.getTemplate(id).categoryId),getTextFormat(0x777164),wrap);
				}
			}else
			{
				if(GlobalData.bagInfo.hasSuitComponet(id))
				{
					addStringToField(CategoryType.getNameByTypeTwo(ItemTemplateList.getTemplate(id).categoryId),getTextFormat(0xffcc00),wrap);
				}else
				{
					addStringToField(CategoryType.getNameByTypeTwo(ItemTemplateList.getTemplate(id).categoryId),getTextFormat(0x777164),wrap);
				}
			}
		}
		
		private function hasSuitComponent(id:int):Boolean
		{
			for(var i:int = 0;i<_otherList.length;i++)
			{
				if(_otherList[i])
				{
					if(_otherList[i].template.templateId == id)
						return true;
				}
			}
			return false;
		}
		
		private function getSuitList(suitNumberInfo:SuitNumberInfo):Array
		{
			var list:Array = [];
			if(_otherList)
			{
				for(var i:int = 0;i<_otherList.length;i++)
				{
					if(_otherList[i])
					{
						if(_otherList[i].template.templateId == suitNumberInfo.clothId || _otherList[i].template.templateId == suitNumberInfo.armetId || 
							_otherList[i].template.templateId == suitNumberInfo.cuffId || _otherList[i].template.templateId == suitNumberInfo.shoesId || 
							_otherList[i].template.templateId == suitNumberInfo.caestusId || _otherList[i].template.templateId == suitNumberInfo.necklaceId)
							list.push(_otherList[i].template.templateId);
					}
				}
			}
			return list;
		}
		
		private function getCharBoundaries(index:int):Rectangle
		{
			var result:Rectangle = _text.getCharBoundaries(index);
			if(!result)
			{
				var n:int = _text.getLineIndexOfChar(index);
				if(_text.bottomScrollV < n)
				{
					var t:int = _text.scrollV;
					_text.scrollV = n;
					result = _text.getCharBoundaries(index);
					_text.scrollV = t;
				}
			}
			return result;
		}
		
		private function getEnchase(templateId:int):String
		{
			var template:ItemTemplateInfo = ItemTemplateList.getTemplate(templateId);
			var name:String = PropertyType.getName(template.property1);
//			var ls:Array = ["","⑴","⑵","⑶","⑷","⑸","⑹","⑺","⑻","⑼","⑽"];
//			var ls:Array = ["","①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩"];
			return "("+template.property3 + ") " + name + " +" + template.property2;
		}
		
		private function getStonePath(categoryId:int):BitmapData
		{
			switch(categoryId)
			{
				case CategoryType.ENCHASEATTACK: 
					return AssetUtil.getAsset("ssztui.common.GongJiStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEDEFENSE: 
					return AssetUtil.getAsset("ssztui.common.FangYuStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEMUMPHURT: 
					return AssetUtil.getAsset("ssztui.common.WaiGongStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEMUMPDEFENSE: 
					return AssetUtil.getAsset("ssztui.common.WaiFangStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEMAGICHURT: 
					return AssetUtil.getAsset("ssztui.common.NeiGongStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEMAGICDEFENSE: 
					return AssetUtil.getAsset("ssztui.common.NeiFangStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEFARHURT: 
					return AssetUtil.getAsset("ssztui.common.YuanGongStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEFARDEFENSE: 
					return AssetUtil.getAsset("ssztui.common.YuanFangStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEHITTARGET: 
					return AssetUtil.getAsset("ssztui.common.MinZhongStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEDUCK: 
					return AssetUtil.getAsset("ssztui.common.ShanBiStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEDELIGENCY: 
					return AssetUtil.getAsset("ssztui.common.JianRenStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASEPOWERHIT: 
					return AssetUtil.getAsset("ssztui.common.BaoJiStoneAsset",BitmapData) as BitmapData;
				case CategoryType.ENCHASERED: 
					return AssetUtil.getAsset("ssztui.common.ShengMinStoneAsset",BitmapData) as BitmapData;
			}
			return null;
		}
		
		override protected function addTipsName():void
		{
			addStringToField(getName(_iteminfo.template.name),getTextFormatExLeading(14,CategoryType.getQualityColor(_iteminfo.template.quality),null,11),false);
		}
		
		override protected function getName(name:String):String
		{
			if(_iteminfo.strengthenLevel > 0)return name + "(+" + _iteminfo.strengthenLevel + ")";
			return name;
		}
		
		override protected function getBindType(type:int):String
		{
//			if(_iteminfo.isBind)return "已绑定";
			if(_iteminfo.isBind)return LanguageManager.getWord("ssztl.common.binded");
			else
				return super.getBindType(type);
		}
		
		override protected function getDurable(durable:int):String
		{
			if(durable <= 0)return "";
//			return "耐久：" + _iteminfo.durable + "/" + durable;
			return LanguageManager.getWord("ssztl.common.endureValue",_iteminfo.durable + "/" + durable);
			
		}
		
		override protected function addStar():void
		{
			
			if (!CategoryType.isEquip(_iteminfo.template.categoryId))
				return;
			/*
			_star = new Bitmap(ToolTipCaches.tipStarAsset);
			_star.x = 8;
			_star.y = 31;
			addChild(_star);
			_star1 = new Bitmap(ToolTipCaches.tipStarAsset1);
			_star1.x = 8;
			_star1.y = 31;
			addChild(_star1);
			
			_star1.mask = _starMask;
			_starMask.x = 8;
			_starMask.y = 31;
			addChild(_starMask);
			
			_starMask.graphics.clear();
			_starMask.graphics.beginFill(0,0);
			_starMask.graphics.drawRect(0,0,15*_iteminfo.strengthenLevel,15);
			_starMask.graphics.endFill();
			_starMask.mouseEnabled = false;
			_starMask.mouseChildren = true;
			
			addStringToField("\n\t\t",getTextFormat(0),false);
			*/
			var str:String = LanguageManager.getWord("ssztl.furnace.perfectDegree") + _iteminfo.strengthenPerfect + "%";
			addStringToField(str,getTextFormat(0xfffccc));
		}
		
		override protected function addDressIcon():void
		{
			if (!CategoryType.isEquip(this._iteminfo.template.categoryId))
				return;
			
			if (this._iteminfo.place > 30)
				return;
				
			if (GlobalData.bagInfo._itemList.indexOf(this._iteminfo) != -1)
			{
				if (this._isDressIcon == null)
				{
					this._isDressIcon = new Bitmap(ToolTipCaches.tipWidgetFitAsset);
					this._isDressIcon.x = 100;
					this._isDressIcon.y = 45;
					addChild(this._isDressIcon);
				}
			}
		}
		
		override protected function addQuilayBg():void
		{
			if (!_iteminfo.template || _iteminfo.template.quality == 0)
				return;
			
			if( _qualityBg == null )
			{
				_qualityBg = new Bitmap(ToolTipCaches.toolTipBgCache[this._iteminfo.template.quality]);
				_qualityBg.x = _qualityBg.y = 3;
				addChild(_qualityBg);
			}
		}
		
		/*
		override protected function addLineBG():void
		{
			var line:MCacheSplit2Line = new MCacheSplit2Line()
			line.x = 0;
			line.y = _text.textHeight+19;
			addChild(line);
			_lineBg.push(line);
			addStringToField("\n",getTextFormat(0),false);
		}
		*/
		
		override protected function getAttack(attack:int,add:int = 0):String
		{
			if(attack <= 0 )return "";
			if (int(attack * add / 100) <= 0)
				return LanguageManager.getWord("ssztl.common.attackValue", attack);
		
			return LanguageManager.getWord("ssztl.common.attackValue", attack + setRgProperty(attack,add,StringUtils.checkLen(LanguageManager.getWord("ssztl.common.attackValue", attack))));
			
		}
		
		override protected function getDefence(def:int,add:int = 0):String
		{
			if(def <= 0)return "";
			if (int(def * add / 100) <= 0)
				return LanguageManager.getWord("ssztl.common.defenseValue",def);

			return LanguageManager.getWord("ssztl.common.defenseValue", def + setRgProperty(def,add,StringUtils.checkLen(LanguageManager.getWord("ssztl.common.defenseValue",def))));
		}
		
		override protected function getRegularProperty(argPropertyInfo:PropertyInfo, add:int=0):String
		{
			if(argPropertyInfo)
			{
				
				var name:String = PropertyType.getName(argPropertyInfo.propertyId);
				var content:String = "";
				if(argPropertyInfo.propertyPercent != -1)
				{
					
					content = name + " +" + (argPropertyInfo.propertyValue/100) + "%" + setRgProperty((argPropertyInfo.propertyValue/100),add,StringUtils.checkLen(name + " +" + (argPropertyInfo.propertyValue/100) + "%"));
					
				}
				else
				{
					content = name + " +" +argPropertyInfo.propertyValue + setRgProperty(argPropertyInfo.propertyValue,add,StringUtils.checkLen(name + " +" + (argPropertyInfo.propertyValue/100) + "%"));
				}
				return content;
			}
			return "";
		}
		
		protected function setRgProperty(data:int,add:int ,len:int):String
		{
			var value:int = int(data * add / 100);
			if (value <= 0)return "";
			
			if(!_strengExtraText)
			{
				_strengExtraText = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				_strengExtraText.setLabelType([new TextFormat("SimSun",12,0x33ff00,null,null,null,null,null,null,null,null,null,4)]);
				_strengExtraText.move(120,_text.textHeight+14);
				addChild(_strengExtraText);
			}
			
			_strengExtraText.appendText(LanguageManager.getWord("ssztl.common.strengthData",value.toString()) + "\n");
			
			var content_str:String = "";
//			if(len < 8) content_str = content_str +  "\t\t\t<font color='#33ff00'>"+LanguageManager.getWord("ssztl.common.strengthData",value.toString())+"</font>";
//			else if(len < 12) content_str = content_str + "\t\t<font color='#33ff00'>"+LanguageManager.getWord("ssztl.common.strengthData",value.toString())+"</font>";
//			else content_str = content_str + "\t<font color='#33ff00'>"+LanguageManager.getWord("ssztl.common.strengthData",value.toString())+"</font>";
			return content_str;
		}
		
		override protected function clear():void
		{
			super.clear();
			if(_star)
			{
				if(this.contains(_star)) this.removeChild(_star);
				_star = null;
			}
			if(_star1)
			{
				if(this.contains(_star1)) this.removeChild(_star1);
				_star1 = null;
			}
			if(_starMask)
			{
				if(this.contains(_starMask)) this.removeChild(_starMask);
			}
			
			if(_bingding)
			{
				if(this.contains(_bingding)) this.removeChild(_bingding);
				_bingding = null;
			}
			
			if (_isDressIcon)
			{
				if (this.contains(_isDressIcon)) this.removeChild(_isDressIcon);
				_isDressIcon = null;
			}
			
			if (_qualityBg)
			{
				if (this.contains(_qualityBg)) this.removeChild(_qualityBg);
				_qualityBg = null;
			}
		
			if (_riseIcon)
			{
				if (this.contains(_riseIcon)) this.removeChild(_riseIcon);
				_riseIcon = null;
			}
			
			if (_descendIcon)
			{
				if (this.contains(_descendIcon)) this.removeChild(_descendIcon);
				_descendIcon = null;
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
			if(_strengExtraText)
			{
				if(this.contains(_strengExtraText)) this.removeChild(_strengExtraText);
				_strengExtraText = null;
			}
			
			for(var i:int = 0; i < _enchaseList.length; i++)
			{
				if(_enchaseList[i] && _enchaseList[i].parent)
					_enchaseList[i].parent.removeChild(_enchaseList[i]);
			}
			if(_usingField && _usingField.parent)
				_usingField.parent.removeChild(_usingField);
			if(_wuHunIcon && _wuHunIcon.parent)
			{
				_wuHunIcon.parent.removeChild(_wuHunIcon);
				_wuHunIcon = null;
			}
		}
		
		
		override public function dispose():void
		{
			if(_itemIcon)
			{
				if(this.contains(_itemIcon)) this.removeChild(_itemIcon);
				_itemIcon.dispose();
				_itemIcon = null;
			}
			if(_star)
			{
				if(this.contains(_star)) this.removeChild(_star);
				_star = null;
			}
			if(_star1)
			{
				if(this.contains(_star1)) this.removeChild(_star1);
				_star1 = null;
			}
			if(_starMask)
			{
				if(this.contains(_starMask)) this.removeChild(_starMask);
			}
			
			if(_bingding)
			{
				if(this.contains(_bingding)) this.removeChild(_bingding);
				_bingding = null;
			}
			
			if (_isDressIcon)
			{
				if (this.contains(_isDressIcon)) this.removeChild(_isDressIcon);
				_isDressIcon = null;
			}
			
			if (_qualityBg)
			{
				if (this.contains(_qualityBg)) this.removeChild(_qualityBg);
				_qualityBg = null;
			}
			if (_riseIcon)
			{
				if (this.contains(_riseIcon)) this.removeChild(_riseIcon);
				_riseIcon = null;
			}
			if(_strengExtraText)
			{
				if(this.contains(_strengExtraText)) this.removeChild(_strengExtraText);
				_strengExtraText = null;
			}
			
			if (_descendIcon)
			{
				if (this.contains(_descendIcon)) this.removeChild(_descendIcon);
				_descendIcon = null;
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