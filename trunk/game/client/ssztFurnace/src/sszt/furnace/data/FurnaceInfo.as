package sszt.furnace.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.furnace.parametersList.StoneMatchTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.data.lastConfig.FurnaceLastConfigInfo;
	import sszt.furnace.events.FuranceEvent;
	
	public class FurnaceInfo extends EventDispatcher
	{
		/**右上角品质数据层**/
//		public var qualityVector:Vector.<FurnaceItemInfo> = new Vector.<FurnaceItemInfo>();
//		/**右下角材料数据层**/
//		public var materialVector:Vector.<FurnaceItemInfo> = new Vector.<FurnaceItemInfo>();
		public var qualityVector:Array = [];
		/**右下角材料数据层**/
		public var materialVector:Array = [];
		
		/**炼制材料数据**/
//		public var refinMaterialList:Array = [];
		
		/**当前购买类型**/
		private var _currentBuyType:int = -1;
		/**强化失败次数**/
		public var strengthFailCount:int;
		private var _currentEquipCategoryId:int = -1;
		
		public var furnaceLastConfigInfo:FurnaceLastConfigInfo;
		
		public function FurnaceInfo(target:IEventDispatcher=null)
		{
			super(target);
			furnaceLastConfigInfo = new FurnaceLastConfigInfo();
		}
		
		/*******************************qualityVector操作**********************************/
		public function addToQualityVector(argFurnaceItemInfo:FurnaceItemInfo, dispatch:Boolean = true):void
		{
			qualityVector.push(argFurnaceItemInfo);
			if(dispatch)
				dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_ADD,argFurnaceItemInfo.bagItemInfo.itemId));
		}
		
		public function removeFromQualityVector(itemId:Number):void
		{
			var tmpInfo:FurnaceItemInfo = getFurnaceItemInfoFromQualityVector(itemId);
			for(var i:int = 0;i < tmpInfo.placeList.length;i++)
			{
				deleteToPlace(tmpInfo,tmpInfo.placeList[i]);
			}
			qualityVector.splice(qualityVector.indexOf(tmpInfo),1);
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_DELETE,itemId));
		}
		
		/*******************************materialVector操作*********************************/
		public function addToMaterialVector(argFurnaceItemInfo:FurnaceItemInfo, dispatch:Boolean = true):void
		{
			
			materialVector.push(argFurnaceItemInfo);
			if(dispatch)
				dispatchEvent(new FuranceEvent(FuranceEvent.CELL_MATERIAL_ADD,argFurnaceItemInfo.bagItemInfo.itemId));
		}
		
		public function removeFromMaterialVector(itemId:Number):void
		{
			var tmpInfo:FurnaceItemInfo = getFurnaceItemInfoFromMaterialVector(itemId);
			materialVector.splice(materialVector.indexOf(tmpInfo),1);
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_MATERIAL_DELETE,itemId));
			//清空对应中间面板
			for(var j:int = tmpInfo.placeList.length - 1;j >= 0;j--)
			{
				deleteToPlace(tmpInfo,tmpInfo.placeList[j]);
			}
		}
		public function removeAllFromMaterialVector():void
		{
			materialVector = [];
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_MATERIAL_CLEAR));
//			//清空对应中间面板
//			for(var j:int = tmpInfo.placeList.length - 1;j >= 0;j--)
//			{
//				deleteToPlace(tmpInfo,tmpInfo.placeList[j]);
//			}
		}
		
		public function updatePetBagToFurnace(itemId:Number):void
		{
			var tmpFurnaceItemInfo:FurnaceItemInfo = getFurnaceItemInfo(itemId);
			var tmpBagItemInfo:ItemInfo = GlobalData.petBagInfo.getItemByItemId(itemId);
			if(tmpFurnaceItemInfo)
			{
				if(qualityVector.indexOf(tmpFurnaceItemInfo) != -1)
				{
					//删除
					if(!tmpBagItemInfo)
					{
						removeFromQualityVector(itemId);
					}
					else
					{
						//更新材料数据层格子数量
						qualityVector[qualityVector.indexOf(tmpFurnaceItemInfo)].bagItemInfo = tmpBagItemInfo
						//更新材料视图层信息
						dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_UPDATE,itemId));
					}
				}
			}
			else
			{
				if(!tmpBagItemInfo)return;
				//增加
				addToQualityVector(new FurnaceItemInfo(tmpBagItemInfo,_currentBuyType));
			}
		}
		
		
		/********************************从背包更新信息******************************/
