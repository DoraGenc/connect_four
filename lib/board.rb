class Board

  attr_reader :current_board

  def initialize
    @current_board = [
      ["01", "02", "03", "04", "05", "06", "07"],
      ["08", "09", "10", "11", "12", "13", "14"],
      ["15", "16", "17", "18", "19", "20", "21"],
      ["22", "23", "24", "25", "26", "27", "28"],
      ["29", "30", "31", "32", "33", "34", "35"],
      ["36", "37", "38", "39", "40", "41", "42"]
    ]

    @initial_board = initial_board = [
      ["01", "02", "03", "04", "05", "06", "07"],
      ["08", "09", "10", "11", "12", "13", "14"],
      ["15", "16", "17", "18", "19", "20", "21"],
      ["22", "23", "24", "25", "26", "27", "28"],
      ["29", "30", "31", "32", "33", "34", "35"],
      ["36", "37", "38", "39", "40", "41", "42"]
    ]
  end

  def print_board
    puts ""
    current_board.each_with_index do |row, index|
      puts row.join(' | ')
      puts "---+----+----+----+----+----+----" if index < current_board.length - 1
    end
  end

  def full_row?(chosen_field)

    column_index = initial_board[0].index(chosen_field)
  
    current_board.each do |row|
      if row[column_index] == initial_board[current_board.index(row)][column_index]
       return false
      end
    end
    true
  end

  def drop_mark(chosen_row, mark_type)
    column_index = initial_board[0].index(chosen_row)

    (current_board.length - 1).downto(0) do |row_index|
      if current_board[row_index][column_index] == initial_board[row_index][column_index]
        field_to_replace = initial_board[row_index][column_index]
        
        update_board!(field_to_replace, mark_type)
        return
      end
    end
  end

  def update_board!(chosen_field, mark_type)
    current_board.each_with_index do |row, row_index|
      row.each_with_index do |element, element_index|

        if element == chosen_field
          current_board[row_index][element_index] = mark_type
          return
        end
      end
    end
  end

  def win?(current_player_mark)
    check_horizontal_win(current_player_mark, current_board) ||
    check_vertical_win(current_player_mark, current_board) ||
    check_diagonal_win(current_player_mark, current_board)
  end

  def check_horizontal_win(current_player_mark, current_board)
    
    current_board.each do |row|
      consecutive_count = 0

      row.each do |column|
        if column == current_player_mark
          consecutive_count += 1
          return true if consecutive_count == 4
        else 
          consecutive_count = 0
        end
      end
    end
    false
  end

  def check_vertical_win(current_player_mark, current_board)

    row_amount = current_board.length
    column_amount = current_board[0].length

    (0...column_amount).each do |column| #erst die Spalten
      consecutive_count = 0

      (0...row_amount).each do |row| # Spalte mit jeder unter ihr vergleichen
        if current_board[row][column] == current_player_mark
          consecutive_count += 1
          return true if consecutive_count == 4
        else
          consecutive_count = 0
        end
      end
    end
    false
  end
  
  def check_diagonal_win(current_player_mark, current_board)

    row_amount = current_board.length
    column_amount = current_board[0].length

    (0...row_amount).each do |row|
      (0...column_amount).each do |col|

        if row <= row_amount -4 && col>= 3 #oben links nach unten rechts, col mindestens 3
          if current_board[row][col] == current_player_mark &&
             current_board[row + 1][col + 1] == current_player_mark &&
             current_board[row + 2][col + 2] == current_player_mark &&
             current_board[row + 3][col + 3] == current_player_mark
            return true
          end
        end

       if row <= row_amount - 4 && col <= column_amount - 4 #oben rechts nach unten links, col max 3
          if current_board[row][col] == current_player_mark &&
            current_board[row + 1][col + 1] == current_player_mark &&
            current_board[row + 2][col + 2] == current_player_mark &&
            current_board[row + 3][col + 3] == current_player_mark
            return true
          end
        end
      end
    end
    false
  end

  private 

  attr_reader :initial_board
end