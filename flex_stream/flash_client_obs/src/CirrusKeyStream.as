package {
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class CirrusKeyStream extends KeyStream {
		private var	
			devKey:String = '032b86a57fd53f9874a4bc5f-ed2e9b6d4a1f',
			cirrusURI:String = 'rtmfp://p2p.rtmfp.net/032b86a57fd53f9874a4bc5f-ed2e9b6d4a1f/',
			farID:String;
		
		public function CirrusKeyStream(){
			super();
		}
		
		override public function init():void {
			initSocket();
			initKeys();
		}
		
		override protected function initStream():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			v = new Video();
			addChild(v);
			
			// new stuff for RTFMP
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			nc.client = connectionClient;
			nc.connect(cirrusURI);
		}
		
		override protected function onSocketConnect(e:Event):void {
			super.onSocketConnect(e);
			s.writeUTFBytes('ping\r\n');
		}
		
		override protected function onSocketData(e:ProgressEvent):void  {
			var str:String = s.readUTFBytes(s.bytesAvailable);
			trace('socket data: ', str);
			if(str.indexOf('publisher') == 0){
				farID = str.substring(10).split('\n').join('');
				trace('farID: ', farID);
				
				initStream();
			}
		}
		
		protected function onConnectionStatus(e:NetStatusEvent):void {
			trace('stream NetStatus: ', e.info.code);
			
			if(e.info.code == 'NetConnection.Connect.Success'){
			
				ns = new NetStream(nc, farID);
				ns.addEventListener(NetStatusEvent.NET_STATUS, onStreamStatus);
				v.attachNetStream(ns);
				ns.play('screencast');
			}
		}
		
		override protected function onStreamStatus(e:NetStatusEvent):void {
			trace('connection NetStatus: ', e.info.code);
			
		}
		
	}
}