self.formats = [:html]

if @share.errors.any?
  json.status :not_accepted
  json.content render(:partial => 'shares/form', :object => @share)
else
  json.status :ok
  json.content render(:template => 'shares/index')
end
