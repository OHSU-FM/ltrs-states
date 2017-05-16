require 'rails_helper'

RSpec.describe "leave_requests/index", type: :view do
  before(:each) do
    @leave_requests = FactoryGirl.create_list(:leave_request, 2)
  end

  it 'renders a list of leave_requests' do
    assign :leave_requests, @leave_requests; render
    @leave_requests.each do |lr|
      expect(rendered).to have_content lr.user.full_name
    end
  end

  it 'renders show links to each request' do
    assign :leave_requests, @leave_requests; render
    @leave_requests.each do |lr|
      expect(rendered).to have_link("Show", href: leave_request_path(lr))
    end
  end

  it 'renders delete links for each request' do
    assign :leave_requests, @leave_requests; render
    @leave_requests.each do |lr|
      expect(rendered).to have_link("Destroy", href: leave_request_path(lr))
    end
  end

  it 'should render a link to create a new request' do
    render
    expect(rendered).to have_link("New", href: new_leave_request_path)
  end

  it 'doesnt render edit links to each request' do
    assign :leave_requests, @leave_requests; render
    expect(rendered).not_to have_content('Edit')
  end
end
