package sszt.club.components.clubMain.pop.manage.war
{
	public interface IWarPanel
	{
		function show():void;
		function hide():void;
		function dispose():void;
		function move(argX:int,argY:int):void;
	}
}