package sszt.interfaces.character
{
	import flash.events.IEventDispatcher;
	
	public interface ICharacterInfo extends IEventDispatcher
	{
		function get characterId():uint;

		/**
		 * 衣服，武器，骑宠，翅膀
		 * @return 
		 * 
		 */		
		function get style():Array;
		function getSex():int;
		function getCareer():int;

		/**
		 * 是否有坐骑
		 * @return 
		 * 
		 */		
		function getMounts():Boolean;
		/**
		 * 传入layerType,返回对应的单元图片长宽
		 * @param type
		 * @return 
		 * 
		 */		
		function getPicWidth():int;
		function getPicHeight():int;
		/**
		 * 身上的装备样式ID
		 * @return 
		 * 
		 */	
		function getPartStyle(categoryId:int):int;
		
		
		/**
		 * 通过模版ID去找物品模版
		 * @param id
		 * @return 
		 * 
		 */		
		function getLayerInfoById(id:int):ILayerInfo;
		/**
		 * 取默认装备（脱光显示用）
		 * @param category
		 * @return 
		 * 
		 */		
		function getDefaultLayer(category:int):ILayerInfo;
		/**
		 * 默认动作 作废
		 * @return 
		 * 
		 */		
		function getDefaultAction(type:String):ICharacterActionInfo;
		
		/**
		 *  默认动作
		 * @param type
		 * @return 
		 * 
		 */		
		function getDefaultActionType(type:String):int;
		
		/**
		 * 武器强化等级
		 * @return 
		 * 
		 */		
		function getWeaponStrength():int;
		/**
		 * 翅膀强化等级
		 * @return 
		 * 
		 */		
		function getWindStrength():int;
		/**
		 * 坐骑强化等级 
		 * @return 
		 * 
		 */		
		function getMountsStrengthLevel():int;
		
		function getHideWeapon():Boolean;
		function getHideSuit():Boolean;
		
		/**
		 * 获取帧频 
		 * @param actionType
		 * @return 
		 * 
		 */		
		function getFrameRate(actionType:int):int;
	}
}