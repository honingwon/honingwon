/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-18 下午5:12:28 
 * 
 */ 
package sszt.character
{
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterInfo;

	public class BaseSceneCharacter extends LayerCharacter 
	{
		protected var _currentStyle:Array;
		protected var _getMounts:Boolean;
		protected var _strengthLevel:int;
		protected var _windStrengthLevel:int;
		protected var _hideWeapon:Boolean;
		protected var _hideSuit:Boolean;
		protected var _currentListType:Array;
		protected var _currentCareerSortType:Array;
		protected var _hasWing:Boolean = true;
		
		
		protected static var _career1:Array = [[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149],[]];
		
		protected static var _qiang_1:Array = [
			[3,10,11,13,14,15,19,21,22,23,24,27,29,30,31,32,37,38,39,46,47,48,49,66,67,68,69,76,77,78,79,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,138,139,140,141,142,143,144,145,146,147,148,149],
			[0,1,2,4,5,6,7,8,9,12,16,17,18,20,25,26,28,33,34,35,36,40,41,42,43,44,45,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,70,71,72,73,74,75,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137]
		]; 0.
		protected static var _qiang_2:Array = [
			[1,2,3,9,10,11,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,44,45,46,47,48,49,62,63,64,65,66,67,68,69,76,77,78,79,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,138,139,140,141,142,143,144,145,146,147,148,149],
			[0,4,5,6,7,8,12,13,40,41,42,43,50,51,52,53,54,55,56,57,58,59,60,61,70,71,72,73,74,75,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137]
		];
		protected static var _san_1:Array = [
			[0,1,2,3,4,6,7,8,9,10,11,16,17,18,19,26,37,40,41,42,43,44,45,50,51,52,53,54,55,56,57,70,71,72,73,74,75,80,81,82,83,84,85,86,87,90,91,92,93,94,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137],
			[5,12,13,14,15,20,21,22,23,24,25,27,28,29,30,31,32,33,34,35,36,38,39,46,47,48,49,58,59,60,61,62,63,64,65,66,67,68,69,76,77,78,79,88,89,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,138,139,140,141,142,143,144,145,146,147,148,149]];
		protected static var _san_2:Array = [
			[0,1,2,3,4,5,6,7,8,9,10,11,17,18,26,34,37,38,39,40,41,42,43,44,50,51,52,53,54,55,56,57,70,71,72,120,121,122,123,124,125,126,127,128,129,130,131],
			[12,13,14,15,16,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,45,46,47,48,49,58,59,60,61,62,63,64,65,66,67,68,69,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149]
		];
		protected static var _dao_1:Array = [
			[9,10,17,18,25,26,34,112,113,114,115,116,117,118,119],
			[0,1,2,3,4,5,6,7,8,11,12,13,14,15,16,19,20,21,22,23,24,27,28,29,30,31,32,33,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149]
		];
		protected static var _dao_2:Array = [
			[1,3,4,5,6,7,9,11,12,13,14,15,20,21,22,23,26,28,29,30,31,32,34,41,43,45,47,62,63,64,65,66,67,68,69,76,77,78,85,86,87,88,112,113,114,115,116118,119,139,140,141,142,143,144,145,146,147,148,149],
			[0,2,8,10,16,17,18,19,24,25,27,33,35,36,37,38,39,40,42,44,46,48,49,50,51,52,53,54,55,56,57,58,59,60,61,70,71,72,73,74,75,79,80,81,82,83,84,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,116,117,118,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,13]
		];
		
		protected static var _layerSort1:Array = [[3,1,0,2], [3,0, 1,2]];
		
		protected static var _layerSort2:Array = [[1,0,2], [0, 1,2]];
		
		protected function setListType():void
		{
			var index:int;
			if (this._currentStyle && this._currentStyle[1] != 0)
			{
				index = int(this._currentStyle[1]/1000);
				switch (index){
					case 211:
						this._currentListType =  _info.getSex() == 1 ?  _qiang_1 : _qiang_2;
						return;
					case 213:
						this._currentListType =  _info.getSex() == 1 ?  _san_1 : _san_2;
						return;
					case 212:
						this._currentListType =  _info.getSex() == 1 ?  _dao_1 : _dao_2;
						return;
						
				}
			} 
			else 
			{
				this._currentListType = _career1;
			}
		}
		
		public function BaseSceneCharacter(info:ICharacterInfo)
		{
			super(info);
			this._currentStyle = info.style.slice(0);
			this._getMounts = info.getMounts();
			this._strengthLevel = info.getWeaponStrength();
			this._windStrengthLevel = info.getWindStrength();
			this._hideWeapon = _info.getHideWeapon();
			this._hideSuit = _info.getHideSuit();
			this._currentCareerSortType = _layerSort1;
			this.setListType();
		}
		
		
		override protected function characterUpdateHandler(evt:CharacterEvent):void
		{
			if (_info == null || !this._getMounts == _info.getMounts())
			{
				return;
			}
			if (this._currentStyle[0] == _info.style[0] 
				&& this._currentStyle[1] == _info.style[1]
				&& this._currentStyle[2] == _info.style[2] 
				&& this._currentStyle[3] == _info.style[3] 
				&& this._strengthLevel == _info.getWeaponStrength() 
				&& this._windStrengthLevel == _info.getWindStrength()
				&& this._hideWeapon == _info.getHideWeapon()
				&& this._hideSuit == _info.getHideSuit()
			
			){
				return;
			}
			this._currentStyle = _info.style.slice(0);
			this._strengthLevel = _info.getWeaponStrength();
			this._windStrengthLevel = _info.getWindStrength();
			this._hideWeapon = _info.getHideWeapon();
			this._hideSuit = _info.getHideSuit();
			this.setListType();
			_actionController.stop();
			clearDatas();
			initLoadingAsset();
			_loader.load(showComplete);
		}
		
		
	}
}