# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string(255)
#  name              :string(255)
#  email             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string(255)
#  remember_token    :string(255)
#  sex               :string(255)
#  age               :integer
#  secure_key        :string(255)
#  native_languages  :text
#  foreign_languages :text
#  admin             :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
 
	before do
		
		@attributes = {username: "exampleuser",
			 email: "user@example.com", title: "Example Blog",
			 password: 'foobar', password_confirmation: 'foobar'}
		
		@user = User.new(@attributes)
	 end
		 
	subject { @user }
	
	it { should respond_to(:username) }

	it { should respond_to(:email) }
	
	it { should respond_to(:password_digest) }
	
	it { should respond_to(:password) }
	
	it { should respond_to(:password_confirmation) }
	
	it { should respond_to(:authenticate) }
	
	it { should respond_to(:remember_token) }
	
	it { should be_valid }
	
	
	describe "when password is not present" do
		
		before { @user.password = @user.password_confirmation = '' }
		
		it { should_not be_valid }
		
	end
	
	describe "when password doesn't match password_confirmation" do
		
		before { @user.password_confirmation = 'barzee' }
		
		it { should_not be_valid }
		
	end
	
	describe "when password_confirmation is nil" do
		
		before { @user.password_confirmation = nil }
		
		it { should_not be_valid }
		
	end
	
	describe "when username is not valid" do
		
		before { @user.username = 'Marry Keller' }
		
		it { should_not be_valid }
		
	end
	
	describe "remember token" do
		
		before { @user.save }
		
		its(:remember_token) { should_not be_blank } 
		
	end
	
	describe "when username is valid" do
		
		it { should be_valid }
		
	end
	
	describe "when name is not present" do
		
		before { @user.username = '' }
		
		it { should_not be_valid }
		
	end
	
	describe "when name is too long" do
		
		before { @user.username = 'a'*51 }
		
		it { should_not be_valid }
		
	end
	
	describe "when e-mail is invalid" do
		
		before { @user.email = 'notachance' }
		
		it { should_not be_valid }
		
	end
	
	describe 'when e-mail is identical but for case' do
		
		before do
			user_with_close_email = User.new(@attributes)
			user_with_close_email.email = 'USER@EXAMPLE.COM'
			user_with_close_email.username = 'hello'
			user_with_close_email.save
		end
		
		it { should_not be_valid }
		
	end
	
	
	describe "when e-mail is valid" do
		
		it { should be_valid }
		
	end
	
	describe "when e-mail is not present" do
			
		before { @user.email = '' }
			
		it { should_not be_valid }
		
	end
	
	describe "when e-mail is already taken" do
		
		before do
			same_email_user = User.new(@attributes)
			same_email_user.username = 'hello'
			same_email_user.save!
		end
		
		it { should_not be_valid }
		
	end
 
	describe "return value of authenticate" do
			
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }
			
		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end
		
		describe "with invalid password" do
			
			let(:invalid_user) { found_user.authenticate("invalid") }
			
			it { should_not == invalid_user }
			
			specify { invalid_user.should be_false }
			
		end
		
		describe "with a short password" do
			before { @user.password = @user.password_confirmation = 'a'*5 }
			it { should_not be_valid }
		end
		
	end
 
 
 
 
 
 
 
 
end
