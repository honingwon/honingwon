package sszt.core.view.tips
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import sszt.constData.CareerType;
	import sszt.constData.PropertyType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.PropertyInfo;
	import sszt.core.data.pet.PetStarTemplate;
	import sszt.core.data.pet.PetStarTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	public class PetStarLevelTip extends BaseDynamicTip
	{
		public static var instance:PetStarLevelTip;//当前tips的一个实例
		private var _lineBg:Array;//线条背景
		private var _templateId:int;
		private var _starLevel:int;
		
		
		public function PetStarLevelTip()
		{
			super();
			_lineBg = new Array();
		}
		
		public static function getInstance():PetStarLevelTip
		{
			if( instance == null )
			{
				instance = new PetStarLevelTip();
			}
			
			return instance;
		}
		
		private function keyIsDownHandler(evt:KeyboardEvent):void
		{
			hide();
		}
		
		override public function hide():void
		{
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
			super.clear();
			if(parent) parent.removeChild(this);
		}
		
		//启动块
		public function showTip(template_id:int,star_level:int,pos:Point):void
		{
			this._templateId = template_id;
			this._starLevel = star_level;
			setTip();
			if(!parent) GlobalAPI.layerManager.getTipLayer().addChild(this);
			this.x = pos.x;
			this.y = pos.y;
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
		}
		
		public function getDataStr(template_id:int,star_level:int):String
		{
			this._templateId = template_id;
			this._starLevel = star_level;
			
			var tipStr:String = "";
			
			if(_starLevel>0)
			{
				tipStr += "<font color='#ff9900' size='13'><b>" + LanguageManager.getWord("ssztl.mounts.starLevel",_starLevel) + " " + LanguageManager.getWord("ssztl.mounts.aptitude",_starLevel*10) + "</b></font>\n";
				tipStr += "<font color='#0099ff'>" + LanguageManager.getWord("ssztl.activity.hasActivated") + "</font>\n";
				tipStr += "<font color='#33cc00'>" + getProperty(_starLevel) + "</font>\n\n";
			}
			tipStr += "<font color='#777164' size='13'><b>" + LanguageManager.getWord("ssztl.mounts.starLevel",_starLevel+1) + " " + LanguageManager.getWord("ssztl.mounts.aptitude",(_starLevel+1)*10) + "</b></font>\n";
			if(_starLevel==0) tipStr += "<font color='#ff3333'>" + LanguageManager.getWord("ssztl.common.unActivity") + "</font>\n";
			tipStr += "<font color='#777164'>" + getProperty(_starLevel+1) + "</font>\n\n";
			
			tipStr += "<font color='#bb8050'>" + LanguageManager.getWord("ssztl.common.attention") + "\n";
			tipStr += LanguageManager.getWord("ssztl.pet.attentionStarLevelTip1") + "\n";
			tipStr += LanguageManager.getWord("ssztl.pet.attentionStarLevelTip2") + "</font>";
			
			return tipStr;
		}
		private function getProperty(d:int):String
		{
			var tipStr:String = "";
			
			var petInfo:PetStarTemplate = PetStarTemplateList.getStarInfo(_templateId,d);
			if(petInfo)
			{
				if(petInfo.attack > 0) tipStr += PropertyType.getName(PropertyType.ATTR_ATTACK) + " +" +  petInfo.attack + "\n";
				if(petInfo.hit > 0)  tipStr += PropertyType.getName(PropertyType.ATTR_HITTARGET) + " +" +  petInfo.hit;
			}
			return tipStr;
		}
		
		private function setTip():void
		{
			currentInfo();
			nextInfo();
			
			addLineBG();
			addStringToField(LanguageManager.getWord("ssztl.common.attention"),getTextFormat(0xEDDB60));
			addStringToField(LanguageManager.getWord("ssztl.pet.attentionStarLevelTip1"),getTextFormat(0xEDDB60));
			addStringToField(LanguageManager.getWord("ssztl.pet.attentionStarLevelTip2"),getTextFormat(0xEDDB60));
			show();
		}
		
		private function currentInfo():void
		{
			addStringToField(LanguageManager.getWord("ssztl.mounts.starLevel",_starLevel)+LanguageManager.getWord("ssztl.mounts.aptitude",_starLevel*10),getTextFormatExLeading(0xff9900,14,null,true,12));
			var tempColor:int;
			if(_starLevel >= 0)
			{
				addStringToField(LanguageManager.getWord("ssztl.activity.hasActivated"),getTextFormat(0x00ff00));
				tempColor = 0x00ff00;
			}	
			else
			{
				addStringToField(LanguageManager.getWord("ssztl.common.unActivity"),getTextFormat(0xff0000));
				tempColor = 0x939393;
			}
			
			
			var petInfo:PetStarTemplate = PetStarTemplateList.getStarInfo(_templateId,_starLevel);
			if(petInfo)
			{
				if(petInfo.attack > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_ATTACK) + "：+" +  petInfo.attack, getTextFormat(tempColor));
				if(petInfo.hit > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_HITTARGET) + "：+" +  petInfo.hit, getTextFormat(tempColor));
			}
			
			addLineBG();
		}
		
		private function nextInfo():void
		{
			addStringToField(LanguageManager.getWord("ssztl.mounts.starLevel",(_starLevel + 1))+LanguageManager.getWord("ssztl.mounts.aptitude",(_starLevel + 1)*10),getTextFormatExLeading(0x939393,14,null,true,12));
			var tempColor:int = 0x939393;
			
			var petInfo:PetStarTemplate = PetStarTemplateList.getStarInfo(_templateId,_starLevel+1);
			if(petInfo)
			{
				if(petInfo.attack > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_ATTACK) + "：+" +  petInfo.attack, getTextFormat(tempColor));
				if(petInfo.hit > 0) addStringToField(PropertyType.getName(PropertyType.ATTR_HITTARGET) + "：+" +  petInfo.hit, getTextFormat(tempColor));
			}
		}
		
		//线条图片实现块
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
		
		//销毁块
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
		//销毁块
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