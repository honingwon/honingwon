package sszt.skill.components
{
	public interface ISkillTabPanel
	{
		function move(x:Number,y:Number):void;
		function show():void;
		function hide():void;
		function dispose():void;
		function assetsCompleteHandler():void;
	}
}