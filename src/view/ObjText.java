package view;


public class ObjText extends ObjDefault {
	private String sqlOnExit;
	private String sqlOnChange;
	private String luaOnExit;
	private String luaOnChange;
	public String getSqlOnExit() {
		return sqlOnExit;
	}
	public void setSqlOnExit(String sqlOnExit) {
		this.sqlOnExit = sqlOnExit;
	}
	public String getSqlOnChange() {
		return sqlOnChange;
	}
	public void setSqlOnChange(String sqlOnChange) {
		this.sqlOnChange = sqlOnChange;
	}
	public String getLuaOnExit() {
		return luaOnExit;
	}
	public void setLuaOnExit(String luaOnExit) {
		this.luaOnExit = luaOnExit;
	}
	public String getLuaOnChange() {
		return luaOnChange;
	}
	public void setLuaOnChange(String luaOnChange) {
		this.luaOnChange = luaOnChange;
	}

}
