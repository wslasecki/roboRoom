package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.text.*;
	import flash.utils.*;

	public class ObsTurkerInterface extends Sprite {
		public var currentKey:String = '';
		
		
		//⎈ \u2638
		[Embed(source="./ArialUnicode.ttf", fontName="ArialUnicode", fontFamily="ArialUnicode", mimeType="application/x-font-truetype", embedAsCFF='false', unicodeRange="U+0021-U+007B,U+007B-U+007E,U+00A1-U+00A3,U+00D6-U+00D8,U+2190-U+2194,U+21B5-U+2200,U+2712-U+2714")]
		public static const font:String;
		
		public static const greenTF:TextFormat = new TextFormat('ArialUnicode', 50, 0x00ff00),
							redTF:TextFormat = new TextFormat('ArialUnicode', 50, 0xff0000);
		
		[Embed(source="./crowd_you.png", mimeType="image/png")]
		public static const diagram:Class;
		
		private var _keyFeedback:TextField,
					_keyBG:Sprite,
					_crowdFeedback:TextField,
					_crowdBG:Sprite,
					_idleFeedback:TextField,
					_idleBG:Sprite,
					_currentKeyCode:uint = 0,
					_feedbackHolder:Sprite = new Sprite(),
					_meter:AgreementMeter = new AgreementMeter(),
					_weight:Number = 0,
					_leaderWeight:Number = 0,
					_diagram:Bitmap = new diagram() as Bitmap,
					_idle:uint,
					_crowdDir:String = '\u00d7';
		
		public function ObsTurkerInterface(){
			stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			_initFeedback();
			
			addChild(_meter);
			_meter.x = stage.stageWidth - _meter.width;
			_meter.y = 0;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _updateKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, _clearKey);
		}
		
		private function _initFeedback():void {
			_keyFeedback = new TextField();
			_keyFeedback.embedFonts = true;
			font;
			
			_crowdFeedback = new TextField();
			_crowdFeedback.embedFonts = true;
			
			_idleFeedback = new TextField();
			_idleFeedback.embedFonts = true;
			
			_keyFeedback.width = 50;
			_keyFeedback.height = 50;
			_keyFeedback.selectable = false;
			
			_crowdFeedback.width = 50;
			_crowdFeedback.height = 50;
			_crowdFeedback.selectable = false;
			
			_idleFeedback.width = stage.stageWidth;
			_idleFeedback.height = 70;
			_idleFeedback.multiline = true;
			_idleFeedback.wordWrap = true;
			//_idleFeedback.selectable = false;
			
			_crowdFeedback.x = -10;
			_keyFeedback.x = 140;
			_idleFeedback.y = (stage.stageWidth - 70) / 2 - 100;
			
			var tf:TextFormat = new TextFormat('ArialUnicode', 50, 0xffffff);
			tf.align = TextFormatAlign.CENTER;
			_keyFeedback.defaultTextFormat = tf;
			_crowdFeedback.defaultTextFormat = tf;
			
			var itf:TextFormat = new TextFormat('ArialUnicode', 50, 0xff0000);
			itf.align = TextFormatAlign.CENTER;
			itf.leading = -20;
			_idleFeedback.defaultTextFormat = itf;
			
			_keyFeedback.text = '\u00d7';
			_crowdFeedback.text = 'x';
			//_keyFeedback.setTextFormat(tf);
			
			_idleFeedback.text = 'Please input a command.';
			
			// text background
			_keyBG = new Sprite();
			_keyBG.graphics.beginFill(0x000000, 0.75);
			_keyBG.graphics.drawRect(0, 0, 50, 50);
			_keyBG.graphics.endFill();
			_keyBG.x = _keyFeedback.x;
			
			_crowdBG = new Sprite();
			_disagree();
			
			_idleBG = new Sprite();
			_idleBG.graphics.beginFill(0, 0.75);
			_idleBG.graphics.drawRect(0, (stage.stageWidth - 70) / 2 - 100, stage.stageWidth, 70);
			_idleBG.graphics.endFill();
			
			addChild(_idleBG);
			addChild(_idleFeedback);
			
			addChild(_diagram);
			addChild(_feedbackHolder);
			_feedbackHolder.addChild(_keyBG)
			addChild(_crowdBG);
			_feedbackHolder.addChild(_keyFeedback);
			_feedbackHolder.addChild(_crowdFeedback);
			_crowdFeedback.visible = false;
			
			_feedbackHolder.x = stage.stageWidth - _feedbackHolder.width;
			_feedbackHolder.y = stage.stageHeight - _diagram.height - _feedbackHolder.height;
			
			_keyFeedback.y -= 20;
			_crowdFeedback.y -= 20;
			
			_diagram.x = stage.stageWidth - _diagram.width;
			_diagram.y = stage.stageHeight - _diagram.height;
			
		}
		
		private function _fade(e:Event):void {
			if(_keyFeedback.alpha > 0){
				_keyFeedback.alpha -= 1.0 / 15;
				_keyBG.alpha = _keyFeedback.alpha;
			}
		}
		
		private function _updateKey(e:KeyboardEvent):void {
			_currentKeyCode = e.keyCode;
			
			_idleFeedback.alpha = 0;
			_idleBG.alpha = 0;
			clearTimeout(_idle);
			
			if(e.charCode > 0){
				currentKey = String.fromCharCode(e.charCode);
				var map:* = {
					w: ' ↑', a: ' ←', s: ' ↓', d: ' →', q: ' ↶', e: ' ↷'
				}
				map[' '] = '\u00d7';
				currentKey += map[currentKey] || '';
			} else {
				switch(e.keyCode){
					case 37: // left
						currentKey = '←';
						break;
					
					case 39: // right
						currentKey = '→';
						break;
					
					case 40: // down
						currentKey = '↓';
						break;
					
					case 38: // up
						currentKey = '↑';
						break;
					default: 
						currentKey = '?';
				}
			}
			
			_keyFeedback.text = currentKey;
			_keyFeedback.alpha = 1;
			_keyBG.alpha = 1;
			removeEventListener(Event.ENTER_FRAME, _fade);
			
			if(_crowdDir == currentKey){
				_agree();
			} else {
				_disagree();
			}
		}
		
		private function _clearKey(e:KeyboardEvent):void {
			if(e.keyCode == _currentKeyCode){
				//_keyFeedback.text = '';
				addEventListener(Event.ENTER_FRAME, _fade);
			}
			
			clearTimeout(_idle);
			_idle = setTimeout(_displayIdle, 2000);
		}
		
		private function _displayIdle():void {
			_idleFeedback.alpha = 1;
			_idleBG.alpha = 1;
		}
		
		public function set crowdText(s:String):void {
			var str:String = '';
			switch(s){
				case 'up':
					str = '↑';
					break;
				case 'down':
					str = '↓';
					break;
				case 'left':
					str = '←';
					break;
				case 'right':
					str = '→';
					break
				case 'q':
					str = '←';
					break;
				case 'e':
					str = '→';
					break
				default:
					str = '\u00d7';
			}
			_crowdDir = str;
			if(str == _keyFeedback.text){
				_agree();
			} else {
				_disagree();
			}
		}
		
		private function _agree():void {
			_crowdBG.graphics.clear();
			_crowdBG.graphics.beginFill(0, 0.75);
			_crowdBG.graphics.drawRect(0, 0, 150, 82);
			_crowdBG.graphics.endFill();
			_crowdBG.x = stage.stageWidth - 251;
			_crowdBG.y = stage.stageHeight - 82;
		}
		
		private function _disagree():void {
			_crowdBG.graphics.clear();
			_crowdBG.graphics.beginFill(0, 0.75);
			_crowdBG.graphics.drawRect(0, 0, 100, 82);
			_crowdBG.graphics.endFill();
			_crowdBG.x = stage.stageWidth - 100;
			_crowdBG.y = stage.stageHeight - 82;
		}
		
		public function get weight():Number {
			return _weight;
		}
		
		public function set weight(val:Number):void {
			if(val != _weight){
				_weight = val;
				_meter.updateTo(_weight, _leaderWeight);
			}
		}
		
		public function set leaderWeight(val:Number):void {
			if(val != _leaderWeight){
				_leaderWeight = val;
				_meter.updateTo(_weight, _leaderWeight);
			}
		}
		
		public function get leaderWeight():Number {
			return _leaderWeight;
		}
	}
}

