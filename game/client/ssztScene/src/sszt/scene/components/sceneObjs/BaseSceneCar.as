package sszt.scene.components.sceneObjs
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import scene.sceneObjs.BaseSceneObj;
	
	import sszt.constData.ActionType;
	import sszt.core.data.CarInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.characterActionInfos.SceneCarActionInfo;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.data.SceneCarListUpdateEvent;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	
	public class BaseSceneCar extends BaseRole
	{		
		public function BaseSceneCar(info:BaseSceneCarInfo)
		{
			super(info);
		}
		
		override protected function init():void
		{
			super.init();
			mouseChildren = mouseChildren = tabEnabled = false;
			tabChildren = false;
			_mouseAvoid = true;
			
			_character = GlobalAPI.characterManager.createCarCharacter(new CarInfo(getCarInfo().quality));
//			_character = GlobalAPI.characterManager.createCarCharacterPool(new CarInfo()) as ICharacter;
			_character.show();
//			_character.move(-185,-230);
			addChild(_character as DisplayObject);
			
			nick.y = titleY - 20;
			nick.htmlText = "<font color='" + getColor(getCarInfo().quality) + "'>" + getNick(getCarInfo().name) + "</font>";
		}
		
		
		private function getNick(name:String):String
		{
			var re:String;
			switch(getCarInfo().quality)
			{
				case 0:return LanguageManager.getWord("ssztl.scene.playerTransportCar","["+name+"]");
				case 1:return LanguageManager.getWord("ssztl.scene.playerTransportCar1","["+name+"]");
				case 2:return LanguageManager.getWord("ssztl.scene.playerTransportCar2","["+name+"]");
				case 3:return LanguageManager.getWord("ssztl.scene.playerTransportCar3","["+name+"]");
				case 4:return LanguageManager.getWord("ssztl.scene.playerTransportCar4","["+name+"]");
			}
			return  LanguageManager.getWord("ssztl.scene.playerTransportCar","["+name+"]");
		}
			
		
		
		override public function get titleY():Number
		{
			switch(getCarInfo().quality)
			{
				case 0:return -300;
				case 1:return -300;
				case 2:return -300;
				case 3:return -300;
				case 4:return -300;
			}
			return -300;
		}
		
		private function getColor(quality:int):String
		{
			switch(quality)
			{
				case 0:return "#ffffff";
				case 1:return "#80ff2b";
				case 2:return "#00eaff";
				case 3:return "#ff49f4";
				case 4:return "#ffcc00";
			}
			return "";
		}
		
		public function getCarInfo():BaseSceneCarInfo
		{
			return _info as BaseSceneCarInfo;
		}
		
		override protected function walkStartHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			super.walkStartHandler(evt);
			doWalkAction();
		}
		
		override public function doWalkAction():void
		{
			if(_character.currentAction && _character.currentAction.actionType != ActionType.WALK)
				_character.doActionType(ActionType.WALK);
		}
		
		override protected function walkComplete():void
		{
			super.walkComplete();
			_character.doActionType(ActionType.STAND);
		}
		
		override public function dispose():void
		{
//			if(_character)
//			{
//				_character.dispose();
//				_character = null;
//			}
			super.dispose();
		}
	}
}