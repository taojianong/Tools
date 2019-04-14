package com.ui.gif {
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.manager.UIManager;
	import com.tools.gifv.GIFBoy;
	import com.tools.gifv.GIFEvent;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Container;
	import com.ui.componet.TextInput;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * Gif解析工具
	 * @author taojianlong 2014-2-7 13:37
	 */
	public class GifToolUI extends BaseUI {
		
		private var xml:XML =  <data>
				<Container id="imgCon" />
				<TextInput id="inputTxt" x="400" text="10"/>
				<Button id="showBtn" x="500" label="显示GIF图片" />
				<Button id="closeBtn" x="730" y="5" label="" outSourceClass="common|close_out" overSourceClass="common|close_over" downSourceClass="common|close_down" />
			</data>
		
		private var inputTxt:TextInput; //输入帧频
		private var showBtn:Button; //显示每帧图片
		private var imgCon:Container;
		
		private var loader:URLLoader;
		private var gifBoy:GIFBoy;
		
		public function GifToolUI() {
			
			super( xml , 800 , 600 , 0xcccccc , 0.8 );			
		}
		
		override protected function init():void {
			
			super.init();
			
			imgCon   = this.getElementById("imgCon");
			inputTxt = this.getElementById("inputTxt");
			showBtn  = this.getElementById("showBtn");
			
			inputTxt.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest("gif/2.gif"));
			loader.addEventListener(Event.COMPLETE, loadGifComplete);			
		}
		
		private function focusOutHandler(event:FocusEvent):void {
			
			if (gifBoy) {
				gifBoy.fps = int(inputTxt.text);
			}
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			var btn:Button = event.target as Button;
			clickBtn( btn );			
		}
		
		private function clickBtn( btn:Button ):void {
			
			switch (btn && btn.id) {
				
				case "closeBtn":
					UIManager.Instance.closeGifToolUI();
					break;
				
				case "showBtn": 
					if (gifBoy) {
						imgCon.removeAll();
						var bmp:Bitmap;
						var gap:int = 5;
						var allWidth:Number = 0;
						var i:int = 0;
						var frames:Array = gifBoy.frames;
						var timeline:TimelineMax = new TimelineMax();
						allWidth = frames.length > 0 ? (frames.length - 1) * gap : 0;
						for (i = 0; i < frames.length; i++) {
							bmp = frames[i];
							allWidth += bmp.width;
							bmp.y = 50;
							bmp.x = stage.stageWidth / 2;
							if (bmp && !this.contains(bmp)) {
								imgCon.addChild(bmp);
							}
						}
						var toX:Number = (stage.stageWidth - allWidth) / 2;
						for (i = 0; i < frames.length; i++) {
							bmp = frames[i];
							toX = i > 0 ? toX + frames[i - 1].width + gap : toX;
							timeline.insert(TweenLite.to(bmp, 0.5, {x: toX}));
							trace("toX: " + toX);
						}
						//timeline.play();
					}
					break;
			}
		}
		
		private function loadGifComplete(event:Event):void {
			
			var gifLoader:GIFBoy = new GIFBoy();
			gifLoader.addEventListener(GIFEvent.OK, gifCompleted);
			gifLoader.loadBytes(loader.data);
		}
		
		private function gifCompleted(event:GIFEvent):void {
			
			gifBoy = event.target as GIFBoy;
			gifBoy.x = (stage.stageWidth - gifBoy.width) * 0.5;
			gifBoy.y = (stage.stageHeight - gifBoy.height) * 0.5;
			this.addChild(gifBoy);
		}
	}

}