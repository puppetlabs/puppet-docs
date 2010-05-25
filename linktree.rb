#!/usr/bin/ruby
#
# Copyright 2010, Puppet Labs
# Michael DeHaan <michael@puppetlabs.com>
#
# Given any directory tree containing HTML files, output the list 
# of files in the order that they would be best fed to htmldoc, so 
# that PDF conversion of the files reads logically.  NOTE: it turns
# out trying to do this by software is a BAD idea and our docs
# don't have a lot of structure.  A better approach in the future
# is probably go from docbook -> both formats using something
# like Publican.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301  USA

require 'find'
require 'rubygems'
require 'nokogiri'

class Scanner

    def initialize(tree,head)
        @serial = 0
        @serials = {} # { |hash,key| 0 }
        @tree = tree
        @tree = tree + "/" unless tree.match("\/$")
        @head = head
        pattern = /\.html$/
        @candidates = get_candidates(@tree,pattern)
   end
   
    def run()
        # first we sort candidates by depth so things further down in the tree appear later
        sorted = get_sorted_candidates(@candidates)
        serials = {}
        serial = 0
        # now we'll sort them by the order in which the lengths for each appear in our list
        links = []
        compute(sorted) { |candidate,link|
           link = link.gsub("//","/")
           unless link.nil? or links.include?(link) or link.include?("references")
                links << link if File.exists?(link) 
           end
        }
        links = links.insert(0, @head)
        links.join(' ')
    end
    
    def get_sorted_candidates(candidates)
        candidates.sort { |a,b| depth_cmp(a,b,@head) }
    end

    def get_candidates(tree,pattern)
        result = []
        Find.find(tree) do |filename|
        if File.file?(filename) && filename =~ pattern
            result << filename
            end
        end
        result
    end

    def depth_cmp(a,b,head)
        if a == head
            return -1
        end
        ca = a.count("/")
        cb = b.count("/")
        if ca != cb
            ca <=> cb
        else
            a <=> b
        end
    end

    def link_cleanup(dir, link)
        if !link.match(/\.html$/)
            nil
        elsif link.include?("/trac") || link.include?("references") || link.include?("file::")
            nil
        elsif link.match(/^\./) && !link.match(/^\.\./)
            dir + "/" + link.sub(".","")
        elsif link.match(/^\//)
            @tree + "/" + link
        elsif link.match(/^\w/) && !link.match(/\@/) && !link.match(/^http:\/\//)
            dir + "/" + link
        else
            nil
        end
    end 

    def compute(candidates)
        candidates.each do |candidate|
            doc = Nokogiri::HTML(open(candidate))
            doc.css('a').each do |anchor|
                link = link_cleanup(File.dirname(candidate),anchor['href'])
                yield candidate,link unless link.nil?
           end
        end
    end

end


