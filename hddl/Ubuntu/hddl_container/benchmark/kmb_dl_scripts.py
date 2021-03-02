#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from gazpacho import get
from gazpacho import Soup
import os, sys
from re import search
import wget


# pip3 install jupyter wget gazpacho

# In[ ]:


def Search_and_Export(link=None, file=None, env_tag=None, export_file=None,verbose=0):
    html = get(link)
    soup = Soup(html)
    body = soup.find('body')
    download = body.find('a')
    release_binary = [dl.text for dl in download]
    if verbose == 1:
        for dl in release_binary:
            print(dl)
    found = 0
    for binary in release_binary:
        if search(file, binary):
            print(binary)
            file_exact = binary
            found += 1
    if found == 0:
        print("No file found: " + file)
    elif found > 1:
        print("Multiple files found! Only the last found saved!")
    os.environ[env_tag] = file_exact
    if export_file != None:
        with open(export_file, "a") as myfile:
            myfile.write("export " + env_tag + "=" + file_exact + "\n")


# os.environ["KMB_LINK"] = 'https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2021/Mainline_BKC/20210302-0010'
# os.environ["KMB_FILE"] = 'download.txt'

# In[ ]:


#os.environ["KMB_LINK"] = 'https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/PREINT/20201003-0611/'
Release_Link = os.getenv("KMB_LINK")

# trim / from http link
if Release_Link[-1] == '/':
    Release_Link = Release_Link[:-1]
print(Release_Link)


# In[ ]:


def Get_Tags(filename):
    with open(filename) as f:
        lines = [line.rstrip() for line in f]
    for line in lines:
        if line[0] != '#':
            xxx = line.split('::')
            print(Release_Link+xxx[0])
            print(xxx[1])
            print(xxx[2])
            Search_and_Export(link=Release_Link+xxx[0], file=xxx[1], env_tag=xxx[2], export_file="dl_export", verbose=0)


Get_Tags(os.getenv("KMB_FILE"))


# Search_and_Export(link=Release_Link, file="l_openvino_toolkit_private_ubuntu18_kmb_x86_.*.tar.gz", 
#                   env_tag='OPENVINO_PACKAGE_NAME', export_file="dl_export",verbose=0)
# 
# Search_and_Export(link=Release_Link + "/host_packages", file="kmb-hddl-driver-.*_all.deb", 
#                   env_tag='DEB_PACKAGE_NAME', export_file="dl_export",verbose=0)
# 
# Search_and_Export(link=Release_Link + "/host_packages", file="bypass_host_hddlunite_hvasample_.*.tgz", 
#                   env_tag='HOST_PACKAGE_NAME', export_file="dl_export",verbose=0)
# 
# Search_and_Export(link=Release_Link + "/host_packages", file="pms-host-*-x86_64.deb", 
#                   env_tag='PMS_PACKAGE_NAME', export_file="dl_export",verbose=0)
# 

# url = Release_Link + '/' + os.getenv("KMB_HDDL_DEB")
# wget.download(url)

# In[ ]:




