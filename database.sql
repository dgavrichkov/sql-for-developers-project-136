
CREATE TABLE courses (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TABLE lessons (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  content TEXT,
  video_url VARCHAR(255),
  position INT NOT NULL,
  course_id BIGINT REFERENCES courses(id) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TABLE modules (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TABLE programs (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  program_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Связь между программами и модулями - многие ко многим
CREATE TABLE program_modules (
  program_id BIGINT NOT NULL REFERENCES programs(id),
  module_id BIGINT NOT NULL REFERENCES modules(id),
  PRIMARY KEY (program_id, module_id)
);

-- Связь между курсами и модулями - многие ко многим
CREATE TABLE course_modules (
  course_id BIGINT NOT NULL REFERENCES courses(id),
  module_id BIGINT NOT NULL REFERENCES modules(id),
  PRIMARY KEY (course_id, module_id)
);

CREATE TABLE teaching_groups (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  slug VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(60) NOT NULL,
  teaching_group_id BIGINT REFERENCES teaching_groups(id) NOT NULL,
  role VARCHAR(50) NOT NULL, -- 'student', 'teacher', 'admin'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TYPE enrollment_status AS ENUM ('active', 'pending', 'cancelled', 'completed');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'failed', 'refunded');
CREATE TYPE program_status AS ENUM ('active', 'completed', 'cancelled');

CREATE TABLE enrollments (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT REFERENCES users(id) NOT NULL,
  program_id BIGINT REFERENCES programs (id) NOT NULL,
  status enrollment_status NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  enrollment_id BIGINT REFERENCES enrollments (id) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  status payment_status,
  paid_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE program_completions (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT REFERENCES users (id) NOT NULL,
  program_id BIGINT REFERENCES programs (id) NOT NULL,
  status program_status NOT NULL,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE certificates (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT REFERENCES users (id) NOT NULL,
  program_id BIGINT REFERENCES programs (id) NOT NULL,
  url VARCHAR(255) NOT NULL,
  issued_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quizzes (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
  name VARCHAR(255) NOT NULL,
  content JSONB NOT NULL, -- JSONB для хранения вопросов и вариантов ответов
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREATE TABLE questions (
--   id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
--   quiz_id BIGINT NOT NULL REFERENCES quizzes(id),
--   text TEXT NOT NULL,
--   answer_value TEXT, -- какой ответ приводит к этому вопросу
--   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

-- Связи между вопросами (ветвление)
-- CREATE TABLE question_links (
--   from_question_id BIGINT NOT NULL REFERENCES questions(id),
--   to_question_id BIGINT NOT NULL REFERENCES questions(id),
--   answer_value TEXT NOT NULL, -- напр. 'yes', 'no', 'A', 'B', или ID варианта
--   PRIMARY KEY (from_question_id, answer_value)
-- );

CREATE TABLE exercises (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
  name VARCHAR(255) NOT NULL,
  url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE discussions (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  lesson_id BIGINT REFERENCES lessons (id) NOT NULL,
  user_id BIGINT REFERENCES users (id) NOT NULL,
  text JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE blogs (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id BIGINT REFERENCES users (id) NOT NULL,
  name VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  status VARCHAR(50) NOT NULL, -- created, in moderation, published, archived
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);