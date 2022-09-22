require "pg"
# require "pry"

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: "todos")
    @logger = logger
  end

  def query(sql_statement, *params)
    @logger.info "#{sql_statement}: #{params}"
    @db.exec_params(sql_statement, params)
  end

  def find_list(id)
    sql = "SELECT * FROM lists WHERE id = $1"
    result = query(sql, id)
    tuple = result.first

    list_id = tuple["id"].to_i
    todos = find_todos_for_list(list_id)
    { id: list_id, name: tuple["name"], todos: todos }
  end

  def all_lists
    sql = "SELECT * FROM lists ORDER BY id"
    result = query(sql)

    result.map do |tuple|
        list_id = tuple["id"].to_i
        todos = find_todos_for_list(list_id)
      {id: list_id, name: tuple["name"], todos: todos}
    end
  end

  def create_new_list(list_name)
    sql = <<~SQL
          INSERT INTO lists (name)
          VALUES  ($1);
          SQL
    query(sql, list_name)
  end

  def delete_list(id)
    sql = "DELETE FROM lists WHERE id = $1"
    query(sql, id)
  end

  def update_list_name(id, new_name)
    sql = <<~SQL
            UPDATE lists
            SET name = $1
            WHERE id = $2;
          SQL
    query(sql, new_name, id)
  end

  def create_new_todo(list_id, todo_name)
    sql = <<~SQL
            INSERT INTO todos (list_id, name)
            VALUES  ($1, $2);
          SQL
    query(sql, list_id, todo_name)
  end

  def delete_todo_from_list(list_id, todo_id)
    sql = <<~SQL
            DELETE FROM todos
            WHERE id = $1 AND list_id = $2;
          SQL
    query(sql, todo_id, list_id)
  end

  def update_todo_status(list_id, todo_id, new_status)
    sql = <<~SQL
            UPDATE todos
            SET completed = $1
            WHERE list_id = $2 AND id = $3;
          SQL
    query(sql, new_status, list_id, todo_id)
  end

  def mark_all_todos_as_completed(list_id)
    sql = <<~SQL
            UPDATE todos
            SET completed = true
            WHERE list_id = $1;
          SQL
    query(sql, list_id)
  end

  private

  def find_todos_for_list(list_id)
    todo_sql = "SELECT * FROM todos WHERE list_id = $1 ORDER BY todos.id"
        todos_result = query(todo_sql, list_id)

        todos_result.map do |todo_tuple|
          todo_id = todo_tuple["id"]
          { id: todo_tuple["id"].to_i, 
            name: todo_tuple["name"], 
            completed: todo_tuple["completed"] == "t" }
        end
  end

end