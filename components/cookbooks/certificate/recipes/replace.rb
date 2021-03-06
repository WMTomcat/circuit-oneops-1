cloud_name = node[:workorder][:cloud][:ciName]

auto_provision = node.workorder.rfcCi.ciAttributes.auto_provision

if !auto_provision.nil? && auto_provision == "true"
  provider = node[:workorder][:services][:certificate][cloud_name][:ciClassName].gsub("cloud.service.","").downcase.split(".").last
  include_recipe provider + "::replace_certificate"
elsif node[:workorder][:services].has_key?("keymanagement")
  include_recipe "barbican::replace"
else
  include_recipe "certificate::add"
end

