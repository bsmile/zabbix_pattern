require 'spec_helper'
require 'zabbix_client'

describe service('httpd') do
  it { should be_enabled }
end

describe service('mysqld') do
  it { should be_enabled }
end

describe service('zabbix_agentd') do
  it { should be_enabled }
end

describe service('zabbix_server') do
  it { should be_enabled }
end

describe 'zabbix server example' do
  http_proxy = ENV['http_proxy']
  ENV['http_proxy'] = nil

  params = property[:consul_parameters]

  if params[:zabbix] && params[:zabbix][:web] && params[:zabbix][:web][:fqdn]
    server = params[:zabbix][:web][:fqdn]
  else
    server = 'localhost'
  end

  if params[:zabbix] && params[:zabbix][:web] && params[:zabbix][:web][:login]
    user = params[:zabbix][:web][:login]
  else
    user = 'admin'
  end
  if params[:zabbix] && params[:zabbix][:web] && params[:zabbix][:web][:password]
    passwd = params[:zabbix][:web][:password]
  else
    passwd = 'zabbix'
  end

  zabbix_client = CloudConductor::ZabbixClient.new(server, user, passwd)
  ENV['http_proxy'] = http_proxy
  servers = property[:servers]
  servers.each_key do |hostname|
    result = zabbix_client.exist_host("#{hostname}")
    it "#{hostname} is registered in zabbix" do
      result.should be_truthy
    end
  end
end
