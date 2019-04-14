package {
	
	import com.Common;
	import com.manager.CalendarManager;
	import com.manager.SourceManager;
	import com.manager.UIManager;
	import com.sociodox.theminer.TheMiner;
	import com.tconst.MenuConst;
	import com.ui.componet.Container;
	import com.ui.componet.shape.SixShape;
	import com.ui.componet.slider.SliderEvent;
	import com.ui.componet.slider.VSlider;
	import com.ui.componet.VSprite;
	import com.ui.item.ToolItem;
	import com.UIGlobal;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	/**
	 * 工具箱
	 * @author taojianlong 2014-2-22 19:57
	 */
	[SWF(width='800',height='600',backgroundColor='#ccffcc',frameRate='30')]	
	public class Main extends MainSprite {
		
		private var toolInfoList:Array = [
		        {label: "SwfTool", id: 1, des: "swf文件读取保存工具" }, 
				{label: "GifTool", id: 2, des: "gif读取工具" }, 
				{label: "Log System", id: 3, des: "日志系统" }, 
				{label: "XML Parser", id: 4, des: "xml解析器，读取并修改保存xml文件." },
				{label: "Permanent Calendar", id: 5, des: "万年历" },
				{label: "ExcelTool", id: 6 , des:"excel表格处理工具"}, 
				{label: "Encrypt Tool", id: 7 , des:"加密解密界面"},
				{label: "tool_8", id: 8 }, 
				{ label: "tool_9", id: 9 },
				{label: "tool_10", id: 10 },
				{ label: "tool_11", id: 11 }, 
				{label: "tool_12", id: 12 },
				{ label: "tool_13", id: 13 },
				{label: "tool_14", id: 14 },
				{label: "tool_15", id: 15 }
			];
		
		private var toolList:VSprite;
		private var slider:VSlider;
		private var uiLayer:Container; //添加UI层
		
		public function Main():void {
			
			//System.useCodePage = true; //外部文本文件不是 Unicode 编码格式，则应将 useCodePage 设置为 true
			
			super();
		}
		
		override protected function init(event:Event = null):void {
			
			super.init(event);
			
			SourceManager.Instance.startLoad(initUI); //加载初始化资源
		}
		
		protected function initUI():void {
			
			Common.stage = stage;
			
			this.addChild(UIGlobal.bottomLayer);
			this.addChild(UIGlobal.uiLayer);
			this.addChild(UIGlobal.topLayer);
			this.addChild(UIGlobal.alertLayer);
			
			toolList = new VSprite();
			slider = new VSlider();
			uiLayer = new Container();
			
			toolList.x = 280;
			toolList.y = 100;
			toolList.gap = 3;
			
			slider.x = 500;
			slider.y = 100;
			
			slider.setRedBtnSource(new slider_red_out, new slider_red_over, new slider_red_down);
			slider.setAddBtnSource(new slider_add_out, new slider_add_over, new slider_add_down);
			slider.setBarBtnSource(new slider_bar_out, new slider_bar_over, new slider_bar_down);
			slider.setBarBackSource(new slider_back);
			
			UIGlobal.bottomLayer.addChild(toolList);
			UIGlobal.bottomLayer.addChild(slider);
			
			toolList.addEventListener(Event.CHANGE, changeHandler);
			toolList.addEventListener(MouseEvent.CLICK, clickToolitemHandler);
			
			var data:Object;
			var toolItem:ToolItem;
			for (var i:int = 0; i < toolInfoList.length; i++) {
				data = toolInfoList[i];
				if (data) {
					toolItem = new ToolItem();
					toolItem.data = data;
					toolList.addElement(toolItem);
				}
			}
			
			slider.target = toolList;
			slider.setMask(200, 240);
			slider.sliderValue = 5;
			slider.addEventListener(SliderEvent.SLIDER_STOP_RENDER, sliderStopRenderHandler);
			slider.addEventListener(SliderEvent.SLIDER_DOWN, sliderDownRenderHandler);
			
			//性能测试工具
			this.addChild( new TheMiner() );
			
			this.addChild( new SixShape() );
		}
		
		private function changeHandler(event:Event):void {
			
			slider.updateTarget();
		}
		
		private function sliderDownRenderHandler(event:Event):void {
			
			toolList.isUpdate = false;
		}
		
		private function sliderStopRenderHandler(event:SliderEvent):void {
			
			toolList.isUpdate = true;
		}
		
		private function clickToolitemHandler(event:MouseEvent):void {
			
			var toolItem:ToolItem = event.target as ToolItem;
			if (toolItem && toolItem.data) {
				
				UIManager.Instance.removeAllUILayerElements();
				
				switch (toolItem.data.id) {
					
					case MenuConst.MENU_SwfTool: 
						UIManager.Instance.openSwfToolUI();
						break;
					
					case MenuConst.MENU_GifTool: 
						UIManager.Instance.openGifToolUI();
						break;
					
					case MenuConst.MENU_LogSystem: 
						UIManager.Instance.openLogUI();
						break;
					
					case MenuConst.MENU_XmlParser: 
						UIManager.Instance.openXMLParserUI();
						break;
					
					case MenuConst.MENU_Calendar: 
						UIManager.Instance.openCalendarUI();
						break;
						
					case MenuConst.MENU_Excel:
						UIManager.Instance.openExcelToolUI();
						break;
						
					case MenuConst.MENU_Encrypt:
						UIManager.Instance.openEncryptUI();
						break;
				}
			}
		}
		
		//-------------------------------------------------------
		
		override protected function keyUpHandler(event:KeyboardEvent):void {
			
			super.keyUpHandler(event);
		}
		
		//全局渲染
		override protected function render(event:Event):void {
			
			super.render(event);
			
		}
		
		//全局秒钟刷新
		override protected function sceondRender(event:TimerEvent):void {
			
			super.sceondRender(event);
			
			CalendarManager.Instance.sceondRender();
		}
	}

}