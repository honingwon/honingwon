package sszt.core.utils
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.furnace.ForgeCorrespondInfo;
	import sszt.core.data.item.ItemFreeProperty;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.loginReward.LoginRewardData;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.player.BasePlayerInfo;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.player.TipPlayerInfo;
	import sszt.interfaces.socket.IPackageIn;

	public class PackageUtil
	{
		public static function readBasePlayer(player:BasePlayerInfo,data:IPackageIn):void
		{
			player.nick = data.readString();
			player.sex = data.readBoolean();
			player.level = data.readUnsignedByte();
		}
		
		public static function readTipPlayer(player:TipPlayerInfo,data:IPackageIn):void
		{
			readBasePlayer(player,data);
		}
		
		public static function readFigurePlayer(player:FigurePlayerInfo,data:IPackageIn,cloth:int = -1):void
		{
			readTipPlayer(player,data);
			player.camp = data.readByte();
			player.career = data.readByte();
			//正常 1单修 2普双休 3特殊双休
			var clotht:int = data.readInt();
			if(cloth != -1)clotht = cloth;
			//player.updateStyle(clotht,data.readInt(),data.readInt(),data.readInt(),data.readInt(),data.readBoolean(),data.readBoolean(),data.readByte() != 0);
			player.updateStyle(clotht,data.readInt(),data.readInt(),data.readInt(),data.readInt(),data.readInt(),data.readBoolean(),data.readBoolean(),data.readByte() != 0,data.readByte() != 0);
			
			player.stallName = data.readString();
			var clubId:Number = data.readInt();
			var p:Boolean = false;
			if(player.userId == GlobalData.selfPlayer.userId && player.clubId != clubId)
			{
				p = true;
			}
			player.clubId = clubId;
			player.clubName = data.readString();
			player.clubDuty = data.readByte();
			player.clubLevel = data.readByte();
			player.clubFurnaceLevel = data.readByte();
			player.selfExploit = data.readInt();
			player.totalExploit = data.readInt();
			if(p)GlobalData.taskInfo.updateJoinClubTask();
			
			player.PKMode = data.readByte();
			player.PKValue = data.readInt();
			player.updateVipType(data.readShort());
			player.title = data.readInt();
			player.isTitleHide = data.readBoolean();
			player.buffTitleId = data.readShort();
//			player.currentServerId = data.readShort();
//			player.serverId = data.readShort();
		}
		
//		public static function readStyle(player:FigurePlayerInfo,data:IPackageIn):void
//		{
//			var tmpContent:String = data.readString();
//			var tmpList:Array = tmpContent.split(",");
//			var hideSuit:Boolean = Boolean(parseInt(tmpList[5]));
//			var suit:int = parseInt(tmpList[6]);
//			var cloth:int = parseInt(tmpList[0]);
//			if(!hideSuit && suit != 0)
//			{
//				cloth = suit;
//			}
//			player.updateStyle(cloth,int(tmpList[1]),int(tmpList[2]),int(tmpList[3]),int(tmpList[4]),0,hideSuit);
//			player.sex = Boolean(parseInt(tmpList[7]));
//		}
		
		public static function readDetailPlayer(player:DetailPlayerInfo,data:IPackageIn):void
		{
			readFigurePlayer(player,data);
			player.totalHP = data.readInt();
			player.totalMP = data.readInt();
			player.currentHP = data.readInt();
			player.currentMP = data.readInt();
			player.currentClubContribute = data.readInt();
			player.attack = data.readInt();
			player.defense = data.readInt();
			player.hitTarget = data.readInt();
			player.duck = data.readInt();
			player.keepOff = data.readInt();
			player.powerHit = data.readInt();
			player.deligency = data.readInt();
			player.magicAttack = data.readInt();
			player.magicDefense = data.readInt();
			player.magicAvoidInHurt = data.readInt();
			player.farAttack = data.readInt();
			player.farDefense = data.readInt();
			player.farAvoidInHurt = data.readInt();
			player.mumpAttack = data.readInt();
			player.mumpDefense = data.readInt();
			player.mumpAvoidInHurt = data.readInt();
			player.lifeExperiences = data.readInt();
			player.totalLifeExperiences = data.readInt();
			player.godRepute = data.readInt();
			player.ghostRepute = data.readInt();
			player.honor = data.readInt();
			player.title = data.readInt();
			player.maxPhysical = data.readInt();
			player.currentPhysical = data.readInt();
//			player.attackSuppress = data.readInt();
//			player.defenseSuppress = data.readInt();
			player.fight = data.readInt();
			player.damage = data.readInt();
		}
		
		public static function readSelfPlayer(player:SelfPlayerInfo,data:IPackageIn):void
		{
			readDetailPlayer(player,data);
			player.userName = data.readString();
			player.currentExp = data.readNumber();
			player.userMoney.parseData(data as ByteArray);
//			player.yuanBaoScore = data.readInt();
			player.money = data.readInt();
			//player.exploit = data.readInt();
			GlobalData.pvpInfo.exploit = data.readInt();
			player.bagMaxCount = data.readInt();
			player.wareHouseMaxCount = data.readInt();
			player.totalClubContribute = data.readInt();
			player.HPRevert = data.readInt();
			player.MPRevert = data.readInt();
			player.exceptRate = data.readInt();
			player.defenseExceptRate = data.readInt();
			player.fitEquipType = data.readInt();
			player.fitWeaponType = data.readInt();
			player.especialStatus = data.readInt();
			player.clientConfig = data.readInt();
			player.PKModeChangeDate = data.readDate();
//			player.honor = data.readInt();
		}
		
		
		
		public static function readItem(item:ItemInfo,data:IPackageIn):void
		{						
			item.itemId = data.readNumber();
			item.templateId = data.readInt();
			item.isBind = data.readBoolean();
			var level:int = data.readInt();
			var perfect:int = level  % 100;
			level = level / 100;
			if(perfect == 0 && level >= 1)
			{
				perfect = 100;
				level = level - 1;
			}
			item.strengthenLevel = level ;			
			item.strengthenPerfect = perfect;
			item.count = data.readInt();
			item.place = data.readInt();
			item.date = data.readDate();
			item.state = data.readInt();
			item.enchase1 = data.readInt();
			item.enchase2 = data.readInt();
			item.enchase3 = data.readInt();
			item.enchase4 = data.readInt();
			item.enchase5 = data.readInt();
			item.enchase6 = data.readInt();
			item.durable = data.readInt();
			item.score = data.readInt();
			item.freePropertyVector = parseFreeProperty(data.readString());
			item.stallSellPrice = data.readInt();
//			item.score = data.readInt();
//			item.wuHunId = data.readInt();
		}
		/**
		 * 读取属性串
		 * @param argList
		 * @param argContent
		 * 
		 */		
//		public static function parseProperty(argContent:String):Vector.<PropertyInfo>
		public static function parseProperty(argContent:String):Array
		{
//			var result:Vector.<PropertyInfo> = new Vector.<PropertyInfo>();
			var result:Array = [];
			if(argContent == ""||argContent == "undefined")return result;
			var tmpList1:Array = argContent.split("|");
			for(var i:int = 0;i < tmpList1.length;i++)
			{
				var tmpList2:Array = tmpList1[i].split(",");
				var tmpInfo:PropertyInfo = new PropertyInfo();
				tmpInfo.propertyId = Number(tmpList2[0]);
				tmpInfo.propertyValue = Number(tmpList2[1]);
				result.push(tmpInfo);
			}
			return result;
		}
		/**
		 * 读取自由属性串
		 * @param argList
		 * @param argContent
		 * 
		 */		
		//		public static function parseProperty(argContent:String):Vector.<PropertyInfo>
		public static function parseFreeProperty(argContent:String):Array
		{
			//			var result:Vector.<PropertyInfo> = new Vector.<PropertyInfo>();
			var result:Array = [];
			if(argContent == ""||argContent == "undefined")return result;
			var tmpList1:Array = argContent.split("|");
			for(var i:int = 0;i < tmpList1.length;i++)
			{
				var tmpList2:Array = tmpList1[i].split(",");
				var tmpInfo:ItemFreeProperty = new ItemFreeProperty();
				tmpInfo.index = Number(tmpList2[0]);
				tmpInfo.propertyId = Number(tmpList2[1]);
				tmpInfo.propertyValue = Number(tmpList2[2]);
				tmpInfo.lockState = Number(tmpList2[3]);
				result.push(tmpInfo);
			}
			result.sort(sortOnIndex);
			return result; 
		}
		/**
		 * 读取自由属性串2
		 * @param argList
		 * @param argContent
		 * 
		 */		
		//		public static function parseProperty(argContent:String):Vector.<PropertyInfo>
		public static function parseFreePropertyList(argContent:String):Array
		{
			//			var result:Vector.<PropertyInfo> = new Vector.<PropertyInfo>();
			var result:Array = [];
			if(argContent == ""||argContent == "undefined")return result;
			var tmpList1:Array = argContent.split("|");
			for(var i:int = 0;i < tmpList1.length;i++)
			{
				var tmpList2:Array = tmpList1[i].split(",");
				var tmpInfo:ItemFreeProperty = new ItemFreeProperty();
				tmpInfo.index = Number(i);
				tmpInfo.propertyId = Number(tmpList2[0]);
				tmpInfo.propertyValue = Number(tmpList2[1]);
				tmpInfo.lockState = Number(0);
				result.push(tmpInfo);
			}
			result.sort(sortOnIndex);
			return result; 
		}
		private static function sortOnIndex(a:ItemFreeProperty, b:ItemFreeProperty):int
		{
			if(a.propertyId > b.propertyId)
				return 1;
			else if(a.propertyId < b.propertyId)
				return -1;
			else if(a.index > b.index)
				return 1;
			else
				return -1;
		}
		
		/**
		 * 读取固定属性串
		 * @param argList
		 * @param argContent
		 * 
		 */	
		public static function parseRegularProperty(argContent:String):Array
		{
			var result:Array = [];
			if(argContent == "")return result;
			var tmpList1:Array = argContent.split("|");
			for(var i:int = 0;i < tmpList1.length;i++)
			{
				var tmpList2:Array = tmpList1[i].split(",");
				var tmpInfo:PropertyInfo = new PropertyInfo();
				if(tmpList2.length == 2)
				{
					tmpInfo.propertyId = Number(tmpList2[0]);
					tmpInfo.propertyValue = Number(tmpList2[1]);
					result.push(tmpInfo);
				}
				else if(tmpList2.length == 3)
				{
					tmpInfo.propertyId = Number(tmpList2[0]);
					tmpInfo.propertyValue = Number(tmpList2[1]);
					tmpInfo.propertyPercent = Number(tmpList2[2]);
					result.push(tmpInfo);
				}
			}
			return result;
		}
		/**
		 * 
		 *读取炼炉分类字符串 
		 * 
		 */		
		public static function parseFireBoxSort(argContent:String):Array
		{
			var result:Array = [];
			if(argContent == "")return result;
			var tmpList1:Array = argContent.split("|");
			for(var i:int = 0;i < tmpList1.length;i++)
			{
				var tmpList2:Array = tmpList1[i].split(",");
				var tmpInfo:ForgeCorrespondInfo = new ForgeCorrespondInfo();
				tmpInfo.sortId = Number(tmpList2[0]);
				tmpInfo.sortName = tmpList2[1];
				result.push(tmpInfo);
			}
			return result;
		}
		
		public static function parseClubEnemyList(data:IPackageIn):Array
		{
			var result:Array = [];
			var len:int = data.readInt();
			for(var i:int = 0;i < len;i++)
			{
				result.push(data.readInt());
			}
			return result;
		}
		
		public static function parseMountsRefined(mounts:MountsItemInfo,_data:IPackageIn):void
		{			
			mounts.refined = _data.readByte();
			mounts.refinedHp = _data.readShort();
			mounts.refinedMp = _data.readShort();
			mounts.refinedAttack = _data.readShort();
			mounts.refinedDefence = _data.readShort();
			mounts.refinedProAttack = _data.readShort();
			mounts.refinedMagicDefence = _data.readShort();
			mounts.refinedFarDefence = _data.readShort();
			mounts.refinedMumpDefence = _data.readShort();
		}
		
		public static function parseMountsProperty(mounts:MountsItemInfo,_data:IPackageIn):void
		{
			mounts.fight = _data.readInt();
			mounts.skillCellNum = _data.readByte();
			mounts.upGrow = _data.readByte();
			mounts.upQuality = _data.readByte();
			mounts.hp = _data.readInt();
			mounts.hp1 = _data.readShort();
			mounts.mp = _data.readShort();
			mounts.mp1 = _data.readShort();
			mounts.attack = _data.readShort();
			mounts.attack1 = _data.readShort();
			mounts.defence = _data.readShort();
			mounts.defence1 = _data.readShort();
			mounts.magicAttack = _data.readShort();
			mounts.magicAttack1 = _data.readShort();
			mounts.farAttack = _data.readShort();
			mounts.farAttack1 = _data.readShort();
			mounts.mumpAttack = _data.readShort();
			mounts.mumpAttack1 = _data.readShort();
			
			mounts.magicDefence = _data.readShort();
			mounts.magicDefence1 = _data.readShort();
			mounts.farDefence = _data.readShort();
			mounts.farDefence1 = _data.readShort();
			mounts.mumpDefence = _data.readShort();
			mounts.mumpDefence1 = _data.readShort();
		}
		
		
		public static function parsePetProperty(pet:PetItemInfo,_data:IPackageIn):void
		{
			pet.fight = _data.readInt();
			pet.skillCellNum = _data.readByte();
			pet.upGrow = _data.readByte();
			pet.upQuality = _data.readByte();
			pet.hit =  _data.readShort();
			pet.hit2 = _data.readShort();
			pet.powerHit = _data.readShort();
			pet.powerHit2 = _data.readShort();
			pet.attack =  _data.readShort();
			pet.attack2 =_data.readShort();
			pet.magicAttack =_data.readShort();
			pet.magicAttack2 =_data.readShort();
			pet.farAttack =_data.readShort();
			pet.farAttack2 =_data.readShort();
			pet.mumpAttack =_data.readShort();
			pet.mumpAttack2 =_data.readShort();
		}
		
		
		public static function readNumber(data:ByteArray):Number
		{
			data.readShort();
			var t:Number = data.readShort();
			return (t << 24) * 256 + data.readUnsignedInt();
		}
		
		public static function readDate(data:ByteArray):Date
		{
			return new Date(Number(data.readInt()) * 1000);
		}
		
		public static function readLoginRewardData(lrd:LoginRewardData,data:IPackageIn):void
		{
			lrd.got = data.readBoolean();
			lrd.gotChargeUser = data.readBoolean();
			var ld:int = data.readShort();
			if(ld <= 0)
			{
				ld = 1;
			}
			lrd.login_day = ld;
			var singeNum:int = data.readShort();
			var multiNum:int = data.readShort();
			lrd.duplicateNum = singeNum
			lrd.multiDuplicateNum = multiNum;
			lrd.offLineTimes = data.readInt();
			lrd.gotDuplicate = !singeNum;
			lrd.gotMultiDuplicateNum = !multiNum;
			var _count:int = int(lrd.offLineTimes / 3600);
			if(_count<=0)
				lrd.gotOffLineTimes = true;
				
			
		}
	}
}