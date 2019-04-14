package {
	
	import com.ui.componet.base.BaseSprite;
	import com.ui.swftool.SwfToolUI;
	import com.UIGlobal;
	import flash.events.Event;
	
	/**
	 * swf工具
	 * 说明: 要实现打包SWF工具时,将项目编译的AIR安装文件打包成EXE，并安装在未有带空格的文件夹下
	 * 打包EXE步骤：
	 *  1、<supportedProfiles>desktop extendedDesktop</supportedProfiles>添加在air主页的xml配置文件下
		2、export导出air程序
		3、将程序拷贝到sdk下的bin目录下，如D:\Program Files\Adobe\Flex Builder 3 Plug-in\sdks\3.2.0\bin
		这里要注意下air的版本问题，将文件重命名为myApp.air（不该也可以，在输入时换成文件名就可以了）
		4、开始-运行-cmd-cd..返回到c盘目录下，如果在D盘的话，输入d:就可以了 然后输入cd Prog （可以直接手打，也可以tab键偷懒）回车继续cd Ado.....一直输出到bin目录下
		　复制粘贴adt -package -target native myAir.exe myApp.air 回车执行 如果不报错的话 就生成成功了 去bin目录下找到exe文件拷贝出来就可以了
		
	 * @author taojianlong 2013-12-15 23:24
	 */
	[SWF(width='800',height='600',backgroundColor='#cccccc',frameRate='30')]
	public class SwfTool extends BaseSprite {
		
		public function SwfTool() {
			
			super();
		}
		
		override protected function addToStageHandler( event:Event ):void {
			
			super.addToStageHandler(event);
			
			if ( UIGlobal.swfToolUI == null) {
				
				UIGlobal.swfToolUI = new SwfToolUI();
			}
			this.addChild( UIGlobal.swfToolUI );
		}
	}

}