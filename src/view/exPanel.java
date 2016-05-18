package view;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;



public class exPanel extends Composite{
	private ObjPanel panel;
	public exPanel(Composite parent, ObjPanel panel){
		super(parent, SWT.CENTER);
		this.panel=panel;
		this.setVisible(panel.isVisible());
		int width = panel.getWidth();
		if (width==0) {
			width=60;
			getObj().setWidth(width);
		}

		int height = panel.getHeight();
		if (height==0) {
			height=20;
			getObj().setHeight(height);
		}

		
		
		this.setData("NAME",panel.getName());
//		System.out.println(this.getData("NAME"));
		this.setFont(panel.getFont());
		this.setForeground(panel.getForeColor());
		this.setBackground(panel.getBackColor());
		this.setBounds(panel.getLeft(), panel.getTop(), width, height);

	}
	
	public void setFontColor(String color){
		this.getObj().setForeColor(color);
		this.setForeground(this.getObjPanel().getForeColor());
	}
	public void setBgColor(String color){
		this.getObj().setBackColor(color);
		this.setBackground(this.getObjPanel().getBackColor());
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

	
	protected void checkSubclass() {
		// TODO Auto-generated method stub
//		super.checkSubclass();
//		swt objektumokat nem lehet örökiteni, kiveve igy
	}


	public ObjPanel getObjPanel() {
		return panel;
	}
	public ObjPanel getObj() {
		return panel;
	}	



	

}
