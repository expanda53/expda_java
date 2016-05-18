package view;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;



public class exLabel extends Label{
	private ObjLabel label;
	public exLabel(Composite parent, ObjLabel label){
		super(parent, label.getAlign());
		this.label=label;
		this.setVisible(label.isVisible());
		this.setText(label.getText());
		int width = label.getWidth();
		if (width==0) {
			width=60;
			getObj().setWidth(width);
		}

		int height = label.getHeight();
		if (height==0) {
			height=20;
			getObj().setHeight(height);
		}

		
		this.setData("NAME",label.getName());
//		System.out.println(this.getData("NAME"));
		this.setFont(label.getFont());
		
		FontData[] fD = this.getFont().getFontData();
		fD[0].setHeight(label.getFontSize());
		if (label.isFontBold())	fD[0].setStyle(SWT.BOLD);
		
		this.setFont( new Font(parent.getDisplay(),fD[0]));
		
		
		this.setForeground(label.getForeColor());
		this.setBackground(label.getBackColor());
		this.setBounds(label.getLeft(), label.getTop(), width, height);

	}
	public void setFontColor(String color){
		this.getObj().setForeColor(color);
		this.setForeground(this.getObj().getForeColor());
	}
	public void setBgColor(String color){
		this.getObj().setBackColor(color);
		this.setBackground(this.getObj().getBackColor());
	}
	protected void checkSubclass() {
		// TODO Auto-generated method stub
//		super.checkSubclass();
//		swt objektumokat nem lehet örökiteni, kiveve igy
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
	public void setAlign(String align){
		getObj().setAlign(align);
		this.setAlignment(getObj().getAlign());
		
	}
	
	
	public ObjLabel getObj() {
		return label;
	}


	
	



	

}
