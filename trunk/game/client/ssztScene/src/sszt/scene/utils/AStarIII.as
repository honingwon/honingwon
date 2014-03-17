package sszt.scene.utils
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.utils.Geometry;

	public class AStarIII 
	{
		private static const MAX_COUNT:int = 50000;
		private static const G_COST:int = 10;
		private static const H_COST:int = 10;
		
		private var _data:Array;
		private var _mapStatus:Array;
		private var _openList:Array;
		private var _checkCount:int;
		
		private var _rlen:int;
		private var _clen:int;
		
		private function isEmpty(row:int,col:int):Boolean
		{
			if(!_data) return false;
			if(row < 0 || row >= _data.length || col >= _data[0].length || col < 0)return false;
			return _data[row][col] == MapDataType.EMPTY;
		}
		
		private function init():void
		{
			_openList = [];
			_mapStatus = [];
		}
		
		private function getInfo(row:int,col:int):Info
		{
			return _mapStatus[row][col];
		}
		
		/**
		 * 当放入openlist中时就进行排序(二分法)
		 */		
		private function sortOpenList(index:int):void
		{
			var middle:int;
			var firstP:Point;
			var middleP:Point;
			var firstInfo:Info;
			var middleInfo:Info;
			while(index > 1)
			{
				middle = Math.floor(index * 0.5);
				firstP = _openList[index - 1];
				middleP = _openList[middle - 1];
				firstInfo = getInfo(firstP.y,firstP.x);
				middleInfo = getInfo(middleP.y,middleP.x);
				if(firstInfo.f < middleInfo.f)
				{
					//开放列表交换位置
					_openList[index - 1] = middleP;
					_openList[middle - 1] = firstP;
					middleInfo.openIndex = index - 1;
					firstInfo.openIndex = middle - 1;
					index = middle;
				}
				else
				{
					break;
				}
			}
		}
		
		public function setSource(data:Array):void
		{
			this._data = data;
			_rlen = data.length;
			_clen = data[0].length;
		}
		
		private function isOpen(row:int,col:int):Boolean
		{
			var t:Array = _mapStatus[row];
			if(t != null)
			{
				var info:Info = t[col];
				return (info != null && info.openIndex != -1);
			}
			return false;
		}
		
		private function isClose(row:int,col:int):Boolean
		{
			var t:Array = _mapStatus[row];
			if(t != null)
			{
				var info:Info = t[col];
				return (info != null && info.openIndex == -1);
			}
			return false;
		}
		
//		private function setOpenIndex(row:int,col:int,value:int):void
//		{
//			getInfo(row,col).openIndex = value;
//		}
		
		/**
		 * 二叉树排序
		 */		
		private function shiftOpenList():void
		{
			if (_openList.length == 1)
			{
				_openList.length = 0;
				return;
			};
			
			_openList[0] = _openList.pop();
			_mapStatus[_openList[0].y][_openList[0].x].openIndex = 0;
//			setOpenIndex(_openList[0].y,_openList[0].x,0);
			
			var first:int = 1;
			var tFirst:int;
			var middle:int;
			
			while (true) 
			{
				tFirst = first;
				middle = first * 2;
				if (middle <= _openList.length)
				{
					if (_mapStatus[_openList[first - 1].y][_openList[first - 1].x].f > _mapStatus[_openList[middle - 1].y][_openList[middle - 1].x].f)first = middle;
					if (middle + 1 <= _openList.length && this._mapStatus[_openList[first - 1].y][_openList[first - 1].x].f > _mapStatus[_openList[middle].y][_openList[middle].x].f)first = middle + 1;
				};
				if (tFirst == first)break;
				
				var t:Point = _openList[tFirst - 1];
				_openList[tFirst - 1] = _openList[first - 1];
				_openList[first - 1] = t;	
				_mapStatus[_openList[tFirst - 1].y][_openList[tFirst - 1].x].openIndex = tFirst - 1;
				_mapStatus[_openList[first - 1].y][_openList[first - 1].x].openIndex = first - 1;
			}
		}
		
		private function t(t:Array):void
		{
			for each(var a:Point in t)
			{
				a.x = CommonConfig.GRID_SIZE * (a.x+0.5);
				a.y = CommonConfig.GRID_SIZE*(a.y+0.5);
			}
		}
		
		private function posToIndex(pos:Point):Point
		{
			pos.x = Math.floor(pos.x / CommonConfig.GRID_SIZE);
			pos.y = Math.floor(pos.y / CommonConfig.GRID_SIZE);
			return pos;
		}
		
		private function indexToPos(index:Point):Point
		{
			index.x = (index.x + 0.5) * CommonConfig.GRID_SIZE;
			index.y = (index.y + 0.5) * CommonConfig.GRID_SIZE;
			return index;
		}
		
		private var _startPos:Point;
		private var _endPos:Point;
		private var endIndex:Point;
		public function findpath(start:Point,end:Point,stopAtDispatch:int = 0,maxCount:int = 6000):Array{
			if(stopAtDispatch > 0)
			{
				if(Point.distance(start,end) <= stopAtDispatch)
					return [start];
			}
			_startPos=start.clone();
			_endPos=end.clone();
			
			start = start.clone();
			end = end.clone();
			start = posToIndex(start);
			endIndex = posToIndex(end);
//			if(isEmpty(end.y,end.x))return null;
			if(isEmpty(endIndex.y,endIndex.x))
			{
				endIndex=getAroundIndex();
				if(endIndex == null)
				{
					return null;
				}
				_endPos=indexToPos(endIndex.clone());
			}
			
			init();
			
			var row:int;
			var col:int;
			var tg:int;
			var th:int;
			
			_openList.push(start);
			_mapStatus[start.y] = [];
			_mapStatus[start.y][start.x] = new Info(null,0,0,0,0);
			_checkCount = 1;
			var current:Point;
			var minRow:int;
			var maxRow:int;
			var minCol:int;
			var maxCol:int;
			while ((_openList.length > 0) && (!(isClose(endIndex.y, endIndex.x))))
			{
				current = _openList[0];
				_mapStatus[current.y][current.x].openIndex = -1;
				shiftOpenList();
				minRow = Math.max(0,current.y - 1);
				maxRow = Math.min(current.y + 1,_rlen - 1);
				row = minRow;
				
				minCol = Math.max(0,current.x - 1);
				maxCol = Math.min(current.x + 1,_clen - 1);
				row = minRow;
				
				while (row <= maxRow) 
				{
					col = minCol;
					while (col <= maxCol) 
					{
						if (!((row == current.y) && (col == current.x)) && (row == current.y || col == current.x || !(isEmpty(row,current.x)) && (!isEmpty(current.y,col))))
						{
							if(!isEmpty(row,col))
							{
								if (!this.isClose(row, col)){
									tg = int(this._mapStatus[current.y][current.x].g) + G_COST;
									if (this.isOpen(row, col))
									{
										if (tg < this._mapStatus[row][col].g)
										{
											this._mapStatus[row][col].parent = current;
											this._mapStatus[row][col].f = (tg + this._mapStatus[row][col].h);
											this.sortOpenList((this._mapStatus[row][col].openIndex + 1));
										}
									}
									else 
									{
										th = ((Math.abs((row - endIndex.y)) + Math.abs((col - endIndex.x))) * H_COST);
										_openList.push(new Point(col, row));
										if (!this._mapStatus[row])
										{
											this._mapStatus[row] = [];
										};
										_mapStatus[row][col] = new Info(current,tg,th,tg + th,_openList.length - 1);
										sortOpenList(_openList.length);
									}
								}
							}
						}
						col++;
					}
					row++;
				}
				this._checkCount++;
				
				if (this._checkCount > maxCount)
				{
					break;
				}
			}
//			trace(this._checkCount);
			if (isClose(endIndex.y, endIndex.x))
			{
				var result:Array = [];
				var tp:Point;
				tp = endIndex;
				while (((!((tp.y == start.y))) || (!((tp.x == start.x))))) {
					result.push(tp);
					tp = this._mapStatus[tp.y][tp.x].parent;
				};
				tp.x = start.x;
				tp.y = start.y;
				result.push(tp);

				result.reverse();
				result = optimizePath(result);
				for(var index:int = result.length - 1; index > 0; index--)
				{
					if(result[index] == result[index - 1])
						result.splice(index,1);
				}
				t(result);
				result[0]=_startPos;
				//如果停止距离大于0，那么最后一点和结束点的距离如果小于停止距离，就直接忽略结束点，否则添加结束点再切线
				return PathUtils.cutPathEnd(result,stopAtDispatch,_endPos);
				
//				if(stopAtDispatch > 0 && result.length >= 2)
//				{
//					if(Point.distance(result[result.length - 2],_endPos) > stopAtDispatch)
//					{
//						result = PathUtils.cutPathEnd(result,stopAtDispatch);
//					}
//					else
//					{
//						result = result.slice(0,result.length - 1);
//					}
//				}
				
				
//				if(stopAtDispatch > 0)
//				{
//					var tmpResult:Array = [];
//					for(var i:int = 0; i < result.length; i++)
//					{
//						if(Point.distance(result[i],_endPos) <= stopAtDispatch)
//						{
//							tmpResult = result.slice(0,i);
//						}
//					}
//					
//					
//					result = PathUtils.cutPathEnd(result,stopAtDispatch);
//				}
//				trace("消耗时间:",getTimer() - t1)
//				return result;
			};
			return null;
		}

		/**
		 *递归找到非可行点的最近的可行点 
		 * @param i 目标点的前后i个网格范围
		 * @return 最近的点
		 * 
		 */		
		private function getAroundIndex(i:int=1):Point
		{
			var startRow:int = Math.max(endIndex.y - i, 0);
			var endRow:int = Math.min(endIndex.y+ i, _rlen-1);
			var startCol:int = Math.max(endIndex.x - i, 0);
			var endCol:int = Math.min(endIndex.x + i, _clen-1);
			
			var result:Point;
			var j:int;
			
			for(j=startCol; j <=endCol; j++)
			{
				if(!isEmpty(startRow,j))
				{
					return result=new Point(j,startRow);
				}
			}
			
			for(j= startCol; j <=endCol; j++)
			{
				if(!isEmpty(endRow,j))
				{
					return result=new Point(j,endRow);
				}
			}
			
			for(j= startRow; j <=endRow; j++)
			{
				if(!isEmpty(j,startCol))
				{
					return result=new Point(startCol,j);
				}
			}
			
			for(j= startRow; j <=endRow; j++)
			{
				if(!isEmpty(j,endCol))
				{
					return result=new Point(endCol,j);
				}
			}
			
			if(result == null && i < _rlen-1 && i < _clen-1)
				return getAroundIndex(i+1);
			return result;
		}
		
		/**
		 *优化路径 
		 * @return 
		 * 
		 */		
		private function optimizePath(path:Array):Array 
		{
			var t:Number = getTimer();
			if(path.length==0)
			{
				return [];
			}
			var __len:int = path.length;
			var __path:Array = [];
			var _diagonal:Array = [];
			var __dLen:int;
			var __cross:Boolean = true;
			var __currentNode:Point = path[0]
			__path.push(path[0]);
			for (var i:int=1; i<__len; i++) 
			{
				_diagonal = Diagonal.find(__currentNode, path[i]);
				__dLen = _diagonal.length;
				__cross = true;
				for (var j:int=0; j<__dLen; j++) 
				{
					if (_data[_diagonal[j].y][_diagonal[j].x]==0) 
					{
						__cross = false;
						break;
					}
				}
				if (!__cross) 
				{
					if (i>1) 
					{
						__currentNode = path[(i-1)];
						__path.push(path[(i-1)]);
					}
				}
			}
			__path.push(path[(__len-1)]);
			path = __path;
//			trace("优化路径:",getTimer() - t);
			return path;
		}
		
	}
}

import flash.geom.Point;

class Info
{
	public function Info(parent:Point,g:int,h:int,f:int,openIndex:int)
	{
		this.parent = parent;
		this.g = g;
		this.h = h;
		this.f = f;
		this.openIndex = openIndex;
	}
	public var parent:Point;
	public var g:int;
	public var h:int;
	public var f:int;
	public var openIndex:int;
}
