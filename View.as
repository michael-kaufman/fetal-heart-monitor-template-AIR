/**
 * @Company: High Impact
 * @author: Michael Kaufman
 * @authorUrl: http://www.highimpact.com
 * @date: 3/12/13
 */

package mvc
{	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import buttons.BPPButton;
	import buttons.BpmBlue;
	import buttons.BpmOrange;
	import buttons.BrushButton;
	import buttons.ClearButton;
	import buttons.ControllerBeginButton;
	import buttons.ControllerEndButton;
	import buttons.ControllerFFButton;
	import buttons.ControllerPlayButton;
	import buttons.ControllerRTButton;
	import buttons.ControllerRWButton;
	import buttons.EllipseButton;
	import buttons.LaunchPhotos;
	import buttons.LineButton;
	import buttons.LoadButton;
	import buttons.OneMinuteButton;
	import buttons.RectButton;
	import buttons.SaveButton;
	import buttons.SearchBox;
	import buttons.SearchPage;
	import buttons.SelectionButton;
	import buttons.SimpleToggleButton;
	import buttons.Snapshot;
	import buttons.TenMinuteButton;
	import buttons.TextButton;
	TweenPlugin.activate([TintPlugin]);	
	
	import flash.system.fscommand;
	import com.adobe.images.PNGEncoder;
	
	import com.highimpact.drawing.SimpleRectangle;
	import com.highimpact.utils.Counter;
	import com.highimpact.utils.SimpleButtons1;
		
	
	import com.nocircleno.graffiti.GraffitiCanvas;
	import com.nocircleno.graffiti.converters.FormatType;
	import com.nocircleno.graffiti.display.BrushObject;
	import com.nocircleno.graffiti.display.LineObject;
	import com.nocircleno.graffiti.display.ShapeObject;
	import com.nocircleno.graffiti.display.TextObject;
	import com.nocircleno.graffiti.events.GraffitiObjectEvent;
	import com.nocircleno.graffiti.managers.GraffitiObjectManager;
	import com.nocircleno.graffiti.tools.BrushTool;
	import com.nocircleno.graffiti.tools.BrushType;
	import com.nocircleno.graffiti.tools.EditableParams;
	import com.nocircleno.graffiti.tools.LineTool;
	import com.nocircleno.graffiti.tools.LineType;
	import com.nocircleno.graffiti.tools.SelectionTool;
	import com.nocircleno.graffiti.tools.ShapeTool;
	import com.nocircleno.graffiti.tools.ShapeType;
	import com.nocircleno.graffiti.tools.TextSettings;
	import com.nocircleno.graffiti.tools.TextTool;
	import com.nocircleno.graffiti.tools.ToolMode;
	import com.hybrid.ui.ToolTip;
	
	import fl.controls.ColorPicker;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import events.SliderInteractionEvent;
	import events.SliderEvent;	
	import events.ControllerEvent;	
	import events.SearchDayEvent

	import flash.text.StyleSheet;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.net.URLLoader;
	import flash.display.DisplayObjectContainer;



	public class View extends Sprite
	{
		
		
		[Embed(source="../assets/images/delete-icon.png")]
		private var DeleteButton:Class;			
				
		[Embed(source="../assets/swfs/bppChart.swf")]
		private var BPP:Class;		
		
		private var _model:Model;
		private var _controller:Controller;
		
		private var _toggleDrawingButton:SimpleToggleButton;
		private var _toggleAnnotationsButton:SimpleToggleButton;
		private var _toggleLandmarksButton:SimpleToggleButton;
		private var _toggleTimesButton:SimpleToggleButton;
		private var _sheet:StyleSheet = new StyleSheet();
		
		private var _mainContainer:Sprite;		
		private var _buttonContainer:Sprite;
		private var _logo:Loader;
		private var _login:LogInScreen;
		
		private var pngEncoder:PNGEncoder;
		private var byteArray:ByteArray;
		private var bitmapData:BitmapData;
		public var clear_button:ClearButton;	
		
		// graffiti
		private var _graffitiContainer:Sprite;
		public  var _canvas:GraffitiCanvas;
		private var _objectManager:GraffitiObjectManager;		
		private var _lineColorLabel:TextField;
		private var _fillColorLabel:TextField;
		private var _eraserTool:BrushTool;
		private var _brushTool:BrushTool;
		private var _selectionTool:SelectionTool;
		private var _rectTool:ShapeTool;
		private var _elipseTool:ShapeTool;
		private var _lineTool:LineTool;
		private var _textTool:TextTool;		
		private var _textObject:TextObject
		private var _brushSize:Number = 5;
		private var _strokeColor:uint = 0x00FF00;
		private var _fillColor:uint = 0xFF0000;
		private var _strokeAlpha:Number = 1;
		private var _fillAlpha:Number = 1;
		private var _brushBlur:Number = 0;
		private var _fontColor:uint = 0x00FF00;
		private var _fontSize:uint = 15;
		private var _brushShapeIndex:int;
		private var _lineStyleIndex:int;
		private var _fontIndex:uint = 0;
		private var _fontList:DataProvider;
		private var _brushShapes:DataProvider;
		private var _lineStyles:DataProvider;
		private var _traces:Sprite;
		private var _orangeLineHasCounter:Boolean = false;		
		private var _overlay_cb:ComboBox;		
		public var fill_color_mc:ColorPicker;
		public var stroke_color_mc:ColorPicker;
		public var font_cb:ComboBox;
		public var stroke_multiple_color_icon:Sprite;
		public var fill_multiple_color_icon:Sprite;
		public var font_multiple_icon:Sprite;	
		public var selection_button:SelectionButton;
		public var rect_button:RectButton;
		public var brush_button:BrushButton;
		public var ellipse_button:EllipseButton;
		public var line_button:LineButton;
		public var text_button:TextButton;
		private var _fontDataProvider:DataProvider;
		
		//schrifin lines
		private var _whiteLineContainer:Sprite = new Sprite();
		private var _blueLineContainer:Sprite = new Sprite();
		private var _orangeLineContainer:Sprite = new Sprite();
		private var _orangeCounter:Counter = new Counter();
		private var _blueCounter:Counter = new Counter();	
		private var _bpmBlueButton:BpmBlue;
		private var _bpmOrangeButton:BpmOrange;
		private var _blueLineExists:Boolean = false;
		private var _orangeLineExists:Boolean = false;
		private var _whiteLineExists:Boolean = false;
		private var _greenLineExists:Boolean = false; //normal range line 
		private var _counterFmt:TextFormat;
		private var _orangeCounterTF:TextField;
		private var _blueCounterTF:TextField;
		private var _orangeLineIsDragging:Boolean = false;
		private var _blueLineIsDragging:Boolean = false;
		private var _HorzLineRectBlue:Rectangle;
		private var _HorzLineRectOrange:Rectangle;
		
		//values for blue/orange schiferin lines
		private var gMax:Number = 30;
		private var gMin:Number = 240;	
		
		private var yMax:Number = 117;
		private var yMin:Number = 387;
						
		//saving
		public var save_button:SaveButton;		
		public var load_button:LoadButton;	
		private var _savePNG:SaveButton;
		private var _saveFileRef:FileReference;
		private var _loadFileRef:FileReference;		
				
		//controller buttons		
		private var _controllerRTButton:ControllerRTButton;
		private var _controllerBeginButton:ControllerBeginButton;
		private var _controllerEndButton:ControllerEndButton;
		private var _controllerRWButton:ControllerRWButton;
		private var _controllerFFButton:ControllerFFButton;
		private var _controllerPlayButton:ControllerPlayButton;
		
		//controller flags
		private var _currentState:String;
		private var _isRT:Boolean = false;	
		private var _isRW:Boolean = false;
		private var _isFF:Boolean = false;
		private var _isPlaying:Boolean = false;

		//public  var  scroller:ScrollPane;
		private var _overlayLoader:Loader = new Loader();
		private var _overlayDataProvider:DataProvider;
		private var _textSizeDataProvider:DataProvider;
		private var _strokeSizeDataProvider:DataProvider;

		//search		
		private var _searchString:String
		public var searchDay:String = '1d'
		private var _searchByTime:SearchBox;
		private var _searchByPage:SearchPage;
		private var _gotoTime:Number;
		private var _date:Date;		
		
		//delete all pop-up
		private var _butt:SimpleButtons1;
		private var yesButton:SimpleButtons1; 
		private var noButton:SimpleButtons1;
		private var _buttExists:Boolean = false;
		
		private var actualScale :Number;
		private var actualStageWidth :Number;
		private var actualStageHeight :Number;
		private var pixel:int;
		private var _snapshot_button:Snapshot
		private var monthLabels:Array = new Array("1", "2", "3", "4", "5", "6","7","8","9","10", "11","12");

		//one/ten minute buttons
		private var _realTimeTimer:Timer;	
		private var _oneMinuteButton:OneMinuteButton;
		private var _tenMinuteButton:TenMinuteButton;
		private var _oneMinuteRect:SimpleRectangle;
		private var _oneMinuteRectActive:Boolean = false;
		private var _tenMinuteRect:SimpleRectangle;
		private var _tenMinuteRectActive:Boolean;		
		
		//landmarks
		private var landmarkArray:Array =[["7588","BPP1 7/30", "4:18am", "25"],	["154052","BPP2 7/31", "7:10am", "903"]];		
		private var landmarkHolder:Sprite;
		private var landmark:MovieClip;
		private var landmarkBar:MovieClip;
		
		private var _bpp:Sprite;
		private var _bppButton:BPPButton;
		private var _launchPhotosButton:LaunchPhotos;

		private var tt:ToolTip;
		private var lName:String;
		private var lText:String;		
		private var i:uint = 0;
		private var _pageNumber:TextField;
		private var pageHeader:TextField;

		private var undoButton:SimpleButtons1;

		private var deleteButton:Bitmap;
		private var sp:Sprite;
		
		
		
		public function View (model:Model, controller:Controller)
		{
			_model = model;
			_controller = controller;		
		
			
			if (AssetManager.REQUIRES_LOGIN == true)
			{				
				_login = new LogInScreen();
				addChild(_login)
			}

		}
		

		public function init():void
		{	
			
			var _digiAssets:DisplayObject = new DigiAssets()
				addChild(_digiAssets);
			
			
			if (AssetManager.HAS_LANDMARKS)
			{				
			loadStyleSheet();	
			}
		
			_mainContainer = new Sprite();
			_buttonContainer = new Sprite();
			addChild(_mainContainer);
			
			//ORANGE/BLUE LINES
			_counterFmt = new TextFormat()
			_counterFmt.font = 'Avenir Demi'
			_counterFmt.size = 14
			_counterFmt.color = 0xFFFFFF
			_counterFmt.align = 'left'				
			_orangeCounterTF = new TextField();
			_blueCounterTF = new TextField();	
			_bpmOrangeButton = new BpmOrange ();
			_bpmOrangeButton.name = 'bpm_orange'
			_bpmOrangeButton.x = 5
			_bpmOrangeButton.useHandCursor = true;
			_bpmOrangeButton.buttonMode = true;
			_buttonContainer.addChild(_bpmOrangeButton)
			_bpmBlueButton = new BpmBlue ();
			_bpmBlueButton.name = 'bpm_blue'
			_bpmBlueButton.x = 40;
			_bpmBlueButton.useHandCursor = true;
			_bpmBlueButton.buttonMode = true;
			_buttonContainer.addChild(_bpmBlueButton);				
			_bpmBlueButton.scaleX = _bpmOrangeButton.scaleX = .6
			_bpmBlueButton.scaleY = _bpmOrangeButton.scaleY = .6
				
				
			//ONE &  TEN MINUTE BUTTONS	
			
			if (AssetManager.TEN_MINUTE_OVERLAY == true)
			{
				_tenMinuteRect = new SimpleRectangle(1000, 486, 0xD4D400, 0x000000, 1);
				_tenMinuteRect.blendMode = 'multiply'
				_tenMinuteRect.x = stage.stageWidth / 2 - _tenMinuteRect.width/2
				_tenMinuteRect.y = 115	
				_tenMinuteRect.alpha = 0
				_tenMinuteRect.mouseEnabled = false;
				
				_tenMinuteButton = new TenMinuteButton()
				_tenMinuteButton.buttonMode = true;
				_tenMinuteRectActive = false;
				_tenMinuteButton.x = 76
				_tenMinuteButton.y = 1.5
				_tenMinuteButton.scaleX = _tenMinuteButton.scaleY = .9
				_buttonContainer.addChild(_tenMinuteButton)	
				_tenMinuteButton.addEventListener(MouseEvent.CLICK, onTenMinuteButton, false, 0, true);	
				
			}
				
			
				
			if (AssetManager.ONE_MINUTE_OVERLAY == true)
			{
				_oneMinuteRect = new SimpleRectangle(120, 490, 0xD4D400, 0x000000, 1);
				_oneMinuteRect.blendMode = 'multiply'
				_oneMinuteRect.x = stage.stageWidth / 2 - _oneMinuteRect.width/2
				_oneMinuteRect.y = 115	
				_oneMinuteRect.alpha = 0
				_oneMinuteRect.mouseEnabled = false;				
				
				_oneMinuteButton = new OneMinuteButton()
				_oneMinuteButton.buttonMode = true;
				_oneMinuteRectActive = false;
				_oneMinuteButton.x = 111
				_oneMinuteButton.y = 1.5
				_oneMinuteButton.scaleX = _oneMinuteButton.scaleY = .9
				_buttonContainer.addChild(_oneMinuteButton)						
				_oneMinuteButton.addEventListener(MouseEvent.CLICK, onOneMinuteButton, false, 0, true);				
			}				
			
				
			//OVERLAYS
			if (AssetManager.HAS_OVERLAYS == true)
			{
				
			_overlay_cb = new ComboBox()	
			_overlay_cb.visible = false;
			_overlay_cb.setSize(250, 25);
			_overlay_cb.dropdownWidth = 300;
			_overlay_cb.drawFocus(false);
			_overlay_cb.rowCount = 10;
			_overlay_cb.x = 390
			_overlay_cb.y = 10	
				
			_mainContainer.addChild(_overlay_cb)	
				
			_overlay_cb.addItem( { label: "No Overlay", data:""});
			_overlay_cb.addItem( { label: "Absence Of Short Term Variability", data:'AbsenceOfShortTermVariability.swf'});
			_overlay_cb.addItem( { label: "Absent Variability", data:'AbsentVariability.swf'});
			_overlay_cb.addItem( { label: "Acceleration", data:'Acceleration.swf'});			
			_overlay_cb.addItem( { label: "Baseline Fetal Heart Rate", data:'BaselineFetalHeartRate.swf'});
			_overlay_cb.addItem( { label: "Early Deceleration", data:'EarlyDeceleration.swf'});
			_overlay_cb.addItem( { label: "Fetal Bradycardia", data:'FetalBradycardia.swf'});
			_overlay_cb.addItem( { label: "Fetal Heart and Contractions", data:'FetalHeartAndContractions.swf'});
			_overlay_cb.addItem( { label: "Hyperstimulation", data:'Hyperstimulation.swf'});
			_overlay_cb.addItem( { label: "Late Deceleration", data:'LateDeceleration.swf'});
			_overlay_cb.addItem( { label: "Long Term Variability", data:'LongTermShortTermVariability.swf'});
			_overlay_cb.addItem( { label: "Marked Variability", data:'LongTermVariability.swf'});			
			_overlay_cb.addItem( { label: "Normal Contractions", data:'MarkedVariability.swf'});
			_overlay_cb.addItem( { label: "Normal Fetal Heart Rate", data:'NormalContractions.swf'});
			_overlay_cb.addItem( { label: "Overshoot", data:'NormalFetalHeartRate.swf'});
			_overlay_cb.addItem( { label: "Prolonged Deceleration", data:'Overshoot.swf'});
			_overlay_cb.addItem( { label: "Reassuring Variable Decelerations", data:'ReassuringVariableDecelerations.swf'});			
			_overlay_cb.addItem( { label: "Short Term Variability", data:'ShortTermVariability.swf'});			
			_overlay_cb.addItem( { label: "Sinusoidal Tracing", data:'SinusoidalTracing.swf'});
			_overlay_cb.addItem( { label: "Tetanic Contractions", data:'TetanicContractions.swf'});
			_overlay_cb.addItem( { label: "Variable Deceleration", data:'VariableDeceleration.swf'});			
			_overlay_cb.addEventListener(Event.CHANGE, doOverlaySelected);				
			
			}
				
			//CONTROLLER BUTTONS
			_controllerBeginButton = new ControllerBeginButton();	
			_controllerRWButton = new ControllerRWButton();
			_controllerPlayButton = new ControllerPlayButton();
			_controllerFFButton = new ControllerFFButton();
			_controllerEndButton = new ControllerEndButton();

		
			_controllerBeginButton.x = 390;
			_buttonContainer.addChild(_controllerBeginButton);				
			_buttonContainer.addChild(_controllerRWButton);
			_controllerRWButton.x = 425;
			_buttonContainer.addChild(_controllerPlayButton);
			_controllerPlayButton.x = 470;				
			_buttonContainer.addChild(_controllerFFButton);
			_controllerFFButton.x = 515;				
			_buttonContainer.addChild(_controllerEndButton)
			_controllerEndButton.x = 560				
			_controllerBeginButton.scaleX = _controllerEndButton.scaleX = .8
			_controllerBeginButton.scaleY = _controllerEndButton.scaleY = .8					
				
				
			//GRAFFITI BUTTONS
			selection_button = new SelectionButton ();
			selection_button.name = 'selection_button'
			selection_button.x = 610
			selection_button.useHandCursor = true;
			selection_button.buttonMode = true;
			_buttonContainer.addChild(selection_button)
				
			rect_button = 	new RectButton ();
			rect_button.name = 'rect_button'
			rect_button.x = 645
			rect_button.useHandCursor = true;
			rect_button.buttonMode = true;
			_buttonContainer.addChild(rect_button)
				
			line_button = 	new LineButton ();
			line_button.name = 'line_button'
			line_button.x = 680
			line_button.useHandCursor = true;
			line_button.buttonMode = true;
			_buttonContainer.addChild(line_button)
				
			ellipse_button = new EllipseButton ();
			ellipse_button.name = 'ellipse_button'
			ellipse_button.x = 715
			_buttonContainer.addChild(ellipse_button);
			
			text_button = 	new TextButton ();
			text_button.name = 'text_button'
			text_button.x = 750
			text_button.useHandCursor = true;
			text_button.buttonMode = true;
			_buttonContainer.addChild(text_button)	
				
			brush_button = new BrushButton ();
			brush_button.name = 'brush_button'
			brush_button.x = 785
			brush_button.useHandCursor = true;
			brush_button.buttonMode = true;
			_buttonContainer.addChild(brush_button);
			
			clear_button = new ClearButton()
			clear_button.name = 'clear_button'
			clear_button.x = 820
			clear_button.addEventListener(MouseEvent.CLICK, onClear, false, 0, true);			
			_buttonContainer.addChild(clear_button)				
				
			save_button = new SaveButton()
			save_button.name = 'save_button'
			save_button.x = 880
			save_button.scaleX = save_button.scaleY = .7
			save_button.useHandCursor = true;
			save_button.buttonMode = true;
			_buttonContainer.addChild(save_button)
				
			load_button = new LoadButton()
			load_button.name = 'load_button'
			load_button.x = 930
			load_button.scaleX = load_button.scaleY = .7
			load_button.useHandCursor = true;
			load_button.buttonMode = true;
			_buttonContainer.addChild(load_button)
				
			_snapshot_button = 	new Snapshot()
			_snapshot_button.name = 'snapshot_button'
			_snapshot_button.x = 980
			_snapshot_button.scaleX = _snapshot_button.scaleY = .7
			_snapshot_button.useHandCursor = true;
			_snapshot_button.buttonMode = true;
			_buttonContainer.addChild(_snapshot_button)					
				
			
			var comboBoxFmt:TextFormat = new TextFormat()
			comboBoxFmt.font = 'Avenir Demi'
			comboBoxFmt.size = 14;
			comboBoxFmt.bold = true
			comboBoxFmt.color = 0x626262;
			
			_lineColorLabel = new TextField()
			_lineColorLabel.embedFonts = true;
			_lineColorLabel.selectable = false;
			_lineColorLabel.text = 'Line';
			_lineColorLabel.x = 175;
			_lineColorLabel.y = 13;
			_lineColorLabel.setTextFormat(comboBoxFmt);
			
			_fillColorLabel = new TextField()
			_fillColorLabel.embedFonts = true;
			_fillColorLabel.selectable = false;
			_fillColorLabel.text = 'Fill';
			_fillColorLabel.x = 260;
			_fillColorLabel.y = 13;
			_fillColorLabel.setTextFormat(comboBoxFmt);			
			
			stroke_color_mc = new ColorPicker();
			stroke_color_mc.setStyle("columnCount", 8); 
			stroke_color_mc.setStyle("swatchWidth", 50); 
			stroke_color_mc.setStyle("swatchHeight", 50); 
			stroke_color_mc.setStyle("swatchPadding", 2); 
			stroke_color_mc.setStyle("backgroundPadding", 3); 
			stroke_color_mc.setStyle("textPadding", 1);
			stroke_color_mc.x = 210 
			stroke_color_mc.y = 5
			stroke_color_mc.colors = [0x000000, 0x66CCFF, 0xFF0000, 0x99FF00, 0xFF9900, 0x660000, 0x006600, 0xFFFF00];
			
			fill_color_mc = new ColorPicker();
			fill_color_mc.colors = [0x000000, 0x66CCFF, 0xFF0000, 0x99FF00, 0xFF9900, 0x660000, 0x006600, 0xFFFF00];
			fill_color_mc.x = 297
			fill_color_mc.y = 5				
			fill_color_mc.setStyle("columnCount", 8); 
			fill_color_mc.setStyle("swatchWidth", 50); 
			fill_color_mc.setStyle("swatchHeight", 50); 
			fill_color_mc.setStyle("swatchPadding", 2); 
			fill_color_mc.setStyle("backgroundPadding", 3); 
			fill_color_mc.setStyle("textPadding", 1);
			
			
			_buttonContainer.addChild(_lineColorLabel);
			_buttonContainer.addChild(_fillColorLabel);
			_buttonContainer.addChild(stroke_color_mc);				
			_buttonContainer.addChild(fill_color_mc)	
			fill_color_mc.addEventListener(Event.CHANGE, colorSelectHandler);
			stroke_color_mc.addEventListener(Event.CHANGE, colorSelectHandler);			
			
			if (AssetManager.REAL_TIME_BUTTON == true)
			{			
				_controllerRTButton = new ControllerRTButton()
				_controllerRTButton.scaleX = _controllerRTButton.scaleY = .6
				_controllerRTButton.x = 345;			
				_buttonContainer.addChild(_controllerRTButton)				
			}
			
			
			//SEARCH 
			
			if (AssetManager.SEARCH_BY_DAY == true)
			{
			_searchByTime = new SearchBox (0);
			_buttonContainer.addChild(_searchByTime)
			_searchByTime.y = 60;
			_searchByTime.x = 940;
			
			addEventListener(SearchDayEvent.DAY1, onDay1, false, 0, true);
			addEventListener(SearchDayEvent.DAY2, onDay2, false, 0, true);	
			_searchByTime.addEventListener(Event.CHANGE, onTextChange, false, 0, true); 		
			}
			
			
			if(AssetManager.SEARCH_BY_PAGE == true)
			{
			_searchByPage = new SearchPage();
			_searchByPage.y = 60
			_searchByPage.x = 770
			_searchByPage.addEventListener(KeyboardEvent.KEY_DOWN, onPageChange, false, 0, true); 		
			_buttonContainer.addChild(_searchByPage)
			}

			//LOAD BUTTONS
			_buttonContainer.alpha = 0
			_buttonContainer.y = 680
			_buttonContainer.x = 0;		

			_canvas = new GraffitiCanvas(2800, 610, 10);			
			_canvas.addEventListener(GraffitiObjectEvent.SELECT, objectEventHandler);
			_canvas.addEventListener(GraffitiObjectEvent.DESELECT, objectEventHandler);
			_canvas.addEventListener(GraffitiObjectEvent.ENTER_EDIT, objectEventHandler);
			_canvas.addEventListener(GraffitiObjectEvent.EXIT_EDIT, objectEventHandler);
			_canvas.addEventListener(GraffitiObjectEvent.MOVE, objectEventHandler);
			_canvas.addEventListener(GraffitiObjectEvent.DELETE, objectEventHandler);
			_canvas.addEventListener(Event.INIT, fadeInButtonContainer, false, 0, true);		

			_canvas.y = 63
			_mainContainer.addChild(_canvas);
			_canvas.addEventListener(MouseEvent.CLICK, onGraffitiContainerClick, false, 0, true);


			_saveFileRef = new FileReference();			
			_loadFileRef = new FileReference(); 
			_saveFileRef.addEventListener(Event.COMPLETE, onSaveComplete);
			_saveFileRef.addEventListener(Event.CANCEL, onSaveComplete);			
			_loadFileRef.addEventListener(Event.SELECT, selectFile);  
			_loadFileRef.addEventListener(Event.COMPLETE, completeFile);
			_loadFileRef.addEventListener(Event.CANCEL, cancelFile);			
			_snapshot_button.addEventListener(MouseEvent.CLICK, onSavePictureButtonClicked, false, 0, true);
			_objectManager = GraffitiObjectManager.getInstance();

			//INSTANTIATE TOOLS
			//_eraserTool = new BrushTool(40, _fillColor, 1, _brushBlur, BrushType.ROUND, ToolMode.ERASE);
			_brushTool = new BrushTool(8, 0x000000, 1, 0, BrushType.ROUND, ToolMode.NORMAL, true);
			_selectionTool = new SelectionTool();
			_rectTool = new ShapeTool(2, 0xFFFF00, 0xFFFF00, 1, .5, ShapeType.RECTANGLE, ToolMode.NORMAL, true);
			_elipseTool = new ShapeTool(2, 0xFFFF00, 0xFFFF00, 1, .5, ShapeType.OVAL, ToolMode.NORMAL, true);
			_lineTool = new LineTool(4, 0x000000, 1, LineType.SOLID, null, true);
			
			var font:Font = new AssetManager.myFont
			var fmt:TextFormat = new TextFormat();
			fmt.size = 30;
			fmt.color = 0x000000;			
			_textTool = new TextTool(new TextSettings(font, fmt, 0x000000, 0x000000));			
			
			//add listeners to the _buttonContainer buttons			

			
			brush_button.addEventListener(MouseEvent.CLICK, toolSelectHandler);			
			rect_button.addEventListener(MouseEvent.CLICK, toolSelectHandler);
			ellipse_button.addEventListener(MouseEvent.CLICK, toolSelectHandler);
			line_button.addEventListener(MouseEvent.CLICK, toolSelectHandler);
			text_button.addEventListener(MouseEvent.CLICK, toolSelectHandler);
			selection_button.addEventListener(MouseEvent.CLICK, toolSelectHandler)
			//eraser_button.addEventListener(MouseEvent.CLICK, toolSelectHandler, false, 0, true);
			_bpmBlueButton.addEventListener(MouseEvent.CLICK, onBlueLine, false, 0, true);
			_bpmOrangeButton.addEventListener(MouseEvent.CLICK, onOrangeLine, false, 0, true);				
			
			
			//CONTROLLER EVENTS

			addEventListener(ControllerEvent.CONTROLLER_RT_ON, controllerEventHandler, false, 0, true);
			addEventListener(ControllerEvent.CONTROLLER_RT_OFF, controllerEventHandler, false, 0, true);			
			addEventListener(ControllerEvent.CONTROLLER_BEGIN_ON, controllerEventHandler, false, 0, true);
			addEventListener(ControllerEvent.CONTROLLER_BEGIN_OFF, controllerEventHandler, false, 0, true);			
			addEventListener(ControllerEvent.CONTROLLER_RW_ON, controllerEventHandler, false,0, true);
			addEventListener(ControllerEvent.CONTROLLER_RW_OFF, controllerEventHandler, false,0, true);			
			addEventListener(ControllerEvent.CONTROLLER_PLAY_ON, controllerEventHandler, false, 0, true);	
			addEventListener(ControllerEvent.CONTROLLER_PLAY_OFF, controllerEventHandler, false, 0, true);			
			addEventListener(ControllerEvent.CONTROLLER_PAUSE_ON, controllerEventHandler, false, 0, true);
			addEventListener(ControllerEvent.CONTROLLER_PAUSE_OFF, controllerEventHandler, false, 0, true);
			addEventListener(ControllerEvent.CONTROLLER_FF_ON, controllerEventHandler, false,0, true);
			addEventListener(ControllerEvent.CONTROLLER_FF_OFF, controllerEventHandler, false,0, true);
			addEventListener(ControllerEvent.CONTROLLER_END_ON, controllerEventHandler, false,0, true);
			addEventListener(ControllerEvent.CONTROLLER_END_OFF, controllerEventHandler, false,0, true);
			//handles nav buttons if user grabs left/right arrow or thumb of scroller.
			addEventListener(SliderEvent.SLIDER_INTERACTION,  handleControllerButtons, false, 0, true);
			//handles delete button state
			addEventListener(GraffitiObjectEvent.SELECT, onGraffitiSelect);
			addEventListener(GraffitiObjectEvent.DESELECT, onGraffitiSelect);
			addEventListener(GraffitiObjectEvent.DELETE, onGraffitiSelect);
			

			
			
			//LOAD/SAVE GRAFFITI EVENTS
			save_button.addEventListener(MouseEvent.CLICK, getDegrafaData, false, 0, true);
			load_button.addEventListener(MouseEvent.CLICK, generateObjects, false, 0, true);			
			_canvas.activeTool = _selectionTool			
			selection_button.setToActiveState(true);		
			
			if (AssetManager.HAS_LANDMARKS == true)
			{
				createLandmarks();
			}
			
			if (AssetManager.TOGGLE_ANNOTATIONS_LAYER == true)
			{
				_toggleDrawingButton = new SimpleToggleButton('Annotations', 'yellow', 1, 1);
				_toggleDrawingButton.y = 51;
				_toggleDrawingButton.x = 10;
				_buttonContainer.addChild( _toggleDrawingButton);			
				_toggleDrawingButton.addEventListener(MouseEvent.CLICK, doToggleDrawing);
				
			}			
			if (AssetManager.DUAL_LAYER_DIGISTRIP == true)
			{
				_toggleAnnotationsButton = new SimpleToggleButton('2nd Layer', 'yellow', 1, 1);
				_toggleAnnotationsButton.y = 51;
				_toggleAnnotationsButton.x = 125;
				_buttonContainer.addChild( _toggleAnnotationsButton);			
				_toggleAnnotationsButton.addEventListener(MouseEvent.CLICK, doToggleAnnotations);
				
			}
			
			if (AssetManager.SHOW_TIMES == true)
			{
				_toggleTimesButton = new SimpleToggleButton('Toggle Time', 'yellow', 1, 1);
				_toggleTimesButton.y = 51;
				_toggleTimesButton.x = 240;
				_buttonContainer.addChild( _toggleTimesButton);			
				_toggleTimesButton.addEventListener(MouseEvent.CLICK, doToggleTimes);
			}
			
			
			if (AssetManager.HAS_FSCOMMAND_LAUNCHER == true)
			{
				_launchPhotosButton = new LaunchPhotos();
				_launchPhotosButton.visible = false;
				addChild(_launchPhotosButton);
				_launchPhotosButton.x = 75;
				_launchPhotosButton.addEventListener(MouseEvent.CLICK, onLaunchPhotos, false, 0, true);
			}
			
			if (AssetManager.HAS_BPP_OVERLAY == true)
			{
				_bpp = new BPP();
				addChild(_bpp)
				_bpp.visible = false;
				_bpp.y = 66;
				
				
				_bppButton = new BPPButton();	
				_bppButton.x = 300
				_bppButton.y = 13
				_bppButton.visible = false;
				addChild(_bppButton)			
				_bppButton.addEventListener(MouseEvent.CLICK, doOverlay)
					

				
			}
			
			
			sp = new Sprite()
			deleteButton = new DeleteButton()
			deleteButton.alpha = .5
			sp.addChild(deleteButton)
			sp.buttonMode = true;
			_buttonContainer.addChild(sp)
			
			deleteButton.scaleX = deleteButton.scaleY = 1
			deleteButton.x = 355
			deleteButton.y = 40
				
			sp.addEventListener(MouseEvent.CLICK, onUndo)
			
			
			
			if (AssetManager.SEARCH_BY_PAGE == true)
			{
			
			var pageNumberFormat:TextFormat = new TextFormat()
			pageNumberFormat.font = 'Avenir Demi'
			pageNumberFormat.color = 0xFFFFFF;
			pageNumberFormat.size = 18;	
			
			
			//this is the single word 'Page' that prepends dynamic page num.
			pageHeader = new TextField()
			pageHeader.selectable = false;
			pageHeader.visible = false;
			pageHeader.text = 'Page ' 
			pageHeader.embedFonts = true;
			pageHeader.autoSize = 'left'
			
			pageHeader.setTextFormat(pageNumberFormat)
			pageHeader.defaultTextFormat = pageNumberFormat
			pageHeader.y = 38
			addChild(pageHeader)		

			_pageNumber = new TextField()
			_pageNumber.visible = false;
			_pageNumber.embedFonts = true
			_pageNumber.text = "1"
			_pageNumber.autoSize = 'left'
			_pageNumber.y = 38
			_pageNumber.selectable = false;
			_pageNumber.x = 51
			_pageNumber.setTextFormat(pageNumberFormat)
			_pageNumber.defaultTextFormat = pageNumberFormat;
			 addChild(_pageNumber);			
			
			 addEventListener(Event.ENTER_FRAME, calculatePage, false, 0, true);		

				
			
			
			}
		}
		
		protected function onGraffitiSelect(event:GraffitiObjectEvent):void
		{
			if(deleteButton.alpha == .5){				
			deleteButton.alpha = 1
			} else if (deleteButton.alpha == 1)	{
				deleteButton.alpha = .5					
			}
		}
		
		protected function doToggleTimes (event:MouseEvent):void
		{			
			if (_whiteLineExists == false)
			{
				_toggleTimesButton.opacity = .5				
				_mainContainer.addChild(_whiteLineContainer)				
				_whiteLineContainer.cacheAsBitmap = true;
				_whiteLineExists = true;

				var g:Graphics = _whiteLineContainer.graphics			
				g.lineStyle(43, 0xFFFFFF, 1, false, 'normal', CapsStyle.SQUARE, null, 0 )			
				g.moveTo(25, 0);
				g.lineTo(1003, 0);
				_whiteLineContainer.y = 418;
				
				_mainContainer.addChild(_whiteLineContainer);			
				
			} else {	
				_toggleTimesButton.opacity = 1
				_mainContainer.removeChild(_whiteLineContainer)
				_whiteLineExists = false;				
			}				
			
		}
		
		
		
		
		
		
		
		protected function handleControllerButtons(event:SliderInteractionEvent):void
		{
			if (_isPlaying || _isFF || _isRW || _isRT)
			{
			_controllerPlayButton.PauseNormalUp()
				
			}

			stopCurrentScrollerAction(event.type)
			_isRT = false;
			_isFF = false;
			_isPlaying = false;
			_isRW = false;	
			
		}		
		
		

		
		protected function onUndo(event:MouseEvent):void
		{
			_objectManager.deleteSelected();

		}
		
		protected function onLaunchPhotos(event:MouseEvent):void
		{
			fscommand("exec", "anatomy.exe"); // Windows
			//fscommand("exec", "anatomy.app"); // Mac
		}		
	
		
		
		protected function doOverlay(event:MouseEvent):void
		{
			
			if (_bpp.visible == false)
			{
				_bpp.visible = true;
			}
			else {
				_bpp.visible = false;
			}			
			
		}

		
		
		protected function doToggleDrawing(event:MouseEvent):void
		{			
			
			if (_canvas.object_layer.alpha == 1 && _canvas.object_layer.numChildren > 0 )
			{
				_toggleDrawingButton.opacity = .5
				_canvas.object_layer.alpha = 0;
			}
			else if (_canvas.object_layer.alpha == 0)
			{
				_toggleDrawingButton.opacity = 1
				_canvas.object_layer.alpha = 1;				
				
			}
			
		}
		
		protected function doToggleAnnotations(event:MouseEvent):void
		{			
			

			
			
			
			if (_canvas.annotation_layer.visible == true)
			{

				_toggleAnnotationsButton.opacity = .5
				_canvas.annotation_layer.visible = false;

			}
			else if (_canvas.annotation_layer.visible == false)
			{

				_toggleAnnotationsButton.opacity = 1
				_canvas.annotation_layer.visible = true;
				
				if (_whiteLineExists)
				{
				_toggleTimesButton.opacity = 1				
				_mainContainer.removeChild(_whiteLineContainer)				
				_whiteLineExists = false;						
				}

				
			}
			
		}
		
		
		private function loadStyleSheet():void
		{
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			var req:URLRequest = new URLRequest("../css/styles.css");
			loader.load(req);
		}
		
		protected function loaderCompleteHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			var loader:URLLoader = URLLoader(event.target);
			_sheet.parseCSS(loader.data);
		}
		
		
		
		protected static function errorHandler(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			
		}		
		
		
		private function createLandmarks():void
			
		{	
				var rect:SimpleRectangle = new SimpleRectangle (940, 25, 0xff0000, 0x000000, 0);
				rect.x = 40
				rect.y = -30
				rect.mouseEnabled = false;
				_buttonContainer.addChild(rect)	
			
			
			for(i=0; i < landmarkArray.length; i++)
			{
/*				landmark = new Landmark()
				landmark.name = 'landmark' + i
				rect.addChild(landmark)
				landmark.x = landmarkArray[i][3];
				landmark.myI = i
				landmark.buttonMode = true;		
				
				
				landmark.addEventListener(MouseEvent.MOUSE_OVER, onLandmarkOver);
				landmark.addEventListener(MouseEvent.MOUSE_OUT, onLandmarkOut);
				landmark.addEventListener(MouseEvent.CLICK, onLandmarkClick);
								
				if(i%2)
				{					

					landmark.y = 17
					
				} else	{					
					
					landmark.scaleY = -1
					landmark.y = 12
				}
*/
				
			}
			
		}
		
		protected function onLandmarkClick(event:MouseEvent):void
		{
			//_canvas.scroller.horizontalScrollPosition = Number(landmarkArray[event.target.myI][0])
			
		}
		
		protected function onLandmarkOver(event:MouseEvent):void
		{
			

			tt = new ToolTip();
			tt.align = "center";
			tt.hook = true;
			tt.cornerRadius = 10;
			tt.border = 0x626262
			tt.borderSize = 2
			tt.autoSize = true;
			tt.colors = [0xDC9E00, 0xFFED00]
			tt.show(DisplayObject(event.target), landmarkArray[event.target.myI][2]+" - "+landmarkArray[event.target.myI][1]);	
		}		
		
		
		protected function onLandmarkOut(event:MouseEvent):void
		{
			tt.hide();		
		
		}

		
		protected function onSaveComplete(event:Event):void
		{
			resetButtonStates();
			
		}
		
		private function fadeInButtonContainer(event:Event):void
		{

			_mainContainer.addChildAt (_buttonContainer, _mainContainer.numChildren -1);

			TweenLite.to(_buttonContainer, 1, {alpha:1, ease:Quad.easeOut});
			
			if(AssetManager.SEARCH_BY_PAGE == true)
			{
			_pageNumber.visible= true;
			pageHeader.visible = true;
			_overlay_cb.visible = true;
				
			}
			if (AssetManager.HAS_OVERLAYS)
			{
			_overlay_cb.visible = true;				
			}
			
			if (AssetManager.HAS_BPP_OVERLAY)
			{
				_bppButton.visible = true
			}
			
		/*var undo:SimpleButtons = new SimpleButtons (25, 25, 'undo', 0x000000, 1, 'center')
			undo.addEventListener(MouseEvent.CLICK, onUndo);
			_buttonContainer.addChild(undo)		*/
			




		}

		
		protected function onOneMinuteButton(event:MouseEvent):void
		{
			

			if ( _oneMinuteRectActive == false)
			{				
				_mainContainer.addChild(_oneMinuteRect)				
				TweenLite.to(_oneMinuteRect, .5, {tint:0xFF0000}); 
				TweenLite.to(_oneMinuteRect, .5, {alpha:1, ease:Quad.easeOut});
				_oneMinuteRectActive = true;

				
				
			} else {
				TweenLite.to(_oneMinuteRect, .5, {alpha:0, ease:Quad.easeOut, onComplete:removeOne});
			}
			
		}
		
		
		
		
		protected function onTenMinuteButton(event:MouseEvent):void
		{
			if ( _tenMinuteRectActive == false)
			{
				
				
				_mainContainer.addChild(_tenMinuteRect)				
				TweenLite.to(_tenMinuteRect, .5, {tint:0xFF0000}); 
				TweenLite.to(_tenMinuteRect, .5, {alpha:1, ease:Quad.easeOut});
				_tenMinuteRectActive = true;

				
			} else {
				TweenLite.to(_tenMinuteRect, .5, {alpha:0, ease:Quad.easeOut, onComplete:removeTen});
			}
						
		}
		
		
		private function removeOne():void
		{
			if (_oneMinuteRectActive)
			{				
				_mainContainer.removeChild(_oneMinuteRect)
				_oneMinuteRectActive = false
			}
			
		}
		

		private function removeTen():void
		{
			if (_tenMinuteRectActive)
			{				
			_mainContainer.removeChild(_tenMinuteRect)
			_tenMinuteRectActive = false
			}

		}
		
		
		
		protected function onDay2(event:Event):void
		{
			searchDay = '2d'
		}
		
		protected function onDay1(event:Event):void
		{
			searchDay = '1d'
			
		}
		
		
		protected function onTextChange(event:Event):void
		{
			
			_searchString =  searchDay + _searchByTime.searchText.text
			
			if (_searchString.length == 6)
			{
				doTimeSearch(_searchString);
			}		

		}
		

		
		protected function onPageChange(event:KeyboardEvent):void
		{			
			
			if (event.charCode == 13)
			{
				
				
				var str:String = _searchByPage.searchText.text;
				var constant:Number = AssetManager.SINGLE_PAGE_WIDTH;
				var total:Number = AssetManager.SCROLLER_ENDING_X - constant
				
				trace('search string is ' + str, 'constant is ' + AssetManager.SINGLE_PAGE_WIDTH, 'total is ' + total)
				
				var page:Number = Number(str) * constant
				var goNum:Number = (page / total) //- AssetManager.SINGLE_PAGE_WIDTH;

					
				trace('page is ' + page, 'goNum ' + goNum);
					
				_canvas._scrollbar.percent = goNum
				_searchByPage.searchText.text = ''
				_pageNumber.text = _searchByPage.searchText.text;
			}			
			onControllerPause(null);
		}		

		
		
		private function doTimeSearch(num:String):void
		{
			
	
			switch(num)
			{
				case '1d1130':
					pixel = 540;
					break;
				case '1d1140':
					pixel = 1296;
					break;
				case '1d1150':
					pixel = 2029;
					break;
				case '1d1200':
					pixel = 2786;
					break;
				case '1d1210':
					pixel = 3533;
					break;
				case '1d1220':
					pixel = 4286;
					break;
				case '1d1230':
					pixel = 5040;
					break;
				case '1d1240':
					pixel = 5767;
					break;
				case '1d1250':
					pixel = 6524;
					break;
				case '1d1300':
					pixel = 7258;
					break;
				case '1d1310':
					pixel = 9093;
					break;
				case '1d1320':
					pixel = 9840;
					break;
				case '1d1330':
					pixel = 10570;
					break;
				case '1d1340':
					pixel = 11316;
					break;
				case '1d1350':
					pixel = 12052;
					break;
				case '1d1400':
					pixel = 12800;
					break;
				case '1d1410':
					pixel = 13536;
					break;
				case '1d1420':
					pixel = 14267;
					break;
				case '1d1430':
					pixel = 15010;
					break;
				case '1d1440':
					pixel = 15578;
					break;
				case '1d1450':
					pixel = 16507;
					break;
				case '1d1500':
					pixel = 17250;
					break;
				case '1d1510':
					pixel = 17978;
					break;
				case '1d1520':
					pixel = 18730;
					break;
				case '1d1530':
					pixel = 19465;
					break;
				case '1d1540':
					pixel = 20220;
					break;
				case '1d1550':
					pixel = 20972;
					break;
				case '1d1600':
					pixel = 21722;
					break;
				case '1d1610':
					pixel = 22454;
					break;
				case '1d1620':
					pixel = 23220;
					break;
				case '1d1630':
					pixel = 23973;
					break;
				case '1d1640':
					pixel = 24706;
					break;
				case '1d1650':
					pixel = 25443;
					break;
				case '1d1700':
					pixel = 26191;
					break;
				case '1d1710':
					pixel = 26935;
					break;
				case '1d1720':
					pixel = 27667;
					break;
				case '1d1730':
					pixel = 28427;
					break;
				case '1d1740':
					pixel = 29175;
					break;
				case '1d1750':
					pixel = 29921;
					break;
				case '1d1800':
					pixel = 30661;
					break;
				case '1d1810':
					pixel = 31402;
					break;
				case '1d1820':
					pixel = 32138;
					break;
				case '1d1830':
					pixel = 32891;
					break;
				case '1d1840':
					pixel = 33637;
					break;
				case '1d1850':
					pixel = 34388;
					break;
				case '1d1900':
					pixel = 35134;
					break;
				case '1d1910':
					pixel = 35867;
					break;
				case '1d1920':
					pixel = 36620;
					break;
				case '1d1930':
					pixel = 37353;
					break;
				case '1d1940':
					pixel = 38107;
					break;
				case '1d1950':
					pixel = 38854;
					break;
				case '1d2000':
					pixel = 39566;
					break;
				case '1d2010':
					pixel = 40317;
					break;
				case '1d2020':
					pixel = 41053;
					break;
				case '1d2030':
					pixel = 41781;
					break;
				case '1d2040':
					pixel = 42520;
					break;
				case '1d2050':
					pixel = 43248;
					break;
				case '1d2100':
					pixel = 44571;
					break;
				case '1d2110':
					pixel = 45303;
					break;
				case '1d2120':
					pixel = 46050;
					break;
				case '1d2130':
					pixel = 46781;
					break;
				case '1d2140':
					pixel = 47600;
					break;
				case '1d2150':
					pixel = 48313;
					break;
				case '1d2200':
					pixel = 49026;
					break;				
				case '1d2210':
					pixel = 49775;
					break;
				case '1d2220':
					pixel = 50510;
					break;
				case '1d2230':
					pixel = 51252;
					break;
				case '1d2240':
					pixel = 51996;
					break;
				case '1d2250':
					pixel = 52735;
					break;
				case '1d2300':
					pixel = 53458;
					break;
				case '1d2310':
					pixel = 54166;
					break;
				case '1d2320':
					pixel = 54918;
					break;
				case '1d2330':
					pixel = 55664;
					break;
				case '1d2340':
					pixel = 56397;
					break;
				case '1d2350':
					pixel = 56998;
					break;
				case '1d0000':
					pixel = 57818;
					break;
				case '1d0010':
					pixel = 58583;
					break;
				case '1d0020':
					pixel = 59292;
					break;
				case '1d0030':
					pixel = 60042;
					
					break;
				case '1d0040':
					pixel = 60775;
					break;
				case '1d0050':
					pixel = 61500;
					break;
				case '1d0100':
					pixel = 62254;
					break;
				case '1d0110':
					pixel = 62993;
					break;
				case '1d0120':
					pixel = 63741;
					break;
				case '1d0130':
					pixel = 64494;
					break;
				case '1d0140':
					pixel = 65229;
					break;
				case '1d0150':
					pixel = 65978;
					break;
				case '1d0200':
					pixel = 66716;
					break;
				case '1d0210':
					pixel = 67465;
					break;
				case '1d0220':
					pixel = 68213;
					break;
				case '1d0230':
					pixel = 68995;
					break;
				case '1d0240':
					pixel = 69752;
					break;
				case '1d0250':
					pixel = 70510;
					break;
				case '1d0300':
					pixel = 71256;
					break;
				case '1d0310':
					pixel = 72000;
					break;
				case '1d0320':
					pixel = 72726;
					break;
				case '1d0330':
					pixel = 73477;
					break;
				case '1d0340':
					pixel = 74174;
					break;
				case '1d0350':
					pixel = 74922;
					break;
				case '1d0400':
					pixel = 75665;
					break;
				case '1d0410':
					pixel = 76404;
					break;
				case '1d0420':
					pixel = 77130;
					break;
				case '1d0430':
					pixel = 77891;
					break;
				case '1d0440':
					pixel = 78648;
					break;
				case '1d0450':
					pixel = 79606;
					break;
				case '1d0500':
					pixel = 80330;
					break;
				case '1d0510':
					pixel = 81073;
					break;
				case '1d0520':
					pixel = 81813;
					break;				
				case '1d0530':
					pixel = 82554;
					break;
				case '1d0540':
					pixel = 83299;
					break;
				case '1d0550':
					pixel = 84038;
					break;
				case '1d0600':
					pixel = 84783;
					break;
				case '1d0610':
					pixel = 85509;
					break;
				case '1d0620':
					pixel = 86264;
					break;
				case '1d0630':
					pixel = 87013;
					break;
				case '1d0640':
					pixel = 87766;
					break;
				case '1d0650':
					pixel = 88516;
					break;
				case '1d0700':
					pixel = 89261;
					break;
				case '1d0710':
					pixel = 90035;
					break;
				}
			
			_canvas._scrollbar.percent = (pixel / AssetManager.SCROLLER_ENDING_X) * 1.006 //offset to left of page.
			_searchByTime.searchText.text = ''
		}
		
		
		protected function calculatePage(event:Event):void
		{	

			if (_canvas._scrollbar)
			{
				var constant:uint = AssetManager.SINGLE_PAGE_WIDTH
				var total:Number = 	_canvas.container.scrollRect.x					
				var page:Number = total / constant * 1	
					
				_pageNumber.text = int(page + 1).toString();

			}

				
		}	
			
		
		protected function onGraffitiContainerClick(event:MouseEvent):void
		{
			_canvas.activeTool = _selectionTool				
			brush_button.setToNormalState(true);
			rect_button.setToNormalState(true);
			ellipse_button.setToNormalState(true);
			line_button.setToNormalState(true);
			text_button.setToNormalState(true);
			selection_button.setToActiveState(true);	
			clear_button.setToNormalState(true);
			save_button.setToNormalState(true)
			load_button.setToNormalState(true);
			_snapshot_button.setToNormalState(true);
			
		}		
		
		
		
		private function get time():String
		{
					
			_date = new Date()			
			var year:Number = _date.fullYear;
			var month:Number = _date.month;
			var thisMonth:String = monthLabels[month];
			var day:Number = _date.date;		
			var hours:Number = _date.hours;
			var min:Number = _date.minutes;
			var sec:Number = _date.seconds;
			
			var now:String = year.toString() + thisMonth + day.toString() + hours.toString() + min.toString() + sec.toString();
			
			return now;
		}
		
		
		private function onSavePictureButtonClicked(event:MouseEvent):void
		
		{		
			var bitmapData:BitmapData=new BitmapData( 1024, 768);			
			bitmapData.draw(_controller._stage); 			
			pngEncoder = new PNGEncoder();
			byteArray = PNGEncoder.encode(bitmapData);
			var fileReference:FileReference = new FileReference();
			fileReference.addEventListener(Event.CANCEL, onFileSaveCancel);			
			fileReference.save(byteArray, "Digistrip_Image_" + this.time + ".png");
		}
		
		
		protected function onFileSaveCancel(event:Event):void
		{
			resetButtonStates();			
		}
		
		private function resetButtonStates(): void
		{
			_canvas.activeTool = _selectionTool;			
			brush_button.setToNormalState(true);
			rect_button.setToNormalState(true);
			ellipse_button.setToNormalState(true);			
			line_button.setToNormalState(true);
			text_button.setToNormalState(true);
			selection_button.setToActiveState(true);	
			clear_button.setToNormalState(true);
			save_button.setToNormalState(true)
			load_button.setToNormalState(true);
			_snapshot_button.setToNormalState(true);		
		}
		
		
		protected function onClear(event:MouseEvent):void
		{

			if (_buttExists==false && _objectManager.objectList.length > 0)
			{
				
				
			clear_button.setToNormalState(false);
			_butt = new SimpleButtons1(500, 400, "   ARE YOU SURE YOU WANT TO\nCLEAR ALL DRAWINGS AND TEXT?", 0x000000, .8, 'center', 0xFFFFFF, 30);
			_butt.x = 0;
			_butt.y = 0;

			yesButton = new SimpleButtons1(100, 50, "YES", 0x000000, .2, 'center', 0xFFFFFF, 30);
			noButton = new SimpleButtons1(100, 50, "NO", 0x000000, .2, 'center', 0xFFFFFF, 30);
			
			yesButton.addEventListener(MouseEvent.CLICK, doClear, false, 0, true);
			noButton.addEventListener(MouseEvent.CLICK, doCancelClear, false, 0, true);
			
			_butt.addChild(yesButton);
			_butt.addChild(noButton);;
				
			yesButton.x = 150;
			yesButton.y = 320;
			noButton.x = 250;
			noButton.y = 320;

			_mainContainer.addChildAt(_butt, _mainContainer.numChildren);
				
			_buttExists = true;
				
			}			
		}		
		
		
		private function doCancelClear(event:MouseEvent):void
		{
			clear_button.setToNormalState(true);
			
			yesButton.removeEventListener(MouseEvent.CLICK, doClear);
			noButton.removeEventListener(MouseEvent.CLICK, doCancelClear);
			_mainContainer.removeChild(_butt);				
			_buttExists = false;
		}		
		
		
		private function doClear(event:MouseEvent):void
		{
			clear_button.setToNormalState(true);
			_canvas.clearCanvas();
			yesButton.removeEventListener(MouseEvent.CLICK, doClear)
			noButton.removeEventListener(MouseEvent.CLICK, doCancelClear)
			_mainContainer.removeChild(_butt)
			_buttExists = false;			
		}			
		
		

		
		/**********************************************CONTROLLER BIDNETH***************************************************************************/
		
		

		private function controllerEventHandler (event:ControllerEvent):void
		{
			//trace('event type is ' + event.type)
			_currentState = event.type
				
			switch (event.type)
			{
				
				case 'RTon':	
					stopCurrentScrollerAction(event.type)					
					_isRT = true;
					_isRW = false;
					_isFF = false;
					_isPlaying = false;
					_realTimeTimer = new Timer(10, 0)
					_realTimeTimer.addEventListener(TimerEvent.TIMER, doRealTime);
					_realTimeTimer.start();
					_controllerPlayButton.PauseNormalUp()
					break;
				case 'RToff':
					_realTimeTimer.stop();					
					_realTimeTimer.removeEventListener(TimerEvent.TIMER, doRealTime);
					break;
				case 'BeginOn':
					stopCurrentScrollerAction(event.type)
					_controllerBeginButton.setNormal();
					if (AssetManager.SEARCH_BY_PAGE)
					{						
					_pageNumber.text = '1'
					}
					_canvas._scrollbar.percent = 0;	
					_controllerPlayButton.PauseNormalUp()
					break;
				case 'RWon':
					stopCurrentScrollerAction(event.type)
					_isRT = false;
					_isFF = false;
					_isPlaying = false;
					_isRW = true;
					addEventListener(Event.ENTER_FRAME, onRWEnterFrame);
					_controllerPlayButton.showPause();
					break;
				case 'RWoff':
					removeEventListener(Event.ENTER_FRAME, onRWEnterFrame);
					_controllerPlayButton.PauseNormalUp()
					break;				
				case 'PlayOn':
					stopCurrentScrollerAction(event.type)
					_isRT = false;
					_isFF = false;
					_isPlaying = true;
					_isRW = false;
					addEventListener(Event.ENTER_FRAME, playEnterFrame);
					break;
				case 'PlayOff':
					removeEventListener(Event.ENTER_FRAME, playEnterFrame);
					break;
				case 'PauseOn':
					stopCurrentScrollerAction(event.type)
					//removeEventListener(Event.ENTER_FRAME, playEnterFrame);
					break;
				case 'PauseOff':
					break;
				case 'FFon':
					stopCurrentScrollerAction(event.type)
					_isRT = false;
					_isFF = true;
					_isPlaying = false;
					_isRW = false;	
					addEventListener(Event.ENTER_FRAME, onFFEnterFrame);
					_controllerPlayButton.showPause();
					break;
				case 'FFoff':
					removeEventListener(Event.ENTER_FRAME, onFFEnterFrame);
					_controllerPlayButton.PauseNormalUp()
					break;
				case 'EndOn':
					stopCurrentScrollerAction(event.type)
					_controllerEndButton.setNormal();
					if (AssetManager.SEARCH_BY_PAGE)
					{						
						_pageNumber.text = String(AssetManager.NUM_IMAGES);
					}
					_canvas._scrollbar.percent = 1;	
					_controllerPlayButton.PauseNormalUp()
					break;
				case 'EndOff':
					break;
			}			
			
		}
		
		private function stopCurrentScrollerAction(str:String):void
		{

	
				if (_isPlaying && str != 'PlayOn')
				{
					removeEventListener(Event.ENTER_FRAME, playEnterFrame);
					_isPlaying = false;
					//_controllerPlayButton.PauseNormalUp()

				}
				if (_isFF && str != 'FFon')
				{
					removeEventListener(Event.ENTER_FRAME, onFFEnterFrame);	
					_controllerFFButton.setNormal();
					_isFF = false;
				}
				if (_isRW && str != 'RWon')
				{
					removeEventListener(Event.ENTER_FRAME, onRWEnterFrame);
					_controllerRWButton.setNormal();
					_isRW = false;
				}

				if (_isRT && str != 'RTon')
				{
					_realTimeTimer.stop();					
				_realTimeTimer.removeEventListener(TimerEvent.TIMER, doRealTime);
				_isRT = false;
				_controllerRTButton.setNormal();
				}
				if (str != 'EndOn')
				{

					_controllerEndButton.setNormal();
				}
				if (str != 'BeginOn')
				{
					
					_controllerBeginButton.setNormal();
				}
				
				if (str == 'PauseOn')
				{

					removeEventListener(Event.ENTER_FRAME, playEnterFrame);
					removeEventListener(Event.ENTER_FRAME, onRWEnterFrame);
					removeEventListener(Event.ENTER_FRAME, onFFEnterFrame);	
					_isPlaying = false;
					_isFF = false;
					_isRW = false;
					_isRT = false;
				}
			}
				
	


		protected function onFFEnterFrame(event:Event):void
		{						
			if (_canvas._scrollbar.percent == 1)
			{
				removeEventListener(Event.ENTER_FRAME, onFFEnterFrame);
				stopCurrentScrollerAction(event.type)
				return;
			}
				_canvas._scrollbar.percent += AssetManager.SCROLLER__FFRW_SPEED

		}		
				
		
		protected function onRWEnterFrame(event:Event):void
		{
			if (_canvas._scrollbar.percent == 0)
			{
				removeEventListener(Event.ENTER_FRAME, onRWEnterFrame);
				stopCurrentScrollerAction(event.type)
				return;
			}
			_canvas._scrollbar.percent -= AssetManager.SCROLLER__FFRW_SPEED;
			
		}		
		

		
		protected function onControllerPause(event:ControllerEvent):void
		{
			_canvas._scrollbar.percent = _canvas._scrollbar.percent		
		}
		
		
		
		private function playEnterFrame(event:Event):void
		{			
			_canvas._scrollbar.percent += AssetManager.SCROLLER_PLAY_SPEED
			
			if (_canvas._scrollbar.percent == 0 || _canvas._scrollbar.percent == 1)
			{
				return;
			}		
			
		}	
	
		

		protected function doRealTime(event:Event):void
		{
			_canvas._scrollbar.percent += AssetManager.REAL_TIME_X_AMOUNT;	
			
		}			
		
		/**********************************************END CONTROLLER BIDNETH***************************************************************************/
	

		protected function onBlueLine(event:MouseEvent):void
		{
			
			if (_blueLineExists == false)
			{

			_mainContainer.addChild(_blueLineContainer)				
			_blueLineContainer.cacheAsBitmap = true;
			//_blueLineContainer.blendMode = 'multiply'  This makes blue schrifrin line transparent but is expensive.
			_blueCounter.alpha = 0	
			_blueCounter.y = -3
			_blueCounter.x = -2
			_blueCounterTF.defaultTextFormat = _counterFmt;
			_blueCounterTF.selectable = false;
			_blueCounterTF.y = 2
			_blueCounterTF.embedFonts = true;	
			_blueCounterTF.text = '30 bpm'			
			_blueCounter.addChild(_blueCounterTF)
			_blueLineContainer.addChild(_blueCounter);
			_blueCounterTF.setTextFormat(_counterFmt);			
			
			 
			var g:Graphics = _blueLineContainer.graphics
			
			//invisible hit state
			g.lineStyle(40, 0x00CC44, 0, false, 'normal', CapsStyle.SQUARE, null, 0 )			
			g.moveTo(0, 0);
			g.lineTo(1024, 0);
			
			g.lineStyle(5, 0x186BEF, 1, false, 'normal', CapsStyle.SQUARE, null, 0 )			
			g.moveTo(0, 0);
			g.lineTo(1024, 0);		

			_mainContainer.addChild(_blueLineContainer);				
			
			_HorzLineRectBlue = new Rectangle (0, 117, 1, 270)
			_blueLineContainer.startDrag(true, _HorzLineRectBlue)	
			_blueLineIsDragging = true	
			_blueLineExists = true;

			_blueLineContainer.addEventListener(MouseEvent.MOUSE_DOWN, onBlueDown) 
			_blueLineContainer.addEventListener(MouseEvent.MOUSE_UP, onBlueUp) 				
			
			} else {			
			_mainContainer.removeChild(_blueLineContainer)
			_blueLineExists = false;
			_blueLineIsDragging = false
				
			}			

		}
		
		
		protected function onBlueUp(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, calculateOrangeY);				
			this.removeEventListener(Event.ENTER_FRAME, calculateBlueY);
			_blueLineContainer.stopDrag();
			_blueLineIsDragging = false;
			
		}
		
		protected function onBlueDown(event:MouseEvent):void
		{
			
			if (_orangeLineExists == true)
			{
				swapDepths(_mainContainer,  _orangeLineContainer, _blueLineContainer)
			}

			_blueCounter.alpha = 1	
			this.addEventListener(Event.ENTER_FRAME, calculateBlueY);
			_blueLineContainer.startDrag(true, _HorzLineRectBlue);
			_blueLineIsDragging = true;
			
		}			

		
		protected function onOrangeLine(event:MouseEvent):void
		{
			if (_orangeLineExists == false)
			{
				_orangeLineExists = true;				
				_orangeLineContainer.cacheAsBitmap = true;
				//_orangeLineContainer.blendMode = 'multiply'


				
				_orangeCounter.alpha = 0	
				_orangeCounter.y = -3
				_orangeCounter.x = -2
				_orangeCounterTF.defaultTextFormat = _counterFmt;
				_orangeCounterTF.selectable = false;
				_orangeCounterTF.embedFonts = true;	
				_orangeCounterTF.text = '30 bpm'
				_orangeCounterTF.y = 2
				_orangeCounter.addChild(_orangeCounterTF)
				_orangeLineContainer.addChild(_orangeCounter);
				_orangeCounterTF.setTextFormat(_counterFmt);				

				var g:Graphics = _orangeLineContainer.graphics					
				g.lineStyle(40, 0x00CC44, 0, false, 'normal', CapsStyle.SQUARE, null, 0 )
				g.moveTo(0, 0);
				g.lineTo(1024, 0);
				_mainContainer.addChild(_orangeLineContainer)					
					
				g.lineStyle(5, 0xFD8A07, 1, false, 'normal', CapsStyle.SQUARE, null, 0 )	
				g.moveTo(0, 0);
				g.lineTo(1024, 0);
				
				_HorzLineRectOrange = new Rectangle  (0, 117, 1, 270)
				_orangeLineContainer.startDrag(true, _HorzLineRectOrange)	
				_orangeLineIsDragging = true
					
				_orangeLineContainer.addEventListener(MouseEvent.MOUSE_DOWN, onOrangeDown) 
				_orangeLineContainer.addEventListener(MouseEvent.MOUSE_UP, onOrangeUp)
				_orangeLineContainer.addEventListener(MouseEvent.ROLL_OUT, onOrangeUp);

				
			} else {

				_mainContainer.removeChild(_orangeLineContainer)
				_orangeLineExists = false;
				_orangeLineIsDragging = false

			}
			
		}
		
		
		protected function onOrangeDown(event:MouseEvent):void
		{
			
			if (_blueLineExists == true)
			{
				swapDepths(_mainContainer, _blueLineContainer, _orangeLineContainer)
			}
			
			_orangeCounter.alpha = 1			
			_orangeLineContainer.startDrag(true, _HorzLineRectOrange);
			_orangeLineIsDragging = true;	
			addEventListener(Event.ENTER_FRAME, calculateOrangeY);

		}

		
		protected function onOrangeUp(event:MouseEvent):void
		{	
			removeEventListener(Event.ENTER_FRAME, calculateOrangeY);			
			_orangeLineContainer.stopDrag();
			_orangeLineIsDragging = false;
		}
		
		
		protected function calculateOrangeY(event:Event):void
		{				
			var percent:Number	 = (_orangeLineContainer.y - yMax) / (yMin - yMax);
			var corresponding:Number = percent * (gMax - gMin) + gMin;		
			_orangeCounterTF.text = String(corresponding.toFixed(0) + ' bpm') ;			
		}
		
		protected function calculateBlueY(event:Event):void
		{			
			var percent:Number	 = (_blueLineContainer.y - yMax) / (yMin - yMax);
			var corresponding:Number = percent * (gMax - gMin) + gMin;			
			_blueCounterTF.text = String(corresponding.toFixed(0) + ' bpm') ;			
		}
		
		
		
		protected function swapDepths(parent:DisplayObjectContainer, d1:DisplayObject, d2:DisplayObject):void
		{
			var obj1:int = parent.getChildIndex(d1);
			var obj2:int = parent.getChildIndex(d2);
			if(obj1 == obj2)
			{
				throw new Error('ERROR: Cannot swap an object with itself');
			}
			
			if (_mainContainer.getChildIndex(d1) > _mainContainer.getChildIndex(d2))
			{
				parent.setChildIndex(d2,obj1);
				parent.setChildIndex(d1,obj2);
				
			}
			
		}
		
		
		protected function doOverlaySelected(event:Event):void
		{
			if (_overlay_cb.selectedIndex == 0)
			{
				_mainContainer.removeChild(_overlayLoader)
			}
			
			else if (_overlay_cb.selectedItem.data != null)
			{
				_overlayLoader.scaleX = _overlayLoader.scaleY = 1.28
				_overlayLoader.x = -40
				_overlayLoader.y = -123
				_overlayLoader.load(new URLRequest('../assets/overlays/' + _overlay_cb.selectedItem.data));
				_mainContainer.addChild(_overlayLoader);

			}	

			
		}


		
		/*********************************************************
		 Method  : generateObjects()
		 
		 Purpose : Method will open browse menu to load
		 an object xml file.
		 
		 Params	: e -- MouseEvent object.
		 **********************************************************/
		private function generateObjects(e:MouseEvent):void {
			_loadFileRef.browse([new FileFilter("All Formats (*.xml)", "*.xml")]);	
			
			save_button.setToNormalState(true)
			load_button.setToNormalState(true);
			_snapshot_button.setToNormalState(true);

		}
		
		/*********************************************************
		 Method  : cancelFile()
		 
		 Purpose : Method will handle the cancel event.
		 
		 Params	: e -- Event object.
		 **********************************************************/
		private function cancelFile(e:Event):void {
			resetButtonStates();
		}
		
		/*********************************************************
		 Method  : selectFile()
		 
		 Purpose : Method will handle the select event.
		 
		 Params	: e -- Event object.
		 **********************************************************/
		private function selectFile(e:Event):void {  
			_loadFileRef.load();  
			
			save_button.setToNormalState(true)
			load_button.setToNormalState(true);
			_snapshot_button.setToNormalState(true);
		} 
		
		/*********************************************************
		 Method  : completeFile()
		 
		 Purpose : Method will handle the file load complete
		 event.
		 
		 Params	: e -- Event object.
		 **********************************************************/
		private function completeFile(e:Event):void 
		{ 
			save_button.setToNormalState(true)
			load_button.setToNormalState(true);
			_snapshot_button.setToNormalState(true);
			
			_canvas.setObjectData(new XML(_loadFileRef['data']), FormatType.DEGRAFA);
		} 
		
		/*********************************************************
		 Method  : getDegrafaData()
		 
		 Purpose : Method will save the objects to a xml
		 file for the user.
		 
		 Params	: e -- MouseEvent object.
		 **********************************************************/
		private function getDegrafaData(e:MouseEvent):void {
			
			var name:String = AssetManager.SAVE_ANNOTATIONS_NAME			
			var xml:XML = _canvas.getObjectData(FormatType.DEGRAFA);			
			_saveFileRef.save(xml.toString(), name + ".xml");
			
		}
		
		/*********************************************************
		 Method  : colorSelectHandler()
		 
		 Purpose : Method will handle all color picker events.
		 
		 Params	: e -- Event object.
		 **********************************************************/
		private function colorSelectHandler(e:Event):void {
			
			var selectedColor:uint = e.currentTarget.selectedColor;
			
			if(e.currentTarget == fill_color_mc) {
				
				_objectManager.changeSettingsForSelectedObjects({FillTextColor:selectedColor});				
				_rectTool.fillColor = selectedColor;
				_elipseTool.fillColor = selectedColor;
				_textTool.textSettings.textFormat.color = selectedColor;
				
				//fill_multiple_color_icon.visible = false;
				
			} else if(e.currentTarget == stroke_color_mc) {
				
				_brushTool.color = selectedColor;
				_rectTool.strokeColor = selectedColor;
				_elipseTool.strokeColor = selectedColor;
				_lineTool.color = selectedColor;				
				_objectManager.changeSettingsForSelectedObjects({StrokeColor:selectedColor});
				
				//stroke_multiple_color_icon.visible = false;
				
			}
			
		}
		
		
		/**************************************************************************
		 Method	: toolSelectHandler()
		 
		 Purpose	: This method will handle the selection of a new tool.
		 
		 Params	: e - MouseEvent Object
		 ***************************************************************************/
		private function toolSelectHandler(event:MouseEvent):void
		{
			
			//trace('button name was ' + event.currentTarget.name)
			setActiveToolByButton(event.currentTarget.name);
			
		}
		
		
		/**************************************************************************
		 Method	: setActiveToolByButton()
		 
		 Purpose	: This method will change tools based on the tool button.
		 
		 Params	: button - Tool Button
		 ***************************************************************************/
		private function setActiveToolByButton(buttonName:String):void 
		{
		
			// set all ui to an active state (cheap way of doing this)
			selection_button.enabled = true;
			brush_button.enabled = true;
			rect_button.enabled = true;
			ellipse_button.enabled = true;
			//eraser_button.enabled = true;
			line_button.enabled = true;
			text_button.enabled = true;			
			stroke_color_mc.enabled = true;
			fill_color_mc.enabled = true;
			//font_cb.visible = true;
			
		
			if (buttonName == 'selection_button') 
			{
				if (_canvas.activeTool == _selectionTool) selection_button.setToActiveState(true);
			
				brush_button.setToNormalState(true);
				rect_button.setToNormalState(true);
				ellipse_button.setToNormalState(true);
				//eraser_button.setToNormalState(true);
				line_button.setToNormalState(true);
				text_button.setToNormalState(true);
				save_button.setToNormalState(true)
				load_button.setToNormalState(true);
				_snapshot_button.setToNormalState(true);
				fill_color_mc.enabled = true;
				stroke_color_mc.enabled = true;
				_canvas.activeTool = _selectionTool;
				
				
				selection_button.enabled = false;
				
			} else if (buttonName == 'brush_button') 
				
			{
				_canvas.activeTool = _brushTool;
				selection_button.setToNormalState(true);
				rect_button.setToNormalState(true);
				ellipse_button.setToNormalState(true);
				//eraser_button.setToNormalState(true);
				line_button.setToNormalState(true);
				text_button.setToNormalState(true);
				save_button.setToNormalState(true)
				load_button.setToNormalState(true);
				_snapshot_button.setToNormalState(true);
				
				fill_color_mc.enabled = false;
				stroke_color_mc.enabled = true;
				brush_button.enabled = false;
				//font_cb.visible = false;
				
			} else if (buttonName == 'rect_button')
			{
				
				if (_canvas.activeTool == _rectTool) rect_button.setToNormalState(false)
				
				selection_button.setToNormalState(true);
				ellipse_button.setToNormalState(true);
				//eraser_button.setToNormalState(true);
				line_button.setToNormalState(true);
				text_button.setToNormalState(true);
				brush_button.setToNormalState(true);
				save_button.setToNormalState(true)
				load_button.setToNormalState(true);
				_snapshot_button.setToNormalState(true);
				
				fill_color_mc.enabled = true;
				stroke_color_mc.enabled = true;
				
				_canvas.activeTool = _rectTool;
				rect_button.enabled = false;
				//font_cb.visible = false;
				
			} else if(buttonName == 'ellipse_button')
			{
				if (_canvas.activeTool == _elipseTool) ellipse_button.setToNormalState(false)
				
				selection_button.setToNormalState(true);
				rect_button.setToNormalState(true);
				//eraser_button.setToNormalState(true);
				line_button.setToNormalState(true);
				text_button.setToNormalState(true);
				brush_button.setToNormalState(true);
				save_button.setToNormalState(true)
				load_button.setToNormalState(true);
				_snapshot_button.setToNormalState(true);
			
				fill_color_mc.enabled = true;
				stroke_color_mc.enabled = true;				
				_canvas.activeTool = _elipseTool;
				ellipse_button.enabled = false;				
				//font_cb.visible = false;
				
			} else if(buttonName == 'line_button') 
			{		
				if (_canvas.activeTool == _lineTool) line_button.setToNormalState(false)
				
				selection_button.setToNormalState(true);
				rect_button.setToNormalState(true);
				//eraser_button.setToNormalState(true);
				ellipse_button.setToNormalState(true);
				text_button.setToNormalState(true);
				brush_button.setToNormalState(true);
				save_button.setToNormalState(true)
				load_button.setToNormalState(true);
				_snapshot_button.setToNormalState(true);
				
				_canvas.activeTool = _lineTool;				
				line_button.enabled = false;				
				fill_color_mc.enabled = false;
				//font_cb.visible = false;
				
			} else if (buttonName == 'text_button') 
			{
				if (_canvas.activeTool == _textTool) text_button.setToNormalState(false)
			
				brush_button.setToNormalState(true)
				selection_button.setToNormalState(true)
				rect_button.setToNormalState(true)
				//eraser_button.setToNormalState(true)
				line_button.setToNormalState(true)
				ellipse_button.setToNormalState(true)
				save_button.setToNormalState(true)
				load_button.setToNormalState(true);
				_snapshot_button.setToNormalState(true);
	

				//var font:Font = Font(font_cb.selectedItem.data);
				var font:Font = new AssetManager.myFont();
				var fmt:TextFormat = new TextFormat();

				fmt.size = _fontSize;
				fmt.bold = true
				fmt.color = fill_color_mc.colors[0];
				_textTool.textSettings = new TextSettings(font, fmt, 0xffcc22, 0x000000);
				
				_canvas.activeTool = _textTool;				
				text_button.enabled = false;
	
				//stroke_color_mc.enabled = false;				
			} else if (buttonName == 'eraser_button')
			{
				
				selection_button.setToNormalState(true)
				rect_button.setToNormalState(true)
				text_button.setToNormalState(true)
				line_button.setToNormalState(true)
				ellipse_button.setToNormalState(true)
				brush_button.setToNormalState(true);
				
				_canvas.activeTool = _eraserTool;
				// config color picker
				brush_button.setToNormalState(true)
				fill_color_mc.enabled = false;
				stroke_color_mc.enabled = false;
			}
			
			
			
		}
		
		
		
		/**************************************************************************
		 Method	: textSettingsHandler()
		 
		 Purpose	: This method will handle font seletion in the UI.
		 
		 Params	: e - Event Object
		 ***************************************************************************/
		private function textSettingsHandler(e:Event):void 
		{
			
			var ts:TextSettings;
			
		
					var font:Font = Font(font_cb.selectedItem.data);
					_objectManager.changeSettingsForSelectedObjects({Font:font});					
					ts = _textTool.textSettings;
					ts.font = font;
					_textTool.textSettings = ts;

					
					//font_multiple_icon.visible = false;
					
			}

		
		/**************************************************************************
		 Method	: objectEventHandler()
		 
		 Purpose	: This method will handle events related to GraffitiObjects.
		 We want to handle when an object is selected and enters
		 the edit mode.
		 
		 Params	: e - GraffitiObjectEvent Object
		 ***************************************************************************/
		private function objectEventHandler(e:GraffitiObjectEvent):void 
		{
			
			var font:Font;
			var fmt:TextFormat;
			var i:int;
			
			// text object was selected
			if (e.type == GraffitiObjectEvent.SELECT) {
				
				// check to see if multiple objects are selected
				if(_objectManager.areMultipleObjectsSelected()) {
					
					// check to see if multiple fill values exist for selected objects
					if(_objectManager.areMultipleValuesInSelection(EditableParams.FILL_TEXT_COLOR)) {
						//fill_multiple_color_icon.visible = true;
					} else {
						
						//fill_multiple_color_icon.visible = false;
						
						// set swatch color
						if (e.graffitiObjects[0] is BrushObject) {
							fill_color_mc.selectedColor = BrushObject(e.graffitiObjects[0]).brushDefinition.color;
						} else if (e.graffitiObjects[0] is ShapeObject) {
							fill_color_mc.selectedColor = ShapeObject(e.graffitiObjects[0]).shapeDefinition.fillColor;
						} else if (e.graffitiObjects[0] is TextObject) {
							fill_color_mc.selectedColor = int(TextObject(e.graffitiObjects[0]).textSetting.textFormat.color);
							
						}
						
					}
					
					// check to see if multiple stroke values exist for selected objects
					if(_objectManager.areMultipleValuesInSelection(EditableParams.STROKE_COLOR)) {
						//stroke_multiple_color_icon.visible = true;
					} else {
						
						//stroke_multiple_color_icon.visible = false;
						
						// set swatch color
						if (e.graffitiObjects[0] is LineObject) {
							fill_color_mc.selectedColor = LineObject(e.graffitiObjects[0]).lineDefinition.strokeColor;
						} else if (e.graffitiObjects[0] is ShapeObject) {
							fill_color_mc.selectedColor = ShapeObject(e.graffitiObjects[0]).shapeDefinition.strokeColor;
						}
						
					}
					
					// check to see if multiple fonts exist for selected objects
					if(_objectManager.areMultipleValuesInSelection(EditableParams.FONT)) {
						//font_multiple_icon.visible = true;
					} else {
						//font_multiple_icon.visible = false;
					}
					
					// NOTE: you can check for multiple for all values in the EditableParams Class.
					
				} else {
					
					// update UI based on what was selected
					if (e.graffitiObjects[0] is BrushObject) {
						
						fill_color_mc.selectedColor = BrushObject(e.graffitiObjects[0]).brushDefinition.color;
						
					} else if (e.graffitiObjects[0] is ShapeObject) {
						
						stroke_color_mc.selectedColor = ShapeObject(e.graffitiObjects[0]).shapeDefinition.strokeColor;
						fill_color_mc.selectedColor = ShapeObject(e.graffitiObjects[0]).shapeDefinition.fillColor;
						
					} else if (e.graffitiObjects[0] is LineObject) {
						
						stroke_color_mc.selectedColor = LineObject(e.graffitiObjects[0]).lineDefinition.strokeColor;
						
					} else if (e.graffitiObjects[0] is TextObject) {
						
						font = TextObject(e.graffitiObjects[0]).textSetting.font;
						fmt = TextObject(e.graffitiObjects[0]).textSetting.textFormat;
						
						var fontFromList:Font;
						//var numberFonts:uint = _fontDataProvider.length;
						
						// find select text font in font list
						for (i = 0; i < 0; i++) {
							
							fontFromList = Font(_fontDataProvider.getItemAt(i).data);
							
							if (fontFromList.fontName == font.fontName && fontFromList.fontStyle == font.fontStyle) {
								//font_cb.selectedIndex = i;
								break;
							}
							
						}
						
						// if text tool is current tool then update settings
						if (_canvas.activeTool is TextTool) {
							
							TextTool(_canvas.activeTool).textSettings = new TextSettings(font, fmt);
							
						}
						
						fill_color_mc.selectedColor = uint(TextObject(e.graffitiObjects[0]).textSetting.textFormat.color);
						
					}
					
				}
				
			} else if(e.type == GraffitiObjectEvent.MOVE) {
				
				
				
			} else if(e.type == GraffitiObjectEvent.DESELECT) {
				
				if(_objectManager.areMultipleValuesInSelection(EditableParams.FILL_TEXT_COLOR)) {
					//fill_multiple_color_icon.visible = true;
				} else {
					//fill_multiple_color_icon.visible = false;
				}
				
				if(_objectManager.areMultipleValuesInSelection(EditableParams.STROKE_COLOR)) {
					//stroke_multiple_color_icon.visible = true;
				} else {
					//stroke_multiple_color_icon.visible = false;
				}
				
				if(_objectManager.areMultipleValuesInSelection(EditableParams.FONT)) {
					//font_multiple_icon.visible = true;
				} else {
					//font_multiple_icon.visible = false;
				}
				
			} else if (e.type == GraffitiObjectEvent.ENTER_EDIT) {
				
				// the user can double click on a TextObject to enter edit mode
				// this will automatically set the text tool to selected state.
				if (e.graffitiObjects[0] is TextObject && !(_canvas.activeTool is TextTool)) {
					setActiveToolByButton ('text_button');
				}
				
			} else if(e.type == GraffitiObjectEvent.DELETE) {
				
				
				
			}
			
			
			
		}
		
	}				
};






/*
_fontDataProvider = new DataProvider();
var fonts:Array = Font.enumerateFonts(true);
var numberFonts:int = fonts.length;			
for (var i:uint = 0; i < numberFonts; i++) {
	_fontDataProvider.addItem( { label:fonts[i].fontName, data:fonts[i] } );
}	
*/

/*_mainContainer.addChild(font_cb)
font_cb = new ComboBox()
font_cb.x = 30;
font_cb.y = 50
font_cb.width = 250;
font_cb.dataProvider = _fontDataProvider;
font_cb.addEventListener(Event.CHANGE, textSettingsHandler);*/

// get first font in the list to start with
//var font:Font = _fontDataProvider.getItemAt(0).data;

