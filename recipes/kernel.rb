log '**********************************************'
log '*                                            *'
log '*        EBS Recipe:kernel                   *'
log '*                                            *'
log '**********************************************'

include_recipe 'oracle_ebs::kernel_directory'
include_recipe 'oracle_ebs::kernel_oslevel'
include_recipe 'oracle_ebs::kernel_chdev'
include_recipe 'oracle_ebs::kernel_netsvc_conf'
include_recipe 'oracle_ebs::kernel_network'
include_recipe 'oracle_ebs::kernel_filesets'
include_recipe 'oracle_ebs::kernel_nfsmount'
include_recipe 'oracle_ebs::kernel_etchosts'
include_recipe 'oracle_ebs::kernel_swap'
