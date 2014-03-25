package sszt.core.data.bag
{
	import flash.events.EventDispatcher;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.PlaceCategoryTemaplteList;
	import sszt.core.data.item.SuitNumberInfo;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.betterEquip.BetterEquipPanel;
	import sszt.core.view.getAndUse.GetAndUseCell;
	import sszt.core.view.getAndUse.GetAndUseEquipPanel;
	import sszt.core.view.getAndUse.GetAndUsePanel;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class BagInfo extends EventDispatcher
	{
		public static const BAG_MAX_SIZE:int=108;
		public static const EQUIP_SIZE:int = 30;
		public var pageSize:int = 36;
		private var _currentSize:int = 0;              
//      public var _itemList:Vector.<ItemInfo>;
		public var _itemList:Array;
		/**
		 * 当前拖动对象，翻页时需要记录
		 */		
		public var currentDrag:ItemInfo;
		
		/**
		 *构造函数 
		 * @param size
		 * 
		 */		
		public function BagInfo(size:int = 36)
		{
			super();
//			_itemList=new Vector.<ItemInfo>(BAG_MAX_SIZE+EQUIP_SIZE);
			_itemList = new Array(BAG_MAX_SIZE+EQUIP_SIZE);
		}
		
		/**
		 * 初始化列表
		 * @param items
		 * 
		 */		
//		public function initList(items:Vector.<ItemInfo>):void
		public function initList(items:Array):void
		{  
//			var tempList:Vector.<ItemInfo>=items.slice(0);
			var tempList:Array = items.slice(0);
			_itemList=tempList;
		} 
		
		/**
		 * 增加物品
		 * @param item
		 * @param type
		 * 
		 */		
		public function addItem(item:ItemInfo):void
		{           
			if(_itemList.indexOf(item) == -1)
			{
				_itemList[item.place]=item;
			}
		    dispatchEvent(new BagInfoUpdateEvent(BagInfoUpdateEvent.ITEM_UPDATE ,[item.place]));
		}
		
		/**
		 * 根据位置删除物品
		 * @param place
		 * @param type
		 * 
		 */		
		public function removeItem(place:int):void
		{                    
			if(place < 0||place >= _itemList.length) return;
			_itemList[place] = null;	
		    dispatchEvent(new BagInfoUpdateEvent(BagInfoUpdateEvent.ITEM_UPDATE,[place]));
		}
		
		/**
		 *获取背包第一个空位置 
		 * @return 
		 * 
		 */		
		public function getEmptyPlace():int
		{
			for(var i:int = 30;i<GlobalData.selfPlayer.bagMaxCount + 30;i++)
			{
				if(_itemList[i] == null)
					return i;
			}
			return -1;
		}
		
		/**
		 * 根据在背包中的位置检索物品
		 * @param location
		 * @param type
		 * @return 
		 * 
		 */		
		public function getItem(place:int):ItemInfo         
		{
			if(place < 0||place >= _itemList.length) return null;
			return _itemList[place];
		}
		
		/**
		 * 通过主键Id检索物品
		 * @param argItemId
		 * @return ItemInfo
		 * 
		 */		
		public function getItemByItemId(argItemId:Number):ItemInfo
		{
			for(var i:int = 30;i <_itemList.length;i++)
			{
				if(_itemList[i] && _itemList[i].itemId == argItemId)
				{
					return _itemList[i];
				}
			}
			return null;
		}
		/**通过模版编号获取首个物品信息 **/
		public function getItemByTemplateId(templateId:int, isBind:Boolean):ItemInfo
		{
			var temp:ItemInfo;
			for(var i:int = 0;i <_itemList.length;i++)
			{
				if(_itemList[i] && _itemList[i].templateId == templateId)
				{
					if(_itemList[i].isBind == isBind)
						return _itemList[i];
					else
						temp = _itemList[i];
				}
			}
			return temp;
		}
		/**通过模版编号获取物品信息 **/
		public function getItemByTemplateId2(templateId:int):ItemInfo
		{
			var temp:ItemInfo;
			for(var i:int = 0;i <_itemList.length;i++)
			{
				if(_itemList[i] && _itemList[i].templateId == templateId)
				{
						temp = _itemList[i];
				}
			}
			if(temp==null)
			{
				temp = new ItemInfo();
				temp.count = 0;
				temp.itemId = 206088;
//				temp.template.picPath = "206088";
				
			}
			return temp;
		}
		
		/**
		 * 更具模板id 获得该物品的总数量 
		 * @param templateId 模板id
		 * @return 
		 * 
		 */		
		public function getItemCountByItemplateId(templateId:int):int
		{
			var count:int = 0;
			for(var i:int = 0;i <_itemList.length;i++)
			{
				if(_itemList[i] && _itemList[i].templateId == templateId)
				{
					count += _itemList[i].count;
				}
			}
			return count;
		}
		
		public function getAllItemByItemId(argItemId:Number):ItemInfo
		{
			for(var i:int = 0;i <_itemList.length;i++)
			{
				if(_itemList[i] && _itemList[i].itemId == argItemId)
				{
					return _itemList[i];
				}
			}
			return null;
		}
		public function addItemEvetList(item:ItemInfo):void
		{
			var oldNum:int = 0;
			if(_itemList[item.place])
			{
				oldNum = _itemList[item.place].count;
			}
			if(item.count > oldNum)
			{
				var message:String = LanguageManager.getWord("ssztl.common.gainItem",item.template.name, item.count - oldNum);
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
			}
		}
		
//		public function updateItems(list:Vector.<ItemInfo>):void
		public function updateItems(list:Array):void
		{
//			var updates:Vector.<int> = new Vector.<int>();
			var updates:Array = [];
//			var updateItemIds:Vector.<Number> = new Vector.<Number>();
			var updateItemIds:Array = [];
//			var equipUpdates:Vector.<int> = new Vector.<int>();
			var equipUpdates:Array = [];
			var tmpItemId:Number;
			for each(var i:ItemInfo in list)
			{
				if(!i.isExist)
				{
					if(_itemList[i.place])
					{
						//失去的物品为最高等级的新手礼包，则移除新手礼包topIcon
						if(CategoryType.isHighestLevelNewcomeGift( ItemInfo(_itemList[i.place]).templateId) )
						{
							ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.REMOVE_NEWCOMER_GIFT_ICON));
						}
						tmpItemId = _itemList[i.place].itemId;
						_itemList[i.place] = null;
					}
				}
				else
				{
					if(_itemList[i.place])
					{
						tmpItemId = _itemList[i.place].itemId;
					}
					else
					{
						tmpItemId = i.itemId;
					}
					var newcomeGift:int = CategoryType.isNewcomeGift(i.templateId);
					if(newcomeGift > 0)
					{
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NEWCOMER_GIFT_ICON,newcomeGift));
					}
					_itemList[i.place] = i;
					//更新特殊孔
					_itemList[i.place].updateSpecialHole();
					_itemList[i.place].updateInfo();
//					tmpItemId = _itemList[i.place].itemId
				}
				if(i.place < 30)
				{
					equipUpdates.push(i.place);
					updateItemIds.push(tmpItemId);
				}
				else
				{
					updateItemIds.push(tmpItemId);
					updates.push(i.place);
					GlobalData.taskInfo.updateCollectTask();
				}
