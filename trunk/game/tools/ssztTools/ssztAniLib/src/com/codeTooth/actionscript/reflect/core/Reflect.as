package com.codeTooth.actionscript.reflect.core
{	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.StringUtils;
	import com.codeTooth.actionscript.lang.utils.nil.NilUtil;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;

	/**
	 * 反射
	 */
	
	public class Reflect
	{		
		//对象的XML描述	
		private static var _description:XML = null;
		
		//指定的对象
		private static var _object:Object = null;
		
		//指定的应用程序域
		private static var _applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
				
		public function Reflect()
		{
			
		}
		
		/**
		 * 设置指定的反射对象
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException
		 * 指定了null对象
		 * 
		 * @param object
		 */		
		public static function setObject(object:Object):void
		{
			if(object == null)
			{
				throw new NullPointerException("Null object");
			}
			
			if(_object != object)
			{
				_description = describeType(object);
			}
		}
		
		/**
		 * 反射的应用程序域
		 * 
		 * @param applicationDomain
		 */		
		public static function setApplicationDomain(applicationDomain:ApplicationDomain):void
		{
			if(applicationDomain == null)
			{
				throw new NullPointerException("Null applicationDomain");
			}
			
			_applicationDomain = applicationDomain;
		}
		
		/**
		 * @private
		 */			
		public static function getApplicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		/**
		 * 反射对象
		 * 
		 * @return
		 */		
		public static function getReflectObject():ReflectObject
		{
			var reflectObject:ReflectObject = new ReflectObject();
			reflectObject.typeInternal = getType();
			reflectObject.baseTypeInternal = getBaseType();
			reflectObject.isDynamicInternal = isDynamic();
			reflectObject.isFinalInternal = isFinal();
			reflectObject.isStaticInternal = isStatic();
			reflectObject.constructorInternal = getConstructor();
			reflectObject.extendsTypesIteratorInternal = hasExtendsTypes() ? extendsTypesIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.extendsDefinitionsIteratorInternal = hasExtendsDefinitions() ? extendsDefinitionsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.implementsTypesIteratorInternal = hasImplementsTypes() ? implementsTypesIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.implementsDefinitionsIteratorInternal = hasImplementsDefinitions() ? implementsDefinitionsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.staticConstantsIteratorInternal = hasStaticConstants() ? staticConstantsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.staticAccessorsIteratorInternal = hasStaticAccessors() ? staticAccessorsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.staticMethodsIteratorInternal = hasStaticMethods() ? staticMethodsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.constantsIteratorInternal = hasConstants() ? constantsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.accessorsIteratorInternal = hasAccessors() ? accessorsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.methodsIteratorInternal = hasMethods() ? methodsIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.staticVariablesIteratorInternal = hasStaticVariables() ? staticVariablesIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			reflectObject.variablesIteratorInternal = hasVariables() ? variablesIterator() : new ArrayIterator(NilUtil.NIL_ARRAY);
			
			return reflectObject;
		}
		
		/**
		 * 指定对象的类型
		 *  
		 * @return
		 */		
		public static function getType():String
		{	
			return String(_description.@name);
		}
		
		/**
		 * 指定对象的类定义
		 * 
		 * @return
		 */		
		public static function getDefinition():Class
		{	
			return getDefinitionInternal(getType());
		}
		
		/**
		 * 指定对象的直接超类类型
		 * 
		 * @return
		 */		
		public static function getBaseType():String
		{	
			return String(_description.@base);
		}
		
		/**
		 * 指定对象的直接超类类定义
		 * 
		 * @return
		 */
		public static function getBaseDefinition():Class
		{
			return getDefinitionInternal(getBaseType());
		}
		
		/**
		 * 指定对象是否是动态类
		 * 
		 * @return
		 */		
		public static function isDynamic():Boolean
		{	
			return StringUtils.toBoolean(String(_description.@isDynamic));
		}
		
		/**
		 * 指定对象的类定义是否是最终类
		 * 
		 * @return
		 */		
		public static function isFinal():Boolean
		{
			return StringUtils.toBoolean(String(_description.@isFinal));
		}
		
		/**
		 * 用来判断指定的对象是类定义还是对象实例
		 * 
		 * @return
		 */		
		public static function isStatic():Boolean
		{
			return StringUtils.toBoolean(String(_description.@isStatic));
		}
		
		/**
		 * 继承类型迭代器
		 * 
		 * @return
		 */		
		public static function extendsTypesIterator():IIterator
		{
			if(!hasExtendsTypes())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			var extendsList:XMLList = _description.factory == undefined ? _description.extendsClass : _description.factory.extendsClass;
			var extendsTypes:Array = new Array();
			for each(var extendsXML:XML in extendsList)
			{
				extendsTypes.push(String(extendsXML.@type));	
			}
			
			return new ArrayIterator(extendsTypes);
		}
		
		/**
		 * 继承类定义迭代器
		 * 
		 * @return
		 */		
		public static function extendsDefinitionsIterator():IIterator
		{
			if(!hasExtendsDefinitions())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			var iterator:IIterator = extendsTypesIterator();
			var extendsDefinitions:Array = new Array();
			while(iterator.hasNext())
			{
				extendsDefinitions.push(getDefinitionInternal(String(iterator.next())));
			}
			iterator.destroy();
			
			return new ArrayIterator(extendsDefinitions);
		}
		
		/**
		 * 实现接口类型的迭代器
		 * 
		 * @return <IIterator>
		 */		
		public static function implementsTypesIterator():IIterator
		{
			if(!hasImplementsTypes())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			var implementsList:XMLList = _description.factory == undefined ? _description.implementsInterface : _description.factory.implementsInterface;
			var implementsTypes:Array = new Array();
			for each(var implementsXML:XML in implementsList)
			{
				implementsTypes.push(String(implementsXML.@type));	
			}
			
			return new ArrayIterator(implementsTypes);
		}
		
		/**
		 * 获得指定对象实现接口类定义的迭代器
		 * 
		 * @return
		 */
		public static function implementsDefinitionsIterator():IIterator
		{
			if(!hasImplementsDefinitions())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			var iterator:IIterator = implementsTypesIterator();
			var implementsDefinitions:Array = new Array();
			while(iterator.hasNext())
			{
				implementsDefinitions.push(getDefinitionInternal(String(iterator.next())));
			}
			iterator.destroy();
			
			return new ArrayIterator(implementsDefinitions);
		}
		
		/**
		 * 构造函数对象
		 * 
		 * @return
		 */		
		public static function getConstructor():Constructor
		{
			var constructor:Constructor = new Constructor();
			var parametersList:XMLList = _description.factory == undefined ? 
															(_description.constructor.parameter == undefined ? null : _description.constructor.parameter) : 
															(_description.factory.constructor.parameter == undefined ? null : _description.factory.constructor.parameter);
			if(parametersList != null)
			{
				var parameters:Array = new Array();
				var parameter:Parameter = null;
				constructor.parametersInternal = parameters;
				for each(var parameterXML:XML in parametersList)
				{
					parameter = new Parameter();
					parameter.typeInternal = String(parameterXML.@type);
					parameter.optionalInternal = StringUtils.toBoolean(String(parameterXML.@optional));
					parameters.push(parameter);
				}
			}
			
			return constructor;
		}
		
		/**
		 * 静态常量迭代器
		 * 
		 * @return
		 */
		public static function staticConstantsIterator():IIterator
		{
			if(!hasStaticConstants())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getConstants(_description.constant));
		}
		
		/**
		 * 静态变量迭代器
		 * 
		 * @return
		 */
		public static function staticVariablesIterator():IIterator
		{
			if(!hasStaticVariables())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getVariables(_description.variable));
		}
		
		/**
		 * 静态存取器迭代器
		 * 
		 * @return <IIterator>
		 */		
		public static function staticAccessorsIterator():IIterator
		{
			if(!hasStaticAccessors())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getAccessors(_description.accessor));
		}
		
		/**
		 * 静态方法迭代器
		 * 
		 * @return
		 */		
		public static function staticMethodsIterator():IIterator
		{
			if(!hasStaticMethods())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getMethods(_description.method));
		}
		
		/**
		 * 静态常量迭代器
		 * 
		 * @return
		 */
		public static function constantsIterator():IIterator
		{
			if(!hasConstants())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getConstants(_description.factory == undefined ? _description.constant : _description.factory.constant));
		}
		
		/**
		 * 变量迭代器
		 * 
		 * @return
		 */
		public static function variablesIterator():IIterator
		{
			if(!hasVariables())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getVariables(_description.factory == undefined ? _description.variable : _description.factory.variable));
		}
		
		/**
		 * 存取器迭代器
		 * 
		 * @return
		 */		
		public static function accessorsIterator():IIterator
		{
			if(!hasAccessors())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getAccessors(_description.factory == undefined ? _description.accessor : _description.factory.accessor));
		}
		
		/**
		 * 方法迭代器
		 * 
		 * @return
		 */		
		public static function methodsIterator():IIterator
		{	
			if(!hasMethods())
			{
				return new ArrayIterator(NilUtil.NIL_ARRAY);
			}
			
			return new ArrayIterator(getMethods(_description.factory == undefined ? _description.method : _description.factory.method));
		}
		
		/**
		 * 判断是否存在继承类型
		 * 
		 * @return
		 */		
		public static function hasExtendsTypes():Boolean
		{
			return _description.factory == undefined ? _description.extendsClass != undefined : _description.factory.extendsClass != undefined;
		}
		
		/**
		 * 判断是否存在继承定义
		 * 
		 * @return
		 */
		public static function hasExtendsDefinitions():Boolean
		{
			return hasExtendsTypes();
		}
		
		/**
		 * 判断是否存在实现类型
		 * 
		 * @return
		 */
		public static function hasImplementsTypes():Boolean
		{
			return _description.factory == undefined ? _description.implementsInterface != undefined : _description.factory.implementsInterface != undefined;
		}
		
		/**
		 * 判断是否存在实现定义
		 * 
		 * @return
		 */
		public static function hasImplementsDefinitions():Boolean
		{
			return hasImplementsTypes();
		}
		
		/**
		 * 判断是否存在静态常量
		 * 
		 * @return
		 */		
		public static function hasStaticConstants():Boolean
		{
			return _description.factory != undefined && _description.constant != undefined;
		}
		
		/**
		 * 判断是否有静态的变量
		 * 
		 * @return
		 */		
		public static function hasStaticVariables():Boolean
		{
			return _description.factory != undefined && _description.variable != undefined;
		}
		
		/**
		 * 判断是否存在静态存取器
		 * 
		 * @return
		 */
		public static function hasStaticAccessors():Boolean
		{
			return _description.factory != undefined && _description.accessor != undefined;
		}
		
		/**
		 * 判断是否存在静态方法
		 * 
		 * @return
		 */
		public static function hasStaticMethods():Boolean
		{
			return _description.factory != undefined && _description.method != undefined;
		}
		
		/**
		 * 判断是否存在常量
		 * 
		 * @return
		 */		
		public static function hasConstants():Boolean
		{
			return _description.factory != undefined ? _description.constant != undefined : _description.factory.constant != undefined;
		}
		
		/**
		 * 判断是否存在变量
		 * 
		 * @return
		 */		
		public static function hasVariables():Boolean
		{
			return _description.factory == undefined ? _description.variable != undefined : _description.factory.variable != undefined;
		}
		
		/**
		 * 判断是否存在存取器
		 * 
		 * @return 
		 */
		public static function hasAccessors():Boolean
		{
			return _description.factory == undefined ? _description.accessor != undefined : _description.factory.accessor != undefined;
		}
		
		/**
		 * 判断是否存在方法
		 * 
		 * @return
		 */
		public static function hasMethods():Boolean
		{
			return _description.factory == undefined ? _description.method != undefined : _description.factory.method != undefined;
		}
		
		//通过类型获得类定义
		internal static function getDefinitionInternal(type:String):Class
		{	
			return type == "*" ? Class : (type == "void" ? Void : Class(_applicationDomain.getDefinition(type)));
		}
		
		//通过xml结构获得存取器
		private static function getAccessors(accessorsList:XMLList):Array
		{
			var accessors:Array = new Array();
			var accessor:Accessor = null;
			
			for each(var accessorXML:XML in accessorsList)
			{
				accessor = new Accessor();
				accessors.push(accessor);
				accessor.nameInternal = String(accessorXML.@name);
				accessor.accessInternal = String(accessorXML.@access);
				accessor.typeInternal = String(accessorXML.@type);
				accessor.declaredByTypeInternal = String(accessorXML.@declaredBy);
			}
			
			return accessors;
		}
		
		//通过xml结构获得方法
		private static function getMethods(methodsList:XMLList):Array
		{
			var methods:Array = new Array();
			var method:Method = null;
			var parametersList:XMLList = null;
			var parameters:Array = null;
			var parameter:Parameter = null;
			
			for each(var methodXML:XML in methodsList)
			{
				method = new Method();
				methods.push(method);
				method.nameInternal = String(methodXML.@name);
				method.declaredByTypeInternal = String(methodXML.@declaredBy);
				method.returnTypeInternal = String(methodXML.@returnType);
				
				if(methodXML.parameter != undefined)
				{
					parametersList = methodXML.parameter;
					parameters = new Array();
					method.parametersInternal = parameters;
					for each(var parameterXML:XML in parametersList)
					{
						parameter = new Parameter();
						parameter.typeInternal = String(parameterXML.@type);
						parameter.optionalInternal = StringUtils.toBoolean(String(parameterXML.@optional));
						parameters.push(parameter);
					}
				}
			}
			
			
			return methods;
		}
		
		//通过XML结构获得变量
		private static function getVariables(variablesList:XMLList):Array
		{
			var variables:Array = new Array();
			var variable:Variable = null;
			
			for each(var variableXML:XML in variablesList)
			{
				variable = new Variable();
				variables.push(variable);
				variable.nameInternal = String(variableXML.@name);
				variable.typeInternal = String(variableXML.@type);
			}
			
			return variables;
		}
		
		//通过XML结构获得常量
		private static function getConstants(constantsList:XMLList):Array
		{
			var constants:Array = new Array();
			var constant:Constant = null;
			
			for each(var constantXML:XML in constantsList)
			{
				constant = new Constant();
				constants.push(constant);
				constant.nameInternal = String(constantXML.@name);
				constant.typeInternal = String(constantXML.@type);
			}
			
			return constants;
		}
	}
}