//		public function updateBagToFurnace(itemId:Number,argCallBackFunction:Function = null,argMaterialCategoryIdList:Vector.<int> = null):void
		public function updateBagToFurnace(itemId:Number,argCallBackFunction:Function = null,argMaterialCategoryIdList:Array = null):void
		{
			var tmpFurnaceItemInfo:FurnaceItemInfo = getFurnaceItemInfo(itemId);
			var tmpBagItemInfo:ItemInfo = GlobalData.bagInfo.getAllItemByItemId(itemId);
			if(tmpFurnaceItemInfo)
			{
				if(qualityVector.indexOf(tmpFurnaceItemInfo) != -1)
				{
					//删除
					if(!tmpBagItemInfo)
					{
						removeFromQualityVector(itemId);
					}
					else
					{
						//更新材料数据层格子数量
						qualityVector[qualityVector.indexOf(tmpFurnaceItemInfo)].bagItemInfo = tmpBagItemInfo
						//更新材料视图层信息
						dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_UPDATE,itemId));
					}
				}
				else if(materialVector.indexOf(tmpFurnaceItemInfo) != -1)
				{
					if(!tmpBagItemInfo)
					{
						removeFromMaterialVector(itemId);
					}
					else
					{
						materialVector[materialVector.indexOf(tmpFurnaceItemInfo)].bagItemInfo = tmpBagItemInfo;
//						dispatchEvent(new FuranceEvent(FuranceEvent.CELL_MATERIAL_UPDATE,itemId));
					}
				}
			}
			else
			{
				if(!tmpBagItemInfo)return;
				//增加
				if(argCallBackFunction(tmpBagItemInfo))
				{
					addToQualityVector(new FurnaceItemInfo(tmpBagItemInfo,_currentBuyType));
				}
				if(argMaterialCategoryIdList.indexOf(tmpBagItemInfo.template.categoryId)+1)
				{
					addToMaterialVector(new FurnaceItemInfo(tmpBagItemInfo));
				}
			}
		}
		//cell数量的增减
		public function updateToFurnaceVector(argItemId:Number,argCount:int,isUpOrDownTag:Boolean):void
		{
			var tmpFurnaceItemInfo:FurnaceItemInfo = getFurnaceItemInfo(argItemId);
			if(tmpFurnaceItemInfo)
			{
				if(isUpOrDownTag)
				{
					tmpFurnaceItemInfo.count += argCount;
				}
				else
				{
					tmpFurnaceItemInfo.count -= argCount;
				}
			}
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_UPDATE,argItemId));
		}
		
		/******************************************中间合成面板操作*************************************/
		//点击格子发出事件
		public function clickHandler(argFurnaceItemInfo:FurnaceItemInfo):void
		{
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_CLICK,argFurnaceItemInfo));
		}
		
		public function putAgainHandler(argItemId:Number):void
		{
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_PUTAGAIN,argItemId));
		}
		
		public function replaceRebuildHandler(argItemId:Number):void
		{
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_REPLACE_REBUILD,argItemId));
		}
		
		//增加到中间面板
		public function setToPlace(argFurnaceItemInfo:FurnaceItemInfo,argPlace:int):void
		{
//			updateToFurnaceVector(argFurnaceItemInfo.bagItemInfo.itemId,1,false);
			argFurnaceItemInfo.addPlace(argPlace);
			argFurnaceItemInfo.setTo();
			dispatchEvent(new FuranceEvent(FuranceEvent.FURANCE_CELL_UPDATE,{info:argFurnaceItemInfo,place:argPlace}));
		}
//		public function setToPlace2(argFurnaceItemInfo:FurnaceItemInfo,argPlace:int):void
//		{
//			argFurnaceItemInfo.addPlace(argPlace);
//			dispatchEvent(new FuranceEvent(FuranceEvent.FURANCE_CELL_UPDATE,{info:argFurnaceItemInfo,place:argPlace}));
//		}
		
		//从中间面板删除
		public function deleteToPlace(argFurnaceItemInfo:FurnaceItemInfo,argPlace:int):void
		{
//			updateToFurnaceVector(argFurnaceItemInfo.bagItemInfo.itemId,1,true);
			 argFurnaceItemInfo.removePlace(argPlace);
			argFurnaceItemInfo.setBack();
			dispatchEvent(new FuranceEvent(FuranceEvent.FURANCE_CELL_UPDATE,{info:null,place:argPlace}));
		}
		
		public function deleteToPlace2(argFurnaceItemInfo:FurnaceItemInfo,argPlace:int):void
		{
			argFurnaceItemInfo.removePlace(argPlace);
			dispatchEvent(new FuranceEvent(FuranceEvent.FURANCE_CELL_UPDATE,{info:null,place:argPlace}));
		}
		
		/**********************************************数据初始化**********************************************/
		/*大切卡初始化数据容器**/
