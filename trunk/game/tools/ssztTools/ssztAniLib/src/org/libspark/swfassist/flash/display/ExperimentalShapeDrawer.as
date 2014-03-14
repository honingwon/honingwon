/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.flash.display
{
	import flash.utils.Dictionary;
	import org.libspark.swfassist.swf.structures.*;

	public class ExperimentalShapeDrawer extends AbstractShapeDrawer
	{
		private static const NONE_FILL:uint = 0;
		public function ExperimentalShapeDrawer(graphics:VectorGraphics = null)
		{
			super(graphics);
		}
		
		private var _x:Number;
		private var _y:Number;

		private var _twx:int;
		private var _twy:int;

		private var _leftFill :uint; // fill0
		private var _rightFill:uint; // fill1
		private var _lineStyleIndex:uint; 

		private var _edges:Array;
		private var _leftFillEdges :Dictionary;
		private var _rightFillEdges:Dictionary;

		private var _maxFillIndex:uint;
		private var _fillStyles:FillStyleArray;
		private var _lineStyles:LineStyleArray;

		public override function draw(shape:Shape):void
		{

			_x = 0;
			_y = 0;
			_twx = 0;
			_twy = 0;
			_leftFill  = NONE_FILL;
			_rightFill = NONE_FILL;
			_lineStyleIndex = NONE_FILL;
			_maxFillIndex = 0;

			_edges = [];
			_leftFillEdges  = new Dictionary(true);
			_rightFillEdges = new Dictionary(true);
			if (shape is ShapeWithStyle)
			{
				_fillStyles = ShapeWithStyle(shape).fillStyles;
				_lineStyles = ShapeWithStyle(shape).lineStyles;
			}

			super.draw(shape);
		}

		protected override function drawStyleChange(record:StyleChangeRecord):void
		{
			if (record.stateMoveTo) {
				_x = record.moveDeltaX;
				_y = record.moveDeltaY;

				_twx = record.moveDeltaXTwips;
				_twy = record.moveDeltaYTwips;
			}

			if (record.stateNewStyles)
			{
				commitEdges();
				_fillStyles = record.fillStyles;
				_lineStyles = record.lineStyles;
			}

			if (record.stateFillStyle0)
			{
				_leftFill  = record.fillStyle0;
				if (_leftFill != NONE_FILL && _leftFill > _maxFillIndex)
					_maxFillIndex = _leftFill;
			}

			if (record.stateFillStyle1)
			{
				_rightFill = record.fillStyle1;
				if (_rightFill != NONE_FILL && _rightFill > _maxFillIndex)
					_maxFillIndex = _rightFill;
			}

			if (record.stateLineStyle)
				_lineStyleIndex = record.lineStyle;
		}
		
		protected override function drawStraightEdge(record:StraightEdgeRecord):void
		{
			var E:EdgePart = new EdgePart(false);
			E.x1  = _x;
			E.y1  = _y;
			E.tx1 = _twx;
			E.ty1 = _twy;

			if (record.generalLine || record.horizontalLine) {
				_x   += record.deltaX;
				_twx += record.deltaXTwips;
			}
			if (record.generalLine || record.verticalLine) {
				_y   += record.deltaY;
				_twy += record.deltaYTwips;
			}

			E.x2 = _x;
			E.y2 = _y;
			E.tx2 = _twx;
			E.ty2 = _twy;
			addEdge(E);
		}
		
		protected override function drawCurvedEdge(record:CurvedEdgeRecord):void
		{
			var E:EdgePart = new EdgePart(true);
			var controlX:Number = _x + record.controlDeltaX;
			var controlY:Number = _y + record.controlDeltaY;

			var controlXT:int = _twx + record.controlDeltaXTwips;
			var controlYT:int = _twy + record.controlDeltaYTwips;

			E.x1 = _x;
			E.y1 = _y;
			E.tx1 = _twx;
			E.ty1 = _twy;

			_x  = controlX + record.anchorDeltaX;
			_y  = controlY + record.anchorDeltaY;
			_twx = controlXT + record.anchorDeltaXTwips;
			_twy = controlYT + record.anchorDeltaYTwips;

			E.ax = controlX;
			E.ay = controlY;
			E.x2 = _x;
			E.y2 = _y;
			E.tx2 = _twx;
			E.ty2 = _twy;
			addEdge(E);
		}

		protected function commitEdges():void
		{
			var len:uint, i:uint;
			var side:uint = 0;

			var fi:uint;
			var collected_edges:Array;


/*
STDOUT.cls();
var fis:Array = [];
var fn:String;
for (fn in _rightFillEdges)
	fis.push(fn);
STDOUT.puts(fis.join(" "));
*/
			//for (side = 0;side < 2;side++)
			{
//				for (fi = 1;fi <= _maxFillIndex;fi++)
				for (fi = _maxFillIndex;fi >= 1;fi--)
				{
					collected_edges = [];
					var elist:Array;
	
					elist = _rightFillEdges[fi];
					if (elist) {
						len = elist.length;
						for (i = 0;i < len;i++)
							collected_edges.push(EdgePart(elist[i]).tearOff(side != 0));
					}
	
					elist = _leftFillEdges[fi];
					if (elist) {
						len = elist.length;
						for (i = 0;i < len;i++)
							collected_edges.push(EdgePart(elist[i]).tearOff(side == 0));

					}
	
					makeLoop(collected_edges, fi);
				}
			}
			_leftFillEdges  = new Dictionary(true);
			_rightFillEdges = new Dictionary(true);

			len = _edges.length;
			for (i = 0;i < len;i++) {
				var E:EdgePart = _edges[i];
				graphics.beginFill(0,0);
				if (E.ls == 0)
					continue;

				var s:LineStyle = _lineStyles.lineStyles[E.ls-1];
				graphics.lineStyle(s.width, s.color.toUint()&0xffffff, Number(s.color.alpha)/255.0);

				graphics.moveTo(E.x1, E.y1);

				if (!E.curved) {
					graphics.lineTo(E.x1, E.y1);
					graphics.lineTo(E.x2, E.y2);
				}
				else
				{
					graphics.curveTo(E.ax, E.ay, E.x2, E.y2);
				}
				graphics.lineStyle(undefined);
				graphics.endFill();
			}

			_edges = [];
		}

		protected override function drawEnd():void
		{
			commitEdges();
		}

		protected function makeLoop(elist:Array, fillIndex:uint):void
		{
			var te:TearedEdge, fst:TearedEdge, nxt:TearedEdge;
			var i:uint, len:uint, k:String;

			var pmap:Dictionary = new Dictionary(false);

			len = elist.length;
			for (i = 0;i < len;i++)
			{
				te = elist[i];
				k = make_key(te.tx1, te.ty1);
				if (!pmap[k]) pmap[k] = [];
				pmap[k].push(te);
			}

			var start_k:String;
			var loops:Array = [];
			var parts:Array;
			len = elist.length;
			for (i = 0;i < len;i++)
			{
				te = elist[i];
				if (te.has_loop)
					continue;

				te.has_loop = true;
				parts = [te];
				fst = te;
				var usedmap:Dictionary = new Dictionary();
				for (start_k = make_key(te.tx1, te.ty1);;)
				{
					k = make_key(te.tx2, te.ty2);
					if (k == start_k)
					{
						for each(var pe:TearedEdge in parts)
							pe.has_loop = true;

						loops.push(parts);
						break;
					}
					if (!pmap[k] || pmap[k].length == 0) break;

					nxt = seq_next(pmap[k], elist[i+1], usedmap);
					if (!nxt) break;
					
					te = nxt;
					usedmap[te] = true;
					parts.push(te);
				}
			}

			graphics.lineStyle(undefined);
			var fill_set:Boolean = false;

			if (_fillStyles) {
				var fs:FillStyle = _fillStyles.fillStyles[fillIndex-1];
				if (fs && fs.fillStyleType == FillStyleTypeConstants.SOLID_FILL) {
					graphics.beginFill(fs.color.toUint()&0xffffff, Number(fs.color.alpha)/255.0);
					fill_set = true;
				}
			}



			if (!fill_set)
				graphics.beginFill(0, 0);

			len = loops.length;
			for (i = 0;i < len;i++)
				renderLoop(loops[i], fillIndex);

			graphics.endFill();
		}

		protected function seq_next(list:Array, t:TearedEdge, usedmap:Dictionary):TearedEdge
		{
			if (!t) return null;

			var i:uint;
			var len:uint = list.length;
			for (i = 0;i < len;i++)
			{
				if (list[i] == t && !list[i].has_loop)
				{
					var ret:TearedEdge = list[i];
					list.splice(i, 1);

					return ret;
				}
			}

			for (i = 0;i < len;i++)
			{
				if (!list[i].has_loop && !usedmap[list[i]])
					return list[i];
			}

			return null;
		}

		protected function renderLoop(loop:Array, fillIndex:uint):void
		{
			var len:uint = loop.length;
			var i:uint, te:TearedEdge;


			for (i = 0;i < len;i++)
			{
				te = loop[i];
				te.used = true;
				if (i == 0)
					graphics.moveTo(te.x1, te.y1);

				if (te.curved)
				{
					graphics.curveTo(te.ax, te.ay, te.x2, te.y2);
				}
				else
				{
					graphics.lineTo(te.x2, te.y2);
				}
			}

		}

		private static function make_key(x:int, y:int):String {
			return x+"_"+y;
		}

		protected function addEdge(E:EdgePart):void
		{
			E.ls = _lineStyleIndex;
			_edges.push(E);

			if (_leftFill != NONE_FILL) {
				if (!_leftFillEdges[_leftFill])
					_leftFillEdges[_leftFill] = [];

				_leftFillEdges[_leftFill].push(E);
			}

			if (_rightFill != NONE_FILL) {
				if (!_rightFillEdges[_rightFill])
					_rightFillEdges[_rightFill] = [];

				_rightFillEdges[_rightFill].push(E);
			}
		}
	}
}

