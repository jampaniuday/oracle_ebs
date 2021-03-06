log '
     **********************************************************************
     *                                                                    * 
     *                 Recipe:kernel_swap                                 * 
     *                                                                    * 
     * This recipe is conditional. You many not want to add swap of the   * 
     * orcle recommended swap size (which is 1/2 the memory size).        * 
     *                                                                    * 
     * By default, we enforce a fixed size swap requirement. However,     * 
     * if you wish to ignore this requirement, modify the attribute:      * 
     *                                                                    * 
     *     default[:ebs[]:vg][:ignore_swap_check] = true                  * 
     *                                                                    * 
     ********************************************************************** 
    '



  # download the addswap.pl file to the machine
  #
cookbook_file "#{node[:ebs][:db][:bin]}/addswap.pl" do
  user 'root'
  group node[:root_group]
  mode '0775'
  source 'addswap.pl'
end


  ######################################################
  # convert the OHAI swap memory to integer in MEGS
curswap = node[:memory][:swap][:total].sub('kB', '')
curswap = curswap.to_i /  1024.to_i


  #boolean to see if we should modify swap. the only if
  # does NOT like conditional expression. So either T or F
  #
swap_is_too_small = curswap < node[:ebs][:vg][:swapspace]


  # this was painful code. Track its correct.
log    "CURSWAP: #{curswap} SWAPSPACE: #{node[:ebs][:vg][:swapspace]}"
log    "swap_is_too_small: #{swap_is_too_small}"

  # Do we add more swap space?
unless node[:ebs][:vg][:swapspace_ignore]
  execute "check_swap_size_#{node[:ebs][:vg][:swapspace]}" do
    user 'root'
    group node[:root_group]
    command "perl #{node[:ebs][:db][:bin]}/addswap.pl -s #{node[:ebs][:vg][:swapspace]}"
    only_if  "#{swap_is_too_small}"
  end
end


  #########################################################
  # CHECK MIN MEMORY NEEDS
  # convert the OHAI total memory to integer in MEGS
actualMemory = node[:memory][:total].sub('kB', '')
actualMemory = actualMemory.to_i /  1024.to_i
minMem=node[:ebs][:vg][:minimum_memory]

if ( node[:ebs][:vg][:minimum_memory] > actualMemory )
  Chef::Log.warn("Failed Memory Check: actualMemory:${actualMemory} is less than Minimum: #{node[:ebs][:vg][:minimum_memory]}")
  raise "Not enough memory in system: #{actualMemory} MBs Required: #{minMem} MBs"
end
