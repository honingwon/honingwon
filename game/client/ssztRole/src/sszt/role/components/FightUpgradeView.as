package sszt.role.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.role.FightItemDotAsset;

	public class FightUpgradeView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _bgMap:Bitmap;
		private var _tagMap:Bitmap;
		private var _itemOver:Bitmap;
		private var _picon:Array;
		
		private var _parents:Array;
		private var _sons:Array;
		private var _currentPt:int;
		private var _links:Array;
		
		private var _label1:Array;
		private var _label2:Array;
		
		private var _pos:Point = new Point(4,32);
		
		private var _closeBtn:MCacheAssetBtn1;
		
		public function FightUpgradeView()
		{
			_bgMap = new Bitmap();
			addChild(_bgMap);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(1,3,156,26)),
			]);
			addChild(_bg as DisplayObject);
			
			_tagMap = new Bitmap();
			_tagMap.x = 33;
			_tagMap.y = 7;
			addChild(_tagMap);
			
			_closeBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.return"));
			_closeBtn.move(47,337);
			addChild(_closeBtn);
			
			_itemOver = new Bitmap();
			_itemOver.x = _pos.x;
			addChild(_itemOver);
			_itemOver.visible = false;
			
			_label1 = [
				LanguageManager.getWord("ssztl.common.equip2")+LanguageManager.getWord("ssztl.common.furnaceModule"),
				LanguageManager.getWord("ssztl.common.munts"),
				LanguageManager.getWord("ssztl.common.pet"),
				LanguageManager.getWord("ssztl.common.upgrade")+LanguageManager.getWord("ssztl.role.veins"),
				LanguageManager.getWord("ssztl.common.upgrade")+LanguageManager.getWord("ssztl.skill.skill")
			];
			_label2 = [
				[LanguageManager.getWord("ssztl.furnace.strengthEquip"),LanguageManager.getWord("ssztl.furnace.rebuildEquip"),LanguageManager.getWord("ssztl.furnace.equipUplevel"),LanguageManager.getWord("ssztl.furnace.equipUpgrade"),LanguageManager.getWord("ssztl.furnace.enchaseStone")],
				[LanguageManager.getWord("ssztl.role.getfightTip1"),LanguageManager.getWord("ssztl.common.growLabel"),LanguageManager.getWord("ssztl.common.qualityLabel"),LanguageManager.getWord("ssztl.common.stairs")],
				[LanguageManager.getWord("ssztl.role.getfightTip2"),LanguageManager.getWord("ssztl.common.growLabel"),LanguageManager.getWord("ssztl.common.qualityLabel"),LanguageManager.getWord("ssztl.common.stairs")],
				[],
				[LanguageManager.getWord("ssztl.skill.careerSkill"),LanguageManager.getWord("ssztl.club.clubSkill")]
			];
			_currentPt = -1;
			_parents = [];
			_sons = [];
			_picon = [];
			_links = [];
			for(var i:int=0; i<5; i++)
			{
				_parents.push(addParentItem(i));
				_sons.push(addSonsItem(i));
			}
			initEvent();
		}
		private function addParentItem(n:Number):MSprite
		{
			var con:MSprite = new MSprite;
			con.move(_pos.x, _pos.y + n*37);
			con.buttonMode = true;
			addChild(con);
			con.graphics.beginFill(0,0);
			con.graphics.drawRect(0,0,150,36);
			con.graphics.endFill();			
			con.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,35,158,2),new MCacheSplit2Line()));
			
			var icon:Bitmap = new Bitmap();
			icon.x = 2;
			icon.y = 4;
			con.addChild(icon);
			_picon.push(icon);
			
			var tag:MAssetLabel = new MAssetLabel(_label1[n],MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			tag.textColor = 0xb18a56;
			tag.move(34,10);
			con.addChild(tag);
			
			return con;
		}
		private function addSonsItem(n:Number):MSprite
		{
			var con:MSprite = new MSprite;
			con.move(_pos.x, _pos.y + (n+1)*37);
			addChild(con);
			con.visible = false;
			
			var list:Array = _label2[n];
			for(var i:int=0; i<list.length; i++)
			{
				con.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(19,5+i*21,10,10),new Bitmap(new FightItemDotAsset())));		
				var tag:MAssetLabel = new MAssetLabel(list[i],MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				tag.textColor = 0xecd099;
				tag.move(34,21*i+2);
				con.addChild(tag);
				
				var link:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				link.textColor = 0xe96c28;
				link.move(115,21*i+2);
				link.setHtmlValue("<u>"+LanguageManager.getWord("ssztl.role.getfightTip3")+"</u>");
				con.addChild(link);
				
				var linkBtn:Sprite = new Sprite();
				linkBtn.graphics.beginFill(0,0);
				linkBtn.graphics.drawRect(112,21*i+2,30,16);
				linkBtn.graphics.endFill();
				con.addChild(linkBtn);
				linkBtn.buttonMode = true;
				_links.push(linkBtn);
			}
			return con;
		}
		public function assetsCompleteHandler():void
		{
			_bgMap.bitmapData = AssetUtil.getAsset("ssztui.role.RoleSideBgAsset",BitmapData) as BitmapData;
			_tagMap.bitmapData = AssetUtil.getAsset("ssztui.role.RoleFightUpTitleAsset",BitmapData) as BitmapData;
			_itemOver.bitmapData = AssetUtil.getAsset("ssztui.role.FightItemOverAsset",BitmapData) as BitmapData;
			for(var i:int = 0; i<5; i++)
			{
				_picon[i].bitmapData = AssetUtil.getAsset("ssztui.role.FightItemAsset"+i,BitmapData) as BitmapData;
			}
		}
		
		private function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			for(var i:int = 0; i<5; i++)
			{
				_parents[i].addEventListener(MouseEvent.MOUSE_OVER,parentOverHandler);
				_parents[i].addEventListener(MouseEvent.MOUSE_OUT,parentOutHandler);
				
				_parents[i].addEventListener(MouseEvent.CLICK,parentClickHandler);
			}
			for(i=0; i<_links.length; i++)
			{
				_links[i].addEventListener(MouseEvent.CLICK,linkClickHandler);
			}
		}
		private function removeEvent():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			for(var i:int = 0; i<5; i++)
			{
				_parents[i].removeEventListener(MouseEvent.MOUSE_OVER,parentOverHandler);
				_parents[i].removeEventListener(MouseEvent.MOUSE_OUT,parentOutHandler);
				
				_parents[i].removeEventListener(MouseEvent.CLICK,parentClickHandler);
			}
			for(i=0; i<_links.length; i++)
			{
				_links[i].removeEventListener(MouseEvent.CLICK,linkClickHandler);
			}
		}
		
		private function parentClickHandler(evt:MouseEvent):void
		{
			for(var i:int=0; i<5; i++)
			{
				_parents[i].move(_pos.x, _pos.y + i*37);
				_sons[i].visible = false;
			}
			
			var n:int =  _parents.indexOf(evt.currentTarget);
			if(_currentPt != n)
			{				
				for(i=n+1; i<5; i++)
				{
					_parents[i].move(_pos.x, _pos.y + i*37 + (_label2[n].length*21));
				}
				_sons[n].visible = true;
				_itemOver.y = _parents[n].y;
				_currentPt = n;
			}else
			{
				_currentPt = -1;
			}
			// 空位连接
			if(n == 3)
				null;
		}
		private function linkClickHandler(evt:MouseEvent):void
		{
			var index:int = _links.indexOf(evt.currentTarget);
			switch(index)
			{
				case 0:			//强化
					SetModuleUtils.addFurnace(0);
					break;
				case 1:			//鉴定
					SetModuleUtils.addFurnace(1);
					break;
				case 2:			//升级
					SetModuleUtils.addFurnace(2);
					break;
				case 3:			//精炼
					SetModuleUtils.addFurnace(3);
					break;
				case 4:			//镶嵌
					SetModuleUtils.addFurnace(4);
					break;
				case 5:			//获得坐骑
					SetModuleUtils.addStore(new ToStoreData(1));
					break;
				case 6:			//成长
					SetModuleUtils.addMounts(new ToMountsData(0));
					break;
				case 7:			//资质
					SetModuleUtils.addMounts(new ToMountsData(0));
					break;
				case 8:			//进阶
					SetModuleUtils.addMounts(new ToMountsData(0));
					break;
				case 9:			//获得宠物
					SetModuleUtils.addStore(new ToStoreData(1));
					break;
				case 10:		//成长
					SetModuleUtils.addPet();
					break;
				case 11:		//资质
					SetModuleUtils.addPet();
					break;
				case 12:		//进阶
					SetModuleUtils.addPet();
					break;
				case 13:		//职业技能
					SetModuleUtils.addSkill();
					break;
				case 14:		//帮会技能
					SetModuleUtils.addSkill();
					break;
			}
		}
		private function parentOverHandler(evt:MouseEvent):void
		{
			var n:int =  _parents.indexOf(evt.currentTarget);
			_itemOver.y = _parents[n].y;
			_itemOver.visible = true;
		}
		private function parentOutHandler(evt:MouseEvent):void
		{
			_itemOver.visible = false;
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			hide();
		}
		public function hide():void
		{
			TweenLite.to(this,0.5,{x:279-158,ease:Cubic.easeOut, onComplete:dispose});
		}
		public function show():void
		{
			TweenLite.from(this,0.5,{x:279-158,ease:Cubic.easeOut});
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function dispose():void
		{
			removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgMap && _bgMap.bitmapData)
			{
				_bgMap.bitmapData.dispose();
				_bgMap = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn =null;
			}
			if(_itemOver && _itemOver.bitmapData)
			{
				_itemOver.bitmapData.dispose();
				_itemOver = null;
			}
			for(var i:int=0; i<5; i++)
			{
				if(_picon[i] && _picon[i].bitmapData)
				{
					_picon[i].bitmapData = null;
					_picon[i] = null;
				}
				if(_parents[i] && _parents[i].parent)
				{
					_parents[i].parent.removeChild(_parents[i]);
					_parents[i] = null;
				}
				if(_sons[i] && _sons[i].parent)
				{
					_sons[i].parent.removeChild(_sons[i]);
					_sons[i] = null;
				}
			}
			_links = null;
			_picon = null;
			_parents = null;
			_sons = null;
			_pos = null;
			_label1 = null;
			_label2 = null;
			
			if(parent) parent.removeChild(this);
		}
	}
}