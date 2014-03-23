package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class TurkerInterface extends flash.display.Sprite
    {
        public function get leaderWeight():Number
        {
            return this._leaderWeight;
        }

        public function set leaderWeight(arg1:Number):void
        {
            if (arg1 != this._leaderWeight) 
            {
                this._leaderWeight = arg1;
                this._meter.updateTo(this._weight, this._leaderWeight);
            }
            return;
        }

        public function set weight(arg1:Number):void
        {
            if (arg1 != this._weight) 
            {
                this._weight = arg1;
                this._meter.updateTo(this._weight, this._leaderWeight);
            }
            return;
        }

        public function get weight():Number
        {
            return this._weight;
        }

        internal function _disagree():void
        {
            this._crowdBG.graphics.clear();
            this._crowdBG.graphics.beginFill(0, 0.75);
            this._crowdBG.graphics.drawRect(0, 0, 100, 82);
            this._crowdBG.graphics.endFill();
            this._crowdBG.x = stage.stageWidth - 100;
            this._crowdBG.y = stage.stageHeight - 82;
            return;
        }

        internal function _agree():void
        {
            this._crowdBG.graphics.clear();
            this._crowdBG.graphics.beginFill(0, 0.75);
            this._crowdBG.graphics.drawRect(0, 0, 150, 82);
            this._crowdBG.graphics.endFill();
            this._crowdBG.x = stage.stageWidth - 251;
            this._crowdBG.y = stage.stageHeight - 82;
            return;
        }

        public function set crowdText(arg1:String):void
        {
            var loc1:*="";
            var loc2:*=arg1;
            switch (loc2) 
            {
                case "up":
                {
                    loc1 = "↑";
                    break;
                }
                case "down":
                {
                    loc1 = "↓";
                    break;
                }
                case "left":
                {
                    loc1 = "←";
                    break;
                }
                case "right":
                {
                    loc1 = "→";
                    break;
                }
                default:
                {
                    loc1 = arg1;
                }
            }
            this._crowdDir = loc1;
            if (loc1 != this._keyFeedback.text) 
            {
                this._disagree();
            }
            else 
            {
                this._agree();
            }
            return;
        }

        internal function _displayIdle():void
        {
            this._idleFeedback.alpha = 1;
            this._idleBG.alpha = 1;
            return;
        }

        internal function _clearKey(arg1:flash.events.KeyboardEvent):void
        {
            if (arg1.keyCode == this._currentKeyCode) 
            {
                addEventListener(flash.events.Event.ENTER_FRAME, this._fade);
            }
            flash.utils.clearTimeout(this._idle);
            this._idle = flash.utils.setTimeout(this._displayIdle, 2000);
            return;
        }

        internal function _updateKey(arg1:flash.events.KeyboardEvent):void
        {
            var loc1:*=undefined;
            this._currentKeyCode = arg1.keyCode;
            this._idleFeedback.alpha = 0;
            this._idleBG.alpha = 0;
            flash.utils.clearTimeout(this._idle);
            if (arg1.charCode > 0) 
            {
                this.currentKey = String.fromCharCode(arg1.charCode);
                loc1 = {"w":" ↑", "a":" ←", "s":" ↓", "d":" →", "q":" ↶", "e":" ↷"};
                loc1[" "] = "×";
                this.currentKey = this.currentKey + (loc1[this.currentKey] || "");
            }
            else 
            {
                var loc2:*=arg1.keyCode;
                switch (loc2) 
                {
                    case 37:
                    {
                        this.currentKey = "←";
                        break;
                    }
                    case 39:
                    {
                        this.currentKey = "→";
                        break;
                    }
                    case 40:
                    {
                        this.currentKey = "↓";
                        break;
                    }
                    case 38:
                    {
                        this.currentKey = "↑";
                        break;
                    }
                    default:
                    {
                        this.currentKey = "?";
                    }
                }
            }
            this._keyFeedback.text = this.currentKey;
            this._keyFeedback.alpha = 1;
            this._keyBG.alpha = 1;
            removeEventListener(flash.events.Event.ENTER_FRAME, this._fade);
            if (this._crowdDir != this.currentKey) 
            {
                this._disagree();
            }
            else 
            {
                this._agree();
            }
            return;
        }

        internal function _fade(arg1:flash.events.Event):void
        {
            if (this._keyFeedback.alpha > 0) 
            {
                this._keyFeedback.alpha = this._keyFeedback.alpha - 1 / 15;
                this._keyBG.alpha = this._keyFeedback.alpha;
            }
            return;
        }

        internal function _initFeedback():void
        {
            this._keyFeedback = new flash.text.TextField();
            this._keyFeedback.embedFonts = true;
            font;
            this._crowdFeedback = new flash.text.TextField();
            this._crowdFeedback.embedFonts = true;
            this._idleFeedback = new flash.text.TextField();
            this._idleFeedback.embedFonts = true;
            this._keyFeedback.width = 50;
            this._keyFeedback.height = 50;
            this._keyFeedback.selectable = false;
            this._crowdFeedback.width = 50;
            this._crowdFeedback.height = 50;
            this._crowdFeedback.selectable = false;
            this._idleFeedback.width = stage.stageWidth;
            this._idleFeedback.height = 70;
            this._idleFeedback.multiline = true;
            this._idleFeedback.wordWrap = true;
            this._crowdFeedback.x = -10;
            this._keyFeedback.x = 140;
            this._idleFeedback.y = (stage.stageWidth - 70) / 2 - 100;
            var loc1:*=new flash.text.TextFormat("ArialUnicode", 50, 16777215);
            loc1.align = flash.text.TextFormatAlign.CENTER;
            this._keyFeedback.defaultTextFormat = loc1;
            this._crowdFeedback.defaultTextFormat = loc1;
            var loc2:*=new flash.text.TextFormat("ArialUnicode", 50, 16711680);
            loc2.align = flash.text.TextFormatAlign.CENTER;
            loc2.leading = -20;
            this._idleFeedback.defaultTextFormat = loc2;
            this._keyFeedback.text = "×";
            this._crowdFeedback.text = "x";
            this._idleFeedback.text = "Please input a command.";
            this._keyBG = new flash.display.Sprite();
            this._keyBG.graphics.beginFill(0, 0.75);
            this._keyBG.graphics.drawRect(0, 0, 50, 50);
            this._keyBG.graphics.endFill();
            this._keyBG.x = this._keyFeedback.x;
            this._crowdBG = new flash.display.Sprite();
            this._disagree();
            this._idleBG = new flash.display.Sprite();
            this._idleBG.graphics.beginFill(0, 0.75);
            this._idleBG.graphics.drawRect(0, (stage.stageWidth - 70) / 2 - 100, stage.stageWidth, 70);
            this._idleBG.graphics.endFill();
            addChild(this._diagram);
            addChild(this._feedbackHolder);
            this._feedbackHolder.addChild(this._keyBG);
            addChild(this._crowdBG);
            this._feedbackHolder.addChild(this._keyFeedback);
            this._feedbackHolder.addChild(this._crowdFeedback);
            this._crowdFeedback.visible = false;
            this._feedbackHolder.x = stage.stageWidth - this._feedbackHolder.width;
            this._feedbackHolder.y = stage.stageHeight - this._diagram.height - this._feedbackHolder.height;
            this._keyFeedback.y = this._keyFeedback.y - 20;
            this._crowdFeedback.y = this._crowdFeedback.y - 20;
            this._diagram.x = stage.stageWidth - this._diagram.width;
            this._diagram.y = stage.stageHeight - this._diagram.height;
            return;
        }

        internal function init(arg1:flash.events.Event=null):void
        {
            this._initFeedback();
            addChild(this._meter);
            this._meter.x = stage.stageWidth - this._meter.width;
            this._meter.y = 0;
            stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, this._updateKey);
            stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, this._clearKey);
            return;
        }

        public function TurkerInterface()
        {
            this._feedbackHolder = new flash.display.Sprite();
            this._meter = new AgreementMeter();
            this._diagram = new diagram() as flash.display.Bitmap;
            super();
            if (stage) 
            {
                this.init();
            }
            else 
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, this.init);
            }
            return;
        }

        public static const diagram:Class=TurkerInterface_diagram;

        public static const redTF:flash.text.TextFormat=new flash.text.TextFormat("ArialUnicode", 50, 16711680);

        public static const greenTF:flash.text.TextFormat=new flash.text.TextFormat("ArialUnicode", 50, 65280);

        public static const font:String="TurkerInterface_font";

        public var currentKey:String="";

        internal var _keyFeedback:flash.text.TextField;

        internal var _keyBG:flash.display.Sprite;

        internal var _crowdFeedback:flash.text.TextField;

        internal var _crowdBG:flash.display.Sprite;

        internal var _idleFeedback:flash.text.TextField;

        internal var _idleBG:flash.display.Sprite;

        internal var _currentKeyCode:uint=0;

        internal var _feedbackHolder:flash.display.Sprite;

        internal var _meter:AgreementMeter;

        internal var _weight:Number=0;

        internal var _leaderWeight:Number=0;

        internal var _crowdDir:String="×";

        internal var _idle:uint;

        internal var _diagram:flash.display.Bitmap;
    }
}

