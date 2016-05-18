package view;

import model.Stringfunc;


public class ObjPanel extends ObjDefault {
	private String sqlOnCreate;
	private String luaOnCreate;
	private boolean mainPanel;
	private boolean taskPanel;
	private boolean menuPanel;
	private String[] ParamsToLabels;
	public ObjPanel(boolean mainParent, boolean taskPanel, boolean menuPanel){
		setMainPanel(mainParent);
		setTaskPanel(taskPanel);
		setMenuPanel(menuPanel);
		setText("...");
	}
	public String getsqlOnCreate() {
		return sqlOnCreate;
	}

	public void setSqlOnCreate(String sqlOnCreate) {
		this.sqlOnCreate = sqlOnCreate;
	}
	public boolean isMainPanel() {
		return mainPanel;
	}
	public void setMainPanel(boolean mainParent) {
		this.mainPanel = mainParent;
	}
	public boolean isTaskPanel() {
		return taskPanel;
	}
	public void setTaskPanel(boolean taskPanel) {
		this.taskPanel = taskPanel;
	}
	public boolean isMenuPanel() {
		return menuPanel;
	}
	public void setMenuPanel(boolean menuPanel) {
		this.menuPanel = menuPanel;
	}
	public String[] getParamsToLabels() {
		return ParamsToLabels;
	}
	public void setParamsToLabels(String paramsToLabels) {
		ParamsToLabels = Stringfunc.split(paramsToLabels,";");
	}
	public String getLuaOnCreate() {
		return luaOnCreate;
	}
	public void setLuaOnCreate(String luaOnCreate) {
		this.luaOnCreate = luaOnCreate;
	}


}
