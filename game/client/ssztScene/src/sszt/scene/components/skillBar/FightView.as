package sszt.scene.components.skillBar
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Form;
	import mx.messaging.AbstractConsumer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.tips.GuideTip;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;

	public class FightView extends MSprite implements ITick
	{
		private var _current:Number;
		
		private var _fightTextBox:MSprite;
		private var _fightBg:Bitmap;
		private var _numAssets:Array = [];
		
		private var _zoomTexts:MSprite;
		
		private var _addBox:MSprite;
		private var _addBg:Bitmap;
		private var _addTexts:MSprite;
		private var _addNumAssets:Array = [];
		
		private var _start:int = 0;
		private var _end:int = 0;
		private var _speed:int = 1;
		private var _step:int = 0; 			//步骤: 0:未显示 	1:累加中	2:移动中
		
		private var _btnOpen:MSprite;
		
		private var _btnStrong:MAssetButton1;
		
		private var _deathEff:MovieClip;
		
		public function FightView()
		{
			//战斗力
			_numAssets.push(
				AssetUtil.getAsset("ssztui.scene.NumberAsset0") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset6") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset7") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset8") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.NumberAsset9") as BitmapData
			);
			_addNumAssets.push(
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset0") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset6") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset7") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset8") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.AddNumberAsset9") as BitmapData
			);
			
			_fightBg = new Bitmap(AssetUtil.getAsset("ssztui.scene.FightBarBgAsset") as BitmapData);
			addChild(_fightBg);
			
			_fightTextBox = new MSprite();
			_fightTextBox.move(66,2);
			addChild(_fightTextBox);
			
			_btnStrong = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.btnFightAddAsset") as MovieClip);
			_btnStrong.move(152,0);
			addChild(_btnStrong);
			
			/*
			_btnOpen = new MSprite();
			_btnOpen.graphics.beginFill(0,0);
			_btnOpen.graphics.drawRect(0,0,165,32);
			_btnOpen.graphics.endFill();
			addChild(_btnOpen);
			_btnOpen.buttonMode = true;
			*/
			
			_current = GlobalData.selfPlayer.fight;
			setNumbers(_current,_fightTextBox,_numAssets);
			_btnStrong.move(_fightTextBox.width+75,0);
			
			initEvent();
//			showDeathTip(true);
		}
		
		private function setNumbers(n:int,obj:MSprite,src:Array,sp:int = 15):void
		{
			while(obj && obj.numChildren>0){
				obj.removeChildAt(0);
			}
			var f:String = n.toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(src[int(f.charAt(i))]);
				mc.x = i*sp; 
				obj.addChild(mc);
			}
			_btnStrong.move(_fightTextBox.width+75,0);
		}
		private function initEvent():void
		{
			_btnStrong.addEventListener(MouseEvent.CLICK,onOpenHanlder);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,updatePropertyHandler);
		}
		private function removeEvent():void
		{
			_btnStrong.removeEventListener(MouseEvent.CLICK,onOpenHanlder);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,updatePropertyHandler);
		}
		private function onOpenHanlder(e:MouseEvent):void
		{
			showDeathTip(false);
			SetModuleUtils.addRole(GlobalData.selfPlayer.userId,100);	
		}
		public function showDeathTip(value:Boolean):void
		{
			if(value)
			{
				if(!_deathEff)
				{
					_deathEff = AssetUtil.getAsset("ssztui.scene.btnFightEffectAsset") as MovieClip;
					_deathEff.x = _btnStrong.x;
					addChild(_deathEff);
					_deathEff.mouseEnabled = _deathEff.mouseChildren = false;
				}
				GuideTip.getInstance().show(LanguageManager.getWord("ssztl.scene.deathFightTip"),4,new Point(_btnStrong.x-190,-100),addChild);
			}else
			{
				if(_deathEff && _deathEff.parent)
				{
					_deathEff.parent.removeChild(_deathEff);
					_deathEff = null;
				}
				GuideTip.getInstance().hide();
			}
		}
		//战斗力数据更新处理
		private function updatePropertyHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			var diff:Number = GlobalData.selfPlayer.fight - _current;
			
			if(diff > 0)
			{
				_end = diff;
				_speed = Math.round(_end/20)<1?1:Math.round(_end/20);
				if(_step == 0) startAdd();
				
			}else if(diff < 0)
			{
				setNumbers(GlobalData.selfPlayer.fight,_fightTextBox,_numAssets);
				_current = GlobalData.selfPlayer.fight;
			}
			_btnStrong.move(_fightTextBox.width+75,0);
		}
		
		private function startAdd():void
		{
			addDispose();
			GlobalAPI.tickManager.removeTick(this);
			setNumbers(_current,_fightTextBox,_numAssets);
			
			_addBox = new MSprite();
			_addBox.move(CommonConfig.GAME_WIDTH/2,CommonConfig.GAME_HEIGHT/2);
			GlobalAPI.layerManager.getTipLayer().addChild(_addBox);					
			_addBg = new Bitmap(AssetUtil.getAsset("ssztui.scene.AddNumberBgAsset") as BitmapData);
			_addBox.addChild(_addBg);					
			_addTexts = new MSprite();
			_addTexts.move(78,-5);
			_addBox.addChild(_addTexts);
			
			_start = 0;
			_step = 1;
			_speed = Math.round(_end/20)<1?1:Math.round(_end/20);
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
				
			if(_start <= _end)
			{
				setNumbers(_start,_addTexts,_addNumAssets,21);
				_start += _speed;
			} 
			else if(_addBox)
			{
				setNumbers(_end,_addTexts,_addNumAssets,21);
				GlobalAPI.tickManager.removeTick(this);
				
				_current += _end;
				_end = 0;
				_step = 2;
				TweenLite.to(_addBox,1,{x:(CommonConfig.GAME_WIDTH - 728 >> 1) + this.x,y:CommonConfig.GAME_HEIGHT+this.y,delay:1,ease:Cubic.easeOut,onComplete:onAddMoveComplete,onStart:function():void{_addBg.visible = false;}});
			}
		}
		private function onAddMoveComplete():void
		{
			_step = 0;
			addDispose();
			setNumbers(_current,_fightTextBox,_numAssets);
			if(_end >0)
				startAdd();
			
			_zoomTexts = new MSprite();
			_zoomTexts.move(66,2);
			addChild(_zoomTexts);
			_zoomTexts.mouseEnabled = _zoomTexts.mouseChildren = false;
			setNumbers(_current,_zoomTexts,_numAssets);
			var pt:Point = new Point(_zoomTexts.x - _zoomTexts.width/2,_zoomTexts.y - _zoomTexts.height/2);
			TweenLite.to(_zoomTexts,0.5,{x:pt.x,y:pt.y,scaleX:2, scaleY:2,alpha:0,ease:Cubic.easeOut,onComplete:onEfComplete});
		}
		private function onEfComplete():void
		{
			_zoomTexts.parent.removeChild(_zoomTexts);
			_zoomTexts = null;
		}
		
		private function addDispose():void
		{
			if(_addTexts && _addTexts.parent)
			{
				while(_addTexts.numChildren>0){
					_addTexts.removeChildAt(0);
				}
				_addTexts.parent.removeChild(_addTexts);
				_addTexts = null;
			}
			if(_addBg && _addBg.bitmapData)
			{
				_addBg.bitmapData.dispose();
				_addBg = null;
			}
			if(_addBox && _addBox.parent)
			{
				_addBox.parent.removeChild(_addBox);
				_addBox = null;
			}			
		}			
	}
}