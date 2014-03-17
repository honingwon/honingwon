package sszt.core.data.item
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.LayerInfo;
	import sszt.core.data.ProtocolType;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.socket.IPackageIn;

	public class ItemTemplateInfo extends LayerInfo
	{
		/**模板名称 **/
		public var name:String;
		/**描述**/
		public var description:String;
		/**质量(1绿，2蓝，3紫，4橙)**/
		public var quality:int;
		/**攻击**/
		public var attack:int;
		/**防御**/
		public var defense:int;
//		/**元宝**/
//		public var yuanbao:int;
//		/**铜币**/
//		public var copper:int;
//		/**
//		 * 绑定元宝
//		 */		
//		public var bindYuanBao:int;
//		/**
//		 * 绑定铜币
//		 */		
//		public var bindCopper:int;
		/**绑定类型**/
		public var bindType:int;
		/**使用需要等级**/
		public var needLevel:int;
		/**使用性**/
		public var needSex:int;      //0无要求，1男，2女
		/**职业**/
		public var needCareer:int;  //0无要求，1尚武，2逍遥,3流星
		/**最大数量**/
		public var maxCount:int;
		/**修复次数**/
		public var repair:int;
		/**耐用度**/
		public var durable:int;
		/**冷却时间**/
		public var cd:int;
		/**可否使用**/
		public var canUse:Boolean;
		/**可否加锁**/
		public var canLock:Boolean;	
		/**可否修理**/
	    public var canRepair:Boolean;
		/**可否升级**/
		public var canUpgrade:Boolean;
		/**可否回收**/
		public var canRecycle:Boolean;
		/**可否强化**/
		public var canStrengthen:Boolean;
		/**可否镶嵌**/
		public var canEnchase:Boolean;
//		/**可否合成**/
//		public var canCompose:Boolean;
		/**可否销售**/
		public var canSell:Boolean;
		/**可否交易**/
		public var canTrade:Boolean;
		/**可否绑定**/
		public var canUnbind:Boolean;
		/**可否鉴定**/
		public var canRebuild:Boolean;
		/**可否销毁**/
		public var canDestory:Boolean;
		/**可否喂养**/
		public var canFeed:Boolean;
		/**隐藏属性**/
//		public var freePropertyList:Vector.<PropertyInfo>;
		public var freePropertyList:Array;
		/**固定属性**/
//		public var regularPropertyList:Vector.<PropertyInfo>;
		public var regularPropertyList:Array;
		/**隐藏属性**/
//		public var hidePropertyList:Vector.<PropertyInfo>;
		public var hidePropertyList:Array;
		public var attchSkill:String;
		public var hideAttck:int;
		public var hideDefense:int;
		public var validTime:int;
		/**喂养产生的经验**/
		public var feedCount:int;
		
		public var script:String;
		/**如果是宝石模板，这个表示宝石等级**/
		public var property1:int;
		public var property2:int;
		public var property3:int;
		public var property4:int;
		public var property5:int;
		public var property6:int;
		public var property7:int;
		public var property8:int;
		
		public var sellCopper:int;
		/**
		 *售店获得铜币类型   0 为不绑定铜币，1为绑定铜币
		 */		
		public var sellType:int;
		public var suitId:int;
		
		public var categoryId:int;
		
		public function ItemTemplateInfo()
		{
//			freePropertyList = new Vector.<PropertyInfo>();
			freePropertyList = [];
//			regularPropertyList = new Vector.<PropertyInfo>();
			regularPropertyList = [];
//			hidePropertyList = new Vector.<PropertyInfo>();
			hidePropertyList = [];
		}
		
		/**
		 * 填充数据
		 * @param data
		 * 
		 */		
		public function loadData(category:int,data:ByteArray):void
		{
			categoryId = category;
			templateId = data.readInt();
			name = data.readUTF();
			picPath = String(data.readInt());
			iconPath = String(data.readInt());
			description = data.readUTF();
//			categoryId = data.readInt();
			quality = data.readInt();
			needLevel = data.readInt();
			needSex = data.readInt();
			needCareer = data.readInt();
			maxCount = data.readInt();
			attack = data.readInt();
			defense = data.readInt();
			
			sellCopper = data.readInt();
			sellType = data.readInt();
			
//			copper = data.readInt();
//			yuanbao = data.readInt();
//			bindCopper = data.readInt();
//			bindYuanBao = data.readInt();
			suitId = data.readInt();
			repair = data.readInt();
			bindType = data.readInt();
			
			durable = data.readInt();
			cd = data.readInt();
			
			canUse = data.readBoolean();
			canStrengthen = data.readBoolean();
			canEnchase = data.readBoolean();
//			canCompose = data.readBoolean();
			canRebuild = data.readBoolean();
			canRecycle = data.readBoolean();
			canUpgrade = data.readBoolean();
			canUnbind = data.readBoolean();
			canRepair = data.readBoolean();
			canDestory = data.readBoolean();
			
			canSell = data.readBoolean();
			canTrade = data.readBoolean();
			canFeed = data.readBoolean();
			freePropertyList = PackageUtil.parseFreePropertyList(data.readUTF());
			regularPropertyList = PackageUtil.parseRegularProperty(data.readUTF());
			hidePropertyList = PackageUtil.parseProperty(data.readUTF());
			attchSkill = data.readUTF();
			hideAttck = data.readInt();
			hideDefense = data.readInt();
			validTime = data.readInt();
			feedCount = data.readInt();
			script = data.readUTF();
			property1 = data.readInt();
			property2 = data.readInt();
			property3 = data.readInt();
			property4 = data.readInt();
			property5 = data.readInt();
			property6 = data.readInt();
			property7 = data.readInt();
			property8 = data.readInt();
		}
		
		public function splitString(argContent:String,argKeyWord:String):Array
		{
			var tmpSplitList:Array = null;
			if(argContent != "")
			{
				tmpSplitList = argContent.split(argKeyWord);
			}
			return tmpSplitList;
		}
		
//		public function clone():ItemTemplateInfo
//		{
//			var itemTemplateInfo:ItemTemplateInfo = new ItemTemplateInfo();
//			itemTemplateInfo.attack = attack;
//			itemTemplateInfo.attchSkill = attchSkill;
//			itemTemplateInfo.bindType = bindType;
//			itemTemplateInfo.canDestory = canDestory;
//			itemTemplateInfo.canEnchase = canEnchase;
//			itemTemplateInfo.canLock = canLock;
//			itemTemplateInfo.canRebuild = canRebuild;
//			itemTemplateInfo.canRecycle = canRecycle;
//			itemTemplateInfo.canRepair = canRepair;
//			itemTemplateInfo.canSell = canSell;
//			itemTemplateInfo.canStrengthen = canStrengthen;
//			itemTemplateInfo.canTrade = canTrade;
//			itemTemplateInfo.canUnbind = canUnbind;
//			itemTemplateInfo.canUpgrade = canUpgrade;
//			itemTemplateInfo.canUse = canUse;
//			itemTemplateInfo.categoryId = categoryId;
//			itemTemplateInfo.cd = cd;
//			itemTemplateInfo.defense = defense;
//			itemTemplateInfo.description = description;
//			itemTemplateInfo.durable = durable;
//			itemTemplateInfo.freePropertyList = freePropertyList;
//			itemTemplateInfo.hideAttck = hideAttck;
//			itemTemplateInfo.hideDefense = hideDefense;
//			itemTemplateInfo.hidePropertyList = hidePropertyList;
//			itemTemplateInfo.maxCount = maxCount;
//			itemTemplateInfo.name = name;
//			itemTemplateInfo.needCareer = needCareer;
//			itemTemplateInfo.needLevel = needLevel;
//			itemTemplateInfo.needSex = needSex;
//			itemTemplateInfo.picPath = picPath;
//			itemTemplateInfo.picPath2 = picPath2;
//			itemTemplateInfo.picPath3 = picPath3;
//			itemTemplateInfo.property1 = property1;
//			itemTemplateInfo.property2 = property2;
//			itemTemplateInfo.property3 = property3;
//			itemTemplateInfo.property4 = property4;
//			itemTemplateInfo.property5 = property5;
//			itemTemplateInfo.property6 = property6;
//			itemTemplateInfo.property7 = property7;
//			itemTemplateInfo.property8 = property8;
//			itemTemplateInfo.quality = quality;
//			itemTemplateInfo.regularPropertyList = regularPropertyList;
//			itemTemplateInfo.repair = repair;
//			itemTemplateInfo.script = script;
//			itemTemplateInfo.sellCopper = sellCopper;
//			itemTemplateInfo.sellType = sellType;
//			itemTemplateInfo.suitId = suitId;
//			itemTemplateInfo.templateId = templateId;
//			itemTemplateInfo.validTime = validTime;
//
//			return itemTemplateInfo;
//		}
		
//		/**分解字符串**/
//		public function parseProperty(argList:Vector.<PropertyInfo>,argContent:String):void
//		{
//			if(argContent == "")return;
//			var tmpList1:Array = argContent.split("|");
//			for(var i:int = 0;i < tmpList1.length;i++)
//			{
//				var tmpList2:Array = tmpList1[i].split(",");
//				argList.push(new PropertyInfo(Number(tmpList2[0]),Number(tmpList2[1])));
//			}
//		}
	}
}