import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.utils.*;

internal class AgreementMeter extends Sprite {
	private var _bar:Shape = new Shape(),
				_outline:Shape = new Shape(),
				_bg:Shape = new Shape(),
				_mark:Shape = new Shape(),
				_text:TextField = new TextField(),
				_best:TextField = new TextField(),
				_you:TextField = new TextField(),
				_target:Number = 0,
				_val:Number = 0,
				_leader:Number = 0;
	
	private var _w:int = 35,
				_h:int = 150,
				_margin:int = 15;
	
	public static const speed:Number = 0.02;
	
	public function AgreementMeter(){
		_init();
		
		addChild(_bg);
		addChild(_outline);
		addChild(_bar);
		addChild(_mark);
		addChild(_text);
		addChild(_best);
		addChild(_you);
	}
	
	private function _init():void {
		_bg.graphics.clear(), _outline.graphics.clear(), _bar.graphics.clear(),
		_mark.graphics.clear(); // in case this func is re-called
		
		_bg.graphics.beginFill(0xffffff, 0.35);
		_bg.graphics.drawRoundRect(0, 0, _w + 2 * _margin, _h + 2 * _margin, _margin, _margin);
		_bg.graphics.endFill();
		
		_outline.graphics.lineStyle(2);
		_outline.graphics.drawRect(_margin, _margin, _w, _h);
		
		var tf:TextFormat = new TextFormat('ArialUnicode', 11, 0);
		tf.align = TextFormatAlign.CENTER;
		
		_best.defaultTextFormat = tf;
		_you.defaultTextFormat = tf;
		_text.defaultTextFormat = tf;
		
		_best.text = '¢MAX';
		_best.x = _margin;
		_best.width = _w;
		_best.height = 15;
		
		_you.text = 'YOU';
		_you.width = _w;
		_you.x = _margin;
		
		_text.width = _w;
		_text.text = (0).toString();
		_text.x = _margin;
	}
	
