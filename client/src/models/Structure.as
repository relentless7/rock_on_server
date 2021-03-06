package models
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	import mx.events.DynamicEvent;

	public class Structure extends EssentialModel
	{
		public var _mc:MovieClip;
		public var _swf_url:String;
		public var _symbol_name:String;
		public var _name:String;
		public var _id:int;
		public var _structure_type:String;
		
		public var _width:Number;
		public var _height:Number;
		public var _depth:Number;
				
		public function Structure(params:Object=null, loadedClass:Class=null, target:IEventDispatcher=null)
		{
			super(params, target);
			if (loadedClass)
			{
				var displayObject:DisplayObject = new loadedClass();			
				if (displayObject is MovieClip)
				{
					_mc = displayObject as MovieClip;
				}
			}
			setProperties(params);			
		}

		public function setProperties(params:Object):void
		{
			_id = params['id'];
			_swf_url = params['swf_url'];
			_symbol_name = params['symbol_name'];
			_name = params['name'];
			_structure_type = params['structure_type'];
			
			if (params['width'])
			{
				_width = params['width'];
			}
			if (params['height'])
			{
				_height = params['height'];
			}
			if (params['depth'])
			{
				_depth = params['depth'];
			}
		}
		
		public function set id(val:int):void
		{
			_id = val;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set swf_url(val:String):void
		{
			_swf_url = val;
		}
		
		public function get swf_url():String
		{
			return _swf_url;
		}
		
		public function set symbol_name(val:String):void
		{
			_symbol_name = val;
		}
		
		public function get symbol_name():String
		{
			return _symbol_name;
		}
		
		public function set structure_type(val:String):void
		{
			_structure_type = val;
		}
		
		public function get structure_type():String
		{
			return _structure_type;
		}
		
		public function setMovieClipFromClass(val:Class):void
		{
			var displayObject:DisplayObject = new val();			
			if (displayObject is MovieClip)
			{
				_mc = displayObject as MovieClip;
				
				var evt:DynamicEvent = new DynamicEvent('movieClipLoaded', true, true);
				evt.thinger = this;
				dispatchEvent(evt);					
			}
		}
		
		public function set mc(val:MovieClip):void
		{
			_mc = val;
		}
		
		public function get mc():MovieClip
		{
			return _mc;
		}
		
		public function set name(val:String):void
		{
			_name = val;
		}
		
		public function get name():String
		{
			return _name;
		}	
		
		public function set width(val:Number):void
		{
			_width = val;
		}	
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set height(val:Number):void
		{
			_height = val;
		}	
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set depth(val:Number):void
		{
			_depth = val;
		}	
		
		public function get depth():Number
		{
			return _depth;
		}
		
	}
}