package {
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.Mouse;
	import flash.utils.*;
	
	public class KeyStream extends Sprite {
		protected var
			s:Socket,
			v:Video,
			nc:NetConnection,
			ns:NetStream,
			host:String = 'roc.cs.rochester.edu', //'dynamic-addr-134-2.resnet.rochester.edu',
			socketPort:uint = 8000,
			t:TextField,
			hitInfo:Object = {
				assignmentId: 'UNSET',
				workerId: 'UNSET',
				hitId: 'UNSET',
				turkSubmitTo: 'UNSET'
			},
			ti:TurkerInterface,
			threshold:Boolean = false,
			heartbeat:Timer = new Timer(100),
			submitOkay:Boolean = false;
			
		protected var connectionClient:* = {
			onBWDone: onStreamBW
		}
	
		public function KeyStream(){
			init();
		}
		
		public function init():void {
			
			initKeys();
			initStream();
			
			// Useful for debugging RTMFP connections.
			initText();
			
			initSocket(); // must go after initText because initText reads the hitId
			
			initTurkerInterface();
		}
		
		private function initTurkerInterface():void {
			ti = new TurkerInterface();
			addChild(ti)
		}
		
		private function initText():void {
			t = new TextField();
			t.width = 250;
			t.height = 100;
			t.textColor = 0xffffff;
			t.multiline = true;
			t.wordWrap = true;
			t.visible = false;
			t.background = true;
			t.backgroundColor = 0;
			t.selectable = false;
			
			var fmt:TextFormat = new TextFormat('_sans', 24, 0xffffff);
			t.defaultTextFormat = fmt;
			t.setTextFormat(fmt);
			
			//addChild(t);
			
			var ret:String = ExternalInterface.call('window.location.search.toString') as String;
			
			if(ret.length > 1){
				var parts:Array = ret.substring(1).split('&');
				for(var i:int = 0; i < parts.length; i++){
					var keyval:Array = parts[i].split('=');
					var key:String = keyval[0];
					var val:String = decodeURIComponent(keyval[1]);
					hitInfo[key] = val;
				}
			}
			
			//t.text = 'AssignmentID: ' + hitInfo.assignmentId + '\nHit ID: ' + hitInfo.hitId + '\nWorkerID: ' + hitInfo.workerId + '\n' + ret;
			t.visible = true;
			if(hitInfo.assignmentId == 'UNSET' || hitInfo.assignmentId == 'ASSIGNMENT_ID_NOT_AVAILABLE'){
				// tea demo hack
				if(hitInfo.special == 'true'){
					hitInfo.assignmentId = new Date().getTime().toString(16) + '' +  Math.random();
					hitInfo.workerId = new Date().getTime().toString(16) + '' + Math.random();
					hitInfo.hitId = new Date().getTime().toString(16) + '' + Math.random();
				}
				
				// This stuff is for 'real' turk stuff
				
				t.text = 'Key commands not accepted until the HIT is accepted.'
					
				if(hitInfo.special == 'true'){
					t.text = 'Special user';
				}
			}
			
			//addEventListener(Event.ENTER_FRAME, updateDebugText);
		}
		
		private function updateDebugText(e:Event):void {
			if(ns){
				t.text = 'Delay: ' + ns.liveDelay + ', FPS: ' + ns.currentFPS;
			}
		}
		
		protected function initStream():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			v = new Video();
			addChild(v);
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);
			nc.client = connectionClient;
			nc.connect('rtmfp://' + host + '/live/_definst_');
			
			// unrelated, add click to fullscreen
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onClick);
		}
		
		protected function onClick(e:MouseEvent):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
			v.width = Capabilities.screenResolutionX;
			v.height = Capabilities.screenResolutionY;
		}
		
		protected function initKeys():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function initSocket():void {
			if(hitInfo.assignmentId == 'UNSET' || hitInfo.assignmentId == 'ASSIGNMENT_ID_NOT_AVAILABLE') return;
			
			s = new Socket();
			s.addEventListener(Event.CLOSE, onSocketClose);
			s.addEventListener(Event.CONNECT, onSocketConnect);
			s.addEventListener(IOErrorEvent.IO_ERROR, onSocketIOError);
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecError);
			s.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			s.connect(host, socketPort);
		}
		
		protected function onStreamStatus(e:NetStatusEvent):void {
			trace('NetStatus: ', e.info.code);
			if(e.info.code == 'NetConnection.Connect.Success'){
				var stream:NetStream = new NetStream(nc);
				ns = stream;
				stream.client = connectionClient;
				v.attachNetStream(stream);
				stream.play('livestream');
				trace('buff:', stream.bufferLength, stream.bufferTime);
				v.width = 640;
				v.height = 480;
			}
		}
		
		/**
		 * This generates the string that's sent with each keypress/ping to roboTurk
		 */
		private function makeRoboTurkInfo(info:String):String {
			return [hitInfo.special == 'true' ? 'special' + hitInfo.workerId : hitInfo.workerId, hitInfo.assignmentId, info, new Date().getTime()].join(':');
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if(!s || !s.connected) return;
			var char:String = String.fromCharCode(e.charCode);
			
			// If the rating isn't a number, ignore it
			// TODO: Fix 30 and 40 to correctly bound the range of numbers
			if( e.charCode < 30 || e.charCode > 40 ) return;
			
			if(!threshold){
				return;
			}
			
			if(!submitOkay){
				ExternalInterface.call('roboTurk.showSubmit');
				submitOkay = true;
			}
			
			//trace(e.keyCode, e.charCode, '---' + char + '---');
			char = "rating=" + char;
			if(e.charCode > 0 && char != ' ' && e.keyCode != 13){
				str = makeRoboTurkInfo(char);
				s.writeUTFBytes(str + '\n');
				trace('sendkey', char);
			} else {
				var str:String;
				
				// modified these to be 'wasd' instead up 'updownleftright' for InputMediator consistency
				switch(e.keyCode){
					case 38: // up
						str = 'up';
						break;
					case 40: // down
						str = 'down';
						break;
					case 37: // left
						str = 'q';
						break;
					case 39: // right
						str = 'e';
						break;
					case 13: // return
						str = 'return';
						break;
					case 32: // space
						str = 'space';
						break;
				}		
				
				var key_str:String = str;
				str = makeRoboTurkInfo(key_str);
				
				trace('socketsending: ', str);
				
				s.writeUTFBytes(str + '\n');
			}
			s.flush();
		}
		
		protected function onSocketData(e:ProgressEvent):void {
			
			var response:String = s.readUTFBytes(s.bytesAvailable);
			var responses:Array = response.split('\n');
			trace('socket data', response);
			
			//t.text = 'sdata ' + response;
			
			for each(response in responses){
				var arr:Array = response.split(':');
				var command:String = arr[0];
				var val:String = arr[1];
				
				//if(!command) continue;
				
				switch(command){
					case 'epoch_pay':
						var amount:Number = parseFloat(val);
						//ExternalInterface.call('roboTurk.epochPay', amount);
						break;
					case 'disconnect':
						ExternalInterface.call('roboTurk.disconnect');
						disconnect();
						break;
					case 'last_action':
						//t.text = 'crowd direction: ' + val;
						ti.crowdText = val;
						break;
					case 'weight':
						ti.weight = parseFloat(val);
						ExternalInterface.call('roboTurk.epochPay', parseFloat(val) / 10);
						//t.text = 'ping: ' + val;
						break;
					case 'max':
						ti.leaderWeight = parseFloat(val);
						//ExternalInterface.call('roboTurk.updateTime', parseFloat(val) * 300000, val);
						break;
					case 'threshold':
						threshold = true;
						ExternalInterface.call('roboTurk.hideMinigame');
						break;
					case 'time':
						s.writeUTFBytes(response + '\n');
						s.flush();
						break;
					default:
						if(val != null) trace('misunderstood command: ', command, val);
				}
			}
		}
		
		protected function onSocketConnect(e:Event):void {
			trace('socket connected', e);
			heartbeat.addEventListener(TimerEvent.TIMER, onHeartbeat);
			heartbeat.start();
			//setTimeout(killServer, 45000);
		}
		
		protected function onHeartbeat(e:TimerEvent):void {
			var str:String = makeRoboTurkInfo('ping');
			//trace('sending--' + 'ping:' + str + '\n');
			s.writeUTFBytes('ping:' + str + '\n')
			//t.appendText('pinging');
			s.flush();
		}
		
		private function disconnect():void {
			if(s.connected) s.close();
		}
		
		private function killServer():void {
			trace('sending exit message');
			s.writeUTFBytes('exit\n');
			s.flush();
		}
		
		private function onSocketClose(e:Event):void {
			trace('socket closed', e);
		}
		
		private function onSocketIOError(e:IOErrorEvent):void {
			trace('io error event: ', e);
		}
		
		private function onSocketSecError(e:SecurityErrorEvent):void {
			trace('security error event: ', e);
		}
		
		private function onStreamBW():void {
			trace('hmm, stream BW');
		}
	}
}