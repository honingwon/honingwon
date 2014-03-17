package sszt.rank.mediator
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.rank.RankModule;
	import sszt.rank.components.RankPanel;
	import sszt.rank.data.RankType;
	import sszt.rank.events.RankMediatorEvents;
	import sszt.rank.socketHandlers.ShenMoIslandRankQueryHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class RankMediator extends Mediator
	{
		private var _dataLoader:URLLoader;
		
		public static const NAME:String = "rankMediator";
		public function RankMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				RankMediatorEvents.SHOW_RANK_PANEL,
				RankMediatorEvents.RANK_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case RankMediatorEvents.SHOW_RANK_PANEL:
					showRank();
					break;
				case RankMediatorEvents.RANK_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		//打开或关闭排行榜
		private function showRank():void
		{
			if(rankModule.rankPanel == null)
			{
				rankModule.rankPanel = new RankPanel(this, rankModule.rankInfos);
				rankModule.rankPanel.addEventListener(Event.CLOSE, rankCloseHandler);
				GlobalAPI.layerManager.addPanel(rankModule.rankPanel);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != rankModule.rankPanel)
				{
					rankModule.rankPanel.setToTop();
				}
				else
				{
					rankModule.rankPanel.dispose();
				}
			}
		}
		
		private function rankCloseHandler(evt:Event):void
		{
			if(rankModule.rankPanel)
			{
				rankModule.rankPanel.removeEventListener(Event.CLOSE, rankCloseHandler);
				rankModule.rankPanel = null;
				rankModule.dispose();
			}
		}
		
		public function loadData(name:String):void
		{
			_dataLoader = new URLLoader();
			_dataLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_dataLoader.addEventListener(Event.COMPLETE,loaderCompleteHandler,false,0,true);
			_dataLoader.addEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler,false,0,true);
			
//			loader.load(new URLRequest(GlobalAPI.pathManager.getRankPath(name)));
			try
			{
				_dataLoader.load(new URLRequest("rank/" + name + ".xml?" + Math.random()));
			}
			catch(e:Error){}
			function loaderCompleteHandler(evt:Event):void
			{
				try
				{
					if(_dataLoader == null)return;
					_dataLoader.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
					_dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler);
					if(_dataLoader == null || rankModule == null)return;
					var data:ByteArray = _dataLoader.data as ByteArray;
					if(data == null)return;
					data.position = 0;
					var xmlData:XML = XML(data.readUTFBytes(data.length));
					
//					rankModule.rankInfos.readRankData(name,xmlData);
				}
				catch(e:Error)
				{
					
				}
				
//				var rankType:int = parseInt(name.substr(0,2));
//				switch(rankType)
//				{
//					case RankType.INDIVIDUAL_RANK:
//						rankModule.rankInfos.readIndividualRank(name,xmlData);
//						break;
//					case RankType.CLUB_RANK:
//						rankModule.rankInfos.readClubRank(name,xmlData);
//						break;	
//				}
			}
			
			function loaderErrorHandler(evt:IOErrorEvent):void
			{
				_dataLoader.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
				_dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler);
			}
		}
		
		public function shenMoIslandQuery():void
		{
			ShenMoIslandRankQueryHandler.sendQuery();
		}
		
		public function get rankModule():RankModule
		{
			return viewComponent as RankModule;
		}
		
		public function dispose():void
		{
			if(_dataLoader)
			{
				_dataLoader = null;
			}
			viewComponent = null;
		}
	}
}