package view;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;


public class exText extends Text{
	private Composite parent;
	private ObjText textobj;
	
	public exText(Composite parent, ObjText b){
		super(parent,SWT.SINGLE);
		this.parent=parent;
		this.textobj=b;
		this.setVisible(b.isVisible());
		
		this.setText(b.getText());
		int width = b.getWidth();
		if (width==0) {
			width=60;
			getObj().setWidth(width);
		}


		int height = b.getHeight();
		if (height==0) {
			height=20;
			getObj().setHeight(height);
		}


		
		this.setData("NAME",b.getName());
		this.setFont(this.getObj().getFont());
		
		FontData[] fD = this.getFont().getFontData();
		fD[0].setHeight(this.getObj().getFontSize());
		if (this.getObj().isFontBold())	fD[0].setStyle(SWT.BOLD);
		
		this.setFont( new Font(parent.getDisplay(),fD[0]));

		this.setForeground(b.getForeColor());
		this.setBackground(b.getBackColor());
		this.setBounds(b.getLeft(), b.getTop(), width, height);
		this.addListener(SWT.FocusOut, infoListener);
		this.addListener(SWT.DefaultSelection, modListener);
//		this.setimage
	}
	
	Listener infoListener = new Listener() {
		public void handleEvent(Event arg0) { 		

				Composite xparent = parent;
				if (xparent instanceof exPanel){
					xparent=xparent.getParent();
				}
				 ((exPane)xparent).sendGetExecute(textobj.getSqlOnExit(), true);
				 ((exPane)xparent).luaInit(textobj.getLuaOnExit());
		}
	};
	Listener modListener = new Listener() {
		public void handleEvent(Event arg0) { 		
				Composite xparent = parent;
				if (xparent instanceof exPanel){
					xparent=xparent.getParent();
				}
				 ((exPane)xparent).sendGetExecute(textobj.getSqlOnChange(), true);
				 ((exPane)xparent).luaInit(textobj.getLuaOnChange());
				 
		}
	};


	protected void checkSubclass() {};
	public void setFontColor(String color){
		this.getObj().setForeColor(color);
		this.setForeground(this.getObj().getForeColor());
	}
	public void setBgColor(String color){
		this.getObj().setBackColor(color);
		this.setBackground(this.getObj().getBackColor());
	}
	private void setWidth(int width){
		getObj().setWidth(width);
		this.setBounds(getObj().getLeft(), getObj().getTop(), getObj().getWidth(), getObj().getHeight());
	}
	private void setHeight(int height){
		getObj().setHeight(height);
		this.setBounds(getObj().getLeft(), getObj().getTop(), getObj().getWidth(), getObj().getHeight());
	}
	private void setTop(int top){
		getObj().setTop(top);
		this.setBounds(getObj().getLeft(), getObj().getTop(), getObj().getWidth(), getObj().getHeight());
	}
	private void setLeft(int left){
		getObj().setLeft(left);
		this.setBounds(getObj().getLeft(), getObj().getTop(), getObj().getWidth(), getObj().getHeight());
	}
	
	public void setBounds(String command, int val){
		if (command.equalsIgnoreCase("SETTOP")) this.setTop(val);
		if (command.equalsIgnoreCase("SETWIDTH")) this.setWidth(val);
		if (command.equalsIgnoreCase("SETHEIGHT")) this.setHeight(val);
		if (command.equalsIgnoreCase("SETLEFT")) this.setLeft(val);
	}

	
	public ObjText getObj(){
		return this.textobj;
	}
}
