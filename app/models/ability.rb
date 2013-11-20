class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
        can :manage, :all        
        cannot :destroy, Department
        cannot :destroy, Designation
        cannot :destroy, LeaveType

    elsif user.has_role? :employee
        can :read, Employee, :user_id => user.id
        can :read, Employee, :user_id => user.my_subordinates.collect(&:id)
        
        can :create, Memo if user.my_subordinates.count > 0
        can :read, Memo, :user_id => user.id
        can [:read, :create], Memo, :user_id => user.my_subordinates.collect(&:id)
        can [:update, :destroy], Memo, :created_by => user.id
        
        can :read, LeaveStatus, :user_id => user.id
        can :read, LeaveStatus, :user_id => user.my_subordinates.collect(&:id)

        can :create, LeaveRequest, :user_id => user.id
        can :read, LeaveRequest, :user_id => user.id
        can :destroy, LeaveRequest, :user_id => user.id, :leave_at => (Date.today + 1.day)..(Date.today + LeaveRequest.leave_duration), :status => "pending"
        can [:create, :read], LeaveRequest, :user_id => user.my_subordinates.collect(&:id)
        can :update, LeaveRequest, :user_id => user.my_subordinates.collect(&:id), :leave_at => Date.today..(Date.today + LeaveRequest.leave_duration), :status => "pending", :leave_type_id => LeaveType.where(without_pay: false).collect(&:id)

        can :read, Loan, :user_id => user.id
        can :read, Advance, :user_id => user.id
        can :read, WorkedHoliday, :user_id => user.id
        can :read, Message

        can :read, Report
    end

    # can :destroy, LeaveRequest do |leave|
    #     leave.user_id = user.id
    #     leave.leave_at > Date.today
    # end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
