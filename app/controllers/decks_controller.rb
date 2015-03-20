class DecksController < ApplicationController

  def edit
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards

    # render json: {user: @user, deck: @deck, cards: @cards}
  end

  def show
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards

    # render json: {user: @user, deck: @deck, cards: @cards}
  end

  def take_quiz
    # p params
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards
  end

  def start_quiz
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @cards = @deck.cards
    @cards = @cards.shuffle

    render json: {user: @user, deck: @deck, cards: @cards}
  end

  def update
    # /users/1/decks/2/edit
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:id])
    @deck.update_attributes(deck_info)

    redirect_to action: :edit, user_id: @user.id, id: @deck.id
  end

  def new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @deck = @user.decks.new(deck_info)
    if @deck.save
      redirect_to action: :edit, user_id: @user.id, id: @deck.id
    else
      render json: {error_code: '...', msg: 'no good', user: @user, deck: @deck}
    end
  end

  def validate
    p params
    @user = User.find(params[:user_id])
    @deck = @user.decks.find(params[:deck_id])
    @cards_deck = @deck.cards_decks.where(card_id: params[:card_id])[0]
    performance = @cards_deck.performances.create(certainty: params[:certainty], correct: params[:correct], previous_card_id: params[:previous_card_id])
    p Performance.last
    p performance

    render json: {msg: 'success'}
  end

  def next_card
    #happens client side, consider removing
  end

  def copy_deck
    old_deck = Deck.find(params[:id])
    new_deck = User.find(current_user).decks.create(name: old_deck.name)
    new_deck.save

    old_deck.cards.each do |card|
      new_deck.cards.create(question: card.question, answer_1: card.answer_1, answer_2: card.answer_2, answer_3: card.answer_3, answer_4: card.answer_4, answer_number: card.answer_number)
    end

    redirect_to user_deck_path(user_id: new_deck.user_id, id: new_deck.id)
  end

  private
  def deck_info
    params.require(:deck).permit(:name)
  end

  #this was copied from the decks controller. DRY THIS OUT
  def current_user
    if session[:id]
      session[:id]
    else
      p 'no user logged in'
    end
  end

end
