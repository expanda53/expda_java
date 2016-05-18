package view;



import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Font;

public class ObjDefault {
	private int Top;
	private int Left;
	private int Width;
	private int Height;
	private String Name;
	private String text="";
	private boolean visible=true;
	private Color foreColor;
	private Color backColor;
	private Font font;
	private String parent;
	private int FontSize=9;
	private boolean FontBold=false;
	
	public ObjDefault(){
		parent="";
	}
	
	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public boolean isVisible() {
		return visible;
	}

	public void setVisible(String visible) {
		
		this.visible = (visible.equalsIgnoreCase("true") || visible.equalsIgnoreCase("igen") || visible=="");
	}

	
	
	private Color getColor(String colorstr, int defColor){
		return Colorfunc.getColor(colorstr, defColor);
	}

	public Color getForeColor() {
		return foreColor;
	}

	public void setForeColor(String foreColor) {
		
		this.foreColor=this.getColor(foreColor,SWT.COLOR_LIST_FOREGROUND);
	}

	public Color getBackColor() {
		return backColor;
	}

	public void setBackColor(String backColor) {
		this.backColor=this.getColor(backColor,SWT.COLOR_WIDGET_BACKGROUND);

	}	
	
	
	
	public int getTop() {
		return Top;
	}

	public void setTop(int top) {
		Top = top;
	}

	public int getLeft() {
		return Left;
	}

	public void setLeft(int left) {
		Left = left;
	}

	public int getWidth() {
		return Width;
	}

	public void setWidth(int width) {
		Width = width;
	}

	public int getHeight() {
		return Height;
	}

	public void setHeight(int height) {
		Height = height;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name){
		Name=name;
		
	}

	public Font getFont() {
		return font;
	}


	public String getParent() {
		return parent;
	}

	public void setParent(String parent) {
		this.parent = parent;
	}

	public int getFontSize() {
		return FontSize;
	}

	public void setFontSize(int fontSize) {
		FontSize = fontSize;
	}

	public boolean isFontBold() {
		return FontBold;
	}

	public void setFontBold(boolean fontBold) {
		FontBold = fontBold;
	}
	
}
