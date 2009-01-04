Factory.define :story do |s|
  s.author User.first
  s.workflow_state 'approved'
end