//				getAndUseEquip(i);
			}
			if(updates.length > 0)dispatchEvent(new BagInfoUpdateEvent(BagInfoUpdateEvent.ITEM_UPDATE,updates));
			if(updateItemIds.length > 0)dispatchEvent(new BagInfoUpdateEvent(BagInfoUpdateEvent.ITEM_ID_UPDATE,updateItemIds));
			if(equipUpdates.length > 0)dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.EQUIPUPDATE,equipUpdates));
			
			var getAndUsePanel:GetAndUsePanel = GetAndUsePanel.getInstance();
			if ((GlobalData.selfPlayer.level >= 30 && GlobalData.selfPlayer.level <= 40) || getItemByTemplateId(274001,false) || getItemByTemplateId(274002,false))
			{
				if( !getAndUsePanel.parent || (getAndUsePanel.parent && !CategoryType.isEquip(getAndUsePanel.info.categoryId)))
				{
					checkBetterEquip();
				}
			}
		}
		public function checkBetterEquip() : void
		{
			var argItem:ItemInfo;
			var j:int;
			var tmpItem:ItemInfo;
			var k:int;
			var argPlace:int;
			var len:int = (EQUIP_SIZE + GlobalData.selfPlayer.bagMaxCount);
			var result:Array = [];
			var i:int;
			while (i < 14) {
				if (this._itemList[i])
				{
					j = 30;
					while (j < len) {
						if (this._itemList[j] && this._itemList[i].template.categoryId == this._itemList[j].template.categoryId && this._itemList[j].getCanUse())
						{
							if (this._itemList[i].template.quality < this._itemList[j].template.quality)
							{
								if (this._itemList[j].template.needLevel <= GlobalData.selfPlayer.level)
								{
									result.push(this._itemList[j]);
								}
							} 
							else 
							{
								if (this._itemList[i].template.quality == this._itemList[j].template.quality)
								{
									if (this._itemList[i].template.needLevel < this._itemList[j].template.needLevel && this._itemList[j].template.needLevel <= GlobalData.selfPlayer.level && !CategoryType.isPetEquip(this._itemList[j].template.categoryId))
									{
										result.push(this._itemList[j]);
									}
								}
							}
						}
						j++;
					}
				}
				else 
				{
					k = 30;
					while (k < len) {
						argItem = this._itemList[k];
						if (argItem){
							argPlace = PlaceCategoryTemaplteList.categoryToPlace(argItem.template.categoryId);
							if (argItem && argPlace == i && argItem.getCanUse())
							{
								if (!tmpItem || compareEquip(tmpItem.template, argItem.template) == 2){
									tmpItem = argItem;
								}
							}
						}
						k++;
					}
					if (tmpItem && !CategoryType.isPetEquip(tmpItem.template.categoryId)){
						result.push(tmpItem);
						tmpItem = null;
					}
				}
				i++;
			}
			if (result.length > 0 && BetterEquipPanel.getInstance().parent == null)
			{
				BetterEquipPanel.getInstance().show(result);
			}
		}
		
		private function compareEquip(equip1:ItemTemplateInfo, equip2:ItemTemplateInfo):int{
			if (equip1.quality < equip2.quality){
				return 2;
			}
			if (equip1.quality == equip2.quality){
				if (equip1.needLevel < equip2.needLevel){
					return 2;
				}
			}
			return 1;
		}
		
		/**
		 * 返回特定类型的物品
		 * @param pageIndex
		 * @param type
		 * @return 
		 * 
		 */		
