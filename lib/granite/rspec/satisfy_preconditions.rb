# @scope Business Actions
#
# Checks if business action satisfies preconditions in current state.
#
# Modifiers:
# * `with_message(message)` (and `with_messages([list, of, messages])`) --
#   only for negated matchers, checks messages of preconditions not satisfied;
# * `with_message_of_kind(:message_kind)` (and `with_messages_of_kinds(:list, :of, :messages)`) --
#   only for negated matchers, checks messages of preconditions not satisfied;
# * `exactly` (secondary modifier for `with_message`/`with_messages`) --
#   if set, checks if only those messages are set in errors; otherwise
#   those messages should present, but others could too.
#
# Examples:
#
# ```ruby
# # assuming subject is business action
# it { is_expected.to satisfy_preconditions }
# it { is_expected.not_to satisfy_preconditions.with_message('Tax form has not been signed') }
# it { is_expected.not_to satisfy_preconditions.with_message_of_kind(:relevant_portfolio_items_needed) }
# it { is_expected.not_to satisfy_preconditions.with_messages_of_kinds(:relevant_portfolio_items_needed, :relevant_education_needed) }
# ```
#
RSpec::Matchers.define :satisfy_preconditions do
  chain(:with_message) do |message|
    @expected_messages = [message]
  end

  chain(:with_messages) do |messages|
    @expected_messages = messages
  end

  chain(:with_message_of_kind) do |kind|
    @expected_kind_of_messages = [kind]
  end

  chain(:with_messages_of_kinds) do |*kinds|
    @expected_kind_of_messages = kinds.flatten
  end

  chain(:exactly) do
    @exactly = true
  end

  match do |object|
    fail '"with_messages" method chain is not supported for positive matcher' if @expected_messages
    object.satisfy_preconditions?
  end

  match_when_negated do |object|
    result = !object.satisfy_preconditions?
    if @expected_messages
      errors = object.errors[:base]
      result &&= if @exactly
                   errors.to_a.sort == @expected_messages.sort
                 else
                   (@expected_messages - errors).empty?
                 end
    elsif @expected_kind_of_messages
      error_kinds = object.errors.details[:base].map(&:values).flatten
      result &&= (@expected_kind_of_messages - error_kinds).empty?
    end

    result
  end

  failure_message do |object|
    "expected #{object} to satisfy preconditions but got following errors:\n #{object.errors[:base].inspect}"
  end

  failure_message_when_negated do |object|
    message = "expected #{object} not to satisfy preconditions"
    message + if @expected_messages
                expected_messages_error(object, @exactly, @expected_messages)
              elsif @expected_kind_of_messages
                expected_kind_of_messages_error(object, @expected_kind_of_messages)
              else
                ' but preconditions were satisfied'
              end.to_s
  end

  def expected_messages_error(object, exactly, expected_messages, message = '')
    actual_errors = object.errors[:base]
    message += ' exactly' if exactly
    message += " with error messages #{expected_messages}"
    message + " but got following error messages:\n    #{actual_errors.inspect}"
  end

  def expected_kind_of_messages_error(object, expected_kind_of_messages, message = '')
    actual_kind_of_errors = object.errors.details[:base].map(&:keys).flatten
    message += " with error messages of kind #{expected_kind_of_messages}"
    message + " but got following kind of error messages:\n    #{actual_kind_of_errors.inspect}"
  end
end

RSpec::Matchers.define_negated_matcher :fail_preconditions, :satisfy_preconditions