//		public function initialFurnaceVector(argCallBackFunction:Function,argMaterialCategoryIdList:Vector.<int>):void
		public function initialFurnaceVector(argCallBackFunction:Function,argMaterialCategoryIdList:Array):void
		{
			var pet:PetItemInfo = GlobalData.petList.getFightPet();
			if(pet)
			{
				for each(var k:ItemInfo in GlobalData.petBagInfo.petDic[pet.id])
				{
					if(k && argCallBackFunction(k)) addToQualityVector(new FurnaceItemInfo(k,_currentBuyType), false);
				}
			}
				
			for each(var n:ItemInfo in GlobalData.bagInfo.getWearEquipByFunction(argCallBackFunction))
			{
				addToQualityVector(new FurnaceItemInfo(n,_currentBuyType), false);
			}			
			for each(var i:ItemInfo in GlobalData.bagInfo.getEquipByFunction(argCallBackFunction))
			{
				addToQualityVector(new FurnaceItemInfo(i,_currentBuyType), false);
			}
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_ADD,0));
			for each(var j:ItemInfo in GlobalData.bagInfo.getListByType(argMaterialCategoryIdList,0,false))
			{
				addToMaterialVector(new FurnaceItemInfo(j), false);
			}
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_MATERIAL_ADD,0));
			/**商城信息(直接读模板)**/
		}
		
//		public function initialRefiningMaterial(materialList:Array):void
//		{
//			refinMaterialList = [];
//			for(var i:int = 0; i < materialList.length; i++)
//			{
//				var num:int = GlobalData.bagInfo.getItemCountById(materialList[i].id);
//				refinMaterialList.push({id:materialList[i].id, need:materialList[i].num, amount:num});
//			}
//		}
		
		//过滤掉 不可熔炼的装备
		public function chooseFuseQuality(argCallBackFunction:Function):void
		{
			qualityVector = [];
			for each(var n:ItemInfo in GlobalData.bagInfo.getWearEquipByFunction(argCallBackFunction))
			{
//				if(!argCallBackFunction1(n))
//					n.lock = true;
//				else n.lock = false;
				addToQualityVector(new FurnaceItemInfo(n,_currentBuyType), false);
			}			
			for each(var i:ItemInfo in GlobalData.bagInfo.getEquipByFunction(argCallBackFunction))
			{
//				if(!argCallBackFunction1(i))
//					i.lock = true;
//				else i.lock = false;
				addToQualityVector(new FurnaceItemInfo(i,_currentBuyType), false);
			}
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUALITY_ADD,0));
			/**商城信息(直接读模板)**/
		}	
			
		//过滤掉不可镶嵌的宝石
//		public function chooseEnchaseMaterial(argCategoryIdVector:Vector.<int>,argEquipCategoryId:int = -1):void
		public function chooseEnchaseMaterial(argCategoryIdVector:Array,argEquipCategoryId:int = -1):void
		{
//			var tmpVector:Vector.<int>;
			var tmpVector:Array;
			clearMaterialVector();
			if(argCategoryIdVector)
			{
				tmpVector = argCategoryIdVector;
			}
			else
			{
				tmpVector = StoneMatchTemplateList.getStoneMatchInfo(argEquipCategoryId).stoneList;
			}
			var vector:Array =  GlobalData.bagInfo.getListByType(tmpVector,0,false);
			for(var i:int = 0; i< vector.length; ++i)
			{
				if(i == vector.length -1 )
				{
					addToMaterialVector(new FurnaceItemInfo(vector[i]));
				}
				else
				{
					addToMaterialVector(new FurnaceItemInfo(vector[i]),false);
				}
			}
		}
		
		
		
		/*************************清空容器***************************/
		//所有容器(不包括中间合成面板)
		//所有容器
		public function clearAllVector():void
		{
			for(var i:int = qualityVector.length - 1;i >= 0;i--)
			{
				qualityVector.splice(i,1);
			}
			for(var j:int = materialVector.length - 1;j >= 0;j--)
			{
				materialVector.splice(j,1);
			}
			currentBuyType = -1;
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_ALL_CLEAR));
		}
		//清空中间面板
		public function clearMiddlePanel():void
		{
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_MIDDLE_CLEAR));
		}
		
		public function clearMaterialVector():void
		{
			removeAllFromMaterialVector();
//			for(var j:int = materialVector.length - 1;j >= 0;j--)
//			{
//				removeFromMaterialVector(materialVector[j].bagItemInfo.itemId);
//			}
		}
		//清除炼制面板