//		public function getListByType(type:Vector.<int>,pageIndex:int = 0,hasPage:Boolean = true):Vector.<ItemInfo>
		public function getListByType(type:Array,pageIndex:int = 0,hasPage:Boolean = true):Array
		{
//			var result:Vector.<ItemInfo>;
			var result:Array;
			if(type == CategoryType.ALL_TYPES)result = _itemList;
			else
			{
//				result = new Vector.<ItemInfo>();
				result = [];
				for(var i:int = 30;i<_itemList.length;i++)
				{
					if(_itemList[i]&&(type.indexOf(_itemList[i].template.categoryId)+1))
					{
						result.push(_itemList[i]);
					}
				}	
			}
			if(hasPage)
			{
				return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);
			}
			else
			{
				return result;
			}
		}
		/**
		 * 根据回调条件索引装备(可强化0，可重铸1....)
		 * @return Vector.<ItemInfo>
		 * 
		 */		
//		public function getEquipByFunction(argFunction:Function):Vector.<ItemInfo>
		public function getEquipByFunction(argFunction:Function):Array
		{
//			var tmpResult:Vector.<ItemInfo> = new Vector.<ItemInfo>();
			var tmpResult:Array = [];
			for(var i:int = 30;i < _itemList.length;i++)
			{
					if(_itemList[i] && argFunction(_itemList[i]))
					{
						tmpResult.push(_itemList[i]);
					}
			}
			return tmpResult;
		}
		//
		public function getItemListByCategoryId(Id:int):Array
		{
			var tmpResult:Array = [];
			for(var i:int = 30;i < _itemList.length;i++)
			{
				if(_itemList[i].template.categoryId == Id)
				{
					tmpResult.push(_itemList[i]);
				}
			}
			return tmpResult;			
		}
		//返回穿戴在身上的装备
		public function getWearEquipByFunction(argFunction:Function):Array
		{
			var tmpResult:Array = [];
			for(var i:int = 0;i < 30;i++)
			{
				if(_itemList[i] && argFunction(_itemList[i]))
				{
					tmpResult.push(_itemList[i]);
				}
			}
			return tmpResult;
		}
		
