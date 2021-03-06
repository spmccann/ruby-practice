# frozen_string_literal: true

require_relative '../lib/moves'

describe Moves do
  subject(:game) { described_class.new }

  describe '#grid' do
    it 'returns a visual 6x7 space grid for tokens' do
      print_grid = "\n00 01 02 03 04 05 06 \n07 08 09 10 11 12 13 \n14 15 16 17 18 19 20 \n21 22 23 24 25 26 27 \n28 29 30 31 32 33 34 \n35 36 37 38 39 40 41 "

      expect(game.grid).to eq(print_grid)
    end
  end

  describe '#drop_token' do
    context 'when a token is dropped into the grid' do
      it 'updates the number to a token for player 1 ⚫' do
        game.instance_variable_set(:@place, 35)
        expect(game.drop_token(true)).to eq('⚫')
      end
    end

    context 'when a token is dropped into the grid' do
      it 'updates the number to a token for player 2 ⚪' do
        game.instance_variable_set(:@place, 35)
        expect(game.drop_token(false)).to eq('⚪')
      end
    end
  end

  describe '#validation' do
    context 'when a number is entered outside of grid range' do
      it 'does not place the token' do
        game.instance_variable_set(:@place, 43)
        expect(game.validation(true)).to eq(nil)
      end
    end

    context 'when a number is entered within grid range' do
      it 'returns the token to place' do
        game.instance_variable_set(:@place, 36)
        expect(game.validation(true)).to eq('⚫')
      end
    end

    context 'when a token placement does not follow gravity' do
      it 'returns nil and not the token' do
        game.instance_variable_set(:@place, 29)
        expect(game.validation(true)).to eq(nil)
      end
    end

    context 'when a player tries a grid spot already taken' do
      it 'returns nil and not the token' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                      27, 28, 29, 30, 31, 32, 33, 34, 35, '⚫', 37, 38, 39, 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        game.instance_variable_set(:@place, 36)
        expect(game.validation(true)).to eq(nil)
      end
    end

    context 'when a player tries a grid spot above one already taken' do
      it 'returns the token' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                      27, 28, 29, 30, 31, 32, 33, 34, 35, '⚫', 37, 38, 39, 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        game.instance_variable_set(:@place, 29)
        expect(game.validation(true)).to eq('⚫')
      end
    end
  end

  describe '#game_over?' do
    context 'when a player 1 gets connect four horizontally' do
      it 'ends the game with a winner' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                      27, 28, 29, 30, 31, 32, 33, 34, '⚫', '⚫', '⚫', '⚫', '⚪', 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when a player 2 gets connect four horizontally' do
      it 'ends the game with a winner' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                      27, 28, 29, 30, 31, 32, 33, 34, '⚪', '⚪', '⚪', '⚪', '⚫', 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when a player connects four numbers horizontally but not on the same row' do
      it 'returns false and game continues' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                      27, 28, 29, 30, 31, 32, '⚫', '⚫', '⚫', '⚫', 37, 38, '⚪', '⚪', '⚪']
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(false)
      end
    end

    context 'when a player gets connect four vertically' do
      it 'ends the game with a winner' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, '⚫', 15, 16, 17, 18, 19, 20, '⚫', 22, 23, 24, 25,
                      26, 27, '⚫', 29, 30, 31, 32, 33, 34, '⚫', 36, 37, 38, '⚪', '⚪', '⚪']
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when a player connects four numbers vertically but not in the same column' do
      it 'returns false and game continues' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, '⚫', 22, 23, 24, 25,
                      26, 27, '⚫', 29, 30, 31, 32, 33, 34, '⚫', 36, 37, '⚪', '⚪', '⚪', '⚫']
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(false)
      end
    end

    context 'when a player gets connect four on the left diagonal' do
      it 'ends the game with a winner' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, '⚫', 18, 19, 20, 21, 22, 23, '⚫', '⚫',
                      26, 27, 28, 29, 30, '⚪', '⚪', '⚫', 34, 35, 36, '⚪', '⚫', '⚪', '⚪', '⚫']
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when a player gets connect four numbers on the left diagonal but not in the grid' do
      it 'returns false and game continues' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, '⚫', 12, 13, 14, 15, 16, 17, 18, '⚫', 20, 21, 22, 23, 24, 25,
                      26, '⚫', 28, 29, 30, 31, 32, 33, 34, '⚫', 36, 37, 38, 39, 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(false)
      end
    end

    context 'when a player gets connect four on the right diagonal' do
      it 'ends the game with a winner' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, '⚪', 18, 19, 20, 21, 22, '⚪', '⚫', 25,
                      26, 27, 28, '⚪', '⚫', '⚪', 32, 33, 34, '⚪', '⚫', '⚫', '⚫', 39, 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(true)
      end
    end

    context 'when a player gets connect four numbers on the right diagonal but not in the grid' do
      it 'returns false and game continues' do
        grid_state = [0, 1, 2, 3, 4, 5, 6, 7, 8, '⚪', 10, 11, 12, 13, 14, '⚪', 16, 17, 18, 19, 20, '⚪', 22, 23, 24, 25,
                      26, '⚪', 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41]
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.game_over?).to eq(false)
      end
    end
  end

  describe '#tie?' do
    context 'when all grid spots have been filled with no connect four' do
      it 'end game as a tie' do
        grid_state = ['⚪', '⚪', '⚪', '⚫', '⚪', '⚪', '⚪', '⚫', '⚫', '⚫', '⚪', '⚫', '⚫', '⚫', '⚪', '⚪', '⚪', '⚫', '⚪',
                      '⚪', '⚪', '⚫', '⚫', '⚫', '⚪', '⚫', '⚫', '⚫', '⚪', '⚪', '⚪', '⚫', '⚪', '⚪', '⚪', '⚫', '⚫', '⚫', '⚪', '⚫', '⚫', '⚫']
        game.instance_variable_set(:@spaces, grid_state)
        expect(game.tie?).to eq(true)
      end
    end

    context 'when all grid spots have not been filled with no connect four' do
      it 'returns false and game continues' do
        grid_state = [0, '⚪', '⚪', '⚫', '⚪', '⚪', '⚪', '⚫', '⚫', '⚫', '⚪', '⚫', '⚫', '⚫', '⚪', '⚪', '⚪', '⚫', '⚪', '⚪',
                      '⚪', '⚫', '⚫', '⚫', '⚪', '⚫', '⚫', '⚫', '⚪', '⚪', '⚪', '⚫', '⚪', '⚪', '⚪', '⚫', '⚫', '⚫', '⚪', '⚫', '⚫', '⚫']

        game.instance_variable_set(:@spaces, grid_state)
        expect(game.tie?).to eq(false)
      end
    end
  end

  describe '#reset' do
    context 'when the play wants to start a new game' do
      it 'returns a fresh board' do
      end
    end
  end
end
