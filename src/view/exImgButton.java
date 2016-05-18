package view;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;


public class exImgButton extends CLabel{
	private Composite parent;
	private ObjButton button;
	public exImgButton(Composite parent, ObjButton b){
		super(parent,SWT.CENTER);
		this.parent=parent;
		this.button=b;
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

		if (b.getImage()!="") {
			try {
				Image image = new Image(parent.getDisplay(), b.getImage());
				this.setImage(image);
				//this.setMargins(5, (height/2)-b.getFontSize()-2, 0, 0);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
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
		this.addListener(SWT.MouseUp, infoListener);

	}
	
	Listener infoListener = new Listener() {
		public void handleEvent(Event arg0) { 		
			if (button.getFunction().equalsIgnoreCase("CLOSE")) {
				parent.getShell().close();
			}
			else {
				Composite xparent = parent;
				if (xparent instanceof exPanel){
					xparent=xparent.getParent();
				}
				 ((exPane)xparent).sendGetExecute(button.getSqlAfterClick(), true);
				 ((exPane)xparent).luaInit(button.getLuaAfterClick());
//				MessageBox infoBox = new MessageBox(parent.getShell(), SWT.ICON_INFORMATION | SWT.OK );
//				infoBox.setText("Info");
//				infoBox.setMessage("This is an Jalimo SWT example. \n\n       www.jalimo.org\n"
//									+"\njava version: "+System.getProperty("java.version")
//									+"\nvm: "+System.getProperty("java.vm.vendor")+", "+System.getProperty("java.vm.version")
//									+"\njava: "+System.getProperty("java.vendor")
//									+"\nsql_after_click: "+button.getSqlAfterClick());
//				infoBox.open();
			}
		}
	};

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

	protected void checkSubclass() {};

	public void setFontColor(String color){
		this.getObj().setForeColor(color);
		this.setForeground(this.getObj().getForeColor());
	}
	public void setBgColor(String color){
		this.getObj().setBackColor(color);
		this.setBackground(this.getObj().getBackColor());
	}
	
	public ObjButton getObjButton(){
		return getObj();
	}
	
	public ObjButton getObj(){
		return this.button;
	}
}
