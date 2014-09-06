class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "You go " + direction.to_s
    @player.location = find_room_in_direction(direction)
    show_current_description
  end

  class Player
    attr_accessor :name, :location

    def initialize(name)
      @name = name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      @name + "\n\nYou are in " + @description
    end
  end


end


def print_room(dungeon)
  arr = ["-------",
         "|     |",
         "|  @  |",
         "|     |",
         "-------"]
  #load 'debug.rb'

  the_dirs = dungeon.find_room_in_dungeon(dungeon.player.location).connections.keys


  arr[2][6] = '+' if the_dirs.include?(:east)
  arr[2][0] = '+' if the_dirs.include?(:west)
  arr[0][3] = '+' if the_dirs.include?(:north)
  arr[4][3] = '+' if the_dirs.include?(:south)

  arr.each { |l| puts l }

end


def game_start
  puts "What is the name of the player?"
  name = gets.chomp
  my_dungeon = Dungeon.new(name)

  puts "How many rooms do you want to add to your dungeon? (5 or 7)"
  num = gets.chomp
  my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave",
  {:east => :largecave, :south => :southcave, :north => :pondcave})
  my_dungeon.add_room(:southcave, "South Cave", "a large cavernous cave on
  South", {:north => :smallcave, :east => :lowercave})
  my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave",
  {:west => :smallcave, :south => :lowercave})
  my_dungeon.add_room(:lowercave, "Lower Cave", "a lower dark cave",
  {:west => :southcave, :north => :largecave, :south => :undergroundlevel})
  my_dungeon.add_room(:undergroundlevel, "Underground Level", "a large
  underground cave", {:north => :lowercave, :south => :secretcave})
  if num == "7"
    my_dungeon.add_room(:pondcave, "Pond Cave", "a large cave with a lotus pond
    ", {:south => :smallcave})
    my_dungeon.add_room(:secretcave, "Secret Cave", "a small hidden cave with a
    secret", {:north => :undergroundlevel})
  end

  puts "Press \"Any Key\" to start a game or \"E\" to exit."
  game_state = gets.chomp
  if game_state != "e" && game_state != "E"

    puts "#{name} is in"
    my_dungeon.start(:largecave)


    while game_state != "e" && game_state != "E"
      print_room(my_dungeon)
      puts "What direction do you want to move?"
      direction = gets.chomp
      if direction == "e" || direction == "E"
        game_state = direction
      else
        if my_dungeon.find_room_in_direction(direction.to_sym)
          my_dungeon.go(direction.to_sym)
        else
          puts "Direction not allowed, choose another direction to move."
        end

      end
    end
  end
end


game_start
