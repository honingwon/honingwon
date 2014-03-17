package sszt.interfaces.path
{
	public interface IPathManager
	{
		/**
		 * 模块资源地址和类地址
		 * @param moduleId
		 * @return 
		 * 
		 */		
		function getModulePath(moduleId:int):String;
		/**
		 * 获得该模板id的模板路径地址
		 * @param moduleId 模板id
		 * @return 模板路径地址
		 * 
		 */
		function getModuleClassPath(moduleId:int):String;
		/**
		 * 获得该模板id的swf资源的数组 
		 * @param moduleId 模板id
		 * @return 模板id的swf资源的数组
		 */
		function getModulAssetsPath(moduleId:int):Array;
		 
		/**
		 * 物品资源地址和类地址
		 * @param pic
		 * @param layerType
		 * @param hatType
		 * @return 
		 * 
		 */		
		function getItemPath(path:String,layerType:String,dir:int = 0,action:int = 0):String;
		function getDisplayItemPath(path:String,layerType:String):String;
		function getFunctionGuidePath(path:String):String
		function getItemClassPath(path:String,layerType:String):String;
		function getSceneItemsPath(path:String,layerType:String):String;
		function getSceneMonsterItemsPath(path:String):String;
		function getSceneMonsterShowPath(path:String):String;
		function getSceneNpcItemsPath(path:String):String;
		function getSceneNpcAvatarPath(path:String):String;
		function getTargetPath(path:String):String;
		function getChallengePath(path:String):String;
		function getSceneCarItemPath(path:String):String;
		function getSceneCollectItemPath(path:String):String;
		/**
		 * 公用音效（比如按钮点击等等）
		 * @return 
		 * 
		 */		
		function getCommonSoundPath():String;
		function getSoundClassPath(path:String):String;
		function getMusicPath(music:int):String;
		function getFacePath():String;
		/**
		 * 等待loading资源
		 * @return 
		 * 
		 */		
		function getWaitingPath(type:int):String;
		function getWaitingClassPath(type:int):String;
		/**
		 * 压缩配置文件地址
		 * @return 
		 * 
		 */		
		function getConfigZipPath():String;
		/**
		 * 场景路径
		 * @return 
		 * 
		 */		
		function getSceneConfigPath(picPath:String):String;
		function getScenePreMapPath(path:String):String;
		function getScenePreMapClassPath(id:int):String;
		function getSceneDetailMapPath(path:String,row:int,col:int):String;
		function getSceneDetailMapClassPath(id:int,row:int,col:int):String;
		function getScenePetItemPath(path:String,layerType:String):String;
		function getSceneSpaPath(sex:int):String;
		function getSceneSwimPath(sex:int):String;
//		function getSceneUnwalkClassPath(picPath:String):String;
//		function getSceneDetailClassPath(id:int,x:int,y:int):String;
		
		/**
		 * 获取商城美女图片地址
		 * @return 
		 * 
		 */		
		function getStorePeriPath():String;
		
		/**
		 * 获取活动提醒banner图片地址
		 * @return 
		 * 
		 */		
		function getActivityBannerPath(id:int):String;
		/**
		 * 获取banner目录下的图片
		 * @return 
		 * 
		 */	
		function getBannerPath(name:String):String;
		
		/**
		 * 获取世界BOSS头像及大图片地址
		 * @return 
		 * 
		 */		
		function getWorldBossPath(name:String):String;
		
		/**
		 * 获取资源地址
		 * @return 
		 * 
		 */		
		function getAssetPath(path:String):String;
		
		/**
		 * 登陆游戏地址
		 * @return 
		 * 
		 */		
		function getLoginPath():String;
		/**
		 * 排行版地址
		 * @return 
		 * 
		 */		
		function getRankPath():String;
		/**
		 * 网站登陆地址
		 * @return 
		 * 
		 */		
		function getWebLoginPath():String;
		/**
		 * 官网地址
		 * @return 
		 * 
		 */		
		function getOfficalPath():String;
		/**
		 * 选F地址
		 * @return 
		 * 
		 */		
		function getSelectServerPath():String;
		/**
		 * 论坛地址
		 * @return 
		 * 
		 */		
		function getBBSPath():String;
		/**
		 * 注册页面
		 * @return 
		 * 
		 */		
		function getRegisterPath():String;
		/**
		 * 充值地址
		 * @return 
		 * 
		 */		
		function getFillPath():String;
		/**
		 * 新手卡激活码页面
		 * @return 
		 * 
		 */		
		function getActivityCode():String;
		/**
		 * 媒体礼包激活码页面
		 * @return 
		 * 
		 */		
		function getLuckCode():String;
		/**
		 * 类型2媒体礼包激活码页面
		 * @return 
		 * 
		 */
		function getLuckCodeTwo():String;
		/**
		 * 统计地址
		 * @return 
		 * 
		 */		
		function getStatPath():String;
		/**
		 * 动画地址
		 * @param path
		 * @return 
		 * 
		 */		
		function getMoviePath(path:String):String;
		/**
		 * 页面地址
		 * @param path
		 * @return 
		 * 
		 */		
		function getWebServicePath(path:String):String;
		/**
		 * 语言包地址
		 * @return 
		 * 
		 */		
		function getLanagerPath(type:String):String;
		/**
		 * 防沉迷地址
		 * @return 
		 * 
		 */		
		function getAdlsPath():String;
		/**
		 *GM链接地址 
		 * @return 
		 * 
		 */		
		function getGMLinkPath():String;
		
		/**
		 * facebook查询链接
		 * @return 
		 * 
		 */		
		function getFacebookQueryPath(id:String,serverId:int,nick:String):String
			
		
		/**
		 *  开通黄钻/续费黄钻 地址
		 * @return 
		 * 
		 */			
		function getPayYellowPath():String;
		
		/**
		 * 开通年费黄钻/续费年费黄钻 地址  
		 * @return 
		 * 
		 */		
		function getPayYellowYeayPath():String;
			
//		/**
//		 * 场景NPC地址
//		 * @param path
//		 * @return 
//		 * 
//		 */		
//		function getSceneNpcPath(path:String):String;
//		function getSceneNpcClassPath(path:String):String;
//		/**
//		 * 场景跳点地址
//		 * @param path
//		 * @return 
//		 * 
//		 */		
//		function getSceneJumpPath(path:String):String;
//		function getSceneJumpClassPath(path:String):String;
	}
}