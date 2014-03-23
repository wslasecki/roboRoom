package 
{
    import __AS3__.vec.*;
    import flash.utils.*;
    
    public class Base64 extends Object
    {
        public function Base64()
        {
            super();
            return;
        }

        public static function encode(arg1:flash.utils.ByteArray):String
        {
            var loc5:*=0;
            var loc1:*=new flash.utils.ByteArray();
            loc1.length = (2 + arg1.length - (arg1.length + 2) % 3) * 4 / 3;
            var loc2:*=0;
            var loc3:*=arg1.length % 3;
            var loc4:*=arg1.length - loc3;
            while (loc2 < loc4) 
            {
                loc5 = arg1[loc2++] << 16 | arg1[loc2++] << 8 | arg1[loc2++];
                loc5 = _encodeChars[loc5 >>> 18] << 24 | _encodeChars[loc5 >>> 12 & 63] << 16 | _encodeChars[loc5 >>> 6 & 63] << 8 | _encodeChars[loc5 & 63];
                loc1.writeInt(loc5);
            }
            if (loc3 != 1) 
            {
                if (loc3 == 2) 
                {
                    loc5 = arg1[loc2++] << 8 | arg1[loc2];
                    loc5 = _encodeChars[loc5 >>> 10] << 24 | _encodeChars[loc5 >>> 4 & 63] << 16 | _encodeChars[(loc5 & 15) << 2] << 8 | 61;
                    loc1.writeInt(loc5);
                }
            }
            else 
            {
                loc5 = arg1[loc2];
                loc5 = _encodeChars[loc5 >>> 2] << 24 | _encodeChars[(loc5 & 3) << 4] << 16 | 61 << 8 | 61;
                loc1.writeInt(loc5);
            }
            loc1.position = 0;
            return loc1.readUTFBytes(loc1.length);
        }

        public static function decode(arg1:String):flash.utils.ByteArray
        {
            var loc1:*=0;
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=0;
            var loc5:*=0;
            var loc6:*=0;
            var loc7:*=null;
            loc6 = arg1.length;
            loc5 = 0;
            loc7 = new flash.utils.ByteArray();
            var loc8:*;
            (loc8 = new flash.utils.ByteArray()).writeUTFBytes(arg1);
            while (loc5 < loc6) 
            {
                do 
                {
                    loc1 = _decodeChars[loc8[loc5++]];
                }
                while (loc5 < loc6 && loc1 == -1);
                if (loc1 == -1) 
                {
                    break;
                }
                do 
                {
                    loc2 = _decodeChars[loc8[loc5++]];
                }
                while (loc5 < loc6 && loc2 == -1);
                if (loc2 == -1) 
                {
                    break;
                }
                loc7.writeByte(loc1 << 2 | (loc2 & 48) >> 4);
                do 
                {
                    if ((loc3 = loc8[loc5++]) == 61) 
                    {
                        return loc7;
                    }
                    loc3 = _decodeChars[loc3];
                }
                while (loc5 < loc6 && loc3 == -1);
                if (loc3 == -1) 
                {
                    break;
                }
                loc7.writeByte((loc2 & 15) << 4 | (loc3 & 60) >> 2);
                do 
                {
                    if ((loc4 = loc8[loc5++]) == 61) 
                    {
                        return loc7;
                    }
                    loc4 = _decodeChars[loc4];
                }
                while (loc5 < loc6 && loc4 == -1);
                if (loc4 == -1) 
                {
                    break;
                }
                loc7.writeByte((loc3 & 3) << 6 | loc4);
            }
            return loc7;
        }

        public static function InitEncoreChar():__AS3__.vec.Vector.<int>
        {
            var loc1:*=new Vector.<int>();
            var loc2:*="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            var loc3:*=0;
            while (loc3 < 64) 
            {
                loc1.push(loc2.charCodeAt(loc3));
                ++loc3;
            }
            return loc1;
        }

        public static function InitDecodeChar():__AS3__.vec.Vector.<int>
        {
            var loc1:*=new Vector.<int>();
            loc1.push(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, (-1 - 1), -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
            return loc1;
        }

        internal static const _encodeChars:__AS3__.vec.Vector.<int>=InitEncoreChar();

        internal static const _decodeChars:__AS3__.vec.Vector.<int>=InitDecodeChar();
    }
}
