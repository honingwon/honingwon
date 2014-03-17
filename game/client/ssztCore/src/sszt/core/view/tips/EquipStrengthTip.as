package sszt.core.view.tips
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import sszt.constData.CareerType;
	import sszt.constData.PropertyType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.equipStrength.EquipStrengthTemplate;
	import sszt.core.data.equipStrength.EquipStrengthTemplateList;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.mcache.splits.MCacheSplit2Line;

	public class EquipStrengthTip extends BaseDynamicTip
	{
		public static var instance:EquipStrengthTip;
		private var level:int;
		private var upCount:int;
		private var career:int;
		private var _lineBg:Array;
		
		public function EquipStrengthTip()
		{
			super();
			_lineBg = new Array();
		}
		
		public static function getInstance():EquipStrengthTip
		{
			if(instance == null)
			{
				instance = new EquipStrengthTip();
			}
			return instance;
		}
		
		private function keyIsDownHandler(evt:KeyboardEvent):void
		{
			hide();
		}
		
		public function showTip(level:int,upCount:int,career:int,pos:Point):void
		{
			this.level = level;
			this.upCount = upCount;
			this.career = career;
			setTip();
			if(!parent) GlobalAPI.layerManager.getTipLayer().addChild(this);
			this.x = pos.x;
			this.y = pos.y;
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
		}
		
		override public function hide():void
		{
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
			super.clear();
			if(parent) parent.removeChild(this);
		}
		
		private function setTip():void
		{

			addStringToField(LanguageManager.getWord("ssztl.common.allEquipUp",level) + "(" + upCount + "/9)",getTextFormatExLeading(0xff9900,14,null,true,12));
			var tempColor:int;
			if(upCount >= 9)
			{
				addStringToField(LanguageManager.getWord("ssztl.activity.hasActivated"),getTextFormat(0x00ff00));
				tempColor = 0x00ff00;
			}	
			else
			{
				addStringToField(LanguageManager.getWord("ssztl.common.unActivity"),getTextFormat(0xff0000));
				tempColor = 0x939393;
			}
			var type:int;
			var type1:int;
			if(career == CareerType.SANWU) 
			{
				type = PropertyType.ATTR_MUMPHURTATT;
				type1 = PropertyType.ATTR_MUMPDEFENSE;
			}
			if(career == CareerType.XIAOYAO) 
			{
				type = PropertyType.ATTR_MAGICHURTATT;
				type1 = PropertyType.ATTR_MAGICDEFENCE;
			}
			if(career == CareerType.LIUXING) 
			{
				type = PropertyType.ATTR_FARHURTATT;
				type1 = PropertyType.ATTR_FARDEFENSE;
			}
			var strengthInfo:EquipStrengthTemplate = EquipStrengthTemplateList.getTemplate(level);
			if(strengthInfo)
			{
				
				if(strengthInfo.attack > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_ATTACK) + "：" +  strengthInfo.attack,getTextFormat(tempColor));
				if(strengthInfo.defence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_DEFENSE) + "：" +  strengthInfo.defence,getTextFormat(tempColor));
				if(strengthInfo.attrAttack > 0) addStringToField(PropertyType.getName(type) + "：" +  strengthInfo.attrAttack,getTextFormat(tempColor));
				if(strengthInfo.attrDefence > 0) addStringToField(PropertyType.getName(type1) + "：" +  strengthInfo.attrDefence,getTextFormat(tempColor));
				if(strengthInfo.hp > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_HP) + "：" +  strengthInfo.hp,getTextFormat(tempColor));
				if(strengthInfo.mp > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_MP) + "：" +  strengthInfo.mp,getTextFormat(tempColor));
				if(strengthInfo.defenceSuppress > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_SUPPRESSIVE_DEFEN) + "：" +  strengthInfo.defenceSuppress,getTextFormat(tempColor));
				if(strengthInfo.attrAttackPer > 0) addStringToField(PropertyType.getName(type) + "：" + strengthInfo.attrAttackPer/100 + "%",getTextFormat(tempColor));
				if(strengthInfo.mumpDefence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_MUMPDEFENSE) + "：" + strengthInfo.mumpDefence,getTextFormat(tempColor));
				if(strengthInfo.magicDefence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_MAGICDEFENCE)+ "：" + strengthInfo.magicDefence,getTextFormat(tempColor));
				if(strengthInfo.farDefence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_FARDEFENSE)+ "：" + strengthInfo.farDefence,getTextFormat(tempColor));
			}
			if( (level == 6 && tempColor == 0x939393) || (level == 12 && tempColor == 0x00ff00))
			{
				addLineBG();
			}
			else
			{
				//下一等级强化星级
				if(level == 6)
					level = 8;
				else
					level = level + 1;
				addLineBG();
				nextStarInfo(level);
				addLineBG();
			}
			addStringToField(LanguageManager.getWord("ssztl.common.attention"),getTextFormat(0xEDDB60));
			addStringToField(LanguageManager.getWord("ssztl.common.attentionDetail1",level),getTextFormat(0xEDDB60));
			addStringToField(LanguageManager.getWord("ssztl.common.attentionDetail2"),getTextFormat(0xEDDB60));
			show();
		}
		protected function nextStarInfo(lv:int):void
		{
			addStringToField(LanguageManager.getWord("ssztl.common.allEquipUp",lv) + "(" + upCount + "/9)",getTextFormatExLeading(0x939393,14,null,true,12));
			var type:int;
			var type1:int;
			var tempColor:int = 0x939393;
			if(career == CareerType.SANWU) 
			{
				type = PropertyType.ATTR_MUMPHURTATT;
				type1 = PropertyType.ATTR_MUMPDEFENSE;
			}
			if(career == CareerType.XIAOYAO) 
			{
				type = PropertyType.ATTR_MAGICHURTATT;
				type1 = PropertyType.ATTR_MAGICDEFENCE;
			}
			if(career == CareerType.LIUXING) 
			{
				type = PropertyType.ATTR_FARHURTATT;
				type1 = PropertyType.ATTR_FARDEFENSE;
			}
			var strengthInfo:EquipStrengthTemplate = EquipStrengthTemplateList.getTemplate(lv);
			if(strengthInfo)
			{
				
				if(strengthInfo.attack > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_ATTACK) + "：" +  strengthInfo.attack,getTextFormat(tempColor));
				if(strengthInfo.defence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_DEFENSE) + "：" +  strengthInfo.defence,getTextFormat(tempColor));
				if(strengthInfo.attrAttack > 0) addStringToField(PropertyType.getName(type) + "：" +  strengthInfo.attrAttack,getTextFormat(tempColor));
				if(strengthInfo.attrDefence > 0) addStringToField(PropertyType.getName(type1) + "：" +  strengthInfo.attrDefence,getTextFormat(tempColor));
				if(strengthInfo.hp > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_HP) + "：" +  strengthInfo.hp,getTextFormat(tempColor));
				if(strengthInfo.mp > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_MP) + "：" +  strengthInfo.mp,getTextFormat(tempColor));
				if(strengthInfo.defenceSuppress > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_SUPPRESSIVE_DEFEN) + "：" +  strengthInfo.defenceSuppress,getTextFormat(tempColor));
				if(strengthInfo.attrAttackPer > 0) addStringToField(PropertyType.getName(type) + "：" + strengthInfo.attrAttackPer/100 + "%",getTextFormat(tempColor));
				if(strengthInfo.mumpDefence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_MUMPDEFENSE) + "：" + strengthInfo.mumpDefence,getTextFormat(tempColor));
				if(strengthInfo.magicDefence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_MAGICDEFENCE)+ "：" + strengthInfo.magicDefence,getTextFormat(tempColor));
				if(strengthInfo.farDefence > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_FARDEFENSE)+ "：" + strengthInfo.farDefence,getTextFormat(tempColor));
			}
		}
		
		protected function addLineBG():void
		{
			var line:MCacheSplit2Line = new MCacheSplit2Line()
			line.x = 0;
			line.y = _text.textHeight+22;
			addChild(line);
			_lineBg.push(line);	
			addStringToField("\n",getTextFormat(0),false);
		}
		
		private function getPropertyString(property:PropertyInfo):String
		{
			var result:String = "";
			var type:int = property.propertyId;
			if(property.propertyId == PropertyType.ATTRIBUTE_ATTACK)
			{
				if(GlobalData.selfPlayer.career == CareerType.SANWU) type = PropertyType.ATTR_MUMPHURTATT;
				if(GlobalData.selfPlayer.career == CareerType.XIAOYAO) type = PropertyType.ATTR_MAGICHURTATT;
				if(GlobalData.selfPlayer.career == CareerType.LIUXING) type = PropertyType.ATTR_FARHURTATT;
			}
			result += PropertyType.getName(type) + "：";
			result += property.propertyValue;
			return result;
		}
		
		protected function getTextFormat(color:uint,size:int=12,blod:Boolean=false):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),size,color,blod,null,null,null,null,null,null,null,null,3);
		}
		
		protected function getTextFormatExLeading(color:uint,size:int=12,align:String = null,blod:Boolean=false,leading:int = 3):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),size,color,blod,null,null,null,null,align,null,null,null,leading);
		}
		
		override protected function clear():void
		{
			super.clear();
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
		}
		
		
		override public function dispose():void
		{
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