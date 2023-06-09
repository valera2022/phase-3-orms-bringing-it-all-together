class Dog
    attr_accessor :id, :name, :breed
    def initialize(args)
        @id = args[:id]
        @name = args[:name]
        @breed = args[:breed]


    end

    def self.create_table 
       cr = <<-SQL 
           CREATE TABLE IF NOT EXISTS  dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT

           )
        SQL

        DB[:conn].execute(cr)
    end

    def self.drop_table 
        dr = "DROP TABLE dogs;" 
        
       

        DB[:conn].execute(dr)
    end

    
        def save
            sql = <<-SQL
              INSERT INTO dogs (name, breed)
              VALUES (?, ?)
            SQL
        
            DB[:conn].execute(sql, self.name, self.breed)
            self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        
            self
        end


    
          def self.create(name:, breed:)
            dog_one = Dog.new(name: name, breed: breed)
            dog_one.save
          end
          
          def self.new_from_db(row)
            
            self.new(id: row[0], name: row[1], breed: row[2])
        
          end
          
          def self.all
            sql = <<-SQL
              SELECT *
              FROM dogs
            SQL
        
            DB[:conn].execute(sql).map do |row|
                self.new_from_db(row) 
            end
          end

          def self.find_by_name(name)
            sql = <<-SQL
              SELECT *
              FROM dogs
              WHERE dogs.name = ?
              LIMIT 1;
            SQL
        
            DB[:conn].execute(sql, name).map do |row|
              self.new_from_db(row)
            end.first
          end

          def self.find(id)
            sql = <<-SQL
              SELECT *
              FROM dogs
              WHERE dogs.id = ?
              LIMIT 1;
            SQL
        
            DB[:conn].execute(sql, id).map do |row|
              self.new_from_db(row)
            end.first
          end

end
