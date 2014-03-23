package com.adobe.serialization.json 
{
    public class JSONToken extends Object
    {
        public function JSONToken(arg1:int=-1, arg2:Object=null)
        {
            super();
            this._type = arg1;
            this._value = arg2;
            return;
        }

        public function get type():int
        {
            return this._type;
        }

        public function set type(arg1:int):void
        {
            this._type = arg1;
            return;
        }

        public function get value():Object
        {
            return this._value;
        }

        public function set value(arg1:Object):void
        {
            this._value = arg1;
            return;
        }

        internal var _type:int;

        internal var _value:Object;
    }
}