class EdgePart
{
	function EdgePart(cv:Boolean) {
		curved = cv;
		_used = false;
	}
public var collected:Boolean = false;
	public var curved:Boolean;
	public var ls:uint;

	public var x1:Number;
	public var y1:Number;
	public var x2:Number;
	public var y2:Number;

	public var ax:Number;
	public var ay:Number;
	private var _used:Boolean;

	public var tx1:int;
	public var ty1:int;
	public var tx2:int;
	public var ty2:int;

	public function set used(u:Boolean):void {
		_used = u;
	}

	public function get used():Boolean {
		return _used;
	}

	public function tearOff(rev:Boolean):TearedEdge
	{
		var te:TearedEdge = new TearedEdge(curved, this);

		if (!rev)
		{
			te.x1 = x1;
			te.x2 = x2;
			te.y1 = y1;
			te.y2 = y2;

			te.tx1 = tx1;
			te.tx2 = tx2;
			te.ty1 = ty1;
			te.ty2 = ty2;
		}
		else
		{
			te.x1 = x2;
			te.x2 = x1;
			te.y1 = y2;
			te.y2 = y1;

			te.tx1 = tx2;
			te.tx2 = tx1;
			te.ty1 = ty2;
			te.ty2 = ty1;
		}

		te.ax = ax;
		te.ay = ay;

		return te;
	}
}

class TearedEdge extends EdgePart
{
	function TearedEdge(cv:Boolean, org:EdgePart) {
		super(cv);
		original = org;
		has_loop = false;
	}
public function collect():void{
original.collected = true;
}

	public var has_loop:Boolean;
	
	private var original:EdgePart;

	public override function set used(u:Boolean):void {
		original.used = u;
	}
}