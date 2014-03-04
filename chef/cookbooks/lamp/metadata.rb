version           "1.0"
recipe            "lamp", "Final configuration of the LAMP server"

%w{ ubuntu debian }.each do |os|
  supports os
end
