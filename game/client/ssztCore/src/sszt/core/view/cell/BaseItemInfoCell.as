package sszt.core.view.cell
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffectPool;
	import sszt.core.view.effects.BaseQuealityMoveEffectPool;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class BaseItemInfoCell extends BaseCell
	{
		protected var _iteminfo:ItemInfo;
		protected var _qualitEffect:BaseLoadEffectPool;
		
		public function BaseItemInfoCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		public function get itemInfo():ItemInfo
		{
			return _iteminfo;
		}
		
		public function set itemInfo(value:ItemInfo):void
		{
			if(_iteminfo == value)return;
			if(_iteminfo)
			{
				_iteminfo.removeEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,lockUpdateHandler);
			}
			_iteminfo = value;
			if(_iteminfo)
			{
				_iteminfo.addEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,lockUpdateHandler);
				info = _iteminfo.template;
			}
			else
			{
				info = null;
			}
			
		}
		
		
		
		override protected function clearEffect():void
		{
			if(_qualitEffect && _qualitEffect.parent)
			{
				_qualitEffect.parent.removeChild(_qualitEffect as DisplayObject);
				_qualitEffect.collect();
				_qualitEffect = null;
			}
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setItemLock();
			
			if(_iteminfo && _iteminfo.isBind)
			{
				_lockPic.bitmapData = AssetUtil.getAsset("ssztui.common.GoodsLockIconAsset") as BitmapData;
				if(!_lockPic.parent) addChild(_lockPic);
			}
			
		}
		
		override protected function updatePicGrayFilters():void
		{
			super.updatePicGrayFilters();
			if(_info is SkillTemplateInfo)return;
			if(CategoryType.isEquip((_info as ItemTemplateInfo).categoryId))
			{
				if((_info as ItemTemplateInfo).quality > 0 && _iteminfo.strengthenLevel>=6)
				{
					var movieInfo:MovieTemplateInfo = MovieTemplateList.getMovie((_info as ItemTemplateInfo).quality + 500);
					if(movieInfo)
					{
						_qualitEffect = CommonEffectPoolManager.baseLoaderEffectManager.getObj([movieInfo]) as BaseLoadEffectPool;
					}
//					switch((_info as ItemTemplateInfo).quality)
//					{
//						case 1:
//							_qualitEffect = CommonEffectPoolManager.baseLoaderEffectManager.getObj([movieInfo]) as BaseLoadEffectPool;
//							_qualitEffect = CommonEffectPoolManager.qualityMoveEffectManager1.getObj(null) as BaseQuealityMoveEffectPool;
//							break;
//						case 2:
//							_qualitEffect = CommonEffectPoolManager.qualityMoveEffectManager2.getObj(null) as BaseQuealityMoveEffectPool;
//							break;
//						case 3:
//							_qualitEffect = CommonEffectPoolManager.qualityMoveEffectManager3.getObj(null) as BaseQuealityMoveEffectPool;
//							break;
//						case 4:
//							_qualitEffect = CommonEffectPoolManager.qualityMoveEffectManager4.getObj(null) as BaseQuealityMoveEffectPool;
//							break;
//						default:
//							_qualitEffect = CommonEffectPoolManager.qualityMoveEffectManager1.getObj(null) as BaseQuealityMoveEffectPool;
//							break;
//					}
					_qualitEffect.play(SourceClearType.NEVER);
					_qualitEffect.move( _pic.x + (_figureBound.width )/2,_pic.y + (_figureBound.height )/2);
					if(!_qualitEffect.parent) addChild(_qualitEffect as DisplayObject);
				}
			}
		}
		
		protected function setItemLock():void
		{
			if(_iteminfo)
				locked = _iteminfo.lock;
		}
		
		protected function lockUpdateHandler(evt:ItemInfoUpdateEvent):void
		{
			if(_iteminfo)
			{
				locked = _iteminfo.lock;
			}
		}
		
		override public function getSourceData():Object
		{
			return itemInfo;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(itemInfo)
				TipsUtil.getInstance().show(itemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			else if(info)
				TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(itemInfo || info)TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			hideTipHandler(null);
			if(_iteminfo)
			{
				_iteminfo.removeEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,lockUpdateHandler);
			}
			_iteminfo = null;
		
			if(_qualitEffect && _qualitEffect.parent)
			{
				_qualitEffect.parent.removeChild(_qualitEffect as DisplayObject);
				_qualitEffect.collect();
				_qualitEffect = null;
			}
			super.dispose();
		}
	}
}