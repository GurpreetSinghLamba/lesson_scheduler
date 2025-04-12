require 'rails_helper'

RSpec.describe "enrollments/new", type: :view do
  before(:each) do
    assign(:enrollment, Enrollment.new(
      student: nil,
      lesson: nil
    ))
  end

  it "renders new enrollment form" do
    render

    assert_select "form[action=?][method=?]", enrollments_path, "post" do

      assert_select "input[name=?]", "enrollment[student_id]"

      assert_select "input[name=?]", "enrollment[lesson_id]"
    end
  end
end
