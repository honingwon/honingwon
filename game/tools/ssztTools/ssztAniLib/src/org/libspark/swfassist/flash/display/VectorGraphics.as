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
	
	public interface VectorGraphics
	{
		function beginFill(color:uint, alpha:Number = 1.0):void;
		function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void;
		function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void;
		function endFill():void;
		function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, sparedMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void;
		function lineStyle(thickness:Number, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void;
		function lineTo(x:Number, y:Number):void;
		function moveTo(x:Number, y:Number):void;
	}
}