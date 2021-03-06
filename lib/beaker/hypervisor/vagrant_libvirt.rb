require 'beaker/hypervisor/vagrant'

class Beaker::VagrantLibvirt < Beaker::Vagrant
  @memory = nil
  @cpu    = nil

  class << self
    attr_reader :memory
  end

  def provision(provider = 'libvirt')
    super
  end

  def self.provider_vfile_section(host, options)
    "    v.vm.provider :libvirt do |node|\n" +
      "      node.cpus = #{cpu(host, options)}\n" +
      "      node.memory = #{memory(host, options)}\n" +
      build_options_str(options) +
      "    end\n"
  end

  def self.cpu(host, options)
    return @cpu unless @cpu.nil?
    @cpu = case
    when host['vagrant_cpus']
      host['vagrant_cpus']
    when options['vagrant_cpus']
      options['vagrant_cpus']
    else
      '1'
    end
  end

  def self.memory(host, options)
    return @memory unless @memory.nil?
    @memory = case
    when host['vagrant_memsize']
      host['vagrant_memsize']
    when options['vagrant_memsize']
      options['vagrant_memsize']
    else
      '512'
    end
  end

  def self.build_options_str(options)
    other_options_str = ''
    if options['libvirt']
      other_options = []
      options['libvirt'].each do |k, v|
        other_options << "      node.#{k} = '#{v}'"
      end
      other_options_str = other_options.join("\n")
    end
    "#{other_options_str}\n"
  end
end
