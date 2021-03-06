# Oracle_EBS Cookbook

The oracle_ebs Cookbook installs Oracle E-Business Suite.

##Description

Installs and configures Oracle E-Business Suite Version 12.2.5:

  * Assumes a new AIX 7.1 LPAR.
  * Prepares the AIX OS to install software by:
      * Setting kernel parameters.
      * creating the ebsvg01(default) volume group
      * Creating file systems(defaults) /d01 and /applmgr.
  * Installs the Oracle EBS base 12.2.0,
  * Updates the base database from 11.2.0.3 to 11.2.0.4,
  * Updates the 11.2.0.4 database to the latest patches,
  * Installs required patches to Oracle EBS components,
  * Updates EBS to version 12.2.5, and installs 12.2.5 patches,

Dependency: AIX 0.1.0

oracle_ebs COOKBOOK Limitations:

  * Does not support Oracle Database RAC option.
  * Does not support a multi-tier/lpar installation.
  * Does not support other operating systems other than AIX 7.1
  * Installs the VIS demo database option.
  * Installs both application and database on the same LPAR with
     users applmgr,oraprod respectivly.

NOTE: Oracle E-Business Suite requires valid licenses to install.
It is expected that the user of this cookbook follows all licensing
requirements of Oracle EBS.

##Quickstart (EBS)

* Have either an open Source Chef Server or a Hosted Chef account at
  the ready.
* Create your AIX 7.1 operating system target machine.
* Download the Oracle EBS source binaries from edelivery.oracle.com
* Download the patch files based on Oracle EBS Documents:
  ** Doc ID: 1983050.1
  ** Doc ID: 1594274.1
  ** Doc ID: 1617461.1
* Download Oracle Database 11.2.0.4 binaries from edelivery.oracle.com
* Create your staging directory on the AIX 7.1 LPAR
* Create a role to override the default attribute values for your environment

```'
  ebsrole.rb (Role file)
  ----------------------------------------------------------------------
  name 'p134n55'
  description 'Role applied to Oracle EBS.'
  
  run_list 'recipe[oracle_ebs]'
  
  override_attributes :ebs_appuser => 'applmgr',
    :ebs_dbuser                    => 'oraprod',
    :ebs_groupid                   => 1000,
    :ebs_group                     => 'oinstall',
    :ebs => {
      :app   =>  { :usr => { :uid  => 2000 } },
      :db    =>  { :usr => { :uid  => 3000 } },
      :vg    =>  { :app_fs_nam     => '/applmgr',
                   :app_fs_siz     => 122,
                   :db_fs_nam      => '/d01',
                   :db_fs_siz      => 223,
                   :pp_siz         => 128,
                   :sashosts       => [ 'p134n55' ],
                   :ssdhosts       => [ ],
                   :swapspace      => 16384,
                   :vgname         => 'ebsvg01',
                   :drives         => { 'p134n55' => [ 'hdisk1','hdisk2' ] },
                 },
    } # ebs field
  ----------------------------------------------------------------------
```

* Bootstrap the node, telling Chef to install itself, and install the 
  Oracle E-Business Suite environment for the DEMO Database, 'VIS'.

  Ex: knife bootstrap <TARGETNODE> -x root -P <root_password> -N <TARGETNODE> -r role[ebsrole]
    where TARGETNODE is the AIX 7.1 LPAR.

* This Install will take plenty of time, so find a good book to read.
  (On my fastest machine, it took over 12 hours, on slower machines/disks, can be 20 hours)


#Requirements

## Oracle EBS:

  New Oracle E-Business Suite R12 Operating System and Tools Requirements 
  on IBM AIX on Power Systems (Doc ID 1294357.1)

## Chef

The oracle_ebs cookbook was tested using Chef-Client 12.14.89, in combo
with the open source Chef Server 12, as well as with Hosted Chef.

## Platforms

* AIX 7.1 

(Note: oracle_ebs cookbook has not been tested on AIX 6.1. However 
       AIX 6.1 is very compatible with AIX 7.1. )

## DOCUMENTATION/FILES

* Download the 12.2.5. EBS install files from Oracle.
  The list of zip files can be found in:
    Docs/Edelivery_Oracle_EBS_12.2.5.00_for_IBM_AIX_Download_Summary.htm.
  Patches used can be found in the document in the appendix: 
    Docs/EBS 12.2.5_COOKBOOK.htm.
# The included html file, Docs/EBS 12.2.5_COOKBOOK.mht, is required
  reading for more information on the oracle_ebs cookbook. It contains
  alot more detail, included disk space requirements and required
  file systems.

# Miscellaneous

  * vnc software is required for the installation

## Recipes

Follow the file recipes/default.rb for the order of included recipe files

##Usage Notes

* .rsp files are used. Feel free to replace response files with your own

Contributing
============

1. Fork the repository on Github: (https://github.com/jkohlmeier/oracle_ebs)
2. Create a named feature branch (like `add_component_x`)
3. Write your changes
4. Write tests for your changes (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
===================

* Author:: Jubal Kohlmeier <jubal@us.ibm.com>  

Copyright:: 2016, Jubal Kohlmeier

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
