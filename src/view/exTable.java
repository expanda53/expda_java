package view;

import java.util.ArrayList;

import model.Stringfunc;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;


public class exTable extends Table{
	private Composite parent;
	private ObjTable table;
	private exTable akttable;
	
	Listener infoListener = new Listener() {
		public void handleEvent(Event arg0) { 		
			
				Composite xparent = parent;
				if (xparent instanceof exPanel){
					xparent=xparent.getParent();
				}
				Object[] c = akttable.getObj().getColumns();
				String[] vt = akttable.getObj().getValueTo();
				String[] vf = akttable.getObj().getValueFrom();
				
				if (vt!=null){
					for (int i=0;i<c.length;i++) {
						for (int j=0;j<vf.length;j++) {
							if ( ((ObjColumn)c[i]).getName().equalsIgnoreCase(vf[j])  ) {
								String currCell =((TableItem)arg0.item).getText(i);
	//							System.out.println(currCell);
								
								((exPane)xparent).valueTo(vt[j], currCell,false);							
							}
						}
					}
				}
				((exPane)xparent).sendGetExecute(akttable.getObj().getSqlAfterClick(), true); 
				((exPane)xparent).luaInit(akttable.getObj().getLuaAfterClick());

				
		
		}
	};
	public exTable(Composite parent, ObjTable b){
		super(parent, SWT.SINGLE | SWT.BORDER | SWT.V_SCROLL  | SWT.H_SCROLL | SWT.FULL_SELECTION);
		this.parent=parent;
		this.table=b;
	    this.akttable=this ;
		this.setVisible(b.isVisible());
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

		this.setHeaderVisible(true);
		
		this.setData("NAME",b.getName());
		
		this.setFont(b.getFont());
		
		FontData[] fD = this.getFont().getFontData();
		fD[0].setHeight(b.getFontSize());
		if (b.isFontBold())	fD[0].setStyle(SWT.BOLD);
		
		this.setFont( new Font(parent.getDisplay(),fD[0]));

	
//		this.setForeground(b.getForeColor());
//		this.setBackground(b.getBackColor());
		this.setBounds(b.getLeft(), b.getTop(), width, height);
		this.addListener(SWT.Selection, infoListener);
		   this.addListener(SWT.MeasureItem, new Listener() {
		        public void handleEvent(Event event) {
		        	int rh = akttable.getObj().getRowHeight();
		        	if ( rh!=0)  event.height = rh;
		        }
		    });		
		
		
		Object[] cols = table.getColumns();
//		int colnum = cols.length;
	    for (int loopIndex = 0; loopIndex < cols.length; loopIndex++) {
	      TableColumn column = new TableColumn(this, SWT.NULL);
	     ObjColumn col = (ObjColumn)cols[loopIndex];
	      column.setText(col.getTitle());
	      column.setWidth(col.getWidth());
	    }


//	    for (int loopIndex = 0; loopIndex < 24; loopIndex++) {
//	      TableItem item = new TableItem(table, SWT.NULL);
//	      item.setText("Item " + loopIndex);
//	      item.setText(0, "Item " + loopIndex);
//	      item.setText(1, "Yes");
//	      item.setText(2, "No");
//	      item.setText(3, "A table item");
//	    }
//
//	    for (int loopIndex = 0; loopIndex <colnum; loopIndex++) {
//	      this.getColumn(loopIndex).pack();
//	    }

//	    table.setBounds(25, 25, 220, 200);
//
	    
//	    this.addListener(SWT.Selection, new Listener() {
//	      public void handleEvent(Event event) {
//	        this.temps = event.item.toString();
//	        
//	      }
//	    });
//		
	}
	private String[] parseResponse(String row){
		String[] curr = Stringfunc.split(row.replace('[', ' ').trim(),"=");
		return curr;
	}
	
	 
	public void refresh(ArrayList res){
//		tabla feltoltese
		this.removeAll();
		for(int i=0;i<res.size();i++){
			String[] row = Stringfunc.split(res.get(i).toString(),"]]");
			TableItem item = new TableItem(this, SWT.NULL);
			for (int j=0;j<row.length ;j++){
				String[] temps = parseResponse(row[j]);
				int index = this.table.getColumnIndexByName(temps[0]);
				if (temps.length>1 && index>-1) {
				String[] values = Stringfunc.split(temps[1],"@@");
			    item.setText(index, values[0]);
			    if (values.length>1){
			    	for (int k=1;k<values.length;k++){
			    		String aktitem = values[k];
			    		String[] itemprops = Stringfunc.split(aktitem,":");
			    		if (itemprops[0].equalsIgnoreCase("BGCOLOR")) item.setBackground(Colorfunc.getColor(itemprops[1], SWT.COLOR_WHITE));
			    		if (itemprops[0].equalsIgnoreCase("FONT_COLOR") || itemprops[0].equalsIgnoreCase("FONTCOLOR") || itemprops[0].equalsIgnoreCase("TEXTCOLOR")) item.setForeground(Colorfunc.getColor(itemprops[1], SWT.COLOR_BLACK));
			    	}
			    }
				}
			    
			}
		}
	}
	
//	checksubclass amiatt kell, mert egyebkent nem lehet subclassolni
	protected void checkSubclass() {}; 
	
	public ObjTable getObj(){
		return this.table;
	}
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
	

}
