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
	import flash.geom.Matrix;
	import flash.display.Sprite;
	import flash.events.Event;

	public class PenGraphics extends Sprite implements VectorGraphics
	{
		private var _commands:Array = [];
		
		public function beginFill(color:uint, alpha:Number=1.0):void
		{
			_commands.push(new GraphicBeginFill(color, alpha));
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb", focalPointRatio:Number=0):void
		{
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			var a:GraphicPoint = new GraphicPoint(controlX, controlY);
			var b:GraphicPoint = new GraphicPoint(anchorX, anchorY);
			
			addChild(new DraggablePoint(a, 0xffccff));
			addChild(new DraggablePoint(b));
			
			a.addEventListener(Event.CHANGE, changeHandler);
			b.addEventListener(Event.CHANGE, changeHandler);
			
			_commands.push(new GraphicCurveTo(a, b));
		}
		
		public function endFill():void
		{
			_commands.push(new GraphicEndFill());
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix=null, sparedMethod:String="pad", interpolationMethod:String="rgb", focalPointRatio:Number=0):void
		{
		}
		
		public function lineStyle(thickness:Number, color:uint=0, alpha:Number=1.0, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String=null, joints:String=null, miterLimit:Number=3):void
		{
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			var p:GraphicPoint = new GraphicPoint(x, y);
			
			addChild(new DraggablePoint(p));
			
			p.addEventListener(Event.CHANGE, changeHandler);
			
			_commands.push(new GraphicLineTo(p));
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			var p:GraphicPoint = new GraphicPoint(x, y);
			
			addChild(new DraggablePoint(p));
			
			p.addEventListener(Event.CHANGE, changeHandler);
			
			_commands.push(new GraphicMoveTo(p));
		}
		
		public function update():void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x66ccff);
			
			for each (var command:GraphicCommand in _commands) {
				command.draw(graphics);
			}
		}
		
		private function changeHandler(e:Event):void
		{
			update();
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.EventDispatcher;
import flash.display.Graphics;

interface GraphicCommand
{
	function draw(graphics:Graphics):void;
}

class GraphicMoveTo implements GraphicCommand
{
	public function GraphicMoveTo(point:GraphicPoint)
	{
		this.point = point;
	}
	
	private var point:GraphicPoint;
	
	public function draw(graphics:Graphics):void
	{
		graphics.moveTo(point.x, point.y);
	}
}

class GraphicLineTo implements GraphicCommand
{
	public function GraphicLineTo(point:GraphicPoint)
	{
		this.point = point;
	}
	
	private var point:GraphicPoint;
	
	public function draw(graphics:Graphics):void
	{
		graphics.lineTo(point.x, point.y);
	}
}

class GraphicCurveTo extends EventDispatcher implements GraphicCommand
{
	public function GraphicCurveTo(a:GraphicPoint, b:GraphicPoint)
	{
		this.a = a;
		this.b = b;
	}
	
	private var a:GraphicPoint;
	private var b:GraphicPoint;
	
	public function draw(graphics:Graphics):void
	{
		graphics.curveTo(a.x, a.y, b.x, b.y);
	}
}

class GraphicBeginFill extends EventDispatcher implements GraphicCommand
{
	public function GraphicBeginFill(color:uint, alpha:Number)
	{
		this.c = color;
		this.a = alpha;
	}
	
	private var c:uint;
	private var a:Number;
	
	public function draw(graphics:Graphics):void
	{
		graphics.beginFill(c, a);
	}
}

class GraphicEndFill extends EventDispatcher implements GraphicCommand
{
	public function GraphicEndFill()
	{
	}
	
	public function draw(graphics:Graphics):void
	{
		graphics.endFill();
	}
}

class GraphicPoint extends EventDispatcher
{
	public function GraphicPoint(x:Number, y:Number)
	{
		this.x = x;
		this.y = y;
	}
	
	public var x:Number;
	public var y:Number;
	
	public function fireChange():void
	{
		dispatchEvent(new Event(Event.CHANGE));
	}
}

class DraggablePoint extends Sprite
{
	public function DraggablePoint(p:GraphicPoint, c:uint = 0x66ccff)
	{
		graphics.lineStyle(1, c);
		graphics.beginFill(0xffffff);
		graphics.drawCircle(0, 0, 2);
		
		point = p;
		
		x = p.x;
		y = p.y;
		
		addEventListener(Event.ADDED, addedHandler);
	}
	
	private var point:GraphicPoint;
	
	private function addedHandler(e:Event):void
	{
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		parent.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
	}
	
	private function mouseDownHandler(e:MouseEvent):void
	{
		parent.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	private function mouseUpHandler(e:MouseEvent):void
	{
		parent.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	private function mouseMoveHandler(e:MouseEvent):void
	{
		point.x = x = parent.mouseX;
		point.y = y = parent.mouseY;
		point.fireChange();
	}
}