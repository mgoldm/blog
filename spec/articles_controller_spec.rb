require 'spec_helper'
require 'rails_helper'
require_relative 'C:/Users/Nick Smirnov/RoR/blog/app/controllers/articles_controller.rb'
describe ArticlesController < ApplicationController do
	describe '.create' do
		it 'sets the name' do
			articles = Article.new(title: 'Ruby_test', body: 'testing')
			
			expect(articles.title).to eq 'Ruby_test'
      expect(articles.body).to eq 'testing'
    end
  end
end

