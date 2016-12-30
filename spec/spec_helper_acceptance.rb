require 'beaker-rspec'

# Install Puppet on all hosts
install_puppet_on(hosts, options)

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  module_path = '/etc/puppetlabs/code/modules'

  c.before :suite do
    # Install module to all hosts
    hosts.each do |host|
      install_dev_puppet_module_on(host, :source => module_root, :module_name => 'vault_client', :target_module_path => module_path)
      # Install dependencies
      # Install dependencies
      scp_to(host, "#{module_root}/spec/fixtures/modules", File.dirname(module_path), {})
    end
  end
end
