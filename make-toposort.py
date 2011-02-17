#!/usr/bin/python

import os

def uniq (list):
    return dict (map (lambda a: (a,1),list)).keys ()

def dict_to_list (dict):
    ret_list = []
    for k,v in dict.iteritems ():
        ret_list.append (k)
        for ele in v:
            ret_list.append (ele)
    return ret_list

deps = {
    'abc' : ['xyz', '123'],
    'foo' : ['bar', 'abc'],
    'me' : ['foo', 'abc'],
    'haha' : ['hoho', 'bar']
    }

def list_to_str (lst):
    ret_str = " "
    for mem in lst:
        ret_str = ret_str + mem + " "
    return ret_str

def get_dep_list (tok):
    ret_list = " "
    try:
        lst = deps[tok]
        return list_to_str (lst)
    except:
        return " "

tokens = uniq (dict_to_list (deps))

stuff=""
for token in tokens:
    stuff = stuff + "\n" + token + ":" + get_dep_list (token) + "\n\t" +\
            "@echo " + token

stuff = stuff + "\nall: " + list_to_str (tokens) + "\n"

os.system ("echo \"" + stuff + "\" | make -f - all")
