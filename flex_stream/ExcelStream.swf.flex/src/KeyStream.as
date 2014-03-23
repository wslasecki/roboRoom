package 
{
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class KeyStream extends flash.display.Sprite
    {
        internal function initText():void
        {
            var loc3:*=null;
            var loc4:*=0;
            var loc5:*=null;
            var loc6:*=null;
            var loc7:*=null;
            this.t = new flash.text.TextField();
            this.t.width = 250;
            this.t.height = 100;
            this.t.textColor = 16777215;
            this.t.multiline = true;
            this.t.wordWrap = true;
            this.t.visible = false;
            this.t.background = true;
            this.t.backgroundColor = 0;
            this.t.selectable = false;
            var loc1:*=new flash.text.TextFormat("_sans", 24, 16777215);
            this.t.defaultTextFormat = loc1;
            this.t.setTextFormat(loc1);
            var loc2:*=flash.external.ExternalInterface.call("window.location.search.toString") as String;
            if (loc2.length > 1) 
            {
                loc3 = loc2.substring(1).split("&");
                loc4 = 0;
                while (loc4 < loc3.length) 
                {
                    loc6 = (loc5 = loc3[loc4].split("="))[0];
                    loc7 = decodeURIComponent(loc5[1]);
                    this.hitInfo[loc6] = loc7;
                    ++loc4;
                }
            }
            this.t.visible = true;
            if (this.hitInfo.assignmentId == "UNSET" || this.hitInfo.assignmentId == "ASSIGNMENT_ID_NOT_AVAILABLE") 
            {
                if (this.hitInfo.special == "true") 
                {
                    this.hitInfo.assignmentId = new Date().getTime().toString(16) + "" + Math.random();
                    this.hitInfo.workerId = new Date().getTime().toString(16) + "" + Math.random();
                    this.hitInfo.hitId = new Date().getTime().toString(16) + "" + Math.random();
                }
                this.t.text = "Key commands not accepted until the HIT is accepted.";
                if (this.hitInfo.special == "true") 
                {
                    this.t.text = "Special user";
                }
            }
            return;
        }

        internal function initMouse():void
        {
            var loc1:*=new flash.net.URLLoader();
            loc1.addEventListener(flash.events.Event.COMPLETE, this.onJSONLoad);
            loc1.dataFormat = flash.net.URLLoaderDataFormat.TEXT;
            loc1.load(new flash.net.URLRequest("http://roc.cs.rochester.edu/videoclient/hitInfo.json"));
            return;
        }

        internal function onJSONLoad(arg1:flash.events.Event):void
        {
            var loc1:*=null;
            var loc2:*=NaN;
            var loc3:*=NaN;
            var loc4:*=NaN;
            stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.hitJSON = new com.adobe.serialization.json.JSONDecoder((arg1.target as flash.net.URLLoader).data as String, false).getValue();
            var loc5:*=0;
            var loc6:*=this.hitJSON;
            for (loc1 in loc6) 
            {
                this.hitJSON[loc1] = Base64.decode(this.hitJSON[loc1]).toString();
                if (loc1 != "coords") 
                {
                    continue;
                }
                this.hitJSON[loc1] = new com.adobe.serialization.json.JSONDecoder(this.hitJSON[loc1], false).getValue();
            }
            if (this.hitJSON.coords) 
            {
                loc2 = this.hitJSON.coords[1][0];
                loc3 = this.hitJSON.coords[1][1];
                loc4 = loc2 / loc3;
                this.scaleFactor = loc2 / stage.stageWidth;
                if (loc4 > Number(stage.stageWidth) / stage.stageHeight) 
                {
                    this.barSize = stage.stageHeight * 1 / this.scaleFactor / 2;
                    this.sideBars = false;
                }
                else 
                {
                    this.barSize = stage.stageWidth * this.scaleFactor / 2;
                    this.sideBars = true;
                }
                this.offsetX = this.hitJSON.coords[0][0];
                this.offsetY = 1050 - this.hitJSON.coords[0][1];
                trace("scaleFactor", this.scaleFactor, "offsetX", this.offsetX, "offsetY", this.offsetY);
            }
            else 
            {
                this.hitJSON.coords = [[0, 0], [0, 0]];
            }
            return;
        }

        internal function updateDebugText(arg1:flash.events.Event):void
        {
            if (this.ns) 
            {
                this.t.text = "Delay: " + this.ns.liveDelay + ", FPS: " + this.ns.currentFPS;
            }
            return;
        }

        protected function initStream():void
        {
            stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
            stage.align = flash.display.StageAlign.TOP_LEFT;
            this.v = new flash.media.Video();
            addChild(this.v);
            this.nc = new flash.net.NetConnection();
            this.nc.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onStreamStatus);
            this.nc.client = this.connectionClient;
            this.nc.connect("rtmfp://" + this.host + "/live/_definst_");
            stage.addEventListener(flash.events.MouseEvent.DOUBLE_CLICK, this.onClick);
            return;
        }

        protected function onClick(arg1:flash.events.MouseEvent):void
        {
            stage.displayState = flash.display.StageDisplayState.FULL_SCREEN;
            this.v.width = flash.system.Capabilities.screenResolutionX;
            this.v.height = flash.system.Capabilities.screenResolutionY;
            return;
        }

        protected function initKeys():void
        {
            stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, this.onKeyDown);
            return;
        }

        protected function initSocket():void
        {
            if (this.hitInfo.assignmentId == "UNSET" || this.hitInfo.assignmentId == "ASSIGNMENT_ID_NOT_AVAILABLE") 
            {
                return;
            }
            this.s = new flash.net.Socket();
            this.s.addEventListener(flash.events.Event.CLOSE, this.onSocketClose);
            this.s.addEventListener(flash.events.Event.CONNECT, this.onSocketConnect);
            this.s.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onSocketIOError);
            this.s.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onSocketSecError);
            this.s.addEventListener(flash.events.ProgressEvent.SOCKET_DATA, this.onSocketData);
            this.s.connect(this.host, this.socketPort);
            return;
        }

        protected function onStreamStatus(arg1:flash.events.NetStatusEvent):void
        {
            var loc1:*=null;
            trace("NetStatus: ", arg1.info.code);
            if (arg1.info.code == "NetConnection.Connect.Success") 
            {
                loc1 = new flash.net.NetStream(this.nc);
                this.ns = loc1;
                loc1.client = this.connectionClient;
                this.v.attachNetStream(loc1);
                loc1.play("livestream");
                trace("buff:", loc1.bufferLength, loc1.bufferTime);
                this.v.width = 640;
                this.v.height = 480;
            }
            return;
        }

        internal function makeRoboTurkInfo(arg1:String):String
        {
            return [this.hitInfo.special != "true" ? this.hitInfo.workerId : "special" + this.hitInfo.workerId, this.hitInfo.assignmentId, arg1, new Date().getTime()].join(":");
        }

        internal function onMouseDown(arg1:flash.events.MouseEvent):void
        {
            if (!this.s || !this.s.connected) 
            {
                return;
            }
            var loc1:*=stage.stageWidth - stage.mouseX;
            var loc2:*=stage.stageHeight - stage.mouseY;
            var loc3:*=stage.mouseX - stage.mouseX % 25 + 12;
            var loc4:*=loc2 - loc2 % 25 + 12;
            var loc5:*=uint(loc3 * this.scaleFactor + this.offsetX);
            var loc6:*=uint(this.offsetY - loc4 * this.scaleFactor);
            loc5 = Math.min(1680, loc5);
            loc6 = Math.min(1050, loc6);
            trace(loc3, loc4, "->", loc5, loc6, "=");
            var loc7:*="~" + this._4pad(loc5) + "|" + this._4pad(loc6);
            var loc8:*=this.makeRoboTurkInfo(loc7);
            trace(loc8);
            this.s.writeUTFBytes(loc8 + "\n");
            this.s.flush();
            return;
        }

        internal function _4pad(arg1:uint):String
        {
            return ["0000", "000", "00", "0", ""][arg1.toString().length] + arg1;
        }

        internal function onKeyDown(arg1:flash.events.KeyboardEvent):void
        {
            var loc2:*=null;
            var loc3:*=null;
            if (!this.s || !this.s.connected) 
            {
                return;
            }
            var loc1:*=String.fromCharCode(arg1.charCode);
            if (!this.threshold) 
            {
                return;
            }
            if (!this.submitOkay) 
            {
                flash.external.ExternalInterface.call("roboTurk.showSubmit");
                this.submitOkay = true;
            }
            if (arg1.charCode > 0 && !(loc1 == " ") && !(arg1.keyCode == 13) && !(arg1.keyCode == 8) && !(arg1.keyCode == 9)) 
            {
                loc2 = this.makeRoboTurkInfo(loc1.toLowerCase());
                this.s.writeUTFBytes(loc2 + "\n");
                trace("sendkey", loc1);
            }
            else 
            {
                var loc4:*=arg1.keyCode;
                switch (loc4) 
                {
                    case 38:
                    {
                        loc2 = "up";
                        break;
                    }
                    case 40:
                    {
                        loc2 = "down";
                        break;
                    }
                    case 37:
                    {
                        loc2 = "left";
                        break;
                    }
                    case 39:
                    {
                        loc2 = "right";
                        break;
                    }
                    case 13:
                    {
                        loc2 = "return";
                        break;
                    }
                    case 8:
                    {
                        loc2 = "delete";
                        break;
                    }
                    case 9:
                    {
                        loc2 = "tab";
                        break;
                    }
                    case 32:
                    {
                        loc2 = "space";
                        break;
                    }
                }
                loc3 = loc2;
                loc2 = this.makeRoboTurkInfo(loc3);
                trace("socketsending: ", loc2);
                this.s.writeUTFBytes(loc2 + "\n");
            }
            this.s.flush();
            return;
        }

        protected function onSocketData(arg1:flash.events.ProgressEvent):void
        {
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=NaN;
            var loc1:*=this.s.readUTFBytes(this.s.bytesAvailable);
            var loc2:*=loc1.split("\n");
            trace("socket data", loc1);
            var loc7:*=0;
            var loc8:*=loc2;
            label437: for each (loc1 in loc8) 
            {
                loc4 = (loc3 = loc1.split(":"))[0];
                loc5 = loc3[1];
                var loc9:*=loc4;
                switch (loc9) 
                {
                    case "epoch_pay":
                    {
                        loc6 = parseFloat(loc5);
                        continue label437;
                    }
                    case "disconnect":
                    {
                        flash.external.ExternalInterface.call("roboTurk.disconnect");
                        this.disconnect();
                        continue label437;
                    }
                    case "last_action":
                    {
                        this.ti.crowdText = loc5;
                        continue label437;
                    }
                    case "weight":
                    {
                        this.ti.weight = parseFloat(loc5);
                        flash.external.ExternalInterface.call("roboTurk.epochPay", parseFloat(loc5) / 10);
                        continue label437;
                    }
                    case "max":
                    {
                        this.ti.leaderWeight = parseFloat(loc5);
                        continue label437;
                    }
                    case "threshold":
                    {
                        this.threshold = true;
                        flash.external.ExternalInterface.call("roboTurk.hideMinigame");
                        continue label437;
                    }
                    case "time":
                    {
                        this.s.writeUTFBytes(loc1 + "\n");
                        this.s.flush();
                        continue label437;
                    }
                    default:
                    {
                        if (loc5 != null) 
                        {
                            trace("misunderstood command: ", loc4, loc5);
                        }
                    }
                }
            }
            return;
        }

        protected function onSocketConnect(arg1:flash.events.Event):void
        {
            trace("socket connected", arg1);
            this.heartbeat.addEventListener(flash.events.TimerEvent.TIMER, this.onHeartbeat);
            this.heartbeat.start();
            return;
        }

        protected function onHeartbeat(arg1:flash.events.TimerEvent):void
        {
            var loc1:*=this.makeRoboTurkInfo("ping");
            this.s.writeUTFBytes("ping:" + loc1 + "\n");
            this.s.flush();
            return;
        }

        internal function disconnect():void
        {
            if (this.s.connected) 
            {
                this.s.close();
            }
            return;
        }

        internal function killServer():void
        {
            trace("sending exit message");
            this.s.writeUTFBytes("exit\n");
            this.s.flush();
            return;
        }

        internal function onSocketClose(arg1:flash.events.Event):void
        {
            trace("socket closed", arg1);
            return;
        }

        internal function onSocketIOError(arg1:flash.events.IOErrorEvent):void
        {
            trace("io error event: ", arg1);
            return;
        }

        internal function onSocketSecError(arg1:flash.events.SecurityErrorEvent):void
        {
            trace("security error event: ", arg1);
            return;
        }

        internal function onStreamBW():void
        {
            trace("hmm, stream BW");
            return;
        }

        public function KeyStream()
        {
            this.hitInfo = {"assignmentId":"UNSET", "workerId":"UNSET", "hitId":"UNSET", "turkSubmitTo":"UNSET"};
            this.heartbeat = new flash.utils.Timer(100);
            this.connectionClient = {"onBWDone":this.onStreamBW};
            super();
            this.init();
            return;
        }

        internal function initTurkerInterface():void
        {
            this.ti = new TurkerInterface();
            addChild(this.ti);
            return;
        }

        public function init():void
        {
            this.initKeys();
            this.initMouse();
            this.initStream();
            this.initText();
            this.initSocket();
            this.initTurkerInterface();
            return;
        }

        protected var s:flash.net.Socket;

        protected var v:flash.media.Video;

        protected var nc:flash.net.NetConnection;

        protected var ns:flash.net.NetStream;

        protected var host:String="roc.cs.rochester.edu";

        protected var socketPort:uint=8000;

        protected var t:flash.text.TextField;

        protected var hitInfo:Object;

        protected var hitJSON:Object;

        protected var ti:TurkerInterface;

        protected var threshold:Boolean=false;

        protected var heartbeat:flash.utils.Timer;

        protected var submitOkay:Boolean=false;

        protected var scaleFactor:Number;

        protected var offsetX:uint;

        protected var offsetY:uint;

        protected var barSize:Number=0;

        protected var sideBars:Boolean=false;

        protected var connectionClient:*;
    }
}
