package sszt.core.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.socketHandlers.pay.QQBugGoodsSocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;

	public class JSUtils
	{
		/**
		 * 添加收藏
		 * 
		 */		
		public static function addFavorite():void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("AddFavorite",GlobalAPI.pathManager.getOfficalPath(),CommonConfig.FAVORITENAME);
				}
				catch(e:Error){}
			}
		}
		
		/**
		 * 关闭页面是否询问
		 * @param ask
		 * 
		 */		
		public static function setCloseState(ask:Boolean = true):void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("SetState",ask ? 0 : 1);
				}
				catch(e:Error){}
				
			}
		}
		/**
		 * 关闭时弹开收藏提示
		 * @param favorite
		 * 
		 */		
		public static function setFavoriteState(favorite:Boolean = true):void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("SetState",favorite ? 2 : 1);
				}
				catch(e:Error){}
				
			}
		}
		
		/**
		 * 页面跳转
		 * @param path
		 * @param self
		 * 
		 */		
		public static function gotoPage(path:String,self:Boolean = false):void
		{
			navigateToURL(new URLRequest(path),self ? "_self" : "_blank");
		}
		
		public static function gotoPage2(url:URLRequest,self:Boolean = false):void
		{
			navigateToURL(url,self ? "_self" : "_blank");
		}
		
		public static function gotoFill():void
		{
//			BuyPanel.getInstance().show([206100,206102,206103],new ToStoreData(ShopID.STORE));
//			if(ExternalInterface.available)
//			{
//				try
//				{
//					ExternalInterface.call("qq_game.fusionPay");
//				}
//				catch(e:Error){}
//			}
			
			if(GlobalData.functionYellowEnabled)
				SetModuleUtils.addStore(new ToStoreData(2));
			else
				JSUtils.gotoPage(GlobalData.fillPath2);
//			var path:String = GlobalAPI.pathManager.getFillPath();
//			path = path.split("{user}").join(GlobalData.tmpUserName).split("{server_id}").join(String(GlobalData.selfPlayer.serverId));
//			gotoPage(path,false);
		}
		
		public static function gotoPayYellow():void
		{
			var path:String = GlobalAPI.pathManager.getPayYellowPath();
			gotoPage(path,false);
		}
		
		public static function gotoPayYellowYeay():void
		{
			var path:String = GlobalAPI.pathManager.getPayYellowYeayPath();
			gotoPage(path,false);
		}
		
		public static function gotoActivityCode():void
		{
			gotoPage(GlobalAPI.pathManager.getActivityCode(),false);
		}
		
		public static function gotoLuckCode():void
		{
			gotoPage(GlobalAPI.pathManager.getLuckCode(),false);
		}
		
		public static function gotoLuckCodeTwo():void
		{
			gotoPage(GlobalAPI.pathManager.getLuckCodeTwo(),false);
		}
		
		public static function doFullScene():void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("doFullScene");
				}
				catch(e:Error){}
			}
		}
		public static function exitFullScene():void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("exitFullScene");
				}
				catch(e:Error){}
			}
		}
		
		public static function reloadPage():void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("reloadPage");
				}
				catch(e:Error){}
			}
		}
		
		/**
		 * 修改成服务端 
		 * @param itemId
		 * @param itemNum
		 * 
		 */		
		public static function funPayToken(itemId:int,itemNum:int=3):void
		{
			QQBugGoodsSocketHandler.send(GlobalData.tmpZoneId,GlobalData.tmpDomain,itemId,itemNum,GlobalData.tmpOpenKey,GlobalData.tmpPf,GlobalData.tmpPfKey);
		}
		
		public static function dialogBuy(obj:Object):void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("qq_game.dialogBuy",obj);
				}
				catch(e:Error){}
			}
		}
		
		public static function inviteFreind():void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("qq_game.inviteFriend");
				}
				catch(e:Error){}
			}
		}
		
		/**
		 * 分享 
		 * 
		 */		
		public static function shareInside(type:int):void
		{
			if(ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("qq_game.shareInside",type);
				}
				catch(e:Error){}
			}
		}
	}
}