//		public function clearAllRefiningVector():void
//		{
//			refinMaterialList = [];
//			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_REFINING_CLEAR));
//		}
		
		/*************************************get方法**********************************************/
		//品质容器
		public function getFurnaceItemInfoFromQualityVector(itemId:Number):FurnaceItemInfo
		{
			for each(var i:FurnaceItemInfo in qualityVector)
			{
				if(i.bagItemInfo.itemId == itemId)
				{
					return i;
				}
			}
			return null;
		}
		//材料容器
		public function getFurnaceItemInfoFromMaterialVector(itemId:Number):FurnaceItemInfo
		{
			for each(var i:FurnaceItemInfo in materialVector)
			{
				if(i.bagItemInfo.itemId == itemId)
				{
					return i;
				}
			}
			return null;
		}
		//两个容器
		public function getFurnaceItemInfo(itemId:Number):FurnaceItemInfo
		{
			for each(var i:FurnaceItemInfo in qualityVector)
			{
				if(i.bagItemInfo.itemId == itemId)
				{
					return i;
				}
			}
			for each(var j:FurnaceItemInfo in materialVector)
			{
				if(j.bagItemInfo.itemId == itemId)
				{
					return j;
				}
			}
			return null;
		}
		/**通过templateId获得物品(绑定，非绑定),数量非0**/
		public function getFurnaceItemInfoByTemplateId(argTemplate:Number,argIstBind:Boolean):FurnaceItemInfo
		{
			for each(var i:FurnaceItemInfo in qualityVector)
			{
				if(i.bagItemInfo.templateId == argTemplate && i.bagItemInfo.isBind == argIstBind && i.count != 0)
				{
					return i;
				}
			}
			for each(var j:FurnaceItemInfo in materialVector)
			{
				if(j.bagItemInfo.templateId == argTemplate && j.bagItemInfo.isBind == argIstBind && j.count != 0)
				{
					return j;
				}
			}
			return null;
		}
		/**返回品质包中宝石中某物品总数**/
		public function getFurnaceStoneNumByTemplateId(argTemplate:Number):int
		{
			var num:int = 0;
			for each(var j:FurnaceItemInfo in qualityVector)
			{
				if(j.bagItemInfo.templateId == argTemplate)
				{
					num += j.count;
				}
			}
			return num;
		}
		/**
		 * 返回材料中某物品总数
		 * */
		public function getFurnaceItemNumByTemplateId(argTemplate:Number):int
		{
			var num:int = 0;
			for each(var j:FurnaceItemInfo in materialVector)
			{
				if(j.bagItemInfo.templateId == argTemplate)
				{
					num += j.count;
				}
			}
			return num;
		}
		/**通过templateId获得材料对象 默认优先使用绑定**/
		public function getFurnaceMaterialByTemplateId(argTemplate:Number, useBind:Boolean = true):FurnaceItemInfo
		{
			for each(var j:FurnaceItemInfo in materialVector)
			{
				if(j.bagItemInfo.templateId == argTemplate && j.bagItemInfo.isBind == useBind && j.count != 0)
				{
					return j;
				}
			}
			for each(var i:FurnaceItemInfo in materialVector)
			{
				if(i.bagItemInfo.templateId == argTemplate && i.count != 0)
				{
					return i;
				}
			}
			return null;
		}
		//当前购买类型
		public function get currentBuyType():int
		{
			return _currentBuyType;
		}
		
		public function set currentBuyType(value:int):void
		{
			_currentBuyType = value;
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_QUICKBUY_INITIAL,_currentBuyType));
		}

		/**当前装备类型Id  (为了材料面板过滤，=-1不过滤)**/
		public function get currentEquipCategoryId():int
		{
			return _currentEquipCategoryId;
		}

		/**
		 * @private
		 */
		public function set currentEquipCategoryId(value:int):void
		{
			_currentEquipCategoryId = value;
			dispatchEvent(new FuranceEvent(FuranceEvent.CELL_EQUIP_UPDATE));
		}

	}
}