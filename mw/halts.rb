def halt_no_item(opts = {})
  halt(404, {msg: opts[:msg] || "No such item."}) 
end

def halt_no_permissions(opts = {})
  halt(401, {msg: opts[:msg] || "You can't do that."}) 
end

def halt_bad_input(opts = {})
  halt(403, {msg: opts[:msg] || "Bad input."}) 
end

def halt_missing_param(field)
  halt(403, {msg: "Missing field: #{field}"}) 
end

def halt_item_exists(field, val = nil)
  halt(403, {msg: "Item exists with field: #{field} and val: #{val}"}) 
end

def halt_error(msg)
  halt(500, {msg: msg})
end

def require_fields(fields)
  Array(fields).each do |field| halt_missing_param(field) unless params[field].present? end 
end

def require_user
  if !cu 
  	redirect "/log_in"
  end
  halt_bad_input({msg:"you were blocked"}) if cu[:blocked]
end

get '/halts' do
  {msg: 'halt!'}
end