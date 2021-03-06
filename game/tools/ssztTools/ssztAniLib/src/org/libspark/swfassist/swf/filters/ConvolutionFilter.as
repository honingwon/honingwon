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

package org.libspark.swfassist.swf.filters
{
	import org.libspark.swfassist.swf.structures.RGBA;
	import flash.filters.ConvolutionFilter;
	
	public class ConvolutionFilter extends AbstractFilter
	{
		public function ConvolutionFilter(filterId:uint = 0)
		{
			super(filterId != 0 ? filterId : FilterConstants.ID_CONVOLUTION);
		}
		
		private var _matrixX:uint = 0;
		private var _matrixY:uint = 0;
		private var _divisor:Number = 1.0;
		private var _bias:Number = 0.0;
		private var _matrix:Array = [];
		private var _defaultColor:RGBA = new RGBA();
		private var _clamp:Boolean = true;
		private var _preserveAlpha:Boolean = true;
		
		public function get matrixX():uint
		{
			return _matrixX;
		}
		
		public function set matrixX(value:uint):void
		{
			_matrixX = value;
		}
		
		public function get matrixY():uint
		{
			return _matrixY;
		}
		
		public function set matrixY(value:uint):void
		{
			_matrixY = value;
		}
		
		public function get divisor():Number
		{
			return _divisor;
		}
		
		public function set divisor(value:Number):void
		{
			_divisor = value;
		}
		
		public function get bias():Number
		{
			return _bias;
		}
		
		public function set bias(value:Number):void
		{
			_bias = value;
		}
		
		public function get matrix():Array
		{
			return _matrix;
		}
		
		public function set matrix(value:Array):void
		{
			_matrix = value;
		}
		
		public function get defaultColor():RGBA
		{
			return _defaultColor;
		}
		
		public function set defaultColor(value:RGBA):void
		{
			_defaultColor = value;
		}
		
		public function get clamp():Boolean
		{
			return _clamp
		}
		
		public function set clamp(value:Boolean):void
		{
			_clamp = value;
		}
		
		public function get preserveAlpha():Boolean
		{
			return _preserveAlpha;
		}
		
		public function set preserveAlpha(value:Boolean):void
		{
			_preserveAlpha = value;
		}
		
		public function fromNativeFilter(filter:flash.filters.ConvolutionFilter):void
		{
			matrixX = filter.matrixX;
			matrixY = filter.matrixY;
			matrix = filter.matrix.slice();
			divisor = filter.divisor;
			bias = filter.bias;
			defaultColor.fromUint(filter.color);
			clamp = filter.clamp;
			preserveAlpha = filter.preserveAlpha;
		}
		
		public function toNativeFilter():flash.filters.ConvolutionFilter
		{
			var filter:flash.filters.ConvolutionFilter = new flash.filters.ConvolutionFilter();
			filter.matrixX = matrixX;
			filter.matrixY = matrixY;
			filter.matrix = matrix.slice();
			filter.divisor = divisor;
			filter.bias = bias;
			filter.color = defaultColor.toUint();
			filter.clamp = clamp;
			filter.preserveAlpha = preserveAlpha;
			return filter;
		}
	}
}