//		public function getItemById(id:int):Vector.<ItemInfo>
		public function getItemById(id:int):Array
		{
//			var result:Vector.<ItemInfo> = new Vector.<ItemInfo>();
			var result:Array = [];
			for each(var i:ItemInfo in _itemList)
			{
				if(i && i.templateId == id)
				{
					result.push(i);
				}
			}
			return result;
		}
		public function getItemCountById(id:int):int
		{
//			var list:Vector.<ItemInfo> = getItemById(id);
			var list:Array = getItemById(id);
			var result:int = 0;
			for each(var i:ItemInfo in list)
			{
				result += i.count;
			}
			return result;
		}
		
		public function hasBindItem(argTemplate:int):Boolean
		{
			var list:Array = getItemById(argTemplate);
			for each(var i:ItemInfo in list)
			{
				if(i.isBind)return true;
			}
			return false;
		}
		
		/**
		 * 扩展背包容量
		 * 
		 */		
		public function extendBagSize(type:int):void
		{
			dispatchEvent(new BagInfoUpdateEvent(BagInfoUpdateEvent.BAG_EXTEND,type));
		}
		
		/**
		 *获取当前背包容量 
		 * @return 
		 * 
		 */		
		public function get currentSize():int
		{
			_currentSize = 0;
			for(var i:int = 30;i<_itemList.length;i++)
			{
				if(_itemList[i])
				{
					_currentSize++;
				}
			}
			return _currentSize;
		}
	
		public function set currentSize(size:int):void
		{
		   _currentSize=size;
		}
		/**
		 * 是否有位置
		 * @param count
		 * @return 
		 * 
		 */		
		public function getHasPos(count:int):Boolean
		{
			return GlobalData.selfPlayer.bagMaxCount - currentSize >= count;
		}
		/**
		 * 获取可用的HP物品
		 * @return 
		 * 
		 */		
		public function getCanUseHpItem(big:Boolean):ItemInfo
		{
			var b:ItemInfo;
			var s:ItemInfo;
			for each(var i:ItemInfo in _itemList)
			{
				if(i && CategoryType.isHpDrup(i.template.categoryId) && i.canOperate() && i.getCanUse())
				{
					if(!b)b = i;
					else
					{
						if(i.template.property2 > b.template.property2)b = i;
					}
					if(!s)s = i;
					else if(i.template.property2 < s.template.property2)s = i;
				}
			}
			if(big)return b;
			return s;
		}
		/**
		 * 获取HP物品
		 * @return 
		 * 
		 */		
		public function getUseHpItem(big:Boolean):ItemInfo
		{
			var b:ItemInfo;
			var s:ItemInfo;
			for each(var i:ItemInfo in _itemList)
			{
				if(i && CategoryType.isHpDrup(i.template.categoryId))
				{
					if(!b)b = i;
					else
					{
						if(i.template.property2 > b.template.property2)b = i;
					}
					if(!s)s = i;
					else if(i.template.property2 < s.template.property2)s = i;
				}
			}
			if(big)return b;
			return s;
		}
		/**
		 * 获取可用的MP物品
		 * @return 
		 * 
		 */		
		public function getCanUseMpItem(big:Boolean):ItemInfo
		{
			var b:ItemInfo;
			var s:ItemInfo;
			for each(var i:ItemInfo in _itemList)
			{
				if(i && CategoryType.isMpDrup(i.template.categoryId) && i.canOperate() && i.getCanUse())
				{
					if(!b)b = i;
					else
					{
						if(i.template.property2 > b.template.property2)b = i;
					}
					if(!s)s = i;
					else if(i.template.property2 < s.template.property2)s = i;
				}
			}
			if(big)return b;
			return s;
		}
		/**
		 * 获取MP物品
		 * @return 
		 * 
		 */		
		public function getUseMpItem(big:Boolean):ItemInfo
		{
			var b:ItemInfo;
			var s:ItemInfo;
			for each(var i:ItemInfo in _itemList)
			{
				if(i && CategoryType.isMpDrup(i.template.categoryId))
				{
					if(!b)b = i;
					else
					{
						if(i.template.property2 > b.template.property2)b = i;
					}
					if(!s)s = i;
					else if(i.template.property2 < s.template.property2)s = i;
				}
			}
			if(big)return b;
			return s;
		}
		
		/**获取物品总数量**/
		public function getCategoryCount(argCategoryType:int):int
		{
			var count:int = 0;
			for each(var i:ItemInfo in _itemList)
			{
				if(i && i.template.categoryId == argCategoryType && i.canOperate())
				{
					count += i.count;
				}
			}
			return count;
		}
		
		/**
		 * 根据类型获取身上装备
		 * @param category
		 * @return 
		 * 
		 */		
		public function getEquipByCategory(category:int):ItemInfo
		{
			for(var i:int = 0; i < EQUIP_SIZE; i++)
			{
				if(_itemList[i] && _itemList[i].template.categoryId == category)return _itemList[i];
			}
			return null;
		}
		
		/**
		 *获取自己身上的套装列表 
		 * @param suitNumberInfo
		 * @return 
		 * 
		 */		
		public function getSuitList(suitNumberInfo:SuitNumberInfo):Array
		{
			var list:Array = [];
			for(var i:int = 0;i<EQUIP_SIZE;i++)
			{
				if(_itemList[i])
				{
					if(_itemList[i].template.templateId == suitNumberInfo.clothId || _itemList[i].template.templateId == suitNumberInfo.armetId || _itemList[i].template.templateId == suitNumberInfo.cuffId || _itemList[i].template.templateId == suitNumberInfo.shoesId || _itemList[i].template.templateId == suitNumberInfo.caestusId || _itemList[i].template.templateId == suitNumberInfo.necklaceId)
						list.push(_itemList[i].template.templateId);
				}
			}
			return list;
		}
		
		public function hasSuitComponet(suitId:int):Boolean
		{
			for(var i:int = 0;i<EQUIP_SIZE;i++)
			{
				if(_itemList[i])
				{
					if(_itemList[i].template.templateId == suitId)
						return true;
				}
			}
			return false;
		}
		
		private function getAndUseEquip(item:ItemInfo) : void
		{
			//检测当前的物品
			if (!CategoryType.isEquip(item.template.categoryId))
				return;
			
			//职业判断
			if (item.template.needCareer != GlobalData.selfPlayer.career)
				return;
			
			//性别判断
			if (item.template.needSex != 0 && item.template.needSex != GlobalData.selfPlayer.getSex())
			{
				return;
			}
			
			//等级判断
			if (item.template.needLevel > GlobalData.selfPlayer.level)
				return;
			
			
			//得到相应位置的装备
			var itemInfo:ItemInfo = getEquipByCategory(item.template.categoryId);
			if ((itemInfo != null && item.score > itemInfo.score) || itemInfo == null)
			{
				GetAndUsePanel.getInstance().show(item.template);
				
			}
		}
		
		public function getTotalStrengthenLevel():int
		{
			var equipList:Array = _itemList.slice(0,30);
			var ret:int = 0;
			for each(var i:ItemInfo in equipList)
			{
				if(i != null && i.place >= 0 )
				{
					ret += i.strengthenLevel;
				}
			}
			return ret;
		}
	}
}