	public function updateTo(val:Number, leader:Number):void {
		if(val == _target && leader == _leader) return;
		
		_target = Math.min(Math.max(val, 0), 1); // clamp
		_leader = Math.min(Math.max(leader, 0), 1);
		
		addEventListener(Event.ENTER_FRAME, _update);
		_update();
	}
	
	private function _update(e:Event = null):void {
		var diff:Number = Math.abs(_target - _val);
		var sign:int = _target - _val > 0 ? 1 : -1;
		
		_val += Math.min(speed, diff) * sign;
		_bar.graphics.clear();
		_bar.graphics.beginFill(0xff0000, 0.5);
		_bar.graphics.drawRect(_margin, _h - (_h * _val) + _margin, _w, _h * _val);
		_bar.graphics.endFill();
		
		_you.y = _h - (_h * _val) + _margin;
		
		_mark.graphics.clear();
		_mark.graphics.beginFill(0x00ff00, 0.5);
		_mark.graphics.drawRect(_margin, _h - (_h * _leader) + _margin, _w, 5);
		_mark.graphics.endFill();
		
		_best.y = _h - (_h * _leader) + _margin - _best.height;
		
		_text.text = (_val * 10).toFixed(0);
		
		if(_val == _target){
			removeEventListener(Event.ENTER_FRAME, arguments.callee);
		}
	}
}