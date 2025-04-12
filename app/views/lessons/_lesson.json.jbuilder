json.extract! lesson, :id, :subject, :start_time, :end_time, :status, :teacher_id, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)
