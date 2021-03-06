# Amahi Home Server
# Copyright (C) 2007-2013 Amahi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License v3
# (29 June 2007), as published in the COPYING file.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# file COPYING for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Amahi
# team at http://www.amahi.org/ under "Contact Us."

class SetTheme

  attr_accessor :name, :headers, :gruff, :author, :author_url, :disable_inheritance

  class << self

    def find
      begin
        theme_setting = Setting.find_or_create_by_name(:name => 'theme', :value => self.default)
        theme_name = init_file_exists?(theme_setting.value) ? theme_setting.value : self.default
        theme = init(theme_name)
        self.new(theme)
      rescue => e
        Rails.logger.error("THEME: name: #{theme_name};  error: #{e}") && exit
      end
    end

    def init(name)
      load init_file_path(name)
      theme_init if defined?(theme_init) == "method"
    end

    def init_file_path(name)
      "#{Rails.root}/themes/#{name}/init.rb"
    end

    def init_file_exists?(name)
      File.exist?(init_file_path(name))
    end

    def default
      Yetting.default_theme
    end

  end

  def initialize(theme={})
    self.name = theme[:name]
    self.headers = theme[:headers].present? ? theme[:headers].map{|h| (h =~ /\.js$/) ? "/themes/#{@theme_name}/#{h}" : h } : []
    self.gruff = theme[:gruff_theme]
    self.author = theme[:author_name]
    self.author_url = theme[:author_url]
    self.disable_inheritance = theme[:disable_inheritance]
  end

  def default
    self.class.default
  end

  def default?
    name == default
  end

  def not_default_and_not_disable_inheritance?
    !default? && !disable_inheritance
  end


end
