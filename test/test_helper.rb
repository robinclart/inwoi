ENV["RAILS_ENV"] ||= "test"

require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Minitest.reporter = Minitap::TapY

class ActiveSupport::TestCase
  def assert_input(name)
    assert css_select("input[name='#{name}']").first, "No #{name} input on the page"
  end

  def signup(name, email, password)
    get signup_path
    assert_response :success
    assert_template "signups/new"

    assert_select "form"
    assert_select "input#user_name"
    assert_select "input#user_email"
    assert_select "input#user_password"

    post_via_redirect signup_path, user: {
      name: name,
      email: email,
      password: password
    }
  end

  def login(email, password)
    get "/login"
    assert_response :success
    assert_template "sessions/new"

    assert_select "form"
    assert_input "email"
    assert_input "password"

    post_via_redirect "/login", email: email, password: password
  end

  def click_link(href)
    assert_select "a[href='#{href}']"
    get href
  end

  def assert_form_for(action)
    assert_select "form[action='#{action}']" do
      assert_select "input[type='submit']"
    end
  end

  def assert_fields_for(model_name, fields)
    fields.each do |name, type|
      assert_select "#{type}##{model_name}_#{name}"
    end
  end
end
