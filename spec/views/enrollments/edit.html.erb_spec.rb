require 'rails_helper'

RSpec.describe "enrollments/edit", type: :view do
  let(:enrollment) {
    Enrollment.create!(
      student: nil,
      lesson: nil
    )
  }

  before(:each) do
    assign(:enrollment, enrollment)
  end

  it "renders the edit enrollment form" do
    render

    assert_select "form[action=?][method=?]", enrollment_path(enrollment), "post" do

      assert_select "input[name=?]", "enrollment[student_id]"

      assert_select "input[name=?]", "enrollment[lesson_id]"
    end
  end
end
