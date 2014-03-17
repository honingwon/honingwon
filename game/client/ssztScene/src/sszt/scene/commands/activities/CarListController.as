package sszt.scene.commands.activities
{
	import flash.utils.Dictionary;
	
	import sszt.interfaces.scene.IScene;
	import sszt.scene.components.sceneObjs.BaseSceneCar;
	import sszt.scene.data.SceneCarListUpdateEvent;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.mediators.SceneMediator;

	public class CarListController
	{
		private var _mediator:SceneMediator;
		
		private var _scene:IScene;
		
//		private var _carList:Vector.<BaseSceneCar>;
		private var _carList:Array;
		
		public function CarListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_carList = new Vector.<BaseSceneCar>();
			_carList = [];
			initCars();
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.carList.addEventListener(SceneCarListUpdateEvent.ADD_CAR,addCarHandler);
			_mediator.sceneInfo.carList.addEventListener(SceneCarListUpdateEvent.REMOVE_CAR,removeCarHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.carList.removeEventListener(SceneCarListUpdateEvent.ADD_CAR,addCarHandler);
			_mediator.sceneInfo.carList.removeEventListener(SceneCarListUpdateEvent.REMOVE_CAR,removeCarHandler);
		}
		
		private function initCars():void
		{
			var list:Dictionary = _mediator.sceneInfo.carList.getCars();
			for each(var i:BaseSceneCarInfo in list)
			{
				addCar(i);
			}
		}
		
		private function addCarHandler(evt:SceneCarListUpdateEvent):void
		{
			addCar(evt.data as BaseSceneCarInfo);
		}
		private function removeCarHandler(evt:SceneCarListUpdateEvent):void
		{
			var info:BaseSceneCarInfo = evt.data as BaseSceneCarInfo;
			var len:int = _carList.length;
			for(var i:int = 0; i < len ;i++)
			{
				if(_carList[i].getCarInfo() == info)
				{
					var car:BaseSceneCar = _carList.splice(i,1)[0];
					car.dispose();
					break;
				}
			}
		}
		
		private function addCar(info:BaseSceneCarInfo):void
		{
			var car:BaseSceneCar = new BaseSceneCar(info);
			_scene.addChild(car);
			_carList.push(car);
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneCar in _carList)
			{
				i.dispose();
			}
			_carList.length = 0;
		}
	}
}