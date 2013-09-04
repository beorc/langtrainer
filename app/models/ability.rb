class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, Exercise
      can [:show, :edit, :update, :destroy], Sentence
      can :create, Sentence, sentence_id: nil, type: nil
      can :view, :all

      # talky
      can :manage, Category
      can :manage, Forum
      can :manage, Topic
      can :manage, Post

      can :manage, Course
    elsif user.has_role? :member
      can [:show, :edit, :update, :destroy], Course, user_id: user.id
      if user.courses.count < Langtrainer.courses[:max]
        can [:new, :create], Course
      end

      can [:show, :edit, :update, :destroy], Exercise, user_id: user.id
      if user.exercises.count < Langtrainer.exercises[:max]
        can [:new, :create], Exercise
      end

      can :view, Sentence, user_id: user.id
      can :view, Sentence, user_id: nil

      can [:show, :edit, :update, :destroy], Sentence, user_id: user.id, type: nil
      if user.sentences.not_corrections.count < Langtrainer.sentences[:max]
        can [:new, :create], Sentence, sentence_id: nil, type: nil
      end
      can [:update, :destroy], Correction, user_id: user.id
      can :create, Correction, sentence: { owner: nil }

      can :index, Category
      can :show, Forum
      can [:new, :create, :show], Topic
      can [:edit, :update], Topic, user_id: user.id
      can [:new, :create, :show], Post
      can [:edit, :update, :destroy], Post, user_id: user.id
    end

    can :index, Category
    can :show, Forum
    can :show, Topic
    can :show, Post

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
