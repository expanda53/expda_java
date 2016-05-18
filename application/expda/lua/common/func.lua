local exClass={};
function exClass.luastat(ui,obj,text,color)
  obj:setFontColor(color)
  obj:setText(text)
  ui:update()
end

function exClass.split(text,delimiter)
  --return (text .. delimiter):gmatch("([^"..delimiter.."]*)"..delimiter)
  result = {}
  i = 1;
  for w in (text .. delimiter):gmatch("([^"..delimiter.."]*)"..delimiter) do
    result[i]=w
    i = i+1
  end
  if (i==1) then result[1]=text end
  return result
end
return exClass;
  