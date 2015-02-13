#
# Cookbook Name:: cert
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'cert::ca'
include_recipe 'cert::servers'