import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.utils.*;


class AgreementMeter extends flash.display.Sprite
{
    public function AgreementMeter()
    {
        this._bar = new flash.display.Shape();
        this._outline = new flash.display.Shape();
        this._bg = new flash.display.Shape();
        this._mark = new flash.display.Shape();
        this._text = new flash.text.TextField();
        this._best = new flash.text.TextField();
        this._you = new flash.text.TextField();
        super();
        this._init();
        addChild(this._bg);
        addChild(this._outline);
        addChild(this._bar);
        addChild(this._mark);
        addChild(this._text);
        addChild(this._best);
        addChild(this._you);
        return;
    }

    internal function _update(arg1:flash.events.Event=null):void
    {
        var loc1:*=Math.abs(this._target - this._val);
        var loc2:*=this._target - this._val > 0 ? 1 : -1;
        this._val = this._val + Math.min(speed, loc1) * loc2;
        this._bar.graphics.clear();
        this._bar.graphics.beginFill(16711680, 0.5);
        this._bar.graphics.drawRect(this._margin, this._h - this._h * this._val + this._margin, this._w, this._h * this._val);
        this._bar.graphics.endFill();
        this._you.y = this._h - this._h * this._val + this._margin;
        this._mark.graphics.clear();
        this._mark.graphics.beginFill(65280, 0.5);
        this._mark.graphics.drawRect(this._margin, this._h - this._h * this._leader + this._margin, this._w, 5);
        this._mark.graphics.endFill();
        this._best.y = this._h - this._h * this._leader + this._margin - this._best.height;
        this._text.text = (this._val * 10).toFixed(0);
        if (this._val == this._target) 
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, arguments.callee);
        }
        return;
    }

    public function updateTo(arg1:Number, arg2:Number):void
    {
        if (arg1 == this._target && arg2 == this._leader) 
        {
            return;
        }
        this._target = Math.min(Math.max(arg1, 0), 1);
        this._leader = Math.min(Math.max(arg2, 0), 1);
        addEventListener(flash.events.Event.ENTER_FRAME, this._update);
        this._update();
        return;
    }

    internal function _init():void
    {
        this._bg.graphics.clear();
        this._outline.graphics.clear();
        this._bar.graphics.clear();
        this._mark.graphics.clear();
        this._bg.graphics.beginFill(16777215, 0.35);
        this._bg.graphics.drawRoundRect(0, 0, this._w + 2 * this._margin, this._h + 2 * this._margin, this._margin, this._margin);
        this._bg.graphics.endFill();
        this._outline.graphics.lineStyle(2);
        this._outline.graphics.drawRect(this._margin, this._margin, this._w, this._h);
        var loc1:*=new flash.text.TextFormat("ArialUnicode", 11, 0);
        loc1.align = flash.text.TextFormatAlign.CENTER;
        this._best.defaultTextFormat = loc1;
        this._you.defaultTextFormat = loc1;
        this._text.defaultTextFormat = loc1;
        this._best.text = "¢MAX";
        this._best.x = this._margin;
        this._best.width = this._w;
        this._best.height = 15;
        this._you.text = "YOU";
        this._you.width = this._w;
        this._you.x = this._margin;
        this._text.width = this._w;
        this._text.text = 0.toString();
        this._text.x = this._margin;
        return;
    }

    public static const speed:Number=0.02;

    internal var _text:flash.text.TextField;

    internal var _best:flash.text.TextField;

    internal var _you:flash.text.TextField;

    internal var _target:Number=0;

    internal var _val:Number=0;

    internal var _leader:Number=0;

    internal var _w:int=35;

    internal var _h:int=150;

    internal var _margin:int=15;

    internal var _mark:flash.display.Shape;

    internal var _bg:flash.display.Shape;

    internal var _outline:flash.display.Shape;

    internal var _bar:flash.display.Shape;
}